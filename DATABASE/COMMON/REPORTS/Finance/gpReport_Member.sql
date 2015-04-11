-- Function: gpReport_Member

DROP FUNCTION IF EXISTS gpReport_Member (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Member(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- Счет
    IN inBranchId         Integer,    -- Счет
    IN inInfoMoneyId      Integer,    -- Управленческая статья
    IN inInfoMoneyGroupId Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, MemberId Integer, MemberCode Integer, MemberName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AccountId Integer, AccountName TVarChar
             , CarName TVarChar
             , BranchName TVarChar
             , StartAmount TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , MoneySumm TFloat, ReportSumm TFloat, AccountSumm TFloat, SendSumm TFloat
             , EndAmount TFloat, EndAmountD TFloat, EndAmountK TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());

     -- Результат
  RETURN QUERY
     SELECT
        Operation.ContainerId,
        Object_Member.Id                                                                            AS MemberId,
        Object_Member.ObjectCode                                                                    AS MemberCode,
        Object_Member.ValueData                                                                     AS MemberName,
        Object_InfoMoney_View.InfoMoneyGroupName                                                    AS InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName                                              AS InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode                                                         AS InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName                                                         AS InfoMoneyName,
        Object_InfoMoney_View.InfoMoneyName_all                                                     AS InfoMoneyName_all,
        Object_Account_View.AccountId                                                               AS AccountId,
        Object_Account_View.AccountName_all                                                         AS AccountName,
        (COALESCE (Object_CarModel.ValueData, '') || ' ' || COALESCE (Object_Car.ValueData, '')) :: TVarChar AS CarName,

        Object_Branch.ValueData                                                                     AS BranchName,
        Operation.StartAmount ::TFloat                                                              AS StartAmount,

        CASE WHEN Operation.StartAmount > 0 THEN Operation.StartAmount ELSE 0 END ::TFloat          AS StartAmountD,
        CASE WHEN Operation.StartAmount < 0 THEN -1 * Operation.StartAmount ELSE 0 END :: TFloat    AS StartAmountK,


        Operation.DebetSumm::TFloat                                                                 AS DebetSumm,
        Operation.KreditSumm::TFloat                                                                AS KreditSumm,

        Operation.MoneySumm::TFloat                                                                 AS MoneySumm,
        Operation.ReportSumm::TFloat                                                                AS ReportSumm,
        Operation.AccountSumm::TFloat                                                               AS AccountSumm,
        Operation.SendSumm::TFloat                                                                  AS SendSumm,

        Operation.EndAmount ::TFloat                                                                AS EndAmount,
        CASE WHEN Operation.EndAmount > 0 THEN Operation.EndAmount ELSE 0 END :: TFloat             AS EndAmountD,
        CASE WHEN Operation.EndAmount < 0 THEN -1 * Operation.EndAmount ELSE 0 END :: TFloat        AS EndAmountK


     FROM
         (SELECT Operation_all.ContainerId, Operation_all.ObjectId,  Operation_all.MemberId, Operation_all.InfoMoneyId,
                 CLO_Car.ObjectId AS CarId, Operation_all.BranchId,
                     SUM (Operation_all.StartAmount) AS StartAmount,
                     SUM (Operation_all.DebetSumm)   AS DebetSumm,
                     SUM (Operation_all.KreditSumm)  AS KreditSumm,

                     SUM (Operation_all.MoneySumm)   AS MoneySumm,
                     SUM (Operation_all.ReportSumm)  AS ReportSumm,
                     SUM (Operation_all.AccountSumm) AS AccountSumm,
                     SUM (Operation_all.SendSumm)    AS SendSumm,

                     SUM (Operation_all.EndAmount)   AS EndAmount
          FROM
          (SELECT tmpContainer.Id AS ContainerId, tmpContainer.ObjectId, tmpContainer.MemberId, tmpContainer.InfoMoneyId, tmpContainer.BranchId,
                     tmpContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0)                                                                                    AS StartAmount,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)          AS DebetSumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)     AS KreditSumm,

                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_Cash()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END)                 AS MoneySumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN (Movement.DescId = zc_Movement_PersonalReport()) OR (Movement.DescId = zc_Movement_PersonalSendCash() AND MIReport.MovementItemId IS NOT NULL) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)  AS ReportSumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId IN (zc_Movement_PersonalAccount(), zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)  AS AccountSumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN Movement.DescId = zc_Movement_PersonalSendCash() AND MIReport.MovementItemId IS NULL THEN MIContainer.Amount ELSE 0 END ELSE 0 END)  AS SendSumm,

                     tmpContainer.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)                         AS EndAmount
            FROM (SELECT CLO_Member.ContainerId AS Id, Container.Amount, Container.ObjectId, CLO_Member.ObjectId AS MemberId, CLO_InfoMoney.ObjectId AS InfoMoneyId, CLO_Branch.ObjectId AS BranchId
                  FROM ContainerLinkObject AS CLO_Member
                  INNER JOIN Container ON Container.Id = CLO_Member.ContainerId AND Container.DescId = zc_Container_Summ()
                  LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                  LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                ON CLO_Branch.ContainerId = Container.Id AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                  LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                ON CLO_Goods.ContainerId = Container.Id AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()

                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId
                  WHERE CLO_Member.DescId = zc_ContainerLinkObject_Member()
                    AND (Object_InfoMoney_View.InfoMoneyDestinationId = inInfoMoneyDestinationId OR inInfoMoneyDestinationId = 0)
                    AND (Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId OR inInfoMoneyId = 0)
                    AND (Object_InfoMoney_View.InfoMoneyGroupId = inInfoMoneyGroupId OR inInfoMoneyGroupId = 0)
                    AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                    AND (CLO_Branch.ObjectId = inBranchId OR inBranchId = 0)
                    AND (CLO_Goods.ObjectId IS  NULL)
                  ) AS tmpContainer
            LEFT JOIN MovementItemContainer AS MIContainer
                                            ON MIContainer.ContainerId = tmpContainer.Id
                                           AND MIContainer.OperDate >= inStartDate
            LEFT JOIN MovementItemReport AS MIReport ON MIReport.MovementItemId = MIContainer.MovementItemId
                                                    AND ((MIReport.ActiveContainerId = MIContainer.ContainerId
                                                      AND MIReport.PassiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                      AND MIContainer.Amount > 0
                                                         )
                                                      OR (MIReport.PassiveContainerId = MIContainer.ContainerId
                                                      AND MIReport.ActiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                      AND MIContainer.Amount < 0
                                                        ))

            LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
            GROUP BY tmpContainer.Id , tmpContainer.ObjectId, tmpContainer.MemberId, tmpContainer.InfoMoneyId, tmpContainer.BranchId, tmpContainer.Amount

           ) AS Operation_all

          LEFT JOIN ContainerLinkObject AS CLO_Car
                                        ON CLO_Car.ContainerId = Operation_all.ContainerId
                                       AND CLO_Car.DescId = zc_ContainerLinkObject_Car()

          GROUP BY Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.MemberId, Operation_all.InfoMoneyId, CLO_Car.ObjectId, Operation_all.BranchId
         ) AS Operation

            LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.ObjectId
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = Operation.MemberId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = Operation.CarId
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Operation.BranchId

            LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

     WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0 OR Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Member (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.09.14                                        *
 26.09.14                                                        *
 04.09.14                                                        *  + Branch
 03.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpReport_Member (inStartDate:= '01.08.2014', inEndDate:= '05.08.2014', inAccountId:= 0, inBranchId:=0, inInfoMoneyId:= 0, inInfoMoneyGroupId:= 0, inInfoMoneyDestinationId:= 0, inSession:= '2');
