-- Function: gpSetErased_Movement_OrderExternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_OrderExternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSetErased_Movement_OrderExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_OrderExternal(
    IN inMovementId        Integer               , -- ���� ���������
   OUT outPrinted          Boolean               ,
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO
                     JOIN Object ON Object.Id = MLO.ObjectId AND Object.DescId = zc_Object_Unit()
                WHERE MLO.MovementId = inMovementId 
                  AND MLO.DescId     = zc_MovementLinkObject_From()
               )
     THEN
         -- ��� ��� zc_Object_Unit
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_OrderExternalUnit());
     ELSE
         -- ��� ��������� 
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_OrderExternal());
     END IF;


     -- ��������� �������� <��� ����������� ������> - ���
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Remains(), inMovementId, FALSE);

     -- �������� ���� ������
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, zc_MI_Child(), MovementItem.ObjectId, inMovementId, 0, MovementItem.ParentId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE 
      ;

     --
     outPrinted := gpUpdate_Movement_OrderExternal_Print(inId := inMovementId , inNewPrinted := FALSE,  inSession := inSession);

     -- �������� - ���� <Master> ��������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- �������� - ���� ���� <Child> ��������, �� <������>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- !!!���������� �������� � ��������� ���������!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), MovementItem.Id, 0)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId;

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.09.21         *
 06.06.14                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_OrderExternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())