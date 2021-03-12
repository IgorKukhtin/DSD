-- Function: gpSelect_Movement_Invoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_InvoiceChoice (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_InvoiceChoice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inCliendId      Integer ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
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
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbProductId Integer;   
BEGIN

     vbUserId:= lpGetUserBySession (inSession);

     -- Ðåçóëüòàò
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
                                                     , zc_MovementLinkObject_Product()
                                                     , zc_MovementLinkObject_PaidKind()
                                                      )
                  )

    -- Ðåçóëüòàò
    SELECT     
        Movement.Id
      , Movement.InvNumber
      , ('¹ ' || Movement.InvNumber || ' îò ' || Movement.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Full
      , Movement.OperDate
      , MovementDate_Plan.ValueData         :: TDateTime    AS PlanDate
      , Object_Status.ObjectCode                            AS StatusCode
      , Object_Status.ValueData                             AS StatusName

        -- ñ ÍÄÑ
      , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END::TFloat AS AmountIn
      , CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END::TFloat AS AmountOut
        -- áåç ÍÄÑ
      , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * zfCalc_Summ_NoVAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END::TFloat AS AmountIn_NotVAT
      , CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * zfCalc_Summ_NoVAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END::TFloat AS AmountOut_NotVAT
        -- ÍÄÑ
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

        LEFT JOIN tmpMLO AS MovementLinkObject_Product
                         ON MovementLinkObject_Product.MovementId = Movement.Id
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
    WHERE Object_Object.Id = inCliendId 
       OR inCliendId = 0
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 02.02.21         *
*/

-- òåñò
-- SELECT * FROM gpSelect_Movement_Invoice (inStartDate:= '01.08.2021', inEndDate:= '01.08.2021', inCliendId:=0, inIsErased := FALSE, inSession:= zfCalc_UserAdmin());
