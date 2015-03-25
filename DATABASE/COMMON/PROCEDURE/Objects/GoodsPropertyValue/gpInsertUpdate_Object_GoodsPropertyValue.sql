-- Function: gpInsertUpdate_Object_GoodsPropertyValue()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue(Integer, TVarChar, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyValue(
 INOUT ioId                  Integer   ,    -- ключ объекта <Значения свойств товаров для классификатора>
    IN inName                TVarChar  ,    -- Название товара(покупателя)
    IN inAmount              TFloat    ,    -- Количество штук в упаковке
    IN inBarCode             TVarChar  ,    -- Штрих-код
    IN inArticle             TVarChar  ,    -- Артикул
    IN inBarCodeGLN          TVarChar  ,    -- Штрих-код GLN
    IN inArticleGLN          TVarChar  ,    -- Артикул GLN
    IN inGroupName           TVarChar  ,    -- Название группы
    IN inGoodsPropertyId     Integer   ,    -- Классификатор свойств товаров
    IN inGoodsId             Integer   ,    -- Товары
    IN inGoodsKindId         Integer   ,    -- Виды товара
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue());

   -- проверка
   IF COALESCE (inGoodsPropertyId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Классификатор свойств товаров>.';
   END IF;
   -- проверка
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
   END IF;
   -- проверка для УП: Доходы + Продукция + Готовая продукция
   IF COALESCE (inGoodsKindId, 0) = 0 AND EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND ChildObjectId = zc_Enum_InfoMoney_30101() AND DescId = zc_ObjectLink_Goods_InfoMoney())
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Вид товара>.';
   END IF;

   -- проверка уникальности
   IF EXISTS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
              FROM ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                   INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                         ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                        AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = inGoodsPropertyId
                                        AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                        ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                       AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
              WHERE ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                AND COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                AND ObjectLink_GoodsPropertyValue_Goods.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION 'Ошибка.Значение Классификатор = <%> + Товар = <%> + Вид товара = <%> уже есть в справочнике. Дублирование запрещено.', lfGet_Object_ValueData (inGoodsPropertyId), lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
   END IF;   


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsPropertyValue(), 0, inName);

   -- сохранили связь
   PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsPropertyValue_Amount(), ioId, inAmount);
   -- сохранили связь
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCode(), ioId, inBarCode);
   -- сохранили связь
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_Article(), ioId, inArticle);
   -- сохранили связь
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCodeGLN(), ioId, inBarCodeGLN);
   -- сохранили связь
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_ArticleGLN(), ioId, inArticleGLN);
   -- сохранили связь
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_GroupName(), ioId, inGroupName);

   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsProperty(), ioId, inGoodsPropertyId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_Goods(), ioId, inGoodsId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsKind(), ioId, inGoodsKindId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.02.15                                        *
 10.10.14                                                       *
 12.06.13          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsPropertyValue()
