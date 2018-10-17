-- Function: gpSelect_ObjectHistory_PriceListItem_Period ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem_Period (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListItem_Period(
    IN inPriceListId        Integer   , -- Прайс-Лист 
    IN inOperDate           TDateTime , -- 
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (GoodsId Integer, StartDate TDateTime, ValuePrice TFloat
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Ограничение - если роль Начисления транспорт-меню
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 78489 AND UserId = vbUserId)
        AND COALESCE (inPriceListId, 0) NOT IN (zc_PriceList_Fuel())
     THEN
         RAISE EXCEPTION 'Ошибка. Нет прав на Просмотр прайса <%>', lfGet_Object_ValueData (inPriceListId);
     END IF;

     -- определяем период , цены за месяц
     vbStartDate := inOperDate - INTERVAL '1 MONTH' ; --DATE_TRUNC ('MONTH', inOperDate);
     vbEndDate := inOperDate + INTERVAL '1 Day'; --vbStartDate + INTERVAL '1 MONTH';

     -- Выбираем данные
     RETURN QUERY 
       SELECT ObjectLink_PriceListItem_Goods.ChildObjectId :: Integer AS GoodsId
            , ObjectHistory_PriceListItem.StartDate
            , ObjectHistoryFloat_PriceListItem_Value.ValueData :: tfloat AS ValuePrice

       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND ObjectHistory_PriceListItem.StartDate >= vbStartDate
         AND ObjectHistory_PriceListItem.StartDate < vbEndDate
       ORDER BY /* ObjectLink_PriceListItem_Goods.ChildObjectId ,*/ ObjectHistory_PriceListItem.StartDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.18         *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem_Period (2707438, '25.10.2018', zfCalc_UserAdmin())
