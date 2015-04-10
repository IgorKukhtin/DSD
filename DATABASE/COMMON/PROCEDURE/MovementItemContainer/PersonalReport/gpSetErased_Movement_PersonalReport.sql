-- Function: gpSetErased_Movement_PersonalReport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PersonalReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PersonalReport(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PersonalReport());

     -- ��������
     PERFORM lpCheck_Movement_PersonalReport (inMovementId:= inMovementId, inComment:= '������', inUserId:= vbUserId);

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.09.14                                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_PersonalReport (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
