-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isCard(
    IN inIsCard            Boolean  , --
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmountToPay       TFloat   , -- сумма к оплате, грн
    IN inAmountToPay_curr  TFloat   , -- сумма к оплате, EUR
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , --
    IN inCurrencyId_Client Integer  , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (AmountRemains       TFloat
             , AmountRemains_curr  TFloat -- Остаток, EUR
             , AmountDiff          TFloat -- Сдача, грн
             , AmountCard          TFloat
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
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


         -- Результат
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
          -- Результат
          SELECT -- Остаток, грн
                 tmpData.AmountRemains
                 -- Остаток, EUR
               , zfCalc_SummPriceList (1, 
                 zfCalc_CurrencySumm (tmpData.AmountRemains, zc_Currency_Basis(), zc_Currency_EUR(), inCurrencyValueEUR, 1)) :: TFloat AS AmountRemains_curr

                 -- Сдача, грн
               , tmpData.AmountDiff
                 -- Сдача, грн
               , tmpData.AmountCard
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
-- SELECT * FROM gpGet_MI_Sale_Child_isCard(inIsCard := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN := 1.2 , inAmountUSD := 100 , inAmountEUR := 0 , inAmountCard:= 1, inAmountDiscount := 0.4 ,  inCurrencyId_Client:= zc_Currency_EUR(), inSession := '2');
