-- Function: gpInsertUpdate_MI_SendPartionDate_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SendPartionDate_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inParentId            Integer   , --
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
   -- IN inPartionDateKindId   Integer   , --
    IN inExpirationDate      TDateTime ,
    IN inPriceWithVAT        TFloat    , -- ���� ������� � ���
    IN inAmount              TFloat    , -- ����������
    IN inContainerId         TFloat    , --
    IN inMovementId_Income   TFloat    , --
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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_Income);

    -- ��������� <>
    --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionDateKind(), ioId, inPartionDateKindId);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), ioId, inExpirationDate);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(), ioId, inPriceWithVAT);

    -- ����������� �������� ����� �� ���������
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    -- ��������� ��������
    --PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.06.19         *
 03.04.19         *
*/