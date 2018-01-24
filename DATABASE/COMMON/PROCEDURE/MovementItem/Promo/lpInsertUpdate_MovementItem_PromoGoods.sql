-- Function: lpInsertUpdate_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoGoods(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inAmount                TFloat    , -- % ������ �� �����
    IN inPrice                 TFloat    , --���� � ������
    IN inPriceSale             TFloat    , --���� �� �����
    IN inPriceWithOutVAT       TFloat    , --���� �������� ��� ����� ���, � ������ ������, ���
    IN inPriceWithVAT          TFloat    , --���� �������� � ������ ���, � ������ ������, ���
    IN inPriceTender           TFloat    , --���� ������ ��� ����� ���, � ������ ������, ���
    IN inAmountReal            TFloat    , --����� ������ � ����������� ������, ��
    IN inAmountPlanMin         TFloat    , --������� ������������ ������ ������ �� ��������� ������ (� ��)
    IN inAmountPlanMax         TFloat    , --�������� ������������ ������ ������ �� ��������� ������ (� ��)
    IN inGoodsKindId           Integer   , --�� ������� <��� ������>
    IN inGoodsKindCompleteId   Integer   , --�� ������� <��� ������ (����������)>
    IN inComment               TVarChar  , --�����������
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ���������
    IF inGoodsKindId <> 0
    THEN
        RAISE EXCEPTION '������. ���������� ��������� ������� ��� (����������), � �������� ��� ������ = <%> ������ ���� ������.', lfGet_Object_ValueData (inGoodsKindId);
    END IF;


    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL, inUserId);
    
    -- ��������� <���� � ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, COALESCE(inPrice,0));
    
    -- ��������� <���� �� �����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, COALESCE(inPriceSale,0));
    
    -- ��������� <���� �������� ��� ����� ���, � ������ ������, ���>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithOutVAT(), ioId, COALESCE(inPriceWithOutVAT,0));
    
    -- ��������� <���� �������� � ������ ���, � ������ ������, ���>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(), ioId, COALESCE(inPriceWithVAT,0));
    
    -- ��������� <���� ������ ��� ����� ���, � ������ ������, ���>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTender(), ioId, COALESCE(inPriceTender,0));
        
    -- !!������ ����� ������!!! ��������� <����� ������ � ����������� ������, ��>
    -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReal(), ioId, COALESCE(inAmountReal,0));
    
    -- ��������� <������� ������������ ������ ������ �� ��������� ������ (� ��)>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMin(), ioId, COALESCE(inAmountPlanMin,0));
    
    -- ��������� <�������� ������������ ������ ������ �� ��������� ������ (� ��)>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMax(), ioId, COALESCE(inAmountPlanMax,0));
    
    -- ��������� ����� � <��� ������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
    -- ��������� ����� � <��� ������ (����������)>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

    -- ��������� <�����������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
    
    -- ��������� ��������
    IF inUserId > 0 THEN 
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 24.01.18         * inPriceTender
 28.11.17         * inGoodsKindCompleteId
 13.10.15                                                                       *
 */