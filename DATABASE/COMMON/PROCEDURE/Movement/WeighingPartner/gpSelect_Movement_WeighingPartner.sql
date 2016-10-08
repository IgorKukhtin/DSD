-- Function: gpSelect_Movement_WeighingPartner()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingPartner (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingPartner (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingPartner (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingPartner(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , MovementId_TransportGoods Integer, InvNumber_TransportGoods TVarChar, OperDate_TransportGoods TDateTime
             , MovementId_Tax Integer, InvNumberPartner_Tax TVarChar, OperDate_Tax TDateTime
             , StartWeighing TDateTime, EndWeighing TDateTime 
             , MovementDescNumber Integer, MovementDescName TVarChar
             , WeighingNumber TFloat
             , InvNumberOrder TVarChar
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime
             , CarName TVarChar, CarModelName TVarChar, PersonalDriverName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalCountPartner TFloat, TotalCountTare TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromName TVarChar, ToName TVarChar
             , PaidKindName TVarChar
             , ContractName TVarChar, ContractTagName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , RouteSortingName TVarChar, RouteGroupName TVarChar, RouteName TVarChar
             , PersonalCode1 Integer, PersonalName1 TVarChar
             , PersonalCode2 Integer, PersonalName2 TVarChar
             , PersonalCode3 Integer, PersonalName3 TVarChar
             , PersonalCode4 Integer, PersonalName4 TVarChar
             , PositionCode1 Integer, PositionName1 TVarChar
             , PositionCode2 Integer, PositionName2 TVarChar
             , PositionCode3 Integer, PositionName3 TVarChar
             , PositionCode4 Integer, PositionName4 TVarChar
             , UserName TVarChar
             , isPromo Boolean
             , MovementPromo TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsXleb Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY 
     /*WITH tmpUserAdmin AS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND NOT EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )*/
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                         UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                              )

       SELECT  Movement.Id
             , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , Movement_Parent.Id                AS MovementId_parent
             , Movement_Parent.OperDate          AS OperDate_parent
             , CASE WHEN Movement_Parent.StatusId = zc_Enum_Status_Complete()
                         THEN Movement_Parent.InvNumber
                    WHEN Movement_Parent.StatusId = zc_Enum_Status_UnComplete()
                         THEN '***' || Movement_Parent.InvNumber
                    WHEN Movement_Parent.StatusId = zc_Enum_Status_Erased()
                         THEN '*' || Movement_Parent.InvNumber
                    ELSE ''
               END :: TVarChar AS InvNumber_parent

             , Movement_TransportGoods.Id            AS MovementId_TransportGoods
             , Movement_TransportGoods.InvNumber     AS InvNumber_TransportGoods
             , Movement_TransportGoods.OperDate      AS OperDate_TransportGoods

             , Movement_Tax.Id                       AS MovementId_Tax
             , CASE WHEN Movement_Tax.StatusId = zc_Enum_Status_Complete() AND MS_InvNumberPartner_Tax.ValueData <> ''
                         THEN MS_InvNumberPartner_Tax.ValueData
                    WHEN Movement_Tax.StatusId = zc_Enum_Status_Complete()
                         THEN '_' || Movement_Tax.InvNumber
                    WHEN Movement_Tax.StatusId = zc_Enum_Status_UnComplete()
                         THEN '***' || Movement_Tax.InvNumber
                    WHEN Movement_Tax.StatusId = zc_Enum_Status_Erased()
                         THEN '*' || Movement_Tax.InvNumber
                    ELSE ''
               END :: TVarChar AS InvNumberPartner_Tax
             , Movement_Tax.OperDate                 AS OperDate_Tax

             , MovementDate_StartWeighing.ValueData  AS StartWeighing  
             , MovementDate_EndWeighing.ValueData    AS EndWeighing

             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.ItemName                      AS MovementDescName
             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder
            
             , Movement_Transport.Id                     AS MovementId_Transport
             , Movement_Transport.InvNumber              AS InvNumber_Transport
             , Movement_Transport.OperDate               AS OperDate_Transport
             , Object_Car.ValueData                      AS CarName
             , Object_CarModel.ValueData                 AS CarModelName
             , View_PersonalDriver.PersonalName          AS PersonalDriverName

             , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData             AS VATPercent
             , MovementFloat_ChangePercent.ValueData          AS ChangePercent
             , MovementFloat_TotalCount.ValueData             AS TotalCount
             , MovementFloat_TotalCountPartner.ValueData      AS TotalCountPartner
             , MovementFloat_TotalCountTare.ValueData         AS TotalCountTare
             , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
             , MovementFloat_TotalSummMVAT.ValueData          AS TotalSummMVAT
             , MovementFloat_TotalSummPVAT.ValueData          AS TotalSummPVAT
             , MovementFloat_TotalSumm.ValueData              AS TotalSumm

             , Object_From.ValueData              AS FromName
             , (CASE WHEN MovementDesc.Id = zc_Movement_Loss() AND Object_PersonalLoss.Id > 0 THEN '(' || Object_PersonalLoss.ObjectCode :: TVarChar || ')' || Object_PersonalLoss.ValueData || ' ***' ELSE '' END || Object_To.ValueData) :: TVarChar AS ToName

             , Object_PaidKind.ValueData          AS PaidKindName
             , View_Contract_InvNumber.InvNumber  AS ContractName
             , View_Contract_InvNumber.ContractTagName

             , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
             , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
             , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
             , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

             , '' :: TVarChar                     AS RouteSortingName
             , Object_RouteGroup.ValueData        AS RouteGroupName
             , Object_Route.ValueData             AS RouteName

             , Object_Personal1.ObjectCode AS PersonalCode1, Object_Personal1.ValueData AS PersonalName1
             , Object_Personal2.ObjectCode AS PersonalCode2, Object_Personal2.ValueData AS PersonalName2
             , Object_Personal3.ObjectCode AS PersonalCode3, Object_Personal3.ValueData AS PersonalName3
             , Object_Personal4.ObjectCode AS PersonalCode4, Object_Personal4.ValueData AS PersonalName4

             , Object_Position1.ObjectCode AS PositionCode1, Object_Position1.ValueData AS PositionName1
             , Object_Position2.ObjectCode AS PositionCode2, Object_Position2.ValueData AS PositionName2
             , Object_Position3.ObjectCode AS PositionCode3, Object_Position3.ValueData AS PositionName3
             , Object_Position4.ObjectCode AS PositionCode4, Object_Position4.ValueData AS PositionName4

             , Object_User.ValueData              AS UserName

             , COALESCE (MovementBoolean_Promo.ValueData, False) AS isPromo
             , zfCalc_PromoMovementName (NULL, Movement_Promo.InvNumber :: TVarChar, Movement_Promo.OperDate, MD_StartSale.ValueData, MD_EndSale.ValueData) AS MovementPromo

       FROM tmpStatus
            INNER JOIN Movement ON Movement.DescId = zc_Movement_WeighingPartner()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.StatusId = tmpStatus.StatusId
            INNER JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement_Parent.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                   ON MovementDate_StartWeighing.MovementId =  Movement.Id
                                  AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
            LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                   ON MovementDate_EndWeighing.MovementId =  Movement.Id
                                  AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()
                                  
            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                    ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
            LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData :: Integer -- COALESCE (Movement_Parent.DescId, MovementFloat_MovementDesc.ValueData)

            LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber
                                    ON MovementFloat_WeighingNumber.MovementId =  Movement.Id
                                   AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()

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
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_PersonalLoss ON Object_PersonalLoss.Id = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal1
                                         ON MovementLinkObject_Personal1.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal1.DescId = zc_MovementLinkObject_PersonalComplete1()
            LEFT JOIN Object AS Object_Personal1 ON Object_Personal1.Id = MovementLinkObject_Personal1.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal2
                                         ON MovementLinkObject_Personal2.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal2.DescId = zc_MovementLinkObject_PersonalComplete2()
            LEFT JOIN Object AS Object_Personal2 ON Object_Personal2.Id = MovementLinkObject_Personal2.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal3
                                         ON MovementLinkObject_Personal3.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal3.DescId = zc_MovementLinkObject_PersonalComplete3()
            LEFT JOIN Object AS Object_Personal3 ON Object_Personal3.Id = MovementLinkObject_Personal3.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal4
                                         ON MovementLinkObject_Personal4.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal4.DescId = zc_MovementLinkObject_PersonalComplete4()
            LEFT JOIN Object AS Object_Personal4 ON Object_Personal4.Id = MovementLinkObject_Personal4.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position1
                                         ON MovementLinkObject_Position1.MovementId = Movement.Id
                                        AND MovementLinkObject_Position1.DescId = zc_MovementLinkObject_PositionComplete1()
            LEFT JOIN Object AS Object_Position1 ON Object_Position1.Id = MovementLinkObject_Position1.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position2
                                         ON MovementLinkObject_Position2.MovementId = Movement.Id
                                        AND MovementLinkObject_Position2.DescId = zc_MovementLinkObject_PositionComplete2()
            LEFT JOIN Object AS Object_Position2 ON Object_Position2.Id = MovementLinkObject_Position2.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position3
                                         ON MovementLinkObject_Position3.MovementId = Movement.Id
                                        AND MovementLinkObject_Position3.DescId = zc_MovementLinkObject_PositionComplete3()
            LEFT JOIN Object AS Object_Position3 ON Object_Position3.Id = MovementLinkObject_Position3.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position4
                                         ON MovementLinkObject_Position4.MovementId = Movement.Id
                                        AND MovementLinkObject_Position4.DescId = zc_MovementLinkObject_PositionComplete4()
            LEFT JOIN Object AS Object_Position4 ON Object_Position4.Id = MovementLinkObject_Position4.ObjectId


            LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId = Movement.Id
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                           ON MovementLinkMovement_Tax.MovementId = Movement.ParentId
                                          AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_Tax ON MS_InvNumberPartner_Tax.MovementId = MovementLinkMovement_Tax.MovementChildId
                                                               AND MS_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            --LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Route_RouteGroup ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                                               AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()
            LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = COALESCE (ObjectLink_Route_RouteGroup.ChildObjectId, Object_Route.Id)

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
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                      ON MovementBoolean_Promo.MovementId =  Movement_Parent.Id
                                     AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Promo
                                           ON MovementLinkMovement_Promo.MovementId = Movement_Parent.Id
                                          AND MovementLinkMovement_Promo.DescId = zc_MovementLinkMovement_Promo()
            LEFT JOIN Movement AS Movement_Promo ON Movement_Promo.Id = MovementLinkMovement_Promo.MovementChildId
            LEFT JOIN MovementDate AS MD_StartSale
                                   ON MD_StartSale.MovementId =  Movement_Promo.Id
                                  AND MD_StartSale.DescId = zc_MovementDate_StartSale()
            LEFT JOIN MovementDate AS MD_EndSale
                                   ON MD_EndSale.MovementId =  Movement_Promo.Id
                                  AND MD_EndSale.DescId = zc_MovementDate_EndSale()
           ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_WeighingPartner (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.10.16         * add inJuridicalBasisId
 04.10.16         * add AccessKey
 11.10.14                                        * all
 11.03.14         *
*/

/*
update Movement set AccessKeyId = xxx
from (select Movement.Id, MovementLinkObject_User.ObjectId
, lpGetAccessKey (ObjectId, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()) as xxx
, Movement.OperDate
      from  Movement ,     MovementLinkObject AS MovementLinkObject_User
where Movement.DescId = zc_Movement_WeighingPartner()
and Movement.AccessKeyId is null
and MovementLinkObject_User.MovementId = Movement.Id
AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()

and MovementLinkObject_User.ObjectId <> 300521 

order by Movement.Id desc limit 10000
) as tmp
where Movement.Id = tmp.Id
*/

-- ����
-- SELECT * FROM gpSelect_Movement_WeighingPartner (inStartDate:= '01.06.2016', inEndDate:= '02.06.2016', inJuridicalBasisId:= zc_Juridical_Basis(), inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
