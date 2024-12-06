-- Function: gpReport_Founder

DROP FUNCTION IF EXISTS gpReport_Founder (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Founder (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_Founder(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inAccountId        Integer,    -- Счет
    IN inInfoMoneyId      Integer,    -- Управленческая статья
    IN inInfoMoneyGroupId Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    --
    IN inIsDate           Boolean,    -- по датам
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, OperDate TDatetime
             , GroupId Integer, GroupName TVarChar
             , FounderCode Integer, FounderName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AccountName TVarChar
             , StartAmount TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , MoneySumm TFloat, ServiceSumm TFloat
             , EndAmount TFloat, EndAmountD TFloat, EndAmountK TFloat
             , MoneyPlaceName TVarChar, ItemName TVarChar
             , Name_by TVarChar, ItemName_by TVarChar
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


 CREATE TEMP TABLE tmpContainer (Id integer, Amount Tfloat, AccountId Integer, FounderId Integer) ON COMMIT DROP;
 
      INSERT INTO tmpContainer (Id , Amount , AccountId , FounderId )
                 SELECT CLO_Founder.ContainerId AS Id, Container.Amount, Container.ObjectId AS AccountId, CLO_Founder.ObjectId AS FounderId -- , CLO_InfoMoney.ObjectId AS InfoMoneyId
                  FROM ContainerLinkObject AS CLO_Founder
                       INNER JOIN Container ON Container.Id = CLO_Founder.ContainerId AND Container.DescId = zc_Container_Summ()
                       /*LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                     ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                       LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId*/
                  WHERE CLO_Founder.DescId = zc_ContainerLinkObject_Founder()
                    /*AND (Object_InfoMoney_View.InfoMoneyDestinationId = inInfoMoneyDestinationId OR inInfoMoneyDestinationId = 0)
                    AND (Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId OR inInfoMoneyId = 0)
                    AND (Object_InfoMoney_View.InfoMoneyGroupId = inInfoMoneyGroupId OR inInfoMoneyGroupId = 0)*/
       ;  
       ANALYZE tmpContainer;

     -- Результат
  RETURN QUERY
    

     SELECT
        Operation.ContainerId,
        CASE WHEN Operation.OperDate = zc_DateStart() THEN NULL ELSE Operation.OperDate END :: TDateTime AS OperDate,
        CASE WHEN Operation.ContainerId > 0 THEN 1          WHEN Operation.DebetSumm > 0 THEN 2           WHEN Operation.KreditSumm > 0 THEN 3              ELSE -1 END :: Integer AS GroupId,
        CASE WHEN Operation.ContainerId > 0 THEN '1.Сальдо' WHEN Operation.DebetSumm > 0 THEN '2.Расчеты' WHEN Operation.KreditSumm > 0 THEN '3.Начисления' ELSE '' END :: TVarChar AS GroupName,
        Object_Founder.ObjectCode                                                                   AS FounderCode,
        Object_Founder.ValueData                                                                    AS FounderName,
        Object_InfoMoney_View.InfoMoneyGroupName                                                    AS InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName                                              AS InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode                                                         AS InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName                                                         AS InfoMoneyName,
        Object_Account_View.AccountName_all                                                         AS AccountName,

        Operation.StartAmount ::TFloat                                                              AS StartAmount,
        CASE WHEN Operation.StartAmount > 0 THEN Operation.StartAmount ELSE 0 END ::TFloat          AS StartAmountD,
        CASE WHEN Operation.StartAmount < 0 THEN -1 * Operation.StartAmount ELSE 0 END :: TFloat    AS StartAmountK,

        Operation.DebetSumm::TFloat                                                                 AS DebetSumm,
        Operation.KreditSumm::TFloat                                                                AS KreditSumm,
        Operation.MoneySumm :: TFloat                                                               AS MoneySumm,
        Operation.ServiceSumm :: TFloat                                                             AS ServiceSumm,

        Operation.EndAmount ::TFloat                                                                AS EndAmount,
        CASE WHEN Operation.EndAmount > 0 THEN Operation.EndAmount ELSE 0 END :: TFloat             AS EndAmountD,
        CASE WHEN Operation.EndAmount < 0 THEN -1 * Operation.EndAmount ELSE 0 END :: TFloat        AS EndAmountK,

        Object_MoneyPlace.ValueData                                                                 AS MoneyPlaceName,
        ObjectDesc.ItemName                                                                         AS ItemName,
        Object_by.ValueData                                                                         AS Name_by,
        ObjectDesc_by.ItemName                                                                      AS ItemName_by,
        Operation.Comment :: TVarChar                                                               AS Comment

     FROM
         (SELECT Operation_all.ContainerId, Operation_all.AccountId,  Operation_all.FounderId
                   , SUM (Operation_all.StartAmount) AS StartAmount
                   , SUM (Operation_all.DebetSumm)   AS DebetSumm
                   , SUM (Operation_all.KreditSumm)  AS KreditSumm
                   , SUM (Operation_all.MoneySumm)   AS MoneySumm
                   , SUM (Operation_all.ServiceSumm) AS ServiceSumm
                   , SUM (Operation_all.EndAmount)   AS EndAmount
                   , Operation_all.ObjectId
                   , Operation_all.MoneyPlaceId
                   , Operation_all.InfoMoneyId
                   , Operation_all.Comment
                   , Operation_all.OperDate
                   , Operation_all.AnalyzerId
          FROM
              (SELECT tmpContainer.Id AS ContainerId, tmpContainer.AccountId, tmpContainer.FounderId
                    , tmpContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0) AS StartAmount
                    , 0 AS DebetSumm
                    , 0 AS KreditSumm
                    , 0 AS MoneySumm
                    , 0 AS ServiceSumm
                    , tmpContainer.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndAmount
                    , 0 AS ObjectId
                    , 0 AS MoneyPlaceId
                    , 0 AS InfoMoneyId
                    , '' AS Comment
                    , zc_DateStart() :: TDatetime AS OperDate
                    , 0 AS AnalyzerId
               FROM tmpContainer
                    LEFT JOIN MovementItemContainer AS MIContainer
                                                    ON MIContainer.ContainerId = tmpContainer.Id
                                                   AND MIContainer.OperDate >= inStartDate
               GROUP BY tmpContainer.Id , tmpContainer.AccountId, tmpContainer.FounderId, tmpContainer.Amount
                      
              UNION ALL
               SELECT 0 AS ContainerId, tmpContainer.AccountId, tmpContainer.FounderId
                    , 0 AS StartAmount
                    , SUM (CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END)      AS DebetSumm
                    , SUM (CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END) AS KreditSumm
                    , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_Income(), zc_Movement_PersonalService(), zc_Movement_Service(), zc_Movement_MobileBills()) THEN MIContainer.Amount ELSE 0 END) AS MoneySumm
                    , SUM (CASE WHEN Movement.DescId IN (zc_Movement_FounderService()) THEN -1 * MIContainer.Amount ELSE 0 END)     AS ServiceSumm
                    , 0 AS EndAmount
                    , MovementItem.ObjectId
                    , MILO_MoneyPlace.ObjectId                  AS MoneyPlaceId
                      -- Налоговые платежи по ЗП - Отчисления ИЛИ ...
                    , CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_PersonalService_Nalog() THEN zc_Enum_InfoMoney_50101() ELSE MILO_InfoMoney.ObjectId END AS InfoMoneyId
                    , COALESCE (MIString_Comment.ValueData, '') AS Comment
                    , CASE WHEN inIsDate = TRUE THEN MIContainer.OperDate ELSE zc_DateStart() END :: TDatetime AS OperDate
                    , MIContainer.AnalyzerId
               FROM tmpContainer
                    LEFT JOIN MovementItemContainer AS MIContainer
                                                    ON MIContainer.ContainerId = tmpContainer.Id
                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                    LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                    LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                    LEFT JOIN MovementItemString AS MIString_Comment
                                                 ON MIString_Comment.MovementItemId = MIContainer.MovementItemId
                                                AND MIString_Comment.DescId = zc_MIString_Comment()
                    LEFT JOIN MovementItemLinkObject AS MILO_MoneyPlace
                                                     ON MILO_MoneyPlace.MovementItemId = MIContainer.MovementItemId
                                                    AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                    LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                     ON MILO_InfoMoney.MovementItemId = MIContainer.MovementItemId
                                                    AND MILO_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
               GROUP BY tmpContainer.AccountId, tmpContainer.FounderId
                      , MovementItem.ObjectId
                      , MILO_MoneyPlace.ObjectId
                      , MILO_InfoMoney.ObjectId
                      , MIString_Comment.ValueData
                      , CASE WHEN inIsDate = TRUE THEN MIContainer.OperDate ELSE zc_DateStart() END :: TDatetime
                      , MIContainer.AnalyzerId
             ) AS Operation_all
          GROUP BY Operation_all.ContainerId, Operation_all.AccountId, Operation_all.FounderId
                 , Operation_all.ObjectId, Operation_all.MoneyPlaceId, Operation_all.InfoMoneyId, Operation_all.Comment
                 , Operation_all.OperDate
                 , Operation_all.AnalyzerId
         ) AS Operation

         LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = Operation.MoneyPlaceId
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId
         LEFT JOIN Object AS Object_by ON Object_by.Id = Operation.ObjectId
         LEFT JOIN ObjectDesc AS ObjectDesc_by ON ObjectDesc_by.Id = Object_by.DescId
         LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.ObjectId
         LEFT JOIN Object AS Object_Founder ON Object_Founder.Id = Operation.FounderId
         LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId

     WHERE (Operation.StartAmount <> 0 
         OR Operation.EndAmount <> 0 
         OR Operation.DebetSumm <> 0 
         OR Operation.KreditSumm <> 0 
         OR Operation.MoneySumm <> 0 
         OR Operation.ServiceSumm <> 0)
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Founder (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.08.15         * add inIsDate
 27.09.14                                        *
 10.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpReport_Founder (inStartDate:= '01.08.2014', inEndDate:= '05.08.2014', inAccountId:= 0, inInfoMoneyId:= 0, inInfoMoneyGroupId:= 0, inInfoMoneyDestinationId:= 0, inIsDate:= FALSE, inSession:= '2');
