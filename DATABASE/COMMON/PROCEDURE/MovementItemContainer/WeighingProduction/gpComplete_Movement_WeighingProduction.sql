-- Function: gpComplete_Movement_WeighingProduction (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_WeighingProduction (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_WeighingProduction(
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

     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingProduction()
                                , inUserId     := vbUserId
                                 );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.05.15                                        *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_WeighingProduction (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
