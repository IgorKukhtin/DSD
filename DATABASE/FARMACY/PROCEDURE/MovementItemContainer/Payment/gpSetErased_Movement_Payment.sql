-- Function: gpSetErased_Movement_Payment (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Payment (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Payment(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Payment());
    vbUserId := inSession::Integer; 
    -- �������� - ���� <Master> ��������, �� <������>
    --PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- ��������
    IF EXISTS (SELECT MIC.Id FROM MovementItemContainer AS MIC WHERE MIC.Movementid = inMovementId)
    THEN
        RAISE EXCEPTION '������.�������� ��������, �������� ���������!';
    END IF;
     
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 13.10.15                                                                       *
*/
