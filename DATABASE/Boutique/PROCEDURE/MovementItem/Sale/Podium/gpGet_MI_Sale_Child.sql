-- Function: gpGet_MI_Sale_Child()

--DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child (Integer, Integer, TVarChar);
/*DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child (Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child (Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);*/

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child(
    IN inId             Integer  , -- ключ
    IN inMovementId     Integer  , --
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , CurrencyId_Client Integer, CurrencyName_Client TVarChar
             , CurrencyNum_ToPay Integer, CurrencyNum_ToPay_EUR Integer

             , CurrencyValue_USD  TFloat, CurrencyValueIn_USD TFloat, ParValue_USD  TFloat
             , CurrencyValue_EUR  TFloat, CurrencyValueIn_EUR TFloat, ParValue_EUR  TFloat
             , CurrencyValue_Cross TFloat, ParValue_Cross TFloat

             , AmountGRN           TFloat
             , AmountUSD           TFloat
             , AmountEUR           TFloat
             , AmountCard          TFloat

               -- Дополнительная скидка грн.
             , AmountDiscount      TFloat
               -- Дополнительная скидка (целая часть)
             , AmountDiscRound     TFloat
               -- Дополнительная скидка (копейки)
             , AmountDiscDiff      TFloat
               -- Округление курсов по грн.
             , AmountRounding  TFloat

               -- Дополнительная скидка EUR
             , AmountDiscount_EUR  TFloat
               -- Дополнительная скидка EUR (целая часть)
             , AmountDiscRound_EUR TFloat
               -- Дополнительная скидка EUR (копейки)
             , AmountDiscDiff_EUR  TFloat
               -- Округление курсов по EUR
             , AmountRounding_EUR  TFloat

               -- Информативно - для Диалога
             , AmountToPay         TFloat
             , AmountToPay_EUR     TFloat
             
               -- факт - отсюда долг
             , AmountToPayFull_GRN TFloat
             , AmountToPayFull_EUR TFloat

             , AmountRemainsCalc       TFloat
             , AmountRemainsCalc_EUR   TFloat

               -- сдача, ГРН
             , AmountDiff          TFloat
             
             , isPayTotal          Boolean
             
             , isGRN               Boolean
             , isUSD               Boolean
             , isEUR               Boolean
             , isCard              Boolean
             , isDiscount          Boolean

             , isGRNOld            Boolean
             , isUSDOld            Boolean
             , isEUROld            Boolean
             , isCardOld           Boolean
             , isDiscountOld       Boolean
             
             , isChangeEUR         Boolean
             , isAmountRemains_EUR Boolean
             , AmountRemains_EUR   TFloat
             , isAmountDiff        Boolean
             , AmountDiff_GRN      TFloat
             , isAdmin             Boolean

               -- Расчетная сумма грн.
             , AmountToPay_Calc    TFloat
             , AmountToPay_EUR_Calc TFloat

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
   DECLARE vbUserId                 Integer;
   DECLARE vbCurrencyId_Client      Integer;
   DECLARE vbOperDate               TDateTime;
   DECLARE vbAmountToPay_GRN        TFloat;
   DECLARE vbAmountToPay_EUR        TFloat;
-- DECLARE vbAmountToPay_GRN_real   TFloat;
-- DECLARE vbAmountToPay_EUR_real   TFloat;
   DECLARE vbCurrencyValue_USD      TFloat;
   DECLARE vbCurrencyValueIn_USD    TFloat;
   DECLARE vbParValue_USD           TFloat;
   DECLARE vbCurrencyValue_EUR      TFloat;
   DECLARE vbCurrencyValueIn_EUR    TFloat;
   DECLARE vbParValue_EUR           TFloat;
   DECLARE vbCurrencyValue_Cross    TFloat;
   DECLARE vbParValue_Cross         TFloat;

   DECLARE vbAmountDiscount_GRN     TFloat;
   DECLARE vbAmountDiscount_EUR     TFloat;
   DECLARE vbAmountRounding_GRN     TFloat;
   DECLARE vbAmountRounding_EUR     TFloat;
   DECLARE vbAmountChange           TFloat; 
   DECLARE vbSummTotalPay_GRN       TFloat;
   DECLARE vbSummTotalPay_EUR       TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- данные из документа
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- данные из документа
     vbCurrencyId_Client:= COALESCE((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_CurrencyClient())
                                  , zc_Currency_EUR()
                                   );


     -- Определили курс - если вводили
     SELECT MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN COALESCE (MIFloat_CurrencyValue.ValueData, 0) ELSE 0 END) AS CurrencyValue_USD
          , MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN COALESCE (MIFloat_CurrencyValueIn.ValueData, 0) ELSE 0 END) AS CurrencyValueIn_USD
          , MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN COALESCE (MIFloat_ParValue.ValueData, 1)      ELSE 0 END) AS ParValue_USD
          , MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE (MIFloat_CurrencyValue.ValueData, 0) ELSE 0 END) AS CurrencyValue_EUR
          , MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE (MIFloat_CurrencyValueIn.ValueData, 0) ELSE 0 END) AS CurrencyValueIn_EUR
          , MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE (MIFloat_ParValue.ValueData, 1)      ELSE 0 END) AS ParValue_EUR
            INTO vbCurrencyValue_USD, vbCurrencyValueIn_USD, vbParValue_USD
               , vbCurrencyValue_EUR, vbCurrencyValueIn_EUR, vbParValue_EUR
     FROM MovementItem
          LEFT JOIN MovementItem AS MI_Master ON MI_Master.Id       = MovementItem.ParentId
                                             AND MI_Master.isErased = FALSE
          LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
          INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                            ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
          LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                      ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                     AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
          LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValueIn
                                      ON MIFloat_CurrencyValueIn.MovementItemId = MovementItem.Id
                                     AND MIFloat_CurrencyValueIn.DescId         = zc_MIFloat_CurrencyValueIn()
          LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                      ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                     AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE;


     -- если НЕ нашли
     IF COALESCE (vbCurrencyValue_USD, 0) = 0
     THEN
         -- в первый раз, взять курс из истории
         SELECT tmp.Amount, tmp.CurrencyValueIn, tmp.ParValue INTO vbCurrencyValue_USD, vbCurrencyValueIn_USD, vbParValue_USD
         FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_USD()) AS tmp;
     END IF;
     -- если НЕ нашли
     IF COALESCE (vbCurrencyValueIn_USD, 0) = 0
     THEN
         -- в первый раз, взять курс из истории
         SELECT tmp.CurrencyValueIn INTO vbCurrencyValueIn_USD
         FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_USD()) AS tmp;
     END IF;
     -- если НЕ нашли
     IF COALESCE (vbCurrencyValue_EUR, 0) = 0
     THEN
         -- в первый раз, взять курс из истории
         SELECT tmp.Amount, tmp.CurrencyValueIn, tmp.ParValue INTO vbCurrencyValue_EUR, vbCurrencyValueIn_EUR, vbParValue_EUR
         FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_EUR()) AS tmp;
     END IF;
     -- если НЕ нашли
     IF COALESCE (vbCurrencyValueIn_EUR, 0) = 0
     THEN
         -- в первый раз, взять курс из истории
         SELECT tmp.CurrencyValueIn INTO vbCurrencyValueIn_EUR
         FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_EUR()) AS tmp;
     END IF;


     -- Кросс-курс - если вводили или расчет
     vbCurrencyValue_Cross:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_CurrencyCrossValue())
                                    , zfCalc_CurrencyCross_calc (vbCurrencyValue_EUR, vbCurrencyValue_USD)
                                     );
     vbParValue_Cross:= 1;


     -- Расчет из Мастера
     SELECT -- сумма к оплате ГРН - учитывается ТОЛЬКО скидка %
            /*SUM (zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPriceList.ValueData, 1)
               - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
               + COALESCE (MIFloat_SummChangePercent.ValueData, 0)
                ) AS AmountToPay_GRN*/
             
            zfCalc_CurrencyFrom (   
            SUM (zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, 1)
               - COALESCE (MIFloat_TotalChangePercent_curr.ValueData, 0)
               + COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0)
               + COALESCE (MIFloat_SummRounding_curr.ValueData, 0)), vbCurrencyValue_EUR, 1) AS AmountToPay_GRN   

            -- сумма к оплате EUR - учитывается ТОЛЬКО скидка %
          , SUM (zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, 1)
               - COALESCE (MIFloat_TotalChangePercent_curr.ValueData, 0)
               + COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0)
               + COALESCE (MIFloat_SummRounding_curr.ValueData, 0)) AS AmountToPay_EUR

            -- сумма доп.скидки - Списание при округлении - всегда ГРН
          , SUM (COALESCE (MIFloat_SummChangePercent.ValueData, 0)) AS SummChangePercent_GRN

            -- сумма доп.скидки - Списание при округлении - всегда EUR
          , SUM (COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0)) AS SummChangePercent_EUR

            -- сумма округления - Списание при округлении - всегда ГРН
          , SUM (COALESCE (MIFloat_SummRounding.ValueData, 0)) AS SummRounding_GRN

            -- сумма округления - Списание при округлении - всегда EUR
          , SUM (COALESCE (MIFloat_SummRounding_curr.ValueData, 0)) AS SummRounding_EUR

            -- Итого сумма оплаты ГРН
          , SUM (COALESCE (MIFloat_TotalPay.ValueData, 0)) AS SummTotalPay_GRN

            -- Итого сумма оплаты EUR
          , SUM (COALESCE (MIFloat_TotalPay_curr.ValueData, 0)) AS SummTotalPay_EUR

     INTO vbAmountToPay_GRN, vbAmountToPay_EUR, vbAmountDiscount_GRN, vbAmountDiscount_EUR, vbAmountRounding_GRN, vbAmountRounding_EUR, vbSummTotalPay_GRN, vbSummTotalPay_EUR

     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency_pl
                                           ON MILinkObject_Currency_pl.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Currency_pl.DescId         = zc_MILinkObject_Currency_pl()
          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                      ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                     AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                      ON MIFloat_OperPriceList_curr.MovementItemId = MovementItem.Id
                                     AND MIFloat_OperPriceList_curr.DescId         = zc_MIFloat_OperPriceList_curr()

          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                      ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent_curr
                                      ON MIFloat_TotalChangePercent_curr.MovementItemId = MovementItem.Id
                                     AND MIFloat_TotalChangePercent_curr.DescId         = zc_MIFloat_TotalChangePercent_curr()

          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                      ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_curr
                                      ON MIFloat_SummChangePercent_curr.MovementItemId = MovementItem.Id
                                     AND MIFloat_SummChangePercent_curr.DescId         = zc_MIFloat_SummChangePercent_curr()

          LEFT JOIN MovementItemFloat AS MIFloat_SummRounding
                                      ON MIFloat_SummRounding.MovementItemId = MovementItem.Id
                                     AND MIFloat_SummRounding.DescId         = zc_MIFloat_SummRounding()
          LEFT JOIN MovementItemFloat AS MIFloat_SummRounding_curr
                                      ON MIFloat_SummRounding_curr.MovementItemId = MovementItem.Id
                                     AND MIFloat_SummRounding_curr.DescId         = zc_MIFloat_SummRounding_curr()

          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                      ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                     AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_curr
                                      ON MIFloat_TotalPay_curr.MovementItemId = MovementItem.Id
                                     AND MIFloat_TotalPay_curr.DescId         = zc_MIFloat_TotalPay_curr()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
       AND (MovementItem.Id = inId OR inId = 0)
      ;
      
      
     -- raise notice 'Value 0: % %   % %  % %  % % ', vbAmountToPay_GRN, vbAmountToPay_EUR, vbAmountDiscount_GRN, vbAmountDiscount_EUR, vbAmountRounding_GRN, vbAmountRounding_EUR, vbSummTotalPay_GRN, vbSummTotalPay_EUR;
          
     -- Результат
     RETURN QUERY
        WITH -- 1.1. zc_MI_Child
             tmpRes_all AS (SELECT -- AmountGRN
                                   COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() THEN MovementItem.Amount ELSE 0 END), 0) AS AmountGRN
                                   -- AmountUSD
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END), 0) AS AmountUSD
                                   -- AmountEUR
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END), 0) AS AmountEUR
                                   -- AmountCard
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END), 0) AS AmountCard
                                                                                                   
                                   -- AmountGRNOver
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() AND MovementItem.ParentId IS NULL THEN MovementItem.Amount ELSE 0 END), 0) AS AmountGRNOver
                                   -- AmountUSDOver
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() AND MovementItem.ParentId IS NULL THEN MovementItem.Amount ELSE 0 END), 0) AS AmountUSDOver
                                   -- AmountEUROver
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() AND MovementItem.ParentId IS NULL THEN MovementItem.Amount ELSE 0 END), 0) AS AmountEUROver
                                   -- AmountCardOver
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() AND MovementItem.ParentId IS NULL THEN MovementItem.Amount ELSE 0 END), 0) AS AmountCardOver
                                                                    
                                 -- AmountGRNOver_GRN
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() AND MovementItem.ParentId IS NULL THEN MovementItem.Amount ELSE 0 END), 0) AS AmountGRNOver_GRN
                                   -- AmountUSDOver_GRN
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() AND MovementItem.ParentId IS NULL THEN MIFloat_AmountExchange.ValueData ELSE 0 END), 0) AS AmountUSDOver_GRN
                                   -- AmountEUROver_GRN
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() AND MovementItem.ParentId IS NULL THEN MIFloat_AmountExchange.ValueData ELSE 0 END), 0) AS AmountEUROver_GRN
                                   -- AmountCardOver_GRN
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() AND MovementItem.ParentId IS NULL THEN MovementItem.Amount ELSE 0 END), 0) AS AmountCardOver_GRN
                                   -- AmountDiff
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() AND MovementItem.ParentId IS NULL THEN MIFloat_AmountExchange.ValueData ELSE 0 END), 0) AS AmountDiff
                            FROM MovementItem
                                  LEFT JOIN MovementItem AS MI_Master ON MI_Master.Id = MovementItem.ParentId
                                  LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                   ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                             ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                                 LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                             ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                                 LEFT JOIN MovementItemFloat AS MIFloat_AmountExchange
                                                             ON MIFloat_AmountExchange.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountExchange.DescId         = zc_MIFloat_AmountExchange()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Child()
                              AND MovementItem.isErased   = FALSE
                              AND (MovementItem.ParentId = inId  OR inId = 0)
                              AND (MI_Master.isErased    = FALSE OR MovementItem.ParentId IS NULL)
                           )
                -- 1.2.
              , tmpRes AS (SELECT tmpRes_all.AmountGRN
                                , tmpRes_all.AmountUSD
                                , tmpRes_all.AmountEUR
                                , tmpRes_all.AmountCard
                                , tmpRes_all.AmountGRNOver
                                , tmpRes_all.AmountUSDOver
                                , tmpRes_all.AmountEUROver
                                , tmpRes_all.AmountCardOver
                                , tmpRes_all.AmountGRNOver_GRN
                                , tmpRes_all.AmountUSDOver_GRN
                                , tmpRes_all.AmountEUROver_GRN
                                , tmpRes_all.AmountCardOver_GRN
                                , tmpRes_all.AmountDiff

                                , (tmpRes_all.AmountGRNOver_GRN +
                                   tmpRes_all.AmountUSDOver_GRN +
                                   tmpRes_all.AmountEUROver_GRN +
                                   tmpRes_all.AmountCardOver_GRN) ::TFloat   AS AmountOver_GRN
                                   
                                , Round(((vbAmountToPay_EUR - tmpRes_all.AmountEUR) * vbCurrencyValue_Cross * vbCurrencyValue_USD - (vbAmountToPay_EUR - tmpRes_all.AmountEUR) * vbCurrencyValue_EUR), 2) ::TFloat AS AmountRounding_ForUSD
                                , Round(tmpRes_all.AmountUSD * vbCurrencyValue_USD - Round(tmpRes_all.AmountUSD / vbCurrencyValue_Cross, 2)* vbCurrencyValue_EUR, 2) ::TFloat                                      AS AmountRounding_ForEUR
                                                                   
                           FROM tmpRes_all
                          )
              -- 1.3.
            , tmpMI AS (SELECT tmpRes.AmountGRN
                             , tmpRes.AmountUSD
                             , tmpRes.AmountEUR
                             , tmpRes.AmountCard
                             , tmpRes.AmountGRNOver_GRN
                             , tmpRes.AmountUSDOver_GRN
                             , tmpRes.AmountEUROver_GRN
                             , tmpRes.AmountCardOver_GRN
                             , tmpRes.AmountDiff
                                 
                             , tmpRes.AmountOver_GRN
                                 
                             , tmpRes.AmountRounding_ForUSD
                             , tmpRes.AmountRounding_ForEUR
                                 
                             , CASE WHEN tmpRes.AmountDiff <> 0
                                    THEN ROUND(zfCalc_CurrencyTo (vbAmountDiscount_GRN, vbCurrencyValue_EUR, 1), 2)
                                    ELSE 0 END :: TFloat  AS AmountDiscount_EUR_Diff

                             , tmpRes.AmountUSD > 0 AND (tmpRes.AmountGRN + tmpRes.AmountCard) > 0 AND
                               (tmpRes.AmountRounding_ForUSD <> tmpRes.AmountRounding_ForEUR AND (tmpRes.AmountRounding_ForEUR + vbAmountRounding_GRN)::TFloat = 0 OR 
                               tmpRes.AmountUSDOver_GRN > 0 AND tmpRes.AmountUSDOver_GRN = Round(tmpRes.AmountUSDOver / vbCurrencyValue_Cross * vbCurrencyValueIn_EUR, 2))            AS isChangeEUR
                                   
                        FROM tmpRes
                        )
                         
      -- 1.4. Результат
      SELECT 0                    :: Integer AS Id
           , Object_CurrencyClient.Id        AS CurrencyId_Client
           , Object_CurrencyClient.ValueData AS CurrencyName_Client

           , 1 :: Integer                    AS CurrencyNum_ToPay
           , 2 :: Integer                    AS CurrencyNum_ToPay_EUR

           , vbCurrencyValue_USD             AS CurrencyValue_USD
           , vbCurrencyValueIn_USD           AS CurrencyValueIn_USD
           , vbParValue_USD                  AS ParValue_USD
           , vbCurrencyValue_EUR             AS CurrencyValue_EUR
           , vbCurrencyValueIn_EUR           AS CurrencyValueIn_EUR
           , vbParValue_EUR                  AS ParValue_EUR
           , vbCurrencyValue_Cross           AS CurrencyValue_Cross
           , vbParValue_Cross                AS ParValue_Cross

           , tmpMI.AmountGRN     :: TFloat
           , tmpMI.AmountUSD     :: TFloat
           , tmpMI.AmountEUR     :: TFloat
           , tmpMI.AmountCard    :: TFloat

             -- Дополнительная скидка - ГРН
           , Res.AmountDiscount                                                  AS AmountDiscount
             -- Дополнительная скидка - ГРН
           , round(Res.AmountDiscount)::TFloat                                   AS AmountDiscRound
             -- Округление - ГРН
           , (Res.AmountDiscount - round(Res.AmountDiscount))::TFloat            AS AmountDiscDiff
             -- Округлениее курсов - ГРН
           , Res.AmountRounding


             -- Дополнительная скидка - EUR
           , Res.AmountDiscount_EUR                                                  AS AmountDiscount_EUR
             -- Дополнительная скидка - EUR
           , Round(Res.AmountDiscount_EUR)::TFloat                                   AS AmountDiscRound_EUR
             -- Округление - EUR
           , (Res.AmountDiscount_EUR - round(Res.AmountDiscount_EUR))::TFloat        AS AmountDiscDiff_EUR
             -- Округлениее курсов - EUR
           , Res.AmountRounding_EUR

             -- сумма к оплате, грн - здесь округлили
           , zfCalc_SummPriceList (1, vbAmountToPay_GRN) :: TFloat AS AmountToPay
             -- сумма к оплате, EUR - здесь округлили
           , zfCalc_SummPriceList (1, vbAmountToPay_EUR) :: TFloat AS AmountToPay_EUR
           
             -- сумма к оплате, грн - НЕ округлили, отсюда остаток
           , vbAmountToPay_GRN         :: TFloat AS AmountToPayFull_GRN
             -- сумма к оплате, EUR - НЕ округлили, отсюда остаток
           , vbAmountToPay_EUR         :: TFloat AS AmountToPayFull_EUR

             -- Остаток, грн
           , Res.AmountRemains AS AmountRemainsCalc
             
             -- Остаток, EUR - НЕ округлили
           , Res.AmountRemains_EUR  AS AmountRemainsCalc_EUR

             -- Сдача, грн
           , Res.AmountDiff

           , TRUE AS isPayTotal

           , tmpMI.AmountGRN > 0, tmpMI.AmountUSD > 0, tmpMI.AmountEUR > 0, tmpMI.AmountCard > 0
           , ABS(Res.AmountDiscount_EUR) >= 1 OR ABS(Res.AmountDiscount) >= 5 AND (Res.AmountOver_GRN + Res.AmountDiscount) = 0 AND (Res.AmountOver_GRN) > 0
           , tmpMI.AmountGRN > 0, tmpMI.AmountUSD > 0, tmpMI.AmountEUR > 0, tmpMI.AmountCard > 0
           , ABS(Res.AmountDiscount_EUR) >= 1 OR ABS(Res.AmountDiscount) >= 5 AND (Res.AmountOver_GRN + Res.AmountDiscount) = 0 AND (Res.AmountOver_GRN) > 0
           
           , tmpMI.isChangeEUR
           
           , False                                        AS isAmountRemains_EUR
           , 0 :: TFloat                                  AS AmountRemains_EUR
           , False                                        AS isAmountDiff
           , 0 ::TFloat                                   AS AmountDiff_GRN
                      
           , inSession = zfCalc_UserAdmin()               AS isAdmin

           , Res.AmountToPay_Calc
           , Res.AmountToPay_EUR_Calc 

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

           , Res.AmountRest
           , Res.AmountRest_EUR
           
             -- Итоговые обороты по валютам (должно быть 0)
           , Res.AmountDiffFull_GRN
           , Res.AmountDiffFull_EUR
       FROM tmpMI
      
            LEFT JOIN Object AS Object_CurrencyClient ON Object_CurrencyClient.Id = vbCurrencyId_Client
            
            LEFT JOIN lpGet_MI_Sale_Child_TotalCalc(inCurrencyValueUSD       := vbCurrencyValue_USD
                                                  , inCurrencyValueInUSD     := vbCurrencyValueIn_USD
                                                  , inCurrencyValueEUR       := vbCurrencyValue_EUR
                                                  , inCurrencyValueInEUR     := vbCurrencyValueIn_EUR
                                                  , inCurrencyValueCross     := vbCurrencyValue_Cross

                                                  , inAmountToPay_EUR        := vbAmountToPay_EUR 

                                                  , inAmountGRN              := tmpMI.AmountGRN
                                                  , inAmountUSD              := tmpMI.AmountUSD
                                                  , inAmountEUR              := tmpMI.AmountEUR
                                                  , inAmountCard             := tmpMI.AmountCard
                                                  , inAmountDiscount_EUR     := CASE WHEN ABS(vbAmountDiscount_EUR - tmpMI.AmountDiscount_EUR_Diff) >= 1 
                                                                                     THEN vbAmountDiscount_EUR - tmpMI.AmountDiscount_EUR_Diff 
                                                                                     ELSE ROUND(vbAmountDiscount_EUR - tmpMI.AmountDiscount_EUR_Diff) END
                                                  , inAmountDiscDiff_EUR     := 0
                                                   
                                                  , inisDiscount             := ABS(vbAmountDiscount_EUR + tmpMI.AmountDiscount_EUR_Diff) >= 1 OR ABS(vbAmountDiscount_GRN) >= 5 AND (tmpMI.AmountOver_GRN + vbAmountDiscount_GRN) = 0 AND (tmpMI.AmountOver_GRN) > 0
                                                  , inisChangeEUR            := tmpMI.isChangeEUR
                                                  , inisAmountDiff           := TRUE
                                                  , inAmountDiff             := tmpMI.AmountDiff
                                                  , inCurrencyId_Client      := vbCurrencyId_Client 
                                                  , inUserId                 := vbUserId) AS Res ON 1 = 1
            
            ;          
            
       raise notice 'Value 0: %', ROUND(vbAmountToPay_EUR - vbSummTotalPay_EUR - vbAmountDiscount_EUR - vbAmountRounding_EUR);  

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 10.04.17         *
*/

-- тест
-- SELECT * FROM gpGet_MI_Sale_Child (inId:= 0, inMovementId := 6231, inIsDiscount:= FALSE, inIsGRN:= FALSE, inIsUSD:= FALSE, inIsEUR:= FALSE, inIsCard:= FALSE, inSession:= zfCalc_UserAdmin());


select * from gpGet_MI_Sale_Child(inId := 0 , inMovementId := 23589 ,  inSession := '2');