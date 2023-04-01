-- Function: gpInsert_MovementItem_GoodsSPInform_1303()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsSPInform_1303 (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsSPInform_1303(
 INOUT ioId                     Integer   ,    -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   ,    -- Идентификатор документа
    IN inGoodsId                Integer   ,    -- Товар

    IN inCol                    Integer   ,    -- Номер по порядку

    IN inIntenalSP_1303Id       Integer   ,    -- Міжнародна непатентована або загальноприйнята назва лікарського засобу (1)
    IN inKindOutSP_1303Id       Integer   ,    -- Форма випуску (3)
    IN inDosage_1303Id          Integer   ,    -- Дозування (Соц. проект)(4)

    IN inPriceMargSP            TFloat    ,    -- Гранична оптово-відпускна ціна в перерахунку на одиницю лікарської форми (грн.)(Соц. проект)
    IN inPriceOptSP             TFloat    ,    -- Задекларована оптово-відпускна ціна (грн.)(Соц. проект)

    IN inReferral               TVarChar  ,    -- Реферування
  
    IN inSession                TVarChar    -- сессия пользователя
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
    PERFORM lpInsertUpdate_MovementItem_GoodsSPInform_1303 (ioId                  := COALESCE(ioId, 0)
                                                          , inMovementId          := inMovementId
                                                          , inGoodsId             := inGoodsId
                                                          , inCol                 := inCol
                                                          , inIntenalSP_1303Id    := inIntenalSP_1303Id
                                                          , inKindOutSP_1303Id    := inKindOutSP_1303Id
                                                          , inDosage_1303Id       := inDosage_1303Id
                                                          
                                                          , inPriceMargSP         := inPriceMargSP
                                                          , inPriceOptSP          := inPriceOptSP

                                                          , inReferral            := TRIM(inReferral)::TVarChar
                                                          , inUserId              := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.04.23                                                       *
*/
-- select * from gpInsertUpdate_MovementItem_GoodsSPInform_1303(ioId := 514496660 , inMovementId := 27854839 , inGoodsId := 0 , inIntenalSPId := 19717536 , inBrandSPId := 19717553 , inKindOutSP_1303Id := 19717556 , inDosage_1303Id := 19717557 , inCountSP_1303Id := 19709040 , inMakerSP_1303Id := 19715021 , inCountry_1303Id := 19710413 , inCodeATX := 'J06BA01' , inReestrSP := 'UA/17277/01/01' , inReestrDateSP := ('22.02.2019')::TDateTime , inValiditySP := ('22.02.2024')::TDateTime , inPriceOptSP := 8744.31 , inCurrencyId := 19698853 , inExchangeRate := 33.7553 , inOrderNumberSP := 2841 , inOrderDateSP := ('09.12.2020')::TDateTime , inID_MED_FORM := 306189 , inMorionSP := 0 ,  inSession := '3');