SELECT 
    ISNULL(CONVERT(NVARCHAR, r.DateStart, 104), 
        CASE 
            WHEN GROUPING(m.FullName) = 0 THEN N'ИТОГО по мастеру'
            ELSE N'ОБЩИЙ ИТОГ'
        END
    ) AS Дата_Поступления,
    ISNULL(m.FullName, 
        CASE 
            WHEN GROUPING(m.FullName) = 1 THEN N''
            ELSE N'ОБЩИЙ ИТОГ'
        END
    ) AS Мастер,
    ISNULL(c.Brand, '') AS Марка,
    ISNULL(c.PlateNumber, '') AS ГосНомер,
    ISNULL(r.IssueDescription, '') AS Неисправность,    
    SUM(r.Cost) AS Сумма,
    CASE 
        WHEN GROUPING(m.FullName) = 0 AND GROUPING(r.DateStart) = 1 THEN 
            dbo.fn_MasterLoadPercent_Total(MAX(r.MasterID), 2025, 5)
        ELSE NULL
    END AS Загруженность_Мастера_в_Процентах
FROM Repairs r
LEFT JOIN Cars c ON r.CarID = c.CarID 
LEFT JOIN Masters m ON r.MasterID = m.MasterID 
WHERE 
    MONTH(r.DateStart) = 5 AND
    YEAR(r.DateStart) = 2025 AND
    (r.DateEnd IS NULL OR r.DateEnd > GETDATE())
GROUP BY 
    GROUPING SETS (
        (r.DateStart, m.FullName, r.MasterID, c.Brand, c.PlateNumber, r.IssueDescription),
        (m.FullName),
        ()
    )
ORDER BY 
    CASE 
        WHEN GROUPING(m.FullName) = 1 THEN 2 
        WHEN r.DateStart IS NULL THEN 1      
        ELSE 0                              
    END,
    MIN(r.DateStart),
    Мастер,
    Марка;

