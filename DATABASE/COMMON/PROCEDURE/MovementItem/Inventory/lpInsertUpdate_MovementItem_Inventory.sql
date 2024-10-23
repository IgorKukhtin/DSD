-- Function: lpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

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
    IN inPartNumber          TVarChar  , -- � �� ��� �������� 
    IN inPartionGoodsId      Integer   , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inGoodsKindCompleteId Integer   , -- ���� �������  ��
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inUnitId              Integer   , -- ������������� (��� ��)
    IN inStorageId           Integer   , -- ����� �������� 
    IN inPartionModelId      Integer   , -- ������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- !!!�������� - �������������� - ������ �� ��������� (��������� ������ ����������)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 11109744)
        AND inUserId > 0
     THEN
          RAISE EXCEPTION '������.��� ����.';
     END IF;

     -- !!!������ ����� ��������!!!
     IF inUserId < 0 THEN inUserId:= -1 * inUserId; END IF;


      -- !!!�������� inPartionGoodsDate!!!
     IF inPartionGoodsDate IS NOT NULL
     -- ����� ���������� + ����� ���� ��
     AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (8458)) --, zc_Unit_RK()
     -- ��������� �����
     AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382))
     -- !!!tmp
     -- AND inUserId <> 5
      THEN
          RAISE EXCEPTION '������.� ��������� <��������������> � <%> �� <%> ������ ���� ������ ���� ������ <%>.% <%> <%>'
                         , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                         , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                         , zfConvert_DateToString (inPartionGoodsDate)
                         , CHR (13)
                         , lfGet_Object_ValueData_sh (inGoodsId)
                         , lfGet_Object_ValueData_sh (inGoodsKindId)
                          ;
      END IF;

     -- !!!��� - �������� ��� ������� ����!!!
     IF 1=0
     AND inAmount <> 0 -- AND inGoodsKindId <> 0
     -- ����� ���������� + ����� ���� ��
     AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (zc_Unit_RK(), 8458))
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


     -- ��� ������ ����� ���� ��������� ������ ���� ������
     IF 1=1 AND inAssetId < 0 
     -- ����������� ��������
     AND zc_Unit_RK() = (SELECT MLO.ObjectId AS MLO FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
     -- ��������
     AND EXISTS (SELECT 1
                 FROM MovementItem
                      INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                   ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                  AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                  AND MIFloat_PartionCell.ValueData      = -1 * inAssetId :: TFloat
                      LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                       ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                      LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                 ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                   AND MovementItem.Id         <> COALESCE (ioId, 0)
                   -- ���� ������ ������ ��� ����� � ���� ������
                   AND (MovementItem.ObjectId <> inGoodsId
                     OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                     OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (inPartionGoodsDate, zc_DateStart())
                       )
                )
      THEN
          RAISE EXCEPTION '������.� ��������� <��������������> � <%> �� <%> %��� ������ <%> %����� ���� ��������� ������ ������% <%> %� ����� <%>.'
                         , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                         , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                        , CHR (13)
                        , lfGet_Object_ValueData (-1 * inAssetId)
                        , CHR (13)
                        , CHR (13)
                        , (SELECT DISTINCT lfGet_Object_ValueData (MovementItem.ObjectId) || '> <' || lfGet_Object_ValueData_sh (MILO_GoodsKind.ObjectId)
                           FROM MovementItem
                                INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                             ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                            AND MIFloat_PartionCell.ValueData      = -1 * inAssetId :: TFloat
                                LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                 ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
          
                                LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                           ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                          AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                             AND MovementItem.Id         <> COALESCE (ioId, 0)
                             -- ���� ������ ������ ��� ����� � ���� ������
                             AND (MovementItem.ObjectId <> inGoodsId
                               OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                               OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (inPartionGoodsDate, zc_DateStart())
                                 )
                          )
                        , CHR (13)
                        , (SELECT DISTINCT zfConvert_DateToString (MID_PartionGoodsDate.ValueData)
                           FROM MovementItem
                                INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                             ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                            AND MIFloat_PartionCell.ValueData      = -1 * inAssetId :: TFloat
                                LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                 ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
          
                                LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                           ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                          AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                             AND MovementItem.Id         <> COALESCE (ioId, 0)
                             -- ���� ������ ������ ��� ����� � ���� ������
                             AND (MovementItem.ObjectId <> inGoodsId
                               OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                               OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (inPartionGoodsDate, zc_DateStart())
                                 )
                          )
                         ;
      END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <���������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     -- ��������� �������� <���������� ������� ��� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);

     -- ��������� �������� <ContainerId>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, 0);

     -- ��������� �������� <ContainerId>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), ioId, TRUE);

     -- ��������� ����� � <������ �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionGoods(), ioId, inPartionGoodsId);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- ��������� ����� � <���� ������� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);


     -- ���� ��� ������ �������� - ������ ��� ����������� ��������
     IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (zc_Unit_RK()))
        -- ��� ���������� �� Scale
        AND inAssetId < 0
     THEN
         -- ��������� ����� � <������ ��������>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell(), ioId, -1 * inAssetId :: TFloat);
     ELSE
         -- ��������� ����� � <�������� �������� (��� ������� ���������� ���)>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);
     END IF;


     IF COALESCE (inPartionGoodsId, 0) = 0
     THEN
         -- ��������� �������� <����>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
         -- ��������� �������� <�����>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);
         -- ��������� �������� <���� ������/���� �����������>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
         -- ��������� �������� <������ ������/����������� �����>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
         
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
         
         -- ��������� ����� � <������������� (��� ��)>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

         -- ��������� �������� <� �� ��� ��������>
         IF inPartNumber <> '' OR EXISTS (SELECT 1 FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_PartNumber())
         THEN
             PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);
         END IF;
     END IF;



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
 19.12.18         * inPartionGoodsId
 26.07.14                                        * add inPrice and inUnitId and inStorageId
 21.08.13                                        * add inGoodsKindId
 18.07.13         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Inventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inPartionGoodsId:=0, inGoodsKindId:= 0, inSession:= '2')
