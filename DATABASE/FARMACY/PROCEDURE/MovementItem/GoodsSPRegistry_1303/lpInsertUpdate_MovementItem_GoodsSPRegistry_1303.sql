-- Function: lpInsertUpdate_MovementItem_GoodsSPRegistry_1303()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsSPRegistry_1303 (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                        , TVarChar, TVarChar, TDateTime, TDateTime, TFloat, Integer, TFloat, Integer, TDateTime
                                                                        , Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_GoodsSPRegistry_1303(
 INOUT ioId                  Integer   ,    -- ���� ������� <������� ���������>
    IN inMovementId          Integer   ,    -- ������������� ���������

    IN inGoodsId             Integer   ,    -- Id ������

    IN inIntenalSPId         Integer   ,    -- ̳�������� ������������� ����� (���. ������)(2)
    IN inBrandSPId           Integer   ,    -- ����������� ����� ���������� ������ (���. ������)(4)

    IN inKindOutSP_1303Id    Integer   ,    -- ����� ������� (���. ������)(5)
    IN inDosage_1303Id       Integer   ,    -- ��������� (���. ������)(6)
    IN inCountSP_1303Id      Integer   ,    -- ʳ������ �������� � �������� (���. ������)(7)
    IN inMakerSP_1303Id      Integer   ,    -- ����� ��������� (���. ������)(8)
    IN inCountry_1303Id      Integer   ,    -- ����� (���. ������)(9)

    IN inCodeATX             TVarChar  ,    -- ��� ��� (���. ������)(10)
    IN inReestrSP            TVarChar  ,    -- � ������������� ����������(���. ������)(11)
    IN inReestrDateSP        TDateTime ,    -- ���� ���������(���. ������)(12)
    IN inValiditySP          TDateTime ,    -- ����� 䳿(���. ������)(13)

    IN inPriceOptSP          TFloat    ,    -- ������������� ������-�������� ���� (���.)(���. ������)(14)
    IN inCurrencyId          Integer   ,    -- ������ (���. ������)(16)
    IN inExchangeRate        TFloat    ,    -- ��������� ����,������������ ������������ ������ ������ �� ���� ������� ���������� ���� ������-�������� ����(���. ������)(17)

    IN inOrderNumberSP       Integer   ,    -- � �����, � ����� ������� ��(���. ������)(18)
    IN inOrderDateSP         TDateTime ,    -- ���� ������, � ����� ������� ��(���. ������)(19)

    IN inID_MED_FORM         Integer   ,    -- ID_MED_FORM(���. ������)(20)
    IN inMorionSP            Integer   ,    -- ��� �������(���. ������)(21)
    IN inUserId              Integer        -- ������������
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
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ReestrDateSP(), ioId, inReestrDateSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ValiditySP(), ioId, inValiditySP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OrderDateSP(), ioId, inOrderDateSP);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceOptSP(), ioId, inPriceOptSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ExchangeRate(), ioId, inExchangeRate);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OrderNumberSP(), ioId, inOrderNumberSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ID_MED_FORM(), ioId, inID_MED_FORM);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MorionSP(), ioId, inMorionSP);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_CodeATX(), ioId, inCodeATX);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrSP(), ioId, inReestrSP);
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP(), ioId, inIntenalSPId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BrandSP(), ioId, inBrandSPId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP_1303(), ioId, inKindOutSP_1303Id);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Dosage_1303(), ioId, inDosage_1303Id);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CountSP_1303(), ioId, inCountSP_1303Id);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MakerSP_1303(), ioId, inMakerSP_1303Id);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Country_1303(), ioId, inCountry_1303Id);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioId, inCurrencyId);


    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.05.22                                                       *
 */