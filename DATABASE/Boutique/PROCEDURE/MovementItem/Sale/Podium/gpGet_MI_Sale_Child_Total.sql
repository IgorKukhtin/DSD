-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_Total(
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmountToPay_GRN   TFloat   , -- ����� � ������, ���
    IN inAmountToPay_EUR   TFloat   , -- ����� � ������, EUR
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , -- ������ ���
    IN inCurrencyId_Client Integer  , -- 
    IN inSession           TVarChar   -- ������ ������������
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

               -- ������������ ������� - ���������
             , AmountDiscount      TFloat
             , AmountDiscount_curr TFloat

               -- AmountPay - ��� �������
             , AmountPay            TFloat
             , AmountPay_curr       TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY
       WITH tmp1 AS (SELECT -- ����� ������ - � ���
                             COALESCE (inAmountGRN, 0)
                           + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                           + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                           + COALESCE (inAmountCard, 0)
                             AS AmountPay_GRN

                            -- ����� � ������, ��� - �� ���������, ������ �������
                          , zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1) AS AmountToPay_GRN
                            -- ����� � ������, EUR - �� ���������, ������ �������
                          , inAmountToPay_EUR AS AmountToPay_EUR
                    )
          , tmp2 AS (SELECT -- ���� ����� ���������� - ����� �������
                            CASE WHEN tmp1.AmountPay_GRN = zfCalc_SummPriceList (1, tmp1.AmountToPay_GRN)
                                 THEN -- ������� � ����� ������ ���������
                                      tmp1.AmountToPay_GRN - zfCalc_SummPriceList (1, tmp1.AmountToPay_GRN)

                                 -- ���� ��� � USD
                                 WHEN zfCalc_SummPriceList (1, zfCalc_CurrencyTo (tmp1.AmountToPay_GRN, inCurrencyValueUSD, 1)) = inAmountUSD
                                 THEN -- ������� � ����� ������ ���������
                                      tmp1.AmountToPay_GRN - tmp1.AmountPay_GRN

                                 WHEN tmp1.AmountPay_GRN = 0 AND inAmountDiscount < 2 AND tmp1.AmountToPay_GRN > 2
                                 THEN -- "�������" �������� ���
                                      0
                                 ELSE -- �������� ��� ����
                                      inAmountDiscount
                             END AS AmountDiscount_GRN

                            -- ����� ������ - � ���
                          , tmp1.AmountPay_GRN
                            -- ����� � ������, ��� - �� ���������, ������ �������
                          , tmp1.AmountToPay_GRN
                            -- ����� � ������, EUR - �� ���������, ������ �������
                          , tmp1.AmountToPay_EUR
                     FROM tmp1
                    )
             -- ������ - ������� �������� �������� / ���� �����
           , tmp AS (SELECT -- ����� � ������ ����� ����� ������ - ��� � ���
                            tmp2.AmountToPay_GRN - tmp2.AmountPay_GRN - tmp2.AmountDiscount_GRN AS AmountDiff
                            -- ����� � ������, ��� - �� ���������, ������ �������
                          , tmp2.AmountToPay_GRN
                            -- ����� � ������, EUR - �� ���������, ������ �������
                          , tmp2.AmountToPay_EUR
                            -- ����� ������� ��������
                          , tmp2.AmountDiscount_GRN
                            -- ����� ������ - � ���
                          , tmp2.AmountPay_GRN
                     FROM tmp2
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
                        THEN -1 * tmp.AmountDiff

                   ELSE 0
              END :: TFloat AS AmountDiff

              -- AmountDiscount, ���
            , tmp.AmountDiscount_GRN :: TFloat AS AmountDiscount
              -- AmountDiscount, EUR
            , zfCalc_SummIn (1, zfCalc_CurrencyTo (tmp.AmountDiscount_GRN, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountDiscount_curr

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
-- SELECT * FROM gpGet_MI_Sale_Child_Total (inCurrencyValueUSD:= 1, inCurrencyValueEUR:= 1, inAmountToPay_GRN:= 1, inAmountToPay_EUR:= 1, inAmountGRN:= 1, inAmountUSD:= 1, inAmountEUR:= 1, inAmountCard:= 1, inAmountDiscount:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
