-- Function: gpSetErased_Movement_FinalSUA (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_FinalSUA (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_FinalSUA(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
  DECLARE vbStatusId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_FinalSUA());
     vbUserId := inSession;

     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
       RAISE EXCEPTION '����������� �������� ��� ���������, ���������� � ���������� ��������������';
     END IF;

     IF EXISTS (SELECT 1 FROM MovementDate  WHERE MovementId = inMovementId AND DescId = zc_MovementDate_Calculation())
     THEN
       RAISE EXCEPTION '�� ��������� ������������ ����������� � ��� ��������� ������� ���������.';
     END IF;
    
     -- �������� - ���� <Master> ��������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- �������� - ���� ���� <Child> ��������, �� <������>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.02.21                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_FinalSUA (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())