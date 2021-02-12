-- Function: gpComplete_Movement_FinalSUA()

DROP FUNCTION IF EXISTS gpComplete_Movement_FinalSUA  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_FinalSUA(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Complete_FinalSUA());
  vbUserId := inSession;
    
  -- ����������� �������� �����
  PERFORM lpInsertUpdate_FinalSUA_TotalSumm (inMovementId);
  
  -- ���������� ��������
  PERFORM lpComplete_Movement_FinalSUA(inMovementId, -- ���� ���������
                                                    vbUserId);    -- ������������ 
                         
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.02.21                                                       * 
 */

-- ����
-- SELECT * FROM gpComplete_Movement_FinalSUA (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')