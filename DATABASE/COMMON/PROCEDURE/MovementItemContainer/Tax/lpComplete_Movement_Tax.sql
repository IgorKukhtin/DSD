-- Function: lpComplete_Movement_Tax()

DROP FUNCTION IF EXISTS lpComplete_Movement_Tax (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Tax(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
 RETURNS VOID
AS
$BODY$
BEGIN

     -- ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Tax()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * set lp
 10.05.14                                        * add lpInsert_MovementProtocol
 11.02.14                                                       *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Tax (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
