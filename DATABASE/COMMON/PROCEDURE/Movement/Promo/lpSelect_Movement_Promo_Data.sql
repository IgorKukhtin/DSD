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
             , CountForPrice         TFloat
             , PriceWithOutVAT_orig  TFloat   -- Цена отгрузки без учета НДС, с учетом скидки, грн
             , PriceWithVAT_orig     TFloat   -- Цена отгрузки с учетом НДС, с учетом скидки, грн
             , isChangePercent     Boolean -- учитывать % скидки по договору
              )
AS
$BODY$
BEGIN
     -- RAISE EXCEPTION '% % % %', inOperDate, inPartnerId, inContractId, inUnitId;

     -- Результат
     RETURN QUERY
        SELECT tmp.MovementId
             , tmp.GoodsId
             , tmp.GoodsKindId
             , tmp.MovementPromo
             , tmp.TaxPromo
             , tmp.PriceWithOutVAT
             , tmp.PriceWithVAT
             , tmp.CountForPrice
             , tmp.PriceWithOutVAT_orig
             , tmp.PriceWithVAT_orig
             , tmp.isChangePercent
        FROM lpSelect_Movement_Promo_Data_all (inOperDate     := inOperDate
                                             , inPartnerId    := inPartnerId
                                             , inContractId   := inContractId
                                             , inUnitId       := inUnitId
                                             , inIsReturn     := FALSE
                                              ) AS tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 21.08.16                                        *
*/

-- тест
-- SELECT * FROM lpSelect_Movement_Promo_Data (inOperDate:= CURRENT_DATE, inPartnerId:= 324124, inContractId:= 0, inUnitId:= 0) AS tmp LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = GoodsId LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = GoodsKindId LEFT JOIN Movement ON Movement.Id = MovementId
