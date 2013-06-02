-- Function: gpReport_Balance()

--DROP FUNCTION gpReport_Balance(TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Balance(
IN inStartDate   TDateTime,
IN inEndDate     TDateTime,
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (RootName TVarChar, AccountGroup TVarChar, 
               AccountDirectionName TVarChar, InfoMoneyDestinationName TVarChar, AccountName TVarChar, 
               StartRemains TFloat, MovementSumm TFloat, EndRemains TFloat) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
SELECT
   CAST(AccountPlan.RootName AS TVarChar) AS RootName,
   CAST(AccountPlan.AccountGroup AS TVarChar) AS AccountGroup, 
   CAST(AccountPlan.AccountDirectionName AS TVarChar) AS AccountDirectionName,
   CAST(AccountPlan.InfoMoneyDestinationName AS TVarChar) AS InfoMoneyDestinationName, 
   OBJECT.ValueData AS AccountName,
   CAST(Report.StartRemains AS TFloat) AS StartRemains,
   CAST(Report.OperSumm AS TFloat) AS OperSumm,
   CAST(Report.EndRemains AS TFloat) AS EndRemains
FROM 
(SELECT SUM(Report.Remains) AS EndRemains, SUM(Report.OperSumm) AS OperSumm, SUM(Report.Remains - Report.OperSumm) AS StartRemains, Report.AccountId
FROM (SELECT Container.Amount - COALESCE(SUM(movementitemcontainer.Amount), 0) AS Remains,
            COALESCE(SUM(Oper.amount), 0) AS OperSumm,
            Container.AccountId
      FROM Container 
LEFT JOIN movementitemcontainer ON movementitemcontainer.Containerid = container.id
   AND movementitemcontainer.operdate > inEndDate
LEFT JOIN movementitemcontainer AS Oper ON Oper.Containerid = container.id
   AND Oper.operdate BETWEEN inStartDate AND inEndDate
WHERE Container.DescId = zc_Container_Summ()
     GROUP BY Container.AccountId, Container.Id
     HAVING (Container.Amount - COALESCE(SUM(movementitemcontainer.Amount), 0) <> 0) OR (COALESCE(SUM(Oper.amount), 0) <> 0)) AS Report

GROUP BY Report.AccountId) AS Report
JOIN OBJECT 
 ON OBJECT.Id = Report.AccountId,
 (SELECT 'Активы' RootName, 'Запасы' AccountGroup, 'на складахГП' AccountDirectionName, 'Мясное сырье' InfoMoneyDestinationName, 4001 AS ID
UNION SELECT 'Пассивы' RootName, 'Кредиторы' AccountGroup, 'поставщики' AccountDirectionName, 'Мясное сырье' InfoMoneyDestinationName, 4002 AS ID) AS AccountPlan
WHERE AccountPlan.Id = Report.AccountID;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpReport_Balance(TDateTime, TDateTime, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpReport_Balance('2')