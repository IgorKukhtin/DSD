-- Function: gpUpdate_MI_ProductionUnionTech_Master()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnionTech_Master(
    IN inMovementItemId_order Integer   , -- ���� ������� <������� ���������>
 INOUT ioMovementItemId       Integer   , -- ���� ������� <������� ���������>
 INOUT ioMovementId           Integer   , -- ���� ������� <��������>
    IN inReceiptId            Integer   , -- ���������
    IN inGoodsId              Integer   , -- ����� - !!!������ ��� �������� inReceiptId!!!
    IN inCount	              TFloat    , -- ���������� ������� ��� ��������
    IN inRealWeight           TFloat    , -- ����������� ���(������������)
    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbFromId Integer;
   DECLARE vbToId   Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnionTech_Master());


   -- �������� - ���� �� ����� ioMovementItemId + ioMovementId
   IF ioMovementId <> 0 AND NOT EXISTS (SELECT Id FROM MovementItem WHERE Id = ioMovementItemId AND MovementId = ioMovementId)
   THEN
       RAISE EXCEPTION '������.MovementId.';
   END IF;

   -- ���� ��� ������� - ������
   IF NOT EXISTS (SELECT MovementItem.Id FROM MovementItem INNER JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_ProductionUnion() WHERE MovementItem.Id = ioMovementItemId)
   THEN
       RAISE EXCEPTION '������.������ �� <��������> �� ������������.';
   END IF;

   -- �������� ��� ��� �������+���-��
   vbFromId:= COALESCE ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = ioMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From()), 0);
   vbToId  := COALESCE ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = ioMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_To())  , 0);
   IF (vbFromId <> vbToId) OR (NOT EXISTS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect WHERE lfSelect.UnitId = vbFromId)
                           -- AND vbFromId <> 951601 -- ��� �������� ����
                           AND vbFromId <> 981821   -- ��� �����. ����
                           AND vbFromId <> 2790412  -- ��� �������
                           AND vbFromId <> 8020711  -- ��� ������� + ���������� (����)
                              )
   THEN
       RAISE EXCEPTION '������.��������� �������� ������ ��� ������������ <%>.', lfGet_Object_ValueData (8446);
   END IF;

   -- ��������
   IF COALESCE (inReceiptId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <�������� ���������> �� �����������.';
   END IF;

   -- ��������
   IF 1 = 0 AND NOT EXISTS (SELECT ObjectId FROM ObjectLink  WHERE ChildObjectId = inGoodsId AND ObjectId = inReceiptId AND DescId = zc_ObjectLink_Receipt_Goods())
   THEN
       RAISE EXCEPTION '������.��� ������ <%> �� ����� ���� ������� ��������� <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inReceiptId);
   END IF;

   -- �������� - ���� ���������� <���������>
   IF COALESCE (inReceiptId, 0) <> COALESCE ((SELECT ObjectId FROM MovementItemLinkObject WHERE MovementItemId = ioMovementItemId AND DescId = zc_MILinkObject_Receipt()), 0)
      AND EXISTS (SELECT MovementId FROM MovementItem WHERE MovementId = ioMovementId AND DescId = zc_MI_Child())
   THEN
       RAISE EXCEPTION '������.������� ������ �� <��������>.�������� <�������� ���������> �������� ������.';
   END IF;


   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_Receipt(), ioMovementItemId, inReceiptId);
   -- ��������� ��-�� <�� ��������� ��������>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_WeightMain(), tmp.MovementItemId, CASE WHEN MIFloat_AmountSecond.ValueData > 0 THEN TRUE ELSE FALSE END)
   FROM (SELECT ioMovementItemId AS MovementItemId) AS tmp
        LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                    ON MIFloat_AmountSecond.MovementItemId = inMovementItemId_order
                                   AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond();

   -- ��������� �������� <���������� �������>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Count(), ioMovementItemId, inCount);
   -- ��������� �������� <����������� ���(������������)>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_RealWeight(), ioMovementItemId, inRealWeight);

   -- ��������� �������� <����������>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioMovementItemId, inComment);


   -- !!!��������� ��-�� <���������> � ������!!!
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), MovementItem_f.Id, inReceiptId)
   FROM MovementItem
        INNER JOIN MovementItemLinkObject AS MILO_Goods
                                          ON MILO_Goods.MovementItemId = MovementItem.Id
                                         AND MILO_Goods.DescId = zc_MILinkObject_Goods()
        INNER JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                          ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                         AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
        INNER JOIN MovementItem AS MovementItem_f ON MovementItem_f.MovementId = MovementItem.MovementId
                                                 AND MovementItem_f.DescId = zc_MI_Master()
        INNER JOIN MovementItemLinkObject AS MILO_Goods_f
                                          ON MILO_Goods_f.MovementItemId = MovementItem_f.Id
                                         AND MILO_Goods_f.DescId         = zc_MILinkObject_Goods()
                                         AND MILO_Goods_f.ObjectId       = MILO_Goods.ObjectId
        INNER JOIN MovementItemLinkObject AS MILO_GoodsKindComplete_f
                                          ON MILO_GoodsKindComplete_f.MovementItemId = MovementItem_f.Id
                                         AND MILO_GoodsKindComplete_f.DescId         = zc_MILinkObject_GoodsKindComplete()
                                         AND MILO_GoodsKindComplete_f.ObjectId       = MILO_GoodsKindComplete.ObjectId
   WHERE MovementItem.Id = inMovementItemId_order;

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioMovementItemId, vbUserId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioMovementItemId, CURRENT_TIMESTAMP);

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (ioMovementItemId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.03.15                                        *all
 19.12.14                                                       * add zc_MILinkObject_GoodsKindComplete
 12.12.14                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_ProductionUnionTech_Master (ioId:= 0, ioMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
