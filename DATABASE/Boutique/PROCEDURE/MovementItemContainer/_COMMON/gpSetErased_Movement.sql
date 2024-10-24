-- Function: gpSetErased_Movement (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement(
    IN inMovementId Integer               , -- ���� ������� <��������>
    IN inSession    TVarChar                -- ������� ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Movement());
      vbUserId:= lpGetUserBySession (inSession);
/*
     -- !!!��� ������ ��������� ��� ��������, ����� �� Sybase �� ���������!!!
     IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- �������� - ���� <Master> ��������, �� <������>
         PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

         -- �������� - ���� ���� <Child> ��������, �� <������>
         PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');
     END IF;
*/
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Income())
     THEN
         -- ������� ��������
         PERFORM gpSetErased_Movement_Income (inMovementId := inMovementId
                                            , inSession    := inSession);
     ELSE
         -- ������� ��������
         PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                     , inUserId     := vbUserId);
     END IF;

/*
     -- ������� ����������� ���������
     PERFORM lpSetErased_Movement (inMovementId := Movement.Id
                                 , inUserId     := vbUserId)
     FROM Movement
     WHERE ParentId = inMovementId;
*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_Movement (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.04.14                                        * add !!!��� ������ ��������� ��� ��������, ����� �� Sybase �� ���������!!!
 12.10.13                                        * del ������� ����������� ���������
 12.10.13                                        * add lfCheck_Movement_ParentStatus and lfCheck_Movement_ChildStatus
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement (inMovementId:= 0, inIsChild := TRUE, inSession:= '2')
