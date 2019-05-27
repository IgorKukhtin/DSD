-- Function: gpInsertUpdate_MI_SendPartionDate_Master()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SendPartionDate_Master(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountRemains       TFloat    , --
    IN inChangePercent       TFloat    , -- % (���� �� 1 ��� �� 6 ���)
    IN inChangePercentMin    TFloat    , -- % (���� ������ ������)
    IN inUserId              Integer    -- ������ ������������
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
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentMin(), ioId, inChangePercentMin);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), ioId, inAmountRemains);

    -- ����������� �������� ����� �� ���������
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
    
    -- ��������� ��������
    --PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.05.19         *
 03.04.19         *
*/