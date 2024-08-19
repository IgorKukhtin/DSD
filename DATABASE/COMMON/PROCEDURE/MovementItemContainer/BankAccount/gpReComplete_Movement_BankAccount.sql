-- Function: gpReComplete_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpReComplete_Movement_BankAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_BankAccount(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar               -- ������ ������������
)
  RETURNS void AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_BankAccount());
     
     
     if vbUserId = 5 THEN vbUserId:= zc_Enum_Process_Auto_PrimeCost(); end if;

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- �������� ��������
     PERFORM lpComplete_Movement_BankAccount (inMovementId := inMovementId
                                            , inUserId     := vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.11.14                                                       *
*/
