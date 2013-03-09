-- Function: gpInsertUpdate_Object_Cash()

-- DROP FUNCTION gpInsertUpdate_Object_Cash();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Cash(
INOUT ioId	 Integer   ,   	/* ключ объекта <Касса> */
IN inCashName    TVarChar  ,    /* Название объекта <Касса> */
IN inSession     TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Cash());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Cash(), inCashName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Cash(), 0, inCashName);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            