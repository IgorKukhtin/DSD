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
        RAISE EXCEPTION '�� ������� ������������ ���������. �������� �� ��������';
     END IF;*/

     -- ������� ��� ���������
     PERFORM lpSetErased_Movement (inMovementId := Movement_BankAccount.Id
                                 , inUserId     := vbUserId)
     FROM Movement AS Movement_BankStatementItem
          JOIN Movement AS Movement_BankAccount ON Movement_BankAccount.ParentId = Movement_BankStatementItem.Id
     WHERE Movement_BankStatementItem.ParentId = inMovementId;

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.03.14                                        * add ������� ��� ���������
 17.01.14                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_BankStatement (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
