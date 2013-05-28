-- Function: gpInsertUpdate_Object_InfoMoneyGroup()

-- DROP FUNCTION gpInsertUpdate_Object_InfoMoneyGroup(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoneyGroup(
INOUT ioId	         Integer   ,   	/* ключ */
IN inCode                Integer   , 
IN inName                TVarChar  ,    /* Группа управленческих аналитик */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_InfoMoneyGroup());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoneyGroup(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_InfoMoneyGroup(), inCode, inName);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            