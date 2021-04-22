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
RETURNS TABLE (AmountRemains       TFloat -- �������, ���
             , AmountRemains_curr  TFloat -- �������, EUR
             , AmountDiff          TFloat -- �����, ���
             , AmountCard          TFloat -- ��������� �����
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountPay_GRN TFloat;
   DECLARE vbAmountCard TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ����� ������ - ���
     vbAmountPay_GRN := COALESCE (inAmountGRN, 0)
                      + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                      + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                      + COALESCE (inAmountDiscount, 0)
                       ;

     -- ����� - ���
     IF inIsCard = TRUE
     THEN
         IF inAmountCard = 0
         THEN
             vbAmountCard := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN -- ��������� � 0 ������, ������� ������� ��������� � ��������
                                            zfCalc_SummPriceList (1, inAmountToPay - vbAmountPay_GRN)

                                       ELSE -- �� ���������
                                            inAmountToPay - vbAmountPay_GRN
                             END;
         ELSE -- �������� ��� ���������
              vbAmountCard := inAmountCard;
         END IF;
     ELSE
         -- ��������
         vbAmountCard := 0;
     END IF;

     -- ���������
     IF vbAmountCard < 0 THEN vbAmountCard:= 0; END IF;


     -- ���������
     RETURN QUERY
      WITH -- ������� � ������ - ���
           tmpData_all AS (SELECT inAmountToPay - (vbAmountPay_GRN + vbAmountCard) AS AmountDiff
                          )
              -- ������ - ��� ���
            , tmpData AS (SELECT CASE WHEN tmpData_all.AmountDiff > 0
                                      THEN tmpData_all.AmountDiff
                                      ELSE 0
                                 END AS AmountRemains

                               , CASE WHEN tmpData_all.AmountDiff < 0
                                      THEN -1 * tmpData_all.AmountDiff
                                      ELSE 0
                                 END AS AmountDiff

                                 -- ��������� �����
                               , vbAmountCard AS AmountCard

                          FROM tmpData_all
                         )
      -- ���������
      SELECT -- �������, ���
             tmpData.AmountRemains :: TFloat AS AmountRemains
             -- �������, EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (tmpData.AmountRemains, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountRemains_curr

             -- �����, ���
           , tmpData.AmountDiff :: TFloat AS AmountDiff

             -- ��������� ����� ��
           , tmpData.AmountCard

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
-- SELECT * FROM gpGet_MI_Sale_Child_isCard(inIsCard := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN := 1.2 , inAmountUSD := 100 , inAmountEUR := 0 , inAmountCard:= 1, inAmountDiscount := 0.4 ,  inCurrencyId_Client:= zc_Currency_EUR(), inSession := '2');
