-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_GoodsAccount_Child (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_GoodsAccount_Child(
    IN inId             Integer  , -- ключ
    IN inMovementId     Integer  , --
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , CurrencyValue_USD TFloat, ParValue_USD TFloat
             , CurrencyValue_EUR TFloat, ParValue_EUR TFloat
             , AmountGRN      TFloat
             , AmountUSD      TFloat
             , AmountEUR      TFloat
             , AmountCard     TFloat
             , AmountDiscount TFloat
             , AmountToPay    TFloat
             , AmountRemains  TFloat
             , AmountDiff     TFloat
             , isPayTotal     Boolean
             , isGRN          Boolean
             , isUSD          Boolean
             , isEUR          Boolean
             , isCard         Boolean
             , isDiscount     Boolean
              )
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbOperDate          TDateTime;
   DECLARE vbSummToPay         TFloat;
   DECLARE vbSummChangePercent TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- данные из документа
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);


     -- самое Важное - Сложный расчет ДОЛГА - с учетом ВОЗВРАТА
     SELECT SUM (-- Сумма по Прайсу
                 zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)
                 -- МИНУС: Итого сумма Скидки (в ГРН) - для ВСЕХ документов - суммируется 1)по %скидки + 2)дополнительная + 3)дополнительная в оплатах
               - (COALESCE (MIFloat_SummChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0))
                 -- МИНУС: Итого сумма оплаты (в ГРН) - для ВСЕХ документов - суммируется 1) + 2)
               - (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0))
                 -- МИНУС TotalReturn - Итого сумма возврата со скидкой - все док-ты
               - COALESCE (MIFloat_TotalReturn.ValueData, 0)
                 -- !!!ПЛЮС!!! TotalReturn - Итого возврат оплаты - все док-ты
               + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
                ) AS SummToPay

            -- сумма доп.скидки - Списание при округлении - в текущем документе
          , COALESCE (SUM (COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0)), 0) AS SummChangePercent

            INTO vbSummToPay, vbSummChangePercent

     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_curr
                                      ON MIFloat_SummChangePercent_curr.MovementItemId = MovementItem.Id
                                     AND MIFloat_SummChangePercent_curr.DescId         = zc_MIFloat_SummChangePercent()

          -- получаем сразу партию Продажи
          LEFT JOIN MovementItemLinkObject AS MILO_PartionMI_level1
                                           ON MILO_PartionMI_level1.MovementItemId = MovementItem.Id
                                          AND MILO_PartionMI_level1.DescId = zc_MILinkObject_PartionMI()
          LEFT JOIN Object AS Object_PartionMI_level1 ON Object_PartionMI_level1.Id = MILO_PartionMI_level1.ObjectId
          -- получаем партию Продажи если в предыдущем была партия Возврата
          LEFT JOIN MovementItemLinkObject AS MILO_PartionMI_level2
                                           ON MILO_PartionMI_level2.MovementItemId = Object_PartionMI_level1.ObjectCode
                                          AND MILO_PartionMI_level2.DescId         = zc_MILinkObject_PartionMI()
          LEFT JOIN Object AS Object_PartionMI_level2 ON Object_PartionMI_level2.Id = MILO_PartionMI_level2.ObjectId

          LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = COALESCE (Object_PartionMI_level2.ObjectCode, Object_PartionMI_level1.ObjectCode)

          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                      ON MIFloat_OperPriceList.MovementItemId = MI_Sale.Id
                                     AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                      ON MIFloat_SummChangePercent.MovementItemId = MI_Sale.Id
                                     AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                      ON MIFloat_TotalChangePercentPay.MovementItemId = MI_Sale.Id
                                     AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                      ON MIFloat_TotalPay.MovementItemId = MI_Sale.Id
                                     AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
          LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                      ON MIFloat_TotalPayOth.MovementItemId = MI_Sale.Id
                                     AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

          LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                      ON MIFloat_TotalReturn.MovementItemId = MI_Sale.Id
                                     AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
          LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                      ON MIFloat_TotalPayReturn.MovementItemId = MI_Sale.Id
                                     AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased   = FALSE
        AND (MovementItem.Id = inId OR inId = 0);


     -- Результат
     RETURN QUERY
        WITH tmpRes AS
                     (SELECT COALESCE (SUM (CASE WHEN MovementItem.ParentId IS NULL
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

                           , COALESCE (SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END),0) AS AmountCard
                           , COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN COALESCE (MIFloat_CurrencyValue.ValueData, 0) ELSE 0 END), 0) AS CurrencyValue_USD
                           , COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN COALESCE (MIFloat_ParValue.ValueData, 1)      ELSE 0 END), 0) AS ParValue_USD
                           , COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE (MIFloat_CurrencyValue.ValueData, 0) ELSE 0 END), 0) AS CurrencyValue_EUR
                           , COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE (MIFloat_ParValue.ValueData, 1)      ELSE 0 END), 0) AS ParValue_EUR
                      FROM MovementItem
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
                        AND (MovementItem.ParentId = inId OR inId = 0)
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

           , vbSummChangePercent :: TFloat  AS AmountDiscount -- сумма доп.скидки, грн
           , vbSummToPay         :: TFloat  AS AmountToPay    -- сумма к оплате, грн

           , CASE WHEN tmpMI.AmountDiff > 0 THEN      tmpMI.AmountDiff ELSE 0 END :: TFloat  AS AmountRemains -- Остаток, грн
           , CASE WHEN tmpMI.AmountDiff < 0 THEN -1 * tmpMI.AmountDiff ELSE 0 END :: TFloat  AS AmountDiff    -- Сдача, грн

           , TRUE AS isPayTotal

           , CASE WHEN tmpMI.AmountGRN      > 0 THEN TRUE ELSE FALSE END AS isGRN
           , CASE WHEN tmpMI.AmountUSD     <> 0 THEN TRUE ELSE FALSE END AS isUSD
           , CASE WHEN tmpMI.AmountEUR     <> 0 THEN TRUE ELSE FALSE END AS isEUR
           , CASE WHEN tmpMI.AmountCard    <> 0 THEN TRUE ELSE FALSE END AS isCard
           , CASE WHEN vbSummChangePercent <> 0 THEN TRUE ELSE FALSE END AS isDiscount

       FROM tmpMI
            CROSS JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_USD()) AS tmp_USD
            CROSS JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_EUR()) AS tmp_EUR
            ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 18.05.17         *
*/

-- тест
-- SELECT * FROM gpGet_MI_GoodsAccount_Child (inId := 92 , inMovementId := 28 ,  inSession := '2');
