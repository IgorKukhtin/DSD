-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpReport_Check_Promo (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_Promo(
    IN inStartDate     TDateTime ,
    IN inEndDate       TDateTime ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    PlanDate          TDateTime,  --Месяц 
    UnitName          TVarChar,   --подразделение
    TotalAmount       TFloat,     --итого продажа шт
    TotalSumma        TFloat,     --итого продажа грн
    AmountPromo       TFloat,     --продажа Промо шт
    SummaPromo        TFloat,     --продажа Промо грн
    Amount            TFloat,     --продажа Промо шт
    Summa             TFloat,     --продажа Промо грн
    PercentPromo      TFloat     --% ПРомо от всех продаж
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    --inStartDate := date_trunc('month', inStartDate);
    --inEndDate := date_trunc('month', inEndDate) + Interval '1 MONTH';
    inEndDate := inEndDate + interval '1  day';
        
    RETURN QUERY
      WITH
           -- выбираем все данные из проводок  ( цена, док маркетинга)
             tmpData AS (SELECT Date_trunc('month', MIContainer.OperDate)::TDateTime AS OperDate
                              , COALESCE (MIContainer.WhereObjectId_analyzer,0) AS UnitId
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS TotalAmount
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS TotalSumma
                              , SUM (CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer,0) = 0 THEN 0 ELSE COALESCE (-1 * MIContainer.Amount, 0) END) AS AmountPromo
                              , SUM (CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer,0) = 0 THEN 0 ELSE COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) END) AS SummaPromo

                         FROM MovementItemContainer AS MIContainer
                         WHERE MIContainer.DescId = zc_MIContainer_Count()
                           AND MIContainer.MovementDescId = zc_Movement_Check()
                           AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate
                          -- AND MIContainer.OperDate >= '03.10.2016' AND MIContainer.OperDate < '01.12.2016'
                         GROUP BY date_trunc('month', MIContainer.OperDate)
                                , COALESCE (MIContainer.WhereObjectId_analyzer,0)
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                        )

         -- результат
         SELECT tmpData.OperDate           AS PlanDate      
              , Object_Unit.ValueData      AS UnitName
              , tmpData.TotalAmount        :: TFloat
              , tmpData.TotalSumma         :: TFloat
              , tmpData.AmountPromo        :: TFloat
              , tmpData.SummaPromo         :: TFloat
              , (tmpData.TotalAmount - tmpData.AmountPromo)     :: TFloat AS Amount
              , (tmpData.TotalSumma - tmpData.SummaPromo)       :: TFloat AS SummaSale
              , CASE WHEN tmpData.TotalSumma <> 0 THEN (tmpData.SummaPromo * 100 / tmpData.TotalSumma) ELSE 0 END :: TFloat AS PercentPromo
          FROM tmpData
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId 
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 09.01.17         * на проводках
 12.12.16         *
*/

-- тест
--SELECT * FROM gpReport_Check_Promo (inMakerId:= 2336604  , inStartDate:= '08.11.2016', inEndDate:= '08.11.2016', inSession:= '2')
--SELECT * FROM gpReport_Check_Promo (inMakerId:= 2336604  , inStartDate:= '08.05.2016', inEndDate:= '08.05.2016', inSession:= '2')
--select * from gpReport_Check_Promo( inStartDate := ('02.12.2016')::TDateTime , inEndDate := ('03.12.2016')::TDateTime ,  inSession := '3');