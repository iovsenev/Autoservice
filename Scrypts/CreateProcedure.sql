CREATE FUNCTION fn_MasterLoadPercent_OnlyInWork (
    @MasterID INT,
    @Year INT,
    @Month INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TotalRepairs INT
    DECLARE @MasterRepairs INT
    DECLARE @Percent FLOAT

    SELECT @TotalRepairs = COUNT(*)
    FROM Repairs
    WHERE YEAR(DateStart) = @Year AND MONTH(DateStart) = @Month AND (DateEnd = null or DateEnd > GETDATE())

    SELECT @MasterRepairs = COUNT(*)
    FROM Repairs
    WHERE MasterID = @MasterID AND YEAR(DateStart) = @Year AND MONTH(DateStart) = @Month AND (DateEnd = null or DateEnd > GETDATE())

    IF @TotalRepairs = 0
        SET @Percent = 0
    ELSE
        SET @Percent = ROUND(CAST(@MasterRepairs AS FLOAT) / @TotalRepairs * 100, 2)

    RETURN @Percent
END

CREATE FUNCTION fn_MasterLoadPercent_Total (
    @MasterID INT,
    @Year INT,
    @Month INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TotalRepairs INT
    DECLARE @MasterRepairs INT
    DECLARE @Percent FLOAT

    SELECT @TotalRepairs = COUNT(*)
    FROM Repairs
    WHERE YEAR(DateStart) = @Year AND MONTH(DateStart) = @Month

    SELECT @MasterRepairs = COUNT(*)
    FROM Repairs
    WHERE MasterID = @MasterID AND YEAR(DateStart) = @Year AND MONTH(DateStart) = @Month

    IF @TotalRepairs = 0
        SET @Percent = 0
    ELSE
        SET @Percent = ROUND(CAST(@MasterRepairs AS FLOAT) / @TotalRepairs * 100, 2)

    RETURN @Percent
END
