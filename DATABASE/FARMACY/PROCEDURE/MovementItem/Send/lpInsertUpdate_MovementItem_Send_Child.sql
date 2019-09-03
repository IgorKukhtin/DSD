-- Function: lpInsertUpdate_MovementItem_Send_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inParentId            Integer   , --
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inContainerId         TFloat    , --
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

    IF vbIsInsert = TRUE
    THEN
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
    END IF;

    -- ��������� ��������
    --PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 04.07.19                                                      *
*/