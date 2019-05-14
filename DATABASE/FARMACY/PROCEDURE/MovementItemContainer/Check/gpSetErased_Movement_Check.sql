DROP FUNCTION IF EXISTS gpSetErased_Movement_Check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Check(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    --���� �������� ��� �������� �� �������� �����
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    IF EXISTS(SELECT 1
              FROM Movement
              WHERE
                  ID = inMovementId
                  AND
                  StatusId = zc_Enum_Status_Complete())
    THEN
        vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Income());
    END IF;

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.   ������ �.�.
 13.05.19                                                                                     *
 05.07.15                                                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Income (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
