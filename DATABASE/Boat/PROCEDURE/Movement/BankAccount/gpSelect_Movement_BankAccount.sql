-- Function: gpSelect_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_BankAccount(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inIsErased                 Boolean ,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumberPartner TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , Comment TVarChar
             , BankAccountId Integer, BankAccountName TVarChar, BankName TVarChar
             , MoneyPlaceCode Integer, MoneyPlaceName TVarChar, ItemName TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice_Full TVarChar
             , Amount_Invoice TFloat
             , Amount_diff TFloat
             , isDiff Boolean
             , ObjectName_Invoice TVarChar
             , DescName_Invoice TVarChar
             , InfoMoneyCode_Invoice Integer, InfoMoneyGroupName_Invoice TVarChar, InfoMoneyDestinationName_Invoice TVarChar, InfoMoneyName_Invoice TVarChar, InfoMoneyName_all_Invoice TVarChar

             , ProductCode_Invoice Integer
             , ProductName_Invoice TVarChar
             , ProductCIN_Invoice TVarChar
             , PaidKindName_Invoice TVarChar
             , UnitName_Invoice TVarChar
             , ReceiptNumber_Invoice TVarChar
             , Comment_Invoice TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
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

        -- Документы BankAccount
      , tmpMovement AS (SELECT Movement.*
                        FROM tmpStatus
                             JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                          AND Movement.DescId = zc_Movement_BankAccount()
                                          AND Movement.StatusId = tmpStatus.StatusId
                        )
        -- у BankAccount нашли его Invoice
      , tmpMovementLinkMovement AS (SELECT MLM_Invoice.*
                                           -- № п/п - только в последнем платеже покажем Сумма по Счету
                                         , ROW_NUMBER() OVER (PARTITION BY MLM_Invoice.MovementChildId ORDER BY tmp.OperDate DESC, tmp.MovementId DESC) AS Ord
                                    FROM (SELECT DISTINCT tmpMovement.Id AS MovementId, tmpMovement.OperDate FROM tmpMovement) AS tmp
                                         INNER JOIN MovementLinkMovement AS MLM_Invoice
                                                                         ON MLM_Invoice.MovementId = tmp.MovementId
                                                                        AND MLM_Invoice.DescId     = zc_MovementLinkMovement_Invoice()
                                    )
        -- данные Invoice
      , tmpInvoice_Params AS (SELECT tmp.MovementId_Invoice                              AS MovementId_Invoice
                                   , MovementFloat_Amount.ValueData            :: TFloat AS Amount
                                   , Object_Object.Id                                    AS ObjectId
                                   , Object_Object.ValueData                             AS ObjectName
                                   , ObjectDesc.ItemName                                 AS DescName
                                   , Object_InfoMoney_View.InfoMoneyId
                                   , Object_InfoMoney_View.InfoMoneyCode
                                   , Object_InfoMoney_View.InfoMoneyGroupName
                                   , Object_InfoMoney_View.InfoMoneyDestinationName
                                   , Object_InfoMoney_View.InfoMoneyName
                                   , Object_InfoMoney_View.InfoMoneyName_all

                                   , Object_Product.Id                          AS ProductId
                                   , Object_Product.ObjectCode                  AS ProductCode
                                   , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)   AS ProductName
                                   , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS ProductCIN

                                   , Object_PaidKind.Id                         AS PaidKindId
                                   , Object_PaidKind.ValueData                  AS PaidKindName
                                   , Object_Unit.Id                             AS UnitId
                                   , Object_Unit.ValueData                      AS UnitName
                                   , MovementString_ReceiptNumber.ValueData     AS ReceiptNumber
                                   , MovementString_Comment.ValueData           AS Comment

                              FROM (SELECT DISTINCT tmpMovementLinkMovement.MovementChildId AS MovementId_Invoice FROM tmpMovementLinkMovement) AS tmp
                                    LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                            ON MovementFloat_Amount.MovementId = tmp.MovementId_Invoice
                                                           AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

                                    LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                                             ON MovementString_ReceiptNumber.MovementId = tmp.MovementId_Invoice
                                                            AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()

                                    LEFT JOIN MovementString AS MovementString_Comment
                                                             ON MovementString_Comment.MovementId = tmp.MovementId_Invoice
                                                            AND MovementString_Comment.DescId = zc_MovementString_Comment()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Object
                                                                 ON MovementLinkObject_Object.MovementId = tmp.MovementId_Invoice
                                                                AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object()
                                    LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementLinkObject_Object.ObjectId
                                    LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                                                 ON MovementLinkObject_InfoMoney.MovementId = tmp.MovementId_Invoice
                                                                AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
                                    LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = tmp.MovementId_Invoice
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                 ON MovementLinkObject_PaidKind.MovementId = tmp.MovementId_Invoice
                                                                AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                    LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                 ON MovementLinkObject_Product.MovementId = tmp.MovementId_Invoice
                                                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                                    LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

                                    LEFT JOIN ObjectString AS ObjectString_CIN
                                                           ON ObjectString_CIN.ObjectId = Object_Product.Id
                                                          AND ObjectString_CIN.DescId   = zc_ObjectString_Product_CIN()
                              )

        -- у Invoice нашли ВСЕ его BankAccount
      , tmpInvoice_sum AS (SELECT tmp.MovementId_Invoice
                                  -- итого ВСЕ оплаты
                                , SUM (MovementItem.Amount) AS Summ
                           FROM (SELECT DISTINCT tmpMovementLinkMovement.MovementChildId AS MovementId_Invoice FROM tmpMovementLinkMovement) AS tmp
                                INNER JOIN MovementLinkMovement AS MLM_Invoice
                                                                ON MLM_Invoice.MovementChildId = tmp.MovementId_Invoice
                                                               AND MLM_Invoice.DescId          = zc_MovementLinkMovement_Invoice()
                                INNER JOIN Movement AS Movement_BankAccount ON Movement_BankAccount.Id       = MLM_Invoice.MovementId
                                                                           AND Movement_BankAccount.StatusId = zc_Enum_Status_Complete()
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement_BankAccount.Id
                                                       AND MovementItem.DescId = zc_MI_Master()
                           GROUP BY tmp.MovementId_Invoice
                          )
       -- Результат
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) ::Integer AS InvNumber
           , MovementString_InvNumberPartner.ValueData :: TVarChar AS InvNumberPartner
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , CASE WHEN MovementItem.Amount > 0 THEN  1 * MovementItem.Amount ELSE 0 END ::TFloat AS AmountIn
           , CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END ::TFloat AS AmountOut

           , MIString_Comment.ValueData        AS Comment
           , MovementItem.ObjectId             AS BankAccountId
           , Object_BankAccount.ValueData      AS BankAccountName
           , Object_Bank.ValueData             AS BankName
           , Object_MoneyPlace.ObjectCode      AS MoneyPlaceCode
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName
           , ObjectDesc.ItemName

           , Movement_Invoice.Id AS MovementId_Invoice
           , zfCalc_InvNumber_isErased ('', Movement_Invoice.InvNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice_Full

             -- Сумма по Счету - только в последнем платеже
           , CASE WHEN tmpInvoice_Params.Amount > 0 AND MLM_Invoice.Ord = 1
                       THEN  1 * tmpInvoice_Params.Amount
                  WHEN tmpInvoice_Params.Amount < 0 AND MLM_Invoice.Ord = 1
                       THEN  1 * tmpInvoice_Params.Amount
                  ELSE 0
             END :: TFloat AS Amount_Invoice

             -- Разница с суммой по Счету - только в последнем платеже покажем
           , CASE WHEN MLM_Invoice.Ord = 1
                  THEN COALESCE (tmpInvoice_Params.Amount, 0) - COALESCE (tmpInvoice_sum.Summ, 0)
                  ELSE 0
             END :: TFloat  AS Amount_diff

           , CASE WHEN COALESCE (tmpInvoice_Params.Amount, 0) <> COALESCE (tmpInvoice_sum.Summ, 0)
                  THEN TRUE
                  ELSE FALSE
             END ::Boolean AS isDiff

           , tmpInvoice_Params.ObjectName          AS ObjectName_Invoice
           , tmpInvoice_Params.DescName            AS DescName_Invoice
           , tmpInvoice_Params.InfoMoneyCode       AS InfoMoneyCode_Invoice
           , tmpInvoice_Params.InfoMoneyGroupName  AS InfoMoneyGroupName_Invoice
           , tmpInvoice_Params.InfoMoneyDestinationName AS InfoMoneyDestinationName_Invoice
           , tmpInvoice_Params.InfoMoneyName       AS InfoMoneyName_Invoice
           , tmpInvoice_Params.InfoMoneyName_all   AS InfoMoneyName_all_Invoice
           , tmpInvoice_Params.ProductCode         AS ProductCode_Invoice
           , tmpInvoice_Params.ProductName         AS ProductName_Invoice
           , tmpInvoice_Params.ProductCIN          AS ProductCIN_Invoice
           , tmpInvoice_Params.PaidKindName        AS PaidKindName_Invoice
           , tmpInvoice_Params.UnitName            AS UnitName_Invoice
           , tmpInvoice_Params.ReceiptNumber       AS ReceiptNumber_Invoice
           , tmpInvoice_Params.Comment             AS Comment_Invoice

           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate
       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN tmpMovementLinkMovement AS MLM_Invoice
                                              ON MLM_Invoice.MovementId = Movement.Id
                                             AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            -- данные Invoice
            LEFT JOIN tmpInvoice_Params ON tmpInvoice_Params.MovementId_Invoice = Movement_Invoice.Id
            -- итого ВСЕ оплаты
            LEFT JOIN tmpInvoice_sum ON tmpInvoice_sum.MovementId_Invoice = Movement_Invoice.Id


            -- данные BankAccount
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()

            LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = MovementItem.ObjectId

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

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
