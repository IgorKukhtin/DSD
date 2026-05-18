-- Function: gpSelect_ObjectHistory_PricePlanItem_Period ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PricePlanItem_Period (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PricePlanItem_Period(
    IN inPriceListId        Integer   , -- Прайс-Лист 
    IN inOperDate           TDateTime , -- 
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (GoodsId Integer, GoodsKindId Integer, StartDate TDateTime, ValuePrice TFloat
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
        AND NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        AND COALESCE (inPriceListId, 0) NOT IN (zc_PriceList_Fuel())
     THEN
         RAISE EXCEPTION 'Ошибка. Нет прав на Просмотр прайса <%>', lfGet_Object_ValueData (inPriceListId);
     END IF;


     -- Ограничение - Прайс-лист - просмотр с ограничениями
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10575455)
     THEN
         -- Ограничение
         IF NOT EXISTS (SELECT 1 AS Id FROM Object_ViewPriceList_View WHERE Object_ViewPriceList_View.UserId = vbUserId AND Object_ViewPriceList_View.PriceListId = inPriceListId)
            -- если установлены
            --AND EXISTS (SELECT 1 FROM Object_ViewPriceList_View WHERE Object_ViewPriceList_View.UserId = vbUserId AND Object_ViewPriceList_View.PriceListId > 0)
         THEN
             IF COALESCE (inPriceListId, 0) = 0
             THEN
                 RETURN;
             ELSE
                 RAISE EXCEPTION 'Ошибка.Нет прав на просмотр прайса <%>.', lfGet_Object_ValueData (inPriceListId);
             END IF;
         END IF;
     END IF;


     -- определяем период , цены за месяц
     --vbStartDate := inOperDate - INTERVAL '1 MONTH' ; --DATE_TRUNC ('MONTH', inOperDate);
     --vbEndDate := inOperDate + INTERVAL '1 Day'; --vbStartDate + INTERVAL '1 MONTH';
     vbStartDate := CASE WHEN inOperDate + INTERVAL '1 Day'  =  DATE_TRUNC ('MONTH', inOperDate + INTERVAL '1 Day') THEN DATE_TRUNC ('MONTH', inOperDate) ELSE inOperDate - INTERVAL '1 MONTH' END; --DATE_TRUNC ('MONTH', inOperDate);
     vbEndDate   := inOperDate ; --vbStartDate + INTERVAL '1 MONTH';

     -- Выбираем данные
     RETURN QUERY 
     WITH
     tmpItem_all AS (SELECT ObjectLink_PricePlanItem_Goods.ChildObjectId     AS GoodsId
                          , ObjectLink_PricePlanItem_GoodsKind.ChildObjectId AS GoodsKindId
                          , ObjectHistoryFloat_PricePlanItem_Value.ValueData AS ValuePrice
                          , ObjectHistory_PricePlanItem.StartDate
                          , ObjectHistory_PricePlanItem.EndDate
                     FROM ObjectLink AS ObjectLink_PricePlanItem_PriceList
                          LEFT JOIN ObjectLink AS ObjectLink_PricePlanItem_Goods
                                               ON ObjectLink_PricePlanItem_Goods.ObjectId = ObjectLink_PricePlanItem_PriceList.ObjectId
                                              AND ObjectLink_PricePlanItem_Goods.DescId   = zc_ObjectLink_PricePlanItem_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_PricePlanItem_GoodsKind
                                               ON ObjectLink_PricePlanItem_GoodsKind.ObjectId = ObjectLink_PricePlanItem_PriceList.ObjectId
                                              AND ObjectLink_PricePlanItem_GoodsKind.DescId   = zc_ObjectLink_PricePlanItem_GoodsKind()
                          LEFT JOIN ObjectHistory AS ObjectHistory_PricePlanItem
                                                  ON ObjectHistory_PricePlanItem.ObjectId = ObjectLink_PricePlanItem_PriceList.ObjectId
                                                 AND ObjectHistory_PricePlanItem.DescId   = zc_ObjectHistory_PricePlanItem()
                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PricePlanItem_Value
                                                       ON ObjectHistoryFloat_PricePlanItem_Value.ObjectHistoryId = ObjectHistory_PricePlanItem.Id
                                                      AND ObjectHistoryFloat_PricePlanItem_Value.DescId          = zc_ObjectHistoryFloat_PricePlanItem_Value()
  
                     WHERE ObjectLink_PricePlanItem_PriceList.DescId        = zc_ObjectLink_PricePlanItem_PriceList()
                       AND ObjectLink_PricePlanItem_PriceList.ChildObjectId = inPriceListId
                       AND ObjectHistory_PricePlanItem.EndDate              >= vbStartDate
                       AND ObjectHistory_PricePlanItem.StartDate            <= vbEndDate
                    )
       -- Результат
       SELECT tmp.GoodsId
            , tmp.GoodsKindId
            , tmp.StartDate
            , tmp.ValuePrice

       FROM (SELECT tmpItem_all.GoodsId, tmpItem_all.GoodsKindId, tmpItem_all.ValuePrice, tmpItem_all.StartDate
             FROM tmpItem_all
             WHERE tmpItem_all.StartDate >= vbStartDate
            UNION ALL
             SELECT tmpItem_all.GoodsId, tmpItem_all.GoodsKindId, tmpItem_all.ValuePrice, tmpItem_all.StartDate
             FROM tmpItem_all
                  LEFT JOIN tmpItem_all AS tmpItem_all_check ON tmpItem_all_check.GoodsId   = tmpItem_all.GoodsId
                                                            AND COALESCE (tmpItem_all_check.GoodsKindId,0) = COALESCE (tmpItem_all.GoodsKindId,0)
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
 28.11.19         * GoodsKind
 16.10.18         *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PricePlanItem_Period (2707438, '25.10.2018', zfCalc_UserAdmin())
