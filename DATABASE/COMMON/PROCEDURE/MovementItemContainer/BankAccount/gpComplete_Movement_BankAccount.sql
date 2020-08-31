-- Function: gpComplete_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpComplete_Movement_BankAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_BankAccount(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar               -- ������ ������������
)
  RETURNS void AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_BankAccount());

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- �������� ��������
     PERFORM lpComplete_Movement_BankAccount (inMovementId := inMovementId
                                            , inUserId     := vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 22.01.14                                        * add IsMaster
 16.01.13                                        * add lpComplete_Movement_BankAccount
 24.11.13                                        * add View_InfoMoney
 26.08.13                        *
*/
