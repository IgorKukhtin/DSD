-- Function: gpInsert_Movement_DiscountPrograms_effie

DROP FUNCTION IF EXISTS gpInsert_Movement_DiscountPrograms_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_DiscountPrograms_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS VOID
AS

$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- временная таблица PriceListItem
     CREATE TEMP TABLE _tmpPromo (MovementId Integer, MovementItemId Integer, StartSale TDateTime, EndSale TDateTime, ContractId Integer, PartnerId Integer, GoodsId Integer, GoodsKindId Integer)  ON COMMIT DROP;

     INSERT INTO _tmpPromo (MovementId, MovementItemId, StartSale, EndSale, ContractId, PartnerId, GoodsId, GoodsKindId)
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
        --    limit 1
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

   , tmpMovementDate AS (
                         SELECT MovementDate.*
                         FROM MovementDate
                         WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpPromo.Id FROM tmpPromo)
                           AND MovementDate.DescId IN (zc_MovementDate_StartSale()
                                                     , zc_MovementDate_EndSale()
                                                      )
                         )
   , tmpMLO_PriceList AS (SELECT MovementLinkObject.*
                          FROM MovementLinkObject
                          WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpPromo.Id FROM tmpPromo)
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
                         WHERE Movement_PromoPartner.ParentId IN (SELECT DISTINCT tmpPromo.Id FROM tmpPromo)
                           AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                           AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                         )

   , tmpMI AS (SELECT MovementItem.*
               FROM MovementItem
               WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpPromo.Id FROM tmpPromo)
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
                                , tmpMI.Id       AS MovementItemId
                                , tmpMI.ObjectId AS GoodsId
                                , COALESCE (tmpGoodsByGoodsKind_GoodsKind.GoodsKindId, tmpGoodsByGoodsKind.GoodsKindId)               AS GoodsKindId
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
                           WHERE COALESCE (tmpGoodsByGoodsKind_GoodsKind.GoodsByGoodsKindId, tmpGoodsByGoodsKind.GoodsByGoodsKindId) <> 0
                           )


   , tmpData AS (SELECT Movement.Id    AS MovementId
                      , tmpMI.MovementItemId
                      , tmpPromoPartner.PartnerId
                      , COALESCE (tmpPromoPartner.ContractId, 0) AS ContractId
                      , tmpMI.GoodsByGoodsKindId
                      , tmpMI.GoodsId
                      , tmpMI.GoodsKindId
                 FROM tmpPromo AS Movement
                      LEFT JOIN tmpPromoPartner ON tmpPromoPartner.ParentId = Movement.Id
                      INNER JOIN tmpMI_ByGoodsKind AS tmpMI ON tmpMI.MovementId = Movement.Id       --только те строки что соотв. условию выгрузки товара (ByGoodsKind)
                 )

     SELECT tmpData.MovementId
          , tmpData.MovementItemId
          , MovementDate_StartSale.ValueData     AS StartSale
          , MovementDate_EndSale.ValueData       AS EndSale
          , tmpData.ContractId
          , tmpData.PartnerId                    
          , tmpData.GoodsId           
          , tmpData.GoodsKindId                   
     FROM tmpData
          LEFT JOIN tmpMovementDate AS MovementDate_StartSale
                                    ON MovementDate_StartSale.MovementId = tmpData.MovementId
                                   AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
          LEFT JOIN tmpMovementDate AS MovementDate_EndSale
                                    ON MovementDate_EndSale.MovementId = tmpData.MovementId
                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
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


     --записываем в таблицу Object_PromoItem_effie  те элементы , которых нет
     INSERT INTO Object_PromoItem_effie (MovementId, MovementItemId, StartSale, EndSale, ContractId, PriceListId, PartnerId, GoodsId, GoodsKindId, InsertDate)
     SELECT DISTINCT
            _tmpPromo.MovementId
          , _tmpPromo.MovementItemId
          , _tmpPromo.StartSale
          , _tmpPromo.EndSale                 
          , _tmpPromo.ContractId
          , 0                 AS PriceListId
          , _tmpPromo.PartnerId
          , _tmpPromo.GoodsId
          , _tmpPromo.GoodsKindId
          , CURRENT_TIMESTAMP AS InsertDate
      FROM _tmpPromo
           LEFT JOIN Object_PromoItem_effie ON Object_PromoItem_effie.MovementId  = _tmpPromo.MovementId
                                           AND Object_PromoItem_effie.MovementItemId  = _tmpPromo.MovementItemId
                                           AND Object_PromoItem_effie.ContractId  = _tmpPromo.ContractId
                                           AND Object_PromoItem_effie.PartnerId   = _tmpPromo.PartnerId
                                           AND Object_PromoItem_effie.GoodsId     = _tmpPromo.GoodsId
                                           AND COALESCE (Object_PromoItem_effie.GoodsKindId,0) = COALESCE (_tmpPromo.GoodsKindId,0)
     WHERE Object_PromoItem_effie.Id IS NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.03.26         *
*/

-- тест
-- SELECT * FROM  gpInsert_Movement_DiscountPrograms_effie (zfCalc_UserAdmin()::TVarChar); ;