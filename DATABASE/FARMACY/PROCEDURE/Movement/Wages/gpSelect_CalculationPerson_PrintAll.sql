-- Function: gpSelect_CalculationPerson_PrintAll()

DROP FUNCTION IF EXISTS gpSelect_CalculationPerson_PrintAll (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CalculationPerson_PrintAll(
    IN inOperDate      TDateTime,
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
        SELECT 'Расчет з.п. за '||zfCalc_MonthYearName(inOperDate)||' г.' as Title;

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        SELECT
            Object_Personal.ValueData              AS PersonalName
          , Object_Position.ValueData              AS PositionName
          , CASE WHEN COALESCE (Calculation.UserId, 0) = 0 THEN 'Не связан' END AS UserId
          , Calculation.OperDate                   AS OperDate
          , Calculation.UnitName                   AS UnitName
          , Calculation.ShortName                  AS ShortName
          , Calculation.PayrollTypeName            AS PayrollTypeName
          , Calculation.SummaCalc                  AS SummaCalc
          , Calculation.FormulaCalc                AS FormulaCalc
        FROM gpSelect_Calculation_Wages(inOperDate, 0, inSession) AS Calculation

             INNER JOIN Object AS Object_Personal ON Object_Personal.Id = Calculation.PersonalId
      
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                  ON ObjectLink_Personal_Position.ObjectId = Calculation.PersonalId
                                 AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                 
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId
             
        ORDER BY Object_Personal.ValueData, Calculation.OperDate;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_CalculationPerson_PrintAll (TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.08.19                                                        *
*/

-- SELECT * FROM gpSelect_CalculationPerson_PrintAll (inOperDate := ('01.08.2019')::TDateTime, inSession:= '3');