-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isDiscount(
    IN inIsDiscount          Boolean  , --
    IN inCurrencyValueUSD    TFloat   , --
    IN inCurrencyValueEUR    TFloat   , --
    IN inCurrencyValueCross  TFloat   , --
    IN inAmountToPay         TFloat   , -- сумма к оплате, грн
    IN inAmountToPay_curr    TFloat   , -- сумма к оплате, EUR
    IN inAmountGRN           TFloat   , --
    IN inAmountUSD           TFloat   , --
    IN inAmountEUR           TFloat   , --
    IN inAmountCard          TFloat   , --
    IN inAmountDiscount      TFloat   , -- или ГРН или EUR
    IN inCurrencyId_Client   Integer  , --
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS TABLE (AmountRemains       TFloat -- Остаток, грн
             , AmountRemains_curr  TFloat -- Остаток, EUR
             , AmountDiff          TFloat -- Сдача, грн
             , AmountDiscount      TFloat -- Расчетная сумма - Дополнительная скидка ГРН
             , AmountDiscount_curr TFloat -- Расчетная сумма - Дополнительная скидка EUR
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountPay_GRN      TFloat;
   DECLARE vbAmountDiscount_GRN TFloat;
   DECLARE vbCurrencyValueUSD   NUMERIC (20, 10);
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- !замена! Курс, будем пересчитывать из-за кросс-курса, 2 знака
     vbCurrencyValueUSD:= zfCalc_CurrencyTo_Cross (inCurrencyValueEUR, inCurrencyValueCross);


     -- сумма оплаты - ГРН
     vbAmountPay_GRN := COALESCE (inAmountGRN, 0)
                      + zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, 1)
                      + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                      + COALESCE (inAmountCard, 0)
                       ;

     -- Сумма Дополнительной скидки - ГРН
     IF inIsDiscount = TRUE THEN
         -- НЕ округлили
         vbAmountDiscount_GRN := inAmountToPay - vbAmountPay_GRN;

     ELSE
         -- обнулили
         vbAmountDiscount_GRN := 0;
     END IF;


     -- Результат
     RETURN QUERY
      WITH -- только остаток к оплате - или ГРН или EUR
           tmpData_all AS (SELECT inAmountToPay - (vbAmountPay_GRN + vbAmountDiscount_GRN) AS AmountDiff
                          )
              -- данные - ГРН
            , tmpData AS (SELECT CASE WHEN tmpData_all.AmountDiff > 0
                                      THEN tmpData_all.AmountDiff
                                      ELSE 0
                                 END AS AmountRemains

                               , CASE WHEN tmpData_all.AmountDiff < 0
                                      THEN -1 * tmpData_all.AmountDiff
                                      ELSE 0
                                 END AS AmountDiff

                               , vbAmountDiscount_GRN AS AmountDiscount

                          FROM tmpData_all
                         )
      -- Результат
      SELECT -- Остаток, грн
             tmpData.AmountRemains :: TFloat AS AmountRemains
             -- Остаток, EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (tmpData.AmountRemains, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountRemains_curr

             -- Сдача, грн
           , tmpData.AmountDiff :: TFloat AS AmountDiff

             -- Расчетная сумма - Дополнительная скидка ГРН
           , tmpData.AmountDiscount :: TFloat AS AmountDiscount

             -- Расчетная сумма - Дополнительная скидка EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (tmpData.AmountDiscount, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountDiscount_curr

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
-- SELECT * FROM gpGet_MI_Sale_Child_isDiscount(inIsDiscount:= TRUE, inCurrencyValueUSD:= 26.25, inCurrencyValueEUR:= 31.2, inCurrencyValueCross:= 1, inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN:= 1.2, inAmountUSD:= 100, inAmountEUR:= 84, inAmountCard:= 0, inAmountDiscount:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
