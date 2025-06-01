namespace AutoService.Api;

public class RepairReportDto
{
    public string DateStart { get; set; }
    public string Master { get; set; }
    public string Brand { get; set; }
    public string PlateNumber { get; set; }
    public string IssueDescription { get; set; }
    public decimal CostSum { get; set; }
    public decimal? MasterLoadPercent { get; set; }
}
