-- Function: gpSelect_Movement_CashSend()

DROP FUNCTION IF EXISTS gpSelect_Movement_CashSend (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CashSend(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean   , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , AmountOut TFloat, AmountIn TFloat
             , CashId_from Integer, CashCode_from Integer, CashName_from TVarChar  -- из какой расход
             , CashId_to Integer, CashCode_to Integer, CashName_to TVarChar        -- в какую приход
             , CommentMoveMoneyId Integer, CommentMoveMoneyCode Integer, CommentMoveMoneyName TVarChar
             , CurrencyName_from TVarChar, CurrencyName_to TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
               )

AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUser_isAll Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_CashSend());
     vbUserId:= lpGetUserBySession (inSession);

     --
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                  AND Movement.DescId = zc_Movement_CashSend()
                                                  AND Movement.StatusId = tmpStatus.StatusId
                          )

       SELECT
             Movement.Id                 AS Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate                   AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , MovementFloat_CurrencyValue.ValueData ::TFloat AS CurrencyValue
           , MovementFloat_ParValue.ValueData      ::TFloat AS ParValue
           , MovementItem.Amount                   ::TFloat AS AmountOut
           , MovementItemFloat_Amount.ValueData    ::TFloat AS AmountIn
           , Object_Cash_from.Id                AS CashId_from
           , Object_Cash_from.ObjectCode        AS CashCode_from
           , Object_Cash_from.ValueData         AS CashName_from
           , Object_Cash_to.Id                  AS CashId_to
           , Object_Cash_to.ObjectCode          AS CashCode_to
           , Object_Cash_to.ValueData           AS CashName_to
           , Object_CommentMoveMoney.Id         AS CommentMoveMoneyId
           , Object_CommentMoveMoney.ObjectCode AS CommentMoveMoneyCode
           , Object_CommentMoveMoney.ValueData  AS CommentMoveMoneyName

           , Object_Currency_from.ValueData     AS CurrencyName_from
           , Object_Currency_to.ValueData       AS CurrencyName_to

           , Object_Insert.ValueData            AS InsertName
           , MovementDate_Insert.ValueData      AS InsertDate
           , Object_Update.ValueData            AS UpdateName
           , MovementDate_Update.ValueData      AS UpdateDate
       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

            -- Сумма (расход)
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.isErased = FALSE

            -- Сумма (приход)
            LEFT JOIN MovementItemFloat AS MovementItemFloat_Amount
                                        ON MovementItemFloat_Amount.MovementItemId = MovementItem.Id
                                       AND MovementItemFloat_Amount.DescId         = zc_MIFloat_Amount()

            LEFT JOIN Object AS Object_Cash_from ON Object_Cash_from.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Cash
                                             ON MILinkObject_Cash.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Cash.DescId = zc_MILinkObject_Cash()
            LEFT JOIN Object AS Object_Cash_to ON Object_Cash_to.Id = MILinkObject_Cash.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentMoveMoney
                                             ON MILinkObject_CommentMoveMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CommentMoveMoney.DescId         = zc_MILinkObject_CommentMoveMoney()
            LEFT JOIN Object AS Object_CommentMoveMoney ON Object_CommentMoveMoney.Id = MILinkObject_CommentMoveMoney.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Currency_from
                                 ON ObjectLink_Currency_from.ObjectId = Object_Cash_from.Id
                                AND ObjectLink_Currency_from.DescId = zc_ObjectLink_Cash_Currency()
            LEFT JOIN Object AS Object_Currency_from ON Object_Currency_from.Id = ObjectLink_Currency_from.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Currency_to
                                 ON ObjectLink_Currency_to.ObjectId = Object_Cash_to.Id
                                AND ObjectLink_Currency_to.DescId = zc_ObjectLink_Cash_Currency()
            LEFT JOIN Object AS Object_Currency_to ON Object_Currency_to.Id = ObjectLink_Currency_to.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll_from
                                    ON ObjectBoolean_UserAll_from.ObjectId = Object_Cash_from.Id
                                   AND ObjectBoolean_UserAll_from.DescId = zc_ObjectBoolean_Cash_UserAll()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll_to
                                    ON ObjectBoolean_UserAll_to.ObjectId = Object_Cash_to.Id
                                   AND ObjectBoolean_UserAll_to.DescId = zc_ObjectBoolean_Cash_UserAll()

        WHERE vbUser_isAll = TRUE
           OR (ObjectBoolean_UserAll_from.ValueData = TRUE AND ObjectBoolean_UserAll_to.ValueData = TRUE)
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_CashSend(inStartDate := ('01.01.2022')::TDateTime , inEndDate := ('01.01.2022')::TDateTime , inIsErased := 'False',  inSession := '5');
