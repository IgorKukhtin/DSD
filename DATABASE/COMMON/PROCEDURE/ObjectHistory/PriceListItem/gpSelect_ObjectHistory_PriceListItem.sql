-- Function: gpSelect_ObjectHistory_PriceListItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem (Integer, TDateTime);
DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListItem(
    IN inPriceListId        Integer   , -- ключ
    IN inOperDate           TDateTime , -- Дата действия
    IN inShowAll            Boolean,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer , ObjectId Integer
                , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                , GoodsKindId Integer, GoodsKindName TVarChar
                , isErased Boolean, GoodsGroupNameFull TVarChar
                , MeasureName TVarChar
                , TradeMarkName TVarChar
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

                , ValuePrice_kg TFloat, ValuePriceWithVAT_kg TFloat
                , Weight TFloat
                , Value1 TVarChar, Value2_4 TVarChar, Value5_6 TVarChar

                , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar
                , InfoMoneyDestinationName TVarChar
                , InfoMoneyName TVarChar, InfoMoneyId Integer
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
   END IF;*/


   -- Ограничение - если роль Начисления транспорт-меню
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 78489 AND UserId = vbUserId)
      AND NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
      AND COALESCE (inPriceListId, 0) NOT IN (SELECT zc_PriceList_Fuel()
                                             UNION
                                              SELECT DISTINCT ObjectLink_Contract_PriceList.ChildObjectId
                                              FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                                                   INNER JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                                                         ON ObjectLink_Contract_PriceList.ObjectId      = ObjectLink_Contract_InfoMoney.ObjectId
                                                                        AND ObjectLink_Contract_PriceList.DescId        = zc_ObjectLink_Contract_PriceList()
                                                                        AND ObjectLink_Contract_PriceList.ChildObjectId > 0
                                              WHERE ObjectLink_Contract_InfoMoney.DescId        = zc_ObjectLink_Contract_InfoMoney()
                                                AND ObjectLink_Contract_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20401() -- ГСМ
                                             UNION
                                              SELECT DISTINCT ObjectLink_Juridical_PriceList.ChildObjectId
                                              FROM ObjectLink AS ObjectLink_CardFuel_Juridical
                                                   INNER JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                                                         ON ObjectLink_Juridical_PriceList.ObjectId      = ObjectLink_CardFuel_Juridical.ObjectId
                                                                        AND ObjectLink_Juridical_PriceList.DescId        = zc_ObjectLink_Juridical_PriceList()
                                                                        AND ObjectLink_Juridical_PriceList.ChildObjectId > 0
                                              WHERE ObjectLink_CardFuel_Juridical.ObjectId > 0
                                                AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
                                             )
   THEN
       RAISE EXCEPTION 'Ошибка. Нет прав на Просмотр прайса <%>', lfGet_Object_ValueData (inPriceListId);
   END IF;

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
                          , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                          , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                          , ObjectHistory_PriceListItem.StartDate
                          , ObjectHistory_PriceListItem.EndDate
                     FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                          LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                               ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                              AND ObjectLink_PriceListItem_Goods.DescId   = zc_ObjectLink_PriceListItem_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                               ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                              AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()
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
                        , tmp.GoodsKindId      AS GoodsKindId
                        , MIN (tmp.ValuePrice) AS ValuePrice_min
                        , MAX (tmp.ValuePrice) AS ValuePrice_max
                   FROM (SELECT tmpItem_all.GoodsId, tmpItem_all.GoodsKindId, tmpItem_all.ValuePrice
                         FROM tmpItem_all
                         WHERE tmpItem_all.StartDate >= vbStartDate
                        UNION ALL
                         SELECT tmpItem_all.GoodsId, tmpItem_all.GoodsKindId, tmpItem_all.ValuePrice
                         FROM tmpItem_all
                              LEFT JOIN tmpItem_all AS tmpItem_all_check ON tmpItem_all_check.GoodsId   = tmpItem_all.GoodsId
                                                                        AND tmpItem_all_check.GoodsKindId = tmpItem_all.GoodsKindId
                                                                        AND tmpItem_all_check.StartDate = vbStartDate
                         WHERE tmpItem_all.StartDate < vbStartDate
                           AND tmpItem_all_check.GoodsId IS NULL
                        ) AS tmp
                   GROUP BY tmp.GoodsId
                          , tmp.GoodsKindId
                  )

   , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                  , Object_GoodsByGoodsKind_View.GoodsKindId
                             FROM Object_GoodsByGoodsKind_View
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Order ON ObjectBoolean_Order.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                                               AND ObjectBoolean_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_ScaleCeh ON ObjectBoolean_ScaleCeh.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                                                   AND ObjectBoolean_ScaleCeh.DescId   = zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh()
                             WHERE ObjectBoolean_Order.ValueData    = TRUE
                               AND ObjectBoolean_ScaleCeh.ValueData = TRUE
                            )

   , tmpPrice AS (SELECT ObjectHistory_PriceListItem.Id                   AS PriceListItemId
                       , ObjectHistory_PriceListItem.ObjectId             AS PriceListItemObjectId
                       , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                       , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId

                       , ObjectHistory_PriceListItem.StartDate
                       , ObjectHistory_PriceListItem.EndDate
                       , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice

                  FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                       LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                            ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                           AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

                       LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                            ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                           AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

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
                      , tmpGoodsByGoodsKind.GoodsId                       AS GoodsId
                      , tmpGoodsByGoodsKind.GoodsKindId                   AS GoodsKindId
                      , COALESCE (tmpPrice.StartDate, NULL)  :: TDateTime AS StartDate
                      , COALESCE (tmpPrice.EndDate, NULL)    :: TDateTime AS EndDate
                      , COALESCE (tmpPrice.ValuePrice, 0)    :: TFloat    AS ValuePrice
                 FROM tmpGoodsByGoodsKind
                      LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoodsByGoodsKind.GoodsId
                                        AND COALESCE (tmpPrice.GoodsKindId,0) = COALESCE (tmpGoodsByGoodsKind.GoodsKindId,0)
                UNION
                 SELECT COALESCE (tmpPrice.PriceListItemId,0)       AS PriceListItemId
                      , COALESCE (tmpPrice.PriceListItemObjectId,0) AS PriceListItemObjectId
                      , Object_Goods.Id                             AS GoodsId
                      , NULL                                        AS GoodsKindId
                      , COALESCE (tmpPrice.StartDate, NULL)  :: TDateTime AS StartDate
                      , COALESCE (tmpPrice.EndDate, NULL)    :: TDateTime AS EndDate
                      , COALESCE (tmpPrice.ValuePrice, 0)    :: TFloat    AS ValuePrice
                 FROM Object AS Object_Goods
                      LEFT JOIN tmpPrice ON tmpPrice.GoodsId = Object_Goods.Id
                                        AND tmpPrice.GoodsKindId IS NULL
                 WHERE Object_Goods.DescId = zc_Object_Goods()
               )

       -- Результат
       SELECT
             tmpPrice.PriceListItemId       AS Id
           , tmpPrice.PriceListItemObjectId AS ObjectId
           , Object_Goods.Id                AS GoodsId     --ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , Object_GoodsKind.Id            AS GoodsKindId
           , Object_GoodsKind.ValueData     AS GoodsKindName
           , Object_Goods.isErased          AS isErased

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData     AS MeasureName
           , Object_TradeMark.ValueData   AS TradeMarkName

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
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData<>0
                     THEN (CASE WHEN vbPriceWithVAT = TRUE THEN COALESCE (tmpPrice.ValuePrice, 0) / (1 + vbVATPercent / 100) ELSE COALESCE (tmpPrice.ValuePrice, 0) END) / ObjectFloat_Weight.ValueData
                     ELSE (CASE WHEN vbPriceWithVAT = TRUE THEN COALESCE (tmpPrice.ValuePrice, 0) / (1 + vbVATPercent / 100) ELSE COALESCE (tmpPrice.ValuePrice, 0) END)
             END   :: TFloat AS ValuePrice_kg
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData<>0
                     THEN (CASE WHEN vbPriceWithVAT = FALSE THEN COALESCE (tmpPrice.ValuePrice, 0) * (1 + vbVATPercent / 100) ELSE COALESCE (tmpPrice.ValuePrice, 0) END) / ObjectFloat_Weight.ValueData
                     ELSE (CASE WHEN vbPriceWithVAT = FALSE THEN COALESCE (tmpPrice.ValuePrice, 0) * (1 + vbVATPercent / 100) ELSE COALESCE (tmpPrice.ValuePrice, 0) END)
             END   :: TFloat AS ValuePriceWithVAT_kg

           , ObjectFloat_Weight.ValueData AS Weight
           , ObjectString_Value1.ValueData AS Value1
           , (COALESCE (ObjectString_Value2.ValueData,'')||' / '||COALESCE (ObjectString_Value4.ValueData,'') )::  TVarChar AS Value2_4
           , (COALESCE (ObjectString_Value5.ValueData,'')||' / '||COALESCE (ObjectString_Value6.ValueData,'') )::  TVarChar AS Value5_6

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyId
       FROM tmpData AS tmpPrice
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpPrice.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpPrice.GoodsKindId
          
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
                             AND tmpMinMax.GoodsId = Object_GoodsKind.Id

          --
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS GoodsQuality_Goods
                               ON GoodsQuality_Goods.ChildObjectId = Object_Goods.Id
                              AND GoodsQuality_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()
          LEFT JOIN ObjectString AS ObjectString_Value1							-- Вид упаковки
                                 ON ObjectString_Value1.ObjectId = GoodsQuality_Goods.ObjectId
                                AND ObjectString_Value1.DescId = zc_ObjectString_GoodsQuality_Value1()
          LEFT JOIN ObjectString AS ObjectString_Value2							-- Термін зберігання
                                 ON ObjectString_Value2.ObjectId = GoodsQuality_Goods.ObjectId
                                AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
          LEFT JOIN ObjectString AS ObjectString_Value4							-- Термін зберігання в газ.середовищ, №8
                                 ON ObjectString_Value4.ObjectId = GoodsQuality_Goods.ObjectId
                                AND ObjectString_Value4.DescId = zc_ObjectString_GoodsQuality_Value4()
          LEFT JOIN ObjectString AS ObjectString_Value5							-- Вакуумна упаковка - Термін зберігання цілим виробом, №10
                                 ON ObjectString_Value5.ObjectId = GoodsQuality_Goods.ObjectId
                                AND ObjectString_Value5.DescId = zc_ObjectString_GoodsQuality_Value5()
          LEFT JOIN ObjectString AS ObjectString_Value6							-- Вакуумна упаковка - Термін зберігання порційна нарізка, №11
                                 ON ObjectString_Value6.ObjectId = GoodsQuality_Goods.ObjectId
                                AND ObjectString_Value6.DescId = zc_ObjectString_GoodsQuality_Value6()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

       WHERE Object_Goods.DescId = zc_Object_Goods()

       ;

   ELSE

     -- Выбираем данные
     RETURN QUERY
     WITH
     tmpItem_all AS (SELECT ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                          , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                          , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                          , ObjectHistory_PriceListItem.StartDate
                          , ObjectHistory_PriceListItem.EndDate
                     FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                          LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                               ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                              AND ObjectLink_PriceListItem_Goods.DescId   = zc_ObjectLink_PriceListItem_Goods()

                          LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                               ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                              AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

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
                        , tmp.GoodsKindId
                        , MIN (tmp.ValuePrice) AS ValuePrice_min
                        , MAX (tmp.ValuePrice) AS ValuePrice_max
                   FROM (SELECT tmpItem_all.GoodsId, tmpItem_all.GoodsKindId, tmpItem_all.ValuePrice
                         FROM tmpItem_all
                         WHERE tmpItem_all.StartDate >= vbStartDate
                        UNION ALL
                         SELECT tmpItem_all.GoodsId, tmpItem_all.GoodsKindId, tmpItem_all.ValuePrice
                         FROM tmpItem_all
                              LEFT JOIN tmpItem_all AS tmpItem_all_check ON tmpItem_all_check.GoodsId = tmpItem_all.GoodsId
                                                                        AND tmpItem_all_check.GoodsKindId   = tmpItem_all.GoodsKindId
                                                                        AND tmpItem_all_check.StartDate = vbStartDate
                         WHERE tmpItem_all.StartDate < vbStartDate
                           AND tmpItem_all_check.GoodsId IS NULL
                        ) AS tmp
                   GROUP BY tmp.GoodsId
                          , tmp.GoodsKindId
                  )

       -- Результат
       SELECT
             ObjectHistory_PriceListItem.Id
           , ObjectHistory_PriceListItem.ObjectId
           , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Goods.isErased   AS isErased

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData     AS MeasureName
           , Object_TradeMark.ValueData   AS TradeMarkName

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

           --
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData<>0
                     THEN (CASE WHEN vbPriceWithVAT = TRUE THEN COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) / (1 + vbVATPercent / 100) ELSE COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) END) / ObjectFloat_Weight.ValueData
                     ELSE (CASE WHEN vbPriceWithVAT = TRUE THEN COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) / (1 + vbVATPercent / 100) ELSE COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) END)
             END   :: TFloat AS ValuePrice_kg
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData<>0
                     THEN (CASE WHEN vbPriceWithVAT = FALSE THEN COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) * (1 + vbVATPercent / 100) ELSE COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) END) / ObjectFloat_Weight.ValueData
                     ELSE (CASE WHEN vbPriceWithVAT = FALSE THEN COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) * (1 + vbVATPercent / 100) ELSE COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) END)
             END   :: TFloat AS ValuePriceWithVAT_kg

           , ObjectFloat_Weight.ValueData AS Weight
           , ObjectString_Value1.ValueData AS Value1
           , (COALESCE (ObjectString_Value2.ValueData,'')||' / '||COALESCE (ObjectString_Value4.ValueData,'') )::  TVarChar AS Value2_4
           , (COALESCE (ObjectString_Value5.ValueData,'')||' / '||COALESCE (ObjectString_Value6.ValueData,'') )::  TVarChar AS Value5_6

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyId

       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_PriceListItem_Goods.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                 ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_PriceListItem_GoodsKind.ChildObjectId

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
                             AND COALESCE (tmpMinMax.GoodsKindId,0) = COALESCE (ObjectLink_PriceListItem_GoodsKind.ChildObjectId,0)

          --
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS GoodsQuality_Goods
                               ON GoodsQuality_Goods.ChildObjectId = Object_Goods.Id
                              AND GoodsQuality_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()
          LEFT JOIN ObjectString AS ObjectString_Value1							-- Вид упаковки
                                 ON ObjectString_Value1.ObjectId = GoodsQuality_Goods.ObjectId
                                AND ObjectString_Value1.DescId = zc_ObjectString_GoodsQuality_Value1()
          LEFT JOIN ObjectString AS ObjectString_Value2							-- Термін зберігання
                                 ON ObjectString_Value2.ObjectId = GoodsQuality_Goods.ObjectId
                                AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
          LEFT JOIN ObjectString AS ObjectString_Value4							-- Термін зберігання в газ.середовищ, №8
                                 ON ObjectString_Value4.ObjectId = GoodsQuality_Goods.ObjectId
                                AND ObjectString_Value4.DescId = zc_ObjectString_GoodsQuality_Value4()
          LEFT JOIN ObjectString AS ObjectString_Value5							-- Вакуумна упаковка - Термін зберігання цілим виробом, №10
                                 ON ObjectString_Value5.ObjectId = GoodsQuality_Goods.ObjectId
                                AND ObjectString_Value5.DescId = zc_ObjectString_GoodsQuality_Value5()
          LEFT JOIN ObjectString AS ObjectString_Value6							-- Вакуумна упаковка - Термін зберігання порційна нарізка, №11
                                 ON ObjectString_Value6.ObjectId = GoodsQuality_Goods.ObjectId
                                AND ObjectString_Value6.DescId = zc_ObjectString_GoodsQuality_Value6()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
       ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ObjectHistory_PriceListItem (Integer, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.05.21         * InfoMoney
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


