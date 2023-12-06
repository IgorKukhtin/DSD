-- Function: gpGet_Movement_Invoice()

DROP FUNCTION IF EXISTS gpGet_Movement_Invoice (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Invoice (Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Invoice(
    IN inMovementId        Integer  , -- ключ Документа 
    IN inMovementId_OrderClient Integer,
    IN inProductId         Integer,
    IN inClientId          Integer,
    IN inOperDate          TDateTime , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate        TDateTime
             , PlanDate        TDateTime
             , StatusCode      Integer
             , StatusName      TVarChar
             , InvoiceKindId   Integer
             , InvoiceKindName TVarChar
             , isAuto          Boolean
             
             , VATPercent      TFloat
             , AmountIn        TFloat
             , AmountOut       TFloat

             , ObjectId        Integer
             , ObjectName      TVarChar 
             , TaxKindId       Integer
             , TaxKindName     TVarChar
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
             , MovementId_parent Integer
             , InvNumber_parent TVarChar
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
           , CURRENT_DATE /*inOperDate*/ :: TDateTime AS OperDate
           , NULL :: TDateTime          AS PlanDate
           , lfObject_Status.Code       AS StatusCode
           , lfObject_Status.Name       AS StatusName
           , 0                          AS InvoiceKindId
           , CAST ('' as TVarChar)      AS InvoiceKindName
           , FALSE                      AS isAuto

           , 0::TFloat                  AS VATPercent
           , 0::TFloat                  AS AmountIn
           , 0::TFloat                  AS AmountOut

           , Object_Object.Id           AS ObjectId
           , Object_Object.ValueData    AS ObjectName 
           , Object_TaxKind.Id          AS TaxKindId
           , Object_TaxKind.ValueData   AS TaxKindName
           , Object_InfoMoney.Id        AS InfoMoneyId
           , Object_InfoMoney.ValueData ::TVarChar AS InfoMoneyName
           , Object_Product.Id          AS ProductId
           , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
           , 0                          AS PaidKindId
           , CAST ('' as TVarChar)      AS PaidKindName
           , 0                          AS UnitId
           , CAST ('' as TVarChar)      AS UnitName

           , CAST ('' as TVarChar)      AS InvNumberPartner
           , vbReceiptNumber:: TVarChar AS ReceiptNumber
           , CAST ('' as TVarChar)      AS Comment
           , Movement_Parent.Id ::Integer  AS MovementId_parent
           , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumber_parent

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status 
           LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = inMovementId_OrderClient
           LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId
           LEFT JOIN Object AS Object_Object ON Object_Object.Id = inClientId
           LEFT JOIN Object AS Object_Product ON Object_Product.Id = inProductId 
           
           LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                ON ObjectLink_InfoMoney.ObjectId = Object_Object.Id
                               AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Client_InfoMoney()
           LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_InfoMoney.ChildObjectId  
           
           LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                ON ObjectLink_TaxKind.ObjectId = Object_Object.Id
                               AND ObjectLink_TaxKind.DescId IN (zc_ObjectLink_Client_TaxKind(), zc_ObjectLink_Partner_TaxKind())
           LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId
      ;
     ELSE

     RETURN QUERY
        WITH -- Все документы, в которых указан этот Счет, возьмем первый
             tmpMLM AS (SELECT *
                        FROM (SELECT MovementLinkMovement.*
                                   , ROW_NUMBER() OVER (PARTITION BY MovementLinkMovement.MovementChildId ORDER BY Movement.Id) AS Ord
                              FROM MovementLinkMovement
                                   INNER JOIN Movement ON Movement.Id       = MovementLinkMovement.MovementId
                                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                      AND Movement.DescId   IN (zc_Movement_Income(), zc_Movement_OrderClient())
                              WHERE MovementLinkMovement.MovementChildId = inMovementId
                                AND MovementLinkMovement.DescId          = zc_MovementLinkMovement_Invoice()
                             ) AS tmp
                        WHERE tmp.Ord = 1
                       )
       -- Результат
       SELECT
           Movement.Id
         , Movement.InvNumber
         , Movement.OperDate
         , MovementDate_Plan.ValueData         :: TDateTime    AS PlanDate
         , Object_Status.ObjectCode                            AS StatusCode
         , Object_Status.ValueData                             AS StatusName
         , Object_InvoiceKind.Id                               AS InvoiceKindId
         , Object_InvoiceKind.ValueData                        AS InvoiceKindName
         , COALESCE (MovementBoolean_Auto.ValueData, FALSE) ::Boolean AS isAuto         
         
         , COALESCE (MovementFloat_VATPercent.ValueData, 0)    ::TFloat      AS VATPercent
         , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN MovementFloat_Amount.ValueData      ELSE 0 END::TFloat AS AmountIn
         , CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END::TFloat AS AmountOut
         , Object_Object.Id                                    AS ObjectId
         , Object_Object.ValueData                             AS ObjectName
         , Object_TaxKind.Id                                   AS TaxKindId
         , Object_TaxKind.ValueData                            AS TaxKindName
         , Object_InfoMoney_View.InfoMoneyId
         , Object_InfoMoney_View.InfoMoneyName
         , Object_Product.Id                                   AS ProductId
         , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
         , Object_PaidKind.Id                                  AS PaidKindId
         , Object_PaidKind.ValueData                           AS PaidKindName
         , Object_Unit.Id                                      AS UnitId
         , Object_Unit.ValueData                               AS UnitName

         , MovementString_InvNumberPartner.ValueData           AS InvNumberPartner
         , MovementString_ReceiptNumber.ValueData              AS ReceiptNumber
         , MovementString_Comment.ValueData                    AS Comment

         , Movement_Parent.Id             ::Integer  AS MovementId_parent
         , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumber_parent

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

           -- Номер документа (внешний)
           LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                    ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                   AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
           -- Официальный номер квитанции
           LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                    ON MovementString_ReceiptNumber.MovementId = Movement.Id
                                   AND MovementString_ReceiptNumber.DescId = zc_MovementString_ReceiptNumber()
           LEFT JOIN MovementString AS MovementString_Comment
                                    ON MovementString_Comment.MovementId = Movement.Id
                                   AND MovementString_Comment.DescId = zc_MovementString_Comment()

           LEFT JOIN MovementBoolean AS MovementBoolean_Auto
                                     ON MovementBoolean_Auto.MovementId = Movement.Id
                                    AND MovementBoolean_Auto.DescId = zc_MovementBoolean_Auto()

           --  Client or Partner
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Object
                                        ON MovementLinkObject_Object.MovementId = Movement.Id
                                       AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object()
           LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementLinkObject_Object.ObjectId

           LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                        ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
                                       AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId

           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

           LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                        ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                       AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
           LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId


           -- Parent - если "нашли"
           LEFT JOIN tmpMLM AS MovementLinkMovement_Invoice
                            ON MovementLinkMovement_Invoice.MovementChildId = Movement.Id
                           AND MovementLinkMovement_Invoice.DescId          = zc_MovementLinkMovement_Invoice()
           -- Parent - если указан - он в приоритете
           LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = COALESCE (Movement.ParentId, MovementLinkMovement_Invoice.MovementId)
           LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId

           -- Лодку показываем из док. Movement_Parent
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                        ON MovementLinkObject_Product.MovementId = Movement_Parent.Id
                                       AND MovementLinkObject_Product.DescId     = zc_MovementLinkObject_Product()
           LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

           LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                ON ObjectLink_TaxKind.ObjectId = Object_Object.Id
                               AND ObjectLink_TaxKind.DescId IN (zc_ObjectLink_Client_TaxKind(), zc_ObjectLink_Partner_TaxKind())
           LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId

          WHERE Movement.Id = inMovementId
          ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.23         *
 03.02.21         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Invoice (inMovementId:= 1, inMovementId_OrderClient :=0, inProductId:=0, inClientId:=0, inOperDate:= NULL :: TDateTime, inSession:= zfCalc_UserAdmin());
