-- Function: gpInsertUpdate_Object_BankAccount()

-- DROP FUNCTION gpInsertUpdate_Object_BankAccount();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccount(
INOUT ioId	         Integer   ,   	/* ключ объекта < Счет> */
IN inCode                Integer   ,    /* Код объекта <Счет> */
IN inName                TVarChar  ,    /* Название объекта <Счет> */
IN inJuridicalId         Integer   ,    /* Юр. лицо */
IN inBankId              Integer   ,    /* Банк */
IN inCurrencyId          Integer   ,    /* Валюта */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_BankAccount());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_BankAccount(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_BankAccount(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), ioId, inJuridicalId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), ioId, inBankId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Currency(), ioId, inCurrencyId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            