-- Function: gpUnComplete_Movement_OrderExternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderExternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderExternal (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUnComplete_Movement_OrderExternal(
    IN inMovementId        Integer               , -- ���� ���������
 INOUT ioPrinted           Boolean               ,
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������

)
RETURNS Boolean
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_OrderExternal());
     PERFORM gpInsertUpdate_Movement_OrderExternal_Print(inId := inMovementId , inNewPrinted := False , ioPrinted := False ,  inSession := inSession);
     ioPrinted := False;

     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

     -- !!!���������� �������� � ��������� ���������!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), MovementItem.Id, 0)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId;

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.06.14                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_OrderExternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
