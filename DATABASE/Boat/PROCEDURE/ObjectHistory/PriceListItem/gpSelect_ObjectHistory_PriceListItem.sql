-- Function: gpSelect_ObjectHistory_PriceListItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListItem(
    IN inPriceListId        Integer   , -- ключ
    IN inOperDate           TDateTime , -- Дата действия
    IN inShowAll            Boolean,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer , ObjectId Integer
                , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                , isErased Boolean, GoodsGroupNameFull TVarChar
                , MeasureName TVarChar
                , StartDate TDateTime, EndDate TDateTime
                , ValuePrice   TFloat
                , PriceNoVAT   TFloat
                , PriceWVAT    TFloat
                , ValuePrice_min  TFloat
                , ValuePrice_max  TFloat
                , Diff_min        TFloat
                , Diff_max        TFloat
                , InsertName TVarChar, UpdateName TVarChar
                , InsertDate TDateTime, UpdateDate TDateTime
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbVATPercent TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- определяем период , цены за месяц
     vbStartDate := CASE WHEN inOperDate + INTERVAL '1 Day'  =  DATE_TRUNC ('MONTH', inOperDate + INTERVAL '1 Day') THEN DATE_TRUNC ('MONTH', inOperDate) ELSE inOperDate - INTERVAL '1 MONTH' END; --DATE_TRUNC ('MONTH', inOperDate);
     vbEndDate   := inOperDate ; --vbStartDate + INTERVAL '1 MONTH';

   -- Ограничение - если роль Бухгалтер ПАВИЛЬОНЫ
   /*IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 80548 AND UserId = vbUserId)
      AND COALESCE (inPriceListId, 0) NOT IN (140208 -- Пав-ны приход
                                            , 140209 -- Пав-ны продажа
                                             )
   THEN
       RAISE EXCEPTION 'Ошибка. Нет прав на Просмотр прайса <%>', lfGet_Object_ValueData (inPriceListId);
   END IF;
   */

     -- параметры прайс листа
     SELECT ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
          , ObjectFloat_VATPercent.ValueData     AS VATPercent
    INTO vbPriceWithVAT, vbVATPercent
     FROM ObjectBoolean AS ObjectBoolean_PriceWithVAT
          LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                ON ObjectFloat_VATPercent.ObjectId = ObjectBoolean_PriceWithVAT.ObjectId
                               AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
     WHERE ObjectBoolean_PriceWithVAT.ObjectId = inPriceListId
       AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT();


   IF inShowAll = TRUE THEN

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
   , tmpMinMax AS (SELECT tmp.GoodsId          AS GoodsId
                        , MIN (tmp.ValuePrice) AS ValuePrice_min
                        , MAX (tmp.ValuePrice) AS ValuePrice_max
                   FROM (SELECT tmpItem_all.GoodsId, tmpItem_all.ValuePrice
                         FROM tmpItem_all
                         WHERE tmpItem_all.StartDate >= vbStartDate
                        UNION ALL
                         SELECT tmpItem_all.GoodsId, tmpItem_all.ValuePrice
                         FROM tmpItem_all
                              LEFT JOIN tmpItem_all AS tmpItem_all_check ON tmpItem_all_check.GoodsId   = tmpItem_all.GoodsId
                                                                        AND tmpItem_all_check.StartDate = vbStartDate
                         WHERE tmpItem_all.StartDate < vbStartDate
                           AND tmpItem_all_check.GoodsId IS NULL
                        ) AS tmp
                   GROUP BY tmp.GoodsId
                  )

   , tmpPrice AS (SELECT ObjectHistory_PriceListItem.Id                   AS PriceListItemId
                       , ObjectHistory_PriceListItem.ObjectId             AS PriceListItemObjectId
                       , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId

                       , ObjectHistory_PriceListItem.StartDate
                       , ObjectHistory_PriceListItem.EndDate
                       , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice

                  FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                       LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                            ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                           AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                               ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                              AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                              AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                    ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                  WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                    AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                    AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
                    )

   , tmpData AS (-- сохраненные данные
                 SELECT COALESCE (tmpPrice.PriceListItemId,0)       AS PriceListItemId
                      , COALESCE (tmpPrice.PriceListItemObjectId,0) AS PriceListItemObjectId
                      , tmpPrice.GoodsId                            AS GoodsId
                      , COALESCE (tmpPrice.StartDate, NULL)  :: TDateTime AS StartDate
                      , COALESCE (tmpPrice.EndDate, NULL)    :: TDateTime AS EndDate
                      , COALESCE (tmpPrice.ValuePrice, 0)    :: TFloat    AS ValuePrice
                 FROM tmpPrice
                UNION
                 SELECT COALESCE (tmpPrice.PriceListItemId,0)       AS PriceListItemId
                      , COALESCE (tmpPrice.PriceListItemObjectId,0) AS PriceListItemObjectId
                      , Object_Goods.Id                             AS GoodsId
                      , COALESCE (tmpPrice.StartDate, NULL)  :: TDateTime AS StartDate
                      , COALESCE (tmpPrice.EndDate, NULL)    :: TDateTime AS EndDate
                      , COALESCE (tmpPrice.ValuePrice, 0)    :: TFloat    AS ValuePrice
                 FROM Object AS Object_Goods
                      LEFT JOIN tmpPrice ON tmpPrice.GoodsId = Object_Goods.Id
                 WHERE Object_Goods.DescId = zc_Object_Goods()
               )

       -- Результат
       SELECT
             tmpPrice.PriceListItemId       AS Id
           , tmpPrice.PriceListItemObjectId AS ObjectId
           , Object_Goods.Id                AS GoodsId     --ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , Object_Goods.isErased          AS isErased

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData       AS MeasureName

           , tmpPrice.StartDate
           , tmpPrice.EndDate
           , COALESCE (tmpPrice.ValuePrice, NULL) ::TFloat  AS ValuePrice
           
             -- расчет цены без НДС, до 2 знаков
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (COALESCE (tmpPrice.ValuePrice, 0) - COALESCE (tmpPrice.ValuePrice, 0) * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                  ELSE COALESCE (tmpPrice.ValuePrice, 0)
             END ::TFloat AS PriceNoVAT

             -- расчет цены с НДС, до 2 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((COALESCE (tmpPrice.ValuePrice, 0) + COALESCE (tmpPrice.ValuePrice, 0) * (vbVATPercent / 100)) AS NUMERIC (16, 2))
                  ELSE CAST (COALESCE (tmpPrice.ValuePrice, 0) AS NUMERIC (16, 2))
             END ::TFloat AS PriceWVAT

           , COALESCE (tmpMinMax.ValuePrice_min, 0) :: TFloat AS ValuePrice_min
           , COALESCE (tmpMinMax.ValuePrice_max, 0) :: TFloat AS ValuePrice_max

           , CAST (CASE WHEN tmpMinMax.ValuePrice_min > 0 AND tmpPrice.ValuePrice > 0
                             THEN 100 * (tmpPrice.ValuePrice - tmpMinMax.ValuePrice_min) / tmpMinMax.ValuePrice_min
                        WHEN COALESCE (tmpMinMax.ValuePrice_min, 0) = 0 AND tmpPrice.ValuePrice > 0
                             THEN 100
                        ELSE 0
                   END  AS NUMERIC (16,0))  :: TFloat AS Diff_min

           , CAST (CASE WHEN tmpMinMax.ValuePrice_min > 0 AND tmpMinMax.ValuePrice_max > 0
                             THEN 100 * (tmpMinMax.ValuePrice_max - tmpMinMax.ValuePrice_min) / tmpMinMax.ValuePrice_min
                        WHEN COALESCE (tmpMinMax.ValuePrice_min, 0) = 0 AND tmpMinMax.ValuePrice_max > 0
                             THEN 100
                        ELSE 0
                   END  AS NUMERIC (16,0)) :: TFloat AS Diff_max

           , Object_Insert.ValueData   AS InsertName
           , Object_Update.ValueData   AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate
           --
       FROM tmpData AS tmpPrice
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpPrice.GoodsId
          
          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                               ON ObjectDate_Protocol_Insert.ObjectId = tmpPrice.PriceListItemObjectId
                              AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = tmpPrice.PriceListItemObjectId
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = tmpPrice.PriceListItemObjectId
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = tmpPrice.PriceListItemObjectId
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

          LEFT JOIN tmpMinMax ON tmpMinMax.GoodsId = Object_Goods.Id

       WHERE Object_Goods.DescId = zc_Object_Goods()
       ;

   ELSE

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
   , tmpMinMax AS (SELECT tmp.GoodsId
                        , MIN (tmp.ValuePrice) AS ValuePrice_min
                        , MAX (tmp.ValuePrice) AS ValuePrice_max
                   FROM (SELECT tmpItem_all.GoodsId, tmpItem_all.ValuePrice
                         FROM tmpItem_all
                         WHERE tmpItem_all.StartDate >= vbStartDate
                        UNION ALL
                         SELECT tmpItem_all.GoodsId, tmpItem_all.ValuePrice
                         FROM tmpItem_all
                              LEFT JOIN tmpItem_all AS tmpItem_all_check ON tmpItem_all_check.GoodsId = tmpItem_all.GoodsId
                                                                        AND tmpItem_all_check.StartDate = vbStartDate
                         WHERE tmpItem_all.StartDate < vbStartDate
                           AND tmpItem_all_check.GoodsId IS NULL
                        ) AS tmp
                   GROUP BY tmp.GoodsId
                  )

       -- Результат
       SELECT
             ObjectHistory_PriceListItem.Id
           , ObjectHistory_PriceListItem.ObjectId
           , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName
           , Object_Goods.isErased   AS isErased

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData     AS MeasureName

           , ObjectHistory_PriceListItem.StartDate
           , ObjectHistory_PriceListItem.EndDate
           , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice

             -- расчет цены без НДС, до 2 знаков
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (ObjectHistoryFloat_PriceListItem_Value.ValueData - ObjectHistoryFloat_PriceListItem_Value.ValueData * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                  ELSE ObjectHistoryFloat_PriceListItem_Value.ValueData
             END ::TFloat AS PriceNoVAT

             -- расчет цены с НДС, до 2 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((ObjectHistoryFloat_PriceListItem_Value.ValueData + ObjectHistoryFloat_PriceListItem_Value.ValueData * (vbVATPercent / 100)) AS NUMERIC (16, 2))
                  ELSE CAST (ObjectHistoryFloat_PriceListItem_Value.ValueData AS NUMERIC (16, 2))
             END ::TFloat AS PriceWVAT

           , COALESCE (tmpMinMax.ValuePrice_min, 0) :: TFloat AS ValuePrice_min
           , COALESCE (tmpMinMax.ValuePrice_max, 0) :: TFloat AS ValuePrice_max

           , CAST (CASE WHEN tmpMinMax.ValuePrice_min > 0 AND ObjectHistoryFloat_PriceListItem_Value.ValueData > 0
                             THEN 100 * (ObjectHistoryFloat_PriceListItem_Value.ValueData - tmpMinMax.ValuePrice_min) / tmpMinMax.ValuePrice_min
                        WHEN COALESCE (tmpMinMax.ValuePrice_min, 0) = 0 AND ObjectHistoryFloat_PriceListItem_Value.ValueData > 0
                             THEN 100
                        ELSE 0
                   END  AS NUMERIC (16,0))  :: TFloat AS Diff_min

           , CAST (CASE WHEN tmpMinMax.ValuePrice_min > 0 AND tmpMinMax.ValuePrice_max > 0
                             THEN 100 * (tmpMinMax.ValuePrice_max - tmpMinMax.ValuePrice_min) / tmpMinMax.ValuePrice_min
                        WHEN COALESCE (tmpMinMax.ValuePrice_min, 0) = 0 AND tmpMinMax.ValuePrice_max > 0
                             THEN 100
                        ELSE 0
                   END  AS NUMERIC (16,0)) :: TFloat AS Diff_max

           , Object_Insert.ValueData   AS InsertName
           , Object_Update.ValueData   AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_PriceListItem_Goods.ChildObjectId

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                   AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                             ON ObjectDate_Protocol_Insert.ObjectId = ObjectHistory_PriceListItem.ObjectId
                            AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                             ON ObjectDate_Protocol_Update.ObjectId = ObjectHistory_PriceListItem.ObjectId
                            AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = ObjectHistory_PriceListItem.ObjectId
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = ObjectHistory_PriceListItem.ObjectId
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

          LEFT JOIN tmpMinMax ON tmpMinMax.GoodsId = ObjectLink_PriceListItem_Goods.ChildObjectId

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
       ;
  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.20         *
 27.11.19         * GoodsKind
 22.10.18         *
 20.08.15         * add inShowAll
 25.07.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP, FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem (zc_PriceList_Basis(), CURRENT_TIMESTAMP, FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem (zc_PriceList_ProductionSeparateHist() , CURRENT_TIMESTAMP, true, inSession:= zfCalc_UserAdmin())
--where goodsid =  2131


