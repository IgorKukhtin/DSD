-- Function: gpReport_CashBalance()

DROP FUNCTION IF EXISTS gpReport_CashBalance (TDateTime, TDateTime, Integer, Integer,  TVarChar);


CREATE OR REPLACE FUNCTION gpReport_CashBalance(
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , -- месяц начислений
    IN inCashGroupId  Integer,
    IN inInfoMoneyId  Integer,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (CashCode Integer, CashName TVarChar
             , GroupNameFull_Cash TVarChar, ParentName_Cash TVarChar
             , NPP TFloat
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , MovementDescName TVarChar
             , AccountCode Integer, AccountName TVarChar 
             , CurrencyName TVarChar
             , AmountDebetStart TFloat, AmountKreditStart TFloat
             , AmountDebet TFloat, AmountKredit TFloat
             , AmountDebetEnd TFloat, AmountKreditEnd TFloat
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUser_isAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Balance());
     vbUserId:= lpGetUserBySession (inSession);

     --
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

     -- Результат
     RETURN QUERY
     WITH
     tmpCash AS (SELECT lfSelect.CashId AS CashId
                 FROM lfSelect_Object_Cash_byGroup (inCashGroupId) AS lfSelect
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                              ON ObjectBoolean_UserAll.ObjectId = lfSelect.CashId
                                             AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_Cash_UserAll()
                 WHERE inCashGroupId <> 0
                   AND (vbUser_isAll = TRUE OR ObjectBoolean_UserAll.ValueData = TRUE)

                UNION
                 SELECT Object.Id AS CashId
                 FROM Object
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                              ON ObjectBoolean_UserAll.ObjectId = Object.Id
                                             AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_Cash_UserAll()
                 WHERE Object.DescId = zc_Object_Cash()
                   AND Object.isErased = FALSE
                   AND COALESCE (inCashGroupId, 0) = 0
                   AND (vbUser_isAll = TRUE OR ObjectBoolean_UserAll.ValueData = TRUE)
                 )     

   , tmpInfoMoney AS (SELECT lfSelect_Object_InfoMoney_byGroup.InfoMoneyId AS InfoMoneyId
                      FROM lfSelect_Object_InfoMoney_byGroup (inInfoMoneyId) AS lfSelect_Object_InfoMoney_byGroup
                      WHERE inInfoMoneyId <> 0
                     UNION
                      SELECT Object.Id AS InfoMoneyId 
                      FROM Object
                      WHERE Object.DescId = zc_Object_InfoMoney()
                        AND Object.isErased = False
                        AND inInfoMoneyId = 0
                      )

   , tmpMIContainer_all AS (SELECT Container.Id             AS ContainerId
                                 , Container.ObjectId       AS AccountId
                                 , Container.Amount         AS Amount
                                 , CLO_Cash.ObjectId        AS CashId
                                 , CASE WHEN MIContainer.MovementDescId = zc_Movement_CashSend() THEN MIContainer.ObjectIntId_analyzer ELSE MILO_InfoMoney.ObjectId END AS InfoMoneyId 
                                 , MIContainer.MovementDescId
                                 
                                 , COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND (MIContainer.OperDate BETWEEN inStartDate AND inEndDate) THEN  1 * MIContainer.Amount ELSE 0 END), 0) AS AmountDebet
                                 , COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND (MIContainer.OperDate BETWEEN inStartDate AND inEndDate) THEN -1 * MIContainer.Amount ELSE 0 END), 0) AS AmountKredit
                                 , SUM (CASE WHEN (MIContainer.OperDate > inEndDate) THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Amount_summ                                                       

                            FROM Container
                                 INNER JOIN ContainerLinkObject AS CLO_Cash
                                                                ON CLO_Cash.ContainerId = Container.Id
                                                               AND CLO_Cash.DescId      = zc_ContainerLinkObject_Cash()
                                                               AND CLO_Cash.ObjectId IN (SELECT DISTINCT tmpCash.CashId FROM tmpCash)
                                 LEFT JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.Containerid = Container.Id
                                                                AND MIContainer.OperDate    >= inStartDate
                                 LEFT JOIN MovementItemLinkObject AS MILO_InfoMoney
                                                                  ON MILO_InfoMoney.MovementItemId = MIContainer.MovementItemId
                                                                 AND MILO_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                            WHERE Container.DescId = zc_Container_Summ()
                            --AND (CLO_InfoMoney.ObjectId IN (SELECT tmp.InfoMoneyId FROM tmpInfoMoney AS tmp) OR inInfoMoneyId = 0)
                            GROUP BY Container.Id
                                   , Container.ObjectId
                                   , Container.Amount
                                   , CLO_Cash.ObjectId  
                                   , MILO_InfoMoney.ObjectId
                                   , MIContainer.ObjectIntId_analyzer
                                   , MIContainer.MovementDescId
                                   
                           )

   , tmpMIContainer_rem AS (SELECT tmpMIContainer_all.ContainerId
                                 , tmpMIContainer_all.AccountId
                                 , tmpMIContainer_all.CashId
                                 , tmpMIContainer_all.Amount - SUM (tmpMIContainer_all.Amount_summ + tmpMIContainer_all.AmountDebet - tmpMIContainer_all.AmountKredit) AS AmountRemainsStart
                                 , tmpMIContainer_all.Amount - SUM (tmpMIContainer_all.Amount_summ) AS AmountRemainsEnd
                            FROM tmpMIContainer_all
                            GROUP BY tmpMIContainer_all.ContainerId
                                   , tmpMIContainer_all.AccountId
                                   , tmpMIContainer_all.Amount
                                   , tmpMIContainer_all.CashId
                            HAVING 0 <> tmpMIContainer_all.Amount - SUM (tmpMIContainer_all.Amount_summ + tmpMIContainer_all.AmountDebet - tmpMIContainer_all.AmountKredit)
                                OR 0 <> tmpMIContainer_all.Amount - SUM (tmpMIContainer_all.Amount_summ)
                           )
   , tmpMIContainer AS (SELECT tmpMIContainer_all.ContainerId
                             , tmpMIContainer_all.AccountId
                             , tmpMIContainer_all.CashId
                             , tmpMIContainer_all.InfoMoneyId
                             , tmpMIContainer_all.AmountDebet
                             , tmpMIContainer_all.AmountKredit
                             , 0 AS AmountRemainsStart
                             , 0 AS AmountRemainsEnd
                             , tmpMIContainer_all.MovementDescId

                        FROM tmpMIContainer_all
                        WHERE (tmpMIContainer_all.InfoMoneyId IN (SELECT tmp.InfoMoneyId FROM tmpInfoMoney AS tmp) OR inInfoMoneyId = 0)
                          AND (tmpMIContainer_all.AmountDebet <> 0
                            OR tmpMIContainer_all.AmountKredit <> 0
                              )

                       UNION ALL
                        SELECT tmpMIContainer_rem.ContainerId
                             , tmpMIContainer_rem.AccountId
                             , tmpMIContainer_rem.CashId
                             , 0 AS InfoMoneyId
                             , 0 AS AmountDebet
                             , 0 AS AmountKredit
                             , tmpMIContainer_rem.AmountRemainsStart
                             , tmpMIContainer_rem.AmountRemainsEnd
                             , 0 AS MovementDescId

                        FROM tmpMIContainer_rem
                       )
       -- Результат
       SELECT Object_Cash.ObjectCode AS CashCode
            , Object_Cash.ValueData  AS CashName
            , ObjectString_Cash_GroupNameFull.ValueData AS GroupNameFull_Cash
            , Object_ParentCash.ValueData               AS ParentName_Cash
            , ObjectFloat_NPP.ValueData   ::TFloat AS NPP

            , Object_InfoMoney.ObjectCode AS InfoMoneyCode
            , Object_InfoMoney.ValueData  AS InfoMoneyName 

            , MovementDesc.ItemName ::TVarChar AS MovementDescName
                                   
            , Object_Account.ObjectCode   AS AccountCode
            , Object_Account.ValueData    AS AccountName
            , Object_Currency.ValueData   AS CurrencyName

            , CAST (CASE WHEN tmpMIContainer.AmountRemainsStart > 0 OR  1=1 THEN tmpMIContainer.AmountRemainsStart ELSE 0 END AS TFloat)      AS AmountDebetStart
            , CAST (CASE WHEN tmpMIContainer.AmountRemainsStart < 0 AND 1=1 THEN -1 * tmpMIContainer.AmountRemainsStart ELSE 0 END AS TFloat) AS AmountKreditStart
            , CAST (tmpMIContainer.AmountDebet AS TFloat)  AS AmountDebet
            , CAST (tmpMIContainer.AmountKredit AS TFloat) AS AmountKredit
            , CAST (CASE WHEN tmpMIContainer.AmountRemainsEnd > 0 OR  1=1 THEN tmpMIContainer.AmountRemainsEnd ELSE 0 END AS TFloat)      AS AmountDebetEnd
            , CAST (CASE WHEN tmpMIContainer.AmountRemainsEnd < 0 AND 1=1 THEN -1 * tmpMIContainer.AmountRemainsEnd ELSE 0 END AS TFloat) AS AmountKreditEnd

       FROM tmpMIContainer
           LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMIContainer.InfoMoneyId
           LEFT JOIN Object AS Object_Account   ON Object_Account.Id   = tmpMIContainer.AccountId
           LEFT JOIN Object AS Object_Cash      ON Object_Cash.Id      = tmpMIContainer.CashId 
           LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMIContainer.MovementDescId

           LEFT JOIN ObjectString AS ObjectString_Cash_GroupNameFull
                                  ON ObjectString_Cash_GroupNameFull.ObjectId = Object_Cash.Id
                                 AND ObjectString_Cash_GroupNameFull.DescId = zc_ObjectString_Cash_GroupNameFull()

           LEFT JOIN ObjectLink AS ObjectLink_Cash_Parent
                                ON ObjectLink_Cash_Parent.ObjectId = Object_Cash.Id
                               AND ObjectLink_Cash_Parent.DescId = zc_ObjectLink_Cash_Parent()
           LEFT JOIN Object AS Object_ParentCash ON Object_ParentCash.Id = ObjectLink_Cash_Parent.ChildObjectId

           LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                                 ON ObjectFloat_NPP.ObjectId = Object_Cash.Id
                                AND ObjectFloat_NPP.DescId = zc_ObjectFloat_Cash_NPP()

           LEFT JOIN ObjectLink AS ObjectLink_Currency
                                ON ObjectLink_Currency.ObjectId = Object_Cash.Id
                               AND ObjectLink_Currency.DescId = zc_ObjectLink_Cash_Currency()
           LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Currency.ChildObjectId

      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.02.22         *
*/

-- тест
-- SELECT * FROM gpReport_CashBalance (inStartDate := '01.01.2021', inEndDate:= '31.12.2021', inCashGroupId:= 0, inInfoMoneyId:= 0, inSession:= zfCalc_UserAdmin())
