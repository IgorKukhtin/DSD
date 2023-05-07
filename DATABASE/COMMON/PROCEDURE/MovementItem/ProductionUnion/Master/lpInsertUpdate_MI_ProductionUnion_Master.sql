-- Function: lpInsertUpdate_MI_ProductionUnion_Master()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnion_Master(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inAmount                TFloat    , -- ����������
    IN inCount	               TFloat    , -- ���������� �������
    IN inCuterWeight	       TFloat    , -- ����������� ���(�������)
    IN inPartionGoodsDate      TDateTime , -- ������ ������
    IN inPartionGoods          TVarChar  , -- ������ ������
    IN inPartNumber            TVarChar  , -- � �� ��� ��������
    IN inGoodsKindId           Integer   , -- ���� �������
    IN inGoodsKindId_Complete  Integer   , -- ���� ������� �� 
    IN inStorageId             Integer   , -- ����� ��������
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbIsInsert Boolean;
BEGIN
   -- ��������
   IF COALESCE (inGoodsId, 0) = 0
   THEN 
       RAISE EXCEPTION '������.�� ���������� �������� ��������� <�����>.';
   END IF;

     ---�������� zc_ObjectBoolean_GoodsByGoodsKind_Order ��� ������������� �� Object_Unit_check_isOrder_View
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO 
                WHERE MLO.MovementId = inMovementId
                  AND MLO.DescId = zc_MovementLinkObject_To()
                  AND MLO.ObjectId IN (SELECT tt.UnitId FROM Object_Unit_check_isOrder_View AS tt)
                )
     THEN   
         --���� ������ � ���� ������  ��� � zc_ObjectBoolean_GoodsByGoodsKind_Order  - ����� �������
         IF NOT EXISTS (SELECT 1
                        FROM ObjectBoolean AS ObjectBoolean_Order
                             INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                        WHERE ObjectBoolean_Order.ValueData = TRUE
                          AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                          AND Object_GoodsByGoodsKind_View.GoodsId = inGoodsId
                          AND COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) = COALESCE (inGoodsKindId,0)
                        )
         THEN
             RAISE EXCEPTION '������.� ������ <%> <%> �� ����������� �������� ������������ � �������.% % � % �� % % %'
                            , lfGet_Object_ValueData (inGoodsId)
                            , lfGet_Object_ValueData_sh (inGoodsKindId)
                            , CHR (13)
                            , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_ProductionUnion()) 
                            , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                            , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                            , CHR (13)
                            , (SELECT Object.ValueData 
                               FROM MovementLinkObject AS MLO
                                  LEFT JOIN Object ON Object.Id = MLO.ObjectId
                               WHERE MLO.MovementId = inMovementId
                                 AND MLO.DescId = zc_MovementLinkObject_To())
                            ;
         END IF;
     END IF;

   -- ������ ��������
   IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;


   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

   -- ��������� ����� � <���� �������>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
   -- ��������� ����� � <���� ������� ��>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindId_Complete);

   -- ��������� ����� � <����� ��������> - ��� ������ ������� �� ��
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
     
   -- ��������� �������� <���������� �������>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Count(), ioId, inCount);

   -- ��������� �������� <����������� ���(�������)>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_CuterWeight(), ioId, inCuterWeight);
   
   -- ��������� �������� <������ ������> � Child
   IF vbIsInsert = FALSE
   THEN
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), MovementItem.Id, inPartionGoodsDate)
       FROM MovementItemDate
            INNER JOIN MovementItem ON MovementItem.ParentId = ioId
            INNER JOIN MovementItemDate AS MovementItemDate_find ON MovementItemDate_find.MovementItemId = MovementItem.Id
                                                                AND MovementItemDate_find.DescId = zc_MIDate_PartionGoods()
                                                                AND MovementItemDate_find.ValueData = MovementItemDate.ValueData
       WHERE MovementItemDate.MovementItemId = ioId
         AND MovementItemDate.DescId = zc_MIDate_PartionGoods();
   END IF;

   -- ������� ������
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionClose(), ioId, FALSE);

   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_PartionGoods(), ioId, inPartionGoods);

   -- ��������� �������� <� �� ��� ��������>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);

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
 26.10.20         * add inGoodsKindId_Complete
 29.06.16         * add inCuterWeight
 21.03.15                                        * all
 19.12.14                                                       * add zc_MILinkObject_???GoodsKindComplete
 11.12.14         * �� gp
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_ProductionUnion_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
