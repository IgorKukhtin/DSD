-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_Total(
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmountToPay       TFloat   , -- ����� � ������, ���
    IN inAmountToPay_curr  TFloat   , -- ����� � ������, EUR
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , -- ��� ��� ��� EUR
    IN inCurrencyId_Client Integer  , -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountToPay         TFloat -- � ������, ���
             , AmountToPay_curr    TFloat -- � ������, EUR
             , AmountRemains       TFloat -- �������, ���
             , AmountRemains_curr  TFloat -- �������, EUR
             , AmountDiff          TFloat -- �����, ���
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY
       WITH tmp AS (SELECT CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                THEN
                                    inAmountToPay_curr - (zfCalc_SummPriceList (1, zfCalc_CurrencyTo (inAmountGRN, inCurrencyValueEUR, 1))
                                                        + zfCalc_SummPriceList (1, zfCalc_CurrencyTo (zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1), inCurrencyValueEUR, 1))
                                                        + COALESCE (inAmountEUR, 0)
                                                        + zfCalc_SummPriceList (1, zfCalc_CurrencyTo (inAmountCard, inCurrencyValueEUR, 1))
                                                        + COALESCE (inAmountDiscount, 0)
                                                         )
                                ELSE
                                    inAmountToPay - (COALESCE (inAmountGRN, 0)
                                                   + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                   + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                   + COALESCE (inAmountCard, 0)
                                                   + COALESCE (inAmountDiscount, 0)
                                                    )
                           END AS AmountDiff
                   )
       SELECT -- � ������, ���
              CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                        -- ��������� �� EUR � ���
                        THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_curr, inCurrencyValueEUR, 1))
                   ELSE inAmountToPay
              END :: TFloat AS AmountToPay

              -- � ������, EUR
            , CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                        THEN inAmountToPay_curr
                   ELSE -- ��������� �� ��� � EUR
                        zfCalc_SummPriceList (1, zfCalc_CurrencyTo (inAmountToPay, inCurrencyValueEUR, 1))
              END :: TFloat AS AmountToPay_curr

              -- �������, ���
            , CASE WHEN tmp.AmountDiff > 0 AND inCurrencyId_Client = zc_Currency_EUR()
                        -- ��������� �� EUR � ���
                        THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmp.AmountDiff, inCurrencyValueEUR, 1))

                   WHEN tmp.AmountDiff > 0
                        -- ����� ���� � ���
                        THEN tmp.AmountDiff

                   ELSE 0
              END :: TFloat AS AmountRemains

              -- �������, EUR
            , CASE WHEN tmp.AmountDiff > 0 AND inCurrencyId_Client = zc_Currency_EUR()
                        -- ����� ���� � EUR
                        THEN tmp.AmountDiff

                   WHEN tmp.AmountDiff > 0
                        -- ��������� �� ��� � EUR + ���������� ?
                        THEN zfCalc_SummPriceList (1, zfCalc_CurrencyTo (tmp.AmountDiff, inCurrencyValueEUR, 1))

                   ELSE 0
              END :: TFloat AS AmountRemains_curr


              -- �����, ���
            , CASE WHEN tmp.AmountDiff < 0 AND inCurrencyId_Client = zc_Currency_EUR() 
                        -- ��������� �� EUR � ���
                        THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (-1 * tmp.AmountDiff, inCurrencyValueEUR, 1))

                   WHEN tmp.AmountDiff < 0
                        -- ����� ���� � ���
                        THEN -1 * tmp.AmountDiff

                   ELSE 0
              END :: TFloat AS AmountDiff

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
-- SELECT * FROM gpGet_MI_Sale_Child_Total (inCurrencyValueUSD:= 1, inCurrencyValueEUR:= 1, inAmountToPay:= 1, inAmountToPay_curr:= 1, inAmountGRN:= 1, inAmountUSD:= 1, inAmountEUR:= 1, inAmountCard:= 1, inAmountDiscount:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
