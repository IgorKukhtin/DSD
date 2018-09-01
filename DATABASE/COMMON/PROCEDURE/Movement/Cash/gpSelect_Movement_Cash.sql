-- Function: gpSelect_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cash (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cash(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inCashId           Integer , --
    IN inCurrencyId       Integer , --
    IN inJuridicalBasisId Integer   , -- Главное юр.лицо
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , AmountCurrency TFloat, AmountSumm TFloat
             , ServiceDate TDateTime
             , Comment TVarChar
             , CashName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceCode Integer, MoneyPlaceName TVarChar, OKPO TVarChar, ItemName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , MemberName TVarChar, PositionName TVarChar, PersonalServiceListId Integer, PersonalServiceListCode Integer, PersonalServiceListName TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , CarId Integer, CarName TVarChar
             , CarModelId Integer, CarModelName TVarChar
             , UnitId_Car Integer, UnitName_Car TVarChar
             , CurrencyName TVarChar, CurrencyPartnerName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , isLoad Boolean
             , PartionMovementName TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InsertDate TDateTime
             , InsertMobileDate TDateTime
             , InsertName TVarChar
             , UnitName_Mobile TVarChar
             , PositionName_Mobile TVarChar
             , GUID TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;

     -- Блокируем ему просмотр за ДРУГОЙ период
     ELSEIF EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_CashReplace() AND UserId = vbUserId)
        -- AND inCashId    <> 296540 -- Касса Днепр БН
        AND (inStartDate < zc_DateStart_Role_CashReplace() OR inStartDate > zc_DateEnd_Role_CashReplace()
          OR inEndDate   < zc_DateStart_Role_CashReplace() OR inEndDate   > zc_DateEnd_Role_CashReplace()
          OR inCashId    <> 14462 -- Касса Днепр
            )
     THEN
         IF inStartDate < zc_DateStart_Role_CashReplace() OR inStartDate > zc_DateEnd_Role_CashReplace() THEN inStartDate:= zc_DateStart_Role_CashReplace(); END IF;
         IF inEndDate   < zc_DateStart_Role_CashReplace() OR inEndDate   > zc_DateEnd_Role_CashReplace() THEN inEndDate  := zc_DateEnd_Role_CashReplace();   END IF;

     END IF;


     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate WHERE inIsErased = TRUE
                         )
          , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
          , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
          , tmpAccessKey_isCashAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                 UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_CashAll()
                                      )
          , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_isCashAll.Id FROM tmpAccessKey_isCashAll)
                           UNION SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = zc_Enum_Process_InsertUpdate_Movement_Cash() AND EXISTS (SELECT tmpAccessKey_isCashAll.Id FROM tmpAccessKey_isCashAll) GROUP BY AccessKeyId
                                )
          , tmpAll AS (SELECT tmpStatus.StatusId, tmpStatus.StartDate, tmpStatus.EndDate, tmpRoleAccessKey.AccessKeyId FROM tmpStatus, tmpRoleAccessKey)
          , tmpMovement AS (SELECT Movement.*
                              , Object_Status.ObjectCode AS StatusCode
                              , Object_Status.ValueData  AS StatusName
                         FROM tmpAll
                              INNER JOIN Movement ON Movement.DescId = zc_Movement_Cash()
                                                 AND Movement.OperDate BETWEEN tmpAll.StartDate AND tmpAll.EndDate -- inStartDate AND inEndDate
                                                 AND Movement.StatusId = tmpAll.StatusId
                                                 AND Movement.AccessKeyId = tmpAll.AccessKeyId
                              LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpAll.StatusId
                        )
         , tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.BranchId
                           FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
       -- Результат
       SELECT
             tmpMovement.Id
           , tmpMovement.InvNumber
           , tmpMovement.OperDate
           , tmpMovement.StatusCode
           , tmpMovement.StatusName

           , CASE WHEN MILinkObject_Currency.ObjectId <> inCurrencyId AND inCurrencyId = zc_Enum_Currency_Basis()
                   AND MovementItem.Amount < 0
                       THEN MovementFloat_AmountSumm.ValueData
                  WHEN MILinkObject_Currency.ObjectId <> inCurrencyId AND inCurrencyId = zc_Enum_Currency_Basis()
                       THEN 0
                  WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountIn
           , CASE WHEN MILinkObject_Currency.ObjectId <> inCurrencyId AND inCurrencyId = zc_Enum_Currency_Basis()
                   AND MovementItem.Amount > 0
                       THEN MovementFloat_AmountSumm.ValueData
                  WHEN MILinkObject_Currency.ObjectId <> inCurrencyId AND inCurrencyId = zc_Enum_Currency_Basis()
                       THEN 0
                  WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountOut

           , MovementFloat_AmountCurrency.ValueData AS AmountCurrency
           , CASE WHEN MovementFloat_AmountSumm.ValueData <> 0 THEN MovementFloat_AmountSumm.ValueData * CASE WHEN MovementItem.Amount < 0 THEN 1 ELSE -1 END
                  WHEN ObjectDesc.Id = zc_Object_Cash() AND Object_Currency.Id <> zc_Enum_Currency_Basis() THEN -1 * MovementItem.Amount -- !!!с обратным знаком!!!
             END :: TFloat AS AmountSumm
             
           , MIDate_ServiceDate.ValueData      AS ServiceDate
           , MIString_Comment.ValueData        AS Comment
           , Object_Cash.ValueData             AS CashName
           , Object_MoneyPlace.Id              AS MoneyPlaceId
           , Object_MoneyPlace.ObjectCode      AS MoneyPlaceCode
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName
           , ObjectHistory_JuridicalDetails_View.OKPO
           , ObjectDesc.ItemName
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all
           , Object_Member.ValueData            AS MemberName
           , Object_Position.ValueData          AS PositionName
           , Object_PersonalServiceList.Id         AS PersonalServiceListId
           , Object_PersonalServiceList.ObjectCode AS PersonalServiceListCode
           , Object_PersonalServiceList.ValueData  AS PersonalServiceListName
           , View_Contract_InvNumber.ContractCode
           , View_Contract_InvNumber.InvNumber  AS ContractInvNumber
           , View_Contract_InvNumber.ContractTagName
           , Object_Unit.ObjectCode             AS UnitCode
           , Object_Unit.ValueData              AS UnitName

           , Object_CarModel.Id                 AS CarId
           , Object_CarModel.ValueData          AS CarName
           , Object_CarModel.Id                 AS CarModelId
           , Object_CarModel.ValueData          AS CarModelName
           , Object_Unit_Car.Id                 AS UnitId_Car
           , Object_Unit_Car.ValueData          AS UnitName_Car

           , Object_Currency.ValueData                     AS CurrencyName
           , Object_CurrencyPartner.ValueData              AS CurrencyPartnerName
           , MovementFloat_CurrencyValue.ValueData         AS CurrencyValue
           , MovementFloat_ParValue.ValueData              AS ParValue
           , MovementFloat_CurrencyPartnerValue.ValueData  AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData       AS ParPartnerValue

           , COALESCE (MovementBoolean_isLoad.ValueData, FALSE) :: Boolean AS isLoad

           , zfCalc_PartionMovementName (Movement_PartionMovement.DescId, MovementDesc_PartionMovement.ItemName, Movement_PartionMovement.InvNumber, MovementDate_OperDatePartner_PartionMovement.ValueData) AS PartionMovementName

           , Movement_Invoice.Id                 AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice
           , MS_Comment_Invoice.ValueData        AS Comment_Invoice

           , MovementDate_Insert.ValueData          AS InsertDate
           , MovementDate_InsertMobile.ValueData    AS InsertMobileDate
           , Object_User.ValueData                  AS InsertName
           , Object_Unit_mobile.ValueData           AS UnitName_Mobile
           , CASE WHEN MovementString_GUID.ValueData <> '' THEN Object_Position_mobile.ValueData ELSE '' END :: TVarChar AS PositionName_Mobile
           , MovementString_GUID.ValueData          AS GUID

       FROM tmpMovement

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = tmpMovement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_InsertMobile
                                   ON MovementDate_InsertMobile.MovementId = tmpMovement.Id
                                  AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                                -- AND MovementString_GUID.ValueData <> ''
            LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
            LEFT JOIN Object AS Object_Position_mobile ON Object_Position_mobile.Id = tmpPersonal.PositionId
            LEFT JOIN Object AS Object_Unit_mobile ON Object_Unit_mobile.Id = tmpPersonal.UnitId

            LEFT JOIN MovementString AS MovementString_GUID
                                     ON MovementString_GUID.MovementId = tmpMovement.Id
                                    AND MovementString_GUID.DescId = zc_MovementString_GUID()

            LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                           ON MLM_Invoice.MovementId = tmpMovement.Id
                                          AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MS_Comment_Invoice
                                     ON MS_Comment_Invoice.MovementId = Movement_Invoice.Id
                                    AND MS_Comment_Invoice.DescId = zc_MovementString_Comment()

            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.ObjectId = inCashId
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                      ON MovementBoolean_isLoad.MovementId = tmpMovement.Id
                                     AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()

            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_PartionMovement ON Movement_PartionMovement.Id = MIFloat_MovementId.ValueData :: Integer
            LEFT JOIN MovementDesc AS MovementDesc_PartionMovement ON MovementDesc_PartionMovement.Id = Movement_PartionMovement.DescId
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_PartionMovement
                                   ON MovementDate_OperDatePartner_PartionMovement.MovementId =  Movement_PartionMovement.Id
                                  AND MovementDate_OperDatePartner_PartionMovement.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                         ON MLO_PersonalServiceList.MovementId = tmpMovement.Id
                                        AND MLO_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MLO_PersonalServiceList.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                         ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                        AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                         ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                             ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MILinkObject_Member.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                         ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                      AND MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_60101() -- Заработная плата + Заработная плата
                                      AND MILinkObject_MoneyPlace.ObjectId > 0
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            -- Ограничили - Только одной валютой
            INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                              ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()

            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MILinkObject_Currency.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyPartner
                                             ON MILinkObject_CurrencyPartner.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CurrencyPartner.DescId = zc_MILinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MILinkObject_CurrencyPartner.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                             ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MILinkObject_Car.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId = tmpMovement.Id
                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
            LEFT JOIN MovementFloat AS MovementFloat_AmountSumm
                                    ON MovementFloat_AmountSumm.MovementId = tmpMovement.Id
                                   AND MovementFloat_AmountSumm.DescId = zc_MovementFloat_Amount()

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId = tmpMovement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = tmpMovement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId = tmpMovement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId = tmpMovement.Id
                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            --свойства авто
            LEFT JOIN ObjectLink AS Car_CarModel
                                 ON Car_CarModel.ObjectId = MILinkObject_Car.ObjectId
                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                                 ON ObjectLink_Car_Unit.ObjectId = MILinkObject_Car.ObjectId
                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object AS Object_Unit_Car ON Object_Unit_Car.Id = ObjectLink_Car_Unit.ChildObjectId
            --
       WHERE MILinkObject_Currency.ObjectId = inCurrencyId
             OR (inCurrencyId = zc_Enum_Currency_Basis() AND MovementFloat_AmountSumm.ValueData <> 0)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Cash (TDateTime, TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.09.18         * add Car
 21.05.17         * add CurrencyPartner
 06.10.16         * add inJuridicalBasisId
 26.07.16         * invoice
 17.04.16         * add inCurrencyid
 27.04.15         * add InvNumber_Sale
 06.03.15         * add Currency...
 30.08.14                                        * all
 14.01.14                                        * add Object_Contract_InvNumber_View
 26.12.13                                        * add View_InfoMoney
 26.12.13                                        * add Object_RoleAccessKey_View
 23.12.13                          *
 09.08.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cash (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inCashId:= 14462, inCurrencyId:= zc_Enum_Currency_Basis(), inJuridicalBasisId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Movement_Cash (inStartDate:= '30.01.2016', inEndDate:= '30.01.2016', inCashId:= 14462, inCurrencyId:= zc_Enum_Currency_Basis(), inJuridicalBasisId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
