-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_ReturnIn_Child_Total (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_ReturnIn_Child_Total (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_ReturnIn_Child_Total(
    IN inId                Integer  , -- ключ  парамеметр что б понимать какой режим - общая оплата =0
    IN inMovementId        Integer  , --
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Amount        TFloat
             , AmountRemains TFloat
             , AmountChange TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSumm TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- сумма к оплате
     SELECT CAST ((COALESCE(MovementItem.Amount,0) *  COALESCE(MIFloat_OperPriceList.ValueData,0)
                 - COALESCE(MIFloat_TotalChangePercent.ValueData,0)) AS NUMERIC (16, 2))
            INTO vbSumm
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                      ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                     AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                      ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
     WHERE (MovementItem.Id = inId OR inId = 0)                           -- оплата строки или итого
       AND MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE;

         -- Результат
         RETURN QUERY
          SELECT ( COALESCE (inAmountGRN,0)
               +  (COALESCE (inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
               +  (COALESCE (inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
               +   COALESCE (inAmountCard,0)   )             ::TFloat AS Amount

               , CASE WHEN vbSumm - (  COALESCE(inAmountGRN,0)
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                    +  COALESCE(inAmountCard,0) ) > 0
                      THEN vbSumm - (  COALESCE(inAmountGRN,0)
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                    +  COALESCE(inAmountCard,0) )
                      ELSE 0
                 END                                            ::TFloat AS AmountRemains
               , CASE WHEN vbSumm - (  COALESCE(inAmountGRN,0)
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                    +  COALESCE(inAmountCard,0) ) < 0
                      THEN (vbSumm - ( COALESCE(inAmountGRN,0)
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1))
                                    +  COALESCE(inAmountCard,0) )) * (-1)
                      ELSE 0
                 END                                            ::TFloat AS AmountChange
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
-- select * from gpGet_MI_ReturnIn_Child_Total(inId := 92 , inMovementId := 28 ,  inSession := '2');