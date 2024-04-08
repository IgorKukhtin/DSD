-- Function: gpSelect_Movement_PersonalReport()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalReport (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalReport (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalReport (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalReport (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalReport(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inMemberId         Integer,    --
    IN inJuridicalBasisId Integer   , -- Главное юр.лицо
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , MovementDescName TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , Comment TVarChar
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar
             , UnitCode Integer, UnitName TVarChar
             , MoneyPlaceCode Integer, MoneyPlaceName TVarChar, ItemName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , CarName TVarChar
             , ProfitLossGroupName     TVarChar
             , ProfitLossDirectionName TVarChar
             , ProfitLossName          TVarChar
             , ProfitLossName_all      TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalReport());
     vbUserId:= lpGetUserBySession (inSession);

     -- Блокируем ему просмотр
     IF 1=0 AND vbUserId = 9457 -- Климентьев К.И.
     THEN
         RETURN;
     END IF;

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (/*SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION*/
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

    , tmpMovement AS (SELECT CLO_Member.ContainerId AS ContainerId
                           , CLO_Member.ObjectId    AS MemberId
                           , Movement.DescId        AS MovementDescId
                           , Movement.InvNumber
                           , Movement.StatusId
                           , MIContainer.MovementId
                           , MIContainer.OperDate
                           , MIContainer.MovementItemId
                           , MIContainer.Amount /** CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive() THEN -1 ELSE 1 END*/ AS Amount
                           , CASE WHEN CLO_InfoMoney.ObjectId > 0 THEN CLO_InfoMoney.ObjectId ELSE MILinkObject_InfoMoney.ObjectId END AS InfoMoneyId
                           , CLO_Branch.ObjectId    AS BranchId
                           -- , 0 AS UnitId
                           , COALESCE (ContainerLO_Member_inf.ObjectId, COALESCE (ContainerLO_Cash_inf.ObjectId, COALESCE (ContainerLO_BankAccount_inf.ObjectId, ContainerLO_Juridical_inf.ObjectId))) AS MoneyPlaceId
                           , COALESCE (CLO_Car.ObjectId, MILinkObject_Car.ObjectId) AS CarId
                      FROM ContainerLinkObject AS CLO_Member
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = CLO_Member.ContainerId
                                                           AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                           AND MIContainer.DescId = zc_MIContainer_Summ()
                                                           AND MIContainer.Amount <> 0
                           LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                           LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                         ON CLO_Goods.ContainerId = CLO_Member.ContainerId
                                                        AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                           LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                         ON CLO_InfoMoney.ContainerId = CLO_Member.ContainerId
                                                        AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                           LEFT JOIN ContainerLinkObject AS CLO_Car
                                                         ON CLO_Car.ContainerId = CLO_Member.ContainerId
                                                        AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
                                                        AND CLO_Car.ObjectId    > 0
                           LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                         ON CLO_Branch.ContainerId = CLO_Member.ContainerId
                                                        AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                           LEFT JOIN ContainerLinkObject AS ContainerLO_Member_inf ON ContainerLO_Member_inf.ContainerId = MIContainer.ContainerId_Analyzer
                                                                                  AND ContainerLO_Member_inf.DescId = zc_ContainerLinkObject_Member()
                                                                                  AND ContainerLO_Member_inf.ObjectId > 0
                           LEFT JOIN ContainerLinkObject AS ContainerLO_Cash_inf ON ContainerLO_Cash_inf.ContainerId = MIContainer.ContainerId_Analyzer
                                                                                AND ContainerLO_Cash_inf.DescId = zc_ContainerLinkObject_Cash()
                                                                                AND ContainerLO_Cash_inf.ObjectId > 0
                           LEFT JOIN ContainerLinkObject AS ContainerLO_BankAccount_inf ON ContainerLO_BankAccount_inf.ContainerId = MIContainer.ContainerId_Analyzer
                                                                                       AND ContainerLO_BankAccount_inf.DescId = zc_ContainerLinkObject_BankAccount()
                                                                                       AND ContainerLO_BankAccount_inf.ObjectId > 0
                           LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical_inf ON ContainerLO_Juridical_inf.ContainerId = MIContainer.ContainerId_Analyzer
                                                                                     AND ContainerLO_Juridical_inf.DescId = zc_ContainerLinkObject_Juridical()
                                                                                     AND ContainerLO_Juridical_inf.ObjectId > 0
         
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                            ON MILinkObject_InfoMoney.MovementItemId = MIContainer.MovementItemId
                                                           AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                            ON MILinkObject_Car.MovementItemId = MIContainer.MovementItemId
                                                           AND MILinkObject_Car.DescId = zc_MILinkObject_Car()

                      WHERE CLO_Member.DescId = zc_ContainerLinkObject_Member()
                        AND (CLO_Member.ObjectId = inMemberId OR COALESCE (inMemberId, 0) = 0)
                        AND CLO_Goods.ContainerId IS NULL
                      --AND Movement.DescId <> zc_Movement_PersonalReport()
                     UNION
                      SELECT 0 AS ContainerId
                           , MovementItem.ObjectId AS MemberId
                           , Movement.DescId AS MovementDescId
                           , Movement.InvNumber
                           , Movement.StatusId
                           , Movement.Id AS MovementId
                           , Movement.OperDate
                           , MovementItem.Id AS MovementItemId
                           , MovementItem.Amount
                           , MILinkObject_InfoMoney.ObjectId  AS InfoMoneyId
                           , 0                                AS BranchId
                           -- , MILinkObject_Unit.ObjectId       AS UnitId
                           , MILinkObject_MoneyPlace.ObjectId AS MoneyPlaceId
                           , MILinkObject_Car.ObjectId        AS CarId
                      FROM tmpStatus
                           INNER JOIN Movement ON Movement.DescId = zc_Movement_PersonalReport()
                                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                              AND Movement.StatusId = tmpStatus.StatusId
                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                            ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                            ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                       WHERE (MovementItem.ObjectId = inMemberId OR COALESCE (inMemberId, 0) = 0)
                     )
         -- ProfitLoss из проводок
         , tmpMIС_ProfitLoss AS (SELECT DISTINCT MovementItemContainer.MovementId
                                      , CLO_ProfitLoss.ObjectId AS ProfitLossId
                                 FROM MovementItemContainer
                                      INNER JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                                     ON CLO_ProfitLoss.ContainerId = MovementItemContainer.ContainerId
                                                                    AND CLO_ProfitLoss.DescId      = zc_ContainerLinkObject_ProfitLoss()
                                 WHERE MovementItemContainer.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement WHERE tmpMovement.MovementDescId = zc_Movement_PersonalReport())
                                   AND MovementItemContainer.DescId     = zc_MIContainer_Summ()
                                   AND MovementItemContainer.AccountId  = zc_Enum_Account_100301()   -- прибыль текущего периода
                                 --AND 1=0
                                )
         , tmpProfitLoss_View AS (SELECT * FROM Object_ProfitLoss_View WHERE Object_ProfitLoss_View.ProfitLossId IN (SELECT tmpMIС_ProfitLoss.ProfitLossId FROM tmpMIС_ProfitLoss))

         , tmpMLM AS (SELECT MovementLinkMovement.*
                      FROM MovementLinkMovement
                      WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                        AND  MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                      )


       --РЕЗУЛЬТАТ 
       SELECT
             tmpMovement.MovementId   AS Id
           , tmpMovement.InvNumber
           , tmpMovement.OperDate
           , Object_Status.ObjectCode AS StatusCode
           , Object_Status.ValueData  AS StatusName
           , MovementDesc.ItemName    AS MovementDescName

           , CASE WHEN tmpMovement.Amount > 0
                       THEN tmpMovement.Amount
                  ELSE 0
             END::TFloat                        AS AmountIn
           , CASE WHEN tmpMovement.Amount < 0
                       THEN -1 * tmpMovement.Amount
                  ELSE 0
             END::TFloat                        AS AmountOut

           , MIString_Comment.ValueData         AS Comment

           , Object_Member.Id                   AS MemberId
           , Object_Member.ObjectCode           AS MemberCode
           , Object_Member.ValueData            AS MemberName
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all
           , View_Contract_InvNumber.ContractCode AS ContractCode
           , View_Contract_InvNumber.InvNumber  AS ContractInvNumber
           , Object_Unit.ObjectCode             AS UnitCode
           , Object_Unit.ValueData              AS UnitName
           , Object_MoneyPlace.ObjectCode       AS MoneyPlaceCode
           , Object_MoneyPlace.ValueData        AS MoneyPlaceName
           , ObjectDesc.ItemName
           , Object_Branch.ObjectCode           AS BranchCode
           , Object_Branch.ValueData            AS BranchName
           , (COALESCE (Object_CarModel.ValueData, '') || COALESCE (' ' || Object_CarType.ValueData, '')|| ' ' || COALESCE (Object_Car.ValueData, '')) :: TVarChar AS CarName

           , tmpProfitLoss_View.ProfitLossGroupName     ::TVarChar
           , tmpProfitLoss_View.ProfitLossDirectionName ::TVarChar
           , tmpProfitLoss_View.ProfitLossName          ::TVarChar
           , tmpProfitLoss_View.ProfitLossName_all      ::TVarChar

           , Movement_Invoice.Id                            AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice
       FROM tmpMovement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement.StatusId
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMovement.MovementDescId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = tmpMovement.MovementItemId
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                         ON MILinkObject_Contract.MovementItemId = tmpMovement.MovementItemId
                                        AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpMovement.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMovement.MemberId
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpMovement.BranchId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpMovement.InfoMoneyId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId -- tmpMovement.UnitId
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = tmpMovement.MoneyPlaceId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpMovement.CarId
            LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId =  Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN tmpMIС_ProfitLoss ON tmpMIС_ProfitLoss.MovementId = tmpMovement.MovementId
            LEFT JOIN tmpProfitLoss_View ON tmpProfitLoss_View.ProfitLossId = tmpMIС_ProfitLoss.ProfitLossId

            LEFT JOIN tmpMLM AS MLM_Invoice
                             ON MLM_Invoice.MovementId = tmpMovement.MovementId
                            AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.03.22         * Invoice
 23.03.17         *
 06.10.16         * add inJuridicalBasisId
 07.05.15         * add Contract
 08.04.15                                        * all
 15.09.14                                                        *
*/

-- тест
--SELECT * FROM gpSelect_Movement_PersonalReport (inStartDate:= '01.01.2015', inEndDate:= '01.02.2015', inMemberId:= 0, inJuridicalBasisId:= 0, inIsErased:=false , inSession:= zfCalc_UserAdmin())
