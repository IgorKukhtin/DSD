-- Function: gpSelect_Movement_Invoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_InvoiceOrderChoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_InvoiceOrderChoice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inCliendId      Integer ,
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
                            , MovementLinkObject_Object.ObjectId AS ObjectId
                      FROM tmpStatus
                           INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                                              AND Movement.DescId = zc_Movement_Invoice()
                                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Object
                                                         ON MovementLinkObject_Object.MovementId = Movement.Id
                                                        AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object()
                                                        AND (MovementLinkObject_Object.ObjectId = inCliendId OR inCliendId = 0)
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
     --Лодку показываем из док. Заказ
     , tmpMLM AS (SELECT *
                  FROM (SELECT MovementLinkMovement.*
                             , ROW_NUMBER() OVER (PARTITION BY MovementLinkMovement.MovementId) AS ord
                        FROM MovementLinkMovement
                             INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                                AND Movement.DescId = zc_Movement_OrderClient()
                        WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                         ) AS tmp
                  WHERE tmp.Ord = 1
                  )

     -- док Заказа без счетов
     , tmpMovement_OrderClient AS (SELECT Movement_OrderClient.Id
                                        , Movement_OrderClient.DescId
                                        , Movement_OrderClient.InvNumber
                                        , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                                        , Movement_OrderClient.OperDate             AS OperDate
                                        , Movement_OrderClient.StatusId             AS StatusId
                                        , MovementLinkObject_From.ObjectId          AS FromId
                                        , MovementLinkObject_To.ObjectId            AS ToId
                                        , MovementLinkObject_PaidKind.ObjectId      AS PaidKindId
                                        , MovementLinkObject_Product.ObjectId       AS ProductId
                                   FROM Movement AS Movement_OrderClient 
                                        INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                      ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                     AND (MovementLinkObject_From.ObjectId = inCliendId OR inCliendId = 0)
    
                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                     ON MovementLinkObject_To.MovementId = Movement_OrderClient.Id
                                                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                        LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                                                       ON MovementLinkMovement_Invoice.MovementId = Movement_OrderClient.Id
                                                                      AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
    
                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                     ON MovementLinkObject_PaidKind.MovementId = Movement_OrderClient.Id
                                                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
    
                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                     ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                                                    AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
    
                                        LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                                 ON MovementString_InvNumberPartner.MovementId = Movement_OrderClient.Id
                                                                AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                                   WHERE Movement_OrderClient.StatusId <> zc_Enum_Status_Erased()
                                     AND Movement_OrderClient.OperDate BETWEEN inStartDate AND inEndDate
                                     AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
                                     AND COALESCE (MovementLinkMovement_Invoice.MovementChildId,0) = 0
                                  )


    -- Результат
    SELECT     
        Movement.Id
      , Movement.InvNumber
      , ('№ ' || Movement.InvNumber || ' от ' || zfConvert_DateToString (Movement.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Full
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
      , ('№ '
         ||CASE WHEN Movement_Parent.StatusId = zc_Enum_Status_UnComplete() THEN zc_InvNumber_Status_UnComlete()
                WHEN Movement_Parent.StatusId = zc_Enum_Status_Erased()     THEN zc_InvNumber_Status_Erased()
                ELSE ''
           END
         ||' '
         || Movement_Parent.InvNumber || ' от ' || zfConvert_DateToString (Movement_Parent.OperDate) :: TVarChar ||' (' ||MovementDesc_Parent.ItemName||' )' ) :: TVarChar  AS InvNumber_parent

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

        --Лодку показываем из док. Заказ
        LEFT JOIN tmpMLM AS MovementLinkMovement_Invoice
                         ON MovementLinkMovement_Invoice.MovementChildId = Movement.Id
                        AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                     ON MovementLinkObject_Product.MovementId = COALESCE (Movement.ParentId, MovementLinkMovement_Invoice.MovementId)
                                    AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
        LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

        LEFT JOIN ObjectString AS ObjectString_CIN
                               ON ObjectString_CIN.ObjectId = Object_Product.Id
                              AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

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

        --Parent Документ Заказ или ПРиход
        LEFT JOIN Movement AS Movement_Parent
                           ON Movement_Parent.Id = Movement.ParentId
                          AND Movement_Parent.StatusId <> zc_Enum_Status_Erased()
        LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId
     UNION
       SELECT 0
            , ''   :: TVarChar  AS InvNumber
            , ''   :: TVarChar  AS InvNumber_Full
            , NULL :: TDateTime AS OperDate
            , NULL :: TDateTime AS PlanDate
            , NULL :: Integer   AS StatusCode
            , ''   :: TVarChar  AS StatusName
      
              -- с НДС
            , 0 ::TFloat AS AmountIn
            , 0 ::TFloat AS AmountOut
              -- без НДС
            , 0 ::TFloat AS AmountIn_NotVAT
            , 0 ::TFloat AS AmountOut_NotVAT
              -- НДС
            , 0 ::TFloat AS AmountIn_VAT
            , 0 ::TFloat AS AmountOut_VAT
      
            , ObjectFloat_TaxKind_Value.ValueData    ::TFloat AS VATPercent
      
            , Object_From.Id                                    AS ObjectId
            , Object_From.ValueData                             AS ObjectName
            , ObjectDesc.ItemName                               AS DescName

            , 0 ::Integer AS InfoMoneyId
            , 0 ::Integer AS InfoMoneyCode
            , ''   :: TVarChar  AS InfoMoneyName
            , ''   :: TVarChar  AS InfoMoneyName_all
            , 0 ::Integer AS InfoMoneyGroupId
            , 0 ::Integer AS InfoMoneyGroupCode
            , ''   :: TVarChar  AS InfoMoneyGroupName
            , 0 ::Integer AS InfoMoneyDestinationId
            , 0 ::Integer AS InfoMoneyDestinationCode
            , ''   :: TVarChar  AS InfoMoneyDestinationName
            , Object_Product.Id            AS ProductId
            , Object_Product.ObjectCode    AS ProductCode
            , Object_Product.ValueData     AS ProductName
            , ObjectString_CIN.ValueData   AS ProductCIN
            , Object_PaidKind.Id           AS PaidKindId
            , Object_PaidKind.ValueData    AS PaidKindName
            , Object_To.Id                 AS UnitId
            , Object_To.ValueData          AS UnitName
      
            , ''   :: TVarChar  AS InvNumberPartner
            , ''   :: TVarChar  AS ReceiptNumber
            , ''   :: TVarChar  AS Comment

            , ''   :: TVarChar  AS InsertName
            , NULL :: TDateTime AS InsertDate
            , ''   :: TVarChar  AS UpdateName
            , NULL :: TDateTime AS UpdateDate

            , Movement_OrderClient.Id   ::Integer  AS MovementId_parent
            , ('№ ' || Movement_OrderClient.InvNumber || ' от ' || zfConvert_DateToString (Movement_OrderClient.OperDate) :: TVarChar ||' (' ||MovementDesc_Parent.ItemName||' )' ) :: TVarChar  AS InvNumber_parent
            

       FROM tmpMovement_OrderClient AS Movement_OrderClient
        LEFT JOIN Object AS Object_From   ON Object_From.Id   = Movement_OrderClient.FromId
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_From.DescId
        LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_OrderClient.DescId
        
        LEFT JOIN Object AS Object_To     ON Object_To.Id     = Movement_OrderClient.ToId
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Movement_OrderClient.PaidKindId
        LEFT JOIN Object AS Object_Product  ON Object_Product.Id  = Movement_OrderClient.ProductId

        LEFT JOIN ObjectString AS ObjectString_CIN
                               ON ObjectString_CIN.ObjectId = Object_Product.Id
                              AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

        LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                             ON ObjectLink_TaxKind.ObjectId = Object_From.Id
                            AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
        LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId 
 
        LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                              ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                             AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
        
        LEFT JOIN tmpMovement ON tmpMovement.ParentId = Movement_OrderClient.Id
       WHERE tmpMovement.ParentId IS NULL
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.03.21         *
*/

-- тест
-- select * from gpSelect_Movement_InvoiceOrderChoice(inStartDate := ('01.01.2021')::TDateTime , inEndDate := ('18.02.2021')::TDateTime , inCliendId :=0, inIsErased := 'False' ,  inSession := zfCalc_UserAdmin());