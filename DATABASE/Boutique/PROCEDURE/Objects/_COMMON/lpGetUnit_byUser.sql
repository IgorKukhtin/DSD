-- Function: lpGetUnit_byUser(Integer)

DROP FUNCTION IF EXISTS lpGetUnitBySession (TVarChar);
DROP FUNCTION IF EXISTS lpGetUnitByUser (Integer);
DROP FUNCTION IF EXISTS lpGetUnit_byUser (Integer);

CREATE OR REPLACE FUNCTION lpGetUnit_byUser (
    IN inUserId Integer
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- для Админа  - Все Права
     IF EXISTS (SELECT 1
                FROM ObjectLink AS Object_UserRole_User -- Связь пользователя с объектом роли пользователя
                         JOIN ObjectLink AS Object_UserRole_Role -- Связь ролей с объектом роли пользователя
                                         ON Object_UserRole_Role.DescId        = zc_ObjectLink_UserRole_Role()
                                        AND Object_UserRole_Role.ObjectId      = Object_UserRole_User.ObjectId
                                        AND Object_UserRole_Role.ChildObjectId = zc_Enum_Role_Admin()
                WHERE Object_UserRole_User.DescId        = zc_ObjectLink_UserRole_User()
                  AND Object_UserRole_User.ChildObjectId = inUserId
               )
     THEN
        -- Все Права
        RETURN 0;
     ELSE
        -- Получили для Пользователя - к какому Подразделению он привязан
        RETURN COALESCE ((SELECT ObjectLink_User_Unit.ChildObjectId AS UnitId
                          FROM ObjectLink AS ObjectLink_User_Unit
                          WHERE ObjectLink_User_Unit.DescId   = zc_ObjectLink_User_Unit()
                            AND ObjectLink_User_Unit.ObjectId = inUserId)
                         , 0);
     END IF;

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
