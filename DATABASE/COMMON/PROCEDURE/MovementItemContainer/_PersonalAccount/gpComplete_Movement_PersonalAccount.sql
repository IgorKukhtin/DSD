-- Function: gpComplete_Movement_PersonalAccount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_PersonalAccount ( TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_PersonalAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PersonalAccount(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalAccount());


     -- �������� ��������
     PERFORM lpComplete_Movement_PersonalAccount (inMovementId := inMovementId
                                                 , inUserId     := vbUserId);



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.12.13         * 
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_PersonalAccount (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
