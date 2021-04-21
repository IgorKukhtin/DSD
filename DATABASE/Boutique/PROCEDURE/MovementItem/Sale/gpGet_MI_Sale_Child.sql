-- Function: gpGet_Movement_Income()

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

             , AmountToPay         TFloat
             , AmountToPay_curr    TFloat

             , AmountRemains       TFloat
             , AmountRemains_curr  TFloat

             , AmountDiff          TFloat

             , isPayTotal          Boolean
             , isGRN               Boolean
             , isUSD               Boolean
             , isEUR               Boolean
             , isCard              Boolean
             , isDiscount          Boolean

             , CurrencyId_Client Integer, CurrencyName_Client TVarChar
              )
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbCurrencyId_Client Integer;
   DECLARE vbOperDate          TDateTime;
   DECLARE vbSummToPay         TFloat;
   DECLARE vbSummChangePercent TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- данные из документа
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- данные из документа
     vbCurrencyId_Client:= COALESCE((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_CurrencyClient())
                                  , CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE THEN zc_Currency_GRN() ELSE zc_Currency_EUR() END
                                   );


     -- Расчет из Мастера
     SELECT -- сумма к оплате - учитывается ТОЛЬКО скидка %
            COALESCE (SUM (zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                         - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                         + COALESCE (MIFloat_SummChangePercent.ValueData, 0)
                          ), 0)
            -- сумма доп.скидки - Списание при округлении
          , COALESCE (SUM (COALESCE (MIFloat_SummChangePercent.ValueData, 0)), 0)
            INTO vbSummToPay, vbSummChangePercent
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                      ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                     AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                      ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                      ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
       AND (MovementItem.Id = inId OR inId = 0)
      ;


     -- Результат
     RETURN QUERY
        WITH tmpRes AS (SELECT COALESCE (SUM (CASE WHEN MovementItem.ParentId IS NULL
                                                        -- Расчетная сумма в грн для обмен
                                                        THEN -1 * zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                                   WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN()
                                                        THEN COALESCE (MovementItem.Amount,0)
                                                   ELSE 0
                                              END), 0) AS AmountGRN
                             , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END), 0) AS AmountUSD
                             , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END), 0) AS AmountEUR
                             , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData) ELSE 0 END), 0) AS AmountUSD_GRN
                             , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData) ELSE 0 END), 0) AS AmountEUR_GRN
                             , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END), 0) AS AmountCard
                             , COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN COALESCE (MIFloat_CurrencyValue.ValueData, 0) ELSE 0 END), 0) AS CurrencyValue_USD
                             , COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN COALESCE (MIFloat_ParValue.ValueData, 1)      ELSE 0 END), 0) AS ParValue_USD
                             , COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE (MIFloat_CurrencyValue.ValueData, 0) ELSE 0 END), 0) AS CurrencyValue_EUR
                             , COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE (MIFloat_ParValue.ValueData, 1)      ELSE 0 END), 0) AS ParValue_EUR
                        FROM MovementItem
                              LEFT JOIN MovementItem AS MI_Master ON MI_Master.Id = MovementItem.ParentId
                              LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                               ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
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
            , tmpMI AS (SELECT tmpRes.AmountGRN
                             , tmpRes.AmountUSD
                             , tmpRes.AmountEUR
                             , tmpRes.AmountUSD_GRN
                             , tmpRes.AmountEUR_GRN
                             , tmpRes.AmountCard
                             , tmpRes.CurrencyValue_USD
                             , tmpRes.ParValue_USD
                             , tmpRes.CurrencyValue_EUR
                             , tmpRes.ParValue_EUR
                             , vbSummToPay - (CASE WHEN tmpRes.AmountGRN > 0 THEN tmpRes.AmountGRN ELSE 0 END
                                            + tmpRes.AmountUSD_GRN
                                            + tmpRes.AmountEUR_GRN
                                            + tmpRes.AmountCard
                                            + vbSummChangePercent) AS AmountDiff
                        FROM tmpRes
                       )
      -- Результат
      SELECT 0                   :: Integer AS Id
           , CASE WHEN tmpMI.CurrencyValue_USD > 0 THEN tmpMI.CurrencyValue_USD ELSE tmp_USD.Amount   END :: TFloat AS CurrencyValue_USD
           , CASE WHEN tmpMI.ParValue_USD      > 0 THEN tmpMI.ParValue_USD      ELSE tmp_USD.ParValue END :: TFloat AS ParValue_USD
           , CASE WHEN tmpMI.CurrencyValue_EUR > 0 THEN tmpMI.CurrencyValue_EUR ELSE tmp_EUR.Amount   END :: TFloat AS CurrencyValue_EUR
           , CASE WHEN tmpMI.ParValue_EUR      > 0 THEN tmpMI.ParValue_EUR      ELSE tmp_EUR.ParValue END :: TFloat AS ParValue_EUR

             -- из-за обмена может быть < 0
           , CASE WHEN tmpMI.AmountGRN > 0 THEN tmpMI.AmountGRN ELSE 0 END :: TFloat AS AmountGRN
           , tmpMI.AmountUSD     :: TFloat
           , tmpMI.AmountEUR     :: TFloat
           , tmpMI.AmountCard    :: TFloat

             -- сумма доп.скидки, грн + EUR
           , vbSummChangePercent :: TFloat  AS AmountDiscount
           , zfCalc_SummPriceList (1, 
             zfCalc_CurrencySumm (vbSummChangePercent, zc_Currency_Basis(), zc_Currency_EUR()
                                , CASE WHEN tmpMI.CurrencyValue_EUR > 0 THEN tmpMI.CurrencyValue_EUR ELSE tmp_EUR.Amount   END
                                , CASE WHEN tmpMI.ParValue_EUR      > 0 THEN tmpMI.ParValue_EUR      ELSE tmp_EUR.ParValue END
                                  )) :: TFloat  AS AmountDiscount_curr

             -- сумма к оплате, грн + EUR
           , vbSummToPay         :: TFloat  AS AmountToPay
           , zfCalc_SummPriceList (1, 
             zfCalc_CurrencySumm (vbSummToPay, zc_Currency_Basis(), zc_Currency_EUR()
                                , CASE WHEN tmpMI.CurrencyValue_EUR > 0 THEN tmpMI.CurrencyValue_EUR ELSE tmp_EUR.Amount   END
                                , CASE WHEN tmpMI.ParValue_EUR      > 0 THEN tmpMI.ParValue_EUR      ELSE tmp_EUR.ParValue END
                                 )) :: TFloat  AS AmountToPay_curr

             -- Остаток, грн + EUR
           , CASE WHEN tmpMI.AmountDiff > 0 THEN tmpMI.AmountDiff ELSE 0 END :: TFloat  AS AmountRemains
           , CASE WHEN tmpMI.AmountDiff > 0 THEN zfCalc_SummPriceList (1, 
                                                 zfCalc_CurrencySumm (tmpMI.AmountDiff, zc_Currency_Basis(), zc_Currency_EUR()
                                                                    , CASE WHEN tmpMI.CurrencyValue_EUR > 0 THEN tmpMI.CurrencyValue_EUR ELSE tmp_EUR.Amount   END
                                                                    , CASE WHEN tmpMI.ParValue_EUR      > 0 THEN tmpMI.ParValue_EUR      ELSE tmp_EUR.ParValue END
                                                                     ))
                                            ELSE 0
             END :: TFloat  AS AmountRemains_curr
  
             -- Сдача, грн
           , CASE WHEN tmpMI.AmountDiff < 0 THEN -1 * tmpMI.AmountDiff ELSE 0 END :: TFloat  AS AmountDiff

           , TRUE AS isPayTotal

           , CASE WHEN tmpMI.AmountGRN      > 0 THEN TRUE ELSE FALSE END AS isGRN
           , CASE WHEN tmpMI.AmountUSD     <> 0 THEN TRUE ELSE FALSE END AS isUSD
           , CASE WHEN tmpMI.AmountEUR     <> 0 THEN TRUE ELSE FALSE END AS isEUR
           , CASE WHEN tmpMI.AmountCard    <> 0 THEN TRUE ELSE FALSE END AS isCard
           , CASE WHEN vbSummChangePercent <> 0 THEN TRUE ELSE FALSE END AS isDiscount

           , Object_CurrencyClient.Id               AS CurrencyId_Client
           , Object_CurrencyClient.ValueData        AS CurrencyName_Client

       FROM tmpMI
            CROSS JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_USD()) AS tmp_USD
            CROSS JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_EUR()) AS tmp_EUR
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
