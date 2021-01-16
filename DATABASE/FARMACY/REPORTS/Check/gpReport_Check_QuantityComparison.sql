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
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE vbOperDate TDateTime;
   DECLARE vbQueryText Text;
   DECLARE vbIndex Integer;
   DECLARE curOperDate refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
      SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inDateStart), DATE_TRUNC ('MONTH', inDateFinal), '1 MONTH' :: INTERVAL) AS OperDate;


    CREATE TEMP TABLE tmpData ON COMMIT DROP AS
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
                                     , DATE_TRUNC ('MONTH', Movement.OperDate) AS OperDate
                                FROM Movement
                                WHERE (Movement.OperDate >= DATE_TRUNC ('MONTH', inDateStart)
                                  AND Movement.OperDate <  DATE_TRUNC ('MONTH', inDateFinal) + INTERVAL '1 MONTH'
                                   OR Movement.OperDate >= DATE_TRUNC ('MONTH', inDateStart) - (inYearsAgo::TVArChar||' YEAR')::INTERVAL
                                  AND Movement.OperDate <  DATE_TRUNC ('MONTH', inDateFinal) - (inYearsAgo::TVArChar||' YEAR')::INTERVAL  + INTERVAL '1 MONTH')
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
                                     , Count(*)::Integer                                 AS CountChecks
                                     , SUM(MovementFloat_TotalSumm.ValueData) / Count(*) AS AverageCheck
                                     , SUM(CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash() THEN 1 ELSE 0 END)  AS CountCash
                                     , SUM(CASE WHEN MovementLinkObject_PaidType.ObjectId <> zc_Enum_PaidType_Cash() THEN 1 ELSE 0 END) AS CountCashLess
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
             , Movement.AverageCheck
             , Movement.CountCash
             , Movement.CountCashLess
        FROM tmpMovementSum as Movement);

    CREATE TEMP TABLE tmpResult (
            UnitId    Integer,
            UnitCode  Integer,
            UnitName  TVarChar
    ) ON COMMIT DROP;

    INSERT INTO tmpResult
    (WITH tmpUnit AS (SELECT DISTINCT tmpData.UnitId FROM tmpData WHERE tmpData.OperDate >= DATE_TRUNC ('MONTH', inDateStart))

     SELECT Objectt_Unit.Id
          , Objectt_Unit.ObjectCode
          , Objectt_Unit.ValueData
     FROM tmpUnit
          INNER JOIN Object AS Objectt_Unit ON Objectt_Unit.ID = tmpUnit.UnitId

    );


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
                       ' , ADD COLUMN CountPrev' || COALESCE (vbIndex, 0)::Text || ' Integer NOT NULL DEFAULT 0 ' ||
                       ' , ADD COLUMN AverageCheckPrev' || COALESCE (vbIndex, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
                       ' , ADD COLUMN CountCashPrev' || COALESCE (vbIndex, 0)::Text || ' Integer NOT NULL DEFAULT 0 ' ||
                       ' , ADD COLUMN CountCashLessPrev' || COALESCE (vbIndex, 0)::Text || ' Integer NOT NULL DEFAULT 0 ';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE tmpResult SET Count' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountChecks, 0) ' ||
                                          ', AverageCheck' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.AverageCheck, 0) ' ||
                                          ', CountCash' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountCash, 0) ' ||
                                          ', CountCashLess' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountCashLess, 0) ' ||
                       ' FROM (SELECT tmpData.* FROM tmpData WHERE tmpData.OperDate = '''|| zfConvert_DateShortToString(vbOperDate) ||''') AS T1'||
                       ' WHERE tmpResult.UnitId = T1.UnitId';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE tmpResult SET CountPrev' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountChecks, 0) ' ||
                                          ', AverageCheckPrev' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.AverageCheck, 0) ' ||
                                          ', CountCashPrev' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountCash, 0) ' ||
                                          ', CountCashLessPrev' || COALESCE (vbIndex, 0)::Text || ' = COALESCE (T1.CountCashLess, 0) ' ||
                       ' FROM (SELECT tmpData.* FROM tmpData WHERE tmpData.OperDate = '''|| zfConvert_DateShortToString(vbOperDate - (inYearsAgo::TVArChar||' YEAR')::INTERVAL ) ||''') AS T1'||
                       ' WHERE tmpResult.UnitId = T1.UnitId';
        EXECUTE vbQueryText;

        vbIndex := vbIndex + 1;
    END LOOP; -- финиш цикла по курсору1
    CLOSE curOperDate; -- закрыли курсор1

    -- Результаты

    -- возвращаем заголовки столбцов и даты
    OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime          AS OperDate
                       , zfcalc_MonthName(tmpOperDate.OperDate)   AS ValueMonthName
                       , EXTRACT (YEAR FROM tmpOperDate.OperDate)::TVarChar AS ValueYearName
                       , EXTRACT (YEAR FROM (tmpOperDate.OperDate - (inYearsAgo::TVArChar||' YEAR')::INTERVAL))::TVarChar AS ValueYearNamePrev
                       , 'Чеков'   AS ValueNameChecks
                       , 'Ср. чек' AS ValueNameAverageCheck
                       , 'Нал'     AS ValueNameCash
                       , 'Безнал'  AS ValueNameCashLess
                       , ' '       AS ValueNameNull
                  FROM tmpOperDate
                  ORDER BY tmpOperDate.OperDate;
    RETURN NEXT cur1;

    -- Результат
    OPEN cur2 FOR SELECT *
                  FROM tmpResult
                  ORDER BY tmpResult.UnitName;
    RETURN NEXT cur2;

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
--
select * from gpReport_Check_QuantityComparison(inDateStart := ('01.12.2020')::TDateTime , inDateFinal := ('29.12.2020')::TDateTime , inRetailId := 4 , inYearsAgo := 1 , inUnitId := 183292 ,  inSession := '3');