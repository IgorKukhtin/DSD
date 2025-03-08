-- Function: gpSelect_Movement_SendOnPrice()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_SendOnPrice (TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_SendOnPrice (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendOnPrice(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsPartnerDate      Boolean ,
    IN inIsErased           Boolean ,
    IN inJuridicalBasisId   Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCountTare TFloat, TotalCount TFloat, TotalCountPartner TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , TotalCountKgFrom TFloat, TotalCountShFrom TFloat, TotalSummFrom TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar, RouteGroupName TVarChar, RouteName TVarChar, PersonalName TVarChar
             , MovementId_Order Integer, InvNumber_Order TVarChar
             , RetailName_order TVarChar
             , PartnerName_order TVarChar
             , Comment_order TVarChar

             , EdiOrdspr Boolean, EdiInvoice Boolean, EdiDesadv Boolean
             , isEdiOrdspr_partner Boolean, isEdiInvoice_partner Boolean, isEdiDesadv_partner Boolean

             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime, InvNumber_Transport_Full TVarChar
             , CarName TVarChar, CarModelName TVarChar, PersonalDriverName TVarChar
             , Comment TVarChar
             , MovementId_Production Integer, InvNumber_ProductionFull TVarChar

             , MovementId_TransportGoods Integer, InvNumber_TransportGoods TVarChar
             , OperDate_TransportGoods TDateTime, OperDate_TransportGoods_calc TDateTime

             , CheckedName   TVarChar
             , CheckedDate   TDateTime
             , Checked       Boolean
             , isHistoryCost Boolean

             , ReestrKindId Integer, ReestrKindName TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SendOnPrice());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId GROUP BY UserId)
        , tmpBranch AS (SELECT Object_RoleAccessKeyGuide_View.BranchId, Object_RoleAccessKeyGuide_View.UserId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId, Object_RoleAccessKeyGuide_View.UserId)
        , tmpMLM_Production AS (SELECT Movement.* 
                                     , MovementLinkMovement_Production.MovementChildId
                                     , ROW_NUMBER() OVER (PARTITION BY MovementLinkMovement_Production.MovementChildId
                                                          ORDER BY CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN 1
                                                                        WHEN Movement.StatusId = zc_Enum_Status_UnComplete() THEN 2
                                                                        ELSE 3
                                                                   END
                                                         ) AS Ord
                                FROM Movement
                                      INNER JOIN MovementLinkMovement AS MovementLinkMovement_Production
                                                                      ON MovementLinkMovement_Production.MovementId = Movement.Id                                   --MovementLinkMovement_Production.MovementId = Movement.Id
                                                                     AND MovementLinkMovement_Production.DescId          = zc_MovementLinkMovement_Production()
                                 WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                   AND Movement.DescId = zc_Movement_ProductionUnion()
                               )
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
           , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName

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

           , MovementFloat_TotalCountKgFrom.ValueData       AS TotalCountKgFrom
           , MovementFloat_TotalCountShFrom.ValueData       AS TotalCountShFrom
           , MovementFloat_TotalSummFrom.ValueData          AS TotalSummFrom

           , Object_From.Id                             AS FromId
           , Object_From.ValueData                      AS FromName
           , Object_To.Id                               AS ToId
           , Object_To.ValueData                        AS ToName

           , Object_RouteSorting.Id                     AS RouteSortingId
           , Object_RouteSorting.ValueData              AS RouteSortingName
           , Object_RouteGroup.ValueData                AS RouteGroupName
           , Object_Route.ValueData                     AS RouteName
           , Object_Personal.ValueData                  AS PersonalName

           , MovementLinkMovement_Order.MovementChildId AS MovementId_Order
           , Movement_Order.InvNumber                   AS InvNumber_Order
           , Object_Retail_order.ValueData              AS RetailName_order
           , Object_Partner_order.ValueData             AS PartnerName_order
           , TRIM (COALESCE (MovementString_Comment_order.ValueData, '')) :: TVarChar AS Comment_order

           , COALESCE (MovementBoolean_EdiOrdspr.ValueData, FALSE)    AS EdiOrdspr
           , COALESCE (MovementBoolean_EdiInvoice.ValueData, FALSE)   AS EdiInvoice
           , COALESCE (MovementBoolean_EdiDesadv.ValueData, FALSE)    AS EdiDesadv

           , COALESCE (ObjectBoolean_EdiOrdspr.ValueData, CAST (False AS Boolean))     AS isEdiOrdspr_partner
           , COALESCE (ObjectBoolean_EdiInvoice.ValueData, CAST (False AS Boolean))    AS isEdiInvoice_partner
           , COALESCE (ObjectBoolean_EdiDesadv.ValueData, CAST (False AS Boolean))     AS isEdiDesadv_partner
        
           , Movement_Transport.Id                     AS MovementId_Transport
           , Movement_Transport.InvNumber              AS InvNumber_Transport
           , Movement_Transport.OperDate               AS OperDate_Transport
           , ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport_Full 
           , Object_Car.ValueData                      AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , View_PersonalDriver.PersonalName          AS PersonalDriverName

           , MovementString_Comment.ValueData          AS Comment

           , Movement_Production.Id               AS MovementId_Production
           , (CASE WHEN Movement_Production.StatusId = zc_Enum_Status_Erased()
                       THEN '???'
                   WHEN Movement_Production.StatusId = zc_Enum_Status_UnComplete()
                       THEN '?'
                   ELSE ''
              END
           || zfCalc_PartionMovementName (CASE WHEN MovementBoolean_Peresort.ValueData = TRUE THEN -1 ELSE 1 END * Movement_Production.DescId, MovementDesc_Production.ItemName, Movement_Production.InvNumber, Movement_Production.OperDate)
             ) :: TVarChar AS InvNumber_ProductionFull

           , Movement_TransportGoods.Id                     AS MovementId_TransportGoods
           , Movement_TransportGoods.InvNumber              AS InvNumber_TransportGoods
           , Movement_TransportGoods.OperDate               AS OperDate_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, Movement.OperDate) :: TDateTime AS OperDate_TransportGoods_calc

           , Object_Checked.ValueData           AS CheckedName
           , MovementDate_Checked.ValueData     AS CheckedDate
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE)     AS Checked
           , COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) AS isHistoryCost
           
           , Object_ReestrKind.Id             		    AS ReestrKindId
           , Object_ReestrKind.ValueData       		    AS ReestrKindName

           , Object_SubjectDoc.Id                                 AS SubjectDocId
           , COALESCE (Object_SubjectDoc.ValueData,'') ::TVarChar AS SubjectDocName

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
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()


            LEFT JOIN MovementBoolean AS MovementBoolean_EdiOrdspr
                                      ON MovementBoolean_EdiOrdspr.MovementId = Movement.Id
                                     AND MovementBoolean_EdiOrdspr.DescId = zc_MovementBoolean_EdiOrdspr()

            LEFT JOIN MovementBoolean AS MovementBoolean_EdiInvoice
                                      ON MovementBoolean_EdiInvoice.MovementId = Movement.Id
                                     AND MovementBoolean_EdiInvoice.DescId = zc_MovementBoolean_EdiInvoice()

            LEFT JOIN MovementBoolean AS MovementBoolean_EdiDesadv
                                      ON MovementBoolean_EdiDesadv.MovementId = Movement.Id
                                     AND MovementBoolean_EdiDesadv.DescId = zc_MovementBoolean_EdiDesadv()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKgFrom
                                    ON MovementFloat_TotalCountKgFrom.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountKgFrom.DescId = zc_MovementFloat_TotalCountKgFrom()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountShFrom
                                    ON MovementFloat_TotalCountShFrom.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountShFrom.DescId = zc_MovementFloat_TotalCountShFrom()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                    ON MovementFloat_TotalSummFrom.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()

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
      
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner_order
                                         ON MovementLinkObject_Partner_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Partner_order.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner_order ON Object_Partner_order.Id = MovementLinkObject_Partner_order.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail_order
                                         ON MovementLinkObject_Retail_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Retail_order.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail_order ON Object_Retail_order.Id = MovementLinkObject_Retail_order.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment_order
                                     ON MovementString_Comment_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                    AND MovementString_Comment_order.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Route_RouteGroup ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                                               AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()
            LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = COALESCE (ObjectLink_Route_RouteGroup.ChildObjectId, Object_Route.Id)

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId
          
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
--
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN tmpMLM_Production AS Movement_Production
                                        ON Movement_Production.MovementChildId = Movement.Id
                                       AND Movement_Production.Ord             = 1
            LEFT JOIN MovementDesc AS MovementDesc_Production ON MovementDesc_Production.Id = Movement_Production.DescId
            LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                      ON MovementBoolean_Peresort.MovementId =  Movement_Production.Id
                                     AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId = Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                      ON MovementBoolean_HistoryCost.MovementId = Movement.Id
                                     AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()

            LEFT JOIN MovementDate AS MovementDate_Checked 
                                   ON MovementDate_Checked.MovementId = Movement.Id
                                  AND MovementDate_Checked.DescId = zc_MovementDate_Checked()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Checked
                                         ON MovementLinkObject_Checked.MovementId = Movement.Id
                                        AND MovementLinkObject_Checked.DescId = zc_MovementLinkObject_Checked()
            LEFT JOIN Object AS Object_Checked ON Object_Checked.Id = MovementLinkObject_Checked.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

       WHERE (tmpBranch.UserId IS NULL
           OR ObjectLink_UnitFrom_Branch.ChildObjectId = tmpBranch.BranchId
           OR ObjectLink_UnitTo_Branch.ChildObjectId = tmpBranch.BranchId
           OR tmpBranch.UserId = 280162 -- Панасенко А.Н.
             )
      ;
                                               
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.02.20         *
 11.10.18         *
 05.10.16         * add inJuridicalBasisId
 03.10.16         * add Movement_Production
 05.05.14                                                        * надо раскоментить права после отладки
 18.04.14                                                        * all new
 05.09.13                                        * add TotalCountPartner
 12.07.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_SendOnPrice (inStartDate:= '01.08.2016', inEndDate:= '01.08.2016', inIsPartnerDate:= FALSE, inIsErased:= TRUE, inJuridicalBasisId:=0, inSession:= zfCalc_UserAdmin())
