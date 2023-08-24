-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

--DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListTax(
    IN inId                         Integer,    -- ключ объекта <Элемент прайс-листа>
    IN inPriceListFromId            Integer,    -- Прайс-лист
    IN inPriceListToId              Integer,    -- Прайс-лист
    IN inGoodsGroupId               Integer,    -- если заполнено тогда ограничиваем
    IN inInfoMoneyId                Integer,    -- если заполнено тогда ограничиваем
    IN inOperDate                   TDateTime,  -- Изменение цены с
    IN inOperDateFrom               TDateTime,  -- Дата цены основания
    IN inTax                        TFloat,     -- (-)% Скидки (+)% Наценки
    IN inSession                    TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- Проверка
   IF COALESCE (inPriceListFromId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не определено значение <Прайс-лист основание>.';
   END IF;

   -- Проверка
   IF COALESCE (inPriceListToId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не определено значение <Прайс-лист результат>.';
   END IF;

   -- Проверка
   IF inOperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Изменение цены с> не может быть раньше чем <%>.', DATE (DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH');
   END IF;

   -- Проверка
   IF inOperDateFrom < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Дата цены основания> не может быть раньше чем <%>.', DATE (DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH');
   END IF;


   -- Изменение ВСЕХ цен
   PERFORM  lpInsertUpdate_ObjectHistory_PriceListItem (ioId         := 0
                                                     , inPriceListId := inPriceListToId
                                                     , inGoodsId     := ObjectLink_PriceListItem_Goods.ChildObjectId
                                                     , inGoodsKindId := ObjectLink_PriceListItem_GoodsKind.ChildObjectId
                                                     , inOperDate    := inOperDate
                                                     , inValue       := zfCalc_PriceTruncate (inOperDate     := CURRENT_DATE
                                                                                            , inChangePercent:= inTax
                                                                                            , inPrice        := ObjectHistoryFloat_PriceListItem_Value.ValueData
                                                                                            , inIsWithVAT    := ObjectBoolean_PriceWithVAT.ValueData
                                                                                             )
                                                     , inUserId      := vbUserId)

                                     /*PERFORM  gpInsertUpdate_ObjectHistory_PriceListItemLast
                                                      (ioId          := inId
                                                     , inPriceListId := inPriceListToId
                                                     , inGoodsId     := ObjectLink_PriceListItem_Goods.ChildObjectId
                                                     , inOperDate    := inOperDate
                                                     , inValue       := CAST (ObjectHistoryFloat_PriceListItem_Value.ValueData
                                                                           + (ObjectHistoryFloat_PriceListItem_Value.ValueData * inTax / 100) AS Numeric (16,2)) ::TFloat
                                                     , inIsLast      := TRUE
                                                     , inSession     := inSession)*/
                                                     
              FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                          ON ObjectBoolean_PriceWithVAT.ObjectId = ObjectLink_PriceListItem_PriceList.ChildObjectId
                                         AND ObjectBoolean_PriceWithVAT.DescId   = zc_ObjectBoolean_PriceList_PriceWithVAT()
                  LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                       ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                      AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

                  LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                       ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                      AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

                  LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                          ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                         AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                         AND inOperDateFrom >= ObjectHistory_PriceListItem.StartDate AND inOperDateFrom < ObjectHistory_PriceListItem.EndDate
                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                               ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                              AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                  
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_PriceListItem_Goods.ChildObjectId
                                      AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent_0
                                       ON ObjectLink_GoodsGroup_parent_0.ObjectId = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                      AND ObjectLink_GoodsGroup_parent_0.DescId = zc_ObjectLink_GoodsGroup_Parent()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent_1
                                       ON ObjectLink_GoodsGroup_parent_1.ObjectId = ObjectLink_GoodsGroup_parent_0.ChildObjectId
                                      AND ObjectLink_GoodsGroup_parent_1.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent_2
                                       ON ObjectLink_GoodsGroup_parent_2.ObjectId = ObjectLink_GoodsGroup_parent_1.ChildObjectId
                                      AND ObjectLink_GoodsGroup_parent_2.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent_3
                                       ON ObjectLink_GoodsGroup_parent_3.ObjectId = ObjectLink_GoodsGroup_parent_2.ChildObjectId
                                      AND ObjectLink_GoodsGroup_parent_3.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent_4
                                       ON ObjectLink_GoodsGroup_parent_4.ObjectId = ObjectLink_GoodsGroup_parent_3.ChildObjectId
                                      AND ObjectLink_GoodsGroup_parent_4.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent_5
                                       ON ObjectLink_GoodsGroup_parent_5.ObjectId = ObjectLink_GoodsGroup_parent_4.ChildObjectId
                                      AND ObjectLink_GoodsGroup_parent_5.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent_6
                                       ON ObjectLink_GoodsGroup_parent_6.ObjectId = ObjectLink_GoodsGroup_parent_5.ChildObjectId
                                      AND ObjectLink_GoodsGroup_parent_6.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent_7
                                       ON ObjectLink_GoodsGroup_parent_7.ObjectId = ObjectLink_GoodsGroup_parent_6.ChildObjectId
                                      AND ObjectLink_GoodsGroup_parent_7.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent_8
                                       ON ObjectLink_GoodsGroup_parent_8.ObjectId = ObjectLink_GoodsGroup_parent_7.ChildObjectId
                                      AND ObjectLink_GoodsGroup_parent_8.DescId   = zc_ObjectLink_GoodsGroup_Parent()
    
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_PriceListItem_Goods.ChildObjectId
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_PriceListItem_Goods.ChildObjectId

              WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListFromId
                AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
                -- если заполнены  переносить данные только по этим товарам
                AND (ObjectLink_Goods_GoodsGroup.ChildObjectId = inGoodsGroupId OR inGoodsGroupId = 0
                  OR ObjectLink_GoodsGroup_parent_0.ChildObjectId = inGoodsGroupId 
                  OR ObjectLink_GoodsGroup_parent_1.ChildObjectId = inGoodsGroupId 
                  OR ObjectLink_GoodsGroup_parent_2.ChildObjectId = inGoodsGroupId 
                  OR ObjectLink_GoodsGroup_parent_3.ChildObjectId = inGoodsGroupId 
                  OR ObjectLink_GoodsGroup_parent_4.ChildObjectId = inGoodsGroupId 
                  OR ObjectLink_GoodsGroup_parent_5.ChildObjectId = inGoodsGroupId 
                  OR ObjectLink_GoodsGroup_parent_6.ChildObjectId = inGoodsGroupId 
                  OR ObjectLink_GoodsGroup_parent_7.ChildObjectId = inGoodsGroupId 
                  OR ObjectLink_GoodsGroup_parent_8.ChildObjectId = inGoodsGroupId 
                    )
                AND (ObjectLink_Goods_InfoMoney.ChildObjectId = inInfoMoneyId OR inInfoMoneyId = 0)
                --
                AND Object_Goods.isErased = FALSE
                AND (Object_Goods.ObjectCode <> 0 OR ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0)
                -- !!!
                AND ObjectHistoryFloat_PriceListItem_Value.ValueData  > 0.01
             ;

-- !!! ВРЕМЕННО !!!
if vbUserId = 5 AND 1=1
then
    RAISE EXCEPTION 'Admin - Test = OK';
    -- 'Повторите действие через 3 мин.'
end if;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.05.21         * inGoodsGroupId, inInfoMoneyId
 11.12.19         * add zc_ObjectLink_PriceListItem_GoodsKind
 21.08.15         *
*/
