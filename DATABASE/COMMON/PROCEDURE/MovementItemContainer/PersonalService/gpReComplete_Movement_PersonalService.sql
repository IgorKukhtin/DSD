-- Function: gpReComplete_Movement_PersonalService (integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_PersonalService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_PersonalService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalService());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_PersonalService())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_PersonalService (inMovementId     := inMovementId
                                                , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.04.15                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_PersonalService (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
