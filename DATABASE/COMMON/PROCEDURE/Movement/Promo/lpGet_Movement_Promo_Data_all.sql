-- Все Акции на дату по ТОВАР + Контрагент + Договор + Подразделение
-- Function: lpGet_Movement_Promo_Data_all()

-- DROP FUNCTION IF EXISTS lpGet_Movement_Promo_Data_test (TDateTime, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpGet_Movement_Promo_Data_all (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpGet_Movement_Promo_Data_all(
    IN inOperDate     TDateTime , --
    IN inPartnerId    Integer   , --
    IN inContractId   Integer   , --
    IN inUnitId       Integer   , --
    IN inGoodsId      Integer   , --
    IN inGoodsKindId  Integer   , --
    IN inIsReturn     Boolean     --
)
RETURNS TABLE (MovementId          Integer -- Документ
             , TaxPromo            TFloat  
             , PriceWithOutVAT     TFloat  -- Цена отгрузки без учета НДС, с учетом скидки, грн
             , PriceWithVAT        TFloat  -- Цена отгрузки с учетом НДС, с учетом скидки, грн
             , CountForPrice         TFloat
             , PriceWithOutVAT_orig  TFloat   -- Цена отгрузки без учета НДС, с учетом скидки, грн
             , PriceWithVAT_orig     TFloat   -- Цена отгрузки с учетом НДС, с учетом скидки, грн
             , isChangePercent     Boolean -- учитывать % скидки по договору
              )
AS
$BODY$
   DECLARE vbDescId_EndDate Integer;
BEGIN

     -- определили
     vbDescId_EndDate:= CASE WHEN inIsReturn = TRUE THEN zc_MovementDate_EndReturn() ELSE zc_MovementDate_EndSale() END;
     
     
     -- Результат
     RETURN QUERY
        WITH tmpDate_all AS 
                      (SELECT MovementDate_End_calc.MovementId
                            , MovementDate_StartSale.ValueData AS StartDate
                       FROM MovementDate AS MovementDate_End_calc
                            LEFT JOIN MovementDate AS MovementDate_StartSale
                                                   ON MovementDate_StartSale.MovementId = MovementDate_End_calc.MovementId
                                                  AND MovementDate_StartSale.DescId     = zc_MovementDate_StartSale()
                       WHERE MovementDate_End_calc.ValueData >= inOperDate
                         AND MovementDate_End_calc.DescId     = vbDescId_EndDate
                      )
           , tmpDate AS 
                      (SELECT tmpDate_all.MovementId
                       FROM tmpDate_all
                       WHERE tmpDate_all.StartDate <= inOperDate
                      )
           , tmpMovement_all AS 
                      (SELECT Movement.Id AS MovementId
                            , Movement.StatusId
                       FROM Movement
                       WHERE Movement.Id     IN (SELECT DISTINCT tmpDate.MovementId FROM tmpDate)
                         AND Movement.DescId = zc_Movement_Promo()
                      )
           , tmpMI_all AS 
                      (SELECT MovementItem.Id          AS MovementItemId
                            , MovementItem.MovementId  AS MovementId
                            , MovementItem.Amount      AS TaxPromo
                            , MovementItem.ObjectId    AS GoodsId
                            , MovementItem.isErased    AS isErased
                       FROM MovementItem
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpDate.MovementId FROM tmpDate)
                         AND MovementItem.DescId     = zc_MI_Master()
                      )
           , tmpMovement AS 
                      (SELECT tmpMovement_all.MovementId  AS MovementId
                            , tmpMI_all.MovementItemId    AS MovementItemId
                            , tmpMI_all.TaxPromo          AS TaxPromo
                       FROM tmpMovement_all
                            INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMovement_all.MovementId
                                                AND tmpMI_all.GoodsId    = inGoodsId
                                                AND tmpMI_all.isErased   = FALSE
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = tmpMI_all.MovementItemId
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                          --AND 1 = 0 -- !!!

                       WHERE tmpMovement_all.StatusId = zc_Enum_Status_Complete()
                         AND (MILinkObject_GoodsKind.ObjectId = inGoodsKindId OR COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0)
                      )
           , tmpMovement_PromoPartner AS 
                      (SELECT Movement.ParentId AS MovementId_parent
                            , Movement.Id       AS MovementId
                            , Movement.StatusId
                            , Movement.DescId
                       FROM Movement
                       WHERE Movement.ParentId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                         -- AND Movement.DescId = zc_Movement_PromoPartner()
                      )
           , tmpMLO AS 
                      (SELECT MovementLinkObject.MovementId
                            , MovementLinkObject.DescId
                            , MovementLinkObject.ObjectId
                       FROM MovementLinkObject
                       WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_PromoPartner.MovementId FROM tmpMovement_PromoPartner)
                      )
       , tmpPartner_all AS 
                      (SELECT tmpMovement.MovementId
                            , tmpMovement.MovementItemId
                            , tmpMovement.TaxPromo
                            , COALESCE (MLO_Partner.ObjectId, 0) AS ObjectId
                            , Object_by.DescId                   AS ObjectDescId
                       FROM tmpMovement
                            INNER JOIN tmpMovement_PromoPartner ON tmpMovement_PromoPartner.MovementId_parent = tmpMovement.MovementId
                            LEFT JOIN tmpMLO AS MLO_Partner
                                             ON MLO_Partner.MovementId = tmpMovement_PromoPartner.MovementId
                                            AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                            LEFT JOIN Object AS Object_by ON Object_by.Id = MLO_Partner.ObjectId
                            LEFT JOIN tmpMLO AS MLO_Contract
                                             ON MLO_Contract.MovementId = tmpMovement_PromoPartner.MovementId
                                            AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                            LEFT JOIN tmpMLO AS MLO_Unit
                                             ON MLO_Unit.MovementId = tmpMovement.MovementId
                                            AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                       WHERE (MLO_Contract.ObjectId = inContractId OR COALESCE (MLO_Contract.ObjectId, 0) = 0)
                         AND (MLO_Unit.ObjectId     = inUnitId     OR COALESCE (MLO_Unit.ObjectId, 0) = 0)
                         AND (MLO_Partner.ObjectId  = inPartnerId  OR Object_by.DescId <> zc_Object_Partner())
                      )
       , tmpResult AS (-- Контрагенты
                       SELECT tmpPartner_all.MovementId
                            , tmpPartner_all.MovementItemId
                            , tmpPartner_all.TaxPromo
                       FROM tmpPartner_all
                       WHERE tmpPartner_all.ObjectDescId = zc_Object_Partner()
                      UNION
                       -- из Юр. лиц
                       SELECT tmpPartner_all.MovementId
                            , tmpPartner_all.MovementItemId
                            , tmpPartner_all.TaxPromo
                       FROM tmpPartner_all
                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = tmpPartner_all.ObjectId
                                                 AND ObjectLink_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
                                                 AND ObjectLink_Partner_Juridical.ObjectId      = inPartnerId
                       WHERE tmpPartner_all.ObjectDescId = zc_Object_Juridical()
                      UNION
                       -- из Торговой сети
                       SELECT tmpPartner_all.MovementId
                            , tmpPartner_all.MovementItemId
                            , tmpPartner_all.TaxPromo
                       FROM tmpPartner_all
                            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ChildObjectId = tmpPartner_all.ObjectId
                                                 AND ObjectLink_Juridical_Retail.DescId        = zc_ObjectLink_Juridical_Retail()
                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                 AND ObjectLink_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
                                                 AND ObjectLink_Partner_Juridical.ObjectId      = inPartnerId
                       WHERE tmpPartner_all.ObjectDescId = zc_Object_Retail()
                      )
       , tmpChangePercent AS 
                      (SELECT DISTINCT
                              tmpResult.MovementId
                       FROM tmpResult
                            INNER JOIN MovementItem AS MI_Child
                                                    ON MI_Child.MovementId = tmpResult.MovementId
                                                   AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff() -- без учета % скидки по договору
                                                   AND MI_Child.isErased   = FALSE
                      )
        SELECT DISTINCT
               tmpResult.MovementId
             , tmpResult.TaxPromo
             , (COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0) / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END) :: TFloat AS PriceWithOutVAT
             , (COALESCE (MIFloat_PriceWithVAT.ValueData, 0)    / CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END) :: TFloat AS PriceWithVAT
             , CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END :: TFloat AS CountForPrice
             , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0) :: TFloat AS PriceWithOutVAT_orig
             , COALESCE (MIFloat_PriceWithVAT.ValueData, 0)    :: TFloat AS PriceWithVAT_orig
             , CASE WHEN tmpChangePercent.MovementId > 0 THEN FALSE ELSE TRUE END :: Boolean AS isChangePercent
        FROM tmpResult
             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                         ON MIFloat_PriceWithOutVAT.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_PriceWithOutVAT.DescId         = zc_MIFloat_PriceWithOutVAT()
             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                         ON MIFloat_PriceWithVAT.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_PriceWithVAT.DescId         = zc_MIFloat_PriceWithVAT()
             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                         ON MIFloat_CountForPrice.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
             LEFT JOIN tmpChangePercent ON tmpChangePercent.MovementId = tmpResult.MovementId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 21.08.16                                        *
 29.11.15                                        *
*/

-- тест
-- SELECT * FROM lpGet_Movement_Promo_Data_all (inOperDate:= CURRENT_DATE, inPartnerId:= 324124, inContractId:= NULL, inUnitId:= 0, inGoodsId:= 2524, inGoodsKindId:= NULL, inIsReturn:= FALSE) AS tmp LEFT JOIN Movement ON Movement.Id = MovementId
