-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListTax(Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListTax(
    IN inId                         Integer,    -- ключ объекта <Элемент прайс-листа>
    IN inPriceListFromId            Integer,    -- Прайс-лист
    IN inPriceListToId              Integer,    -- Прайс-лист
    IN inOperDate                   TDateTime,  -- Дата действия прайс-листа
    IN inOperDateFrom               TDateTime,  -- Дата действия прайс-листа
    IN inTax                        TFloat,     -- Значение цены
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

   PERFORM  lpInsertUpdate_ObjectHistory_PriceListItem (ioId         := inId
                                                     , inPriceListId := inPriceListToId
                                                     , inGoodsId     := ObjectLink_PriceListItem_Goods.ChildObjectId
                                                     , inOperDate    := inOperDate
                                                     , inValue       := CAST (ObjectHistoryFloat_PriceListItem_Value.ValueData+(ObjectHistoryFloat_PriceListItem_Value.ValueData * inTax/100) AS Numeric (16,2)) ::TFloat
                                                     , inUserId      := vbUserId)

              FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
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

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.08.15         *
*/
