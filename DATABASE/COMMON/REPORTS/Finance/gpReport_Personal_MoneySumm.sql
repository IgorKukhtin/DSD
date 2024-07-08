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
RETURNS TABLE (Id Integer, MovementItemId Integer, InvNumber TVarChar, MovementDescName TVarChar
             , OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , CashId Integer, CashName TVarChar
             
             , MoneySumm_inf   TFloat
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PersonalServiceListCode Integer, PersonalServiceListName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , BranchName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AccountName TVarChar
             , ServiceDate TDateTime
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
     
     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- !!!Проверка прав роль - Ограничение - нет вообще доступа к просмотру данных ЗП!!!
     PERFORM lpCheck_UserRole_8813637 (vbUserId);
     

     -- !!!Проверка прав роль - Ограничение - нет доступа к просмотру ведомость Админ ЗП!!!
     PERFORM lpCheck_UserRole_11026035 (CASE WHEN inPersonalServiceListId > 0
                                                  THEN inPersonalServiceListId
                                             ELSE (SELECT OB.ObjectId FROM ObjectBoolean AS OB WHERE OB.DescId = zc_ObjectBoolean_PersonalServiceList_User() AND OB.ValueData = TRUE LIMIT 1)
                                        END
                                      , vbUserId
                                       );


     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;

     -- !!! права пользователей !!!
     IF EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
        AND vbUserId <> 14599 -- Коротченко Т.Н.
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
                           , CLO_Personal.ObjectId            AS PersonalId
                           , CLO_InfoMoney.ObjectId           AS InfoMoneyId
                           , CLO_Unit.ObjectId                AS UnitId
                           , CLO_Position.ObjectId            AS PositionId
                           , CLO_PersonalServiceList.ObjectId AS PersonalServiceListId
                           , CLO_Branch.ObjectId              AS BranchId 
                           , Container.ObjectId               AS AccountId
                           , ObjectDate_Service.ValueData     AS ServiceDate
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
                        WHERE MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount())  
                       )

   , tmpMovement AS (SELECT MIContainer.MovementId
                          , MIContainer.MovementDescId
                          , MIContainer.MovementItemId
                          , tmpContainer.PersonalId
                          , tmpContainer.InfoMoneyId
                          , tmpContainer.AccountId
                          , tmpContainer.UnitId
                          , tmpContainer.PositionId
                          , tmpContainer.PersonalServiceListId
                          , tmpContainer.BranchId
                          , tmpContainer.ServiceDate
                          , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN MIContainer.Amount ELSE 0 END) AS MoneySumm
                     FROM tmpContainer
                          LEFT JOIN tmpMIContainer AS MIContainer
                                                   ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                     GROUP BY MIContainer.MovementId
                            , MIContainer.MovementDescId
                            , MIContainer.MovementItemId
                            , tmpContainer.PersonalId
                            , tmpContainer.InfoMoneyId
                            , tmpContainer.AccountId
                            , tmpContainer.UnitId
                            , tmpContainer.PositionId
                            , tmpContainer.PersonalServiceListId
                            , tmpContainer.BranchId
                            , tmpContainer.ServiceDate
                     HAVING 0 <> SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN MIContainer.Amount ELSE 0 END)
                    )

   , tmpInfoMoney_View AS (SELECT * FROM Object_InfoMoney_View)

     SELECT
             Movement.Id                          AS Id
           , tmpMovement.MovementItemId           AS MovementItemId
           , Movement.InvNumber                   AS InvNumber   
           , MovementDesc.ItemName     ::TVarChar AS MovementDescName
           , Movement.OperDate                    AS OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , Object_Cash.Id                       AS CashId
           , (Object_Cash.ValueData || ' * ' || Object_Currency.ValueData) :: TVarChar AS CashName

           , tmpMovement.MoneySumm                   ::TFloat AS MoneySumm_inf

           , Object_Personal.Id                               AS PersonalId
           , Object_Personal.ObjectCode                       AS PersonalCode
           , Object_Personal.ValueData                        AS PersonalName
           , Object_PersonalServiceList.ObjectCode            AS PersonalServiceListCode
           , Object_PersonalServiceList.ValueData             AS PersonalServiceListName
           , Object_Unit.ObjectCode                           AS UnitCode
           , Object_Unit.ValueData                            AS UnitName
           , Object_Position.ObjectCode                       AS PositionCode
           , Object_Position.ValueData                        AS PositionName
           , Object_Branch.ValueData                          AS BranchName
           , Object_InfoMoney_View.InfoMoneyGroupName         AS InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName   AS InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode              AS InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName              AS InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all          AS InfoMoneyName_all
           , Object_Account_View.AccountName_all              AS AccountName
           , tmpMovement.ServiceDate                          AS ServiceDate

     FROM tmpMovement
          LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
 
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = tmpMovement.PersonalServiceListId
          LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpMovement.PersonalId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement.UnitId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpMovement.PositionId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpMovement.BranchId
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpMovement.InfoMoneyId
          LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpMovement.AccountId

          LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId
          LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                           ON MILinkObject_Currency.MovementItemId = tmpMovement.MovementItemId
                                          AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = COALESCE (MILinkObject_Currency.ObjectId, zc_Enum_Currency_Basis())
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
