-- Function: gpReComplete_Movement_OrderReturnTare(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_OrderReturnTare (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_OrderReturnTare(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderReturnTare());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_OrderReturnTare())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement_OrderReturnTare (inMovementId := inMovementId
                                                   , inUserId     := vbUserId);
     END IF;

     -- �������� ��������
     PERFORM lpComplete_Movement_OrderReturnTare (inMovementId     := inMovementId
                                             , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.11.20         *
*/

-- ����
-- 