-- Function: lpInsertUpdate_MovementItem_GoodsSPSearch_1303()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsSPSearch_1303 (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                        , TVarChar, TVarChar, TDateTime, TFloat, Integer, TFloat, Integer, TDateTime
                                                                        , Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_GoodsSPSearch_1303(
 INOUT ioId                     Integer   ,    -- ���� ������� <������� ���������>
    IN inMovementId             Integer   ,    -- ������������� ���������

    IN inCol                    Integer   ,    -- ����� �� �������

    IN inIntenalSP_1303Id       Integer   ,    -- ̳�������� ������������� ��� ���������������� ����� ���������� ������ (1)
    IN inBrandSPId              Integer   ,    -- ����������� ����� ���������� ������ (2)

    IN inKindOutSP_1303Id       Integer   ,    -- ����� ������� (3)
    IN inDosage_1303Id          Integer   ,    -- ��������� (���. ������)(4)
    IN inCountSP_1303Id         Integer   ,    -- ʳ������ ������� ���������� ������ � ��������� �������� (5)
    IN inMakerCountrySP_1303Id  Integer   ,    -- ������������ ���������, ����� (6)

    IN inCodeATX                TVarChar  ,    -- ��� ��� (7)
    IN inReestrSP               TVarChar  ,    -- ����� ������������� ���������� �� ��������� ���� (8)
    IN inValiditySP             TDateTime ,    -- ���� ��������� ������ 䳿 ������������� ���������� �� ��������� ���� (9)

    IN inPriceOptSP             TFloat    ,    -- ������������� ������-�������� ���� (���.)(���. ������)(10)
    IN inCurrencyId             Integer   ,    -- ������ (���. ������)(11)
    IN inExchangeRate           TFloat    ,    -- ��������� ����,������������ ������������ ������ ������ �� ���� ������� ���������� ���� ������-�������� ����(���. ������)(11)

    IN inOrderNumberSP          Integer   ,    -- � �����, � ����� ������� ��(���. ������)(12)
    IN inOrderDateSP            TDateTime ,    -- ���� ������, � ����� ������� ��(���. ������)(12)

    IN inUserId                 Integer        -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), 0, inMovementId, inCol, NULL);
    
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
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_CodeATX(), ioId, inCodeATX);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrSP(), ioId, inReestrSP);
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP_1303(), ioId, inIntenalSP_1303Id);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BrandSP(), ioId, inBrandSPId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP_1303(), ioId, inKindOutSP_1303Id);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Dosage_1303(), ioId, inDosage_1303Id);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CountSP_1303(), ioId, inCountSP_1303Id);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MakerCountrySP_1303(), ioId, inMakerCountrySP_1303Id);
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