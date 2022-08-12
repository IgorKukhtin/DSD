-- Function: lpInsertUpdate_MovementItem_GoodsSP()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsSP (Integer, Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsSP (Integer, Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsSP (Integer, Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsSP (Integer, Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar, TVarChar
                                                           , Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsSP (Integer, Integer, Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar, TVarChar
                                                           , Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_GoodsSP(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   ,
    IN inGoodsId              Integer   , -- Товары
    IN inIntenalSPId          Integer ,
    IN inBrandSPId            Integer ,
    IN inKindOutSPId          Integer ,
    IN inColSP                TFloat  ,
    IN inCountSPMin           TFloat  , 
    IN inCountSP              TFloat  ,
    IN inPriceOptSP           TFloat  ,
    IN inPriceRetSP           TFloat  ,
    IN inDailyNormSP          TFloat  ,
    IN inDailyCompensationSP  TFloat  ,
    IN inPriceSP              TFloat  ,
    IN inPaymentSP            TFloat  ,
    IN inGroupSP              TFloat  ,
    IN inDenumeratorValueSP   TFloat  ,
    IN inPack                 TVarChar,
    IN inCodeATX              TVarChar,
    IN inMakerSP              TVarChar,
    IN inReestrSP             TVarChar,
    IN inReestrDateSP         TVarChar,
    IN inIdSP                 TVarChar,
    IN inDosageIdSP           TVarChar,
    
    IN inProgramIdSP          TVarChar  ,    --
    IN inNumeratorUnitSP      TVarChar  ,    --
    IN inDenumeratorUnitSP    TVarChar  ,    --
    IN inUserId               Integer     -- пользователь
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
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColSP(), ioId, inColSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSPMin(), ioId, inCountSPMin);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSP(), ioId, inCountSP);
    -- сохранили <>
    IF inPriceOptSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceOptSP(), ioId, inPriceOptSP);
    END IF;
    -- сохранили <>
    IF inPriceRetSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceRetSP(), ioId, inPriceRetSP);
    END IF;
    -- сохранили <>
    IF inDailyNormSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DailyNormSP(), ioId, inDailyNormSP);
    END IF;
    -- сохранили <>
    IF inDailyCompensationSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DailyCompensationSP(), ioId, inDailyCompensationSP);
    END IF;
    -- сохранили <>
    IF inPriceSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSP(), ioId, inPriceSP);
    END IF;
    -- сохранили <>
    IF inPaymentSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PaymentSP(), ioId, inPaymentSP);
    END IF;
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_GroupSP(), ioId, inGroupSP);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DenumeratorValueSP(), ioId, inDenumeratorValueSP);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Pack(), ioId, inPack);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_CodeATX(), ioId, inCodeATX);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_MakerSP(), ioId, inMakerSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrSP(), ioId, inReestrSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrDateSP(), ioId, inReestrDateSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_IdSP(), ioId, inIdSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_DosageIdSP(), ioId, inDosageIdSP);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ProgramIdSP(), ioId, inProgramIdSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_NumeratorUnitSP(), ioId, inNumeratorUnitSP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_DenumeratorUnitSP(), ioId, inDenumeratorUnitSP);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP(), ioId, inIntenalSPId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BrandSP(), ioId, inBrandSPId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP(), ioId, inKindOutSPId);


    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.    Кухтин И.В.   Климентьев К.И.
 31.07.19         *
 22.04.19         * add IdSP, inDosageIdSP
 14.08.18         *
 */