-- Function: lpComplete_Movement_PromoUnit (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_PromoUnit (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PromoUnit(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$

BEGIN

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_PromoUnit()
                               , inUserId     := inUserId
                                );

    -- ����������� ����� �� ��������� (��� ����� �������, ������� ��������� ����� ���������� ���������)
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm(inMovementId);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 06.02.17         * 
*/