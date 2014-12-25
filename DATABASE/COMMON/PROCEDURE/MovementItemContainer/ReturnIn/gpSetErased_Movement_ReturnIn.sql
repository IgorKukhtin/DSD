-- Function: gpSetErased_Movement_ReturnIn (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ReturnIn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ReturnIn(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ReturnIn());

     -- �������� - ���� <Master> ��������, �� <������>
     -- PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- �������� - ���� ���� <Child> ��������, �� <������>
     -- PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- ��������� ��� ����������� �������������
     PERFORM lpSetErased_Movement (inMovementId := MovementLinkMovement.MovementId
                                 , inUserId     := vbUserId)
     FROM MovementLinkMovement
     WHERE MovementLinkMovement.MovementChildId = inMovementId
       AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.12.14				         * add ��������� ��� ����������� �������������
 29.01.14				                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ReturnIn (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
