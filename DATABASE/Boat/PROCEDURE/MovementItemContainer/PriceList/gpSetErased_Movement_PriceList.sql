-- Function: gpSetErased_Movement_PriceList (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PriceList(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PriceList());
    vbUserId:= lpGetUserBySession (inSession);

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.03.22         *
*/
