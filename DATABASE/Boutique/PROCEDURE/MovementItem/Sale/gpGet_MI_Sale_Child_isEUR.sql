-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isEUR(
    IN inIsEUR             Boolean  , --
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmountToPay       TFloat   , -- сумма к оплате, грн
    IN inAmountToPay_curr  TFloat   , -- сумма к оплате, EUR
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , -- или ГРН или EUR
    IN inCurrencyId_Client Integer  , -- 
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
   DECLARE vbAmountEUR TFloat;
   DECLARE vbAmountPay TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- сумма оплаты - или ГРН или EUR
     vbAmountPay := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                              THEN 
                                  zfCalc_SummIn (1
                                                 -- переводим обратно в EUR
                                               , zfCalc_CurrencyTo (inAmountGRN
                                                                  + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                                  + COALESCE (inAmountCard, 0)
                                                                  , inCurrencyValueEUR, 1)
                                               + COALESCE (inAmountDiscount, 0)
                                                 , 1)
                              -- переводим все в ГРН
                              ELSE COALESCE (inAmountGRN, 0)
                                 + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                 + COALESCE (inAmountCard, 0)
                                 + COALESCE (inAmountDiscount, 0)
                    END;

     -- Сумма - EUR
     IF inIsEUR = TRUE
     THEN
         IF inAmountEUR = 0
         THEN 
              vbAmountEUR := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN -- округлили ВВЕРХ
                                            CEIL (inAmountToPay_curr - vbAmountPay)
                                       ELSE -- округлили до 0 знаков
                                            CAST (zfCalc_CurrencyTo (inAmountToPay - vbAmountPay, inCurrencyValueEUR, 1) AS NUMERIC (16, 0))
                             END;
         ELSE -- оставили без изменений
              vbAmountEUR := inAmountEUR;
         END IF;
     ELSE
         -- обнулили
         vbAmountEUR := 0;
     END IF;


     -- Результат
     RETURN QUERY
      WITH -- остаток к оплате - или ГРН или EUR
           tmpData_all AS (SELECT CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN inAmountToPay_curr - (vbAmountPay + vbAmountEUR)
                                       ELSE inAmountToPay      - (vbAmountPay + vbAmountEUR)
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

                               , vbAmountEUR AS AmountEUR

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

             -- Сумма EUR
           , tmpData.AmountEUR

      FROM tmpData;


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
