-- Function: gpUpdate_Object_Retail_GLNCode()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_GLNCode(
 INOUT ioId             Integer   ,     -- ключ объекта <Торговая сеть> 
    IN inGLNCode        TVarChar  ,     -- Код GLN
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_GLNCode());
   --vbUserId := inSession;

   -- сохранили св-во <Код GLN>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Retail_GLNCode(), ioId, inGLNCode);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.03.15         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Retail_GLNCode(ioId:=null, inCode:=null, inName:='Торговая сеть 1', inSession:='2')