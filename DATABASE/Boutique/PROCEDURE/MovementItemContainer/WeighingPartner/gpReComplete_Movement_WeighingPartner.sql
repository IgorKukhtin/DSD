-- Function: gpReComplete_Movement_WeighingPartner(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_WeighingPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_WeighingPartner(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_WeighingPartner());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_WeighingPartner())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingPartner()
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
-- SELECT * FROM gpReComplete_Movement_WeighingPartner (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
