-- Function: gpReport_Balance()

DROP FUNCTION IF EXISTS gpReport_Balance (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Balance(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (RootName TVarChar, AccountCode Integer, AccountGroupName TVarChar, AccountDirectionName TVarChar, AccountName  TVarChar, 
               AccountOnComplete Boolean, InfoMoneyName TVarChar, InfoMoneyName_Detail TVarChar
             , ByObjectName TVarChar, GoodsName TVarChar
             , AmountDebetStart TFloat, AmountKreditStart TFloat, AmountDebet TFloat, AmountKredit TFloat, AmountDebetEnd TFloat, AmountKreditEnd TFloat
             , CountStart TFloat, CountDebet TFloat, CountKredit TFloat, CountEnd TFloat
              )
AS
$BODY$BEGIN

     -- ïðîâåðêà ïðàâ ïîëüçîâàòåëÿ íà âûçîâ ïðîöåäóðû
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Balance());

     RETURN QUERY 
       SELECT
             CAST (CASE WHEN Object_Account_View.AccountCode >= 70000 THEN 'ÏÀÑÑÈÂÛ' ELSE 'ÀÊÒÈÂÛ' END AS TVarChar) AS RootName

           , Object_Account_View.AccountCode
           , (Object_Account_View.AccountGroupCode||' '||Object_Account_View.AccountGroupName)::TVarChar  AS AccountGroupName
           , (Object_Account_View.AccountDirectionCode||'  '||Object_Account_View.AccountDirectionName)::TVarChar      AS AccountDirectionName
           , (Object_Account_View.AccountCode||'  '||Object_Account_View.AccountName)::TVarChar                     AS AccountName
           , Object_Account_View.onComplete                      AS AccountOnComplete

           --, lfObject_InfoMoney.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
           --, lfObject_InfoMoney_Detail.InfoMoneyCode AS InfoMoneyCode_Detail
           , Object_InfoMoney_View_Detail.InfoMoneyName AS InfoMoneyName_Detail

           --, Object_by.ObjectCode         AS ByObjectCode
           , Object_by.ValueData          AS ByObjectName
           --, Object_Goods.ObjectCode      AS GoodsCode
           , Object_Goods.ValueData       AS GoodsName

           , CAST (CASE WHEN tmpReportOperation.AmountRemainsStart > 0 THEN tmpReportOperation.AmountRemainsStart ELSE 0 END AS TFloat) AS AmountDebetStart
           , CAST (CASE WHEN tmpReportOperation.AmountRemainsStart < 0 THEN -tmpReportOperation.AmountRemainsStart ELSE 0 END AS TFloat) AS AmountKreditStart
           , CAST (tmpReportOperation.AmountDebet AS TFloat) AS AmountDebet
           , CAST (tmpReportOperation.AmountKredit AS TFloat) AS AmountKredit
           , CAST (CASE WHEN tmpReportOperation.AmountRemainsEnd > 0 THEN tmpReportOperation.AmountRemainsEnd ELSE 0 END AS TFloat) AS AmountDebetEnd
           , CAST (CASE WHEN tmpReportOperation.AmountRemainsEnd < 0 THEN -tmpReportOperation.AmountRemainsEnd ELSE 0 END AS TFloat) AS AmountKreditEnd

           , CAST (tmpReportOperation.CountRemainsStart AS TFloat) AS CountStart
           , CAST (tmpReportOperation.CountDebet AS TFloat) AS CountDebet
           , CAST (tmpReportOperation.CountKredit AS TFloat) AS CountKredit
           , CAST (tmpReportOperation.CountRemainsEnd AS TFloat) AS CountEnd
       FROM 
           Object_Account_View 
           LEFT JOIN
           (SELECT tmpMIContainer_Remains.AccountId
                 , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                 , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail
                 , ContainerLinkObject_Member.ObjectId AS MemberId
                 , ContainerLinkObject_Juridical.ObjectId AS JuridicalId
                 , ContainerLinkObject_Unit.ObjectId AS UnitId
                 , ContainerLinkObject_Car.ObjectId  AS CarId
                 , ContainerLinkObject_Goods.ObjectId AS GoodsId

                 , SUM (tmpMIContainer_Remains.AmountRemainsStart) AS AmountRemainsStart
                 , SUM (tmpMIContainer_Remains.AmountDebet) AS AmountDebet
                 , SUM (tmpMIContainer_Remains.AmountKredit) AS AmountKredit
                 , SUM (tmpMIContainer_Remains.AmountRemainsStart + tmpMIContainer_Remains.AmountDebet - tmpMIContainer_Remains.AmountKredit) AS AmountRemainsEnd

                 , SUM (COALESCE (tmpMIContainer_RemainsCount.AmountRemainsStart, 0)) AS CountRemainsStart
                 , SUM (COALESCE (tmpMIContainer_RemainsCount.AmountDebet, 0)) AS CountDebet
                 , SUM (COALESCE (tmpMIContainer_RemainsCount.AmountKredit, 0)) AS CountKredit
                 , SUM (COALESCE (tmpMIContainer_RemainsCount.AmountRemainsStart, 0) + COALESCE (tmpMIContainer_Remains.AmountDebet, 0) - COALESCE (tmpMIContainer_Remains.AmountKredit, 0)) AS CountRemainsEnd
            FROM
                (SELECT Container.ObjectId AS AccountId
                      , Container.Id AS ContainerId
                      , Container.ParentId
                      , COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS AmountDebet
                      , COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) AS AmountKredit
                      , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS AmountRemainsStart
                 FROM Container
                      LEFT JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.Containerid = Container.Id
                                                     AND MIContainer.OperDate >= inStartDate
                 WHERE Container.DescId = zc_Container_Summ()
                 GROUP BY Container.ObjectId
                        , Container.Amount
                        , Container.Id
                        , Container.ParentId
                 HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0) -- AmountRemainsStart <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountDebet <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountKredit <> 0
                ) AS tmpMIContainer_Remains
                LEFT JOIN
                (SELECT Container.Id AS ContainerId
                      , COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS AmountDebet
                      , COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) AS AmountKredit
                      , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS AmountRemainsStart
                 FROM Container
                      LEFT JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.Containerid = Container.Id
                                                     AND MIContainer.OperDate >= inStartDate
                WHERE Container.DescId = zc_Container_Count()
                 GROUP BY Container.ObjectId
                        , Container.Amount
                        , Container.Id
                 HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0) -- AmountRemainsStart <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountDebet <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountKredit <> 0
                ) AS tmpMIContainer_RemainsCount ON tmpMIContainer_RemainsCount.ContainerId = tmpMIContainer_Remains.ParentId
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                              ON ContainerLinkObject_InfoMoney.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                              ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                              ON ContainerLinkObject_Juridical.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Member
                                              ON ContainerLinkObject_Member.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Member.DescId = zc_ContainerLinkObject_Member()
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                              ON ContainerLinkObject_Unit.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                              ON ContainerLinkObject_Car.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                              ON ContainerLinkObject_Goods.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
            GROUP BY tmpMIContainer_Remains.AccountId
                   , ContainerLinkObject_InfoMoney.ObjectId
                   , ContainerLinkObject_InfoMoneyDetail.ObjectId
                   , ContainerLinkObject_Member.ObjectId
                   , ContainerLinkObject_Juridical.ObjectId
                   , ContainerLinkObject_Unit.ObjectId
                   , ContainerLinkObject_Car.ObjectId
                   , ContainerLinkObject_Goods.ObjectId
           ) AS tmpReportOperation ON tmpReportOperation.AccountId = Object_Account_View.AccountId
           LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpReportOperation.InfoMoneyId
           LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View_Detail ON Object_InfoMoney_View_Detail.InfoMoneyId = CASE WHEN COALESCE (tmpReportOperation.InfoMoneyId_Detail, 0) = 0 THEN tmpReportOperation.InfoMoneyId ELSE tmpReportOperation.InfoMoneyId_Detail END
           LEFT JOIN Object AS Object_by ON Object_by.Id = COALESCE (JuridicalId, COALESCE (CarId, COALESCE (MemberId, UnitId)))
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = GoodsId
          ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Balance (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 21.01.14                                        * add CarId
 21.12.13                                        * Personal -> Member
 24.11.13                                        * add AccountCode
 21.10.13                        * add Code
 24.08.13                                        * add count and goods
 11.07.13                                        * add optimize
 08.07.13                                        * add ByObjectName
 08.07.13                                        * add AccountOnComplete
 04.07.13                                        *
*/

-- òåñò
-- SELECT * FROM gpReport_Balance (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inSession:= '2') 