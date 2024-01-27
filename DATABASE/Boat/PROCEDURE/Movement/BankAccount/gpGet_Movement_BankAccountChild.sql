-- Function: gpGet_Movement_BankAccountChild()

DROP FUNCTION IF EXISTS gpGet_Movement_BankAccountChild (Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_BankAccountChild(
    IN inMovementId            Integer  , -- ключ Документа
    IN inMovementId_Value      Integer   ,  
    IN inMovementId_Invoice    Integer   ,
    IN inMovementId_parent     Integer   ,
    IN inMovementItemId_child  Integer,
    IN inMoneyPlaceId          Integer   ,
    IN inOperDate              TDateTime , --
    IN inSession               TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , Amount_pay TFloat 
             , Amount_invoice TFloat
             , Comment TVarChar
             , Comment_master Text
             , BankAccountId Integer, BankAccountName TVarChar
             , BankId Integer, BankName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar
             , InvoiceKindId    Integer, InvoiceKindName  TVarChar 
             , InfoMoneyName_invoice TVarChar
             , MovementId_parent Integer
             , InvNumber_parent TVarChar
             , ProductName_Invoice TVarChar
             , ProductCIN_Invoice TVarChar
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
           , 0     :: TFloat                                   AS Amount_pay  
           , ABS (MovementFloat_Amount.ValueData)    :: TFloat AS Amount_invoice
           , ''::TVarChar                                      AS Comment 
           , NULL :: Text                                      AS Comment_master
           , tmpBankAccount.Id                                 AS BankAccountId
           , tmpBankAccount.Name                               AS BankAccountName
           , tmpBankAccount.BankId                             AS BankId
           , tmpBankAccount.BankName                           AS BankName
           , Object_MoneyPlace.Id                              AS MoneyPlaceId
           , Object_MoneyPlace.ValueData                       AS MoneyPlaceName
           
           , Movement_Invoice.Id                               AS MovementId_Invoice
           --, zfCalc_InvNumber_isErased ('', Movement_Invoice.InvNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
           , zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, MovementString_ReceiptNumber.ValueData, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
           , Object_InvoiceKind.Id                             AS InvoiceKindId
           , Object_InvoiceKind.ValueData                      AS InvoiceKindName   
           , Object_InfoMoney_View_invoice.InfoMoneyName       AS InfoMoneyName_invoice
                       
           , Movement_Parent.Id             ::Integer  AS MovementId_parent
           , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumber_parent
           , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)   AS ProductName_Invoice
           , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS ProductCIN_Invoice

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = inMovementId_Invoice
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                         ON MovementLinkObject_InvoiceKind.MovementId = Movement_Invoice.Id
                                        AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
            LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = COALESCE (MovementLinkObject_InvoiceKind.ObjectId, zc_Enum_InvoiceKind_PrePay())

           -- номер счета
            LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                     ON MovementString_ReceiptNumber.MovementId = Movement_Invoice.Id
                                    AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()
            -- сумма счета
            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId = Movement_Invoice.Id
                                   AND MovementFloat_Amount.DescId     = zc_MovementFloat_Amount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney_invoice
                                         ON MovementLinkObject_InfoMoney_invoice.MovementId = Movement_Invoice.Id
                                        AND MovementLinkObject_InfoMoney_invoice.DescId     = zc_MovementLinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View_invoice ON Object_InfoMoney_View_invoice.InfoMoneyId = MovementLinkObject_InfoMoney_invoice.ObjectId

            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = inMoneyPlaceId
            LEFT JOIN Movement AS Movement_Parent
                               ON Movement_Parent.Id = inMovementId_parent
            LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                         ON MovementLinkObject_Product.MovementId = Movement_Parent.Id
                                        AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
            LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId
            LEFT JOIN ObjectString AS ObjectString_CIN
                                   ON ObjectString_CIN.ObjectId = Object_Product.Id
                                  AND ObjectString_CIN.DescId   = zc_ObjectString_Product_CIN()

            LEFT JOIN tmpBankAccount ON 1=1
      ;
     ELSE

     RETURN QUERY 
       WITH
      
      -- чайд
       tmpMI_Child AS (SELECT MovementItem.*
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId_Value
                         AND MovementItem.Id = inMovementItemId_child
                         AND MovementItem.DescId = zc_MI_Child()
                       )

       SELECT
             Movement.Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , MovementString_InvNumberPartner.ValueData :: TVarChar AS InvNumberPartner
           , CASE WHEN inMovementId = 0 THEN inOperDate ELSE Movement.OperDate END AS OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , CASE WHEN tmpMI_Child.Amount > 0 THEN tmpMI_Child.Amount      ELSE 0 END ::TFloat AS AmountIn
           , CASE WHEN tmpMI_Child.Amount < 0 THEN -1 * tmpMI_Child.Amount ELSE 0 END ::TFloat AS AmountOut
           , ABS (MovementItem.Amount)                                                ::TFloat AS Amount_pay  
           , ABS (MovementFloat_Amount.ValueData) :: TFloat AS Amount_invoice

           , MIString_Comment.ValueData                AS Comment
           , MovementBlob_Comment.ValueData:: Text     AS Comment_master

           , Object_BankAccount.Id             AS BankAccountId
           , Object_BankAccount.ValueData      AS BankAccountName
           , Object_Bank.Id                    AS BankId
           , Object_Bank.ValueData             AS BankName
           , COALESCE (Object_MoneyPlace.Id, Object_Object.Id)               AS MoneyPlaceId
           , COALESCE (Object_MoneyPlace.ValueData, Object_Object.ValueData) AS MoneyPlaceName

           , Movement_Invoice.Id               AS MovementId_Invoice
           --, zfCalc_InvNumber_isErased ('', Movement_Invoice.InvNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
           , zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, MovementString_ReceiptNumber.ValueData, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
           , Object_InvoiceKind.Id             AS InvoiceKindId
           , Object_InvoiceKind.ValueData      AS InvoiceKindName
           , Object_InfoMoney_View_invoice.InfoMoneyName       AS InfoMoneyName_invoice

           --parent для Invoice
           , Movement_Parent.Id             ::Integer  AS MovementId_parent
           , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumber_parent
           , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)   AS ProductName_Invoice
           , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS ProductCIN_Invoice
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END

            -- Примечание (Цель использования)
            LEFT JOIN MovementBlob AS MovementBlob_Comment
                                   ON MovementBlob_Comment.MovementId = Movement.Id
                                  AND MovementBlob_Comment.DescId     = zc_MovementBlob_11()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            -- данные BankAccount
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
                  
            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

            ---Сhild------         
            LEFT JOIN tmpMI_Child AS tmpMI_Child
                                  ON tmpMI_Child.MovementId = Movement.Id
                                 AND tmpMI_Child.ParentId = MovementItem.Id
                                 AND tmpMI_Child.DescId = zc_MI_Child()

            LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpMI_Child.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = tmpMI_Child.Id
                                       AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MIFloat_MovementId.ValueData ::Integer

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpMI_Child.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                         ON MovementLinkObject_InvoiceKind.MovementId = Movement_Invoice.Id
                                        AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
            LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = COALESCE (MovementLinkObject_InvoiceKind.ObjectId, zc_Enum_InvoiceKind_PrePay())

           -- номер счета
            LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                     ON MovementString_ReceiptNumber.MovementId = Movement_Invoice.Id
                                    AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()
            -- сумма счета
            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId = Movement_Invoice.Id
                                   AND MovementFloat_Amount.DescId     = zc_MovementFloat_Amount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney_invoice
                                         ON MovementLinkObject_InfoMoney_invoice.MovementId = Movement_Invoice.Id
                                        AND MovementLinkObject_InfoMoney_invoice.DescId     = zc_MovementLinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View_invoice ON Object_InfoMoney_View_invoice.InfoMoneyId = MovementLinkObject_InfoMoney_invoice.ObjectId

            --Parent для Movement_Invoice - Документ Заказ или Приход
            LEFT JOIN Movement AS Movement_Parent
                               ON Movement_Parent.Id = Movement_Invoice.ParentId
                              AND Movement_Parent.StatusId <> zc_Enum_Status_Erased()
            LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                         ON MovementLinkObject_Product.MovementId = Movement_Parent.Id
                                        AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
            LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId
            LEFT JOIN ObjectString AS ObjectString_CIN
                                   ON ObjectString_CIN.ObjectId = Object_Product.Id
                                  AND ObjectString_CIN.DescId   = zc_ObjectString_Product_CIN()
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
--SELECT * FROM gpGet_Movement_BankAccountChild (inMovementId:= 271, inMovementId_Value := 705 , inMovementId_Invoice := 254931 , inMovementId_parent := 253190 , inMovementItemId_child :=0, inMoneyPlaceId:=0, inOperDate:= NULL :: TDateTime, inSession:= zfCalc_UserAdmin());
