-- Function: lfSelect_Movement_CurrencyAll_byDate()

DROP FUNCTION IF EXISTS lfSelect_Movement_CurrencyAll_byDate (TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lfSelect_Movement_CurrencyAll_byDate (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lfSelect_Movement_CurrencyAll_byDate(
    IN inOperDate          TDateTime , -- 
    IN inCurrencyFromId    Integer   , -- âàëþòà â êîòîðîé ââåäåí êóðc
    IN inCurrencyToId      Integer     -- âàëþòà äëÿ êîòîðîé ââåäåí êóðñ
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
       WITH tmpObject AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_Currency())
          , tmpCurrency AS (SELECT Object_From.Id AS CurrencyFromId, Object_To.Id   AS CurrencyToId FROM tmpObject As Object_From INNER JOIN tmpObject AS Object_to ON Object_to.Id = inCurrencyToId OR COALESCE (inCurrencyToId, 0) = 0 WHERE Object_From.Id = inCurrencyFromId OR COALESCE (inCurrencyFromId, 0) = 0
                  UNION ALL SELECT Object_To.Id   AS CurrencyFromId, Object_From.Id AS CurrencyToId FROM tmpObject As Object_From INNER JOIN tmpObject AS Object_to ON Object_to.Id = inCurrencyToId OR COALESCE (inCurrencyToId, 0) = 0 WHERE Object_From.Id = inCurrencyFromId OR COALESCE (inCurrencyFromId, 0) = 0
                           )
          , tmpMovement AS (SELECT Movement.Id                    AS MovementId
                                 , Movement.OperDate              AS OperDate
                                 , MovementItem.Id                AS MovementItemId
                                 , MovementItem.ObjectId          AS CurrencyFromId
                                 , MovementItem.Amount            AS Amount
                                 , CASE WHEN MIFloat_ParValue.ValueData > 0 THEN MIFloat_ParValue.ValueData ELSE 1 END AS ParValue
                                 , MILinkObject_Currency.ObjectId AS CurrencyToId
                                 , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_Currency.ObjectId ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
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
                           )
       -- Ðåçóëüòàò
       SELECT
             tmpMovement.MovementId
           , tmpMovement.OperDate
           , Object_CurrencyFrom.Id          AS CurrencyFromId
           , Object_CurrencyFrom.ValueData   AS CurrencyFromName
           , Object_CurrencyTo.Id            AS CurrencyToId
           , Object_CurrencyTo.ValueData     AS CurrencyToName

           , tmpMovement.Amount    :: TFloat AS Amount
           , tmpMovement.ParValue  :: TFloat AS ParValue

       FROM tmpMovement
            LEFT JOIN Object AS Object_CurrencyFrom ON Object_CurrencyFrom.Id = tmpMovement.CurrencyFromId
            LEFT JOIN Object AS Object_CurrencyTo   ON Object_CurrencyTo.Id   = tmpMovement.CurrencyToId
       WHERE tmpMovement.Ord = 1
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 14.08.17                                        *
*/

-- òåñò
-- SELECT * FROM lfSelect_Movement_CurrencyAll_byDate (inOperDate:= CURRENT_DATE, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_Basis());
-- SELECT * FROM lfSelect_Movement_CurrencyAll_byDate (inOperDate:= CURRENT_DATE, inCurrencyFromId:= 9, inCurrencyToId:= zc_Currency_Basis());
