-- Function: gpReport_Cash

DROP FUNCTION IF EXISTS gpReport_Cash (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Cash(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- Счет
    IN inCashId           Integer,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, CashCode Integer, CashName TVarChar
             , GroupId Integer, GroupName TVarChar
             , BranchName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AccountName TVarChar
             , UnitName TVarChar
             , MoneyPlaceName TVarChar, ItemName TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , StartAmount TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , EndAmount TFloat, EndAmountD TFloat, EndAmountK TFloat
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- Из-за прав меняем значение параметра
     IF COALESCE (inCashId, 0) = 0 AND (EXISTS (SELECT AccessKeyId_Guide FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_Guide <> 0 AND UserId = vbUserId)
                                     OR EXISTS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId
                                                                                                    AND AccessKeyId IN (SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = zc_Enum_Process_InsertUpdate_Movement_Cash())
                                               )
                                       )
     THEN inCashId:= -1;
     END IF;


     -- Результат
  RETURN QUERY
     SELECT
        Operation.ContainerId,
        Object_Cash.ObjectCode                                                                      AS CashCode,
        Object_Cash.ValueData                                                                       AS CashName,
        CASE WHEN Operation.ContainerId > 0 THEN 1 WHEN Operation.DebetSumm > 0 THEN 2 WHEN Operation.DebetSumm > 0 THEN 3 ELSE -1 END :: Integer AS GroupId,
        CASE WHEN Operation.ContainerId > 0 THEN '1.Сальдо' WHEN Operation.DebetSumm > 0 THEN '2.Поступления' WHEN Operation.DebetSumm > 0 THEN '3.Платежи' ELSE '' END :: TVarChar AS GroupName,
        Object_Branch.ValueData                                                                     AS BranchName,
        Object_InfoMoney_View.InfoMoneyGroupName                                                    AS InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName                                              AS InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode                                                         AS InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName                                                         AS InfoMoneyName,
        Object_InfoMoney_View.InfoMoneyName_all                                                     AS InfoMoneyName_all,
        Object_Account_View.AccountName_all                                                         AS AccountName,
        Object_Unit.ValueData                                                                       AS UnitName,
        Object_MoneyPlace.ValueData                                                                 AS MoneyPlaceName,
        ObjectDesc.ItemName                                                                         AS ItemName,
        Object_Contract_InvNumber_View.ContractCode                                                 AS ContractCode,
        Object_Contract_InvNumber_View.InvNumber                                                    AS ContractInvNumber,
        Object_Contract_InvNumber_View.ContractTagName                                              AS ContractTagName,
        Operation.StartAmount ::TFloat                                                              AS StartAmount,
        CASE WHEN Operation.StartAmount > 0 THEN Operation.StartAmount ELSE 0 END ::TFloat          AS StartAmountD,
        CASE WHEN Operation.StartAmount < 0 THEN -1 * Operation.StartAmount ELSE 0 END :: TFloat    AS StartAmountK,
        Operation.DebetSumm::TFloat                                                                 AS DebetSumm,
        Operation.KreditSumm::TFloat                                                                AS KreditSumm,
        Operation.EndAmount ::TFloat                                                                AS EndAmount,
        CASE WHEN Operation.EndAmount > 0 THEN Operation.EndAmount ELSE 0 END :: TFloat             AS EndAmountD,
        CASE WHEN Operation.EndAmount < 0 THEN -1 * Operation.EndAmount ELSE 0 END :: TFloat        AS EndAmountK,
        Operation.Comment :: TVarChar                                                               AS Comment

     FROM
         (SELECT Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.CashId, Operation_all.InfoMoneyId,
                 Operation_all.UnitId, Operation_all.MoneyPlaceId, Operation_all.ContractId, Operation_all.Comment,
                     SUM (Operation_all.StartAmount) AS StartAmount,
                     SUM (Operation_all.DebetSumm)   AS DebetSumm,
                     SUM (Operation_all.KreditSumm)  AS KreditSumm,
                     SUM (Operation_all.EndAmount)   AS EndAmount
          FROM
           -- остаток
          (SELECT CLO_Cash.ContainerId      AS ContainerId,
                  Container.ObjectId        AS ObjectId,
                  CLO_Cash.ObjectId         AS CashId,
                  0                         AS InfoMoneyId,
                  0                         AS UnitId,
                  0                         AS MoneyPlaceId,
                  0                         AS ContractId,
                  Container.Amount - COALESCE(SUM (MIContainer.Amount), 0)                                                             AS StartAmount,
                  0                         AS DebetSumm,
                  0                         AS KreditSumm,
                  Container.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)  AS EndAmount,
                  '' AS Comment

           FROM ContainerLinkObject AS CLO_Cash
                  INNER JOIN Container ON Container.Id = CLO_Cash.ContainerId AND Container.DescId = zc_Container_Summ()

                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = Container.Id
                                                                AND MIContainer.OperDate >= inStartDate

           WHERE CLO_Cash.DescId = zc_ContainerLinkObject_Cash()
             AND (Container.ObjectId = inAccountId OR inAccountId = 0)
             AND (CLO_Cash.ObjectId = inCashId OR inCashId = 0)
           GROUP BY CLO_Cash.ContainerId , Container.ObjectId, CLO_Cash.ObjectId, Container.Amount

           UNION ALL
           -- движение
           SELECT 0                                 AS ContainerId,
                  Container.ObjectId                AS ObjectId,
                  CLO_Cash.ObjectId                 AS CashId,
                  MILO_InfoMoney.ObjectId           AS InfoMoneyId,
                  MILO_Unit.ObjectId                AS UnitId,
                  MILO_MoneyPlace.ObjectId          AS MoneyPlaceId,
                  MILO_Contract.ObjectId            AS ContractId,
                  0                                 AS StartAmount,
                  SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)         AS DebetSumm,
                  SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)    AS KreditSumm,
                  0                                 AS EndAmount,
                  COALESCE (MIString_Comment.ValueData, '') AS Comment

           FROM ContainerLinkObject AS CLO_Cash
                  INNER JOIN Container ON Container.Id = CLO_Cash.ContainerId AND Container.DescId = zc_Container_Summ()

                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = Container.Id
                                                                AND MIContainer.OperDate >= inStartDate

                  LEFT JOIN MovementItemString AS MIString_Comment
                                               ON MIString_Comment.MovementItemId = MIContainer.MovementItemId
                                              AND MIString_Comment.DescId = zc_MIString_Comment()
                  LEFT JOIN MovementItemLinkObject AS MILO_MoneyPlace
                                                   ON MILO_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                  AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                  LEFT JOIN MovementItemLinkObject AS MILO_Contract
                                                   ON MILO_Contract.MovementItemId = MIContainer.MovementItemId
                                                  AND MILO_Contract.DescId = zc_MILinkObject_Contract()
                  LEFT JOIN MovementItemLinkObject AS MILO_Unit
                                                   ON MILO_Unit.MovementItemId = MIContainer.MovementItemId
                                                  AND MILO_Unit.DescId = zc_MILinkObject_Unit()
                  LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                   ON MILO_InfoMoney.MovementItemId = MIContainer.MovementItemId
                                                  AND MILO_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILO_InfoMoney.ObjectId

           WHERE CLO_Cash.DescId = zc_ContainerLinkObject_Cash()
             AND (Container.ObjectId = inAccountId OR inAccountId = 0)
             AND (CLO_Cash.ObjectId = inCashId OR inCashId = 0)
           GROUP BY CLO_Cash.ContainerId , Container.ObjectId, CLO_Cash.ObjectId, MILO_InfoMoney.ObjectId,
                    MILO_Unit.ObjectId, MILO_MoneyPlace.ObjectId, MILO_Contract.ObjectId,
                    MIString_Comment.ValueData

           ) AS Operation_all



          GROUP BY Operation_all.ContainerId, Operation_all.ObjectId, Operation_all.CashId, Operation_all.InfoMoneyId, Operation_all.UnitId, Operation_all.MoneyPlaceId, Operation_all.ContractId, Operation_all.Comment
         ) AS Operation


     LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.ObjectId
     LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = Operation.CashId
     LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
     LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Operation.UnitId
     LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = Operation.MoneyPlaceId
     LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId

     LEFT JOIN ObjectLink AS ObjectLink_Cash_Branch
                          ON ObjectLink_Cash_Branch.ObjectId = Operation.CashId
                         AND ObjectLink_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
     LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Cash_Branch.ChildObjectId

     LEFT JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId = Operation.ContractId

     WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0 OR Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Cash (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.09.14                                        *
 09.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpReport_Cash (inStartDate:= '01.08.2014', inEndDate:= '31.08.2014', inAccountId:= 0, inCashId:=0, inSession:= '2');
