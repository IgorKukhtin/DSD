-- Function: gpReComplete_Movement_ReestrReturn(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_ReestrReturn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ReestrReturn(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReestrReturn());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_ReestrReturn())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� ��������
     PERFORM lpComplete_Movement_ReestrReturn (inMovementId     := inMovementId
                                             , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.03.17         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_ReestrReturn (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
