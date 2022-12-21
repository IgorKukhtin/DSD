-- Function: gpComplete_Movement_Payment()

DROP FUNCTION IF EXISTS gpComplete_Movement_Payment  (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Payment  (Integer, TVarChar);

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
	
    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%>', inMovementId, inSession;
    END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 13.10.15                                                         *
 */

-- select * from gpComplete_Movement_Payment(inMovementId := 30410865 ,  inSession := '3');