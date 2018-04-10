-- Function: gpGet_UnitbyUser()

DROP FUNCTION IF EXISTS gpGet_UnitbyUser (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_UnitbyUser(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE(UnitId integer, UnitName TVarChar
            , StartDate TDatetime, EndDate TDatetime    -- для отчета = CURRENT_DATE
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     vbUnitId := COALESCE ((SELECT ObjectLink_User_Unit.ChildObjectId AS UnitId
                            FROM ObjectLink AS ObjectLink_User_Unit
                            WHERE ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Unit()
                              AND ObjectLink_User_Unit.ObjectId = vbUserId)
                           , 0) ::Integer;

     RETURN QUERY
     SELECT Object.Id           AS UnitId
          , Object.ValueData    AS UnitName
          , CURRENT_DATE ::TDatetime AS StartDate
          , CURRENT_DATE ::TDatetime AS EndDate
     FROM Object 
     WHERE Object.Id = vbUnitId AND vbUnitId <> 0
   UNION 
     SELECT 0                        AS UnitId
          , ''           ::TVarChar  AS UnitName
          , CURRENT_DATE ::TDatetime AS StartDate
          , CURRENT_DATE ::TDatetime AS EndDate
     WHERE vbUnitId = 0
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.04.18         *
 14.03.18         * rename gpGet_UserUnit  - - gpGet_UnitbyUser
 19.02.18         *

*/

-- тест
-- SELECT * FROM gpGet_UnitbyUser (inSession:= zfCalc_UserAdmin())
select * from gpGet_UnitbyUser( inSession := '6');