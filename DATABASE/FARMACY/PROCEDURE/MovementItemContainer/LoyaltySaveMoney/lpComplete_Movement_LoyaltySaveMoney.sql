-- Function: lpComplete_Movement_LoyaltySaveMoney (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_LoyaltySaveMoney (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_LoyaltySaveMoney(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$

BEGIN

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_LoyaltySaveMoney()
                               , inUserId     := inUserId
                                );
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.12.19                                                       *
*/