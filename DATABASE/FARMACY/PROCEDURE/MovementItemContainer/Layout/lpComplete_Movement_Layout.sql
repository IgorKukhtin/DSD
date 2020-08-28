 -- Function: lpComplete_Movement_Layout (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Layout (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Layout(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbLayoutId Integer;
BEGIN

     -- �������� ����, ��������, ���. ��� ������ , �� ������ ��������� ������������ ���� ���� ����� � ����� ���������
     vbLayoutId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_Layout() AND MLO.MovementId = inMovementId);

     IF EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Layout
                                                   ON MovementLinkObject_Layout.MovementId = Movement.Id
                                                  AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
                                                  AND MovementLinkObject_Layout.ObjectId = vbLayoutId
                WHERE Movement.DescId = zc_Movement_Layout()
                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                  AND Movement.Id <> inMovementId)
     THEN
          RAISE EXCEPTION '������.�������� ��� �������� <%> ��� ����������.', lfGet_Object_ValueData (vbLayoutId);
     END IF;

     
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