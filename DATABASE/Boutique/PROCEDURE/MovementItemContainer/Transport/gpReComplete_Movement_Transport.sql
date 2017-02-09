-- Function: gpReComplete_Movement_Transport(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Transport (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Transport(
    IN inMovementId        Integer               , -- ���� ���������
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Transport());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_Transport())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Transport_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_Transport (inMovementId     := inMovementId
                                          , inUserId         := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.04.15         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 1794 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_Transport (inMovementId := 1794, inIsLastComplete := FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 1794 , inSession:= '2')

