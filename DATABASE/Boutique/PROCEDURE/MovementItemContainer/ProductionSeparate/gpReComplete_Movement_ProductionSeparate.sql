-- Function: gpReComplete_Movement_ProductionSeparate(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_ProductionSeparate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ProductionSeparate(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ProductionSeparate());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_ProductionSeparate())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- �������� ��������
     PERFORM gpComplete_Movement_ProductionSeparate (inMovementId     := inMovementId
                                                   , inIsLastComplete := TRUE
                                                   , inSession        := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.07.15                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_ProductionSeparate (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
