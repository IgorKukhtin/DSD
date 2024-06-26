-- Function: gpSelect_ObjectHistory_PriceListItem_Print ()


DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem_Print (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListItem_Print(
    IN inPriceListId        Integer   , -- ключ
    IN inOperDate           TDateTime , -- Дата действия
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer , ObjectId Integer
                , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsGroupNameFull TVarChar
                , TradeMarkName TVarChar
                , MeasureName TVarChar
                , ValuePrice TFloat, ValuePriceWithVAT TFloat
                , ValuePrice_kg TFloat, ValuePriceWithVAT_kg TFloat
                , Weight TFloat
                , Value1 TVarChar, Value2_4 TVarChar, Value5_6 TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT_pl Boolean;
   DECLARE vbVATPercent_pl TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Определили
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = inPriceListId AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- Определили
     vbVATPercent_pl:= (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPriceListId AND ObjectFloat.DescId = zc_ObjectFloat_PriceList_VATPercent());


     -- Ограничение - если роль Бухгалтер ПАВИЛЬОНЫ
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 80548 AND UserId = vbUserId)
        AND COALESCE (inPriceListId, 0) NOT IN (140208 -- Пав-ны приход
                                              , 140209 -- Пав-ны продажа
                                               )
     THEN
         RAISE EXCEPTION 'Ошибка. Нет прав на Просмотр прайса <%>', lfGet_Object_ValueData (inPriceListId);
     END IF;


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


     -- Выбираем данные
     RETURN QUERY
       SELECT
             ObjectHistory_PriceListItem.Id
           , ObjectHistory_PriceListItem.ObjectId

           , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName
           
           , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_TradeMark.ValueData      AS TradeMarkName
           , Object_Measure.ValueData        AS MeasureName

           , CASE WHEN vbPriceWithVAT_pl = TRUE THEN COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) / (1 + vbVATPercent_pl / 100) ELSE COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) END :: TFloat  AS ValuePrice
           , CASE WHEN vbPriceWithVAT_pl = FALSE THEN COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) * (1 + vbVATPercent_pl / 100) ELSE COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) END :: TFloat AS ValuePriceWithVAT

           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData<>0
                     THEN (CASE WHEN vbPriceWithVAT_pl = TRUE THEN COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) / (1 + vbVATPercent_pl / 100) ELSE COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) END) / ObjectFloat_Weight.ValueData
                     ELSE (CASE WHEN vbPriceWithVAT_pl = TRUE THEN COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) / (1 + vbVATPercent_pl / 100) ELSE COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) END)
             END   :: TFloat AS ValuePrice_kg
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData<>0
                     THEN (CASE WHEN vbPriceWithVAT_pl = FALSE THEN COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) * (1 + vbVATPercent_pl / 100) ELSE COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) END) / ObjectFloat_Weight.ValueData
                     ELSE (CASE WHEN vbPriceWithVAT_pl = FALSE THEN COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) * (1 + vbVATPercent_pl / 100) ELSE COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) END)
             END   :: TFloat AS ValuePriceWithVAT_kg

           , ObjectFloat_Weight.ValueData AS Weight
           , ObjectString_Value1.ValueData AS Value1
           , (COALESCE (ObjectString_Value2.ValueData,'')||' / '||COALESCE (ObjectString_Value4.ValueData,'') )::  TVarChar AS Value2_4
           , (COALESCE (ObjectString_Value5.ValueData,'')||' / '||COALESCE (ObjectString_Value6.ValueData,'') )::  TVarChar AS Value5_6


       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList


            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
            LEFT JOIN Object AS Object_Goods
                             ON Object_Goods.Id = ObjectLink_PriceListItem_Goods.ChildObjectId

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

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

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


       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 ) --OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
         AND Object_Goods.isErased = FAlSE
       ;

   END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.19         * add zc_ObjectLink_PriceListItem_GoodsKind
 03.12.15         *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem_Print (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem_Print (zc_PriceList_Basis(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
