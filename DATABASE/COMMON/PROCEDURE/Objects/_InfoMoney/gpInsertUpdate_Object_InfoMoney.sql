-- Function: gpInsertUpdate_Object_InfoMoney()

-- DROP FUNCTION gpInsertUpdate_Object_InfoMoney();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney(
INOUT ioId	            Integer   ,    /* ключ */
IN inCode                   Integer   , 
IN inName                   TVarChar  ,    /* Группа управленческих аналитик */
IN inInfoMoneyGroupId       Integer   , 
IN inInfoMoneyDestinationId Integer   , 
IN inSession                TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_InfoMoney());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoney(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_InfoMoney(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_InfoMoney_InfoMoneyGroup(), ioId, inInfoMoneyGroupId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_InfoMoney_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            