-- Function: gpSetErased_Movement_ProjectsImprovements (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ProjectsImprovements (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ProjectsImprovements(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProjectsImprovements());

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '�������� ��� ���������, ���������� � ���������� ��������������';
    END IF;

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.05.20                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ProjectsImprovements (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
