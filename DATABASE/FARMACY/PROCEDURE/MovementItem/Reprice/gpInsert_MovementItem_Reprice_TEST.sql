-- Function: gpInsert_MovementItem_Reprice_TEST()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Reprice_TEST ();

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Reprice_TEST()
RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN


    -- !!!Протокол - отладка Скорости!!!
    vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


    PERFORM gpInsertUpdate_MovementItem_Reprice (ioId                  := 0 -- Ключ записи
                                               , inGoodsId             := Id -- Товары
                                               , inUnitId              := 6128298 -- подразделение
                                               , inUnitId_Forwarding   := 0 -- Подразделения(основание для равенства цен)
                                               , inTax                 := 0 -- % +/-
                                               , inJuridicalId         := JuridicalId -- поставщик
                                               , inContractId          := ContractId -- Договор
                                               , inExpirationDate      := ExpirationDate -- Срок годности
                                               , inMinExpirationDate   := MinExpirationDate -- Срок годности остатка
                                               , inAmount              := RemainsCount -- Количество (Остаток)
                                               , inPriceOld            := 1 -- Цена старая
                                               , inPriceNew            := 2 -- Цена новая
                                               , inJuridical_Price     := 3 -- Цена поставщика
                                               , inJuridical_Percent   := 1 -- % Корректировки наценки поставщика
                                               , inContract_Percent    := 1 -- % Корректировки наценки Договора
                                               , inGUID                := '123'  -- GUID для определения текущей переоценки
                                               , inSession             := '3'  -- сессия пользователя
                                                )
    FROM gpSelect_AllGoodsPrice (inUnitId := 6128298 , inUnitId_to := 0 , inMinPercent := 0 , inVAT20 := 'True' , inTaxTo := 0 , inPriceMaxTo := 0 ,  inSession := '3')
      AS tmp;

    RAISE EXCEPTION ' %  %', vbOperDate_StartBegin, CLOCK_TIMESTAMP();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 18.02.16         *
 27.11.15                                                                       *
*/
-- SELECT COUNT(*) FROM Log_Reprice
-- SELECT * FROM Log_Reprice WHERE TextValue NOT LIKE '%InsertUpdate%' ORDER BY Id DESC LIMIT 100
-- SELECT * FROM Log_Reprice ORDER BY Id DESC LIMIT 100
-- SELECT * FROM gpInsert_MovementItem_Reprice_TEST()
