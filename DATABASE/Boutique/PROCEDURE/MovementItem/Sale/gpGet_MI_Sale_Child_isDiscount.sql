-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isDiscount(
    IN inIsDiscount        Boolean  , --
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
             , AmountDiscount      TFloat -- Дополнительная скидка !!! или ГРН или EUR !!!
             , AmountDiscount_curr TFloat -- Дополнительная скидка !!! или ГРН или EUR !!!
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountDiscount TFloat;
   DECLARE vbAmountPay TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- сумма оплаты - или ГРН или EUR
     vbAmountPay := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                              -- переводим все в EUR
                              THEN zfCalc_SummPriceList (1, zfCalc_CurrencyTo (inAmountGRN, inCurrencyValueEUR, 1))
                                 + zfCalc_SummPriceList (1, zfCalc_CurrencyTo (zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1), inCurrencyValueEUR, 1))
                                 + COALESCE (inAmountEUR, 0)
                                 + zfCalc_SummPriceList (1, zfCalc_CurrencyTo (inAmountCard, inCurrencyValueEUR, 1))

                              -- переводим все в ГРН
                              ELSE inAmountGRN
                                 + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                 + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                 + inAmountCard
                    END;

     -- сумма Дополнительной скидки - или ГРН или EUR
     IF inIsDiscount = TRUE THEN
         IF inAmountDiscount = 0
         THEN -- округлили до 2-х знаков
              vbAmountDiscount := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                            THEN CAST (inAmountToPay_curr - vbAmountPay AS NUMERIC (16, 2))
                                            ELSE CAST (inAmountToPay      - vbAmountPay AS NUMERIC (16, 2))
                                  END;

         ELSE -- оставили без изменений
              vbAmountDiscount := inAmountDiscount;

         END IF;
     ELSE
         -- обнулили
         vbAmountDiscount := 0;
     END IF;



     -- Результат
     RETURN QUERY
      WITH -- только остаток к оплате - или ГРН или EUR
           tmpData_all AS (SELECT CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN inAmountToPay_curr - (vbAmountPay + vbAmountDiscount)
                                       ELSE inAmountToPay      - (vbAmountPay + vbAmountDiscount)
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
                               , vbAmountDiscount AS AmountDiscount
                          FROM tmpData_all
                         )
      -- Результат
      SELECT -- Остаток, грн
             CASE WHEN inCurrencyId_Client = zc_Currency_EUR() 
                       THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmpData.AmountRemains, inCurrencyValueEUR, 1))
                       ELSE tmpData.AmountRemains
             END :: TFloat AS AmountRemains
             -- Остаток, EUR
           , CASE WHEN inCurrencyId_Client = zc_Currency_EUR() 
                       THEN tmpData.AmountRemains
                       ELSE zfCalc_SummPriceList (1, zfCalc_CurrencyTo (tmpData.AmountRemains, inCurrencyValueEUR, 1))
             END :: TFloat AS AmountRemains_curr

             -- Сдача, грн
           , CASE WHEN inCurrencyId_Client = zc_Currency_EUR() 
                       THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmpData.AmountDiff, inCurrencyValueEUR, 1))
                       ELSE tmpData.AmountDiff
             END :: TFloat AS AmountDiff

             -- Дополнительная скидка !!! EUR or грн !!!
           , tmpData.AmountDiscount :: TFloat AS AmountDiscount

             -- Дополнительная скидка
           , CASE WHEN inCurrencyId_Client = zc_Currency_EUR() 
                       THEN -- переводим в ГРН
                            zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmpData.AmountDiscount, inCurrencyValueEUR, 1))

                       ELSE -- переводим в EUR
                            zfCalc_SummPriceList (1, zfCalc_CurrencyTo (tmpData.AmountDiscount, inCurrencyValueEUR, 1))

             END :: TFloat AS AmountDiscount_curr

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
-- SELECT * FROM gpGet_MI_Sale_Child_isDiscount(inIsDiscount := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inAmount := 5247.4 , inAmountGRN := 1.2 , inAmountUSD := 100 , inAmountEUR := 84 , inAmountCard := 0 , inAmountDiscount:= 1, inSession := '2');
