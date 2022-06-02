-- Function: gpGet_Movement_CashSend_exit()

DROP FUNCTION IF EXISTS gpGet_Movement_CashSend_exit (Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_CashSend_exit(
    IN inMovementId        Integer  , -- ключ Документа
    IN inCashId_from       Integer   , -- касса (расход) 
    IN inCashId_to         Integer   , -- касса (приход) 
    IN inCurrencyValue     TFloat    , -- курс
    IN inParValue          TFloat    , -- номинал
    IN inAmountOut         TFloat    , -- Сумма (расход)
    IN inAmountIn          TFloat    , -- Сумма (приход)
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (AmountIn TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_CashSend());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY 
       SELECT inAmountOut AS AmountIn
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.22         * 
*/

-- тест
-- SELECT * FROM gpGet_Movement_CashSend_exit(inMovementId := 608 , inCashId_from := 608 , inCashId_to := 0 , inCurrencyValue := 0, inParValue := 0, inAmountOut := 555, inAmountIn := 0,  inSession := '5');
