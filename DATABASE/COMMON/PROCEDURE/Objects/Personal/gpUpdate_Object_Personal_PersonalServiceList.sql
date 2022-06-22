-- Function: gpUpdate_Object_Personal_PersonalServiceList ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_PersonalServiceList (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Personal_PersonalServiceList(
    IN inId                        Integer   , -- ключ объекта <Сотрудники>
    IN inPersonalServiceListId     Integer   , -- Новая Ведомость начисл.(главная)
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Personal_PersonalServiceList());

   --проверка
   IF COALESCE (inPersonalServiceListId,0) = 0 
   THEN
        RAISE EXCEPTION 'Ошибка.Значение Новая Ведомость начисл.(главная) не выбрано.';
   END IF;

   -- сохранили связь с <Ведомость начисления(главная)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceList(), ioId, inPersonalServiceListId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.22         *
*/

-- тест
--