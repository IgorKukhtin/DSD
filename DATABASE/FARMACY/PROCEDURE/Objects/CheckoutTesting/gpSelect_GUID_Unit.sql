-- Function: gpSelect_GUID_Unit()

DROP FUNCTION IF EXISTS gpSelect_GUID_Unit (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GUID_Unit(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (GUID TVarChar, CashRegister TVarChar,
               UnitId Integer, UnitName TVarChar, 
               UserId Integer, UserName TVarChar, 
               DateLogIn TDateTime,
               isErased Boolean) 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbUserId := lpGetUserBySession (inSession);

    RETURN QUERY
    WITH tmpEmployeeWorkLog AS (
      SELECT ROW_NUMBER() OVER (PARTITION BY EmployeeWorkLog.CashSessionId ORDER BY EmployeeWorkLog.DateLogIn DESC) AS Ord
           , EmployeeWorkLog.CashSessionId      AS CashSessionId
           , EmployeeWorkLog.CashRegister       AS CashRegister
           , EmployeeWorkLog.DateLogIn          AS DateLogIn
           , EmployeeWorkLog.UnitId             AS UnitId 
           , EmployeeWorkLog.UserId             AS UserId 
      FROM EmployeeWorkLog
      WHERE EmployeeWorkLog.DateLogIn >= CURRENT_DATE - INTERVAL '5 DAY')  

    SELECT EmployeeWorkLog.CashSessionId      AS GUID
         , EmployeeWorkLog.CashRegister       AS CashRegister
         , Object_Unit.Id                     AS UnitId
         , Object_Unit.valuedata              AS UnitName
         , Object_User.Id                     AS UserId
         , Object_User.valuedata              AS UserName
         , EmployeeWorkLog.DateLogIn          AS DateLogIn
         , False                              AS isErased 
    FROM tmpEmployeeWorkLog AS EmployeeWorkLog

         LEFT JOIN Object AS Object_Unit ON Object_Unit.id = EmployeeWorkLog.UnitId

         LEFT JOIN Object AS Object_User ON Object_User.id = EmployeeWorkLog.UserId
         
    WHERE EmployeeWorkLog.Ord = 1
    ORDER BY Object_Unit.valuedata, EmployeeWorkLog.CashSessionId ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.06.21                                                       *
*/

-- тест
-- 

select * from gpSelect_GUID_Unit( inSession := '3');