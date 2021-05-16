-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_Total(
    IN inCurrencyValueUSD    TFloat   , --
    IN inCurrencyValueEUR    TFloat   , --
    IN inCurrencyValueCross  TFloat   , --
    IN inAmountToPay_GRN     TFloat   , -- ����� � ������, ���
    IN inAmountToPay_EUR     TFloat   , -- ����� � ������, EUR
    IN inAmountGRN           TFloat   , --
    IN inAmountUSD           TFloat   , --
    IN inAmountEUR           TFloat   , --
    IN inAmountCard          TFloat   , --
    IN inAmountDiscount      TFloat   , -- ������ ���
    IN inCurrencyId_Client   Integer  , --
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS TABLE (-- ������������ - ��� �������
               AmountToPay         TFloat -- � ������, ���
             , AmountToPay_curr    TFloat -- � ������, EUR
               -- ���� - ������ ����
             , AmountToPay_GRN     TFloat
             , AmountToPay_EUR     TFloat
               --
             , AmountRemains       TFloat -- �������, ���
             , AmountRemains_curr  TFloat -- �������, EUR

               -- �����, ���
             , AmountDiff          TFloat

               -- �������������� ������
             , AmountDiscount      TFloat
             , AmountDiscount_curr TFloat
             
               -- ����, ����� ����� ������������� ��-�� �����-�����
             , CurrencyValueUSD TFloat

               -- AmountPay - ��� �������
             , AmountPay            TFloat
             , AmountPay_curr       TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCurrencyValueUSD NUMERIC (20, 10);
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- !������! ����, ����� ������������� ��-�� �����-�����, 2 �����
     vbCurrencyValueUSD:= zfCalc_CurrencyTo_Cross (inCurrencyValueEUR, inCurrencyValueCross);


     -- ���� ������ = 0 + �� ��� ��������
     IF inAmountToPay_GRN <> inAmountDiscount
        AND inAmountGRN      = 0
        AND inAmountUSD      = 0
        AND inAmountEUR      = 0
        AND inAmountCard     = 0
     THEN
         -- ��������
         inAmountDiscount:= 0;

     -- ���� ���� USD, ������ inAmountDiscount, �.�. �����-����
     ELSEIF inAmountUSD > 0 AND inAmountDiscount = 0 -- inAmountGRN = 0 AND 1=0
     THEN
         inAmountDiscount:= zfCalc_CurrencyFrom (-- ��������� �� ����� EUR
                                                 zfCalc_CurrencyCross (inAmountUSD, inCurrencyValueCross, 1)
                                               , inCurrencyValueEUR, 1)
                          - zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, 1)
                           ;
     END IF;


     -- ���������
     RETURN QUERY
      WITH tmp1 AS (SELECT -- ����� ������ - � ���
                            COALESCE (inAmountGRN, 0)
                        /*+ zfCalc_CurrencyFrom (-- ��������� �� ����� EUR
                                                 zfCalc_CurrencyCross (inAmountUSD, inCurrencyValueCross, 1)
                                               , inCurrencyValueEUR, 1)*/
                          + zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, 1)
                          + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                          + COALESCE (inAmountCard, 0)
                            AS AmountPay_GRN

                           -- ����� � ������, ��� - �� ���������, ������ �������
                         , zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1) AS AmountToPay_GRN
                           -- ����� � ������, EUR - �� ���������, ������ �������
                         , inAmountToPay_EUR AS AmountToPay_EUR
                           -- ����� ������� ��������
                         , inAmountDiscount  AS AmountDiscount_GRN
                   )
            -- ������ - ������� �������� �������� / ���� �����
          , tmp AS (SELECT -- ����� � ������ ����� ����� ������ - ��� � ���
                           tmp1.AmountToPay_GRN - tmp1.AmountPay_GRN - tmp1.AmountDiscount_GRN AS AmountDiff
                           -- ����� � ������, ��� - �� ���������, ������ �������
                         , tmp1.AmountToPay_GRN
                           -- ����� � ������, EUR - �� ���������, ������ �������
                         , tmp1.AmountToPay_EUR
                           -- ����� ������� ��������
                         , tmp1.AmountDiscount_GRN
                           -- ����� ������ - � ���
                         , tmp1.AmountPay_GRN

                    FROM tmp1
                   )

      SELECT -- � ������, ��� - ����� ���������
             zfCalc_SummPriceList (1, tmp.AmountToPay_GRN) :: TFloat AS AmountToPay
             -- � ������, EUR - ����� ���������
           , zfCalc_SummPriceList (1, tmp.AmountToPay_EUR) :: TFloat AS AmountToPay_curr

             -- � ������, ��� - �� ���������
           , tmp.AmountToPay_GRN :: TFloat AS AmountToPay_GRN
             -- � ������, EUR - �� ���������
           , tmp.AmountToPay_EUR :: TFloat AS AmountToPay_EUR

             -- ������� �������� ��������, ���
           , CASE WHEN tmp.AmountDiff > 0 AND tmp.AmountToPay_GRN = tmp.AmountDiff
                        THEN -- ����� ���������
                             zfCalc_SummPriceList (1, tmp.AmountDiff)
                   WHEN tmp.AmountDiff > 0
                       -- �� ���������
                       THEN tmp.AmountDiff
                  ELSE 0
             END :: TFloat AS AmountRemains

             -- ������� �������� ��������, EUR - �� ���������
           , CASE WHEN tmp.AmountDiff > 0
                       -- ��������� �� ��� � EUR + ���������� ?
                       THEN zfCalc_SummIn (1, zfCalc_CurrencyTo (tmp.AmountDiff, inCurrencyValueEUR, 1), 1)
                  ELSE 0
             END :: TFloat AS AmountRemains_curr

             -- �����, ���
           , CASE WHEN tmp.AmountDiff < 0
                       -- ����� ���� � ���
                     --THEN -1 * (tmp.AmountDiff - (tmp.AmountDiff - FLOOR (ROUND(tmp.AmountDiff/10, 0)*10)))
                       THEN -1 * tmp.AmountDiff

                  ELSE 0
             END :: TFloat AS AmountDiff

             -- �������������� ������ - ���
           , CASE WHEN tmp.AmountDiff < 0 AND tmp.AmountDiff <> FLOOR (ROUND(tmp.AmountDiff/10, 0)*10) AND inAmountToPay_GRN > 0
                       -- ��������� � ������ ���, ���� ����� �������� �� 10���
                       THEN inAmountDiscount + (tmp.AmountDiff - FLOOR (ROUND(tmp.AmountDiff/10, 0)*10))

                  WHEN tmp.AmountDiff > 0 AND zfCalc_CurrencyTo (tmp.AmountDiff, inCurrencyValueEUR, 1) <> FLOOR (zfCalc_CurrencyTo (tmp.AmountDiff, inCurrencyValueEUR, 1))
                       -- ��������� � ������ ���, ���� ������� EUR - ��� �����
                       THEN inAmountDiscount + (tmp.AmountDiff - zfCalc_CurrencyFrom (ROUND (zfCalc_CurrencyTo (tmp.AmountDiff, inCurrencyValueEUR, 1), 0), inCurrencyValueEUR, 1))

                  ELSE inAmountDiscount
             END :: TFloat AS AmountDiscount

             -- �������������� ������ - EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (
             CASE WHEN tmp.AmountDiff < 0 AND tmp.AmountDiff <> FLOOR (ROUND(tmp.AmountDiff/10, 0)*10) AND inAmountToPay_GRN > 0
                       THEN inAmountDiscount + (tmp.AmountDiff - FLOOR (ROUND(tmp.AmountDiff/10, 0)*10))
                  ELSE inAmountDiscount
             END, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountDiscount_curr

             -- ����, ����� ����� ������������� ��-�� �����-�����
           , inCurrencyValueUSD :: TFLoat AS CurrencyValueUSD

             -- AmountPay, ���
           , tmp.AmountPay_GRN :: TFloat AS AmountPay
             -- AmountPay, EUR
           , zfCalc_CurrencyTo (tmp.AmountPay_GRN, inCurrencyValueEUR, 1) :: TFloat AS AmountPay_curr

      FROM tmp;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE; 

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 22.05.17         *
*/

-- ����
-- SELECT * FROM gpGet_MI_Sale_Child_Total (inCurrencyValueUSD:= 1, inCurrencyValueEUR:= 1, inCurrencyValueCross:= 1, inAmountToPay_GRN:= 1, inAmountToPay_EUR:= 1, inAmountGRN:= 1, inAmountUSD:= 1, inAmountEUR:= 1, inAmountCard:= 1, inAmountDiscount:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
