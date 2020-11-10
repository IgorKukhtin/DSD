-- Function: gpInsertUpdate_Object_Bank ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Bank(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Bank(
 INOUT ioId	             Integer,       -- ключ объекта < Банк>
    IN inCode                Integer,       -- Код объекта <Банк>
    IN inName                TVarChar,      -- Название объекта <Банк>
    IN inIBAN                TVarChar,      -- IBAN
    IN inComment             TVarChar,      -- 
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Bank());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- Если код не установлен, определяем его каи последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_Bank());

   -- проверка прав уникальности для свойства <Наименование Банка>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Bank(), inName);
   -- проверка прав уникальности для свойства <Код Банка>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Bank(), inCode);

   -- проверка прав уникальности для свойства <IBAN>
   IF inIBAN <> ''
   THEN
       PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_ObjectString_Bank_IBAN(), inIBAN);
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Bank(), inCode, inName);

   --
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_IBAN(), ioId, inIBAN);
   --
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_Comment(), ioId, inComment);

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.20         *
*/

-- тест
--                          