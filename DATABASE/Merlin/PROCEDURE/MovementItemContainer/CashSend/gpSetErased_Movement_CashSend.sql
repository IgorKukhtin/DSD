-- Function: gpSetErased_Movement_CashSend (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_CashSend (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_CashSend(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_CashSend());
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
 15.01.22         *
*/
