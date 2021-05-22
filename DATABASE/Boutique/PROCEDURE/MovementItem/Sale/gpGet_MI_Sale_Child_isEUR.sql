-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isEUR(
    IN inIsEUR             Boolean  , --
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmount            TFloat   , -- сумма к оплате, грн
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , -- или ГРН или EUR
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (AmountRemains       TFloat -- Остаток, грн
             , AmountRemains_curr  TFloat -- Остаток, EUR
             , AmountDiff          TFloat -- Сдача, грн
             , AmountEUR           TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSumm TFloat;
   DECLARE vbAmountEUR TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF inisEUR THEN
         IF inAmountEUR = 0 THEN
         vbAmountEUR := CAST (CASE WHEN COALESCE(inCurrencyValueEUR,1) <> 0
                                   THEN (inAmount - (COALESCE (inAmountGRN,0)
                                                + (COALESCE (inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                +  COALESCE (inAmountCard,0)
                                                +  COALESCE (inAmountDiscount,0)))
                                         /  COALESCE(inCurrencyValueEUR,1)
                                   ELSE 0
                              END AS NUMERIC (16, 0)) ;
         ELSE vbAmountEUR := inAmountEUR;
         END IF;
     ELSE
         vbAmountEUR := 0;
     END IF;


         -- Результат
         RETURN QUERY
          WITH tmpData AS (SELECT CASE WHEN inAmount - (  COALESCE(inAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(vbAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(inAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) ) > 0
                                       THEN inAmount - (  COALESCE(inAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(vbAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(inAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) )
                                       ELSE 0
                                  END                                            ::TFloat AS AmountRemains
                                , CASE WHEN inAmount - (  COALESCE(inAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(vbAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(inAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) ) < 0
                                       THEN (inAmount - ( COALESCE(inAmountGRN,0)
                                                     + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                                     + (COALESCE(vbAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                                     +  COALESCE(inAmountCard,0)
                                                     +  COALESCE(inAmountDiscount,0) )) * (-1)
                                       ELSE 0
                                  END                                            ::TFloat AS AmountDiff
                                , vbAmountEUR                                    ::TFloat AS AmountEUR
                          )
          -- Результат
          SELECT -- Остаток, грн
                 tmpData.AmountRemains
                 -- Остаток, EUR
               , zfCalc_SummPriceList (1, 
                 zfCalc_CurrencySumm (tmpData.AmountRemains, zc_Currency_Basis(), zc_Currency_EUR(), inCurrencyValueEUR, 1)) :: TFloat AS AmountRemains_curr

                 -- Сдача, грн
               , tmpData.AmountDiff

               , tmpData.AmountEUR
          FROM tmpData
         ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 29.05.17         *
*/

-- тест
-- SELECT * FROM gpGet_MI_Sale_Child_isEUR (inIsEUR:= TRUE, inCurrencyValueUSD:= 26.25, inCurrencyValueEUR:= 31.2, inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN:= 1.2, inAmountUSD:= 100, inAmountEUR:= 10, inAmountCard:= 0, inAmountDiscount:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
