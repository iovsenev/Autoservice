using Microsoft.Data.SqlClient;
using System.Runtime.InteropServices;
using Excel = Microsoft.Office.Interop.Excel;

var path = Directory.GetCurrentDirectory();
Console.WriteLine(path);
Console.Write("Введите месяц: ");
int month = int.Parse(Console.ReadLine());

Console.Write("Введите год: ");
int year = int.Parse(Console.ReadLine());
string connectionString = "Server=localhost;Database=AutoServiceDB;User Id=sa;Password=LOLO_karapuz0991;TrustServerCertificate=True;";
string query = @"
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
    MONTH(r.DateStart) = @Month AND
    YEAR(r.DateStart) = @Year AND
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
        ";

System.Data.DataTable table = new System.Data.DataTable();
using (SqlConnection conn = new SqlConnection(connectionString))
using (SqlCommand cmd = new SqlCommand(query, conn))
{
    cmd.Parameters.AddWithValue("@month", month);
    cmd.Parameters.AddWithValue("@year", year);

    conn.Open();
    using (SqlDataReader reader = cmd.ExecuteReader())
    {
        table.Load(reader);
    }
}

Excel.Application excelApp = null;
Excel.Workbook wb = null;
Excel.Worksheet ws = null;

try
{
    excelApp = new Excel.Application();
    excelApp.Visible = true;

    wb = excelApp.Workbooks.Open(Path.Combine(path, @"Template.xltm"), ReadOnly: false);
    ws = (Excel.Worksheet)wb.Sheets["Report"];

    for (int i = 0; i < table.Columns.Count; i++)
    {
        Excel.Range cell = (Excel.Range)ws.Cells[1, i + 1];
        cell.Value = table.Columns[i].ColumnName;
        Marshal.ReleaseComObject(cell);
    }

    for (int i = 0; i < table.Rows.Count; i++)
    {
        for (int j = 0; j < table.Columns.Count; j++)
        {
            Excel.Range cell = (Excel.Range)ws.Cells[i + 2, j + 1];
            cell.Value = table.Rows[i][j];
            Marshal.ReleaseComObject(cell);
        }
    }

    excelApp.Run("FormatReport");

    wb.SaveAs(Path.Combine(path, @"SavedReport.xlsx"));
        wb.Close(false);
}
finally
{
    if (ws != null) Marshal.ReleaseComObject(ws);
    if (wb != null)
        Marshal.ReleaseComObject(wb);
    if (excelApp != null)
    {
        excelApp.Quit();
        Marshal.ReleaseComObject(excelApp);
    }

    GC.Collect();
    GC.WaitForPendingFinalizers();
}

Console.WriteLine("Отчет создан. для завершения нажмите любую клавишу. ");
Console.ReadKey();