-- Function: gpSelect_SheetWorkTime_Period()

-- DROP FUNCTION gpSelect_SheetWorkTime_Period (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SheetWorkTime_Period(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, UnitId Integer, UnitName TVarChar
              )
AS
$BODY$
  DECLARE vbStartDate TDateTime;
          vbEndDate TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SheetWorkTime());

     vbStartDate := date_trunc('month', inStartDate);    -- первое число месяца
     vbEndDate := date_trunc('month', inEndDate);        -- последнее число месяца
 
     RETURN QUERY 
       SELECT
             Period.OperDate::TDateTime
           , Object_Unit.Id           AS UnitId
           , Object_Unit.ValueData    AS UnitName
       FROM Object AS Object_Unit,
            (SELECT generate_series(vbStartDate, vbEndDate, '1 MONTH'::interval) OperDate) AS Period  
       WHERE Object_Unit.DescId = zc_Object_Unit();
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_SheetWorkTime_Period (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_SheetWorkTime (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')/