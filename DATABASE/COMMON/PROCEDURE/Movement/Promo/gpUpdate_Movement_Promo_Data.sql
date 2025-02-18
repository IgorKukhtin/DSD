-- Function: gpUpdate_Movement_Promo_Data()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Data (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Data(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
   DECLARE vbUnitId    Integer;
   DECLARE vbStatusId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Promo_Data());


     -- Проверили - Ви товара
     IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                     INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                           ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                          AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                         , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                         , zc_Enum_InfoMoney_30102() -- Тушенка
                                                                                          )
                                          AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0
               )
        AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Необходимо заполнить колонку вид товара.';
     END IF;


     -- параметры из документа <Акции>
     SELECT Movement_Promo_View.StatusId
          , Movement_Promo_View.StartSale
          , Movement_Promo_View.EndSale
          , COALESCE (Movement_Promo_View.UnitId, 0)
            INTO vbStatusId, vbStartDate, vbEndDate, vbUnitId
     FROM Movement_Promo_View
     WHERE Movement_Promo_View.Id = inMovementId
    ;

   /*IF vbStatusId <> zc_Enum_Status_Complete()
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не проведен.';
     END IF;*/


     -- сохранение "новых" контрагентов + по продажам за аналогичный период
     PERFORM lpUpdate_Movement_Promo_Auto (inMovementId := inMovementId
                                         , inUserId     := vbUserId
                                          );
/*
     -- данные по акциям
     CREATE TEMP TABLE _tmpMI_promo (GoodsId Integer, GoodsKindId Integer, PriceWithOutVAT TFloat, PriceWithVAT TFloat) ON COMMIT DROP;
     -- данные по продажам, в которых будет установлен признак "акция"
     CREATE TEMP TABLE _tmpMI_sale (MovementId Integer, MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat, PriceWithOutVAT TFloat) ON COMMIT DROP;
     -- данные по заявкам, в которых будет установлен признак "акция"
     CREATE TEMP TABLE _tmpMI_order (MovementId Integer, MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat, PriceWithOutVAT TFloat) ON COMMIT DROP;


     -- Данные Promo
     INSERT INTO _tmpMI_promo (GoodsId, GoodsKindId, PriceWithOutVAT, PriceWithVAT)
        SELECT DISTINCT
               MI_PromoGoods.GoodsId
             , COALESCE (MI_PromoGoods.GoodsKindId, 0) AS GoodsKindId
             , MI_PromoGoods.PriceWithOutVAT  -- Цена отгрузки без учета НДС, с учетом скидки
             , MI_PromoGoods.PriceWithVAT     -- Цена отгрузки с учетом НДС, с учетом скидки
        FROM MovementItem_PromoGoods_View AS MI_PromoGoods
        WHERE MI_PromoGoods.MovementId = inMovementId
          AND MI_PromoGoods.isErased = FALSE
          AND MI_PromoGoods.Amount <> 0 -- % скидки на товар
       ;


     WITH tmpPartner AS (SELECT tmp.PartnerId
                              , tmp.ContractId
                         FROM lpSelect_Movement_PromoPartner_Detail (inMovementId:= inMovementId) AS tmp
                        )
  , tmpMovement_sale AS (SELECT Movement.Id AS MovementId
                              , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
                         FROM tmpPartner
                              INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.ObjectId = tmpPartner.PartnerId
                                                                     AND MLO_To.DescId = zc_MovementLinkObject_To()
                              INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate - INTERVAL '0 DAY' AND vbEndDate + INTERVAL '0 DAY'
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                     AND MovementDate_OperDatePartner.MovementId = MLO_To.MovementId
                              INNER JOIN Movement ON Movement.Id = MLO_To.MovementId
                                                 AND Movement.DescId = zc_Movement_Sale()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = MLO_To.MovementId
                                                                      AND MLO_From.DescId = zc_MovementLinkObject_From()
                              LEFT JOIN MovementLinkObject AS MLO_Contract ON MLO_Contract.MovementId = MLO_To.MovementId
                                                                          AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()
                              LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                        ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                                       AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                         WHERE (MLO_From.ObjectId = vbUnitId OR vbUnitId = 0)
                           AND (MLO_Contract.ObjectId = tmpPartner.ContractId OR tmpPartner.ContractId = 0)
                        )
        , tmpMI_sale AS (SELECT DISTINCT
                                tmpMovement_sale.MovementId     AS MovementId
                              , MovementItem.Id                 AS MovementItemId
                              , _tmpMI_promo.GoodsId            AS GoodsId
                              , _tmpMI_promo.GoodsKindId        AS GoodsKindId
                              , MIFloat_AmountPartner.ValueData AS AmountPartner
                              , _tmpMI_promo.PriceWithOutVAT    AS PriceWithOutVAT
                         FROM tmpMovement_sale
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_sale.MovementId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                          ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                         AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                                         AND MIFloat_PromoMovement.ValueData <> 0
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              INNER JOIN _tmpMI_promo ON _tmpMI_promo.GoodsId = MovementItem.ObjectId
                                                 AND (_tmpMI_promo.GoodsKindId = MILinkObject_GoodsKind.ObjectId OR _tmpMI_promo.GoodsKindId = 0)
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                          ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                              -- INNER JOIN MovementItemFloat AS MIFloat_Price
                              --                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                              --                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              --                             AND MIFloat_Price.ValueData = CASE WHEN tmpMovement_sale.PriceWithVAT = TRUE THEN _tmpMI_promo.PriceWithVAT ELSE _tmpMI_promo.PriceWithOutVAT END
                         WHERE MIFloat_AmountPartner.ValueData > 0
                           AND COALESCE (MIFloat_PromoMovement.ValueData, inMovementId) = inMovementId
                        )
         -- Данные Sale
        INSERT INTO _tmpMI_sale (MovementId, MovementItemId, GoodsId, GoodsKindId, AmountPartner, PriceWithOutVAT)
           SELECT tmpMovement_sale.MovementId
                , tmpMI_sale.MovementItemId
                , tmpMI_sale.GoodsId
                , tmpMI_sale.GoodsKindId
                , tmpMI_sale.AmountPartner
                , tmpMI_sale.PriceWithOutVAT
           FROM tmpMovement_sale
                LEFT JOIN tmpMI_sale ON tmpMI_sale.MovementId = tmpMovement_sale.MovementId;


     -- Данные Order
     INSERT INTO _tmpMI_order (MovementId, MovementItemId, GoodsId, GoodsKindId, AmountPartner, PriceWithOutVAT)
        SELECT DISTINCT
               MovementLinkMovement_Order.MovementChildId AS MovementId
             , MovementItem.Id                 AS MovementItemId
             , _tmpMI_promo.GoodsId            AS GoodsId
             , _tmpMI_promo.GoodsKindId        AS GoodsKindId
             , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) AS AmountPartner
             , _tmpMI_promo.PriceWithOutVAT    AS PriceWithOutVAT
        FROM (SELECT DISTINCT _tmpMI_sale.MovementId FROM _tmpMI_sale WHERE _tmpMI_sale.MovementItemId <> 0) AS tmp
             INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                             ON MovementLinkMovement_Order.MovementId = tmp.MovementId
                                            AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
             INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement_Order.MovementChildId
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND MovementItem.isErased = FALSE
             LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                         ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                        AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                        AND MIFloat_PromoMovement.ValueData <> 0
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             INNER JOIN _tmpMI_promo ON _tmpMI_promo.GoodsId = MovementItem.ObjectId
                                    AND (_tmpMI_promo.GoodsKindId = MILinkObject_GoodsKind.ObjectId OR _tmpMI_promo.GoodsKindId = 0)
             LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
             -- INNER JOIN MovementItemFloat AS MIFloat_Price
             --                              ON MIFloat_Price.MovementItemId = MovementItem.Id
             --                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
             --                             AND MIFloat_Price.ValueData = CASE WHEN tmpMovement_sale.PriceWithVAT = TRUE THEN _tmpMI_promo.PriceWithVAT ELSE _tmpMI_promo.PriceWithOutVAT END
        WHERE (MovementItem.Amount <> 0 OR MIFloat_AmountSecond.ValueData <> 0)
          AND COALESCE (MIFloat_PromoMovement.ValueData, inMovementId) = inMovementId
       ;

     -- Результат - в Movement Продажа + Order
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo(), tmp.MovementId, TRUE)
     FROM (SELECT DISTINCT _tmpMI_sale.MovementId FROM _tmpMI_sale WHERE _tmpMI_sale.MovementItemId <> 0
          UNION
           SELECT DISTINCT _tmpMI_order.MovementId FROM _tmpMI_order
          ) AS tmp
     ;
     -- Результат - в MovementItem Продажа + Order
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), tmp.MovementItemId, inMovementId)
     FROM (SELECT _tmpMI_sale.MovementItemId FROM _tmpMI_sale WHERE _tmpMI_sale.MovementItemId <> 0
          UNION
           SELECT _tmpMI_order.MovementItemId FROM _tmpMI_order
          ) AS tmp
     ;
     -- Результат - Итоги в MovementItem Акция
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOut(), MI_PromoGoods.Id, COALESCE (tmp_sale.AmountPartner, 0))
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), MI_PromoGoods.Id, COALESCE (tmp_order.AmountPartner, 0))
     FROM MovementItem_PromoGoods_View AS MI_PromoGoods
          LEFT JOIN (SELECT _tmpMI_sale.GoodsId, _tmpMI_sale.GoodsKindId, SUM (_tmpMI_sale.AmountPartner) AS AmountPartner, _tmpMI_sale.PriceWithOutVAT
                     FROM _tmpMI_sale
                     GROUP BY _tmpMI_sale.GoodsId, _tmpMI_sale.GoodsKindId, _tmpMI_sale.PriceWithOutVAT
                    ) AS tmp_sale ON tmp_sale.GoodsId            = MI_PromoGoods.GoodsId
                                 AND tmp_sale.GoodsKindId        = COALESCE (MI_PromoGoods.GoodsKindId, 0)
                                 AND tmp_sale.PriceWithOutVAT    = MI_PromoGoods.PriceWithOutVAT
                                 AND MI_PromoGoods.isErased = FALSE
                                 AND MI_PromoGoods.Amount   <> 0 -- % скидки на товар
          LEFT JOIN (SELECT _tmpMI_order.GoodsId, _tmpMI_order.GoodsKindId, SUM (_tmpMI_order.AmountPartner) AS AmountPartner, _tmpMI_order.PriceWithOutVAT
                     FROM _tmpMI_order
                     GROUP BY _tmpMI_order.GoodsId, _tmpMI_order.GoodsKindId, _tmpMI_order.PriceWithOutVAT
                    ) AS tmp_order ON tmp_order.GoodsId            = MI_PromoGoods.GoodsId
                                  AND tmp_order.GoodsKindId        = COALESCE (MI_PromoGoods.GoodsKindId, 0)
                                  AND tmp_order.PriceWithOutVAT    = MI_PromoGoods.PriceWithOutVAT
                                  AND MI_PromoGoods.isErased = FALSE
                                  AND MI_PromoGoods.Amount   <> 0 -- % скидки на товар
     WHERE MI_PromoGoods.MovementId = inMovementId
    ;
    */
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 26.11.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Promo_Data (inMovementId:= 2641111, inSession:= zfCalc_UserAdmin())
