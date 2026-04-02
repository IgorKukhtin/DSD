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
     CREATE TEMP TABLE tmpGoodsByGoodsKind (GoodsByGoodsKindId Integer, GoodsId Integer, GoodsKindId Integer)  ON COMMIT DROP;
     CREATE TEMP TABLE tmpPrice (PriceListId Integer, GoodsId Integer, GoodsKindId Integer, ValuePrice TFloat)  ON COMMIT DROP;
     CREATE TEMP TABLE _tmp1 (GoodsByGoodsKindId Integer, GoodsId Integer, GoodsKindId Integer, PriceListId Integer, Price TFloat)  ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2 (GoodsByGoodsKindId Integer, GoodsId Integer, GoodsKindId Integer, PriceListId Integer, Price TFloat)  ON COMMIT DROP;
     CREATE TEMP TABLE _tmp3 (GoodsByGoodsKindId Integer, GoodsId Integer, GoodsKindId Integer, PriceListId Integer, Price TFloat)  ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult (GoodsByGoodsKindId Integer, GoodsId Integer, GoodsKindId Integer, PriceListId Integer, Price TFloat)  ON COMMIT DROP;
     
     INSERT INTO tmpGoodsByGoodsKind (GoodsByGoodsKindId, GoodsId, GoodsKindId)
     SELECT DISTINCT
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
                                  AND ObjectBoolean_Order.ValueData = TRUE                
          INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()                                                       
                               AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                              , zc_Enum_InfoMoney_30102() -- Тушенка
                                                                              , zc_Enum_InfoMoney_20901() -- Ирна
                                                                               )
     WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
     --LIMIT 10
     ;

    INSERT INTO tmpPrice (PriceListId,GoodsId, GoodsKindId,  ValuePrice)
    WITH
    tmpContractPrices AS (SELECT DISTINCT
                                 tmp.priceHeaderExtId  ::Integer AS PriceListId
                          FROM gpSelect_Object_ContractPrices_effie (inSession) AS tmp
                          ) 
      
    SELECT DISTINCT 
            ObjectLink_PriceListItem_PriceList.ChildObjectId AS PriceListId
          , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
          , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
          , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
         
     FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
          INNER JOIN Object AS Object_PriceList 
                            ON Object_PriceList.Id = ObjectLink_PriceListItem_PriceList.ChildObjectId
                         --AND Object_PriceList.IsErased = FALSE
          INNER JOIN tmpContractPrices ON tmpContractPrices.PriceListId = ObjectLink_PriceListItem_PriceList.ChildObjectId 

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
     ;
    ANALYZE tmpGoodsByGoodsKind;
    ANALYZE tmpPrice;
     
    INSERT INTO _tmp1 (GoodsByGoodsKindId, GoodsId, GoodsKindId, PriceListId, Price) 
    SELECT tmpGoods.GoodsByGoodsKindId
         , tmpGoods.GoodsId
         , tmpGoods.GoodsKindId
         , tmpPrice.PriceListId  
         , tmpPrice.ValuePrice    ::TFloat AS Price
    FROM tmpGoodsByGoodsKind AS tmpGoods
        -- связь товар + вид товара 
        INNER JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                            AND tmpPrice.GoodsKindId = tmpGoods.GoodsKindId -- and 1 = 0
                            AND COALESCE (tmpPrice.GoodsKindId, 0) > 0
    WHERE COALESCE (tmpPrice.PriceListId, 0) > 0
    ;            
    
    INSERT INTO _tmp2 (GoodsByGoodsKindId, GoodsId, GoodsKindId, PriceListId, Price)     
     -- вид товара вес 
    SELECT tmpGoods.GoodsByGoodsKindId
         , tmpGoods.GoodsId
         , tmpGoods.GoodsKindId
         , tmpPrice.PriceListId            AS PriceListId
         , tmpPrice.ValuePrice    ::TFloat AS Price
    FROM tmpGoodsByGoodsKind AS tmpGoods
        -- связь товар + вид товара 
        INNER JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                           AND tmpPrice.GoodsKindId = zc_GoodsKind_Basis()
    WHERE COALESCE (tmpPrice.PriceListId, 0) > 0 
    ;
 
    INSERT INTO _tmp3 (GoodsByGoodsKindId, GoodsId, GoodsKindId, PriceListId, Price) 
     --вид товара пусто
    SELECT tmpGoods.GoodsByGoodsKindId
         , tmpGoods.GoodsId
         , tmpGoods.GoodsKindId
         , tmpPrice.PriceListId            AS PriceListId
         , tmpPrice.ValuePrice    ::TFloat AS Price
    FROM tmpGoodsByGoodsKind AS tmpGoods
        -- связь товар + вид товара пусто
        LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                          AND tmpPrice.GoodsKindId IS NULL
                     
    WHERE COALESCE (tmpPrice.PriceListId, 0) > 0 
    ;
    ANALYZE _tmp1;
    ANALYZE _tmp2;
    ANALYZE _tmp3;
    

    INSERT INTO _tmpResult (GoodsByGoodsKindId, GoodsId, GoodsKindId, PriceListId, Price) 
     -- 
    SELECT *
    FROM (SELECT _tmp1.GoodsByGoodsKindId
               , _tmp1.GoodsId
               , _tmp1.GoodsKindId
               , _tmp1.PriceListId
               , _tmp1.Price
          FROM _tmp1
       UNION 
          SELECT _tmp2.GoodsByGoodsKindId
               , _tmp2.GoodsId
               , _tmp2.GoodsKindId
               , _tmp2.PriceListId AS PriceListId
               , _tmp2.Price
          FROM _tmp2
              LEFT JOIN _tmp1 ON _tmp1.GoodsByGoodsKindId = _tmp2.GoodsByGoodsKindId 
                             AND _tmp1.PriceListId = _tmp2.PriceListId
          WHERE _tmp1.PriceListId IS NULL 
       UNION 
          SELECT _tmp2.GoodsByGoodsKindId
               , _tmp2.GoodsId
               , _tmp2.GoodsKindId
               , _tmp2.PriceListId AS PriceListId
               , _tmp2.Price
          FROM _tmp3
              LEFT JOIN _tmp1 ON _tmp1.GoodsByGoodsKindId = _tmp3.GoodsByGoodsKindId 
                             AND _tmp1.PriceListId = _tmp3.PriceListId
                            
              LEFT JOIN _tmp2 ON _tmp2.GoodsByGoodsKindId = _tmp3.GoodsByGoodsKindId 
                             AND _tmp2.PriceListId = _tmp3.PriceListId
                             AND _tmp1.PriceListId IS NULL
              
          WHERE _tmp2.PriceListId IS NULL    
          AND _tmp1.PriceListId IS NULL
          ) AS tmp
    WHERE COALESCE (tmp.PriceListId,0) <> 0
     ;

    --обнуляем все цены в таблице
    UPDATE Object_PriceListItem_effie
    SET Price = 0
    ;

     --нужно записать в таблица Object_PriceListItem_effie.Id - по ключу Това+Вид+Прайс  те элементы , которых нет
     INSERT INTO Object_PriceListItem_effie (PriceListId, GoodsId, GoodsKindId, GoodsByGoodsKindId, InsertDate, Price)
     SELECT _tmpResult.PriceListId
          , _tmpResult.GoodsId
          , _tmpResult.GoodsKindId
          , _tmpResult.GoodsByGoodsKindId
          , CURRENT_TIMESTAMP AS InsertDate
          , _tmpResult.Price
     FROM _tmpResult
          LEFT JOIN Object_PriceListItem_effie ON Object_PriceListItem_effie.PriceListId = _tmpResult.PriceListId
                                              AND Object_PriceListItem_effie.GoodsId     = _tmpResult.GoodsId
                                              AND COALESCE (Object_PriceListItem_effie.GoodsKindId,0) = COALESCE (_tmpResult.GoodsKindId,0)
     WHERE Object_PriceListItem_effie.Id IS NULL
       AND COALESCE (_tmpResult.PriceListId,0) > 0;

    --актуализация цен в таблице
    UPDATE Object_PriceListItem_effie
    SET Price              = _tmpResult.Price
      , GoodsByGoodsKindId = _tmpResult.GoodsByGoodsKindId
    FROM _tmpResult 
    WHERE Object_PriceListItem_effie.PriceListId = _tmpResult.PriceListId
      AND Object_PriceListItem_effie.GoodsId     = _tmpResult.GoodsId
      AND COALESCE (Object_PriceListItem_effie.GoodsKindId,0) = COALESCE (_tmpResult.GoodsKindId,0) 
    ;

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

/*
with a as (
                          SELECT distinct Object_PriceList.Id AS PriceListId
                               , MovementItem.ObjectId           AS GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId

                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MLO_Contract
                                                            ON MLO_Contract.MovementId = Movement.Id
                                                           AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MLO_Contract.ObjectId
                               -- УП Статья назначения
                               LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                    ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                                   AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                               LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId


                               LEFT JOIN MovementLinkObject AS MLO_PriceList
                                                            ON MLO_PriceList.MovementId = Movement.Id
                                                           AND MLO_PriceList.DescId     = zc_MovementLinkObject_PriceList()
                               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MLO_PriceList.ObjectId

                               LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                               -- Вид товаров
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                          WHERE Movement.OperDate BETWEEN '01.01.2026' AND '31.03.2026'
                            AND Movement.DescId = zc_Movement_Sale()
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND Object_InfoMoney.Id = zc_Enum_InfoMoney_30101()
)                            
-- select count(*) from a
select *
from a
     left join Object_PriceListItem_effie on Object_PriceListItem_effie.PriceListId = a.PriceListId
                                         and Object_PriceListItem_effie.GoodsId = a.GoodsId
                                         and Object_PriceListItem_effie.GoodsKindId = a.GoodsKindId
where Object_PriceListItem_effie.PriceListId is null
  AND a.PriceListId IN (SELECT DISTINCT tmp.priceHeaderExtId ::Integer AS PriceListId FROM gpSelect_Object_ContractPrices_effie ('') AS tmp)

*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceItems_effie (zfCalc_UserAdmin()::TVarChar);
