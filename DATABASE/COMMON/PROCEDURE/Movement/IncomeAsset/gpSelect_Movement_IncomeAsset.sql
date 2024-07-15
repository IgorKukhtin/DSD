-- Function: gpSelect_Movement_IncomeAsset()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeAsset (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeAsset(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- гл. юр.лицо
    IN inIsErased          Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalCount_unit TFloat, TotalCount_diff TFloat, TotalCountPartner TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummSpending TFloat, TotalSummVAT TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , isCurrencyUser Boolean
             , FromName TVarChar, ToName TVarChar
             , PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , JuridicalName_From TVarChar, OKPO_From TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CurrencyDocumentName TVarChar, CurrencyPartnerName TVarChar
             , Comment TVarChar
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime, InvNumber_Transport_Full TVarChar
             , CarName TVarChar, CarModelName TVarChar, PersonalDriverName TVarChar
             , InvNumber_Invoice_Full TVarChar
             , InvNumber_Invoice TVarChar
             , OperDate_Invoice TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_IncomeAsset());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


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
                              )
        , tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_IncomeAsset() AND Movement.StatusId = tmpStatus.StatusId
                               -- JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
                         )

        , tmpMI AS (SELECT tmp.MovementId
                         , tmp.InvNumber_Invoice_Full
                         , tmp.InvNumber_Invoice
                         , tmp.OperDate_Invoice
                         , ROW_NUMBER() OVER(PARTITION BY tmp.MovementId) AS Ord
                     FROM (SELECT DISTINCT tmp.MovementId
                         , (CASE WHEN MI_Invoice.isErased = TRUE OR Movement_Invoice.StatusId <> zc_Enum_Status_Complete() THEN 'Ошибка *** ' ELSE '' END
                         || zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner_Invoice.ValueData, '') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate)
                           ) :: TVarChar AS InvNumber_Invoice_Full
                         , (COALESCE (MovementString_InvNumberPartner_Invoice.ValueData, '') || '/' || Movement_Invoice.InvNumber)  :: TVarChar AS InvNumber_Invoice
                         , Movement_Invoice.OperDate AS OperDate_Invoice
                       FROM (SELECT DISTINCT MovementItem.MovementId
                                  , MIFloat_Invoice.ValueData :: Integer AS MIId_Invoice
                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_Invoice
                                                        ON MIFloat_Invoice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Invoice.DescId = zc_MIFloat_MovementItemId()

                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                            ) AS tmp
                            LEFT JOIN MovementItem AS MI_Invoice ON MI_Invoice.Id = tmp.MIId_Invoice
                            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MI_Invoice.MovementId
                            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
                            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                                     ON MovementString_InvNumberPartner_Invoice.MovementId = Movement_Invoice.Id
                                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()
                           ) AS tmp
                    )

        , tmpMovementFloat AS (SELECT *
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId IN (zc_MovementFloat_VATPercent()
                                                            , zc_MovementFloat_ChangePercent()
                                                            , zc_MovementFloat_TotalCount()
                                                            , zc_MovementFloat_TotalCountPartner()
                                                            , zc_MovementFloat_TotalSummMVAT()
                                                            , zc_MovementFloat_TotalSummPVAT()
                                                            , zc_MovementFloat_TotalSumm()
                                                            , zc_MovementFloat_TotalSummSpending()
                                                            , zc_MovementFloat_CurrencyValue()
                                                            , zc_MovementFloat_ParValue()
                                                              )
                              )

        , tmpMovementDate AS (SELECT *
                              FROM MovementDate
                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                              )

        , tmpMovementString AS (SELECT *
                                FROM MovementString
                                WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementString.DescId IN (zc_MovementString_Comment()
                                                              , zc_MovementString_InvNumberPartner()
                                                               )
                               )

        , tmpMovementBoolean AS (SELECT *
                                 FROM MovementBoolean
                                 WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementBoolean.DescId IN (zc_MovementBoolean_PriceWithVAT(), zc_MovementBoolean_CurrencyUser())
                                 )

        , tmpMLM AS (SELECT *
                     FROM MovementLinkMovement
                     WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Transport()
                     )

        , tmpMovementLinkObject AS (SELECT *
                                    FROM MovementLinkObject
                                    WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                      AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From()
                                                                      , zc_MovementLinkObject_To()
                                                                      , zc_MovementLinkObject_PaidKind()
                                                                      , zc_MovementLinkObject_Contract()
                                                                      , zc_MovementLinkObject_CurrencyPartner()
                                                                      , zc_MovementLinkObject_CurrencyDocument()
                                                                       )
                                    )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          AS StatusCode
           , Object_Status.ValueData           AS StatusName

           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

           , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData          AS VATPercent
           , MovementFloat_ChangePercent.ValueData       AS ChangePercent

           , CASE WHEN tmpMI.Ord = 1 THEN MovementFloat_TotalCount.ValueData ELSE 0 END ::TFloat          AS TotalCount
           , CASE WHEN tmpMI.Ord = 1 THEN (COALESCE (MovementFloat_TotalCount.ValueData, 0)) ELSE 0 END ::TFloat AS TotalCount_unit
           , CASE WHEN tmpMI.Ord = 1 THEN (COALESCE (MovementFloat_TotalCount.ValueData, 0) - COALESCE (MovementFloat_TotalCountPartner.ValueData, 0)) ELSE 0 END ::TFloat AS TotalCount_diff
           , CASE WHEN tmpMI.Ord = 1 THEN MovementFloat_TotalCountPartner.ValueData ELSE 0 END ::TFloat   AS TotalCountPartner
           , CASE WHEN tmpMI.Ord = 1 THEN MovementFloat_TotalSummMVAT.ValueData ELSE 0 END ::TFloat       AS TotalSummMVAT
           , CASE WHEN tmpMI.Ord = 1 THEN MovementFloat_TotalSummPVAT.ValueData ELSE 0 END ::TFloat       AS TotalSummPVAT
           , CASE WHEN tmpMI.Ord = 1 THEN MovementFloat_TotalSumm.ValueData ELSE 0 END ::TFloat           AS TotalSumm
           , CASE WHEN tmpMI.Ord = 1 THEN MovementFloat_TotalSummSpending.ValueData ELSE 0 END ::TFloat   AS TotalSummSpending
           , CASE WHEN tmpMI.Ord = 1 THEN CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) ELSE 0 END ::TFloat AS TotalSummVAT

           , CAST (COALESCE (MovementFloat_CurrencyValue.ValueData, 0) AS TFloat)  AS CurrencyValue
           , COALESCE (MovementFloat_ParValue.ValueData, 1) :: TFloat              AS ParValue
           , COALESCE (MovementBoolean_CurrencyUser.ValueData, FALSE) ::Boolean    AS isCurrencyUser

           , Object_From.ValueData                       AS FromName
           , Object_To.ValueData                         AS ToName
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
           , Object_PersonalDriver.ValueData             AS PersonalDriverName
           
           , tmpMI.InvNumber_Invoice_Full :: TVarChar
           , tmpMI.InvNumber_Invoice      :: TVarChar
           , tmpMI.OperDate_Invoice       :: TDateTime

       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                         ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                        AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN tmpMovementBoolean AS MovementBoolean_CurrencyUser
                                         ON MovementBoolean_CurrencyUser.MovementId = Movement.Id
                                        AND MovementBoolean_CurrencyUser.DescId = zc_MovementBoolean_CurrencyUser()

            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
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

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Contract
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

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

             LEFT JOIN tmpMLM AS MovementLinkMovement_Transport
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
            --LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId
  

            LEFT JOIN tmpMI ON tmpMI.MovementId = Movement.Id

       WHERE COALESCE (Object_To.DescId, 0) NOT IN (zc_Object_Car(), zc_Object_Member()) -- !!!САМОЕ НЕКРАСИВОЕ РЕШЕНИЕ!!!
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.07.24         * isCurrencyUser
 15.01.20         * add InvNumber_Invoice
 07.10.16         * add inJuridicalBasisId
 06.10.16         * parce
 29.07.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_IncomeAsset (inStartDate:= '01.01.2015', inEndDate:= '01.02.2015', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- select * from gpSelect_Movement_IncomeAsset (inStartDate := ('01.01.2019')::TDateTime , inEndDate := ('31.12.2019')::TDateTime , inJuridicalBasisId := 9399 , inIsErased := 'False' ,  inSession := '5');