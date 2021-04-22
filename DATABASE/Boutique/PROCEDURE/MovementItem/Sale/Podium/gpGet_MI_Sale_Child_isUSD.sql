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
             , AmountUSD           TFloat -- ��������� �����
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountPay_GRN TFloat;
   DECLARE vbAmountUSD TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ����� ������ - ���
     vbAmountPay_GRN := COALESCE (inAmountGRN, 0)
                      + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                      + COALESCE (inAmountCard, 0)
                      + COALESCE (inAmountDiscount, 0)
                       ;

     -- ����� - USD
     IF inIsUSD = TRUE
     THEN
         IF inAmountUSD = 0
         THEN
              vbAmountUSD := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN -- ��������� � 0 ������, ������� ������� ��������� � ��������
                                            zfCalc_SummPriceList (1, zfCalc_CurrencyTo (inAmountToPay - vbAmountPay_GRN, inCurrencyValueUSD, 1))

                                       ELSE -- �� ���������
                                            zfCalc_CurrencyTo (inAmountToPay - vbAmountPay_GRN, inCurrencyValueUSD, 1)
                             END;
         ELSE -- �������� ��� ���������
              vbAmountUSD := inAmountUSD;
         END IF;
     ELSE
         -- ��������
         vbAmountUSD := 0;
     END IF;
     
     -- ���������
     IF vbAmountUSD < 0 THEN vbAmountUSD:= 0; END IF;


     -- ���������
     RETURN QUERY
      WITH -- ������� � ������ - ���
           tmpData_all AS (SELECT inAmountToPay - (vbAmountPay_GRN + zfCalc_CurrencyFrom (vbAmountUSD, inCurrencyValueUSD, 1)) AS AmountDiff
                          )
              -- ������ - ��� ��� ��� EUR
            , tmpData AS (SELECT CASE WHEN tmpData_all.AmountDiff > 0
                                      THEN tmpData_all.AmountDiff
                                      ELSE 0
                                 END AS AmountRemains

                               , CASE WHEN tmpData_all.AmountDiff < 0
                                      THEN -1 * tmpData_all.AmountDiff
                                      ELSE 0
                                 END AS AmountDiff

                                 -- ��������� �����
                               , vbAmountUSD AS AmountUSD

                          FROM tmpData_all
                         )
      -- ���������
      SELECT -- �������, ���
             tmpData.AmountRemains :: TFloat AS AmountRemains 
             -- �������, EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (tmpData.AmountRemains, inCurrencyValueUSD, 1), 1) :: TFloat AS AmountRemains_curr

             -- �����, ���
           , tmpData.AmountDiff :: TFloat AS AmountDiff

             -- ��������� ����� USD
           , tmpData.AmountUSD

      FROM tmpData;


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
