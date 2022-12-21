-- Function: gpSetErased_Movement_SendOnPrice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_SendOnPrice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_SendOnPrice(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_Peresort Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_SendOnPrice());

     -- �������� - ���� <Master> ��������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- �������� - ���� ���� <Child> ��������, �� <������>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


     -- ����� "�����������"
     vbMovementId_Peresort:= (SELECT MLM.MovementId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Production());
     -- ��������� - �������
     IF vbMovementId_Peresort <> 0
     THEN
         PERFORM lpSetErased_Movement (inMovementId := vbMovementId_Peresort
                                     , inUserId     := vbUserId
                                      );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.05.14                                                       *
 29.10.13                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_SendOnPrice (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
