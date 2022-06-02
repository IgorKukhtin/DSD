DROP FUNCTION IF EXISTS lpComplete_Movement_ServiceItem (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ServiceItem(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbAccountId_ServiceItem   Integer;
  DECLARE vbAccountId_Debts  Integer;
  DECLARE vbAccountId_Profit Integer;
  DECLARE vbProfitLossId     Integer;
BEGIN


    -- ������� ��������� �������
    --PERFORM lpComplete_Movement_ServiceItem_CreateTemp();

    -- !!!�����������!!! �������� ������� ��������

    -- 4.1. �������������� ��������� ������

    -- 5.1. ����� - ����������� ��������� ��������
    --PERFORM lpInsertUpdate_MovementItemContainer_byTable();

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ServiceItem()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.06.22         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_ServiceItem (inMovementId:= 40980, inUserId := zfCalc_UserAdmin() :: Integer);