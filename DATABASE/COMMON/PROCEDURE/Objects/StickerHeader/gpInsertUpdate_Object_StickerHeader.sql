-- Function: gpInsertUpdate_Object_StickerHeader()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerHeader(Integer, Integer, TVarChar, Text, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerHeader(
 INOUT ioId                    Integer   ,     -- ключ объекта <Торговая сеть> 
    IN inCode                  Integer   ,     -- Код объекта  
    IN inName                  TVarChar  ,     -- Название объекта 
    IN inInfo                  Text      ,     -- 
    IN inisDefault             Boolean   ,     --
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StickerHeader());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_StickerHeader());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_StickerHeader(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StickerHeader(), inCode);
  
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StickerHeader(), inCode, inName);
   
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_StickerHeader_Info(), ioId, inInfo);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerHeader_Default(), ioId, inisDefault);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
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