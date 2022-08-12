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
 INOUT ioId                   Integer   , -- ���� ������� <������� ���������>
    IN inMovementId           Integer   ,
    IN inGoodsId              Integer   , -- ������
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
    IN inUserId               Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColSP(), ioId, inColSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSPMin(), ioId, inCountSPMin);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSP(), ioId, inCountSP);
    -- ��������� <>
    IF inPriceOptSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceOptSP(), ioId, inPriceOptSP);
    END IF;
    -- ��������� <>
    IF inPriceRetSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceRetSP(), ioId, inPriceRetSP);
    END IF;
    -- ��������� <>
    IF inDailyNormSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DailyNormSP(), ioId, inDailyNormSP);
    END IF;
    -- ��������� <>
    IF inDailyCompensationSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DailyCompensationSP(), ioId, inDailyCompensationSP);
    END IF;
    -- ��������� <>
    IF inPriceSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSP(), ioId, inPriceSP);
    END IF;
    -- ��������� <>
    IF inPaymentSP IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PaymentSP(), ioId, inPaymentSP);
    END IF;
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_GroupSP(), ioId, inGroupSP);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DenumeratorValueSP(), ioId, inDenumeratorValueSP);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Pack(), ioId, inPack);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_CodeATX(), ioId, inCodeATX);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_MakerSP(), ioId, inMakerSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrSP(), ioId, inReestrSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrDateSP(), ioId, inReestrDateSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_IdSP(), ioId, inIdSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_DosageIdSP(), ioId, inDosageIdSP);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ProgramIdSP(), ioId, inProgramIdSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_NumeratorUnitSP(), ioId, inNumeratorUnitSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_DenumeratorUnitSP(), ioId, inDenumeratorUnitSP);
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP(), ioId, inIntenalSPId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BrandSP(), ioId, inBrandSPId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP(), ioId, inKindOutSPId);


    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.    ������ �.�.   ���������� �.�.
 31.07.19         *
 22.04.19         * add IdSP, inDosageIdSP
 14.08.18         *
 */