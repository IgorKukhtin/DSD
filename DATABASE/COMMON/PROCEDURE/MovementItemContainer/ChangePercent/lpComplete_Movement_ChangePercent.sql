-- Function: lpComplete_Movement_ChangePercent (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_ChangePercent (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ChangePercent(
    IN inMovementId        Integer               , -- ���� ���������
   OUT outMessageText      Text                  ,
    IN inUserId            Integer                 -- ������������
)                              
RETURNS Text
AS
$BODY$
BEGIN


     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ChangePercent()
                                , inUserId     := inUserId
                                 );

 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.03.23         *
*/
-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 267275 , inSession:= '2')
-- SELECT * FROM lpComplete_Movement_ChangePercent (inMovementId:= 267275, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 267275 , inSession:= '2')