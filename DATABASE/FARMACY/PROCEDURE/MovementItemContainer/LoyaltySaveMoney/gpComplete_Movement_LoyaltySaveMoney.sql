-- Function: gpComplete_Movement_LoyaltySaveMoney()

DROP FUNCTION IF EXISTS gpComplete_Movement_LoyaltySaveMoney (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_LoyaltySaveMoney(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  
BEGIN
    vbUserId:= inSession;

    -- ���������� ��������
    PERFORM lpComplete_Movement_LoyaltySaveMoney(inMovementId, -- ���� ���������
                                          vbUserId);    -- ������������  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.12.19                                                       *
 */