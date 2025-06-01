import React, { useState, useEffect } from "react";

type RepairReportRow = {
    dateStart: string;
    master: string;
    brand: string;
    plateNumber: string;
    issueDescription: string;
    costSum: number;
    masterLoadPercent: number | null;
};

export default function Report() {
    const [year, setYear] = useState<number>(2025);
    const [month, setMonth] = useState<number>(5);
    const [data, setData] = useState<RepairReportRow[]>([]);
    const [loading, setLoading] = useState<boolean>(false);

    const fetchReport = async () => {
        setLoading(true);
        try {
            const response = await fetch(
                `https://localhost:7265/api/reports?year=${year}&month=${month}`
            );
            if (!response.ok) {
                throw new Error("Ошибка при загрузке отчёта");
            }
            const json: RepairReportRow[] = await response.json();
            setData(json);
        } catch (err) {
            console.error("Ошибка при получении данных отчёта:", err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchReport();
    }, [year, month]);

    return (
        <div>
            <h2>Отчёт по ремонту</h2>
            <div>
                <label>
                    Год:
                    <select
                        value={year}
                        onChange={(e) => setYear(Number(e.target.value))}
                    >
                        {[2023, 2024, 2025].map((y) => (
                            <option key={y} value={y}>
                                {y}
                            </option>
                        ))}
                    </select>
                </label>
                <label>
                    Месяц:
                    <select
                        value={month}
                        onChange={(e) => setMonth(Number(e.target.value))}
                    >
                        {[...Array(12).keys()].map((m) => (
                            <option key={m + 1} value={m + 1}>
                                {m + 1}
                            </option>
                        ))}
                    </select>
                </label>
            </div>
            {loading ? (
                <p>Загрузка...</p>
            ) : (
                <table
                    border={1}
                    cellPadding={5}
                    style={{ borderCollapse: "collapse", marginTop: "10px" }}
                >
                    <thead>
                        <tr>
                            <th>Дата поступления</th>
                            <th>Мастер</th>
                            <th>Марка</th>
                            <th>Гос. номер</th>
                            <th>Неисправность</th>
                            <th>Сумма</th>
                            <th>Загруженность мастера (%)</th>
                        </tr>
                    </thead>
                    <tbody>
                        {data.length === 0 ? (
                            <tr>
                                <td colSpan={7}>Данные отсутствуют</td>
                            </tr>
                        ) : (
                            data.map((row, i) => (
                                <tr key={i}>
                                    <td>{row.dateStart}</td>
                                    <td>{row.master}</td>
                                    <td>{row.brand}</td>
                                    <td>{row.plateNumber}</td>
                                    <td>{row.issueDescription}</td>
                                    <td>{row.costSum.toFixed(2)}</td>
                                    <td>
                                        {row.masterLoadPercent !== null
                                            ? row.masterLoadPercent.toFixed(2)
                                            : ""}
                                    </td>
                                </tr>
                            ))
                        )}
                    </tbody>
                </table>
            )}
        </div>
    );
}
