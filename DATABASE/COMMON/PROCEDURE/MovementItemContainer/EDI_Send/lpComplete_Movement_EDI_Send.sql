-- Function: lpComplete_Movement_EDI_Send()

DROP FUNCTION IF EXISTS lpComplete_Movement_EDI_Send (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_EDI_Send(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
 RETURNS VOID
AS
$BODY$
BEGIN


     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_EDI_Send()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.02.18         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_EDI_Send (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
