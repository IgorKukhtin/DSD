-- Function: gpInsertUpdate_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

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
    IN inGoodsKindId         Integer    , --�� ������� <��� ������>
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceList Integer;
   DECLARE vbPriceWithWAT Boolean;
   DECLARE vbVAT TFloat;
   
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
                  MI_PromoGoods.Id <> COALESCE(ioId,0))
    THEN
        RAISE EXCEPTION '������. � ��������� ��� ������� ������ �� ��������� ����� <%> � ��� ������ <%>.', (SELECT ValueData FROM Object WHERE id = inGoodsId),(SELECT ValueData FROM Object WHERE id = inGoodsKindId);
    END IF;
    
    --������ ���������
    SELECT
        COALESCE(Movement_Promo.PriceListId,zc_PriceList_Basis())
    INTO
        vbPriceList
    FROM
        Movement_Promo_View AS Movement_Promo
    WHERE
        Movement_Promo.Id = inMovementId;
    --�������� �������� "� ���" � "�������� ���"
    SELECT
        PriceList.PriceWithVAT
       ,PriceList.VATPercent
    INTO
        vbPriceWithWAT
       ,vbVAT
    FROM
        gpGet_Object_PriceList(vbPriceList,inSession) as PriceList;
    
    --����� ���� �� �������� ������
    IF COALESCE(ioPrice,0) = 0
    THEN
        SELECT 
            Price.ValuePrice
        INTO
            ioPrice
        FROM 
            lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceList, 
                                                  inOperDate   := (SELECT OperDate FROM Movement WHERE Id = inMovementId)) AS Price
        WHERE
            Price.GoodsId = inGoodsId;
    
         --���� ���������� - �������� ���� � ���� � ���
        IF vbPriceWithWAT = TRUE
        THEN
            ioPrice := ROUND(ioPrice/(vbVAT/100.0+1),2);
        END IF;
    END IF;
    
    --��������� <���� �������� ��� ����� ���, � ������ ������, ���>
    outPriceWithOutVAT := ROUND(ioPrice - COALESCE(ioPrice * inAmount/100.0),2);
    
    --��������� <���� �������� � ������ ���, � ������ ������, ���>
    outPriceWithVAT := ROUND(outPriceWithOutVAT * ((vbVAT/100.0)+1),2);
    
    
    -- ���������
    ioId := lpInsertUpdate_MovementItem_PromoGoods (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inPrice              := ioPrice
                                            , inPriceWithOutVAT    := outPriceWithOutVAT
                                            , inPriceWithVAT       := outPriceWithVAT
                                            , inAmountReal         := inAmountReal
                                            , inAmountPlanMin      := inAmountPlanMin
                                            , inAmountPlanMax      := inAmountPlanMax
                                            , inGoodsKindId        := inGoodsKindId
                                            , inUserId             := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 13.10.15                                                                         *
*/