	-- Function: lpSelect_MI_Child_calc()

--DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
--DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);
--DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);
--DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);
--DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TFloat, Boolean, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);

DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_MI_Child_calc(
    IN inMovementId            Integer   , -- Ключ
    IN inUnitId                Integer   , -- Ключ
    IN inAmountGRN             TFloat    , -- сумма оплаты
    IN inAmountUSD             TFloat    , -- сумма оплаты
    IN inAmountEUR             TFloat    , -- сумма оплаты
    IN inAmountCard            TFloat    , -- сумма оплаты
    IN inAmountDiscount_EUR    TFloat    , -- Сумма скидки всегда EUR
    IN inAmountDiff            TFloat    , -- Сумма сдачи
    IN inAmountRemains_EUR     TFloat    , -- Сумма долга

    IN inisDiscount            Boolean   , -- Списать остаток
    IN inisChangeEUR           Boolean   , -- Расчет от евро

    IN inCurrencyValueUSD      TFloat    , --
    IN inCurrencyValueInUSD    TFloat    , --
    IN inParValueUSD           TFloat    , --
    IN inCurrencyValueEUR      TFloat    , --
    IN inCurrencyValueInEUR    TFloat    , --
    IN inParValueEUR           TFloat    , --
    IN inCurrencyValueCross    TFloat    , -- Кросс-курс
    IN inParValueCross         TFloat    , -- Номинал для Кросс-курса
    IN inCurrencyId_Client     Integer   , --
    IN inUserId                Integer     -- Ключ
)
RETURNS TABLE (MovementItemId      Integer
             , ParentId            Integer
             , CashId              Integer -- Касса, в которую будет Приход/Расход(если возврат)
             , CurrencyId          Integer -- Валюта кассы, в которую будет Приход/Расход(если возврат)
             , AmountToPay         TFloat  -- Сумма К оплате, грн
             , AmountToPay_EUR     TFloat  -- Сумма К оплате, EUR
             , AmountDiscount      TFloat  -- Сумма скидки, грн
             , AmountDiscount_EUR  TFloat  -- Сумма скидки, EUR
             , AmountRounding      TFloat  -- Дополнительное округление, грн
             , AmountRounding_EUR  TFloat  -- Дополнительное округление, EUR
             , Amount              TFloat  -- Сумма оплаты
             , Amount_GRN          TFloat  -- Сумма ИТОГО оплаты в ГРН
             , Amount_EUR          TFloat  -- Сумма ИТОГО оплаты в EUR
             , CurrencyValue       TFloat
             , CurrencyValueIn     TFloat
             , ParValue            TFloat
             , CashId_Exc          Integer -- касса в ГРН - из которой будет Расход/Приход(если возврат) сумма для Обмена
              )
AS
$BODY$
   DECLARE vbAmountToPay           TFloat;
   DECLARE vbAmountToPay_EUR       TFloat;
   DECLARE vbMaxOrder              Integer;
   
   DECLARE vbAmountDiff            TFloat;
   DECLARE vbAmountRemains         TFloat;
   DECLARE vbAmountRemains_EUR     TFloat;
   DECLARE vbAmountDiscount        TFloat;
   DECLARE vbAmountRounding        TFloat;
   DECLARE vbAmountDiscount_EUR    TFloat;
   DECLARE vbAmountRounding_EUR    TFloat;          
   DECLARE vbAmountGRN_Pay         TFloat;
   DECLARE vbAmountGRN_EUR         TFloat;
   DECLARE vbAmountGRN_Over        TFloat;
   DECLARE vbAmountUSD_Pay         TFloat;
   DECLARE vbAmountUSD_EUR         TFloat;
   DECLARE vbAmountUSD_Pay_GRN     TFloat;
   DECLARE vbAmountUSD_Over        TFloat;
   DECLARE vbAmountUSD_Over_GRN    TFloat;
   DECLARE vbAmountEUR_Pay         TFloat;
   DECLARE vbAmountEUR_Pay_GRN     TFloat;
   DECLARE vbAmountEUR_Over        TFloat;
   DECLARE vbAmountEUR_Over_GRN    TFloat;
   DECLARE vbAmountCARD_Pay        TFloat;
   DECLARE vbAmountCARD_EUR        TFloat;
   DECLARE vbAmountCARD_Over       TFloat;   

   DECLARE vbAmountDiffLeft_GRN    TFloat;
   DECLARE vbAmountDiscRest        TFloat;
   DECLARE vbAmountDiscRest_EUR    TFloat;

   DECLARE vbText                  Text;   
BEGIN
     
     --
     -- !!!ДЛЯ ТЕСТА!!!
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmp_MI_Master'))
     THEN
         -- заливка мастер - !!!ТОЛЬКО ДЛЯ ТЕСТА!!!
         CREATE TEMP TABLE _tmp_MI_Master (MovementItemId Integer, SummPriceList TFloat, SummPriceList_EUR TFloat, AmountToPay TFloat, AmountToPay_EUR TFloat) ON COMMIT DROP;
         INSERT INTO _tmp_MI_Master (MovementItemId, SummPriceList, SummPriceList_EUR, AmountToPay, AmountToPay_EUR)
           WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                                 -- SummPriceList
                               , zfCalc_SummIn (MovementItem.Amount, CASE WHEN inCurrencyId_Client <> zc_Currency_GRN()
                                                                               THEN zfCalc_CurrencyFrom (MIFloat_OperPriceList_curr.ValueData, inCurrencyValueEUR, 1)
                                                                          ELSE MIFloat_OperPriceList.ValueData
                                                                     END, 1) AS SummPriceList
                                 -- SummPriceList_curr
                               , zfCalc_SummIn (MovementItem.Amount, CASE WHEN inCurrencyId_Client <> zc_Currency_GRN()
                                                                               THEN MIFloat_OperPriceList_curr.ValueData
                                                                          ELSE zfCalc_CurrencyTo (MIFloat_OperPriceList.ValueData, inCurrencyValueEUR, 1)
                                                                     END, 1) AS SummPriceList_EUR
   
                                -- AmountToPay
                              , CASE WHEN inCurrencyId_Client <> zc_Currency_GRN()
                                          THEN zfCalc_CurrencyFrom (zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                                                  , inCurrencyValueEUR, 1)
                                          ELSE zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                END AS AmountToPay
                                -- AmountToPay_curr
                              , CASE WHEN inCurrencyId_Client <> zc_Currency_GRN()
                                          THEN zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                          ELSE zfCalc_CurrencyTo (zfCalc_SummChangePercentNext (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData, MIFloat_ChangePercentNext.ValueData)
                                                                , inCurrencyValueEUR, 1)
                                END AS AmountToPay_EUR

                          FROM MovementItem
                               LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                           ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                          AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                               LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                                           ON MIFloat_OperPriceList_curr.MovementItemId = MovementItem.Id
                                                          AND MIFloat_OperPriceList_curr.DescId         = zc_MIFloat_OperPriceList_curr()
                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                           ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentNext
                                                           ON MIFloat_ChangePercentNext.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext()

                               LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                           ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_curr
                                                           ON MIFloat_SummChangePercent_curr.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummChangePercent_curr.DescId         = zc_MIFloat_SummChangePercent_curr()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                         )
           -- результат
           SELECT tmpMI.MovementItemId, tmpMI.SummPriceList, tmpMI.SummPriceList_EUR, tmpMI.AmountToPay, tmpMI.AmountToPay_EUR
           FROM tmpMI
         --WHERE tmpMI.MovementItemId     = inParentId
         --   OR COALESCE (inParentId, 0) = 0;
            -- SELECT 1, 12550, 12550
          ;

     END IF;
     -- !!!ДЛЯ ТЕСТА!!!
     --

     -- Временная таблица для распределениия оплат
     CREATE TEMP TABLE _tmpResult (MovementItemId      Integer
                                 , ParentId            Integer
                                 , CashId              Integer -- Касса, в которую будет Приход/Расход(если возврат)
                                 , CurrencyId          Integer -- Валюта кассы, в которую будет Приход/Расход(если возврат)
                                 , AmountToPay         TFloat  -- Сумма К оплате, грн
                                 , AmountToPay_EUR     TFloat  -- Сумма К оплате, EUR
                                 , AmountDiscount      TFloat  -- Сумма скидки, грн
                                 , AmountDiscount_EUR  TFloat  -- Сумма скидки, EUR
                                 , AmountRounding      TFloat  -- Дополнительное округление, грн
                                 , AmountRounding_EUR  TFloat  -- Дополнительное округление, EUR
                                 , Amount              TFloat  -- Сумма оплаты
                                 , Amount_GRN          TFloat  -- Сумма ИТОГО оплаты в ГРН
                                 , Amount_EUR          TFloat  -- Сумма ИТОГО оплаты в EUR
                                 , CurrencyValue       TFloat
                                 , CurrencyValueIn     TFloat
                                 , ParValue            TFloat
                                 , CashId_Exc          Integer -- касса в ГРН - из которой будет Расход/Приход(если возврат) сумма для Обмена
                                 , Ord                 Integer -- Очередность оплаты
                                ) ON COMMIT DROP;

--    RAISE EXCEPTION 'Ошибка.<%>  %', (select _tmp_MI_Master.AmountToPay from _tmp_MI_Master )
--   , (select _tmp_MI_Master.AmountToPay_EUR from _tmp_MI_Master )
--    ;

     -- проверка - свойство должно быть установлено
     IF COALESCE (inUnitId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <Магазин>.';
     END IF;

     -- проверка - свойство должно быть установлено
     IF NOT EXISTS (SELECT 1 FROM _tmp_MI_Master) THEN
        RAISE EXCEPTION 'Ошибка.Нет данных для распределния оплаты.';
     END IF;

     -- нашли Итого Сумма к Оплате - !!! грн + EUR !!!
     vbAmountToPay     := (SELECT SUM (_tmp_MI_Master.AmountToPay)      FROM _tmp_MI_Master);
     vbAmountToPay_EUR:= (SELECT SUM (_tmp_MI_Master.AmountToPay_EUR) FROM _tmp_MI_Master);
     
     --inAmountDiscount_EUR := Round(inAmountDiscount_EUR);
     
     -- кассы
     CREATE TEMP TABLE tmpCash ON COMMIT DROP AS 
     SELECT lpSelect.CashId, lpSelect.CurrencyId, lpSelect.isBankAccount FROM lpSelect_Object_Cash (inUnitId, inUserId) AS lpSelect;
     
     -- Данные - Child
     CREATE TEMP TABLE tmpMI_Child ON COMMIT DROP AS 
     SELECT MovementItem.Id                     AS MovementItemId
          , COALESCE (MovementItem.ParentId, 0) AS ParentId
          , MovementItem.ObjectId               AS CashId
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE;

     
     -- Распределили суммы по оплатам
     SELECT Res.AmountDiff

          , Res.AmountRest
          , Res.AmountRest_EUR

            -- Дополнительная скидка - ГРН
          , Res.AmountDiscount
            -- Округлениее курсов - ГРН
          , Res.AmountRounding


            -- Дополнительная скидка - EUR
          , Res.AmountDiscount_EUR
            -- Дополнительная скидка - EUR
          , Res.AmountRounding_EUR
          
          , Res.AmountGRN_Pay
          , Res.AmountGRN_EUR

          , Res.AmountGRN_Over

          , Res.AmountUSD_Pay
          , Res.AmountUSD_EUR
          , Res.AmountUSD_Pay_GRN
          , Res.AmountUSD_Over
          , Res.AmountUSD_Over_GRN

          , Res.AmountEUR_Pay
          , Res.AmountEUR_Pay_GRN
          , Res.AmountEUR_Over
          , Res.AmountEUR_Over_GRN

          , Res.AmountCARD_Pay
          , Res.AmountCARD_EUR
          , Res.AmountCARD_Over

     INTO vbAmountDiff

        , vbAmountRemains
        , vbAmountRemains_EUR
        
          -- Дополнительная скидка - ГРН
        , vbAmountDiscount
          -- Округлениее курсов - ГРН
        , vbAmountRounding


          -- Дополнительная скидка - EUR
        , vbAmountDiscount_EUR
          -- Дополнительная скидка - EUR
        , vbAmountRounding_EUR
        
        , vbAmountGRN_Pay
        , vbAmountGRN_EUR
        , vbAmountGRN_Over

        , vbAmountUSD_Pay
        , vbAmountUSD_EUR
        , vbAmountUSD_Pay_GRN
        , vbAmountUSD_Over
        , vbAmountUSD_Over_GRN

        , vbAmountEUR_Pay
        , vbAmountEUR_Pay_GRN
        , vbAmountEUR_Over
        , vbAmountEUR_Over_GRN

        , vbAmountCARD_Pay
        , vbAmountCARD_EUR
        , vbAmountCARD_Over
           
     FROM lpGet_MI_Sale_Child_TotalCalc(inCurrencyValueUSD       := inCurrencyValueUSD
                                      , inCurrencyValueInUSD     := inCurrencyValueInUSD
                                      , inCurrencyValueEUR       := inCurrencyValueEUR
                                      , inCurrencyValueInEUR     := inCurrencyValueInEUR
                                      , inCurrencyValueCross     := inCurrencyValueCross

                                      , inAmountToPay_EUR        := vbAmountToPay_EUR 
                                      , inAmountGRN              := inAmountGRN
                                      , inAmountUSD              := inAmountUSD
                                      , inAmountEUR              := inAmountEUR
                                      , inAmountCard             := inAmountCard
                                      , inAmountDiscount_EUR     := inAmountDiscount_EUR
                                      , inAmountDiscDiff_EUR     := 0
                                       
                                      , inisDiscount             := inisDiscount
                                      , inisChangeEUR            := inisChangeEUR
                                       
                                      , inisAmountDiff           := TRUE
                                      , inAmountDiff             := inAmountDiff
                                      , inCurrencyId_Client      := inCurrencyId_Client 
                                      , inUserId                 := inUserId) AS Res;
                                           
     --raise notice 'Remains: % %', vbAmountRemains, vbAmountRemains_EUR;
     --raise notice 'Discount: % % % %', vbAmountDiscount, vbAmountRounding, vbAmountDiscount_EUR, vbAmountRounding_EUR;
     --raise notice 'EUR: % % % %', vbAmountEUR_Pay, vbAmountEUR_Pay_GRN, vbAmountEUR_Over, vbAmountEUR_Over_GRN;
     --raise notice 'USD: % % % % %', vbAmountUSD_Pay, vbAmountUSD_EUR, vbAmountUSD_Pay_GRN, vbAmountUSD_Over, vbAmountUSD_Over_GRN;
     --raise notice 'CARD: % % %', vbAmountCARD_Pay, vbAmountCARD_EUR, vbAmountCARD_Over;
     --raise notice 'GRN: % % %', vbAmountGRN_Pay, vbAmountGRN_EUR, vbAmountGRN_Over;
     
     
     -- Не выданную сдачу добавим в округление по евро
     IF inisDiscount = FALSE AND COALESCE(inAmountDiscount_EUR, 0) = 0 AND ROUND(zfCalc_CurrencyTo (vbAmountDiff -  (vbAmountEUR_Over_GRN + vbAmountUSD_Over_GRN + vbAmountCARD_Over + vbAmountGRN_Over), inCurrencyValueEUR, 1), 2) <> 0
     THEN
       SELECT Res.AmountDiff

            , Res.AmountRest
            , Res.AmountRest_EUR

              -- Дополнительная скидка - ГРН
            , Res.AmountDiscount
              -- Округлениее курсов - ГРН
            , Res.AmountRounding


              -- Дополнительная скидка - EUR
            , Res.AmountDiscount_EUR
              -- Дополнительная скидка - EUR
            , Res.AmountRounding_EUR
            
            , Res.AmountGRN_Pay
            , Res.AmountGRN_EUR

            , Res.AmountGRN_Over

            , Res.AmountUSD_Pay
            , Res.AmountUSD_EUR
            , Res.AmountUSD_Pay_GRN
            , Res.AmountUSD_Over
            , Res.AmountUSD_Over_GRN

            , Res.AmountEUR_Pay
            , Res.AmountEUR_Pay_GRN
            , Res.AmountEUR_Over
            , Res.AmountEUR_Over_GRN

            , Res.AmountCARD_Pay
            , Res.AmountCARD_EUR
            , Res.AmountCARD_Over

       INTO vbAmountDiff

          , vbAmountRemains
          , vbAmountRemains_EUR
          
            -- Дополнительная скидка - ГРН
          , vbAmountDiscount
            -- Округлениее курсов - ГРН
          , vbAmountRounding


            -- Дополнительная скидка - EUR
          , vbAmountDiscount_EUR
            -- Дополнительная скидка - EUR
          , vbAmountRounding_EUR
            
          , vbAmountGRN_Pay
          , vbAmountGRN_EUR
          , vbAmountGRN_Over

          , vbAmountUSD_Pay
          , vbAmountUSD_EUR
          , vbAmountUSD_Pay_GRN
          , vbAmountUSD_Over
          , vbAmountUSD_Over_GRN

          , vbAmountEUR_Pay
          , vbAmountEUR_Pay_GRN
          , vbAmountEUR_Over
          , vbAmountEUR_Over_GRN

          , vbAmountCARD_Pay
          , vbAmountCARD_EUR
          , vbAmountCARD_Over
             
       FROM lpGet_MI_Sale_Child_TotalCalc(inCurrencyValueUSD       := inCurrencyValueUSD
                                        , inCurrencyValueInUSD     := inCurrencyValueInUSD
                                        , inCurrencyValueEUR       := inCurrencyValueEUR
                                        , inCurrencyValueInEUR     := inCurrencyValueInEUR
                                        , inCurrencyValueCross     := inCurrencyValueCross

                                        , inAmountToPay_EUR        := vbAmountToPay_EUR 
                                        , inAmountGRN              := inAmountGRN
                                        , inAmountUSD              := inAmountUSD
                                        , inAmountEUR              := inAmountEUR
                                        , inAmountCard             := inAmountCard
                                        , inAmountDiscount_EUR     := ROUND(zfCalc_CurrencyTo (vbAmountDiff - (vbAmountEUR_Over_GRN + vbAmountUSD_Over_GRN + vbAmountCARD_Over + vbAmountGRN_Over), inCurrencyValueEUR, 1), 2)
                                        , inAmountDiscDiff_EUR     := 0
                                         
                                        , inisDiscount             := inisDiscount
                                        , inisChangeEUR            := inisChangeEUR
                                         
                                        , inisAmountDiff           := TRUE
                                        , inAmountDiff             := inAmountDiff
                                        , inCurrencyId_Client      := inCurrencyId_Client 
                                        , inUserId                 := inUserId) AS Res;     

     END IF;
          
     --Округляем долг в валюте до целого
     IF /*COALESCE(inAmountDiscount_EUR, 0) = 0 AND */ COALESCE(vbAmountRemains_EUR, 0) <> Round(COALESCE(vbAmountRemains_EUR, 0))
     THEN
       SELECT Res.AmountDiff

            , Res.AmountRest
            , Res.AmountRest_EUR

              -- Дополнительная скидка - ГРН
            , Res.AmountDiscount
              -- Округлениее курсов - ГРН
            , Res.AmountRounding


              -- Дополнительная скидка - EUR
            , Res.AmountDiscount_EUR
              -- Дополнительная скидка - EUR
            , Res.AmountRounding_EUR
            
            , Res.AmountGRN_Pay
            , Res.AmountGRN_EUR

            , Res.AmountGRN_Over

            , Res.AmountUSD_Pay
            , Res.AmountUSD_EUR
            , Res.AmountUSD_Pay_GRN
            , Res.AmountUSD_Over
            , Res.AmountUSD_Over_GRN

            , Res.AmountEUR_Pay
            , Res.AmountEUR_Pay_GRN
            , Res.AmountEUR_Over
            , Res.AmountEUR_Over_GRN

            , Res.AmountCARD_Pay
            , Res.AmountCARD_EUR
            , Res.AmountCARD_Over

       INTO vbAmountDiff

          , vbAmountRemains
          , vbAmountRemains_EUR
          
            -- Дополнительная скидка - ГРН
          , vbAmountDiscount
            -- Округлениее курсов - ГРН
          , vbAmountRounding


            -- Дополнительная скидка - EUR
          , vbAmountDiscount_EUR
            -- Дополнительная скидка - EUR
          , vbAmountRounding_EUR
            
          , vbAmountGRN_Pay
          , vbAmountGRN_EUR
          , vbAmountGRN_Over

          , vbAmountUSD_Pay
          , vbAmountUSD_EUR
          , vbAmountUSD_Pay_GRN
          , vbAmountUSD_Over
          , vbAmountUSD_Over_GRN

          , vbAmountEUR_Pay
          , vbAmountEUR_Pay_GRN
          , vbAmountEUR_Over
          , vbAmountEUR_Over_GRN

          , vbAmountCARD_Pay
          , vbAmountCARD_EUR
          , vbAmountCARD_Over
             
       FROM lpGet_MI_Sale_Child_TotalCalc(inCurrencyValueUSD       := inCurrencyValueUSD
                                        , inCurrencyValueInUSD     := inCurrencyValueInUSD
                                        , inCurrencyValueEUR       := inCurrencyValueEUR
                                        , inCurrencyValueInEUR     := inCurrencyValueInEUR
                                        , inCurrencyValueCross     := inCurrencyValueCross

                                        , inAmountToPay_EUR        := vbAmountToPay_EUR 
                                        , inAmountGRN              := inAmountGRN
                                        , inAmountUSD              := inAmountUSD
                                        , inAmountEUR              := inAmountEUR
                                        , inAmountCard             := inAmountCard
                                        , inAmountDiscount_EUR     := vbAmountDiscount_EUR + COALESCE(vbAmountRemains_EUR, 0) - Round(COALESCE(vbAmountRemains_EUR, 0))
                                        , inAmountDiscDiff_EUR     := 0
                                         
                                        , inisDiscount             := inisDiscount
                                        , inisChangeEUR            := inisChangeEUR
                                         
                                        , inisAmountDiff           := TRUE
                                        , inAmountDiff             := inAmountDiff
                                        , inCurrencyId_Client      := inCurrencyId_Client 
                                        , inUserId                 := inUserId) AS Res;

       raise notice 'Discount 3: % % % %', vbAmountDiscount, vbAmountRounding, vbAmountDiscount_EUR, vbAmountRounding_EUR;
     
     END IF;
     
     --Поменяем долг по гривне от долга евро
     IF Round(zfCalc_CurrencyFrom (vbAmountRemains_EUR, inCurrencyValueEUR, 1), 2) <> Round(zfCalc_CurrencyFrom (vbAmountToPay_EUR, inCurrencyValueEUR, 1), 2) - vbAmountEUR_Pay_GRN - vbAmountUSD_Pay_GRN - vbAmountCARD_Pay - vbAmountGRN_Pay - vbAmountDiscount - vbAmountRounding
        AND inisDiscount = FALSE
     THEN 
       /*raise notice 'D: %  %  %', 
                               vbAmountDiscount, 
                               (Round(zfCalc_CurrencyFrom (vbAmountToPay_EUR, inCurrencyValueEUR, 1), 2) - vbAmountEUR_Pay_GRN - vbAmountUSD_Pay_GRN - vbAmountCARD_Pay - vbAmountGRN_Pay - vbAmountDiscount - vbAmountRounding),
                                Round(zfCalc_CurrencyFrom (vbAmountRemains_EUR, inCurrencyValueEUR, 1), 2);*/
       vbAmountDiscount := vbAmountDiscount + (Round(zfCalc_CurrencyFrom (vbAmountToPay_EUR, inCurrencyValueEUR, 1), 2) - vbAmountEUR_Pay_GRN - vbAmountUSD_Pay_GRN - vbAmountCARD_Pay - vbAmountGRN_Pay - vbAmountDiscount - vbAmountRounding) - Round(zfCalc_CurrencyFrom (vbAmountRemains_EUR, inCurrencyValueEUR, 1), 2);
       --raise notice 'D: % ', vbAmountDiscount;
     END IF;

                                      
     -- Дополнительная оплата из за невыданного округления    
     vbAmountDiffLeft_GRN := (vbAmountEUR_Over_GRN + vbAmountUSD_Over_GRN + vbAmountCARD_Over + vbAmountGRN_Over) - vbAmountDiff;
     --vbAmountDiscount := vbAmountDiscount + vbAmountDiff;

     --raise notice 'D: % %  % ', vbAmountDiffLeft_GRN, (vbAmountEUR_Over_GRN + vbAmountUSD_Over_GRN + vbAmountCARD_Over + vbAmountGRN_Over), vbAmountDiff;
          
     -- распределили - Дополнительую скидку по всем строкам
     -- Распределили EUR
     WITH  tmp_MI_Master_all AS (SELECT _tmp_MI_Master.MovementItemId
                                        -- Сумма к оплате - !!! грн + EUR !!!
                                      , _tmp_MI_Master.AmountToPay
                                      , _tmp_MI_Master.AmountToPay_EUR

                                        -- распределили Доп. Скидку по элементам - !!! ГРН !!!
                                      , CASE WHEN vbAmountDiscount = vbAmountToPay AND vbAmountRounding = 0 
                                             THEN _tmp_MI_Master.AmountToPay

                                             -- если кратна курсу ЕРО или ВСЕГДА
                                             ELSE -- перевели целую часть обратно в ГРН
                                                  ROUND(vbAmountDiscount * _tmp_MI_Master.AmountToPay / vbAmountToPay) :: TFloat
                                             END AS AmountDiscount_GRN

                                        -- распределили Доп. Скидку по элементам - !!! EUR !!!
                                      , CASE WHEN vbAmountDiscount_EUR = vbAmountToPay_EUR AND vbAmountRounding_EUR = 0
                                             THEN _tmp_MI_Master.AmountToPay_EUR
                                             ELSE ROUND(vbAmountDiscount_EUR * _tmp_MI_Master.AmountToPay_EUR / vbAmountToPay_EUR) :: TFloat
                                             END AS AmountDiscount_EUR

                                        -- распределили округление по элементам - !!! ГРН !!!
                                      , CASE WHEN vbAmountRounding = vbAmountToPay AND vbAmountDiscount = 0
                                             THEN _tmp_MI_Master.AmountToPay

                                             -- если кратна курсу ЕРО или ВСЕГДА
                                             ELSE -- перевели целую часть обратно в ГРН
                                                  ROUND(vbAmountRounding * _tmp_MI_Master.AmountToPay / vbAmountToPay) :: TFloat
                                             END AS AmountRounding_GRN

                                        -- распределили округление по элементам - !!! EUR !!!
                                      , CASE WHEN vbAmountRounding_EUR = vbAmountToPay_EUR AND vbAmountDiscount_EUR = 0
                                             THEN _tmp_MI_Master.AmountToPay_EUR
                                             ELSE ROUND(vbAmountRounding_EUR * _tmp_MI_Master.AmountToPay_EUR / vbAmountToPay_EUR) :: TFloat
                                        END AS AmountRounding_EUR
                                        
                                        -- распределили не выданную сдачу - !!! ГРН !!!
                                      , ROUND(vbAmountDiffLeft_GRN * _tmp_MI_Master.AmountToPay / vbAmountToPay, 2) :: TFloat AS AmountDiffLeft_GRN

                                      , ROW_NUMBER() OVER (ORDER BY _tmp_MI_Master.AmountToPay_EUR DESC) AS Ord

                                 FROM _tmp_MI_Master
                                )
           -- выровняли - Дополнительная скидка - т.е. разницу на коп. при округлении
         , tmp_MI_Master AS (SELECT tmp_MI_Master_all.MovementItemId
                                    -- Сумма к выплате - !!! грн + EUR !!!
                                  , tmp_MI_Master_all.AmountToPay
                                  , tmp_MI_Master_all.AmountToPay_EUR

                                    -- Доп. Скидка по элементам минус разница на коп. при округлении - !!! ГРН !!!
                                  , (CASE WHEN tmp_MI_Master_all.Ord = 1 --(SELECT MAX(tmp_MI_Master_all.Ord) FROM tmp_MI_Master_all)
                                          THEN vbAmountDiscount - COALESCE((SELECT SUM (tmp_MI_Master_all.AmountDiscount_GRN) AS AmountDiscount_GRN FROM tmp_MI_Master_all WHERE tmp_MI_Master_all.Ord <> 1 /*(SELECT MAX(tmp_MI_Master_all.Ord) FROM tmp_MI_Master_all)*/), 0)
                                          ELSE tmp_MI_Master_all.AmountDiscount_GRN
                                          END) AS AmountDiscount_GRN

                                    -- Доп. Скидка по элементам минус разница на коп. при округлении - !!! EUR !!!
                                  , (CASE WHEN tmp_MI_Master_all.Ord = 1 -- (SELECT MAX(tmp_MI_Master_all.Ord) FROM tmp_MI_Master_all)
                                          THEN vbAmountDiscount_EUR - COALESCE((SELECT SUM (tmp_MI_Master_all.AmountDiscount_EUR) AS AmountDiscount_EUR FROM tmp_MI_Master_all WHERE tmp_MI_Master_all.Ord <> 1 /*(SELECT MAX(tmp_MI_Master_all.Ord) FROM tmp_MI_Master_all)*/), 0)
                                          ELSE tmp_MI_Master_all.AmountDiscount_EUR
                                          END) AS AmountDiscount_EUR

                                    -- Округление по элементам минус разница на коп. при округлении - !!! ГРН !!!
                                  , (CASE WHEN tmp_MI_Master_all.Ord = 1 --(SELECT MAX(tmp_MI_Master_all.Ord) FROM tmp_MI_Master_all)
                                          THEN vbAmountRounding - COALESCE((SELECT SUM (tmp_MI_Master_all.AmountRounding_GRN) AS AmountRounding_GRN FROM tmp_MI_Master_all WHERE tmp_MI_Master_all.Ord <> 1 /*(SELECT MAX(tmp_MI_Master_all.Ord) FROM tmp_MI_Master_all)*/), 0)
                                          ELSE tmp_MI_Master_all.AmountRounding_GRN
                                          END) AS AmountRounding_GRN

                                    -- Округление по элементам минус разница на коп. при округлении - !!! EUR !!!
                                  , (CASE WHEN tmp_MI_Master_all.Ord = 1 --(SELECT MAX(tmp_MI_Master_all.Ord) FROM tmp_MI_Master_all)
                                          THEN vbAmountRounding_EUR - COALESCE((SELECT SUM (tmp_MI_Master_all.AmountRounding_EUR) AS AmountRounding_EUR FROM tmp_MI_Master_all WHERE tmp_MI_Master_all.Ord <> 1 /*(SELECT MAX(tmp_MI_Master_all.Ord) FROM tmp_MI_Master_all)*/), 0)
                                          ELSE tmp_MI_Master_all.AmountRounding_EUR
                                          END) AS AmountRounding_EUR

                                    -- Распределили не выданную сдачу на коп. при округлении - !!! ГРН !!!
                                  , (CASE WHEN tmp_MI_Master_all.Ord = 1 --(SELECT MAX(tmp_MI_Master_all.Ord) FROM tmp_MI_Master_all)
                                          THEN vbAmountDiffLeft_GRN - COALESCE((SELECT SUM (tmp_MI_Master_all.AmountDiffLeft_GRN) AS AmountDiffLeft_GRN FROM tmp_MI_Master_all WHERE tmp_MI_Master_all.Ord <> 1 /*(SELECT MAX(tmp_MI_Master_all.Ord) FROM tmp_MI_Master_all)*/), 0)
                                          ELSE tmp_MI_Master_all.AmountDiffLeft_GRN
                                          END) AS AmountDiffLeft_GRN

                                    --
                                    --
                                  , tmp_MI_Master_all.Ord

                             FROM tmp_MI_Master_all
                            )
           -- 1.1. остаток для оплаты EUR - с накопительной суммой
         , tmp_MI_EUR AS (SELECT tmpMI.MovementItemId
                               , tmpMI.Amount_calc  AS Amount_calc
                                 --
                               , SUM (tmpMI.Amount_calc) OVER (ORDER BY tmpMI.Ord) AS Amount_SUM
                               , tmpMI.Ord

                          FROM (SELECT tmpMI.MovementItemId
                                     , tmpMI.Ord

                                       -- сумма с учетом Доп. скидки - для расч. EUR - !!! EUR !!!
                                     , ROUND (tmpMI.AmountToPay_EUR - tmpMI.AmountDiscount_EUR - tmpMI.AmountRounding_EUR) AS Amount_calc

                                FROM tmp_MI_Master AS tmpMI
                               ) AS tmpMI
                         )
           -- 1.2. оплата EUR результат - !!! грн !!!
         , tmp_MI_EUR_res AS (
                              -- результат в ГРН
                              SELECT DD.MovementItemId
                                         
                                   , CASE WHEN vbAmountEUR_Pay - DD.Amount_SUM > 0
                                          -- оплатили полностью
                                          THEN DD.Amount_calc
                                          -- оплатили частично
                                          WHEN vbAmountEUR_Pay - (DD.Amount_SUM - DD.Amount_calc) > 0
                                          THEN vbAmountEUR_Pay - (DD.Amount_SUM - DD.Amount_calc) 
                                          ELSE 0
                                     END AS Amount
                                            
                                     -- накопительно - сколько оплатили
                                   , DD.Amount_SUM

                                   , DD.Ord
                              FROM tmp_MI_EUR AS DD
                             )
                            
     INSERT INTO _tmpResult (MovementItemId, ParentId, CashId, CurrencyId, AmountToPay, AmountToPay_EUR
                           , AmountDiscount, AmountDiscount_EUR
                           , AmountRounding, AmountRounding_EUR
                           , Amount, Amount_GRN, Amount_EUR
                           , CurrencyValue, CurrencyValueIn, ParValue, CashId_Exc, Ord)
     SELECT tmpMI_Child.MovementItemId AS MovementItemId
          , res.MovementItemId  AS ParentId
          , tmpCash.CashId
          , tmpCash.CurrencyId

            -- Сумма с учетом Дополнительная скидка
          , tmp_MI_Master.AmountToPay                 :: TFloat AS AmountToPay
          , tmp_MI_Master.AmountToPay_EUR             :: TFloat AS AmountToPay_EUR            
            -- Дополнительная скидка
          , tmp_MI_Master.AmountDiscount_GRN          :: TFloat AS AmountDiscount
          , tmp_MI_Master.AmountDiscount_EUR          :: TFloat AS AmountDiscount_EUR
            -- Дополнительное округление
          , tmp_MI_Master.AmountRounding_GRN :: TFloat          AS AmountRounding
          , tmp_MI_Master.AmountRounding_EUR :: TFloat          AS AmountRounding_EUR

          , res.Amount :: TFloat AS Amount

          , (CASE WHEN vbAmountEUR_Pay = 0 THEN 0 ELSE Round(vbAmountEUR_Pay_GRN * res.Amount / vbAmountEUR_Pay, 2) END + COALESCE(tmp_MI_Master.AmountDiffLeft_GRN, 0)) :: TFloat AS Amount_GRN
          , res.Amount :: TFloat      AS Amount_EUR

          , inCurrencyValueEUR     AS CurrencyValue
          , inCurrencyValueInEUR   AS CurrencyValueIn
          , inParValueEUR          AS ParValue

          , 0 :: Integer           AS CashId_Exc
          
          , tmp_MI_Master.Ord      AS Ord
     FROM tmp_MI_EUR_res AS res
          LEFT JOIN tmp_MI_Master ON tmp_MI_Master.MovementItemId = res.MovementItemId
          LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_EUR()
          LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = res.MovementItemId
                               AND tmpMI_Child.CashId   = tmpCash.CashId
     ;

     -- Поправили суммe оплаты из за распределения по строкам
     IF vbAmountEUR_Pay > 0
     THEN
     
       vbMaxOrder := (SELECT Max(tmpMI.Ord) FROM _tmpResult AS tmpMI 
                      WHERE tmpMI.CurrencyId = zc_Currency_EUR() AND tmpMI.Amount > 0);

       UPDATE _tmpResult SET Amount_GRN = vbAmountEUR_Pay_GRN + vbAmountDiffLeft_GRN - COALESCE(tmpData.Amount_GRN, 0) 
       FROM (SELECT SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN tmpMI.Amount_GRN END):: TFloat AS Amount_GRN
             FROM _tmpResult AS tmpMI
             WHERE tmpMI.CurrencyId = zc_Currency_EUR() 
               AND tmpMI.Amount > 0) AS tmpData
       WHERE _tmpResult.CurrencyId = zc_Currency_EUR() AND _tmpResult.Ord = vbMaxOrder;
     END IF;   
     
     -- Распределили USD, целую часть
     WITH  tmp_MI_USD AS (SELECT tmpMI.MovementItemId
                               , tmpMI.Amount_all   AS Amount_all
                               , tmpMI.Amount_calc  AS Amount_calc
                                 --
                               , SUM (tmpMI.Amount_calc) OVER (ORDER BY tmpMI.Ord) AS Amount_SUM
                                   
                               , tmpMI.Ord
                               
                          FROM (SELECT tmpMI.ParentId     AS MovementItemId

                                       -- сумма с учетом Доп. скидки - !!! EUR !!!
                                     , tmpMI.AmountToPay_EUR - tmpMI.AmountDiscount_EUR - tmpMI.AmountRounding_EUR - tmpMI.Amount_EUR AS Amount_all
                                     
                                       -- Переводим в Валюту + округлили коп.
                                     , ROUND ((tmpMI.AmountToPay_EUR - tmpMI.AmountDiscount_EUR - tmpMI.AmountRounding_EUR - tmpMI.Amount_EUR) * inCurrencyValueCross) AS Amount_calc
                                       
                                     , tmpMI.Ord

                                FROM _tmpResult AS tmpMI
                                WHERE COALESCE (tmpMI.ParentId, 0) <> 0
                                  AND tmpMI.CurrencyId = zc_Currency_EUR()
                               ) AS tmpMI
                          )
               -- 2.2. оплата USD результат - !!! грн !!!
             , tmp_MI_USD_res AS (SELECT DD.MovementItemId

                                       , CASE WHEN vbAmountUSD_Pay  - DD.Amount_SUM > 0
                                              -- оплатили полностью
                                              THEN DD.Amount_calc
                                              -- оплатили частично
                                              WHEN vbAmountUSD_Pay - (DD.Amount_SUM - DD.Amount_calc) > 0
                                              THEN vbAmountUSD_Pay - (DD.Amount_SUM - DD.Amount_calc)
                                              ELSE 0
                                         END AS Amount

                                        , CASE WHEN vbAmountUSD_Pay  - DD.Amount_SUM > 0
                                               -- оплатили полностью
                                               THEN Round(DD.Amount_calc / inCurrencyValueCross, 2) 
                                               -- оплатили частично
                                               WHEN vbAmountUSD_Pay - (DD.Amount_SUM - DD.Amount_calc) > 0
                                               THEN Round((vbAmountUSD_Pay - (DD.Amount_SUM - DD.Amount_calc)) / inCurrencyValueCross, 2) 
                                               ELSE 0
                                          END AS Amount_EUR

                                       , CASE WHEN vbAmountUSD_Pay  - DD.Amount_SUM > 0
                                              -- оплатили полностью, поправили скидку
                                              THEN DD.Amount_all - Round(DD.Amount_calc / inCurrencyValueCross, 2) ::TFloat
                                              -- оплатили частично
                                              ELSE 0
                                         END :: TFloat AS AmountDiscount_EUR_add

                                         -- накопительно - сколько оплатили
                                       , DD.Amount_SUM

                                       , DD.Ord

                                  FROM tmp_MI_USD AS DD
                                  /*WHERE vbAmountUSD_Pay - (DD.Amount_SUM - DD.Amount_calc) > 0
                                    AND DD.Amount_all > 0*/
                                 ) 
                                
     INSERT INTO _tmpResult (MovementItemId, ParentId, CashId, CurrencyId, AmountToPay, AmountToPay_EUR
                           , AmountDiscount, AmountDiscount_EUR
                           , AmountRounding, AmountRounding_EUR
                           , Amount, Amount_GRN, Amount_EUR
                           , CurrencyValue, CurrencyValueIn, ParValue, CashId_Exc, Ord)
     SELECT tmpMI_Child.MovementItemId AS MovementItemId
          , res.MovementItemId  AS ParentId
          , tmpCash.CashId
          , tmpCash.CurrencyId

            -- Сумма с учетом Дополнительная скидка
          , _tmpResult.AmountToPay                 :: TFloat AS AmountToPay
          , _tmpResult.AmountToPay_EUR             :: TFloat AS AmountToPay_EUR            
            -- Дополнительная скидка
          , 0 :: TFloat                            :: TFloat AS AmountDiscount
          , CASE WHEN res.Amount > 0 
                 THEN res.AmountDiscount_EUR_add 
                 ELSE 0 END:: TFloat                         AS AmountDiscount_EUR
            -- Дополнительное округление
          , 0 :: TFloat AS AmountRounding
          , 0 :: TFloat AS AmountRounding_EUR

          , res.Amount :: TFloat AS Amount

          , CASE WHEN vbAmountUSD_Pay = 0 THEN 0 ELSE Round(vbAmountUSD_Pay_GRN * res.Amount / vbAmountUSD_Pay, 2) END :: TFloat AS Amount_GRN
          /*, CASE WHEN res.Amount_EUR > 0 
                 THEN Round(zfCalc_CurrencyFrom (res.Amount, inCurrencyValueUSD, 1), 2)
                 ELSE 0 END :: TFloat AS Amount_GRN*/
          , CASE WHEN vbAmountUSD_Pay = 0 THEN 0 ELSE res.Amount_EUR END :: TFloat AS Amount_EUR

          , inCurrencyValueUSD     AS CurrencyValue
          , inCurrencyValueInUSD   AS CurrencyValueIn
          , inParValueUSD          AS ParValue

          , 0 :: Integer           AS CashId_Exc
          
          , res.Ord
     FROM tmp_MI_USD_res AS res
          LEFT JOIN _tmpResult ON _tmpResult.ParentId = res.MovementItemId
                              AND _tmpResult.CurrencyId = zc_Currency_EUR()
          LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_USD()
          LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = res.MovementItemId
                               AND tmpMI_Child.CashId   = tmpCash.CashId
     WHERE (COALESCE (res.Amount, 0) <> 0 OR COALESCE (tmpMI_Child.MovementItemId, 0) <> 0)
     ;
          
     -- Поправили округление из за распределения целыми суммами USD
     IF vbAmountUSD_Pay > 0
     THEN
       vbMaxOrder := (SELECT Max(tmpMI.Ord) FROM _tmpResult AS tmpMI WHERE tmpMI.CurrencyId = zc_Currency_USD() AND tmpMI.Amount > 0);
       
       UPDATE _tmpResult SET AmountDiscount_EUR = COALESCE(tmpData.AmountDiscount_EUR, 0)
                           , Amount = vbAmountUSD_Pay - COALESCE(tmpData.Amount, 0)    
                           , Amount_GRN = vbAmountUSD_Pay_GRN - COALESCE(tmpData.Amount_GRN, 0)    
                           , Amount_EUR = vbAmountUSD_EUR - COALESCE(tmpData.Amount_EUR, 0)    
       FROM (SELECT SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN - tmpMI.AmountDiscount_EUR END):: TFloat AS AmountDiscount_EUR
                  , SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN tmpMI.Amount END):: TFloat AS Amount
                  , SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN tmpMI.Amount_GRN END):: TFloat AS Amount_GRN
                  , SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN tmpMI.Amount_EUR END):: TFloat AS Amount_EUR
             FROM _tmpResult AS tmpMI
             WHERE tmpMI.CurrencyId = zc_Currency_USD() 
               AND tmpMI.Amount > 0) AS tmpData
       WHERE _tmpResult.CurrencyId = zc_Currency_USD() AND _tmpResult.Ord = vbMaxOrder;
     END IF;     
     
     -- Распределили CARD
     WITH  tmp_MI_CARD AS (SELECT tmpMI.MovementItemId
                                , tmpMI.Amount_all   AS Amount_all
                                , tmpMI.Amount_calc  AS Amount_calc
                                  --
                                , SUM (tmpMI.Amount_calc) OVER (ORDER BY tmpMI.Ord) AS Amount_SUM
                                     
                                , tmpMI.Ord
                                 
                           FROM (SELECT tmpMI.ParentId     AS MovementItemId

                                        -- сумма с учетом Доп. скидки - !!! EUR !!!
                                      , tmpMI.AmountToPay_EUR - tmpMI.AmountDiscount_EUR - tmpMI.AmountRounding_EUR - tmpMI.Amount_EUR - COALESCE(res.Amount_EUR, 0) AS Amount_all
                                       
                                        -- Переводим в Валюту + округлили коп.
                                      , ROUND (CASE WHEN inisChangeEUR = TRUE OR inAmountUSD = 0
                                                    THEN (tmpMI.AmountToPay_EUR - tmpMI.AmountDiscount_EUR - tmpMI.AmountRounding_EUR - tmpMI.Amount_EUR - COALESCE(res.Amount_EUR, 0)) * inCurrencyValueEUR 
                                                    ELSE (tmpMI.AmountToPay_EUR - tmpMI.AmountDiscount_EUR - tmpMI.AmountRounding_EUR - tmpMI.Amount_EUR - COALESCE(res.Amount_EUR, 0)) * inCurrencyValueUSD * inCurrencyValueCross END) AS Amount_calc
                                         
                                      , tmpMI.Ord

                                 FROM _tmpResult AS tmpMI
                                 
                                      LEFT JOIN (SELECT res.ParentId
                                                      , Round(Sum(res.Amount_EUR + res.AmountDiscount_EUR), 2)::TFloat AS Amount_EUR
                                                 FROM _tmpResult AS res 
                                                 WHERE res.CurrencyId <> zc_Currency_EUR()
                                                   AND COALESCE (res.ParentId, 0) <> 0
                                                 GROUP BY res.ParentId) AS res ON res.ParentId = tmpMI.ParentId 
                                 
                                 WHERE COALESCE (tmpMI.ParentId, 0) <> 0
                                   AND tmpMI.CurrencyId = zc_Currency_EUR()
                                ) AS tmpMI
                           )
               -- 2.2. оплата CARD результат - !!! грн !!!
             , tmp_MI_CARD_res AS (SELECT DD.MovementItemId


                                        , CASE WHEN vbAmountCARD_Pay  - DD.Amount_SUM > 0
                                               -- оплатили полностью
                                               THEN DD.Amount_calc
                                               -- оплатили частично
                                               WHEN vbAmountCARD_Pay - (DD.Amount_SUM - DD.Amount_calc) > 0
                                               THEN vbAmountCARD_Pay - (DD.Amount_SUM - DD.Amount_calc)
                                               ELSE 0
                                          END AS Amount

                                        , CASE WHEN vbAmountCARD_Pay  - DD.Amount_SUM > 0
                                               -- оплатили полностью
                                               THEN DD.Amount_all
                                               -- оплатили частично
                                               WHEN vbAmountCARD_Pay - (DD.Amount_SUM - DD.Amount_calc) > 0
                                               THEN Round(CASE WHEN inisChangeEUR = TRUE OR inAmountUSD = 0 
                                                               THEN (vbAmountCARD_Pay - (DD.Amount_SUM - DD.Amount_calc)) * inCurrencyValueEUR 
                                                               ELSE (vbAmountCARD_Pay - (DD.Amount_SUM - DD.Amount_calc)) * inCurrencyValueUSD * inCurrencyValueCross END, 2) 
                                               ELSE 0
                                          END AS Amount_EUR

                                        , CASE WHEN vbAmountCARD_Pay  - DD.Amount_SUM > 0
                                               -- оплатили полностью, поправили скидку
                                               THEN Round(DD.Amount_all - CASE WHEN inisChangeEUR = TRUE OR inAmountUSD = 0 
                                                                               THEN DD.Amount_calc / inCurrencyValueEUR 
                                                                               ELSE DD.Amount_calc / inCurrencyValueUSD / inCurrencyValueCross END, 2) ::TFloat
                                               -- оплатили частично
                                               ELSE 0
                                          END :: TFloat AS AmountDiscount_EUR_add

                                        , CASE WHEN vbAmountCARD_Pay  - DD.Amount_SUM > 0
                                               -- оплатили полностью, поправили скидку
                                               THEN Round(CASE WHEN inisChangeEUR = TRUE OR inAmountUSD = 0 
                                                               THEN DD.Amount_all * inCurrencyValueEUR 
                                                               ELSE DD.Amount_all * inCurrencyValueUSD * inCurrencyValueCross END - DD.Amount_calc, 2) ::TFloat
                                               -- оплатили частично
                                               ELSE 0
                                          END :: TFloat AS AmountDiscount_GRN_add

                                          -- накопительно - сколько оплатили
                                        , DD.Amount_SUM

                                        , DD.Ord
 
                                   FROM tmp_MI_CARD AS DD
                                   /*WHERE vbAmountCARD_Pay - (DD.Amount_SUM - DD.Amount_calc) > 0
                                     AND DD.Amount_all > 0*/
                                  ) 
                            
     INSERT INTO _tmpResult (MovementItemId, ParentId, CashId, CurrencyId, AmountToPay, AmountToPay_EUR
                           , AmountDiscount, AmountDiscount_EUR
                           , AmountRounding, AmountRounding_EUR
                           , Amount, Amount_GRN, Amount_EUR
                           , CurrencyValue, CurrencyValueIn, ParValue, CashId_Exc, Ord)
     SELECT tmpMI_Child.MovementItemId AS MovementItemId
          , res.MovementItemId  AS ParentId
          , tmpCash.CashId
          , tmpCash.CurrencyId

            -- Сумма с учетом Дополнительная скидка
          , _tmpResult.AmountToPay                 :: TFloat AS AmountToPay
          , _tmpResult.AmountToPay_EUR             :: TFloat AS AmountToPay_EUR            
            -- Дополнительная скидка
          , CASE WHEN res.Amount > 0 
                 THEN res.AmountDiscount_GRN_add 
                 ELSE 0 END:: TFloat               :: TFloat AS AmountDiscount
          , CASE WHEN res.Amount > 0 
                 THEN res.AmountDiscount_EUR_add 
                 ELSE 0 END:: TFloat                         AS AmountDiscount_EUR
            -- Дополнительное округление
          , 0 :: TFloat AS AmountRounding
          , 0 :: TFloat AS AmountRounding_EUR

          , res.Amount :: TFloat AS Amount

          , res.Amount :: TFloat AS Amount_GRN
          , res.Amount_EUR :: TFloat AS Amount_EUR

          , 0 :: TFloat              AS CurrencyValue
          , 0 :: TFloat              AS CurrencyValueIn
          , 0                        AS ParValue

          , 0 :: Integer             AS CashId_Exc
          
          , res.Ord
     FROM tmp_MI_CARD_res AS res
          LEFT JOIN _tmpResult ON _tmpResult.ParentId = res.MovementItemId
                              AND _tmpResult.CurrencyId = zc_Currency_EUR()
          LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = TRUE
          LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = res.MovementItemId
                               AND tmpMI_Child.CashId   = tmpCash.CashId
     WHERE (COALESCE (res.Amount, 0) <> 0 OR COALESCE (tmpMI_Child.MovementItemId, 0) <> 0)
     ;
     
     -- Поправили округление из за распределения целыми суммами CARD
     IF vbAmountCARD_Pay > 0
     THEN
       vbMaxOrder := (SELECT Max(tmpMI.Ord) FROM _tmpResult AS tmpMI 
                      WHERE tmpMI.CurrencyId = zc_Currency_GRN() AND tmpMI.Amount > 0 
                        AND tmpMI.CashId = (SELECT tmpCash.CashId FROM tmpCash WHERE tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = TRUE));
       
       UPDATE _tmpResult SET AmountDiscount = COALESCE(tmpData.AmountDiscount, 0)
                           , AmountDiscount_EUR = COALESCE(tmpData.AmountDiscount_EUR, 0)
                           , Amount = vbAmountCARD_Pay - COALESCE(tmpData.Amount, 0)    
                           , Amount_GRN = vbAmountCARD_Pay - COALESCE(tmpData.Amount_GRN, 0)    
                           , Amount_EUR = vbAmountCARD_EUR - COALESCE(tmpData.Amount_EUR, 0)    
       FROM (SELECT SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN - tmpMI.AmountDiscount END):: TFloat AS AmountDiscount
                  , SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN - tmpMI.AmountDiscount_EUR END):: TFloat AS AmountDiscount_EUR
                  , SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN tmpMI.Amount END):: TFloat AS Amount
                  , SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN tmpMI.Amount_GRN END):: TFloat AS Amount_GRN
                  , SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN tmpMI.Amount_EUR END):: TFloat AS Amount_EUR
             FROM _tmpResult AS tmpMI
             WHERE tmpMI.CurrencyId = zc_Currency_GRN() 
               AND tmpMI.Amount > 0 
               AND tmpMI.CashId = (SELECT tmpCash.CashId FROM tmpCash WHERE tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = TRUE)) AS tmpData
       WHERE _tmpResult.CurrencyId = zc_Currency_GRN() AND _tmpResult.Ord = vbMaxOrder
         AND _tmpResult.CashId = (SELECT tmpCash.CashId FROM tmpCash WHERE tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = TRUE);
     END IF;      
     
     -- Распределили GRN
     WITH  tmp_MI_GRN AS (SELECT tmpMI.MovementItemId
                               , tmpMI.Amount_all   AS Amount_all
                               , tmpMI.Amount_calc  AS Amount_calc
                                 --
                               , SUM (tmpMI.Amount_calc) OVER (ORDER BY tmpMI.Ord) AS Amount_SUM
                                     
                               , tmpMI.Ord
                                 
                          FROM (SELECT tmpMI.ParentId     AS MovementItemId

                                       -- сумма с учетом Доп. скидки - !!! EUR !!!
                                     , tmpMI.AmountToPay_EUR - tmpMI.AmountDiscount_EUR - tmpMI.AmountRounding_EUR - tmpMI.Amount_EUR - COALESCE(res.Amount_EUR, 0) AS Amount_all
                                       
                                       -- Переводим в Валюту + округлили коп.
                                     , Round(CASE WHEN inisChangeEUR = TRUE OR inAmountUSD = 0 
                                                  THEN (tmpMI.AmountToPay_EUR - tmpMI.AmountDiscount_EUR - tmpMI.AmountRounding_EUR - tmpMI.Amount_EUR - COALESCE(res.Amount_EUR, 0)) * inCurrencyValueEUR 
                                                  ELSE (tmpMI.AmountToPay_EUR - tmpMI.AmountDiscount_EUR - tmpMI.AmountRounding_EUR - tmpMI.Amount_EUR - COALESCE(res.Amount_EUR, 0)) * inCurrencyValueUSD * inCurrencyValueCross END) AS Amount_calc
                                         
                                     , tmpMI.Ord

                                FROM _tmpResult AS tmpMI
                                 
                                     LEFT JOIN (SELECT res.ParentId
                                                     , Round(Sum(res.Amount_EUR + res.AmountDiscount_EUR), 2)::TFloat AS Amount_EUR
                                                FROM _tmpResult AS res 
                                                 WHERE res.CurrencyId <> zc_Currency_EUR()
                                                  AND COALESCE (res.ParentId, 0) <> 0
                                                GROUP BY res.ParentId) AS res ON res.ParentId = tmpMI.ParentId 
                                 
                                WHERE COALESCE (tmpMI.ParentId, 0) <> 0
                                  AND tmpMI.CurrencyId = zc_Currency_EUR()
                               ) AS tmpMI
                          )
               -- 2.2. оплата GRN результат - !!! грн !!!
             , tmp_MI_GRN_res AS (SELECT DD.MovementItemId

                                        , CASE WHEN vbAmountGRN_Pay  - DD.Amount_SUM > 0
                                               -- оплатили полностью
                                               THEN DD.Amount_calc
                                               -- оплатили частично
                                               WHEN vbAmountGRN_Pay - (DD.Amount_SUM - DD.Amount_calc) > 0
                                               THEN vbAmountGRN_Pay - (DD.Amount_SUM - DD.Amount_calc)
                                               ELSE 0 
                                          END AS Amount

                                        , CASE WHEN vbAmountGRN_Pay  - DD.Amount_SUM > 0
                                               -- оплатили полностью
                                               THEN DD.Amount_all
                                               -- оплатили частично
                                               WHEN vbAmountGRN_Pay - (DD.Amount_SUM - DD.Amount_calc) > 0
                                               THEN Round(CASE WHEN inisChangeEUR = TRUE OR inAmountUSD = 0 
                                                               THEN (vbAmountGRN_Pay - (DD.Amount_SUM - DD.Amount_calc)) * inCurrencyValueEUR 
                                                               ELSE (vbAmountGRN_Pay - (DD.Amount_SUM - DD.Amount_calc)) * inCurrencyValueUSD * inCurrencyValueCross END, 2) 
                                               ELSE 0
                                          END AS Amount_EUR

                                        , CASE WHEN vbAmountGRN_Pay  - DD.Amount_SUM > 0
                                               -- оплатили полностью, поправили скидку
                                               THEN Round(DD.Amount_all - CASE WHEN inisChangeEUR = TRUE OR inAmountUSD = 0 
                                                                               THEN DD.Amount_calc / inCurrencyValueEUR 
                                                                               ELSE DD.Amount_calc / inCurrencyValueUSD / inCurrencyValueCross END, 2) ::TFloat
                                               -- оплатили частично
                                               ELSE 0
                                          END :: TFloat AS AmountDiscount_EUR_add

                                        , CASE WHEN vbAmountGRN_Pay  - DD.Amount_SUM > 0
                                               -- оплатили полностью, поправили скидку
                                               THEN Round(CASE WHEN inisChangeEUR = TRUE OR inAmountUSD = 0 
                                                               THEN DD.Amount_all * inCurrencyValueEUR 
                                                               ELSE DD.Amount_all * inCurrencyValueUSD * inCurrencyValueCross END - DD.Amount_calc, 2) ::TFloat
                                               -- оплатили частично
                                               ELSE 0
                                          END :: TFloat AS AmountDiscount_GRN_add

                                          -- накопительно - сколько оплатили
                                        , DD.Amount_SUM

                                        , DD.Ord
 
                                   FROM tmp_MI_GRN AS DD
                                  /* WHERE vbAmountGRN_Pay - (DD.Amount_SUM - DD.Amount_calc) > 0
                                     AND DD.Amount_all > 0*/
                                  ) 
                            
     INSERT INTO _tmpResult (MovementItemId, ParentId, CashId, CurrencyId, AmountToPay, AmountToPay_EUR
                           , AmountDiscount, AmountDiscount_EUR
                           , AmountRounding, AmountRounding_EUR
                           , Amount, Amount_GRN, Amount_EUR
                           , CurrencyValue, CurrencyValueIn, ParValue, CashId_Exc, Ord)
     SELECT tmpMI_Child.MovementItemId AS MovementItemId
          , res.MovementItemId  AS ParentId
          , tmpCash.CashId
          , tmpCash.CurrencyId

            -- Сумма с учетом Дополнительная скидка
          , _tmpResult.AmountToPay                 :: TFloat AS AmountToPay
          , _tmpResult.AmountToPay_EUR             :: TFloat AS AmountToPay_EUR            
            -- Дополнительная скидка
          , CASE WHEN res.Amount > 0 
                 THEN res.AmountDiscount_GRN_add 
                 ELSE 0 END:: TFloat                         AS AmountDiscount
          , CASE WHEN res.Amount > 0 
                 THEN res.AmountDiscount_EUR_add 
                 ELSE 0 END:: TFloat                         AS AmountDiscount_EUR
            -- Дополнительное округление
          , 0 :: TFloat AS AmountRounding
          , 0 :: TFloat AS AmountRounding_EUR

          , res.Amount :: TFloat AS Amount

          , res.Amount :: TFloat AS Amount_GRN
          , res.Amount_EUR :: TFloat AS Amount_EUR

          , 0 :: TFloat              AS CurrencyValue
          , 0 :: TFloat              AS CurrencyValueIn
          , 0                        AS ParValue

          , 0 :: Integer             AS CashId_Exc
          
          , res.Ord
     FROM tmp_MI_GRN_res AS res
          LEFT JOIN _tmpResult ON _tmpResult.ParentId = res.MovementItemId
                              AND _tmpResult.CurrencyId = zc_Currency_EUR()
          LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = FALSE
          LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = res.MovementItemId
                               AND tmpMI_Child.CashId   = tmpCash.CashId
     WHERE (COALESCE (res.Amount, 0) <> 0 OR COALESCE (tmpMI_Child.MovementItemId, 0) <> 0)
     ;
          
     -- Поправили округление из за распределения целыми суммами GRN
     IF vbAmountGRN_Pay > 0
     THEN
       vbMaxOrder := (SELECT Max(tmpMI.Ord) FROM _tmpResult AS tmpMI 
                      WHERE tmpMI.CurrencyId = zc_Currency_GRN() AND tmpMI.Amount > 0 
                        AND tmpMI.CashId = (SELECT tmpCash.CashId FROM tmpCash WHERE tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = False));
                        
       UPDATE _tmpResult SET AmountDiscount = COALESCE(tmpData.AmountDiscount, 0)
                           , AmountDiscount_EUR = COALESCE(tmpData.AmountDiscount_EUR, 0)
                           , Amount = vbAmountGRN_Pay - COALESCE(tmpData.Amount, 0)    
                           , Amount_GRN = vbAmountGRN_Pay - COALESCE(tmpData.Amount_GRN, 0)    
                           , Amount_EUR = vbAmountGRN_EUR - COALESCE(tmpData.Amount_EUR, 0)    
       FROM (SELECT SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN - tmpMI.AmountDiscount END):: TFloat AS AmountDiscount
                  , SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN - tmpMI.AmountDiscount_EUR END):: TFloat AS AmountDiscount_EUR
                  , SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN tmpMI.Amount END):: TFloat AS Amount
                  , SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN tmpMI.Amount_GRN END):: TFloat AS Amount_GRN
                  , SUM(CASE WHEN tmpMI.Ord <> vbMaxOrder THEN tmpMI.Amount_EUR END):: TFloat AS Amount_EUR
             FROM _tmpResult AS tmpMI
             WHERE tmpMI.CurrencyId = zc_Currency_GRN() 
               AND tmpMI.Amount > 0 
               AND tmpMI.CashId = (SELECT tmpCash.CashId FROM tmpCash WHERE tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = FALSE)) AS tmpData
       WHERE _tmpResult.CurrencyId = zc_Currency_GRN() AND _tmpResult.Ord = vbMaxOrder
         AND _tmpResult.CashId = (SELECT tmpCash.CashId FROM tmpCash WHERE tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = FALSE);
     END IF; 
     
     
     -- ********** Перераспределили скидки по гривне и евро с учнтом оплат **********
     -- Уберем переплаты по грн и евро
     UPDATE _tmpResult SET AmountDiscount = CASE WHEN (_tmpResult.AmountToPay - COALESCE( tmpData.AmountDiscount, 0) - COALESCE( tmpData.AmountRounding, 0)) < COALESCE( tmpData.Amount_GRN, 0) 
                                                 THEN _tmpResult.AmountDiscount + (_tmpResult.AmountToPay - COALESCE( tmpData.AmountDiscount, 0) - COALESCE( tmpData.AmountRounding, 0)) - COALESCE( tmpData.Amount_GRN, 0) 
                                                 ELSE _tmpResult.AmountDiscount END
                         , AmountDiscount_EUR = CASE WHEN (_tmpResult.AmountToPay_EUR - COALESCE( tmpData.AmountDiscount_EUR, 0) - COALESCE( tmpData.AmountRounding_EUR, 0)) < COALESCE( tmpData.Amount_EUR, 0)  
                                                     THEN _tmpResult.AmountDiscount_EUR + (_tmpResult.AmountToPay_EUR - COALESCE( tmpData.AmountDiscount_EUR, 0) - COALESCE( tmpData.AmountRounding_EUR, 0)) - COALESCE( tmpData.Amount_EUR, 0)  
                                                     ELSE _tmpResult.AmountDiscount_EUR END
     FROM (SELECT tmpMI.ParentId
                , SUM(tmpMI.AmountDiscount):: TFloat AS AmountDiscount
                , SUM(tmpMI.AmountRounding):: TFloat AS AmountRounding
                , SUM(tmpMI.Amount_GRN):: TFloat AS Amount_GRN
                , SUM(tmpMI.AmountDiscount_EUR):: TFloat AS AmountDiscount_EUR
                , SUM(tmpMI.AmountRounding_EUR):: TFloat AS AmountRounding_EUR
                , SUM(tmpMI.Amount_EUR):: TFloat AS Amount_EUR
           FROM _tmpResult AS tmpMI
           WHERE tmpMI.ParentId <> 0
           GROUP BY tmpMI.ParentId) AS tmpData
     WHERE _tmpResult.CurrencyId = zc_Currency_EUR() 
       AND _tmpResult.ParentId = tmpData.ParentId;

     -- Получили что надо дораспределить
     SELECT (vbAmountDiscount - SUM(_tmpResult.AmountDiscount)) :: TFloat AS AmountDiscount
          , (vbAmountDiscount_EUR - SUM(_tmpResult.AmountDiscount_EUR)) :: TFloat AS AmountDiscount_EUR
     INTO vbAmountDiscRest, vbAmountDiscRest_EUR 
     FROM _tmpResult
     WHERE _tmpResult.CurrencyId = zc_Currency_EUR();

     -- raise notice 'Discount: % % % %', vbAmountDiscount, vbAmountDiscRest, vbAmountDiscount_EUR, vbAmountDiscRest_EUR;    
      
     -- Дораспределили остатки скидок
     UPDATE _tmpResult SET AmountDiscount = _tmpResult.AmountDiscount + COALESCE(tmpData.AmountDiscountAdd, 0)
                         , AmountDiscount_EUR = _tmpResult.AmountDiscount_EUR + COALESCE(tmpData.AmountDiscountAdd_EUR, 0)
     FROM (WITH  tmp_MI AS (SELECT tmpMI.ParentId
                                 , tmpMI.Amount_calc   AS Amount_calc
                                 , tmpMI.Amount_EUR_calc  AS Amount_EUR_calc
                                   --
                                 , SUM (tmpMI.Amount_calc) OVER (ORDER BY tmpMI.Ord) AS Amount_SUM
                                 , SUM (tmpMI.Amount_EUR_calc) OVER (ORDER BY tmpMI.Ord) AS Amount_EUR_SUM
                                           
                                 , tmpMI.Ord
                                       
                            FROM (SELECT tmpMI.ParentId     AS ParentId

                                         -- Сумма до полной оплаты грн
                                       , tmpMI.AmountToPay - (COALESCE(res.Amount_GRN, 0) + COALESCE(res.AmountDiscount, 0) + COALESCE(res.AmountRounding, 0))  AS Amount_calc

                                         -- Сумма до полной оплаты евро
                                       , tmpMI.AmountToPay_EUR - (COALESCE(res.Amount_EUR, 0) + COALESCE(res.AmountDiscount_EUR, 0) + COALESCE(res.AmountRounding_EUR, 0))  AS Amount_EUR_calc
                                               
                                       , tmpMI.Ord

                                  FROM _tmpResult AS tmpMI
                                       
                                       LEFT JOIN (SELECT tmpMI.ParentId
                                                , SUM(tmpMI.AmountDiscount):: TFloat AS AmountDiscount
                                                , SUM(tmpMI.AmountRounding):: TFloat AS AmountRounding
                                                , SUM(tmpMI.Amount_GRN):: TFloat AS Amount_GRN
                                                , SUM(tmpMI.AmountDiscount_EUR):: TFloat AS AmountDiscount_EUR
                                                , SUM(tmpMI.AmountRounding_EUR):: TFloat AS AmountRounding_EUR
                                                , SUM(tmpMI.Amount_EUR):: TFloat AS Amount_EUR
                                           FROM _tmpResult AS tmpMI
                                           WHERE tmpMI.ParentId <> 0
                                           GROUP BY tmpMI.ParentId) AS res ON res.ParentId = tmpMI.ParentId 
                                       
                                  WHERE COALESCE (tmpMI.ParentId, 0) <> 0
                                    AND tmpMI.CurrencyId = zc_Currency_EUR()
                                 ) AS tmpMI
                            )
           -- 2.2. распределили
           SELECT DD.ParentId

                , CASE WHEN vbAmountDiscRest - DD.Amount_SUM > 0
                       -- оплатили полностью
                       THEN DD.Amount_calc
                       -- оплатили частично
                       WHEN vbAmountDiscRest - (DD.Amount_SUM - DD.Amount_calc) > 0
                       THEN vbAmountDiscRest - (DD.Amount_SUM - DD.Amount_calc)
                       ELSE 0 
                  END AS AmountDiscountAdd

                , CASE WHEN vbAmountDiscRest_EUR - DD.Amount_EUR_SUM > 0
                       -- оплатили полностью
                       THEN DD.Amount_EUR_calc
                       -- оплатили частично
                       WHEN vbAmountDiscRest_EUR - (DD.Amount_EUR_SUM - DD.Amount_EUR_calc) > 0
                       THEN vbAmountDiscRest_EUR - (DD.Amount_EUR_SUM - DD.Amount_EUR_calc)
                       ELSE 0 
                  END AS AmountDiscountAdd_EUR

           FROM tmp_MI AS DD) AS tmpData
     WHERE _tmpResult.CurrencyId = zc_Currency_EUR() 
       AND _tmpResult.ParentId = tmpData.ParentId;

     
     -- ********** Обмен (переплата) **********
     
     -- Обмен EUR -> GRN
     INSERT INTO _tmpResult (MovementItemId, ParentId, CashId, CurrencyId, AmountToPay, AmountToPay_EUR
                           , AmountDiscount, AmountDiscount_EUR
                           , AmountRounding, AmountRounding_EUR
                           , Amount, Amount_GRN, Amount_EUR
                           , CurrencyValue, CurrencyValueIn, ParValue, CashId_Exc)
     SELECT tmpMI_Child.MovementItemId AS MovementItemId
          , 0                          AS ParentId
          , tmpCash.CashId
          , tmpCash.CurrencyId

          , 0 :: TFloat AS AmountToPay
          , 0 :: TFloat AS AmountToPay_curr
          , 0 :: TFloat AS AmountDiscount
          , 0 :: TFloat AS AmountDiscount_curr
            -- Дополнительное округление
          , 0 :: TFloat AS AmountRounding
          , 0 :: TFloat AS AmountRounding_curr

          , vbAmountEUR_Over     :: TFloat AS Amount
          , vbAmountEUR_Over_GRN :: TFloat AS Amount_GRN
          , 0                    :: TFloat AS Amount_EUR

          , inCurrencyValueEUR           AS CurrencyValue
          , inCurrencyValueInEUR         AS CurrencyValueIn
          , inParValueEUR                AS ParValue
          , tmpCash_ch.CashId :: Integer AS CashId_Exc

     FROM tmpCash 
          LEFT JOIN tmpCash AS tmpCash_ch ON tmpCash_ch.CurrencyId = zc_Currency_GRN() AND tmpCash_ch.isBankAccount = FALSE
          LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = 0
                               AND tmpMI_Child.CashId   = tmpCash.CashId
     WHERE tmpCash.CurrencyId = zc_Currency_EUR()
       AND (COALESCE (vbAmountEUR_Over, 0) > 0 OR COALESCE (tmpMI_Child.MovementItemId, 0) <> 0);     

     -- Обмен USD -> GRN
     INSERT INTO _tmpResult (MovementItemId, ParentId, CashId, CurrencyId, AmountToPay, AmountToPay_EUR
                           , AmountDiscount, AmountDiscount_EUR
                           , AmountRounding, AmountRounding_EUR
                           , Amount, Amount_GRN, Amount_EUR
                           , CurrencyValue, CurrencyValueIn, ParValue, CashId_Exc)
     SELECT tmpMI_Child.MovementItemId AS MovementItemId
          , 0                          AS ParentId
          , tmpCash.CashId
          , tmpCash.CurrencyId

          , 0 :: TFloat AS AmountToPay
          , 0 :: TFloat AS AmountToPay_curr
          , 0 :: TFloat AS AmountDiscount
          , 0 :: TFloat AS AmountDiscount_curr
            -- Дополнительное округление
          , 0 :: TFloat AS AmountRounding
          , 0 :: TFloat AS AmountRounding_curr

          , vbAmountUSD_Over    :: TFloat AS Amount
          , vbAmountUSD_Over_GRN :: TFloat AS Amount_GRN
          , 0                  :: TFloat AS Amount_EUR

          , inCurrencyValueUSD           AS CurrencyValue
          , inCurrencyValueInUSD         AS CurrencyValueIn
          , inParValueEUR                AS ParValue
          , tmpCash_ch.CashId :: Integer AS CashId_Exc

     FROM tmpCash 
          LEFT JOIN tmpCash AS tmpCash_ch ON tmpCash_ch.CurrencyId = zc_Currency_GRN() AND tmpCash_ch.isBankAccount = FALSE
          LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = 0
                               AND tmpMI_Child.CashId   = tmpCash.CashId
     WHERE tmpCash.CurrencyId = zc_Currency_USD()
       AND (COALESCE (vbAmountUSD_Over, 0) > 0 OR COALESCE (tmpMI_Child.MovementItemId, 0) <> 0);     

     -- Переплата CARD -> GRN
     INSERT INTO _tmpResult (MovementItemId, ParentId, CashId, CurrencyId, AmountToPay, AmountToPay_EUR
                           , AmountDiscount, AmountDiscount_EUR
                           , AmountRounding, AmountRounding_EUR
                           , Amount, Amount_GRN, Amount_EUR
                           , CurrencyValue, CurrencyValueIn, ParValue, CashId_Exc)
     SELECT tmpMI_Child.MovementItemId AS MovementItemId
          , 0                          AS ParentId
          , tmpCash.CashId
          , tmpCash.CurrencyId

          , 0 :: TFloat AS AmountToPay
          , 0 :: TFloat AS AmountToPay_curr
          , 0 :: TFloat AS AmountDiscount
          , 0 :: TFloat AS AmountDiscount_curr
            -- Дополнительное округление
          , 0 :: TFloat AS AmountRounding
          , 0 :: TFloat AS AmountRounding_curr

          , vbAmountCARD_Over  :: TFloat AS Amount
          , vbAmountCARD_Over  :: TFloat AS Amount_GRN
          , 0                  :: TFloat AS Amount_EUR

          , 0 :: TFloat                  AS CurrencyValue
          , 0 :: TFloat                  AS CurrencyValueIn
          , 0                            AS ParValue
          , tmpCash_ch.CashId :: Integer AS CashId_Exc

     FROM tmpCash 
          LEFT JOIN tmpCash AS tmpCash_ch ON tmpCash_ch.CurrencyId = zc_Currency_GRN() AND tmpCash_ch.isBankAccount = FALSE
          LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = 0
                               AND tmpMI_Child.CashId   = tmpCash.CashId
     WHERE tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = TRUE
       AND (COALESCE (vbAmountCARD_Over, 0) > 0 OR COALESCE (tmpMI_Child.MovementItemId, 0) <> 0);     


     -- Переплата GRN -> GRN
     INSERT INTO _tmpResult (MovementItemId, ParentId, CashId, CurrencyId, AmountToPay, AmountToPay_EUR
                           , AmountDiscount, AmountDiscount_EUR
                           , AmountRounding, AmountRounding_EUR
                           , Amount, Amount_GRN, Amount_EUR
                           , CurrencyValue, CurrencyValueIn, ParValue, CashId_Exc)
     SELECT tmpMI_Child.MovementItemId AS MovementItemId
          , 0                          AS ParentId
          , tmpCash.CashId
          , tmpCash.CurrencyId

          , 0 :: TFloat AS AmountToPay
          , 0 :: TFloat AS AmountToPay_curr
          , 0 :: TFloat AS AmountDiscount
          , 0 :: TFloat AS AmountDiscount_curr
            -- Дополнительное округление
          , 0 :: TFloat AS AmountRounding
          , 0 :: TFloat AS AmountRounding_curr

          , vbAmountGRN_Over   :: TFloat AS Amount
          , inAmountDiff       :: TFloat AS Amount_GRN
          , 0                  :: TFloat AS Amount_EUR

          , 0 :: TFloat                  AS CurrencyValue
          , 0 :: TFloat                  AS CurrencyValueIn
          , 0                            AS ParValue
          , tmpCash_ch.CashId :: Integer AS CashId_Exc

     FROM tmpCash 
          LEFT JOIN tmpCash AS tmpCash_ch ON tmpCash_ch.CurrencyId = zc_Currency_GRN() AND tmpCash_ch.isBankAccount = FALSE
          LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = 0
                               AND tmpMI_Child.CashId   = tmpCash.CashId
     WHERE tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = FALSE
       AND (COALESCE (vbAmountGRN_Over, 0) > 0 OR COALESCE (tmpMI_Child.MovementItemId, 0) <> 0 OR inAmountDiff <> 0);     
       
     -- Проверим итоговые суммы
     SELECT 
       -- Оплата
       -- AmountGRN
       CASE WHEN COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_GRN() AND _tmpResult.ParentId <> 0 THEN _tmpResult.Amount ELSE 0 END), 0)::TFloat <> vbAmountGRN_Pay
            THEN 'Сумму распределенной оплаты грн. '||COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_GRN() AND _tmpResult.ParentId <> 0 THEN _tmpResult.Amount ELSE 0 END), 0)::Text||
                 ' не равна сумме оплаты: '||vbAmountGRN_Pay::Text||Chr(13)
            ELSE '' END||
       -- AmountUSD
       CASE WHEN COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_USD() AND _tmpResult.ParentId <> 0 THEN _tmpResult.Amount ELSE 0 END), 0)::TFloat <> vbAmountUSD_Pay
            THEN 'Сумму распределенной оплаты доллар. '||COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_USD() AND _tmpResult.ParentId <> 0 THEN _tmpResult.Amount ELSE 0 END), 0)::Text||
                 ' не равна сумме оплаты: '||vbAmountUSD_Pay::Text||Chr(13)
            ELSE '' END||
       -- AmountEUR
       CASE WHEN COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_EUR() AND _tmpResult.ParentId <> 0 THEN _tmpResult.Amount ELSE 0 END), 0)::TFloat <> vbAmountEUR_Pay
            THEN 'Сумму распределенной оплаты евро. '||COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_EUR() AND _tmpResult.ParentId <> 0 THEN _tmpResult.Amount ELSE 0 END), 0)::Text||
                 ' не равна сумме оплаты: '||vbAmountEUR_Pay::Text||Chr(13)
            ELSE '' END||
       -- AmountCard
       CASE WHEN COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() AND _tmpResult.ParentId <> 0 THEN _tmpResult.Amount ELSE 0 END), 0)::TFloat <> vbAmountCARD_Pay
            THEN 'Сумму распределенной оплаты карта. '||COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() AND _tmpResult.ParentId <> 0 THEN _tmpResult.Amount ELSE 0 END), 0)::Text||
                 ' не равна сумме оплаты: '||vbAmountGRN_Over::Text||Chr(13)
            ELSE '' END||
                                 
       -- Переплата  
       -- AmountGRN                                   
       CASE WHEN COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_GRN() AND _tmpResult.ParentId = 0 THEN _tmpResult.Amount ELSE 0 END), 0)::TFloat <> vbAmountGRN_Over
            THEN 'Сумму распределенной переплаты грн. '||COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_GRN() AND _tmpResult.ParentId = 0 THEN _tmpResult.Amount ELSE 0 END), 0)::Text||
                 ' не равна сумме переплаты: '||vbAmountGRN_Over::Text||Chr(13)
            ELSE '' END||
       -- AmountUSD
       CASE WHEN COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_USD() AND _tmpResult.ParentId = 0 THEN _tmpResult.Amount ELSE 0 END), 0)::TFloat <> vbAmountUSD_Over
            THEN 'Сумму распределенной переплаты доллар. '||COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_USD() AND _tmpResult.ParentId = 0 THEN _tmpResult.Amount ELSE 0 END), 0)::Text||
                 ' не равна сумме переплаты: '||vbAmountUSD_Over::Text||Chr(13)
            ELSE '' END||
       -- AmountEUR
       CASE WHEN COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_EUR() AND _tmpResult.ParentId = 0 THEN _tmpResult.Amount ELSE 0 END), 0)::TFloat <> vbAmountEUR_Over
            THEN 'Сумму распределенной переплаты евро. '||COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND _tmpResult.CurrencyId = zc_Currency_EUR() AND _tmpResult.ParentId = 0 THEN _tmpResult.Amount ELSE 0 END), 0)::Text||
                 ' не равна сумме переплаты: '||vbAmountEUR_Over::Text||Chr(13)
            ELSE '' END||
       -- AmountCard
       CASE WHEN COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() AND _tmpResult.ParentId = 0 THEN _tmpResult.Amount ELSE 0 END), 0)::TFloat <> vbAmountCARD_Over
            THEN 'Сумму распределенной переплаты карта. '||COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() AND _tmpResult.ParentId = 0 THEN _tmpResult.Amount ELSE 0 END), 0)::Text||
                 ' не равна сумме переплаты: '||vbAmountCARD_Over::Text||Chr(13)
            ELSE '' END||

       -- Скидка
       -- AmountGRN
       CASE WHEN COALESCE (SUM (_tmpResult.AmountDiscount), 0)::TFloat <> vbAmountDiscount
            THEN 'Сумму распределенной скидки грн. '||COALESCE (SUM (_tmpResult.AmountDiscount), 0)::Text||
                 ' не равна сумме скидки: '||vbAmountDiscount::Text||Chr(13)
            ELSE '' END||
       -- AmountEUR
       CASE WHEN COALESCE (SUM (_tmpResult.AmountDiscount_EUR), 0)::TFloat <> vbAmountDiscount_EUR
            THEN 'Сумму распределенной скидки евро. '||COALESCE (SUM (_tmpResult.AmountDiscount_EUR)::TFloat, 0)::Text||
                 ' не равна сумме скидки: '||vbAmountDiscount_EUR::Text||Chr(13)
            ELSE '' END||

       -- Округление
       -- AmountGRN
       CASE WHEN COALESCE (SUM (_tmpResult.AmountRounding), 0)::TFloat <> vbAmountRounding
            THEN 'Сумму распределенной округления грн. '||COALESCE (SUM (_tmpResult.AmountRounding), 0)::Text||
                 ' не равна сумме округления: '||vbAmountRounding::Text||Chr(13)
            ELSE '' END||
       -- AmountEUR
       CASE WHEN COALESCE (SUM (_tmpResult.AmountRounding_EUR), 0)::TFloat <> vbAmountRounding_EUR
            THEN 'Сумму распределенной округления евро. '||COALESCE (SUM (_tmpResult.AmountRounding_EUR)::TFloat, 0)::Text||
                 ' не равна сумме округления: '||vbAmountRounding_EUR::Text||Chr(13)
            ELSE '' END

     INTO vbText
     FROM _tmpResult
     
          LEFT JOIN Object ON Object.Id = _tmpResult.CashId;
       
     IF COALESCE(vbText, '') <> ''
     THEN
        RAISE notice /*EXCEPTION*/ 'Ошибка. Не удалось распределить суммы:% %', Chr(13), vbText;
     END IF;
          
     -- RAISE notice /*EXCEPTION*/ 'Ошибка. %', (SELECT SUM (_tmpResult.AmountDiscount) FROM _tmpResult     );
                              
     -- Результат такой
     RETURN QUERY
     SELECT tmpResult.MovementItemId
          , tmpResult.ParentId
          , tmpResult.CashId
          , tmpResult.CurrencyId
          , tmpResult.AmountToPay
          , tmpResult.AmountToPay_EUR
          , tmpResult.AmountDiscount
          , tmpResult.AmountDiscount_EUR
          , tmpResult.AmountRounding
          , tmpResult.AmountRounding_EUR
          , tmpResult.Amount
          , tmpResult.Amount_GRN
          , tmpResult.Amount_EUR
          , tmpResult.CurrencyValue
          , tmpResult.CurrencyValueIn
          , tmpResult.ParValue
          , tmpResult.CashId_Exc     
     FROM _tmpResult AS tmpResult;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.05.17         *
*/

-- тест

SELECT Object_Cash.valuedata, Calc.* 
FROM lpSelect_MI_Child_calc(
      inMovementId            := 23589        
    , inUnitId                := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = 23589 AND MLO.DescId = zc_MovementLinkObject_From())
    , inAmountGRN := 0 , inAmountUSD := 300 , inAmountEUR := 200 , inAmountCARD := 0, inAmountDiscount_EUR := 0, inAmountDiff :=  1020, inAmountRemains_EUR := 0
    , inisDiscount := 'False', inisChangeEUR := 'False'
    , inCurrencyValueUSD := 37.68 , inCurrencyValueInUSD := 37.31 , inParValueUSD := 1
    , inCurrencyValueEUR := 40.95 , inCurrencyValueInEUR := 40.54 , inParValueEUR := 1
    , inCurrencyValueCross := 1.0868 , inParValueCross := 1
    , inCurrencyId_Client     := zc_Currency_EUR()
    , inUserId                := 2
) AS Calc left join Object AS Object_Cash ON Object_Cash.Id = Calc.CashId --WHERE Calc.CashId = 18666
ORDER BY Calc.ParentId, Calc.ParValue;

/*
SELECT 
       Calc.parentid
     , Max(Calc.amounttopay)         AS amounttopay
     , Sum(Calc.amountdiscount)      AS amountdiscount
     , Sum(Calc.amountrounding)      AS amountrounding
     , Max(Calc.amounttopay) -
       Sum(Calc.amountdiscount) -
       Sum(Calc.amountrounding)      AS amountpay
     , Sum(Calc.amount_grn)          AS amount_grn
     , Max(Calc.amounttopay) -
       Sum(Calc.amountdiscount) -
       Sum(Calc.amountrounding) -
       Sum(Calc.amount_grn)          AS dif
     
     , Max(Calc.amounttopay_eur)     AS amounttopay_eur
     , Sum(Calc.amountdiscount_eur)  AS amountdiscount_eur
     , Sum(Calc.amountrounding_eur)  AS amountrounding_eur
     , Max(Calc.amounttopay_eur) -
       Sum(Calc.amountdiscount_eur) -
       Sum(Calc.amountrounding_eur) AS amountpay_eur
     , Sum(Calc.amount_eur)         AS amount_eur
     , Max(Calc.amounttopay_eur) -
       Sum(Calc.amountdiscount_eur) -
       Sum(Calc.amountrounding_eur) -
       Sum(Calc.amount_eur)         AS dif_eur
     
     
FROM lpSelect_MI_Child_calc(
      inMovementId            := 23589        
    , inUnitId                := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = 23589 AND MLO.DescId = zc_MovementLinkObject_From())
    , inAmountGRN := 6164 , inAmountUSD := 328 , inAmountEUR := 0 , inAmountCARD := 0, inAmountDiscount_EUR := 0, inAmountDiff :=  0, inAmountRemains_EUR := 175.77
    , inisDiscount := 'False', inisChangeEUR := 'False'
    , inCurrencyValueUSD := 37.68 , inCurrencyValueInUSD := 37.31 , inParValueUSD := 1
    , inCurrencyValueEUR := 40.95 , inCurrencyValueInEUR := 40.54 , inParValueEUR := 1
    , inCurrencyValueCross := 1.09 , inParValueCross := 1
    , inCurrencyId_Client     := zc_Currency_EUR()
    , inUserId                := 2
) AS Calc 
WHERE Calc.parentid <> 0
GROUP BY Calc.parentid
ORDER BY Calc.ParentId*/