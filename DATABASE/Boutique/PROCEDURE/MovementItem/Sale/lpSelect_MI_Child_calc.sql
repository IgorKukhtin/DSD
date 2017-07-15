-- Function: lpSelect_MI_Child_calc()

DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION lpSelect_MI_Child_calc(
    IN inUnitId                Integer   , -- ����
    IN inAmountGRN             TFloat    , -- ����� ������
    IN inAmountUSD             TFloat    , -- ����� ������
    IN inAmountEUR             TFloat    , -- ����� ������
    IN inAmountCard            TFloat    , -- ����� ������
    IN inAmountDiscount        TFloat    , -- �������������� ������ � ������� ���
    IN inCurrencyValueUSD      TFloat    , --
    IN inParValueUSD           TFloat    , --
    IN inCurrencyValueEUR      TFloat    , --
    IN inParValueEUR           TFloat      --
)
RETURNS TABLE (ParentId       Integer
             , CashId         Integer -- �����, � ������� ����� ������/������(���� �������)
             , CurrencyId     Integer -- ������ �����, � ������� ����� ������/������(���� �������)
             , AmountToPay    TFloat  -- ����� � ������
             , Amount         TFloat  -- ����� ������
             , AmountDiscount TFloat  -- ����� ������
             , CurrencyValue  TFloat
             , ParValue       TFloat
             , CashId_ch      Integer -- ����� � ��� - �� ������� ����� ������/������(���� �������) ����� ��� ������
              )
AS
$BODY$
   DECLARE vbTotalAmountToPay TFloat;
BEGIN

     -- !!!��� �����!!!
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmp_MI_Child'))
     THEN
         CREATE TEMP TABLE _tmp_MI_Child (MovementItemId Integer, AmountToPay TFloat) ON COMMIT DROP;
         INSERT INTO _tmp_MI_Child (MovementItemId, AmountToPay)
            SELECT 1, 100
           UNION
            SELECT 2, 200
           UNION
            SELECT 3, 300
           ;
     END IF;


     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inUnitId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ���������� �������� <�������>.';
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF NOT EXISTS (SELECT 1 FROM _tmp_MI_Child) THEN
        RAISE EXCEPTION '������.��� ������ ��� ������������ ������.';
     END IF;

     -- ����� �����
     vbTotalAmountToPay:= (SELECT SUM (_tmp_MI_Child.AmountToPay) FROM _tmp_MI_Child);

     -- ��������
     IF vbTotalAmountToPay < inAmountDiscount THEN
        RAISE EXCEPTION '������.����� �������������� ������ = <%> ��� �� ����� ���� ������ ��� <%> ���.', inAmountDiscount, vbTotalAmountToPay;
     END IF;



     -- �������� - CurrencyId ������ ���� ����������
     IF EXISTS (SELECT 1
                FROM Object AS Object_Unit
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                          ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                         AND ObjectLink_Unit_Parent.DescId   = zc_ObjectLink_Unit_Parent()
                     LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                          ON ObjectLink_Cash_Unit.ChildObjectId = Object_Unit.Id
                                         AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
                     LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit_Parent
                                          ON ObjectLink_Cash_Unit_Parent.ChildObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                         AND ObjectLink_Cash_Unit_Parent.DescId        = zc_ObjectLink_Cash_Unit()
                                         AND ObjectLink_Cash_Unit.ChildObjectId        IS NULL
                     INNER JOIN Object AS Object_Cash
                                       ON Object_Cash.Id       = COALESCE (ObjectLink_Cash_Unit.ObjectId, ObjectLink_Cash_Unit_Parent.ObjectId)
                                      AND Object_Cash.DescId   = zc_Object_Cash()
                                      AND Object_Cash.isErased = FALSE
                     INNER JOIN ObjectLink AS ObjectLink_Cash_Currency
                                           ON ObjectLink_Cash_Currency.ObjectId      = Object_Cash.Id
                                          AND ObjectLink_Cash_Currency.DescId        = zc_ObjectLink_Cash_Currency()
                                          AND ObjectLink_Cash_Currency.ChildObjectId = zc_Currency_GRN()
                WHERE Object_Unit.Id = inUnitId
                HAVING COUNT(*) > 1
               )
     THEN
        RAISE EXCEPTION '������.��� �������� <%> ����������� ��������� ���� � ������ <%>.', lfGet_Object_ValueData (inUnitId)
                       , lfGet_Object_ValueData ((SELECT tmp.CurrencyId
                                                  FROM (SELECT ObjectLink_Cash_Currency.ChildObjectId
                                                        FROM Object AS Object_Unit
                                                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                                                  ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                                                                 AND ObjectLink_Unit_Parent.DescId   = zc_ObjectLink_Unit_Parent()
                                                             LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                                                                  ON ObjectLink_Cash_Unit.ChildObjectId = Object_Unit.Id
                                                                                 AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
                                                             LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit_Parent
                                                                                  ON ObjectLink_Cash_Unit_Parent.ChildObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                                                                 AND ObjectLink_Cash_Unit_Parent.DescId        = zc_ObjectLink_Cash_Unit()
                                                                                 AND ObjectLink_Cash_Unit.ChildObjectId        IS NULL
                                                             INNER JOIN Object AS Object_Cash
                                                                               ON Object_Cash.Id       = COALESCE (ObjectLink_Cash_Unit.ObjectId, ObjectLink_Cash_Unit_Parent.ObjectId)
                                                                              AND Object_Cash.DescId   = zc_Object_Cash()
                                                                              AND Object_Cash.isErased = FALSE
                                                             INNER JOIN ObjectLink AS ObjectLink_Cash_Currency
                                                                                   ON ObjectLink_Cash_Currency.ObjectId      = Object_Cash.Id
                                                                                  AND ObjectLink_Cash_Currency.DescId        = zc_ObjectLink_Cash_Currency()
                                                                                  AND ObjectLink_Cash_Currency.ChildObjectId = zc_Currency_GRN()
                                                        WHERE Object_Unit.Id = inUnitId
                                                        GROUP BY ObjectLink_Cash_Currency.ChildObjectId
                                                        HAVING COUNT(*) > 1
                                                       ) AS tmp LIMIT 1))
                        ;
     END IF;


     -- ��������� �����
     RETURN QUERY
       WITH -- ������ - ���
            tmpPay AS (SELECT zc_Currency_GRN() AS CurrencyId, inAmountGRN AS Amount, 0 AS CurrencyValue, 0 AS ParValue WHERE inAmountGRN <> 0
                      UNION
                       SELECT zc_Currency_USD() AS CurrencyId, inAmountUSD AS Amount, COALESCE (inCurrencyValueUSD, 1) AS CurrencyValue, CASE WHEN inParValueUSD > 0 THEN inParValueUSD ELSE  1 END AS ParValue WHERE inAmountUSD > 0
                      UNION
                       SELECT zc_Currency_EUR() AS CurrencyId, inAmountEUR AS Amount, COALESCE (inCurrencyValueEUR, 1) AS CurrencyValue, CASE WHEN inParValueEUR > 0 THEN inParValueEUR ELSE  1 END AS ParValue WHERE inAmountEUR > 0
                      )
           -- ����� ��������
         , tmpCash AS (SELECT Object_Cash.Id                          AS CashId
                            , ObjectLink_Cash_Currency.ChildObjectId  AS CurrencyId
                       FROM Object AS Object_Unit
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                 ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Parent.DescId   = zc_ObjectLink_Unit_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                                 ON ObjectLink_Cash_Unit.ChildObjectId = Object_Unit.Id
                                                AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
                            LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit_Parent
                                                 ON ObjectLink_Cash_Unit_Parent.ChildObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                                AND ObjectLink_Cash_Unit_Parent.DescId        = zc_ObjectLink_Cash_Unit()
                                                AND ObjectLink_Cash_Unit.ChildObjectId        IS NULL
                            INNER JOIN Object AS Object_Cash
                                              ON Object_Cash.Id       = COALESCE (ObjectLink_Cash_Unit.ObjectId, ObjectLink_Cash_Unit_Parent.ObjectId)
                                             AND Object_Cash.DescId   = zc_Object_Cash()
                                             AND Object_Cash.isErased = FALSE
                            INNER JOIN ObjectLink AS ObjectLink_Cash_Currency
                                                  ON ObjectLink_Cash_Currency.ObjectId      = Object_Cash.Id
                                                 AND ObjectLink_Cash_Currency.DescId        = zc_ObjectLink_Cash_Currency()
                                                 AND ObjectLink_Cash_Currency.ChildObjectId = zc_Currency_GRN()
                       WHERE Object_Unit.Id = inUnitId
                      )
          -- ����� �����
        , _tmpCash AS (SELECT tmpCash.CashId
                            , tmpPay.CurrencyId
                            , tmpPay.Amount
                            , tmpPay.CurrencyValue
                            , tmpPay.ParValue
                       FROM tmpPay
                            INNER JOIN tmpCash ON tmpCash.CurrencyId = tmpPay.CurrencyId
                      UNION ALL
                       -- ��������� ���� �������� - � ���
                       SELECT ObjectLink_Unit_BankAccount.ChildObjectId     AS CashId
                            , ObjectLink_BankAccount_Currency.ChildObjectId AS CurrencyId
                            , inAmountCard AS Amount
                            , 0            AS CurrencyValue
                            , 0            AS ParValue
                       FROM ObjectLink AS ObjectLink_Unit_BankAccount
                            INNER JOIN ObjectLink AS ObjectLink_BankAccount_Currency
                                                  ON ObjectLink_BankAccount_Currency.ObjectId      = ObjectLink_Unit_BankAccount.ChildObjectId
                                                 AND ObjectLink_BankAccount_Currency.DescId        = zc_ObjectLink_BankAccount_Currency()
                                                 AND ObjectLink_BankAccount_Currency.ChildObjectId = zc_Currency_GRN()
                       WHERE ObjectLink_Unit_BankAccount.ObjectId = inUnitId
                         AND ObjectLink_Unit_BankAccount.DescId   = zc_ObjectLink_Unit_BankAccount()
                         AND inAmountCard                         <> 0
                      )
  -- �����
, tmp_MI_Child_all AS (SELECT _tmp_MI_Child.MovementItemId
                            , _tmp_MI_Child.AmountToPay
                            , CASE WHEN inAmountDiscount = vbTotalAmountToPay THEN _tmp_MI_Child.AmountToPay ELSE CAST (inAmountDiscount * _tmp_MI_Child.AmountToPay / vbTotalAmountToPay AS NUMERIC (16, 2)) END AS AmountDiscount
                            , ROW_NUMBER() OVER (ORDER BY _tmp_MI_Child.AmountToPay DESC) AS Ord
                       FROM _tmp_MI_Child
                      )
      -- �����
    , tmp_MI_Child AS (SELECT tmp_MI_Child_all.MovementItemId
                            , tmp_MI_Child_all.AmountToPay
                            , tmp_MI_Child_all.AmountDiscount
                              - (CASE WHEN tmp_MI_Child_all.Ord = 1
                                           THEN (SELECT SUM (tmp_MI_Child_all.AmountDiscount) AS AmountDiscount FROM tmp_MI_Child_all)
                                              - inAmountDiscount
                                      ELSE 0
                                 END) AS AmountDiscount
                            , tmp_MI_Child_all.AmountDiscount AS AmountDiscount_two 
                            , tmp_MI_Child_all.Ord
                       FROM tmp_MI_Child_all
                      )
       -- ���������
       SELECT
              tmp_MI_Child.MovementItemId AS ParentId
            , 0 :: Integer AS CashId
            , 0 :: Integer AS CurrencyId
            , tmp_MI_Child.AmountToPay
            , 0 :: TFloat AS Amount
            , tmp_MI_Child.AmountDiscount :: TFloat AS AmountDiscount
            , tmp_MI_Child.AmountDiscount_two :: TFloat AS CurrencyValue
            , 0 :: TFloat AS ParValue
            , 0 :: Integer AS CashId_ch
       FROM tmp_MI_Child
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
-- SELECT * FROM lpSelect_MI_Child_calc (inUnitId:= 1, inAmountGRN:= 1, inAmountUSD:= 1, inAmountEUR:= 1, inAmountCard:= 1, inAmountDiscount:= 101.1, inCurrencyValueUSD:= 25, inParValueUSD:= 1, inCurrencyValueEUR:= 30, inParValueEUR:= 1);
