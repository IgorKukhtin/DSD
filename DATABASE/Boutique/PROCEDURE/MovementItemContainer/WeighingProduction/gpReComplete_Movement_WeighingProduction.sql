-- Function: gpReComplete_Movement_WeighingProduction(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_WeighingProduction (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_WeighingProduction(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_WeighingProduction());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_WeighingProduction())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingProduction()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.05.15                                        *
*/

-- ����
-- SELECT * FROM gpReComplete_Movement_WeighingProduction (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
