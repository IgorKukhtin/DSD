-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isUSD (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isUSD (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isUSD(
    IN inIsUSD             Boolean  , --
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmount            TFloat   , -- ����� � ������
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , --
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountRemains       TFloat
             , AmountRemains_curr  TFloat -- �������, EUR
             , AmountDiff          TFloat -- �����, ���
             , AmountUSD           TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSumm TFloat;
   DECLARE vbAmountUSD TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF inIsUSD THEN
         IF inAmountUSD = 0 THEN
         vbAmountUSD := CAST (CASE WHEN COALESCE(inCurrencyValueUSD,1) <> 0
                                   THEN (inAmount - (COALESCE (inAmountGRN,0)
                                                   + (COALESCE (inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                   + COALESCE (inAmountCard,0)
                                                   + COALESCE (inAmountDiscount,0)
                                                    ))
                                         /  COALESCE(inCurrencyValueUSD,1)
                                   ELSE 0
                              END AS NUMERIC (16, 0)) ;
         ELSE vbAmountUSD := inAmountUSD;
         END IF;
     ELSE
         vbAmountUSD := 0;
     END IF;

         -- ���������
         RETURN QUERY
          WITH tmpData AS (SELECT CASE WHEN inAmount - (COALESCE(inAmountGRN,0)
                                                      + (COALESCE(vbAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                      + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                      +  COALESCE(inAmountCard,0)
                                                      +  COALESCE(inAmountDiscount,0)
                                                       ) > 0
                                       THEN inAmount - (COALESCE(inAmountGRN,0)
                                                      + (COALESCE(vbAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                      + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                      +  COALESCE(inAmountCard,0)
                                                      +  COALESCE(inAmountDiscount,0)
                                                       )
                                       ELSE 0
                                  END                                            ::TFloat AS AmountRemains
                                , CASE WHEN inAmount - (COALESCE(inAmountGRN,0)
                                                      + (COALESCE(vbAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                      + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                      +  COALESCE(inAmountCard,0)
                                                      +  COALESCE(inAmountDiscount,0)
                                                       ) < 0
                                       THEN (inAmount - (COALESCE(inAmountGRN,0)
                                                       + (COALESCE(vbAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                       + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                       +  COALESCE(inAmountCard,0)
                                                       +  COALESCE(inAmountDiscount,0) )) * (-1)
                                       ELSE 0
                                  END                                            ::TFloat AS AmountDiff
                                , vbAmountUSD                                    ::TFloat AS AmountUSD
                          )
          -- ���������
          SELECT -- �������, ���
                 tmpData.AmountRemains
                 -- �������, EUR
               , zfCalc_SummPriceList (1, 
                 zfCalc_CurrencySumm (tmpData.AmountRemains, zc_Currency_Basis(), zc_Currency_EUR(), inCurrencyValueEUR, 1)) :: TFloat AS AmountRemains_curr

                 -- �����, ���
               , tmpData.AmountDiff

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
-- SELECT * FROM gpGet_MI_Sale_Child_isUSD (inIsUSD:= TRUE, inCurrencyValueUSD:= 26.25, inCurrencyValueEUR:= 31.2, inAmount:= 5247.4, inAmountGRN:= 1.2, inAmountEUR:= 0, inAmountUSD:= 10, inAmountCard:= 0, inAmountDiscount:= 0.4, inSession:= '2');
