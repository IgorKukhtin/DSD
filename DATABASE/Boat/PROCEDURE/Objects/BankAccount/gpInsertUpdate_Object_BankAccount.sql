-- Function: gpInsertUpdate_Object_BankAccount (Integer, Integer, TVarChar, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccount (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccount(
 INOUT ioId                       Integer   ,    -- Ключ объекта <> 
 INOUT ioCode                     Integer   ,    -- Код объекта <> 
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inBankId                   Integer   ,    -- ключ объекта <Банк> 
    IN inCurrencyId               Integer   ,    -- ключ объекта <Валюта> 
    IN inComment                  TVarChar  ,    -- 
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_BankAccount_seq'); 
   END IF; 
   
   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_BankAccount(), inName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BankAccount(), ioCode, inName);

   -- сохранили связь с <Банк>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccount_Bank(), ioId, inBankId);
   -- сохранили связь с <Валюта>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccount_Currency(), ioId, inCurrencyId);

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


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.21         *
*/

-- тест
--