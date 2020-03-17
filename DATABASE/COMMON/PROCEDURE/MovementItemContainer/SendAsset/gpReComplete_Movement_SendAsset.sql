-- Function: gpReComplete_Movement_Send(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_SendAsset (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_SendAsset(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SendAsset());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_SendAsset())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     -- PERFORM lpComplete_Movement_SendAsset_CreateTemp();
     -- �������� ��������
     PERFORM gpComplete_Movement_SendAsset (inMovementId     := inMovementId
                                     , inIsLastComplete := NULL
                                     , inSession        := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.03.20         *
*/

-- ����
-- 