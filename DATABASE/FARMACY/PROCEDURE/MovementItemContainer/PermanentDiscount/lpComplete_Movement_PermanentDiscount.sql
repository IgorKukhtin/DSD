-- Function: lpComplete_Movement_PermanentDiscount (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_PermanentDiscount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PermanentDiscount(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$

BEGIN

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_PermanentDiscount()
                               , inUserId     := inUserId
                                );
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.12.19                                                       *
*/