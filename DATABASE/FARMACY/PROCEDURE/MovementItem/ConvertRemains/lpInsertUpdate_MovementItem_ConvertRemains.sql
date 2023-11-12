-- Function: lpInsertUpdate_MovementItem_ConvertRemains()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ConvertRemains (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ConvertRemains(
 INOUT ioId                     Integer   ,    -- ���� ������� <������� ���������>
    IN inMovementId             Integer   ,    -- ������������� ���������
    IN inNumber                 Integer   ,    -- � �� �������
    IN inGoodsId                Integer   ,    -- �����

    IN inAmount                 TFloat    ,    -- ����������

    IN inPriceWithVAT           TFloat    ,    -- ���� � ������ ���
    IN inVAT                    TFloat    ,    -- ���

    IN inGoodsName              TVarChar  ,    -- �������� ������
    IN inMeasure                TVarChar  ,    -- ������� ���������

    IN inComment                TVarChar  ,    -- �����������

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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Number(), ioId, inNumber);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(), ioId, inPriceWithVAT);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_VAT(), ioId, inVAT);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), ioId, inGoodsName);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Measure(), ioId, inMeasure);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.10.2023                                                     *
 */