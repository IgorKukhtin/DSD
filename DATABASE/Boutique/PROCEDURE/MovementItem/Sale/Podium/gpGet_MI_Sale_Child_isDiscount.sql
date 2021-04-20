-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
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
   DECLARE vbAmountPay_grn  TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- сумма оплаты - ГРН
     vbAmountPay_grn := COALESCE (inAmountGRN, 0)
                      + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                      + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                      + COALESCE (inAmountCard, 0)
                       ;

     -- Сумма Дополнительной скидки - или ГРН или EUR
     IF inIsDiscount = TRUE THEN
         IF inAmountDiscount = 0
         THEN -- округлили до 2-х знаков
              vbAmountDiscount := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                            THEN CAST (zfCalc_CurrencyTo (zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_curr, inCurrencyValueEUR, 1))
                                                                        - vbAmountPay_grn
                                                                        , inCurrencyValueEUR, 1)
                                                      AS NUMERIC (16, 2))
                                            ELSE CAST (inAmountToPay - vbAmountPay_grn AS NUMERIC (16, 2))
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
                                       THEN zfCalc_SummIn (1
                                                         , zfCalc_CurrencyTo (zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_curr, inCurrencyValueEUR, 1))
                                                                            - (vbAmountPay_grn
                                                                             + zfCalc_CurrencyFrom (vbAmountDiscount, inCurrencyValueEUR, 1))
                                                                            , inCurrencyValueEUR, 1)
                                                         , 1)
                                       ELSE inAmountToPay  - (vbAmountPay_grn + vbAmountDiscount)
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

             -- Дополнительная скидка !!! EUR or грн !!!
           , tmpData.AmountDiscount :: TFloat AS AmountDiscount

             -- Дополнительная скидка
           , CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                       THEN -- переводим в ГРН
                            zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmpData.AmountDiscount, inCurrencyValueEUR, 1), 0)

                       ELSE -- переводим в EUR
                            zfCalc_SummIn (1, zfCalc_CurrencyTo (tmpData.AmountDiscount, inCurrencyValueEUR, 1), 1)

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
-- SELECT * FROM gpGet_MI_Sale_Child_isDiscount(inIsDiscount:= TRUE, inCurrencyValueUSD:= 26.25, inCurrencyValueEUR:= 31.2, inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN:= 1.2, inAmountUSD:= 100, inAmountEUR:= 84, inAmountCard:= 0, inAmountDiscount:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
