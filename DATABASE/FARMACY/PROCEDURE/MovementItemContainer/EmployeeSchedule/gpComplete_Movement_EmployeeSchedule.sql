-- Function: gpComplete_Movement_EmployeeSchedule()

DROP FUNCTION IF EXISTS gpComplete_Movement_EmployeeSchedule  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_EmployeeSchedule(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EmployeeSchedule());
    vbUserId := inSession;
                                             
    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.12.23                                                       *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_EmployeeSchedule (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')
