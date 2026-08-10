 -- Function: gpUpdate_Object_Partner_Commerc()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Commerc (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Commerc(
    IN inId                      Integer   ,    -- ключ объекта <Контрагент> 
    IN inRouteTTId               Integer   ,    -- Маршрут ТТ
    IN inUnitCommercId           Integer   ,    -- Отдео комменции
    IN inPersonalGroupCommercId  Integer   ,    -- Группа Сотрудников
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());


   -- сохранили связь с <Маршруты ТТ>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteTT(), inId, inRouteTTId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_UnitCommerc(), inId, CASE WHEN COALESCE (inRouteTTId,0) <> 0 THEN NULL ELSE inUnitCommercId END);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalGroupCommerc(), inId, CASE WHEN COALESCE (inRouteTTId,0) <> 0 THEN NULL ELSE inPersonalGroupCommercId END);

 
   -- !!! ВРЕМЕННО !!!
   IF vbUserId = 5 AND 1=1
   THEN
       RAISE EXCEPTION 'Admin - Test = OK';
   END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.08.26         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_Commerc()
