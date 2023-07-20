-- Function: gpReport_Personal_MoneySumm

DROP FUNCTION IF EXISTS gpReport_Personal_MoneySumm (TDateTime, TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Personal_MoneySumm(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inServiceDate      TDateTime , --
    IN inIsServiceDate    Boolean , --
    IN inIsMember         Boolean , -- по физ лицу
    IN inAccountId        Integer,    -- Счет
    IN inBranchId         Integer,    -- филиал
    IN inInfoMoneyId      Integer,    -- Управленческая статья
    IN inInfoMoneyGroupId Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    --
    IN inPersonalServiceListId    Integer,    -- ведомость
    IN inPersonalId       Integer,    -- Фио сотрудника
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, MovementDescName TVarChar
             , OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             
             , MoneySumm_inf   TFloat
              
             , Amount TFloat 
             , ServiceDate TDateTime
             , Comment TVarChar
             , BankAccountId Integer, BankAccountName TVarChar
             , MemberId Integer, MemberName TVarChar
             , InvNumber_Service TVarChar, OperDate_Service TDateTime
             , ServiceDate_Service TDateTime
             , Comment_Service TVarChar
             , PersonalServiceListName TVarChar
             , TotalSummToPay_Service TFloat
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMemberId   Integer;
   DECLARE vbIsList_all Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Проверка прав роль - Ограничение просмотра данных ЗП!!!
     PERFORM lpCheck_UserRole_8813637 (vbUserId);


     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;

     -- !!! права пользователей !!!
     IF EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
     THEN
         inBranchId:= (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId);
     END IF;

     -- !!! округление !!!
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);


     -- Результат
     RETURN QUERY
     WITH
     _tmpPersonal AS(SELECT ObjectLink_Personal_Member.ObjectId AS PersonalId
                     FROM ObjectLink AS ObjectLink_Personal_Member
                     WHERE ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                       AND inIsMember = TRUE AND COALESCE (inPersonalId,0) <> 0
                       AND ObjectLink_Personal_Member.ChildObjectId IN (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                                                        FROM ObjectLink AS ObjectLink_Personal_Member
                                                                        WHERE ObjectLink_Personal_Member.ObjectId = inPersonalId
                                                                          AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                                                        )
                     UNION
                      SELECT Object.Id
                      FROM Object
                      WHERE Object.DescId = zc_Object_Personal()
                      AND ( ((Object.Id = inPersonalId OR COALESCE (inPersonalId,0) = 0) AND inIsMember = FALSE)
                          OR (COALESCE (inPersonalId,0) = 0 AND inIsMember = TRUE) )
                     )

   , tmpContainer AS (SELECT CLO_Personal.ContainerId         AS ContainerId
                      FROM ContainerLinkObject AS CLO_Personal
                           INNER JOIN Container ON Container.Id = CLO_Personal.ContainerId AND Container.DescId = zc_Container_Summ()
                           INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                          ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                           LEFT JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                         ON CLO_PersonalServiceList.ContainerId = Container.Id
                                                        AND CLO_PersonalServiceList.DescId = zc_ContainerLinkObject_PersonalServiceList()

                           LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                         ON CLO_Unit.ContainerId = Container.Id AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                           LEFT JOIN ContainerLinkObject AS CLO_Position
                                                         ON CLO_Position.ContainerId = Container.Id AND CLO_Position.DescId = zc_ContainerLinkObject_Position()
                           LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                         ON CLO_Branch.ContainerId = Container.Id AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()

                           LEFT JOIN ContainerLinkObject AS CLO_ServiceDate
                                                         ON CLO_ServiceDate.ContainerId = CLO_Personal.ContainerId
                                                        AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate()
                           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId
                           LEFT JOIN ObjectDate AS ObjectDate_Service
                                                ON ObjectDate_Service.ObjectId = CLO_ServiceDate.ObjectId
                                               AND ObjectDate_Service.DescId = zc_ObjectDate_ServiceDate_Value()
                      WHERE CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                        --AND (CLO_Personal.ObjectId = inPersonalId OR inPersonalId = 0)  -- через _tmpPersonal
                        AND CLO_Personal.ObjectId  IN (SELECT _tmpPersonal.PersonalId FROM _tmpPersonal)
                        AND (Object_InfoMoney_View.InfoMoneyDestinationId = inInfoMoneyDestinationId OR inInfoMoneyDestinationId = 0)
                        AND (Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId OR inInfoMoneyId = 0)
                        AND (Object_InfoMoney_View.InfoMoneyGroupId = inInfoMoneyGroupId OR inInfoMoneyGroupId = 0)
                        AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                        AND (CLO_Branch.ObjectId = inBranchId OR inBranchId = 0)
                        AND (ObjectDate_Service.ValueData = inServiceDate OR inIsServiceDate = FALSE)
                        AND (CLO_PersonalServiceList.ObjectId = inPersonalServiceListId OR COALESCE (inPersonalServiceListId,0) = 0)
                      )

   , tmpMIContainer AS (SELECT MIContainer.*
                        FROM tmpContainer
                             INNER JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.Containerid = tmpContainer.ContainerId
                                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                       )

   , tmpMovement AS (SELECT MIContainer.MovementId
                          , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS MoneySumm
                     FROM tmpContainer
                          LEFT JOIN tmpMIContainer AS MIContainer
                                                   ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                     GROUP BY MIContainer.MovementId
                     HAVING 0 <> SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                    )

   , tmpInfoMoney_View AS (SELECT * FROM Object_InfoMoney_View)

     SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber   
           , MovementDesc.ItemName     ::TVarChar       AS MovementDescName
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
          
           , tmpMovement.MoneySumm   ::TFloat AS MoneySumm_inf

           , (-1 * MovementItem.Amount) :: TFloat AS Amount
  
           , MIDate_ServiceDate.ValueData      AS ServiceDate
           , MIString_Comment.ValueData        AS Comment
           , Object_Cash.Id                    AS CashId
           , Object_Cash.ValueData             AS CashName

           , Object_Member.Id                  AS MemberId
           , Object_Member.ValueData           AS MemberName

           , Movement_PersonalService.InvNumber         AS InvNumber_Service
           , Movement_PersonalService.OperDate          AS OperDate_Service
           , MovementDate_ServiceDate_Service.ValueData AS ServiceDate_Service
           , MovementString_Comment_Service.ValueData   AS Comment_Service
           , Object_PersonalServiceList.ValueData       AS PersonalServiceListName
           , (COALESCE (MovementFloat_TotalSummToPay.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCard.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCardSecond.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCardSecondCash.ValueData, 0)
             ) :: TFloat AS TotalSummToPay_Service

           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all           
           
        
     FROM tmpMovement
          LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
 
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                 AND MovementItem.DescId = zc_MI_Master()
                                 --AND (MovementItem.ObjectId = inCashId OR COALESCE (inCashId, 0) = 0)
          LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId

          LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                     ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                    AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                                                         
          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
      
          LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                           ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = MILinkObject_Member.ObjectId

          LEFT JOIN Movement AS Movement_PersonalService
                             ON Movement_PersonalService.Id = Movement.ParentId
                            AND Movement_PersonalService.StatusId = zc_Enum_Status_Complete()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                       ON MovementLinkObject_PersonalServiceList.MovementId = Movement_PersonalService.Id
                                      AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

          LEFT JOIN MovementFloat AS MovementFloat_TotalSummToPay
                                  ON MovementFloat_TotalSummToPay.MovementId =  Movement_PersonalService.Id
                                 AND MovementFloat_TotalSummToPay.DescId = zc_MovementFloat_TotalSummToPay()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                  ON MovementFloat_TotalSummCard.MovementId =  Movement_PersonalService.Id
                                 AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecond
                                  ON MovementFloat_TotalSummCardSecond.MovementId =  Movement_PersonalService.Id
                                 AND MovementFloat_TotalSummCardSecond.DescId = zc_MovementFloat_TotalSummCardSecond()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecondCash
                                  ON MovementFloat_TotalSummCardSecondCash.MovementId = Movement_PersonalService.Id
                                 AND MovementFloat_TotalSummCardSecondCash.DescId = zc_MovementFloat_TotalSummCardSecondCash()
                                 
          LEFT JOIN MovementDate AS MovementDate_ServiceDate_Service
                                 ON MovementDate_ServiceDate_Service.MovementId = Movement_PersonalService.Id
                                AND MovementDate_ServiceDate_Service.DescId = zc_MovementDate_ServiceDate()
          LEFT JOIN MovementString AS MovementString_Comment_Service
                                   ON MovementString_Comment_Service.MovementId = Movement_PersonalService.Id
                                  AND MovementString_Comment_Service.DescId = zc_MovementString_Comment()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
          LEFT JOIN tmpInfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId






     ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.23         *
*/

-- тест
-- 
-- select * from gpReport_Personal_MoneySumm (inStartDate := ('01.06.2023')::TDateTime , inEndDate := ('30.06.2023')::TDateTime , inServiceDate := ('27.06.2023')::TDateTime , inisServiceDate := 'TRUE' , inisMember := 'False', inAccountId := 0 , inBranchId := 301310 , inInfoMoneyId := 273733 , inInfoMoneyGroupId := 0 , inInfoMoneyDestinationId := 0 , inPersonalServiceListId := 0 , inPersonalId := 633146 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
-- select * from gpReport_Personal_MoneySumm(inStartDate := ('01.06.2023')::TDateTime , inEndDate := ('30.06.2023')::TDateTime , inServiceDate := ('27.06.2023')::TDateTime , inisServiceDate := 'False' , inisMember := 'False' , inAccountId := 0 , inBranchId := 8374 , inInfoMoneyId := 273733 , inInfoMoneyGroupId := 0 , inInfoMoneyDestinationId := 0 , inPersonalServiceListId := 0 , inPersonalId := 9224419 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');

--select * from object where id = 633146