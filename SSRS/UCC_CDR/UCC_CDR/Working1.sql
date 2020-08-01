select * from cdr where GlobalCallID_Callid = 460019

  select * from information_schema.columns
  where table_name = 'cdr'

select * from cmr 

select GlobalCallID_Callid, count(1)
  FROM cdr
group by GlobalCallID_Callid
having count(1) > 1
order by GlobalCallID_Callid DESC

SELECT DISTINCT ROW_NUMBER() OVER(PARTITION BY GlobalCallID_Callid ORDER BY GlobalCallID_Callid, [dateTimeOrigination], [dateTimeConnect], [dateTimeDisconnect] ASC) AS RN
      ,GlobalCallID_Callid
      ,callingPartyNumber
      ,finalCalledPartyNumber
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
ORDER BY GlobalCallID_Callid, [dateTimeOrigination], [dateTimeConnect], [dateTimeDisconnect];


  select * from information_schema.columns
  where table_name = 'cdr'
  and column_name like '%hunt%'

  select destConversationID, * from cdr

select finalCalledPartyNumberPartition from cdr


January 1st, 1970.

 

For example, 973995954 translates to 11/12/00 2:25 AM.


SELECT DATEADD(second, 973995954, '19700101')
SELECT DATEADD(second, 1562000193, '19700101')


select replace('abc"def"', '"', '')

select * from CDRQuePerformance 
select [finalCalledPartyUnicodeLoginUserID], * from cdrarc order by dateTimeConnect desc
select count(1) from cdr (nolock)
select count(1) from CDRQuePerformance (nolock)

select * from CDRQuePerformance where [GlobalCallID_Callid] = 761792


    SELECT DISTINCT ROW_NUMBER() OVER(PARTITION BY [GlobalCallID_Callid] ORDER BY [GlobalCallID_Callid], [dateTimeOrigination], [dateTimeConnect], [dateTimeDisconnect] ASC) AS RN
          ,[GlobalCallID_Callid]
          ,REPLACE([callingPartyNumber], '"', '')                                                AS [callingPartyNumber]
          ,REPLACE([finalCalledPartyNumber], '"', '')                                            AS [finalCalledPartyNumber]
	      ,RIGHT(LTRIM(RTRIM(REPLACE([finalCalledPartyNumber], '"', '') )), 4)                   AS [finalCalledPartyNumberShort]
          ,REPLACE([finalCalledPartyUnicodeLoginUserID], '"', '')                                AS [finalCalledPartyUnicodeLoginUserID]
          ,DATEADD(SECOND, CONVERT([INT], dateTimeOrigination), '19700101')                      AS [dateTimeOrigination]
          ,DATEADD(SECOND, CONVERT([INT], dateTimeConnect), '19700101')                          AS [dateTimeConnect]
          ,DATEADD(SECOND, CONVERT([INT], dateTimeDisconnect) , '19700101')                      AS [dateTimeDisconnect]
          ,duration
		  into base
      FROM cdr

	  create clustered index abc on base([GlobalCallID_Callid])


    SELECT [finalCalledPartyNumber]
	      ,[finalCalledPartyNumberShort]
		  ,[finalCalledPartyUnicodeLoginUserID]
		  ,COUNT(1)                                                                         AS [CallsHandled]
		  ,CONVERT(VARCHAR, DATEADD(ms, SUM([Answer]) * 1000, 0), 114)                      AS [TotalSpeedAnswer]
		  ,CONVERT(VARCHAR, DATEADD(ms, AVG([Answer]) * 1000, 0), 114)                      AS [AverageSpeedAnswer]
		  ,CASE WHEN SUM([Handle]) < 1000000
		        THEN CONVERT(VARCHAR, DATEADD(ms, SUM([Handle]) * 1000, 0), 114)
				ELSE CONVERT(VARCHAR, DATEADD(mi, SUM([Handle]) * 10, 0), 114)
				 END                                                                        AS [HandleTime]
		  ,CONVERT(VARCHAR, DATEADD(ms, AVG([Handle]) * 1000, 0), 114)                      AS [AverageHandleTime]
      FROM [UCC].[dbo].[CDRQuePerformance] AS a
     WHERE ([finalCalledPartyUnicodeLoginUserID] <> '\')
	   AND [datetimeconnect] > DATEADD(DAY, -7, GETDATE())
     GROUP BY [finalCalledPartyNumber], [finalCalledPartyNumberShort], [finalCalledPartyUnicodeLoginUserID]
	  ORDER BY [finalCalledPartyUnicodeLoginUserID]

 SELECT [finalCalledPartyNumber]
	      ,[finalCalledPartyNumberShort]
		  ,[finalCalledPartyUnicodeLoginUserID]
		  ,COUNT(1)                                                                         AS [CallsHandled]
		  ,CONVERT(VARCHAR, DATEADD(ms, SUM([Answer]) * 1000, 0), 114)                      AS [TotalSpeedAnswer]
		  ,CONVERT(VARCHAR, DATEADD(ms, AVG([Answer]) * 1000, 0), 114)                      AS [AverageSpeedAnswer]
		  ,CASE WHEN SUM([Handle]) < 1000000
		        THEN CONVERT(VARCHAR, DATEADD(ms, SUM([Handle]) * 1000, 0), 114)
				ELSE CONVERT(VARCHAR, DATEADD(mi, SUM([Handle]) * 10, 0), 114)
				 END                                                                        AS [HandleTime]
		  ,CONVERT(VARCHAR, DATEADD(ms, AVG([Handle]) * 1000, 0), 114)                      AS [AverageHandleTime]
      FROM [UCC].[dbo].[CDRQuePerformance] AS a
     WHERE ([finalCalledPartyUnicodeLoginUserID] <> '\')
	   AND [datetimeconnect] > DATEADD(DAY, -7, GETDATE())
                     --AND [finalCalledPartyNumberShort] = '7550'
     GROUP BY [finalCalledPartyNumber], [finalCalledPartyNumberShort], [finalCalledPartyUnicodeLoginUserID]
	  ORDER BY [finalCalledPartyUnicodeLoginUserID]



SELECT * FROM [UCC].[dbo].[CDRQuePerformance] WHERE [finalCalledPartyNumber] LIKE '%7550' OR CallingPartyNumber LIKE '%7550'

select * from cdr
where [GlobalCallID_Callid]
in (
680906
,687691
,680906
,699378
,692047
,2937224
,687692
,699378
)
select *
		   from [UCC].[dbo].[CDRQuePerformance]
where CallingPartyNumber LIKE '%7550'
--or originalcalledpartynumber like '%7550'
or [finalCalledPartyNumber] LIKE '%7550'
--or lastredirectdn LIKE '%7550'
--or originalcalledpartypattern like '%7550'

select * from [UCC].[dbo].[CDRQuePerformance] 

 SELECT   CASE WHEN a.[finalCalledPartyNumber] IS NOT NULL
               THEN a.[finalCalledPartyNumber]
			   ELSE 'Totals'
			    END AS a.[finalCalledPartyNumber]
	      ,a.[finalCalledPartyNumberShort]
		  ,a.[finalCalledPartyUnicodeLoginUserID]
		  ,COUNT(1)                                                                         AS [CallsHandled]
		  ,CONVERT(VARCHAR, DATEADD(ms, SUM(a.[Answer]) * 1000, 0), 114)                      AS [TotalSpeedAnswer]
		  ,CONVERT(VARCHAR, DATEADD(ms, AVG(a.[Answer]) * 1000, 0), 114)                      AS [AverageSpeedAnswer]
		  ,CASE WHEN SUM(a.[Handle]) < 1000000
		        THEN CONVERT(VARCHAR, DATEADD(ms, SUM(a.[Handle]) * 1000, 0), 114)
				ELSE CONVERT(VARCHAR, DATEADD(mi, SUM(a.[Handle]) * 10, 0), 114)
				 END                                                                        AS [HandleTime]
		  ,CONVERT(VARCHAR, DATEADD(ms, AVG(a.[Handle]) * 1000, 0), 114)                      AS [AverageHandleTime]
		  ,GROUPING(a.[finalCalledPartyUnicodeLoginUserID])                                   AS Grouped
      FROM [UCC].[dbo].[CDRQuePerformance] AS a
	  JOIN (SELECT [GlobalCallID_Callid]
	          FROM [UCC].[dbo].[CDRQuePerformance]
			 WHERE ([CallingPartyNumber] LIKE '%7550'
			   OR [finalCalledPartyNumber] LIKE '%7550')) b
	    ON a.[GlobalCallID_Callid] = b.[GlobalCallID_Callid]
     WHERE a.[datetimeconnect] > DATEADD(DAY, -7, GETDATE())
	 --  AND (a.[finalCalledPartyUnicodeLoginUserID] <> '\')
     GROUP BY GROUPING SETS ((a.[finalCalledPartyNumber], a.[finalCalledPartyNumberShort], a.[finalCalledPartyUnicodeLoginUserID]), ())
	  ORDER BY Grouped, a.[finalCalledPartyUnicodeLoginUserID]


SELECT    a.[finalCalledPartyNumber]
	      ,a.[finalCalledPartyNumberShort]
		  ,a.[finalCalledPartyUnicodeLoginUserID]
		  ,COUNT(1)                                                                         AS [CallsHandled]
		  ,CONVERT(VARCHAR, DATEADD(ms, SUM(a.[Answer]) * 1000, 0), 114)                      AS [TotalSpeedAnswer]
		  ,CONVERT(VARCHAR, DATEADD(ms, AVG(a.[Answer]) * 1000, 0), 114)                      AS [AverageSpeedAnswer]
		  ,CASE WHEN SUM(a.[Handle]) < 1000000
		        THEN CONVERT(VARCHAR, DATEADD(ms, SUM(a.[Handle]) * 1000, 0), 114)
				ELSE CONVERT(VARCHAR, DATEADD(mi, SUM(a.[Handle]) * 10, 0), 114)
				 END                                                                        AS [HandleTime]
		  ,CONVERT(VARCHAR, DATEADD(ms, AVG(a.[Handle]) * 1000, 0), 114)                      AS [AverageHandleTime]
		  ,GROUPING(a.[finalCalledPartyUnicodeLoginUserID])                                   AS Grouped
      FROM [UCC].[dbo].[CDRQuePerformance] AS a
	  JOIN (SELECT [GlobalCallID_Callid]
	          FROM [UCC].[dbo].[CDRQuePerformance]
			 WHERE ([CallingPartyNumber] LIKE '%7550'
			   OR [finalCalledPartyNumber] LIKE '%7550')) b
	    ON a.[GlobalCallID_Callid] = b.[GlobalCallID_Callid]
     WHERE a.[datetimeconnect] > DATEADD(DAY, -7, GETDATE())
	 --  AND (a.[finalCalledPartyUnicodeLoginUserID] <> '\')
     GROUP BY GROUPING SETS ((a.[finalCalledPartyNumber], a.[finalCalledPartyNumberShort], a.[finalCalledPartyUnicodeLoginUserID]), ())
	  ORDER BY Grouped, a.[finalCalledPartyUnicodeLoginUserID]


