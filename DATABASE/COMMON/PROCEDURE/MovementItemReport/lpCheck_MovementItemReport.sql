-- Function: lpCheck_MovementItemReport (TDateTime, TDateTime)

-- DROP FUNCTION lpCheck_MovementItemReport (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION lpCheck_MovementItemReport(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime   --
)
  RETURNS TABLE (MovementId Integer, ContainerId Integer, AccountId Integer, Amount TFloat, Amount_check TFloat)
AS
$BODY$
BEGIN

   RETURN QUERY 
     SELECT _tmpMI.MovementId
          , _tmpMI.ContainerId
          , _tmpMI.AccountId
          , CAST (SUM (_tmpMI.Amount) AS TFloat)       AS Amount
          , CAST (SUM (_tmpMI.Amount_check) AS TFloat) AS Amount_check
     FROM (SELECT _tmp.MovementId
                , _tmp.ContainerId
                , _tmp.AccountId
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
          UNION ALL
           SELECT _tmp.MovementId
                , _tmp.ContainerId
                , _tmp.AccountId
                , 0 AS Amount_A
                , SUM (_tmp.Amount) AS Amount
           FROM (SELECT MIContainer.MovementId
                      , MIContainer.ContainerId
                      , Container.ObjectId AS AccountId
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
          ) AS _tmpMI
     GROUP BY _tmpMI.MovementId
            , _tmpMI.ContainerId
            , _tmpMI.AccountId;


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
-- SELECT * FROM lpCheck_MovementItemReport ('01.01.2013', '31.01.2013') WHERE (Amount <> Amount_check) ORDER BY 2
