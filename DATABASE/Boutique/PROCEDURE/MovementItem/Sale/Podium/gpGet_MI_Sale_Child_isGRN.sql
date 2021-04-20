-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isGRN(
    IN inIsGRN             Boolean  , --
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
             , AmountGRN           TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountGRN TFloat;
   DECLARE vbAmountPay TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- сумма оплаты - или ГРН или EUR
     vbAmountPay := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                              THEN 
                           zfCalc_SummPriceList (1
                                                 -- переводим обратно в EUR
/*                                               , zfCalc_CurrencyTo (zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                                  + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                                  + COALESCE (inAmountCard, 0)
                                                                  , inCurrencyValueEUR, 1)
                                               + COALESCE (inAmountDiscount, 0)*/
                                               , zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                               + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                               + COALESCE (inAmountCard, 0)
                                               + zfCalc_CurrencyFrom (inAmountDiscount, inCurrencyValueEUR, 1)
                                               , 0)

                              -- переводим все в ГРН
                              ELSE zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                 + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                 + COALESCE (inAmountCard, 0)
                                 + COALESCE (inAmountDiscount, 0)
                    END;


     -- Сумма - или ГРН или EUR
     IF inIsGRN = TRUE
     THEN
         IF inAmountGRN = 0
         THEN
             vbAmountGRN := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                      THEN 
                                         --zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_curr - vbAmountPay, inCurrencyValueEUR, 1), 0)
                                           zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_curr, inCurrencyValueEUR, 1), 0)
                                         - vbAmountPay
                                      ELSE 
                                           inAmountToPay - vbAmountPay
                            END;
          ELSE -- оставили без изменений
               vbAmountGRN := inAmountGRN;
          END IF;
     ELSE
         -- обнулили
         vbAmountGRN := 0;
     END IF;


     -- Результат
     RETURN QUERY
      WITH -- остаток к оплате - или ГРН или EUR
           tmpData_all AS (SELECT CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN inAmountToPay_curr - (zfCalc_CurrencyTo (COALESCE (vbAmountGRN, 0)
                                                                                   + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                                                   + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                                                   + COALESCE (inAmountCard, 0)
                                                                                   , inCurrencyValueEUR, 1)
                                                                + COALESCE (inAmountDiscount, 0))
                                       ELSE
                                           inAmountToPay - (vbAmountPay + vbAmountGRN)
                                  END AS AmountRemains
                          )
              -- данные - или ГРН или EUR
            , tmpData AS (SELECT CASE WHEN tmpData_all.AmountRemains > 0
                                      THEN tmpData_all.AmountRemains
                                      ELSE 0
                                 END AS AmountRemains

                               , CASE WHEN tmpData_all.AmountRemains < 0
                                      THEN -1 * tmpData_all.AmountRemains
                                      ELSE 0
                                 END AS AmountDiff

                               , vbAmountGRN AS AmountGRN

                          FROM tmpData_all
                         )
      -- Результат
      SELECT -- Остаток, грн
             CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                       THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmpData.AmountRemains, inCurrencyValueEUR, 1), 0)
                       ELSE tmpData.AmountRemains
             END :: TFloat AS AmountRemains
             -- Остаток, EUR
           , CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                       THEN tmpData.AmountRemains
                       ELSE zfCalc_SummIn (1, zfCalc_CurrencyTo (tmpData.AmountRemains, inCurrencyValueEUR, 1), 1)
             END :: TFloat AS AmountRemains_curr

             -- Сдача, грн
           , CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                       THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmpData.AmountDiff, inCurrencyValueEUR, 1), 0)
                       ELSE tmpData.AmountDiff
             END :: TFloat AS AmountDiff

           , tmpData.AmountGRN
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
-- SELECT * FROM gpGet_MI_Sale_Child_isGRN(inIsGRN := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN := 100 ,inAmountUSD := 100 , inAmountEUR := 84 , inAmountCard := 0 , inAmountDiscount := 0.4 , inCurrencyId_Client:= zc_Currency_EUR(), inSession := '2');
