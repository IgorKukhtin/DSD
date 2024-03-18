-- Function: lpGet_MI_Sale_Child_TotalCalc()

DROP FUNCTION IF EXISTS lpGet_MI_Sale_Child_TotalCalc (TFloat,TFloat,TFloat,TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TFloat, TFloat, Boolean, Boolean, Boolean,TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_MI_Sale_Child_TotalCalc(

    IN inCurrencyValueUSD    TFloat   , --
    IN inCurrencyValueInUSD  TFloat   , --
    IN inCurrencyValueEUR    TFloat   , --
    IN inCurrencyValueInEUR  TFloat   , --
    IN inCurrencyValueCross  TFloat   , --

    IN inAmountToPay_EUR     TFloat   , -- сумма к оплате, EUR
    
    IN inAmountGRN           TFloat   , --
    IN inAmountUSD           TFloat   , --
    IN inAmountEUR           TFloat   , --
    IN inAmountCard          TFloat   , --
    IN inAmountDiscount_EUR  TFloat   , -- всегда EUR
    IN inAmountDiscDiff_EUR  TFloat   , -- всегда EUR
        
    IN inisDiscount          Boolean  , -- Списать остаток
    IN inisChangeEUR         Boolean  , -- Расчет от евро
    IN inisAmountDiff        Boolean  , -- Ручная сдача
    IN inAmountDiff          TFloat   , -- Сумма ручной сдачи
    

    IN inCurrencyId_Client   Integer  , --
    IN inUserId              Integer     -- Ключ
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

               -- Расчетная сумма
             , AmountGRN           TFloat
             , AmountUSD           TFloat
             , AmountEUR           TFloat
             , AmountCard          TFloat
               -- Дополнительная скидка евро
             , AmountDiscount_EUR  TFloat
               -- Дополнительная скидка евро по округлению сдачи
             , AmountDiscDiff_EUR  TFloat

               -- Дополнительная скидка грн.
             , AmountDiscount      TFloat
               -- сдача, ГРН
             , AmountDiff          TFloat

               -- Округлениее курсов
             , AmountRounding      TFloat
             , AmountRounding_EUR  TFloat
             
                          
               -- Расчетная сумма грн.
             , AmountToPay_Calc    TFloat
             , AmountToPay_EUR_Calc TFloat

               -- AmountPay - для отладки
             , AmountPay            TFloat
             , AmountPay_EUR        TFloat

             , AmountGRN_EUR        TFloat
             , AmountGRN_Pay        TFloat
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
             , AmountCARD_Pay       TFloat
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
   DECLARE vbAmountPay_GRN       TFloat;
   DECLARE vbAmountPay_EUR       TFloat;

   DECLARE vbAmountToPay_Calc    TFloat;
   DECLARE vbAmountToPay_EUR_Calc  TFloat;
   DECLARE vbAmountToPay_GRN     TFloat;
   DECLARE vbAmountToPay_EUR     TFloat;

   DECLARE vbAmountDiscount      TFloat;
   
   DECLARE vbAmountRounding      TFloat;
   DECLARE vbAmountRounding_EUR  TFloat;
   
   DECLARE vbAmountRemains       TFloat;
   DECLARE vbAmountRemains_EUR   TFloat;

   DECLARE vbAmountRest          TFloat;
   DECLARE vbAmountRest_EUR      TFloat;
   DECLARE vbAmountRest_USD      TFloat;
   
   DECLARE vbAmountOverpay_GRN   TFloat;
   DECLARE vbAmountOverpay_CARD  TFloat;
   DECLARE vbAmountOverpay_EUR   TFloat;
   DECLARE vbAmountOverpay_USD   TFloat;
   
   DECLARE vbAmountEUR_Over_GRN  TFloat;
   DECLARE vbAmountUSD_Over_GRN  TFloat;
             
   DECLARE vbAmountDiff          TFloat;
BEGIN

     -- !замена! Курс, будем пересчитывать из-за кросс-курса без округления
     inCurrencyValueCross := CASE WHEN inCurrencyValueCross > 0 THEN inCurrencyValueCross ELSE 1 END;
     
     --raise notice 'Value: %  % % % % %  % % % %' , inAmountToPay_EUR, inAmountGRN, inAmountUSD, inAmountEUR, inAmountCard, inisDiscount, inAmountDiscount_EUR, inisChangeEUR, inisAmountDiff, inAmountDiff;
     

     IF inAmountGRN < 0 THEN inAmountGRN := 0; END IF;
     IF inAmountUSD < 0 THEN inAmountUSD := 0; END IF;
     IF inAmountEUR < 0 THEN inAmountEUR := 0; END IF;
     IF inAmountCard < 0 THEN inAmountCard :=0; END IF;
     -- IF inAmountDiscount_EUR < 0 THEN inAmountDiscount_EUR :=0; END IF;

     vbAmountToPay_EUR := CASE WHEN COALESCE(inAmountToPay_EUR, 0) - COALESCE(inAmountDiscount_EUR, 0) - COALESCE(inAmountDiscDiff_EUR, 0) > 0 
                               THEN COALESCE (inAmountToPay_EUR, 0) - COALESCE(inAmountDiscount_EUR, 0) - COALESCE(inAmountDiscDiff_EUR, 0) ELSE 0 END;

     vbAmountToPay_EUR_Calc := COALESCE (vbAmountToPay_EUR, 0);

     vbAmountToPay_GRN := Round(zfCalc_CurrencyFrom (vbAmountToPay_EUR, inCurrencyValueEUR, 1), 2);
     vbAmountToPay_Calc := Round(zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1), 2);

     inAmountGRN := COALESCE (inAmountGRN, 0);
     inAmountUSD := COALESCE (inAmountUSD, 0);
     inAmountEUR := COALESCE (inAmountEUR, 0);
     inAmountCard := COALESCE (inAmountCard, 0);
     inAmountDiscount_EUR := COALESCE (inAmountDiscount_EUR, 0);

     vbAmountDiscount := 0; 
     vbAmountRemains := 0; vbAmountRemains_EUR := 0;
     vbAmountPay_GRN := 0; vbAmountPay_EUR := 0; vbAmountDiff := 0;
     vbAmountRest := 0; vbAmountRest_EUR := 0; vbAmountRest_USD := 0;
     vbAmountOverpay_GRN := 0; vbAmountOverpay_CARD := 0; vbAmountOverpay_EUR := 0; vbAmountOverpay_USD := 0;

     vbAmountRounding := 0; vbAmountRounding_EUR := 0;
          
     -- определили начальные данные для дальнейшего расчета по валютам
     IF vbAmountToPay_EUR < inAmountEUR
     THEN
       vbAmountRest_EUR := 0; 
       vbAmountRest := 0; 
       vbAmountRest_USD := 0;
       -- Оплата гривна и евро
       vbAmountPay_GRN := Round(zfCalc_CurrencyFrom (vbAmountToPay_EUR, inCurrencyValueEUR, 1), 2);
       vbAmountPay_EUR := vbAmountToPay_EUR;     
       -- Переплата евро
       vbAmountOverpay_EUR := inAmountEUR - vbAmountToPay_EUR;
     ELSEIF inAmountUSD = 0
     THEN
       vbAmountRest_EUR := vbAmountToPay_EUR - inAmountEUR; 
       vbAmountRest := Round(zfCalc_CurrencyFrom (vbAmountRest_EUR, inCurrencyValueEUR, 1), 2);
       vbAmountRest_USD := Round(zfCalc_CurrencyFrom (vbAmountRest_EUR, inCurrencyValueCross, 1), 2);    
       -- Оплата гривна и евро
       vbAmountPay_GRN := Round(zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1), 2);
       vbAmountPay_EUR := inAmountEUR;     
     ELSE
       vbAmountRest_EUR := vbAmountToPay_EUR - inAmountEUR; 
       vbAmountRest_USD := Round(zfCalc_CurrencyFrom (vbAmountRest_EUR, inCurrencyValueCross, 1), 2);    
       
       -- Оплата гривна и евро если есть евро
       vbAmountPay_GRN := Round(zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1), 2);
       vbAmountPay_EUR := inAmountEUR;     

       IF inAmountUSD < vbAmountRest_USD
       THEN
         -- Оплата гривна и евро
         vbAmountPay_GRN := vbAmountPay_GRN + Round(zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1), 2);
         vbAmountPay_EUR := vbAmountPay_EUR + Round(inAmountUSD / inCurrencyValueCross, 2);     

         vbAmountRest_EUR := vbAmountRest_EUR - Round(inAmountUSD / inCurrencyValueCross, 2); 
         IF vbAmountRest_EUR < 0 THEN vbAmountRest_EUR := 0; END IF;
         vbAmountRest_USD := vbAmountRest_USD - inAmountUSD;    

         IF inisChangeEUR = TRUE
         THEN
           vbAmountRest := Round(zfCalc_CurrencyFrom (vbAmountRest_EUR, inCurrencyValueEUR, 1), 2);
         ELSE
           vbAmountRest := Round(zfCalc_CurrencyFrom (vbAmountRest_USD, inCurrencyValueUSD, 1), 2);
         END IF;         

       ELSE
         vbAmountOverpay_USD := inAmountUSD - vbAmountRest_USD;
         -- Оплата гривна и евро
         vbAmountPay_GRN := vbAmountPay_GRN + Round(zfCalc_CurrencyFrom (vbAmountRest_USD, inCurrencyValueUSD, 1), 2);
         vbAmountPay_EUR := vbAmountPay_EUR + Round(vbAmountRest_USD / inCurrencyValueCross, 2);     

         vbAmountRest_EUR := 0;
         vbAmountRest := 0;
         vbAmountRest_USD := 0;
       
       END IF;       
     END IF;

     -- Оплата карта
     IF inAmountCard > 0
     THEN
       IF vbAmountRest <= 0
       THEN
         
         vbAmountOverpay_CARD := inAmountCard;
       
       ELSEIF inAmountCard > vbAmountRest
       THEN

         vbAmountPay_GRN := vbAmountPay_GRN + vbAmountRest;
         vbAmountPay_EUR := vbAmountPay_EUR + Round(zfCalc_CurrencyTo (vbAmountRest, inCurrencyValueEUR, 1), 2);

         vbAmountOverpay_CARD := inAmountCard - vbAmountRest;
         vbAmountRest_EUR := 0;
         vbAmountRest := 0;
         vbAmountRest_USD := 0;

         --raise notice 'Value: %', vbAmountPay_EUR;
         
       ELSE 

         vbAmountPay_GRN := vbAmountPay_GRN + inAmountCard;
         vbAmountPay_EUR := vbAmountPay_EUR + Round(zfCalc_CurrencyTo (inAmountCard, inCurrencyValueEUR, 1), 2);
         vbAmountRest := Round(vbAmountRest - inAmountCard, 2);

         IF inisChangeEUR = TRUE OR inAmountUSD = 0
         THEN
           vbAmountRest_EUR := Round(zfCalc_CurrencyTo (vbAmountRest, inCurrencyValueEUR, 1), 2); 
           vbAmountRest_USD := Round(zfCalc_CurrencyFrom (vbAmountRest_EUR, inCurrencyValueCross, 1), 2);
         ELSE
           vbAmountRest_EUR := Round(zfCalc_CurrencyTo (vbAmountRest, inCurrencyValueUSD, 1) / inCurrencyValueCross, 2);
           vbAmountRest_USD := Round(zfCalc_CurrencyFrom (vbAmountRest_EUR, inCurrencyValueCross, 1), 2);
         END IF;
       END IF;
     END IF;
     
     --raise notice 'Value: %', vbAmountPay_EUR;


     -- Оплата гривня
     IF inAmountGRN > 0
     THEN
       IF vbAmountRest <= 0
       THEN
         
         vbAmountOverpay_GRN := inAmountGRN;
       
       ELSEIF inAmountGRN > vbAmountRest
       THEN

         vbAmountPay_GRN := vbAmountPay_GRN + vbAmountRest;
         vbAmountPay_EUR := vbAmountPay_EUR + Round(zfCalc_CurrencyTo (vbAmountRest, inCurrencyValueEUR, 1), 2);
         
         vbAmountOverpay_GRN := inAmountGRN - vbAmountRest;
         vbAmountRest_EUR := 0;
         vbAmountRest := 0;
         vbAmountRest_USD := 0;

         --raise notice 'Value: %', vbAmountPay_EUR;
         
       ELSE 

         vbAmountPay_GRN := vbAmountPay_GRN + inAmountGRN;
         vbAmountPay_EUR := vbAmountPay_EUR + Round(zfCalc_CurrencyTo (inAmountGRN, inCurrencyValueEUR, 1), 2);
         vbAmountRest := Round(vbAmountRest - inAmountGRN, 2);

         IF inisChangeEUR = TRUE OR inAmountUSD = 0
         THEN
           vbAmountRest_EUR := Round(zfCalc_CurrencyTo (vbAmountRest, inCurrencyValueEUR, 1), 2); 
           vbAmountRest_USD := Round(zfCalc_CurrencyFrom (vbAmountRest_EUR, inCurrencyValueCross, 1), 2);
         ELSE
           vbAmountRest_EUR := Round(zfCalc_CurrencyTo (vbAmountRest, inCurrencyValueUSD, 1) / inCurrencyValueCross, 2);
           vbAmountRest_USD := Round(zfCalc_CurrencyFrom (vbAmountRest_EUR, inCurrencyValueCross, 1), 2);
         END IF;
       END IF;
     END IF;
             
     vbAmountToPay_Calc := vbAmountPay_GRN + vbAmountRest;
     vbAmountToPay_EUR_Calc := vbAmountPay_EUR + vbAmountRest_EUR;
     
     vbAmountRounding := Round(vbAmountToPay_GRN - vbAmountToPay_Calc, 2);
     vbAmountRounding_EUR := Round(vbAmountToPay_EUR - vbAmountToPay_EUR_Calc, 2);
     
     vbAmountEUR_Over_GRN := Round(zfCalc_CurrencyFrom (vbAmountOverpay_EUR, inCurrencyValueInEUR, 1), 2);
     vbAmountUSD_Over_GRN := Round(zfCalc_CurrencyFrom (vbAmountOverpay_USD, inCurrencyValueInUSD, 1), 2);
     
                                   /*CASE WHEN inisChangeEUR = TRUE 
                                        THEN zfCalc_CurrencyFrom (vbAmountOverpay_USD / inCurrencyValueCross, inCurrencyValueInEUR, 1)
                                        ELSE zfCalc_CurrencyFrom (vbAmountOverpay_USD, inCurrencyValueInUSD, 1) END, 2):: TFloat;*/
     
     
     vbAmountRemains_EUR := Round(vbAmountRest_EUR);
     IF vbAmountRemains_EUR < 0 
     THEN 
       vbAmountRemains_EUR := 0; 
     END IF;         

     /*vbAmountRest := vbAmountRest - Round(zfCalc_CurrencyFrom (vbAmountRest_EUR - Round(vbAmountRest_EUR), inCurrencyValueEUR, 1), 2);  
     inAmountDiscount_EUR := inAmountDiscount_EUR + vbAmountRest_EUR - Round(vbAmountRest_EUR);
     vbAmountRest_EUR := vbAmountRemains_EUR;*/
               
     -- Остаток грн.
     vbAmountRemains := Round(vbAmountRest);
     IF vbAmountRemains < 0 
     THEN 
       vbAmountRemains := 0; 
     END IF;
       
     -- Сума скидки в грн.   
     if inAmountDiscount_EUR <> 0 
     THEN
       vbAmountDiscount := Round(zfCalc_CurrencyFrom (inAmountDiscount_EUR, inCurrencyValueEUR, 1), 2) - (vbAmountEUR_Over_GRN + vbAmountUSD_Over_GRN + vbAmountOverpay_CARD + vbAmountOverpay_GRN);
     ELSE 
       vbAmountDiscount :=  - (vbAmountEUR_Over_GRN + vbAmountUSD_Over_GRN + vbAmountOverpay_CARD + vbAmountOverpay_GRN); 
     END IF;

     -- raise notice 'Value: % % ', vbAmountRest_EUR, inAmountDiscount_EUR;

     -- Если списали под 0 и остались копейки добавим их в списание
     IF vbAmountRemains = 0 AND vbAmountRest_EUR = 0 AND vbAmountRest <> 0
     THEN 
       vbAmountDiscount := vbAmountDiscount + vbAmountRest;
       vbAmountRest := 0;
       vbAmountRemains := 0;
     END IF;
                                            
     -- Сдача
     IF inisAmountDiff = FALSE
     THEN
       vbAmountDiff := Round((vbAmountEUR_Over_GRN + vbAmountUSD_Over_GRN + vbAmountOverpay_CARD + vbAmountOverpay_GRN), -1);
     ELSEIF inAmountDiff <> -0.01
     THEN
       
       /*IF inAmountDiff > (vbAmountEUR_Over_GRN + vbAmountUSD_Over_GRN + vbAmountOverpay_CARD + vbAmountOverpay_GRN)::TFloat AND
          inAmountDiff > Round((vbAmountEUR_Over_GRN + vbAmountUSD_Over_GRN + vbAmountOverpay_CARD + vbAmountOverpay_GRN), -1)::TFloat
       THEN
          RAISE EXCEPTION 'Ошибка. Сумма введенной сдачи % превышает максимально возможную %', inAmountDiff, Round((vbAmountEUR_Over_GRN + vbAmountUSD_Over_GRN + vbAmountOverpay_CARD + vbAmountOverpay_GRN), -1);
       ELSE*/
         
       IF inAmountDiff < 0
       THEN
          RAISE EXCEPTION 'Ошибка. Сумма введенной сдачи % должна быть положительной', inAmountDiff;
       END IF;
          
       vbAmountDiff := inAmountDiff;
     END IF;
         
     --vbAmountToPay_Calc := vbAmountToPay_Calc + vbAmountDiscount;
     --vbAmountToPay_EUR_Calc := vbAmountToPay_EUR_Calc + inAmountDiscount_EUR;

     -- Сума скидки в грн. убираем скидку   
     vbAmountDiscount := vbAmountDiscount + vbAmountDiff;     

     -- Результат
     RETURN QUERY
      SELECT -- К оплате, грн - здесь округлили
             zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1)) :: TFloat AS AmountToPay
             -- К оплате, EUR - здесь округлили
           , zfCalc_SummPriceList (1, inAmountToPay_EUR) :: TFloat AS AmountToPa_EUR

             -- К оплате, грн - НЕ округлили
           , zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1) :: TFloat AS AmountToPayFull
             -- К оплате, EUR - НЕ округлили
           , inAmountToPay_EUR :: TFloat              AS AmountToPayFull_EUR

             -- сколько осталось оплатить, ГРН
           , vbAmountRemains  :: TFloat               AS AmountRemains

             -- сколько осталось оплатить, EUR
           , vbAmountRemains_EUR  :: TFloat           AS AmountRemains_EUR

           , inAmountGRN
           , inAmountUSD
           , inAmountEUR
           , inAmountCard
           , inAmountDiscount_EUR
           , inAmountDiscDiff_EUR

             -- Дополнительная скидка - ГРН
           , vbAmountDiscount  :: TFloat              AS AmountDiscount
             -- Сдача, грн
           , vbAmountDiff :: TFloat                   AS AmountDiff

             -- Округление по курсам
           , vbAmountRounding  :: TFloat              AS AmountRounding
           , vbAmountRounding_EUR  :: TFloat          AS AmountRounding_EUR
           
           , (Round(vbAmountToPay_Calc, 2) + Round(zfCalc_CurrencyFrom (COALESCE (inAmountDiscount_EUR, 0), inCurrencyValueEUR, 1), 2)) :: TFloat          AS AmountToPay_Calc
           , (Round(vbAmountToPay_EUR_Calc, 2) + Round(inAmountDiscount_EUR, 2)) :: TFloat   AS vbAmountToPay_EUR_Calc
           
             -- AmountPay, ГРН
           , vbAmountPay_GRN :: TFloat AS AmountPay
             -- AmountPay, EUR
           , vbAmountPay_EUR :: TFloat AS AmountPay_EUR

           , Round(CASE WHEN inisChangeEUR = TRUE 
                        THEN (inAmountGRN - vbAmountOverpay_GRN) / inCurrencyValueEUR
                        ELSE (inAmountGRN - vbAmountOverpay_GRN) / inCurrencyValueEUR /* inCurrencyValueUSD / inCurrencyValueCross*/ END, 2) :: TFloat AS AmountGRN_EUR
           , (inAmountGRN - vbAmountOverpay_GRN)  :: TFloat                                AS AmountGRN_Pay
           , vbAmountOverpay_GRN  :: TFloat                                                AS AmountGRN_Over
                        
           , Round((inAmountUSD - vbAmountOverpay_USD) / inCurrencyValueCross, 2) :: TFloat AS AmountUSD_EUR
           , Round(inAmountUSD - vbAmountOverpay_USD, 2)::TFloat AS AmountUSD_Pay
           , Round(zfCalc_CurrencyFrom (inAmountUSD - vbAmountOverpay_USD, inCurrencyValueUSD, 1), 2)::TFloat AS AmountUSD_Pay_GRN
           , Round(vbAmountOverpay_USD, 2) :: TFloat  AS AmountUSD_Over
           , vbAmountUSD_Over_GRN                                                                             AS AmountUSD_Over_GRN

           , Round(inAmountEUR - vbAmountOverpay_EUR, 2):: TFloat AS AmountEUR_Pay
           , Round(zfCalc_CurrencyFrom (inAmountEUR - vbAmountOverpay_EUR, inCurrencyValueEUR, 1), 2):: TFloat AS AmountEUR_Pay_GRN
           , Round(vbAmountOverpay_EUR, 2) :: TFloat AS AmountEUR_Over
           , vbAmountEUR_Over_GRN                                                                              AS AmountEUR_Over_GRN

           , Round(CASE WHEN inisChangeEUR = TRUE 
                        THEN (inAmountCard - vbAmountOverpay_Card) / inCurrencyValueEUR
                        ELSE (inAmountCard - vbAmountOverpay_Card) / inCurrencyValueEUR /* inCurrencyValueUSD / inCurrencyValueCross*/ END, 2) :: TFloat AS AmountCARD_EUR
                        
           , (inAmountCard - vbAmountOverpay_Card) :: TFloat AS AmountCARD_Pay
           , vbAmountOverpay_Card :: TFloat                  AS AmountCARD_Over
           
           
           , (vbAmountOverpay_GRN + vbAmountUSD_Over_GRN + vbAmountEUR_Over_GRN + vbAmountOverpay_Card) :: TFloat AS AmountOver_GRN
           
           , Round(vbAmountRest, 2) :: TFloat                AS AmountRest
           , Round(vbAmountRest_EUR, 2) :: TFloat            AS AmountRest_EUR

             -- Итоговые обороты по валютам (должно быть 0)
           , (Round(zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1), 2) -
             (inAmountGRN + inAmountCard +
             Round(CASE WHEN inisChangeEUR = TRUE 
                        THEN zfCalc_CurrencyFrom (inAmountUSD - vbAmountOverpay_USD, inCurrencyValueUSD, 1) 
                        ELSE zfCalc_CurrencyFrom (inAmountUSD - vbAmountOverpay_USD, inCurrencyValueUSD, 1) END, 2) +
             Round(CASE WHEN inisChangeEUR = TRUE 
                        THEN zfCalc_CurrencyFrom (vbAmountOverpay_USD, inCurrencyValueInUSD /*/ inCurrencyValueCross, inCurrencyValueInEUR*/, 1)
                        ELSE zfCalc_CurrencyFrom (vbAmountOverpay_USD, inCurrencyValueInUSD, 1) END, 2) +
             Round(zfCalc_CurrencyFrom (inAmountEUR - vbAmountOverpay_EUR, inCurrencyValueEUR, 1), 2) +
             Round(zfCalc_CurrencyFrom (vbAmountOverpay_EUR, inCurrencyValueInEUR, 1), 2) +                   
             Round(vbAmountRest, 2) + vbAmountDiscount + ROUND(zfCalc_CurrencyFrom ( COALESCE (inAmountDiscDiff_EUR, 0), inCurrencyValueEUR, 1), 2) + 
             vbAmountRounding - vbAmountDiff)) :: TFloat AS AmountDiffFull_GRN

           , (COALESCE(inAmountToPay_EUR, 0) -
             (inAmountEUR - vbAmountOverpay_EUR +
             Round(CASE WHEN inAmountUSD = 0 OR inisChangeEUR = TRUE 
                        THEN (inAmountGRN - vbAmountOverpay_GRN) / inCurrencyValueEUR
                        ELSE (inAmountGRN - vbAmountOverpay_GRN) / inCurrencyValueEUR /* inCurrencyValueUSD / inCurrencyValueCross*/ END, 2) +
             Round(CASE WHEN inAmountUSD = 0 OR inisChangeEUR = TRUE 
                        THEN (inAmountCard - vbAmountOverpay_Card) / inCurrencyValueEUR
                        ELSE (inAmountCard - vbAmountOverpay_Card) / inCurrencyValueEUR /* inCurrencyValueUSD / inCurrencyValueCross*/ END, 2) +
             Round((inAmountUSD - vbAmountOverpay_USD) / inCurrencyValueCross, 2) +
             Round(vbAmountRest_EUR, 2) + inAmountDiscount_EUR + inAmountDiscDiff_EUR + vbAmountRounding_EUR)) :: TFloat AS AmountDiffFull_EUR
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


select AmountUSD_Over
     , AmountUSD_Over_GRN

from lpGet_MI_Sale_Child_TotalCalc(inCurrencyValueUSD := 37.68 , inCurrencyValueInUSD := 37.31 , inCurrencyValueEUR := 40.95 , inCurrencyValueInEUR := 40.54 , inCurrencyValueCross := 1.0868 , 
                                   inAmountToPay_EUR := 451 , 
                                   inAmountGRN := 0 , inAmountUSD := 300 , inAmountEUR := 176 , inAmountCard := 0 , inAmountDiscount_EUR := 0 , inAmountDiscDiff_EUR := 0,
                                   inisDiscount := False, inisChangeEUR := True , inisAmountDiff := False , inAmountDiff := 0, 
                                   inCurrencyId_Client := 18101 ,  inUserId := 2);
                                            
/*select AmountDiscount_EUR, AmountRemains_EUR, AmountRest_EUR
from gpGet_MI_Sale_Child_Total(inisGRN := 'False' , inisUSD := 'True' , inisEUR := 'False' , inisCard := 'False' , inisDiscount := 'False' , 
                               inisGRNOld := 'False' , inisUSDOld := 'True' , inisEUROld := 'False' , inisCardOld := 'False' , inisDiscountOld := 'False' , 
                               inCurrencyValueUSD := 37.68 , inCurrencyValueInUSD := 37.31 , inCurrencyValueEUR := 40.95 , inCurrencyValueInEUR := 40.54 , inCurrencyValueCross := 1.01 , 
                               inAmountToPay_GRN := 18468 , inAmountToPay_EUR := 451 , 
                               inAmountGRN := 0 , inAmountUSD := 300 , inAmountEUR := 0 , inAmountCard := 0 , inAmountDiscount_EUR := 0 , inAmountDiscount := 0 ,
                               inisChangeEUR := 'False' , inAmountRemains := 0 , 
                               inisAmountRemains_EUR := 'True' , inAmountRemains_EUR := 160 , inisAmountDiff := 'False' , inAmountManualDiff := 0 , 
                               inCurrencyId_Client := 18101 ,  inSession := '2');*/