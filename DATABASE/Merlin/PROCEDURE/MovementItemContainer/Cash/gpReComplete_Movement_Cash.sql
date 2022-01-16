-- Function: gpReComplete_Movement_Cash(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Cash(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Cash());
    vbUserId:= lpGetUserBySession (inSession);
    
    -- ������ ���� �������� ��������
    IF EXISTS(
                SELECT 1
                FROM Movement
                WHERE Id = inMovementId
                  AND StatusId = zc_Enum_Status_Complete()
              )
    THEN
        --����������� ��������
        PERFORM gpUpdate_Status_Cash(inMovementId := inMovementId,
                                          inStatusCode := zc_Enum_StatusCode_UnComplete(),
                                          inSession    := inSession);
        --�������� ��������
        PERFORM gpUpdate_Status_Cash(inMovementId := inMovementId,
                                          inStatusCode := zc_Enum_StatusCode_Complete(),
                                          inSession    := inSession);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.01.22         *
*/
