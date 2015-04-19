-- Function: gpInsertUpdate_Object_Goods_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_Sybase(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_Sybase(
 INOUT ioId                  Integer   , -- ключ объекта <Товар>
    IN inCode                Integer   , -- Код объекта <Товар>
    IN inName                TVarChar  , -- Название объекта <Товар>
    IN inWeight              TFloat    , -- Вес
    IN inGoodsGroupId        Integer   , -- ссылка на группу Товаров
    IN inMeasureId           Integer   , -- ссылка на единицу измерения
    IN inInfoMoneyId         Integer   , -- Управленческие аналитики
    IN inBusinessId          Integer   , -- Бизнесы
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbGroupNameFull TVarChar;   

   DECLARE vbIndex               Integer;
   DECLARE vbGoodsGroupId        Integer;
   DECLARE vbTradeMarkId         Integer;
   DECLARE vbGoodsTagId          Integer;
   DECLARE vbGoodsGroupAnalystId Integer;
   DECLARE vbGoodsPlatformId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   
   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- !!! vbCode:=lfGet_ObjectCode (inCode, zc_Object_Goods());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- !!! проверка уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Goods(), inName);

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), vbCode);



   -- !!!заменили!!!
   IF inInfoMoneyId NOT IN (zc_Enum_InfoMoney_10202(), zc_Enum_InfoMoney_10203()) -- Прочее сырье + Оболочка + Упаковка
      AND inInfoMoneyId IN (zc_Enum_InfoMoney_10201(), zc_Enum_InfoMoney_10204()) -- Прочее сырье + Специи + Прочее сырье
      AND ioId > 0 
      AND EXISTS (SELECT ObjectLink_Receipt_Goods.ObjectId
                  FROM ObjectLink AS ObjectLink_Receipt_GoodsKind
                       INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods ON ObjectLink_Receipt_Goods.ChildObjectId = ObjectLink_Receipt_GoodsKind.ObjectId
                                                                        AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                                                        AND ObjectLink_Receipt_Goods.ObjectId = ioId
                       INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = ObjectLink_Receipt_GoodsKind.ObjectId
                                                                               AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                       INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                               AND Object_ReceiptChild.isErased = FALSE
                       INNER JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id 
                                               AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
                                               AND ObjectBoolean_TaxExit.ValueData = TRUE
                  WHERE ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                    AND ObjectLink_Receipt_GoodsKind.ChildObjectId = zc_GoodsKind_WorkProgress())
   THEN
       inInfoMoneyId:= zc_Enum_InfoMoney_10203(); -- Упаковка
   END IF;


   -- хардкод
   vbGoodsPlatformId:= (SELECT CASE WHEN InfoMoneyCode IN (10102,10103,10104,10105,30101,30201,30301) -- Основное сырье + Мясное сырье OR Доходы + Продукция or Мясное сырье
                                         THEN (SELECT Id FROM Object WHERE ObjectCode = 1 AND DescId = zc_Object_GoodsPlatform())
                                    WHEN InfoMoneyCode IN (20901) -- Ирна
                                         THEN (SELECT Id FROM Object WHERE ObjectCode = 2 AND DescId = zc_Object_GoodsPlatform())
                                    WHEN InfoMoneyCode IN (30102) -- Тушенка
                                         THEN (SELECT Id FROM Object WHERE ObjectCode = 3 AND DescId = zc_Object_GoodsPlatform())
                                    WHEN InfoMoneyCode IN (20901) -- Хлеб
                                         THEN (SELECT Id FROM Object WHERE ObjectCode = 4 AND DescId = zc_Object_GoodsPlatform())
                               END AS GoodsPlatformId
                        FROM Object_InfoMoney_View
                        WHERE Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId);


   -- расчетно свойство <Полное название группы>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), vbCode, inName
                                , inAccessKeyId:= CASE WHEN ioId <> 0
                                                            THEN (SELECT AccessKeyId FROM Object WHERE Id= ioId)
                                                  END);



   -- сохранили свойство <Полное название группы>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);
   -- сохранили свойство <Вес>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Weight(), ioId, inWeight);
   -- сохранили связь с <Группой товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <Единицей измерения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили связь с <Управленческие аналитики>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили связь с <Бизнесы>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Business(), ioId, inBusinessId);
   -- сохранили связь с <Производственная площадка>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ioId, vbGoodsPlatformId);


   -- Level-0
   vbTradeMarkId:=         (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_TradeMark());
   vbGoodsTagId:=          (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_GoodsTag());
   vbGoodsGroupAnalystId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst());
   vbGoodsGroupId:=        (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_Parent());

   vbIndex:= 1;
   WHILE vbGoodsGroupId <> 0 AND vbIndex < 10 LOOP
      -- Level-next
      IF COALESCE (vbTradeMarkId, 0) = 0         THEN vbTradeMarkId:=         (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_TradeMark()); END IF;
      IF COALESCE (vbGoodsTagId, 0) = 0          THEN vbGoodsTagId:=          (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_GoodsTag()); END IF;
      IF COALESCE (vbGoodsGroupAnalystId, 0) = 0 THEN vbGoodsGroupAnalystId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()); END IF;
      vbGoodsGroupId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_Parent());
      -- теперь следуюющий
      vbIndex := vbIndex + 1;
   END LOOP;

   -- сохранили связь с <Торговые марки>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ioId, vbTradeMarkId);   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ioId, vbGoodsTagId);   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ioId, vbGoodsGroupAnalystId);  

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods_Sybase (Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;
 
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.09.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods_Sybase (ioId:=0, inCode:=-1, inName:= 'TEST-GOODS', ... , inSession:= '2')
