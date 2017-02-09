-- Function: gpReComplete_Movement_PersonalSendCash(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_PersonalSendCash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_PersonalSendCash(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalSendCash());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_PersonalSendCash())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_PersonalSendCash_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_PersonalSendCash (inMovementId := inMovementId
                                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.09.15         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_PersonalSendCash (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
