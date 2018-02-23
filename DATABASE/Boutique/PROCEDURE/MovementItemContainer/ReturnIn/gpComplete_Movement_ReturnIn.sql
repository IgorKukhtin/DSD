-- Function: gpComplete_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnIn  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnIn(
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());

     -- ��������� ��������� ������� - ��� ������������ ������ �� ���������
     PERFORM lpComplete_Movement_ReturnIn_CreateTemp();

     -- ��������
     PERFORM lpComplete_Movement_ReturnIn (inMovementId  -- ��������
                                         , vbUserId);    -- ������������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 23.07.17         *
 14.05.17         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_ReturnIn (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
