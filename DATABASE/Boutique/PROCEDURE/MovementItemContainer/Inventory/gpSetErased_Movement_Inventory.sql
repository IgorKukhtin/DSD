-- Function: gpSetErased_Movement_Inventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Inventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Inventory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_Inventory());
    vbUserId:= lpGetUserBySession (inSession);

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 25.04.17         *
*/
