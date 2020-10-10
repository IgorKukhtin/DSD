-- Function: gpInsertUpdate_Object_Buyer()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Buyer(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Buyer(
 INOUT ioId             Integer   ,     -- ключ объекта <Покупатель> 
    IN inCode           Integer   ,     -- Код объекта  
    IN inPhone          TVarChar  ,     -- Телефон 
    IN inName           TVarChar  ,     -- Фамилия Имя Отчество
    IN inEmail          TVarChar  ,     -- E-Mail
    IN inAddress        TVarChar  ,     -- Место проживания
    IN inComment        TVarChar  ,     -- Примечание
    IN inDateBirth      TDateTime ,     -- Дата рождения
    IN inSex            TVarChar  ,     -- Пол
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Buyer());
   vbUserId := inSession;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Buyer());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Buyer(), inPhone);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Buyer(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Buyer(), vbCode_calc, inPhone);
   
   -- сохранили Фамилия Имя Отчество
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_Name(), ioId, inName);
   -- сохранили E-Mail
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_EMail(), ioId, inEMail);
   -- сохранили Место проживания
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_Address(), ioId, inAddress);
   -- сохранили Примечание
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_Comment(), ioId, inComment);
   -- сохранили 
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Buyer_DateBirth(), ioId, inDateBirth);
   -- сохранили 
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Buyer_Sex(), ioId, inSex);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.12.19                                                       *
*/

-- тест
