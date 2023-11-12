-- Function: gpInsert_MovementItem_ConvertRemains()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ConvertRemains (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ConvertRemains(
 INOUT ioId                     Integer   ,    -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   ,    -- Идентификатор документа
    IN inGoodsId                Integer   ,    -- Товар

    IN inAmount                 TFloat    ,    -- Количество

    IN inPriceWithVAT           TFloat    ,    -- Цена с учетом НДС
    IN inVAT                    TFloat    ,    -- НДС

    IN inMeasure                TVarChar  ,    -- Единица измерения

    IN inComment                TVarChar  ,    -- Комментарий

    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    -- сохранить запись
    PERFORM lpInsertUpdate_MovementItem_ConvertRemains (ioId                  := COALESCE(ioId, 0)
                                                      , inMovementId          := inMovementId
                                                      , inGoodsId             := inGoodsId
                                                      , inAmount              := inAmount
                                                      , inPriceWithVAT        := inPriceWithVAT
                                                      , inVAT                 := inVAT
                                                      , inMeasure             := inMeasure
                                                      , inComment             := inComment
                                                      , inUserId              := vbUserId);

     -- пересчитали итоговые суммы
     PERFORM gpInsertUpdate_ConvertRemains_TotalSumm (ioId, inSession);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.10.2023                                                     *
*/
-- select * from gpInsertUpdate_MovementItem_ConvertRemains(ioId := 514496660 , inMovementId := 27854839 , inGoodsId := 0 , inIntenalSPId := 19717536 , inBrandSPId := 19717553 , inKindOutSP_1303Id := 19717556 , inDosage_1303Id := 19717557 , inCountSP_1303Id := 19709040 , inMakerSP_1303Id := 19715021 , inCountry_1303Id := 19710413 , inCodeATX := 'J06BA01' , inReestrSP := 'UA/17277/01/01' , inReestrDateSP := ('22.02.2019')::TDateTime , inValiditySP := ('22.02.2024')::TDateTime , inPriceOptSP := 8744.31 , inCurrencyId := 19698853 , inExchangeRate := 33.7553 , inOrderNumberSP := 2841 , inOrderDateSP := ('09.12.2020')::TDateTime , inID_MED_FORM := 306189 , inMorionSP := 0 ,  inSession := '3');