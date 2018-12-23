-- Function: gpInsertUpdate_Object_RecalcMCSSheduler()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RecalcMCSSheduler(Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RecalcMCSSheduler(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Причина разногласия>
 INOUT ioCode                    Integer   ,    -- Код объекта <Причина разногласия>
    IN inUnitId                  Integer, 
    IN inWeekId                  Integer, 
    IN inUserId                  Integer, 
    IN inIsClose                 Boolean,
    IN inSession                 TVarChar       -- Сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReasonDifferences());
   vbUserId:= inSession;
   
   IF COALESCE(inUnitId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка. Не заполнено подразделение..';   
   END IF;
   
   IF COALESCE(inWeekId, 0) < 1 OR COALESCE(inWeekId, 0) > 7
   THEN
     RAISE EXCEPTION 'Ошибка. Не выбран день недели..';   
   END IF;

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_RecalcMCSSheduler());
   vbName := 'Планировщик перещета НТЗ '||ioCode::TVarChar;

   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_RecalcMCSSheduler(), vbName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_RecalcMCSSheduler(), ioCode);

   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_RecalcMCSSheduler(), ioCode, vbName, NULL);

   -- сохранили связь с <Наше юр. лицо>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RecalcMCSSheduler_Unit(), ioId, inUnitId);

   --сохранили 
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RecalcMCSSheduler_Week(), ioId, inWeekId);

   -- сохранили связь с <Сотрудником>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RecalcMCSSheduler_User(), ioId, inUserId);

   -- изменили
   UPDATE Object SET isErased = inIsClose WHERE Id = ioId;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RecalcMCSSheduler(Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.12.18                                                       *

*/
