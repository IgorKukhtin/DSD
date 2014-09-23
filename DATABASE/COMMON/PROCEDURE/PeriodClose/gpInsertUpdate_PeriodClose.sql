-- Function: gpInsertUpdate_PeriodClose (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_PeriodClose (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_PeriodClose(
 INOUT ioId	        Integer   ,     -- ключ объекта связи 
    IN inUserId         Integer   ,     -- Пользователь
    IN inRoleId         Integer   ,     -- Роль
    IN inUnitId         Integer   ,     -- Подразделение
    IN inPeriod         Integer   ,     -- Дни
    IN inCloseDate      TDateTime ,     -- Закрытый период
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInterval Interval;
   DECLARE vbAccessKeyId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);

   -- для Админа  - Все Права
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
   THEN vbAccessKeyId:= 0;
   ELSE vbAccessKeyId:= (SELECT AccessKeyId_PeriodClose FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PeriodClose <> 0 AND UserId = vbUserId GROUP BY AccessKeyId_PeriodClose);
   END IF;

   IF vbAccessKeyId <> 0 AND COALESCE (ioId, 0) <> 3
   THEN
       RAISE EXCEPTION 'Ошибка.Нет Прав.';
   END IF;


   inCloseDate:= DATE_TRUNC ('DAY', inCloseDate);

   IF inUserId = 0 THEN
      inUserId := NULL;
   END IF;

   vbInterval := (to_char(inPeriod, '999')||' day')::interval;
   IF inRoleId = 0 THEN
      inRoleId := NULL;
   END IF;
   IF inUnitId = 0 THEN
      inUnitId := NULL;
   END IF;

   IF COALESCE (ioId, 0) = 0 THEN
      -- добавили новый элемент справочника и вернули значение <Ключ объекта>
      INSERT INTO PeriodClose (UserId, RoleId, UnitId, Period, CloseDate)
                  VALUES (inUserId, inRoleId, inUnitId, vbInterval, inCloseDate) RETURNING Id INTO ioId;
   ELSE
       -- изменили элемент справочника по значению <Ключ объекта>
       UPDATE PeriodClose SET UserId = inUserId, RoleId = inRoleId, UnitId = inUnitId, Period = vbInterval, CloseDate = inCloseDate
              WHERE Id = ioId;
       -- если такой элемент не был найден
       IF NOT FOUND THEN
          -- добавили новый элемент справочника со значением <Ключ объекта>
          INSERT INTO PeriodClose (Id, UserId, RoleId, UnitId, Period, CloseDate)
               VALUES (ioId, inUserId, inRoleId, inUnitId, vbInterval, inCloseDate) RETURNING Id INTO ioId;
       END IF; -- if NOT FOUND

   END IF; -- if COALESCE (ioId, 0) = 0
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_PeriodClose (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.14                                        *
 23.09.13                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_UserRole()
