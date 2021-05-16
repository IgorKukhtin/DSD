-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_Total(
    IN inCurrencyValueUSD    TFloat   , --
    IN inCurrencyValueEUR    TFloat   , --
    IN inCurrencyValueCross  TFloat   , --
    IN inAmountToPay_GRN     TFloat   , -- сумма к оплате, грн
    IN inAmountToPay_EUR     TFloat   , -- сумма к оплате, EUR
    IN inAmountGRN           TFloat   , --
    IN inAmountUSD           TFloat   , --
    IN inAmountEUR           TFloat   , --
    IN inAmountCard          TFloat   , --
    IN inAmountDiscount      TFloat   , -- всегда ГРН
    IN inCurrencyId_Client   Integer  , --
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS TABLE (-- Информативно - для Диалога
               AmountToPay         TFloat -- К оплате, грн
             , AmountToPay_curr    TFloat -- К оплате, EUR
               -- факт - отсюда долг
             , AmountToPay_GRN     TFloat
             , AmountToPay_EUR     TFloat
               --
             , AmountRemains       TFloat -- Остаток, грн
             , AmountRemains_curr  TFloat -- Остаток, EUR

               -- сдача, ГРН
             , AmountDiff          TFloat

               -- Дополнительная скидка
             , AmountDiscount      TFloat
             , AmountDiscount_curr TFloat
             
               -- Курс, может будем пересчитывать из-за кросс-курса
             , CurrencyValueUSD TFloat

               -- AmountPay - для отладки
             , AmountPay            TFloat
             , AmountPay_curr       TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCurrencyValueUSD NUMERIC (20, 10);
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- !замена! Курс, будем пересчитывать из-за кросс-курса, 2 знака
     vbCurrencyValueUSD:= zfCalc_CurrencyTo_Cross (inCurrencyValueEUR, inCurrencyValueCross);


     -- если Оплата = 0 + НЕ все списание
     IF inAmountToPay_GRN <> inAmountDiscount
        AND inAmountGRN      = 0
        AND inAmountUSD      = 0
        AND inAmountEUR      = 0
        AND inAmountCard     = 0
     THEN
         -- обнулили
         inAmountDiscount:= 0;

     -- если есть USD, меняем inAmountDiscount, т.к. Кросс-курс
     ELSEIF inAmountUSD > 0 AND inAmountDiscount = 0 -- inAmountGRN = 0 AND 1=0
     THEN
         inAmountDiscount:= zfCalc_CurrencyFrom (-- округлили до целых EUR
                                                 zfCalc_CurrencyCross (inAmountUSD, inCurrencyValueCross, 1)
                                               , inCurrencyValueEUR, 1)
                          - zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, 1)
                           ;
     END IF;


     -- Результат
     RETURN QUERY
      WITH tmp1 AS (SELECT -- Сумма оплаты - в ГРН
                            COALESCE (inAmountGRN, 0)
                        /*+ zfCalc_CurrencyFrom (-- округлили до целых EUR
                                                 zfCalc_CurrencyCross (inAmountUSD, inCurrencyValueCross, 1)
                                               , inCurrencyValueEUR, 1)*/
                          + zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, 1)
                          + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                          + COALESCE (inAmountCard, 0)
                            AS AmountPay_GRN

                           -- сумма к оплате, грн - НЕ округлили, отсюда остаток
                         , zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1) AS AmountToPay_GRN
                           -- сумма к оплате, EUR - НЕ округлили, отсюда остаток
                         , inAmountToPay_EUR AS AmountToPay_EUR
                           -- сумма ручного списания
                         , inAmountDiscount  AS AmountDiscount_GRN
                   )
            -- Расчет - сколько осталось оплатить / либо сдача
          , tmp AS (SELECT -- Сумма к оплате МИНУС Итого Оплата - все в ГРН
                           tmp1.AmountToPay_GRN - tmp1.AmountPay_GRN - tmp1.AmountDiscount_GRN AS AmountDiff
                           -- сумма к оплате, грн - НЕ округлили, отсюда остаток
                         , tmp1.AmountToPay_GRN
                           -- сумма к оплате, EUR - НЕ округлили, отсюда остаток
                         , tmp1.AmountToPay_EUR
                           -- сумма ручного списания
                         , tmp1.AmountDiscount_GRN
                           -- Сумма оплаты - в ГРН
                         , tmp1.AmountPay_GRN

                    FROM tmp1
                   )

      SELECT -- К оплате, грн - здесь округлили
             zfCalc_SummPriceList (1, tmp.AmountToPay_GRN) :: TFloat AS AmountToPay
             -- К оплате, EUR - здесь округлили
           , zfCalc_SummPriceList (1, tmp.AmountToPay_EUR) :: TFloat AS AmountToPay_curr

             -- К оплате, грн - НЕ округлили
           , tmp.AmountToPay_GRN :: TFloat AS AmountToPay_GRN
             -- К оплате, EUR - НЕ округлили
           , tmp.AmountToPay_EUR :: TFloat AS AmountToPay_EUR

             -- сколько осталось оплатить, ГРН
           , CASE WHEN tmp.AmountDiff > 0 AND tmp.AmountToPay_GRN = tmp.AmountDiff
                        THEN -- здесь округлили
                             zfCalc_SummPriceList (1, tmp.AmountDiff)
                   WHEN tmp.AmountDiff > 0
                       -- НЕ округлили
                       THEN tmp.AmountDiff
                  ELSE 0
             END :: TFloat AS AmountRemains

             -- сколько осталось оплатить, EUR - НЕ округлили
           , CASE WHEN tmp.AmountDiff > 0
                       -- переводим из ГРН в EUR + ОКРУГЛЕНИЕ ?
                       THEN zfCalc_SummIn (1, zfCalc_CurrencyTo (tmp.AmountDiff, inCurrencyValueEUR, 1), 1)
                  ELSE 0
             END :: TFloat AS AmountRemains_curr

             -- Сдача, грн
           , CASE WHEN tmp.AmountDiff < 0
                       -- сумма итак в ГРН
                     --THEN -1 * (tmp.AmountDiff - (tmp.AmountDiff - FLOOR (ROUND(tmp.AmountDiff/10, 0)*10)))
                       THEN -1 * tmp.AmountDiff

                  ELSE 0
             END :: TFloat AS AmountDiff

             -- Дополнительная скидка - ГРН
           , CASE WHEN tmp.AmountDiff < 0 AND tmp.AmountDiff <> FLOOR (ROUND(tmp.AmountDiff/10, 0)*10) AND inAmountToPay_GRN > 0
                       -- добавляем к скидке так, чтоб сдача делилась на 10грн
                       THEN inAmountDiscount + (tmp.AmountDiff - FLOOR (ROUND(tmp.AmountDiff/10, 0)*10))

                  WHEN tmp.AmountDiff > 0 AND zfCalc_CurrencyTo (tmp.AmountDiff, inCurrencyValueEUR, 1) <> FLOOR (zfCalc_CurrencyTo (tmp.AmountDiff, inCurrencyValueEUR, 1))
                       -- добавляем к скидке так, чтоб остаток EUR - был целым
                       THEN inAmountDiscount + (tmp.AmountDiff - zfCalc_CurrencyFrom (ROUND (zfCalc_CurrencyTo (tmp.AmountDiff, inCurrencyValueEUR, 1), 0), inCurrencyValueEUR, 1))

                  ELSE inAmountDiscount
             END :: TFloat AS AmountDiscount

             -- Дополнительная скидка - EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (
             CASE WHEN tmp.AmountDiff < 0 AND tmp.AmountDiff <> FLOOR (ROUND(tmp.AmountDiff/10, 0)*10) AND inAmountToPay_GRN > 0
                       THEN inAmountDiscount + (tmp.AmountDiff - FLOOR (ROUND(tmp.AmountDiff/10, 0)*10))
                  ELSE inAmountDiscount
             END, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountDiscount_curr

             -- Курс, может будем пересчитывать из-за кросс-курса
           , inCurrencyValueUSD :: TFLoat AS CurrencyValueUSD

             -- AmountPay, ГРН
           , tmp.AmountPay_GRN :: TFloat AS AmountPay
             -- AmountPay, EUR
           , zfCalc_CurrencyTo (tmp.AmountPay_GRN, inCurrencyValueEUR, 1) :: TFloat AS AmountPay_curr

      FROM tmp;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE; 

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 22.05.17         *
*/

-- тест
-- SELECT * FROM gpGet_MI_Sale_Child_Total (inCurrencyValueUSD:= 1, inCurrencyValueEUR:= 1, inCurrencyValueCross:= 1, inAmountToPay_GRN:= 1, inAmountToPay_EUR:= 1, inAmountGRN:= 1, inAmountUSD:= 1, inAmountEUR:= 1, inAmountCard:= 1, inAmountDiscount:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
