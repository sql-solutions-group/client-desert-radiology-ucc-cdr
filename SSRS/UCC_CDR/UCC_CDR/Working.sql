USE Jabber;
GO

IF EXISTS(SELECT 1
            FROM [dbo].[sysobjects]
		   WHERE [id]                                         = OBJECT_ID(N'[dbo].[QuePerformance]')
		     AND OBJECTPROPERTY([id], N'IsTable')         = 1)
BEGIN
  DROP TABLE [dbo].[QuePerformance];
END;
GO


SET NOCOUNT ON;

WITH BASE AS
(
SELECT DISTINCT ROW_NUMBER() OVER(PARTITION BY GlobalCallID_Callid ORDER BY GlobalCallID_Callid, [dateTimeOrigination], [dateTimeConnect], [dateTimeDisconnect] ASC) AS RN
      ,GlobalCallID_Callid
      ,callingPartyNumber
      ,finalCalledPartyNumber
	  ,RIGHT(LTRIM(RTRIM(finalCalledPartyNumber)), 4)                                        AS [finalCalledPartyNumberShort]
      ,finalCalledPartyUnicodeLoginUserID
      ,DATEADD(SECOND, CONVERT([INT], dateTimeOrigination), '19700101')                      AS [dateTimeOrigination]
      ,DATEADD(SECOND, CONVERT([INT], dateTimeConnect), '19700101')                          AS [dateTimeConnect]
      ,DATEADD(SECOND, CONVERT([INT], dateTimeDisconnect) , '19700101')                      AS [dateTimeDisconnect]
      ,duration
FROM cdr
where GlobalCallID_Callid in 
(select GlobalCallID_Callid
  FROM cdr
group by GlobalCallID_Callid
having count(1) > 2)
--ORDER BY GlobalCallID_Callid, [dateTimeOrigination], [dateTimeConnect], [dateTimeDisconnect]
)

SELECT [rn]
      ,a.[GlobalCallID_Callid]
      ,a.[callingPartyNumber]
	  ,a.[finalCalledPartyNumber] 
	  ,a.[finalCalledPartyNumberShort]
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
 -- INTO [QuePerformance]
  FROM [base]                  a
 ORDER BY a.[GlobalCallID_Callid], a.[dateTimeOrigination], a.[dateTimeConnect], a.[dateTimeDisconnect];


 --DELETE Temp
 --WHERE ([GlobalCallID_Callid] IN(SELECT GlobalCallID_Callid
 --                                  FROM Temp
 --                                 GROUP BY GlobalCallID_Callid
 --                                HAVING COUNt(1) > 1)
 --  AND [finalCalledPartyUnicodeLoginUserID] = '\');


SELECT a.[finalCalledPartyNumber] 
      ,a.[finalCalledPartyNumberShort]
      ,a.[finalCalledPartyUnicodeLoginUserID]
	  ,COUNT(1)                                                  AS [CallsHandled]
	  ,CONVERT(VARCHAR, DATEADD(ms, SUM([Answer])  * 1000, 0), 114)                                             AS [TotalSpeedAnswer]
	  ,CONVERT(VARCHAR, DATEADD(ms, AVG([Answer])   * 1000, 0), 114)                                            AS [AverageSpeedAnswer]
	  ,SUM([Handle])                                             AS [HandleTime] 
	  ,CONVERT(VARCHAR, DATEADD(ms, AVG([Handle])  * 1000, 0), 114)                                             AS [AverageHandleTime]                                       
  FROM [UCC].[dbo].[CDRQuePerformance] a 
 WHERE a.[finalCalledPartyUnicodeLoginUserID] <> '\' AND (dateTimeConnect > @p_Start)
 GROUP BY a.[finalCalledPartyNumber] , a.[finalCalledPartyNumberShort], a.[finalCalledPartyUnicodeLoginUserID]
ORDER BY a.[finalCalledPartyUnicodeLoginUserID];

SELECT        finalCalledPartyNumber, finalCalledPartyNumberShort, finalCalledPartyUnicodeLoginUserID, COUNT(1) AS CallsHandled,
CONVERT(VARCHAR, DATEADD(ms, SUM(Answer) * 1000, 0), 114)  AS TotalSpeedAnswer, CONVERT(VARCHAR, DATEADD(ms, AVG(Answer)* 1000, 0), 114)   AS AverageSpeedAnswer, CONVERT(VARCHAR, DATEADD(ms, SUM(CONVERT(BIGINT), Handle)) * 1000, 0), 114)           AS HandleTime,  AVG(Handle)   AS AverageHandleTime
FROM            [UCC].[dbo].[CDRQuePerformance] AS a
WHERE        (finalCalledPartyUnicodeLoginUserID <> '\') AND (dateTimeConnect > @p_Start)
GROUP BY finalCalledPartyNumber, finalCalledPartyNumberShort, finalCalledPartyUnicodeLoginUserID
ORDER BY finalCalledPartyUnicodeLoginUserID


--SELECT * INTO ucc.dbo.QuePerformance FROM [QuePerformance]
--DROP TABLE Temp

select @@SERVERNAME

select * from QuePerformance where finalcalledpartynumbershort = '7750'

SELECT CONVERT(varchar, DATEADD(ms, 62 * 1000, 0), 114)

select min(datetimeconnect), max(datetimeconnect) from QuePerformance


select * from [UCC].[dbo].[CDRQuePerformance]
where [finalCalledPartyNumberShort] = '7750'
 and datetimeorigination > DATEADD(DAY, -14, GETDATE())
order by datetimeorigination asc


select * 
from [dbo].[CDRARC]
where originalCalledPartyNumber like '%7750%'
and finalcalledpartynumber LIKE '%4999%'
order by datetimeconnect desc



select * from INFORMATION_SCHEMA.columns where table_name = 'CDRARC'
and column_name like '%global%'


select *
from [UCC].[dbo].[CDRQuePerformance]
where globalCallID_callId IN (
861140
,3025833
,858471
,858449
,3016225
,835898
,3011378
,823724)
order by globalCallID_callId