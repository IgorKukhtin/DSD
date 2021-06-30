-- Function: gpInsertUpdate_Object_CorrectMinAmount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CheckoutTesting (Integer, TVarchar, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CheckoutTesting(
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
   
   IF EXISTS(SELECT Object_CheckoutTesting.Id
             FROM Object AS Object_CheckoutTesting
             WHERE Object_CheckoutTesting.DescId = zc_Object_CheckoutTesting()
               AND Object_CheckoutTesting.ValueData = inGUID)
   THEN
     SELECT Object_CheckoutTesting.Id
     INTO ioId
     FROM Object AS Object_CheckoutTesting
     WHERE Object_CheckoutTesting.DescId = zc_Object_CheckoutTesting()
       AND Object_CheckoutTesting.ValueData = inGUID;
       
     IF EXISTS(SELECT Object_CheckoutTesting.Id
               FROM Object AS Object_CheckoutTesting
               WHERE Object_CheckoutTesting.Id = ioId
                 AND Object_CheckoutTesting.isErased = True)
     THEN
       UPDATE Object AS Object_CheckoutTesting SET isErased = False
       WHERE Object_CheckoutTesting.Id = ioId
         AND Object_CheckoutTesting.isErased = True;       
     END IF;
   END IF;

   -- пытаемся найти код
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_CheckoutTesting());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CheckoutTesting(), inGUID);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CheckoutTesting(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CheckoutTesting(), vbCode_calc, inGUID);

   -- сохранили связь с <Тип расчета заработной платы>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_CheckoutTesting_Updates(), ioId, False);

   -- сохранили свойство <Дата начала действия>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_CheckoutTesting_DateUpdate(), ioId, Null);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.06.21                                                       *
*/

-- тест
-- 

select * from gpInsertUpdate_Object_CheckoutTesting(ioId := 0, inGUID := '{CAE90CED-6DB6-45C0-A98E-84BC0E5D9F26}' ,  inSession := '3');