-- Function: gpUnComplete_Movement_PromoTrade (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_PromoTrade (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_PromoTrade(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_PromoTrade());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.11.20         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_PromoTrade (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
