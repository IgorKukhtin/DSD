-- Function: gpInsertUpdate_MovementItem_SendOnPrice()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_SendOnPrice(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inAmountChangePercent TFloat    , -- ���������� c ������ % ������
    IN inChangePercentAmount TFloat    , -- % ������ ��� ���-��
    IN inPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ��������� 

    IN inCount               TFloat    , -- ���������� ������� (������)
    IN inCountPartner        TFloat    , -- ���������� �������(������)
    
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inUnitId              Integer   , -- �������������
    IN inCountPack           TFloat    , -- ���������� �������� (������)
    IN inWeightTotal         TFloat    , -- ��� 1 ��. ��������� + ��������
    IN inWeightPack          TFloat    , -- ��� �������� ��� 1-�� ��. ���������
    IN inIsBarCode           Boolean   , -- 
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� zc_ObjectBoolean_GoodsByGoodsKind_Order
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO 
                WHERE MLO.MovementId = inMovementId
                  AND MLO.DescId   IN (zc_MovementLinkObject_From(), zc_MovementLinkObject_To())
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
              AND NOT (inGoodsId     = 9505524 -- 457 - ������� Բ����� ��� 1 � �� ���� �������
                   AND inGoodsKindId = 8344    -- �/� 0,5��
                      )
         THEN
             /*RAISE EXCEPTION '������.%� ������ <%> <%>%�� ����������� �������� <������������ � �������>=��.% % � % �� % % %'
                            , CHR (13)
                            , lfGet_Object_ValueData (inGoodsId)
                            , lfGet_Object_ValueData_sh (inGoodsKindId)
                            , CHR (13)
                            , CHR (13)
                            , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_SendOnPrice()) 
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


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <���������� � �����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- ��������� �������� <���������� c ������ % ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountChangePercent(), ioId, inAmountChangePercent);
     -- ��������� �������� <% ������ ��� ���-��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), ioId, inChangePercentAmount);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- ��������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);


     -- ��������� �������� <���������� �������� (������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountPack);
     -- ��������� �������� <��� 1 ��. ��������� + ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTotal(), ioId, inWeightTotal);
     -- ��������� �������� <��� �������� ��� 1-�� ��. ���������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightPack(), ioId, inWeightPack);

     -- ��������� �������� <���������� ������� (������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);
     -- ��������� �������� <���������� ������� (������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPartner(), ioId, inCountPartner);
     
     -- ��������� �������� <�� �������>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), ioId, inIsBarCode);


     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     IF inGoodsId <> 0
     THEN
         -- ������� ������ <����� ������ � ���� �������>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmountPartner * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmountPartner * inPrice AS NUMERIC (16, 2))
                      END;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.08.22         * add inCount, inCountPartner
 13.11.15                                        *
 04.06.15         * add inUnitId
 05.05.14                                                        *
 08.02.14                                        *
 04.02.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_SendOnPrice (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
