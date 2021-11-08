-- Function: gpSetErased_Movement_Income (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Income(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Income());

     -- �������� - ���� <Master> ��������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- �������� - ���� ���� <Child> ��������, �� <������>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     IF EXISTS(SELECT ValueData FROM  MovementBoolean 
               WHERE MovementBoolean.DescId = zc_MovementBoolean_Conduct()
                 AND MovementBoolean.MovementId = inMovementId
                 AND MovementBoolean.ValueData = TRUE)
     THEN
       -- �������� ���������� �� ������� ����������
       IF EXISTS(SELECT ValueData FROM MovementItem
                        INNER JOIN MovementItemBoolean ON MovementItemBoolean.DescId = zc_MIBoolean_Conduct()
                                                     AND MovementItemBoolean.MovementItemId = MovementItem.Id
                                                     AND MovementItemBoolean.ValueData = TRUE
                        WHERE MovementItem.MovementId = inMovementId)
       THEN
           PERFORM lpUnConduct_MovementItem_Income (inMovementId, MovementItem.Id, vbUserId) FROM MovementItem
                        INNER JOIN MovementItemBoolean ON MovementItemBoolean.DescId = zc_MIBoolean_Conduct()
                                                     AND MovementItemBoolean.MovementItemId = MovementItem.Id
                                                     AND MovementItemBoolean.ValueData = TRUE
                        WHERE MovementItem.MovementId = inMovementId;
       END IF;

       -- ��������� �������� <�������� �� ����������>
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Conduct(), inMovementId, False);

       -- ��������� �������� <���� ���������� �� ����������>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Conduct(), inMovementId, CURRENT_TIMESTAMP);
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
 03.07.14                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Income (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
