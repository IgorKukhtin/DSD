-- Function: lpInsertUpdate_MovementItem_GoodsSPInform_1303()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsSPInform_1303 (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_GoodsSPInform_1303(
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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inCol, NULL);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceOptSP(), ioId, inPriceOptSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceMargSP(), ioId, inPriceMargSP);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Referral(), ioId, inReferral);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP_1303(), ioId, inIntenalSP_1303Id);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP_1303(), ioId, inKindOutSP_1303Id);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Dosage_1303(), ioId, inDosage_1303Id);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.04.23                                                       *
 */