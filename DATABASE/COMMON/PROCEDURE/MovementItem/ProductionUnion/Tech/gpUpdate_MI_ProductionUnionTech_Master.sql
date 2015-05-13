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

   -- ��������
   IF COALESCE (inReceiptId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <�������� ���������> �� �����������.';
   END IF;

   -- ��������
   IF NOT EXISTS (SELECT ObjectId FROM ObjectLink  WHERE ChildObjectId = inGoodsId AND ObjectId = inReceiptId AND DescId = zc_ObjectLink_Receipt_Goods())
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

   -- ��������� �������� <���������� �������>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Count(), ioMovementItemId, inCount);
   -- ��������� �������� <����������� ���(������������)>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_RealWeight(), ioMovementItemId, inRealWeight);

   -- ��������� �������� <����������>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioMovementItemId, inComment);


   -- !!!��������� ��-�� <���������> � ������!!!
   IF inMovementItemId_order <> 0
   THEN
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), inMovementItemId_order, inReceiptId);
   END IF;

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
