-- Function: gpComplete_Movement_ChangeIncomePayment()

DROP FUNCTION IF EXISTS gpComplete_Movement_ChangeIncomePayment (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ChangeIncomePayment(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate    TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ChangeIncomePayment());
    vbUserId:= inSession;
    
     -- ��������� ��������� ������� - ��� ������������ ������ ��� �������� 
     -- ��� ��� ��������� ���������� ���������� ��� �� �� ��������� ���������� ��������
    PERFORM lpComplete_Movement_Finance_CreateTemp();
    -- ���������� ��������
    PERFORM lpComplete_Movement_ChangeIncomePayment(inMovementId, -- ���� ���������
                                                    vbUserId);    -- ������������                          

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId 
      AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 21.12.15                                                                       * 

*/
