-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isDiscount(
    IN inIsDiscount        Boolean  , --
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmount            TFloat   , -- ����� � ������, ���
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , -- ��� ��� ��� EUR
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountRemains       TFloat -- �������, ���
             , AmountRemains_curr  TFloat -- �������, EUR
             , AmountDiff          TFloat -- �����, ���
             , AmountDiscount      TFloat -- �������������� ������ !!! ��� ��� ��� EUR !!!
             , AmountDiscount_curr TFloat -- �������������� ������ !!! ��� ��� ��� EUR !!!
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSumm TFloat;
   DECLARE vbAmountDiscount TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF inisDiscount THEN
         IF inAmountDiscount = 0 THEN
         vbAmountDiscount := CAST ((inAmount - (COALESCE (inAmountGRN,0)
                                           + (COALESCE (inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1)) 
                                           + (COALESCE (inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                           +  COALESCE (inAmountCard,0))
                                    ) AS NUMERIC (16, 2)) ;
         ELSE vbAmountDiscount := inAmountDiscount;
         END IF;
     ELSE 
         vbAmountDiscount := 0;
     END IF;


         -- ���������
         RETURN QUERY 
          WITH tmpData AS (SELECT CASE WHEN inAmount - (  COALESCE(inAmountGRN,0) 
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                                     +  COALESCE(inAmountCard,0)
                                                     +  COALESCE(vbAmountDiscount,0) ) > 0 
                                       THEN inAmount - (  COALESCE(inAmountGRN,0) 
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                                     +  COALESCE(inAmountCard,0) 
                                                     +  COALESCE(vbAmountDiscount,0) )
                                       ELSE 0
                                  END                                            ::TFloat AS AmountRemains          
                                , CASE WHEN inAmount - (  COALESCE(inAmountGRN,0) 
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                                     +  COALESCE(inAmountCard,0)
                                                     +  COALESCE(vbAmountDiscount,0) ) < 0 
                                       THEN (inAmount - ( COALESCE(inAmountGRN,0) 
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                                     +  COALESCE(inAmountCard,0) 
                                                     +  COALESCE(vbAmountDiscount,0) )) * (-1)
                                       ELSE 0
                                  END                                            ::TFloat AS AmountDiff
                                , vbAmountDiscount                               ::TFloat AS AmountDiscount
                          )
          -- ���������
          SELECT -- �������, ���
                 tmpData.AmountRemains          
                 -- �������, EUR
               , zfCalc_SummPriceList (1, 
                 zfCalc_CurrencySumm (tmpData.AmountRemains, zc_Currency_Basis(), zc_Currency_EUR(), inCurrencyValueEUR, 1)) :: TFloat AS AmountRemains_curr

                 -- �����, ���
               , tmpData.AmountDiff

                 --
               , tmpData.AmountDiscount
               , zfCalc_CurrencySumm (tmpData.AmountDiscount, zc_Currency_Basis(), zc_Currency_EUR(), inCurrencyValueEUR, 1) :: TFloat AS AmountDiscount_curr
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
-- SELECT * FROM gpGet_MI_Sale_Child_isDiscount(inIsDiscount:= TRUE, inCurrencyValueUSD:= 26.25, inCurrencyValueEUR:= 31.2, inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN:= 1.2, inAmountUSD:= 100, inAmountEUR:= 84, inAmountCard:= 0, inAmountDiscount:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
