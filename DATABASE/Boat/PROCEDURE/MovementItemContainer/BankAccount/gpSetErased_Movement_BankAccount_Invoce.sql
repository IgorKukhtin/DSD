-- Function: gpSetErased_Movement_BankAccount_Invoce()

DROP FUNCTION IF EXISTS gpSetErased_Movement_BankAccount_Invoce (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_BankAccount_Invoce(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inMovementId_Invoce   Integer   , -- ���� ������� <�������� ����>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

     IF COALESCE (inMovementId,0) <> 0 THEN PERFORM gpSetErased_Movement_BankAccount (inMovementId, inSession); END IF;
     IF COALESCE (inMovementId_Invoce,0) <> 0 THEN PERFORM gpSetErased_Movement_Invoice (inMovementId_Invoce, inSession); END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.10.25         *
 */