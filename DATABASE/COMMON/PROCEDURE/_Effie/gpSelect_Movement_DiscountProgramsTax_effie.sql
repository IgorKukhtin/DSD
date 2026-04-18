-- Function: gpSelect_Movement_DiscountProgramsTax_effie

DROP FUNCTION IF EXISTS gpSelect_Movement_DiscountProgramsTax_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_DiscountProgramsTax_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (extId                      TVarChar   --Уникальный идентификатор промо акции
             , Name                       TVarChar   --Описание программы скидок
             , description                TVarChar   --Описание программы скидок
             , typeId                     Integer    --Тип расчета
             , linkTypeId                 Integer    --Тип связи
             , priority                   Integer    --Приоритет программы скидок при применении в заказе. От высшего = 1 до низшего = 255
             , сontractHeaderExtId        TVarChar   -- Внешний идентификатор контракта, к которому привязана программа скидок
             , beginDate                  TVarChar   --Дата начала действия программы скидок
             , endDate                    TVarChar   --Дата окончания действия программы скидок
             , shortName                  TVarChar   --короткое название
             , isAutoUse                  Boolean    --Авто применение программы скидок (признак false = не активен / true = активен)
             , beforeDiscountQuestHeaderId TVarChar  --Id Анкеты Контроль цены до скидки
             , afterDiscountQuestHeaderId TVarChar   --Id Анкеты Контроль цены после скидки
             , isDeleted                  Boolean    --Признак активности
             , customTypeExtId            TVarChar   --Внешний идентификатор типа скидки.
             , clientExtId                TVarChar   --Внешний идентификатор контрагента
             , isPreDiscountCheckSkipped  Boolean    --Признак пропуска контроля цены до скидки
             , linkDiscounts_extId        TVarChar   --Идентификатор единицы связи. К примеру, типа связи по продуктам это будет значение внешнего идентификатора продукта.
             , linkDiscounts_discount     TFloat     --"Объём скидки, используется только для типа программы скидок 1 - фиксированная.Допустимо отрицательное значение."
               -- для проверки
             , Price_effie                TFloat     -- цена из effie
             , Price_promo                TFloat     -- цена Promo - со кидкой без НДС

) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- временная таблица PriceListItem
     CREATE TEMP TABLE _tmpPromoTax (ContractId Integer, PartnerId Integer, PriceListId Integer, GoodsByGoodsKindId Integer
                                , ChangePercent TFloat, Price_promo TFloat, Price_effie TFloat
                                 )  ON COMMIT DROP;

     INSERT INTO _tmpPromoTax (ContractId, PartnerId, PriceListId, GoodsByGoodsKindId, ChangePercent, Price_promo, Price_effie)
     WITH
     tmpContract_effie AS (SELECT DISTINCT gpSelect.extId ::Integer FROM gpSelect_Object_ContractHeaders_effie (inSession) AS gpSelect)
   , tmpContract AS (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId     AS ContractId
                          , ObjectFloat_Value.ValueData                   :: TFloat AS ChangePercent
                     FROM (SELECT zc_Enum_ContractConditionKind_ChangePercent()     AS Id -- (-)% Скидки (+)% Наценки
                          ) AS tmpContractConditionKind
                          INNER JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                ON ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = tmpContractConditionKind.Id
                                               AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                          INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                       AND Object_ContractCondition.isErased = FALSE
                          INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                 ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                AND ObjectFloat_Value.ValueData <> 0
                          INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                               AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                               AND ObjectLink_ContractCondition_Contract.ChildObjectId IN (SELECT DISTINCT tmpContract_effie.extId FROM tmpContract_effie)

                          LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                               ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractCondition_StartDate()
                          LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                               ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractCondition_EndDate()
                     WHERE (COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())) <= CURRENT_DATE
                       AND (COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())) > CURRENT_DATE 
                     --LIMIT 1
                    )

     -- связь договор + прайс
   , tmpContractPrices_effie AS (SELECT tmp.priceHeaderExtId    ::Integer AS PriceListId   -- Идентификатор прайса
                                      , tmp.contractHeaderExtId ::Integer AS ContractId    -- Идентификатор контракта
                                      , tmp.PartnerId           ::Integer AS PartnerId     -- Контрагент инф.
                                 FROM gpSelect_Object_ContractPrices_effie (inSession) AS tmp
                                )

   , tmpContractPrice AS (SELECT tmpContract.ContractId
                               , tmpContract.ChangePercent
                               , tmpContractPrices_effie.PriceListId
                               , tmpContractPrices_effie.PartnerId
                          FROM tmpContract
                               INNER JOIN tmpContractPrices_effie ON tmpContractPrices_effie.ContractId = tmpContract.ContractId
                         )
   --цены по прайсам без скидки
   , tmpPriceListItem_effie AS (SELECT Object_PriceListItem_effie.*
                                FROM Object_PriceListItem_effie
                                WHERE Object_PriceListItem_effie.PriceListId IN (SELECT DISTINCT tmpContractPrice.PriceListId FROM tmpContractPrice)
                                )

   , tmpGoodsByGoodsKind AS (SELECT DISTINCT
                                    Object_GoodsByGoodsKind.Id                                        AS GoodsByGoodsKindId
                                  , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   AS GoodsId
                                  , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                             FROM Object AS Object_GoodsByGoodsKind
                                  JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                  ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object_GoodsByGoodsKind.Id
                                                 AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                 AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId > 0

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




 , tmpData AS (SELECT tmpContractPrice.PriceListId
                    , tmpContractPrice.PartnerId
                    , tmpContractPrice.ContractId
                    , tmpContractPrice.ChangePercent
                    , tmpGoodsByGoodsKind.GoodsByGoodsKindId
                    , tmpPriceListItem_effie.Price           AS Price_effie
                    , (tmpPriceListItem_effie.Price * (1 + tmpContractPrice.ChangePercent / 100))  AS Price_promo
               FROM tmpContractPrice
                    
                    INNER JOIN tmpPriceListItem_effie ON tmpPriceListItem_effie.PriceListId = tmpContractPrice.PriceListId

                    INNER JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = tmpPriceListItem_effie.GoodsId
                                                  AND tmpGoodsByGoodsKind.GoodsKindId = tmpPriceListItem_effie.GoodsKindId
               )


    SELECT DISTINCT
           tmpData.ContractId 
         , tmpData.PartnerId
         , tmpData.PriceListId
         , tmpData.GoodsByGoodsKindId
         , tmpData.ChangePercent
         , tmpData.Price_promo
         , tmpData.Price_effie
    FROM tmpData
   ;


     --нужно записать в таблицу Object_Promo_effie  те элементы , которых нет - Договор + Прайс
     INSERT INTO Object_Promo_effie (MovementId, PartnerId, ContractId, PriceListId, InsertDate)
     SELECT DISTINCT
            0 AS MovementId
          , 0 AS PartnerId
          , _tmpPromoTax.ContractId
          , _tmpPromoTax.PriceListId
          , CURRENT_TIMESTAMP AS InsertDate
      FROM _tmpPromoTax
           LEFT JOIN Object_Promo_effie ON Object_Promo_effie.ContractId  = _tmpPromoTax.ContractId
                                       AND Object_Promo_effie.PriceListId = _tmpPromoTax.PriceListId
     WHERE Object_Promo_effie.Id IS NULL;


     -- Результат
     RETURN QUERY
    --
     SELECT Object_Promo_effie.Id                ::TVarChar AS extId
          , ('Прайс ' || Object_PriceList.ValueData||' Договір № '||Object_Contract.ValueData) ::TVarChar AS Name
          , ('Прайс ' || Object_PriceList.ValueData||' Договір № '||Object_Contract.ValueData) ::TVarChar AS description
          , 1                                    ::Integer  AS typeId
          , 1                                    ::Integer  AS linkTypeId
          , 255                                  ::Integer  AS priority
          , Object_Promo_effie.ContractId        ::TVarChar AS сontractHeaderExtId
          , zc_DateStart()                       ::TVarChar AS beginDate
          , zc_DateEnd()                         ::TVarChar AS endDate
        --, ('Прайс ' || Object_PriceList.ValueData||' Договір № '||Object_Contract.ValueData) ::TVarChar AS shortName
          , 'Прайс'                                                                            ::TVarChar AS shortName
          , TRUE                                 ::Boolean  AS isAutoUse
          , NULL                                 ::TVarChar AS beforeDiscountQuestHeaderId
          , NULL                                 ::TVarChar AS afterDiscountQuestHeaderId
          , FALSE                                ::Boolean  AS isDeleted
          , NULL                                 ::TVarChar AS customTypeExtId

          , _tmpPromoTax.PartnerId                  ::TVarChar AS clientExtId
          , FALSE                                ::Boolean  AS isPreDiscountCheckSkipped

          , _tmpPromoTax.GoodsByGoodsKindId         ::TVarChar AS linkDiscounts_extId
          , _tmpPromoTax.ChangePercent              ::TFloat   AS linkDiscounts_discount

          , _tmpPromoTax.Price_effie                ::TFloat   AS Price_effie  -- цена из effie
          , _tmpPromoTax.Price_promo                ::TFloat   AS Price_promo  -- цена Promo - со кидкой без НДС

     FROM _tmpPromoTax 
          LEFT JOIN Object_Promo_effie ON Object_Promo_effie.ContractId = _tmpPromoTax.ContractId
                                      AND Object_Promo_effie.PriceListId = _tmpPromoTax.PriceListId

          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = _tmpPromoTax.ContractId
          LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = _tmpPromoTax.PriceListId
 --limit 200
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_DiscountProgramsTax_effie (zfCalc_UserAdmin()::TVarChar);
