-- Function: gpReComplete_Movement_ReestrIncome(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_ReestrIncome (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ReestrIncome(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReestrIncome());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_ReestrIncome())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� ��������
     PERFORM lpComplete_Movement_ReestrIncome (inMovementId     := inMovementId
                                             , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.12.20         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_ReestrIncome (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
