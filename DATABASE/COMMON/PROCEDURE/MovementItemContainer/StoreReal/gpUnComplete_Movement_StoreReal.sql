-- Function: gpUnComplete_Movement_StoreReal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_StoreReal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_StoreReal(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_StoreReal());
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.03.17         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_StoreReal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
