-- Function: gpComplete_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnIn_User  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnIn_User(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������ ������ ��� �������������!!! - ���� ���. ������ ��������������� ���� ����������
     UPDATE Movement SET OperDate = CURRENT_DATE WHERE Movement.Id = inMovementId;

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
 26.02.18         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_ReturnIn_User (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
