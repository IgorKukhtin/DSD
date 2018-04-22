-- Function: gpGet_UnitByUser() - Для форм Документов и Отчетов - сразу подставляем Магазин Пользователя

DROP FUNCTION IF EXISTS gpGet_UserUnit (TVarChar);
DROP FUNCTION IF EXISTS gpGet_UnitByUser (TVarChar);
DROP FUNCTION IF EXISTS gpGet_UnitByUser (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_UnitByUser(
    IN inUnitId        Integer,    -- сохр. подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE(UnitId Integer, UnitName TVarChar
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


     -- Нашли у Пользователя
     vbUnitId:= COALESCE ((SELECT ObjectLink_User_Unit.ChildObjectId AS UnitId
                           FROM ObjectLink AS ObjectLink_User_Unit
                           WHERE ObjectLink_User_Unit.DescId   = zc_ObjectLink_User_Unit()
                             AND ObjectLink_User_Unit.ObjectId = vbUserId
                          ), 0);

     -- переопределяем если подразделение не выбрано на вх. парам.
     IF vbUnitId = 0 AND COALESCE (inUnitId, 0) <> 0 THEN
        vbUnitId:= inUnitId;
     END IF;

     RETURN QUERY
     SELECT Object.Id           AS UnitId
          , Object.ValueData    AS UnitName
          , CURRENT_DATE ::TDatetime AS StartDate
          , CURRENT_DATE ::TDatetime AS EndDate
     FROM Object
     WHERE Object.Id = vbUnitId AND vbUnitId <> 0
    UNION ALL
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
 19.04.18         * add inUnitId
 10.04.18         *
 14.03.18         * rename gpGet_UserUnit  - - gpGet_UnitByUser
 19.02.18         *

*/

-- тест
-- SELECT * FROM gpGet_UnitByUser (inUnitId :=0, inSession:= zfCalc_UserAdmin())
