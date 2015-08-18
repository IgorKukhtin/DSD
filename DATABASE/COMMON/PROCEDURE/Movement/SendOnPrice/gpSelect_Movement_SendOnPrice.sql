-- Function: gpSelect_Movement_SendOnPrice()

DROP FUNCTION IF EXISTS gpSelect_Movement_SendOnPrice (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendOnPrice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsPartnerDate Boolean ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCountTare TFloat, TotalCount TFloat, TotalCountPartner TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , MovementId_Order Integer, InvNumber_Order TVarChar

             , EdiOrdspr Boolean, EdiInvoice Boolean, EdiDesadv Boolean
             , isEdiOrdspr_partner Boolean, isEdiInvoice_partner Boolean, isEdiDesadv_partner Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SendOnPrice());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId GROUP BY UserId)
        , tmpBranch AS (SELECT Object_RoleAccessKeyGuide_View.BranchId, Object_RoleAccessKeyGuide_View.UserId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId, Object_RoleAccessKeyGuide_View.UserId)
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName

           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner

           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_ChangePercent.ValueData      AS ChangePercent

           , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData       AS TotalCountSh
           , MovementFloat_TotalCountTare.ValueData     AS TotalCountTare

           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalCountPartner.ValueData  AS TotalCountPartner

           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm

           , Object_From.Id                             AS FromId
           , Object_From.ValueData                      AS FromName
           , Object_To.Id                               AS ToId
           , Object_To.ValueData                        AS ToName

           , Object_RouteSorting.Id                     AS RouteSortingId
           , Object_RouteSorting.ValueData              AS RouteSortingName

           , MovementLinkMovement_Order.MovementChildId AS MovementId_Order
           , Movement_Order.InvNumber                   AS InvNumber_Order

           , COALESCE (MovementBoolean_EdiOrdspr.ValueData, FALSE)    AS EdiOrdspr
           , COALESCE (MovementBoolean_EdiInvoice.ValueData, FALSE)   AS EdiInvoice
           , COALESCE (MovementBoolean_EdiDesadv.ValueData, FALSE)    AS EdiDesadv

           , COALESCE (ObjectBoolean_EdiOrdspr.ValueData, CAST (False AS Boolean))     AS isEdiOrdspr_partner
           , COALESCE (ObjectBoolean_EdiInvoice.ValueData, CAST (False AS Boolean))    AS isEdiInvoice_partner
           , COALESCE (ObjectBoolean_EdiDesadv.ValueData, CAST (False AS Boolean))     AS isEdiDesadv_partner

       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_SendOnPrice() AND Movement.StatusId = tmpStatus.StatusId
             WHERE inIsPartnerDate = FALSE
            UNION ALL
             SELECT MovementDate_OperDatePartner.MovementId  AS Id
             FROM MovementDate AS MovementDate_OperDatePartner
                  JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId AND Movement.DescId = zc_Movement_SendOnPrice()
                  JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
             WHERE inIsPartnerDate = TRUE
               AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
               AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()


            LEFT JOIN MovementBoolean AS MovementBoolean_EdiOrdspr
                                      ON MovementBoolean_EdiOrdspr.MovementId =  Movement.Id
                                     AND MovementBoolean_EdiOrdspr.DescId = zc_MovementBoolean_EdiOrdspr()

            LEFT JOIN MovementBoolean AS MovementBoolean_EdiInvoice
                                      ON MovementBoolean_EdiInvoice.MovementId =  Movement.Id
                                     AND MovementBoolean_EdiInvoice.DescId = zc_MovementBoolean_EdiInvoice()

            LEFT JOIN MovementBoolean AS MovementBoolean_EdiDesadv
                                      ON MovementBoolean_EdiDesadv.MovementId =  Movement.Id
                                     AND MovementBoolean_EdiDesadv.DescId = zc_MovementBoolean_EdiDesadv()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId
            LEFT JOIN tmpBranch ON tmpBranch.UserId = vbUserId

            LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                 ON ObjectLink_UnitFrom_Branch.ObjectId = Object_From.Id
                                AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                 ON ObjectLink_UnitTo_Branch.ObjectId = Object_To.Id
                                AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                        ON MovementLinkMovement_Order.MovementId = Movement.Id 
                                       AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId
      
          
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement_Order.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiOrdspr
                                 ON ObjectBoolean_EdiOrdspr.ObjectId =  MovementLinkObject_Partner.ObjectId
                                AND ObjectBoolean_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiInvoice
                                 ON ObjectBoolean_EdiInvoice.ObjectId =  MovementLinkObject_Partner.ObjectId
                                AND ObjectBoolean_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiDesadv
                                 ON ObjectBoolean_EdiDesadv.ObjectId =  MovementLinkObject_Partner.ObjectId
                                AND ObjectBoolean_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()

       WHERE tmpBranch.UserId IS NULL
          OR ObjectLink_UnitFrom_Branch.ChildObjectId = tmpBranch.BranchId
          OR ObjectLink_UnitTo_Branch.ChildObjectId = tmpBranch.BranchId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.05.14                                                        * надо раскоментить права после отладки
 18.04.14                                                        * all new
 05.09.13                                        * add TotalCountPartner
 12.07.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_SendOnPrice (inStartDate:= '01.08.2015', inEndDate:= '01.08.2015', inIsPartnerDate:= FALSE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
