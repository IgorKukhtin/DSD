DROP FUNCTION IF EXISTS lpInsertFind_Bank(TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Bank(
    IN inBankMFO             TVarChar,      -- <MFO>
    IN inBankName            TVarChar,      -- Название банка
    IN inUserId              Integer
)
RETURNS integer AS
$BODY$
   DECLARE vbBankId Integer;
   DECLARE vbBankName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());

   -- Ищем Банк по МФО. Если не находим, то добавляем
   SELECT Object_Bank_View.Id, Object_Bank_View.BankName INTO vbBankId, vbBankName 
          FROM Object_Bank_View 
         WHERE Object_Bank_View.MFO = inBankMFO;
   IF COALESCE(vbBankId, 0) = 0 OR COALESCE(vbBankName, '')

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