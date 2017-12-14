-- Function: lpComplete_Movement_PromoCode (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_PromoCode (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PromoCode(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$

BEGIN

    -- 1. �����������
    /*PERFORM lpReComplete_Movement_PromoCode_All (inMovementId := inMovementId
                                                 , inUserId     := inUserId
                                                 );
    */
    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Promo()
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
 14.12.17         * 
*/