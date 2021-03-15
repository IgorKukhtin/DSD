-- Function: gpGet_Movement_Invoice()

DROP FUNCTION IF EXISTS gpGet_Movement_Invoice (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Invoice(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate        TDateTime
             , PlanDate        TDateTime
             , StatusCode      Integer
             , StatusName      TVarChar
             , VATPercent      TFloat
             , AmountIn        TFloat
             , AmountOut       TFloat

             , ObjectId        Integer
             , ObjectName      TVarChar
             , InfoMoneyId     Integer
             , InfoMoneyName_all TVarChar
             , ProductId       Integer
             , ProductName     TVarChar
             , PaidKindId      Integer
             , PaidKindName    TVarChar
             , UnitId          Integer
             , UnitName        TVarChar

             , InvNumberPartner TVarChar
             , ReceiptNumber    TVarChar
             , Comment TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbReceiptNumber Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     -- Quittung Nr последний+1  -- формируется только для Amount>0
     vbReceiptNumber := COALESCE ((SELECT MAX (MovementString.ValueData::Integer) + 1
                                   FROM MovementString
                                   WHERE MovementString.DescId = zc_MovementString_ReceiptNumber())
                                   , 1);
                                   
     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_Invoice_seq') AS TVarChar)  AS InvNumber
           , inOperDate                 AS OperDate
           , NULL :: TDateTime          AS PlanDate
           , lfObject_Status.Code       AS StatusCode
           , lfObject_Status.Name       AS StatusName

           , 0::TFloat                  AS VATPercent
           , 0::TFloat                  AS AmountIn
           , 0::TFloat                  AS AmountOut

           , 0                          AS ObjectId
           , CAST ('' as TVarChar)      AS ObjectName
           , 0                          AS InfoMoneyId
           , CAST ('' as TVarChar)      AS InfoMoneyName
           , 0                          AS ProductId
           , CAST ('' as TVarChar)      AS ProductName
           , 0                          AS PaidKindId
           , CAST ('' as TVarChar)      AS PaidKindName
           , 0                          AS UnitId
           , CAST ('' as TVarChar)      AS UnitName

           , CAST ('' as TVarChar)      AS InvNumberPartner
           , vbReceiptNumber:: TVarChar AS ReceiptNumber
           , CAST ('' as TVarChar)      AS Comment


       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
      ;
     ELSE
     
     RETURN QUERY 
    SELECT     
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , MovementDate_Plan.ValueData         :: TDateTime    AS PlanDate
      , Object_Status.ObjectCode                            AS StatusCode
      , Object_Status.ValueData                             AS StatusName
      , MovementFloat_VATPercent.ValueData    ::TFloat      AS VATPercent
      , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN MovementFloat_Amount.ValueData      ELSE 0 END::TFloat AS AmountIn
      , CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END::TFloat AS AmountOut
      , Object_Object.Id                                    AS ObjectId
      , Object_Object.ValueData                             AS ObjectName
      , Object_InfoMoney_View.InfoMoneyId
      , Object_InfoMoney_View.InfoMoneyName
      , Object_Product.Id                                   AS ProductId
      , Object_Product.ValueData                            AS ProductName
      , Object_PaidKind.Id                                  AS PaidKindId
      , Object_PaidKind.ValueData                           AS PaidKindName
      , Object_Unit.Id                                      AS UnitId
      , Object_Unit.ValueData                               AS UnitName

      , MovementString_InvNumberPartner.ValueData           AS InvNumberPartner
      , MovementString_ReceiptNumber.ValueData              AS ReceiptNumber
      , MovementString_Comment.ValueData                    AS Comment

    FROM Movement
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
        
        LEFT JOIN MovementFloat AS MovementFloat_Amount
                                ON MovementFloat_Amount.MovementId = Movement.Id
                               AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

        LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                ON MovementFloat_VATPercent.MovementId = Movement.Id
                               AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

        LEFT JOIN MovementDate AS MovementDate_Plan
                               ON MovementDate_Plan.MovementId = Movement.Id
                              AND MovementDate_Plan.DescId = zc_MovementDate_Plan()
 
        LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                 ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
        LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                 ON MovementString_ReceiptNumber.MovementId = Movement.Id
                                AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()
        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Object
                                     ON MovementLinkObject_Object.MovementId = Movement.Id
                                    AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object()
        LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementLinkObject_Object.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                     ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
                                    AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId

        /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                     ON MovementLinkObject_Product.MovementId = Movement.Id
                                    AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
        LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId*/
        --Лодку показываем из док. Заказ информативно
        LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                       ON MovementLinkMovement_Invoice.MovementChildId = Movement.Id
                                      AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
        LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Invoice.MovementId
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                     ON MovementLinkObject_Product.MovementId = Movement_Order.Id
                                    AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
        LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                     ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement_Order.StatusId <> zc_Enum_Status_Erased()
         AND Movement_Order.DescId = zc_Movement_OrderClient();

   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 03.02.21         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Invoice (inMovementId:= 0, inOperDate:= NULL :: TDateTime, inSession:= zfCalc_UserAdmin());
