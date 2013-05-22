-- Function: gpInsertUpdate_Object_Account()

-- DROP FUNCTION gpInsertUpdate_Object_Account();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Account(
INOUT ioId	         Integer   ,   	/* ключ объекта <Счет> */
IN inCode                Integer   ,    /* Код объекта <Счет> */
IN inName                TVarChar  ,    /* Название объекта <Счет> */
IN inAccountGroupId      Integer   ,    /* Группа счетов */
IN inAccountPlaceId      Integer   ,    /* Аналитика счета (место) */
IN inAccountReferenceId  Integer   ,    /* Аналитика счета (назначение) */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Account(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_AccountGroup(), ioId, inAccountGroupId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_AccountPlace(), ioId, inAccountPlaceId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_AccountReference(), ioId, inAccountReferenceId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            