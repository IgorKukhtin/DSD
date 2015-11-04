-- Function: gpComplete_Movement_Payment()

DROP FUNCTION IF EXISTS gpComplete_Movement_Payment  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Payment(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_BankAccount());
  
    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummPayment (inMovementId);
    -- ���������� ��������
    PERFORM lpComplete_Movement_Payment(inMovementId, -- ���� ���������
                                     vbUserId);    -- ������������  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 13.10.15                                                         *
 */