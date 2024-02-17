-- Function: gpGet_Movement_BankAccount_byPDF()

DROP FUNCTION IF EXISTS gpGet_Movement_BankAccount_byPDF (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_BankAccount_byPDF(
    IN inMovementId            Integer  , -- ключ Документа
    IN inMovementItemId_child  Integer,
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
             , InfoMoneyId_invoice Integer, InfoMoneyName_invoice TVarChar
             , MovementId_parent Integer
             , InvNumber_parent TVarChar
             , ProductName_Invoice TVarChar
             , ProductCIN_Invoice TVarChar
             , String_7     TVarChar  --Name Zahlungsbeteiligter; наименование плательщика;
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);


     RETURN QUERY 
       WITH
      
      -- чайд
       tmpMI_Child AS (SELECT MovementItem.*
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND (MovementItem.Id = inMovementItemId_child OR inMovementItemId_child = 0) --показіваем инфу по всем счетам STRING_AGG
                         AND MovementItem.DescId = zc_MI_Child() 
                         AND (MovementItem.isErased = FALSE OR inMovementItemId_child <> 0)
                       )
       --счета
     , tmpInvoice AS (SELECT MIFloat_MovementId.MovementItemId
                           , MIFloat_MovementId.ValueData ::Integer  
                           , MIFloat_MovementId.DescId
                      FROM MovementItemFloat AS MIFloat_MovementId
                      WHERE MIFloat_MovementId.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                        AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                      )
       --Сумма счета
     , tmpInvoice_Amount AS (SELECT MovementFloat_Amount.*
                             FROM MovementFloat AS MovementFloat_Amount
                             WHERE MovementFloat_Amount.MovementId IN (SELECT DISTINCT tmpInvoice.ValueData::Integer FROM tmpInvoice)
                               AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                             ) 
       --Сумма по всем счетам
     , tmpInvoice_Amount_All AS (SELECT SUM(tmpInvoice_Amount.ValueData) AS Summ_all
                                 FROM tmpInvoice_Amount
                                 )

       SELECT
             Movement.Id
           , Movement.InvNumber         AS InvNumber
           , MovementString_InvNumberPartner.ValueData :: TVarChar AS InvNumberPartner
           , Movement.OperDate          AS OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , CASE WHEN inMovementItemId_child = 0 THEN  ABS (MovementItem.Amount - SUM (COALESCE(tmpMI_Child.Amount,0)))
                  ELSE SUM (CASE WHEN tmpMI_Child.Amount > 0 THEN tmpMI_Child.Amount ELSE 0 END)
             END ::TFloat AS AmountIn
           , CASE WHEN inMovementItemId_child = 0 THEN 0
                  ELSE SUM (CASE WHEN tmpMI_Child.Amount < 0 THEN -1 * tmpMI_Child.Amount ELSE 0 END)
             END ::TFloat AS AmountOut
           , ABS (MovementItem.Amount)                                               ::TFloat AS Amount_pay  
           , ABS (CASE WHEN inMovementItemId_child = 0 THEN tmpInvoice_Amount_All.Summ_all ELSE SUM (MovementFloat_Amount.ValueData) END) :: TFloat AS Amount_invoice

           , STRING_AGG (DISTINCT COALESCE (MIString_Comment.ValueData,'') , ';') ::TVarChar     AS Comment
           , STRING_AGG (DISTINCT MovementBlob_Comment.ValueData, ';'):: Text     AS Comment_master

           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Object_BankAccount.Id END  AS BankAccountId
           , STRING_AGG (DISTINCT Object_BankAccount.ValueData, ';')              ::TVarChar      AS BankAccountName
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Object_Bank.Id  END        AS BankId
           , STRING_AGG (DISTINCT Object_Bank.ValueData, ';')              ::TVarChar             AS BankName
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE COALESCE (Object_MoneyPlace.Id, Object_Object.Id) END AS MoneyPlaceId
           , STRING_AGG (DISTINCT COALESCE (Object_MoneyPlace.ValueData, Object_Object.ValueData), ';')          ::TVarChar  AS MoneyPlaceName

           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Movement_Invoice.Id END                        AS MovementId_Invoice
           , STRING_AGG (DISTINCT zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, MovementString_ReceiptNumber.ValueData, Movement_Invoice.OperDate, Movement_Invoice.StatusId), CHR (13)) ::TVarChar AS InvNumber_Invoice
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Object_InvoiceKind.Id END                      AS InvoiceKindId
           , STRING_AGG (DISTINCT Object_InvoiceKind.ValueData, ';')                                  ::TVarChar      AS InvoiceKindName  
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Object_InfoMoney_View_invoice.InfoMoneyId END  AS InfoMoneyId_invoice
           , STRING_AGG (DISTINCT Object_InfoMoney_View_invoice.InfoMoneyName, ';')                  ::TVarChar       AS InfoMoneyName_invoice

           --parent для Invoice
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Movement_Parent.Id  END            ::Integer  AS MovementId_parent
           , STRING_AGG (DISTINCT zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId), ';') ::TVarChar AS InvNumber_parent
           , STRING_AGG (DISTINCT zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased), ';') ::TVarChar      AS ProductName_Invoice
           , STRING_AGG (DISTINCT zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased), ';') ::TVarChar    AS ProductCIN_Invoice
           --
           , MovementString_7.ValueData   ::TVarChar AS String_7
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END

            -- Примечание (Цель использования)
            LEFT JOIN MovementBlob AS MovementBlob_Comment
                                   ON MovementBlob_Comment.MovementId = Movement.Id
                                  AND MovementBlob_Comment.DescId     = zc_MovementBlob_11()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner() 
            LEFT JOIN MovementString AS MovementString_7
                                     ON MovementString_7.MovementId = Movement.Id
                                    AND MovementString_7.DescId = zc_MovementString_7()
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

            LEFT JOIN tmpInvoice AS MIFloat_MovementId
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
            LEFT JOIN tmpInvoice_Amount AS MovementFloat_Amount
                                        ON MovementFloat_Amount.MovementId = Movement_Invoice.Id
                                       AND MovementFloat_Amount.DescId     = zc_MovementFloat_Amount() 
                                       AND inMovementItemId_child <> 0
            LEFT JOIN tmpInvoice_Amount_All ON inMovementItemId_child = 0

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

       WHERE Movement.Id = inMovementId
       GROUP BY Movement.Id
           , Movement.InvNumber 
           , MovementString_InvNumberPartner.ValueData
           , Movement.OperDate
           , Object_Status.ObjectCode
           , Object_Status.ValueData
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Object_BankAccount.Id END
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Object_Bank.Id  END
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE COALESCE (Object_MoneyPlace.Id, Object_Object.Id) END
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Movement_Invoice.Id END
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Object_InvoiceKind.Id END
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Object_InfoMoney_View_invoice.InfoMoneyId END
           , CASE WHEN inMovementItemId_child = 0 THEN 0 ELSE Movement_Parent.Id  END 
           , (MovementItem.Amount) 
           , ABS (CASE WHEN inMovementItemId_child = 0 THEN tmpInvoice_Amount_All.Summ_all ELSE 0 END)
           , tmpInvoice_Amount_All.Summ_all
           , MovementString_7.ValueData
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
*/

-- тест
--SELECT * FROM gpGet_Movement_BankAccount_byPDF (inMovementId:= 1804, inMovementItemId_child :=0, inSession:= zfCalc_UserAdmin());