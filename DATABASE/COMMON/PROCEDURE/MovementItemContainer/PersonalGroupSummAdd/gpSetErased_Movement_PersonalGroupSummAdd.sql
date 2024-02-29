-- Function: gpSetErased_Movement_PersonalGroupSummAdd (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PersonalGroupSummAdd (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PersonalGroupSummAdd(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PersonalGroupSummAdd());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.02.24         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_PersonalGroupSummAdd (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
