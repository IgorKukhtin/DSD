-- Function: lpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistory_PriceListItem (Integer,Integer,Integer,TDateTime,TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistory_PriceListItem(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент ИСТОРИИ>
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inOperDate               TDateTime,  -- Дата действия цены
    IN inValue                  TFloat,     -- Цена
    IN inUserId                 Integer     -- сессия пользователя
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbPriceListItemId Integer;
BEGIN

   -- Поиск <Элемент цены>
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, inUserId);

   -- Сохранили историю
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate, inUserId);

   -- Сохранили цену
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);

   -- Сохранили ВАЛЮТУ
   PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_PriceListItem_Currency(), ioId
                                           , COALESCE (-- валюта из истории - у всех элементов одинаковая ...
                                                       (SELECT DISTINCT OHL_Currency.ObjectId
                                                        FROM ObjectHistory AS OH_PriceListItem
                                                             LEFT JOIN ObjectHistoryLink AS OHL_Currency
                                                                                         ON OHL_Currency.ObjectHistoryId = OH_PriceListItem.Id
                                                                                        AND OHL_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                                                        WHERE OH_PriceListItem.ObjectId = vbPriceListItemId
                                                          AND OHL_Currency.ObjectId     > 0
                                                       )
                                                       -- валюта прайса
                                                     , (SELECT OL_Currency.ChildObjectId
                                                        FROM ObjectLink AS OL_Currency
                                                        WHERE OL_Currency.ObjectId = inPriceListId
                                                          AND OL_Currency.DescId   = zc_ObjectLink_PriceList_Currency()
                                                       )
                                                     , zc_Currency_GRN()
                                                      )
                                            );


   -- не забыли - cохранили Последнюю Цену в ПАРТИЯХ
   IF inPriceListId = zc_PriceList_Basis()
   THEN
       PERFORM lpUpdate_Object_PartionGoods_OperPriceList (inGoodsId:= inGoodsId, inUserId:= inUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= ObjectHistory.ObjectId, inUserId:= inUserId, inStartDate:= StartDate, inEndDate:= EndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE)
   FROM ObjectHistory WHERE Id = ioId;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.08.15         *
*/
