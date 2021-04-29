-- Function: lpInsertUpdate_MovementItem_ReturnIn()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnIn(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
 INOUT ioPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inMovementId_Partion  Integer   , -- Id ��������� �������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
 INOUT ioMovementId_Promo    Integer   ,
 INOUT ioChangePercent       TFloat    , -- (-)% ������ (+)% �������
   OUT outPricePromo         TFloat    ,
    IN inIsCheckPrice        Boolean   , -- 
    IN inUserId              Integer     -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.����� �� ���������.';
     END IF;


     -- ��������� ����� - �� "���� ��������� � �����������"
     SELECT tmp.MovementId
          , CASE WHEN tmp.isChangePercent = TRUE
                      THEN COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0)
                 ELSE 0
            END
          , ioPrice
            INTO ioMovementId_Promo, ioChangePercent, outPricePromo
     FROM lpGet_Movement_Promo_Data_all (inOperDate     := (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDatePartner())
                                       , inPartnerId    := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                       , inContractId   := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                       , inUnitId       := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                       , inGoodsId      := inGoodsId
                                       , inGoodsKindId  := inGoodsKindId
                                       , inIsReturn     := TRUE
                                        ) AS tmp
     -- !!!������ ���� ������������� ����!!!
     WHERE ioPrice = CASE WHEN TRUE = (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT())
                               THEN tmp.PriceWithVAT
                          WHEN 1=1
                               THEN tmp.PriceWithOutVAT
                          ELSE 0 -- ???����� ���� ����� ����� �� ������ ����� ���� ����� ��� ����� ������� ��� ��� �����???
                     END
    ;
     -- !!!� ���� ������ - ������ �� ���������!!!
     IF zc_isReturnInNAL_bySale() > (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
        OR COALESCE (ioMovementId_Promo, 0) = 0
     THEN ioChangePercent:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0); END IF;
     

     -- 
   /*IF COALESCE (ioMovementId_Promo, 0) = 0 AND inIsCheckPrice = TRUE
     THEN
          -- !!!������!!!
          ioPrice:= lpGet_ObjectHistory_Price_check (inMovementId            := inMovementId
                                                   , inMovementItemId        := ioId
                                                   , inContractId            := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                   , inPartnerId             := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                   , inMovementDescId        := zc_Movement_ReturnIn()
                                                   , inOperDate_order        := NULL
                                                   , inOperDatePartner       := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner()) 
                                                   , inDayPrior_PriceReturn  := 14
                                                   , inIsPrior               := FALSE -- !!!���������� �� ������ ���!!!
                                                   , inOperDatePartner_order := NULL
                                                   , inGoodsId               := inGoodsId
                                                   , inGoodsKindId           := inGoodsKindId
                                                   , inPrice                 := ioPrice
                                                   , inCountForPrice         := 1
                                                   , inUserId                := inUserId
                                                    );
     END IF;*/


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <���������� � �����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, ioPrice);
     -- ��������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- ��������� �������� <���������� �����>
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);

     -- ��������� �������� <id ��������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_Partion);



     -- !!!������ ����� ����� - ��� � ��������� � ��������!!!
     -- ��������� �������� <(-)% ������ (+)% �������> 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, ioChangePercent);
     -- ��������� �������� <MovementId-�����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), ioId, COALESCE (ioMovementId_Promo, 0));



     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- ��������� ����� � <�������� �������� (��� ������� ���������� ���)>
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     /*IF inGoodsId <> 0
     THEN
         -- ������� ������ <����� ������ � ���� �������>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;*/

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmountPartner * ioPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmountPartner * ioPrice AS NUMERIC (16, 2))
                      END;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     IF 1 = 1 -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- ��������� ��������
         PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 27.04.15         * add inMovementId
 11.05.14                                        * change ioCountForPrice
 07.05.14                                        * add lpInsert_MovementItemProtocol
 08.04.14                                        * rem ������� ������ <����� ������ � ���� �������>
 14.02.14                                                         * add ioCountForPrice
 13.02.14                         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_ReturnIn (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, ioPrice:= 1, ioCountForPrice:= 1, outAmountSumm:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
