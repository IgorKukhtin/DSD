-- Function: gpInsertUpdate_Object_ProdColorPatternPhoto(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorPatternPhoto(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdColorPatternPhoto(
 INOUT ioId                           Integer   , -- ключ объекта <Документ артикула>
    IN inPhotoName                    TVarChar  , -- Файл
    IN inProdColorPatternId           Integer   , -- Артикул
    IN inProdColorPatternPhotoData    TBlob     , -- Тело документа 	
    IN inSession                      TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbGoodsId  Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ProdColorPattern());
   vbUserId:= lpGetUserBySession (inSession);

   -- пределяем Goods
   vbGoodsId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_ProdColorPattern_Goods() AND ObjectLink.ObjectId = inProdColorPatternId);

   IF COALESCE (vbGoodsId,0) <> 0
   THEN 
       -- если заполнен zc_ObjectLink_ProdColorPattern_Goods - тогда берем и сохраняем фото у товара
       ioId := gpInsertUpdate_Object_GoodsPhoto (ioId
                                               , inPhotoName
                                               , vbGoodsId
                                               , inProdColorPatternPhotoData
                                               , inSession
                                               );
   ELSE
        -- проверка
       IF COALESCE (inProdColorPatternId, 0) = 0
       THEN
           --RAISE EXCEPTION 'Ошибка! Boat Structure не установлен!';
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка! Boat Structure не установлен!' :: TVarChar
                                                 , inProcedureName := 'gpInsertUpdate_Object_ProdColorPatternPhoto' :: TVarChar
                                                 , inUserId        := vbUserId
                                                 );
       END IF;
       
       -- сохранили <Объект>
       ioId := lpInsertUpdate_Object (ioId, zc_Object_ProdColorPatternPhoto(), 0, inPhotoName);
       
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_ProdColorPatternPhoto_Data(), ioId, inProdColorPatternPhotoData);
       
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorPatternPhoto_ProdColorPattern(), ioId, inProdColorPatternId);   
    
       -- сохранили протокол
       PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.02.21         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProdColorPatternPhoto (ioId:=0, inValue:=100, inProdColorPatternId:=5, inProdColorPatternConditionKindId:=6, inSession:='2')

