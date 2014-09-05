DROP FUNCTION IF EXISTS gpReport_Personal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Personal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Personal (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Personal(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inServiceDate      TDateTime , --
    IN inisServiceDate    Boolean , --
    IN inAccountId        Integer,    -- Счет
    IN inBranchId         Integer,    -- Счет
    IN inInfoMoneyId      Integer,    -- Управленческая статья
    IN inInfoMoneyGroupId Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (PersonalCode Integer, PersonalName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AccountName TVarChar
             , DateService TDateTime
             , BranchName TVarChar
             , StartAmount_A TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , EndAmount_A TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- Результат
  RETURN QUERY
     SELECT
        Object_Personal.ObjectCode                                                                  AS PersonalCode,
        Object_Personal.ValueData                                                                   AS PersonalName,
        Object_InfoMoney_View.InfoMoneyGroupName                                                    AS InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName                                              AS InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode                                                         AS InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName                                                         AS InfoMoneyName,
        Object_Account_View.AccountName_all                                                         AS AccountName,
        Operation.DateService                                                                       AS DateService,
        Object_Branch.ValueData                                                                     AS BranchName,
        Operation.StartAmount ::TFloat                                                              AS StartAmount_A,
        Operation.DebetSumm::TFloat                                                                 AS DebetSumm,
        Operation.KreditSumm::TFloat                                                                AS KreditSumm,
        Operation.EndAmount ::TFloat                                                                AS EndAmount_A

     FROM
         (SELECT Operation_all.ContainerId, Operation_all.ObjectId,  Operation_all.PersonalId, Operation_all.InfoMoneyId,
                 Operation_all.BranchId, Operation_all.DateService,
                     SUM (Operation_all.StartAmount) AS StartAmount,
                     SUM (Operation_all.DebetSumm)   AS DebetSumm,
                     SUM (Operation_all.KreditSumm)  AS KreditSumm,
                     SUM (Operation_all.EndAmount)   AS EndAmount
          FROM
          (SELECT tmpContainer.Id AS ContainerId, tmpContainer.ObjectId, tmpContainer.PersonalId, tmpContainer.InfoMoneyId, tmpContainer.BranchId, tmpContainer.DateService,
                     tmpContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0)                                                                                    AS StartAmount,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)          AS DebetSumm,
                     SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)     AS KreditSumm,
                     tmpContainer.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)                         AS EndAmount
            FROM (SELECT CLO_Personal.ContainerId AS Id, Container.Amount, Container.ObjectId, CLO_Personal.ObjectId AS PersonalId, CLO_InfoMoney.ObjectId AS InfoMoneyId, CLO_Branch.ObjectId AS BranchId, ObjectDate_Service.ValueData AS DateService
                  FROM ContainerLinkObject AS CLO_Personal
                  INNER JOIN Container ON Container.Id = CLO_Personal.ContainerId AND Container.DescId = zc_Container_Summ()
                  INNER JOIN Object ON Object.Id = CLO_Personal.ObjectId AND Object.DescId = zc_Object_Personal()
                  INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                 ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()

                  LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                ON CLO_Branch.ContainerId = Container.Id AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()

                  LEFT JOIN ContainerLinkObject AS CLO_ServiceDate
                                                ON CLO_ServiceDate.ContainerId = CLO_Personal.ContainerId
                                               AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate()
                  LEFT JOIN ObjectDate AS ObjectDate_Service
                                       ON ObjectDate_Service.ObjectId = CLO_ServiceDate.ObjectId
                                      AND ObjectDate_Service.DescId = zc_ObjectDate_ServiceDate_Value()



                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId
                  WHERE CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                    AND (Object_InfoMoney_View.InfoMoneyDestinationId = inInfoMoneyDestinationId OR inInfoMoneyDestinationId = 0)
                    AND (Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId OR inInfoMoneyId = 0)
                    AND (Object_InfoMoney_View.InfoMoneyGroupId = inInfoMoneyGroupId OR inInfoMoneyGroupId = 0)
                    AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                    AND (CLO_Branch.ObjectId = inBranchId OR inBranchId = 0)
                    AND (CASE WHEN inisServiceDate = True THEN ObjectDate_Service.ValueData = inServiceDate ELSE 0 = 0 END)
                  ) AS tmpContainer

            LEFT JOIN MovementItemContainer AS MIContainer
                                            ON MIContainer.Containerid = tmpContainer.Id
                                           AND MIContainer.OperDate >= inStartDate
            LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
            GROUP BY tmpContainer.Id, tmpContainer.ObjectId, tmpContainer.PersonalId, tmpContainer.InfoMoneyId, tmpContainer.BranchId, tmpContainer.DateService, tmpContainer.Amount

           ) AS Operation_all

          GROUP BY Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.PersonalId, Operation_all.InfoMoneyId, Operation_all.BranchId, Operation_all.DateService
         ) AS Operation


     LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.ObjectId
     LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = Operation.PersonalId
     LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
     LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Operation.BranchId

     WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0 OR Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Personal (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.09.14                                                        *


*/

-- тест
-- SELECT * FROM gpReport_Personal (inStartDate:= '01.08.2014', inEndDate:= '05.08.2014', inServiceDate:= '05.08.2014', inisServiceDate:= false, inAccountId:= 0, inBranchId:=0, inInfoMoneyId:= 0, inInfoMoneyGroupId:= 0, inInfoMoneyDestinationId:= 0, inSession:= '2');
