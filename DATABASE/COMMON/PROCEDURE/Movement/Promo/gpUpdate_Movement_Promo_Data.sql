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
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

     -- параметры из документа <Акции>
     SELECT Movement_Promo.StartSale
          , Movement_Promo.EndSale
          , Movement_Promo.UnitId
            INTO vbStartDate, vbEndDate, vbUnitId
     FROM Movement_Promo_View
     WHERE Movement_Promo_View.Id = inMovementId;


     CREATE TEMP TABLE _tmpItem (MovementDescId Integer, OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, OperSumm_Currency TFloat, OperSumm_Diff TFloat
                               , MovementItemId Integer, ContainerId Integer, ContainerId_Currency Integer, ContainerId_Diff Integer, ProfitLossId_Diff Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_Balance Integer, BusinessId_ProfitLoss Integer, JuridicalId_Basis Integer
                               , UnitId Integer, PositionId Integer, PersonalServiceListId Integer, BranchId_Balance Integer, BranchId_ProfitLoss Integer, ServiceDateId Integer, ContractId Integer, PaidKindId Integer
                               , PartionMovementId Integer
                               , AnalyzerId Integer, ObjectIntId_Analyzer Integer, ObjectExtId_Analyzer Integer
                               , CurrencyId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;

     WITH tmpGoods AS (SELECT MI_PromoGoods.GoodsId
                            , COALESCE (MI_PromoGoods.GoodsKindId, 0) AS GoodsKindId
                            , MI_PromoGoods.PriceWithOutVAT  --Цена отгрузки без учета НДС, с учетом скидки, грн
                            , MI_PromoGoods.PriceWithVAT     --Цена отгрузки с учетом НДС, с учетом скидки, грн
                       FROM MovementItem_PromoGoods_View AS MI_PromoGoods
                       WHERE MI_PromoGoods.MovementId = inMovementId
                         AND MI_PromoGoods.isErased = FALSE
                      )
  , tmpPartner_all AS (SELECT Movement_PromoPartner_View.PartnerId
                            , Movement_PromoPartner.PartnerDescId
                            , COALESCE (Movement_PromoPartner_View.ContractId, 0) AS ContractId
                       FROM Movement_PromoPartner_View
                       WHERE Movement_PromoPartner_View.MovementId = inMovementId
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
, tmpMovement_order AS (SELECT tmpPartner_all.PartnerId
                        FROM tmpPartner
                             INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.ObjectId = tmpPartner.PartnerId
                                                                      AND MLO_From.DescId = tmpPartner.PartnerId
                             INNER JOIN Movement ON Movement.DescId = zc_Movement_Order()
                                                AND Movement.OperDate BETWEEN vbStartDate - INTERVAL '3 DAY' AND vbEndDate + INTERVAL '3 DAY'
                                                AND Movement.MovementId = MLO_From.MovementId
                                                AND Movement.StatusId = zc_Enum_KindStatus_Complete()
                        WHERE tmpPartner_all.PartnerDescId = zc_Object_Partner()
                       )


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 26.11.15                                        *
*/