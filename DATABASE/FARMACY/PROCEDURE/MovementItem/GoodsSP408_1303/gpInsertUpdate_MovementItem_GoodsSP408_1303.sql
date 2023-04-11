-- Function: gpInsert_MovementItem_GoodsSP408_1303()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsSP408_1303 (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                        , TVarChar, TVarChar, TDateTime, TDateTime, TFloat, Integer, TFloat, Integer, TDateTime
                                                                        , Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsSP408_1303(
 INOUT ioId                  Integer   , -- Ключ записи
    IN inMovementId          Integer   ,    -- Идентификатор документа

    IN inGoodsId             Integer   ,    -- Id Товара

    IN inIntenalSPId         Integer   ,    -- Міжнародна непатентована назва (Соц. проект)(2)
    IN inBrandSPId           Integer   ,    -- Торговельна назва лікарського засобу (Соц. проект)(4)

    IN inKindOutSP_1303Id    Integer   ,    -- Форма випуску (Соц. проект)(5)
    IN inDosage_1303Id       Integer   ,    -- Дозування (Соц. проект)(6)
    IN inCountSP_1303Id      Integer   ,    -- Кількість таблеток в упаковці (Соц. проект)(7)
    IN inMakerSP_1303Id      Integer   ,    -- Назва виробника (Соц. проект)(8)
    IN inCountry_1303Id      Integer   ,    -- Країна (Соц. проект)(9)

    IN inCodeATX             TVarChar  ,    -- Код АТХ (Соц. проект)(10)
    IN inReestrSP            TVarChar  ,    -- № реєстраційного посвідчення(Соц. проект)(11)
    IN inReestrDateSP        TDateTime ,    -- Дата реєстрації(Соц. проект)(12)
    IN inValiditySP          TDateTime ,    -- Термін дії(Соц. проект)(13)

    IN inPriceOptSP          TFloat    ,    -- Задекларована оптово-відпускна ціна (грн.)(Соц. проект)(14)
    IN inCurrencyId          Integer   ,    -- Валюта (Соц. проект)(16)
    IN inExchangeRate        TFloat    ,    -- Офіційний курс,встановлений Національним банком України на дату подання декларації зміни оптово-відпускної ціни(Соц. проект)(17)

    IN inOrderNumberSP       Integer   ,    -- № накау, в якому внесено ЛЗ(Соц. проект)(18)
    IN inOrderDateSP         TDateTime ,    -- Дата наказу, в якому внесено ЛЗ(Соц. проект)(19)

    IN inID_MED_FORM         Integer   ,    -- ID_MED_FORM(Соц. проект)(20)
    IN inMorionSP            Integer   ,    -- Код мориона(Соц. проект)(21)

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
    PERFORM lpInsertUpdate_MovementItem_GoodsSP408_1303 (ioId                  := COALESCE(ioId, 0)
                                                            , inMovementId          := inMovementId
                                                            , inGoodsId             := inGoodsId
                                                            , inIntenalSPId         := inIntenalSPId
                                                            , inBrandSPId           := inBrandSPId
                                                            , inKindOutSP_1303Id    := inKindOutSP_1303Id
                                                            , inDosage_1303Id       := inDosage_1303Id
                                                            , inCountSP_1303Id      := inCountSP_1303Id
                                                            , inMakerSP_1303Id      := inMakerSP_1303Id
                                                            , inCountry_1303Id      := inCountry_1303Id
                                                            , inCodeATX             := TRIM(inCodeATX)::TVarChar
                                                            , inReestrSP            := TRIM(inReestrSP)::TVarChar
                                                            , inReestrDateSP        := inReestrDateSP
                                                            , inValiditySP          := inValiditySP
                                                            , inPriceOptSP          := COALESCE (inPriceOptSP, 0) :: TFloat
                                                            , inCurrencyId          := inCurrencyId
                                                            , inExchangeRate        := COALESCE (inExchangeRate, 0) :: TFloat
                                                            , inOrderNumberSP       := inOrderNumberSP
                                                            , inOrderDateSP         := inOrderDateSP
                                                            , inID_MED_FORM         := inID_MED_FORM
                                                            , inMorionSP            := COALESCE (inMorionSP, 0)
                                                            , inUserId              := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.04.23                                                       *
*/
--

select * from gpInsertUpdate_MovementItem_GoodsSP408_1303(ioId := 514496660 , inMovementId := 27854839 , inGoodsId := 0 , inIntenalSPId := 19717536 , inBrandSPId := 19717553 , inKindOutSP_1303Id := 19717556 , inDosage_1303Id := 19717557 , inCountSP_1303Id := 19709040 , inMakerSP_1303Id := 19715021 , inCountry_1303Id := 19710413 , inCodeATX := 'J06BA01' , inReestrSP := 'UA/17277/01/01' , inReestrDateSP := ('22.02.2019')::TDateTime , inValiditySP := ('22.02.2024')::TDateTime , inPriceOptSP := 8744.31 , inCurrencyId := 19698853 , inExchangeRate := 33.7553 , inOrderNumberSP := 2841 , inOrderDateSP := ('09.12.2020')::TDateTime , inID_MED_FORM := 306189 , inMorionSP := 0 ,  inSession := '3');