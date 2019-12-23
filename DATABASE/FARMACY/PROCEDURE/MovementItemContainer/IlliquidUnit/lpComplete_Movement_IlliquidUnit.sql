-- Function: lpComplete_Movement_IlliquidUnit (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_IlliquidUnit (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_IlliquidUnit(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$

BEGIN

      -- ������������� ����������
    PERFORM lpUpdate_Movement_IlliquidUnit_TotalCount(inMovementId);

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_IlliquidUnit()
                               , inUserId     := inUserId
                                );
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.12.19                                                       *
*/