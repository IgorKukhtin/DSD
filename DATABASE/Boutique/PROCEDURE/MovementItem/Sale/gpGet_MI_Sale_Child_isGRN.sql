-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isGRN(
    IN inIsGRN             Boolean  , --
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
             , AmountGRN           TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSumm TFloat;
   DECLARE vbAmountGRN TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF inisGRN = TRUE THEN
         IF inAmountGRN = 0 THEN
         vbAmountGRN := (inAmount - ( (COALESCE (inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE (inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                    +  COALESCE (inAmountCard,0)
                                    +  COALESCE (inAmountDiscount,0)) );
          ELSE vbAmountGRN := inAmountGRN;
          END IF;
     ELSE
         vbAmountGRN := 0;
     END IF;

         -- ���������
         RETURN QUERY
          WITH tmpData AS (SELECT CASE WHEN inAmount - (  COALESCE(vbAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(inAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) ) > 0
                                       THEN inAmount - (  COALESCE(vbAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(inAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) )
                                       ELSE 0
                                  END                                            ::TFloat AS AmountRemains
                                , CASE WHEN inAmount - (  COALESCE(vbAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(inAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) ) < 0
                                       THEN (inAmount - ( COALESCE(vbAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(inAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) )) * (-1)
                                       ELSE 0
                                  END                                            ::TFloat AS AmountDiff
                                , vbAmountGRN                                    ::TFloat AS AmountGRN
                          )
          -- ���������
          SELECT -- �������, ���
                 tmpData.AmountRemains
                 -- �������, EUR
               , zfCalc_SummPriceList (1, 
                 zfCalc_CurrencySumm (tmpData.AmountRemains, zc_Currency_Basis(), zc_Currency_EUR(), inCurrencyValueEUR, 1)) :: TFloat AS AmountRemains_curr

                 -- �����, ���
               , tmpData.AmountDiff

               , tmpData.AmountGRN
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
-- SELECT * FROM gpGet_MI_Sale_Child_isGRN(inIsGRN := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN := 100 ,inAmountUSD := 100 , inAmountEUR := 84 , inAmountCard := 0 , inAmountDiscount := 0.4 , inCurrencyId_Client:= zc_Currency_EUR(), inSession := '2');
