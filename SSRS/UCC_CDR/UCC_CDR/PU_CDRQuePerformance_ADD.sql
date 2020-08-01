USE UCC;
GO

IF EXISTS(SELECT 1
            FROM [dbo].[sysobjects] (NOLOCK)
           WHERE [id]                                            = OBJECT_ID(N'[dbo].[PU_CDRQuePerformance_ADD]')
             AND OBJECTPROPERTY([id], N'IsProcedure')            = 1) 

BEGIN 
  DROP PROCEDURE [dbo].[PU_CDRQuePerformance_ADD];
  
  PRINT '<<< DROPPED PROCEDURE [dbo].[PU_CDRQuePerformance_ADD] >>>';
END 
GO

CREATE PROC [dbo].[PU_CDRQuePerformance_ADD]
AS  

/*************************************************************************************************/ 
/* Name        : PU_CDRQuePerformance_ADD                                                        */
/* Version     : 1.0                                                                             */
/* Author      : Jared Kirkpatrick                                                               */
/* Date        : 2019-05-24                                                                      */
/* Description : Insertes a record in the Batch Header                                           */
/*************************************************************************************************/ 
/* Date        : Version: Who: Description                                                       */
/*************************************************************************************************/ 
/* 2019-05-24  : 1.0    : REB: Initial Release.                                                  */
/*************************************************************************************************/ 

SET NOCOUNT ON;

/* Declare Variables */
DECLARE @v_Now                       [DATETIME]
       ,@v_Domain                    [NVARCHAR](100)
       ,@v_IPAddress                 [NVARCHAR](100)
       ,@v_SQL                       [NVARCHAR](4000)
       ,@v_UserName                  [NVARCHAR](100)
       ,@v_PW                        [NVARCHAR](100)
       ,@v_Error                     [INT]
       ,@v_ActivityLog_ID            [INT]
       ,@v_DB                        [NVARCHAR](100)
       ,@v_Obj                       [NVARCHAR](100)
       ,@v_App                       [NVARCHAR](100)
       ,@v_User                      [NVARCHAR](100)            
       ,@v_Spid                      [NVARCHAR](100)
       ,@v_Debug                     [BIT]       
       ,@v_MSG                       [NVARCHAR](1000)
       ,@v_SystemName                [NVARCHAR](100)
       ,@v_Connect_Type_ID           [INT]
       ,@v_RowCount                  [INT]
       ,@v_Count                     [INT]
       ,@v_Version                   [INT]
       ,@v_MSSQL_ID                  [INT];
       
/* Define Variables */
SELECT @v_Now                        = GETDATE()
      ,@v_DB                         = DB_NAME()
      ,@v_Obj                        = '[DBCATCH].[dbo].[PU_CDRQuePerformance_ADD]'
      ,@v_App                        = APP_NAME()
      ,@v_User                       = ISNULL(ORIGINAL_LOGIN(), USER_NAME()) 
      ,@v_Spid                       = CONVERT([NVARCHAR](25), @@SPID) 
      ,@v_Debug                      = 0;
      
-- IF @p_StartDate IS NULL
-- BEGIN
 
--   SELECT @p_StartDate         = DATEADD(DAY, -7, @v_Now);
   
--END;

--IF @p_EndDate IS NULL
-- BEGIN
 
--   SELECT @p_EndDate           = @v_Now;
   
--END;                                    
      
IF @v_Debug                          = 1
BEGIN -- debug = 1 Ref: 1

  SELECT 'REF:1 - Define Static Variables';

  SELECT @v_Now                      AS [GETDATE]
        ,@v_DB                       AS [DB]
        ,@v_Obj                      AS [OBJ]
        ,@v_App                      AS [APP]
        ,@v_User                     AS [User]
        ,@v_Spid                     AS [SPID];
        
END; -- debug = 1         


BEGIN TRANSACTION 

  BEGIN TRY

    WITH BASE AS
    (
    SELECT DISTINCT ROW_NUMBER() OVER(PARTITION BY [GlobalCallID_Callid] ORDER BY [GlobalCallID_Callid], [dateTimeOrigination], [dateTimeConnect], [dateTimeDisconnect] ASC) AS RN
          ,[GlobalCallID_Callid]
          ,REPLACE([callingPartyNumber], '"', '')                                                AS [callingPartyNumber]
          ,REPLACE([finalCalledPartyNumber], '"', '')                                            AS [finalCalledPartyNumber]
	      ,RIGHT(LTRIM(RTRIM(REPLACE([finalCalledPartyNumber], '"', '') )), 4)                   AS [finalCalledPartyNumberShort]
		  ,RIGHT(LTRIM(RTRIM(REPLACE([originalCalledPartyNumber], '"', '') )), 4)                AS [originalCalledPartyNumber]
          ,REPLACE([finalCalledPartyUnicodeLoginUserID], '"', '')                                AS [finalCalledPartyUnicodeLoginUserID]
          ,DATEADD(SECOND, CONVERT([INT], dateTimeOrigination), '19700101')                      AS [dateTimeOrigination]
          ,DATEADD(SECOND, CONVERT([INT], dateTimeConnect), '19700101')                          AS [dateTimeConnect]
          ,DATEADD(SECOND, CONVERT([INT], dateTimeDisconnect) , '19700101')                      AS [dateTimeDisconnect]
          ,duration
      FROM cdr)

    INSERT [UCC].[dbo].[CDRQuePerformance]
	([rn], [GlobalCallID_Callid], [callingPartyNumber], [finalCalledPartyNumber], [finalCalledPartyNumberShort], [originalCalledPartyNumber], [finalCalledPartyUnicodeLoginUserID], [dateTimeOrigination], [dateTimeConnect], [dateTimeDisconnect], [Answer], [Handle], [duration])
    SELECT a.[rn]
          ,a.[GlobalCallID_Callid]
          ,a.[callingPartyNumber]
	      ,a.[finalCalledPartyNumber] 
	      ,a.[finalCalledPartyNumberShort]
		  ,a.[originalCalledPartyNumber]
	      ,a.[finalCalledPartyUnicodeLoginUserID]
	      ,a.[dateTimeOrigination]
	      ,a.[dateTimeConnect]
	      ,a.[dateTimeDisconnect]
	      ,ISNULL(CASE WHEN a.[RN] > 1
	                    AND a.[dateTimeOrigination] = a.[dateTimeConnect]
			            AND a.[finalCalledPartyUnicodeLoginUserID] <> '\'
			           THEN (SELECT z.[duration]
			                   FROM [base]                               z
				              WHERE a.[GlobalCallID_Callid] = z.[GlobalCallID_Callid]
				                AND z.[RN]                  = a.[RN] -1
					            AND z.[finalCalledPartyUnicodeLoginUserID] = '\')
		               ELSE DATEDIFF(SECOND, a.[dateTimeOrigination], a.[dateTimeConnect])
			            END, 0)                                    AS [Answer]
          ,DATEDIFF(SECOND, a.[dateTimeConnect], a.[dateTimeDisconnect])                         AS [Handle]
	      ,a.[duration]
       FROM [base]                  a
	   LEFT JOIN [UCC].[dbo].[CDRQuePerformance]              b
	     ON a.[GlobalCallID_Callid]                           = b.[GlobalCallID_Callid] 
	  WHERE b.[GlobalCallID_Callid]                           IS NULL
      ORDER BY a.[GlobalCallID_Callid], a.[dateTimeOrigination], a.[dateTimeConnect], a.[dateTimeDisconnect];

  END TRY
  
  BEGIN CATCH
  
    SELECT @v_Error                  = 100007
          ,@v_MSG                    = CONVERT(NVARCHAR(2500), 
                                       'Error: ' + CONVERT([NVARCHAR](255), ISNULL(ERROR_NUMBER(), -1)) + 
                                       ' Severity: ' + CONVERT([NVARCHAR](255), ISNULL(ERROR_SEVERITY(), -1)) +
                                       ' State: ' + CONVERT([NVARCHAR](255), ISNULL(ERROR_STATE(), -1)) +
                                       ' Line: ' +  CONVERT([NVARCHAR](255), ISNULL(ERROR_LINE(), -1)) +
                                       ' Procedure: ' + CONVERT([NVARCHAR](255), ISNULL(ERROR_PROCEDURE(), @v_Obj)) +
                                       ' MSG: Error Inserting into [DBCATCH].[dbo].[TU_Batch] with error:' + ISNULL(ERROR_MESSAGE(), ''));  

      
    ROLLBACK TRAN;
    RETURN @v_Error;
    
  END CATCH;

COMMIT TRANSACTION;
WHILE @@TRANCOUNT > 1
  ROLLBACK TRAN
GO

IF OBJECT_ID('[dbo].[PU_CDRQuePerformance_ADD]') IS NOT NULL
BEGIN
	PRINT '<<< CREATED PROCEDURE [dbo].[PU_CDRQuePerformance_ADD] >>>';
END;
ELSE 
BEGIN
	PRINT '<<< FAILED TO CREATE PROCEDURE [dbo].[PU_CDRQuePerformance_ADD] >>>';
END;
GO

