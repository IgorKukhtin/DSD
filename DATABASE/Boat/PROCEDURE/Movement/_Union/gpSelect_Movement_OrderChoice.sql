-- Function: gpSelect_Movement_OrderChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_InvoiceOrderChoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeOrderChoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderChoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderChoice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inObjectId      Integer   , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full TVarChar, InvNumberPartner TVarChar
             , OperDate TDateTime, OperDatePartner TDateTime
             , StatusCode Integer, StatusName TVarChar, DescName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, DiscountTax TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummVAT TFloat
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ProductId Integer, ProductCode Integer, ProductName TVarChar, ProductCIN TVarChar
             , Comment TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

         , tmpMovement AS (SELECT Movement.Id
                               , Movement.DescId
                               , Movement.InvNumber
                               , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                               , Movement.OperDate                  AS OperDate
                               , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
                               , Movement.StatusId                  AS StatusId
                               , CASE WHEN Movement.DescId = zc_Movement_OrderClient()
                                           THEN MovementLinkObject_From.ObjectId
                                      WHEN Movement.DescId = zc_Movement_OrderPartner()
                                           THEN MovementLinkObject_To.ObjectId
                                 END AS ObjectId
                               , CASE WHEN Movement.DescId = zc_Movement_OrderClient()
                                           THEN MovementLinkObject_To.ObjectId
                                      WHEN Movement.DescId = zc_Movement_OrderPartner()
                                           THEN MovementLinkObject_From.ObjectId
                                 END AS UnitId
                               , MovementLinkObject_PaidKind.ObjectId      AS PaidKindId
                               , MovementLinkMovement_Invoice.MovementChildId AS MovementId_Invoice
                          FROM tmpStatus
                               INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                                                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                  AND Movement.DescId IN (zc_Movement_OrderPartner(), zc_Movement_OrderClient())

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                               LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                        ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                               LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                               LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                                              ON MovementLinkMovement_Invoice.MovementId = Movement.Id
                                                             AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                         )


        SELECT Movement.Id
             , zfConvert_StringToNumber (Movement.InvNumber) ::Integer AS InvNumber
             , zfCalc_InvNumber_isErased ('', Movement.InvNumber, Movement.OperDate, Movement.StatusId) AS InvNumber_Full
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

             , Object_Object.Id                             AS ObjectId
             , Object_Object.ObjectCode                     AS ObjectCode
             , Object_Object.ValueData                      AS ObjectName
             , Object_Unit.Id                               AS UnitId
             , Object_Unit.ObjectCode                       AS UnitCode
             , Object_Unit.ValueData                        AS UnitName
             , Object_PaidKind.Id                           AS PaidKindId
             , Object_PaidKind.ValueData                    AS PaidKindName
             , Object_Product.Id                            AS ProductId
             , Object_Product.ObjectCode                    AS ProductCode
             , Object_Product.ValueData                     AS ProductName
             , ObjectString_CIN.ValueData                   AS ProductCIN
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Movement_Invoice.Id                      AS MovementId_Invoice
             , zfCalc_InvNumber_isErased ('', Movement_Invoice.InvNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
             , MovementString_Comment_Invoice.ValueData AS Comment_Invoice

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

        FROM tmpMovement AS Movement

             LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

             LEFT JOIN Object AS Object_Status   ON Object_Status.Id   = Movement.StatusId
             LEFT JOIN Object AS Object_Object   ON Object_Object.Id   = Movement.ObjectId
             LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = Movement.UnitId
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Movement.PaidKindId
             LEFT JOIN Object AS Object_Product  ON Object_Product.Id  = NULL

             LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = Movement.MovementId_Invoice

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

        WHERE Movement.ObjectId = inObjectId OR COALESCE (inObjectId, 0) = 0
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
-- SELECT * FROM gpSelect_Movement_OrderChoice (inStartDate:= '29.01.2016'::TDateTime, inEndDate:= '01.02.2016'::TDateTime, inObjectId:=0, inIsErased := FALSE ::Boolean, inSession:= '2'::TVarChar)
