 -- Function: lpInsertUpdate_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, TFloat, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, Integer, TFloat, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, TVarChar,TVarChar, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������������ - ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inPartionGoodsDate    TDateTime , -- ������ ������	
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inPartNumber          TVarChar  , -- � �� ��� �������� 
    IN inModel               TVarChar  , -- ������       
    IN inGoodsKindId         Integer   , -- ���� ������� 
    IN inGoodsKindCompleteId Integer   , -- ���� ������� �� 
    IN inStorageId           Integer   , -- ����� ��������             
    IN inCount_onCount       TFloat    , -- ���������� �������
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     ---�������� zc_ObjectBoolean_GoodsByGoodsKind_Order ��� ������������� �� Object_Unit_check_isOrder_View
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO 
                WHERE MLO.MovementId = inMovementId
                  AND MLO.DescId = zc_MovementLinkObject_From()
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
                                 AND MLO.DescId = zc_MovementLinkObject_From())
                            ; 
         END IF;
     END IF;


   -- !!!��������!!!
   IF ioId = 38052130 THEN
   -- ��������� ����� � <���� ������� ��>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, 8340); -- �������
   END IF;


   -- ��������
   IF COALESCE (inGoodsId, 0) = 0
   THEN 
       RAISE EXCEPTION '������.�� ���������� �������� ��������� <�����>.';
   END IF;
   -- ��������
   IF COALESCE (inParentId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� �������� ������� �������.';
   END IF;

   -- ������ ��������
   IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
 
   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId           := ioId
                                      , inDescId       := zc_MI_Child()
                                      , inObjectId     := inGoodsId
                                      , inMovementId   := inMovementId
                                      , inAmount       := inAmount
                                      , inParentId     := inParentId
                                      , inUserId       := inUserId
                                       );
  
   -- ��������� �������� <������ ������>
   IF inPartionGoodsDate NOT IN (zc_DateStart(), zc_DateEnd()) OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = ioId AND MID.DescId = zc_MIDate_PartionGoods())
   THEN
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
   END IF;
   

   -- ��������� �������� <������ ������/����������� �����>
   IF inPartionGoods <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_PartionGoods())
   THEN
       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
   END IF;
   

   -- ��������� �������� <� �� ��� ��������>
   IF inPartNumber <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_PartNumber())
   THEN
       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);
   END IF;
   
   -- ��������� �������� <������ (������ �����)>
   IF inModel <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_Model())
   THEN
       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Model(), ioId, inModel);
   END IF;
   
   -- ��������� ����� � <���� �������>
   IF inGoodsKindId > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_GoodsKind())
   THEN
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
   END IF;

   -- ��������� ����� � <���� ������� ��>
   IF inGoodsKindCompleteId > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_GoodsKindComplete())
   THEN
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);
   END IF;
   

   -- ��������� ����� � <����� ��������> - ��� ������ ������� �� ��
   IF inStorageId > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_Storage())
   THEN
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
   END IF;
   
   
   -- ��������� �������� <���������� �������>
   IF inCount_onCount <> 0 OR EXISTS (SELECT 1 FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_Count())
   THEN
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount_onCount);
   END IF;
   
     
   -- !!!������ ��� ��������!!!
   IF vbIsInsert = TRUE AND inUserId IN (zc_Enum_Process_Auto_PartionDate(), zc_Enum_Process_Auto_PartionClose())
   THEN
       PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, TRUE);
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
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.05.23         *
 07.11.15         * add inGoodsKindCompleteId
 11.07.15                                        * add inUserId:=
 05.07.15                                        * add inCount_onCount
 21.03.15                                        * all
 11.12.14         * �� gp
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_ProductionUnion_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
