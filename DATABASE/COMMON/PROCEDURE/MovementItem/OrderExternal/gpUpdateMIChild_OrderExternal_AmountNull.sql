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
--return;
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternalUnit());

    -- ���������
   PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, zc_MI_Child(), MovementItem.ObjectId, inMovementId, Null, MovementItem.ParentId);
         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), MovementItem.Id, Null)  -- ��������� �������� <���������� �������>
   FROM MovementItem
   WHERE MovementItem.MovementId = inMovementId
     AND MovementItem.DescId = zc_MI_Child()
     AND MovementItem.isErased = FALSE 
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