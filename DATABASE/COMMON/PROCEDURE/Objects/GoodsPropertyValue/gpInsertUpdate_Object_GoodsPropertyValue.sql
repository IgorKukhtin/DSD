-- Function: gpInsertUpdate_Object_GoodsPropertyValue()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsPropertyValue();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyValue(
 INOUT ioId                  Integer   ,   	-- ключ объекта <Значения свойств товаров для классификатора> 
    IN inName                TVarChar  ,    -- Название товара(покупателя) 
    IN inAmount              TFloat    ,    -- Количество штук в упаковке  
    IN inBarCode             TVarChar  ,    -- Штрих-код                   
    IN inArticle             TVarChar  ,    -- Артикул                     
    IN inBarCodeGLN          TVarChar  ,    -- Штрих-код GLN               
    IN inArticleGLN          TVarChar  ,    -- Артикул GLN                 
    IN inGoodsPropertyId     Integer   ,    -- Классификатор свойств товаров 
    IN inGoodsId             Integer   ,    -- Товары 
    IN inGoodsKindId         Integer   ,    -- Виды товара            
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
 
 BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsPropertyValue());
   UserId := inSession;
  
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsPropertyValue(), 0, inName);

   -- Вставляем свойство
   PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsPropertyValue_Amount(), ioId, inAmount);
   -- Вставляем свойство
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCode(), ioId, inBarCode);
   -- Вставляем свойство
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_Article(), ioId, inArticle);
   -- Вставляем свойство
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCodeGLN(), ioId, inBarCodeGLN);
   -- Вставляем свойство
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_ArticleGLN(), ioId, inArticleGLN);

   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsProperty(), ioId, inGoodsPropertyId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_Goods(), ioId, inGoodsId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsKind(), ioId, inGoodsKindId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_GoodsPropertyValue(Integer, TVarChar, TFloat, TVarChar, TVarChar, TVarChar,
                                                        TVarChar, Integer, Integer, Integer, TVarChar)
  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.06.13          *
 00.06.13          

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsPropertyValue()