-- Function: gpReport_Partner

DROP FUNCTION IF EXISTS gpReport_Partner (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Partner(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inPartnerId          Integer,    -- Постащик
    IN inInfoMoneyId        Integer,    -- Управленческая статья
    IN inAccountId          Integer,    -- счет
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AccountName_all TVarChar
             , StartAmount TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , EndAmount TFloat, EndAmountD TFloat, EndAmountK TFloat
             , ContainerId Integer
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMemberId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
     WITH
     tmpPartner AS(SELECT Object.Id
                    FROM Object
                    WHERE Object.DescId = zc_Object_Partner()
                    AND (Object.Id = inPartnerId OR inPartnerId = 0)
                    )

   , tmpContainer AS (SELECT CLO_Partner.ContainerId          AS ContainerId
                           , Container.ObjectId               AS AccountId
                           , Container.Amount
                           , CLO_Partner.ObjectId             AS PartnerId
                           , CLO_InfoMoney.ObjectId           AS InfoMoneyId
                      FROM ContainerLinkObject AS CLO_Partner

                           LEFT JOIN Container ON Container.Id = CLO_Partner.ContainerId AND Container.DescId = zc_Container_Summ()

                           LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                         ON CLO_InfoMoney.ContainerId = Container.Id
                                                        AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()

                      WHERE CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                        AND CLO_Partner.ObjectId  IN (SELECT tmpPartner.Id FROM tmpPartner)
                        AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR inInfoMoneyId = 0)
                        AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                      )

   , tmpMIContainer AS (SELECT MIContainer.*
                        FROM tmpContainer
                             INNER JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.Containerid = tmpContainer.ContainerId
                                                             AND MIContainer.OperDate >= inStartDate
                       )

    , tmpOperation AS (SELECT tmpContainer.AccountId
                            , tmpContainer.PartnerId
                            , tmpContainer.InfoMoneyId
                            , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)                                                                                   AS StartAmount
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId NOT IN (zc_Movement_Income(), zc_Movement_ProductionUnion()) THEN  1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS DebetSumm
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId     IN (zc_Movement_Income(), zc_Movement_ProductionUnion()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS KreditSumm
                            , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)                        AS EndAmount
                            , tmpContainer.ContainerId
                       FROM tmpContainer
                            LEFT JOIN tmpMIContainer AS MIContainer
                                                     ON MIContainer.ContainerId = tmpContainer.ContainerId
                       GROUP BY tmpContainer.ContainerId
                              , tmpContainer.AccountId
                              , tmpContainer.PartnerId
                              , tmpContainer.InfoMoneyId
                              , tmpContainer.Amount
                              , tmpContainer.ContainerId
                       HAVING 0 <> tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)
                           OR 0 <> SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                           OR 0 <> SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)
                           OR 0 <> tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)
                     )
     SELECT
            Object_Partner.Id         AS PartnerId
          , Object_Partner.ObjectCode AS PartnerCode
          , Object_Partner.ValueData  AS PartnerName
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , Object_Account_View.AccountName_all
            --
          , (-1 * tmpOperation.StartAmount) :: TFloat AS StartAmount
          , CASE WHEN tmpOperation.StartAmount > 0 THEN  1 * tmpOperation.StartAmount ELSE 0 END :: TFloat AS StartAmountD
          , CASE WHEN tmpOperation.StartAmount < 0 THEN -1 * tmpOperation.StartAmount ELSE 0 END :: TFloat AS StartAmountK
            --
          , tmpOperation.DebetSumm          :: TFloat AS DebetSumm
          , tmpOperation.KreditSumm         :: TFloat AS KreditSumm
            --
          , (-1 * tmpOperation.EndAmount)   :: TFloat AS EndAmount
          , CASE WHEN tmpOperation.EndAmount > 0 THEN  1 * tmpOperation.EndAmount ELSE 0 END :: TFloat AS EndAmountD
          , CASE WHEN tmpOperation.EndAmount < 0 THEN -1 * tmpOperation.EndAmount ELSE 0 END :: TFloat AS EndAmountD
            --
          , tmpOperation.ContainerId        :: Integer AS ContainerId

   FROM tmpOperation
          LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpOperation.AccountId
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpOperation.InfoMoneyId
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperation.PartnerId

   WHERE (tmpOperation.StartAmount <> 0
       OR tmpOperation.EndAmount   <> 0
       OR tmpOperation.DebetSumm   <> 0
       OR tmpOperation.KreditSumm  <> 0
         )
  ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.07.23         *
*/

-- тест
-- SELECT * FROM gpReport_Partner(inStartDate := ('01.01.2019')::TDateTime , inEndDate := ('01.01.2023')::TDateTime , inPartnerId := 0, inInfoMoneyId := 0  , inAccountId:=0 ,  inSession := '5');
