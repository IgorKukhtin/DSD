-- Function: gpReComplete_Movement_QualityDoc(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_QualityDoc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_QualityDoc(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_QualityDoc());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_QualityDoc())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_QualityDoc()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.05.15                                        *
*/

-- ����
-- SELECT * FROM gpReComplete_Movement_QualityDoc (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
