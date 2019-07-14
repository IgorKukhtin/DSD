DROP FUNCTION IF EXISTS lpComplete_MovementUnit_SendOverdue (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_MovementUnit_SendOverdue(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);

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