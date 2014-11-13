-- Function: lfSelect_Movement_Currency_byDate()

DROP FUNCTION IF EXISTS lfSelect_Movement_Currency_byDate (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lfSelect_Movement_Currency_byDate(
    IN inOperDate          TDateTime , -- 
    IN inCurrencyFromId    Integer   , -- валюта в которой введен курc
    IN inCurrencyToId      Integer   , -- валюта для которой введен курс
    IN inPaidKindId        Integer     -- 
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime
             , Amount TFloat, ParValue TFloat
             , Comment TVarChar
             , CurrencyFromId Integer, CurrencyFromName TVarChar
             , CurrencyToId Integer, CurrencyToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             )
AS
$BODY$
BEGIN

     RETURN QUERY 
       WITH tmpCurrency AS (SELECT inCurrencyFromId AS CurrencyFromId, inCurrencyToId AS CurrencyToId UNION ALL inCurrencyToId AS CurrencyFromId, inCurrencyFromId AS CurrencyToId)
          , tmpMovement AS (SELECT Movement.*
                                 , MovementItem.ObjectId          AS CurrencyFromId
                                 , MILinkObject_Currency.ObjectId AS CurrencyToId
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                   ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_PaidKind.DescId = zc_MILinkObject_Currency()
                                 INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                   ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                                 INNER JOIN tmpCurrency
                             ) AS tmpCurrency ON tmpCurrency.CurrencyFromId = 
    IN     Integer   , -- валюта в которой введен курc
    IN inCurrencyToId      Integer   , -- валюта для которой введен курс
             WHERE Movement.DescId = zc_Movement_Currency()
               AND Movement.OperDate <= inOperDate
               AND Movement.StatusId = zc_Enum_Status_Complete()
            ) AS 

       SELECT
             inMovementId as Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('Movement_currency_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN inOperDate ELSE Movement.OperDate END AS OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
                     
           , MovementItem.Amount AS Amount

           , MIFloat_ParValue.ValueData   AS ParValue
           , MIString_Comment.ValueData   AS Comment

           , Object_CurrencyFrom.Id           AS CurrencyFromId
           , Object_CurrencyFrom.ValueData    AS CurrencyFromName


           , Object_CurrencyTo.Id         AS CurrencyToId
           , Object_CurrencyTo.ValueData  AS CurrencyToName

           , Object_PaidKind.Id                 AS PaidKindId
           , Object_PaidKind.ValueData          AS PaidKindName

       FROM (SELECT MAX (Movement.OperDate)
             FROM Movement
                  INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                    ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_PaidKind.DescId = zc_MILinkObject_Currency()
                                                    AND MILinkObject_PaidKind.ObjectId = inCurrencyPartnerId
                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.ObjectId = inCurrencyDocumentId
                  INNER JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                              ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                             AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
                                             AND MILinkObject_CurrencyTo.ObjectId = inCurrencyPartnerId
                  INNER JOIN (SELECT inCurrencyFromId AS CurrencyFromId, inCurrencyToId AS CurrencyToId UNION ALL inCurrencyToId AS CurrencyFromId, inCurrencyFromId AS CurrencyToId
                             ) AS tmpCurrency ON tmpCurrency.CurrencyFromId = 
    IN     Integer   , -- валюта в которой введен курc
    IN inCurrencyToId      Integer   , -- валюта для которой введен курс
             WHERE Movement.DescId = zc_Movement_Currency()
               AND Movement.OperDate <= inOperDate
               AND Movement.StatusId = zc_Enum_Status_Complete()
            ) AS 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END
            
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object AS Object_CurrencyFrom ON Object_CurrencyFrom.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_ParValue.DescId = zc_MIFloat_ParValue()
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                             ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
            LEFT JOIN Object AS Object_CurrencyTo ON Object_CurrencyTo.Id = MILinkObject_CurrencyTo.ObjectId
        
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                         ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

       WHERE Movement.Id =  inMovementId_Value;

   END IF;  

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_Movement_Currency_byDate (Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.14                                        * add PaidKind...
 10.11.14                                        * add ParValue
 28.07.14         *
*/

-- тест
-- SELECT * FROM lfSelect_Movement_Currency_byDate (inMovementId:= 1, inMovementId_Value:= 0, inOperDate:= CURRENT_DATE,  inSession:= zfCalc_UserAdmin());
