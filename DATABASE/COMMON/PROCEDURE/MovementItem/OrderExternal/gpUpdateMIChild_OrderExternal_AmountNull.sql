-- Function: gpUpdateMIChild_OrderExternal_AmountNull()

DROP FUNCTION IF EXISTS gpUpdateMIChild_OrderExternal_AmountNull (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdateMIChild_OrderExternal_AmountNull(
    IN inMovementId      Integer      , -- ���� ���������
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternal_child());


     -- ��������� �������� <��� ����������� ������> - ���
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Remains(), inMovementId, FALSE);


     -- �������� ���� ������
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, zc_MI_Child(), MovementItem.ObjectId, inMovementId, 0, MovementItem.ParentId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE 
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�..
 05.07.22         *
*/

-- ����