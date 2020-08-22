-- Function: gpInsertUpdate_MovementItem_Inventory_Code()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_Code (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_Code(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������������>
    IN inGoodsCode           Integer   , -- �����
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGoodsId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);

       -- ������������ <�������� ����>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

            -- �������� GoodsMainId
     SELECT Object_Goods_Retail.Id
     INTO vbGoodsId
     FROM Object_Goods_Main
            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_Main.Id
                                         AND Object_Goods_Retail.RetailId = vbObjectId
     WHERE Object_Goods_Main.ObjectCode = inGoodsCode;

     IF COALESCE (vbGoodsId, 0) = 0
     THEN
       RAISE EXCEPTION '�� ������ ��� ������.';
     END IF;

     IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = vbGoodsId)
     THEN
       SELECT MovementItem.ID, MovementItem.Amount + inAmount
       INTO ioId, inAmount
       FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = vbGoodsId;
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), vbGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <�����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, Round(inPrice * inAmount, 2));

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ������ �.�.
 21.08.200                                                                  *
*/

-- ����
-- UPDATE MovementItem set Amount = 0 WHERE MovementItem.MovementId = 19965583
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_Code (ioId:= 0, inMovementId:= 19965583 , inGoodsCode:= 33618, inAmount:= 1, inPrice:= 247.5, inSession:= '14080152 ')