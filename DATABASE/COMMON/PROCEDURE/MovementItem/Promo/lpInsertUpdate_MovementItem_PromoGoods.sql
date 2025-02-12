-- Function: lpInsertUpdate_MovementItem_PromoGoods()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoGoods(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inAmount                TFloat    , -- % ������ �� �����
    IN inPrice                 TFloat    , -- ���� � ������ ������ ������
    IN inOperPriceList         TFloat    , -- ���� � ������
    IN inPriceSale             TFloat    , -- ���� �� �����
    IN inPriceWithOutVAT       TFloat    , -- ���� �������� ��� ����� ���, � ������ ������, ���
    IN inPriceWithVAT          TFloat    , -- ���� �������� � ������ ���, � ������ ������, ���
    IN inPriceTender           TFloat    , -- ���� ������ ��� ����� ���, � ������ ������, ���
    IN inCountForPrice         TFloat    , -- ��������� �� ���� �����
    IN inAmountReal            TFloat    , -- ����� ������ � ����������� ������, ��
    IN inAmountPlanMin         TFloat    , -- ������� ������������ ������ ������ �� ��������� ������ (� ��)
    IN inAmountPlanMax         TFloat    , -- �������� ������������ ������ ������ �� ��������� ������ (� ��)
    IN inTaxRetIn              TFloat    , -- % ��������
    IN inAmountMarket          TFloat    , --���-�� ���� (������ ������)
    IN inSummOutMarket         TFloat    , --����� ���� ������(������ ������)
    IN inSummInMarket          TFloat    , --����� ���� �����(������ ������)
    IN inGoodsKindId           Integer   , --�� ������� <��� ������>
    IN inGoodsKindCompleteId   Integer   , --�� ������� <��� ������ (����������)>
    IN inTradeMarkId                    Integer,  --�������� �����
    IN inGoodsGroupPropertyId           Integer,
    IN inGoodsGroupDirectionId          Integer,
    IN inComment               TVarChar  , --�����������
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ���������
    IF COALESCE (inGoodsKindId, 0) = 0 AND 1=1
       AND 1=0
       AND EXISTS (SELECT 1 FROM ObjectLink AS OL
                               WHERE OL.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- ����
                                                        , zc_Enum_InfoMoney_30101() -- ������� ���������
                                                        , zc_Enum_InfoMoney_30102() -- �������
                                                         )
                              AND OL.DescId = zc_ObjectLink_Goods_InfoMoney()
                              AND OL.ObjectId = inGoodsId
                  )
    THEN
        -- RAISE EXCEPTION '������. ���������� ��������� ������� ��� (����������), � �������� ��� ������ = <%> ������ ���� ������.', lfGet_Object_ValueData (inGoodsKindId);
        RAISE EXCEPTION '������.���������� ��������� ������� ��� ������.';
    END IF;


    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL, inUserId);

    -- ��������� <���� � ������> ��� ����� % ������ (�������)
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, COALESCE(inOperPriceList,0));

    -- ��������� <���� � ������> c ������ % ������ (�������)
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, COALESCE(inPrice,0));

    -- ��������� <���� �� �����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, COALESCE(inPriceSale,0));

    -- ��������� <���� �������� ��� ����� ���, � ������ ������, ���>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithOutVAT(), ioId, COALESCE(inPriceWithOutVAT,0));

    -- ��������� <���� �������� � ������ ���, � ������ ������, ���>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(), ioId, COALESCE(inPriceWithVAT,0));

    -- ��������� <���� ������ ��� ����� ���, � ������ ������, ���>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTender(), ioId, COALESCE(inPriceTender,0));

    -- ��������� <CountForPrice>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

    -- !!������ ����� ������!!! ��������� <����� ������ � ����������� ������, ��>
    -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReal(), ioId, COALESCE(inAmountReal,0));

    -- ��������� <������� ������������ ������ ������ �� ��������� ������ (� ��)>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMin(), ioId, COALESCE(inAmountPlanMin,0));

    -- ��������� <�������� ������������ ������ ������ �� ��������� ������ (� ��)>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMax(), ioId, COALESCE(inAmountPlanMax,0));

    -- ��������� <���-�� ���� (������ ������)>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountMarket(), ioId, inAmountMarket);
    -- ��������� <����� ���� �����(������ ������) >
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummInMarket(), ioId, inSummInMarket);
    -- ��������� <����� ���� ������(������ ������)>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummOutMarket(), ioId, inSummOutMarket);

    -- ��������� ����� � <��� ������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
    -- ��������� ����� � <��� ������ (����������)> - ����� ���� ������
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, CASE WHEN inGoodsKindId > 0 THEN inGoodsKindId ELSE inGoodsKindCompleteId END);

    --���� ����� ������ ��� inGoodsGroupPropertyId, inGoodsGroupDirectionId, inTradeMarkId - ��������� ����. NULL
    --  � ���������� �������� ������

    -- ��������� ����� � <��� ������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TradeMark(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inTradeMarkId ELSE NULL END ::Integer);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsGroupProperty(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inGoodsGroupPropertyId ELSE NULL END ::Integer);
    -- ��������� ����� � <��� ������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsGroupDirection(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inGoodsGroupDirectionId ELSE NULL END ::Integer);

    -- ��������� <�����������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

    -- ��������� % ������� ��� ���� �������
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TaxRetIn(), MovementItem.Id, inTaxRetIn)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.ObjectId = inGoodsId;

    -- ��������� ��������
    IF inUserId > 0 THEN
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
    ELSE
      PERFORM lpInsert_MovementItemProtocol (ioId, zc_Enum_Process_Auto_ReComplete(), vbIsInsert);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 23.08.24         *
 07.08.24         *
 22.10.20         * inTaxRetIn
 14.07.20         * inOperPriceList
 24.01.18         * inPriceTender
 28.11.17         * inGoodsKindCompleteId
 13.10.15                                                                       *
 */
