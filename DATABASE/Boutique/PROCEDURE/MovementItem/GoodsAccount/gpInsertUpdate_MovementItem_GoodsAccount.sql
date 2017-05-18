-- Function: gpInsertUpdate_MovementItem_GoodsAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsAccount(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inGoodsId                Integer   , -- ������
    IN inPartionId              Integer   , -- ������
    IN inPartionMI_Id           Integer   , -- ������ �������� �������/�������
    IN inSaleMI_Id              Integer   , -- ������ ���. �������
    IN inisPay                  Boolean   , -- �������� � �������
    IN inAmount                 TFloat    , -- ����������
   OUT outOperPrice             TFloat    , -- ����
   OUT outCountForPrice         TFloat    , -- ���� �� ����������
   OUT outAmountSumm            TFloat    , -- ����� ���������
   OUT outOperPriceList         TFloat    , -- ���� �� ������
   OUT outAmountPriceListSumm   TFloat    , -- ����� �� ������
   OUT outCurrencyValue         TFloat    , -- 
   OUT outParValue              TFloat    , -- 
   OUT outSummChangePercent     TFloat    , -- 
   OUT outTotalPay              TFloat    , -- 
   OUT outTotalSummPay          TFloat    , -- 
    IN inSession                TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbDiscountGoodsAccountKindId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbClientId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_GoodsAccount());

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

     -- ������ �� �����
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
    INTO vbOperDate, vbClientId
     FROM Movement 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

     -- ���� ������� �� ������ 
     outOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem(vbOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp), 0);

     -- ������ �� ������ : OperPrice � CountForPrice
     SELECT COALESCE (Object_PartionGoods.CountForPrice,1)
          , COALESCE (Object_PartionGoods.OperPrice,0)
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis())
    INTO outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;
     
    IF vbCurrencyId <> zc_Currency_Basis() THEN
        SELECT COALESCE (tmp.Amount,1) , COALESCE (tmp.ParValue,0)
       INTO outCurrencyValue, outParValue
        FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= vbCurrencyId ) AS tmp;
    END IF;
    outCurrencyValue := COALESCE(outCurrencyValue,1);
    outParValue      := COALESCE(outParValue,0);

    -- ���������� ������
  /*  SELECT tmp.ChangePercent, tmp.DiscountGoodsAccountKindId, tmp.DiscountGoodsAccountKindName
   INTO outChangePercent, vbDiscountGoodsAccountKindId, outDiscountGoodsAccountKindName
    FROM zfSelect_DiscountGoodsAccountKind (vbOperDate, vbUnitId, inGoodsId, vbClientId, vbUserId) AS tmp;
*/
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

     --outTotalChangePercent := outAmountPriceListSumm / 100 * COALESCE(outChangePercent,0) + COALESCE(inSummChangePercent,0) ;

     outTotalSummPay := COALESCE(outAmountPriceListSumm,0) - COALESCE(outTotalChangePercent,0) ;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_GoodsAccount   (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inGoodsId            := inGoodsId
                                                      , inPartionId          := COALESCE(inPartionId,0)
                                                      , inPartionMI_Id       := COALESCE(inPartionMI_Id,0)
                                                      , inSaleMI_Id          := COALESCE(inSaleMI_Id,0)
                                                      , inAmount             := inAmount
                                                      , inSummChangePercent     := COALESCE(outSummChangePercent,0)    ::TFloat     
                                                      , inTotalPay              := COALESCE(outTotalPay,0)              ::TFloat              
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
 18.05.17         *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_GoodsAccount(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');