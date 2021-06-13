-- Function: gpSelect_Movement_OrderClient_reserve()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient_reserve (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient_reserve (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderClient_reserve(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inGoodsId       Integer  ,
    IN inPeriodAll     Boolean      , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar, InvNumberPartner TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, DiscountTax TFloat, DiscountNextTax TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummVAT TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ProductId Integer, ProductName TVarChar, BrandId Integer, BrandName TVarChar, CIN TVarChar
             , Comment TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )

AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderClient());

     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH 
     tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
             UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
             UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                  )

   -- "Резерв кол-во" из zc_Movement_OrderClient.zc_MI_Child
   , tmpReserv AS (SELECT Movement.*
                   FROM Movement
                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.DescId     = zc_MI_Child()
                                               AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                                               AND MovementItem.isErased   = FALSE
                                               AND COALESCE (MovementItem.Amount,0) > 0
                                               AND MovementItem.ParentId > 0
                        INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                   WHERE Movement.DescId = zc_Movement_OrderClient()
                     AND (Movement.OperDate BETWEEN inStartDate AND inEndDate OR inPeriodAll = TRUE)
                   )

   , Movement_OrderClient AS ( SELECT Movement_OrderClient.Id
                                    , Movement_OrderClient.InvNumber
                                    , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                                    , Movement_OrderClient.OperDate             AS OperDate
                                    , Movement_OrderClient.StatusId             AS StatusId
                                    , MovementLinkObject_To.ObjectId            AS ToId
                                    , MovementLinkObject_From.ObjectId          AS FromId
                                    , MovementLinkObject_PaidKind.ObjectId      AS PaidKindId
                                    , MovementLinkObject_Product.ObjectId       AS ProductId
                                    , MovementLinkMovement_Invoice.MovementChildId AS MovementId_Invoice
                               FROM tmpReserv AS Movement_OrderClient

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                 ON MovementLinkObject_PaidKind.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                 ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()

                                    LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                             ON MovementString_InvNumberPartner.MovementId = Movement_OrderClient.Id
                                                            AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                                    LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                                                   ON MovementLinkMovement_Invoice.MovementId = Movement_OrderClient.Id
                                                                  AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                              )


        SELECT Movement_OrderClient.Id
             , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) AS InvNumber
             , ('№ ' || Movement_OrderClient.InvNumber || ' от ' || zfConvert_DateToString (Movement_OrderClient.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Full
             , Movement_OrderClient.InvNumberPartner
             , Movement_OrderClient.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData         AS VATPercent
             , MovementFloat_DiscountTax.ValueData        AS DiscountTax
             , MovementFloat_DiscountNextTax.ValueData    AS DiscountNextTax
             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
             , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm
             , (COALESCE (MovementFloat_TotalSummPVAT.ValueData,0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData,0)) :: TFloat AS TotalSummVAT

             , Object_From.Id                             AS FromId
             , Object_From.ObjectCode                     AS FromCode
             , Object_From.ValueData                      AS FromName
             , Object_To.Id                               AS ToId
             , Object_To.ObjectCode                       AS ToCode
             , Object_To.ValueData                        AS ToName
             , Object_PaidKind.Id                         AS PaidKindId
             , Object_PaidKind.ValueData                  AS PaidKindName
             , Object_Product.Id                          AS ProductId
             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
             , Object_Brand.Id                            AS BrandId
             , Object_Brand.ValueData                     AS BrandName
             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS CIN
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Movement_Invoice.Id               AS MovementId_Invoice
             , zfCalc_InvNumber_isErased ('', Movement_Invoice.InvNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
             , MovementString_Comment_Invoice.ValueData AS Comment_Invoice

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

        FROM Movement_OrderClient

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_OrderClient.StatusId
        LEFT JOIN Object AS Object_From   ON Object_From.Id   = Movement_OrderClient.FromId
        LEFT JOIN Object AS Object_To     ON Object_To.Id     = Movement_OrderClient.ToId
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Movement_OrderClient.PaidKindId
        LEFT JOIN Object AS Object_Product  ON Object_Product.Id  = Movement_OrderClient.ProductId
        LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = Movement_OrderClient.MovementId_Invoice

        LEFT JOIN MovementString AS MovementString_Comment_Invoice
                                 ON MovementString_Comment_Invoice.MovementId = Movement_Invoice.Id
                                AND MovementString_Comment_Invoice.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement_OrderClient.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement_OrderClient.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                ON MovementFloat_VATPercent.MovementId = Movement_OrderClient.Id
                               AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

        LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                ON MovementFloat_DiscountTax.MovementId = Movement_OrderClient.Id
                               AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
        LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                ON MovementFloat_DiscountNextTax.MovementId = Movement_OrderClient.Id
                               AND MovementFloat_DiscountNextTax.DescId = zc_MovementFloat_DiscountNextTax()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                ON MovementFloat_TotalSummPVAT.MovementId = Movement_OrderClient.Id
                               AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                ON MovementFloat_TotalSummMVAT.MovementId = Movement_OrderClient.Id
                               AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId = Movement_OrderClient.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_OrderClient.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement_OrderClient.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement_OrderClient.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement_OrderClient.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
        LEFT JOIN MovementLinkObject AS MLO_Update
                                     ON MLO_Update.MovementId = Movement_OrderClient.Id
                                    AND MLO_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

        --
        LEFT JOIN ObjectString AS ObjectString_CIN
                               ON ObjectString_CIN.ObjectId = Object_Product.Id
                              AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
        LEFT JOIN ObjectLink AS ObjectLink_Brand
                             ON ObjectLink_Brand.ObjectId = Object_Product.Id
                            AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
        LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderClient_reserve (inStartDate:= '29.01.2016', inEndDate:= '01.02.2016', inGoodsId:=0 , inPeriodAll:= True, inIsErased := FALSE, inSession:= zfCalc_UserAdmin())
