-- Function: gpSelect_Movement_SendOnPrice()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_SendOnPrice (TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_SendOnPrice_Reestr (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendOnPrice_Reestr(
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
             , OperDate_reestr TDateTime, InvNumber_reestr TVarChar
             , StatusCode_reestr Integer, StatusName_reestr TVarChar
             , CarName_reestr TVarChar, CarModelName_reestr TVarChar
             , PersonalDriverName_reestr TVarChar, MemberName_reestr TVarChar
             , InvNumber_Transport_reestr TVarChar, OperDate_Transport_reestr TDateTime

             , Date_Insert      TDateTime
             , Date_PartnerIn   TDateTime
             , Date_RemakeIn    TDateTime
             , Date_RemakeBuh   TDateTime
             , Date_Remake      TDateTime
             , Date_Buh         TDateTime
             , Date_TransferIn  TDateTime
             , Date_TransferOut TDateTime
             , Date_Double      TDateTime
             , Date_Scan        TDateTime
             
             , Member_Insert        TVarChar
             , Member_PartnerInTo   TVarChar
             , Member_PartnerInFrom TVarChar
             , Member_RemakeInTo    TVarChar
             , Member_RemakeInFrom  TVarChar
             , Member_RemakeBuh     TVarChar
             , Member_Remake        TVarChar
             , Member_Buh           TVarChar
             , Member_TransferIn    TVarChar
             , Member_TransferOut   TVarChar   
             , Member_Double        TVarChar
             , Member_Scan          TVarChar
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

           ---
           , Object_ReestrKind.Id                       AS ReestrKindId
           , Object_ReestrKind.ValueData                AS ReestrKindName

           , Movement_reestr.OperDate                   AS OperDate_reestr
           , Movement_reestr.InvNumber                  AS InvNumber_reestr
           , Object_Status_reestr.ObjectCode            AS StatusCode_reestr
           , Object_Status_reestr.ValueData             AS StatusName_reestr

           , Object_Car_reestr.ValueData                AS CarName_reestr
           --, Object_CarModel_reestr.ValueData           AS CarModelName_reestr
           , (COALESCE (Object_CarModel_reestr.ValueData,'') || COALESCE (' ' || Object_CarType_reestr.ValueData, '') ) ::TVarChar AS CarModelName_reestr
           , Object_PersonalDriver_reestr.PersonalName  AS PersonalDriverName_reestr
           , Object_Member_reestr.ValueData             AS MemberName_reestr

           , Movement_Transport_reestr.InvNumber        AS InvNumber_Transport_reestr
           , Movement_Transport_reestr.OperDate         AS OperDate_Transport_reestr

           , MIDate_Insert.ValueData         AS Date_Insert
           , MIDate_PartnerIn.ValueData      AS Date_PartnerIn
           , MIDate_RemakeIn.ValueData       AS Date_RemakeIn
           , MIDate_RemakeBuh.ValueData      AS Date_RemakeBuh
           , MIDate_Remake.ValueData         AS Date_Remake
           , MIDate_Buh.ValueData            AS Date_Buh
           , MIDate_TransferIn.ValueData     AS Date_TransferIn
           , MIDate_TransferOut.ValueData    AS Date_TransferOut
           , MIDate_Double.ValueData         AS Date_Double
           , MIDate_Scan.ValueData           AS Date_Scan
           
           , CASE WHEN MIDate_Insert.DescId IS NOT NULL THEN Object_ObjectMember.ValueData ELSE '' END :: TVarChar AS Member_Insert -- т.к. в "пустышках" - "криво" формируется это свойство
           , Object_PartnerInTo.ValueData    AS Member_PartnerInTo
           , Object_PartnerInFrom.ValueData  AS Member_PartnerInFrom
           , Object_RemakeInTo.ValueData     AS Member_RemakeInTo
           , Object_RemakeInFrom.ValueData   AS Member_RemakeInFrom
           , Object_RemakeBuh.ValueData      AS Member_RemakeBuh
           , Object_Remake.ValueData         AS Member_Remake
           , Object_Buh.ValueData            AS Member_Buh
           , Object_TransferIn.ValueData     AS Member_TransferIn
           , Object_TransferOut.ValueData    AS Member_TransferOut
           , Object_Double.ValueData         AS Member_Double
           , Object_Scan.ValueData           AS Member_Scan

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

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Production
                                           ON MovementLinkMovement_Production.MovementChildId = Movement.Id                                   --MovementLinkMovement_Production.MovementId = Movement.Id
                                          AND MovementLinkMovement_Production.DescId = zc_MovementLinkMovement_Production()
            LEFT JOIN Movement AS Movement_Production ON Movement_Production.Id = MovementLinkMovement_Production.MovementId  --MovementLinkMovement_Production.MovementChildId
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

            -- инфа из Рееста
            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                   AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_reestr 
                                   ON MI_reestr.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                  AND MI_reestr.isErased = FALSE
            LEFT JOIN Movement AS Movement_reestr ON Movement_reestr.Id = MI_reestr.MovementId
            LEFT JOIN Object AS Object_Status_reestr ON Object_Status_reestr.Id = Movement_reestr.StatusId

            LEFT JOIN MovementLinkObject AS MLO_Car_reestr
                                         ON MLO_Car_reestr.MovementId = Movement_reestr.Id
                                        AND MLO_Car_reestr.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car_reestr ON Object_Car_reestr.Id = MLO_Car_reestr.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel_reestr ON ObjectLink_Car_CarModel_reestr.ObjectId = Object_Car_reestr.Id
                                                                  AND ObjectLink_Car_CarModel_reestr.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel_reestr ON Object_CarModel_reestr.Id = ObjectLink_Car_CarModel_reestr.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType_reestr
                                 ON ObjectLink_Car_CarType_reestr.ObjectId = Object_Car_reestr.Id
                                AND ObjectLink_Car_CarType_reestr.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType_reestr ON Object_CarType_reestr.Id = ObjectLink_Car_CarType_reestr.ChildObjectId

            LEFT JOIN MovementLinkObject AS MLO_PersonalDriver_reestr
                                         ON MLO_PersonalDriver_reestr.MovementId = Movement_reestr.Id
                                        AND MLO_PersonalDriver_reestr.DescId     = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS Object_PersonalDriver_reestr ON Object_PersonalDriver_reestr.PersonalId = MLO_PersonalDriver_reestr.ObjectId

            LEFT JOIN MovementLinkObject AS MLO_Member_reestr
                                         ON MLO_Member_reestr.MovementId = Movement_reestr.Id
                                        AND MLO_Member_reestr.DescId     = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member_reestr ON Object_Member_reestr.Id = MLO_Member_reestr.ObjectId
            -- инфа из П/л (реестр)
            LEFT JOIN MovementLinkMovement AS MLM_Transport_reestr
                                           ON MLM_Transport_reestr.MovementId = Movement_reestr.Id
                                          AND MLM_Transport_reestr.DescId     = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport_reestr ON Movement_Transport_reestr.Id = MLM_Transport_reestr.MovementChildId

            --- протоколы Рееста
            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MI_reestr.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_PartnerIn
                                       ON MIDate_PartnerIn.MovementItemId = MI_reestr.Id
                                      AND MIDate_PartnerIn.DescId = zc_MIDate_PartnerIn()
            LEFT JOIN MovementItemDate AS MIDate_RemakeIn
                                       ON MIDate_RemakeIn.MovementItemId = MI_reestr.Id
                                      AND MIDate_RemakeIn.DescId = zc_MIDate_RemakeIn()
            LEFT JOIN MovementItemDate AS MIDate_RemakeBuh
                                       ON MIDate_RemakeBuh.MovementItemId = MI_reestr.Id
                                      AND MIDate_RemakeBuh.DescId = zc_MIDate_RemakeBuh()
            LEFT JOIN MovementItemDate AS MIDate_Remake
                                       ON MIDate_Remake.MovementItemId = MI_reestr.Id
                                      AND MIDate_Remake.DescId = zc_MIDate_Remake()
            LEFT JOIN MovementItemDate AS MIDate_Buh
                                       ON MIDate_Buh.MovementItemId = MI_reestr.Id
                                      AND MIDate_Buh.DescId = zc_MIDate_Buh()
            LEFT JOIN MovementItemDate AS MIDate_TransferIn
                                       ON MIDate_TransferIn.MovementItemId = MI_reestr.Id
                                      AND MIDate_TransferIn.DescId = zc_MIDate_TransferIn()
            LEFT JOIN MovementItemDate AS MIDate_TransferOut
                                       ON MIDate_TransferOut.MovementItemId = MI_reestr.Id
                                      AND MIDate_TransferOut.DescId = zc_MIDate_TransferOut()
            LEFT JOIN MovementItemDate AS MIDate_Double
                                       ON MIDate_Double.MovementItemId = MI_reestr.Id
                                      AND MIDate_Double.DescId = zc_MIDate_Double()
            LEFT JOIN MovementItemDate AS MIDate_Scan
                                       ON MIDate_Scan.MovementItemId = MI_reestr.Id
                                      AND MIDate_Scan.DescId = zc_MIDate_Scan()

            LEFT JOIN Object AS Object_ObjectMember ON Object_ObjectMember.Id = MI_reestr.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartnerInTo
                                             ON MILinkObject_PartnerInTo.MovementItemId = MI_reestr.Id
                                            AND MILinkObject_PartnerInTo.DescId = zc_MILinkObject_PartnerInTo()
            LEFT JOIN Object AS Object_PartnerInTo ON Object_PartnerInTo.Id = MILinkObject_PartnerInTo.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartnerInFrom
                                             ON MILinkObject_PartnerInFrom.MovementItemId = MI_reestr.Id
                                            AND MILinkObject_PartnerInFrom.DescId = zc_MILinkObject_PartnerInFrom()
            LEFT JOIN Object AS Object_PartnerInFrom ON Object_PartnerInFrom.Id = MILinkObject_PartnerInFrom.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_RemakeInTo
                                             ON MILinkObject_RemakeInTo.MovementItemId = MI_reestr.Id
                                            AND MILinkObject_RemakeInTo.DescId = zc_MILinkObject_RemakeInTo()
            LEFT JOIN Object AS Object_RemakeInTo ON Object_RemakeInTo.Id = MILinkObject_RemakeInTo.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_RemakeInFrom
                                             ON MILinkObject_RemakeInFrom.MovementItemId = MI_reestr.Id
                                            AND MILinkObject_RemakeInFrom.DescId = zc_MILinkObject_RemakeInFrom()
            LEFT JOIN Object AS Object_RemakeInFrom ON Object_RemakeInFrom.Id = MILinkObject_RemakeInFrom.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_RemakeBuh
                                             ON MILinkObject_RemakeBuh.MovementItemId = MI_reestr.Id
                                            AND MILinkObject_RemakeBuh.DescId = zc_MILinkObject_RemakeBuh()
            LEFT JOIN Object AS Object_RemakeBuh ON Object_RemakeBuh.Id = MILinkObject_RemakeBuh.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Remake
                                             ON MILinkObject_Remake.MovementItemId = MI_reestr.Id
                                            AND MILinkObject_Remake.DescId = zc_MILinkObject_Remake()
            LEFT JOIN Object AS Object_Remake ON Object_Remake.Id = MILinkObject_Remake.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Buh
                                             ON MILinkObject_Buh.MovementItemId = MI_reestr.Id
                                            AND MILinkObject_Buh.DescId = zc_MILinkObject_Buh()
            LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = MILinkObject_Buh.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_TransferIn
                                             ON MILinkObject_TransferIn.MovementItemId = MI_reestr.Id
                                            AND MILinkObject_TransferIn.DescId = zc_MILinkObject_TransferIn()
            LEFT JOIN Object AS Object_TransferIn ON Object_TransferIn.Id = MILinkObject_TransferIn.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_TransferOut
                                             ON MILinkObject_TransferOut.MovementItemId = MI_reestr.Id
                                            AND MILinkObject_TransferOut.DescId = zc_MILinkObject_TransferOut()
            LEFT JOIN Object AS Object_TransferOut ON Object_TransferOut.Id = MILinkObject_TransferOut.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Double
                                             ON MILinkObject_Double.MovementItemId = MI_reestr.Id
                                            AND MILinkObject_Double.DescId = zc_MILinkObject_Double()
            LEFT JOIN Object AS Object_Double ON Object_Double.Id = MILinkObject_Double.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Scan
                                             ON MILinkObject_Scan.MovementItemId = MI_reestr.Id
                                            AND MILinkObject_Scan.DescId = zc_MILinkObject_Scan()
            LEFT JOIN Object AS Object_Scan ON Object_Scan.Id = MILinkObject_Scan.ObjectId

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
 05.05.22         *
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
