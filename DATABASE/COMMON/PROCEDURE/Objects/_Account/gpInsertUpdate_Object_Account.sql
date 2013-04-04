-- Function: gpInsertUpdate_Object_Account()

-- DROP FUNCTION gpInsertUpdate_Object_Account();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Account(
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
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Account(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Account(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_Juridical(), ioId, inJuridicalId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_Bank(), ioId, inBankId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_Currency(), ioId, inCurrencyId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            