-- Function: gpInsertUpdate_MI_GoodsAccount_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsAccount_Child (Integer, Integer, Boolean, Boolean,Boolean,Boolean,Boolean,Boolean
                                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsAccount_Child (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsAccount_Child (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsAccount_Child(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inParentId              Integer   , -- ����
    IN inAmountGRN             TFloat    , -- ����� ������
    IN inAmountUSD             TFloat    , -- ����� ������
    IN inAmountEUR             TFloat    , -- ����� ������
    IN inAmountCard            TFloat    , -- ����� ������
    IN inAmountDiscount        TFloat    , -- ����� ������
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
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_GoodsAccount());


     -- ������ �� ���������
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());


     -- !!!��� SYBASE - �� �������, + ��� ������ ����� � �������!!!
     IF vbUserId <> zc_User_Sybase() -- AND inParentId = 0
     THEN
         -- ������� ������
         CREATE TEMP TABLE _tmp_MI_Master (MovementItemId Integer, AmountToPay TFloat) ON COMMIT DROP;
         INSERT INTO _tmp_MI_Master (MovementItemId, AmountToPay)
            WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                                , -- ����� � ������� �� ������ ������� - ����� �������
                                  zfCalc_SummChangePercent (MovementItem.Amount - COALESCE (MIFloat_TotalCountReturn.ValueData, 0)
                                                          , MIFloat_OperPriceList.ValueData
                                                          , MIFloat_ChangePercent.ValueData
                                                            )
                                  -- ����� ������ ��� �������
                                - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                  -- ����� ������ � �������� 
                                - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                                  -- ���� ������� ������
                                + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
                                  AS AmountToPay

                                , -- !!!���� ������� ������ - ����� ���������!!!
                                  0 AS AmountToPay_RETURN
                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILO_PartionMI_level1
                                                                 ON MILO_PartionMI_level1.MovementItemId = MovementItem.Id
                                                                AND MILO_PartionMI_level1.DescId = zc_MILinkObject_PartionMI()
                                LEFT JOIN Object AS Object_PartionMI_level1 ON Object_PartionMI_level1.Id = MILO_PartionMI_level1.ObjectId
                                LEFT JOIN MovementItemLinkObject AS MILO_PartionMI_level2
                                                                 ON MILO_PartionMI_level2.MovementItemId = Object_PartionMI_level1.ObjectCode
                                                                AND MILO_PartionMI_level2.DescId         = zc_MILinkObject_PartionMI()
                                LEFT JOIN Object AS Object_PartionMI_level2 ON Object_PartionMI_level2.Id = MILO_PartionMI_level2.ObjectId

                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = COALESCE (Object_PartionMI_level2.ObjectCode, Object_PartionMI_level1.ObjectCode)
                                                           AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                                LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                            ON MIFloat_ChangePercent.MovementItemId = COALESCE (Object_PartionMI_level2.ObjectCode, Object_PartionMI_level1.ObjectCode)
                                                           AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                            ON MIFloat_TotalCountReturn.MovementItemId = COALESCE (Object_PartionMI_level2.ObjectCode, Object_PartionMI_level1.ObjectCode)
                                                           AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                            ON MIFloat_TotalPay.MovementItemId = COALESCE (Object_PartionMI_level2.ObjectCode, Object_PartionMI_level1.ObjectCode)
                                                           AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                            ON MIFloat_TotalPayOth.MovementItemId = COALESCE (Object_PartionMI_level2.ObjectCode, Object_PartionMI_level1.ObjectCode)
                                                           AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                            ON MIFloat_TotalPayReturn.MovementItemId = COALESCE (Object_PartionMI_level2.ObjectCode, Object_PartionMI_level1.ObjectCode)
                                                           AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
            -- ���������
            SELECT tmpMI.MovementItemId, tmpMI.AmountToPay
            FROM tmpMI
            WHERE tmpMI.MovementItemId     = inParentId
               OR COALESCE (inParentId, 0) = 0;
               

-- RAISE EXCEPTION '<%>', (select max (AmountToPay) from _tmp_MI_Master);
               

         -- ������ ������ Child
         WITH tmpChild AS (SELECT *
                           FROM lpSelect_MI_Child_calc (inMovementId      := inMovementId
                                                      , inUnitId          := vbUnitId
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
       -- � ������ ��������
     , tmpUpdateMaster AS (SELECT *
                           FROM
                          (SELECT 1 AS Num
                                , _tmp_MI_Master.MovementItemId
                                  -- �������������� ������ � �������� ���
                                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(),  _tmp_MI_Master.MovementItemId, COALESCE (tmp.AmountDiscount, 0))
                                  -- ����� ������ � �������� ���
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
                                , lpInsertUpdate_MI_GoodsAccount_Child (ioId                 := tmpChild.MovementItemId
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

     ELSE
         -- !!!��� SYBASE - ����� ������!!! + �������� ��� inParentId

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
             FROM lpSelect_Object_Cash (vbUnitId, vbUserId) AS lpSelect
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
         PERFORM lpInsertUpdate_MI_GoodsAccount_Child (ioId                 := COALESCE (_tmpMI.Id,0)
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


         -- !!!��� SYBASE - �� �������, �.�. ��� ������ ����� � �������!!!
         IF vbUserId = zc_User_Sybase()
         THEN
             -- !!!��� SYBASE - ����� ������!!!
             IF 1=0 THEN RAISE EXCEPTION '������.�������� ������ ��� �������� �� Sybase.'; END IF;
         ELSE
             -- � ������ �������� - �������������� ������ � �������� ���
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), inParentId, inAmountDiscount);
         END IF;

         -- � ������ �������� - ����� ������ � �������� ���
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), inParentId
                                                 , COALESCE ((SELECT SUM (_tmpCash.Amount * CASE WHEN _tmpCash.CurrencyId = zc_Currency_GRN() THEN 1 ELSE _tmpCash.CurrencyValue / _tmpCash.ParValue END)
                                                              FROM _tmpCash
                                                             ), 0));

     END IF;


     -- "������" ����������� "��������" ����� �� ���� ��������� - ����� ������ �� �������
     PERFORM lpUpdate_MI_Sale_Total (Object.ObjectCode)
     FROM MovementItem
          INNER JOIN MovementItemLinkObject AS MILO_PartionMI
                                            ON MILO_PartionMI.MovementItemId = MovementItem.Id
                                           AND MILO_PartionMI.DescId         = zc_MILinkObject_PartionMI()
          INNER JOIN Object ON Object.Id = MILO_PartionMI.ObjectId
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
     ;

     -- "������" ����������� "��������" ����� �� ���� ��������� - ����� ������� ������
     PERFORM lpUpdate_MI_Sale_Total (Object.ObjectCode)
     FROM MovementItem
          INNER JOIN MovementItemLinkObject AS MILO_PartionMI_return
                                            ON MILO_PartionMI_return.MovementItemId = MovementItem.Id
                                           AND MILO_PartionMI_return.DescId         = zc_MILinkObject_PartionMI()
          INNER JOIN Object AS Object_PartionMI_return ON Object_PartionMI_return.Id = MILO_PartionMI_return.ObjectId

          INNER JOIN MovementItemLinkObject AS MILO_PartionMI
                                            ON MILO_PartionMI.MovementItemId = Object_PartionMI_return.ObjectCode
                                           AND MILO_PartionMI.DescId         = zc_MILinkObject_PartionMI()
          INNER JOIN Object ON Object.Id = MILO_PartionMI.ObjectId

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
 15.05.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_GoodsAccount_Child (inMovementId := 35 , inParentId := 112 , inisPayTotal := 'False' , inisPayGRN := 'True' , inisPayUSD := 'False' , inisPayEUR := 'False' , inisPayCard := 'False' , inisDiscount := 'False' , inAmountGRN := 100 , inAmountUSD := 0 , inAmountEUR := 0 , inAmountCARD := 0 , inAmountDiscount := 0 ,  inSession := '2');
-- SELECT * FROM gpInsertUpdate_MI_GoodsAccount_Child (inMovementId := 35 , inParentId := 112 , inisPayTotal := 'False' , inisPayGRN := 'True' , inisPayUSD := 'False' , inisPayEUR := 'False' , inisPayCard := 'False' , inisDiscount := 'False' , inAmountGRN := 100 , inAmountUSD := 0 , inAmountEUR := 0 , inAmountCARD := 0 , inAmountDiscount := 0 ,  inSession := '2');
