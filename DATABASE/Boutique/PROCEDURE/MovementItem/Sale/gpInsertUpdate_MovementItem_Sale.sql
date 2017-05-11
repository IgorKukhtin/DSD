-- Function: gpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                   Integer   , -- ���� ������� <������� ���������>
    IN inMovementId           Integer   , -- ���� ������� <��������>
    IN inGoodsId              Integer   , -- ������
    IN inPartionId            Integer   , -- ������
    IN inisPay                Boolean   , -- �������� � �������
    IN inAmount               TFloat    , -- ����������
    IN inChangePercent        TFloat    , -- % ������
    IN inSummChangePercent    TFloat    , -- ����� �������������� ������ (� ���)
   OUT outOperPrice           TFloat    , -- ����
   OUT outCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm          TFloat    , -- ����� ���������
   OUT outOperPriceList       TFloat    , -- ���� �� ������
   OUT outAmountPriceListSumm TFloat    , -- ����� �� ������

   OUT outCurrencyValue         TFloat    , -- 
   OUT outParValue              TFloat    , -- 
   OUT outTotalChangePercent    TFloat    , -- 
   OUT outTotalChangePercentPay TFloat    , -- 
   OUT outTotalPay              TFloat    , -- 
   OUT outTotalPayOth           TFloat    , -- 
   OUT outTotalCountReturn      TFloat    , -- 
   OUT outTotalReturn           TFloat    , -- 
   OUT outTotalPayReturn        TFloat    , -- 
   OUT outDiscountSaleKindName  TVarChar  , -- ��� ������ ��� �������
    IN inBarCode                TVarChar  , -- �����-��� ����������
    IN inSession                TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbDiscountSaleKindId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());

     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;

     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- ���� ������� �� ������ 
     outOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem(vbOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp), 0);

     -- ������ �� ������ : OperPrice � CountForPrice
     SELECT COALESCE (Object_PartionGoods.CountForPrice,1)
          , COALESCE (Object_PartionGoods.OperPrice,0)
          , CurrencyId
    INTO outCountForPrice, outOperPrice, outCurrencyValue
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;
     
     -- 
     /*IF vbCurrencyId <> zc_Currency_Basis() 
        THEN

     END IF;*/

     outCurrencyValue := 1;
     outParValue := 0;

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN outCountForPrice > 0
                                THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                      END;
     -- ��������� ����� �� ������ �� ��������, ��� �����
     outAmountPriceListSumm := CASE WHEN outCountForPrice > 0
                                         THEN CAST (inAmount * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                    ELSE CAST (inAmount * outOperPriceList AS NUMERIC (16, 2))
                               END;

     outTotalChangePercent := outAmountPriceListSumm / 100 * COALESCE(inChangePercent,0) + COALESCE(inSummChangePercent,0) ;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Sale   (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := inGoodsId
                                              , inPartionId          := COALESCE(inPartionId,0)
                                              , inDiscountSaleKindId := vbDiscountSaleKindId
                                              , inAmount             := inAmount
                                              , inChangePercent      := COALESCE(inChangePercent,0)        ::TFloat
                                              , inSummChangePercent  := COALESCE(inSummChangePercent,0)    ::TFloat
                                              , inOperPrice          := outOperPrice
                                              , inCountForPrice      := outCountForPrice
                                              , inOperPriceList      := outOperPriceList
                                              , inCurrencyValue         := outCurrencyValue 
                                              , inParValue              := outParValue 
                                              , inTotalChangePercent    := COALESCE(outTotalChangePercent,0)    ::TFloat     
                                              , inTotalChangePercentPay := COALESCE(outTotalChangePercentPay,0) ::TFloat
                                              , inTotalPay              := COALESCE(outTotalPay,0)              ::TFloat              
                                              , inTotalPayOth           := COALESCE(outTotalPayOth,0)           ::TFloat           
                                              , inTotalCountReturn      := COALESCE(outTotalCountReturn,0)      ::TFloat      
                                              , inTotalReturn           := COALESCE(outTotalReturn,0)           ::TFloat   
                                              , inTotalPayReturn        := COALESCE(outTotalPayReturn,0)        ::TFloat
                                              , inBarCode               := COALESCE(inBarCode,'')               ::TVarChar
                                              , inUserId                := vbUserId
                                               );

    IF inisPay THEN
       
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.17         *
 10.04.17         *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_Sale(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');