-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean, TFloat,TFloat,TFloat,TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, Boolean,TFloat, Boolean,TFloat, Boolean,TFloat, Integer, TVarChar);

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
             
             , AmountOver_GRN       TFloat

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
   DECLARE vbAmountDiffLeft_GRN  TFloat;   
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
     
     
     --inAmountDiscount_EUR := Round(inAmountDiscount_EUR);

     /*IF inisAmountRemains_EUR = TRUE AND COALESCE (inAmountRemains_EUR, 0) > inAmountToPay_EUR
     THEN
        RAISE EXCEPTION 'Ошибка. Сумма введеннго долга % превышает сумму к оплате %', inAmountRemains_EUR, inAmountToPay_EUR;
     ELSE*/
     
     IF inisAmountRemains_EUR = TRUE AND COALESCE (inAmountRemains_EUR, 0) < 0
     THEN
        RAISE EXCEPTION 'Ошибка. Сумма введеннго долга % должна біть положительной', inAmountRemains_EUR;
     /*ELSEIF COALESCE (inAmountDiscount_EUR, 0) > inAmountToPay_EUR
     THEN
        RAISE EXCEPTION 'Ошибка. Сумма введеннго списания при округлении % превышает сумму к оплате %', inAmountDiscount_EUR, inAmountToPay_EUR;
     ELSEIF COALESCE (inAmountDiscount_EUR, 0) < - 0.5
     THEN
        RAISE EXCEPTION 'Ошибка. Сумма введеннго списания при округлении % должна быть положительной', inAmountDiscount_EUR;*/
     END IF;
     
     inAmountToPay_GRN := zfCalc_CurrencyFrom ( COALESCE (inAmountToPay_EUR, 0), inCurrencyValueEUR, 1);
     
          
     -- сумма оплаты - EUR
     vbAmountPay_EUR := ROUND(zfCalc_CurrencyTo (inAmountGRN, inCurrencyValueEUR, 1) 
                            + COALESCE (inAmountEUR, 0)
                            + Round ( inAmountUSD / inCurrencyValueCross, 2)
                            + zfCalc_CurrencyTo (inAmountCard, inCurrencyValueEUR, 1)
                            + COALESCE (inAmountDiscount_EUR, 0)
                           , 2) ;

     -- сумма оплаты - ГРН
     vbAmountPay_GRN := COALESCE (inAmountGRN, 0)
                      + zfCalc_CurrencyFrom ( COALESCE (inAmountEUR, 0), inCurrencyValueEUR, 1)
                      + Round ( inAmountUSD * vbCurrencyValueUSD, 1)
                      + COALESCE (inAmountCard, 0)
                      + zfCalc_CurrencyFrom ( COALESCE (inAmountDiscount_EUR, 0), inCurrencyValueEUR, 1)
                       ;

     -- На всякий случай обнулили   
     IF inisAmountRemains_EUR = FALSE THEN inAmountRemains_EUR := 0; END IF;
     IF inisAmountDiff = FALSE THEN inAmountManualDiff := 0; END IF;
       
     -- *** Сумма - ГРН
     IF inisGRN = FALSE AND inisGRNOld = FALSE AND COALESCE (inAmountGRN, 0) > 0 
     THEN
       inisGRN := True;
       inisGRNOld = True;
     ELSEIF inisGRN = TRUE AND inisGRNOld = TRUE AND COALESCE (inAmountGRN, 0) = 0
     THEN
       inisGRN := False;
       inisGRNOld = False;
     ELSEIF inisGRN = TRUE AND inisGRNOld = FALSE AND COALESCE (inAmountGRN, 0) = 0
     THEN
        -- расчет остаток суммы
        inAmountGRN := CASE WHEN inCurrencyId_Client = zc_Currency_EUR() AND Round(inAmountRemains) <= 0
                            THEN -- Если оплачено на всчкий случай чтоб минус не получить
                                 0
                            WHEN inCurrencyId_Client = zc_Currency_EUR()
                            THEN -- Округлили к 0 знаков, разница попадет автоматом в списание
                                 Round(inAmountRemains)
                            ELSE
                                 inAmountToPay_GRN - vbAmountPay_GRN
                       END;
     END IF;
     -- Обнулили гривны после снятия галки                        
     IF inisGRN = False AND inisGRNOld = TRUE
     THEN
        -- расчет остаток суммы
        inAmountGRN := 0;
     END IF;
       
     -- *** Сумма - EUR
     IF inisEUR = FALSE AND inisEUROld = FALSE AND COALESCE (inAmountEUR, 0) > 0 
     THEN
       inisEUR := True;
       inisEUROld = True;
     ELSEIF inisEUR = TRUE AND inisEUROld = TRUE AND COALESCE (inAmountEUR, 0) = 0
     THEN
       inisEUR := False;
       inisEUROld = False;
     ELSEIF inisEUR = TRUE AND inisEUROld = FALSE AND COALESCE (inAmountEUR, 0) = 0
     THEN
        -- расчет остаток суммы
        inAmountEUR := CASE WHEN inCurrencyId_Client = zc_Currency_EUR() AND Round (COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR) <= 0
                            THEN -- Если оплачено на всчкий случай чтоб минус не получить
                                 0
                            WHEN inCurrencyId_Client = zc_Currency_EUR()
                            THEN -- Округлили к 100 знаков, разница попадет автоматом в доплату гривнами
                                 Round (COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR, -2)
                            ELSE -- НЕ округлили
                                 zfCalc_CurrencyTo (inAmountToPay_GRN - vbAmountPay_GRN, inCurrencyValueEUR, 1)
                       END;

     END IF;
     -- Обнулили EUR после снятия галки                        
     IF inisEUR = False AND inisEUROld = TRUE
     THEN
        -- расчет остаток суммы
        inAmountEUR := 0;
     END IF;

     -- *** Сумма - USD
     IF inisUSD = FALSE AND inisUSDOld = FALSE AND COALESCE (inAmountUSD, 0) > 0 
     THEN
       inisUSD := True;
       inisUSDOld = True;
     ELSEIF inisUSD = TRUE AND inisUSDOld = TRUE AND COALESCE (inAmountUSD, 0) = 0
     THEN
       inisUSD := False;
       inisUSDOld = False;
     ELSEIF inisUSD = TRUE AND inisUSDOld = FALSE AND COALESCE (inAmountUSD, 0) = 0
     THEN
        -- расчет остаток суммы
        inAmountUSD := CASE WHEN inCurrencyId_Client = zc_Currency_EUR() AND Round((COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR) * inCurrencyValueCross) <= 0
                            THEN -- Если оплачено на всчкий случай чтоб минус не получить
                                 0
                            WHEN inCurrencyId_Client = zc_Currency_EUR()
                            THEN -- Округлили к 0 знаков, разница попадет автоматом в доплату гривнами
                                 Round((COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR) * inCurrencyValueCross, -2)
                            ELSE -- НЕ округлили
                                 zfCalc_CurrencyTo (inAmountToPay_GRN - vbAmountPay_GRN, vbCurrencyValueUSD, 1)
                       END;

     END IF;
     -- Обнулили USD после снятия галки                        
     IF inisUSD = False AND inisUSDOld = TRUE
     THEN
        -- расчет остаток суммы
        inAmountUSD := 0;
     END IF;

     -- *** Сумма - ГРН по карте
     IF inisCard = FALSE AND inisCardOld = FALSE AND COALESCE (inAmountCard, 0) > 0 
     THEN
       inisCard := True;
       inisCardOld = True;
     ELSEIF inisCard = TRUE AND inisCardOld = TRUE AND COALESCE (inAmountCard, 0) = 0
     THEN
       inisCard := False;
       inisCardOld = False;
     ELSEIF inisCard = TRUE AND inisCardOld = FALSE AND COALESCE (inAmountCard, 0) = 0
     THEN
        -- расчет остаток суммы
        inAmountCard := CASE WHEN inCurrencyId_Client = zc_Currency_EUR() AND Round(inAmountRemains) <= 0
                             THEN -- Если оплачено на всчкий случай чтоб минус не получить
                                  0
                             WHEN inCurrencyId_Client = zc_Currency_EUR()
                             THEN -- Округлили к 0 знаков, разница попадет автоматом в списание
                                  Round(inAmountRemains)
                             ELSE
                                  inAmountToPay_GRN - vbAmountPay_GRN
                        END;
     END IF;
     -- Обнулили ГРН по карте после снятия галки                        
     IF inisCard = False AND inisCardOld = TRUE
     THEN
        -- расчет остаток суммы
        inAmountCard := 0;
     END IF;
          
     -- Устанавливаем сумму списания
     IF inisDiscount = TRUE AND inisDiscountOld = FALSE AND COALESCE (inAmountDiscount_EUR, 0) = 0
     THEN
 
        -- расчет остаток суммы
        inAmountDiscount_EUR := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                     THEN -- Округлили к 100 знаков, разница попадет автоматом в доплату гривнами
                                          COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR
                                     ELSE -- НЕ округлили
                                          zfCalc_CurrencyTo (inAmountToPay_GRN - vbAmountPay_GRN, inCurrencyValueEUR, 1)
                                END;
                                
        inisAmountDiff := True;
        inAmountManualDiff := 0;
     END IF;
     -- Обнулили ГРН по карте после снятия галки                        
     IF inisDiscount = False AND inisDiscountOld = TRUE
     THEN
        -- расчет остаток суммы
        inAmountDiscount_EUR := 0;
        inAmountDiscount := 0;
     END IF;
     
     IF inisAmountRemains_EUR = TRUE
     THEN
       inAmountDiscount_EUR := COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR - inAmountRemains_EUR + inAmountDiscount_EUR;
       inisAmountRemains_EUR := False;
     END IF;
                                                      
     -- Результат
     RETURN QUERY
      SELECT -- К оплате, грн - здесь округлили
             Res.AmountToPay
             -- К оплате, EUR - здесь округлили
           , Res.AmountToPay_EUR

             -- К оплате, грн - НЕ округлили
           , Res.AmountToPayFull
             -- К оплате, EUR - НЕ округлили
           , Res.AmountToPayFull_EUR

             -- сколько осталось оплатить, ГРН
           , Res.AmountRemains
             -- сколько осталось оплатить, EUR
           , Res.AmountRemains_EUR

             -- Сдача, грн
           , Res.AmountDiff

             -- Дополнительная скидка - ГРН
           , Res.AmountDiscount                                                  AS AmountDiscount
             -- Дополнительная скидка - ГРН
           , round(Res.AmountDiscount)::TFloat                                   AS AmountDiscRound
             -- Округление - ГРН
           , (Res.AmountDiscount - round(Res.AmountDiscount))::TFloat            AS AmountDiscDiff
             -- Округлениее курсов - ГРН
           , Res.AmountRounding


             -- Дополнительная скидка - EUR
           , Res.AmountDiscount_EUR                                              AS AmountDiscount_EUR
             -- Дополнительная скидка - EUR
           , round(Res.AmountDiscount_EUR)::TFloat                               AS AmountDiscRound_EUR
             -- Округление - EUR
           , (Res.AmountDiscount_EUR - round(Res.AmountDiscount_EUR))::TFloat    AS AmountDiscDiff_EUR
             -- Округлениее курсов - EUR
           , Res.AmountRounding_EUR

           , Res.AmountGRN
           , Res.AmountUSD
           , Res.AmountEUR
           , Res.AmountCard
           
           , Res.AmountToPay_Calc
           , Res.AmountToPay_EUR_Calc
           
           , FALSE                                                              AS isAmountRemains_EUR
           , FALSE                                                              AS isAmountDiff

           
           , Res.AmountGRN > 0, Res.AmountUSD > 0, Res.AmountEUR > 0, Res.AmountCard > 0
           , ABS(Res.AmountDiscount_EUR) >= 1 OR ABS(Res.AmountDiscount) >= 5 AND Res.AmountDiff = 0 AND (Res.AmountGRN_Over + Res.AmountUSD_Over_GRN + Res.AmountEUR_Over_GRN + Res.AmountCARD_Over) > 0
           , Res.AmountGRN > 0, Res.AmountUSD > 0, Res.AmountEUR > 0, Res.AmountCard > 0
           , ABS(Res.AmountDiscount_EUR) >= 1 OR ABS(Res.AmountDiscount) >= 5 AND Res.AmountDiff = 0 AND (Res.AmountGRN_Over + Res.AmountUSD_Over_GRN + Res.AmountEUR_Over_GRN + Res.AmountCARD_Over) > 0

             -- AmountPay, ГРН
           , Res.AmountPay
             -- AmountPay, EUR
           , Res.AmountPay_EUR

           , Res.AmountGRN_EUR
           , Res.AmountGRN_Over

           , Res.AmountUSD_EUR
           , Res.AmountUSD_Pay
           , Res.AmountUSD_Pay_GRN
           , Res.AmountUSD_Over
           , Res.AmountUSD_Over_GRN

           , Res.AmountEUR_Pay
           , Res.AmountEUR_Pay_GRN
           , Res.AmountEUR_Over
           , Res.AmountEUR_Over_GRN

           , Res.AmountCARD_EUR
           , Res.AmountCARD_Over
           
           , Res.AmountOver_GRN

           , Res.AmountRest
           , Res.AmountRest_EUR

             -- Итоговые обороты по валютам (должно быть 0)
           , Res.AmountDiffFull_GRN
           , Res.AmountDiffFull_EUR
           
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

/*select * from gpGet_MI_Sale_Child_Total(inisGRN := 'False' , inisUSD := 'False' , inisEUR := 'False' , inisCard := 'False' , inisDiscount := 'True' , 
                                        inisGRNOld := 'False' , inisUSDOld := 'False' , inisEUROld := 'False' , inisCardOld := 'False' , inisDiscountOld := 'False' , 
                                        inCurrencyValueUSD := 37.68 , inCurrencyValueInUSD := 37.31 , inCurrencyValueEUR := 40.95 , inCurrencyValueInEUR := 40.54 , inCurrencyValueCross := 1.01 , 
                                        inAmountToPay_GRN := 18468.45 , inAmountToPay_EUR := 451 , 
                                        inAmountGRN := 0 , inAmountUSD := 0 , inAmountEUR := 0 , inAmountCard := 0 , inAmountDiscount_EUR := 0 , inAmountDiscount := 0 , inAmountDiff := 0 , 
                                        inisChangeEUR := 'False' , inAmountRemains := 18468 , 
                                        inisAmountRemains_EUR := 'False' , inAmountRemains_EUR := 0 , inisAmountDiff := 'False' , inAmountManualDiff := 0 , inAmountOver_GRN := 0 , 
                                        inCurrencyId_Client := 18101 ,  inSession := '2');*/