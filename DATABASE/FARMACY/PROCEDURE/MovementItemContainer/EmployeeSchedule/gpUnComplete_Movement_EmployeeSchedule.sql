-- Function: gpUnComplete_Movement_EmployeeSchedule (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_EmployeeSchedule (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_EmployeeSchedule(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EmployeeSchedule());
    vbUserId := inSession;


     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    --������������� ����� ��������� �� ��������� �����
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);    
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.12.23                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_EmployeeSchedule (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())