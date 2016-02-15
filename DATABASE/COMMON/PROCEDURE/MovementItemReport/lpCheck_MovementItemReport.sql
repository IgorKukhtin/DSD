-- Function: lpCheck_MovementItemReport (TDateTime, TDateTime)

DROP FUNCTION IF EXISTS lpCheck_MovementItemReport (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION lpCheck_MovementItemReport(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime   --
)
  RETURNS TABLE (MovementId Integer, ContainerId Integer, AccountId Integer, OperDate TDateTime, Amount TFloat, Amount_check TFloat)
AS
$BODY$
BEGIN

   RETURN QUERY 
     SELECT _tmpMI.MovementId
          , _tmpMI.ContainerId
          , _tmpMI.AccountId
          , _tmpMI.OperDate
          , CAST (SUM (_tmpMI.Amount) AS TFloat)       AS Amount
          , CAST (SUM (_tmpMI.Amount_check) AS TFloat) AS Amount_check
     FROM (SELECT _tmp.MovementId
                , _tmp.ContainerId
                , _tmp.AccountId
                , _tmp.OperDate
                , SUM (_tmp.Amount) AS Amount
                , 0 AS Amount_check
           FROM (SELECT MIReport.MovementId
                        -- это вариант 1, но !!!нужен еще union!!!
                      /*, MIReport.ActiveContainerId AS ContainerId_A
                      , MIReport.Amount AS Amount_A
                      , MIReport.PassiveContainerId  AS ContainerId_P
                      , MIReport.Amount AS Amount_P*/
                        -- это вариант 2
                      , ReportContainerLink.ContainerId
                      , ReportContainerLink.AccountId
                      , MIReport.OperDate
                      , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active()  THEN MIReport.Amount
                             WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive() THEN -1 * MIReport.Amount 
                             ELSE 0
                        END AS Amount
                        -- это вариант 3
                      /*, ReportContainerLink.ContainerId
                      , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active()  THEN MIReport.Amount
                             WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive() THEN -1 * MIReport.Amount 
                             ELSE 0
                        END AS Amount*/

                 FROM MovementItemReport AS MIReport
                      -- это вариант 2
                      JOIN ReportContainerLink ON ReportContainerLink.ReportContainerId = MIReport.ReportContainerId
                      -- это вариант 3
                      -- JOIN ChildReportContainerLink AS ReportContainerLink ON ReportContainerLink.ChildReportContainerId = MIReport.ChildReportContainerId
                      --                                                     AND ReportContainerLink.AccountKindId <> zc_Enum_AccountKind_All()
                 WHERE MIReport.OperDate BETWEEN inStartDate AND inEndDate
                   -- AND MIReport.Amount <> 0
                ) AS _tmp
           GROUP BY _tmp.MovementId
                  , _tmp.ContainerId
                  , _tmp.AccountId
                  , _tmp.OperDate
          UNION ALL
           SELECT _tmp.MovementId
                , _tmp.ContainerId
                , _tmp.AccountId
                , _tmp.OperDate
                , 0 AS Amount
                , SUM (_tmp.Amount) AS Amount_check
           FROM (SELECT MIContainer.MovementId
                      , MIContainer.ContainerId
                      , Container.ObjectId AS AccountId
                      , MIContainer.OperDate
                      , MIContainer.Amount
                 FROM MovementItemContainer AS MIContainer
                      LEFT JOIN Container ON Container.Id = MIContainer.ContainerId
                 WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                   AND MIContainer.DescId = zc_MIContainer_Summ()
                   -- AND MIContainer.Amount <> 0
                ) AS _tmp
           GROUP BY _tmp.MovementId
                  , _tmp.ContainerId
                  , _tmp.AccountId
                  , _tmp.OperDate
          ) AS _tmpMI
     GROUP BY _tmpMI.MovementId
            , _tmpMI.ContainerId
            , _tmpMI.AccountId
            , _tmpMI.OperDate;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheck_MovementItemReport (TDateTime, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.13                                        *
*/

-- тест
-- SELECT * FROM lpCheck_MovementItemReport ('01.10.2013', '31.10.2013') WHERE (Amount <> Amount_check) ORDER BY 2
-- SELECT * FROM lpCheck_MovementItemReport ('31.07.2014', '31.07.2014') WHERE (Amount <> Amount_check) ORDER BY 2
-- SELECT * FROM lpCheck_MovementItemReport ('01.07.2015', '31.07.2015') WHERE (Amount <> Amount_check) ORDER BY 2
-- SELECT * FROM lpCheck_MovementItemReport ('01.02.2016', '01.02.2016') WHERE (Amount <> Amount_check) ORDER BY 2
