DROP FUNCTION IF EXISTS lpComplete_Movement_GoodsAccount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_GoodsAccount(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
BEGIN

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_GoodsAccount()
                               , inUserId     := inUserId
                                );

    -- 6.1. ����������� "��������" ����� �� ��������� ������ ������� - ����������� ����� lpComplete
    PERFORM lpUpdate_MI_Partion_Total_byMovement (inMovementId);

    -- 6.2. �������� �������� ����� �� ����������
    PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= TRUE, inUserId:= inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 18.05.17         * 
*/

-- ����
-- SELECT * FROM lpComplete_Movement_GoodsAccount (inMovementId:= 1100, inUserId:= zfCalc_UserAdmin() :: Integer)
