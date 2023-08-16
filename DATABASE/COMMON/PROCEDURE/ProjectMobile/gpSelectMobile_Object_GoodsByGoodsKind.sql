-- Function: gpSelectMobile_Object_GoodsByGoodsKind (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_GoodsLinkGoodsKind (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelectMobile_Object_GoodsByGoodsKind (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_GoodsByGoodsKind (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer  -- Товар
             , GoodsId_key   Integer  -- Товар
             , GoodsKindId   Integer  -- Вид товара
             , Remains       TFloat   -- Остаток на  складе vbUnitId
             , Forecast      TFloat   -- Прогноз прихода на vbUnitId
             , isErased      Boolean  -- Удаленный ли элемент
             , isSync        Boolean  -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- Определили параметры
     SELECT PersonalId, UnitId INTO vbPersonalId, vbUnitId FROM gpGetMobile_Object_Const (inSession);

     -- проверка - свойство должно быть установлено
     IF COALESCE (vbUnitId, 0) =  0 THEN
        RAISE EXCEPTION 'Ошибка.У сотрудника <%> Не установлено значение <Подразделение>.', lfGet_Object_ValueData (vbPersonalId);
     END IF;


      -- Только если Сотрудник был определен
      IF vbPersonalId IS NOT NULL
      THEN
           -- Результат
           RETURN QUERY
             WITH -- все разрешенные Товар + Вид товара
                  tmpGoodsOrder_all AS (SELECT Object_GoodsByGoodsKind.Id
                                             , Object_GoodsByGoodsKind.isErased
                                             , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     AS GoodsId
                                             , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                                        FROM Object AS Object_GoodsByGoodsKind
                                             JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                             ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object_GoodsByGoodsKind.Id
                                                            AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                            AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId > 0
                                             -- Ограничим - есть Вид товара
                                             JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = Object_GoodsByGoodsKind.Id
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
                                             INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                             AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                                                                                , zc_Enum_InfoMoneyDestination_21000() -- Общефирменные + Чапли
                                                                                                                                , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                                                 )
                                        WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind()
                                          AND Object_GoodsByGoodsKind.isErased = FALSE
                                          AND ObjectBoolean_GoodsByGoodsKind_NotMobile.ObjectId IS NULL
                                       )
                  -- сгруппировали Товар
                , tmpGoodsOrder AS (SELECT DISTINCT tmpGoodsOrder_all.GoodsId FROM tmpGoodsOrder_all)
                  -- остатки Товар + Вид товара
                , tmpRemains AS (SELECT Container_Count.ObjectId                             AS GoodsId
                                      , COALESCE (ContainerLinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                      , SUM (Container_Count.Amount)                         AS Amount
                                 FROM ContainerLinkObject AS ContainerLinkObject_Unit
                                      JOIN Container AS Container_Count 
                                                     ON Container_Count.Id     = ContainerLinkObject_Unit.ContainerId 
                                                    AND Container_Count.DescId = zc_Container_Count() 
                                                    AND Container_Count.Amount <> 0.0
                                      -- Только для разрешенных товаров
                                      JOIN tmpGoodsOrder ON tmpGoodsOrder.GoodsId = Container_Count.ObjectId
                                      LEFT JOIN ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                                                    ON ContainerLinkObject_GoodsKind.ContainerId = ContainerLinkObject_Unit.ContainerId
                                                                   AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                      LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Account
                                                                    ON ContainerLinkObject_Account.ContainerId = ContainerLinkObject_Unit.ContainerId
                                                                   AND ContainerLinkObject_Account.DescId = zc_ContainerLinkObject_Account()
                                 WHERE ContainerLinkObject_Unit.ObjectId = vbUnitId
                                   AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                   AND ContainerLinkObject_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                                 GROUP BY Container_Count.ObjectId
                                        , COALESCE (ContainerLinkObject_GoodsKind.ObjectId, 0)
                                 HAVING SUM (Container_Count.Amount) <> 0.0
                                )
             -- Результат
             SELECT tmpGoodsOrder_all.Id
                  , tmpGoodsOrder_all.GoodsId AS GoodsId
                  , tmpGoodsOrder_all.GoodsId AS GoodsId_key
                  , tmpGoodsOrder_all.GoodsKindId 
                  , COALESCE (tmpRemains.Amount, 0.0) :: TFloat AS Remains
                  , 0 :: TFloat                                 AS Forecast 
                  , tmpGoodsOrder_all.isErased
                  , TRUE :: Boolean AS isSync
             FROM tmpGoodsOrder_all
                  LEFT JOIN tmpRemains ON tmpRemains.GoodsId     = tmpGoodsOrder_all.GoodsId
                                      AND tmpRemains.GoodsKindId = tmpGoodsOrder_all.GoodsKindId
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
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_GoodsByGoodsKind(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
