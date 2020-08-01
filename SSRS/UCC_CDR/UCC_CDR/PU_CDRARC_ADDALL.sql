USE UCC;
GO

IF EXISTS(SELECT 1
            FROM [dbo].[sysobjects] (NOLOCK)
           WHERE [id]                                            = OBJECT_ID(N'[dbo].[PU_CDRARC_ADDALL]')
             AND OBJECTPROPERTY([id], N'IsProcedure')            = 1) 

BEGIN 
  DROP PROCEDURE [dbo].[PU_CDRARC_ADDALL];
  
  PRINT '<<< DROPPED PROCEDURE [dbo].[PU_CDRARC_ADDALL] >>>';
END 
GO

CREATE PROC [dbo].[PU_CDRARC_ADDALL]
AS  

/*************************************************************************************************/ 
/* Name        : PU_CDRARC_ADDALL                                                                */
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
      ,@v_Obj                        = '[DBCATCH].[dbo].[PU_CDRARC_ADDALL]'
      ,@v_App                        = APP_NAME()
      ,@v_User                       = ISNULL(ORIGINAL_LOGIN(), USER_NAME()) 
      ,@v_Spid                       = CONVERT([NVARCHAR](25), @@SPID) 
      ,@v_Debug                      = 0;
      
                                  
      
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

    INSERT [UCC].[dbo].[CDRARC]
    (                 [cdrRecordType],   [globalCallID_callManagerId],   [globalCallID_callId],   [origLegCallIdentifier],   [dateTimeOrigination],   [origNodeId],   [origSpan],   [origIpAddr],   [callingPartyNumber],   [callingPartyUnicodeLoginUserID],   [origCause_location],   [origCause_value],   [origPrecedenceLevel],   [origMediaTransportAddress_IP],   [origMediaTransportAddress_Port],   [origMediaCap_payloadCapability],   [origMediaCap_maxFramesPerPacket],   [origMediaCap_g723BitRate],   [origVideoCap_Codec],   [origVideoCap_Bandwidth],   [origVideoCap_Resolution],   [origVideoTransportAddress_IP],   [origVideoTransportAddress_Port],   [origRSVPAudioStat],   [origRSVPVideoStat],   [destLegIdentifier],   [destNodeId],   [destSpan],   [destIpAddr],   [originalCalledPartyNumber],   [finalCalledPartyNumber],   [finalCalledPartyUnicodeLoginUserID],   [destCause_location],   [destCause_value],   [destPrecedenceLevel],   [destMediaTransportAddress_IP],   [destMediaTransportAddress_Port],   [destMediaCap_payloadCapability],   [destMediaCap_maxFramesPerPacket],   [destMediaCap_g723BitRate],   [destVideoCap_Codec],   [destVideoCap_Bandwidth],   [destVideoCap_Resolution],   [destVideoTransportAddress_IP],   [destVideoTransportAddress_Port],   [destRSVPAudioStat],   [destRSVPVideoStat],   [dateTimeConnect],   [dateTimeDisconnect],   [lastRedirectDn],   [pkid],   [originalCalledPartyNumberPartition],   [callingPartyNumberPartition],   [finalCalledPartyNumberPartition],   [lastRedirectDnPartition],   [duration],   [origDeviceName],   [destDeviceName],   [origCallTerminationOnBehalfOf],   [destCallTerminationOnBehalfOf],   [origCalledPartyRedirectOnBehalfOf],   [lastRedirectRedirectOnBehalfOf],   [origCalledPartyRedirectReason],   [lastRedirectRedirectReason],   [destConversationId],   [globalCallId_ClusterID],   [joinOnBehalfOf],   [comment],   [authCodeDescription],   [authorizationLevel],   [clientMatterCode],   [origDTMFMethod],   [destDTMFMethod],   [callSecuredStatus],   [origConversationId],   [origMediaCap_Bandwidth],   [destMediaCap_Bandwidth],   [authorizationCodeValue],   [outpulsedCallingPartyNumber],   [outpulsedCalledPartyNumber],   [origIpv4v6Addr],   [destIpv4v6Addr],   [origVideoCap_Codec_Channel2],   [origVideoCap_Bandwidth_Channel2],   [origVideoCap_Resolution_Channel2],   [origVideoTransportAddress_IP_Channel2],   [origVideoTransportAddress_Port_Channel2],   [origVideoChannel_Role_Channel2],   [destVideoCap_Codec_Channel2],   [destVideoCap_Bandwidth_Channel2],   [destVideoCap_Resolution_Channel2],   [destVideoTransportAddress_IP_Channel2],   [destVideoTransportAddress_Port_Channel2],   [destVideoChannel_Role_Channel2],   [incomingProtocolID],   [incomingProtocolCallRef],   [outgoingProtocolID],   [outgoingProtocolCallRef],   [currentRoutingReason],   [origRoutingReason],   [lastRedirectingRoutingReason],   [huntPilotDN],   [huntPilotPartition],   [calledPartyPatternUsage],   [outpulsedOriginalCalledPartyNumber],   [outpulsedLastRedirectingNumber],   [wasCallQueued],   [totalWaitTimeInQueue],   [callingPartyNumber_uri],   [originalCalledPartyNumber_uri],   [finalCalledPartyNumber_uri],   [lastRedirectDn_uri],   [mobileCallingPartyNumber],   [finalMobileCalledPartyNumber],   [origMobileDeviceName],   [destMobileDeviceName],   [origMobileCallDuration],   [destMobileCallDuration],   [mobileCallType],   [originalCalledPartyPattern],   [finalCalledPartyPattern],   [lastRedirectingPartyPattern],   [huntPilotPattern])       
    SELECT DISTINCT a.[cdrRecordType], a.[globalCallID_callManagerId], a.[globalCallID_callId], a.[origLegCallIdentifier], a.[dateTimeOrigination], a.[origNodeId], a.[origSpan], a.[origIpAddr], a.[callingPartyNumber], a.[callingPartyUnicodeLoginUserID], a.[origCause_location], a.[origCause_value], a.[origPrecedenceLevel], a.[origMediaTransportAddress_IP], a.[origMediaTransportAddress_Port], a.[origMediaCap_payloadCapability], a.[origMediaCap_maxFramesPerPacket], a.[origMediaCap_g723BitRate], a.[origVideoCap_Codec], a.[origVideoCap_Bandwidth], a.[origVideoCap_Resolution], a.[origVideoTransportAddress_IP], a.[origVideoTransportAddress_Port], a.[origRSVPAudioStat], a.[origRSVPVideoStat], a.[destLegIdentifier], a.[destNodeId], a.[destSpan], a.[destIpAddr], a.[originalCalledPartyNumber], a.[finalCalledPartyNumber], a.[finalCalledPartyUnicodeLoginUserID], a.[destCause_location], a.[destCause_value], a.[destPrecedenceLevel], a.[destMediaTransportAddress_IP], a.[destMediaTransportAddress_Port], a.[destMediaCap_payloadCapability], a.[destMediaCap_maxFramesPerPacket], a.[destMediaCap_g723BitRate], a.[destVideoCap_Codec], a.[destVideoCap_Bandwidth], a.[destVideoCap_Resolution], a.[destVideoTransportAddress_IP], a.[destVideoTransportAddress_Port], a.[destRSVPAudioStat], a.[destRSVPVideoStat], a.[dateTimeConnect], a.[dateTimeDisconnect], a.[lastRedirectDn], a.[pkid], a.[originalCalledPartyNumberPartition], a.[callingPartyNumberPartition], a.[finalCalledPartyNumberPartition], a.[lastRedirectDnPartition], a.[duration], a.[origDeviceName], a.[destDeviceName], a.[origCallTerminationOnBehalfOf], a.[destCallTerminationOnBehalfOf], a.[origCalledPartyRedirectOnBehalfOf], a.[lastRedirectRedirectOnBehalfOf], a.[origCalledPartyRedirectReason], a.[lastRedirectRedirectReason], a.[destConversationId], a.[globalCallId_ClusterID], a.[joinOnBehalfOf], a.[comment], a.[authCodeDescription], a.[authorizationLevel], a.[clientMatterCode], a.[origDTMFMethod], a.[destDTMFMethod], a.[callSecuredStatus], a.[origConversationId], a.[origMediaCap_Bandwidth], a.[destMediaCap_Bandwidth], a.[authorizationCodeValue], a.[outpulsedCallingPartyNumber], a.[outpulsedCalledPartyNumber], a.[origIpv4v6Addr], a.[destIpv4v6Addr], a.[origVideoCap_Codec_Channel2], a.[origVideoCap_Bandwidth_Channel2], a.[origVideoCap_Resolution_Channel2], a.[origVideoTransportAddress_IP_Channel2], a.[origVideoTransportAddress_Port_Channel2], a.[origVideoChannel_Role_Channel2], a.[destVideoCap_Codec_Channel2], a.[destVideoCap_Bandwidth_Channel2], a.[destVideoCap_Resolution_Channel2], a.[destVideoTransportAddress_IP_Channel2], a.[destVideoTransportAddress_Port_Channel2], a.[destVideoChannel_Role_Channel2], a.[incomingProtocolID], a.[incomingProtocolCallRef], a.[outgoingProtocolID], a.[outgoingProtocolCallRef], a.[currentRoutingReason], a.[origRoutingReason], a.[lastRedirectingRoutingReason], a.[huntPilotDN], a.[huntPilotPartition], a.[calledPartyPatternUsage], a.[outpulsedOriginalCalledPartyNumber], a.[outpulsedLastRedirectingNumber], a.[wasCallQueued], a.[totalWaitTimeInQueue], a.[callingPartyNumber_uri], a.[originalCalledPartyNumber_uri], a.[finalCalledPartyNumber_uri], a.[lastRedirectDn_uri], a.[mobileCallingPartyNumber], a.[finalMobileCalledPartyNumber], a.[origMobileDeviceName], a.[destMobileDeviceName], a.[origMobileCallDuration], a.[destMobileCallDuration], a.[mobileCallType], a.[originalCalledPartyPattern], a.[finalCalledPartyPattern], a.[lastRedirectingPartyPattern], a.[huntPilotPattern]
      FROM [UCC].[dbo].[CDR]                                      a
      LEFT JOIN [UCC].[dbo].[CDRARC]                              b
        ON a.[GlobalCallID_Callid]                                = b.[GlobalCallID_Callid]
     WHERE b.[GlobalCallID_Callid] IS NULL
     ORDER BY a.GlobalCallID_Callid, a.[dateTimeOrigination], a.[dateTimeConnect], a.[dateTimeDisconnect];

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

IF OBJECT_ID('[dbo].[PU_CDRARC_ADDALL]') IS NOT NULL
BEGIN
	PRINT '<<< CREATED PROCEDURE [dbo].[PU_CDRARC_ADDALL] >>>';
END;
ELSE 
BEGIN
	PRINT '<<< FAILED TO CREATE PROCEDURE [dbo].[PU_CDRARC_ADDALL] >>>';
END;
GO

