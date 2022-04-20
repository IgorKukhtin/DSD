-- Function: gpGet_Movement_Currency()

DROP FUNCTION IF EXISTS gpGet_Movement_Currency (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Currency(
    IN inMovementId        Integer   , -- ключ Документа
    IN inMovementId_Value  Integer   ,
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Amount TFloat, ParValue TFloat
             , Comment TVarChar
             , CurrencyFromId Integer, CurrencyFromName TVarChar
             , CurrencyToId Integer, CurrencyToName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Currency());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           --, CAST (NEXTVAL ('Movement_currency_seq') AS TVarChar) AS InvNumber     
           , CAST (lfGet_InvNumber (0, zc_Movement_Currency()) AS TVarChar) AS InvNumber
           , inOperDate AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName
           , 0::TFloat                        AS Amount
           , 1::TFloat                        AS ParValue
           , ''::TVarChar                     AS Comment
           , 0                                AS CurrencyFromId
           , CAST ('' as TVarChar)            AS CurrencyFromName
           , 0                                AS CurrencyToId
           , CAST ('' as TVarChar)            AS CurrencyToName
       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status;
  
     ELSE

     RETURN QUERY 
       SELECT
             inMovementId AS Id
           , CASE WHEN inMovementId = 0 THEN CAST (lfGet_InvNumber (0, zc_Movement_Currency()) AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
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

       FROM Movement
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

       WHERE Movement.Id =  inMovementId_Value;

   END IF;  

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.04.22         * Merlin
 27.04.17         * бутики
*/

-- тест
-- SELECT * FROM gpGet_Movement_Currency (inMovementId:= 1, inMovementId_Value:= 0, inOperDate:= CURRENT_DATE,  inSession:= zfCalc_UserAdmin());
