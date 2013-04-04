-- Function: gpInsertUpdate_Object_Branch()

-- DROP FUNCTION gpInsertUpdate_Object_Branch();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Branch(
INOUT ioId	         Integer   ,   	/* ключ объекта < Филиал> */
IN inCode                Integer   ,    /* Код объекта <Филиал> */
IN inName                TVarChar  ,    /* Название объекта <Филиал> */
IN inJuridicalId         Integer   ,    /* Юр. лицо */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Branch());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Branch(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Branch(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Branch_Juridical(), ioId, inJuridicalId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            