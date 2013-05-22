-- Function: gpInsertUpdate_Object_Account()

-- DROP FUNCTION gpInsertUpdate_Object_Account();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Account(
INOUT ioId	         Integer   ,   	/* ключ объекта <Счет> */
IN inCode                Integer   ,    /* Код объекта <Счет> */
IN inName                TVarChar  ,    /* Название объекта <Счет> */
IN inAccountGroupId      Integer   ,    /* Группа счетов */
IN inAccountDirectionId  Integer   ,    /* Аналитика счета (место) */
IN inDestinationId       Integer   ,    /* Аналитика счета (назначение) */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Account(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_AccountGroup(), ioId, inAccountGroupId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_AccountDirection(), ioId, inAccountDirectionId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Account_Destination(), ioId, inDestinationId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            