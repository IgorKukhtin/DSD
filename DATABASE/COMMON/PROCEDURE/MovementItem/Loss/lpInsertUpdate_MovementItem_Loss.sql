-- Function: lpInsertUpdate_MovementItem_Loss()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar,TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar,TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Loss(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inHeadCount           TFloat    , -- ���������� ����� 
    IN inPrice               TFloat    , -- ���� �������
    IN inPartionGoodsDate    TDateTime , -- ���� ������/���� �����������
    IN inPartionGoods        TVarChar  , -- ������ ������  
    IN inPartNumber          TVarChar  , -- � �� ��� ��������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inGoodsKindCompleteId Integer   , -- ���� �������  ��
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inPartionGoodsId      Integer   , -- ������ ������� (��� ������ ������� ���� � ��)   
    IN inStorageId           Integer   , -- ����� �������� 
    IN inPartionModelId      Integer   , -- ������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ���� �� ����������� ������ ������
     IF COALESCE (inGoodsId,0) = 0
     THEN
        RETURN;
     END IF;

     -- �������� zc_ObjectBoolean_GoodsByGoodsKind_Order
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO 
                WHERE MLO.MovementId = inMovementId
                  AND MLO.DescId   IN (zc_MovementLinkObject_From())
                  AND MLO.ObjectId IN (SELECT tt.UnitId FROM Object_Unit_check_isOrder_View_two AS tt)
                )
     THEN   
         -- ���� ������ � ��� ������ ��� � zc_ObjectBoolean_GoodsByGoodsKind_Order - ����� �������
         IF NOT EXISTS (SELECT 1
                        FROM ObjectBoolean AS ObjectBoolean_Order
                             INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                        WHERE ObjectBoolean_Order.ValueData = TRUE
                          AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                          AND Object_GoodsByGoodsKind_View.GoodsId = inGoodsId
                          AND COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) = COALESCE (inGoodsKindId,0)
                        )
              AND EXISTS (SELECT 1 FROM ObjectLink AS OL
                                   WHERE OL.ObjectId = inGoodsId
                                     AND OL.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                     AND OL.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- ������� ���������
                                                          --, zc_Enum_InfoMoney_30102() -- �������
                                                            , zc_Enum_InfoMoney_20901() -- ����
                                                             )
                         )
              AND inUserId <> 5
         THEN
             /*RAISE EXCEPTION '������.%� ������ <%> <%>%�� ����������� �������� <������������ � �������>=��.% % � % �� % % %'
                            , CHR (13)
                            , lfGet_Object_ValueData (inGoodsId)
                            , lfGet_Object_ValueData_sh (inGoodsKindId)
                            , CHR (13)
                            , CHR (13)
                            , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Loss()) 
                            , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                            , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                            , CHR (13)
                            , (SELECT lfGet_Object_ValueData_sh (MLO.ObjectId) FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                 || ' =>'  || (SELECT lfGet_Object_ValueData_sh (MLO.ObjectId) FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                            ;*/
              RAISE EXCEPTION '������.��� ������ <%>% ������ �������� ��� = <%>.'
                             , lfGet_Object_ValueData (inGoodsId)
                             , CHR (13)
                             , lfGet_Object_ValueData_sh (inGoodsKindId)
                              ;
         END IF;
     END IF;

     
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

     -- ��������� �������� <���� ������/���� �����������>
     IF COALESCE (inPartionGoodsDate, zc_DateStart()) <> zc_DateStart() OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = ioId AND MID.DescId = zc_MIDate_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate); 
     END IF;


     -- ��������� �������� <���������� ������� ��� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);

     -- ��������� �������� <���������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     
     -- ��������� �������� <���� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- ��������� �������� <������ ������>
     IF inPartionGoods <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_PartionGoods())
     THEN
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
     END IF; 

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- ��������� ����� � <���� ������� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

     -- ��������� ����� � <�������� �������� (��� ������� ���������� ���)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     -- ��������� ����� � <������ �������>
     --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionGoods(), ioId, CASE WHEN TRIM (inPartionGoods) <> '' THEN inPartionGoodsId ELSE inPartionGoodsId END);
     IF COALESCE (inPartionGoodsId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionGoods(), ioId, inPartionGoodsId);
     END IF;

     IF inGoodsId <> 0
     THEN
         -- ������� ������ <����� ������ � ���� �������>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;

     -- ��������� ����� � <����� ��������> - ��� ������ ������� �� ��
     IF COALESCE (inStorageId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_Storage())
     THEN
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
     END IF;

     -- ��������� �������� <������> 
     IF COALESCE (inPartionModelId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_PartionModel())
     THEN
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionModel(), ioId, inPartionModelId);
     END IF;
     
     -- ��������� �������� <� �� ��� ��������>
     IF inPartNumber <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_PartNumber())
     THEN
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.12.23         *
 26.05.23         *
 10.10.14                                        * add inPartionGoodsId
 06.09.14                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Loss (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
