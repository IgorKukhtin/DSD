-- Function: gpComplete_Movement_PromoTrade()

DROP FUNCTION IF EXISTS gpComplete_Movement_PromoTrade (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PromoTrade(
    IN inMovementId        Integer                , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PromoTrade());

     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement_PromoTrade (inMovementId := inMovementId
                                           , inUserId     := vbUserId
                                            );
                                             
     -- �������� �������� + ��������� ��������
     PERFORM gpUpdate_Movement_PromoTradeHistory (inMovementId := inMovementId
                                                , inSession    := inSession
                                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.11.20         *
 */

-- ����
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PersonalService (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
