-- Function: gpInsertUpdate_MI_Sale_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Child (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,  TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Sale_Child(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inParentId              Integer   , -- ����
    IN inAmountGRN             TFloat    , -- ����� ������
    IN inAmountUSD             TFloat    , -- ����� ������
    IN inAmountEUR             TFloat    , -- ����� ������
    IN inAmountCard            TFloat    , -- ����� ������
    IN inAmountDiscount        TFloat    , -- �������������� ������ � ������� !!! EUR or ��� !!!
    IN inCurrencyValueUSD      TFloat    , --
    IN inParValueUSD           TFloat    , --
    IN inCurrencyValueEUR      TFloat    , --
    IN inParValueEUR           TFloat    , --
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbTmp    Integer;
   DECLARE vbCurrencyId_Client Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������ �� ���������
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());

     -- ������ �� ���������
     vbCurrencyId_Client:= COALESCE((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_CurrencyClient())
                                  , CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE THEN zc_Currency_GRN() ELSE zc_Currency_EUR() END
                                   );

     -- ������� ����� � ������ - !!! EUR or ��� !!!
     CREATE TEMP TABLE _tmp_MI_Master (MovementItemId Integer, SummPriceList TFloat, AmountToPay TFloat) ON COMMIT DROP;
     INSERT INTO _tmp_MI_Master (MovementItemId, SummPriceList, SummPriceList_curr, AmountToPay, AmountToPay_curr)
        WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                            , CASE WHEN vbCurrencyId_Client = zc_Currency_EUR()
                                   -- EUR
                                   THEN zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData)
                                   -- ���
                                   ELSE zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                              END AS SummPriceList

                            , CASE WHEN vbCurrencyId_Client = zc_Currency_EUR()
                                   -- EUR
                                   THEN zfCalc_SummChangePercent (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, MIFloat_ChangePercent.ValueData)
                                   -- ���
                                   ELSE zfCalc_SummChangePercent (MovementItem.Amount, MIFloat_OperPriceList.ValueData,      MIFloat_ChangePercent.ValueData)
                              END AS AmountToPay

                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                                        ON MIFloat_OperPriceList_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList_curr.DescId         = zc_MIFloat_OperPriceList_curr()
                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                      )
        -- ���������
        SELECT tmpMI.MovementItemId, tmpMI.SummPriceList, tmpMI.AmountToPay
        FROM tmpMI
        WHERE tmpMI.MovementItemId     = inParentId
           OR COALESCE (inParentId, 0) = 0;


     -- ������ ������ Child
     WITH tmpChild AS (SELECT *
                       FROM lpSelect_MI_Child_calc (inMovementId        := inMovementId
                                                  , inUnitId            := vbUnitId
                                                  , inAmountGRN         := inAmountGRN
                                                  , inAmountUSD         := inAmountUSD
                                                  , inAmountEUR         := inAmountEUR
                                                  , inAmountCard        := inAmountCard
                                                  , inAmountDiscount    := inAmountDiscount
                                                  , inCurrencyValueUSD  := inCurrencyValueUSD
                                                  , inParValueUSD       := inParValueUSD
                                                  , inCurrencyValueEUR  := inCurrencyValueEUR
                                                  , inParValueEUR       := inParValueEUR
                                                  , vbCurrencyId_Client := vbCurrencyId_Client
                                                  , inUserId            := vbUserId
                                                   )
                      )
          -- � ������ ��������
        , tmpUpdateMaster AS (SELECT *
                              FROM (SELECT 1 AS Num
                                         , _tmp_MI_Master.MovementItemId
                                           -- �������������� ������ � ������� ���
                                         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(),  _tmp_MI_Master.MovementItemId, COALESCE (tmp.AmountDiscount, 0))
                                           -- ����� ������ � ������� ���
                                         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), _tmp_MI_Master.MovementItemId, _tmp_MI_Master.SummPriceList - _tmp_MI_Master.AmountToPay + COALESCE (tmp.AmountDiscount, 0))
                                           -- ����� ������ � ������� ���
                                         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), _tmp_MI_Master.MovementItemId, COALESCE (tmp.TotalPay, 0))
                                    FROM _tmp_MI_Master
                                         LEFT JOIN (SELECT tmpChild.ParentId
                                                         , MAX (tmpChild.AmountDiscount) AS AmountDiscount
                                                         , SUM (tmpChild.Amount_GRN)     AS TotalPay
                                                    FROM tmpChild
                                                    WHERE tmpChild.ParentId > 0
                                                    GROUP BY tmpChild.ParentId
                                                   ) AS tmp ON tmp.ParentId = _tmp_MI_Master.MovementItemId
                                   ) AS tmp
                             )
          -- � Child ��������
        , tmpInsertChild AS (SELECT 2 AS Num
                                  , lpInsertUpdate_MI_Sale_Child (ioId                 := tmpChild.MovementItemId
                                                                , inMovementId         := inMovementId
                                                                , inParentId           := tmpChild.ParentId
                                                                , inCashId             := tmpChild.CashId
                                                                , inCurrencyId         := tmpChild.CurrencyId
                                                                , inCashId_Exc         := tmpChild.CashId_Exc
                                                                , inAmount             := tmpChild.Amount
                                                                , inCurrencyValue      := tmpChild.CurrencyValue
                                                                , inParValue           := tmpChild.ParValue
                                                                , inUserId             := vbUserId
                                                                 ) AS MovementItemId
                             FROM tmpChild
                            )
        -- ���������
        SELECT (SELECT MAX (tmpUpdateMaster.MovementItemId) FROM tmpUpdateMaster) :: Integer
             + (SELECT MAX (tmpInsertChild.MovementItemId)  FROM tmpInsertChild)  :: Integer
               INTo vbTmp;


     -- "������" ����������� "��������" ����� �� ���� ���������
     PERFORM lpUpdate_MI_Sale_Total (MovementItem.Id)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
     ;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.05.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_Sale_Child (ioId:= 0, inMovementId:= 8, inGoodsId:= 446, inPartionId:= 50, inAmount:= 4, outOperPrice:= 100, ioCountForPrice:= 1, inSession:= zfCalc_UserAdmin());
