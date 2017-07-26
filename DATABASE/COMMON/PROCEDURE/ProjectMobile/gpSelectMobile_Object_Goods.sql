-- Function: gpSelectMobile_Object_Goods (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Goods (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Goods (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , ObjectCode    Integer  -- Код
             , ValueData     TVarChar -- Название
             , Weight        TFloat   -- Вес товара
             , GoodsGroupId  Integer  -- Группа товара
             , MeasureId     Integer  -- Единица измерения
             , TradeMarkId   Integer  -- Торговая марка
             , isErased      Boolean  -- Удаленный ли элемент
             , isSync        Boolean  -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL
      THEN
           CREATE TEMP TABLE tmpPartner ON COMMIT DROP
           AS (SELECT OP.Id AS PartnerId FROM lfSelectMobile_Object_Partner (inIsErased:= FALSE, inSession:= inSession) AS OP);

           CREATE TEMP TABLE tmpGoods ON COMMIT DROP
           AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId AS GoodsId
               FROM Object AS Object_GoodsByGoodsKind
                    JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_Order
                                       ON ObjectBoolean_GoodsByGoodsKind_Order.ObjectId  = Object_GoodsByGoodsKind.Id
                                      AND ObjectBoolean_GoodsByGoodsKind_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order() 
                                      AND ObjectBoolean_GoodsByGoodsKind_Order.ValueData = TRUE
                    JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                    ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object_GoodsByGoodsKind.Id
                                   AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                   AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId IS NOT NULL
               WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind()
              UNION
               SELECT ObjectLink_GoodsListSale_Goods.ChildObjectId AS GoodsId
               FROM Object AS Object_GoodsListSale
                    JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods 
                                    ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                   AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                                   AND ObjectLink_GoodsListSale_Goods.ChildObjectId IS NOT NULL
                    JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                    ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                   AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                   AND ObjectLink_GoodsListSale_Partner.ChildObjectId IS NOT NULL
                    JOIN tmpPartner ON tmpPartner.PartnerId = ObjectLink_GoodsListSale_Partner.ChildObjectId
               WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale()
              );
           
           IF inSyncDateIn > zc_DateStart() AND 1 = 0 -- пока отключим ограничение по времени
           THEN
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS GoodsId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                       FROM ObjectProtocol
                                            JOIN Object AS Object_Goods
                                                        ON Object_Goods.Id = ObjectProtocol.ObjectId
                                                       AND Object_Goods.DescId = zc_Object_Goods() 
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       GROUP BY ObjectProtocol.ObjectId
                                      )
                  SELECT Object_Goods.Id
                       , Object_Goods.ObjectCode
                       , Object_Goods.ValueData
                       , ObjectFloat_Goods_Weight.ValueData            AS Weight
                       , ObjectLink_Goods_GoodsGroup.ChildObjectId     AS GoodsGroupId
                       , ObjectLink_Goods_Measure.ChildObjectId        AS MeasureId
                       , ObjectLink_GoodsGroup_TradeMark.ChildObjectId AS TradeMarkId
                       , Object_Goods.isErased
                       , EXISTS(SELECT 1 FROM tmpGoods WHERE tmpGoods.GoodsId = Object_Goods.Id) AS isSync
                  FROM Object AS Object_Goods
                       JOIN tmpProtocol ON tmpProtocol.GoodsId = Object_Goods.Id
                       LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                             ON ObjectFloat_Goods_Weight.ObjectId = Object_Goods.Id
                                            AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight() 
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                            ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                           AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup() 
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                            ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure() 
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_TradeMark
                                            ON ObjectLink_GoodsGroup_TradeMark.ObjectId = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                           AND ObjectLink_GoodsGroup_TradeMark.DescId = zc_ObjectLink_GoodsGroup_TradeMark() 
                  WHERE Object_Goods.DescId = zc_Object_Goods();
           ELSE
                RETURN QUERY
                  SELECT Object_Goods.Id
                       , Object_Goods.ObjectCode
                       , Object_Goods.ValueData
                       , ObjectFloat_Goods_Weight.ValueData            AS Weight
                       , ObjectLink_Goods_GoodsGroup.ChildObjectId     AS GoodsGroupId
                       , ObjectLink_Goods_Measure.ChildObjectId        AS MeasureId
                       , ObjectLink_GoodsGroup_TradeMark.ChildObjectId AS TradeMarkId
                       , Object_Goods.isErased
                       , CAST(true AS Boolean) AS isSync
                  FROM Object AS Object_Goods
                       JOIN tmpGoods ON tmpGoods.GoodsId = Object_Goods.Id
                       LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                             ON ObjectFloat_Goods_Weight.ObjectId = Object_Goods.Id
                                            AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight() 
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                            ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                           AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup() 
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                            ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure() 
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_TradeMark
                                            ON ObjectLink_GoodsGroup_TradeMark.ObjectId = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                           AND ObjectLink_GoodsGroup_TradeMark.DescId = zc_ObjectLink_GoodsGroup_TradeMark() 
                  WHERE Object_Goods.DescId = zc_Object_Goods();
           END IF;
      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_Goods(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
