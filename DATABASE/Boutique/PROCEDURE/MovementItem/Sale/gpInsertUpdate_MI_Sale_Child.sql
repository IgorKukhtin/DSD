-- Function: gpInsertUpdate_MI_Sale_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Child (Integer, Integer, Integer, Boolean, Boolean,Boolean,Boolean,Boolean,Boolean
                                                     ,TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Child (Integer, Integer, Boolean, Boolean,Boolean,Boolean,Boolean,Boolean
                                                     ,TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Child (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Sale_Child (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,  TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Sale_Child(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inParentId              Integer   , -- ����
    IN inAmountGRN             TFloat    , -- ����� ������
    IN inAmountUSD             TFloat    , -- ����� ������
    IN inAmountEUR             TFloat    , -- ����� ������
    IN inAmountCard            TFloat    , -- ����� ������
    IN inAmountDiscount        TFloat    , -- �������������� ������ � ������� ���
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
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());


     -- ������ �� ���������
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());


     -- !!!��� SYBASE - �� �������, + ��� ������ ����� � �������!!!
     IF vbUserId <> zc_User_Sybase()
     THEN
         -- ������� ������
         CREATE TEMP TABLE _tmp_MI_Master (MovementItemId Integer, AmountToPay TFloat) ON COMMIT DROP;
         INSERT INTO _tmp_MI_Master (MovementItemId, AmountToPay)
            WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                                , CAST (CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0) AS NUMERIC (16, 0))
                                      * (1 - COALESCE (MIFloat_ChangePercent.ValueData, 0) / 100) AS NUMERIC (16, 0)) AS AmountToPay
                           FROM MovementItem
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                                LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                            ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                           AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
            -- ���������
            SELECT tmpMI.MovementItemId, tmpMI.AmountToPay
            FROM tmpMI
            WHERE tmpMI.MovementItemId     = inParentId
               OR COALESCE (inParentId, 0) = 0;

         -- ����������� Child
         WITH tmpChild AS (SELECT *
                           FROM lpSelect_MI_Master_calc (inUnitId          := vbUnitId
                                                       , inAmountGRN       := inAmountGRN
                                                       , inAmountUSD       := inAmountUSD
                                                       , inAmountEUR       := inAmountEUR
                                                       , inAmountCard      := inAmountCard
                                                       , inAmountDiscount  := inAmountDiscount
                                                       , inCurrencyValueUSD:= inCurrencyValueUSD
                                                       , inParValueUSD     := inParValueUSD
                                                       , inCurrencyValueEUR:= inCurrencyValueEUR
                                                       , inParValueEUR     := inParValueEUR
                                                       , inUserId          := vbUserId
                                                        )
                          )

         -- � ������ �������� - �������������� ������ � ������� ���
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), inParentId, inAmountDiscount);

         -- � ������ �������� - ����� ������ � ������� ���
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), inParentId
                                                 , inAmountDiscount
                                                  + COALESCE ((SELECT SUM (CAST (CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0) AS NUMERIC (16, 0))
                                                                               * COALESCE (MIFloat_ChangePercent.ValueData, 0) / 100 AS NUMERIC (16, 0)))
                                                               FROM MovementItem
                                                                    LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                                                                ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                                                               AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                                                                    LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                                                ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                                               AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                                                               WHERE MovementItem.Id       = inParentId
                                                                 AND MovementItem.DescId   = zc_MI_Master()
                                                                 AND MovementItem.isErased = FALSE
                                                              ), 0));

         -- � ������ �������� - ����� ������ � ������� ���
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), inParentId
                                                 , COALESCE ((SELECT SUM (_tmpCash.Amount * CASE WHEN _tmpCash.CurrencyId = zc_Currency_GRN() THEN 1 ELSE _tmpCash.CurrencyValue / _tmpCash.ParValue END)
                                                              FROM _tmpCash
                                                             ), 0));

     ELSE
         -- !!!��� SYBASE - ����� ������!!!
         -- �������� - �������� ������ ���� �����������
         IF COALESCE (inParentId, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <inParentId>.';
         END IF;

         -- ������� ����� ��� �������� ��� �.��., � ������� ������� ������
         CREATE TEMP TABLE _tmpCash (CashId Integer, CurrencyId Integer, Amount TFloat, CurrencyValue TFloat, ParValue TFloat) ON COMMIT DROP;
         --
         INSERT INTO _tmpCash (CashId, CurrencyId , Amount, CurrencyValue, ParValue)
            SELECT lpSelect.CashId
                 , lpSelect.CurrencyId
                 , CASE WHEN lpSelect.CurrencyId = zc_Currency_GRN() AND lpSelect.isBankAccount = FALSE THEN inAmountGRN
                        WHEN lpSelect.CurrencyId = zc_Currency_GRN() AND lpSelect.isBankAccount = TRUE  THEN inAmountCard
                        WHEN lpSelect.CurrencyId = zc_Currency_EUR() THEN inAmountEUR
                        WHEN lpSelect.CurrencyId = zc_Currency_USD() THEN inAmountUSD
                   END AS Amount
                 , CASE WHEN lpSelect.CurrencyId = zc_Currency_EUR() THEN COALESCE (inCurrencyValueEUR, 1)
                        WHEN lpSelect.CurrencyId = zc_Currency_USD() THEN COALESCE (inCurrencyValueUSD, 1)
                        ELSE 0
                   END AS CurrencyValue
                 , CASE WHEN lpSelect.CurrencyId = zc_Currency_EUR() THEN CASE WHEN inParValueEUR > 0 THEN inParValueEUR ELSE 1 END
                        WHEN lpSelect.CurrencyId = zc_Currency_USD() THEN CASE WHEN inParValueUSD > 0 THEN inParValueUSD ELSE 1 END
                        ELSE 0
                   END AS ParValue
             FROM lpSelect_Object_Cash (vbUnitId, inUserId) AS lpSelect
             WHERE 0 <> CASE WHEN lpSelect.CurrencyId = zc_Currency_GRN() AND lpSelect.isBankAccount = FALSE THEN inAmountGRN
                             WHEN lpSelect.CurrencyId = zc_Currency_GRN() AND lpSelect.isBankAccount = TRUE  THEN inAmountCard
                             WHEN lpSelect.CurrencyId = zc_Currency_EUR() THEN inAmountEUR
                             WHEN lpSelect.CurrencyId = zc_Currency_USD() THEN inAmountUSD
                        END
            ;


         -- ����������� ��������
         CREATE TEMP TABLE _tmpMI (Id Integer, CashId Integer) ON COMMIT DROP;
         --
         INSERT INTO _tmpMI (Id, CashId)
            SELECT MovementItem.Id
                 , MovementItem.ObjectId AS CashId
            FROM MovementItem
            WHERE MovementItem.ParentId   = inParentId
              AND MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Child()
              AND MovementItem.isErased   = FALSE;

         -- �������� - CashId ������ ���� ����������
         IF EXISTS (SELECT 1 FROM _tmpMI GROUP BY _tmpMI.CashId HAVING COUNT(*) > 1) THEN
            RAISE EXCEPTION '������.� ���������� ������� ����������� ����� <%>.', lfGet_Object_ValueData ((SELECT tmp.CashId FROM (SELECT _tmpMI.CashId FROM _tmpMI GROUP BY _tmpMI.CashId HAVING COUNT(*) > 1) AS tmp LIMIT 1));
         END IF;


         -- ���������
         PERFORM lpInsertUpdate_MI_Sale_Child (ioId                 := COALESCE (_tmpMI.Id,0)
                                             , inMovementId         := inMovementId
                                             , inParentId           := inParentId
                                             , inCashId             := COALESCE (_tmpCash.CashId, _tmpMI.CashId)
                                             , inCurrencyId         := _tmpCash.CurrencyId
                                             , inCashId_Exc         := NULL
                                             , inAmount             := COALESCE (_tmpCash.Amount, 0)
                                             , inCurrencyValue      := COALESCE (_tmpCash.CurrencyValue, 0)
                                             , inParValue           := COALESCE (_tmpCash.ParValue, 0)
                                             , inUserId             := vbUserId
                                              )
         FROM _tmpCash
              FULL JOIN _tmpMI ON _tmpMI.CashId = _tmpCash.CashId;


     END IF; -- !!!����� ��� Sybase!!!
     

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- "������" ����������� "��������" ����� �� ���� ���������
     PERFORM lpUpdate_MI_Sale_Total (MovementItem.Id)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
     ;

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
