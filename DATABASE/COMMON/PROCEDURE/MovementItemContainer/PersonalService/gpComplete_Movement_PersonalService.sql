-- Function: gpComplete_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpComplete_Movement_PersonalService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PersonalService(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar               -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalService());

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- �������� ��������
     PERFORM lpComplete_Movement_PersonalService (inMovementId := inMovementId
                                                , inUserId     := vbUserId);

     -- ������ ������ �������
     IF vbUserId = zfCalc_UserAdmin() :: Integer AND 1=1
     THEN
         RAISE EXCEPTION '������.test = ok';
     END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 09.09.14                                        *
*/

-- ����
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PersonalService (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
