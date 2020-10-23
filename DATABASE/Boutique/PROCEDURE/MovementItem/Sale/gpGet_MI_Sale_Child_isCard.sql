-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isCard(
    IN inIsCard            Boolean  , --
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmountToPay       TFloat   , -- ����� � ������, ���
    IN inAmountToPay_curr  TFloat   , -- ����� � ������, EUR
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , --
    IN inCurrencyId_Client Integer  , -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountRemains       TFloat
             , AmountRemains_curr  TFloat -- �������, EUR
             , AmountDiff          TFloat -- �����, ���
             , AmountCard          TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountCard TFloat;
   DECLARE vbAmountPay TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ����� ������ - ��� ��� ��� EUR
     vbAmountPay := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                              THEN 
                           zfCalc_SummPriceList (1
                                                 -- ��������� ������� � EUR
/*                                               , zfCalc_CurrencyTo (COALESCE (inAmountGRN, 0)
                                                                  + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                                  + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                                  , inCurrencyValueEUR, 1)
                                               + COALESCE (inAmountDiscount, 0)*/
                                               , COALESCE (inAmountGRN, 0)
                                               + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                               + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                               + zfCalc_CurrencyFrom (inAmountDiscount, inCurrencyValueEUR, 1)
                                               , 0)

                              -- ��������� ��� � ���
                              ELSE COALESCE (inAmountGRN, 0)
                                 + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                 + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                 + COALESCE (inAmountDiscount, 0)
                    END;

     -- ����� - ��� ��� ��� EUR
     IF inIsCard = TRUE
     THEN
         IF inAmountCard = 0
         THEN
             vbAmountCard := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN 
                                         --zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_curr - vbAmountPay, inCurrencyValueEUR, 1), 0)
                                           zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_curr, inCurrencyValueEUR, 1), 0)
                                         - vbAmountPay
                                       ELSE 
                                            inAmountToPay - vbAmountPay
                             END;
         ELSE -- �������� ��� ���������
              vbAmountCard := inAmountCard;
         END IF;
     ELSE
         -- ��������
         vbAmountCard := 0;
     END IF;


     -- ���������
     RETURN QUERY
      WITH -- ������� � ������ - ��� ��� ��� EUR
           tmpData_all AS (SELECT CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN inAmountToPay_curr - (zfCalc_CurrencyTo (COALESCE (inAmountGRN, 0)
                                                                                   + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                                                   + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                                                   + COALESCE (vbAmountCard, 0)
                                                                                   , inCurrencyValueEUR, 1)
                                                                + COALESCE (inAmountDiscount, 0))
                                       ELSE
                                           inAmountToPay - (vbAmountPay + vbAmountCard)
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

                               , vbAmountCard AS AmountCard

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

           , tmpData.AmountCard
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
-- SELECT * FROM gpGet_MI_Sale_Child_isCard(inIsCard := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN := 1.2 , inAmountUSD := 100 , inAmountEUR := 0 , inAmountCard:= 1, inAmountDiscount := 0.4 ,  inCurrencyId_Client:= zc_Currency_EUR(), inSession := '2');
