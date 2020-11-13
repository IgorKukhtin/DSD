-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListTax(
    IN inId                         Integer,    -- ключ объекта <Элемент прайс-листа>
    IN inPriceListFromId            Integer,    -- Прайс-лист
    IN inPriceListToId              Integer,    -- Прайс-лист
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
                                                     , inOperDate    := inOperDate
                                                     , inValue       := zfCalc_PriceTruncate (inOperDate     := CURRENT_DATE
                                                                                            , inChangePercent:= inTax
                                                                                            , inPrice        := ObjectHistoryFloat_PriceListItem_Value.ValueData
                                                                                            , inIsWithVAT    := ObjectBoolean_PriceWithVAT.ValueData
                                                                                             )
                                                     , inUserId      := vbUserId)

   FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
       LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                               ON ObjectBoolean_PriceWithVAT.ObjectId = ObjectLink_PriceListItem_PriceList.ChildObjectId
                              AND ObjectBoolean_PriceWithVAT.DescId   = zc_ObjectBoolean_PriceList_PriceWithVAT()
       LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                            ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                           AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                               ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                              AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                              AND inOperDateFrom >= ObjectHistory_PriceListItem.StartDate AND inOperDateFrom < ObjectHistory_PriceListItem.EndDate
       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                    ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                   AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

   WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
     AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListFromId
     AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
  ;

-- !!! ВРЕМЕННО !!!
if inSession = '5' AND 1=1
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
 13.11.20         *
 11.12.19         * add zc_ObjectLink_PriceListItem_GoodsKind
 21.08.15         *
*/
