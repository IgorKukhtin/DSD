-- Function: lpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPartionGoodsDate    TDateTime , -- ���� ������
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inHeadCount           TFloat    , -- ���������� �����
 INOUT ioPartionGoods        TVarChar  , -- ������ ������/����������� �����
 INOUT ioPartNumber          TVarChar  , -- � �� ��� �������� 
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inGoodsKindCompleteId Integer   , -- ���� �������  ��
    IN inAssetId             Integer   , -- ��������� �� ������������ 1
    IN inAssetId_two         Integer   , -- ��������� �� ������������ 2
    IN inUnitId              Integer   , -- ������������� (��� ��)
    IN inStorageId           Integer   , -- ����� �������� 
    IN inPartionModelId      Integer   , -- ������
    IN inPartionGoodsId      Integer   , -- ������ ������� (��� ������ ������� ���� � ��)
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

     -- ���� �� ����������� ������ ������
     IF COALESCE (inGoodsId,0) = 0
     THEN
        RETURN;
     END IF;

 
     -- � ���� �������� � � ���� �� �� ����������������� ��������.
     IF inUserId <> 5 OR 1=1 THEN
     IF      -- 1.1.
             (EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_From()
                        -- ����� ���� ��
                        AND MLO.ObjectId = 8458
                     )
          AND EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_To()
                        -- ����������� ��������
                        AND MLO.ObjectId = 8459 
                     )
             )
          -- 1.2.
          OR (EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_From()
                        -- ��� ��������
                        AND MLO.ObjectId = 8451
                     )
          AND EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_To()
                        -- ����������� ��������
                        AND MLO.ObjectId = 8459 
                     )
             )
     THEN
         -- ���� ������ � ��� ������ ��� � zc_ObjectBoolean_GoodsByGoodsKind_Order - ����� �������
         IF NOT EXISTS (SELECT 1
                        FROM ObjectBoolean AS ObjectBoolean_RK
                             INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_RK.ObjectId
                        WHERE ObjectBoolean_RK.ValueData = TRUE
                          AND ObjectBoolean_RK.DescId = zc_ObjectBoolean_GoodsByGoodsKind_RK()
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
                  RAISE EXCEPTION '������.��� ������ <%>% ������ �������� ��� = <%>.% %'
                                 , lfGet_Object_ValueData (inGoodsId)
                                 , CHR (13)
                                 , lfGet_Object_ValueData_sh (inGoodsKindId)
                                 , CHR (13)
                                 , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId
                                                               FROM MovementLinkObject AS MLO
                                                               WHERE MLO.MovementId = inMovementId
                                                                 AND MLO.DescId = zc_MovementLinkObject_From()
                                                              ))
                                || '  =>  '
                                || lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId
                                                               FROM MovementLinkObject AS MLO
                                                               WHERE MLO.MovementId = inMovementId
                                                                 AND MLO.DescId = zc_MovementLinkObject_To()
                                                             ))
                                  ;
         END IF;
     END IF;
     END IF;

     -- ����� ��� �� <��� ��������>, � ������ ������������:
     IF NOT (-- 1.1. ����� ���� �� -> ����� ���� �� (����)
             (EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_From()
                        -- ����� ���� ��
                        AND MLO.ObjectId = 8458
                     )
          AND EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_To()
                        -- ����� ���� �� (����)
                        AND MLO.ObjectId = 8020714
                     )
             )
          -- 1.2. ����� ���� �� (����) -> ����� ���� ��
          OR (EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_To()
                        -- ����� ���� ��
                        AND MLO.ObjectId = 8458
                     )
          AND EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_From()
                        -- ����� ���� �� (����)
                        AND MLO.ObjectId = 8020714
                     )
             )

          -- 2.1. ��� �������� -> ...
          --               ... ->  ��� ��������
          OR EXISTS (SELECT 1
                     FROM MovementLinkObject AS MLO
                     WHERE MLO.MovementId = inMovementId
                       AND MLO.DescId IN (zc_MovementLinkObject_From(), zc_MovementLinkObject_To())
                       -- ��� ��������
                       AND MLO.ObjectId = 8451
                    )

             -- 3.1. ����� ���� �� -> ����������� ��������
          OR (EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_From()
                        -- ����� ���� ��
                        AND MLO.ObjectId = 8458
                     )
          AND EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_To()
                        -- ����������� ��������
                        AND MLO.ObjectId = 8459 
                     )
             )
          -- 3.2. ��� �������� -> ����������� ��������
          OR (EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_From()
                        -- ��� ��������
                        AND MLO.ObjectId = 8451
                     )
          AND EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_To()
                        -- ����������� ��������
                        AND MLO.ObjectId = 8459 
                     )
             )
            )

          -- 0. ����������� �������� -> ��� ��������
          OR (EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_From()
                        -- ����������� ��������
                        AND MLO.ObjectId = 8459 
                     )
          AND EXISTS (SELECT 1
                      FROM MovementLinkObject AS MLO
                      WHERE MLO.MovementId = inMovementId
                        AND MLO.DescId = zc_MovementLinkObject_To()
                        -- ��� ��������
                        AND MLO.ObjectId = 8451
                     )
             )
     THEN

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
            -- ���� ������ � ��� ������ ��� � ����������� ��� ������ - ����� �������
            AND NOT EXISTS (SELECT 1
                            FROM ObjectBoolean AS ObjectBoolean_Order
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                       ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId      = ObjectBoolean_Order.ObjectId
                                                      AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                                      AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                                 LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                      ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectBoolean_Order.ObjectId
                                                     AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                            WHERE ObjectBoolean_Order.ValueData = TRUE
                              AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                              AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId,0)
                           )

                  AND EXISTS (SELECT 1 FROM ObjectLink AS OL
                                       WHERE OL.ObjectId = inGoodsId
                                         AND OL.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                         AND OL.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- ������� ���������
                                                              --, zc_Enum_InfoMoney_30102() -- �������
                                                                , zc_Enum_InfoMoney_20901() -- ����
                                                                 )
                             )
             THEN
                 /*RAISE EXCEPTION '������.%� ������ <%> <%>%�� ����������� �������� <������������ � �������>=��.% % � % �� % % %'
                                , CHR (13)
                                , lfGet_Object_ValueData (inGoodsId)
                                , lfGet_Object_ValueData_sh (inGoodsKindId)
                                , CHR (13)
                                , CHR (13)
                                , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Send())
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

     END IF;


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- ������ ����������� �����: ���� ����������� ����� �� ���������� � ��� ����������� �� ��
     IF (vbIsInsert = TRUE OR COALESCE (ioPartionGoods, '') = '' OR COALESCE (ioPartionGoods, '0') = '0')
        AND EXISTS (SELECT MovementLinkObject_From.ObjectId
                    FROM MovementLinkObject AS MovementLinkObject_From
                         INNER JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                                         AND Object_From.DescId = zc_Object_Unit()
                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = MovementLinkObject_From.MovementId
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         INNER JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                                                       AND Object_To.DescId = zc_Object_Member()
                    WHERE MovementLinkObject_From.MovementId = inMovementId
                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From())
        -- ���� + ����������
        AND (NOT EXISTS (SELECT 1 FROM ObjectLink AS OL
                         WHERE OL.ObjectId = inGoodsId AND OL.DescId = zc_ObjectLink_Goods_InfoMoney()
                           AND OL.ChildObjectId IN (zc_Enum_InfoMoney_20103(), zc_Enum_InfoMoney_20202()))
          OR COALESCE(ioPartionGoods, '') = ''
            )
     THEN
         ioPartionGoods:= lfGet_Object_PartionGoods_InvNumber (inGoodsId);
     ELSE
         -- ������� ����������� �����: ���� ��� ����������� � �� �� ��
         IF EXISTS (SELECT MovementLinkObject_From.ObjectId
                    FROM MovementLinkObject AS MovementLinkObject_From
                         INNER JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                                         AND Object_From.DescId = zc_Object_Member()
                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = MovementLinkObject_From.MovementId
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         INNER JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                                                           AND Object_To.DescId = zc_Object_Member()
                    WHERE MovementLinkObject_From.MovementId = inMovementId
                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From())
        -- ���� + ����������
        AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inGoodsId AND OL.DescId = zc_ObjectLink_Goods_InfoMoney() AND OL.ChildObjectId IN (zc_Enum_InfoMoney_20103(), zc_Enum_InfoMoney_20202()))
        AND inPartionGoodsId > 0
         THEN
             ioPartionGoods:= (SELECT ValueData FROM Object WHERE Id = inPartionGoodsId);
         END IF;
     END IF;


     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <���������� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCount);
     -- ��������� �������� <���������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     
     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- ��������� ����� � <���� ������� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

     -- ��������� ����� � <��������� �� ������������ 1>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);
     -- ��������� ����� � <��������� �� ������������ 2>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset_two(), ioId, inAssetId_two);

     -- ��������� ����� � <������������� (��� ��)> - ������ �� ����
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     
     -- ��������� �������� <���� ������>
     IF COALESCE (inPartionGoodsDate, zc_DateStart()) <> zc_DateStart() OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = ioId AND MID.DescId = zc_MIDate_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate); 
     END IF;

     -- ��������� �������� <������ ������> 
     IF ioPartionGoods <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_PartionGoods())
     THEN
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, ioPartionGoods);
     END IF; 

     -- ��������� �������� <������> 
     IF COALESCE (inPartionModelId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_PartionModel())
     THEN
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionModel(), ioId, inPartionModelId);
     END IF;
   
     -- ��������� �������� <� �� ��� ��������>
     --PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, ioPartNumber);

     -- ��������� �������� <� �� ��� ��������>
     IF ioPartNumber <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_PartNumber())
     THEN
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, ioPartNumber);
     END IF;
   
     -- ��������� ����� � <����� ��������> - ��� ������ ������� �� �� 
     IF COALESCE (inStorageId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_Storage())
     THEN
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
     END IF;

     -- ��������� ����� � <������ ������� (��� ������ ������� ���� � ��)> - ���� �� ����
     IF COALESCE (inPartionGoodsId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionGoods(), ioId, inPartionGoodsId);
     END IF;


     IF inGoodsId <> 0 AND inGoodsKindId <> 0
     THEN
         -- ������� ������ <����� ������ � ���� �������>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     -- !!! ������� ����.!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.05.23         * inPartNumber
 18.10.22         * inAssetId_two
 03.10.22         * Asset
 02.08.17         * add inGoodsKindCompleteId
 29.05.15                                        * set lp
 26.07.14                                        * add inPartionGoodsDate and inUnitId and inStorageId and inPartionGoodsId and ioPartionGoods
 23.05.14                                                       *
 18.07.13         * add inAssetId
 16.07.13                                        * del params by SendOnPrice
 12.07.13         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Send (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
