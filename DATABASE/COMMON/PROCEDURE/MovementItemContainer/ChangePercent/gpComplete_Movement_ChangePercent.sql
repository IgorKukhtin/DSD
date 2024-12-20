-- Function: gpComplete_Movement_ChangePercent()

DROP FUNCTION IF EXISTS gpComplete_Movement_ChangePercent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ChangePercent(
    IN inMovementId        Integer              , -- ���� ���������
   OUT outMessageText      Text                 ,
    IN inSession           TVarChar               -- ������ ������������
)                              
RETURNS Text
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ChangePercent());


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_ChangePercent_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_ChangePercent (inMovementId := inMovementId
                                              , inUserId     := vbUserId
                                               );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.08.14                                        * add MovementDescId
 11.05.14                                        * change _tmpItem
 04.05.14                                        * all
 25.04.14         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ChangePercent (inMovementId:= 10154, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
