-- Function: lpInsertUpdate_MovementItem_GoodsSPRegistry_1303()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsSPRegistry_1303 (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                        , TVarChar, TVarChar, TDateTime, TDateTime, TFloat, Integer, TFloat, Integer, TDateTime
                                                                        , Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_GoodsSPRegistry_1303(
 INOUT ioId                  Integer   ,    -- Ключ объекта <Элемент документа>
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
    IN inUserId              Integer        -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ReestrDateSP(), ioId, inReestrDateSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ValiditySP(), ioId, inValiditySP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OrderDateSP(), ioId, inOrderDateSP);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceOptSP(), ioId, inPriceOptSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ExchangeRate(), ioId, inExchangeRate);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OrderNumberSP(), ioId, inOrderNumberSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ID_MED_FORM(), ioId, inID_MED_FORM);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MorionSP(), ioId, inMorionSP);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_CodeATX(), ioId, inCodeATX);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrSP(), ioId, inReestrSP);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP(), ioId, inIntenalSPId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BrandSP(), ioId, inBrandSPId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP_1303(), ioId, inKindOutSP_1303Id);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Dosage_1303(), ioId, inDosage_1303Id);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CountSP_1303(), ioId, inCountSP_1303Id);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MakerSP_1303(), ioId, inMakerSP_1303Id);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Country_1303(), ioId, inCountry_1303Id);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioId, inCurrencyId);


    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.05.22                                                       *
 */