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
   DECLARE vbEndDate TDateTime;
   DECLARE vbUnitId Integer;
   DECLARE vbStatusId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

     -- параметры из документа <Акции>
     SELECT Movement_Promo_View.StatusId
          , Movement_Promo_View.StartSale
          , Movement_Promo_View.EndSale
          , COALESCE (Movement_Promo_View.UnitId, 0)
            INTO vbStatusId, vbStartDate, vbEndDate, vbUnitId
     FROM Movement_Promo_View
     WHERE Movement_Promo_View.Id = inMovementId
    ;

     IF vbStatusId <> zc_Enum_Status_Complete()
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не проведен.';
     END ID;

     -- данные по продажам, в которых найдена акция
     CREATE TEMP TABLE _tmpMI_sale (MovementId Integer, MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat, PriceWithOutVAT TFloat) ON COMMIT DROP;

     WITH tmpGoods AS (SELECT DISTINCT
                              MI_PromoGoods.GoodsId
                            , COALESCE (MI_PromoGoods.GoodsKindId, 0) AS GoodsKindId
                            , MI_PromoGoods.PriceWithOutVAT  -- Цена отгрузки без учета НДС, с учетом скидки
                            , MI_PromoGoods.PriceWithVAT     -- Цена отгрузки с учетом НДС, с учетом скидки
                       FROM MovementItem_PromoGoods_View AS MI_PromoGoods
                       WHERE MI_PromoGoods.MovementId = inMovementId
                         AND MI_PromoGoods.isErased = FALSE
                         AND MI_PromoGoods.Amount <> 0 -- % скидки на товар
                      )
  , tmpPartner_all AS (SELECT Movement_PromoPartner_View.PartnerId
                            , Movement_PromoPartner_View.PartnerDescId
                            , COALESCE (Movement_PromoPartner_View.ContractId, 0) AS ContractId
                       FROM Movement_PromoPartner_View
                       WHERE Movement_PromoPartner_View.ParentId = inMovementId
                         AND Movement_PromoPartner_View.isErased = FALSE
                      )
      , tmpPartner AS (SELECT tmpPartner_all.PartnerId
                            , tmpPartner_all.ContractId
                       FROM tmpPartner_all
                       WHERE tmpPartner_all.PartnerDescId = zc_Object_Partner()
                      UNION
                       SELECT ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                            , tmpPartner_all.ContractId
                       FROM tmpPartner_all
                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = tmpPartner_all.PartnerId
                                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                       WHERE tmpPartner_all.PartnerDescId = zc_Object_Juridical()
                      UNION
                       SELECT ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                            , tmpPartner_all.ContractId
                       FROM tmpPartner_all
                            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ChildObjectId = tmpPartner_all.PartnerId
                                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                       WHERE tmpPartner_all.PartnerDescId = zc_Object_Retail()
                      )
, tmpMovement_sale AS (SELECT Movement.Id AS MovementId
                            , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
                       FROM tmpPartner
                            INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.ObjectId = tmpPartner.PartnerId
                                                                   AND MLO_To.DescId = zc_MovementLinkObject_To()
                            INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                    ON MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate - INTERVAL '3 DAY' AND vbEndDate + INTERVAL '3 DAY'
                                                   AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                   AND MovementDate_OperDatePartner.MovementId = MLO_To.MovementId
                            INNER JOIN Movement ON Movement.Id = MLO_To.MovementId
                                               AND Movement.DescId = zc_Movement_Sale()
                                               AND Movement.StatusId = zc_Enum_Status_Complete()
                            LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = MLO_To.MovementId
                                                                    AND MLO_From.DescId = zc_MovementLinkObject_From()
                            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                       WHERE (MLO_From.ObjectId = vbUnitId OR vbUnitId = 0)
                      )

      , tmpMI_sale AS (SELECT DISTINCT
                              tmpMovement_sale.MovementId     AS MovementId
                            , MovementItem.Id                 AS MovementItemId
                            , tmpGoods.GoodsId                AS GoodsId
                            , tmpGoods.GoodsKindId            AS GoodsKindId
                            , MIFloat_AmountPartner.ValueData AS AmountPartner
                            , tmpGoods.PriceWithOutVAT        AS PriceWithOutVAT
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
                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                               AND (tmpGoods.GoodsKindId = MILinkObject_GoodsKind.ObjectId OR tmpGoods.GoodsKindId = 0)
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                            INNER JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                        AND MIFloat_Price.ValueData = CASE WHEN tmpMovement_sale.PriceWithVAT = TRUE THEN tmpGoods.PriceWithVAT ELSE tmpGoods.PriceWithOutVAT END
                       WHERE MIFloat_AmountPartner.ValueData > 0
                         AND COALESCE (MIFloat_PromoMovement.ValueData, inMovementId) = inMovementId
                      )
        INSERT INTO _tmpMI_sale (MovementId, MovementItemId, GoodsId, GoodsKindId, AmountPartner, PriceWithOutVAT)
           SELECT tmpMovement_sale.MovementId
                , tmpMI_sale.MovementItemId
                , tmpMI_sale.GoodsId
                , tmpMI_sale.GoodsKindId
                , tmpMI_sale.AmountPartner
                , tmpMI_sale.PriceWithOutVAT
           FROM tmpMovement_sale
                LEFT JOIN tmpMI_sale ON tmpMI_sale.MovementId = tmpMovement_sale.MovementId;
	

     -- Результат - в Movement Продажа
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo(), tmp.MovementId, TRUE)
     FROM (SELECT DISTINCT _tmpMI_sale.MovementId FROM _tmpMI_sale WHERE _tmpMI_sale.MovementItemId <> 0) AS tmp
     ;
     -- Результат - в MovementItem Продажа
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), _tmpMI_sale.MovementItemId, inMovementId)
     FROM _tmpMI_sale
     WHERE _tmpMI_sale.MovementItemId <> 0
     ;
     -- Результат - в MovementItem Акция
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOut(), MI_PromoGoods.Id, COALESCE (tmp.AmountPartner, 0))
     FROM MovementItem_PromoGoods_View AS MI_PromoGoods
          LEFT JOIN (SELECT _tmpMI_sale.GoodsId, _tmpMI_sale.GoodsKindId, SUM (_tmpMI_sale.AmountPartner) AS AmountPartner, _tmpMI_sale.PriceWithOutVAT
                     FROM _tmpMI_sale
                     GROUP BY _tmpMI_sale.GoodsId, _tmpMI_sale.GoodsKindId, _tmpMI_sale.PriceWithOutVAT
                    ) AS tmp ON tmp.GoodsId            = MI_PromoGoods.GoodsId
                            AND tmp.GoodsKindId        = COALESCE (MI_PromoGoods.GoodsKindId, 0)
                            AND tmp.PriceWithOutVAT    = MI_PromoGoods.PriceWithOutVAT
                            AND MI_PromoGoods.isErased = FALSE
                            AND MI_PromoGoods.Amount   <> 0 -- % скидки на товар
     WHERE MI_PromoGoods.MovementId = inMovementId
    ;
     

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
