DROP FUNCTION IF EXISTS gpSelect_PeriodClose (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PeriodClose(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, UserId Integer, UserName TVarChar, RoleId Integer, RoleName TVarChar, 
                           UnitId Integer, UnitName TVarChar, CloseDate TDateTime, Period Integer)
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  RETURN QUERY 
  SELECT 
    PeriodClose.Id        AS Id,
    PeriodClose.UserId    AS UserId,
    Object_User.ValueData AS UserName,
    Object_Role.Id        AS RoleId,
    Object_Role.ValueData AS RoleName,
    Object_Unit.Id        AS UnitId,
    Object_Unit.ValueData AS UnitName,
    PeriodClose.CloseDate,
    EXTRACT(DAY FROM PeriodClose.Period)::Integer AS Period  FROM PeriodClose
  LEFT JOIN Object AS Object_Role ON Object_Role.Id = PeriodClose.RoleId
  LEFT JOIN Object AS Object_User ON Object_User.Id = PeriodClose.UserId
  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = PeriodClose.UnitId;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_PeriodClose (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.13                        *  
*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inSession:= '2'); 
                                                                
