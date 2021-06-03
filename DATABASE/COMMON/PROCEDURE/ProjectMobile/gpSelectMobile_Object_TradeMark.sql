-- Function: gpSelectMobile_Object_TradeMark (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_TradeMark (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_TradeMark (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- Код
             , ValueData  TVarChar -- Название
             , isErased   Boolean  -- Удаленный ли элемент
             , isSync     Boolean  -- Синхронизируется (да/нет)
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
           RETURN QUERY
             -- Убрал - пусть выгружется ВСЕ
             /*WITH tmpTradeMark AS (SELECT DISTINCT ObjectLink_GoodsGroup_TradeMark.ChildObjectId AS TradeMarkId
                                   FROM (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId AS GoodsId
                                         FROM Object AS Object_GoodsByGoodsKind
                                              JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_Order
                                                                 ON ObjectBoolean_GoodsByGoodsKind_Order.ObjectId = Object_GoodsByGoodsKind.Id
                                                                AND ObjectBoolean_GoodsByGoodsKind_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order() 
                                                                AND ObjectBoolean_GoodsByGoodsKind_Order.ValueData = true
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
                                              JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                              ON ObjectLink_Partner_PersonalTrade.ObjectId = ObjectLink_GoodsListSale_Partner.ChildObjectId
                                                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                                             AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                         WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale()
                                        ) AS GG
                                        JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup 
                                                        ON ObjectLink_Goods_GoodsGroup.ObjectId = GG.GoodsId
                                                       AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup() 
                                                       AND ObjectLink_Goods_GoodsGroup.ChildObjectId IS NOT NULL
                                        JOIN ObjectLink AS ObjectLink_GoodsGroup_TradeMark
                                                        ON ObjectLink_GoodsGroup_TradeMark.ObjectId = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                       AND ObjectLink_GoodsGroup_TradeMark.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
                                                       AND ObjectLink_GoodsGroup_TradeMark.ChildObjectId IS NOT NULL
                                  )*/
             SELECT Object_TradeMark.Id
                  , Object_TradeMark.ObjectCode
                  , Object_TradeMark.ValueData
                  , Object_TradeMark.isErased
                  -- , NOT Object_TradeMark.isErased AS isSync
                  , TRUE AS isSync
             FROM Object AS Object_TradeMark
                  -- JOIN tmpTradeMark ON tmpTradeMark.TradeMarkId = Object_TradeMark.Id
             WHERE Object_TradeMark.DescId = zc_Object_TradeMark()
               AND Object_TradeMark.isErased = FALSE
           --LIMIT CASE WHEN vbUserId = 1072129 THEN 0 ELSE 500000 END
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
            ;  

      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 27.04.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_TradeMark(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
