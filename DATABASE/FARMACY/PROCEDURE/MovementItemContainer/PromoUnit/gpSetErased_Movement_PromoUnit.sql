-- Function: gpSetErased_Movement_PromoUnit (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PromoUnit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PromoUnit(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PromoUnit());
    vbUserId:= lpGetUserBySession (inSession);

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 06.02.17         *
*/
