-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isEUR(
    IN inIsEUR               Boolean  , --
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
               -- сдача, ГРН
             , AmountDiff          TFloat
               -- Дополнительная скидка
             , AmountDiscount      TFloat
             , AmountDiscount_curr TFloat
               -- Расчетная сумма
             , AmountEUR           TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountPay_GRN      TFloat;
   DECLARE vbAmountEUR          TFloat;
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
                      + COALESCE (inAmountCard, 0)
                      + COALESCE (inAmountDiscount, 0)
                       ;
     -- сохранили
     vbAmountDiscount_GRN:= COALESCE (inAmountDiscount, 0);

     -- Сумма - EUR
     IF inIsEUR = TRUE
     THEN
         IF inAmountEUR = 0
         THEN -- расчет остаток суммы
              vbAmountEUR := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN -- Округлили к 0 знаков, разница попадет автоматом в списание
                                            zfCalc_SummPriceList (1, zfCalc_CurrencyTo (inAmountToPay - vbAmountPay_GRN, inCurrencyValueEUR, 1))

                                       ELSE -- НЕ округлили
                                            zfCalc_CurrencyTo (inAmountToPay - vbAmountPay_GRN, inCurrencyValueEUR, 1)
                             END;

              -- если нет скидки, сформируем её и спишим "хвостик"
              IF vbAmountDiscount_GRN = 0
              THEN
                  -- пробуем списать весь остаток
                  vbAmountDiscount_GRN:= inAmountToPay - zfCalc_CurrencyFrom (vbAmountEUR, inCurrencyValueEUR, 1);

                  -- если большая сумма
                  IF ABS (vbAmountDiscount_GRN) >= zc_AmountDiscountGRN()
                  THEN
                      -- списываем только КОП.
                      vbAmountDiscount_GRN:= vbAmountDiscount_GRN - FLOOR (vbAmountDiscount_GRN);
                  END IF;

                  -- пересчитали сумму с учетом нового AmountDiscount
                  vbAmountPay_GRN:= vbAmountPay_GRN + vbAmountDiscount_GRN;

              END IF;

         ELSE -- оставили без изменений
              vbAmountEUR := inAmountEUR;
         END IF;
     ELSE
         -- обнулили
         vbAmountEUR := 0;

         -- если все 0
         IF inAmountGRN  = 0
        AND inAmountUSD  = 0
        AND inAmountCard = 0
         THEN
             -- Обнулили Дополнительная скидка
             vbAmountDiscount_GRN:= 0;
             -- пересчитали сумму с учетом нового AmountDiscount
             vbAmountPay_GRN:= 0;
         END IF;

     END IF;

     -- выровняли
     IF vbAmountEUR < 0 THEN vbAmountEUR:= 0; END IF;


     -- Результат
     RETURN QUERY
      WITH -- остаток к оплате - ГРН
           tmpData_all AS (SELECT inAmountToPay - (vbAmountPay_GRN + zfCalc_CurrencyFrom (vbAmountEUR, inCurrencyValueEUR, 1)) AS AmountDiff
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

             -- Дополнительная скидка - ГРН
           , vbAmountDiscount_GRN :: TFloat AS AmountDiscount
             -- Дополнительная скидка - EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (vbAmountDiscount_GRN, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountDiscount_curr

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
-- SELECT * FROM gpGet_MI_Sale_Child_isEUR (inIsEUR:= TRUE, inCurrencyValueUSD:= 26.25, inCurrencyValueEUR:= 31.2, inCurrencyValueCross:= 1, inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN:= 1.2, inAmountUSD:= 100, inAmountEUR:= 10, inAmountCard:= 0, inAmountDiscount:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
