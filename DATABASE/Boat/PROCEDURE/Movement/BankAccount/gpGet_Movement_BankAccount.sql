-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_Movement_BankAccount (Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_BankAccount (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_BankAccount(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_Value  Integer   ,
    IN inMovementId_Invoice   Integer   ,
    IN inMovementId_parent Integer   ,
    IN inMoneyPlaceId      Integer   ,
    IN inOperDate          TDateTime , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , Comment TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InvoiceKindId    Integer, InvoiceKindName  TVarChar
             , MovementId_parent Integer
             , InvNumber_parent TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY
       WITH tmpBankAccount AS (SELECT Object_BankAccount.Id            AS Id
                                    , Object_BankAccount.ObjectCode    AS Code
                                    , Object_BankAccount.ValueData     AS Name
                                    , Object_Bank.Id                   AS BankId
                                    , Object_Bank.ValueData            AS BankName
                               FROM Object AS Object_BankAccount
                                    LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                                         ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                                        AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                                    LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
                               WHERE Object_BankAccount.DescId = zc_Object_BankAccount()
                                 AND Object_BankAccount.isErased = FALSE
                               ORDER BY Object_BankAccount.Id
                               LIMIT 1
                              )
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar)  AS InvNumber
           , ''::TVarChar                                      AS InvNumberPartner
           , CURRENT_DATE /*inOperDate*/          :: TDateTime AS OperDate
           , lfObject_Status.Code                              AS StatusCode
           , lfObject_Status.Name                              AS StatusName
           , 0::TFloat                                         AS AmountIn
           , 0::TFloat                                         AS AmountOut
           , ''::TVarChar                                      AS Comment
           , tmpBankAccount.Id                                 AS BankAccountId
           , tmpBankAccount.Name                               AS BankAccountName
           , tmpBankAccount.BankId                             AS BankId
           , tmpBankAccount.BankName                           AS BankName
           , Object_MoneyPlace.Id                              AS MoneyPlaceId
           , Object_MoneyPlace.ValueData                       AS MoneyPlaceName

           , Movement_Invoice.Id                               AS MovementId_Invoice
           , zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, MovementString_ReceiptNumber.ValueData, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
           , MovementString_Comment_Invoice.ValueData          AS Comment_Invoice

           , Object_InvoiceKind.Id                             AS InvoiceKindId
           , Object_InvoiceKind.ValueData                      AS InvoiceKindName

           , Movement_Parent.Id             ::Integer  AS MovementId_parent
           , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumber_parent
       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = inMovementId_Invoice

            -- тип счета
            LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                         ON MovementLinkObject_InvoiceKind.MovementId = Movement_Invoice.Id
                                        AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
            LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = COALESCE (MovementLinkObject_InvoiceKind.ObjectId, zc_Enum_InvoiceKind_PrePay())

            -- Официальный номер документа Счет
            LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                     ON MovementString_ReceiptNumber.MovementId = Movement_Invoice.Id
                                    AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()

            LEFT JOIN MovementString AS MovementString_Comment_Invoice
                                     ON MovementString_Comment_Invoice.MovementId = Movement_Invoice.Id
                                    AND MovementString_Comment_Invoice.DescId = zc_MovementString_Comment()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = inMoneyPlaceId
            LEFT JOIN Movement AS Movement_Parent
                               ON Movement_Parent.Id = inMovementId_parent
            LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId
            LEFT JOIN tmpBankAccount ON 1=1
      ;
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , MovementString_InvNumberPartner.ValueData :: TVarChar AS InvNumberPartner
           , CASE WHEN inMovementId = 0 THEN inOperDate ELSE Movement.OperDate END AS OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount      ELSE 0 END ::TFloat AS AmountIn
           , CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END ::TFloat AS AmountOut

           , MIString_Comment.ValueData        AS Comment

           , Object_BankAccount.Id             AS BankAccountId
           , Object_BankAccount.ValueData      AS BankAccountName
           , Object_Bank.Id                    AS BankId
           , Object_Bank.ValueData             AS BankName
           , Object_MoneyPlace.Id              AS MoneyPlaceId
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName

           , Movement_Invoice.Id               AS MovementId_Invoice
           , zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, MovementString_ReceiptNumber.ValueData, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
           , MovementString_Comment_Invoice.ValueData AS Comment_Invoice

           , Object_InvoiceKind.Id             AS InvoiceKindId
           , Object_InvoiceKind.ValueData      AS InvoiceKindName

           --parent для Invoice
           , Movement_Parent.Id             ::Integer  AS MovementId_parent
           , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumber_parent

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                           ON MovementLinkMovement_Invoice.MovementId = Movement.Id
                                          AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MovementLinkMovement_Invoice.MovementChildId

            -- тип счета
            LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                         ON MovementLinkObject_InvoiceKind.MovementId = Movement_Invoice.Id
                                        AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
            LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = COALESCE (MovementLinkObject_InvoiceKind.ObjectId, zc_Enum_InvoiceKind_PrePay())

            -- Официальный номер документа Счет
            LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                     ON MovementString_ReceiptNumber.MovementId = Movement_Invoice.Id
                                    AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()

            LEFT JOIN MovementString AS MovementString_Comment_Invoice
                                     ON MovementString_Comment_Invoice.MovementId = Movement_Invoice.Id
                                    AND MovementString_Comment_Invoice.DescId = zc_MovementString_Comment()

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

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

        --Parent для Movement_Invoice - Документ Заказ или Приход
        LEFT JOIN Movement AS Movement_Parent
                           ON Movement_Parent.Id = Movement_Invoice.ParentId
                          AND Movement_Parent.StatusId <> zc_Enum_Status_Erased()
        LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId

       WHERE Movement.Id = inMovementId_Value;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.02.21         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_BankAccount (inMovementId:= 271, inMovementId_Value := 705 , inMovementId_Invoice := 254931 , inMovementId_parent := 253190 , inMoneyPlaceId:=0, inOperDate:= NULL :: TDateTime, inSession:= zfCalc_UserAdmin());
