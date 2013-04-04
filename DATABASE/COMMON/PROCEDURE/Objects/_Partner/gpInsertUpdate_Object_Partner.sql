-- Function: gpInsertUpdate_Object_Partner()

-- DROP FUNCTION gpInsertUpdate_Object_Partner();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
INOUT ioId	         Integer   ,   	/* ключ объекта <Контрагент> */
IN inCode                Integer   ,
IN inName                TVarChar  ,    /* Название объекта <Контрагент> */
IN inGLNCode             TVarChar  ,    /*  */
IN inJuridicalId         Integer   ,    /* Юридическое лицо */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Partner(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Partner(), inCode, inName);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_GLNCode(), ioId, inGLNCode);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Juridical(), ioId, inJuridicalId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Partner(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar)
  OWNER TO postgres;

  
                            