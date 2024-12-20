-- Function: gpSetErased_Movement_EmployeeSchedule (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_EmployeeSchedule (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_EmployeeSchedule(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    vbUserId := inSession;

  -- �������� ���� ������������ �� ����� ���������
  IF inSession::Integer NOT IN (3, 758920, 4183126, 9383066, 8037524)
  THEN
    RAISE EXCEPTION '��������� <������ ������ �����������> ��� ���������.';
  END IF;

  -- �������� ������
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete());

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
