-- Function: gpSelectMobile_Object_Goods (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Goods (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Goods (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id           Integer
             , ObjectCode   Integer  -- Код
             , ValueData    TVarChar -- Название
             , Weight       TFloat   -- Вес товара
             , Remains      TFloat   -- Остаток товара|для склада Object_Const.UnitId - по данным "последней"  синхронизации
             , Forecast     TFloat   -- Прогноз по поступлению - сколько прийдет на склад Object_Const.UnitId на основнии заказа или факта отгрузки на филиал - по данным "последней"  синхронизации
             , GoodsGroupId Integer  -- Группа товара
             , MeasureId    Integer  -- Единица измерения
             , isErased     Boolean  -- Удаленный ли элемент
             , isSync       Boolean  -- Синхронизируется (да/нет)
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
           IF inSyncDateIn > zc_DateZero()
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
                     , tmpGoodsListSale AS (SELECT ObjectLink_GoodsListSale_Goods.ChildObjectId AS GoodsId
                                                 , COUNT(ObjectLink_GoodsListSale_Goods.ChildObjectId) AS GoodsCount
                                            FROM Object AS Object_GoodsListSale
                                                 JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods 
                                                                 ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                                                AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                                                                AND ObjectLink_GoodsListSale_Goods.ChildObjectId IS NOT NULL
                                                 JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                                                 ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                                                AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                                                AND ObjectLink_GoodsListSale_Partner.ChildObjectId IS NOT NULL
                                                 JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = ObjectLink_GoodsListSale_Partner.ChildObjectId
                                                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                                                AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                            WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale()
                                            GROUP BY ObjectLink_GoodsListSale_Goods.ChildObjectId
                                           )
                  SELECT Object_Goods.Id
                       , Object_Goods.ObjectCode
                       , Object_Goods.ValueData
                       , ObjectFloat_Goods_Weight.ValueData AS Weight
                       , CAST(0.0 AS TFloat) AS Remains
                       , CAST(0.0 AS TFloat) AS Forecast
                       , ObjectLink_Goods_GoodsGroup.ChildObjectId AS GoodsGroupId
                       , ObjectLink_Goods_Measure.ChildObjectId    AS MeasureId
                       , Object_Goods.isErased
                       , EXISTS(SELECT 1 FROM tmpGoodsListSale WHERE tmpGoodsListSale.GoodsId = Object_Goods.Id) AS isSync
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
                  WHERE Object_Goods.DescId = zc_Object_Goods();
           ELSE
                RETURN QUERY
                  WITH tmpGoodsListSale AS (SELECT ObjectLink_GoodsListSale_Goods.ChildObjectId AS GoodsId
                                                 , COUNT(ObjectLink_GoodsListSale_Goods.ChildObjectId) AS GoodsCount
                                            FROM Object AS Object_GoodsListSale
                                                 JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods 
                                                                 ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                                                AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                                                                AND ObjectLink_GoodsListSale_Goods.ChildObjectId IS NOT NULL
                                                 JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                                                 ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                                                AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                                                AND ObjectLink_GoodsListSale_Partner.ChildObjectId IS NOT NULL
                                                 JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = ObjectLink_GoodsListSale_Partner.ChildObjectId
                                                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                                                AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                            WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale()
                                            GROUP BY ObjectLink_GoodsListSale_Goods.ChildObjectId
                                           )
                  SELECT Object_Goods.Id
                       , Object_Goods.ObjectCode
                       , Object_Goods.ValueData
                       , ObjectFloat_Goods_Weight.ValueData AS Weight
                       , CAST(0.0 AS TFloat) AS Remains
                       , CAST(0.0 AS TFloat) AS Forecast
                       , ObjectLink_Goods_GoodsGroup.ChildObjectId AS GoodsGroupId
                       , ObjectLink_Goods_Measure.ChildObjectId    AS MeasureId
                       , Object_Goods.isErased
                       , CAST(true AS Boolean) AS isSync
                  FROM Object AS Object_Goods
                       LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                             ON ObjectFloat_Goods_Weight.ObjectId = Object_Goods.Id
                                            AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight() 
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                            ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                           AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup() 
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                            ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure() 
                  WHERE Object_Goods.DescId = zc_Object_Goods()
                    AND EXISTS(SELECT 1 FROM tmpGoodsListSale WHERE tmpGoodsListSale.GoodsId = Object_Goods.Id);
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
-- SELECT * FROM gpSelectMobile_Object_Goods(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
