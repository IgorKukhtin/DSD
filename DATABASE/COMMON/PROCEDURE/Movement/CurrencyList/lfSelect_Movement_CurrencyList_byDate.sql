-- Function: lfSelect_Movement_CurrencyList_byDate()

DROP FUNCTION IF EXISTS lfSelect_Movement_CurrencyList_byDate (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lfSelect_Movement_CurrencyList_byDate(
    IN inOperDate          TDateTime , -- 
    IN inCurrencyFromId    Integer   , -- валюта в которой введен курc
    IN inCurrencyToId      Integer   , -- валюта для которой введен курс
    IN inPaidKindId        Integer     -- 
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime
             , CurrencyFromId Integer, CurrencyFromName TVarChar
             , CurrencyToId Integer, CurrencyToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
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
                                 , MILinkObject_Currency.ObjectId AS CurrencyToId
                                 , MILinkObject_PaidKind.ObjectId AS PaidKindId
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                   ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                                                  AND MILinkObject_PaidKind.ObjectId = inPaidKindId
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                   ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                                 INNER JOIN tmpCurrency ON tmpCurrency.CurrencyFromId = MovementItem.ObjectId
                                                       AND tmpCurrency.CurrencyToId = MILinkObject_Currency.ObjectId
                            WHERE Movement.DescId = zc_Movement_CurrencyList()
                              AND Movement.OperDate <= inOperDate
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )
       SELECT
             tmpMovement.MovementId
           , tmpMovement.OperDate
           , Object_CurrencyFrom.Id          AS CurrencyFromId
           , Object_CurrencyFrom.ValueData   AS CurrencyFromName
           , Object_CurrencyTo.Id            AS CurrencyToId
           , Object_CurrencyTo.ValueData     AS CurrencyToName
           , Object_PaidKind.Id              AS PaidKindId
           , Object_PaidKind.ValueData       AS PaidKindName

           , CASE WHEN tmpMovement.CurrencyFromId = inCurrencyFromId AND tmpMovement.CurrencyToId = inCurrencyToId
                       THEN tmpMovement.Amount
                  WHEN tmpMovement.CurrencyFromId = inCurrencyToId AND tmpMovement.CurrencyToId = inCurrencyFromId
                       THEN CASE WHEN MIFloat_ParValue.ValueData > 0 THEN MIFloat_ParValue.ValueData ELSE 1 END / tmpMovement.Amount
                          * CASE WHEN MIFloat_ParValue.ValueData > 0 THEN MIFloat_ParValue.ValueData ELSE 1 END
             END ::TFloat AS Amount

           , CASE WHEN MIFloat_ParValue.ValueData > 0
                       THEN MIFloat_ParValue.ValueData
                  ELSE 1
             END ::TFloat AS ParValue

       FROM (SELECT MAX (tmpMovement.OperDate) AS OperDate FROM tmpMovement) AS tmpMovement_find
            INNER JOIN tmpMovement ON tmpMovement.OperDate = tmpMovement_find.OperDate

            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                        ON MIFloat_ParValue.MovementItemId = tmpMovement.MovementItemId
                                       AND MIFloat_ParValue.DescId = zc_MIFloat_ParValue()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpMovement.PaidKindId
            LEFT JOIN Object AS Object_CurrencyFrom ON Object_CurrencyFrom.Id = tmpMovement.CurrencyFromId
            LEFT JOIN Object AS Object_CurrencyTo ON Object_CurrencyTo.Id = tmpMovement.CurrencyToId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.23         *
*/

-- тест
--