-- Function: gpInsertUpdate_MI_PromoTrade_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PromoTrade_Load (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PromoTrade_Load(
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inGoodsCode              Integer   , --
    IN inGoodsName              TVarChar  ,              
    IN inGoodsKindName          TVarChar  ,
    IN inPartnerName            TVarChar  ,
    IN inAmount                 TFloat    , 
    IN inSumm                   TFloat    ,
    IN inPartnerCount           TFloat    ,
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbPartnerId   Integer;
   DECLARE vbMIId        Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());

     --������� ������
     vbGoodsId        := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods());
     -- ������� ��� ������
     vbGoodsKindId    := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind());
     -- ������� ����������� (���� ����)
     IF COALESCE (inPartnerName,'') <> ''
     THEN
         vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inPartnerName) AND Object.DescId = zc_Object_Partner());
     
         IF COALESCE (vbPartnerId,0) = 0
         THEN
             RAISE EXCEPTION '������.���������� <%> �� ������.',inPartnerName;
         END IF;
     
     END IF;

     IF COALESCE (vbGoodsId,0) = 0
     THEN
         RAISE EXCEPTION '������.����� (<%>) <%> �� ������.',inGoodsCode, inGoodsName;
     END IF;

     IF (COALESCE (vbGoodsKindId,0) = 0 AND COALESCE (inGoodsKindName,'') <> '' )
     THEN
         RAISE EXCEPTION '������.��� ������ <%> �� ������.', inGoodsKindName;
     END IF;
 
     --������� ����� ������ ��� ����������
     vbMIId := (SELECT MovementItem.Id 
                FROM MovementItem 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                      ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId = zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                   AND MovementItem.ObjectId = vbGoodsId 
                   AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = COALESCE(vbGoodsKindId,0)  
                   AND (COALESCE (MILinkObject_Partner.ObjectId,0) = COALESCE (vbPartnerId,0))
                );

     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem_PromoTradeGoods (ioId                   := COALESCE (vbMIId,0) ::Integer
                                                        , inMovementId           := inMovementId ::Integer
                                                        , inPartnerId            := vbPartnerId  ::Integer
                                                        , inGoodsId              := vbGoodsId    ::Integer
                                                        , inAmount               := inAmount     ::TFloat
                                                        , inSumm                 := inSumm       ::TFloat
                                                        , inPartnerCount         := inPartnerCount ::TFloat
                                                        , inGoodsKindId          := vbGoodsKindId  ::Integer
                                                        , inTradeMarkId          := 0  ::Integer
                                                        , inGoodsGroupPropertyId := 0  ::Integer
                                                        , inGoodsGroupDirectionId:= 0  ::Integer
                                                        , inComment              := '' ::TVarChar
                                                        , inUserId               := vbUserId
                                                         ) ;
                                              
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.09.24        *
*/

-- ����
-- select * from gpInsertUpdate_MI_PromoTrade_Load(inMovementId := 18002434 ,  inSession := '5');