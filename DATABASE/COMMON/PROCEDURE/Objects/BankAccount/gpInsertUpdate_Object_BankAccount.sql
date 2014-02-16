-- Function: gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccount(
 INOUT ioId	                 Integer,       -- ключ объекта < Счет>
    IN inCode                Integer,       -- Код объекта <Счет>
    IN inName                TVarChar,      -- Название объекта <Счет>
    IN inJuridicalId         Integer,       -- Юр. лицо
    IN inBankId              Integer,       -- Банк
    IN inCurrencyId          Integer,       -- Валюта
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_BankAccount());
   UserId := inSession;
  
   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_BankAccount();
   ELSE
       Code_max := inCode;
   END IF;  
   
   -- проверка прав уникальности для свойства <Наименование Счета>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_BankAccount(), inName);
   -- проверка прав уникальности для свойства <Код Счета>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_BankAccount(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_BankAccount(), Code_max, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), ioId, inJuridicalId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), ioId, inBankId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Currency(), ioId, inCurrencyId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_BankAccount (Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar) OWNER TO postgres;  


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.13          *
 05.06.13          

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_BankAccount(1,1,'',1,1,1,'2')