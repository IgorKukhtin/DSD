-- Function: gpSelect_Movement_Invoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_InvoiceChoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inClientId      Integer ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id              Integer
             , InvNumber       TVarChar
             , InvNumber_Full  TVarChar
             , OperDate        TDateTime
             , PlanDate        TDateTime
             , StatusCode      Integer
             , StatusName      TVarChar
             , AmountIn         TFloat
             , AmountOut        TFloat
             , AmountIn_NotVAT  TFloat
             , AmountOut_NotVAT TFloat
             , AmountIn_VAT     TFloat
             , AmountOut_VAT    TFloat
             , VATPercent      TFloat             

             -- оплата
             , AmountIn_BankAccount  TFloat
             , AmountOut_BankAccount TFloat
             , Amount_BankAccount    TFloat --итого оплата
             -- остаток по счету
             , AmountIn_rem  TFloat
             , AmountOut_rem TFloat
             , Amount_rem    TFloat

             , ObjectId        Integer
             , ObjectName      TVarChar
             , DescName        TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , ProductId Integer, ProductCode Integer, ProductName TVarChar, ProductCIN TVarChar
             , PaidKindId      Integer
             , PaidKindName    TVarChar
             , UnitId          Integer
             , UnitName        TVarChar

             , InvNumberPartner TVarChar
             , ReceiptNumber    TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             
             , MovementId_parent Integer
             , InvNumber_parent TVarChar
             , DescName_parent TVarChar
      
             , Color_Pay Integer
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbProductId Integer;   
BEGIN

     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
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

     , tmpMLO AS (SELECT MovementLinkObject.*
                  FROM MovementLinkObject
                  WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                    AND MovementLinkObject.DescId IN ( zc_MovementLinkObject_Object()
                                                     , zc_MovementLinkObject_Unit()
                                                     , zc_MovementLinkObject_InfoMoney()
                                                     --, zc_MovementLinkObject_Product()
                                                     , zc_MovementLinkObject_PaidKind()
                                                      )
                  )

     , tmpMLM_OrderClient AS (SELECT *
                              FROM (
                                    SELECT MovementLinkMovement.*
                                         , ROW_NUMBER() OVER (PARTITION BY MovementLinkMovement.MovementChildId) AS ord
                                    FROM MovementLinkMovement
                                        INNER JOIN Movement AS Movement_Order
                                                            ON Movement_Order.Id = MovementLinkMovement.MovementId
                                                           AND Movement_Order.StatusId <> zc_Enum_Status_Erased()
                                                           AND Movement_Order.DescId = zc_Movement_OrderClient()
                                    WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                      AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                                    ) AS tmp
                              WHERE tmp.Ord = 1
                              )

     , tmpMLM_BankAccount AS (SELECT MovementLinkMovement.MovementChildId
                                   , SUM (CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount      ELSE 0 END) ::TFloat AS AmountIn
                                   , SUM (CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END) ::TFloat AS AmountOut
                              FROM MovementLinkMovement
                                  INNER JOIN Movement AS Movement_BankAccount
                                                      ON Movement_BankAccount.Id = MovementLinkMovement.MovementId
                                                     AND Movement_BankAccount.StatusId = zc_Enum_Status_Complete()   ---<> zc_Enum_Status_Erased()
                                                     AND Movement_BankAccount.DescId = zc_Movement_BankAccount()
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement_BankAccount.Id
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND MovementItem.isErased = FALSE
                                                         AND COALESCE (MovementItem.Amount,0) <> 0
                              WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                              GROUP BY MovementLinkMovement.MovementChildId
                              )

    --
    , tmpData AS (SELECT     
                         Movement.Id
                       , Movement.InvNumber
                       , ('№ ' || Movement.InvNumber || ' от ' || zfConvert_DateToString (Movement.OperDate):: TVarChar ) :: TVarChar  AS InvNumber_Full
                       , Movement.OperDate
                       , MovementDate_Plan.ValueData         :: TDateTime    AS PlanDate
                       , Object_Status.ObjectCode                            AS StatusCode
                       , Object_Status.ValueData                             AS StatusName
                 
                         -- с НДС
                       , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END::TFloat AS AmountIn
                       , CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END::TFloat AS AmountOut
                         -- без НДС
                       , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * zfCalc_Summ_NoVAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END::TFloat AS AmountIn_NotVAT
                       , CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * zfCalc_Summ_NoVAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END::TFloat AS AmountOut_NotVAT
                         -- НДС
                       , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * zfCalc_Summ_VAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END::TFloat AS AmountIn_VAT
                       , CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * zfCalc_Summ_VAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END::TFloat AS AmountOut_VAT
                 
                       , MovementFloat_VATPercent.ValueData    ::TFloat      AS VATPercent
                 
                       -- оплата
                       , CASE WHEN COALESCE (MovementFloat_Amount.ValueData, 0) > 0 THEN (COALESCE (tmpMLM_BankAccount.AmountIn,0) - COALESCE (tmpMLM_BankAccount.AmountOut,0)) ELSE 0 END ::TFloat AS AmountIn_BankAccount
                       , CASE WHEN COALESCE (MovementFloat_Amount.ValueData, 0) < 0 THEN -1 * (COALESCE (tmpMLM_BankAccount.AmountIn,0) - COALESCE (tmpMLM_BankAccount.AmountOut,0)) ELSE 0 END ::TFloat AS AmountOut_BankAccount
                       , (COALESCE (tmpMLM_BankAccount.AmountIn,0) - COALESCE (tmpMLM_BankAccount.AmountOut,0)) ::TFloat AS Amount_BankAccount
                       -- остаток по счету
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
                       , Object_InfoMoney_View.InfoMoneyName_all
                 
                       , Object_InfoMoney_View.InfoMoneyGroupId
                       , Object_InfoMoney_View.InfoMoneyGroupCode
                       , Object_InfoMoney_View.InfoMoneyGroupName
                 
                       , Object_InfoMoney_View.InfoMoneyDestinationId
                       , Object_InfoMoney_View.InfoMoneyDestinationCode
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
                 
                       , Object_Insert.ValueData                    AS InsertName
                       , MovementDate_Insert.ValueData              AS InsertDate
                       , Object_Update.ValueData                    AS UpdateName
                       , MovementDate_Update.ValueData              AS UpdateDate
                 
                       , Movement_Parent.Id             ::Integer  AS MovementId_parent
                       , ('№ ' || Movement_Parent.InvNumber || ' от ' || Movement_Parent.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_parent
                       , MovementDesc_Parent.ItemName   ::TVarChar  AS DescName_parent
                 
                       -- подсветить если счет не оплачен + подсветить красным - если оплата больше чем сумма счета + добавить кнопку - в новой форме показать все оплаты для этого счета
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
                 
                         --Лодку показываем из док. Заказ
                         LEFT JOIN tmpMLM_OrderClient AS MovementLinkMovement_Invoice
                                                      ON MovementLinkMovement_Invoice.MovementChildId = Movement.Id
                                                    -- AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                         
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                      ON MovementLinkObject_Product.MovementId = COALESCE (Movement.ParentId, MovementLinkMovement_Invoice.MovementId)
                                                     AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                         LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId
                 
                         LEFT JOIN ObjectString AS ObjectString_CIN
                                                ON ObjectString_CIN.ObjectId = Object_Product.Id
                                               AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
                 
                         --Parent Документ Заказ или ПРиход
                         LEFT JOIN Movement AS Movement_Parent
                                            ON Movement_Parent.Id = Movement.ParentId
                                           AND Movement_Parent.StatusId <> zc_Enum_Status_Erased()
                         LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId
                 
                         -- оплаты из документа BankAccount
                         LEFT JOIN tmpMLM_BankAccount ON tmpMLM_BankAccount.MovementChildId = Movement.Id
                     WHERE Object_Object.Id = inClientId 
                        OR inClientId = 0
                                   )
    -- Результат
    SELECT     
        tmpData.Id
      , tmpData.InvNumber
      , tmpData.InvNumber_Full
      , tmpData.OperDate
      , tmpData.PlanDate
      , tmpData.StatusCode
      , tmpData.StatusName
        -- с НДС
      , tmpData.AmountIn
      , tmpData.AmountOut
        -- без НДС
      , tmpData.AmountIn_NotVAT
      , tmpData.AmountOut_NotVAT
        -- НДС
      , tmpData.AmountIn_VAT
      , tmpData.AmountOut_VAT

      , tmpData.VATPercent

      -- оплата
      , tmpData.AmountIn_BankAccount
      , tmpData.AmountOut_BankAccount
      , tmpData.Amount_BankAccount
      -- остаток по счету
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
      , tmpData.ProductId
      , tmpData.ProductCode
      , tmpData.ProductName
      , tmpData.ProductCIN
      , tmpData.PaidKindId
      , tmpData.PaidKindName
      , tmpData.UnitId
      , tmpData.UnitName

      , tmpData.InvNumberPartner
      , tmpData.ReceiptNumber
      , tmpData.Comment

      , tmpData.InsertName
      , tmpData.InsertDate
      , tmpData.UpdateName
      , tmpData.UpdateDate

      , tmpData.MovementId_parent
      , tmpData.InvNumber_parent
      , tmpData.DescName_parent

      -- подсветить если счет не оплачен + подсветить красным - если оплата больше чем сумма счета + добавить кнопку - в новой форме показать все оплаты для этого счета
      , CASE WHEN (CASE WHEN COALESCE (tmpData.AmountIn,0)  <> 0 THEN tmpData.AmountIn  ELSE 0 END > COALESCE (tmpData.AmountIn_BankAccount,0)) AND COALESCE (tmpData.AmountIn_BankAccount,0)<>0
               OR (CASE WHEN COALESCE (tmpData.AmountOut,0) <> 0 THEN tmpData.AmountOut ELSE 0 END > COALESCE (tmpData.AmountIn_BankAccount,0)) AND COALESCE (tmpData.AmountOut_BankAccount,0)<>0
             THEN zc_Color_Blue()
             WHEN (CASE WHEN COALESCE (tmpData.AmountIn,0)  <> 0 THEN tmpData.AmountIn  ELSE 0 END < COALESCE (tmpData.AmountIn_BankAccount,0)) AND COALESCE (tmpData.AmountIn_BankAccount,0)<>0
               OR (CASE WHEN COALESCE (tmpData.AmountOut,0) <> 0 THEN tmpData.AmountOut ELSE 0 END < COALESCE (tmpData.AmountIn_BankAccount,0)) AND COALESCE (tmpData.AmountOut_BankAccount,0)<>0
             THEN zc_Color_Red()
             ELSE zc_Color_Black()
        END ::Integer AS Color_Pay
    FROM tmpData

;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.21         *
*/

-- тест
-- select * from gpSelect_Movement_Invoice(inStartDate := ('01.01.2021')::TDateTime , inEndDate := ('18.02.2021')::TDateTime , inClientId:=0, inIsErased := 'False' ,  inSession := zfCalc_UserAdmin());