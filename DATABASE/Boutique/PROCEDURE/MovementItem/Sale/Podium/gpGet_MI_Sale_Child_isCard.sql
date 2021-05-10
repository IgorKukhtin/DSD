-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isCard (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isCard(
    IN inIsCard              Boolean  , --
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
             , AmountCard          TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountPay_GRN      TFloat;
   DECLARE vbAmountCard         TFloat;
   DECLARE vbAmountDiscount_GRN TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- сумма оплаты - ГРН
     vbAmountPay_GRN := COALESCE (inAmountGRN, 0)
                      + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                      + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                      + COALESCE (inAmountDiscount, 0)
                       ;
     -- сохранили
     vbAmountDiscount_GRN:= COALESCE (inAmountDiscount, 0);

     -- Сумма - ГРН
     IF inIsCard = TRUE
     THEN
         IF inAmountCard = 0
         THEN -- расчет остаток суммы
              vbAmountCard := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                        THEN -- Округлили к 0 знаков, разница попадет автоматом в списание
                                             zfCalc_SummPriceList (1, inAmountToPay - vbAmountPay_GRN)

                                        ELSE -- НЕ округлили
                                             inAmountToPay - vbAmountPay_GRN
                              END;

              -- если нет скидки, сформируем её и спишим "хвостик"
              IF vbAmountDiscount_GRN = 0
              THEN
                  -- пробуем списать весь остаток
                  vbAmountDiscount_GRN:= inAmountToPay - vbAmountCard;

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
              vbAmountCard := inAmountCard;

         END IF;

     ELSE
         -- обнулили
         vbAmountCard := 0;

         -- если все 0
         IF inAmountUSD = 0
        AND inAmountEUR = 0
        AND inAmountGRN = 0
         THEN
             -- Обнулили Дополнительная скидка
             vbAmountDiscount_GRN:= 0;
             -- пересчитали сумму с учетом нового AmountDiscount
             vbAmountPay_GRN:= 0;
         END IF;

     END IF;

     -- выровняли
     IF vbAmountCard < 0 THEN vbAmountCard:= 0; END IF;


     -- Результат
     RETURN QUERY
      WITH -- остаток к оплате - ГРН
           tmpData_all AS (SELECT inAmountToPay - (vbAmountPay_GRN + vbAmountCard) AS AmountDiff
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
                               , vbAmountCard AS AmountCard

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

             -- Расчетная сумма БН
           , tmpData.AmountCard

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
-- SELECT * FROM gpGet_MI_Sale_Child_isCard(inIsCard := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inCurrencyValueCross:= 1, inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN := 1.2 , inAmountUSD := 100 , inAmountEUR := 0 , inAmountCard:= 1, inAmountDiscount := 0.4 ,  inCurrencyId_Client:= zc_Currency_EUR(), inSession := '2');
