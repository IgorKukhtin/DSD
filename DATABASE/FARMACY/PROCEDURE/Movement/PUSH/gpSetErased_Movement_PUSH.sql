-- Function: gpSetErased_Movement_PUSH (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PUSH (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PUSH(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    vbUserId := inSession;

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
 11.03.19                                                                        *
 */
