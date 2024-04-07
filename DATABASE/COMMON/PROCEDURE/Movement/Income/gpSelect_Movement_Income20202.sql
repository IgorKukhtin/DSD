-- Function: gpSelect_Movement_Income20202()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income20202 (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income20202(
    IN inStartDate         TDateTime , -- Дата нач. периода
    IN inEndDate           TDateTime , -- Дата оконч. периода
    IN inIsErased          Boolean   , -- показывать удаленные Да/Нет
    IN inJuridicalBasisId  Integer   , -- главное юр.лицо
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , is20202 Boolean
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalCount_unit TFloat, TotalCount_diff TFloat
             , TotalCountPartner TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , TotalSummSpending TFloat, TotalSummVAT TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , FromName TVarChar, ItemName_from TVarChar, ToId Integer, ToName TVarChar, ItemName_to TVarChar
             , PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , JuridicalName_From TVarChar, OKPO_From TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CurrencyDocumentName TVarChar, CurrencyPartnerName TVarChar
             , Comment TVarChar
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime, InvNumber_Transport_Full TVarChar
             , CarName TVarChar, CarModelName TVarChar, PersonalDriverName TVarChar
             , MovementId_Order Integer, InvNumber_Order TVarChar, OperDate_Order TDateTime, InvNumber_Order_Full TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsXleb Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- !!!Хлеб!!!
     vbIsXleb:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 131936  AND UserId = vbUserId);


     -- Результат
     RETURN QUERY
     WITH tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                         UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentDnepr() AS AccessKeyId WHERE vbIsXleb = TRUE
                              )
        , tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        --
        , tmpMovement AS (SELECT Movement.*
                               , COALESCE (MovementBoolean_is20202.ValueData, FALSE) :: Boolean AS is20202
                          FROM (SELECT Movement.*
                                FROM tmpStatus
                                     JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                  AND Movement.DescId = zc_Movement_Income()
                                                  AND Movement.StatusId = tmpStatus.StatusId
                                     JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
                                ) AS Movement
                            JOIN MovementBoolean AS MovementBoolean_is20202
                                                 ON MovementBoolean_is20202.MovementId = Movement.Id
                                                AND MovementBoolean_is20202.DescId = zc_MovementBoolean_is20202()
                                                AND COALESCE (MovementBoolean_is20202.ValueData, FALSE) = TRUE
                         )

        , tmpMovementFloat AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId IN (zc_MovementFloat_ChangePercent()
                                                            , zc_MovementFloat_CurrencyValue()
                                                            , zc_MovementFloat_ParValue()
                                                            , zc_MovementFloat_TotalCount()
                                                            , zc_MovementFloat_TotalCountPartner()
                                                            , zc_MovementFloat_TotalSumm()
                                                            , zc_MovementFloat_TotalSummMVAT()
                                                            , zc_MovementFloat_TotalSummPVAT()
                                                            , zc_MovementFloat_TotalSummSpending()
                                                            , zc_MovementFloat_VATPercent())
                               )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode                    AS StatusCode
           , Object_Status.ValueData                     AS StatusName

           , MovementDate_OperDatePartner.ValueData      AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData   AS InvNumberPartner

           , Movement.is20202                 :: Boolean AS is20202
           , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData          AS VATPercent
           , MovementFloat_ChangePercent.ValueData       AS ChangePercent

           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , COALESCE (MovementFloat_TotalCount.ValueData, 0) :: TFloat AS TotalCount_unit
           , (COALESCE (MovementFloat_TotalCount.ValueData, 0) - COALESCE (MovementFloat_TotalCountPartner.ValueData, 0)) :: TFloat AS TotalCount_diff
           , MovementFloat_TotalCountPartner.ValueData   AS TotalCountPartner
           , MovementFloat_TotalSummMVAT.ValueData       AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData       AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData           AS TotalSumm

           , MovementFloat_TotalSummSpending.ValueData   AS TotalSummSpending
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT

           , CAST (COALESCE (MovementFloat_CurrencyValue.ValueData, 0) AS TFloat)  AS CurrencyValue
           , COALESCE (MovementFloat_ParValue.ValueData, 1) :: TFloat              AS ParValue

           , Object_From.ValueData                       AS FromName
           , ObjectDesc_from.ItemName                    AS ItemName_from
           , Object_To.Id                                AS ToId
           , Object_To.ValueData                         AS ToName
           , ObjectDesc_to.ItemName                      AS ItemName_to
           , Object_PaidKind.ValueData                   AS PaidKindName
           , View_Contract_InvNumber.ContractId          AS ContractId
           , View_Contract_InvNumber.ContractCode        AS ContractCode
           , View_Contract_InvNumber.InvNumber           AS ContractName
           , Object_JuridicalFrom.ValueData              AS JuridicalName_From
           , ObjectHistory_JuridicalDetails_View.OKPO    AS OKPO_From
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName

           , Object_CurrencyDocument.ValueData           AS CurrencyDocumentName
           , Object_CurrencyPartner.ValueData            AS CurrencyPartnerName
           , MovementString_Comment.ValueData            AS Comment

           , Movement_Transport.Id                       AS MovementId_Transport
           , Movement_Transport.InvNumber                AS InvNumber_Transport
           , Movement_Transport.OperDate                 AS OperDate_Transport
           , ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport_Full
           , Object_Car.ValueData                        AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , View_PersonalDriver.PersonalName            AS PersonalDriverName

           , Movement_Order.Id                       AS MovementId_Order
           , Movement_Order.InvNumber                AS InvNumber_Order
           , Movement_Order.OperDate                 AS OperDate_Order
           , ('№ ' || Movement_Order.InvNumber || ' от ' || Movement_Order.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Order_Full

           , Object_ReestrKind.Id                    AS ReestrKindId
           , Object_ReestrKind.ValueData             AS ReestrKindName

       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN tmpMovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummSpending
                                    ON MovementFloat_TotalSummSpending.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummSpending.DescId = zc_MovementFloat_TotalSummSpending()

            LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN tmpMovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectDesc AS ObjectDesc_from ON ObjectDesc_from.Id = Object_From.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectDesc AS ObjectDesc_to ON ObjectDesc_to.Id = Object_To.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical
                                 ON ObjectLink_CardFuel_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, ObjectLink_CardFuel_Juridical.ChildObjectId)
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalFrom.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId = Movement.Id
                                     AND MovementBoolean_isIncome.DescId     = zc_MovementBoolean_isIncome()
                                     AND MovementBoolean_isIncome.ValueData  = FALSE

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                 ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
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

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

       WHERE MovementBoolean_isIncome.ValueData IS NULL
         AND COALESCE (View_InfoMoney.InfoMoneyId, 0) <> zc_Enum_InfoMoney_20401() -- !!!САМОЕ НЕКРАСИВОЕ РЕШЕНИЕ!!!
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.21         * 20202
 02.12.20         * 
 14.04.17         * add Movement_Order
 04.10.16         * add inJuridicalBasisId
 25.06.15         * add inIsErased
 02.08.14                                        * add Object_Member
 23.07.14         * add zc_MovementFloat_CurrencyValue
                        zc_MovementLinkObject_CurrencyDocument
                        zc_MovementLinkObject_CurrencyPartner
 16.03.14                                        * change OKPO_From
 12.02.14                                        * add JuridicalName_From and OKPO
 10.02.14                                        * add TotalCountPartner
 10.02.14                                        * add Object_RoleAccessKey_View
 09.02.14                                        * add Object_Contract_InvNumber_View and Object_InfoMoney_View
 14.12.13                                        * del Object_RoleAccessKey_View
 14.12.13                                        * add Object_RoleAccessKey_View
 23.10.13                                        * add zfConvert_StringToNumber
 07.10.13                                        * add lpCheckRight
 30.09.13                                        * add Object_Personal_View
 30.09.13                                        * del zc_MovementLinkObject_PersonalDriver
 27.09.13                                        * del zc_MovementLinkObject_Car
 07.07.13                                        *
 30.06.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income20202 (inStartDate:= '01.01.2018', inEndDate:= '01.01.2018', inIsErased:= FALSE, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
