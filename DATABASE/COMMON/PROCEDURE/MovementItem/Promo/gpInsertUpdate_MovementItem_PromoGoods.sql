-- Function: gpInsertUpdate_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoGoods(
 INOUT ioId                   Integer   , -- ���� ������� <������� ���������>
    IN inMovementId           Integer   , -- ���� ������� <��������>
    IN inGoodsId              Integer   , -- ������
    IN inAmount               TFloat    , -- % ������ �� �����
 INOUT ioPrice                TFloat    , -- ���� � ������
    IN inPriceSale            TFloat    , -- ���� �� �����
   OUT outPriceWithOutVAT     TFloat    , -- ���� �������� ��� ����� ���, � ������ ������, ���
   OUT outPriceWithVAT        TFloat    , -- ���� �������� � ������ ���, � ������ ������, ���
    IN inPriceTender          TFloat    , -- ���� ������ ��� ����� ���, � ������ ������, ���
    IN inAmountReal           TFloat    , -- ����� ������ � ����������� ������, ��
   OUT outAmountRealWeight    TFloat    , -- ����� ������ � ����������� ������, �� ���
    IN inAmountPlanMin        TFloat    , -- ������� ������������ ������ ������ �� ��������� ������ (� ��)
   OUT outAmountPlanMinWeight TFloat    , -- ������� ������������ ������ ������ �� ��������� ������ (� ��) ���
    IN inAmountPlanMax        TFloat    , -- �������� ������������ ������ ������ �� ��������� ������ (� ��)
   OUT outAmountPlanMaxWeight TFloat    , -- �������� ������������ ������ ������ �� ��������� ������ (� ��) ���
    IN inGoodsKindId          Integer   , -- �� ������� <��� ������>
    IN inGoodsKindCompleteId  Integer   , -- �� ������� <��� ������ (����������)>
    IN inComment              TVarChar  , -- �����������
    IN inSession              TVarChar    -- ������ ������������
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
    vbUserId := CASE WHEN inSession = '-12345' THEN inSession :: Integer ELSE lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo()) END;


    -- �������� - ���� ���� �������, �������������� ������
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inMovementId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

    -- ��������� inPriceTender
    IF inPriceTender <> 0 AND EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Promo() AND MB.ValueData = TRUE)
    THEN
        RAISE EXCEPTION '������. �������� <���� ������> �� ����� ���� ������� ��� ��������� � ��������� <�����>.';
    END IF;


    -- ��������� ������������ �����/��� ������
    IF EXISTS (SELECT 1 
               FROM MovementItem_PromoGoods_View AS MI_PromoGoods
               WHERE MI_PromoGoods.MovementId                          = inMovementId
                   AND MI_PromoGoods.GoodsId                           = inGoodsId
                   AND COALESCE (MI_PromoGoods.GoodsKindId, 0)         = COALESCE (inGoodsKindId, 0)
                   AND COALESCE (MI_PromoGoods.GoodsKindCompleteId, 0) = COALESCE (inGoodsKindCompleteId, 0)
                   AND MI_PromoGoods.Id                        <> COALESCE(ioId, 0)
                   AND MI_PromoGoods.isErased                  = FALSE
              )
    THEN
        RAISE EXCEPTION '������. � ��������� ��� ������� ������ ��� ������ = <%> � ��� = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
    END IF;
    
    -- ����� �����-����
    SELECT COALESCE (Movement_Promo.PriceListId, zc_PriceList_Basis())
           INTO vbPriceList
    FROM Movement_Promo_View AS Movement_Promo
    WHERE Movement_Promo.Id = inMovementId;

    -- ��������� ������ �����-���� "� ���" � "�������� ���"
    SELECT PriceList.PriceWithVAT, PriceList.VATPercent
           INTO vbPriceWithWAT, vbVAT
    FROM gpGet_Object_PriceList(vbPriceList,inSession) AS PriceList;
    
    -- ����� ���� �� �������� ������
    IF COALESCE (ioPrice, 0) = 0 OR COALESCE (ioId, 0) = 0
    THEN
         --
         IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('tmpPriceList'))
         THEN
             DELETE FROM tmpPriceList;
         ELSE
             -- ������� -  ���� �� ������
             CREATE TEMP TABLE tmpPriceList (GoodsId Integer, GoodsKindId Integer, ValuePrice TFloat) ON COMMIT DROP;
         END IF;
         --
         INSERT INTO tmpPriceList (GoodsId, GoodsKindId, ValuePrice)
             SELECT lfSelect.GoodsId     AS GoodsId
                  , lfSelect.GoodsKindId AS GoodsKindId
                  , lfSelect.ValuePrice  AS ValuePrice
             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceList, inOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId)) AS lfSelect;

       ioPrice := COALESCE ((SELECT tmpPriceList.ValuePrice FROM tmpPriceList WHERE tmpPriceList.GoodsId = inGoodsId AND tmpPriceList.GoodsKindId = inGoodsKindId)
                          , (SELECT tmpPriceList.ValuePrice FROM tmpPriceList WHERE tmpPriceList.GoodsId = inGoodsId AND tmpPriceList.GoodsKindId IS NULL)
                          ,0);
        
        /*SELECT Price.ValuePrice
               INTO ioPrice
        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceList
                                                 , inOperDate   := (SELECT OperDate FROM Movement WHERE Id = inMovementId)
                                                  ) AS Price
        WHERE Price.GoodsId = inGoodsId;
        */
    
        -- ���� ���������� - �������� ���� � ���� � ���
        IF vbPriceWithWAT = TRUE
        THEN
            ioPrice := ROUND (ioPrice / (vbVAT / 100.0 + 1), 2);
        END IF;
    END IF;
    
    -- ��� ��� �������
    IF inPriceTender > 0
    THEN
        -- ��������� <���� �������� ��� ����� ���, � ������ ������, ���>
        outPriceWithOutVAT := ROUND(inPriceTender, 2);
        -- ��������� <���� �������� � ������ ���, � ������ ������, ���>
        outPriceWithVAT := ROUND (outPriceWithOutVAT * (1 + vbVAT / 100.0) ,2);
    ELSE
        -- ��������� <���� �������� ��� ����� ���, � ������ ������, ���>
        outPriceWithOutVAT := ROUND (ioPrice - COALESCE (ioPrice * inAmount / 100.0), 2);
        -- ��������� <���� �������� � ������ ���, � ������ ������, ���>
        outPriceWithVAT := ROUND (outPriceWithOutVAT * (1 + vbVAT / 100.0), 2);
    END IF;
    
    -- ��������� ������� ����������
    SELECT inAmountPlanMin * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
         , inAmountPlanMax * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
         , inAmountReal    * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
           INTO outAmountPlanMinWeight
              , outAmountPlanMaxWeight
              , outAmountRealWeight
    FROM ObjectLink AS ObjectLink_Goods_Measure
         LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                     ON ObjectFloat_Goods_Weight.ObjectId = ObjectLink_Goods_Measure.ObjectId
                                    AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()
    WHERE ObjectLink_Goods_Measure.ObjectId = inGoodsId
      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure();
    
    
    -- ���������
    ioId := lpInsertUpdate_MovementItem_PromoGoods (ioId                   := ioId
                                                  , inMovementId           := inMovementId
                                                  , inGoodsId              := inGoodsId
                                                  , inAmount               := inAmount
                                                  , inPrice                := ioPrice
                                                  , inPriceSale            := inPriceSale
                                                  , inPriceWithOutVAT      := outPriceWithOutVAT
                                                  , inPriceWithVAT         := outPriceWithVAT
                                                  , inPriceTender          := inPriceTender
                                                  , inAmountReal           := inAmountReal
                                                  , inAmountPlanMin        := inAmountPlanMin
                                                  , inAmountPlanMax        := inAmountPlanMax
                                                  , inGoodsKindId          := inGoodsKindId
                                                  , inGoodsKindCompleteId  := inGoodsKindCompleteId
                                                  , inComment              := inComment
                                                  , inUserId               := vbUserId
                                                   );

     -- ��������� <�������> - ��������� �����
     IF NOT EXISTS (SELECT 1 FROM MovementItem AS MI JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Message())
     THEN 
         PERFORM gpInsertUpdate_MI_Message_PromoStateKind (ioId               := 0
                                                         , inMovementId       := inMovementId
                                                         , inPromoStateKindId := zc_Enum_PromoStateKind_Start()
                                                         , inIsQuickly        := FALSE
                                                         , inComment          := ''
                                                         , inSession          := inSession
                                                          );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 24.01.18         * inPriceTender
 28.11.17         * inGoodsKindCompleteId
 25.11.15                                                                         * Comment
 13.10.15                                                                         *
*/