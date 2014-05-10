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
     -- ����������� ������ ������ ���������
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_Tax() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.05.14                                        * set lp
 10.05.14                                        * add lpInsert_MovementProtocol
 11.02.14                                                       *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Tax (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
