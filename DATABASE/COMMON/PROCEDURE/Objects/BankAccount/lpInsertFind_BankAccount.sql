-- Function: gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertFind_BankAccount(TVarChar, TVarChar, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_BankAccount(
    IN inBankAccount         TVarChar,      -- <Счет>
    IN inBankMFO             TVarChar,      -- <MFO>
    IN inBankName            TVarChar,      -- Название банка
    IN inJuridicalId         Integer,        -- Юр. лицо
    IN inUserId              Integer
)
RETURNS integer AS
$BODY$
   DECLARE vbBankId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());

   -- Ищем Банк по МФО. Если не находим, то добавляем

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_BankAccount(), Code_max, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), ioId, inJuridicalId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), ioId, inBankId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Currency(), ioId, inCurrencyId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_BankAccount(TVarChar, TVarChar, TVarChar, Integer, Integer) OWNER TO postgres;  

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.06.14          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_BankAccount(1,1,'',1,1,1,'2')