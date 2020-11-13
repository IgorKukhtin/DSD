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

/*
     -- Ограничение - если роль Начисления транспорт-меню
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 78489 AND UserId = vbUserId)
        AND COALESCE (inPriceListId, 0) NOT IN (zc_PriceList_Fuel())
     THEN
         RAISE EXCEPTION 'Ошибка. Нет прав на Просмотр прайса <%>', lfGet_Object_ValueData (inPriceListId);
     END IF;
*/
     -- определяем период , цены за месяц
     vbStartDate := CASE WHEN inOperDate + INTERVAL '1 Day'  =  DATE_TRUNC ('MONTH', inOperDate + INTERVAL '1 Day') THEN DATE_TRUNC ('MONTH', inOperDate) ELSE inOperDate - INTERVAL '1 MONTH' END;
     vbEndDate   := inOperDate ;

     -- Выбираем данные
     RETURN QUERY 
     WITH
     tmpItem_all AS (SELECT ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                          , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                          , ObjectHistory_PriceListItem.StartDate
                          , ObjectHistory_PriceListItem.EndDate
                     FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                          LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                               ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                              AND ObjectLink_PriceListItem_Goods.DescId   = zc_ObjectLink_PriceListItem_Goods()
                          LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                  ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                 AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                       ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                      AND ObjectHistoryFloat_PriceListItem_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
  
                     WHERE ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                       AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                       AND ObjectHistory_PriceListItem.EndDate              >= vbStartDate
                       AND ObjectHistory_PriceListItem.StartDate            <= vbEndDate
                    )
       -- Результат
       SELECT tmp.GoodsId
            , tmp.StartDate
            , tmp.ValuePrice

       FROM (SELECT tmpItem_all.GoodsId, tmpItem_all.ValuePrice, tmpItem_all.StartDate
             FROM tmpItem_all
             WHERE tmpItem_all.StartDate >= vbStartDate
            UNION ALL
             SELECT tmpItem_all.GoodsId, tmpItem_all.ValuePrice, tmpItem_all.StartDate
             FROM tmpItem_all
                  LEFT JOIN tmpItem_all AS tmpItem_all_check ON tmpItem_all_check.GoodsId   = tmpItem_all.GoodsId
                                                            AND tmpItem_all_check.StartDate = vbStartDate
             WHERE tmpItem_all.StartDate < vbStartDate
               AND tmpItem_all_check.GoodsId IS NULL
            ) AS tmp
       ORDER BY tmp.StartDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.20         *
 16.10.18         *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem_Period (2707438, '25.10.2018', zfCalc_UserAdmin())
