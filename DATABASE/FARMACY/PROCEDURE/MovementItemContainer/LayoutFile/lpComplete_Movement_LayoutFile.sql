 -- Function: lpComplete_Movement_LayoutFile (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_LayoutFile (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_LayoutFile(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbLayoutFileId Integer;
BEGIN

     IF NOT EXISTS (SELECT 1
                    FROM Movement
                         INNER JOIN MovementString AS MovementString_FileName
                                                   ON MovementString_FileName.MovementId = Movement.Id
                                                  AND MovementString_FileName.DescId = zc_MovementString_FileName()
                                                  AND COALESCE (MovementString_FileName.ValueData,'') <> ''
                    WHERE Movement.DescId = zc_Movement_LayoutFile()
                      AND Movement.Id = inMovementId)
     THEN
          RAISE EXCEPTION '������. � ��������� �� ���������� ����.';
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
                                , inDescId     := zc_Movement_LayoutFile()
                                , inUserId     := inUserId
                                 );
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.02.22                                                       *
*/

-- ����
-- 