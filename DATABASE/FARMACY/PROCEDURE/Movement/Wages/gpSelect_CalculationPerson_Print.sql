-- Function: gpSelect_CalculationPerson_Print()

DROP FUNCTION IF EXISTS gpSelect_CalculationPerson_Print (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CalculationPerson_Print(
    IN inOperDate      TDateTime,
    IN inUserID        Integer  ,
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
        SELECT 'Расчет з.п. за '||zfCalc_MonthYearName(inOperDate)||' г.' as Title
        UNION ALL
        SELECT 'По юр. лицу: '||(SELECT COALESCE(Object_Member.ValueData, Object.ValueData) FROM Object 
                                        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                             ON ObjectLink_User_Member.ObjectId = Object.Id
                                                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                        LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId
                                 WHERE Object.ID = inUserID);

    RETURN NEXT Cursor1;


    IF inOperDate < '01.09.2019'
    THEN
      OPEN Cursor2 FOR
          SELECT
              Calculation.OperDate                   AS OperDate
            , Calculation.UnitName                   AS UnitName
            , Calculation.ShortName                  AS ShortName
            , Calculation.PayrollTypeName            AS PayrollTypeName
            , Calculation.SummaCalc                  AS SummaCalc
            , Calculation.FormulaCalc                AS FormulaCalc
          FROM gpSelect_Calculation_WagesBoard(inOperDate, 0, inSession) AS Calculation
          WHERE Calculation.UserId = inUserID
          ORDER BY Calculation.OperDate;
    ELSEIF inOperDate < '01.01.2023'
    THEN
      OPEN Cursor2 FOR
          SELECT
              Calculation.OperDate                   AS OperDate
            , Calculation.UnitName                   AS UnitName
            , Calculation.ShortName                  AS ShortName
            , Calculation.PayrollTypeName            AS PayrollTypeName
            , Calculation.SummaCalc                  AS SummaCalc
            , Calculation.FormulaCalc                AS FormulaCalc
          FROM gpSelect_Calculation_Wages(inOperDate, inUserID, inSession) AS Calculation
          ORDER BY Calculation.OperDate;
    ELSE
      OPEN Cursor2 FOR
          SELECT
              Calculation.OperDate                   AS OperDate
            , Calculation.UnitName                   AS UnitName
            , Calculation.ShortName                  AS ShortName
            , Calculation.PayrollTypeName            AS PayrollTypeName
            , Calculation.SummaCalc                  AS SummaCalc
            , Calculation.FormulaCalc                AS FormulaCalc
          FROM gpSelect_Calculation_WagesNew(inOperDate, inUserID, inSession) AS Calculation
          ORDER BY Calculation.OperDate;
    
    END IF;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_CalculationPerson_Print (TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.08.19                                                        *
*/

-- 
select * from gpSelect_CalculationPerson_Print(inOperDate := ('01.09.2019')::TDateTime , inUserID := 3999200 ,  inSession := '3');