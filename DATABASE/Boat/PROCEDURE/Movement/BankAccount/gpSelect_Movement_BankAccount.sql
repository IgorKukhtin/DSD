-- Function: gpSelect_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_BankAccount(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inIsErased                 Boolean ,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , Comment TVarChar
             , BankAccountId Integer, BankAccountName TVarChar, BankName TVarChar
             , MoneyPlaceCode Integer, MoneyPlaceName TVarChar, ItemName TVarChar
             , InvNumber_Invoice_Full TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , MovementString_InvNumberPartner.ValueData :: TVarChar AS InvNumberPartner
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           , CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount      ELSE 0 END ::TFloat AS AmountIn
           , CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END ::TFloat AS AmountOut

           , MIString_Comment.ValueData        AS Comment
           , MovementItem.ObjectId             AS BankAccountId
           , Object_BankAccount.ValueData      AS BankAccountName
           , Object_Bank.ValueData             AS BankName
           , Object_MoneyPlace.ObjectCode      AS MoneyPlaceCode
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName
           --, (Object_MoneyPlace.ValueData || COALESCE (' * '|| Object_Bank.ValueData, '')) :: TVarChar AS MoneyPlaceName
           , ObjectDesc.ItemName

           , ('№ ' || Movement_Invoice.InvNumber || ' от ' || Movement_Invoice.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Invoice_Full           
             
       FROM (SELECT Movement.*
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  
                               AND Movement.DescId = zc_Movement_BankAccount() 
                               AND Movement.StatusId = tmpStatus.StatusId
            ) AS tmpMovement
            LEFT JOIN Movement ON Movement.id = tmpMovement.Id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement.StatusId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                           ON MovementLinkMovement_Invoice.MovementId = Movement.Id
                                          AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MovementLinkMovement_Invoice.MovementId

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
            --
       ;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_BankAccount (inStartDate:= '30.01.2013', inEndDate:= '01.01.2014', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
