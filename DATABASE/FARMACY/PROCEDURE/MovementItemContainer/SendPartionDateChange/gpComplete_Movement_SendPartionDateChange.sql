-- Function: gpComplete_Movement_SendPartionDateChange()

DROP FUNCTION IF EXISTS gpComplete_Movement_SendPartionDateChange  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SendPartionDateChange(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Complete_SendPartionDateChange());
    
  -- ����������� �������� �����
  --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
  
  -- ���������� ��������
  PERFORM lpComplete_Movement_SendPartionDateChange(inMovementId, -- ���� ���������
                                                    vbUserId);    -- ������������ 
                         
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.07.20                                                       * 
 */

-- ����
-- SELECT * FROM gpComplete_Movement_SendPartionDateChange (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')
