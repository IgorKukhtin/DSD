-- Function: lpGetUnit_byUser(Integer)

-- DROP FUNCTION IF EXISTS lpGetUnitBySession (TVarChar);
-- DROP FUNCTION IF EXISTS lpGetUnitByUser (Integer);
DROP FUNCTION IF EXISTS lpGetUnit_byUser (Integer);

CREATE OR REPLACE FUNCTION lpGetUnit_byUser (
    IN inUserId Integer
)
RETURNS Integer
AS
$BODY$  
BEGIN
     -- Получили для Пользователя - к какому Подразделению он привязан
     RETURN  COALESCE ((SELECT ObjectLink_User_Unit.ChildObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_User_Unit
                        WHERE ObjectLink_User_Unit.DescId   = zc_ObjectLink_User_Unit()
                          AND ObjectLink_User_Unit.ObjectId = inUserId)
                       , 0);
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 19.02.18         *
*/

-- тест
-- SELECT * FROM lpGetUnit_byUser (inUserId:= zfCalc_UserAdmin() :: Integer)
