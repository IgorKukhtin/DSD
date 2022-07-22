-- Function: gpUpdateMIChild_OrderExternal_AmountSecondNull()

DROP FUNCTION IF EXISTS gpUpdateMIChild_OrderExternal_AmountSecondNull (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdateMIChild_OrderExternal_AmountSecondNull(
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

    
     -- �������� ������ - ������ � �����������
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, zc_MI_Child(), MovementItem.ObjectId, inMovementId, 0, MovementItem.ParentId)
     FROM MovementItem
          INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                       ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                      AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                      AND MIFloat_MovementId.ValueData      > 0
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE 
      ;

     -- ���� ��� ������� ��������
     IF NOT EXISTS (SELECT 1
                    FROM MovementItem
                         INNER JOIN MovementItem AS MI_parent
                                                 ON MI_parent.MovementId = inMovementId
                                                AND MI_parent.DescId     = zc_MI_Master()
                                                AND MI_parent.Id         = MovementItem.ParentId
                                                AND MI_parent.isErased   = FALSE 
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Child()
                      AND MovementItem.isErased   = FALSE 
                      AND MovementItem.Amount     > 0
                   )
     THEN
         -- ��������� �������� <��� ����������� ������> - ���
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Remains(), inMovementId, FALSE);
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�..
 05.07.22         *
*/

-- ����