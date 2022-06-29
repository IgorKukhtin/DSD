-- Function: lpInsertUpdate_MovementItem_GoodsSPSearch_1303()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsSPSearch_1303 (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                        , TVarChar, TVarChar, TDateTime, TFloat, Integer, TFloat, Integer, TDateTime
                                                                        , Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_GoodsSPSearch_1303(
 INOUT ioId                     Integer   ,    -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   ,    -- Идентификатор документа

    IN inCol                    Integer   ,    -- Номер по порядку

    IN inIntenalSP_1303Id       Integer   ,    -- Міжнародна непатентована або загальноприйнята назва лікарського засобу (1)
    IN inBrandSPId              Integer   ,    -- Торговельна назва лікарського засобу (2)

    IN inKindOutSP_1303Id       Integer   ,    -- Форма випуску (3)
    IN inDosage_1303Id          Integer   ,    -- Дозування (Соц. проект)(4)
    IN inCountSP_1303Id         Integer   ,    -- Кількість одиниць лікарського засобу у споживчій упаковці (5)
    IN inMakerCountrySP_1303Id  Integer   ,    -- Найменування виробника, країна (6)

    IN inCodeATX                TVarChar  ,    -- Код АТХ (7)
    IN inReestrSP               TVarChar  ,    -- Номер реєстраційного посвідчення на лікарський засіб (8)
    IN inValiditySP             TDateTime ,    -- Дата закінчення строку дії реєстраційного посвідчення на лікарський засіб (9)

    IN inPriceOptSP             TFloat    ,    -- Задекларована оптово-відпускна ціна (грн.)(Соц. проект)(10)
    IN inCurrencyId             Integer   ,    -- Валюта (Соц. проект)(11)
    IN inExchangeRate           TFloat    ,    -- Офіційний курс,встановлений Національним банком України на дату подання декларації зміни оптово-відпускної ціни(Соц. проект)(11)

    IN inOrderNumberSP          Integer   ,    -- № накау, в якому внесено ЛЗ(Соц. проект)(12)
    IN inOrderDateSP            TDateTime ,    -- Дата наказу, в якому внесено ЛЗ(Соц. проект)(12)

    IN inUserId                 Integer        -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), 0, inMovementId, inCol, NULL);
    
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
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_CodeATX(), ioId, inCodeATX);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrSP(), ioId, inReestrSP);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP_1303(), ioId, inIntenalSP_1303Id);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BrandSP(), ioId, inBrandSPId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP_1303(), ioId, inKindOutSP_1303Id);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Dosage_1303(), ioId, inDosage_1303Id);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CountSP_1303(), ioId, inCountSP_1303Id);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MakerCountrySP_1303(), ioId, inMakerCountrySP_1303Id);
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