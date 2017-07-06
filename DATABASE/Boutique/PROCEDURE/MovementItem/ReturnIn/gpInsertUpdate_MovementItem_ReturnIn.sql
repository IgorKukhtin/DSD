-- Function: gpInsertUpdate_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnIn(
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
   OUT outTotalSumm            TFloat    , -- ����� ���������
   OUT outTotalSummBalance    TFloat    , -- ����� ��. (���)
 INOUT ioOperPriceList          TFloat    , -- ���� �� ������
   OUT outTotalSummPriceList   TFloat    , -- ����� �� ������
   OUT outCurrencyValue         TFloat    , -- 
   OUT outParValue              TFloat    , -- 
   OUT outTotalChangePercent    TFloat    , -- 
   OUT outTotalPay              TFloat    , -- 
   OUT outTotalPayOth           TFloat    , -- 
   OUT outTotalSummPay          TFloat    , -- 
    IN inSession                TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbDiscountReturnInKindId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbClientId Integer;
   DECLARE vbTotalPay_Sale TFloat;
   DECLARE vbCashId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

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
          , MovementLinkObject_To.ObjectId
    INTO vbOperDate, vbClientId, vbUnitId
     FROM Movement 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;

     -- ���� (�����)
     IF ioOperPriceList <> 0
     THEN
         -- !!!��� SYBASE - ����� ������!!!
         IF vbUserId <> zfCalc_UserAdmin() :: Integer THEN RAISE EXCEPTION '������.�������� ������ ��� �������� �� Sybase.'; END IF;
     ELSE
         -- �� �������
         ioOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                                   , zc_PriceList_Basis()
                                                                                                   , inGoodsId
                                                                                                    ) AS tmp), 0);
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (ioOperPriceList, 0) <= 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <���� (�����)>.';
     END IF;
     -- ������ �� ������ : OperPrice � CountForPrice
     SELECT COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
          , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
            INTO outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;
     

     -- ���� �� ������� ������
     IF vbCurrencyId <> zc_Currency_Basis()
     THEN
         -- ���������� ���� �� ���� ���������
         SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue, 0)
                INTO outCurrencyValue, outParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                               , inCurrencyToId  := vbCurrencyId
                                                ) AS tmp;       
         -- ��������
         IF COALESCE (vbCurrencyId, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <������>.';
         END IF;
         -- ��������
         IF COALESCE (outCurrencyValue, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <����>.';
         END IF;
         -- ��������
         IF COALESCE (outParValue, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <�������>.';
         END IF;

     ELSE
         -- ���� �� �����
         outCurrencyValue:= 1;
         outParValue     := 1;
     END IF;

     -- ��������� ����� �� ��������, ��� �����
     outTotalSumm := CASE WHEN outCountForPrice > 0
                               THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                          ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                     END;
     -- ��������� ����� ��. � ��� �� ��������, ��� �����
     outTotalSummBalance := (CAST (outTotalSumm * outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END AS NUMERIC (16, 2))) ;
                          
     -- ��������� ����� �� ������ �� ��������, ��� �����
     outTotalSummPriceList := CAST (inAmount * ioOperPriceList AS NUMERIC (16, 2));

     --outTotalChangePercent := outTotalSummPriceList / 100 * COALESCE(outChangePercent,0) + COALESCE(inSummChangePercent,0) ;
     -- ��������� C���� ������ � ���
     outTotalPay := (SELECT SUM (MovementItem.Amount * CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_GRN() THEN 1 ELSE COALESCE (MIFloat_CurrencyValue.ValueData,1) / MIFloat_ParValue.ValueData END )
                     FROM (SELECT FALSE AS isErased) AS tmpIsErased
                          JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                           AND MovementItem.DescId     = zc_MI_Child()
                                           AND MovementItem.isErased   = FALSE
                          LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                           ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                          LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                      ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                          LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                      ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                     AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                     WHERE MovementItem.ParentId = ioId
                    );
                    
     -- ���������
     ioId:= lpInsertUpdate_MovementItem_ReturnIn(ioId                    := ioId
                                               , inMovementId            := inMovementId
                                               , inGoodsId               := inGoodsId
                                               , inPartionId             := COALESCE(inPartionId,0)
                                               , inPartionMI_Id          := COALESCE(inPartionMI_Id,0)
                                               , inSaleMI_Id             := COALESCE(inSaleMI_Id,0)
                                               , inAmount                := inAmount
                                               , inOperPrice             := outOperPrice
                                               , inCountForPrice         := outCountForPrice
                                               , inOperPriceList         := ioOperPriceList
                                               , inCurrencyValue         := outCurrencyValue 
                                               , inParValue              := outParValue 
                                               , inTotalChangePercent    := COALESCE(outTotalChangePercent,0)    ::TFloat     
                                               , inTotalPay              := COALESCE(outTotalPay,0)              ::TFloat              
                                               , inTotalPayOth           := COALESCE(outTotalPayOth,0)           ::TFloat           
                                               , inUserId                := vbUserId
                                               );

     vbTotalPay_Sale := (SELECT COALESCE (MIFloat_TotalPay.ValueData, 0) 
                         FROM MovementItemLinkObject AS MILinkObject_PartionMI
                              LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                              LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode
                              LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                     ON MIFloat_TotalPay.MovementItemId = MI_Sale.Id
                                    AND MIFloat_TotalPay.DescId = zc_MIFloat_TotalPay()
                         WHERE MILinkObject_PartionMI.MovementItemId = ioId
                           AND MILinkObject_PartionMI.DescId = zc_MILinkObject_PartionMI());
     
     outTotalSummPay := COALESCE(outTotalSummPriceList,0) - COALESCE(outTotalChangePercent,0);
     outTotalSummPay := CASE WHEN outTotalSummPay > vbTotalPay_Sale THEN vbTotalPay_Sale ELSE outTotalSummPay END;

    IF inisPay = TRUE THEN
       -- ������� ����� ��� ��������, � ������� ������� ������
       vbCashId := (SELECT Object_Cash.Id
                    FROM ObjectLink AS ObjectLink_Cash_Unit
                         INNER JOIN Object AS Object_Cash 
                                           ON Object_Cash.Id     = ObjectLink_Cash_Unit.ObjectId
                                          AND Object_Cash.DescId = zc_Object_Cash()
                                          AND Object_Cash.isErased = FALSE
                         INNER JOIN ObjectLink AS ObjectLink_Cash_Currency
                                               ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                                              AND ObjectLink_Cash_Currency.DescId   = zc_ObjectLink_Cash_Currency()
                                              AND ObjectLink_Cash_Currency.ChildObjectId = zc_Currency_GRN()
                    WHERE ObjectLink_Cash_Unit.ChildObjectId = vbUnitId
                      AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
                    );
                    
      
       -- ����������� ��������
       CREATE TEMP TABLE _tmpMI (Id Integer, CashId Integer) ON COMMIT DROP;
       --
       INSERT INTO _tmpMI (Id, CashId)
          SELECT MovementItem.Id
               , MovementItem.ObjectId AS CashId
          FROM MovementItem
          WHERE MovementItem.ParentId   = ioId
            AND MovementItem.MovementId = inMovementId
            AND MovementItem.ObjectId   = vbCashId
            AND MovementItem.DescId     = zc_MI_Child()
            AND MovementItem.isErased   = FALSE;

       -- ���������
       PERFORM lpInsertUpdate_MI_ReturnIn_Child (ioId                 := COALESCE (_tmpMI.Id,0)
                                               , inMovementId         := inMovementId
                                               , inParentId           := ioId
                                               , inCashId             := _tmpCash.CashId
                                               , inCurrencyId         := zc_Currency_GRN()
                                               , inCashId_Exc         := NULL
                                               , inAmount             := outTotalSummPay :: TFloat
                                               , inCurrencyValue      := 1               :: TFloat
                                               , inParValue           := 1               :: TFloat
                                               , inUserId             := vbUserId
                                                )
                                              
       FROM (SELECT vbCashId AS CashId) AS _tmpCash
            FULL JOIN _tmpMI ON _tmpMI.CashId = _tmpCash.CashId;
            
       -- � ������ �������� ����� ����� ������ ���
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, outTotalSummPay);       
    END IF;

    
    -- �����������
    -- ����� ����� ������ (� ���) - ��� ������
    --PERFORM lpUpdate_MI_ReturnIn_Total(ioId);
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.06.17         *
 15.05.17         *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_ReturnIn(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');