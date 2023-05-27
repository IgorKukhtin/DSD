-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
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
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;



     -- ��������
     /*IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 DAY')
    AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId
                                                          AND MLO.ObjectId IN (8459 -- ����� ����������
                                                                             , 8458 -- ����� ���� ��
                                                                               )
                                                          AND MLO.DescId = zc_MovementLinkObject_From()
               )
    AND EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.Amount <> 0
                  AND MovementItem.Id <> COALESCE (ioId, 0)
                  AND MovementItem.ObjectId                         = COALESCE (inGoodsId, 0)
                  AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
               )
     THEN
         RAISE EXCEPTION '������.����� <%> <%> ��� ���������� � ���������.������������ �������������', lfGet_Object_ValueData_sh (inGoodsId), lfGet_Object_ValueData_sh (inGoodsKindId);
         -- select goodsId, goodsKindId, goodsCode, goodsName, goodsKindName from gpSelect_MovementItem_Inventory(inMovementId := 8538761 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '5') where amount <> 0 group by goodsId, goodsKindId, goodsCode, goodsName, goodsKindName having count(*) > 1
     END IF;*/


     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Inventory (ioId                 := ioId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := inGoodsId
                                                 , inAmount             := inAmount
                                                 , inPartionGoodsDate   := inPartionGoodsDate
                                                 , inPrice              := inPrice
                                                 , inSumm               := inSumm
                                                 , inHeadCount          := inHeadCount
                                                 , inCount              := inCount
                                                 , inPartionGoods       := inPartionGoods
                                                 , inPartNumber         := inPartNumber
                                                 , inPartionGoodsId     := inPartionGoodsId
                                                 , inGoodsKindId        := inGoodsKindId
                                                 , inGoodsKindCompleteId:= inGoodsKindCompleteId
                                                 , inAssetId            := inAssetId
                                                 , inUnitId             := inUnitId
                                                 , inStorageId          := inStorageId
                                                 , inPartionModelId     := inPartionModelId
                                                 , inUserId             := vbUserId
                                                  ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.05.23         *
 19.12.18         * add inPartionGoodsId              
 25.04.05         * add lpInsertUpdate_MovementItem_Inventory
 26.07.14                                        * add inPrice and inUnitId and inStorageId
 21.08.13                                        * add inGoodsKindId
 18.07.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inPartionGoodsId:=0 , inGoodsKindId:= 0, inSession:= '2')
