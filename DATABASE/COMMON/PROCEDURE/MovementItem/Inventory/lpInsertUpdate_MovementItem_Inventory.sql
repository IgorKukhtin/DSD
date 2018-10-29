-- Function: lpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPartionGoodsDate    TDateTime , -- ���� ������/���� �����������
    IN inPrice               TFloat    , -- ����
    IN inSumm                TFloat    , -- �����
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inPartionGoods        TVarChar  , -- ������ ������/����������� �����
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inGoodsKindCompleteId Integer   , -- ���� �������  ��
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inUnitId              Integer   , -- ������������� (��� ��)
    IN inStorageId           Integer   , -- ����� ��������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
      -- !!!�������� inPartionGoodsDate!!!
     IF inPartionGoodsDate IS NOT NULL
     -- ����� ���������� + ����� ���� ��
     AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MILinkObject_From() AND MLO.ObjectId IN (8459, 8458))
     -- ��������� �����
     AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382))
      THEN
          RAISE EXCEPTION '������.� ��������� <��������������> � <%> �� <%> ������ ���� ������ ���� ������ <%>.'
                         , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                         , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                         , zfConvert_DateToString (inPartionGoodsDate)
                          ;
      END IF;

      -- !!!�������� ��� ������� ����!!!
     IF inAmount <> 0 -- AND inGoodsKindId <> 0
     -- ����� ���������� + ����� ���� ��
     AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MILinkObject_From() AND MLO.ObjectId IN (8459, 8458))
     -- ��������� �����
     AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382))
     -- ��������
     AND EXISTS (SELECT 1
                 FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                       ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                      LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                 ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                      LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                   ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                  AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()*/
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.ObjectId = inGoodsId
                   AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0)            = COALESCE (inGoodsKindId, 0)
                   -- AND COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0)    = COALESCE (inGoodsKindCompleteId, 0)
                   -- AND COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) = COALESCE (inPartionGoodsDate, zc_DateStart())
                   -- AND COALESCE (MIString_PartionGoods.ValueData, '')           = COALESCE (inPartionGoods, '')
                   AND MovementItem.isErased = FALSE
                   AND MovementItem.Amount <> 0
                   AND MovementItem.Id <> COALESCE (ioId, 0)
                )
      THEN
          -- RAISE EXCEPTION '������.� ��������� <��������������> � <%> �� <%> ��� ������� ������ <% % % % %> ������ �������������.�������� ������ � ��������� �������� ����� 25 ���.'
          RAISE EXCEPTION '������.� ��������� <��������������> � <%> �� <%> ��� ������� ������ <% %> ������ �������������.�������� ������ � ��������� �������� ����� 5 ���.'
                         , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                         , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                         , lfGet_Object_ValueData (inGoodsId)
                         , lfGet_Object_ValueData_sh (inGoodsKindId)
                         -- , lfGet_Object_ValueData (inGoodsKindCompleteId)
                         -- , (SELECT CASE WHEN inPartionGoodsDate > zc_DateStart() THEN zfConvert_DateToString (inPartionGoodsDate) ELSE '' END)
                         -- , (SELECT CASE WHEN inPartionGoods <> '' THEN inPartionGoods ELSE '' END)
                          ;
      END IF;


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <�����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

     -- ��������� �������� <���������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     -- ��������� �������� <���������� ������� ��� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);

     -- ��������� �������� <ContainerId>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, 0);


     -- ��������� �������� <���� ������/���� �����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
     -- ��������� �������� <������ ������/����������� �����>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- ��������� ����� � <���� ������� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

     -- ��������� ����� � <�������� �������� (��� ������� ���������� ���)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     -- ��������� ����� � <������������� (��� ��)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <����� ��������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);

     -- ������� ������ <����� ������ � ���� �������>
     PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.07.14                                        * add inPrice and inUnitId and inStorageId
 21.08.13                                        * add inGoodsKindId
 18.07.13         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Inventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
