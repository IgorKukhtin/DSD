-- Function: gpInsertUpdate_Object_Bank()

-- DROP FUNCTION gpInsertUpdate_Object_Bank();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Bank(
INOUT ioId	         Integer   ,   	/* ключ объекта < Банк> */
IN inCode                Integer   ,    /* Код объекта <Банк> */
IN inName                TVarChar  ,    /* Название объекта <Банк> */
IN inMFO                 TVarChar  ,    /* МФО */
IN inJuridicalId         Integer   ,    /* Юр. лицо */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Bank());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Bank(), inName);
   PERFORM lpCheckUnique_Object_String_ValueData(ioId, zc_Object_Bank_MFO(), inMFO);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Bank(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Bank_MFO(), ioId, inMFO);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Bank_Juridical(), ioId, inJuridicalId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            