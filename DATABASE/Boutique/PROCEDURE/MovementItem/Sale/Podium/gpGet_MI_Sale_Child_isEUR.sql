-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
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
             , AmountEUR           TFloat -- Расчетная сумма
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountPay_GRN TFloat;
   DECLARE vbAmountEUR TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- сумма оплаты - ГРН
     vbAmountPay_GRN := COALESCE (inAmountGRN, 0)
                      + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                      + COALESCE (inAmountCard, 0)
                      + COALESCE (inAmountDiscount, 0)
                       ;

     -- Сумма - EUR
     IF inIsEUR = TRUE
     THEN
         IF inAmountEUR = 0
         THEN
              vbAmountEUR := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN -- Округлили к 0 знаков, разница попадет автоматом в списание
                                            zfCalc_SummPriceList (1, zfCalc_CurrencyTo (inAmountToPay - vbAmountPay_GRN, inCurrencyValueEUR, 1))

                                       ELSE -- НЕ округлили
                                            zfCalc_CurrencyTo (inAmountToPay - vbAmountPay_GRN, inCurrencyValueEUR, 1)
                             END;
         ELSE -- оставили без изменений
              vbAmountEUR := inAmountEUR;
         END IF;
     ELSE
         -- обнулили
         vbAmountEUR := 0;
     END IF;

     -- выровняли
     IF vbAmountEUR < 0 THEN vbAmountEUR:= 0; END IF;


     -- Результат
     RETURN QUERY
      WITH -- остаток к оплате - ГРН
           tmpData_all AS (SELECT inAmountToPay - (vbAmountPay_GRN + zfCalc_CurrencyFrom (vbAmountEUR, inCurrencyValueEUR, 1)) AS AmountDiff
                          )
              -- данные - или ГРН или EUR
            , tmpData AS (SELECT CASE WHEN tmpData_all.AmountDiff > 0
                                      THEN tmpData_all.AmountDiff
                                      ELSE 0
                                 END AS AmountRemains

                               , CASE WHEN tmpData_all.AmountDiff < 0
                                      THEN -1 * tmpData_all.AmountDiff
                                      ELSE 0
                                 END AS AmountDiff

                                 -- Расчетная сумма
                               , vbAmountEUR AS AmountEUR

                          FROM tmpData_all
                         )
      -- Результат
      SELECT -- Остаток, грн
             tmpData.AmountRemains :: TFloat AS AmountRemains
             -- Остаток, EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (tmpData.AmountRemains, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountRemains_curr

             -- Сдача, грн
           , tmpData.AmountDiff :: TFloat AS AmountDiff

             -- Расчетная сумма EUR
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
