-- Function: gpUnComplete_Movement_ReturnOut (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ReturnOut (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ReturnOut(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnit Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbChangeIncmePaymentId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_ReturnOut());

     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

     --���� ��������� �������� ��������� ����� �� ��������
     SELECT
         MovementLinkMovement.MovementChildId
     INTO
         vbChangeIncmePaymentId
     FROM
         MovementLinkMovement

     WHERE MovementLinkMovement.MovementId = inMovementId
       AND MovementLinkMovement.DescId = zc_MovementLinkMovement_ChangeIncomePayment();


     --���� ����� �������� ���� - ����������� ���
     IF COALESCE(vbChangeIncmePaymentId,0) <> 0
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := vbChangeIncmePaymentId
                                      , inUserId     := vbUserId);  
     END IF;
                                  
     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.07.14                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_ReturnOut (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
