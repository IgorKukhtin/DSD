-- Function: gpSelect_MI_BankAccount_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_BankAccount_Child (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_BankAccount_Child(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inIsErased                 Boolean ,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer
             , Id Integer, ParentId Integer
             , Amount TFloat
             , Comment TVarChar
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar, ItemName TVarChar

             , MovementId_Invoice Integer, ParentId_Invoice Integer, OperDate_Invoice TDateTime, InvNumber_Invoice_Full TVarChar, InvNumber_Invoice TVarChar
             , ReceiptNumber_Invoice Integer, InvoiceKindId Integer, InvoiceKindName TVarChar, ObjectName_invoice TVarChar
             , Amount_Invoice TFloat
             , InfoMoneyId_Invoice Integer, InfoMoneyCode_Invoice Integer, InfoMoneyGroupName_Invoice TVarChar, InfoMoneyDestinationName_Invoice TVarChar, InfoMoneyName_Invoice TVarChar, InfoMoneyName_all_Invoice TVarChar

              -- Заказ Клиента / Заказ Поставщику
             , MovementId_parent Integer, InvNumberFull_parent TVarChar, MovementDescName_parent TVarChar
             , ProductCode_Invoice Integer
             , ProductName_Invoice TVarChar
             , ProductCIN_Invoice TVarChar

             , InsertName TVarChar, InsertDate TDateTime
             , isErased Boolean
             , Ord Integer
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Временно замена!!!
     IF inEndDate < CURRENT_DATE THEN inEndDate:= CURRENT_DATE; END IF;


     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

        -- Документы BankAccount
      , tmpMovement AS (SELECT Movement.*
                        FROM tmpStatus
                             JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                          AND Movement.DescId = zc_Movement_BankAccount()
                                          AND Movement.StatusId = tmpStatus.StatusId
                        )
        --все чайды
      , tmpMI_Child AS (SELECT MovementItem.*
                        FROM MovementItem
                        WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MovementItem.DescId = zc_MI_Child()
                          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                        )

        --  Invoice
      , tmpMIFloat AS (SELECT MovementItemFloat.MovementItemId
                            , MovementItemFloat.ValueData ::Integer AS MovementId_Invoice
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                         AND MovementItemFloat.DescId = zc_MIFloat_MovementId()
                      )
      --
      , tmpMIString AS (SELECT MovementItemString.*
                              FROM MovementItemString
                              WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                                AND MovementItemString.DescId = zc_MIString_Comment()
                              )

       -- Результат
       SELECT
             Movement.Id
           , tmpMI_Child.Id
           , tmpMI_Child.ParentId
           , tmpMI_Child.Amount :: TFloat

           , MIString_Comment.ValueData    AS Comment
           , Object_Object.Id              AS ObjectId
           , Object_Object.ObjectCode      AS ObjectCode
           , Object_Object.ValueData       AS ObjectName
           , ObjectDesc.ItemName

           , Movement_Invoice.Id                            AS MovementId_Invoice
           , Movement_Invoice.ParentId                      AS ParentId_Invoice
           , Movement_Invoice.OperDate                      AS OperDate_Invoice
           , zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, MovementString_ReceiptNumber.ValueData, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice_Full
           , Movement_Invoice.InvNumber                     AS InvNumber_Invoice
           , zfConvert_StringToNumber (MovementString_ReceiptNumber.ValueData) ::Integer AS ReceiptNumber_Invoice
           , Object_InvoiceKind.Id                          AS InvoiceKindId
           , Object_InvoiceKind.ValueData                   AS InvoiceKindName
           , Object_Object_invoice.ValueData                AS ObjectName_invoice
           , ABS (MovementFloat_Amount.ValueData) :: TFloat AS Amount_invoice

           , Object_InfoMoney_View_invoice.InfoMoneyId
           , Object_InfoMoney_View_invoice.InfoMoneyCode
           , Object_InfoMoney_View_invoice.InfoMoneyGroupName
           , Object_InfoMoney_View_invoice.InfoMoneyDestinationName
           , Object_InfoMoney_View_invoice.InfoMoneyName
           , Object_InfoMoney_View_invoice.InfoMoneyName_all

             -- Заказ Клиента / Заказ Поставщику
           , Movement_Parent.Id             ::Integer  AS MovementId_parent
           , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumberFull_parent
           , MovementDesc_Parent.ItemName              AS MovementDescName_parent
           , Object_Product.ObjectCode                                                       AS ProductCode_Invoice
           , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)   AS ProductName_Invoice
           , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS ProductCIN_Invoice

           , Object_Insert.ValueData     AS InsertName
           , MIDate_Insert.ValueData     AS InsertDate

           , tmpMI_Child.isErased  ::Boolean AS isErased

           , ROW_NUMBER() OVER (PARTITION BY Movement.Id ORDER BY Movement.Id, tmpMI_Child.Id) ::Integer AS Ord
       FROM tmpMovement AS Movement
            INNER JOIN tmpMI_Child ON tmpMI_Child.MovementId = Movement.Id

            LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpMI_Child.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

            LEFT JOIN tmpMIFloat AS MIFloat_MovementId
                                 ON MIFloat_MovementId.MovementItemId = tmpMI_Child.Id
                                --AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MIFloat_MovementId.MovementId_Invoice
            -- сумма счета
            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId = Movement_Invoice.Id
                                   AND MovementFloat_Amount.DescId     = zc_MovementFloat_Amount()
            -- номер счета
            LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                     ON MovementString_ReceiptNumber.MovementId = Movement_Invoice.Id
                                    AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()
            -- тип счета
            LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                         ON MovementLinkObject_InvoiceKind.MovementId = Movement_Invoice.Id
                                        AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
            LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId

            -- Lieferanten / Kunden счета
            LEFT JOIN MovementLinkObject AS MLO_Object_invoice
                                         ON MLO_Object_invoice.MovementId = Movement_Invoice.Id
                                        AND MLO_Object_invoice.DescId     = zc_MovementLinkObject_Object()
            LEFT JOIN Object AS Object_Object_invoice ON Object_Object_invoice.Id = MLO_Object_invoice.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney_invoice
                                         ON MovementLinkObject_InfoMoney_invoice.MovementId = Movement_Invoice.Id
                                        AND MovementLinkObject_InfoMoney_invoice.DescId     = zc_MovementLinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View_invoice ON Object_InfoMoney_View_invoice.InfoMoneyId = MovementLinkObject_InfoMoney_invoice.ObjectId

            -- Parent для Movement_Invoice - Документ Заказ или ПРиход
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


            LEFT JOIN tmpMIString AS MIString_Comment
                                  ON MIString_Comment.MovementItemId = tmpMI_Child.Id
                                 AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = tmpMI_Child.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                             ON MILO_Insert.MovementItemId = tmpMI_Child.Id
                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.24         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_BankAccount_Child (inStartDate:= '30.01.2013', inEndDate:= '01.01.2014', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
