DROP FUNCTION IF EXISTS gpSelect_Report_SoldDay (TDateTime, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Report_SoldDay (TDateTime, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Report_SoldDay (TDateTime, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_SoldDay(
    IN inMonth            TDateTime , -- Месяц плана
    IN inUnitId           Integer   , -- Подразделение
    IN inQuasiSchedule    Boolean   , -- Квазираграфик
    IN inisNoStaticCodes  Boolean   , -- Без статических кодов
    IN inisSP             Boolean   , -- Без учета реимбурсации
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (

    PlanDate            TDateTime,  --Месяц плана
    UnitJuridical       TVarChar,   --Юрлицо
    UnitName            TVarChar,   --подразделение
    ProvinceCityName    TVarChar,   -- район
    PlanAmount          TFloat,     --План
    PlanAmountAccum     TFloat,     --План с накоплением
    FactAmount          TFloat,     --Факт
    FactAmountAccum     TFloat,     --Факт с накоплением
    FactAmountSale      TFloat,     --Факт безнал
    FactAmountSaleAccum TFloat,     --Факт безнал с накоплением
    DiffAmount          TFloat,     --Разница (Факт - План)
    DiffAmountAccum     TFloat,     --Разница в накоплении (Факт с накоплением - План с накоплением)
    PercentMake         TFloat,     --% выполнение плана
    PercentMakeAccum    TFloat      --% выпонения по накоплению
)

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbTmpDate TDateTime;
   DECLARE vbDayInMonth TFloat;
BEGIN
    vbStartDate := date_trunc('month', inMonth);
    vbEndDate := date_trunc('month', inMonth) + Interval '1 MONTH';
    vbDayInMonth := (DATE_PART('day', vbEndDate - vbStartDate))::TFloat;

    -- Контролшь использования подразделения
    inUnitId := gpGet_CheckingUser_Unit(inUnitId, inSession);

    CREATE TEMP TABLE _TIME(
        PlanDate          TDateTime,  --Месяц плана
        DayOfWeek         Integer,    --День в неделе
        CountDay          NUMERIC(20,10)    --кол-во дней(понедельников / вторников) в месяце
        ) ON COMMIT DROP;
    CREATE TEMP TABLE _PartDay(
        PlanDate          TDateTime,  --Месяц плана
        DayOfWeek         Integer,    --День в неделе
        UnitId            Integer,
        Part              NUMERIC(20,10)
        ) ON COMMIT DROP;

    CREATE TEMP TABLE _TMP(
        PlanDate              TDateTime,  --Месяц плана
        DayOfWeek             Integer,    --День в неделе
        UnitId                Integer,    --ИД подразделения
        UnitName              TVarChar,   --подразделение
        PlanMonthAmount       NUMERIC(20,10),     --План в Месяц
        PlanAmount            NUMERIC(20,10),     --План в день
        PlanAmountAccum       NUMERIC(20,10),     --План с накоплением
        FactAmount            NUMERIC(20,10),     --Факт в день
        FactAmountAccum       NUMERIC(20,10),     --Факт с накоплением
        FactAmountSale        NUMERIC(20,10),     --Факт в день
        FactAmountSaleAccum   NUMERIC(20,10),     --Факт с накоплением
        DiffAmount            NUMERIC(20,10),     --Разница (Факт - План)
        DiffAmountAccum       NUMERIC(20,10),     --Разница в накоплении (Факт с накоплением - План с накоплением)
        PercentMake           NUMERIC(20,10),     --% выполнение плана
        PercentMakeAccum      NUMERIC(20,10)      --% выпонения по накоплению
    ) ON COMMIT DROP;

    --Заполняем днями пусографку
    vbTmpDate := vbStartDate;
    WHILE vbTmpDate < vbEndDate
    LOOP
        INSERT INTO _TIME(PlanDate,DayOfWeek)
        VALUES(vbTmpDate, date_part('dow', vbTmpDate));
        vbTmpDate := vbTmpDate + INTERVAL '1 DAY';
    END LOOP;

    UPDATE _TIME SET
        CountDay = (SELECT COUNT(*) FROM _TIME AS T1 WHERE T1.DayOfWeek = _TIME.DayOfWeek);

    INSERT INTO _TMP(PlanDate,DayOfWeek,UnitId,PlanMonthAmount)
    SELECT
        Object_ReportSoldParams.PlanDate::TDateTime       AS PlanDate,
        date_part('dow',Object_ReportSoldParams.PlanDate) AS DayOfWeek,
        Object_ReportSoldParams.UnitId                    AS UnitId,
        Object_ReportSoldParams.PlanAmount                AS PlanAmount
    FROM
        Object_ReportSoldParams_View AS Object_ReportSoldParams
    WHERE
        Object_ReportSoldParams.PlanDate >= vbStartDate
        AND
        Object_ReportSoldParams.PlanDate < vbEndDate
        AND
        (
            Object_ReportSoldParams.UnitId = inUnitId
            or
            inUnitId = 0
        );

    WITH tmpData AS (SELECT
                            date_trunc('day', MovementCheck.OperDate)::TDateTime  AS PlanDate,
                            date_part('dow',MovementCheck.OperDate)               AS DayOfWeek,
                            MovementCheck.UnitId                                  AS UnitID,
                            MovementCheck.TotalSumm                               AS FactAmount,
                            0.0::TFloat                                           AS FactAmountSale
                     FROM Movement_Check_View AS MovementCheck
                          LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                                    ON MovementBoolean_CorrectMarketing.MovementId = MovementCheck.Id
                                                   AND MovementBoolean_CorrectMarketing.DescId in (zc_MovementBoolean_CorrectMarketing(), zc_MovementBoolean_CorrectIlliquidMarketing())
                                                   AND MovementBoolean_CorrectMarketing.ValueData = True
                     WHERE MovementCheck.OperDate >= vbStartDate
                       AND MovementCheck.OperDate < vbEndDate
                       AND MovementCheck.StatusId = zc_Enum_Status_Complete()
                       AND (MovementCheck.UnitId = inUnitId or inUnitId = 0)
                       AND COALESCE(MovementBoolean_CorrectMarketing.ValueData, False) = False
                       AND MovementCheck.Id NOT IN (22653173, 22653613, 22653819)
                     UNION ALL
                     SELECT
                            date_trunc('day', MovementSale.OperDate)::TDateTime  AS PlanDate,
                            date_part('dow',MovementSale.OperDate)               AS DayOfWeek,
                            MovementSale.UnitId                                  AS UnitID,
                            MovementSale.TotalSumm                               AS FactAmount,
                            MovementSale.TotalSumm                               AS FactAmountSale
                     FROM Movement_Sale_View AS MovementSale
                     WHERE MovementSale.OperDate >= vbStartDate
                       AND MovementSale.OperDate < vbEndDate
                       AND MovementSale.StatusId = zc_Enum_Status_Complete()
                       AND (MovementSale.UnitId = inUnitId or inUnitId = 0)
                     )
    
    INSERT INTO _TMP(PlanDate,DayOfWeek,UnitId,FactAmount,FactAmountSale)
    SELECT
        Movement.PlanDate                                     AS PlanDate,
        Movement.DayOfWeek                                    AS DayOfWeek,
        Movement.UnitId                                       AS UnitID,
        COALESCE(SUM(Movement.FactAmount), 0)                 AS FactAmount,
        COALESCE(SUM(Movement.FactAmountSale), 0)             AS FactAmountSale
    FROM tmpData AS Movement
    GROUP BY Movement.PlanDate,
             Movement.DayOfWeek,
             Movement.UnitId;
                          
    IF COALESCE (inisSP, FALSE) = TRUE
    THEN
                      
       UPDATE _TMP SET FactAmount = _TMP.FactAmount + COALESCE (SP.Summa, 0)
                     , FactAmountSale = _TMP.FactAmountSale + COALESCE (SP.SummaSale, 0)
       FROM (WITH tmpData AS (SELECT
                                    date_trunc('day', MovementCheck.OperDate)::TDateTime  AS PlanDate,
                                    MovementCheck.UnitId                                  AS UnitID,
                                    MovementCheck.TotalSummChangePercent                  AS Summa,
                                    0.0::TFloat                                           AS SummaSale
                             FROM Movement_Check_View AS MovementCheck
                                  LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                                            ON MovementBoolean_CorrectMarketing.MovementId = MovementCheck.Id
                                                           AND MovementBoolean_CorrectMarketing.DescId in (zc_MovementBoolean_CorrectMarketing(), zc_MovementBoolean_CorrectIlliquidMarketing())
                                                           AND MovementBoolean_CorrectMarketing.ValueData = True
                             WHERE MovementCheck.OperDate >= vbStartDate
                               AND MovementCheck.OperDate < vbEndDate
                               AND MovementCheck.StatusId = zc_Enum_Status_Complete()
                               AND (MovementCheck.UnitId = inUnitId or inUnitId = 0)
                               AND COALESCE( MovementCheck.SPKindId, 0) <> 0
                               AND COALESCE(MovementBoolean_CorrectMarketing.ValueData, False) = False
                               AND MovementCheck.Id NOT IN (22653173, 22653613, 22653819)
                             UNION ALL
                             SELECT
                                    date_trunc('day', MovementSale.OperDate)::TDateTime  AS PlanDate,
                                    MovementSale.UnitId                                  AS UnitID,
                                    MovementSale.TotalSummSale - MovementSale.TotalSumm  AS Summa,
                                    MovementSale.TotalSummSale - MovementSale.TotalSumm  AS SummaSale
                             FROM Movement_Sale_View AS MovementSale
                             WHERE MovementSale.OperDate >= vbStartDate
                               AND MovementSale.OperDate < vbEndDate
                               AND MovementSale.StatusId = zc_Enum_Status_Complete()
                               AND (MovementSale.UnitId = inUnitId or inUnitId = 0)
                               AND COALESCE( MovementSale.SPKindId, 0) <> 0
                             )

          SELECT Movement.PlanDate           AS PlanDate,
                 Movement.UnitId             AS UnitID,
                 SUM(Movement.Summa)         AS Summa,
                 SUM(Movement.SummaSale)     AS SummaSale
          FROM tmpData AS Movement
          GROUP BY Movement.PlanDate,
                   Movement.UnitId) AS SP
       WHERE _TMP.PlanDate = SP.PlanDate AND _TMP.UnitId = SP.UnitId;
    END IF;
        

    -- Убераем статические коды
    IF inisNoStaticCodes = TRUE
    THEN

       UPDATE _TMP SET FactAmount = _TMP.FactAmount - COALESCE (StaticCodes.Summa, 0)
                     , FactAmountSale = _TMP.FactAmountSale - COALESCE (StaticCodes.SummaSale, 0)
       FROM (SELECT date_trunc('day', MovementItemContainer.OperDate)                             AS PlanDate
                   , Container.WhereObjectId                                                      AS UnitId
                   , SUM(ROUND(-1 * MovementItemContainer.Amount * MIFloat_Price.ValueData, 2))   AS Summa
                   , SUM(CASE WHEN MovementItemContainer.MovementDescId = zc_Movement_Sale() 
                              THEN ROUND(-1 * MovementItemContainer.Amount * MIFloat_Price.ValueData, 2) ELSE 0 END)   AS SummaSale
              FROM MovementItemContainer

                    INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID

                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                               
                    LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = Container.ObjectId

               WHERE MovementItemContainer.OperDate >= vbStartDate
                 AND MovementItemContainer.OperDate <= vbEndDate
                 AND MovementItemContainer.MovementDescId in (zc_Movement_Check(), zc_Movement_Sale())
                 AND MovementItemContainer.DescId = zc_MIContainer_Count()
                 AND (Container.WhereObjectId = inUnitId
                      or
                      inUnitId = 0)
                 AND Container.ObjectId IN (SELECT Object_Goods_Retail.ID
                                            FROM Object_Goods_Retail
                                            WHERE COALESCE (Object_Goods_Retail.SummaWages, 0) <> 0
                                               OR COALESCE (Object_Goods_Retail.PercentWages, 0) <> 0)
               GROUP BY date_trunc('day', MovementItemContainer.OperDate)
                      , Container.WhereObjectId) AS StaticCodes
       WHERE _TMP.PlanDate = StaticCodes.PlanDate AND _TMP.UnitId = StaticCodes.UnitId;

    END IF;


    --Если квазиграфик - определяем доли дней в неделе за последние 2 месяца
    IF inQuasiSchedule = True THEN
        INSERT INTO _PartDay(PlanDate,DayOfWeek,UnitId,Part)
        SELECT
            _TIME.PlanDate,
            _TIME.DayOfWeek,
            UNIT.UnitId,
            COALESCE(COALESCE(SOLD.FactAmount,0) / SOLD.FactAmountUnit / _TIME.CountDay,0) AS PartDayOfWeek
        FROM
            _TIME
            CROSS JOIN (SELECT DISTINCT _TMP.UnitId FROM _Tmp) AS UNIT
            LEFT OUTER JOIN(SELECT
                                T0.DayOfWeek,
                                T0.UnitID,
                                T0.FactAmount,
                                SUM(T0.FactAmount)OVER(PARTITION BY T0.UnitId) AS FactAmountUnit
                            FROM(SELECT T1.DayOfWeek,
                                        T1.UnitID,
                                        SUM(T1.FactAmount)                         AS FactAmount
                                 FROM (
                                      SELECT
                                          date_part('dow', MovementCheck.OperDate) AS DayOfWeek,
                                          MovementCheck.UnitId                     AS UnitID,
                                          SUM(MovementCheck.TotalSumm)             AS FactAmount
                                      FROM
                                          Movement_Check_View AS MovementCheck
                                          LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                                                    ON MovementBoolean_CorrectMarketing.MovementId = MovementCheck.Id
                                                                   AND MovementBoolean_CorrectMarketing.DescId in (zc_MovementBoolean_CorrectMarketing(), zc_MovementBoolean_CorrectIlliquidMarketing())
                                                                   AND MovementBoolean_CorrectMarketing.ValueData = True
                                      WHERE
                                          MovementCheck.OperDate >= (vbStartDate-INTERVAL '56 DAY')
                                          AND
                                          MovementCheck.OperDate < vbStartDate
                                          AND
                                          MovementCheck.StatusId = zc_Enum_Status_Complete()
                                          AND 
                                          COALESCE(MovementBoolean_CorrectMarketing.ValueData, False) = False
                                          AND 
                                          MovementCheck.Id NOT IN (22653173, 22653613, 22653819)
                                          AND
                                          (
                                              MovementCheck.UnitId = inUnitId
                                              or
                                              inUnitId = 0
                                          )
                                      GROUP BY
                                          date_part('dow', MovementCheck.OperDate),
                                          MovementCheck.UnitID
                                      UNION ALL
                                      SELECT
                                          date_part('dow', MovementSale.OperDate) AS DayOfWeek,
                                          MovementSale.UnitId                     AS UnitID,
                                          SUM(MovementSale.TotalSumm)             AS FactAmount
                                      FROM
                                          Movement_Sale_View AS MovementSale
                                      WHERE
                                          MovementSale.OperDate >= (vbStartDate-INTERVAL '56 DAY')
                                          AND
                                          MovementSale.OperDate < vbStartDate
                                          AND
                                          MovementSale.StatusId = zc_Enum_Status_Complete()
                                          AND
                                          (
                                              MovementSale.UnitId = inUnitId
                                              or
                                              inUnitId = 0
                                          )
                                      GROUP BY
                                          date_part('dow', MovementSale.OperDate),
                                          MovementSale.UnitID
                                      UNION ALL
                                      SELECT date_part('dow', MovementItemContainer.OperDate)                             AS PlanDate
                                           , Container.WhereObjectId                                                      AS UnitId
                                           , SUM(ROUND(-1 * MovementItemContainer.Amount * MIFloat_Price.ValueData, 2))   AS Summa
                                      FROM MovementItemContainer

                                           INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID

                                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                       ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                       
                                           LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = Container.ObjectId

                                       WHERE MovementItemContainer.OperDate >= (vbStartDate-INTERVAL '56 DAY')
                                         AND MovementItemContainer.OperDate < vbStartDate
                                         AND MovementItemContainer.MovementDescId in (zc_Movement_Check(), zc_Movement_Sale())
                                         AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                         AND (Container.WhereObjectId = inUnitId
                                              or
                                              inUnitId = 0)
                                         AND Container.ObjectId IN (SELECT Object_Goods_Retail.ID
                                                                     FROM Object_Goods_Retail
                                                                     WHERE COALESCE (Object_Goods_Retail.SummaWages, 0) <> 0
                                                                        OR COALESCE (Object_Goods_Retail.PercentWages, 0) <> 0)
                                         AND inisNoStaticCodes = TRUE
                                       GROUP BY date_part('dow', MovementItemContainer.OperDate)
                                              , Container.WhereObjectId) AS T1
                                 GROUP BY T1.DayOfWeek, T1.UnitID
                                ) AS T0
                            ) AS SOLD
                              ON _TIME.DayOfWeek = SOLD.DayOfWeek
                             AND UNIT.UnitId = SOLD.UnitId;


    ELSE --Делим арифметически
        INSERT INTO _PartDay(PlanDate,DayOfWeek,UnitId,Part)
        SELECT
            _TIME.PlanDate,
            _TIME.DayOfWeek,
            T.UnitId,
            100.0/vbDayInMonth/100.0 AS PartDayOfWeek
        FROM
            _TIME
            CROSS JOIN (SELECT DISTINCT
                                _TMP.UnitId
                            FROM
                                _Tmp
                        ) AS T;
    END IF;

    INSERT INTO _TMP(PlanDate,DayOfWeek,UnitId,PlanAmount)
    SELECT
        _TIME.PlanDate,
        _TIME.DayOfWeek,
        TMP.UnitId,
        TMP.PlanMonthAmount * COALESCE(_PartDay.Part,100.0/vbDayInMonth/100.0)
    FROM
        (SELECT * FROM _TMP WHERE _TMP.PlanMonthAmount is not null) AS TMP
        CROSS JOIN _TIME
        LEFT OUTER JOIN _PartDay ON TMP.UnitId = _PartDay.UnitId
                                AND _TIME.PlanDate = _PartDay.PlanDate;


    RETURN QUERY
        SELECT
            T0.PlanDate::TDateTime                                              AS PlanAmount
           ,Object_Juridical.ValueData::TVarChar                                AS UnitJuridical
           ,Object_Unit.ValueData::TVarChar                                     AS UnitName
           ,Object_ProvinceCity.ValueData                                       AS ProvinceCityName

           ,T0.PlanAmount::TFloat                                               AS PlanAmount
           ,(SUM(T0.PlanAmount)OVER(PARTITION BY T0.UnitId
                                    ORDER BY T0.PlanDate))::TFloat              AS PlanAmountAccum
           ,T0.FactAmount::TFloat                                               AS FactAmount
           ,(SUM(T0.FactAmount)OVER(PARTITION BY T0.UnitId
                                    ORDER BY T0.PlanDate))::TFloat              AS FactAmountAccum
           ,T0.FactAmountSale::TFloat                                           AS FactAmountSale
           ,(SUM(T0.FactAmountSale)OVER(PARTITION BY T0.UnitId
                                    ORDER BY T0.PlanDate))::TFloat              AS FactAmountSaleAccum
           ,T0.DiffAmount::TFloat                                               AS DiffAmount
           ,(SUM(T0.DiffAmount)OVER(PARTITION BY T0.UnitId
                                    ORDER BY T0.PlanDate))::TFloat              AS DiffAmountAccum
           ,CASE
                WHEN COALESCE(T0.PlanAmount,0)<>0
                    THEN 100.0*COALESCE(T0.FactAmount,0)/T0.PlanAmount
            END::TFloat                                                         AS PercentMake
           ,CASE
                WHEN COALESCE((SUM(T0.PlanAmount)OVER(PARTITION BY T0.UnitId
                                                      ORDER BY T0.PlanDate)),0)<>0
                    THEN 100.0
                        *(SUM(T0.DiffAmount)OVER(PARTITION BY T0.UnitId
                                                 ORDER BY T0.PlanDate))
                         /(SUM(T0.PlanAmount)OVER(PARTITION BY T0.UnitId
                                                  ORDER BY T0.PlanDate))
            END::TFloat                                                         AS PercentMakeAccum

        FROM(
            SELECT
                _PartDay.PlanDate
               ,_PartDay.UnitId
               ,COALESCE(SUM(_TMP.PlanAmount),0)    AS PlanAmount
               ,COALESCE(SUM(_TMP.FactAmount),0)     AS FactAmount
               ,COALESCE(SUM(_TMP.FactAmountSale),0) AS FactAmountSale
               ,COALESCE(SUM(_TMP.FactAmount),0)-COALESCE(SUM(_TMP.PlanAmount),0) AS DiffAmount
            FROM
                _PartDay
                LEFT OUTER JOIN _TMP ON _PartDay.PlanDate = _TMP.PlanDate
                                    AND _PartDay.UnitId = _TMP.UnitId
            GROUP BY
                _PartDay.PlanDate
               ,_PartDay.UnitId
           ) AS T0
           INNER JOIN Object AS Object_Unit ON T0.UnitId = Object_Unit.Id
           LEFT OUTER JOIN ObjectLink AS ObjectLinkJuridical
                                 ON Object_Unit.id = ObjectLinkJuridical.objectid
                                AND ObjectLinkJuridical.descid = zc_ObjectLink_Unit_Juridical()
           LEFT OUTER JOIN Object AS Object_Juridical ON Object_Juridical.id = ObjectLinkJuridical.childobjectid

           LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
           LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId
       ORDER BY
           Object_Unit.ValueData
          ,T0.PlanDate;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION gpSelect_Report_SoldDay (TDateTime, Integer, Boolean, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А. Шаблий О.В.
 24.02.21                                                                                     *
 30.05.19         *
 21.06.15                                                                                     *
 31.03.15                                                                                     *
 28.09.15                                                                        *
*/

select * from gpSelect_Report_SoldDay(inMonth := ('01.05.2021')::TDateTime , inUnitId := 377613 , inQuasiSchedule := 'False' , inisNoStaticCodes := 'True' , inisSP := 'True' ,  inSession := '3');