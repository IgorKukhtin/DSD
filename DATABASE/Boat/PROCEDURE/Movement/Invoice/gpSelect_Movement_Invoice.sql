-- Function: gpSelect_Movement_Invoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_InvoiceChoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inClientId      Integer ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id               Integer
             , InvNumber        Integer
             , InvNumber_Full   TVarChar
             , OperDate         TDateTime
             , PlanDate         TDateTime
             , StatusCode       Integer
             , StatusName       TVarChar
             , InvoiceKindId    Integer
             , InvoiceKindName  TVarChar
             , isAuto           Boolean
               -- � ���
             , AmountIn         TFloat
             , AmountIn_real    TFloat
             , AmountOut        TFloat
               -- ��� ���
             , AmountIn_NotVAT  TFloat
             , AmountOut_NotVAT TFloat
               -- ����� ���
             , AmountIn_VAT     TFloat
             , AmountOut_VAT    TFloat

               -- ����� ����� (��� ������ � �����)
             , Amount_Invoice   TFloat

               -- % ���
             , VATPercent       TFloat

               -- ������
             , AmountIn_BankAccount  TFloat
             , AmountOut_BankAccount TFloat
               -- ����� ������
             , Amount_BankAccount    TFloat
               -- ������� �� �����
             , AmountIn_rem          TFloat
             , AmountOut_rem         TFloat
             , Amount_rem            TFloat

             , ObjectId        Integer
             , ObjectName      TVarChar
             , ObjectDescName  TVarChar
             , TaxKindName     TVarChar
             , TaxKindName_info TVarChar
             , TaxKindName_Comment TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , ProductId Integer, ProductCode Integer, ProductName TVarChar, ProductCIN TVarChar, Comment_Product TVarChar
             , PaidKindId      Integer
             , PaidKindName    TVarChar
             , UnitId          Integer
             , UnitName        TVarChar

               -- ����� ��������� - External Nr
             , InvNumberPartner TVarChar
               -- ����������� ����� ��������� - Quittung Nr
             , ReceiptNumber    Integer
               --
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime

             , MovementId_parent Integer
             , InvNumberFull_parent TVarChar, InvNumber_parent TVarChar
             , MovementDescName_parent TVarChar
             , isFilesNotUploaded Boolean, isPostedToDropBox Boolean
             , DateUnloading TDateTime

             , Color_Pay Integer
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbProductId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!�������� ������!!!
     IF inEndDate < CURRENT_DATE THEN inEndDate:= CURRENT_DATE; END IF;


     -- ���������
     RETURN QUERY
       WITH
       tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
               UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
               UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                    )

     , tmpMovement AS (SELECT Movement.*
                      FROM tmpStatus
                           INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                                              AND Movement.DescId = zc_Movement_Invoice()
                                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                      )
     , tmpMovementFloat AS (SELECT MovementFloat.*
                            FROM MovementFloat
                            WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                              AND MovementFloat.DescId IN (zc_MovementFloat_Amount()
                                                         , zc_MovementFloat_VATPercent())
                            )

     , tmpMovementDate AS (SELECT MovementDate.*
                           FROM MovementDate
                           WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                             AND MovementDate.DescId = zc_MovementDate_Plan()
                           )

     , tmpMovementString AS (SELECT MovementString.*
                             FROM MovementString
                             WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                               AND MovementString.DescId IN (zc_MovementString_InvNumberPartner()
                                                           , zc_MovementString_ReceiptNumber()
                                                           , zc_MovementString_Comment()
                                                             )
                           )

     , tmpMovementBoolean AS (SELECT MovementBoolean.*
                              FROM MovementBoolean
                              WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementBoolean.DescId IN (zc_MovementBoolean_Auto(), zc_MovementBoolean_FilesNotUploaded(), zc_MovementBoolean_PostedToDropBox())
                             )

     , tmpMLO AS (SELECT MovementLinkObject.*
                  FROM MovementLinkObject
                  WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                    AND MovementLinkObject.DescId IN ( zc_MovementLinkObject_Object()
                                                     , zc_MovementLinkObject_Unit()
                                                     , zc_MovementLinkObject_InfoMoney()
                                                     --, zc_MovementLinkObject_Product()
                                                     , zc_MovementLinkObject_PaidKind()
                                                     , zc_MovementLinkObject_InvoiceKind()
                                                     , zc_MovementLinkObject_TaxKind()
                                                      )
                  )
       -- ��� ���������, � ������� ������ ���� ����, ������� ������
     , tmpMLM AS (SELECT *
                  FROM (SELECT MovementLinkMovement.*
                             , ROW_NUMBER() OVER (PARTITION BY MovementLinkMovement.MovementChildId ORDER BY Movement.Id) AS ord
                        FROM MovementLinkMovement
                            INNER JOIN Movement ON Movement.Id       = MovementLinkMovement.MovementId
                                               AND Movement.StatusId <> zc_Enum_Status_Erased()
                                               AND Movement.DescId   IN (zc_Movement_Income(), zc_Movement_OrderClient())
                        WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                       ) AS tmp
                  WHERE tmp.Ord = 1
                 )

       -- ����� ��� ������
     , tmpMLM_BankAccount AS (SELECT tmp.MovementId_Invoice :: Integer AS MovementId_Invoice
                                   , SUM (CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount      ELSE 0 END) ::TFloat AS AmountIn
                                   , SUM (CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END) ::TFloat AS AmountOut
                              FROM (SELECT DISTINCT tmpMovement.Id :: TFloat AS MovementId_invoice FROM tmpMovement) AS tmp
                                   INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                ON MIFloat_MovementId.ValueData = tmp.MovementId_Invoice
                                                               AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                                   INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                          AND MovementItem.DescId   = zc_MI_Child()
                                                          AND MovementItem.isErased = FALSE
                                   INNER JOIN Movement AS Movement_BankAccount ON Movement_BankAccount.Id       = MovementItem.MovementId
                                                                              AND Movement_BankAccount.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                                                                              AND Movement_BankAccount.DescId   = zc_Movement_BankAccount()
                              GROUP BY tmp.MovementId_Invoice
                             )
    --
    , tmpData AS (SELECT
                         Movement.Id
                       , zfConvert_StringToNumber (Movement.InvNumber) ::Integer AS InvNumber
                       , zfCalc_InvNumber_two_isErased ('', Movement.InvNumber, MovementString_ReceiptNumber.ValueData, Movement.OperDate, Movement.StatusId) AS InvNumber_Full
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
                       , CASE WHEN COALESCE (MovementFloat_Amount.ValueData, 0) > 0
                         THEN  ((COALESCE (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END,0) - COALESCE (tmpMLM_BankAccount.AmountIn,0))
                              - (COALESCE (CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END,0) - COALESCE (tmpMLM_BankAccount.AmountOut,0)) )
                         ELSE 0 END ::TFloat AS AmountIn_rem
                       , CASE WHEN COALESCE (MovementFloat_Amount.ValueData, 0) < 0
                         THEN -1 * ((COALESCE (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END,0) - COALESCE (tmpMLM_BankAccount.AmountIn,0))
                                 - (COALESCE (CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END,0) - COALESCE (tmpMLM_BankAccount.AmountOut,0)) )
                         ELSE 0 END ::TFloat AS AmountOut_rem

                       , ((COALESCE (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END,0) - COALESCE (tmpMLM_BankAccount.AmountIn,0))
                        - (COALESCE (CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END,0) - COALESCE (tmpMLM_BankAccount.AmountOut,0)) ) ::TFloat AS Amount_rem

                       , Object_Object.Id                                    AS ObjectId
                       , Object_Object.ValueData                             AS ObjectName
                       , ObjectDesc.ItemName                                 AS DescName
                       , Object_InfoMoney_View.InfoMoneyId
                       , Object_InfoMoney_View.InfoMoneyCode
                       , Object_InfoMoney_View.InfoMoneyName
                       , Object_InfoMoney_View.InfoMoneyName AS InfoMoneyName_all
                     --, Object_InfoMoney_View.InfoMoneyName_all

                       , Object_InfoMoney_View.InfoMoneyGroupId
                       , Object_InfoMoney_View.InfoMoneyGroupCode
                       , Object_InfoMoney_View.InfoMoneyGroupName

                       , Object_InfoMoney_View.InfoMoneyDestinationId
                       , Object_InfoMoney_View.InfoMoneyDestinationCode
                       , Object_InfoMoney_View.InfoMoneyDestinationName
                       , Object_Product.Id                          AS ProductId
                       , Object_Product.ObjectCode                  AS ProductCode
                       , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)   AS ProductName
                       , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS ProductCIN
                       , ObjectString_Product_Comment.ValueData     AS Comment_Product

                       , Object_PaidKind.Id                         AS PaidKindId
                       , Object_PaidKind.ValueData                  AS PaidKindName
                       , Object_Unit.Id                             AS UnitId
                       , Object_Unit.ValueData                      AS UnitName

                       , Object_TaxKind.Id                          AS TaxKindId
                       , Object_TaxKind.ValueData                   AS TaxKindName

                       , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
                       , MovementString_ReceiptNumber.ValueData     AS ReceiptNumber
                       , MovementString_Comment.ValueData           AS Comment

                       , Object_Insert.ValueData                    AS InsertName
                       , MovementDate_Insert.ValueData              AS InsertDate
                       , Object_Update.ValueData                    AS UpdateName
                       , MovementDate_Update.ValueData              AS UpdateDate

                       , Movement_Parent.Id                         AS MovementId_parent
                       , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumberFull_parent
                       , Movement_Parent.InvNumber                  AS InvNumber_parent
                       , MovementDesc_Parent.ItemName               AS DescName_parent

                       , COALESCE (MovementBoolean_FilesNotUploaded.ValueData, FALSE) ::Boolean AS isFilesNotUploaded
                       , COALESCE (MovementBoolean_PostedToDropBox.ValueData, FALSE)  ::Boolean AS isPostedToDropBox

                       -- ���������� ���� ���� �� ������� + ���������� ������� - ���� ������ ������ ��� ����� ����� + �������� ������ - � ����� ����� �������� ��� ������ ��� ����� �����
                       /*, CASE WHEN (COALESCE (CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END,0) > COALESCE (tmpMLM_BankAccount.AmountOut,0)) AND COALESCE (tmpMLM_BankAccount.AmountOut,0)<>0
                                OR (COALESCE (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END,0) > COALESCE (tmpMLM_BankAccount.AmountIn,0))  AND COALESCE (tmpMLM_BankAccount.AmountIn,0)<>0
                              THEN zc_Color_Blue()
                              WHEN (COALESCE (CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END,0) < COALESCE (tmpMLM_BankAccount.AmountOut,0)) AND COALESCE (tmpMLM_BankAccount.AmountOut,0)<>0
                                OR (COALESCE (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END,0) < COALESCE (tmpMLM_BankAccount.AmountIn,0))  AND COALESCE (tmpMLM_BankAccount.AmountIn,0)<>0
                              THEN zc_Color_Red()
                              ELSE zc_Color_Black()
                         END ::Integer AS Color_Pay*/
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

                         LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                         LEFT JOIN tmpMovementString AS MovementString_ReceiptNumber
                                                     ON MovementString_ReceiptNumber.MovementId = Movement.Id
                                                    AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()

                         LEFT JOIN tmpMovementString AS MovementString_Comment
                                                     ON MovementString_Comment.MovementId = Movement.Id
                                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

                         LEFT JOIN tmpMovementBoolean AS MovementBoolean_Auto
                                                      ON MovementBoolean_Auto.MovementId = Movement.Id
                                                     AND MovementBoolean_Auto.DescId = zc_MovementBoolean_Auto()

                         LEFT JOIN tmpMovementBoolean AS MovementBoolean_FilesNotUploaded
                                                      ON MovementBoolean_FilesNotUploaded.MovementId = Movement.Id
                                                     AND MovementBoolean_FilesNotUploaded.DescId = zc_MovementBoolean_FilesNotUploaded()
                         LEFT JOIN tmpMovementBoolean AS MovementBoolean_PostedToDropBox
                                                      ON MovementBoolean_PostedToDropBox.MovementId = Movement.Id
                                                     AND MovementBoolean_PostedToDropBox.DescId = zc_MovementBoolean_PostedToDropBox()

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

                         LEFT JOIN tmpMLO AS MovementLinkObject_InvoiceKind
                                          ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                         AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
                         LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId

                         LEFT JOIN tmpMLO AS MovementLinkObject_TaxKind
                                                      ON MovementLinkObject_TaxKind.MovementId = Movement.Id
                                                     AND MovementLinkObject_TaxKind.DescId = zc_MovementLinkObject_TaxKind()
                         LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_TaxKind.ObjectId

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


                         -- Parent - ���� "�����"
                         LEFT JOIN tmpMLM AS MovementLinkMovement_Invoice
                                          ON MovementLinkMovement_Invoice.MovementChildId = Movement.Id
                                         AND MovementLinkMovement_Invoice.DescId          = zc_MovementLinkMovement_Invoice()
                         -- Parent - ���� ������
                         LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = COALESCE (Movement.ParentId, MovementLinkMovement_Invoice.MovementId)
                         LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId

                         -- ����� ���������� �� ���. Movement_Parent
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                      ON MovementLinkObject_Product.MovementId = Movement_Parent.Id
                                                     AND MovementLinkObject_Product.DescId     = zc_MovementLinkObject_Product()
                         LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId
                         LEFT JOIN ObjectString AS ObjectString_CIN
                                                ON ObjectString_CIN.ObjectId = Object_Product.Id
                                               AND ObjectString_CIN.DescId   = zc_ObjectString_Product_CIN()
                         LEFT JOIN ObjectString AS ObjectString_Product_Comment
                                                ON ObjectString_Product_Comment.ObjectId = Object_Product.Id
                                               AND ObjectString_Product_Comment.DescId   = zc_ObjectString_Product_Comment()

                         -- ������ �� ��������� BankAccount
                         LEFT JOIN tmpMLM_BankAccount ON tmpMLM_BankAccount.MovementId_Invoice = Movement.Id

                     WHERE Object_Object.Id = inClientId
                        OR inClientId = 0
                 )
    , tmpDateUnloading AS (SELECT tmpData.Id
                                , MAX(ObjectDate_DateUnloading.ValueData)::TDateTime  AS DateUnloading
                                , MAX(CASE WHEN ObjectDate_DateUnloading.ValueData IS NULL THEN 1 ELSE 0 END) = 1 AS isNotSend
                           FROM tmpData

                                INNER JOIN ObjectFloat AS ObjectFloat_InvoicePdf_MovmentId
                                                       ON ObjectFloat_InvoicePdf_MovmentId.ValueData = tmpData.Id
                                                      AND ObjectFloat_InvoicePdf_MovmentId.DescId = zc_ObjectFloat_InvoicePdf_MovementId()

                                LEFT JOIN ObjectDate AS ObjectDate_DateUnloading
                                                     ON ObjectDate_DateUnloading.ObjectId = ObjectFloat_InvoicePdf_MovmentId.ObjectId
                                                    AND ObjectDate_DateUnloading.DescId = zc_ObjectDate_InvoicePdf_DateUnloading()

                           GROUP BY tmpData.Id
                           )
      , tmpSummProduct AS (SELECT  -- ����� ��� ������, ���� ������� ������� ������ �����, ��� ���
                                   gpSelect.MovementId_OrderClient
                                   -- 4. Total LP - ����� ����� ������� ��� ��� - �� ����� �������� (Basis+options) + TRANSPORT
                                 , gpSelect.Basis_summ_transport
                                   -- 5. Total LP + Vat - ����� ����� ������� � ��� - �� ����� �������� (Basis+options) + TRANSPORT
                                 , gpSelect.BasisWVAT_summ_transport

                           FROM gpSelect_Object_Product (0, FALSE, FALSE, '') AS gpSelect
                          )

    -- ���������
    SELECT
        tmpData.Id
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
      , CASE WHEN tmpSummProduct.MovementId_OrderClient  > 0
              AND tmpData.AmountIn > 0
                  -- ������ - ������ �����
                  THEN tmpSummProduct.BasisWVAT_summ_transport
              ELSE tmpData.AmountIn
        END :: TFloat AS AmountIn

      , tmpData.AmountIn AS AmountIn_real
      , tmpData.AmountOut

        -- ��� ���
      , CASE WHEN tmpSummProduct.MovementId_OrderClient  > 0
              AND tmpData.AmountIn > 0
              THEN tmpSummProduct.Basis_summ_transport
              ELSE tmpData.AmountIn_NotVAT
        END :: TFloat AS AmountIn_NotVAT
      , tmpData.AmountOut_NotVAT

        -- ����� ���
      , CASE WHEN tmpSummProduct.MovementId_OrderClient  > 0
              AND tmpData.AmountIn > 0
              THEN tmpSummProduct.BasisWVAT_summ_transport - tmpSummProduct.Basis_summ_transport
              ELSE tmpData.AmountIn_VAT
        END :: TFloat AS AmountIn_VAT
      , tmpData.AmountOut_VAT

        -- ����� ����� (��� ������ � �����)
      , CASE WHEN tmpData.AmountIn > 0 THEN tmpData.AmountIn ELSE tmpData.AmountOut END :: TFloat AS Amount_Invoice

        -- % ���
      , tmpData.VATPercent

        -- ������
      , tmpData.AmountIn_BankAccount
      , tmpData.AmountOut_BankAccount
      , tmpData.Amount_BankAccount
        -- ������� �� �����
      , CASE WHEN tmpData.InvoiceKindId IN (zc_Enum_InvoiceKind_Return(), zc_Enum_InvoiceKind_ReturnPay())
                  THEN 0
             ELSE tmpData.AmountIn_rem
        END :: TFloat AS AmountIn_rem
      , CASE WHEN tmpData.InvoiceKindId IN (zc_Enum_InvoiceKind_Return(), zc_Enum_InvoiceKind_ReturnPay())
                  THEN 0
             ELSE tmpData.AmountOut_rem
        END :: TFloat AS AmountOut_rem
      , CASE WHEN tmpData.InvoiceKindId IN (zc_Enum_InvoiceKind_Return(), zc_Enum_InvoiceKind_ReturnPay())
                  THEN 0
             ELSE tmpData.Amount_rem
        END :: TFloat AS Amount_rem

      , tmpData.ObjectId
      , tmpData.ObjectName
      , tmpData.DescName
      --, tmpData.TaxKindId
      , tmpData.TaxKindName   ::TVarChar
      --, Object_TaxKind.ValueData            AS TaxKindName
      , ObjectString_TaxKind_Info.ValueData AS TaxKindName_info
      , ObjectString_TaxKind_Comment.ValueData AS TaxKindName_Comment

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
      , tmpData.ProductId
      , tmpData.ProductCode
      , tmpData.ProductName
      , tmpData.ProductCIN
      , tmpData.Comment_Product

      , tmpData.PaidKindId
      , tmpData.PaidKindName
      , tmpData.UnitId
      , tmpData.UnitName

      , tmpData.InvNumberPartner
      , zfConvert_StringToNumber_null (tmpData.ReceiptNumber) AS ReceiptNumber
      , tmpData.Comment

      , tmpData.InsertName
      , tmpData.InsertDate
      , tmpData.UpdateName
      , tmpData.UpdateDate

      , tmpData.MovementId_parent
      , tmpData.InvNumberFull_parent
      , tmpData.InvNumber_parent
      , tmpData.DescName_parent
      , tmpData.isFilesNotUploaded
      , (tmpData.isPostedToDropBox AND NOT tmpData.isFilesNotUploaded AND COALESCE(tmpDateUnloading.Id, 0) <> 0) AND
        (COALESCE(tmpData.AmountIn, 0) <> 0 OR COALESCE(tmpData.AmountOut, 0) <> 0) AND
        COALESCE(tmpDateUnloading.isNotSend, FALSE) = FALSE AS isPostedToDropBox
      , tmpDateUnloading.DateUnloading

        -- ���������� ���� ���� �� ������� + ���������� ������� - ���� ������ ������ ��� ����� ����� + �������� ������ - � ����� ����� �������� ��� ������ ��� ����� �����
      , CASE WHEN tmpData.InvoiceKindId IN (zc_Enum_InvoiceKind_Return(), zc_Enum_InvoiceKind_ReturnPay())
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
        LEFT JOIN tmpSummProduct ON tmpSummProduct.MovementId_OrderClient = tmpData.MovementId_parent
                                AND tmpData.InvoiceKindId = zc_Enum_InvoiceKind_Pay()

        LEFT JOIN ObjectString AS ObjectString_TaxKind_Info
                               ON ObjectString_TaxKind_Info.ObjectId = tmpData.TaxKindId
                              AND ObjectString_TaxKind_Info.DescId = zc_ObjectString_TaxKind_Info()

        LEFT JOIN ObjectString AS ObjectString_TaxKind_Comment
                               ON ObjectString_TaxKind_Comment.ObjectId =  tmpData.TaxKindId
                              AND ObjectString_TaxKind_Comment.DescId = zc_ObjectString_TaxKind_Comment()

        LEFT JOIN tmpDateUnloading ON tmpDateUnloading.Id = tmpData.Id

-- where vbUserId <> 5 or tmpData.Id = 6187
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.04.24         *
 06.12.23         *
 02.02.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Invoice (inStartDate:= '01.01.2021', inEndDate:= '18.02.2025', inClientId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
