-- Function: gpUnComplete_Movement_GoodsAccount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_GoodsAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_GoodsAccount(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_GoodsAccount());
    vbUserId:= lpGetUserBySession (inSession);

    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�
 18.05.17         *
*/