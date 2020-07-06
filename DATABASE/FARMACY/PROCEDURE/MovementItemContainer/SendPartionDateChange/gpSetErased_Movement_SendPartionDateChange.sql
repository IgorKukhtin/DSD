-- Function: gpSetErased_Movement_SendPartionDateChange (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_SendPartionDateChange (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_SendPartionDateChange(
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
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_SendPartionDateChange());

     -- ����������� �������� ��������� ������
     SELECT Movement.ID, Movement.StatusId
     INTO vbMovementId, vbStatusId
     FROM Movement
     WHERE Movement.DescId = zc_Movement_SendPartionDate()
       AND Movement.ParentId = inMovementId;
       
     IF COALESCE (vbMovementId, 0) > 0 AND vbStatusId <> zc_Enum_Status_Erased()
     THEN
       PERFORM gpSetErased_Movement_SendPartionDate (vbMovementId, inSession);    
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
 02.07.20                                                       * 
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_SendPartionDateChange (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
