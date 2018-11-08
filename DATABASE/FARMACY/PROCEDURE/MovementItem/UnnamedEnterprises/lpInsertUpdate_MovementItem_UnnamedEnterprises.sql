-- Function: lpInsertUpdate_MovementItem_UnnamedEnterprises()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_UnnamedEnterprises (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_UnnamedEnterprises(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountOrder         TFloat    , -- ���������� � �����
    IN inPrice               TFloat    , -- ����
    IN inSumm                TFloat    , -- �����
    IN inSummOrder           TFloat    , -- ����� � �����
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

    -- ��������� <����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), ioId, inAmountOrder);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummOrder(), ioId, inSummOrder);

    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSummUnnamedEnterprisesExactly (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 30.09.18         *
*/