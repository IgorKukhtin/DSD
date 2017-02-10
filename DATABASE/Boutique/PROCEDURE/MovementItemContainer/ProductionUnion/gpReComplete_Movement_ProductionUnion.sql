-- Function: gpReComplete_Movement_ProductionUnion(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_ProductionUnion (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReComplete_Movement_ProductionUnion (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ProductionUnion(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ProductionUnion());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_ProductionUnion())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := inMovementId
                                                , inIsHistoryCost  := TRUE
                                                , inUserId         := vbUserId);

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
-- SELECT * FROM gpReComplete_Movement_ProductionUnion (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
