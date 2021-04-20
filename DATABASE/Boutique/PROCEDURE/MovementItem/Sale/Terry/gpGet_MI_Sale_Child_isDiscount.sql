-- Function: gpGet_MI_Sale_Child_isDiscount()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isDiscount(
    IN inIsDiscount        Boolean  , --
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmount            TFloat   , -- сумма к оплате
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (AmountRemains TFloat
             , AmountChange  TFloat
             , AmountDiscount TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSumm TFloat;
   DECLARE vbAmountDiscount TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF inIsDiscount THEN
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

         -- Результат
         RETURN QUERY 
          SELECT CASE WHEN inAmount - (  COALESCE(inAmountGRN,0) 
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
                 END                                            ::TFloat AS AmountChange
               , vbAmountDiscount                               ::TFloat AS AmountDiscount
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
-- SELECT * FROM gpGet_MI_Sale_Child_isDiscount(inIsDiscount := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inAmount := 5247.4 , inAmountGRN := 1.2 , inAmountUSD := 100 , inAmountEUR := 84 , inAmountCard := 0 ,  inSession := '2');
