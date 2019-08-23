-- Function: gpSelect_CalculationPerson_Print()

DROP FUNCTION IF EXISTS gpSelect_CalculationPerson_Print (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CalculationPerson_Print(
    IN inOperDate      TDateTime,
    IN inPersonID      Integer  ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
        SELECT 'Расчет з.п. за '||to_char(DATE_TRUNC ('DAY', CURRENT_TIMESTAMP), 'DD.MM.YYYY') as Title
        UNION ALL
        SELECT 'По сотруднику: '||(SELECT ValueData FROM Object WHERE ID = inPersonID);

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        SELECT
            Calculation.OperDate                   AS OperDate
          , Calculation.UnitName                   AS UnitName
          , Calculation.ShortName                  AS ShortName
          , Calculation.PayrollGroupName           AS PayrollGroupName
          , Calculation.SummaCalc                  AS SummaCalc
          , Calculation.FormulaCalc                AS FormulaCalc
        FROM gpSelect_Calculation_Wages(inOperDate, inPersonID, inSession) AS Calculation
        ORDER BY Calculation.OperDate;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_CalculationPerson_Print (TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 07.11.18        *
*/

-- SELECT * FROM gpSelect_CalculationPerson_Print (inOperDate := ('01.08.2019')::TDateTime, inPersonID := 5323676,  inSession:= '3');