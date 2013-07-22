-- Function: gpReport_Balance()

-- DROP FUNCTION gpReport_Balance (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Balance(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (RootName TVarChar, AccountGroupCode Integer, AccountGroupName TVarChar, AccountDirectionCode Integer, AccountDirectionName TVarChar, AccountCode Integer, AccountName  TVarChar, AccountOnComplete Boolean
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyCode_Detail Integer, InfoMoneyName_Detail TVarChar
             , ByObjectCode Integer, ByObjectName TVarChar
             , AmountDebetStart TFloat, AmountKreditStart TFloat, AmountDebet TFloat, AmountKredit TFloat, AmountDebetEnd TFloat, AmountKreditEnd TFloat
              )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Balance());

     RETURN QUERY 
       SELECT
             CAST (CASE WHEN lfObject_Account.AccountCode >= 70000 THEN 'ПАССИВЫ' ELSE 'АКТИВЫ' END AS TVarChar) AS RootName

           , lfObject_Account.AccountGroupCode                AS AccountGroupCode
           , lfObject_Account.AccountGroupName                AS AccountGroupName
           , lfObject_Account.AccountDirectionCode            AS AccountDirectionCode
           , lfObject_Account.AccountDirectionName            AS AccountDirectionName
           , lfObject_Account.AccountCode                     AS AccountCode
           , lfObject_Account.AccountName                     AS AccountName
           , lfObject_Account.onComplete                      AS AccountOnComplete

           , lfObject_InfoMoney.InfoMoneyCode
           , lfObject_InfoMoney.InfoMoneyName
           , lfObject_InfoMoney_Detail.InfoMoneyCode AS InfoMoneyCode_Detail
           , lfObject_InfoMoney_Detail.InfoMoneyName AS InfoMoneyName_Detail

           , Object_by.ObjectCode         AS ByObjectCode
           , Object_by.ValueData          AS ByObjectName

           , CAST (CASE WHEN tmpReportOperation.AmountRemainsStart > 0 THEN tmpReportOperation.AmountRemainsStart ELSE 0 END AS TFloat) AS AmountDebetStart
           , CAST (CASE WHEN tmpReportOperation.AmountRemainsStart < 0 THEN -tmpReportOperation.AmountRemainsStart ELSE 0 END AS TFloat) AS AmountKreditStart
           , CAST (tmpReportOperation.AmountDebet AS TFloat) AS AmountDebet
           , CAST (tmpReportOperation.AmountKredit AS TFloat) AS AmountKredit
           , CAST (CASE WHEN tmpReportOperation.AmountRemainsEnd > 0 THEN tmpReportOperation.AmountRemainsEnd ELSE 0 END AS TFloat) AS AmountDebetEnd
           , CAST (CASE WHEN tmpReportOperation.AmountRemainsEnd < 0 THEN -tmpReportOperation.AmountRemainsEnd ELSE 0 END AS TFloat) AS AmountKreditEnd
       FROM 
           lfSelect_Object_Account() AS lfObject_Account
           LEFT JOIN
           (SELECT tmpMIContainer_Remains.AccountId
                 , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                 , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail
                 , ContainerLinkObject_Personal.ObjectId AS PersonalId
                 , ContainerLinkObject_Juridical.ObjectId AS JuridicalId
                 , ContainerLinkObject_Unit.ObjectId AS UnitId
                 , SUM (tmpMIContainer_Remains.AmountRemainsStart) AS AmountRemainsStart
                 , SUM (tmpMIContainer_Remains.AmountDebet) AS AmountDebet
                 , SUM (tmpMIContainer_Remains.AmountKredit) AS AmountKredit
                 , SUM (tmpMIContainer_Remains.AmountRemainsStart + tmpMIContainer_Remains.AmountDebet - tmpMIContainer_Remains.AmountKredit) AS AmountRemainsEnd
            FROM
                (SELECT Container.ObjectId AS AccountId
                      , Container.Id AS ContainerId
                      , COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS AmountDebet
                      , COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) AS AmountKredit
                      , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS AmountRemainsStart
                      /*, COALESCE (SUM (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) <> zc_Enum_AccountKind_Passive() THEN MIContainer_byPeriod.Amount ELSE 0 END), 0) AS AmountDebet
                      , COALESCE (SUM (CASE WHEN COALESCE (ObjectLink_AccountKind.ChildObjectId, 0) = zc_Enum_AccountKind_Passive() THEN -MIContainer_byPeriod.Amount ELSE 0 END), 0) AS AmountKredit
                      , Container.Amount - COALESCE (SUM (MIContainer_byEndDate.Amount), 0) AS AmountRemainsEnd*/
                 FROM Container
                      LEFT JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.Containerid = Container.Id
                                                     AND MIContainer.OperDate >= inStartDate
                      /*LEFT JOIN MovementItemContainer AS MIContainer_byEndDate
                                                      ON MIContainer_byEndDate.Containerid = Container.Id
                                                     AND MIContainer_byEndDate.OperDate > inEndDate
                      LEFT JOIN MovementItemContainer AS MIContainer_byPeriod
                                                      ON MIContainer_byPeriod.Containerid = Container.Id
                                                     AND MIContainer_byPeriod.OperDate BETWEEN inStartDate AND inEndDate*/
                 WHERE Container.DescId = zc_Container_Summ()
                 GROUP BY Container.ObjectId
                        , Container.Amount
                        , Container.Id
                 HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0) -- AmountRemainsStart <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountDebet <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountKredit <> 0
                 /*HAVING (Container.Amount - COALESCE (SUM (MIContainer_byEndDate.Amount), 0) <> 0) -- AmountRemainsEnd <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer_byPeriod.Amount > 0 THEN MIContainer_byPeriod.Amount ELSE 0 END), 0) <> 0) -- AmountDebet <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer_byPeriod.Amount < 0 THEN -MIContainer_byPeriod.Amount ELSE 0 END), 0) <> 0) -- AmountKredit <> 0*/
                ) AS tmpMIContainer_Remains
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                              ON ContainerLinkObject_InfoMoney.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                              ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                              ON ContainerLinkObject_Juridical.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                             AND 1=1
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal
                                              ON ContainerLinkObject_Personal.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Personal.DescId = zc_ContainerLinkObject_Personal()
                                             AND 1=1
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                              ON ContainerLinkObject_Unit.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                             AND 1=1
            GROUP BY tmpMIContainer_Remains.AccountId
                   , ContainerLinkObject_InfoMoney.ObjectId
                   , ContainerLinkObject_InfoMoneyDetail.ObjectId
                   , ContainerLinkObject_Personal.ObjectId
                   , ContainerLinkObject_Juridical.ObjectId
                   , ContainerLinkObject_Unit.ObjectId
           ) AS tmpReportOperation ON tmpReportOperation.AccountId = lfObject_Account.AccountId
           LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = tmpReportOperation.InfoMoneyId
           LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney_Detail ON lfObject_InfoMoney_Detail.InfoMoneyId = CASE WHEN COALESCE (tmpReportOperation.InfoMoneyId_Detail, 0) = 0 THEN tmpReportOperation.InfoMoneyId ELSE tmpReportOperation.InfoMoneyId_Detail END
           LEFT JOIN Object AS Object_by ON Object_by.Id = COALESCE (JuridicalId, COALESCE (PersonalId, UnitId))
          ;
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Balance (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.13                                        * add optimize
 08.07.13                                        * add ByObjectName
 08.07.13                                        * add AccountOnComplete
 04.07.13                                        *
*/

-- тест
-- SELECT * FROM gpReport_Balance (inStartDate:= '01.01.2013', inEndDate:= '01.01.2013', inSession:= '2')
