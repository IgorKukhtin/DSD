-- Function: gpUnComplete_Movement_SendOnPrice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_SendOnPrice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_SendOnPrice(
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
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_SendOnPrice());

     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);


     -- ����� "�����������"
     vbMovementId_Peresort:= (SELECT MLM.MovementId
                              FROM MovementLinkMovement AS MLM
                                   JOIN Movement ON Movement.Id       = MLM.MovementId
                                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                              WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Production()
                             );
     -- ��������� - ����������
     IF vbMovementId_Peresort <> 0
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Peresort
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
-- SELECT * FROM gpUnComplete_Movement_SendOnPrice (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
