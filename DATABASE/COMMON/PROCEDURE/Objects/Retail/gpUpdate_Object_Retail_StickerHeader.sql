-- Function: gpInsertUpdate_Object_Retail()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_StickerHeader(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_StickerHeader(
    IN inId                    Integer   ,     -- ключ объекта <Торговая сеть> 
    IN inStickerHeaderId       Integer   ,     -- 
   OUT outStickerHeaderName    TVarChar  ,
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Retail());

   IF COALESCE (inId,0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не сохранен.';
   END IF;
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_StickerHeader(), inId, inStickerHeaderId);  

   outStickerHeaderName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = inStickerHeaderId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.22         * 
*/

-- тест
-- 