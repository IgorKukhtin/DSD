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
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF inisCard THEN
         IF inAmountCard = 0 THEN
         vbAmountCard := CAST ((inAmount - (COALESCE (inAmountGRN,0)
                                         + (COALESCE (inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                         + (COALESCE (inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                         +  COALESCE (inAmountDiscount,0))
                               ) AS NUMERIC (16, 2)) ;
         ELSE vbAmountCard := inAmountCard;
         END IF;
     ELSE
         vbAmountCard := 0;
     END IF;


         -- ���������
         RETURN QUERY
          WITH tmpData AS (SELECT CASE WHEN inAmount - (  COALESCE(inAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(vbAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) ) > 0
                                       THEN inAmount - (  COALESCE(inAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(vbAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) )
                                       ELSE 0
                                  END                                            ::TFloat AS AmountRemains
                                , CASE WHEN inAmount - (  COALESCE(inAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(vbAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) ) < 0
                                       THEN (inAmount - ( COALESCE(inAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(vbAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) )) * (-1)
                                       ELSE 0
                                  END                                            ::TFloat AS AmountDiff
                                , vbAmountCard                                   ::TFloat AS AmountCard
                          )
          -- ���������
          SELECT -- �������, ���
                 tmpData.AmountRemains
                 -- �������, EUR
               , zfCalc_SummPriceList (1, 
                 zfCalc_CurrencySumm (tmpData.AmountRemains, zc_Currency_Basis(), zc_Currency_EUR(), inCurrencyValueEUR, 1)) :: TFloat AS AmountRemains_curr

                 -- �����, ���
               , tmpData.AmountDiff
                 -- �����, ���
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
