-- Все Акции на дату по Контрагент + Договор + Подразделение
-- Function: lpSelect_Movement_Promo_Data()

DROP FUNCTION IF EXISTS lpSelect_Movement_Promo_Data (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_Movement_Promo_Data(
    IN inOperDate     TDateTime , --
    IN inPartnerId    Integer   , --
    IN inContractId   Integer   , --
    IN inUnitId       Integer     --
)
RETURNS TABLE (MovementId          Integer -- Документ
             , GoodsId             Integer
             , GoodsKindId         Integer
             , MovementPromo       TVarChar
             , TaxPromo            TFloat  
             , PriceWithOutVAT     TFloat  -- Цена отгрузки без учета НДС, с учетом скидки, грн
             , PriceWithVAT        TFloat  -- Цена отгрузки с учетом НДС, с учетом скидки, грн
              )
AS
$BODY$
BEGIN

     -- RAISE EXCEPTION '% % % %', inOperDate, inPartnerId, inContractId, inUnitId;


     RETURN QUERY
        WITH tmpMovement AS 
                      (SELECT Movement.Id AS MovementId
                            , zfCalc_PromoMovementName (NULL, Movement.InvNumber :: TVarChar, Movement.OperDate, MovementDate_StartSale.ValueData, MovementDate_EndSale.ValueData) AS MovementPromo
                       FROM MovementDate AS MovementDate_StartSale
                            INNER JOIN MovementDate AS MovementDate_EndSale
                                                    ON MovementDate_EndSale.ValueData >= inOperDate
                                                   AND MovementDate_EndSale.MovementId =  MovementDate_StartSale.MovementId
                                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                            INNER JOIN Movement ON Movement.DescId = zc_Movement_Promo()
                                               AND Movement.Id = MovementDate_StartSale.MovementId
                                               AND Movement.StatusId = zc_Enum_Status_Complete()
                       WHERE MovementDate_StartSale.ValueData <= inOperDate
                         AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
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
                            , 0                     AS GoodsKindId
                            -- , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)   AS GoodsKindId
                            , COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0) AS PriceWithOutVAT
                            , COALESCE (MIFloat_PriceWithVAT.ValueData, 0)    AS PriceWithVAT
                       FROM tmpPartner
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpPartner.MovementId
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE
                            /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                            AND 1 = 0 -- !!!*/
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                                        ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                        ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                      )
        SELECT tmpResult.MovementId
             , tmpResult.GoodsId
             , tmpResult.GoodsKindId :: Integer AS GoodsKindId
             , tmpResult.MovementPromo
             , tmpResult.TaxPromo
             , tmpResult.PriceWithOutVAT :: TFloat AS PriceWithOutVAT
             , tmpResult.PriceWithVAT    :: TFloat AS PriceWithVAT
        FROM tmpResult
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 30.11.15                                        *
*/

-- тест
-- SELECT * FROM lpSelect_Movement_Promo_Data (inOperDate:= CURRENT_DATE, inPartnerId:= 324124, inContractId:= 0, inUnitId:= 0) AS tmp LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = GoodsId LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = GoodsKindId LEFT JOIN Movement ON Movement.Id = MovementId
