-- Function: gpGet_Movement_WeighingPartner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_WeighingPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_WeighingPartner(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime, OperDatePartner TDateTime, StatusId Integer, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime
             , MovementId_Order Integer, InvNumberOrder TVarChar
             , PartionGoods TVarChar
             , WeighingNumber TFloat
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat, ChangePercentAmount TFloat
             , MovementDescId Integer
             , MovementDescNumber Integer, MovementDescName TVarChar
             , DescId_from Integer, FromId Integer, FromName TVarChar
             , DescId_to Integer, ToId Integer, ToName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , UserId Integer, UserName TVarChar
             , MemberId Integer, MemberName TVarChar

             , SubjectDocId   Integer
             , SubjectDocCode Integer
             , SubjectDocName TVarChar

             , isPromo Boolean
             , isList Boolean
             , isDocPartner Boolean, isDocPartner_real Boolean
             , isReason1 Boolean
             , isReason2 Boolean

             , PersonalId1 Integer, PersonalName1 TVarChar
             , PersonalId2 Integer, PersonalName2 TVarChar
             , PersonalId3 Integer, PersonalName3 TVarChar
             , PersonalId4 Integer, PersonalName4 TVarChar
             , PersonalId5 Integer, PersonalName5 TVarChar
             , PositionId1 Integer, PositionName1 TVarChar
             , PositionId2 Integer, PositionName2 TVarChar
             , PositionId3 Integer, PositionName3 TVarChar
             , PositionId4 Integer, PositionName4 TVarChar
             , PositionId5 Integer, PositionName5 TVarChar
             , PersonalId1_Stick Integer, PersonalName1_Stick TVarChar
             , PositionId1_Stick Integer, PositionName1_Stick TVarChar

             , PersonalGroupId Integer, PersonalGroupName TVarChar

             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав.';
     ELSE
       RETURN QUERY
       SELECT  Movement.Id
             , Movement.InvNumber
             , MovementString_InvNumberPartner.ValueData ::TVarChar AS InvNumberPartner
             , Movement.OperDate 
             , MovementDate_OperDatePartner.ValueData ::TDateTime AS OperDatePartner
             , Object_Status.Id                  AS StatusId
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , Movement_Parent.Id                AS MovementId_parent
             , Movement_Parent.OperDate          AS OperDate_parent
             , Movement_Parent.InvNumber         AS InvNumber_parent

             , MovementDate_StartWeighing.ValueData  AS StartWeighing
             , MovementDate_EndWeighing.ValueData    AS EndWeighing

             , MovementLinkMovement_Order.MovementChildId AS MovementId_Order
             , CASE WHEN MovementLinkMovement_Order.MovementChildId IS NOT NULL
                         THEN CASE WHEN Movement_Order.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                        THEN ''
                                   ELSE '???'
                              END
                           || CASE WHEN TRIM (COALESCE (MovementString_InvNumberPartner_Order.ValueData, '')) <> ''
                                        THEN MovementString_InvNumberPartner_Order.ValueData
                                   ELSE '***' || Movement_Order.InvNumber
                              END
                    ELSE MovementString_InvNumberOrder.ValueData
               END :: TVarChar AS InvNumberOrder
             , MovementString_PartionGoods.ValueData      AS PartionGoods

             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , Movement_Transport.Id                     AS MovementId_Transport
             , Movement_Transport.InvNumber              AS InvNumber_Transport
             , Movement_Transport.OperDate               AS OperDate_Transport

             , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) :: Boolean AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData             AS VATPercent
             , MovementFloat_ChangePercent.ValueData          AS ChangePercent
             , MovementFloat_ChangePercentAmount.ValueData    AS ChangePercentAmount

             , MovementFloat_MovementDesc.ValueData :: Integer AS MovementDescId
             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.ItemName                      AS MovementDescName

             , Object_From.DescId                   AS DescId_from
             , Object_From.Id                       AS FromId
             , Object_From.ValueData                AS FromName
             , Object_To.DescId                     AS DescId_to
             , Object_To.Id                         AS ToId
             , Object_To.ValueData                  AS ToName
             , CASE WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_To_Juridical.ChildObjectId
                    WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_From_Juridical.ChildObjectId
                    ELSE 0
               END AS JuridicalId
             , CASE WHEN Object_To.DescId = zc_Object_Partner() THEN Object_JuridicalTo.ValueData
                    WHEN Object_From.DescId = zc_Object_Partner() THEN Object_JuridicalFrom.ValueData
                    ELSE ''
               END :: TVarChar AS JuridicalName

             , Object_PaidKind.Id                   AS PaidKindId
             , Object_PaidKind.ValueData            AS PaidKindName
             , MovementLinkObject_Contract.ObjectId AS ContractId
             , View_Contract_InvNumber.InvNumber    AS ContractName
             , View_Contract_InvNumber.ContractTagName

             , Object_User.Id                     AS UserId
             , Object_User.ValueData              AS UserName

             , Object_Member.Id                   AS MemberId
             , Object_Member.ValueData            AS MemberName

             , Object_SubjectDoc.Id            AS SubjectDocId
             , Object_SubjectDoc.ObjectCode    AS SubjectDocCode
             , Object_SubjectDoc.ValueData     AS SubjectDocName

             , COALESCE (MovementBoolean_Promo.ValueData, FALSE) :: Boolean AS isPromo
             , COALESCE (MovementBoolean_List.ValueData,False)   :: Boolean AS isList
             , CASE WHEN MovementBoolean_DocPartner.MovementId > 0 THEN TRUE ELSE FALSE END ::Boolean AS isDocPartner
             , MovementBoolean_DocPartner.ValueData                                                   AS isDocPartner_real
             , COALESCE (MovementBoolean_Reason1.ValueData, False) ::Boolean AS isReason1
             , COALESCE (MovementBoolean_Reason2.ValueData, False) ::Boolean AS isReason2

             , Object_Personal1.Id AS PersonalId1, Object_Personal1.ValueData AS PersonalName1
             , Object_Personal2.Id AS PersonalId2, Object_Personal2.ValueData AS PersonalName2
             , Object_Personal3.Id AS PersonalId3, Object_Personal3.ValueData AS PersonalName3
             , Object_Personal4.Id AS PersonalId4, Object_Personal4.ValueData AS PersonalName4
             , Object_Personal5.Id AS PersonalId5, Object_Personal5.ValueData AS PersonalName5

             , Object_Position1.Id AS PositionId1, Object_Position1.ValueData AS PositionName1
             , Object_Position2.Id AS PositionId2, Object_Position2.ValueData AS PositionName2
             , Object_Position3.Id AS PositionId3, Object_Position3.ValueData AS PositionName3
             , Object_Position4.Id AS PositionId4, Object_Position4.ValueData AS PositionName4
             , Object_Position5.Id AS PositionId5, Object_Position5.ValueData AS PositionName5

             , Object_Personal1_Stick.Id AS PersonalId1_Stick, Object_Personal1_Stick.ValueData AS PersonalName1_Stick
             , Object_Position1_Stick.Id AS PositionId1_Stick, Object_Position1_Stick.ValueData AS PositionName1_Stick

             , Object_PersonalGroup.Id                              AS PersonalGroupId
             , Object_PersonalGroup.ValueData                       AS PersonalGroupName

             , MovementString_Comment.ValueData           AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

            LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                   ON MovementDate_StartWeighing.MovementId = Movement.Id
                                  AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
            LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                   ON MovementDate_EndWeighing.MovementId = Movement.Id
                                  AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber
                                    ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                   AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
            LEFT JOIN MovementString AS MovementString_PartionGoods
                                     ON MovementString_PartionGoods.MovementId = Movement.Id
                                    AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercentAmount
                                    ON MovementFloat_ChangePercentAmount.MovementId = Movement.Id
                                   AND MovementFloat_ChangePercentAmount.DescId = zc_MovementFloat_ChangePercentAmount()

            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                    ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
            LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData :: Integer -- COALESCE (Movement_Parent.DescId, MovementFloat_MovementDesc.ValueData)

            LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                      ON MovementBoolean_Promo.MovementId =  Movement.Id
                                     AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()
            LEFT JOIN MovementBoolean AS MovementBoolean_List
                                      ON MovementBoolean_List.MovementId = Movement.Id
                                     AND MovementBoolean_List.DescId = zc_MovementBoolean_List()
            LEFT JOIN MovementBoolean AS MovementBoolean_DocPartner
                                      ON MovementBoolean_DocPartner.MovementId = Movement.Id
                                     AND MovementBoolean_DocPartner.DescId = zc_MovementBoolean_DocPartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_Reason1
                                      ON MovementBoolean_Reason1.MovementId = Movement.Id
                                     AND MovementBoolean_Reason1.DescId = zc_MovementBoolean_Reason1()
            LEFT JOIN MovementBoolean AS MovementBoolean_Reason2
                                      ON MovementBoolean_Reason2.MovementId = Movement.Id
                                     AND MovementBoolean_Reason2.DescId = zc_MovementBoolean_Reason2()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_From_Juridical
                                 ON ObjectLink_From_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_From_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = ObjectLink_From_Juridical.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_To_Juridical
                                 ON ObjectLink_To_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_To_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_To_Juridical.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId = Movement.Id
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId     = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Order
                                     ON MovementString_InvNumberPartner_Order.MovementId =  Movement_Order.Id
                                    AND MovementString_InvNumberPartner_Order.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
            ---
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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_WeighingPartner();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.11.24         * isDocPartner
 08.11.23         *
 06.09.21         *
 15.03.17         * add Member
 01.12.15         * add Promo
 11.10.14                                        * all
 11.03.14         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_WeighingPartner (inMovementId := 1, inSession:= zfCalc_UserAdmin())
