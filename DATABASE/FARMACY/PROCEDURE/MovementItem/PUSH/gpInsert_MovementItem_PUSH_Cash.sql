-- Function: gpInsert_MovementItem_PUSH_Cash()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_PUSH_Cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_PUSH_Cash(
    IN inMovementId          Integer   , -- ���� ������� <������� ���������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
    vbUserId := inSession;

    IF (COALESCE (inMovementId, 0) = 0)
    THEN
      RAISE EXCEPTION '������. �� �������� ����� ����������.';
    END IF;

    IF NOT EXISTS(SELECT * FROM Movement WHERE Id = inMovementId AND DescId = zc_Movement_PUSH())
    THEN
      RAISE EXCEPTION '������. ���������� �� �������.';
    END IF;

    IF EXISTS(SELECT *

              FROM Movement

                   INNER JOIN MovementItem AS MovementItem
                           ON MovementItem.MovementId = Movement.Id
                          AND MovementItem.DescId = zc_MI_Master()
                          AND MovementItem.ObjectId = vbUserId

              WHERE Movement.Id = inMovementId)
    THEN
      RAISE EXCEPTION '������. ��������� ������� � ��������� �����������.';
    END IF;

    INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
    VALUES (zc_MI_Master(), vbUserId, inMovementId, 0, Null) RETURNING Id INTO vbId;

    -- ��������� <����>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Viewed(), vbId, CURRENT_TIMESTAMP);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, True);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 11.03.19                                                                     *
*/