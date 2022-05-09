-- Function: gpComplete_Movement_CompetitorMarkups()

DROP FUNCTION IF EXISTS gpComplete_Movement_CompetitorMarkups  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_CompetitorMarkups(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups());
                                             
    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.05.22                                                       *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_CompetitorMarkups (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')
