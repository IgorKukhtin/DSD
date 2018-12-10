-- Function: gpComplete_Movement_EmployeeSchedule()

DROP FUNCTION IF EXISTS gpComplete_Movement_EmployeeSchedule  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_EmployeeSchedule (
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
  vbUserId:= inSession;

  -- �������� ���� ������������ �� ����� ���������
  IF 758920 <> inSession::Integer AND 4183126 <> inSession::Integer
  THEN
    RAISE EXCEPTION '��������� <������ ������ �����������> ��� ���������.';
  END IF;
  
  -- �������� ������
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   ������ �.�.
 10.12.18                                                                        *
 */
 