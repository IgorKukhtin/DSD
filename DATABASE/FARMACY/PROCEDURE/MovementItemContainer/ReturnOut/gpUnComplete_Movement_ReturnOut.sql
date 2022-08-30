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
  DECLARE vbStatusId    Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession;

     -- ��������� ������ ����������� � ������� ������    
     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_UnComplete()))
     THEN
       vbUserId := lpCheckRight(inSession, zc_Enum_Process_UnComplete_ReturnOut());
     END IF;

     -- �������� ������
     SELECT Movement.StatusId
     INTO vbStatusId
     FROM Movement
     WHERE Movement.Id = inMovementId;

     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

     IF vbStatusId = zc_Enum_Status_Erased() AND
        EXISTS(SELECT 1
               FROM MovementLinkMovement 

                    INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                               ON MovementBoolean_Deferred.MovementId = MovementLinkMovement.MovementChildId
                                              AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                              AND MovementBoolean_Deferred.ValueData = TRUE

               WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Pretension()
                 AND MovementLinkMovement.MovementId = inMovementId)
     THEN
       RAISE EXCEPTION '��������� ��������. ����� ������� �������� �������� ������� ���������.';       
     END IF;
           
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