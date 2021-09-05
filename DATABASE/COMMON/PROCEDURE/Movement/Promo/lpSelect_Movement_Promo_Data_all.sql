-- Все Акции на дату по Контрагент + Договор + Подразделение
-- Function: lpSelect_Movement_Promo_Data_all()

DROP FUNCTION IF EXISTS lpSelect_Movement_Promo_Data_all (TDateTime, Integer, Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpSelect_Movement_Promo_Data_all(
    IN inOperDate     TDateTime , --
    IN inPartnerId    Integer   , --
    IN inContractId   Integer   , --
    IN inUnitId       Integer   , --
    IN inIsReturn     Boolean     --
)
RETURNS TABLE (MovementId            Integer -- Документ
             , GoodsId               Integer
             , GoodsKindId           Integer
             , MovementPromo         TVarChar -- 
             , TaxPromo              TFloat   -- % скидки товар
             , PriceWithOutVAT       TFloat   -- Цена отгрузки без учета НДС, с учетом скидки, грн
             , PriceWithVAT          TFloat   -- Цена отгрузки с учетом НДС, с учетом скидки, грн
             , CountForPrice         TFloat
             , PriceWithOutVAT_orig  TFloat   -- Цена отгрузки без учета НДС, с учетом скидки, грн
             , PriceWithVAT_orig     TFloat   -- Цена отгрузки с учетом НДС, с учетом скидки, грн
             , isChangePercent       Boolean  -- учитывать % скидки по договору
              )
AS
$BODY$
BEGIN
     -- Результат
     RETURN QUERY
        WITH tmpMovement AS 
                      (SELECT Movement.Id AS MovementId
                            , zfCalc_PromoMovementName (NULL, Movement.InvNumber :: TVarChar, Movement.OperDate, MovementDate_StartSale.ValueData, MovementDate_EndSale.ValueData) AS MovementPromo
                       FROM (SELECT inOperDate AS OperDate, CASE WHEN inIsReturn = TRUE THEN zc_MovementDate_EndReturn() ELSE zc_MovementDate_EndSale() END AS DescId_calc) AS tmp
                            INNER JOIN MovementDate AS MovementDate_StartSale
                                                    ON MovementDate_StartSale.ValueData <= tmp.OperDate
                                                   AND MovementDate_StartSale.DescId    = zc_MovementDate_StartSale()
                            INNER JOIN MovementDate AS MovementDate_EndSale
                                                    ON MovementDate_EndSale.ValueData  >= tmp.OperDate
                                                   AND MovementDate_EndSale.MovementId =  MovementDate_StartSale.MovementId
                                                   AND MovementDate_EndSale.DescId     = tmp.DescId_calc
                            INNER JOIN Movement ON Movement.DescId   = zc_Movement_Promo()
                                               AND Movement.Id       = MovementDate_StartSale.MovementId
                                               AND Movement.StatusId = zc_Enum_Status_Complete()
                      )
       , tmpChangePercent AS 
                      (SELECT DISTINCT
                              tmpMovement.MovementId
                       FROM tmpMovement
                            INNER JOIN MovementItem AS MI_Child
                                                    ON MI_Child.MovementId = tmpMovement.MovementId
                                                   AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff() -- без учета % скидки по договору
                                                   AND MI_Child.isErased   = FALSE
                      )
       , tmpPartner_all AS 
                      (SELECT tmpMovement.MovementId
                            , tmpMovement.MovementPromo
                            , COALESCE (MLO_Partner.ObjectId, 0) AS ObjectId
                            , Object_by.DescId                   AS ObjectDescId
                       FROM tmpMovement
                            INNER JOIN Movement AS Movement_PromoPartner
                                                ON Movement_PromoPartner.ParentId = tmpMovement.MovementId
                                               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                                               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                            LEFT JOIN MovementLinkObject AS MLO_Partner
                                                         ON MLO_Partner.MovementId = Movement_PromoPartner.Id
                                                        AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                            LEFT JOIN Object AS Object_by ON Object_by.Id = MLO_Partner.ObjectId
                            LEFT JOIN MovementLinkObject AS MLO_Contract
                                                         ON MLO_Contract.MovementId = Movement_PromoPartner.Id
                                                        AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                            LEFT JOIN MovementLinkObject AS MLO_Unit
                                                         ON MLO_Unit.MovementId = tmpMovement.MovementId
                                                        AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
                       WHERE (MLO_Contract.ObjectId = inContractId OR COALESCE (MLO_Contract.ObjectId, 0) = 0)
                         AND (MLO_Unit.ObjectId     = inUnitId     OR COALESCE (MLO_Unit.ObjectId, 0) = 0)
                         AND (MLO_Partner.ObjectId  = inPartnerId  OR Object_by.DescId <> zc_Object_Partner())
                      )
      , tmpPartner AS (-- Контрагенты
                       SELECT tmpPartner_all.MovementId
                            , tmpPartner_all.MovementPromo
                       FROM tmpPartner_all
                       WHERE tmpPartner_all.ObjectDescId = zc_Object_Partner()
                      UNION
                       -- из Юр. лиц
                       SELECT tmpPartner_all.MovementId
                            , tmpPartner_all.MovementPromo
                       FROM tmpPartner_all
                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = tmpPartner_all.ObjectId
                                                 AND ObjectLink_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
                                                 AND ObjectLink_Partner_Juridical.ObjectId      = inPartnerId
                       WHERE tmpPartner_all.ObjectDescId = zc_Object_Juridical()
                      UNION
                       -- из Торговой сети
                       SELECT tmpPartner_all.MovementId
                            , tmpPartner_all.MovementPromo
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
       , tmpResult AS (SELECT DISTINCT
                              tmpPartner.MovementId
                            , tmpPartner.MovementPromo
                            , MovementItem.Amount   AS TaxPromo
                            , MovementItem.ObjectId AS GoodsId
                          --, 0                     AS GoodsKindId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)   AS GoodsKindId
                            , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0) AS PriceWithOutVAT
                            , COALESCE (MIFloat_PriceWithVAT.ValueData, 0)    AS PriceWithVAT
                            , CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                       FROM tmpPartner
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpPartner.MovementId
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                          --AND 1 = 0 -- !!!
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                                        ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                        ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                      )
        -- Результат
        SELECT tmpResult.MovementId
             , tmpResult.GoodsId
             , tmpResult.GoodsKindId :: Integer AS GoodsKindId
             , tmpResult.MovementPromo
             , tmpResult.TaxPromo
             , (tmpResult.PriceWithOutVAT / tmpResult.CountForPrice) :: TFloat AS PriceWithOutVAT
             , (tmpResult.PriceWithVAT    / tmpResult.CountForPrice) :: TFloat AS PriceWithVAT
             , tmpResult.CountForPrice   :: TFloat AS CountForPrice
             , tmpResult.PriceWithOutVAT :: TFloat AS PriceWithOutVAT_orig
             , tmpResult.PriceWithVAT    :: TFloat AS PriceWithVAT_orig
             , CASE WHEN tmpChangePercent.MovementId > 0 THEN FALSE ELSE TRUE END :: Boolean AS isChangePercent
        FROM tmpResult
             LEFT JOIN tmpChangePercent ON tmpChangePercent.MovementId = tmpResult.MovementId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 21.08.16                                        *
 30.11.15                                        *
*/

-- тест
-- SELECT * FROM lpSelect_Movement_Promo_Data_all (inOperDate:= CURRENT_DATE, inPartnerId:= 324124, inContractId:= 0, inUnitId:= 0, inIsReturn:= FALSE) AS tmp LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = GoodsId LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = GoodsKindId LEFT JOIN Movement ON Movement.Id = MovementId
