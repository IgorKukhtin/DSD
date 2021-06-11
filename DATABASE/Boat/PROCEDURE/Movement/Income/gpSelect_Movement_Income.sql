-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumberPartner TVarChar
             , OperDate TDateTime, OperDatePartner TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, DiscountTax TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummVAT TFloat
             , TotalSummCost TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , Comment TVarChar
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

        , Movement_Income AS ( SELECT Movement_Income.Id
                                    , Movement_Income.InvNumber
                                    , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                                    , Movement_Income.OperDate                  AS OperDate
                                    , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
                                    , Movement_Income.StatusId                  AS StatusId
                                    , MovementLinkObject_To.ObjectId            AS ToId
                                    , MovementLinkObject_From.ObjectId          AS FromId
                                    , MovementLinkObject_PaidKind.ObjectId      AS PaidKindId
                               FROM tmpStatus
                                    INNER JOIN Movement AS Movement_Income
                                                       ON Movement_Income.StatusId = tmpStatus.StatusId
                                                      AND Movement_Income.OperDate BETWEEN inStartDate AND inEndDate
                                                      AND Movement_Income.DescId = zc_Movement_Income()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                 ON MovementLinkObject_PaidKind.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                                    LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                             ON MovementString_InvNumberPartner.MovementId = Movement_Income.Id
                                                            AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                                    LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                           ON MovementDate_OperDatePartner.MovementId = Movement_Income.Id
                                                          AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                              )


        SELECT Movement_Income.Id
             , zfConvert_StringToNumber (Movement_Income.InvNumber) AS InvNumber
             , Movement_Income.InvNumberPartner
             , Movement_Income.OperDate
             , Movement_Income.OperDatePartner
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData         AS VATPercent
             , MovementFloat_DiscountTax.ValueData        AS DiscountTax
             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
             , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm
             , (COALESCE (MovementFloat_TotalSummPVAT.ValueData,0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData,0)) :: TFloat AS TotalSummVAT
             , MovementFloat_TotalSummCost.ValueData      AS TotalSummCost

             , Object_From.Id                             AS FromId
             , Object_From.ObjectCode                     AS FromCode
             , Object_From.ValueData                      AS FromName
             , Object_To.Id                               AS ToId
             , Object_To.ObjectCode                       AS ToCode
             , Object_To.ValueData                        AS ToName
             , Object_PaidKind.Id                         AS PaidKindId
             , Object_PaidKind.ValueData                  AS PaidKindName
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

        FROM Movement_Income
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Income.StatusId
             LEFT JOIN Object AS Object_From   ON Object_From.Id   = Movement_Income.FromId
             LEFT JOIN Object AS Object_To     ON Object_To.Id     = Movement_Income.ToId
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Movement_Income.PaidKindId

             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                     ON MovementFloat_VATPercent.MovementId = Movement_Income.Id
                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

             LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                     ON MovementFloat_DiscountTax.MovementId = Movement_Income.Id
                                    AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                     ON MovementFloat_TotalSummPVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                     ON MovementFloat_TotalSummMVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummCost
                                     ON MovementFloat_TotalSummCost.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSummCost.DescId = zc_MovementFloat_TotalSummCost()

             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                       ON MovementBoolean_PriceWithVAT.MovementId = Movement_Income.Id
                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement_Income.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement_Income.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
             LEFT JOIN MovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement_Income.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

             LEFT JOIN MovementDate AS MovementDate_Update
                                    ON MovementDate_Update.MovementId = Movement_Income.Id
                                   AND MovementDate_Update.DescId = zc_MovementDate_Update()
             LEFT JOIN MovementLinkObject AS MLO_Update
                                          ON MLO_Update.MovementId = Movement_Income.Id
                                         AND MLO_Update.DescId = zc_MovementLinkObject_Update()
             LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.21         *
 08.02.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income (inStartDate:= '29.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin())
