-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean, TFloat,TFloat,TFloat,TFloat,TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, Boolean,TFloat, Boolean,TFloat, Boolean,TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_Total(

    -- Установленные галки
    IN inisGRN               Boolean  , -- оплата грн
    IN inisUSD               Boolean  , -- оплата доллар
    IN inisEUR               Boolean  , -- оплата евро
    IN inisCard              Boolean  , -- оплата карта
    IN inisDiscount          Boolean  , -- Списать остаток

    -- Предыдущие значения галок
    IN inisGRNOld            Boolean  , -- оплата грн пред. значение
    IN inisUSDOld            Boolean  , -- оплата доллар пред. значение
    IN inisEUROld            Boolean  , -- оплата евро пред. значение
    IN inisCardOld           Boolean  , -- оплата карта пред. значение
    IN inisDiscountOld       Boolean  , -- Списать остаток пред. значение

    IN inCurrencyValueUSD    TFloat   , --
    IN inCurrencyValueInUSD  TFloat   , --
    IN inCurrencyValueEUR    TFloat   , --
    IN inCurrencyValueInEUR  TFloat   , --
    IN inCurrencyValueCross  TFloat   , --

    IN inAmountToPay_GRN     TFloat   , -- сумма к оплате, грн
    IN inAmountToPay_EUR     TFloat   , -- сумма к оплате, EUR

    IN inAmountGRN           TFloat   , --
    IN inAmountUSD           TFloat   , --
    IN inAmountEUR           TFloat   , --
    IN inAmountCard          TFloat   , --
    IN inAmountDiscount_EUR  TFloat   , -- всегда EUR
    IN inAmountDiscount      TFloat   , -- всегда ГРН
    IN inAmountDiff          TFloat   , -- сдачаГРН

    IN inisChangeEUR         Boolean  , --
    IN inAmountRemains       TFloat   , -- остаток в грн

    IN inisAmountRemains_EUR Boolean  , --
    IN inAmountRemains_EUR   TFloat   , --

    IN inisAmountDiff        Boolean  , --
    IN inAmountManualDiff    TFloat   , --


    IN inCurrencyId_Client   Integer  , --
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS TABLE (-- Информативно - для Диалога
               AmountToPay         TFloat -- К оплате, грн
             , AmountToPay_EUR     TFloat -- К оплате, EUR
               -- факт - отсюда долг
             , AmountToPayFull     TFloat
             , AmountToPayFull_EUR TFloat
               --
             , AmountRemains       TFloat -- Остаток, грн
             , AmountRemains_EUR   TFloat -- Остаток, EUR

               -- сдача, ГРН
             , AmountDiff          TFloat

               -- Дополнительная скидка грн.
             , AmountDiscount      TFloat
               -- Дополнительная скидка (целая часть)
             , AmountDiscRound     TFloat
               -- Дополнительная скидка (копейки)
             , AmountDiscDiff      TFloat
               -- Округление курсов по грн.
             , AmountRounding      TFloat

               -- Дополнительная скидка EUR
             , AmountDiscount_EUR  TFloat
               -- Дополнительная скидка EUR (целая часть)
             , AmountDiscRound_EUR TFloat
               -- Дополнительная скидка EUR (копейки)
             , AmountDiscDiff_EUR  TFloat
               -- Округление курсов по EUR
             , AmountRounding_EUR  TFloat

               -- Расчетная сумма
             , AmountGRN           TFloat
             , AmountUSD           TFloat
             , AmountEUR           TFloat
             , AmountCard          TFloat

               -- Расчетная сумма грн.
             , AmountToPay_Calc    TFloat
             , AmountToPay_EUR_Calc TFloat

             , isAmountRemains_EUR Boolean
             , isAmountDiff        Boolean

               -- Новые значения галок для замены предыдущих значений
             , isGRN               Boolean
             , isUSD               Boolean
             , isEUR               Boolean
             , isCard              Boolean
             , isDiscount          Boolean

               -- Новые значения галок для замены предыдущих значений
             , isGRNOld            Boolean
             , isUSDOld            Boolean
             , isEUROld            Boolean
             , isCardOld           Boolean
             , isDiscountOld       Boolean

               -- AmountPay - для отладки
             , AmountPay            TFloat
             , AmountPay_EUR        TFloat

             , AmountGRN_EUR        TFloat
             , AmountGRN_Over       TFloat

             , AmountUSD_EUR        TFloat
             , AmountUSD_Pay        TFloat
             , AmountUSD_Pay_GRN    TFloat
             , AmountUSD_Over       TFloat
             , AmountUSD_Over_GRN   TFloat

             , AmountEUR_Pay        TFloat
             , AmountEUR_Pay_GRN    TFloat
             , AmountEUR_Over       TFloat
             , AmountEUR_Over_GRN   TFloat

             , AmountCARD_EUR       TFloat
             , AmountCARD_Over      TFloat

             , AmountRest           TFloat
             , AmountRest_EUR       TFloat

               -- Итоговые обороты по валютам (должно быть 0)
             , AmountDiffFull_GRN   TFloat
             , AmountDiffFull_EUR   TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCurrencyValueUSD NUMERIC (20, 10);

   DECLARE vbAmountPay_GRN       TFloat;
   DECLARE vbAmountPay_EUR       TFloat;

   DECLARE
     -- К оплате
     vbAmountToPay_EUR     TFloat;
      -- без округл
     vbAmountToPayFull_GRN TFloat;
      -- с округл
     vbAmountToPay_GRN     TFloat;

     -- оплата - GRN
     vbPayGRN      TFloat;
     vbPayGRN_eur  TFloat;

     -- оплата - USD
     vbPayUSD      TFloat;
     vbPayUSD_eur  TFloat;
     vbPayUSD_grn  TFloat;

     -- оплата - EUR
     vbPayEUR      TFloat;
     vbPayEUR_grn  TFloat;

     -- оплата - Card
     vbPayCard     TFloat;
     vbPayCard_eur TFloat;

     -- долг
     vbRem_GRN     TFloat;
     -- долг
     vbRem_EUR     TFloat;

     -- сдача
     vbAmountDiff TFloat;

     -- Дополнительная скидка EUR - округления
     vbRoundDiscount_EUR TFloat;
     -- Дополнительная скидка GRN - округления
     vbRoundDiscount_GRN TFloat;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !замена! Курс, будем пересчитывать из-за кросс-курса без округления
     inCurrencyValueCross := CASE WHEN inCurrencyValueCross > 0 THEN inCurrencyValueCross ELSE 1 END;
     vbCurrencyValueUSD:= inCurrencyValueEUR::NUMERIC (20, 10) / inCurrencyValueCross::NUMERIC (20, 10);

     IF inAmountGRN < 0 THEN inAmountGRN := 0; END IF;
     IF inAmountUSD < 0 THEN inAmountUSD := 0; END IF;
     IF inAmountEUR < 0 THEN inAmountEUR := 0; END IF;
     IF inAmountCard < 0 THEN inAmountCard :=0; END IF;


     IF inisAmountRemains_EUR = TRUE AND COALESCE (inAmountRemains_EUR, 0) > inAmountToPay_EUR
     THEN
        RAISE EXCEPTION 'Ошибка. Сумма введеннго долга % превышает сумму к оплате %', inAmountRemains_EUR, inAmountToPay_EUR;
     ELSEIF inisAmountRemains_EUR = TRUE AND COALESCE (inAmountRemains_EUR, 0) < 0
     THEN
        RAISE EXCEPTION 'Ошибка. Сумма введеннго долга % должна біть положительной', inAmountRemains_EUR;
     ELSEIF COALESCE (inAmountDiscount_EUR, 0) > inAmountToPay_EUR
     THEN
        RAISE EXCEPTION 'Ошибка. Сумма введеннго списания при округлении % превышает сумму к оплате %', inAmountDiscount_EUR, inAmountToPay_EUR;
     ELSEIF COALESCE (inAmountDiscount_EUR, 0) < - 0.5
     THEN
        RAISE EXCEPTION 'Ошибка. Сумма введеннго списания при округлении % должна быть положительной', inAmountDiscount_EUR;
     END IF;


     -- К оплате
     vbAmountToPay_EUR    := inAmountToPay_EUR;
   --vbAmountToPay_EUR    := inAmountToPay_EUR - inAmountDiscount_EUR;
      -- без округл
     vbAmountToPayFull_GRN:= zfCalc_CurrencyFrom (vbAmountToPay_EUR, inCurrencyValueEUR, 1);
      -- с округл
     vbAmountToPay_GRN    := ROUND (vbAmountToPayFull_GRN, 0);

     -- оплата - GRN
     vbPayGRN:= inAmountGRN;
     vbPayGRN_eur:= zfCalc_CurrencyTo_2 (vbPayGRN, inCurrencyValueEUR, 1); -- с округл до 2-х

     -- оплата - USD
     vbPayUSD    := inAmountUSD;
     vbPayUSD_eur:= ROUND (vbPayUSD / inCurrencyValueCross, 2);
     vbPayUSD_grn:= zfCalc_CurrencyFrom_2 (vbPayUSD, inCurrencyValueUSD, 1); -- с округл до 2-х

     -- оплата - EUR
     vbPayEUR    := inAmountEUR;
     vbPayEUR_grn:= zfCalc_CurrencyFrom_2 (vbPayEUR, inCurrencyValueEUR, 1); -- с округл до 2-х

     -- оплата - Card
     vbPayCard:= inAmountCard;
     vbPayCard_eur:= zfCalc_CurrencyTo_2 (vbPayCard, inCurrencyValueEUR, 1); -- с округл до 2-х

     -- долг
     vbRem_GRN:= vbAmountToPayFull_GRN
               - vbPayGRN
               - vbPayUSD_grn
               - vbPayEUR_grn
               - vbPayCard
               -- МИНУС Дополнительная скидка ГРН - !!!оригинал!!!
               - zfCalc_CurrencyFrom_2 (inAmountDiscount_EUR, inCurrencyValueEUR, 1)
                ;

     -- долг
     vbRem_EUR:= vbAmountToPay_EUR
               - vbPayGRN_eur
               - vbPayUSD_eur
               - vbPayEUR
               - vbPayCard_eur
               -- МИНУС Дополнительная скидка - !!!оригинал!!!
               - inAmountDiscount_EUR
                ;

     -- если сдача
     IF vbRem_EUR < 0
     THEN
         -- сдача
         IF vbRem_GRN < 0 THEN vbAmountDiff:= -1 * vbRem_GRN; ELSE vbRem_GRN:= 0; END IF;
         --
         vbRem_GRN:= 0;
         vbRem_EUR:= 0;
         -- посчитали сколько будет в обмене
         -- ............

     END IF;


     -- Дополнительная скидка EUR - округления
     vbRoundDiscount_EUR := vbRem_EUR - ROUND (vbRem_EUR, 0);
     -- Дополнительная скидка GRN - округления
     vbRoundDiscount_GRN := vbRem_GRN - ROUND (vbRem_GRN, 0);

     -- долг, скорректировали
     vbRem_EUR:= vbRem_EUR - vbRoundDiscount_EUR;
     -- долг, скорректировали
     vbRem_GRN:= vbRem_GRN - vbRoundDiscount_GRN;


     -- Результат
     RETURN QUERY
      SELECT -- К оплате, грн - здесь округлили
             vbAmountToPay_GRN AS AmountToPay
             -- К оплате, EUR - здесь округлили
           , vbAmountToPay_EUR AS AmountToPay_EUR

             -- К оплате, грн - НЕ округлили
           , vbAmountToPayFull_GRN AS AmountToPayFull
             -- К оплате, EUR - НЕ округлили
           , vbAmountToPay_EUR     AS AmountToPayFull_EUR

             -- сколько осталось оплатить, ГРН
           , vbRem_GRN AS AmountRemains
             -- сколько осталось оплатить, EUR
           , vbRem_EUR AS AmountRemains_EUR

             -- Сдача, грн
           , vbAmountDiff AS AmountDiff


             -- Дополнительная скидка - ГРН - !!!оригинал!!!
           , zfCalc_CurrencyFrom_2 (inAmountDiscount_EUR, inCurrencyValueEUR, 1) AS AmountDiscount
             -- Дополнительная скидка - ГРН
           , 0 :: TFloat AS AmountDiscRound
             -- Округление - ГРН
           , vbRoundDiscount_GRN :: TFloat AmountDiscDiff
             -- Округлениее курсов - ГРН
           , 0 :: TFloat AmountRounding


             -- Дополнительная скидка - EUR -  !!!оригинал!!!
           , inAmountDiscount_EUR AS AmountDiscount_EUR
             -- Дополнительная скидка - EUR
           , 0 :: TFloat AS AmountDiscRound_EUR

             -- Округление - EUR
           , vbRoundDiscount_EUR AS AmountDiscDiff_EUR
             -- Округлениее курсов - EUR
           , 0 :: TFloat AS AmountRounding_EUR

           , vbPayGRN  AS AmountGRN
           , vbPayUSD  AS AmountUSD
           , vbPayEUR  AS AmountEUR
           , vbPayCard AS AmountCard

           , 0 :: TFloat AS AmountToPay_Calc
           , 0 :: TFloat AS AmountToPay_EUR_Calc

           , FALSE       AS isAmountRemains_EUR
           , FALSE       AS isAmountDiff

             -- В контрол - значения галок
           , vbPayGRN > 0, vbPayUSD > 0, vbPayEUR > 0, vbPayCard > 0
           , vbRoundDiscount_EUR <> 0 OR vbRoundDiscount_GRN <> 0 OR inAmountDiscount_EUR <> 0

             -- для сохранения - значения галок
           , vbPayGRN > 0, vbPayUSD > 0, vbPayEUR > 0, vbPayCard > 0
           , vbRoundDiscount_EUR <> 0 OR vbRoundDiscount_GRN <> 0 OR inAmountDiscount_EUR <> 0

             -- AmountPay, ГРН
           , (vbPayGRN + vbPayUSD_grn + vbPayEUR_grn + vbPayCard)     :: TFloat AS AmountPay
             -- AmountPay, EUR
           , (vbPayGRN_eur + vbPayUSD_eur + vbPayEUR + vbPayCard_eur) :: TFloat AS AmountPay_EUR

           , vbPayGRN_eur AS AmountGRN_EUR
           , 0 :: TFloat  AS AmountGRN_Over

           , vbPayUSD_eur AS AmountUSD_EUR
           , vbPayUSD     AS AmountUSD_Pay
           , vbPayUSD_grn AS AmountUSD_Pay_GRN
           , 0 :: TFloat  AS AmountUSD_Over
           , 0 :: TFloat  AS AmountUSD_Over_GRN

           , vbPayEUR     AS AmountEUR_Pay
           , vbPayEUR_grn AS AmountEUR_Pay_GRN
           , 0 :: TFloat  AS AmountEUR_Over
           , 0 :: TFloat  AS AmountEUR_Over_GRN

           , 0 :: TFloat  AS AmountCARD_EUR
           , 0 :: TFloat  AS AmountCARD_Over

           , 0 :: TFloat  AS AmountRest
           , 0 :: TFloat  AS AmountRest_EUR

             -- Итоговые обороты по валютам (должно быть 0)
           , 0 :: TFloat  AS AmountDiffFull_GRN
           , 0 :: TFloat  AS AmountDiffFull_EUR

      FROM lpGet_MI_Sale_Child_TotalCalc(inCurrencyValueUSD       := inCurrencyValueUSD
                                       , inCurrencyValueInUSD     := inCurrencyValueInUSD
                                       , inCurrencyValueEUR       := inCurrencyValueEUR
                                       , inCurrencyValueInEUR     := inCurrencyValueInEUR
                                       , inCurrencyValueCross     := inCurrencyValueCross

                                       , inAmountToPay_EUR        := inAmountToPay_EUR

                                       , inAmountGRN              := inAmountGRN
                                       , inAmountUSD              := inAmountUSD
                                       , inAmountEUR              := inAmountEUR
                                       , inAmountCard             := inAmountCard
                                       , inAmountDiscount_EUR     := inAmountDiscount_EUR

                                       , inisDiscount             := inisDiscount
                                       , inisChangeEUR            := inisChangeEUR
                                       , inisAmountRemains_EUR    := inisAmountRemains_EUR
                                       , inAmountRemains_EUR      := inAmountRemains_EUR
                                       , inisAmountDiff           := inisAmountDiff
                                       , inAmountDiff             := inAmountManualDiff
                                       , inCurrencyId_Client      := inCurrencyId_Client
                                       , inUserId                 := vbUserId) AS Res
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 22.05.17         *
*/

-- тест
--
/*
select * from gpGet_MI_Sale_Child_Total(inisGRN := 'False' , inisUSD := 'True' , inisEUR := 'False' , inisCard := 'True' , inisDiscount := 'True' ,
                                        inisGRNOld := 'False' , inisUSDOld := 'True' , inisEUROld := 'False' , inisCardOld := 'True' , inisDiscountOld := 'True' ,
                                        inCurrencyValueUSD := 37.68 , inCurrencyValueInUSD := 37.31 , inCurrencyValueEUR := 40.95 , inCurrencyValueInEUR := 40.54 , inCurrencyValueCross := 1.09 ,
                                        inAmountToPay_GRN := 18468.45 , inAmountToPay_EUR := 451 ,
                                        inAmountGRN := 0 , inAmountUSD := 200 , inAmountEUR := 0 , inAmountCard := 10900 , inAmountDiscount_EUR := 283 , inAmountDiscount := 5807.79 , inAmountDiff := 0 ,
                                        inisChangeEUR := 'True' , inAmountRemains := 0 ,
                                        inisAmountRemains_EUR := 'False' , inAmountRemains_EUR := 0 , inisAmountDiff := 'False' , inAmountManualDiff := -10 ,
                                        inCurrencyId_Client := 18101 ,  inSession := '2');
*/
