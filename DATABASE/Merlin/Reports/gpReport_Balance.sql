-- Function: gpReport_UnitBalance()

DROP FUNCTION IF EXISTS gpReport_UnitBalance (TDateTime, Integer, Integer, Boolean, TVarChar);

 /*
 Новый отчет по отделам в разрезе месяц начислений : 
 долг нач, 
 начисления, 
 оплаты, 
 долг конечн, 
 
 в диалоге - группа отд или отд (открывать деревом) + справ статьи + месяц начислений или все месяца
*/

CREATE OR REPLACE FUNCTION gpReport_UnitBalance(
    IN inOperDate     TDateTime , -- месяц начислений
    IN inUnitGroupId  Integer,
    IN inInfoMoneyId  Integer,
    IN inisAll        Boolean,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (ServiceDate TDateTime
             , UnitCode Integer, UnitName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AccountCode Integer, AccountName TVarChar
             , AmountDebetStart TFloat, AmountKreditStart TFloat
             , AmountDebet TFloat, AmountKredit TFloat
             , AmountDebetEnd TFloat, AmountKreditEnd TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Balance());
     vbUserId:= lpGetUserBySession (inSession);

     inOperDate := DATE_TRUNC ('Month', inOperDate);
     vbStartDate := DATE_TRUNC ('Month', inOperDate);
     vbEndDate   := DATE_TRUNC ('Month', inOperDate + Interval '1 Month')- interval '1 Day';

     -- Результат
     RETURN QUERY
     WITH
     tmpUnit AS (SELECT lfSelect_Object_Unit_byGroup.UnitId AS UnitId
                 FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                 WHERE inUnitGroupId <> 0
                UNION
                 SELECT Object.Id AS UnitId
                 FROM Object
                 WHERE Object.DescId = zc_Object_Unit()
                   AND Object.isErased = False
                   AND inUnitGroupId = 0
                 )
/*   , tmpMIContainer AS (SELECT Container.ObjectId AS AccountId
                             , Container.WhereObjectId AS UnitId
                             , MIDate_ServiceDate.ValueData ::TDateTime AS ServiceDate
                             , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                             , COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND (MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate OR inisAll = TRUE) THEN  MIContainer.Amount ELSE 0 END), 0) AS AmountDebet
                             , COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND (MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate OR inisAll = TRUE) THEN -MIContainer.Amount ELSE 0 END), 0) AS AmountKredit
                             , Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS AmountRemainsStart
                             , Container.Amount - SUM (CASE WHEN (MIContainer.OperDate > vbEndDate AND inisAll = FALSE) THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS AmountRemainsEnd
                        FROM Container
                             LEFT JOIN MovementItemContainer AS MIContainer
                                                             ON MIContainer.Containerid = Container.Id
                                                            AND (MIContainer.OperDate >= vbStartDate OR inisAll = TRUE)
                             INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                           ON ContainerLinkObject_InfoMoney.ContainerId = MIContainer.ContainerId
                                                          AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                          AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR inInfoMoneyId = 0)

                             INNER JOIN MovementItemDate AS MIDate_ServiceDate
                                                        ON MIDate_ServiceDate.MovementItemId = MIContainer.MovementItemId
                                                       AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                                       AND (MIDate_ServiceDate.ValueData = inOperDate OR inisAll = TRUE)

                        WHERE Container.DescId = zc_Container_Summ()
                        AND Container.WhereObjectId IN (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)
                        GROUP BY Container.ObjectId
                               , Container.Amount
                               , Container.WhereObjectId
                               , MIDate_ServiceDate.ValueData
                               , ContainerLinkObject_InfoMoney.ObjectId 
                        HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
                            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
                            OR Container.Amount - SUM (CASE WHEN MIContainer.OperDate > vbEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) <> 0
                       )
*/

   , tmpMIContainer AS (SELECT Container.ObjectId AS AccountId
                             , Container.WhereObjectId AS UnitId
                             , MIDate_ServiceDate.ValueData ::TDateTime AS ServiceDate
                             , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                             , COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) AS AmountDebet
                             , COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) AS AmountKredit
                             , Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS AmountRemainsStart
                             , Container.Amount - SUM (CASE WHEN (MIContainer.OperDate > vbEndDate AND inisAll = FALSE) THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS AmountRemainsEnd
                        FROM Container
                             LEFT JOIN MovementItemContainer AS MIContainer
                                                             ON MIContainer.Containerid = Container.Id
                                                            AND (MIContainer.OperDate >= vbStartDate OR inisAll = TRUE)
                             INNER JOIN MovementItemDate AS MIDate_ServiceDate
                                                         ON MIDate_ServiceDate.MovementItemId = MIContainer.MovementItemId
                                                        AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                                        AND (MIDate_ServiceDate.ValueData = inOperDate OR inisAll = TRUE)

                             INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                            ON ContainerLinkObject_InfoMoney.ContainerId = MIContainer.ContainerId
                                                           AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                           AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR inInfoMoneyId = 0)

                        WHERE Container.DescId = zc_Container_Summ()
                        AND Container.WhereObjectId IN (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)
                        GROUP BY Container.ObjectId
                               , Container.Amount
                               , Container.WhereObjectId
                               , MIDate_ServiceDate.ValueData
                               , ContainerLinkObject_InfoMoney.ObjectId 
                        HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
                            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
                            OR Container.Amount - SUM (CASE WHEN MIContainer.OperDate > vbEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) <> 0
                       )


       SELECT COALESCE (tmpMIContainer.ServiceDate, vbStartDate) ::TDateTime AS ServiceDate
            , Object_Unit.ObjectCode AS UnitCode
            , Object_Unit.ValueData  AS UnitName
            , Object_InfoMoney.ObjectCode AS InfoMoneyCode
            , Object_InfoMoney.ValueData  AS InfoMoneyName
            , Object_Account.ObjectCode   AS AccountCode
            , Object_Account.ValueData    AS AccountName

            , CAST (CASE WHEN tmpMIContainer.AmountRemainsStart > 0 THEN tmpMIContainer.AmountRemainsStart ELSE 0 END AS TFloat)      AS AmountDebetStart
            , CAST (CASE WHEN tmpMIContainer.AmountRemainsStart < 0 THEN -1 * tmpMIContainer.AmountRemainsStart ELSE 0 END AS TFloat) AS AmountKreditStart
            , CAST (tmpMIContainer.AmountDebet AS TFloat)  AS AmountDebet
            , CAST (tmpMIContainer.AmountKredit AS TFloat) AS AmountKredit
            , CAST (CASE WHEN tmpMIContainer.AmountRemainsEnd > 0 THEN tmpMIContainer.AmountRemainsEnd ELSE 0 END AS TFloat)      AS AmountDebetEnd
            , CAST (CASE WHEN tmpMIContainer.AmountRemainsEnd < 0 THEN -1 * tmpMIContainer.AmountRemainsEnd ELSE 0 END AS TFloat) AS AmountKreditEnd

       FROM tmpMIContainer
           LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMIContainer.InfoMoneyId
           LEFT JOIN Object AS Object_Account ON Object_Account.Id = tmpMIContainer.AccountId
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMIContainer.UnitId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.02.22         *
*/

-- тест
-- SELECT * FROM gpReport_UnitBalance (inOperDate:= '01.12.2021', inUnitGroupId:= 0, inInfoMoneyId:= 0, inisAll:= true , inSession:= zfCalc_UserAdmin())
