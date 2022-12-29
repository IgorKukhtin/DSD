DROP FUNCTION IF EXISTS lpComplete_Movement_OrderInternal (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_OrderInternal(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_OrderInternal()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.12.22         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_OrderInternal (inMovementId:= 224, inUserId := zfCalc_UserAdmin() :: Integer)  order by ObjectId_parent;
