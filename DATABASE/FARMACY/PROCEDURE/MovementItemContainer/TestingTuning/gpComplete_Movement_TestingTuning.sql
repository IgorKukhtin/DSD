-- Function: gpComplete_Movement_TestingTuning()

DROP FUNCTION IF EXISTS gpComplete_Movement_TestingTuning  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_TestingTuning(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession::Integer;

     -- ��������� ������ ����������� � ������� ������    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '��� ��������� �������� ��������� ������������';
    END IF;
                                             
    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 06.07.21                                                                     *  
 */

-- ����
-- SELECT * FROM gpComplete_Movement_TestingTuning (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')
