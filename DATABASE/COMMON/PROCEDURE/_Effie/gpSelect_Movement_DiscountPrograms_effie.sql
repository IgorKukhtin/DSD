-- Function: gpSelect_Movement_DiscountPrograms_effie

DROP FUNCTION IF EXISTS gpSelect_Movement_DiscountPrograms_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_DiscountPrograms_effie(
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
             , Price_orig                 TFloat     -- цена без НДС из док.Promo
             , Price_effie                TFloat     -- цена из effie
             , Price_promo                TFloat     -- цена Promo - со кидкой без НДС

) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- временная таблица PriceListItem
     CREATE TEMP TABLE _tmpPromo (MovementId Integer, ContractId Integer)  ON COMMIT DROP;

     INSERT INTO _tmpPromo (MovementId, ContractId)
     WITH
     tmpPromo AS (SELECT Movement_Promo.*
                  FROM Movement AS Movement_Promo
                       INNER JOIN MovementDate AS MovementDate_StartSale
                                               ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                       INNER JOIN MovementDate AS MovementDate_EndSale
                                               ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                              AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

                  WHERE Movement_Promo.DescId = zc_Movement_Promo()
                    AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                    AND (MovementDate_StartSale.ValueData <= CURRENT_DATE
                         AND MovementDate_EndSale.ValueData >= CURRENT_DATE
                        ) 
                --limit 10
                 )

    SELECT DISTINCT
           tmpPromo.Id AS MovementId
         , 0           AS ContractId
    FROM tmpPromo
    ;

     --нужно записать в таблицу Object_Promo_effie  те элементы , которых нет - ключ MovementItemId, GoodsKindId
     INSERT INTO Object_Promo_effie (MovementId, ContractId, PriceListId, InsertDate)
     SELECT DISTINCT
            _tmpPromo.MovementId
          , 0 AS ContractId
          , 0 AS PriceListId
          , CURRENT_TIMESTAMP AS InsertDate
      FROM _tmpPromo
           LEFT JOIN Object_Promo_effie ON Object_Promo_effie.MovementId = _tmpPromo.MovementId
     WHERE Object_Promo_effie.Id IS NULL;

     -- Результат
     RETURN QUERY
     WITH
     tmpGoodsByGoodsKind AS (SELECT DISTINCT
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

   , tmpObject_Promo_effie AS (SELECT * 
                               FROM _tmpPromo 
                             
                              -- LIMIT 1
                               )
   , tmpMovementDate AS (
                         SELECT MovementDate.*
                         FROM MovementDate
                         WHERE MovementDate.MovementId IN (SELECT DISTINCT _tmpPromo.MovementId FROM _tmpPromo)
                           AND MovementDate.DescId IN (zc_MovementDate_StartSale()
                                                     , zc_MovementDate_EndSale()
                                                      )
                         )
   , tmpMLO_PriceList AS (SELECT MovementLinkObject.*
                          FROM MovementLinkObject
                          WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT _tmpPromo.MovementId FROM _tmpPromo)
                             AND MovementLinkObject.DescId = zc_MovementLinkObject_PriceList()
                          )


   , tmpPromoPartner AS (SELECT DISTINCT
                                Movement_PromoPartner.ParentId
                              , MI_PromoPartner.ObjectId       AS PartnerId
                              , MILinkObject_Contract.ObjectId AS ContractId
                         FROM Movement AS Movement_PromoPartner
                              INNER JOIN MovementItem AS MI_PromoPartner
                                                      ON MI_PromoPartner.MovementId = Movement_PromoPartner.Id
                                                     AND MI_PromoPartner.DescId = zc_MI_Master()
                                                     AND MI_PromoPartner.isErased = FALSE
                              INNER JOIN Object AS Object_Partner ON Object_Partner.Id = MI_PromoPartner.ObjectId AND Object_Partner.IsErased = FALSE

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                               ON MILinkObject_Contract.MovementItemId = MI_PromoPartner.Id
                                                              AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                         WHERE Movement_PromoPartner.ParentId IN (SELECT DISTINCT _tmpPromo.MovementId FROM _tmpPromo)
                           AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                           AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                         )

   , tmpMI AS (SELECT MovementItem.*
               FROM MovementItem
               WHERE MovementItem.MovementId IN (SELECT DISTINCT _tmpPromo.MovementId FROM _tmpPromo)
                 AND MovementItem.DescId = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
               )
   , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                           FROM MovementItemLinkObject
                           WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                             AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                          )
   , tmpMIFloat_Price AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                            AND MovementItemFloat.DescId IN (zc_MIFloat_PriceWithOutVAT()
                                                           , zc_MIFloat_OperPriceList()
                                                            )
                          )

     --все товары + виды товаров  + цены
   , tmpMI_ByGoodsKind AS (SELECT DISTINCT
                                  tmpMI.MovementId
                                , tmpMI.ObjectId AS GoodsId
                                , COALESCE (tmpGoodsByGoodsKind_GoodsKind.GoodsKindId, tmpGoodsByGoodsKind.GoodsKindId) AS GoodsKindId
                                , COALESCE (tmpGoodsByGoodsKind_GoodsKind.GoodsByGoodsKindId, tmpGoodsByGoodsKind.GoodsByGoodsKindId) AS GoodsByGoodsKindId
                                , MIFloat_PriceWithOutVAT.ValueData ::TFloat AS Price              --Цена с учетом скидки
                                , MIFloat_OperPriceList.ValueData   ::TFloat AS OperPriceList     -- Цена в прайсе
                           FROM tmpMI
                               LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = tmpMI.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                               LEFT JOIN tmpMIFloat_Price AS MIFloat_PriceWithOutVAT
                                                          ON MIFloat_PriceWithOutVAT.MovementItemId = tmpMI.Id
                                                         AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()

                               LEFT JOIN tmpMIFloat_Price AS MIFloat_OperPriceList
                                                          ON MIFloat_OperPriceList.MovementItemId = tmpMI.Id
                                                         AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

                               LEFT JOIN tmpGoodsByGoodsKind AS tmpGoodsByGoodsKind_GoodsKind
                                                             ON tmpGoodsByGoodsKind_GoodsKind.GoodsId = tmpMI.ObjectId
                                                            AND tmpGoodsByGoodsKind_GoodsKind.GoodsKindId = MILinkObject_GoodsKind.ObjectId
                                                            AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) <> 0

                               LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = tmpMI.ObjectId
                                                            AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = 0
                           )


   --прайсы
   , tmpPriceForTwin_effie AS (SELECT gpSelect.extId        ::Integer    AS ContractId
                                    , gpSelect.clientExtID  ::Integer    AS PartnerId
                                    , CASE WHEN COALESCE (gpSelect.priceHeaderExtId ::Integer,0) <> 0 THEN gpSelect.priceHeaderExtId ::Integer
                                           ELSE gpSelect.defaultPrice ::Integer
                                      END ::Integer AS PriceListId
                                    , gpSelect.defaultPrice     AS PriceListId_default
                               FROM gpSelect_Object_PriceForTwin_effie (zfCalc_UserAdmin()::TVarChar) AS gpSelect
                                    INNER JOIN (SELECT DISTINCT tmpPromoPartner.PartnerId, tmpPromoPartner.ContractId
                                                FROM tmpPromoPartner) AS tmp
                                                                 ON tmp.PartnerId = gpSelect.clientExtID ::Integer
                                                               AND ((tmp.ContractId = gpSelect.extId ::Integer AND COALESCE (tmp.ContractId,0)  <> 0)
                                                                 OR COALESCE (tmp.ContractId,0)  = 0
                                                                     )
                               )
   --цены по прайсам без скидки
   , tmpPriceListItem_effie AS (SELECT Object_PriceListItem_effie.*
                                FROM Object_PriceListItem_effie
                                WHERE Object_PriceListItem_effie.PriceListId IN (SELECT DISTINCT tmpPriceForTwin_effie.PriceListId FROM tmpPriceForTwin_effie)
                                )
   , tmpData AS (SELECT Movement.MovementId
                      , tmpPromoPartner.PartnerId
                      , COALESCE (tmpPromoPartner.ContractId, tmpPriceForTwin_effie_All.ContractId) AS ContractId
                      , tmpMI.GoodsByGoodsKindId
                      , tmpMI.Price                   AS Price
                      , tmpMI.OperPriceList           AS Price_orig
                      , tmpPriceListItem_effie.Price  AS Price_effie
                      , CASE WHEN COALESCE (tmpPriceListItem_effie.Price,0) <> 0
                             THEN 100 - (tmpMI.Price * 100 / tmpPriceListItem_effie.Price)
                             ELSE 0
                        END AS TaxPersent
                 FROM _tmpPromo AS Movement
                      LEFT JOIN tmpPromoPartner ON tmpPromoPartner.ParentId = Movement.MovementId
                      LEFT JOIN tmpPriceForTwin_effie ON tmpPriceForTwin_effie.PartnerId = tmpPromoPartner.PartnerId
                                                     AND tmpPriceForTwin_effie.ContractId = tmpPromoPartner.ContractId
                      LEFT JOIN tmpPriceForTwin_effie AS tmpPriceForTwin_effie_All
                                                      ON tmpPriceForTwin_effie_All.PartnerId = tmpPromoPartner.PartnerId
                                                     AND tmpPriceForTwin_effie.PriceListId IS NULL

                      LEFT JOIN tmpMI_ByGoodsKind AS tmpMI ON tmpMI.MovementId = Movement.MovementId
                      LEFT JOIN tmpPriceListItem_effie ON tmpPriceListItem_effie.PriceListId = COALESCE (tmpPriceForTwin_effie.PriceListId, tmpPriceForTwin_effie_All.PriceListId)
                                                      AND tmpPriceListItem_effie.GoodsId = tmpMI.GoodsId
                                                      AND tmpPriceListItem_effie.GoodsKindId = tmpMI.GoodsKindId
                 )

    --
     SELECT Object_Promo_effie.Id                ::TVarChar AS extId
          , ('№ ' || Movement_Promo.InvNumber||' от '||zfConvert_DateToString (Movement_Promo.OperDate)) ::TVarChar AS Name
          , ('№ ' || Movement_Promo.InvNumber||' от '||zfConvert_DateToString (Movement_Promo.OperDate)) ::TVarChar AS description
          , 1                                    ::Integer  AS typeId
          , 1                                    ::Integer  AS linkTypeId
          , 1                                    ::Integer  AS priority
          , tmpData.ContractId                   ::TVarChar AS сontractHeaderExtId
          , MovementDate_StartSale.ValueData     ::TVarChar AS beginDate
          , MovementDate_EndSale.ValueData       ::TVarChar AS endDate
          , ('№ ' || Movement_Promo.InvNumber||' от '||zfConvert_DateToString (Movement_Promo.OperDate)) ::TVarChar AS shortName
          , TRUE                                 ::Boolean  AS isAutoUse
          , NULL                                 ::TVarChar AS beforeDiscountQuestHeaderId
          , NULL                                 ::TVarChar AS afterDiscountQuestHeaderId
          , FALSE                                ::Boolean  AS isDeleted
          , NULL                                 ::TVarChar AS customTypeExtId

          , tmpData.PartnerId                    ::TVarChar AS clientExtId
          , FALSE                                ::Boolean  AS isPreDiscountCheckSkipped

          , tmpData.GoodsByGoodsKindId           ::TVarChar AS linkDiscounts_extId
          , tmpData.TaxPersent                   ::TFloat   AS linkDiscounts_discount

          , tmpData.Price_orig                   ::TFloat   AS Price_orig   -- цена без НДС из док.Promo
          , tmpData.Price_effie                  ::TFloat   AS Price_effie  -- цена из effie
          , tmpData.Price                        ::TFloat   AS Price_promo  -- цена Promo - со кидкой без НДС

     FROM tmpData
          LEFT JOIN Object_Promo_effie ON Object_Promo_effie.MovementId = tmpData.MovementId
          
          LEFT JOIN Movement AS Movement_Promo ON Movement_Promo.Id = tmpData.MovementId

          LEFT JOIN tmpMovementDate AS MovementDate_StartSale
                                    ON MovementDate_StartSale.MovementId = tmpData.MovementId
                                   AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
          LEFT JOIN tmpMovementDate AS MovementDate_EndSale
                                    ON MovementDate_EndSale.MovementId = tmpData.MovementId
                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

 --limit 200
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_DiscountPrograms_effie (zfCalc_UserAdmin()::TVarChar);