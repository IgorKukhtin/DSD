-- Function: gpReComplete_Movement_EntryAsset(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_EntryAsset (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_EntryAsset(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_EntryAsset());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_EntryAsset())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� ��������
     PERFORM lpComplete_Movement_EntryAsset (inMovementId     := inMovementId
                                           , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.08.16         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_EntryAsset (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
