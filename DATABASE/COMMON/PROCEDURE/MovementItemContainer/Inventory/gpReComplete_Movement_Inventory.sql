-- Function: gpReComplete_Movement_Inventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Inventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Inventory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Inventory());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_Inventory())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� - ��� ��������
     IF vbUserId = 5 AND 1=0
     THEN PERFORM gpInsertUpdate_MovementItem_Inventory_Amount (inMovementId := inMovementId
                                                              , inSession    := inSession
                                                               );
     END IF;


     -- �������� ��������
     PERFORM gpComplete_Movement_Inventory (inMovementId     := inMovementId
                                          , inIsLastComplete := TRUE
                                          , inSession        := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.05.15                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpReComplete_Movement_Inventory (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= zfCalc_UserAdmin())
