-- Function: gpInsert_Object_Buyer_Cash()

DROP FUNCTION IF EXISTS gpInsert_Object_Buyer_Cash(Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_Buyer_Cash(
 INOUT ioId             Integer   ,     -- ключ объекта <Покупатель> 
    IN inPhone          TVarChar  ,     -- Телефон 
    IN inName           TVarChar  ,     -- Фамилия Имя Отчество
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Buyer());

   -- пытаемся найти код
   IF ioId <> 0 
   THEN
     RAISE EXCEPTION 'Ошибка. Процедура предназначена для ввода нового покупателя!';
   END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (0, zc_Object_Buyer());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Buyer(), inPhone);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Buyer(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Buyer(), vbCode_calc, inPhone);
      
   -- сохранили Фамилия Имя Отчество
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_Name(), ioId, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.01.20                                                       *
*/

-- тест
