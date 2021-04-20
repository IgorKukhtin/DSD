-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isUSD (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isUSD (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isUSD (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isUSD (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isUSD(
    IN inIsUSD             Boolean  , --
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
RETURNS TABLE (AmountRemains       TFloat -- �������, ���
             , AmountRemains_curr  TFloat -- �������, EUR
             , AmountDiff          TFloat -- �����, ���
             , AmountUSD           TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountUSD TFloat;
   DECLARE vbAmountPay TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ����� ������ - ��� ��� ��� EUR
     vbAmountPay := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                              THEN 
                                  zfCalc_SummIn (1
                                                 -- ��������� ������� � EUR
                                               , zfCalc_CurrencyTo (COALESCE (inAmountGRN, 0)
                                                                  + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                                  + COALESCE (inAmountCard, 0)
                                                                  , inCurrencyValueEUR, 1)
                                               + COALESCE (inAmountDiscount, 0)
                                               , 1)

                              -- ��������� ��� � ���
                              ELSE COALESCE (inAmountGRN, 0)
                                 + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                 + inAmountCard
                                 + COALESCE (inAmountDiscount, 0)
                    END;

     -- ����� - USD
     IF inIsUSD = TRUE
     THEN
         IF inAmountUSD = 0
         THEN
              vbAmountUSD := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN -- ��������� �����
                                            CEIL (zfCalc_CurrencyTo (zfCalc_CurrencyFrom (inAmountToPay_curr - vbAmountPay, inCurrencyValueEUR, 1)
                                                                   , inCurrencyValueUSD, 1))
                                       ELSE -- ��������� �� 0 ������
                                            CAST (zfCalc_CurrencyTo (inAmountToPay - vbAmountPay, inCurrencyValueUSD, 1) AS NUMERIC (16, 0))
                             END;
         ELSE -- �������� ��� ���������
              vbAmountUSD := inAmountUSD;
         END IF;
     ELSE
         -- ��������
         vbAmountUSD := 0;
     END IF;


     -- ���������
     RETURN QUERY
      WITH -- ������� � ������ - ��� ��� ��� EUR
           tmpData_all AS (SELECT CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN inAmountToPay_curr - (vbAmountPay + CAST (zfCalc_CurrencyTo (zfCalc_CurrencyFrom (vbAmountUSD, inCurrencyValueUSD, 1)
                                                                                    , inCurrencyValueUSD, 1) AS NUMERIC (16, 0)))
                                       ELSE inAmountToPay      - (vbAmountPay + zfCalc_CurrencyFrom (vbAmountUSD, inCurrencyValueUSD, 1))
                                  END AS AmountRemains
                          )
              -- ������ - ��� ��� ��� EUR
            , tmpData AS (SELECT CASE WHEN tmpData_all.AmountRemains > 0
                                      THEN tmpData_all.AmountRemains
                                      ELSE 0
                                 END AS AmountRemains

                               , CASE WHEN tmpData_all.AmountRemains < 0
                                      THEN -1 * tmpData_all.AmountRemains
                                      ELSE 0
                                 END AS AmountDiff

                               , vbAmountUSD AS AmountUSD

                          FROM tmpData_all
                         )
      -- ���������
      SELECT -- �������, ���
             CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                       THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmpData.AmountRemains, inCurrencyValueEUR, 1), 0)
                       ELSE tmpData.AmountRemains
             END :: TFloat AS AmountRemains
             -- �������, EUR
           , CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                       THEN tmpData.AmountRemains
                       ELSE zfCalc_SummIn (1, zfCalc_CurrencyTo (tmpData.AmountRemains, inCurrencyValueEUR, 1), 1)
             END :: TFloat AS AmountRemains_curr

             -- �����, ���
           , CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                       THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmpData.AmountDiff, inCurrencyValueEUR, 1), 0)
                       ELSE tmpData.AmountDiff
             END :: TFloat AS AmountDiff

           , tmpData.AmountUSD
      FROM tmpData
     ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 29.05.17         *
*/

-- ����
-- SELECT * FROM gpGet_MI_Sale_Child_isUSD (inIsUSD:= TRUE, inCurrencyValueUSD:= 26.25, inCurrencyValueEUR:= 31.2, inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN:= 1.2, inAmountEUR:= 0, inAmountUSD:= 10, inAmountCard:= 0, inAmountDiscount:= 0.4, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
