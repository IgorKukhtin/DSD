-- Function: gpUpdate_Object_Juridical_GLN()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_GLN (Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_GLN(
 INOUT ioId                  Integer   ,    -- ключ объекта <Юридическое лицо>
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inGoodsPropertyId     Integer   ,  -- Классификаторы свойств товаров
    IN inSession             TVarChar       -- текущий пользователь
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_GLN());

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_GLNCode(), ioId, inGLNCode);
   
   -- сохранили связь с <Классификаторы свойств товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Juridical_GoodsProperty(), ioId, inGoodsPropertyId);   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Juridical_GLN (Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.03.15         *

*/

-- тест
-- SELECT * FROM gpUpdate_Object_Juridical_GLN