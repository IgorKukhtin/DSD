-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_Total(
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmountToPay       TFloat   , --
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (AmountRemains TFloat -- Остаток, грн
             , AmountDiff    TFloat -- Сдача, грн
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       WITH tmp AS (SELECT inAmountToPay - (COALESCE (inAmountGRN, 0)
                                          + COALESCE (inAmountUSD, 0) * COALESCE (inCurrencyValueUSD, 0)
                                          + COALESCE (inAmountEUR, 0) * COALESCE (inCurrencyValueEUR, 0)
                                          + COALESCE (inAmountCard, 0)
                                          + COALESCE (inAmountDiscount, 0)) AS AmountDiff
                   )
       SELECT -- Остаток, грн
              CASE WHEN tmp.AmountDiff > 0 THEN      tmp.AmountDiff ELSE 0 END :: TFloat AS AmountRemains
              -- Сдача, грн
            , CASE WHEN tmp.AmountDiff < 0 THEN -1 * tmp.AmountDiff ELSE 0 END :: TFloat AS AmountDiff
       FROM tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 22.05.17         *
*/

-- тест
-- SELECT * FROM gpGet_MI_Sale_Child_Total (inId:= 92, inMovementId:= 28, inSession:= zfCalc_UserAdmin());
