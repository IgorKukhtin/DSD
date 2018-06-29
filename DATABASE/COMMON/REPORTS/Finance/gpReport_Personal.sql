-- Function: gpReport_Personal

DROP FUNCTION IF EXISTS gpReport_Personal (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Personal(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inServiceDate      TDateTime , --
    IN inIsServiceDate    Boolean , --
    IN inAccountId        Integer,    -- Счет
    IN inBranchId         Integer,    -- филиал
    IN inInfoMoneyId      Integer,    -- Управленческая статья
    IN inInfoMoneyGroupId Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    --
    IN inPersonalServiceListId    Integer,    -- ведомость
    IN inPersonalId       Integer,    -- Фио сотрудника
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PersonalServiceListCode Integer, PersonalServiceListName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , BranchName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AccountName TVarChar
             , ServiceDate TDateTime
             , StartAmount TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , MoneySumm TFloat, MoneySummCard TFloat, MoneySummCardSecond TFloat, MoneySummCash TFloat
             , ServiceSumm TFloat, IncomeSumm TFloat
             , SummTransportAdd TFloat, SummTransportAddLong TFloat, SummTransportTaxi TFloat, SummPhone TFloat, SummNalog TFloat
             , EndAmount TFloat, EndAmountD TFloat, EndAmountK TFloat
             , ContainerId Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

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
     SELECT
        Object_Personal.Id                                                                          AS PersonalId,
        Object_Personal.ObjectCode                                                                  AS PersonalCode,
        Object_Personal.ValueData                                                                   AS PersonalName,
        Object_PersonalServiceList.ObjectCode                                                       AS PersonalServiceListCode,
        Object_PersonalServiceList.ValueData                                                        AS PersonalServiceListName,
        Object_Unit.ObjectCode                                                                      AS UnitCode,
        Object_Unit.ValueData                                                                       AS UnitName,
        Object_Position.ObjectCode                                                                  AS PositionCode,
        Object_Position.ValueData                                                                   AS PositionName,
        Object_Branch.ValueData                                                                     AS BranchName,
        Object_InfoMoney_View.InfoMoneyGroupName                                                    AS InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName                                              AS InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode                                                         AS InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName                                                         AS InfoMoneyName,
        Object_InfoMoney_View.InfoMoneyName_all                                                     AS InfoMoneyName_all,
        Object_Account_View.AccountName_all                                                         AS AccountName,
        Operation.ServiceDate                                                                       AS ServiceDate,
        (-1 * Operation.StartAmount) :: TFloat                                                      AS StartAmount,
        CASE WHEN Operation.StartAmount > 0 THEN Operation.StartAmount ELSE 0 END ::TFloat          AS StartAmountD,
        CASE WHEN Operation.StartAmount < 0 THEN -1 * Operation.StartAmount ELSE 0 END :: TFloat    AS StartAmountK,
        Operation.DebetSumm :: TFloat                                                               AS DebetSumm,
        Operation.KreditSumm :: TFloat                                                              AS KreditSumm,

        Operation.MoneySumm :: TFloat                                                               AS MoneySumm,
        Operation.MoneySummCard :: TFloat                                                           AS MoneySummCard,
        Operation.MoneySummCardSecond :: TFloat                                                     AS MoneySummCardSecond,
        Operation.MoneySummCash :: TFloat                                                           AS MoneySummCash,

        Operation.ServiceSumm :: TFloat                                                             AS ServiceSumm,
        Operation.IncomeSumm :: TFloat                                                              AS IncomeSumm,
        Operation.SummTransportAdd :: TFloat                                                        AS SummTransportAdd,
        Operation.SummTransportAddLong :: TFloat                                                    AS SummTransportAddLong,
        Operation.SummTransportTaxi :: TFloat                                                       AS SummTransportTaxi,
        Operation.SummPhone :: TFloat                                                               AS SummPhone,
        Operation.SummNalog :: TFloat                                                               AS SummNalog,
        (-1 * Operation.EndAmount) :: TFloat                                                        AS EndAmount,
        CASE WHEN Operation.EndAmount > 0 THEN Operation.EndAmount ELSE 0 END :: TFloat             AS EndAmountD,
        CASE WHEN Operation.EndAmount < 0 THEN -1 * Operation.EndAmount ELSE 0 END :: TFloat        AS EndAmountK,
        Operation.ContainerId :: Integer                                                            AS ContainerId

     FROM
         (SELECT Operation_all.ContainerId, Operation_all.AccountId, Operation_all.PersonalId
               , Operation_all.InfoMoneyId, Operation_all.UnitId, Operation_all.PositionId
               , Operation_all.PersonalServiceListId
               , Operation_all.BranchId, Operation_all.ServiceDate
               , SUM (Operation_all.StartAmount) AS StartAmount
               , SUM (Operation_all.DebetSumm)   AS DebetSumm
               , SUM (Operation_all.KreditSumm)  AS KreditSumm
               , SUM (Operation_all.MoneySumm)   AS MoneySumm
               , SUM (Operation_all.MoneySummCard)       AS MoneySummCard
               , SUM (Operation_all.MoneySummCardSecond) AS MoneySummCardSecond
               , SUM (Operation_all.MoneySummCash)       AS MoneySummCash
               , SUM (Operation_all.ServiceSumm)         AS ServiceSumm
               , SUM (Operation_all.IncomeSumm)            AS IncomeSumm
               , SUM (Operation_all.SummTransportAdd)      AS SummTransportAdd
               , SUM (Operation_all.SummTransportAddLong)  AS SummTransportAddLong
               , SUM (Operation_all.SummTransportTaxi)     AS SummTransportTaxi
               , SUM (Operation_all.SummPhone)             AS SummPhone
               , SUM (Operation_all.SummNalog)             AS SummNalog
               , SUM (Operation_all.EndAmount)   AS EndAmount
          FROM
          (SELECT tmpContainer.ContainerId
                , tmpContainer.AccountId
                , tmpContainer.PersonalId
                , tmpContainer.InfoMoneyId
                , tmpContainer.UnitId
                , tmpContainer.PositionId
                , tmpContainer.PersonalServiceListId
                , tmpContainer.BranchId
                , tmpContainer.ServiceDate
                , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)                                                                                   AS StartAmount
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)          AS DebetSumm
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)     AS KreditSumm
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_Cash(), zc_Movement_BankAccount()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS MoneySumm

                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_BankAccount()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS MoneySummCard
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_Cash()) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Cash_PersonalCardSecond() THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS MoneySummCardSecond
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_Cash()) AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalService(), zc_Enum_AnalyzerId_Cash_PersonalAvance()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS MoneySummCash
                
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_PersonalService_Nalog() THEN CASE WHEN Movement.DescId IN (zc_Movement_PersonalService()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ServiceSumm
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND Movement.DescId        = zc_Movement_Income()                       THEN  1 * MIContainer.Amount ELSE 0 END) AS IncomeSumm
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Add()         THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportAdd
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_AddLong()     THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportAddLong
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Taxi()        THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportTaxi
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_PersonalService_Nalog() THEN  1 * MIContainer.Amount ELSE 0 END) AS SummNalog
                , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_MobileBills_Personal()  THEN  1 * MIContainer.Amount ELSE 0 END) AS SummPhone

                , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)                        AS EndAmount
            FROM (SELECT CLO_Personal.ContainerId         AS ContainerId
                       , Container.ObjectId               AS AccountId
                       , Container.Amount
                       , CLO_Personal.ObjectId            AS PersonalId
                       , CLO_InfoMoney.ObjectId           AS InfoMoneyId
                       , CLO_Unit.ObjectId                AS UnitId
                       , CLO_Position.ObjectId            AS PositionId
                       , CLO_PersonalServiceList.ObjectId AS PersonalServiceListId
                       , CLO_Branch.ObjectId              AS BranchId
                       , ObjectDate_Service.ValueData     AS ServiceDate
                  FROM ContainerLinkObject AS CLO_Personal
                       INNER JOIN Container ON Container.Id = CLO_Personal.ContainerId AND Container.DescId = zc_Container_Summ()
                       INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                      ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                       INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                      ON CLO_PersonalServiceList.ContainerId = Container.Id
                                                     AND CLO_PersonalServiceList.DescId = zc_ContainerLinkObject_PersonalServiceList()
                                                     AND (CLO_PersonalServiceList.ObjectId = inPersonalServiceListId OR COALESCE (inPersonalServiceListId,0) = 0)
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
                    AND (CLO_Personal.ObjectId = inPersonalId OR inPersonalId = 0)
                    AND (Object_InfoMoney_View.InfoMoneyDestinationId = inInfoMoneyDestinationId OR inInfoMoneyDestinationId = 0)
                    AND (Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId OR inInfoMoneyId = 0)
                    AND (Object_InfoMoney_View.InfoMoneyGroupId = inInfoMoneyGroupId OR inInfoMoneyGroupId = 0)
                    AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                    AND (CLO_Branch.ObjectId = inBranchId OR inBranchId = 0)
                    AND (ObjectDate_Service.ValueData = inServiceDate OR inIsServiceDate = FALSE)
                  ) AS tmpContainer
                  LEFT JOIN MovementItemContainer AS MIContainer
                                                  ON MIContainer.Containerid = tmpContainer.ContainerId
                                                 AND MIContainer.OperDate >= inStartDate
                  LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
            GROUP BY tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.PersonalId, tmpContainer.InfoMoneyId, tmpContainer.UnitId, tmpContainer.PositionId, tmpContainer.PersonalServiceListId, tmpContainer.BranchId, tmpContainer.ServiceDate, tmpContainer.Amount

           ) AS Operation_all

          GROUP BY Operation_all.ContainerId, Operation_all.AccountId, Operation_all.PersonalId, Operation_all.InfoMoneyId, Operation_all.UnitId, Operation_all.PositionId, Operation_all.BranchId, Operation_all.ServiceDate, Operation_all.PersonalServiceListId
         ) AS Operation

     LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.AccountId
     LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = Operation.PersonalServiceListId
     LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = Operation.PersonalId
     LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Operation.UnitId
     LEFT JOIN Object AS Object_Position ON Object_Position.Id = Operation.PositionId
     LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Operation.BranchId

     LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId

     WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0 OR Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.03.17         * add inPersonalId 
                    add inPersonalServiceListId 
 07.04.15                                        * all
 04.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpReport_Personal (inStartDate:= '01.07.2017', inEndDate:= '01.08.2017', inServiceDate:= '01.07.2017', inIsServiceDate:= false, inAccountId:= 0, inBranchId:=0, inInfoMoneyId:= 0, inInfoMoneyGroupId:= 0, inInfoMoneyDestinationId:= 0, inPersonalServiceListId:= 0, inPersonalId:= 0, inSession:= zfCalc_UserAdmin());
