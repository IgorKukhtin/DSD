-- Function: gpSelect_Object_PriceItems_effie

DROP FUNCTION IF EXISTS gpSelect_Object_PriceItems_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceItems_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (extId            TVarChar   -- Идентификатор строки прайса (необходим для того, чтобы можно было поменять цену по товару по этому идентификатору при новой загрузке данных)
             , priceHeaderExtId TVarChar   -- Идентификатор прайса
             , productExtId     TVarChar   -- Идентификатор товара
             , price            TVarChar   -- Цена
             , isDeleted        Boolean    -- Признак активности
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- временная таблица PriceListItem
     CREATE TEMP TABLE _tmpResult (GoodsByGoodsKindId Integer, GoodsId Integer, GoodsKindId Integer, PriceListId Integer, Price TFloat)  ON COMMIT DROP;
     
     INSERT INTO _tmpResult (GoodsByGoodsKindId, GoodsId, GoodsKindId, PriceListId, Price) 
     WITH
     tmpGoodsByGoodsKind AS (SELECT DISTINCT
                                    ObjectLink_GoodsByGoodsKind_Goods.ObjectId                        AS GoodsByGoodsKindId
                                  , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   AS GoodsId
                                  , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                             FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                       ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                      AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                  INNER JOIN ObjectBoolean AS ObjectBoolean_Order
                                                           ON ObjectBoolean_Order.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                          AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                                          AND COALESCE (ObjectBoolean_Order.ValueData, FALSE) = TRUE                
                                  INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                        ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()                                                       
                                                       AND ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30101() -- Готовая продукция
                             WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                             --LIMIT 2
                             )
          
   , tmpPrice AS (SELECT DISTINCT 
                         ObjectLink_PriceListItem_PriceList.ChildObjectId AS PriceListId
                       , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                       , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                       , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                      
                  FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                       INNER JOIN Object AS Object_PriceList 
                                         ON Object_PriceList.Id = ObjectLink_PriceListItem_PriceList.ChildObjectId
                                        AND Object_PriceList.IsErased = FALSE

                       LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                            ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                           AND ObjectLink_PriceListItem_Goods.DescId   = zc_ObjectLink_PriceListItem_Goods()

                       INNER JOIN (SELECT DISTINCT tmpGoodsByGoodsKind.GoodsId FROM tmpGoodsByGoodsKind) AS tmp ON tmp.GoodsId = ObjectLink_PriceListItem_Goods.ChildObjectId
                                                 --    AND tmpGoodsByGoodsKind.GoodsKindId = ObjectLink_PriceListItem_GoodsKind.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                            ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                           AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

                       INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                               ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                              AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                      
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                    ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
 
                  WHERE ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                    AND ObjectHistory_PriceListItem.EndDate              > CURRENT_DATE
                    AND ObjectHistory_PriceListItem.StartDate            <= CURRENT_DATE
                    )
     -- 
     SELECT tmpGoods.GoodsByGoodsKindId
          , tmpGoods.GoodsId
          , tmpGoods.GoodsKindId
          , COALESCE (tmpPrice_GoodsKind.PriceListId, tmpPrice_Basis.PriceListId,tmpPrice.PriceListId, 0)           AS PriceListId
          , COALESCE (tmpPrice_GoodsKind.ValuePrice, tmpPrice_Basis.ValuePrice, tmpPrice.ValuePrice, 0)    ::TFloat AS Price
     FROM tmpGoodsByGoodsKind AS tmpGoods
         -- связь товар + вид товара 
         LEFT JOIN tmpPrice AS tmpPrice_GoodsKind
                            ON tmpPrice_GoodsKind.GoodsId = tmpGoods.GoodsId
                           AND tmpPrice_GoodsKind.GoodsKindId = tmpGoods.GoodsKindId -- and 1 = 0

        -- связь товар + вид товара  или вид товара вес 
         LEFT JOIN tmpPrice AS tmpPrice_Basis
                            ON tmpPrice_Basis.GoodsId = tmpGoods.GoodsId
                           AND tmpPrice_Basis.GoodsKindId = zc_GoodsKind_Basis()  -- and 1 = 0
                           AND tmpPrice_GoodsKind.PriceListId IS NULL

         -- связь товар + вид товара пусто
         LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                           AND tmpPrice.GoodsKindId IS NULL
                           AND (tmpPrice_Basis.PriceListId IS NULL
                                AND tmpPrice_GoodsKind.PriceListId IS NULL)      --and 1 = 0
     ;

     --нужно записать в таблица Object_PriceListItem_effie.Id - по ключу Това+Вид+Прайс  те элементы , которых нет
     INSERT INTO Object_PriceListItem_effie (PriceListId, GoodsId, GoodsKindId, InsertDate)
     SELECT _tmpResult.PriceListId
          , _tmpResult.GoodsId
          , _tmpResult.GoodsKindId
          , CURRENT_TIMESTAMP AS InsertDate
     FROM _tmpResult
          LEFT JOIN Object_PriceListItem_effie ON Object_PriceListItem_effie.PriceListId = _tmpResult.PriceListId
                                              AND Object_PriceListItem_effie.GoodsId     = _tmpResult.GoodsId
                                              AND Object_PriceListItem_effie.GoodsKindId = _tmpResult.GoodsKindId
     WHERE Object_PriceListItem_effie.Id IS NULL;
 
      

     -- Результат
     RETURN QUERY
     SELECT Object_PriceListItem_effie.Id    ::TVarChar AS extId
          , _tmpResult.PriceListId           ::TVarChar AS priceHeaderExtId
          , _tmpResult.GoodsByGoodsKindId    ::TVarChar AS productExtId
          , _tmpResult.Price                 ::TVarChar AS price
          , FALSE                            ::Boolean  AS isDeleted
     FROM _tmpResult
          LEFT JOIN Object_PriceListItem_effie ON Object_PriceListItem_effie.PriceListId = _tmpResult.PriceListId
                                              AND Object_PriceListItem_effie.GoodsId     = _tmpResult.GoodsId
                                              AND Object_PriceListItem_effie.GoodsKindId = _tmpResult.GoodsKindId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceItems_effie (zfCalc_UserAdmin()::TVarChar);