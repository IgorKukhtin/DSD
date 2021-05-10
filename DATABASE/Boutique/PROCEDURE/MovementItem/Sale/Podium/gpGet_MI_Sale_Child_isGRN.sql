-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isGRN(
    IN inIsGRN               Boolean  , --
    IN inCurrencyValueUSD    TFloat   , --
    IN inCurrencyValueEUR    TFloat   , --
    IN inCurrencyValueCross  TFloat   , --
    IN inAmountToPay         TFloat   , -- сумма к оплате, грн
    IN inAmountToPay_curr    TFloat   , -- сумма к оплате, EUR
    IN inAmountGRN           TFloat   , --
    IN inAmountUSD           TFloat   , --
    IN inAmountEUR           TFloat   , --
    IN inAmountCard          TFloat   , --
    IN inAmountDiscount      TFloat   , --
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
             , AmountGRN           TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAmountPay_GRN      TFloat;
   DECLARE vbAmountGRN          TFloat;
   DECLARE vbAmountDiscount_GRN TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- сумма оплаты - ГРН
     vbAmountPay_GRN := zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                      + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                      + COALESCE (inAmountCard, 0)
                      + COALESCE (inAmountDiscount, 0)
                       ;
     -- сохранили
     vbAmountDiscount_GRN:= COALESCE (inAmountDiscount, 0);


     -- Сумма - ГРН
     IF inIsGRN = TRUE
     THEN
         IF inAmountGRN = 0
         THEN -- расчет остаток суммы
              vbAmountGRN := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN -- Округлили к 0 знаков, разница попадет автоматом в списание
                                            zfCalc_SummPriceList (1, inAmountToPay - vbAmountPay_GRN)
                                       ELSE
                                            inAmountToPay - vbAmountPay_GRN
                             END;

              -- если нет скидки, сформируем её и спишим "хвостик"
              IF vbAmountDiscount_GRN = 0
              THEN
                  -- пробуем списать весь остаток
                  vbAmountDiscount_GRN:= inAmountToPay - vbAmountGRN;

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
               vbAmountGRN := inAmountGRN;
          END IF;

     ELSE
         -- обнулили
         vbAmountGRN := 0;

         -- если все 0
         IF inAmountUSD  = 0
        AND inAmountEUR  = 0
        AND inAmountCard = 0
         THEN
             -- Обнулили Дополнительная скидка
             vbAmountDiscount_GRN:= 0;
             -- пересчитали сумму с учетом нового AmountDiscount
             vbAmountPay_GRN:= 0;
         END IF;

     END IF;

     -- выровняли
     IF vbAmountGRN < 0 THEN vbAmountGRN:= 0; END IF;


     -- Результат
     RETURN QUERY
      WITH -- остаток к оплате - ГРН
           tmpData_all AS (SELECT inAmountToPay - (vbAmountPay_GRN + vbAmountGRN) AS AmountDiff
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
                               , vbAmountGRN AS AmountGRN

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

             -- Расчетная сумма ГРН
           , tmpData.AmountGRN

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
-- SELECT * FROM gpGet_MI_Sale_Child_isGRN(inIsGRN := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2, inCurrencyValueCross:= 1, inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN := 100 ,inAmountUSD := 100 , inAmountEUR := 84 , inAmountCard := 0 , inAmountDiscount := 0.4 , inCurrencyId_Client:= zc_Currency_EUR(), inSession := '2');
