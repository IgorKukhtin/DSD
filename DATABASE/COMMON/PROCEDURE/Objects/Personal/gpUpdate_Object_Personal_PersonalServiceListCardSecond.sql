-- Function: gpUpdate_Object_Personal_PersonalServiceListCardSecond ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_PersonalServiceListCardSecond (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Personal_PersonalServiceListCardSecond (
    IN inId                        Integer   , -- ключ объекта <Сотрудники>
    IN inPersonalServiceListId     Integer   , -- Новая Ведомость начисл.(карта ф2)
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Personal_CardSecond());

   --проверка
   IF COALESCE (inPersonalServiceListId,0) = 0 
   THEN
        RAISE EXCEPTION 'Ошибка.Значение Новая Ведомость начисл.(карта ф2) не выбрано.';
   END IF;

   -- сохранили связь с <Ведомость начисления(карта ф2)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListCardSecond(), inId, inPersonalServiceListId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

  IF vbUserId = 9457
  THEN
        RAISE EXCEPTION 'Test.Ok.';
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.04.25         *
*/

-- тест
--