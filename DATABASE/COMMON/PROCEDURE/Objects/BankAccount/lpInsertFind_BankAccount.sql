-- Function: gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertFind_BankAccount(TVarChar, TVarChar, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_BankAccount(
    IN inBankAccount         TVarChar,      -- <Р/счет>
    IN inBankMFO             TVarChar,      -- <MFO>
    IN inBankName            TVarChar,      -- Название банка
    IN inJuridicalId         Integer,       -- Юр. лицо (чей это Р/счет)
    IN inUserId              Integer
)
RETURNS integer AS
$BODY$
   DECLARE vbBankId Integer;
   DECLARE vbBankAccountId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());


   IF COALESCE (inBankName, '') = '' AND 1=0
   THEN
       RAISE EXCEPTION 'Ошибка.Банк пусто для MFO = <%> '
                     , inBankMFO
                      ;

   END IF;

   -- Ищем Банк по МФО. Если не находим, то добавляем
   vbBankId := lpInsertFind_Bank (COALESCE (inBankMFO, ''), COALESCE (inBankName, ''), inUserId);


   SELECT Id INTO vbBankAccountId
     FROM Object_BankAccount_View
    WHERE BankId = vbBankId AND JuridicalId = inJuridicalId AND Name = inBankAccount;


   IF COALESCE (inBankAccount, '') = ''
   THEN
       RAISE EXCEPTION 'Ошибка.Р.сч. пусто для <%> <%> <%> <%>'
                     , inBankMFO
                     , inBankName
                     , lfGet_Object_ValueData_sh (inJuridicalId)
                     , inJuridicalId
                      ;

   END IF;

   IF COALESCE(vbBankAccountId, 0) = 0
   THEN
     -- RAISE EXCEPTION 'Ошибка.Расчетный счет <%> у юридического лица <%> не найден.', inBankAccount, lfGet_Object_ValueData (inJuridicalId);

     -- сохранили <Объект>
     vbBankAccountId := lpInsertUpdate_Object(vbBankAccountId, zc_Object_BankAccount(), 0, inBankAccount);

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), vbBankAccountId, inJuridicalId);
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), vbBankAccountId, vbBankId);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbBankAccountId, inUserId);

   END IF;

   RETURN vbBankAccountId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_BankAccount(TVarChar, TVarChar, TVarChar, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.06.14                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_BankAccount(1,1,'',1,1,1,'2')