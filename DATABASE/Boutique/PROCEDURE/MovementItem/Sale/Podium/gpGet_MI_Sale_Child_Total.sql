-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_Total(
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmountToPay_GRN   TFloat   , -- сумма к оплате, грн
    IN inAmountToPay_EUR   TFloat   , -- сумма к оплате, EUR
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , -- всегда ГРН
    IN inCurrencyId_Client Integer  , -- 
    IN inSession           TVarChar   -- сессия пользователя
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

               -- корректируем копейки - списанием
             , AmountDiscount      TFloat
             , AmountDiscount_curr TFloat

               -- AmountPay - для отладки
             , AmountPay            TFloat
             , AmountPay_curr       TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       WITH tmp1 AS (SELECT -- Сумма оплаты - в ГРН
                             COALESCE (inAmountGRN, 0)
                           + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                           + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                           + COALESCE (inAmountCard, 0)
                             AS AmountPay_GRN

                            -- сумма к оплате, грн - НЕ округлили, отсюда остаток
                          , zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1) AS AmountToPay_GRN
                            -- сумма к оплате, EUR - НЕ округлили, отсюда остаток
                          , inAmountToPay_EUR AS AmountToPay_EUR
                    )
          , tmp2 AS (SELECT -- если после округления - суммы совпали
                            CASE WHEN tmp1.AmountPay_GRN = zfCalc_SummPriceList (1, tmp1.AmountToPay_GRN)
                                 THEN -- разница и будет ручным списанием
                                      tmp1.AmountToPay_GRN - zfCalc_SummPriceList (1, tmp1.AmountToPay_GRN)

                                 -- если все в USD
                                 WHEN zfCalc_SummPriceList (1, zfCalc_CurrencyTo (tmp1.AmountToPay_GRN, inCurrencyValueUSD, 1)) = inAmountUSD
                                 THEN -- разница и будет ручным списанием
                                      tmp1.AmountToPay_GRN - tmp1.AmountPay_GRN

                                 WHEN tmp1.AmountPay_GRN = 0 AND inAmountDiscount < 2 AND tmp1.AmountToPay_GRN > 2
                                 THEN -- "вернули" списания НЕТ
                                      0
                                 ELSE -- оставили как есть
                                      inAmountDiscount
                             END AS AmountDiscount_GRN

                            -- Сумма оплаты - в ГРН
                          , tmp1.AmountPay_GRN
                            -- сумма к оплате, грн - НЕ округлили, отсюда остаток
                          , tmp1.AmountToPay_GRN
                            -- сумма к оплате, EUR - НЕ округлили, отсюда остаток
                          , tmp1.AmountToPay_EUR
                     FROM tmp1
                    )
             -- Расчет - сколько осталось оплатить / либо сдача
           , tmp AS (SELECT -- Сумма к оплате МИНУС Итого Оплата - все в ГРН
                            tmp2.AmountToPay_GRN - tmp2.AmountPay_GRN - tmp2.AmountDiscount_GRN AS AmountDiff
                            -- сумма к оплате, грн - НЕ округлили, отсюда остаток
                          , tmp2.AmountToPay_GRN
                            -- сумма к оплате, EUR - НЕ округлили, отсюда остаток
                          , tmp2.AmountToPay_EUR
                            -- сумма ручного списания
                          , tmp2.AmountDiscount_GRN
                            -- Сумма оплаты - в ГРН
                          , tmp2.AmountPay_GRN
                     FROM tmp2
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
                        THEN -1 * tmp.AmountDiff

                   ELSE 0
              END :: TFloat AS AmountDiff

              -- AmountDiscount, ГРН
            , tmp.AmountDiscount_GRN :: TFloat AS AmountDiscount
              -- AmountDiscount, EUR
            , zfCalc_SummIn (1, zfCalc_CurrencyTo (tmp.AmountDiscount_GRN, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountDiscount_curr

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
-- SELECT * FROM gpGet_MI_Sale_Child_Total (inCurrencyValueUSD:= 1, inCurrencyValueEUR:= 1, inAmountToPay_GRN:= 1, inAmountToPay_EUR:= 1, inAmountGRN:= 1, inAmountUSD:= 1, inAmountEUR:= 1, inAmountCard:= 1, inAmountDiscount:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
