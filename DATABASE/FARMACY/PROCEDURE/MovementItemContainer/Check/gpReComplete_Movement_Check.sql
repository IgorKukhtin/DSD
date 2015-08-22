-- Function: gpReComplete_Movement_Check(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Check(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
    -- ������ ���� �������� ��������
    IF EXISTS(
                SELECT 1
                FROM Movement
                WHERE
                    Id = inMovementId
                    AND
                    StatusId = zc_Enum_Status_Complete()
             )
    THEN
        --����������� ��������
        PERFORM gpUpdate_Status_Check(inMovementId := inMovementId,
                                      inStatusCode := zc_Enum_StatusCode_UnComplete(),
                                      inSession    := inSession);
        --�������� ��������
        PERFORM gpUpdate_Status_Check(inMovementId := inMovementId,
                                      inStatusCode := zc_Enum_StatusCode_Complete(),
                                      inSession    := inSession);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReComplete_Movement_Check (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 21.08.15                                                                        *
*/