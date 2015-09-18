-- Function: gpUnComplete_Movement_Inventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Inventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Inventory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Inventory());

     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     --������� ��� ������, ������� ��������� ��� ����������
     PERFORM lpDelete_MovementItem(MovementItem.Id,inSession)
     FROM
         MovementItem
         INNER JOIN MovementItemBoolean AS MIBoolean_IsAuto
                                        ON MIBoolean_IsAuto.MovementItemId = MovementItem.Id
                                       AND MIBoolean_IsAuto.DescId = zc_MIBoolean_isAuto()
     WHERE
         MovementItem.MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 16.09.2015                                                                   *  + ������� ��� ������, ������� ��������� ��� ����������
 01.09.14                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_Inventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
