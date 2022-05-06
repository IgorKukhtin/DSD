-- Function: gpInsertUpdate_MI_CompetitorMarkupsLoadGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_CompetitorMarkupsLoadGoods(Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_CompetitorMarkupsLoadGoods(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsCode           Integer   , -- �����
    IN inPrice               TFloat    , -- ������� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbGoodsID Integer;
   DECLARE vbId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups());
    
    IF COALESCE (inGoodsCode, 0) = 0
    THEN
      RETURN;
    END IF;

    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    SELECT Object_Goods_Retail.Id
    INTO vbGoodsID
    FROM Object_Goods_Main
    
         INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_Main.Id
                                       AND Object_Goods_Retail.RetailId = 4
    WHERE Object_Goods_Main.ObjectCode = inGoodsCode;
    
    IF COALESCE (vbGoodsID, 0) = 0
    THEN
      RETURN;
    END IF;

    IF EXISTS(SELECT MovementItem.Id 
              FROM MovementItem
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.ObjectId = vbGoodsID)
    THEN
      SELECT MovementItem.Id 
      INTO vbId
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = vbGoodsID;
        
      IF COALESCE ((SELECT MIFloat_Price.ValueData 
                    FROM MovementItemFloat AS MIFloat_Price
                    WHERE MIFloat_Price.MovementItemId = vbId
                      AND MIFloat_Price.DescId = zc_MIFloat_Price()) , 0) = COALESCE ( inPrice, 0) 
      THEN
         RETURN;
      END IF;
    ELSE
      vbId := 0;
    END IF;

    -- ���������
    PERFORM lpInsertUpdate_MovementItem_CompetitorMarkups (ioId                  := vbId                  -- ���� ������� <������� ���������>
                                                         , inMovementId          := inMovementId          -- ���� ���������
                                                         , inGoodsID             := vbGoodsID             -- �����
                                                         , inPrice               := inPrice               -- ������� ����  
                                                         , inUserId              := vbUserId              -- ������������
                                                           );
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.05.22                                                        *
*/

-- ����
-- select * from gpInsertUpdate_MI_CompetitorMarkupsLoadGoods(inMovementId := 27717912 , inGoodsCode := 18922,  inSession := '3');