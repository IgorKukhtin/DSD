-- Function: gpInsertUpdate_Object_Juridical()

-- DROP FUNCTION gpInsertUpdate_Object_Juridical();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
INOUT ioId	 Integer   ,   	/* ключ объекта <Юридическое лицо> */
IN inName        TVarChar  ,    /* Название объекта <Юридическое лицо> */
IN inOKPO        TVarChar  ,    /*  */
IN inINN         TVarChar  ,    /*  */
IN inPhone       TVarChar  ,    /*  */
IN inAddress     TVarChar  ,    /*  */
IN inGLNCode     TVarChar  ,    /*  */
IN inFullName    TVarChar  ,    /*  */
IN inSession     TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Juridical(), inName);
   PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_ObjectString_Juridical_OKPO(), inOKPO);
   PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_ObjectString_Juridical_INN(), inINN);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Juridical(), 0, inName);
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_OKPO(), ioId, inOKPO);
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_INN(), ioId, inINN);
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_Phone(), ioId, inPhone);
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_Address(), ioId, inAddress);
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_GLNCode(), ioId, inGLNCode);
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_FullName(), ioId, inFullName);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Juridical(Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, tvarchar)
  OWNER TO postgres;

  
                            