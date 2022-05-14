-- Function:  gpReport_Check_QuantityComparison()

DROP FUNCTION IF EXISTS gpReport_Check_QuantityComparison (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_QuantityComparison(
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inRetailId         Integer  ,  -- Сеть
    IN inUnitId           Integer  ,  -- Подразделение
    IN inYearsAgo         Integer  ,  -- Лет назад
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE cur1          refcursor;
   DECLARE cur2          refcursor;
   DECLARE cur3          refcursor;
   DECLARE cur4          refcursor;
   DECLARE cur5          refcursor;
   DECLARE vbOperDate    TDateTime;
   DECLARE vbQueryText   Text;
   DECLARE vbIndex       Integer;
   DECLARE vbYear        Integer;
   DECLARE vbInc         Integer;
   DECLARE curOperDate   refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
      SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inDateStart), DATE_TRUNC ('MONTH', inDateFinal), '1 MONTH' :: INTERVAL) AS OperDate;
      
    CREATE TEMP TABLE tmpDataDay ON COMMIT DROP AS
       (WITH tmpUnit AS (SELECT Objectt_Unit.ID AS UnitId
                         FROM Object AS Objectt_Unit

                              INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                    ON ObjectLink_Unit_Juridical.ObjectId = Objectt_Unit.Id
                                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

                              INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                    ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                   AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)

                         WHERE Objectt_Unit.DescId = zc_Object_Unit()
                           AND (Objectt_Unit.ID = inUnitId OR inUnitId = 0)),
             tmpMovementAll AS (SELECT Movement.ID
                                     , DATE_TRUNC ('DAY', Movement.OperDate) AS OperDate
                                FROM Movement
                                WHERE Movement.OperDate >= DATE_TRUNC ('MONTH', inDateStart) - (inYearsAgo::TVArChar||' YEAR')::INTERVAL - INTERVAL '1 MONTH'
                                  AND Movement.OperDate <  DATE_TRUNC ('MONTH', inDateFinal) + INTERVAL '1 MONTH'
                                  AND Movement.DescId = zc_Movement_Check()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()),
             tmpMovement AS (SELECT Movement.ID
                                  , Movement.OperDate
                                  , MovementLinkObject_Unit.ObjectId        AS UnitId
                             FROM tmpMovementAll AS Movement

                                  INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                  INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId),
             tmpMovementSum AS (SELECT Movement.UnitId
                                     , Movement.OperDate
                                     , Count(*)::Integer                                     AS CountChecks
                                     , SUM(MovementFloat_TotalSumm.ValueData)                AS TotalSumm
                                     , SUM(CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash() THEN 1 ELSE 0 END)::Integer  AS CountCash
                                     , SUM(CASE WHEN MovementLinkObject_PaidType.ObjectId <> zc_Enum_PaidType_Cash() THEN 1 ELSE 0 END)::Integer AS CountCashLess
                                FROM tmpMovement as Movement

                                     LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                             ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                            AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                                                  ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                                                 AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()

                              GROUP BY Movement.UnitId
                                     , Movement.OperDate)


        SELECT Movement.UnitId
             , Movement.OperDate
             , Movement.CountChecks
             , Movement.TotalSumm
             , Movement.CountCash
             , Movement.CountCashLess
        FROM tmpMovementSum as Movement);

    CREATE TEMP TABLE tmpData ON COMMIT DROP AS
    SELECT Movement.UnitId
         , DATE_TRUNC ('MONTH', Movement.OperDate)                          AS OperDate
         , SUM(Movement.CountChecks)                                        AS CountChecks
         , (SUM(Movement.TotalSumm) / SUM(Movement.CountChecks))::TFloat    AS AverageCheck
         , SUM(Movement.CountCash)::Integer                                 AS CountCash
         , SUM(Movement.CountCashLess)::Integer                             AS CountCashLess
    FROM tmpDataDay as Movement
    GROUP BY Movement.UnitId
           , DATE_TRUNC ('MONTH', Movement.OperDate);


    CREATE TEMP TABLE tmpResult (
            UnitId          Integer,
            UnitCode        Integer,
            UnitName        TVarChar,
            Color_calc      Integer,
            Sort            TFloat    NOT NULL DEFAULT 0
    ) ON COMMIT DROP;

    INSERT INTO tmpResult
    (WITH tmpUnit AS (SELECT DISTINCT tmpData.UnitId FROM tmpData WHERE tmpData.OperDate >= DATE_TRUNC ('MONTH', inDateStart))

     SELECT Objectt_Unit.Id
          , Objectt_Unit.ObjectCode
          , Objectt_Unit.ValueData
          , zfCalc_Color(64, 224, 208)
     FROM tmpUnit
          INNER JOIN Object AS Objectt_Unit ON Objectt_Unit.ID = tmpUnit.UnitId

    );

    CREATE TEMP TABLE tmpMultiply (
            Id                                 Integer,
            FieldNameCount                     TVarChar,
            HeaderFieldNameCount               TVarChar,
            BackGroundColumnNameCount          TVarChar,
            FieldNameAverageCheck              TVarChar,
            HeaderFieldNameAverageCheck        TVarChar,
            BackGroundColumnNameAverageCheck   TVarChar,
            FieldNameCountCash                 TVarChar,
            HeaderFieldNameCountCash           TVarChar,
            BackGroundColumnNameCountCash      TVarChar,
            FieldNameCountCashLess             TVarChar,
            HeaderFieldNameCountCashLess       TVarChar,
            BackGroundColumnNameCountCashLess  TVarChar,
            FieldNamePercentChange             TVarChar,
            HeaderFieldNamePercentChange       TVarChar,
            BackGroundColumnNamePercentChange  TVarChar
    ) ON COMMIT DROP;

    CREATE TEMP TABLE tmpChart (
            Id                                Integer,
            DisplayedDataName                 TVarChar,
            SeriesName                        TVarChar,
            FieldName                         TVarChar
    ) ON COMMIT DROP;

    INSERT INTO tmpChart
    VALUES (1, 'Количество чеков', 'Количество чеков '||EXTRACT (YEAR FROM inDateStart)::TVarChar, 'Count');
    INSERT INTO tmpChart
    VALUES (100, 'Срредний чек', 'Срредний чек '||EXTRACT (YEAR FROM inDateStart)::TVarChar, 'AverageCheck');
    INSERT INTO tmpChart
    VALUES (200, 'Чеков нал. расчет', 'Hал. расчет '||EXTRACT (YEAR FROM inDateStart)::TVarChar, 'CountCash');
    INSERT INTO tmpChart
    VALUES (300, 'Чеков безнал. расчет', 'Безнал. расчет '||EXTRACT (YEAR FROM inDateStart)::TVarChar, 'CountCashLess');

    -- Данные для размножения
    vbInc := 1;
    WHILE vbInc <= inYearsAgo LOOP

        vbYear := EXTRACT (YEAR FROM (DATE_TRUNC ('MONTH', inDateStart) - (vbInc::TVArChar||' YEAR')::INTERVAL));

        -- добавляем для размножения
        INSERT INTO tmpMultiply
        SELECT vbInc
             , 'Count'||vbYear::TVarChar
             , CASE WHEN vbInc < inYearsAgo THEN 'ValueName1' ELSE 'ValueNameChecks' END
             , 'Color_calc'||vbYear::TVarChar
             , 'AverageCheck'||vbYear::TVarChar
             , CASE WHEN vbInc < inYearsAgo THEN 'ValueName2' ELSE 'ValueNameAverageCheck' END
             , 'Color_calc'||vbYear::TVarChar
             , 'CountCash'||vbYear::TVarChar
             , CASE WHEN vbInc < inYearsAgo THEN 'ValueName3' ELSE 'ValueNameCash' END
             , 'Color_calc'||vbYear::TVarChar
             , 'CountCashLess'||vbYear::TVarChar
             , CASE WHEN vbInc < inYearsAgo THEN 'ValueName4' ELSE 'ValueNameCashLess' END
             , 'Color_calc'||vbYear::TVarChar
             , 'PercentChange'||vbYear::TVarChar
             , CASE WHEN vbInc < inYearsAgo THEN 'ValueName5' ELSE 'ValueNamePercentChange' END
             , 'Color_calc'||vbYear::TVarChar
          ;

        INSERT INTO tmpChart
        VALUES (1 + vbInc, 'Количество чеков', 'Количество чеков '||EXTRACT (YEAR FROM (inDateStart - (vbInc::TVArChar||' YEAR')::INTERVAL))::TVarChar, 'Count'||vbYear::TVarChar);
        INSERT INTO tmpChart
        VALUES (101 + vbInc, 'Срредний чек', 'Срредний чек '||EXTRACT (YEAR FROM (inDateStart - (vbInc::TVArChar||' YEAR')::INTERVAL))::TVarChar, 'AverageCheck'||vbYear::TVarChar);
        INSERT INTO tmpChart
        VALUES (201 + vbInc, 'Чеков нал. расчет', 'Hал. расчет '||EXTRACT (YEAR FROM (inDateStart - (vbInc::TVArChar||' YEAR')::INTERVAL))::TVarChar, 'CountCash'||vbYear::TVarChar);
        INSERT INTO tmpChart
        VALUES (301 + vbInc, 'Чеков безнал. расчет', 'Безнал. расчет '||EXTRACT (YEAR FROM (inDateStart - (vbInc::TVArChar||' YEAR')::INTERVAL))::TVarChar, 'CountCashLess'||vbYear::TVarChar);

        -- теперь следуюющий год
        vbInc := vbInc + 1;
    END LOOP;


    -- Заполняем данными
    vbIndex := 1;
    OPEN curOperDate FOR
      SELECT tmpOperDate.OperDate::TDateTime
      FROM tmpOperDate
      ORDER BY tmpOperDate.OperDate;


     -- начало цикла по курсору1
     LOOP
        -- данные по курсору1
        FETCH curOperDate INTO vbOperDate;
        -- если данные закончились, тогда выход
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Count' || COALESCE (vbIndex, 0)::Text || ' Integer NOT NULL DEFAULT 0 ' ||
                       ' , ADD COLUMN AverageCheck' || COALESCE (vbIndex, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
                       ' , ADD COLUMN CountCash' || COALESCE (vbIndex, 0)::Text || ' Integer NOT NULL DEFAULT 0 ' ||
                       ' , ADD COLUMN CountCashLess' || COALESCE (vbIndex, 0)::Text || ' Integer NOT NULL DEFAULT 0 ' ||
                       ' , ADD COLUMN PercentChange' || COALESCE (vbIndex, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE tmpResult SET Count' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountChecks, 0) ' ||
                                          ', AverageCheck' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.AverageCheck, 0) ' ||
                                          ', CountCash' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountCash, 0) ' ||
                                          ', CountCashLess' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountCashLess, 0) ' ||
                       ' FROM (SELECT tmpData.* FROM tmpData WHERE tmpData.OperDate = '''|| zfConvert_DateShortToString(vbOperDate) ||''') AS T1'||
                       ' WHERE tmpResult.UnitId = T1.UnitId';
        EXECUTE vbQueryText;

--        IF vbOperDate > DATE_TRUNC ('MONTH', inDateStart)
--        THEN
          IF vbOperDate = DATE_TRUNC ('MONTH', inDateFinal)
          THEN
            vbQueryText := 'UPDATE tmpResult SET PercentChange' || COALESCE (vbIndex, 0)::Text ||
                           ' = CASE WHEN COALESCE (Count' || COALESCE (vbIndex, 0)::Text ||', 0) > 0 THEN 1.0 * (Count' || COALESCE (vbIndex, 0)::Text ||
                           ' - COALESCE (T1.CountChecks, 0)) * 100.0 / Count' || COALESCE (vbIndex, 0)::Text || ' ELSE 0 END, ' ||
                           ' Sort = CASE WHEN COALESCE (Count' || COALESCE (vbIndex, 0)::Text ||', 0) > 0 THEN 1.0 * (Count' || COALESCE (vbIndex, 0)::Text ||
                           ' - COALESCE (T1.CountChecks, 0)) * 100.0 / Count' || COALESCE (vbIndex, 0)::Text || ' ELSE 0 END ' ||
                           ' FROM (SELECT tmpData.* FROM tmpData WHERE tmpData.OperDate = '''|| zfConvert_DateShortToString(vbOperDate - INTERVAL '1 MONTH') ||''') AS T1'||
                           ' WHERE tmpResult.UnitId = T1.UnitId';

          ELSE
            vbQueryText := 'UPDATE tmpResult SET PercentChange' || COALESCE (vbIndex, 0)::Text ||
                           ' = CASE WHEN COALESCE (Count' || COALESCE (vbIndex, 0)::Text ||', 0) > 0 THEN 1.0 * (Count' || COALESCE (vbIndex, 0)::Text ||
                           ' - COALESCE (T1.CountChecks, 0)) * 100.0 / Count' || COALESCE (vbIndex, 0)::Text || ' ELSE 0 END ' ||
                           ' FROM (SELECT tmpData.* FROM tmpData WHERE tmpData.OperDate = '''|| zfConvert_DateShortToString(vbOperDate - INTERVAL '1 MONTH') ||''') AS T1'||
                           ' WHERE tmpResult.UnitId = T1.UnitId';
          END IF;
          EXECUTE vbQueryText;
--        END IF;

        -- Данные для размножения
        vbInc := 1;
        WHILE vbInc <= inYearsAgo LOOP

            vbYear := EXTRACT (YEAR FROM (DATE_TRUNC ('MONTH', inDateStart) - (vbInc::TVArChar||' YEAR')::INTERVAL));

            IF vbIndex = 1
            THEN
              vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Color_calc'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text || ' Integer';
              EXECUTE vbQueryText;

              vbQueryText := 'UPDATE tmpResult SET Color_calc'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text || ' = '|| zfCalc_Color(64, 224, 208, 100 * vbInc / (inYearsAgo + 1))::Text;
              EXECUTE vbQueryText;
            END IF;

            vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Count'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text || ' Integer NOT NULL DEFAULT 0 ' ||
                           ' , ADD COLUMN AverageCheck'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
                           ' , ADD COLUMN CountCash'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text || ' Integer NOT NULL DEFAULT 0 ' ||
                           ' , ADD COLUMN CountCashLess'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text || ' Integer NOT NULL DEFAULT 0 ' ||
                           ' , ADD COLUMN PercentChange'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ';
            EXECUTE vbQueryText;

            vbQueryText := 'UPDATE tmpResult SET Count'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountChecks, 0) ' ||
                                              ', AverageCheck'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.AverageCheck, 0) ' ||
                                              ', CountCash'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountCash, 0) ' ||
                                              ', CountCashLess'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountCashLess, 0) ' ||
                           ' FROM (SELECT tmpData.* FROM tmpData WHERE tmpData.OperDate = '''|| zfConvert_DateShortToString(vbOperDate - (vbInc::TVArChar||' YEAR')::INTERVAL ) ||''') AS T1'||
                           ' WHERE tmpResult.UnitId = T1.UnitId';
            EXECUTE vbQueryText;

--            IF vbOperDate > DATE_TRUNC ('MONTH', inDateStart)
--            THEN
              vbQueryText := 'UPDATE tmpResult SET PercentChange'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text ||
                             ' = CASE WHEN Count'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text ||' > 0 THEN 1.0 * (Count'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text ||
                             ' - COALESCE (T1.CountChecks, 0)) * 100.0 / Count'||vbYear::TVarChar || COALESCE (vbIndex, 0)::Text ||' ELSE 0 END ' ||
                             ' FROM (SELECT tmpData.* FROM tmpData WHERE tmpData.OperDate = '''|| zfConvert_DateShortToString(vbOperDate  - INTERVAL '1 MONTH' - (vbInc::TVArChar||' YEAR')::INTERVAL ) ||''') AS T1'||
                             ' WHERE tmpResult.UnitId = T1.UnitId';
              EXECUTE vbQueryText;
--            END IF;

            -- теперь следуюющий год
            vbInc := vbInc + 1;
        END LOOP;

        vbIndex := vbIndex + 1;
    END LOOP; -- финиш цикла по курсору1
    CLOSE curOperDate; -- закрыли курсор1

    -- Результаты

    -- возвращаем заголовки столбцов и даты
    OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime          AS OperDate
                       , zfcalc_MonthName(tmpOperDate.OperDate) || ' ' ||
                         EXTRACT (YEAR FROM (tmpOperDate.OperDate - (inYearsAgo::TVArChar||' YEAR')::INTERVAL))::TVarChar || ' ... ' ||
                         EXTRACT (YEAR FROM tmpOperDate.OperDate)::TVarChar                                               AS ValueBandName
                       , 'Чеков'     AS ValueNameChecks
                       , 'Ср. чек'   AS ValueNameAverageCheck
                       , 'Нал'       AS ValueNameCash
                       , 'Безнал'    AS ValueNameCashLess
                       , '% измен.'  AS ValueNamePercentChange
                       , CASE WHEN inYearsAgo <= 0 THEN 'Чеков'    ELSE '1' END      AS ValueName1
                       , CASE WHEN inYearsAgo <= 0 THEN 'Ср. чек'  ELSE '2' END      AS ValueName2
                       , CASE WHEN inYearsAgo <= 0 THEN 'Нал'      ELSE '3' END      AS ValueName3
                       , CASE WHEN inYearsAgo <= 0 THEN 'Безнал'   ELSE '4' END      AS ValueName4
                       , CASE WHEN inYearsAgo <= 0 THEN '% измен.' ELSE '5' END      AS ValueName5
                       , zfConvert_IntToString((row_number()OVER(ORDER BY tmpOperDate.OperDate))::Integer, 2) ||'. ' ||zfcalc_MonthName(tmpOperDate.OperDate) AS ValueChartName
                  FROM tmpOperDate
                  ORDER BY tmpOperDate.OperDate;
    RETURN NEXT cur1;

    -- Размножение колонок
    OPEN cur2 FOR SELECT *
                  FROM tmpMultiply
                  ORDER BY tmpMultiply.Id;
    RETURN NEXT cur2;


    -- Строки для графика
    OPEN cur3 FOR SELECT *
                  FROM tmpChart
                  ORDER BY tmpChart.Id;
    RETURN NEXT cur3;

    -- Результат
    OPEN cur4 FOR SELECT *
                  FROM tmpResult
                  ORDER BY Sort, tmpResult.UnitName;
    RETURN NEXT cur4;

    -- Строки для графика под дням
    OPEN cur5 FOR SELECT tmpDataDay.UnitId
                       , tmpDataDay.OperDate
                       , tmpDataDay.CountChecks
                       , tmpDataDayPrew.CountChecks  AS CountChecksPrew
                  FROM tmpDataDay
                       LEFT JOIN tmpDataDay AS tmpDataDayPrew  
                                            ON tmpDataDayPrew.UnitId = tmpDataDay.UnitId
                                           AND tmpDataDayPrew.OperDate = tmpDataDay.OperDate - (inYearsAgo::TVArChar||' YEAR')::INTERVAL
                  WHERE tmpDataDay.OperDate >= DATE_TRUNC ('MONTH', inDateStart) 
                    AND tmpDataDay.OperDate <  DATE_TRUNC ('MONTH', inDateFinal) + INTERVAL '1 MONTH'
                  ORDER BY tmpDataDay.UnitId, tmpDataDay.OperDate;
    RETURN NEXT cur5;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.01.20                                                       *
*/

-- тест
--
 
select * from gpReport_Check_QuantityComparison(inDateStart := ('01.03.2022')::TDateTime , inDateFinal := ('13.05.2022')::TDateTime , inRetailId := 4 , inUnitId := 377605 , inYearsAgo := 1 ,  inSession := '3');

