-- Function: gpSetErased_Movement_HospitalDoc_1C (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_HospitalDoc_1C (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_HospitalDoc_1C(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_HospitalDoc_1C());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.07.25         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_HospitalDoc_1C (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
