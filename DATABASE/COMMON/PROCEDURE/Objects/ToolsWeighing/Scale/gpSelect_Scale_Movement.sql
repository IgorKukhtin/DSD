-- Function: gpSelect_Scale_Movement()

DROP FUNCTION IF EXISTS gpSelect_Scale_Movement (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Movement(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsComlete   Boolean ,
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , MovementId_TransportGoods Integer, InvNumber_TransportGoods TVarChar, OperDate_TransportGoods TDateTime
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime, StartRunPlan TDateTime
             , CarName TVarChar, RouteName TVarChar, PersonalDriverName TVarChar
             , MovementId_Tax Integer, InvNumberPartner_Tax TVarChar, OperDate_Tax TDateTime
             , StartWeighing TDateTime, EndWeighing TDateTime 
             , MovementDescNumber Integer, MovementDescId Integer, MovementDescName TVarChar
             , WeighingNumber TFloat
             , MovementId_Order Integer, InvNumberOrder TVarChar
             , ChangePercent TFloat
             , TotalCount TFloat, TotalCountTare TFloat
             , TotalSumm TFloat
             , FromName TVarChar, ToName TVarChar
             , PaidKindName TVarChar
             , ContractName TVarChar, ContractTagName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar

             , MovementId_Reestr Integer, InvNumber_Reestr Integer, OperDate_Reestr TDateTime, ReestrKindId Integer, ReestrKindName TVarChar

             , PersonalId1 Integer, PersonalCode1 Integer, PersonalName1 TVarChar
             , PersonalId2 Integer, PersonalCode2 Integer, PersonalName2 TVarChar
             , PersonalId3 Integer, PersonalCode3 Integer, PersonalName3 TVarChar
             , PersonalId4 Integer, PersonalCode4 Integer, PersonalName4 TVarChar
             , PositionId1 Integer, PositionCode1 Integer, PositionName1 TVarChar
             , PositionId2 Integer, PositionCode2 Integer, PositionName2 TVarChar
             , PositionId3 Integer, PositionCode3 Integer, PositionName3 TVarChar
             , PositionId4 Integer, PositionCode4 Integer, PositionName4 TVarChar
             , EdiOrdspr Boolean, EdiInvoice Boolean, EdiDesadv Boolean
             , UserName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!��������!!! ������� ��������
     IF EXISTS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin(), 428386, 447972, 326391) AND ObjectLink_UserRole_View.UserId = vbUserId) -- ??? + �������� �� + ��������� �� �������� + ������������ ����� �� �����
     THEN vbUserId:= 0;
     END IF;


     -- ���������
     RETURN QUERY 
     /*WITH tmpUserAdmin AS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND NOT EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )*/
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId WHERE inIsComlete = TRUE
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
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

             , Movement_Transport.Id            AS MovementId_Transport
             , Movement_Transport.InvNumber     AS InvNumber_Transport
             , Movement_Transport.OperDate      AS OperDate_Transport
             , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRunPlan.ValueData) AS TDateTime) AS StartRunPlan
             , (COALESCE (Object_Car.ValueData, '') || ' ' || COALESCE (Object_CarModel.ValueData, '')) :: TVarChar AS CarName
             , Object_Route.ValueData           AS RouteName
             , Object_PersonalDriver.ValueData  AS PersonalDriverName

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
             , MovementDesc.Id                            AS MovementDescId
             , MovementDesc.ItemName                      AS MovementDescName
             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , MovementLinkMovement_Order.MovementChildId AS MovementId_Order
             , Movement_Order.InvNumber                   AS InvNumberOrder

             , MovementFloat_ChangePercent.ValueData          AS ChangePercent
             , MovementFloat_TotalCount.ValueData             AS TotalCount
             , MovementFloat_TotalCountTare.ValueData         AS TotalCountTare
             , MovementFloat_TotalSumm.ValueData              AS TotalSumm

             , Object_From.ValueData              AS FromName
             , (CASE WHEN MovementDesc.Id = zc_Movement_Loss() AND Object_PersonalLoss.Id > 0 THEN '(' || Object_PersonalLoss.ObjectCode :: TVarChar || ')' || Object_PersonalLoss.ValueData || ' ***' ELSE '' END || Object_To.ValueData) :: TVarChar AS ToName

             , Object_PaidKind.ValueData          AS PaidKindName
             , View_Contract_InvNumber.InvNumber  AS ContractName
             , View_Contract_InvNumber.ContractTagName

             , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
             , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

             , MI_Reestr.MovementId                           AS MovementId_Reestr
             , Movement_Reestr.InvNumber :: Integer           AS InvNumber_Reestr
             , Movement_Reestr.OperDate                       AS OperDate_Reestr
             , Object_ReestrKind.Id             	      AS ReestrKindId
             , Object_ReestrKind.ValueData       	      AS ReestrKindName


             , Object_Personal1.Id AS PersonalId1, Object_Personal1.ObjectCode AS PersonalCode1, Object_Personal1.ValueData AS PersonalName1
             , Object_Personal2.Id AS PersonalId2, Object_Personal2.ObjectCode AS PersonalCode2, Object_Personal2.ValueData AS PersonalName2
             , Object_Personal3.Id AS PersonalId3, Object_Personal3.ObjectCode AS PersonalCode3, Object_Personal3.ValueData AS PersonalName3
             , Object_Personal4.Id AS PersonalId4, Object_Personal4.ObjectCode AS PersonalCode4, Object_Personal4.ValueData AS PersonalName4

             , Object_Position1.Id AS PositionId1, Object_Position1.ObjectCode AS PositionCode1, Object_Position1.ValueData AS PositionName1
             , Object_Position2.Id AS PositionId2, Object_Position2.ObjectCode AS PositionCode2, Object_Position2.ValueData AS PositionName2
             , Object_Position3.Id AS PositionId3, Object_Position3.ObjectCode AS PositionCode3, Object_Position3.ValueData AS PositionName3
             , Object_Position4.Id AS PositionId4, Object_Position4.ObjectCode AS PositionCode4, Object_Position4.ValueData AS PositionName4

             , COALESCE (MovementBoolean_EdiOrdspr.ValueData, FALSE)    AS EdiOrdspr
             , COALESCE (MovementBoolean_EdiInvoice.ValueData, FALSE)   AS EdiInvoice
             , COALESCE (MovementBoolean_EdiDesadv.ValueData, FALSE)    AS EdiDesadv

             , Object_User.ValueData              AS UserName

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_WeighingPartner()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId

            INNER JOIN MovementLinkObject AS MovementLinkObject_User
                                          ON MovementLinkObject_User.MovementId = Movement.Id
                                         AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                         AND (MovementLinkObject_User.ObjectId = vbUserId OR vbUserId = 0)
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

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
            LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData

            LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber
                                    ON MovementFloat_WeighingNumber.MovementId =  Movement.Id
                                   AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()

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

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                           ON MovementLinkMovement_Tax.MovementId = Movement.ParentId
                                          AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_Tax ON MS_InvNumberPartner_Tax.MovementId = MovementLinkMovement_Tax.MovementChildId
                                                               AND MS_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()


            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
            LEFT JOIN MovementDate AS MovementDate_StartRunPlan
                                   ON MovementDate_StartRunPlan.MovementId = Movement_Transport.Id
                                  AND MovementDate_StartRunPlan.DescId = zc_MovementDate_StartRunPlan()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN MovementItem AS MI_Transport ON MI_Transport.MovementId = Movement_Transport.Id
                                  AND MI_Transport.DescId     = zc_MI_Master()
                                  AND MI_Transport.isErased   = FALSE
                                  AND (MI_Transport.ObjectId  = MovementLinkObject_Route.ObjectId OR Movement_Transport.DescId = zc_Movement_TransportService() OR Movement_Order.Id IS NULL)
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                             ON MILinkObject_Route.MovementItemId = MI_Transport.Id
                                            AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                            AND (MILinkObject_Route.ObjectId = MovementLinkObject_Route.ObjectId OR Movement_Order.Id IS NULL)
                                            AND Movement_Transport.DescId = zc_Movement_TransportService()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                             ON MILinkObject_Car.MovementItemId = MI_Transport.Id
                                            AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                                            AND Movement_Transport.DescId = zc_Movement_TransportService()

            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = COALESCE (MovementLinkObject_PersonalDriver.ObjectId, CASE WHEN Movement_Transport.DescId = zc_Movement_TransportService() THEN MI_Transport.ObjectId END)
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = COALESCE (MILinkObject_Car.ObjectId, MovementLinkObject_Car.ObjectId)
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = COALESCE (MILinkObject_Route.ObjectId, CASE WHEN Movement_Transport.DescId = zc_Movement_Transport() THEN MI_Transport.ObjectId END)



            LEFT JOIN MovementBoolean AS MovementBoolean_EdiOrdspr
                                      ON MovementBoolean_EdiOrdspr.MovementId =  Movement.ParentId
                                     AND MovementBoolean_EdiOrdspr.DescId = zc_MovementBoolean_EdiOrdspr()

            LEFT JOIN MovementBoolean AS MovementBoolean_EdiInvoice
                                      ON MovementBoolean_EdiInvoice.MovementId =  Movement.ParentId
                                     AND MovementBoolean_EdiInvoice.DescId = zc_MovementBoolean_EdiInvoice()

            LEFT JOIN MovementBoolean AS MovementBoolean_EdiDesadv
                                      ON MovementBoolean_EdiDesadv.MovementId =  Movement.ParentId
                                     AND MovementBoolean_EdiDesadv.DescId = zc_MovementBoolean_EdiDesadv()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement.ParentId
                                        AND MovementLinkObject_ReestrKind.DescId     = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            -- ����� �� �������� � ��������� �����
            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.MovementId =  Movement.ParentId
                                   AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_Reestr ON MI_Reestr.Id  = MovementFloat_MovementItemId.ValueData :: Integer
            LEFT JOIN Movement AS Movement_Reestr ON Movement_Reestr.Id       = MI_Reestr.MovementId
                                                 AND Movement_Reestr.StatusId <> zc_Enum_Status_Erased()
                                                 AND MI_Reestr.isErased       = FALSE

       ORDER BY COALESCE (MovementDate_EndWeighing.ValueData, MovementDate_StartWeighing.ValueData) DESC
              , MovementDate_StartWeighing.ValueData DESC
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Scale_Movement (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.10.14                                        * all
 11.03.14         *
*/

-- ����
-- SELECT * FROM gpSelect_Scale_Movement (inStartDate:= '01.05.2015', inEndDate:= '01.05.2015', inIsComlete:= TRUE, inSession:= zfCalc_UserAdmin())
