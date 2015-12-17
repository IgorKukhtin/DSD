-- Function: lpGet_Movement_Promo_Data()

DROP FUNCTION IF EXISTS lpGet_Movement_Promo_Data (TDateTime, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpGet_Movement_Promo_Data (TDateTime, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_Movement_Promo_Data(
    IN inOperDate     TDateTime , --
    IN inPartnerId    Integer   , --
    IN inContractId   Integer   , --
    IN inUnitId       Integer   , --
    IN inGoodsId      Integer   , --
    IN inGoodsKindId  Integer     --
)
RETURNS TABLE (MovementId          Integer -- Документ
             , TaxPromo            TFloat  
             , PriceWithOutVAT     TFloat  -- Цена отгрузки без учета НДС, с учетом скидки, грн
             , PriceWithVAT        TFloat  -- Цена отгрузки с учетом НДС, с учетом скидки, грн
              )
AS
$BODY$
BEGIN
     RETURN QUERY
        WITH tmpMovement AS 
                      (SELECT Movement.Id                                        AS MovementId
                            , MovementItem.Id                                    AS MovementItemId
                            , MovementItem.Amount                                AS TaxPromo
                       FROM MovementDate AS MovementDate_StartSale
                            INNER JOIN MovementDate AS MovementDate_EndSale
                                                    ON MovementDate_EndSale.ValueData >= inOperDate
                                                   AND MovementDate_EndSale.MovementId =  MovementDate_StartSale.MovementId
                                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                            INNER JOIN Movement ON Movement.DescId = zc_Movement_Promo()
                                               AND Movement.Id = MovementDate_StartSale.MovementId
                                               AND Movement.StatusId = zc_Enum_Status_Complete()
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.ObjectId = inGoodsId
                                                   AND MovementItem.isErased = FALSE
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                            AND 1 = 0 -- !!!

                       WHERE MovementDate_StartSale.ValueData <= inOperDate
                         AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                         AND (MILinkObject_GoodsKind.ObjectId = inGoodsKindId OR COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0)
                      )
       , tmpResult AS (SELECT tmpMovement.MovementId
                            , tmpMovement.MovementItemId
                            , tmpMovement.TaxPromo
                       FROM tmpMovement
                            INNER JOIN Movement AS Movement_PromoPartner
                                                ON Movement_PromoPartner.ParentId = tmpMovement.MovementId
                                               AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                                               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement_PromoPartner.Id
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.ObjectId = inPartnerId
                                                   AND MovementItem.isErased = FALSE
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                            LEFT JOIN MovementLinkObject AS MLO_Unit
                                                         ON MLO_Unit.MovementId = tmpMovement.MovementId
                                                        AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
                       WHERE (MILinkObject_Contract.ObjectId = inContractId OR COALESCE (MILinkObject_Contract.ObjectId, 0) = 0)
                         AND (MLO_Unit.ObjectId              = inUnitId     OR COALESCE (MLO_Unit.ObjectId, 0) = 0)
                      )
        SELECT DISTINCT
               tmpResult.MovementId
             , tmpResult.TaxPromo
             , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0) :: TFloat AS PriceWithOutVAT
             , COALESCE (MIFloat_PriceWithVAT.ValueData, 0)    :: TFloat AS PriceWithVAT
        FROM tmpResult
             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                         ON MIFloat_PriceWithOutVAT.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                         ON MIFloat_PriceWithVAT.MovementItemId = tmpResult.MovementItemId
                                        AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 29.11.15                                        *
*/

-- тест
-- SELECT * FROM lpGet_Movement_Promo_Data (inOperDate:= CURRENT_DATE, inPartnerId:= 536388, inContractId:= NULL, inUnitId:= 0, inGoodsId:= 2153, inGoodsKindId:= NULL)

