-- Function: gpSelect_Movement_BankAccount_byInvoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount_byInvoice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_BankAccount_byInvoice (
    IN inMovementId_Invoice       Integer , --
    IN inIsErased                 Boolean ,
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumberPartner TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , Comment TVarChar
             , BankAccountId Integer, BankAccountName TVarChar, BankName TVarChar
             , MoneyPlaceCode Integer, MoneyPlaceName TVarChar, ItemName TVarChar
             , InvNumber_Invoice_Full TVarChar, InvNumber_Invoice TVarChar
             , AmountIn_Invoice TFloat
             , AmountOut_Invoice TFloat
             , Amount_Invoice TFloat
             , Amount_diff TFloat
             , isDiff Boolean

             , ObjectName_Invoice TVarChar
             , ObjectDescName_Invoice TVarChar

             , InfoMoneyCode_Invoice Integer, InfoMoneyGroupName_Invoice TVarChar, InfoMoneyDestinationName_Invoice TVarChar
             , InfoMoneyName_Invoice TVarChar, InfoMoneyName_all_Invoice TVarChar

             , ProductCode_Invoice Integer
             , ProductName_Invoice TVarChar
             , ProductCIN_Invoice TVarChar
             , PaidKindName_Invoice TVarChar
             , UnitName_Invoice TVarChar
             , InvNumberPartner_Invoice TVarChar
             , ReceiptNumber_Invoice Integer
             , Comment_Invoice TVarChar
             , InvoiceKindName TVarChar

             , MovementId_parent      Integer
             , InvNumberFull_parent   TVarChar
             , InvNumber_parent       TVarChar
             , MovementDescName_parent        TVarChar

             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

     /*, tmpMovement AS (SELECT Movement_BankAccount.*
                            , MovementLinkMovement.MovementChildId AS MovementId_Invoice
                            , ROW_Number() OVER (PARTITION BY MovementLinkMovement.MovementChildId ORDER BY Movement_BankAccount.OperDate Desc) AS Ord
                       FROM MovementLinkMovement
                           INNER JOIN Movement AS Movement_BankAccount
                                               ON Movement_BankAccount.Id = MovementLinkMovement.MovementId
                                              --AND Movement_BankAccount.StatusId = zc_Enum_Status_Complete()   ---<> zc_Enum_Status_Erased()
                                              AND Movement_BankAccount.DescId = zc_Movement_BankAccount()
                           INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_BankAccount.StatusId
                       WHERE MovementLinkMovement.MovementChildId = inMovementId_Invoice
                         AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                       )
      */
      , tmpMovement AS (SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_Invoice
                             , Movement_BankAccount.Id  
                             -- ������ �� �����
                             , SUM (CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount      ELSE 0 END) ::TFloat AS AmountIn
                             , SUM (CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END) ::TFloat AS AmountOut 
                             , SUM (SUM (COALESCE (MovementItem.Amount,0))) OVER (PARTITION BY MIFloat_MovementId.ValueData) AS TotalSumm_invoice
                             , ROW_Number() OVER (PARTITION BY MIFloat_MovementId.ValueData ORDER BY Movement_BankAccount.OperDate Desc) AS Ord
                        FROM MovementItemFloat AS MIFloat_MovementId
                             INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                    AND MovementItem.DescId   = zc_MI_Child()
                                                    AND MovementItem.isErased = FALSE
                             -- �������� BankAccount
                             INNER JOIN Movement AS Movement_BankAccount ON Movement_BankAccount.Id       = MovementItem.MovementId
                                                                        AND Movement_BankAccount.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                                                                        AND Movement_BankAccount.DescId   = zc_Movement_BankAccount()
                        WHERE MIFloat_MovementId.ValueData = inMovementId_Invoice
                          AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                        GROUP BY MIFloat_MovementId.ValueData
                               , Movement_BankAccount.Id
                              
                       )     
      , tmpInvoice_Params AS (SELECT DISTINCT tmp.MovementId
                                   , MovementFloat_Amount.ValueData ::TFloat AS Amount
                                   , Object_Object.Id                                    AS ObjectId
                                   , Object_Object.ValueData                             AS ObjectName
                                   , ObjectDesc.ItemName                                 AS ObjectDescName
                                   , Object_InfoMoney_View.InfoMoneyId
                                   , Object_InfoMoney_View.InfoMoneyCode
                                   , Object_InfoMoney_View.InfoMoneyName
                                   , Object_InfoMoney_View.InfoMoneyName_all
                                   , Object_InfoMoney_View.InfoMoneyGroupName
                                   , Object_InfoMoney_View.InfoMoneyDestinationName
                                   , Object_Product.Id                          AS ProductId
                                   , Object_Product.ObjectCode                  AS ProductCode
                                   , Object_Product.ValueData                   AS ProductName
                                   , ObjectString_CIN.ValueData                 AS ProductCIN
                                   , Object_PaidKind.Id                         AS PaidKindId
                                   , Object_PaidKind.ValueData                  AS PaidKindName
                                   , Object_Unit.Id                             AS UnitId
                                   , Object_Unit.ValueData                      AS UnitName
                                   , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
                                   , MovementString_ReceiptNumber.ValueData     AS ReceiptNumber
                                   , MovementString_Comment.ValueData           AS Comment

                                   , Object_InvoiceKind.Id                      AS InvoiceKindId
                                   , Object_InvoiceKind.ValueData               AS InvoiceKindName

                                   , Movement_Parent.Id                         AS MovementId_parent
                                   , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumberFull_parent
                                   , Movement_Parent.InvNumber                  AS InvNumber_parent
                                   , MovementDesc_Parent.ItemName               AS MovementDescName_parent
                              FROM (SELECT DISTINCT tmpMovement.MovementId_Invoice AS MovementId FROM tmpMovement) AS tmp
                                    LEFT JOIN Movement ON Movement.Id = tmp.MovementId
                                    LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                            ON MovementFloat_Amount.MovementId = tmp.MovementId
                                                           AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

                                    LEFT JOIN MovementDate AS MovementDate_Plan
                                                           ON MovementDate_Plan.MovementId = tmp.MovementId
                                                          AND MovementDate_Plan.DescId = zc_MovementDate_Plan()

                                    LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                             ON MovementString_InvNumberPartner.MovementId = tmp.MovementId
                                                            AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                                    LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                                             ON MovementString_ReceiptNumber.MovementId = tmp.MovementId
                                                            AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()

                                    LEFT JOIN MovementString AS MovementString_Comment
                                                             ON MovementString_Comment.MovementId = tmp.MovementId
                                                            AND MovementString_Comment.DescId = zc_MovementString_Comment()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Object
                                                                 ON MovementLinkObject_Object.MovementId = tmp.MovementId
                                                                AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object()
                                    LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementLinkObject_Object.ObjectId
                                    LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                                                 ON MovementLinkObject_InfoMoney.MovementId = tmp.MovementId
                                                                AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
                                    LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                 ON MovementLinkObject_Product.MovementId = tmp.MovementId
                                                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                                    LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

                                    LEFT JOIN ObjectString AS ObjectString_CIN
                                                           ON ObjectString_CIN.ObjectId = Object_Product.Id
                                                          AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = tmp.MovementId
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                 ON MovementLinkObject_PaidKind.MovementId = tmp.MovementId
                                                                AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                    LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                                 ON MovementLinkObject_InvoiceKind.MovementId = tmp.MovementId
                                                                AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                    LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId

                                    -- Parent - ���� "�����"
                                    LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                                                   ON MovementLinkMovement_Invoice.MovementChildId = Movement.Id
                                                                  AND MovementLinkMovement_Invoice.DescId          = zc_MovementLinkMovement_Invoice()
                                                                  AND COALESCE (Movement.ParentId,0) = 0
                                     -- Parent - ���� ������
                                    LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = COALESCE (Movement.ParentId, MovementLinkMovement_Invoice.MovementId)
                                                                         AND Movement_Parent.DescId = zc_Movement_BankAccount()
                                    LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId
                              )

      , tmpMI AS (SELECT MovementItem.*
                       -- ����� ������ �� ������
                      -- , SUM (CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount      ELSE 0 END) OVER (PARTITION BY tmpMovement.MovementId_Invoice) ::TFloat AS SumIn
                      -- , SUM (CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END) OVER (PARTITION BY tmpMovement.MovementId_Invoice) ::TFloat AS SumOut

                  FROM tmpMovement
                      LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                            AND MovementItem.DescId = zc_MI_Master()
                 ) 
                 
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) ::Integer AS InvNumber
           , MovementString_InvNumberPartner.ValueData   :: TVarChar AS InvNumberPartner
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           --, CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount      ELSE 0 END ::TFloat AS AmountIn
           --, CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END ::TFloat AS AmountOut
           , tmpMovement.AmountIn  ::TFloat AS AmountIn
           , tmpMovement.AmountOut ::TFloat AS AmountOut

           , MIString_Comment.ValueData        AS Comment
           , MovementItem.ObjectId             AS BankAccountId
           , Object_BankAccount.ValueData      AS BankAccountName
           , Object_Bank.ValueData             AS BankName
           , Object_MoneyPlace.ObjectCode      AS MoneyPlaceCode
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName
           , ObjectDesc.ItemName

           , zfCalc_InvNumber_isErased ('', Movement_Invoice.InvNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice_Full
           , Movement_Invoice.InvNumber        AS InvNumber_Invoice


           , CASE WHEN tmpInvoice_Params.Amount > 0 AND tmpMovement.Ord = 1 THEN tmpInvoice_Params.Amount      ELSE 0 END::TFloat AS AmountIn_Invoice
           , CASE WHEN tmpInvoice_Params.Amount < 0 AND tmpMovement.Ord = 1 THEN -1 * tmpInvoice_Params.Amount ELSE 0 END::TFloat AS AmountOut_Invoice

             -- ����� �� ����� - ������ � ��������� �������
           , CASE WHEN tmpInvoice_Params.Amount > 0 AND tmpMovement.Ord = 1
                       THEN  1 * tmpInvoice_Params.Amount
                  WHEN tmpInvoice_Params.Amount < 0 AND tmpMovement.Ord = 1
                       THEN  1 * tmpInvoice_Params.Amount
                  ELSE 0
             END :: TFloat AS Amount_Invoice

           --, (COALESCE (MovementItem.Amount,0) + COALESCE (tmpInvoice_Params.Amount,0))          ::TFloat AS Amount_diff
           , CASE WHEN tmpMovement.Ord = 1 OR tmpMovement.MovementId_Invoice IS NULL
                  THEN (COALESCE (tmpInvoice_Params.Amount,0) - (COALESCE (tmpMovement.TotalSumm_invoice,0)) )
                  ELSE 0
             END     ::TFloat  AS Amount_diff

           --, CASE WHEN COALESCE (MovementItem.Amount,0) + COALESCE (tmpInvoice_Params.Amount,0) <> 0 THEN TRUE ELSE FALSE END ::Boolean AS isDiff
           , CASE WHEN ( COALESCE (tmpInvoice_Params.Amount,0) - COALESCE (tmpMovement.TotalSumm_invoice,0)) <> 0
                  THEN TRUE ELSE FALSE END ::Boolean AS isDiff

           , tmpInvoice_Params.ObjectName          AS ObjectName_Invoice
           , tmpInvoice_Params.ObjectDescName      AS ObjectDescName_Invoice
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
           , tmpInvoice_Params.InvNumberPartner    AS InvNumberPartner_Invoice
           , zfConvert_StringToNumber (tmpInvoice_Params.ReceiptNumber) AS ReceiptNumber_Invoice
           , tmpInvoice_Params.Comment             AS Comment_Invoice
           , tmpInvoice_Params.InvoiceKindName     AS InvoiceKindName

           , tmpInvoice_Params.MovementId_parent        ::Integer
           , tmpInvoice_Params.InvNumberFull_parent     ::TVarChar
           , tmpInvoice_Params.InvNumber_parent         ::TVarChar
           , tmpInvoice_Params.MovementDescName_parent  ::TVarChar

           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate
       FROM tmpMovement
            LEFT JOIN Movement ON Movement.id = tmpMovement.Id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = tmpMovement.MovementId_Invoice

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

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

            LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

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

            -- �� ���. ����
            LEFT JOIN tmpInvoice_Params ON tmpInvoice_Params.MovementId = Movement_Invoice.Id


       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.02.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_BankAccount_byInvoice (inMovementId_Invoice:=0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
--select * from gpSelect_Movement_BankAccount_byInvoice(inMovementId_Invoice := 1808 , inIsErased := 'False' ,  inSession := '5');
