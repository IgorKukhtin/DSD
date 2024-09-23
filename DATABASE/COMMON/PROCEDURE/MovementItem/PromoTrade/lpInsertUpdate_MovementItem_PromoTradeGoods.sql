-- Function: lpInsertUpdate_MovementItem_PromoTradeGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoTradeGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoTradeGoods(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>   
    IN inPartnerId             Integer   ,
    IN inGoodsId               Integer   , -- ������
    IN inAmount                TFloat    , -- 
    IN inSumm                  TFloat    , --
    IN inPartnerCount          TFloat    , -- ���� �� �����
    IN inAmountPlan            TFloat    , --
    IN inPriceWithVAT          TFloat    , --   
   OUT outPriceWithOutVAT      TFloat    ,
    IN inGoodsKindId           Integer   , --�� ������� <��� ������>
    IN inTradeMarkId           Integer   , --�������� ����� 
    IN inGoodsGroupPropertyId  Integer,
    IN inGoodsGroupDirectionId Integer,
    IN inComment               TVarChar  , --�����������
    IN inUserId                Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;  
   DECLARE vbIsUpdate_general Boolean;
   DECLARE vbVat TFloat;
BEGIN
 
    -- ������� - ��������� "������" ����������
    vbIsUpdate_general:= inGoodsId <> COALESCE ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = ioId), 0)
                      OR inSumm    <> COALESCE ((SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.MovementItemId = ioId AND MF.DescId = zc_MIFloat_Summ()), 0)
                        ;

    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL, inUserId);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartnerCount(), ioId, inPartnerCount);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlan(), ioId, inAmountPlan);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(), ioId, inPriceWithVAT);
    
   --��� �� ������ �������� 
    vbVat := COALESCE( (SELECT ObjectFloat_VATPercent.ValueData
                        FROM MovementLinkObject AS MLO
                             LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                                   ON ObjectFloat_VATPercent.ObjectId = MLO.ObjectId
                                                  AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
                        WHERE MLO.DescId = zc_MovementLinkObject_PriceList()
                          AND MLO.MovementId = inMovementId)
                      , 20)::TFloat;
    outPriceWithOutVAT:= ROUND ((inPriceWithVAT - inPriceWithVAT * (vbVAT / (vbVAT + 100))) , 2)::TFloat ; 
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithOutVAT(), ioId, outPriceWithOutVAT);     
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TradeMark(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inTradeMarkId ELSE NULL END ::Integer);
    -- ��������� ����� � <��� ������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
  
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TradeMark(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inTradeMarkId ELSE NULL END ::Integer);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsGroupProperty(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inGoodsGroupPropertyId ELSE NULL END ::Integer);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsGroupDirection(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inGoodsGroupDirectionId ELSE NULL END ::Integer);
    
    -- ��������� <�����������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

    -- ��������� ��������
    IF inUserId > 0 THEN 
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
    ELSE
      PERFORM lpInsert_MovementItemProtocol (ioId, zc_Enum_Process_Auto_ReComplete(), vbIsInsert);
    END IF;


     -- ���� ���� ������������� + ��������� �� zc_Enum_PromoTradeStateKind_Start
     IF vbIsUpdate_general = TRUE
            AND zc_Enum_PromoTradeStateKind_Start() <> (SELECT MI.ObjectId
                                                        FROM MovementItem AS MI
                                                             JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind()
                                                        WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Message() AND MI.isErased = FALSE
                                                        ORDER BY MI.Id DESC
                                                        LIMIT 1
                                                       )
     THEN
         -- ����� ��� �������
         PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Sign()
           AND MovementItem.isErased   = FALSE
          ;

         -- ��������� <� ������ ����� ���������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoTradeStateKind(), inMovementId, zc_Enum_PromoTradeStateKind_Start());
         -- ��������� <� ������ ����� ���������>
         PERFORM gpInsertUpdate_MI_Message_PromoTradeStateKind (ioId                    := 0
                                                              , inMovementId            := inMovementId
                                                              , inPromoTradeStateKindId := zc_Enum_PromoTradeStateKind_Start()
                                                              , inIsQuickly             := FALSE
                                                              , inComment               := ''
                                                              , inSession               := inUserId :: TVarChar
                                                               );

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.09.24         *
 03.09.24         *
 */