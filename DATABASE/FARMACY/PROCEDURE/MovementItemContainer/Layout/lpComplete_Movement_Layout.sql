 -- Function: lpComplete_Movement_Layout (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Layout (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Layout(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
BEGIN

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;

     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Layout()
                                , inUserId     := inUserId
                                 );
    --������������� ����� ��������� �� ��������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm(inMovementId);    
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.08.20         *
*/

-- ����
-- 