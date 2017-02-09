-- Function: gpReComplete_Movement_SendOnPrice(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_SendOnPrice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_SendOnPrice(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SendOnPrice());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_SendOnPrice())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_SendOnPrice_CreateTemp();
     -- �������� ��������
     PERFORM lpComplete_Movement_SendOnPrice (inMovementId     := inMovementId
                                            , inUserId         := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.08.15                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_SendOnPrice (inMovementId:= 2688640, inSession:= zfCalc_UserAdmin()) -- zc_Enum_Process_Auto_PrimeCost() :: TVarChar
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
