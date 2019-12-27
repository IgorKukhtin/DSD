-- Function: lpInsertUpdate_MovementItem_LoyaltySaveMoney()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LoyaltySaveMoney (Integer, Integer, Integer, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_LoyaltySaveMoney(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inBuyerID             Integer   , -- ����� ������
    IN inComment             TVarChar  , -- ��������
    IN inUnitID              Integer   , -- ��������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbAmount TFloat;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    IF vbIsInsert = FALSE
    THEN
      SELECT MovementItem.Amount
      INTO vbAmount
      FROM MovementItem
      WHERE MovementItem.ID = ioId;
    ELSE
      vbAmount := 0;
    END IF;

    IF COALESCE(inBuyerID, 0) = 0
    THEN
       RAISE EXCEPTION '������. �� �������� ����������.';
    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.ID <> COALESCE (ioId, 0)
                                           AND MovementItem.MovementId = inMovementId
                                           AND MovementItem.ObjectID = inBuyerID)
    THEN
       RAISE EXCEPTION '������. �� ���������� ����� ���� ������ ���� ������ � ���������.';
    END IF;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inBuyerID, inMovementId, vbAmount, NULL, zc_Enum_Process_Auto_PartionClose());

    -- ��������� �������� <����������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
    -- ��������� ����� � <�������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitID);

    IF vbIsInsert = TRUE
    THEN
        -- ��������� ����� � <>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
        -- ��������� �������� <>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
    ELSE
        -- ��������� ����� � <>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
        -- ��������� �������� <>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.12.19                                                       *
 */