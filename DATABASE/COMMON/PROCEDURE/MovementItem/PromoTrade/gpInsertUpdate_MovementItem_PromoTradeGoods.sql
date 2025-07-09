-- Function: gpInsertUpdate_MovementItem_PromoTradeGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoTradeGoods(
 INOUT ioId                             Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                     Integer   , -- ���� ������� <��������>
    IN inPartnerId                      Integer   , --
    IN inGoodsId                        Integer   , -- ������
    IN inAmount                         TFloat    , --
    IN inSumm                           TFloat    , -- C��� ���
    IN inPartnerCount                   TFloat    , --
    IN inAmountPlan                     TFloat    , -- 
    IN inPriceWithVAT_pr                TFloat    , -- ���� ����� � ���
    IN inPriceWithOutVAT_pr             TFloat    , -- ���� ����� ��� ���
    IN inPriceWithVAT                   TFloat    , -- ���� ����� � ������� �� ���������
    IN inPriceWithVAT_new               TFloat    , -- ���� ����� � ����� ������� ��  PromoTradeCondition 
  -- OUT outPriceWithOutVAT               TFloat    ,
  -- OUT outSummWithOutVATPlan            TFloat    ,
  -- OUT outSummWithVATPlan               TFloat    ,
    IN inPromoTax                       TFloat    , --
    IN inChangePercent                  TFloat    , --
    IN inPricePromo                     TFloat    , --
    IN inPricePromo_new                 TFloat    , --
    IN inGoodsKindId                    Integer   , -- �� ������� <��� ������>
    IN inTradeMarkId                    Integer   ,  --�������� �����
    IN inGoodsGroupPropertyId           Integer,
    IN inGoodsGroupPropertyId_Parent    Integer,
    IN inGoodsGroupDirectionId          Integer,
   OUT outTradeMarkName                 TVarChar,
   OUT outGoodsGroupPropertyName        TVarChar,
   OUT outGoodsGroupPropertyName_Parent TVarChar,
   OUT outGoodsGroupDirectionName       TVarChar,
    IN inComment                        TVarChar  , -- �����������
    IN inSession                        TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceList Integer;
           vbChangePercent TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoTrade());


    -- �������� - ���� ���� �������, �������������� ������
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inMovementId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

    -- ��������� ������������ �����/��� ������
    IF EXISTS (SELECT 1
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                     ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MILinkObject_Partner.ObjectId
               WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.ObjectId = inGoodsId
                   AND MovementItem.IsErased = FALSE
                   AND MovementItem.DescId = zc_MI_Master()
                   AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
                   AND COALESCE (MILinkObject_Partner.ObjectId,0) = COALESCE (inPartnerId,0)
                   AND MovementItem.Id <> ioId
               )
    THEN
        RAISE EXCEPTION '������. � ��������� ��� ���� ����� = <%> � ��� = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
    END IF;

    -- ��������������  ���� inGoodsGroupPropertyId ��������� ����� ��� , ���� ��� �� ������
    inGoodsGroupPropertyId := CASE WHEN COALESCE (inGoodsGroupPropertyId,0) <> 0 THEN inGoodsGroupPropertyId ELSE inGoodsGroupPropertyId_Parent END;

    --c���������� �������� ������
    vbChangePercent := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_ChangePercent());
    
    --���� �������� ����. ������ ������������� �������� ��� inPricePromo � inPricePromo_new   
    IF COALESCE (vbChangePercent,0) <> COALESCE (inChangePercent,0)
    THEN
        inPricePromo := CAST ( CASE WHEN COALESCE (inChangePercent,0) <> 0 THEN (inPriceWithVAT - inPriceWithVAT * inChangePercent / 100) ELSE inPriceWithVAT END AS NUMERIC (16,4)); 
        inPricePromo_new := CAST ( CASE WHEN COALESCE (inChangePercent,0) <> 0 THEN (inPriceWithVAT_new - inPriceWithVAT_new * inChangePercent / 100) ELSE inPriceWithVAT_new END AS NUMERIC (16,4));
    END IF;


    -- ���������
    SELECT tmp.ioId--, tmp.outPriceWithOutVAT
           INTO ioId--, outPriceWithOutVAT
    FROM lpInsertUpdate_MovementItem_PromoTradeGoods (ioId                   := ioId
                                                    , inMovementId           := inMovementId
                                                    , inPartnerId            := inPartnerId
                                                    , inGoodsId              := inGoodsId
                                                    , inAmount               := inAmount
                                                    , inSumm                 := inSumm
                                                    , inPartnerCount         := inPartnerCount
                                                    , inAmountPlan           := inAmountPlan
                                                    , inPriceWithVAT         := inPriceWithVAT_pr  --���� ����� - � ������� ������ ��� �� ��������
                                                    , inPriceWithOutVAT      := inPriceWithOutVAT_pr  --���� ����� - � ������� ������ ��� �� ��������
                                                    , inPromoTax             := inPromoTax
                                                    , inChangePercent        := inChangePercent
                                                    , inPricePromo           := inPricePromo
                                                    , inPricePromo_new       := inPricePromo_new                                                    
                                                    , inGoodsKindId          := inGoodsKindId
                                                    , inTradeMarkId          := inTradeMarkId
                                                    , inGoodsGroupPropertyId := inGoodsGroupPropertyId
                                                    , inGoodsGroupDirectionId:= inGoodsGroupDirectionId
                                                    , inComment              := inComment
                                                    , inUserId               := vbUserId
                                                     ) AS tmp;


    SELECT Object_TradeMark.ValueData                AS TradeMark
         , Object_GoodsGroupProperty.ValueData       AS GoodsGroupPropertyName
         , Object_GoodsGroupPropertyParent.ValueData AS GoodsGroupPropertyName_Parent
         , Object_GoodsGroupDirection.ValueData      AS GoodsGroupDirectionName
   INTO outTradeMarkName, outGoodsGroupPropertyName, outGoodsGroupPropertyName_Parent, outGoodsGroupDirectionName
    FROM MovementItem
             LEFT JOIN MovementItemLinkObject AS MILinkObject_TradeMark
                                              ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                                             AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = COALESCE (MILinkObject_TradeMark.ObjectId, ObjectLink_Goods_TradeMark.ChildObjectId)
             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupProperty
                                              ON MILinkObject_GoodsGroupProperty.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupProperty.DescId = zc_MILinkObject_GoodsGroupProperty()
                                             AND COALESCE (MovementItem.ObjectId,0) = 0

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                  ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
             LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                  ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                 AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
             LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = COALESCE (ObjectLink_GoodsGroupProperty_Parent.ChildObjectId, MILinkObject_GoodsGroupProperty.ObjectId)
             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupDirection
                                              ON MILinkObject_GoodsGroupDirection.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupDirection.DescId = zc_MILinkObject_GoodsGroupDirection()
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                  ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
             LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = COALESCE (MILinkObject_GoodsGroupDirection.ObjectId, ObjectLink_Goods_GoodsGroupDirection.ChildObjectId)

    WHERE MovementItem.Id = ioId;

     -- ���� �� ���������, ���� ��������� ���������
     IF NOT EXISTS (SELECT 1 FROM MovementItem AS MI JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Message() AND MI.isErased = FALSE)
     THEN
         -- ��������� <� ������ ����� ���������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoTradeStateKind(), inMovementId, zc_Enum_PromoTradeStateKind_Start());
         -- ��������� <� ������ ����� ���������>
         PERFORM gpInsertUpdate_MI_Message_PromoTradeStateKind (ioId                    := 0
                                                              , inMovementId            := inMovementId
                                                              , inPromoTradeStateKindId := zc_Enum_PromoTradeStateKind_Start()
                                                              , inIsQuickly             := FALSE
                                                              , inComment               := ''
                                                              , inSession               := inSession
                                                               );
     END IF;

    /*
    -- ������� ������
    outSummWithOutVATPlan:= (inAmountPlan * outPriceWithOutVAT) ::TFloat;
    outSummWithVATPlan   := (inAmountPlan * inPriceWithVAT)     ::TFloat;
    */
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.09.24         *
*/