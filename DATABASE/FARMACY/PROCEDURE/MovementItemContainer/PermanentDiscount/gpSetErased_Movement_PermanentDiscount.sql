-- Function: gpSetErased_Movement_PermanentDiscount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PermanentDiscount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PermanentDiscount(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PermanentDiscount());
    vbUserId:= lpGetUserBySession (inSession);


    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.12.19                                                       *
*/
