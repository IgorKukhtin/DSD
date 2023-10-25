-- Function: gpComplete_Movement_ConvertRemains()

DROP FUNCTION IF EXISTS gpComplete_Movement_ConvertRemains  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ConvertRemains(
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
  PERFORM lpComplete_Movement_ConvertRemains(inMovementId, -- ���� ���������
                                        vbUserId);    -- ������������ 
                         
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.10.2023                                                     *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_ConvertRemains (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')
