-- Function: gpInsertUpdate_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoGoods(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- % ������ �� �����
 INOUT ioPrice               TFloat    , --���� � ������
   OUT outPriceWithOutVAT    TFloat    , --���� �������� ��� ����� ���, � ������ ������, ���
   OUT outPriceWithVAT       TFloat    , --���� �������� � ������ ���, � ������ ������, ���
    IN inAmountReal          TFloat    , --����� ������ � ����������� ������, ��
    IN inAmountPlanMin       TFloat    , --������� ������������ ������ ������ �� ��������� ������ (� ��)
    IN inAmountPlanMax       TFloat    , --�������� ������������ ������ ������ �� ��������� ������ (� ��)
    IN inGoodsKindId         TFloat    , --�� ������� <��� ������>
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoGoods());
    vbUserId := inSession;
    --��������� ������������ �����/��� ������
    IF EXISTS(SELECT 1 
              FROM
                  MovementItem_PromoGoods_View AS MI_PromoGoods
              WHERE
                  MI_PromoGoods.MovementId = inMovementId
                  AND
                  MI_PromoGoods.GoodsId = inGoodsId
                  AND
                  COALESCE(MI_PromoGoods.GoodsKindId,0) = COALESCE(inGoodsKindId,0)
                  AND
                  MI_PromoGoods.Id = COALESCE(ioId,0))
    THEN
        RAISE EXCEPTION '������. � ��������� ��� ������� ������ �� ��������� ����� <%> � ��� ������ <%>.', (SELECT ValueData FROM Object WHERE id = inGoodsId),(SELECT ValueData FROM Object WHERE id = inGoodsKindId);
    END IF;
    -- ���������
    ioId := lpInsertUpdate_MovementItem_PromoGoods (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inPrice              := inPrice
                                            , inPriceWithOutVAT    := inPriceWithOutVAT
                                            , inPriceWithVAT       := inPriceWithVAT
                                            , inAmountReal         := inAmountReal
                                            , inAmountPlanMin      := inAmountPlanMin
                                            , inAmountPlanMax      := inAmountPlanMax
                                            , inGoodsKindId        := inGoodsKindId
                                            , inUserId             := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 13.10.15                                                                         *
*/