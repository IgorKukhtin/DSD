-- Function: gpSelect_Object_ProductRemains_effie

DROP FUNCTION IF EXISTS gpSelect_Object_ProductRemains_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProductRemains_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (warehouseExtId      TVarChar   -- Идентификатор склада
             , productExtId        TVarChar   -- Идентификатор товара
             , amount              TFloat     -- Кол-во товара
             , isDeleted           Boolean    -- Признак активности: false = активна / true = не активна. По умолчанию false = активна.
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
     tmpGoodsByGoodsKind AS (SELECT DISTINCT
                                    ObjectLink_GoodsByGoodsKind_Goods.ObjectId                        AS ObjectId
                                  , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   AS GoodsId
                                  , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                  , COALESCE (ObjectLink_Goods_GoodsGroup.ChildObjectId, 0)           AS GoodsGroupId
                                  , TRIM (COALESCE (Object_GoodsGroup.ValueData, ''))                 AS GoodsGroupName
                             FROM Object AS Object_GoodsByGoodsKind
                                  JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                  ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object_GoodsByGoodsKind.Id
                                                 AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                 AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId > 0
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                                      AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                                  -- Ограничим - есть Вид товара
                                  INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                        ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId > 0
                                 --
                                  JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_Order
                                                     ON ObjectBoolean_GoodsByGoodsKind_Order.ObjectId  = Object_GoodsByGoodsKind.Id
                                                    AND ObjectBoolean_GoodsByGoodsKind_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                                    AND (ObjectBoolean_GoodsByGoodsKind_Order.ValueData = TRUE -- условие что разрешен
                                                      OR (ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     = 9505524 -- 457 - Сосиски ФІЛЕЙКИ вар 1 ґ ТМ Наші Ковбаси
                                                      AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = 8344    -- Б/В 0,5кг
                                                        ))
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_NotMobile
                                                          ON ObjectBoolean_GoodsByGoodsKind_NotMobile.ObjectId  = Object_GoodsByGoodsKind.Id
                                                         AND ObjectBoolean_GoodsByGoodsKind_NotMobile.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NotMobile()
                                                         AND ObjectBoolean_GoodsByGoodsKind_NotMobile.ValueData = TRUE -- условие что НЕ разрешен

                                  -- Ограничим - если НЕ удален
                                  JOIN Object AS Object_Goods ON Object_Goods.Id       = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                                             AND Object_Goods.isErased = FALSE
                                  -- Ограничим - если НЕ удален
                                  JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id       = ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId
                                                                 AND Object_GoodsKind.isErased = FALSE
                                  -- Ограничим - ТОЛЬКО если ГП
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                       ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                                      AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                  -- ограничили
                                  INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                  AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                                                                     , zc_Enum_InfoMoneyDestination_21000() -- Общефирменные + Чапли
                                                                                                                     , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                                      )

                             WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind()
                               AND Object_GoodsByGoodsKind.isErased = FALSE
                               AND ObjectBoolean_GoodsByGoodsKind_NotMobile.ObjectId IS NULL
                            )

   , tmpUnit AS (SELECT 8459      AS UnitId -- филиал zc_Branch_Basis - Склад Реализации
           UNION SELECT 8411      AS UnitId -- филиал Киев      - Склад ГП ф Киев
           UNION SELECT 8417      AS UnitId -- филиал Николаев (Херсон) - Склад ГП ф.Николаев (Херсон)
           UNION SELECT 346093    AS UnitId -- филиал Одесса    - Склад ГП ф.Одесса
           UNION SELECT 8415      AS UnitId -- филиал Черкассы (Кировоград) - Склад ГП ф.Черкассы (Кировоград)
           UNION SELECT 8413      AS UnitId -- филиал Кр.Рог    - Склад ГП ф.Кривой Рог
           UNION SELECT 8425      AS UnitId -- филиал Харьков   - Склад ГП ф.Харьков
           UNION SELECT 301309    AS UnitId -- филиал Запорожье - Склад ГП ф.Запорожье
           UNION SELECT 3080691   AS UnitId -- филиал Львов     - Склад ГП ф.Львов
           UNION SELECT 11921035  AS UnitId -- Филиал Винница   - Склад ГП ф.Вінниця
                 )
            
     --
     SELECT tmpUnit.UnitId                   ::TVarChar AS warehouseExtId
          , tmpGoodsByGoodsKind.ObjectId     ::TVarChar AS productExtId
          , 0                                ::TFloat   AS amount
          , FALSE                            ::Boolean  AS isDeleted
     FROM tmpUnit
         LEFT JOIN tmpGoodsByGoodsKind ON 1 = 1
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProductRemains_effie (zfCalc_UserAdmin()::TVarChar);


/*

захардкодить все склады из 3702 FULL JOIN tmpGoodsByGoodsKind для zc_ObjectBoolean_GoodsByGoodsKind_Order, сами остатки считать не надо, пока = 0

*/