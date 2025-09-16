-- Function: gpSetErased_Movement_StaffListMember (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_StaffListMember (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_StaffListMember(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_StaffListMember());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.25         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_StaffListMember (inMovementId:= 0, inSession:= zfCalc_UserAdmin())
