-- Function: gpSetErased_Movement_BankStatement (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_BankStatement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_BankStatement(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_BankStatement());


     /*IF (SELECT StatusId FROM Movement WHERE Id = inMovementId) = zc_Enum_Status_Complete() THEN
        RAISE EXCEPTION '�� ������� ������������ ���������.�������� �� ��������';
     END IF;*/


     -- ������� ��� ��������� BankAccount
     PERFORM lpSetErased_Movement (inMovementId := Movement_BankAccount.Id
                                 , inUserId     := vbUserId)
     FROM Movement AS Movement_BankStatementItem
          JOIN Movement AS Movement_BankAccount ON Movement_BankAccount.ParentId = Movement_BankStatementItem.Id
     WHERE Movement_BankStatementItem.ParentId = inMovementId
       AND Movement_BankStatementItem.DescId = zc_Movement_BankStatementItem();

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     -- ������� �������� ��������� �������
     PERFORM lpSetErased_Movement (inMovementId := Movement_BankStatementItem.Id
                                 , inUserId     := vbUserId)
     FROM Movement AS Movement_BankStatementItem
     WHERE Movement_BankStatementItem.ParentId = inMovementId
       AND Movement_BankStatementItem.DescId = zc_Movement_BankStatementItem();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 18.03.14                                        * add ������� �������� ��������� �������
 13.03.14                                        * add ������� ��� ���������
 17.01.14                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_BankStatement (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
