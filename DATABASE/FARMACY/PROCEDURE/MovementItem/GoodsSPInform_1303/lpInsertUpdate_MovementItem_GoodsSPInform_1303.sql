-- Function: lpInsertUpdate_MovementItem_GoodsSPInform_1303()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsSPInform_1303 (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_GoodsSPInform_1303(
 INOUT ioId                     Integer   ,    -- ���� ������� <������� ���������>
    IN inMovementId             Integer   ,    -- ������������� ���������
    IN inGoodsId                Integer   ,    -- �����

    IN inCol                    Integer   ,    -- ����� �� �������

    IN inIntenalSP_1303Id       Integer   ,    -- ̳�������� ������������� ��� ���������������� ����� ���������� ������ (1)
    IN inKindOutSP_1303Id       Integer   ,    -- ����� ������� (3)
    IN inDosage_1303Id          Integer   ,    -- ��������� (���. ������)(4)

    IN inPriceMargSP            TFloat    ,    -- �������� ������-�������� ���� � ����������� �� ������� �������� ����� (���.)(���. ������)
    IN inPriceOptSP             TFloat    ,    -- ������������� ������-�������� ���� (���.)(���. ������)

    IN inReferral               TVarChar  ,    -- �����������

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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inCol, NULL);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceOptSP(), ioId, inPriceOptSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceMargSP(), ioId, inPriceMargSP);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Referral(), ioId, inReferral);
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP_1303(), ioId, inIntenalSP_1303Id);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP_1303(), ioId, inKindOutSP_1303Id);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Dosage_1303(), ioId, inDosage_1303Id);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.04.23                                                       *
 */