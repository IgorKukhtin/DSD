-- Все Акции на дату по ТОВАР + Контрагент + Договор + Подразделение
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
             , CountForPrice         TFloat
             , PriceWithOutVAT_orig  TFloat   -- Цена отгрузки без учета НДС, с учетом скидки, грн
             , PriceWithVAT_orig     TFloat   -- Цена отгрузки с учетом НДС, с учетом скидки, грн
             , isChangePercent     Boolean -- учитывать % скидки по договору
              )
AS
$BODY$
BEGIN
     -- Результат
     RETURN QUERY
        SELECT tmp.MovementId
             , tmp.TaxPromo
             , tmp.PriceWithOutVAT
             , tmp.PriceWithVAT
             , tmp.CountForPrice
             , tmp.PriceWithOutVAT_orig
             , tmp.PriceWithVAT_orig
             , tmp.isChangePercent
        FROM lpGet_Movement_Promo_Data_all (inOperDate     := inOperDate
                                          , inPartnerId    := inPartnerId
                                          , inContractId   := inContractId
                                          , inUnitId       := inUnitId
                                          , inGoodsId      := inGoodsId
                                          , inGoodsKindId  := inGoodsKindId
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
-- SELECT * FROM lpGet_Movement_Promo_Data (inOperDate:= CURRENT_DATE, inPartnerId:= 324124, inContractId:= NULL, inUnitId:= 0, inGoodsId:= 2524, inGoodsKindId:= NULL) AS tmp LEFT JOIN Movement ON Movement.Id = MovementId
