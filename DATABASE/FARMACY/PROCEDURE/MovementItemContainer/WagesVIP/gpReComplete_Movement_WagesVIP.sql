-- Function: gpReComplete_Movement_WagesVIP (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_WagesVIP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_WagesVIP(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WagesVIP());

    -- ������ ���� �������� ��������
    IF EXISTS(
                SELECT 1
                FROM Movement
                WHERE Id = inMovementId
                  AND StatusId = zc_Enum_Status_Complete()
             )
    THEN
        --����������� ��������
        PERFORM gpUpdate_Status_WagesVIP(inMovementId := inMovementId,
                                     inStatusCode := zc_Enum_StatusCode_UnComplete(),
                                     inSession    := inSession);
        --�������� ��������
        PERFORM gpUpdate_Status_WagesVIP(inMovementId := inMovementId,
                                     inStatusCode := zc_Enum_StatusCode_Complete(),
                                     inSession    := inSession);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.09.21                                                       *
*/

-- ����
--