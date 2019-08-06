-- Function: gpSetErased_Movement_Sale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Sale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Sale(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Sale());
    vbUserId := inSession::Integer; 
    -- �������� - ���� <Master> ��������, �� <������>
    --PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

    -- �������� - ���� ���� <Child> ��������, �� <������>
    PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

    IF COALESCE ((SELECT ValueData FROM MovementBoolean 
                  WHERE MovementId = inMovementId
                    AND DescId = zc_MovementBoolean_Deferred()), FALSE)= TRUE
    THEN
       -- ��������� �������
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), inMovementId, FALSE);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.   ������ �.�.
 04.08.19                                                                                      *
 13.10.15                                                                       *
*/



