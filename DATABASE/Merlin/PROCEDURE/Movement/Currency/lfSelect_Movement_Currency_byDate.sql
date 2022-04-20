-- Function: lfSelect_Movement_Currency_byDate()

DROP FUNCTION IF EXISTS lfSelect_Movement_Currency_byDate (TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lfSelect_Movement_Currency_byDate (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lfSelect_Movement_Currency_byDate(
    IN inOperDate          TDateTime , -- 
    IN inCurrencyFromId    Integer   , -- валюта в которой введен курc
    IN inCurrencyToId      Integer     -- валюта для которой введен курс
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime
             , CurrencyFromId Integer, CurrencyFromName TVarChar
             , CurrencyToId Integer, CurrencyToName TVarChar
             , Amount TFloat, ParValue TFloat
             )
AS
$BODY$
BEGIN

     RETURN QUERY 
       WITH tmpCurrency AS (SELECT inCurrencyFromId AS CurrencyFromId, inCurrencyToId AS CurrencyToId UNION ALL SELECT inCurrencyToId AS CurrencyFromId, inCurrencyFromId AS CurrencyToId)
          , tmpMovement AS (SELECT Movement.Id                    AS MovementId
                                 , Movement.OperDate              AS OperDate
                                 , MovementItem.Id                AS MovementItemId
                                 , MovementItem.ObjectId          AS CurrencyFromId
                                 , MovementItem.Amount            AS Amount
                                 , CASE WHEN MIFloat_ParValue.ValueData > 0 THEN MIFloat_ParValue.ValueData ELSE 1 END AS ParValue
                                 , MILinkObject_Currency.ObjectId AS CurrencyToId
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                   ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                                 INNER JOIN tmpCurrency ON tmpCurrency.CurrencyFromId = MovementItem.ObjectId
                                                       AND tmpCurrency.CurrencyToId   = MILinkObject_Currency.ObjectId
                                 LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                             ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ParValue.DescId = zc_MIFloat_ParValue()
                            WHERE Movement.DescId = zc_Movement_Currency()
                              AND Movement.OperDate <= inOperDate
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                            ORDER BY Movement.OperDate DESC, Movement.Id DESC
                            LIMIT 1
                           )
       -- Результат
       SELECT
             tmpMovement.MovementId
           , tmpMovement.OperDate
           , Object_CurrencyFrom.Id          AS CurrencyFromId
           , Object_CurrencyFrom.ValueData   AS CurrencyFromName
           , Object_CurrencyTo.Id            AS CurrencyToId
           , Object_CurrencyTo.ValueData     AS CurrencyToName

           , CASE WHEN tmpMovement.CurrencyFromId = inCurrencyFromId AND tmpMovement.CurrencyToId = inCurrencyToId
                       THEN tmpMovement.Amount
                  WHEN tmpMovement.CurrencyFromId = inCurrencyToId AND tmpMovement.CurrencyToId = inCurrencyFromId
                       THEN tmpMovement.ParValue / tmpMovement.Amount
                          * tmpMovement.ParValue
             END :: TFloat AS Amount

           , CASE WHEN tmpMovement.CurrencyFromId = inCurrencyFromId AND tmpMovement.CurrencyToId = inCurrencyToId
                       THEN tmpMovement.ParValue
                  ELSE tmpMovement.ParValue
             END :: TFloat AS ParValue

       FROM tmpMovement
            LEFT JOIN Object AS Object_CurrencyFrom ON Object_CurrencyFrom.Id = inCurrencyFromId -- tmpMovement.CurrencyFromId
            LEFT JOIN Object AS Object_CurrencyTo   ON Object_CurrencyTo.Id   = inCurrencyToId   -- tmpMovement.CurrencyToId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.04.17         * бутики
 13.11.14                                        *
*/

-- тест
-- SELECT * FROM lfSelect_Movement_Currency_byDate (inOperDate:= CURRENT_DATE, inCurrencyFromId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Currency() AND ObjectCode = 980), inCurrencyToId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Currency() AND ObjectCode = 840));
-- SELECT * FROM lfSelect_Movement_Currency_byDate (inOperDate:= CURRENT_DATE, inCurrencyFromId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Currency() AND ObjectCode = 980), inCurrencyToId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Currency() AND ObjectCode = 643));
