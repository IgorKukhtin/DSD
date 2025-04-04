-- Function: gpReComplete_Movement_Promo(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Promo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Promo(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Promo());
    vbUserId := inSession;


    IF inSession = '3'
    THEN
       -- �������� �� �������....
       PERFORM lpReComplete_Movement_Promo_All (inMovementId, vbUserId);
    ELSE

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
        PERFORM gpUpdate_Status_Promo(inMovementId := inMovementId,
                                     inStatusCode := zc_Enum_StatusCode_UnComplete(),
                                     inSession    := inSession);
        --�������� ��������
        PERFORM gpUpdate_Status_Promo(inMovementId := inMovementId,
                                     inStatusCode := zc_Enum_StatusCode_Complete(),
                                     inSession    := inSession);
    END IF;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �o������� �.�.
 25.04.16         *
*/
