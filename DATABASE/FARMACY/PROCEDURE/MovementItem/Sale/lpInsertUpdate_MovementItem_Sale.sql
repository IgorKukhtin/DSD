-- Function: lpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Sale(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inPriceSale           TFloat    , -- ���� ��� ������
    IN inChangePercent       TFloat    , -- % ������
    IN inSumm                TFloat    , -- �����
    IN inisSP                Boolean   , -- ��������� � ���. �������
    IN inNDSKindId           Integer   , -- ���
    IN inUserId              Integer     -- ������������
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
    
    IF COALESCE ((SELECT MovementBoolean_NP.ValueData FROM MovementBoolean AS MovementBoolean_NP
                  WHERE MovementBoolean_NP.MovementId = inMovementId
                    AND MovementBoolean_NP.DescId = zc_MovementBoolean_NP()), False) = TRUE
    THEN
      inPriceSale := inPrice;
    END IF;
    
    -- ��������� <����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, inPriceSale);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SP(), ioId, inisSP);

    -- ��������� �������� <���>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_NDSKind(), ioId, inNDSKindId);


    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSummSaleExactly (inMovementId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.   ������ �.�.
 11.05.20                                                                                     *               
 09.02.17         *
 13.10.15                                                                       *
 */