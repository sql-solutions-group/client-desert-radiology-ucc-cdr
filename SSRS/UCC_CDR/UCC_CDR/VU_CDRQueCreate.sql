USE UCC;
GO

IF EXISTS(SELECT 1
            FROM [dbo].[sysobjects] (NOLOCK)
           WHERE [id]                                            = OBJECT_ID(N'[dbo].[VU_CDRQueCreate]')
             AND OBJECTPROPERTY([id], N'IsProcedure')            = 1) 

BEGIN 
  DROP PROCEDURE [dbo].[VU_CDRQueCreate];
  
  PRINT '<<< DROPPED PROCEDURE [dbo].[VU_CDRQueCreate] >>>';
END 
GO

CREATE PROC [dbo].[VU_CDRQueCreate]
AS  

/*************************************************************************************************/ 
/* Name        : VU_CDRQueCreate                                                                 */
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
	   ,@v_StartDate                 [DATETIME]
       ,@v_MSSQL_ID                  [INT];
       
/* Define Variables */
SELECT @v_Now                        = GETDATE()
      ,@v_DB                         = DB_NAME()
      ,@v_Obj                        = '[DBCATCH].[dbo].[VU_CDRQueCreate]'
      ,@v_App                        = APP_NAME()
      ,@v_User                       = ISNULL(ORIGINAL_LOGIN(), USER_NAME()) 
      ,@v_Spid                       = CONVERT([NVARCHAR](25), @@SPID) 
      ,@v_Debug                      = 0;
      
SELECT @v_StartDate         = DATEADD(DAY, -77, @v_Now);
   
                                   
      
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

    CREATE VIEW VU_CDRQueCreate AS 
	(


    SELECT [finalCalledPartyNumber]
	      ,[finalCalledPartyNumberShort]
		  ,[finalCalledPartyUnicodeLoginUserID]
		  ,COUNT(1)                                                                         AS [CallsHandled]
		  ,CONVERT(VARCHAR, DATEADD(ms, SUM([Answer]) * 1000, 0), 114)                      AS [TotalSpeedAnswer]
		  ,CONVERT(VARCHAR, DATEADD(ms, AVG([Answer]) * 1000, 0), 114)                      AS [AverageSpeedAnswer]
		  ,CONVERT(VARCHAR, DATEADD(SECOND, SUM([Handle]) * 10, 0), 114)                      AS [HandleTime]
		  ,CONVERT(BIGINT, SUM([Handle])) * 1000                                            AS [HandleTime]
		  ,CONVERT(VARCHAR, DATEADD(ms, AVG([Handle]) * 1000, 0), 114)                      AS [AverageHandleTime]
		--  ,CONVERT(VARCHAR(10), @p_StartDate, 112)                                          AS [StartDate]
		--  ,CONVERT(VARCHAR(10), @p_EndDate, 112)                                            AS [EndDate]
      FROM [UCC].[dbo].[CDRQuePerformance] AS a
     WHERE ([finalCalledPartyUnicodeLoginUserID] <> '\')
	   AND [datetimeconnect] > DATEADD(DAY, -7, GETDATE())
     GROUP BY [finalCalledPartyNumber], [finalCalledPartyNumberShort], [finalCalledPartyUnicodeLoginUserID]

	 )abc

     ORDER BY [finalCalledPartyUnicodeLoginUserID]

	 )

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

IF OBJECT_ID('[dbo].[VU_CDRQueCreate]') IS NOT NULL
BEGIN
	PRINT '<<< CREATED PROCEDURE [dbo].[VU_CDRQueCreate] >>>';
END;
ELSE 
BEGIN
	PRINT '<<< FAILED TO CREATE PROCEDURE [dbo].[VU_CDRQueCreate] >>>';
END;
GO

select CONVERT(VARCHAR, DATEADD(ms, 106000 * 1000, 0), 114)    --00:17:40:000	106000