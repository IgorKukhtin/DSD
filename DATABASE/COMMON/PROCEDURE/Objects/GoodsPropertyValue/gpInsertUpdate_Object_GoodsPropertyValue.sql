-- Function: gpInsertUpdate_Object_GoodsPropertyValue()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue (Integer, TVarChar, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue (Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue (Integer, TVarChar, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue (Integer, TVarChar, TFloat, TFloat, TVarChar, TVarChar, TVargpInsertUpdate_Object_GoodsPropertyValueChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue (Integer, TVarChar, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyValue(
 INOUT ioId                  Integer   ,    -- ключ объекта <Значения свойств товаров для классификатора>
    IN inName                TVarChar  ,    -- Название товара(покупателя)
    IN inAmount              TFloat    ,    -- Кол-во штук при сканировании
    IN inBoxCount            TFloat    ,    -- Кол-во единиц в ящике
    --IN inAmountDoc           TFloat    ,    -- Количество вложение
   OUT outBarCodeShort       TVarChar  ,    -- Штрих-код
    IN inBarCode             TVarChar  ,    -- Штрих-код
    IN inArticle             TVarChar  ,    -- Артикул
    IN inBarCodeGLN          TVarChar  ,    -- Штрих-код GLN
    IN inArticleGLN          TVarChar  ,    -- Артикул GLN
    IN inGroupName           TVarChar  ,    -- Название группы
    IN inGoodsPropertyId     Integer   ,    -- Классификатор свойств товаров
    IN inGoodsId             Integer   ,    -- Товары
    IN inGoodsKindId         Integer   ,    -- Виды товара
    IN inGoodsBoxId          Integer   ,    -- Товары (гофроящик) 
    IN inGoodsKindSubId      Integer   ,    -- Вид товара (факт расход в накладной)
    IN inisGoodsKind         Boolean   ,    -- Разрешена отгрузка с таким видом тов.
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue());

   -- проверка - Изменение значения св-в товаров
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.RoleId IN (11288675, 624406, zc_Enum_Role_Admin())  AND ObjectLink_UserRole_View.UserId = vbUserId)
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав для изменения данных.';
   END IF;

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

   IF ioId IN (327114 -- КОТЛЕТА СТОЛИЧНАЯ. (отбивная с/к)
             , 327115 -- Котлетне  мясо (св2+св3)
             , 126856 -- КОТЛЕТНОЕ МЯСО(св2+св3)
              )
   THEN 
        PERFORM _lp_Delete_Object (ioId, inSession);
        RETURN;
   END IF;

   -- проверка уникальности
   IF /*inGoodsKindId <> 0 AND*/
      EXISTS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
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
       RAISE EXCEPTION 'Ошибка.Значение  <%> + <%> + <%> уже есть в справочнике. Дублирование запрещено.', lfGet_Object_ValueData (inGoodsPropertyId), lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
   END IF;   


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsPropertyValue(), 0, inName);

   -- сохранили 
   PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsPropertyValue_Amount(), ioId, inAmount);
   -- сохранили 
   PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsPropertyValue_BoxCount(), ioId, inBoxCount);
   -- сохранили 
   --PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsPropertyValue_AmountDoc(), ioId, inAmountDoc);
   -- сохранили 
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCode(), ioId, inBarCode);
   -- сохранили 
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_Article(), ioId, inArticle);
   -- сохранили 
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCodeGLN(), ioId, inBarCodeGLN);
   -- сохранили 
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_ArticleGLN(), ioId, inArticleGLN);
   -- сохранили 
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_GroupName(), ioId, inGroupName);

   -- сохранили связь
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsProperty(), ioId, inGoodsPropertyId);
   -- сохранили связь
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_Goods(), ioId, inGoodsId);
   -- сохранили связь
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsKind(), ioId, inGoodsKindId);
   -- сохранили связь
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsBox(), ioId, inGoodsBoxId);

   -- сохранили связь
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsKindSub(), ioId, inGoodsKindSubId);
   -- сохранили 
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_GoodsPropertyValue_isGoodsKind(), ioId, inisGoodsKind);


   -- обновили
   PERFORM lpUpdate_Object_GoodsPropertyValue_BarCodeShort (inGoodsPropertyId, ioId, vbUserId);
   -- 
   outBarCodeShort:= (SELECT ObjectString_BarCodeShort.ValueData
                      FROM ObjectString AS ObjectString_BarCodeShort
                      WHERE ObjectString_BarCodeShort.ObjectId = ioId
                        AND ObjectString_BarCodeShort.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeShort()
                     );

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.07.22         *
 14.02.18         * 
 27.06.17         * del inAmountDoc
 22.06.17         * add inAmountDoc
 17.09.15         * add BoxCount
 12.02.15                                        *
 10.10.14                                                       *
 12.06.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsPropertyValue()
