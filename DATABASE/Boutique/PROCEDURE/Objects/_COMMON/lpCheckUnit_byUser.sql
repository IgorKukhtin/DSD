-- Function: lpCheckUnit_byUser (Integer, Integer)

DROP FUNCTION IF EXISTS lpCheckUnitByUser (Integer, TVarChar);
DROP FUNCTION IF EXISTS lpCheckUnitByUser (Integer, Integer);
DROP FUNCTION IF EXISTS lpCheckUnit_byUser (Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheckUnit_byUser (
    IN inUnitId_by Integer , -- Подразделение которое надо проверить
    IN inUserId    Integer   -- Пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUnitId Integer;
BEGIN
     -- Получили для Пользователя - к какому Подразделению он привязан
     vbUnitId:= lpGetUnit_byUser (inUserId);


     -- Вернули - Подразделение которое проверили
     IF inUserId = 1234551 AND inUnitId_by IN (1550 -- магазин Chado-Outlet
                                             , 1539 -- магазин CHADO
                                             , 1535 -- магазин Vintage
                                             , 1530 -- магазин Terry-Luxury
                                             , 1534 -- магазин Terry-Vintage
                                              )
     THEN
         RETURN COALESCE (inUnitId_by, 0);

     -- если у пользователя = 0, тогда может смотреть любой магазин, иначе только свой ИЛИ свой Склад
     ELSEIF vbUnitId > 0 AND COALESCE (inUnitId_by, 0) NOT IN (SELECT vbUnitId AS UnitId UNION ALL SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Child() AND OL.ObjectId = vbUnitId)
     THEN
         RAISE EXCEPTION 'Ошибка.У Пользователя <%> - <%> нет доступак к данным подразделения <%>.'
                       , lfGet_Object_ValueData_sh (inUserId)
                       , lfGet_Object_ValueData_sh (vbUnitId)
                       , lfGet_Object_ValueData_sh (inUnitId_by)
                        ;
     END IF;

     -- Вернули - Подразделение которое проверили
     RETURN COALESCE (inUnitId_by, 0);
     
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.03.18         *
*/

-- тест
-- SELECT * FROM lpCheckUnit_byUser (inUnitId_by:= 1525, inUserId:= zfCalc_UserAdmin() :: Integer)
