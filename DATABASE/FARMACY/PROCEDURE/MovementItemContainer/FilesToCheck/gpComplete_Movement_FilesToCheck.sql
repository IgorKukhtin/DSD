-- Function: gpComplete_Movement_FilesToCheck()

DROP FUNCTION IF EXISTS gpComplete_Movement_FilesToCheck  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_FilesToCheck(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
    vbUserId:= inSession;
    
  -- ����������� �������� �����
  --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
  
  -- ���������� ��������
  PERFORM lpComplete_Movement_FilesToCheck(inMovementId, -- ���� ���������
                                        vbUserId);    -- ������������ 
                         
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.22                                                       *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_FilesToCheck (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')
