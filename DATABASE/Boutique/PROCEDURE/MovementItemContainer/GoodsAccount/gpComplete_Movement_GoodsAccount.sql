-- Function: gpComplete_Movement_GoodsAccount()

DROP FUNCTION IF EXISTS gpComplete_Movement_GoodsAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_GoodsAccount(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpGetUserBySession (inSession);
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_GoodsAccount());

     -- ��������� ��������� ������� - ��� ������������ ������ �� ���������
     PERFORM lpComplete_Movement_GoodsAccount_CreateTemp();

     -- ���������� ��������
     PERFORM lpComplete_Movement_GoodsAccount (inMovementId  -- ���� ���������
                                             , vbUserId);    -- ������������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 23.07.17         *
 18.05.17         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_GoodsAccount (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
