-- Function: gpReport_Personal

DROP FUNCTION IF EXISTS gpReport_Personal (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Personal(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inServiceDate      TDateTime , --
    IN inIsServiceDate    Boolean , --
    IN inInfoMoneyId      Integer,    -- Управленческая статья
    IN inPersonalId       Integer,    -- Фио сотрудника
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AccountName_all TVarChar
             , ServiceDate TDateTime
             , StartAmount TFloat--, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , EndAmount TFloat--, EndAmountD TFloat, EndAmountK TFloat
              )             
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMemberId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

      -- !!! округление !!!
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- Результат
     RETURN QUERY
     WITH
     tmpPersonal AS(SELECT Object.Id
                     FROM Object
                     WHERE Object.DescId = zc_Object_Personal()
                     AND (Object.Id = inPersonalId OR inPersonalId = 0)
                     )

   , tmpContainer AS (SELECT CLO_Personal.ContainerId         AS ContainerId
                           , Container.ObjectId               AS AccountId
                           , Container.Amount
                           , CLO_Personal.ObjectId            AS PersonalId
                           , CLO_InfoMoney.ObjectId           AS InfoMoneyId
                           , ObjectDate_Service.ValueData     AS ServiceDate

                      FROM ContainerLinkObject AS CLO_Personal

                           LEFT JOIN Container ON Container.Id = CLO_Personal.ContainerId AND Container.DescId = zc_Container_Summ()
                           
                           LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                          ON CLO_InfoMoney.ContainerId = Container.Id
                                                         AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()

                           LEFT JOIN ContainerLinkObject AS CLO_ServiceDate
                                                         ON CLO_ServiceDate.ContainerId = CLO_Personal.ContainerId
                                                        AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate()

                           LEFT JOIN ObjectDate AS ObjectDate_Service
                                                ON ObjectDate_Service.ObjectId = CLO_ServiceDate.ObjectId
                                               AND ObjectDate_Service.DescId = zc_ObjectDate_ServiceDate_Value()
                      WHERE CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                        AND CLO_Personal.ObjectId  IN (SELECT tmpPersonal.Id FROM tmpPersonal)
                        AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR inInfoMoneyId = 0)
                        AND (ObjectDate_Service.ValueData = inServiceDate OR inIsServiceDate = FALSE)
                      )

   , tmpMIContainer AS (SELECT MIContainer.*
                        FROM tmpContainer
                             INNER JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.Containerid = tmpContainer.ContainerId
                                                             AND MIContainer.OperDate >= inStartDate
                       )

    , tmpOperation AS (SELECT tmpContainer.AccountId
                            , tmpContainer.PersonalId
                            , tmpContainer.InfoMoneyId
                            , tmpContainer.ServiceDate
                            , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)                                                                                                   AS StartAmount
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)          AS DebetSumm
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)     AS KreditSumm
                            , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)                        AS EndAmount
                       FROM tmpContainer
                            LEFT JOIN tmpMIContainer AS MIContainer
                                                     ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                   -- AND MIContainer.OperDate >= inStartDate


                       GROUP BY tmpContainer.ContainerId
                              , tmpContainer.AccountId
                              , tmpContainer.PersonalId
                              , tmpContainer.InfoMoneyId
                              , tmpContainer.ServiceDate
                              , tmpContainer.Amount
                       HAVING 0 <> tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)
                           OR 0 <> SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                           OR 0 <> SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)
                           OR 0 <> tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)
                     )
     SELECT
            View_Personal.PersonalId
          , View_Personal.PersonalCode
          , View_Personal.PersonalName
          , View_Personal.PositionCode
          , View_Personal.PositionName
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , Object_Account_View.AccountName_all
          , tmpOperation.ServiceDate
          , (-1 * tmpOperation.StartAmount) :: TFloat  AS StartAmount
          , tmpOperation.DebetSumm          :: TFloat  AS DebetSumm
          , tmpOperation.KreditSumm         :: TFloat  AS KreditSumm
          , tmpOperation.EndAmount          :: TFloat  AS EndAmount
     FROM tmpOperation

          LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpOperation.AccountId
          LEFT JOIN  Object_Personal_View AS View_Personal ON View_Personal.PersonalId = tmpOperation.PersonalId
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpOperation.InfoMoneyId

     WHERE (tmpOperation.StartAmount <> 0
         OR tmpOperation.EndAmount   <> 0
         OR tmpOperation.DebetSumm   <> 0
         OR tmpOperation.KreditSumm  <> 0)
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.23         *
*/

-- тест
-- SELECT * FROM gpReport_Personal(inStartDate := ('01.01.2019')::TDateTime , inEndDate := ('01.01.2023')::TDateTime , inServiceDate := ('01.01.2019')::TDateTime , inisServiceDate := 'False' , inInfoMoneyId := 0 , inPersonalId := 0 ,  inSession := '5');
