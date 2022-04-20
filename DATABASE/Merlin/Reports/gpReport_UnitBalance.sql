-- Function: gpReport_UnitBalance()

DROP FUNCTION IF EXISTS gpReport_UnitBalance (TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_UnitBalance (TDateTime, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

 /*
 Новый отчет по отделам в разрезе месяц начислений : 
 долг нач, 
 начисления, 
 оплаты, 
 долг конечн, 
 
 в диалоге - группа отд или отд (открывать деревом) + справ статьи + месяц начислений или все месяца
*/

CREATE OR REPLACE FUNCTION gpReport_UnitBalance(
    IN inStartDate    TDateTime , -- 
    IN inEndDate      TDateTime , -- месяц начислений
    IN inServiceDate  TDateTime , -- месяц начислений
    IN inUnitGroupId  Integer,
    IN inInfoMoneyId  Integer,
    IN inisAll        Boolean,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (ServiceDate TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GroupNameFull_Unit TVarChar, ParentName_Unit TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AccountCode Integer, AccountName TVarChar
             , AmountDebetStart TFloat, AmountKreditStart TFloat
             , AmountDebet TFloat, AmountKredit TFloat
             , AmountDebetEnd TFloat, AmountKreditEnd TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbServiceDateId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Balance());
     vbUserId:= lpGetUserBySession (inSession);

     inServiceDate := DATE_TRUNC ('Month', inServiceDate);
     vbServiceDateId := (SELECT lpInsertFind_Object_ServiceDate (inServiceDate));
     

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
   , tmpMIContainer AS (SELECT Container.ObjectId       AS AccountId
                             , Container.WhereObjectId  AS UnitId
                             , CLO_ServiceDate.ObjectId AS ServiceDateId
                             , CLO_InfoMoney.ObjectId   AS InfoMoneyId
                             , COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND (MIContainer.OperDate BETWEEN inStartDate AND inEndDate OR inisAll = TRUE) THEN  MIContainer.Amount ELSE 0 END), 0) AS AmountDebet
                             , COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND (MIContainer.OperDate BETWEEN inStartDate AND inEndDate OR inisAll = TRUE) THEN -MIContainer.Amount ELSE 0 END), 0) AS AmountKredit
                             , Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS AmountRemainsStart
                             , Container.Amount - SUM (CASE WHEN (MIContainer.OperDate > inEndDate AND inisAll = FALSE) THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS AmountRemainsEnd
                        FROM Container
                             LEFT JOIN MovementItemContainer AS MIContainer
                                                             ON MIContainer.Containerid = Container.Id
                                                            AND (MIContainer.OperDate >= inStartDate OR inisAll = TRUE)
                             LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                           ON CLO_InfoMoney.ContainerId = MIContainer.ContainerId
                                                          AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                          
                             LEFT JOIN ContainerLinkObject AS CLO_ServiceDate
                                                           ON CLO_ServiceDate.ContainerId = Container.Id
                                                          AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate()

                        WHERE Container.DescId = zc_Container_Summ()
                          AND Container.WhereObjectId IN (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)
                          AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR inInfoMoneyId = 0)
                          AND (( CLO_ServiceDate.ObjectId = vbServiceDateId AND inisAll = TRUE) OR inisAll = FALSE)
                        GROUP BY Container.ObjectId
                               , Container.Amount
                               , Container.WhereObjectId
                               , CLO_ServiceDate.ObjectId
                               , CLO_InfoMoney.ObjectId 
                        HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND (MIContainer.OperDate BETWEEN inStartDate AND inEndDate OR inisAll = TRUE) THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
                            OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND (MIContainer.OperDate BETWEEN inStartDate AND inEndDate OR inisAll = TRUE) THEN -MIContainer.Amount ELSE 0 END), 0) <> 0)
                            OR Container.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate AND inisAll = FALSE THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) <> 0
                       )


       SELECT Object_ServiceDate.ValueData ::TVarChar AS ServiceDate
            , Object_Unit.Id         AS UnitId
            , Object_Unit.ObjectCode AS UnitCode
            , Object_Unit.ValueData  AS UnitName
            , ObjectString_Unit_GroupNameFull.ValueData AS GroupNameFull_Unit
            , Object_ParentUnit.ValueData               AS ParentName_Unit
             
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
           LEFT JOIN Object AS Object_ServiceDate ON Object_ServiceDate.Id = tmpMIContainer.ServiceDateId

           LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                  ON ObjectString_Unit_GroupNameFull.ObjectId = Object_Unit.Id
                                 AND ObjectString_Unit_GroupNameFull.DescId = zc_ObjectString_Unit_GroupNameFull()

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
           LEFT JOIN Object AS Object_ParentUnit ON Object_ParentUnit.Id = ObjectLink_Unit_Parent.ChildObjectId
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
-- SELECT * FROM gpReport_UnitBalance (inStartDate := '01.12.2021', inEndDate:= '01.02.2022', inServiceDate:= '01.12.2021', inUnitGroupId:= 0, inInfoMoneyId:= 0, inisAll:= true , inSession:= zfCalc_UserAdmin())
