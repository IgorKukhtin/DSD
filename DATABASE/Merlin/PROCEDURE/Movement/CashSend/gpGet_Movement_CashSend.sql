-- Function: gpGet_Movement_CashSend()

DROP FUNCTION IF EXISTS gpGet_Movement_CashSend (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_CashSend(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_Value  Integer  ,
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime
             , CurrencyValue TFloat, ParValue TFloat
             , Amount TFloat
             , CashId_from Integer, CashName_from TVarChar  -- из какой расход
             , CashId_to Integer, CashName_to TVarChar      -- в какую приход
             , CommentMoveMoneyId Integer, CommentMoveMoneyName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_CashSend());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_CashSend_seq') AS TVarChar)  AS InvNumber
           , CAST (CURRENT_DATE AS TDateTime)                  AS OperDate
           , 0::TFloat                                         AS CurrencyValue
           , 0::TFloat                                         AS ParValue
           , 0::TFloat                                         AS Amount
           , 0                                                 AS CashId_from
           , CAST ('' as TVarChar)                             AS CashName_from
           , 0                                                 AS CashId_to
           , CAST ('' as TVarChar)                             AS CashName_to
           , 0                                                 AS CommentMoveMoneyId
           , ''::TVarChar                                      AS CommentMoveMoneyName
      ;
     ELSE
     
     RETURN QUERY 
       SELECT
             inMovementId AS Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_cashsend_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN CAST (CURRENT_DATE AS TDateTime) ELSE Movement.OperDate END ::TDateTime AS OperDate
           , MovementFloat_CurrencyValue.ValueData ::TFloat AS CurrencyValue
           , MovementFloat_ParValue.ValueData      ::TFloat AS ParValue
           , MovementItem.Amount                   ::TFloat AS Amount
           , CASE WHEN TRIM (Object_Cash_from.ValueData) <> '' THEN Object_Cash_from.Id ELSE 0 END :: Integer AS CashId_from
           , Object_Cash_from.ValueData                                                                       AS CashName_from
           , CASE WHEN TRIM (Object_Cash_to.ValueData) <> '' THEN Object_Cash_to.Id ELSE 0 END :: Integer AS CashId_to
           , Object_Cash_to.ValueData                                                                     AS CashName_to
           , CASE WHEN TRIM (Object_CommentMoveMoney.ValueData) <> '' THEN Object_CommentMoveMoney.Id ELSE 0 END :: Integer AS CommentMoveMoneyId
           , Object_CommentMoveMoney.ValueData                                                                              AS CommentMoveMoneyName
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
            --
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.isErased = FALSE
            LEFT JOIN Object AS Object_Cash_from ON Object_Cash_from.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Cash
                                             ON MILinkObject_Cash.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Cash.DescId = zc_MILinkObject_Cash()
            LEFT JOIN Object AS Object_Cash_to ON Object_Cash_to.Id = MILinkObject_Cash.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentMoveMoney
                                             ON MILinkObject_CommentMoveMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CommentMoveMoney.DescId         = zc_MILinkObject_CommentMoveMoney()
            LEFT JOIN Object AS Object_CommentMoveMoney ON Object_CommentMoveMoney.Id = MILinkObject_CommentMoveMoney.ObjectId

       WHERE Movement.Id = inMovementId_Value;

   END IF; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.01.22         * 
*/

-- тест
--select * from gpGet_Movement_CashSend(inMovementId := 608 , inMovementId_Value := 608 , inOperDate := ('31.01.2022')::TDateTime ,  inSession := '5');