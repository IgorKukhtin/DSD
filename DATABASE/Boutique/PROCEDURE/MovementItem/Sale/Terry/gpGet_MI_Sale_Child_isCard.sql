-- Function: gpGet_MI_Sale_Child_isCard()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isCard(
    IN inIsCard            Boolean  , --
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
             , AmountCard    TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSumm TFloat;
   DECLARE vbAmountCard TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF inIsCard THEN
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
          SELECT CASE WHEN inAmount - (  COALESCE(inAmountGRN,0) 
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
                 END                                            ::TFloat AS AmountChange
               , vbAmountCard                                   ::TFloat AS AmountCard
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
-- SELECT * FROM gpGet_MI_Sale_Child_isCard(inIsCard := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inAmount := 5247.4 , inAmountGRN := 1.2 , inAmountUSD := 100 , inAmountEUR := 0 , inAmountDiscount := 0.4 ,  inSession := '2');
