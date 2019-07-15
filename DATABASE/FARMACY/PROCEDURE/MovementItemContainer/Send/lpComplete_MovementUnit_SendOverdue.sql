DROP FUNCTION IF EXISTS lpComplete_MovementUnit_SendOverdue (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpComplete_MovementUnit_SendOverdue(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbPartionDateKindID Integer;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);

    -- �������� ���������
  SELECT Movement.StatusId, MovementLinkObject_PartionDateKind.ObjectId
  INTO vbStatusId, vbPartionDateKindID
  FROM Movement
      LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                   ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                  AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
  WHERE Movement.Id = inMovementId;

  IF COALESCE(vbPartionDateKindID, 0) <> zc_Enum_PartionDateKind_0()
  THEN
    RAISE EXCEPTION '������������ ��������� ������ ��� ���������� ����������� ������������� ������.';
  END IF;

  -- ��������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
    RAISE EXCEPTION '������������ ��������� ������ ��� �������������� ����������.';
  END IF;

  IF EXISTS (SELECT MIC.Id FROM MovementItemContainer AS MIC WHERE MIC.Movementid = inMovementId)
  THEN
    -- ��������� ������� ������� � �����������
    PERFORM gpUpdate_Movement_Send_Deferred (inMovementID, FALSE, inSession);
  END IF;

  PERFORM grUpdate_MovementUnit_SendOverdue (inMovementID := inMovementId, inSession:= inSession);

  IF EXISTS(SELECT 1 FROM MovementItem
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND MovementItem.IsErased = FALSE
              AND MovementItem.Amount > 0)
  THEN
    PERFORM lpComplete_Movement_Send (inMovementId := inMovementId, inUserId := vbUserId);
  ELSE
    PERFORM gpSetErased_Movement_Send (inMovementId := inMovementId, inUserId := vbUserId);
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.   ������ �.�.
 12.07.19                                                                                    *
*/

-- SELECT * FROM gpComplete_MovementUnit_SendOverdue (inSession:= '3')       
-- SELECT * FROM lpComplete_MovementUnit_SendOverdue (inMovementId := 7784784 , inSession:= '3')       