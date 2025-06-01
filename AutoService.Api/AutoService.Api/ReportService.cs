using Dapper;
using Microsoft.Data.SqlClient;
namespace AutoService.Api;

public class ReportService
{
    private readonly IConfiguration _configuration;

    public ReportService(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public async Task<List<RepairReportDto>> RunReport(int month, int year)
    {
        var connectionString = _configuration.GetConnectionString("Default");

        using var connection = new SqlConnection(connectionString);
        await connection.OpenAsync();

        var sql = @"-- Твой SQL запрос с параметрами @year и @month
                SELECT 
                    ISNULL(CONVERT(NVARCHAR, r.DateStart, 104), 
                        CASE 
                            WHEN GROUPING(m.FullName) = 0 THEN N'ИТОГО по мастеру'
                            ELSE N'ОБЩИЙ ИТОГ'
                        END
                    ) AS DateStart,
                    ISNULL(m.FullName, 
                        CASE 
                            WHEN GROUPING(m.FullName) = 1 THEN N''
                            ELSE N'ОБЩИЙ ИТОГ'
                        END
                    ) AS Master,
                    ISNULL(c.Brand, '') AS Brand,
                    ISNULL(c.PlateNumber, '') AS PlateNumber,
                    ISNULL(r.IssueDescription, '') AS IssueDescription,    
                    SUM(r.Cost) AS CostSum,
                    CASE 
                        WHEN GROUPING(m.FullName) = 0 AND GROUPING(r.DateStart) = 1 THEN 
                            dbo.fn_MasterLoadPercent_Total(MAX(r.MasterID), @year, @month)
                        ELSE NULL
                    END AS MasterLoadPercent
                FROM Repairs r
                LEFT JOIN Cars c ON r.CarID = c.CarID 
                LEFT JOIN Masters m ON r.MasterID = m.MasterID 
                WHERE 
                    MONTH(r.DateStart) = @month AND
                    YEAR(r.DateStart) = @year AND
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
                    Master,
                    Brand";

        var parameters = new { year, month };
        var report = await connection.QueryAsync<RepairReportDto>(sql, parameters);
        return report.ToList();
    }
}
