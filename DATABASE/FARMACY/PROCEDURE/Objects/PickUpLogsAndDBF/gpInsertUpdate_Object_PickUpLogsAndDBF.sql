-- Function: gpInsertUpdate_Object_PickUpLogsAndDBF()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PickUpLogsAndDBF (Integer, TVarchar, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PickUpLogsAndDBF(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inGUID                    TVarChar  ,    -- Тип расчета заработной платы
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectMinAmount());
   vbUserId := lpGetUserBySession (inSession); 

   
   IF COALESCE(inGUID, '') = ''
   THEN
     RAISE EXCEPTION 'Не определен <GUID>';
   END IF;

   IF NOT EXISTS(SELECT 1
                 FROM EmployeeWorkLog
                 WHERE EmployeeWorkLog.DateLogIn >= CURRENT_DATE - INTERVAL '5 DAY'
                   AND EmployeeWorkLog.CashSessionId = inGUID)
   THEN
     RAISE EXCEPTION 'GUID не найден.';
   END IF;
   
   IF EXISTS(SELECT Object_PickUpLogsAndDBF.Id
             FROM Object AS Object_PickUpLogsAndDBF
             WHERE Object_PickUpLogsAndDBF.DescId = zc_Object_PickUpLogsAndDBF()
               AND Object_PickUpLogsAndDBF.ValueData = inGUID)
   THEN
     SELECT Object_PickUpLogsAndDBF.Id
     INTO ioId
     FROM Object AS Object_PickUpLogsAndDBF
     WHERE Object_PickUpLogsAndDBF.DescId = zc_Object_PickUpLogsAndDBF()
       AND Object_PickUpLogsAndDBF.ValueData = inGUID;
       
     IF EXISTS(SELECT Object_PickUpLogsAndDBF.Id
               FROM Object AS Object_PickUpLogsAndDBF
               WHERE Object_PickUpLogsAndDBF.Id = ioId
                 AND Object_PickUpLogsAndDBF.isErased = True)
     THEN
       UPDATE Object AS Object_PickUpLogsAndDBF SET isErased = False
       WHERE Object_PickUpLogsAndDBF.Id = ioId
         AND Object_PickUpLogsAndDBF.isErased = True;       
     END IF;
   END IF;

   -- пытаемся найти код
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_PickUpLogsAndDBF());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PickUpLogsAndDBF(), inGUID);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PickUpLogsAndDBF(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PickUpLogsAndDBF(), vbCode_calc, inGUID);

   -- сохранили связь с <Тип расчета заработной платы>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_PickUpLogsAndDBF_Loaded(), ioId, False);

   -- сохранили свойство <Дата начала действия>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_PickUpLogsAndDBF_DateLoaded(), ioId, Null);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.01.22                                                       *
*/

-- тест
-- select * from gpInsertUpdate_Object_PickUpLogsAndDBF(ioId := 0, inGUID := '{CAE90CED-6DB6-45C0-A98E-84BC0E5D9F26}' ,  inSession := '3');