-- Function: gpSelect_Movement_Invoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_InvoiceByProduct (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_InvoiceByProduct (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_InvoiceByProduct(
    IN inProductId     Integer ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id              Integer
             , MovementId_parent Integer
             , InvNumber       Integer
             , InvNumber_Full  TVarChar
             , OperDate        TDateTime
             , PlanDate        TDateTime
             , StatusCode      Integer
             , StatusName      TVarChar
             , InvoiceKindId   Integer
             , InvoiceKindName TVarChar
             , isAuto          Boolean
               --
             , Amount         TFloat
               --
             , AmountIn_NotVAT  TFloat
             , AmountOut_NotVAT TFloat
             , AmountIn_VAT     TFloat
             , AmountOut_VAT    TFloat
             , VATPercent      TFloat

             -- ������
             , AmountIn_BankAccount  TFloat
             , AmountOut_BankAccount TFloat
             , Amount_BankAccount    TFloat --����� ������
             -- ������� �� �����
             , AmountIn_rem  TFloat
             , AmountOut_rem TFloat
             , Amount_rem    TFloat

             , ObjectId        Integer
             , ObjectName      TVarChar
             , DescName        TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , PaidKindId      Integer
             , PaidKindName    TVarChar
             , UnitId          Integer
             , UnitName        TVarChar

             , InvNumberPartner TVarChar
             , ReceiptNumber    Integer
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime

             , Color_Pay Integer
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbProductId Integer;
BEGIN

     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
       WITH
       tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
               UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
               UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                    )
       -- �������� ����� ��� �����
     , tmpMovementOrder AS (SELECT MovementLinkObject_Product.*
                            FROM MovementLinkObject AS MovementLinkObject_Product
                            WHERE MovementLinkObject_Product.ObjectId = inProductId
                              AND MovementLinkObject_Product.DescId   = zc_MovementLinkObject_Product()
                           )
       -- ��������� ���� ��� ������
     , tmpMovement AS (SELECT Movement.*
                       FROM tmpMovementOrder
                           INNER JOIN Movement ON Movement.DescId   = zc_Movement_Invoice()
                                              AND Movement.ParentId = tmpMovementOrder.MovementId
                           INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                      )
       -- ��� �����
     , tmpMovementFloat AS (SELECT MovementFloat.*
                            FROM MovementFloat
                            WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                              AND MovementFloat.DescId IN (zc_MovementFloat_Amount()
                                                         , zc_MovementFloat_VATPercent())
                            )
       -- ��� �����
     , tmpMovementDate AS (SELECT MovementDate.*
                           FROM MovementDate
                           WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                             AND MovementDate.DescId = zc_MovementDate_Plan()
                           )
       -- ��� �����
     , tmpMovementBoolean AS (SELECT MovementBoolean.*
                              FROM MovementBoolean
                              WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementBoolean.DescId IN (zc_MovementBoolean_Auto()
                                                              )
                             )
       -- ��� �����
     , tmpMovementString AS (SELECT MovementString.*
                             FROM MovementString
                             WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                               AND MovementString.DescId IN (zc_MovementString_InvNumberPartner()
                                                           , zc_MovementString_ReceiptNumber()
                                                           , zc_MovementString_Comment()
                                                             )
                           )
       -- ��� �����
     , tmpMLO AS (SELECT MovementLinkObject.*
                  FROM MovementLinkObject
                  WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                    AND MovementLinkObject.DescId IN ( zc_MovementLinkObject_Object()
                                                     , zc_MovementLinkObject_Unit()
                                                     , zc_MovementLinkObject_InfoMoney()
                                                   --, zc_MovementLinkObject_Product()
                                                     , zc_MovementLinkObject_PaidKind()
                                                     , zc_MovementLinkObject_InvoiceKind()
                                                      )
                  )
       -- ��������� BankAccount ��� ������
     , tmpMLM_BankAccount AS (SELECT tmpMovementInvoice.Id AS MovementId_Invoice
                                   , SUM (CASE WHEN MovementItem.Amount > 0 THEN  1 * MovementItem.Amount ELSE 0 END) ::TFloat AS AmountIn
                                   , SUM (CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END) ::TFloat AS AmountOut
                              FROM tmpMovement AS tmpMovementInvoice
                                   INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                ON MIFloat_MovementId.ValueData = tmpMovementInvoice.Id :: TFloat
                                                               AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                                   INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                          AND MovementItem.DescId   = zc_MI_Child()
                                                          AND MovementItem.isErased = FALSE
                                   -- �������� BankAccount
                                   JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                AND Movement.DescId   = zc_Movement_BankAccount()
                                                AND Movement.StatusId = zc_Enum_Status_Complete()   ---<> zc_Enum_Status_Erased()
                              GROUP BY tmpMovementInvoice.Id
                             )
      --
    , tmpData AS (SELECT
                         Movement.Id
                       , Movement.Id AS MovementId_parent
                       , zfConvert_StringToNumber (Movement.InvNumber) ::Integer AS InvNumber
                       , zfCalc_InvNumber_isErased ('', Movement.InvNumber, Movement.OperDate, Movement.StatusId) AS InvNumber_Full
                       , Movement.OperDate
                       , MovementDate_Plan.ValueData         :: TDateTime    AS PlanDate
                       , Object_Status.ObjectCode                            AS StatusCode
                       , Object_Status.ValueData                             AS StatusName

                       , Object_InvoiceKind.Id                               AS InvoiceKindId
                       , Object_InvoiceKind.ValueData                        AS InvoiceKindName
                       , COALESCE (MovementBoolean_Auto.ValueData, FALSE) ::Boolean AS isAuto

                         -- � ���
                       , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END::TFloat AS AmountIn
                       , CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END::TFloat AS AmountOut
                         -- ��� ���
                       , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * zfCalc_Summ_NoVAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END::TFloat AS AmountIn_NotVAT
                       , CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * zfCalc_Summ_NoVAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END::TFloat AS AmountOut_NotVAT
                         -- ���
                       , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * zfCalc_Summ_VAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END::TFloat AS AmountIn_VAT
                       , CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * zfCalc_Summ_VAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END::TFloat AS AmountOut_VAT

                       , MovementFloat_VATPercent.ValueData    ::TFloat      AS VATPercent

                       -- ������
                       , CASE WHEN COALESCE (MovementFloat_Amount.ValueData, 0) > 0 THEN (COALESCE (tmpMLM_BankAccount.AmountIn,0) - COALESCE (tmpMLM_BankAccount.AmountOut,0)) ELSE 0 END ::TFloat AS AmountIn_BankAccount
                       , CASE WHEN COALESCE (MovementFloat_Amount.ValueData, 0) < 0 THEN -1 * (COALESCE (tmpMLM_BankAccount.AmountIn,0) - COALESCE (tmpMLM_BankAccount.AmountOut,0)) ELSE 0 END ::TFloat AS AmountOut_BankAccount
                       , (COALESCE (tmpMLM_BankAccount.AmountIn,0) - COALESCE (tmpMLM_BankAccount.AmountOut,0)) ::TFloat AS Amount_BankAccount

                         -- ������� �� �����
                       , CASE WHEN Object_InvoiceKind.Id = zc_Enum_InvoiceKind_Return()
                                   THEN 0
                              WHEN COALESCE (MovementFloat_Amount.ValueData, 0) > 0
                                   THEN  ((COALESCE (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END,0) - COALESCE (tmpMLM_BankAccount.AmountIn,0))
                                        - (COALESCE (CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END,0) - COALESCE (tmpMLM_BankAccount.AmountOut,0)) )
                              ELSE 0
                         END ::TFloat AS AmountIn_rem

                       , CASE WHEN Object_InvoiceKind.Id = zc_Enum_InvoiceKind_Return()
                                   THEN 0
                              WHEN COALESCE (MovementFloat_Amount.ValueData, 0) < 0
                                   THEN -1 * ((COALESCE (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END,0) - COALESCE (tmpMLM_BankAccount.AmountIn,0))
                                           - (COALESCE (CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END,0) - COALESCE (tmpMLM_BankAccount.AmountOut,0)) )
                              ELSE 0
                         END ::TFloat AS AmountOut_rem

                       , CASE WHEN Object_InvoiceKind.Id = zc_Enum_InvoiceKind_Return()
                                   THEN 0
                              ELSE (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END - COALESCE (tmpMLM_BankAccount.AmountIn, 0))
                                 - (CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END - COALESCE (tmpMLM_BankAccount.AmountOut, 0))
                         END ::TFloat AS Amount_rem

                       , Object_Object.Id                                    AS ObjectId
                       , Object_Object.ValueData                             AS ObjectName
                       , ObjectDesc.ItemName                                 AS DescName
                       , Object_InfoMoney_View.InfoMoneyId
                       , Object_InfoMoney_View.InfoMoneyCode
                       , Object_InfoMoney_View.InfoMoneyName
                       , Object_InfoMoney_View.InfoMoneyName_all

                       , Object_InfoMoney_View.InfoMoneyGroupId
                       , Object_InfoMoney_View.InfoMoneyGroupCode
                       , Object_InfoMoney_View.InfoMoneyGroupName

                       , Object_InfoMoney_View.InfoMoneyDestinationId
                       , Object_InfoMoney_View.InfoMoneyDestinationCode
                       , Object_InfoMoney_View.InfoMoneyDestinationName

                       , Object_PaidKind.Id                         AS PaidKindId
                       , Object_PaidKind.ValueData                  AS PaidKindName
                       , Object_Unit.Id                             AS UnitId
                       , Object_Unit.ValueData                      AS UnitName

                       , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
                       , MovementString_ReceiptNumber.ValueData     AS ReceiptNumber
                       , MovementString_Comment.ValueData           AS Comment

                       , Object_Insert.ValueData                    AS InsertName
                       , MovementDate_Insert.ValueData              AS InsertDate
                       , Object_Update.ValueData                    AS UpdateName
                       , MovementDate_Update.ValueData              AS UpdateDate

                     FROM tmpMovement AS Movement
                         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                         LEFT JOIN tmpMovementFloat AS MovementFloat_Amount
                                                    ON MovementFloat_Amount.MovementId = Movement.Id
                                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

                         LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

                         LEFT JOIN tmpMovementDate AS MovementDate_Plan
                                                   ON MovementDate_Plan.MovementId = Movement.Id
                                                  AND MovementDate_Plan.DescId = zc_MovementDate_Plan()

                         LEFT JOIN tmpMovementBoolean AS MovementBoolean_Auto
                                                      ON MovementBoolean_Auto.MovementId = Movement.Id
                                                     AND MovementBoolean_Auto.DescId = zc_MovementBoolean_Auto()

                         LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                         LEFT JOIN tmpMovementString AS MovementString_ReceiptNumber
                                                     ON MovementString_ReceiptNumber.MovementId = Movement.Id
                                                    AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()

                         LEFT JOIN tmpMovementString AS MovementString_Comment
                                                     ON MovementString_Comment.MovementId = Movement.Id
                                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

                         LEFT JOIN tmpMLO AS MovementLinkObject_InvoiceKind
                                          ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                         AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
                         LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId

                         LEFT JOIN tmpMLO AS MovementLinkObject_Object
                                          ON MovementLinkObject_Object.MovementId = Movement.Id
                                         AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object()
                         LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementLinkObject_Object.ObjectId
                         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

                         LEFT JOIN tmpMLO AS MovementLinkObject_InfoMoney
                                          ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
                                         AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
                         LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId

                         /*LEFT JOIN tmpMLO AS MovementLinkObject_Product
                                          ON MovementLinkObject_Product.MovementId = Movement.Id
                                         AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                         LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId*/


                         LEFT JOIN tmpMLO AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

                         LEFT JOIN tmpMLO AS MovementLinkObject_PaidKind
                                          ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                         AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

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

                         -- ������ �� ��������� BankAccount
                         LEFT JOIN tmpMLM_BankAccount ON tmpMLM_BankAccount.MovementId_Invoice = Movement.Id
                        )
    -- ���������
    SELECT
        tmpData.Id
      , tmpData.MovementId_parent
      , tmpData.InvNumber
      , tmpData.InvNumber_Full
      , tmpData.OperDate
      , tmpData.PlanDate
      , tmpData.StatusCode
      , tmpData.StatusName
      , tmpData.InvoiceKindId
      , tmpData.InvoiceKindName
      , tmpData.isAuto
        -- � ���
      , (tmpData.AmountIn - tmpData.AmountOut) :: TFloat AS Amount
        -- ��� ���
      , tmpData.AmountIn_NotVAT
      , tmpData.AmountOut_NotVAT
        -- ���
      , tmpData.AmountIn_VAT
      , tmpData.AmountOut_VAT

      , tmpData.VATPercent

      -- ������
      , tmpData.AmountIn_BankAccount
      , tmpData.AmountOut_BankAccount
      , tmpData.Amount_BankAccount
      -- ������� �� �����
      , tmpData.AmountIn_rem
      , tmpData.AmountOut_rem
      , tmpData.Amount_rem

      , tmpData.ObjectId
      , tmpData.ObjectName
      , tmpData.DescName
      , tmpData.InfoMoneyId
      , tmpData.InfoMoneyCode
      , tmpData.InfoMoneyName
      , tmpData.InfoMoneyName_all

      , tmpData.InfoMoneyGroupId
      , tmpData.InfoMoneyGroupCode
      , tmpData.InfoMoneyGroupName

      , tmpData.InfoMoneyDestinationId
      , tmpData.InfoMoneyDestinationCode
      , tmpData.InfoMoneyDestinationName

      , tmpData.PaidKindId
      , tmpData.PaidKindName
      , tmpData.UnitId
      , tmpData.UnitName

      , tmpData.InvNumberPartner
      , zfConvert_StringToNumber (tmpData.ReceiptNumber) AS ReceiptNumber
      , tmpData.Comment

      , tmpData.InsertName
      , tmpData.InsertDate
      , tmpData.UpdateName
      , tmpData.UpdateDate

        -- ���������� ���� ���� �� ������� + ���������� ������� - ���� ������ ������ ��� ����� ����� + �������� ������ - � ����� ����� �������� ��� ������ ��� ����� �����
      , CASE WHEN tmpData.InvoiceKindId = zc_Enum_InvoiceKind_Return()
             THEN zc_Color_Black()

             WHEN (CASE WHEN COALESCE (tmpData.AmountIn,0)  <> 0 THEN tmpData.AmountIn  ELSE 0 END > COALESCE (tmpData.AmountIn_BankAccount,0)) -- AND COALESCE (tmpData.AmountIn_BankAccount,0)<>0
               OR (CASE WHEN COALESCE (tmpData.AmountOut,0) <> 0 THEN tmpData.AmountOut ELSE 0 END > COALESCE (tmpData.AmountOut_BankAccount,0)) -- AND COALESCE (tmpData.AmountOut_BankAccount,0)<>0
             THEN zc_Color_Blue()

             WHEN (CASE WHEN COALESCE (tmpData.AmountIn,0)  <> 0 THEN tmpData.AmountIn  ELSE 0 END < COALESCE (tmpData.AmountIn_BankAccount,0)) -- AND COALESCE (tmpData.AmountIn_BankAccount,0)<>0
               OR (CASE WHEN COALESCE (tmpData.AmountOut,0) <> 0 THEN tmpData.AmountOut ELSE 0 END < COALESCE (tmpData.AmountOut_BankAccount,0)) -- AND COALESCE (tmpData.AmountOut_BankAccount,0)<>0
             THEN zc_Color_Red()

             ELSE zc_Color_Black()

        END ::Integer AS Color_Pay
    FROM tmpData

;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.06.23         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_InvoiceByProduct (inProductId:= 253191, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
