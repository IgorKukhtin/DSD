 -- Function: gpInsertUpdate_Object_StickerSkin()

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerSkin (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerSkin(
   INOUT ioId                       Integer,     -- ид
      IN incode                     Integer,     -- код 
      IN inName                     TVarChar,    -- наименование 
      IN inComment                  TVarChar,    -- Примечание
      IN inSession                  TVarChar     -- Пользователь
      )
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_StickerSkin());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_StickerSkin()); 
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_StickerSkin(), inName);
   -- проверка прав уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StickerSkin(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StickerSkin(), vbCode_calc, inName);
   
   -- сохранили св-во <Примечание>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_StickerSkin_Comment(), ioId, inComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.17         *
*/

-- тест
-- 
