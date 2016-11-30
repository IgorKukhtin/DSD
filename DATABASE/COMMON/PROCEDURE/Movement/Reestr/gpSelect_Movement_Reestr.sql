-- Function: gpSelect_Movement_Reestr()

DROP FUNCTION IF EXISTS gpSelect_Movement_Reestr (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Reestr(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean   ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UpdateName TVarChar, UpdateDate TDateTime
             , CarName TVarChar, CarModelName TVarChar
             , PersonalDriverName TVarChar
             , MemberName TVarChar

             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime -- , InvNumber_Transport_Full TVarChar
             , StatusCode_Transport Integer, StatusName_Transport TVarChar

             , ReestrKindId Integer, ReestrKindName TVarChar
             , InvNumber_Sale TVarChar, OperDate_Sale TDateTime
             , StatusCode_Sale Integer, StatusName_Sale TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , InvNumberOrder TVarChar, RouteGroupName TVarChar, RouteName TVarChar
             , FromName TVarChar, ToName TVarChar
             , TotalSumm TFloat
             , PaidKindName TVarChar
             , ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , JuridicalName_To TVarChar, OKPO_To TVarChar 

             , Date_Insert    TDateTime
             , Date_PartnerIn TDateTime
             , Date_RemakeIn  TDateTime
             , Date_RemakeBuh TDateTime
             , Date_Remake    TDateTime
             , Date_Buh       TDateTime

             , Member_Insert        TVarChar
             , Member_PartnerInTo   TVarChar
             , Member_PartnerInFrom TVarChar
             , Member_RemakeInTo    TVarChar
             , Member_RemakeInFrom  TVarChar
             , Member_RemakeBuh     TVarChar
             , Member_Remake        TVarChar
             , Member_Buh           TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Reestr());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          AS StatusCode
           , Object_Status.ValueData           AS StatusName

           , Object_Update.ValueData           AS UpdateName
           , MovementDate_Update.ValueData     AS UpdateDate

           , Object_Car.ValueData              AS CarName
           , Object_CarModel.ValueData         AS CarModelName
           , View_PersonalDriver.PersonalName  AS PersonalDriverName
           , Object_Member.ValueData           AS MemberName

           , Movement_Transport.Id             AS MovementId_Transport
           , Movement_Transport.InvNumber      AS InvNumber_Transport
           , Movement_Transport.OperDate       AS OperDate_Transport
           -- , ('� ' || Movement_Transport.InvNumber || ' �� ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport_Full
           , Object_Status_Transport.ObjectCode AS StatusCode_Transport
           , Object_Status_Transport.ValueData  AS StatusName_Transport

           , Object_ReestrKind.Id            AS ReestrKindId
           , Object_ReestrKind.ValueData     AS ReestrKindName
           , Movement_Sale.InvNumber         AS InvNumber_Sale
           , Movement_Sale.OperDate          AS OperDate_Sale
           , Object_Status_Sale.ObjectCode   AS StatusCode_Sale
           , Object_Status_Sale.ValueData    AS StatusName_Sale

           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
           , MovementString_InvNumberOrder.ValueData   AS InvNumberOrder
           , Object_RouteGroup.ValueData               AS RouteGroupName
           , Object_Route.ValueData                    AS RouteName

           , Object_From.ValueData                     AS FromName
           , Object_To.ValueData                       AS ToName
           , MovementFloat_TotalSumm.ValueData         AS TotalSumm
           , Object_PaidKind.ValueData                 AS PaidKindName
           , View_Contract_InvNumber.ContractCode      AS ContractCode
           , View_Contract_InvNumber.InvNumber         AS ContractName
           , View_Contract_InvNumber.ContractTagName
           , Object_JuridicalTo.ValueData              AS JuridicalName_To
           , ObjectHistory_JuridicalDetails_View.OKPO  AS OKPO_To

           , MIDate_Insert.ValueData         AS Date_Insert
           , MIDate_PartnerIn.ValueData      AS Date_PartnerIn
           , MIDate_RemakeIn.ValueData       AS Date_RemakeIn
           , MIDate_RemakeBuh.ValueData      AS Date_RemakeBuh
           , MIDate_Remake.ValueData         AS Date_Remake
           , MIDate_Buh.ValueData            AS Date_Buh

           , CASE WHEN MIDate_Insert.DescId IS NOT NULL THEN Object_ObjectMember.ValueData ELSE '' END :: TVarChar AS Member_Insert -- �.�. � "���������" - "�����" ����������� ��� ��������
           , Object_PartnerInTo.ValueData    AS Member_PartnerInTo
           , Object_PartnerInFrom.ValueData  AS Member_PartnerInFrom
           , Object_RemakeInTo.ValueData     AS Member_RemakeInTo
           , Object_RemakeInFrom.ValueData   AS Member_RemakeInFrom
           , Object_RemakeBuh.ValueData      AS Member_RemakeBuh
           , Object_Remake.ValueData         AS Member_Remake
           , Object_Buh.ValueData            AS Member_Buh

       FROM (SELECT Movement.Id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Reestr() AND Movement.StatusId = tmpStatus.StatusId
             ) AS tmpMovement

            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId  

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
            LEFT JOIN Object AS Object_Status_Transport ON Object_Status_Transport.Id = Movement_Transport.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                 ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            -- �������� ����� �������
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
            LEFT JOIN Object AS Object_ObjectMember ON Object_ObjectMember.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_PartnerIn
                                       ON MIDate_PartnerIn.MovementItemId = MovementItem.Id
                                      AND MIDate_PartnerIn.DescId = zc_MIDate_PartnerIn()
            LEFT JOIN MovementItemDate AS MIDate_RemakeIn
                                       ON MIDate_RemakeIn.MovementItemId = MovementItem.Id
                                      AND MIDate_RemakeIn.DescId = zc_MIDate_RemakeIn()
            LEFT JOIN MovementItemDate AS MIDate_RemakeBuh
                                       ON MIDate_RemakeBuh.MovementItemId = MovementItem.Id
                                      AND MIDate_RemakeBuh.DescId = zc_MIDate_RemakeBuh()
            LEFT JOIN MovementItemDate AS MIDate_Remake
                                       ON MIDate_Remake.MovementItemId = MovementItem.Id
                                      AND MIDate_Remake.DescId = zc_MIDate_Remake()
            LEFT JOIN MovementItemDate AS MIDate_Buh
                                       ON MIDate_Buh.MovementItemId = MovementItem.Id
                                      AND MIDate_Buh.DescId = zc_MIDate_Buh()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartnerInTo
                                             ON MILinkObject_PartnerInTo.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartnerInTo.DescId = zc_MILinkObject_PartnerInTo()
            LEFT JOIN Object AS Object_PartnerInTo ON Object_PartnerInTo.Id = MILinkObject_PartnerInTo.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartnerInFrom
                                             ON MILinkObject_PartnerInFrom.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartnerInFrom.DescId = zc_MILinkObject_PartnerInFrom()
            LEFT JOIN Object AS Object_PartnerInFrom ON Object_PartnerInFrom.Id = MILinkObject_PartnerInFrom.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_RemakeInTo
                                             ON MILinkObject_RemakeInTo.MovementItemId = MovementItem.Id
                                            AND MILinkObject_RemakeInTo.DescId = zc_MILinkObject_RemakeInTo()
            LEFT JOIN Object AS Object_RemakeInTo ON Object_RemakeInTo.Id = MILinkObject_RemakeInTo.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_RemakeInFrom
                                             ON MILinkObject_RemakeInFrom.MovementItemId = MovementItem.Id
                                            AND MILinkObject_RemakeInFrom.DescId = zc_MILinkObject_RemakeInFrom()
            LEFT JOIN Object AS Object_RemakeInFrom ON Object_RemakeInFrom.Id = MILinkObject_RemakeInFrom.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_RemakeBuh
                                             ON MILinkObject_RemakeBuh.MovementItemId = MovementItem.Id
                                            AND MILinkObject_RemakeBuh.DescId = zc_MILinkObject_RemakeBuh()
            LEFT JOIN Object AS Object_RemakeBuh ON Object_RemakeBuh.Id = MILinkObject_RemakeBuh.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Remake
                                             ON MILinkObject_Remake.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Remake.DescId = zc_MILinkObject_Remake()
            LEFT JOIN Object AS Object_Remake ON Object_Remake.Id = MILinkObject_Remake.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Buh
                                             ON MILinkObject_Buh.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Buh.DescId = zc_MILinkObject_Buh()
            LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = MILinkObject_Buh.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.ValueData ::integer = MovementItem.Id -- tmpMI.MovementItemId
                                   AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementFloat_MovementItemId.MovementId
            LEFT JOIN Object AS Object_Status_Sale ON Object_Status_Sale.Id = Movement_Sale.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_Sale.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId


            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalTo.Id
           
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_Sale.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_Sale.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId = Movement_Sale.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement_Sale.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Route_RouteGroup ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                                               AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()
            LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = COALESCE (ObjectLink_Route_RouteGroup.ChildObjectId, Object_Route.Id)
     ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 20.10.16         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Reestr (inStartDate:= '20.10.2016', inEndDate:= '25.10.2016', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
