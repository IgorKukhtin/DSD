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
    IN inAmountDiscount    TFloat   , -- или ГРН или EUR
    IN inCurrencyId_Client Integer  , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (AmountToPay         TFloat -- К оплате, грн
             , AmountToPay_curr    TFloat -- К оплате, EUR
             , AmountRemains       TFloat -- Остаток, грн
             , AmountRemains_curr  TFloat -- Остаток, EUR
             , AmountDiff          TFloat -- Сдача, грн
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       WITH tmp AS (-- Расчет - сколько осталось оплатить / либо сдача
                    SELECT CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                THEN
                                    CASE WHEN COALESCE (inAmountGRN, 0)  = 0
                                          AND COALESCE (inAmountUSD, 0)  = 0
                                          AND COALESCE (inAmountEUR, 0)  = 0
                                          AND COALESCE (inAmountCard, 0) = 0
                                    THEN inAmountToPay_EUR + zfCalc_SummPriceList (1, zfCalc_CurrencyTo (inAmountToPay_GRN, inCurrencyValueEUR, 1))
                                        - COALESCE (inAmountDiscount, 0)
 
                                    WHEN
                                                                  ABS (zfCalc_SummPriceList (1
                                                                    , inAmountToPay_GRN + zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1))
                                                                      -- МИНУС Итого Оплата - переводим в ГРН
                                                                    - (COALESCE (inAmountGRN, 0)
                                                                     + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                                     + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                                     + COALESCE (inAmountCard, 0)
                                                                     + zfCalc_CurrencyFrom (inAmountDiscount, inCurrencyValueEUR, 1)
                                                                      )) < 1
                                    THEN
                             zfCalc_SummPriceList (1
                                                   -- переводим обратно в EUR
                                                 , zfCalc_CurrencyTo (-- Сумма к оплате - переводим в ГРН
                                                                      inAmountToPay_GRN
                                                                    + zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1))
                                                                      -- МИНУС Итого Оплата - переводим в ГРН
                                                                    - (COALESCE (inAmountGRN, 0)
                                                                     + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                                     + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                                     + COALESCE (inAmountCard, 0)
                                                                     + zfCalc_CurrencyFrom (inAmountDiscount, inCurrencyValueEUR, 1)
                                                                      )
                                                                 , inCurrencyValueEUR, 1)
                                                 , 0)
                                    ELSE
                                    zfCalc_SummIn (1
                                                   -- переводим обратно в EUR
                                                 , zfCalc_CurrencyTo (-- Сумма к оплате - переводим в ГРН
                                                   zfCalc_SummPriceList (1, inAmountToPay_GRN + zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1)
                                                                            -- МИНУС Итого Оплата - переводим в ГРН
                                                                          - (COALESCE (inAmountGRN, 0)
                                                                           + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                                           + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                                           + COALESCE (inAmountCard, 0)
                                                                           + zfCalc_CurrencyFrom (inAmountDiscount, inCurrencyValueEUR, 1)
                                                                            ))
                                                                 , inCurrencyValueEUR, 1)
                                                 , 1)
                                    END
                                ELSE -- Сумма к оплате МИНУС Итого Оплата - все в ГРН
                                     inAmountToPay_GRN + zfCalc_SummIn (1, zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1), 0)
                                                    - (COALESCE (inAmountGRN, 0)
                                                    + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                    + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                    + COALESCE (inAmountCard, 0)
                                                    + COALESCE (inAmountDiscount, 0)
                                                     )
                           END AS AmountDiff
                   )
       SELECT -- К оплате, грн
              CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                        -- переводим из EUR в ГРН + округление до 0 знаков
                        THEN inAmountToPay_GRN + zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1), 0)
                   ELSE inAmountToPay_GRN
              END :: TFloat AS AmountToPay

              -- К оплате, EUR
            , CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                        THEN zfCalc_SummIn (1, zfCalc_CurrencyTo (inAmountToPay_GRN, inCurrencyValueEUR, 1), 1) + inAmountToPay_EUR
                   ELSE -- переводим из ГРН в EUR + округление до 2х знаков
                        zfCalc_SummIn (1, zfCalc_CurrencyTo (inAmountToPay_GRN, inCurrencyValueEUR, 1), 1) + inAmountToPay_EUR
              END :: TFloat AS AmountToPay_curr

              -- сколько осталось оплатить, ГРН
            , CASE WHEN tmp.AmountDiff > 0 AND inCurrencyId_Client = zc_Currency_EUR()
                        -- переводим из EUR в ГРН + округление до 0 знаков
                        THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmp.AmountDiff, inCurrencyValueEUR, 1), 0)

                   WHEN tmp.AmountDiff > 0
                        -- сумма итак в ГРН
                        THEN tmp.AmountDiff

                   ELSE 0
              END :: TFloat AS AmountRemains

              -- сколько осталось оплатить, EUR + округление до 0 знаков
            , CASE WHEN tmp.AmountDiff > 0 AND inCurrencyId_Client = zc_Currency_EUR()
                        -- сумма итак в EUR - нельзя округлять
                        THEN tmp.AmountDiff

                   WHEN tmp.AmountDiff > 0
                        -- переводим из ГРН в EUR + ОКРУГЛЕНИЕ ?
                        THEN zfCalc_SummIn (1, zfCalc_CurrencyTo (tmp.AmountDiff, inCurrencyValueEUR, 1), 1)

                   ELSE 0
              END :: TFloat AS AmountRemains_curr


              -- Сдача, грн
            , CASE WHEN tmp.AmountDiff < 0 AND inCurrencyId_Client = zc_Currency_EUR() 
                        -- переводим из EUR в ГРН + округление до 0 знаков
                        THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (-1 * tmp.AmountDiff, inCurrencyValueEUR, 1), 0)

                   WHEN tmp.AmountDiff < 0
                        -- сумма итак в ГРН
                        THEN -1 * tmp.AmountDiff

                   ELSE 0
              END :: TFloat AS AmountDiff

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
