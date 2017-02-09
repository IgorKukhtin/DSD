-- Function: gpSetErased_Movement_QualityDoc (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_QualityDoc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_QualityDoc(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_QualityDoc());


     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.05.15                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_QualityDoc (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
