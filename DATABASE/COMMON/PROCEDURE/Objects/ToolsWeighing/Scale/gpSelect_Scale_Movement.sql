-- Function: gpSelect_Scale_Movement()

DROP FUNCTION IF EXISTS gpSelect_Scale_Movement (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Movement(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsComlete   Boolean ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumberPartner TVarChar, MovementId_DocPartner Integer, OperDate TDateTime, OperDatePartner TDateTime, StatusCode Integer, StatusName TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime
             , ChangePercentAmount TFloat, isReason1 Boolean, isReason2 Boolean

             , MovementId_parent Integer, OperDate_parent TDateTime, OperDatePartner_parent TDateTime, InvNumber_parent TVarChar
             , MovementId_TransportGoods Integer, InvNumber_TransportGoods TVarChar, OperDate_TransportGoods TDateTime
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime, StartRunPlan TDateTime
             , CarName TVarChar, RouteName TVarChar, PersonalDriverName TVarChar
             , MovementId_Tax Integer, InvNumberPartner_Tax TVarChar, OperDate_Tax TDateTime
             , MovementDescNumber Integer, MovementDescId Integer, MovementDescName TVarChar
             , WeighingNumber TFloat
             , MovementId_Order Integer, InvNumberOrder TVarChar
             , ChangePercent TFloat
             , TotalCount TFloat, TotalCountTare TFloat
             , TotalCountPartner TFloat, TotalCountKg TFloat, TotalCountSh TFloat
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
             , PersonalId5 Integer, PersonalCode5 Integer, PersonalName5 TVarChar
             , PositionId1 Integer, PositionCode1 Integer, PositionName1 TVarChar
             , PositionId2 Integer, PositionCode2 Integer, PositionName2 TVarChar
             , PositionId3 Integer, PositionCode3 Integer, PositionName3 TVarChar
             , PositionId4 Integer, PositionCode4 Integer, PositionName4 TVarChar
             , PositionId5 Integer, PositionCode5 Integer, PositionName5 TVarChar
               -- Стикеровщик 1
             , PersonalId1_Stick Integer, PersonalCode1_Stick Integer, PersonalName1_Stick TVarChar
             , PositionId1_Stick Integer, PositionCode1_Stick Integer, PositionName1_Stick TVarChar

             , EdiOrdspr Boolean, EdiInvoice Boolean, EdiDesadv Boolean

             , SubjectDocName TVarChar
             , Comment TVarChar

             , UserName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUserId_save Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);
     
     --
     vbUserId_save:= vbUserId;


     -- !!!временно!!! менется параметр
     IF EXISTS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin(), 428386, 447972, 326391) AND ObjectLink_UserRole_View.UserId = vbUserId) -- ??? + Просмотр СБ + Аналитики по продажам + Руководитель склад ГП Днепр
     THEN vbUserId:= 0;
     END IF;


     -- Результат
     RETURN QUERY
     /*WITH tmpUserAdmin AS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND NOT EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )*/
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId WHERE inIsComlete = TRUE OR vbUserId_save = 5
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         )
         ,  tmpMovementDocPartner AS (SELECT Movement.Id                               AS MovementId
                                           , MovementLinkObject_Contract.ObjectId      AS ContractId
                                           , MovementLinkObject_PaidKind.ObjectId      AS PaidKindId
                                           , COALESCE (MB_DocPartner.ValueData, FALSE) AS isDocPartner
                                           , MS_InvNumberPartner.ValueData             AS InvNumberPartner
                                           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner
                                      FROM Movement
                                           INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                        AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                           INNER JOIN MovementBoolean AS MB_DocPartner
                                                                      ON MB_DocPartner.MovementId = Movement.Id
                                                                     AND MB_DocPartner.DescId     = zc_MovementBoolean_DocPartner()
                                           INNER JOIN MovementString AS MS_InvNumberPartner
                                                                     ON MS_InvNumberPartner.MovementId = Movement.Id
                                                                    AND MS_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                                  ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                      WHERE Movement.OperDate BETWEEN inStartDate - INTERVAL '1 DAY' AND inEndDate
                                        AND Movement.DescId = zc_Movement_WeighingPartner()
                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                                     )
       -- Результат
       SELECT  Movement.Id
             , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
             , (CASE WHEN tmpMovementDocPartner.MovementId = Movement.Id AND tmpMovementDocPartner.isDocPartner = FALSE
                         THEN '(--) '
                    WHEN tmpMovementDocPartner.MovementId = Movement.Id AND tmpMovementDocPartner.isDocPartner = TRUE
                         THEN '(++) '
                    WHEN tmpMovementDocPartner.isDocPartner = FALSE
                         THEN '(-) '
                    WHEN tmpMovementDocPartner.isDocPartner = TRUE
                         THEN '(+) '
                    ELSE ''
               END
            || MS_InvNumberPartner.ValueData) :: TVarChar AS InvNumberPartner
             , tmpMovementDocPartner.MovementId           AS MovementId_DocPartner
             , Movement.OperDate
             , COALESCE (tmpMovementDocPartner.OperDatePartner, MovementDate_OperDatePartner_wp.ValueData) :: TDateTime AS OperDatePartner
             , Object_Status.ObjectCode                AS StatusCode
             , Object_Status.ValueData                 AS StatusName

             , MovementDate_StartWeighing.ValueData  AS StartWeighing
             , MovementDate_EndWeighing.ValueData    AS EndWeighing

             , MF_ChangePercentAmount.ValueData    AS ChangePercentAmount
             , MB_Reason1.ValueData                AS isReason1
             , MB_Reason2.ValueData                AS isReason2

             , Movement_Parent.Id                      AS MovementId_parent
             , Movement_Parent.OperDate                AS OperDate_parent
             , MovementDate_OperDatePartner.ValueData  AS OperDatePartner_parent
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

             , Movement_Transport.Id                 AS MovementId_Transport
             , Movement_Transport.InvNumber          AS InvNumber_Transport
             , Movement_Transport.OperDate           AS OperDate_Transport
             , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRunPlan.ValueData) AS TDateTime) AS StartRunPlan
             , (COALESCE (Object_Car.ValueData, '') || ' ' || COALESCE (Object_CarModel.ValueData, '')|| COALESCE (' ' || Object_CarType.ValueData, '')) :: TVarChar AS CarName  

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

             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.Id                            AS MovementDescId
             , MovementDesc.ItemName                      AS MovementDescName
             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , MovementLinkMovement_Order.MovementChildId AS MovementId_Order
             , Movement_Order.InvNumber                   AS InvNumberOrder

             , MovementFloat_ChangePercent.ValueData          AS ChangePercent
             , MovementFloat_TotalCount.ValueData             AS TotalCount
             , MovementFloat_TotalCountTare.ValueData         AS TotalCountTare

             , MovementFloat_TotalCountPartner.ValueData      AS TotalCountPartner
             , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
             , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh

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
             , Object_Personal5.Id AS PersonalId5, Object_Personal5.ObjectCode AS PersonalCode5, Object_Personal5.ValueData AS PersonalName5

             , Object_Position1.Id AS PositionId1, Object_Position1.ObjectCode AS PositionCode1, Object_Position1.ValueData AS PositionName1
             , Object_Position2.Id AS PositionId2, Object_Position2.ObjectCode AS PositionCode2, Object_Position2.ValueData AS PositionName2
             , Object_Position3.Id AS PositionId3, Object_Position3.ObjectCode AS PositionCode3, Object_Position3.ValueData AS PositionName3
             , Object_Position4.Id AS PositionId4, Object_Position4.ObjectCode AS PositionCode4, Object_Position4.ValueData AS PositionName4
             , Object_Position5.Id AS PositionId5, Object_Position5.ObjectCode AS PositionCode5, Object_Position5.ValueData AS PositionName5

             , Object_Personal1_Stick.Id AS PersonalId1_Stick, Object_Personal1_Stick.ObjectCode AS PersonalCode1_Stick, Object_Personal1_Stick.ValueData AS PersonalName1_Stick
             , Object_Position1_Stick.Id AS PositionId1_Stick, Object_Position1_Stick.ObjectCode AS PositionCode1_Stick, Object_Position1_Stick.ValueData AS PositionName1_Stick

             , COALESCE (MovementBoolean_EdiOrdspr.ValueData, FALSE)    AS EdiOrdspr
             , COALESCE (MovementBoolean_EdiInvoice.ValueData, FALSE)   AS EdiInvoice
             , COALESCE (MovementBoolean_EdiDesadv.ValueData, FALSE)    AS EdiDesadv

             , Object_SubjectDoc.ValueData        AS SubjectDocName
             , MovementString_Comment.ValueData   AS Comment

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

            INNER JOIN MovementFloat AS MovementFloat_BranchCode
                                     ON MovementFloat_BranchCode.MovementId =  Movement.Id
                                    AND MovementFloat_BranchCode.DescId     = zc_MovementFloat_BranchCode()
                                    AND MovementFloat_BranchCode.ValueData  < 1000

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MF_ChangePercentAmount
                                    ON MF_ChangePercentAmount.MovementId = Movement.Id
                                   AND MF_ChangePercentAmount.DescId     = zc_MovementFloat_ChangePercentAmount()
            LEFT JOIN MovementBoolean AS MB_Reason1
                                      ON MB_Reason1.MovementId = Movement.Id
                                     AND MB_Reason1.DescId     = zc_MovementBoolean_Reason1()
            LEFT JOIN MovementBoolean AS MB_Reason2
                                      ON MB_Reason2.MovementId = Movement.Id
                                     AND MB_Reason2.DescId     = zc_MovementBoolean_Reason2()

            LEFT JOIN MovementString AS MS_InvNumberPartner
                                     ON MS_InvNumberPartner.MovementId = Movement.Id
                                    AND MS_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()

            -- у Взвешивания - нашли Главный
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement_Parent.Id
                                  AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
            -- у Взвешивания
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_wp
                                   ON MovementDate_OperDatePartner_wp.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner_wp.DescId     = zc_MovementDate_OperDatePartner()

            -- ТТН у Главного
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement_Parent.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            -- Путевой у ТТН
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport_tg
                                           ON MovementLinkMovement_Transport_tg.MovementId = Movement_TransportGoods.Id
                                          AND MovementLinkMovement_Transport_tg.DescId     = zc_MovementLinkMovement_Transport()

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
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

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


            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal1_Stick
                                         ON MovementLinkObject_Personal1_Stick.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal1_Stick.DescId = zc_MovementLinkObject_PersonalStick1()
            LEFT JOIN Object AS Object_Personal1_Stick ON Object_Personal1_Stick.Id = MovementLinkObject_Personal1_Stick.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position1_Stick
                                         ON MovementLinkObject_Position1_Stick.MovementId = Movement.Id
                                        AND MovementLinkObject_Position1_Stick.DescId = zc_MovementLinkObject_PositionStick1()
            LEFT JOIN Object AS Object_Position1_Stick ON Object_Position1_Stick.Id = MovementLinkObject_Position1_Stick.ObjectId

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
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal5
                                         ON MovementLinkObject_Personal5.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal5.DescId = zc_MovementLinkObject_PersonalComplete5()
            LEFT JOIN Object AS Object_Personal5 ON Object_Personal5.Id = MovementLinkObject_Personal5.ObjectId

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
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position5
                                         ON MovementLinkObject_Position5.MovementId = Movement.Id
                                        AND MovementLinkObject_Position5.DescId = zc_MovementLinkObject_PositionComplete5()
            LEFT JOIN Object AS Object_Position5 ON Object_Position5.Id = MovementLinkObject_Position5.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                           ON MovementLinkMovement_Tax.MovementId = Movement.ParentId
                                          AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_Tax ON MS_InvNumberPartner_Tax.MovementId = MovementLinkMovement_Tax.MovementChildId
                                                               AND MS_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

            -- Путевой у Взвешивания
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId     = zc_MovementLinkMovement_Transport()
            -- Путевой у Главного
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport_parent
                                           ON MovementLinkMovement_Transport_parent.MovementId = Movement_Parent.Id
                                          AND MovementLinkMovement_Transport_parent.DescId     = zc_MovementLinkMovement_Transport()

            -- Путевой лист
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = COALESCE (MovementLinkMovement_Transport_parent.MovementChildId, MovementLinkMovement_Transport.MovementChildId, MovementLinkMovement_Transport_tg.MovementChildId )
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

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

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

            -- связь со строками в документе Реест
            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.MovementId =  Movement.ParentId
                                   AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_Reestr ON MI_Reestr.Id  = MovementFloat_MovementItemId.ValueData :: Integer
            LEFT JOIN Movement AS Movement_Reestr ON Movement_Reestr.Id       = MI_Reestr.MovementId
                                                 AND Movement_Reestr.StatusId <> zc_Enum_Status_Erased()
                                                 AND MI_Reestr.isErased       = FALSE

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId     = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            LEFT JOIN tmpMovementDocPartner ON tmpMovementDocPartner.ContractId       = MovementLinkObject_Contract.ObjectId
                                           AND tmpMovementDocPartner.PaidKindId       = MovementLinkObject_PaidKind.ObjectId
                                           AND tmpMovementDocPartner.InvNumberPartner = MS_InvNumberPartner.ValueData

      UNION ALL
       SELECT  Movement.Id
             , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
             , (CASE WHEN tmpMovementDocPartner.MovementId = Movement.Id AND tmpMovementDocPartner.isDocPartner = FALSE
                         THEN '(--) '
                    WHEN tmpMovementDocPartner.MovementId = Movement.Id AND tmpMovementDocPartner.isDocPartner = TRUE
                         THEN '(++) '
                    WHEN tmpMovementDocPartner.isDocPartner = FALSE
                         THEN '(-) '
                    WHEN tmpMovementDocPartner.isDocPartner = TRUE
                         THEN '(+) '
                    ELSE ''
               END
            || MS_InvNumberPartner.ValueData) :: TVarChar AS InvNumberPartner
             , tmpMovementDocPartner.MovementId               AS MovementId_DocPartner
             , Movement.OperDate
             , COALESCE (tmpMovementDocPartner.OperDatePartner, MovementDate_OperDatePartner_wp.ValueData) :: TDateTime AS OperDatePartner
             , Object_Status.ObjectCode                AS StatusCode
             , Object_Status.ValueData                 AS StatusName

             , MovementDate_StartWeighing.ValueData  AS StartWeighing
             , MovementDate_EndWeighing.ValueData    AS EndWeighing

             , MF_ChangePercentAmount.ValueData    AS ChangePercentAmount
             , MB_Reason1.ValueData                AS isReason1
             , MB_Reason2.ValueData                AS isReason2

             , Movement_Parent.Id                      AS MovementId_parent
             , Movement_Parent.OperDate                AS OperDate_parent
             , MovementDate_OperDatePartner.ValueData  AS OperDatePartner_parent
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

             , Movement_Transport.Id                 AS MovementId_Transport
             , Movement_Transport.InvNumber          AS InvNumber_Transport
             , Movement_Transport.OperDate           AS OperDate_Transport
             , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRunPlan.ValueData) AS TDateTime) AS StartRunPlan
             , (COALESCE (Object_Car.ValueData, '') || ' ' || COALESCE (Object_CarModel.ValueData, '')|| COALESCE (' ' || Object_CarType.ValueData, '')) :: TVarChar AS CarName  

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

             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.Id                            AS MovementDescId
             , MovementDesc.ItemName                      AS MovementDescName
             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , MovementLinkMovement_Order.MovementChildId AS MovementId_Order
             , Movement_Order.InvNumber                   AS InvNumberOrder

             , MovementFloat_ChangePercent.ValueData          AS ChangePercent
             , MovementFloat_TotalCount.ValueData             AS TotalCount
             , MovementFloat_TotalCountTare.ValueData         AS TotalCountTare

             , MovementFloat_TotalCountPartner.ValueData      AS TotalCountPartner
             , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
             , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh

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
             , Object_Personal5.Id AS PersonalId5, Object_Personal5.ObjectCode AS PersonalCode5, Object_Personal5.ValueData AS PersonalName5

             , Object_Position1.Id AS PositionId1, Object_Position1.ObjectCode AS PositionCode1, Object_Position1.ValueData AS PositionName1
             , Object_Position2.Id AS PositionId2, Object_Position2.ObjectCode AS PositionCode2, Object_Position2.ValueData AS PositionName2
             , Object_Position3.Id AS PositionId3, Object_Position3.ObjectCode AS PositionCode3, Object_Position3.ValueData AS PositionName3
             , Object_Position4.Id AS PositionId4, Object_Position4.ObjectCode AS PositionCode4, Object_Position4.ValueData AS PositionName4
             , Object_Position5.Id AS PositionId5, Object_Position5.ObjectCode AS PositionCode5, Object_Position5.ValueData AS PositionName5

             , Object_Personal1_Stick.Id AS PersonalId1_Stick, Object_Personal1_Stick.ObjectCode AS PersonalCode1_Stick, Object_Personal1_Stick.ValueData AS PersonalName1_Stick
             , Object_Position1_Stick.Id AS PositionId1_Stick, Object_Position1_Stick.ObjectCode AS PositionCode1_Stick, Object_Position1_Stick.ValueData AS PositionName1_Stick

             , COALESCE (MovementBoolean_EdiOrdspr.ValueData, FALSE)    AS EdiOrdspr
             , COALESCE (MovementBoolean_EdiInvoice.ValueData, FALSE)   AS EdiInvoice
             , COALESCE (MovementBoolean_EdiDesadv.ValueData, FALSE)    AS EdiDesadv

             , Object_SubjectDoc.ValueData        AS SubjectDocName
             , MovementString_Comment.ValueData   AS Comment

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

            INNER JOIN MovementFloat AS MovementFloat_BranchCode
                                     ON MovementFloat_BranchCode.MovementId =  Movement.Id
                                    AND MovementFloat_BranchCode.DescId     = zc_MovementFloat_BranchCode()
                                    AND MovementFloat_BranchCode.ValueData  < 1000

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MF_ChangePercentAmount
                                    ON MF_ChangePercentAmount.MovementId = Movement.Id
                                   AND MF_ChangePercentAmount.DescId     = zc_MovementFloat_ChangePercentAmount()
            LEFT JOIN MovementBoolean AS MB_Reason1
                                      ON MB_Reason1.MovementId = Movement.Id
                                     AND MB_Reason1.DescId     = zc_MovementBoolean_Reason1()
            LEFT JOIN MovementBoolean AS MB_Reason2
                                      ON MB_Reason2.MovementId = Movement.Id
                                     AND MB_Reason2.DescId     = zc_MovementBoolean_Reason2()

            -- если Взвешивание - это Главный
            INNER JOIN Movement AS Movement_Parent ON Movement_Parent.ParentId = Movement.Id

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement_Parent.Id
                                  AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
            -- у Взвешивания
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_wp
                                   ON MovementDate_OperDatePartner_wp.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner_wp.DescId     = zc_MovementDate_OperDatePartner()

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
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Parent.DescId -- MovementFloat_MovementDesc.ValueData

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
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

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


            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal1_Stick
                                         ON MovementLinkObject_Personal1_Stick.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal1_Stick.DescId = zc_MovementLinkObject_PersonalStick1()
            LEFT JOIN Object AS Object_Personal1_Stick ON Object_Personal1_Stick.Id = MovementLinkObject_Personal1_Stick.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position1_Stick
                                         ON MovementLinkObject_Position1_Stick.MovementId = Movement.Id
                                        AND MovementLinkObject_Position1_Stick.DescId = zc_MovementLinkObject_PositionStick1()
            LEFT JOIN Object AS Object_Position1_Stick ON Object_Position1_Stick.Id = MovementLinkObject_Position1_Stick.ObjectId

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
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal5
                                         ON MovementLinkObject_Personal5.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal5.DescId = zc_MovementLinkObject_PersonalComplete5()
            LEFT JOIN Object AS Object_Personal5 ON Object_Personal5.Id = MovementLinkObject_Personal5.ObjectId

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
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position5
                                         ON MovementLinkObject_Position5.MovementId = Movement.Id
                                        AND MovementLinkObject_Position5.DescId = zc_MovementLinkObject_PositionComplete5()
            LEFT JOIN Object AS Object_Position5 ON Object_Position5.Id = MovementLinkObject_Position5.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                           ON MovementLinkMovement_Tax.MovementId = Movement.ParentId
                                          AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_Tax ON MS_InvNumberPartner_Tax.MovementId = MovementLinkMovement_Tax.MovementChildId
                                                               AND MS_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport_parent
                                           ON MovementLinkMovement_Transport_parent.MovementId = Movement_Parent.Id
                                          AND MovementLinkMovement_Transport_parent.DescId     = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = COALESCE (MovementLinkMovement_Transport_parent.MovementChildId, MovementLinkMovement_Transport.MovementChildId)
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

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

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

            -- связь со строками в документе Реест
            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.MovementId =  Movement.ParentId
                                   AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_Reestr ON MI_Reestr.Id  = MovementFloat_MovementItemId.ValueData :: Integer
            LEFT JOIN Movement AS Movement_Reestr ON Movement_Reestr.Id       = MI_Reestr.MovementId
                                                 AND Movement_Reestr.StatusId <> zc_Enum_Status_Erased()
                                                 AND MI_Reestr.isErased       = FALSE

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId     = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId
            
            LEFT JOIN MovementString AS MS_InvNumberPartner
                                     ON MS_InvNumberPartner.MovementId = Movement.Id
                                    AND MS_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
            LEFT JOIN tmpMovementDocPartner ON tmpMovementDocPartner.ContractId       = MovementLinkObject_Contract.ObjectId
                                           AND tmpMovementDocPartner.PaidKindId       = MovementLinkObject_PaidKind.ObjectId
                                           AND tmpMovementDocPartner.InvNumberPartner = MS_InvNumberPartner.ValueData

       ORDER BY 1 DESC
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.12.18         *
 11.10.14                                        * all
 11.03.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_Movement (inStartDate:= '01.05.2024', inEndDate:= '01.05.2024', inIsComlete:= TRUE, inSession:= zfCalc_UserAdmin())
