-- Function: gpInsertUpdate_MovementItem_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Promo_Set_Zero (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Promo_Set_Zero(
    IN inMovementId          Integer   , -- ���� ������� <�������� ��������������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo());
     vbUserId := inSession;
	 
     -- �������� ��� �������
    PERFORM lpInsertUpdate_MovementItem_Promo (ioId                 := MovementItem.Id
                                             , inMovementId         := MovementItem.MovementId
                                             , inGoodsId            := MovementItem.ObjectId
                                             , inAmount             := 0::TFloat
                                             , inPrice              := COALESCE(MovementItemFloat_Price.ValueData,0)
                                             , inUserId             := vbUserId)
    FROM MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Price
                                          ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                                         AND MovementItemFloat_Price.DescId = zc_MIFloat_Price() 
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.Amount <> 0;
        
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
  25.04.16        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Promo_Set_Zero inMovementId:= 0, inSession:= '2')
