-- Function: gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItemLast(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент ИСТОРИИ>
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inOperDate               TDateTime,  -- Дата действия цены
   OUT outStartDate             TDateTime,  -- Дата действия цены
   OUT outEndDate               TDateTime,  -- Дата действия цены
    IN inValue                  TFloat,     -- Цена
    IN inIsLast                 Boolean,    -- 
    IN inIsDiscountDelete       Boolean,    -- 
    IN inIsDiscount             Boolean,    -- Цена со скидкой (1-Да, 0-НЕТ)
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
   DECLARE vbDiscountPeriodItemId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- !!!меняем значение!!!
   IF inIsLast = TRUE THEN ioId:= 0; END IF;

   -- Поиск <Элемент цены>
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, vbUserId);
 
   -- Сохранили историю
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate, vbUserId);

   -- Сохранили цену
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);

   -- Сохранили Цена со скидкой (1-Да, 0-НЕТ)
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_isDiscount(), ioId, CASE WHEN inIsDiscount = TRUE THEN 1 ELSE 0 END);
   
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

   --
   IF inIsLast = TRUE AND EXISTS (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate)
   THEN
         -- сохранили протокол - "удаление"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
         WHERE ObjectHistory.DescId = zc_ObjectHistory_PriceListItem() AND ObjectHistory.ObjectId = vbPriceListItemId AND ObjectHistory.StartDate > inOperDate;

         -- удалили
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistory WHERE Id IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         -- Здесь надо изменить св-во EndDate
         UPDATE ObjectHistory SET EndDate = zc_DateEnd() WHERE Id = ioId;
   END IF;


   -- вернули значения
   SELECT StartDate, EndDate INTO outStartDate, outEndDate FROM ObjectHistory WHERE Id = ioId;

   -- Проверка
   IF inIsLast = TRUE AND COALESCE (outEndDate, zc_DateStart()) <> zc_DateEnd()
   THEN
       RAISE EXCEPTION 'Ошибка. inIsLast = TRUE AND outEndDate = <%>', outEndDate;
   END IF;
   

   -- !!!не забыли - cохранили Последнюю Цену в ПАРТИЯХ!!!
   IF inPriceListId = zc_PriceList_Basis()
   THEN
       PERFORM lpUpdate_Object_PartionGoods_OperPriceList (inGoodsId:= inGoodsId, inUserId:= vbUserId);
   END IF;

   IF zc_Enum_GlobalConst_isTerry() = FALSE
   THEN
       -- Поиск <Элемент скидки>
       vbDiscountPeriodItemId := lpGetInsert_Object_DiscountPeriodItem ((SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.ChildObjectId = inPriceListId AND OL.DescId = zc_ObjectLink_Unit_PriceList())
                                                                      , inGoodsId, vbUserId);
       -- Проверка
       IF EXISTS (SELECT 1 FROM ObjectHistory AS OH WHERE OH.DescId = zc_ObjectHistory_PriceListItem() AND OH.ObjectId = vbPriceListItemId AND OH.EndDate = inOperDate)
          AND inValue < (SELECT COALESCE (OFl.ValueData, 0) FROM ObjectHistory AS OH LEFT JOIN ObjectHistoryFloat AS OFl ON OFl.ObjectHistoryId = OH.Id AND OFl.DescId = zc_ObjectHistoryFloat_PriceListItem_Value() WHERE OH.DescId = zc_ObjectHistory_PriceListItem() AND OH.ObjectId = vbPriceListItemId AND OH.EndDate = inOperDate)
          AND 0 < (SELECT SUM (COALESCE (OFl.ValueData, 0)) FROM ObjectHistory AS OH LEFT JOIN ObjectHistoryFloat AS OFl ON OFl.ObjectHistoryId = OH.Id AND OFl.DescId IN (zc_ObjectHistoryFloat_DiscountPeriodItem_Value(),zc_ObjectHistoryFloat_DiscountPeriodItem_ValueNext()) WHERE OH.DescId = zc_ObjectHistory_DiscountPeriodItem() AND OH.ObjectId = vbDiscountPeriodItemId AND OH.StartDate <= inOperDate AND inOperDate < OH.EndDate)
       THEN
           IF inIsDiscountDelete = TRUE
           THEN
               PERFORM gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast (ioId         := (SELECT OH.Id FROM ObjectHistory AS OH WHERE OH.DescId = zc_ObjectHistory_DiscountPeriodItem() AND OH.ObjectId = vbDiscountPeriodItemId AND OH.StartDate <= inOperDate AND inOperDate < OH.EndDate) --  ORDER BY OH.Id DESC LIMIT 1
                                                                          , inUnitId     := (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.ChildObjectId = inPriceListId AND OL.DescId = zc_ObjectLink_Unit_PriceList())
                                                                          , inGoodsId    := inGoodsId
                                                                          , inOperDate   := inOperDate
                                                                          , inValue      := 0
                                                                          , inValueNext  := 0
                                                                          , inIsLast     := TRUE
                                                                          , inSession    := inSession
                                                                           );
           ELSE
               RAISE EXCEPTION 'Ошибка.Для товара найдена сезонная скидка = <% %>.Переоценку провести нельзя.'
                             , zfConvert_FloatToString((SELECT SUM (COALESCE (OFl.ValueData, 0) ) FROM ObjectHistory AS OH LEFT JOIN ObjectHistoryFloat AS OFl ON OFl.ObjectHistoryId = OH.Id AND OFl.DescId IN (zc_ObjectHistoryFloat_DiscountPeriodItem_Value(),zc_ObjectHistoryFloat_DiscountPeriodItem_ValueNext()) WHERE OH.DescId = zc_ObjectHistory_DiscountPeriodItem() AND OH.ObjectId = vbDiscountPeriodItemId AND OH.StartDate <= inOperDate AND inOperDate < OH.EndDate))
                             , '%'
                              ;
           END IF;
       END IF;

   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= vbPriceListItemId, inUserId:= vbUserId, inStartDate:= outStartDate, inEndDate:= outEndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE);

   IF vbUserId :: TVarChar = zfCalc_UserAdmin() AND 1=1
   THEN
       RAISE EXCEPTION 'Error.Admin test - ok';
   END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 20.08.15         * lpInsert_ObjectHistoryProtocol
 09.12.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId := 0, inPriceListId:= 4788, inGoodsId := 120766, inOperDate = '26.03.2015', inValue := 59, inIsLast:= TRUE, inSession := zc_User_Sybase() :: TVarChar);
