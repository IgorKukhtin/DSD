-- Function: gpGet_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderClient (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderClient(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, DiscountTax TFloat, DiscountNextTax TFloat
             , NPP TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ProductId Integer, ProductName TVarChar, BrandId Integer, BrandName TVarChar, CIN TVarChar, DateBegin TDateTime
             , Comment TVarChar
             , isChild_Recalc Boolean
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbNPP TFloat;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderClient());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     vbNPP := COALESCE ((SELECT MAX(MovementFloat.ValueData)
                         FROM MovementFloat
                             INNER JOIN Movement ON Movement.Id = MovementFloat.MovementId
                                                AND Movement.DescId = zc_Movement_OrderClient()
                                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                         WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                           AND COALESCE (MovementFloat.ValueData,0)<>0
                         ), 0);
     RETURN QUERY
         SELECT
               0                         AS Id
             , CAST (NEXTVAL ('movement_OrderClient_seq') AS TVarChar) AS InvNumber
             , CAST ('' AS TVarChar)     AS InvNumberPartner
             , inOperDate   ::TDateTime   AS OperDate     --CURRENT_DATE
             , Object_Status.Code        AS StatusCode
             , Object_Status.Name        AS StatusName
             , CAST (False as Boolean)   AS PriceWithVAT
             , ObjectFloat_TaxKind_Value.ValueData :: TFloat AS VATPercent
             , CAST (0 as TFloat)        AS DiscountTax
             , CAST (0 as TFloat)        AS DiscountNextTax
             , (vbNPP +1)       ::TFloat AS NPP
             , 0                         AS FromId
             , CAST ('' AS TVarChar)     AS FromName
             , 0                         AS ToId
             , CAST ('' AS TVarChar)     AS ToName
             , 0                         AS PaidKindId
             , CAST ('' AS TVarChar)     AS PaidKindName
             , 0                         AS ProductId
             , CAST ('' AS TVarChar)     AS ProductName
             , 0                         AS BrandId
             , CAST ('' AS TVarChar)     AS BrandName
             , CAST ('' AS TVarChar)     AS CIN
             , NULL AS TDateTime         AS DateBegin
             , CAST ('' AS TVarChar)     AS Comment
             , FALSE :: Boolean          AS isChild_Recalc
             , 0                         AS MovementId_Invoice
             , CAST ('' as TVarChar)     AS InvNumber_Invoice
             , CAST ('' as TVarChar)     AS Comment_Invoice

             , Object_Insert.Id                AS InsertId
             , Object_Insert.ValueData         AS InsertName
             , CURRENT_TIMESTAMP  ::TDateTime  AS InsertDate
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                     ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis()
                                    AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY

        SELECT
            Movement_OrderClient.Id
          , Movement_OrderClient.InvNumber
          , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
          , Movement_OrderClient.OperDate             AS OperDate
          , Object_Status.ObjectCode                  AS StatusCode
          , Object_Status.ValueData                   AS StatusName

          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) :: Boolean AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData        AS VATPercent
          , MovementFloat_DiscountTax.ValueData       AS DiscountTax
          , MovementFloat_DiscountNextTax.ValueData   AS DiscountNextTax
          , COALESCE (MovementFloat_NPP.ValueData,0) ::TFloat AS NPP

          , Object_From.Id                            AS FromId
          , Object_From.ValueData                     AS FromName
          , Object_To.Id                              AS ToId
          , Object_To.ValueData                       AS ToName
          , Object_PaidKind.Id                        AS PaidKindId
          , Object_PaidKind.ValueData                 AS PaidKindName

          , Object_Product.Id                          AS ProductId
          , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
          , Object_Brand.Id                            AS BrandId
          , Object_Brand.ValueData                     AS BrandName
          , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS CIN
          , ObjectDate_DateBegin.ValueData             AS DateBegin

          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment
        --, EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE) :: Boolean AS isChild_Recalc
          , FALSE :: Boolean AS isChild_Recalc

          , Movement_Invoice.Id                                        AS MovementId_Invoice
          , zfCalc_InvNumber_isErased ('', Movement_Invoice.InvNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
          , MovementString_Comment_Invoice.ValueData                   AS Comment_Invoice

          , Object_Insert.Id                     AS InsertId
          , Object_Insert.ValueData              AS InsertName
          , MovementDate_Insert.ValueData        AS InsertDate

        FROM Movement AS Movement_OrderClient
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_OrderClient.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                         ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
            LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_OrderClient.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                    ON MovementFloat_DiscountTax.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

            LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                    ON MovementFloat_DiscountNextTax.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_DiscountNextTax.DescId = zc_MovementFloat_DiscountNextTax()

             LEFT JOIN MovementFloat AS MovementFloat_NPP
                                     ON MovementFloat_NPP.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_NPP.DescId = zc_MovementFloat_NPP()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement_OrderClient.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_OrderClient.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                           ON MovementLinkMovement_Invoice.MovementId = Movement_OrderClient.Id
                                          AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MovementLinkMovement_Invoice.MovementChildId

            LEFT JOIN MovementString AS MovementString_Comment_Invoice
                                     ON MovementString_Comment_Invoice.MovementId = Movement_Invoice.Id
                                    AND MovementString_Comment_Invoice.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_OrderClient.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_OrderClient.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            --
            LEFT JOIN ObjectString AS ObjectString_CIN
                                   ON ObjectString_CIN.ObjectId = Object_Product.Id
                                  AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
            LEFT JOIN ObjectLink AS ObjectLink_Brand
                                 ON ObjectLink_Brand.ObjectId = Object_Product.Id
                                AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
            LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_DateBegin
                                 ON ObjectDate_DateBegin.ObjectId = Object_Product.Id
                                AND ObjectDate_DateBegin.DescId = zc_ObjectDate_Product_DateBegin()
        WHERE Movement_OrderClient.Id = inMovementId
          AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
          ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderClient (inMovementId:= 0, inOperDate := '02.02.2021'::TDateTime, inSession:= '9818')
