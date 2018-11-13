-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpReport_Check_Promo (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Check_Promo (TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_Check_Promo(
    IN inStartDate     TDateTime ,
    IN inEndDate       TDateTime ,
    IN inIsFarm           Boolean,    -- 
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
    PercentPromo      TFloat,     --% ПРомо от всех продаж
    PlanAmount        TFloat,     --план по маркетингу грн
    DiffAmount        TFloat      --Разница (Факт промо - План) 
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbTmpDate TDateTime;
   --DECLARE vbisFarm Boolean;
   DECLARE vbUnitId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- !!!меняем параметр!!!
    IF inIsFarm = TRUE THEN vbUnitId:= zfConvert_StringToNumber (COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), ''));
    END IF;

    --inStartDate := date_trunc('month', inStartDate);
    --inEndDate := date_trunc('month', inEndDate) + Interval '1 MONTH';
    inEndDate := inEndDate + interval '1  day';
        
    CREATE TEMP TABLE _tmpDate(PlanDate TDateTime) ON COMMIT DROP;
    --Заполняем днями пусографку
    vbTmpDate := inStartDate;
    WHILE vbTmpDate < inEndDate
    LOOP
        INSERT INTO _tmpDate(PlanDate)
        VALUES(Date_trunc('month', vbTmpDate)::TDateTime);
        vbTmpDate := vbTmpDate + INTERVAL '1 DAY';
    END LOOP;

/*
    -- если долность Фармацевт, показываем только его подразделение
    SELECT CASE WHEN ObjectLink_Personal_Position.ChildObjectId = 1672498 THEN TRUE ELSE FALSE END AS isFarm
         , ObjectLink_Personal_Unit.ChildObjectId AS UnitId
  INTO vbisFarm, vbUnitId
    FROM ObjectLink AS ObjectLink_User_Member
        LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                             ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                            AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
        LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                             ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId 
                            AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
        LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                             ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId 
                            AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
    WHERE ObjectLink_User_Member.ObjectId = vbUserId --3354092
      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member();
*/

    CREATE TEMP TABLE _tmpUnit(UnitId Integer) ON COMMIT DROP;
    IF inisFarm = TRUE THEN
       INSERT INTO _tmpUnit(UnitId)
             SELECT vbUnitId AS UnitId;
    ELSE 
       INSERT INTO _tmpUnit(UnitId)
             SELECT Object.Id AS UnitId
             FROM Object
             WHERE Object.DescId = zc_Object_Unit();
    END IF;
      
    
    RETURN QUERY
      WITH
    -- выбираем все данные из проводок  ( цена, док маркетинга)
     tmpData AS (SELECT Date_trunc('month', MIContainer.OperDate)::TDateTime AS OperDate
                      , COALESCE (MIContainer.WhereObjectId_analyzer,0) AS UnitId
                      , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS TotalAmount
                      , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS TotalSumma
                      
                      /*, SUM (CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer,0) = 0 THEN 0 ELSE COALESCE (-1 * MIContainer.Amount, 0) END) AS AmountPromo
                        , SUM (CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer,0) = 0 THEN 0 ELSE COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) END) AS SummaPromo
                      */ 
                      , SUM (CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer,0) <> 0 AND COALESCE (MIBoolean_Checked.ValueData, FALSE) = TRUE 
                                    THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END)                                  AS AmountPromo
                      , SUM (CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer,0) <> 0 AND COALESCE (MIBoolean_Checked.ValueData, FALSE) = TRUE 
                                    THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS SummaPromo
                 FROM MovementItemContainer AS MIContainer
                      INNER JOIN _tmpUnit ON _tmpUnit.UnitId = COALESCE (MIContainer.WhereObjectId_analyzer,0)
                      -- Выбираем товары с отметкой для маркетинга
                      LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                    ON MIBoolean_Checked.MovementItemId = COALESCE (MIContainer.ObjectIntId_analyzer, 0)
                                                   AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                 WHERE MIContainer.DescId = zc_MIContainer_Count()
                   AND MIContainer.MovementDescId = zc_Movement_Check()
                   AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate
                  -- AND MIContainer.OperDate >= '03.10.2016' AND MIContainer.OperDate < '01.12.2016'
                 GROUP BY date_trunc('month', MIContainer.OperDate)
                        , COALESCE (MIContainer.WhereObjectId_analyzer,0)
                 HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                )
   -- выбираем планы по маркетингу
   , tmpPlanPromo AS (SELECT Object_ReportPromoParams.UnitId     AS UnitId
                           , Object_ReportPromoParams.PlanDate   AS PlanDate
                           , Object_ReportPromoParams.PlanAmount AS PlanAmount
                      FROM (SELECT DISTINCT _tmpDate.PlanDate FROM _tmpDate) AS _tmpDate
                           INNER JOIN Object_ReportPromoParams_View AS Object_ReportPromoParams
                                                                    ON Object_ReportPromoParams.PlanDate = _tmpDate.PlanDate
                      )

         -- результат
         SELECT tmpData.OperDate           AS PlanDate      
              , Object_Unit.ValueData      AS UnitName
              , COALESCE (tmpData.TotalAmount,0)        :: TFloat
              , COALESCE (tmpData.TotalSumma,0)         :: TFloat
              , COALESCE (tmpData.AmountPromo,0)        :: TFloat
              , COALESCE (tmpData.SummaPromo,0)         :: TFloat
              , (COALESCE (tmpData.TotalAmount,0) - COALESCE (tmpData.AmountPromo,0))     :: TFloat AS Amount
              , (COALESCE (tmpData.TotalSumma,0) - COALESCE (tmpData.SummaPromo,0))       :: TFloat AS SummaSale
              , CASE WHEN COALESCE (tmpData.TotalSumma,0) <> 0 THEN (COALESCE (tmpData.SummaPromo,0) * 100 / tmpData.TotalSumma) ELSE 0 END :: TFloat AS PercentPromo
              , COALESCE (tmpPlanPromo.PlanAmount,0)            :: TFloat AS PlanAmount
              , ((CASE WHEN COALESCE (tmpData.TotalSumma,0) <> 0 THEN (COALESCE (tmpData.SummaPromo,0) * 100 / tmpData.TotalSumma) ELSE 0 END) 
                  - COALESCE (tmpPlanPromo.PlanAmount,0) )      :: TFloat AS DiffAmount
          FROM tmpData
               LEFT JOIN tmpPlanPromo ON tmpPlanPromo.UnitId = tmpData.UnitId 
                                     AND tmpPlanPromo.PlanDate = tmpData.OperDate 
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId 
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 05.04.17         * add inIsFarm
 26.01.17         * ограничение для фармацевта
 09.01.17         * на проводках
 12.12.16         *
*/

-- тест
--SELECT * FROM gpReport_Check_Promo (inMakerId:= 2336604  , inStartDate:= '08.11.2016', inEndDate:= '08.11.2016', inSession:= '2')
--SELECT * FROM gpReport_Check_Promo (inMakerId:= 2336604  , inStartDate:= '08.05.2016', inEndDate:= '08.05.2016', inSession:= '2')
--select * from gpReport_Check_Promo( inStartDate := ('02.11.2016')::TDateTime , inEndDate := ('03.11.2016')::TDateTime ,  inSession := '3');