-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_Total(
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmountToPay       TFloat   , --
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , --
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountRemains       TFloat -- �������, ���
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
       WITH tmp AS (SELECT inAmountToPay - (COALESCE (inAmountGRN, 0)
                                          + COALESCE (inAmountUSD, 0) * COALESCE (inCurrencyValueUSD, 0)
                                          + COALESCE (inAmountEUR, 0) * COALESCE (inCurrencyValueEUR, 0)
                                          + COALESCE (inAmountCard, 0)
                                          + COALESCE (inAmountDiscount, 0)) AS AmountDiff
                   )
       SELECT -- �������, ���
              CASE WHEN tmp.AmountDiff > 0 THEN tmp.AmountDiff ELSE 0 END :: TFloat AS AmountRemains

              -- �������, EUR
            , zfCalc_SummPriceList (1, 
              zfCalc_CurrencySumm (CASE WHEN tmp.AmountDiff > 0 THEN tmp.AmountDiff ELSE 0 END, zc_Currency_Basis(), zc_Currency_EUR(), inCurrencyValueEUR, 1)) :: TFloat AS AmountRemains_curr

              -- �����, ���
            , CASE WHEN tmp.AmountDiff < 0 THEN -1 * tmp.AmountDiff ELSE 0 END :: TFloat AS AmountDiff
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
-- SELECT * FROM gpGet_MI_Sale_Child_Total (inCurrencyValueUSD:= 1, inCurrencyValueEUR:= 1, inAmountToPay:= 1, inAmountGRN:= 1, inAmountUSD:= 1, inAmountEUR:= 1, inAmountCard:= 1, inAmountDiscount:= 1, inSession:= zfCalc_UserAdmin());
