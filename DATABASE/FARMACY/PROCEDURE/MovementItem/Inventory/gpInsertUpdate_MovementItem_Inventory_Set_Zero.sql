-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_Set_Zero (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_Set_Zero(
    IN inMovementId          Integer   , -- ���� ������� <�������� ��������������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
	 
    -- ���������� �����
    PERFORM lpInsertUpdate_MI_Inventory_Child(inId                 := 0
                                            , inMovementId         := inMovementId
                                            , inParentId           := MovementItem.Id
                                            , inAmountUser         := 0::TFloat
                                            , inUserId             := vbUserId
                                              )
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.Amount <> 0
       AND MovementItem.isErased = FALSE;

    -- �������� ��� �������
    PERFORM lpInsertUpdate_MovementItem_Inventory (ioId                 := MovementItem.Id
                                                 , inMovementId         := MovementItem.MovementId
                                                 , inGoodsId            := MovementItem.ObjectId
                                                 , inAmount             := 0::TFloat
                                                 , inPrice              := COALESCE(MovementItemFloat_Price.ValueData,0)
                                                 , inSumm               := 0::TFloat
                                                 , inComment            := NULL::TVarChar
                                                 , inUserId             := vbUserId)
    FROM MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Price
                                          ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                                         AND MovementItemFloat_Price.DescId = zc_MIFloat_Price() 
    WHERE
        MovementItem.MovementId = inMovementId
        AND
        MovementItem.DescId = zc_MI_Master()
        AND
        MovementItem.Amount <> 0;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Inventory_Set_Zero (Integer, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
  05.01.17        *
  03.08.15                                                                    *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_Set_Zero inMovementId:= 0, inSession:= '2')
