-- Function: gpReComplete_Movement_SendPartionDateChange (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_SendPartionDateChange (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_SendPartionDateChange(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SendPartionDateChange());

    -- ������ ���� �������� ��������
    IF EXISTS(
                SELECT 1
                FROM Movement
                WHERE Id = inMovementId
                  AND StatusId = zc_Enum_Status_Complete()
             )
    THEN
        --����������� ��������
        PERFORM gpUpdate_Status_SendPartionDateChange(inMovementId := inMovementId,
                                     inStatusCode := zc_Enum_StatusCode_UnComplete(),
                                     inSession    := inSession);
        --�������� ��������
        PERFORM gpUpdate_Status_SendPartionDateChange(inMovementId := inMovementId,
                                     inStatusCode := zc_Enum_StatusCode_Complete(),
                                     inSession    := inSession);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.07.20                                                       * 
*/

-- ����
--