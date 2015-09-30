DROP FUNCTION IF EXISTS gpSelect_Report_Sold (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Sold(
    IN inStartDate     TDateTime , -- дата начала
    IN inEndDate       TDateTime , -- дата окончания
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    PlanDate          TDateTime,  --Месяц плана
    UnitName          TVarChar,   --подразделение
    PlanAmount        TFloat,     --План
    PlanAmountAccum   TFloat,     --План с накоплением
    FactAmount        TFloat,     --Факт
    FactAmountAccum   TFloat,     --Факт с накоплением
    DiffAmount        TFloat,     --Разница (Факт - План) 
    DiffAmountAccum   TFloat,     --Разница в накоплении (Факт с накоплением - План с накоплением)
    PercentMake       TFloat,     --% выполнение плана
    PercentMakeAccum  TFloat      --% выпонения по накоплению
)

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    inStartDate := date_trunc('month', inStartDate);
    inEndDate := date_trunc('month', inEndDate) + Interval '1 MONTH';

    RETURN QUERY
        SELECT
            T2.PlanDate,
            T2.UnitName,
            SUM(T2.PlanAmount)::TFloat                                                AS PlanAmount,
            SUM(T2.PlanAmountAccum)::TFloat                                           AS PlanAmountAccum,
            SUM(T2.FactAmount)::TFloat                                                AS FactAmount,
            SUM(T2.FactAmountAccum)::TFloat                                           AS FactAmountAccum,
            (COALESCE(SUM(T2.FactAmount),0)
               - COALESCE(SUM(T2.PlanAmount),0))::TFloat                              AS DiffAmount,
            (COALESCE(SUM(T2.FactAmountAccum),0)
               - COALESCE(SUM(T2.PlanAmountAccum),0))::TFloat                         AS DiffAmountAccum,
            CASE 
              WHEN COALESCE(SUM(T2.PlanAmount),0) <> 0 
                THEN 100.0*COALESCE(SUM(T2.FactAmount),0) / SUM(T2.PlanAmount)
            END::TFloat                                                            AS PercentMake,
            CASE 
              WHEN COALESCE(SUM(T2.PlanAmountAccum),0) <> 0 
                THEN 100.0*COALESCE(SUM(T2.FactAmountAccum),0) / SUM(T2.PlanAmountAccum)
            END::TFloat                                                            AS PercentMakeAccum
        FROM(
            SELECT
                Object_ReportSoldParams.PlanDate                  AS PlanDate,
                Object_ReportSoldParams.UnitName                  AS UnitName,
                Object_ReportSoldParams.PlanAmount                AS PlanAmount,
                SUM(Object_ReportSoldParams.PlanAmount) 
                  OVER(Partition BY Object_ReportSoldParams.UnitId 
                   ORDER BY Object_ReportSoldParams.PlanDate) AS PlanAmountAccum,
                0::TFloat                                         AS FactAmount,
                0::TFloat                                         AS FactAmountAccum
            FROM
                Object_ReportSoldParams_View AS Object_ReportSoldParams
            WHERE
                Object_ReportSoldParams.PlanDate >= inStartDate 
                AND 
                Object_ReportSoldParams.PlanDate < inEndDate
            UNION ALL
            SELECT
                T1.PlanDate,
                Object_Unit.ValueData AS UnitName,
                0.0::TFloat                                                           AS PlanAmount,
                0.0::TFloat                                                           AS PlanAmountAccum,
                T1.FactAmount                                                         AS FactAmount,
                SUM(T1.FactAmount) OVER(PARTITION BY T1.UnitID ORDER BY T1.PlanDate)  AS FactAmountAccum  
            FROM (
                SELECT
                    date_trunc('month', MovementCheck.OperDate)::TDateTime AS PlanDate,
                    MovementCheck.UnitId                                   AS UnitID,
                    SUM(TotalSumm)                                         AS FactAmount
                FROM
                    Movement_Check_View AS MovementCheck
                WHERE
                    MovementCheck.OperDate >= inStartDate
                    AND 
                    MovementCheck.OperDate < inEndDate
                    AND
                    MovementCheck.StatusId = zc_Enum_Status_Complete()
                GROUP BY
                    date_trunc('month', MovementCheck.OperDate)::TDateTime,
                    MovementCheck.UnitID
                ) AS T1
                INNER JOIN Object AS Object_Unit 
                          ON T1.UnitID = Object_Unit.Id
            ) AS T2
        GROUP BY
            T2.PlanDate,
            T2.UnitName
        ORDER BY
            T2.PlanDate,
            T2.UnitName;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Report_Sold (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 28.09.15                                                                        *
*/
