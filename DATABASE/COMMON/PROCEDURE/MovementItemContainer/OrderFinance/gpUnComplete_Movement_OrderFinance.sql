-- Function: gpUnComplete_Movement_OrderFinance (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderFinance (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_OrderFinance(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_OrderFinance());
      vbUserId:= lpGetUserBySession (inSession);

      -- ����������� ��������
      PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                   , inUserId     := vbUserId
                                    );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.07.19         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_OrderFinance (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
