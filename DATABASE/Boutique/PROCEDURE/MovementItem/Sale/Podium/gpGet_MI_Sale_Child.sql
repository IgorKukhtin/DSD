-- Function: gpGet_MI_Sale_Child()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child(
    IN inId             Integer  , -- ключ
    IN inMovementId     Integer  , --
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , CurrencyValue_USD TFloat, ParValue_USD TFloat
             , CurrencyValue_EUR TFloat, ParValue_EUR TFloat

             , AmountGRN           TFloat
             , AmountUSD           TFloat
             , AmountEUR           TFloat
             , AmountCard          TFloat

             , AmountDiscount      TFloat
             , AmountDiscount_curr TFloat
               -- Информативно - для Диалога
             , AmountToPay         TFloat
             , AmountToPay_curr    TFloat
               -- факт - отсюда долг
             , AmountToPay_GRN     TFloat
             , AmountToPay_EUR     TFloat

             , AmountRemains       TFloat
             , AmountRemains_curr  TFloat

               -- сдача, ГРН
             , AmountDiff          TFloat

             , isPayTotal          Boolean
             , isGRN               Boolean
             , isUSD               Boolean
             , isEUR               Boolean
             , isCard              Boolean
             , isDiscount          Boolean

             , CurrencyId_Client Integer, CurrencyName_Client TVarChar

             , CurrencyNum_ToPay Integer, CurrencyNum_ToPay_curr Integer
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
   DECLARE vbParValue_USD           TFloat;
   DECLARE vbCurrencyValue_EUR      TFloat;
   DECLARE vbParValue_EUR           TFloat;
   DECLARE vbAmountDiscount_GRN     TFloat;
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
          , MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN COALESCE (MIFloat_ParValue.ValueData, 1)      ELSE 0 END) AS ParValue_USD
          , MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE (MIFloat_CurrencyValue.ValueData, 0) ELSE 0 END) AS CurrencyValue_EUR
          , MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE (MIFloat_ParValue.ValueData, 1)      ELSE 0 END) AS ParValue_EUR
            INTO vbCurrencyValue_USD, vbParValue_USD
               , vbCurrencyValue_EUR, vbParValue_EUR
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
         SELECT tmp.Amount, tmp.ParValue INTO vbCurrencyValue_USD, vbParValue_USD
         FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_USD()) AS tmp;
     END IF;
     -- если НЕ нашли
     IF COALESCE (vbCurrencyValue_EUR, 0) = 0
     THEN
         -- в первый раз, взять курс из истории
         SELECT tmp.Amount, tmp.ParValue INTO vbCurrencyValue_EUR, vbParValue_EUR
         FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_EUR()) AS tmp;
     END IF;


     -- Расчет из Мастера
     SELECT -- сумма к оплате ГРН - учитывается ТОЛЬКО скидка %
            SUM (zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPriceList.ValueData, 1)
               - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
               + COALESCE (MIFloat_SummChangePercent.ValueData, 0)
                ) AS AmountToPay_GRN

            -- сумма к оплате EUR - учитывается ТОЛЬКО скидка %
          , SUM (zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, 1)
               - COALESCE (MIFloat_TotalChangePercent_curr.ValueData, 0)
               + COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0)
                ) AS AmountToPay_EUR

            -- сумма доп.скидки - Списание при округлении - всегда ГРН
          , SUM (COALESCE (MIFloat_SummChangePercent.ValueData, 0)) AS SummChangePercent_GRN

            INTO vbAmountToPay_GRN, vbAmountToPay_EUR, /*vbAmountToPay_GRN_real, vbAmountToPay_EUR_real,*/ vbAmountDiscount_GRN

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
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
       AND (MovementItem.Id = inId OR inId = 0)
      ;

     -- Результат
     RETURN QUERY
        WITH -- 1.1. zc_MI_Child
             tmpRes_all AS (SELECT -- AmountGRN
                                   COALESCE (SUM (CASE WHEN MovementItem.ParentId IS NULL
                                                            -- Расчетная сумма в грн для обмен
                                                            THEN -1 * zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                                       WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN()
                                                            THEN COALESCE (MovementItem.Amount,0)
                                                       ELSE 0
                                                  END), 0) AS AmountGRN
                                   -- AmountUSD
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END), 0) AS AmountUSD
                                   -- AmountEUR
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END), 0) AS AmountEUR

                                   -- AmountCard
                                 , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END), 0) AS AmountCard

                                   -- CurrencyValue_USD
                                 , vbCurrencyValue_USD AS CurrencyValue_USD
                                 , vbParValue_USD      AS ParValue_USD
                                   -- CurrencyValue_EUR
                                 , vbCurrencyValue_EUR AS CurrencyValue_EUR
                                 , vbParValue_EUR      AS ParValue_EUR

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

                                  -- AmountUSD_GRN
                                , zfCalc_CurrencyFrom (tmpRes_all.AmountUSD, tmpRes_all.CurrencyValue_USD, tmpRes_all.ParValue_USD) AS AmountUSD_GRN
                                  -- AmountEUR_GRN
                                , zfCalc_CurrencyFrom (tmpRes_all.AmountEUR, tmpRes_all.CurrencyValue_EUR, tmpRes_all.ParValue_EUR) AS AmountEUR_GRN

                                  -- AmountGRN_EUR
                                , zfCalc_CurrencyTo (tmpRes_all.AmountGRN, tmpRes_all.CurrencyValue_EUR, tmpRes_all.ParValue_EUR) AS AmountGRN_EUR
                                  -- AmountUSD_EUR
                                , zfCalc_CurrencyTo (zfCalc_CurrencyFrom (tmpRes_all.AmountUSD, tmpRes_all.CurrencyValue_USD, tmpRes_all.ParValue_USD)
                                                   , tmpRes_all.CurrencyValue_EUR, tmpRes_all.ParValue_EUR) AS AmountUSD_EUR
                                  -- AmountCard_EUR
                                , zfCalc_CurrencyTo (tmpRes_all.AmountCard, tmpRes_all.CurrencyValue_EUR, tmpRes_all.ParValue_EUR) AS AmountCard_EUR

                                , tmpRes_all.CurrencyValue_USD
                                , tmpRes_all.ParValue_USD
                                , tmpRes_all.CurrencyValue_EUR
                                , tmpRes_all.ParValue_EUR
                           FROM tmpRes_all
                          )
              -- 1.3.
            , tmpMI AS (SELECT tmpRes.AmountGRN
                             , tmpRes.AmountUSD
                             , tmpRes.AmountEUR
                             , tmpRes.AmountCard

                             , tmpRes.AmountUSD_GRN
                             , tmpRes.AmountEUR_GRN

                             , tmpRes.AmountGRN_EUR
                             , tmpRes.AmountUSD_EUR
                             , tmpRes.AmountCard_EUR

                             , tmpRes.CurrencyValue_USD
                             , tmpRes.ParValue_USD
                             , tmpRes.CurrencyValue_EUR
                             , tmpRes.ParValue_EUR
                             , vbAmountToPay_GRN - (CASE WHEN tmpRes.AmountGRN > 0 THEN tmpRes.AmountGRN ELSE 0 END
                                                + tmpRes.AmountUSD_GRN
                                                + tmpRes.AmountEUR_GRN
                                                + tmpRes.AmountCard
                                                + vbAmountDiscount_GRN) AS AmountDiff_GRN
                        FROM tmpRes
                       )
      -- 1.4. Результат
      SELECT 0                   :: Integer AS Id
           , vbCurrencyValue_USD            AS CurrencyValue_USD
           , vbParValue_USD                 AS ParValue_USD
           , vbCurrencyValue_EUR            AS CurrencyValue_EUR
           , vbParValue_EUR                 AS ParValue_EUR

             -- из-за обмена может быть < 0
           , CASE WHEN tmpMI.AmountGRN > 0 THEN tmpMI.AmountGRN ELSE 0 END :: TFloat AS AmountGRN
           , tmpMI.AmountUSD     :: TFloat
           , tmpMI.AmountEUR     :: TFloat
           , tmpMI.AmountCard    :: TFloat

             -- сумма доп.скидки, грн
           , vbAmountDiscount_GRN :: TFloat AS AmountDiscount
             -- сумма доп.скидки, EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (vbAmountDiscount_GRN
                                                , vbCurrencyValue_EUR
                                                , vbParValue_EUR
                                                 ), 1) :: TFloat  AS AmountDiscount_curr

             -- сумма к оплате, грн - здесь округлили
           , zfCalc_SummPriceList (1, vbAmountToPay_GRN) :: TFloat AS AmountToPay
             -- сумма к оплате, EUR - здесь округлили
           , zfCalc_SummPriceList (1, vbAmountToPay_EUR) :: TFloat AS AmountToPay_curr
         --, vbAmountToPay_GRN_real    :: TFloat AS AmountToPay_GRN
         --, vbAmountToPay_EUR_real    :: TFloat AS AmountToPay_EUR

             -- сумма к оплате, грн - НЕ округлили, отсюда остаток
           , vbAmountToPay_GRN         :: TFloat AS AmountToPay_GRN
             -- сумма к оплате, EUR - НЕ округлили, отсюда остаток
           , vbAmountToPay_EUR         :: TFloat AS AmountToPay_EUR

             -- Остаток, грн
           , CASE WHEN tmpMI.AmountDiff_GRN > 0 AND vbAmountToPay_GRN = tmpMI.AmountDiff_GRN
                       THEN -- здесь округлили
                            zfCalc_SummPriceList (1, tmpMI.AmountDiff_GRN)
                  WHEN tmpMI.AmountDiff_GRN > 0
                       THEN -- НЕ округлили
                            tmpMI.AmountDiff_GRN
                  ELSE 0
             END :: TFloat  AS AmountRemains
             -- Остаток, EUR - НЕ округлили
           , CASE WHEN tmpMI.AmountDiff_GRN > 0 THEN zfCalc_SummIn (1, zfCalc_CurrencyTo (tmpMI.AmountDiff_GRN
                                                                                        , vbCurrencyValue_EUR
                                                                                        , vbParValue_EUR
                                                                                         ), 1)
                                                ELSE 0
             END :: TFloat  AS AmountRemains_curr

             -- Сдача, грн
           , CASE WHEN tmpMI.AmountDiff_GRN < 0 THEN -1 * tmpMI.AmountDiff_GRN ELSE 0 END :: TFloat  AS AmountDiff

           , TRUE AS isPayTotal

           , CASE WHEN tmpMI.AmountGRN      > 0 THEN TRUE ELSE FALSE END AS isGRN
           , CASE WHEN tmpMI.AmountUSD     <> 0 THEN TRUE ELSE FALSE END AS isUSD
           , CASE WHEN tmpMI.AmountEUR     <> 0 THEN TRUE ELSE FALSE END AS isEUR
           , CASE WHEN tmpMI.AmountCard    <> 0 THEN TRUE ELSE FALSE END AS isCard
           , CASE WHEN vbAmountDiscount_GRN <> 0 THEN TRUE ELSE FALSE END AS isDiscount

           , Object_CurrencyClient.Id               AS CurrencyId_Client
           , Object_CurrencyClient.ValueData        AS CurrencyName_Client

           , 1 :: Integer AS CurrencyNum_ToPay
           , 2 :: Integer AS CurrencyNum_ToPay_curr

       FROM tmpMI
            LEFT JOIN Object AS Object_CurrencyClient ON Object_CurrencyClient.Id = vbCurrencyId_Client
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 10.04.17         *
*/

-- тест
-- SELECT * FROM gpGet_MI_Sale_Child (inId:= 0, inMovementId := 6231, inSession:= zfCalc_UserAdmin());
