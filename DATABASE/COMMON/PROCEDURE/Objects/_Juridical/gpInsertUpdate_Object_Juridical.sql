-- Function: gpInsertUpdate_Object_Juridical()

-- DROP FUNCTION gpInsertUpdate_Object_Juridical();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
INOUT ioId	         Integer   ,   	/* ключ объекта <Юридическое лицо> */
IN inCode                Integer   ,
IN inName                TVarChar  ,    /* Название объекта <Юридическое лицо> */
IN inGLNCode             TVarChar  ,    /*  */
IN inisCorporate         Boolean   ,    /*  */
IN inJuridicalGroupId    Integer   ,    /*  */
IN inGoodsPropertyId     Integer   ,    /*  */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

   -- !!! Проверем уникальность имени
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Juridical(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Juridical(), inCode, inName);
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_GLNCode(), ioId, inGLNCode);
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isCorporate(), ioId, inisCorporate);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_JuridicalGroup(), ioId, inJuridicalGroupId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_GoodsProperty(), ioId, inGoodsPropertyId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Juridical(Integer, Integer, TVarChar, TVarChar, Boolean, Integer, Integer, TVarChar)
  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.05.13                                        * rem lpCheckUnique_Object_ValueData

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods                            
