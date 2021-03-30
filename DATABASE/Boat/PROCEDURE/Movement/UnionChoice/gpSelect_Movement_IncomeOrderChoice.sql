-- Function: gpSelect_Movement_IncomeOrderChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeOrderChoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeOrderChoice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inObjectId      Integer   , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumber_Full TVarChar, InvNumberPartner TVarChar
             , OperDate TDateTime, OperDatePartner TDateTime
             , StatusCode Integer, StatusName TVarChar, DescName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, DiscountTax TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummVAT TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ProductId Integer, ProductCode Integer, ProductName TVarChar, ProductCIN TVarChar
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

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());

     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMovement AS ( SELECT Movement.Id
                                    , Movement.DescId
                                    , Movement.InvNumber
                                    , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                                    , Movement.OperDate                  AS OperDate
                                    , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
                                    , Movement.StatusId                  AS StatusId
                                    , MovementLinkObject_To.ObjectId            AS ToId
                                    , MovementLinkObject_From.ObjectId          AS FromId
                                    , MovementLinkObject_PaidKind.ObjectId      AS PaidKindId
                                    , MovementLinkMovement_Invoice.MovementChildId AS MovementId_Invoice
                                    , MovementLinkObject_Product.ObjectId       AS ProductId
                               FROM tmpStatus
                                    INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                                                       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                       AND Movement.DescId IN (zc_Movement_Income(), zc_Movement_OrderClient())

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
           
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                 ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                                AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                                    LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                             ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                            AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                                    LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                           ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                          AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                    
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                 ON MovementLinkObject_Product.MovementId = Movement.Id
                                                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()

                                    LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                                                   ON MovementLinkMovement_Invoice.MovementId = Movement.Id
                                                                  AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                              )


        SELECT Movement.Id
             , Movement.InvNumber
             , ('№ ' || Movement.InvNumber || ' от ' || zfConvert_DateToString (Movement.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Full
             , Movement.InvNumberPartner
             , Movement.OperDate
             , Movement.OperDatePartner
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName
             , MovementDesc.ItemName                      AS DescName

             , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData         AS VATPercent
             , MovementFloat_DiscountTax.ValueData        AS DiscountTax
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
             , Object_Product.ObjectCode                  AS ProductCode
             , Object_Product.ValueData                   AS ProductName
             , ObjectString_CIN.ValueData                 AS ProductCIN
             , MovementString_Comment.ValueData :: TVarChar AS Comment
             
             , Movement_Invoice.Id               AS MovementId_Invoice
             , ('№ ' || Movement_Invoice.InvNumber || ' от ' || zfConvert_DateToString (Movement_Invoice.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Invoice
             , MovementString_Comment_Invoice.ValueData AS Comment_Invoice

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

        FROM tmpMovement AS Movement

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
        LEFT JOIN Object AS Object_From   ON Object_From.Id   = Movement.FromId
        LEFT JOIN Object AS Object_To     ON Object_To.Id     = Movement.ToId
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Movement.PaidKindId
        LEFT JOIN Object AS Object_Product ON Object_Product.Id = Movement.ProductId
        LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = Movement.MovementId_Invoice
        LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

        LEFT JOIN MovementString AS MovementString_Comment_Invoice
                                 ON MovementString_Comment_Invoice.MovementId = Movement_Invoice.Id
                                AND MovementString_Comment_Invoice.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                ON MovementFloat_VATPercent.MovementId = Movement.Id
                               AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

        LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                ON MovementFloat_DiscountTax.MovementId = Movement.Id
                               AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                ON MovementFloat_TotalSummPVAT.MovementId = Movement.Id
                               AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                ON MovementFloat_TotalSummMVAT.MovementId = Movement.Id
                               AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

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

        LEFT JOIN ObjectString AS ObjectString_CIN
                               ON ObjectString_CIN.ObjectId = Object_Product.Id
                              AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
        WHERE Object_From.Id = inObjectId 
       OR inObjectId = 0
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
-- SELECT * FROM gpSelect_Movement_IncomeOrderChoice (inStartDate:= '29.01.2016', inEndDate:= '01.02.2016', inClientId:=0, inIsErased := FALSE, inSession:= '2')