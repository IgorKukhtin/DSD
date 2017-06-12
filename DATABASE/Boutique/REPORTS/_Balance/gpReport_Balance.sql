-- Function: gpReport_Balance()

DROP FUNCTION IF EXISTS gpReport_Balance (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Balance(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (RootName TVarChar, AccountCode Integer, AccountGroupName TVarChar, AccountDirectionName TVarChar, AccountName  TVarChar
             , AccountGroupName_original TVarChar, AccountDirectionName_original TVarChar, AccountName_original  TVarChar
             , InfoMoneyName TVarChar
             , ByObjectItemName TVarChar, ByObjectName TVarChar
             , AmountDebetStart TFloat, AmountKreditStart TFloat, AmountDebet TFloat, AmountKredit TFloat, AmountDebetEnd TFloat, AmountKreditEnd TFloat
             , AmountActiveStart TFloat, AmountPassiveStart TFloat, AmountActiveEnd TFloat, AmountPassiveEnd TFloat
             , CountStart TFloat, CountDebet TFloat, CountKredit TFloat, CountEnd TFloat
             , ContainerId Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Balance());
     vbUserId:= lpGetUserBySession (inSession);



     -- ���������
     RETURN QUERY
       SELECT
             CAST (CASE WHEN Object_Account_View.AccountCode >= 60000 THEN '�������' ELSE '������' END AS TVarChar) AS RootName

           , Object_Account_View.AccountCode
           , Object_Account_View.AccountGroupName
           , Object_Account_View.AccountDirectionName
           , Object_Account_View.AccountName
           --��� �������� ����� ��� ����
           , Object_Account_View.AccountGroupName_original
           , Object_Account_View.AccountDirectionName_original
           , Object_Account_View.AccountName_original


           , Object_InfoMoney_View.InfoMoneyName

           , ObjectDesc_by.ItemName    AS ByObjectItemName
           , Object_by.ValueData       AS ByObjectName

           , CAST (CASE WHEN tmpReportOperation.AmountRemainsStart > 0 THEN tmpReportOperation.AmountRemainsStart ELSE 0 END AS TFloat) AS AmountDebetStart
           , CAST (CASE WHEN tmpReportOperation.AmountRemainsStart < 0 THEN -1 * tmpReportOperation.AmountRemainsStart ELSE 0 END AS TFloat) AS AmountKreditStart
           , CAST (tmpReportOperation.AmountDebet AS TFloat) AS AmountDebet
           , CAST (tmpReportOperation.AmountKredit AS TFloat) AS AmountKredit
           , CAST (CASE WHEN tmpReportOperation.AmountRemainsEnd > 0 THEN tmpReportOperation.AmountRemainsEnd ELSE 0 END AS TFloat) AS AmountDebetEnd
           , CAST (CASE WHEN tmpReportOperation.AmountRemainsEnd < 0 THEN -1 * tmpReportOperation.AmountRemainsEnd ELSE 0 END AS TFloat) AS AmountKreditEnd

           , CAST (CASE WHEN COALESCE (Object_Account_View.AccountKindId, 0) IN (0, zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_All())
                             THEN tmpReportOperation.AmountRemainsStart
                        ELSE 0
                   END AS TFloat) AS AmountActiveStart
           , CAST (CASE WHEN Object_Account_View.AccountKindId = zc_Enum_AccountKind_Passive()
                             THEN -1 * tmpReportOperation.AmountRemainsStart
                        ELSE 0
                   END AS TFloat) AS AmountPassiveStart
           , CAST (CASE WHEN COALESCE (Object_Account_View.AccountKindId, 0) IN (0, zc_Enum_AccountKind_Active(), zc_Enum_AccountKind_All())
                             THEN tmpReportOperation.AmountRemainsEnd
                        ELSE 0
                   END AS TFloat) AS AmountActiveEnd
           , CAST (CASE WHEN Object_Account_View.AccountKindId = zc_Enum_AccountKind_Passive()
                             THEN -1 * tmpReportOperation.AmountRemainsEnd
                        ELSE 0
                   END AS TFloat) AS AmountPassiveEnd

           , CAST (tmpReportOperation.CountRemainsStart AS TFloat) AS CountStart
           , CAST (tmpReportOperation.CountDebet AS TFloat) AS CountDebet
           , CAST (tmpReportOperation.CountKredit AS TFloat) AS CountKredit
           , CAST (tmpReportOperation.CountRemainsEnd AS TFloat) AS CountEnd

           , tmpReportOperation.ContainerId :: Integer AS ContainerId

       FROM Object_Account_View

            LEFT JOIN (SELECT tmpReportOperation_two.AccountId
                            , tmpReportOperation_two.InfoMoneyId
                            , tmpReportOperation_two.AmountRemainsStart
                            , tmpReportOperation_two.AmountDebet
                            , tmpReportOperation_two.AmountKredit
                            , tmpReportOperation_two.AmountRemainsEnd
           
                            , tmpReportOperation_two.CountRemainsStart
                            , tmpReportOperation_two.CountDebet
                            , tmpReportOperation_two.CountKredit
                            , tmpReportOperation_two.CountRemainsEnd
           
                            , tmpReportOperation_two.ContainerId
                       FROM (SELECT tmpMIContainer_Remains.AccountId
                                  , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                 
                                  , SUM (tmpMIContainer_Remains.AmountRemainsStart) AS AmountRemainsStart
                                  , SUM (tmpMIContainer_Remains.AmountDebet) AS AmountDebet
                                  , SUM (tmpMIContainer_Remains.AmountKredit) AS AmountKredit
                                  , SUM (tmpMIContainer_Remains.AmountRemainsStart + tmpMIContainer_Remains.AmountDebet - tmpMIContainer_Remains.AmountKredit) AS AmountRemainsEnd
                 
                                  , 0 AS CountRemainsStart -- SUM (COALESCE (tmpMIContainer_RemainsCount.AmountRemainsStart, 0)) AS CountRemainsStart
                                  , 0 AS CountDebet -- SUM (COALESCE (tmpMIContainer_RemainsCount.AmountDebet, 0)) AS CountDebet
                                  , 0 AS CountKredit -- SUM (COALESCE (tmpMIContainer_RemainsCount.AmountKredit, 0)) AS CountKredit
                                  , 0 AS CountRemainsEnd -- SUM (COALESCE (tmpMIContainer_RemainsCount.AmountRemainsStart, 0) + COALESCE (tmpMIContainer_Remains.AmountDebet, 0) - COALESCE (tmpMIContainer_Remains.AmountKredit, 0)) AS CountRemainsEnd
                 
                                  , MAX (tmpMIContainer_Remains.ContainerId) AS ContainerId
                 
                             FROM (SELECT Container.ObjectId AS AccountId
                                        , Container.Id       AS ContainerId
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
                                          -- , Container.ParentId
                                   HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0) -- AmountRemainsStart <> 0
                                       OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountDebet <> 0
                                       OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountKredit <> 0
                                  ) AS tmpMIContainer_Remains
                                  LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                ON ContainerLinkObject_InfoMoney.ContainerId = tmpMIContainer_Remains.ContainerId
                                                               AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                 
                             GROUP BY tmpMIContainer_Remains.AccountId
                                    , ContainerLinkObject_InfoMoney.ObjectId
                 
                            ) AS tmpReportOperation_two
           
                      ) AS tmpReportOperation ON tmpReportOperation.AccountId = Object_Account_View.AccountId

           LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpReportOperation.InfoMoneyId
           LEFT JOIN Object AS Object_by ON Object_by.Id = NULL
           LEFT JOIN ObjectDesc AS ObjectDesc_by    ON ObjectDesc_by.Id    = Object_by.DescId
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Balance (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.06.17                                        *
*/

-- ����
-- SELECT * FROM gpReport_Balance (inStartDate:= '01.08.2016', inEndDate:= '31.08.2016', inSession:= zfCalc_UserAdmin())
