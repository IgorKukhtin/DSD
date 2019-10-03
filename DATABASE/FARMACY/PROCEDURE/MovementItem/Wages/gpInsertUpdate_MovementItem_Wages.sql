-- Function: gpInsertUpdate_MovementItem_Wages()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages(Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages(Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Wages(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer   , -- ���������
    IN inUnitId              Integer   , -- �������������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT 1  FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID = inUserId
                  AND MovementItem.DescId = zc_MI_Master())
      THEN
        SELECT MovementItem.ID
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementID = inMovementId
          AND MovementItem.ObjectID = inUserId
          AND MovementItem.DescId = zc_MI_Master();
      END IF;
    ELSE
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID = inUserId
                  AND MovementItem.ID <> ioId
                  AND MovementItem.DescId = zc_MI_Master())
      THEN
        RAISE EXCEPTION '������. ������������ ����������� ���������.';
      END IF;
    END IF;

    -- ���������
    ioId := lpInsertUpdate_MovementItem_Wages (ioId                  := ioId                  -- ���� ������� <������� ���������>
                                             , inMovementId          := inMovementId          -- ���� ���������
                                             , inUserWagesId         := inUserId              -- ���������
                                             , inUserId              := vbUserId              -- ������������
                                             , inUnitId              := inUnitId              -- �������������
                                               );

    --
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.08.19                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Wages (, inSession:= '2')

