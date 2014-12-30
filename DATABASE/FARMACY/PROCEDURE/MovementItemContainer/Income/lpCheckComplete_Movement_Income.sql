-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS lpCheckComplete_Movement_Income (Integer);

CREATE OR REPLACE FUNCTION lpCheckComplete_Movement_Income(
    IN inMovementId        Integer              -- ���� ���������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- ��������� ��� �� ������ �����������. 
  IF EXISTS (SELECT * FROM MovementItem WHERE MovementId = inMovementId AND ObjectId IS NULL) THEN
     RAISE EXCEPTION '� ��������� ������� �� ��� ������ �����������';
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.12.14                         *

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
