-- Function: gpReComplete_Movement_IncomeCost (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_IncomeCost (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_IncomeCost(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());


     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_Income())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- �������� ��������
     PERFORM lpComplete_Movement_IncomeCost (inMovementId     := inMovementId
                                           , inUserId         := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.02.19                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_IncomeCost (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
