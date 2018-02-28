-- Function: lpComplete_Movement_LossPersonal (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_LossPersonal (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_LossPersonal(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate   TDateTime;

BEGIN
 
     -- ������������
     SELECT Movement.OperDate
            INTO vbOperDate
     FROM Movement
     WHERE Movement.Id     = inMovementId
       AND Movement.DescId = zc_Movement_LossPersonal()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
    ;

     -- ��������
     IF vbOperDate IS NULL
     THEN
         RAISE EXCEPTION '������.�������� ��� ��������.';
     END IF;

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

  
     -- 5.1. ����� - ���������/��������� ��������
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);


     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_LossPersonal()
                                , inUserId     := inUserId
                                 );
                                 
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.02.18         * 
*/
