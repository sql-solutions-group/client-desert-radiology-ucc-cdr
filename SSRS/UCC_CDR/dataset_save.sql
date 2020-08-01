SELECT        [finalCalledPartyNumber], CASE WHEN Grouped = 0 THEN [finalCalledPartyNumberShort] ELSE 'Totals' END AS [finalCalledPartyNumberShort], [finalCalledPartyUnicodeLoginUserID], [CallsHandled], 
                         [TotalSpeedAnswer], [AverageSpeedAnswer], [HandleTime], [AverageHandleTime], Grouped, CONVERT(INT, NULL) AS UnansweredCalls
FROM            (SELECT        a.[finalCalledPartyNumber], a.[finalCalledPartyNumberShort], a.[finalCalledPartyUnicodeLoginUserID], COUNT(1) AS [CallsHandled], CONVERT(VARCHAR, DATEADD(ms, SUM(a.[Answer]) * 1000, 0), 
                                                    108) AS [TotalSpeedAnswer], CONVERT(VARCHAR, DATEADD(ms, AVG(a.[Answer]) * 1000, 0), 108) AS [AverageSpeedAnswer], CASE WHEN SUM(a.[Handle]) < 1000000 THEN CONVERT(VARCHAR, 
                                                    DATEADD(ms, SUM(a.[Handle]) * 1000, 0), 108) ELSE CONVERT(VARCHAR, DATEADD(mi, SUM(a.[Handle]) * 10, 0), 108) END AS [HandleTime], CONVERT(VARCHAR, DATEADD(ms, AVG(a.[Handle]) 
                                                    * 1000, 0), 108) AS [AverageHandleTime], GROUPING(a.[finalCalledPartyUnicodeLoginUserID]) AS Grouped
                          FROM            [UCC].[dbo].[CDRQuePerformance] AS a
                          WHERE LTRIM(RTRIM([finalCalledPartyNumberShort])) IN ('7738', '7739', '7750', '8710', '8728')
						    AND CONVERT([VARCHAR](10), a.[datetimeconnect], 112) = CASE WHEN DATEPART(DW, GETDATE()) = 2
                                                            THEN CONVERT([VARCHAR](10), DATEADD(DAY, -3, GETDATE()), 112)
															ELSE CONVERT([VARCHAR](10), DATEADD(DAY, -1, GETDATE()), 112)
															 END
                          GROUP BY GROUPING SETS((a.[finalCalledPartyNumber], a.[finalCalledPartyNumberShort], a.[finalCalledPartyUnicodeLoginUserID]), ())) XYZ

UNION

--SELECT        NULL AS [finalCalledPartyNumber], 'Unanswered Calls' AS [finalCalledPartyNumberShort], NULL AS [finalCalledPartyUnicodeLoginUserID], NULL, NULL, NULL, NULL, NULL, - 1 AS Grouped, ISNULL(COUNT(1), 0) 
--                         AS UnansweredCalls

SELECT CASE WHEN [originalCalledPartyNumber] = '7750'
            THEN 'Voicemail for 7750'
			WHEN [originalCalledPartyNumber] = '7738'
            THEN 'Voicemail for 7738'
			WHEN [originalCalledPartyNumber] = '7739'
            THEN 'Voicemail for 7739'
			WHEN [originalCalledPartyNumber] = '8710'
            THEN 'Voicemail for 8710'
			WHEN [originalCalledPartyNumber] = '8728'
            THEN 'Voicemail for 8728'
			ELSE 'VoiceMail'
			 END AS [finalCalledPartyNumber], 
       CASE WHEN [originalCalledPartyNumber] = '7750'
            THEN 'Voicemail for 7750'
			WHEN [originalCalledPartyNumber] = '7738'
            THEN 'Voicemail for 7738'
			WHEN [originalCalledPartyNumber] = '7739'
            THEN 'Voicemail for 7739'
			WHEN [originalCalledPartyNumber] = '8710'
            THEN 'Voicemail for 8710'
			WHEN [originalCalledPartyNumber] = '8728'
            THEN 'Voicemail for 8728'
			ELSE 'VoiceMail'
			 END AS [finalCalledPartyNumberShort], 
			 [finalCalledPartyUnicodeLoginUserID]
       ,NULL AS [CallsHandled], NULL [TotalSpeedAnswer], NULL [AverageSpeedAnswer], NULL [HandleTime], NULL [AverageHandleTime],
	   -1 AS Grouped, ISNULL(COUNT(1), 0) AS UnansweredCalls
FROM            [UCC].[dbo].[CDRQuePerformance] a
WHERE        LTRIM(RTRIM([originalCalledPartyNumber])) IN ('7738', '7739', '7750', '8710', '8728') 
AND finalcalledpartynumber = '4999'
						    AND CONVERT([VARCHAR](10), a.[datetimeconnect], 112) = CASE WHEN DATEPART(DW, GETDATE()) = 2
                                                            THEN CONVERT([VARCHAR](10), DATEADD(DAY, -3, GETDATE()), 112)
															ELSE CONVERT([VARCHAR](10), DATEADD(DAY, -1, GETDATE()), 112)
															 END
GROUP BY [originalCalledPartyNumber], [finalCalledPartyUnicodeLoginUserID]
ORDER BY Grouped, [finalCalledPartyNumber]