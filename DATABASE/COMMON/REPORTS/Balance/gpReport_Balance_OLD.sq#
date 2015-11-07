!!!OLD!!!
-- Function: gpReport_Balance()

DROP FUNCTION IF EXISTS gpReport_Balance (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Balance(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (RootName TVarChar, AccountCode Integer, AccountGroupName TVarChar, AccountDirectionName TVarChar, AccountName  TVarChar 
             , AccountOnComplete Boolean, InfoMoneyName TVarChar, InfoMoneyName_Detail TVarChar
             , ByObjectName TVarChar, GoodsName TVarChar
             , PaidKindName TVarChar
             , JuridicalBasisCode Integer, JuridicalBasisName TVarChar
             , BusinessCode Integer, BusinessName TVarChar
             , AmountDebetStart TFloat, AmountKreditStart TFloat, AmountDebet TFloat, AmountKredit TFloat, AmountDebetEnd TFloat, AmountKreditEnd TFloat
             , CountStart TFloat, CountDebet TFloat, CountKredit TFloat, CountEnd TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Balance());
     vbUserId:= lpGetUserBySession (inSession);

     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


     -- Результат
     RETURN QUERY 

       -- некоторые счета делим на Нал/Бн
       WITH tmpAccount AS (SELECT Object_Account_View.* FROM Object_Account_View)

          , tmpAccountDirection AS (SELECT 30100 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm  -- ++ Дебиторы + покупатели 
                                   UNION
                                    SELECT 30200 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm  -- ++ Дебиторы + наши компании
                                   UNION
                                    SELECT 30300 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm  -- ++ Дебиторы + Дебиторы по услугам
                                   UNION
                                    SELECT 30400 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm  -- ++ Дебиторы + Прочие дебиторы
                                   UNION
                                    SELECT 30500 AS AccountDirectionCode, FALSE AS isFirstForm, TRUE AS isSecondForm -- -+ сотрудники (подотчетные лица)
                                   UNION
                                    SELECT 30600 AS AccountDirectionCode, FALSE AS isFirstForm, TRUE AS isSecondForm -- -+ сотрудники (недостачи, порча)
                                   UNION
                                    SELECT 30700 AS AccountDirectionCode, TRUE AS isFirstForm, FALSE AS isSecondForm -- +- векселя полученные

                                   UNION
                                    SELECT 70100 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm  -- ++ Кредиторы + поставщики
                                   UNION
                                    SELECT 70200 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm  -- ++ Кредиторы + Кредиторы по услугам
                                   UNION
                                    SELECT 70300 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm  -- ++ Кредиторы + Кредиторы по маркетингу
                                   UNION
                                    SELECT 70400 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm  -- ++ Коммунальные услуги
                                   UNION
                                    SELECT 70500 AS AccountDirectionCode, FALSE AS isFirstForm, TRUE AS isSecondForm -- -+ Сотрудники
                                   UNION
                                    SELECT 70600 AS AccountDirectionCode, FALSE AS isFirstForm, TRUE AS isSecondForm -- -+ сотрудники (заготовители)
                                   UNION
                                    SELECT 70700 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm  -- ++ Административные ОС
                                   UNION
                                    SELECT 70800 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm  -- ++ Производственные ОС
                                   UNION
                                    SELECT 70900 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm  -- ++ НМА
                                   UNION
                                    SELECT 71000 AS AccountDirectionCode, TRUE AS isFirstForm, FALSE AS isSecondForm -- +- векселя выданные

                                   UNION
                                    SELECT 80100 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm -- ++ Кредиты банков
                                   UNION
                                    SELECT 80200 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm -- ++ Прочие кредиты
                                   UNION
                                    SELECT 80300 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm -- ++ ???
                                   UNION
                                    SELECT 80400 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isSecondForm -- ++ проценты по кредитам
                                   )
          , tmpAccount_two AS (SELECT tmpAccount.*, COALESCE (tmpAccountDirection.AccountDirectionCode, 0) AS AccountDirectionCode_find, isFirstForm, isSecondForm
                               FROM tmpAccount
                                    LEFT JOIN tmpAccountDirection ON tmpAccountDirection.AccountDirectionCode = tmpAccount.AccountDirectionCode
                              )
          , tmpAccountFind AS (SELECT * FROM tmpAccount_two WHERE AccountDirectionCode_find <> 0)

          , tmpAccountAll AS (SELECT tmpAccount_two.*, COALESCE (tmpPaidKind.PaidKindId, 0) AS PaidKindId
                              FROM tmpAccount_two
                                   LEFT JOIN (SELECT zc_Enum_PaidKind_FirstForm() AS PaidKindId UNION ALL SELECT zc_Enum_PaidKind_SecondForm() AS PaidKindId
                                             ) AS tmpPaidKind ON tmpAccount_two.AccountDirectionCode_find <> 0 AND ((isFirstForm  = TRUE AND tmpPaidKind.PaidKindId = zc_Enum_PaidKind_FirstForm())
                                                                                                                 OR (isSecondForm = TRUE AND tmpPaidKind.PaidKindId = zc_Enum_PaidKind_SecondForm())
                                                                                                                   )
                             )
       -- результат
       SELECT
             CAST (CASE WHEN Object_Account_View.AccountCode >= 70000 THEN 'ПАССИВЫ' ELSE 'АКТИВЫ' END AS TVarChar) AS RootName

           , Object_Account_View.AccountCode
           , Object_Account_View.AccountGroupName
           , Object_Account_View.AccountDirectionName
           , Object_Account_View.AccountName
           , Object_Account_View.onComplete AS AccountOnComplete

           --, lfObject_InfoMoney.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
           --, lfObject_InfoMoney_Detail.InfoMoneyCode AS InfoMoneyCode_Detail
           , Object_InfoMoney_View.InfoMoneyName AS InfoMoneyName_Detail
           -- , Object_InfoMoney_View_Detail.InfoMoneyName AS InfoMoneyName_Detail

           --, Object_by.ObjectCode         AS ByObjectCode
           , (COALESCE (Object_Bank.ValueData || ' * ', '') || Object_by.ValueData) :: TVarChar AS ByObjectName
           --, Object_Goods.ObjectCode      AS GoodsCode
           , Object_Goods.ValueData       AS GoodsName

           , Object_PaidKind.ValueData   AS PaidKindName

           , Object_JuridicalBasis.ObjectCode AS JuridicalBasisCode
           , Object_JuridicalBasis.ValueData  AS JuridicalBasisName
           , Object_Business.ObjectCode       AS BusinessCode
           , Object_Business.ValueData        AS BusinessName

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
           tmpAccountAll AS Object_Account_View
           LEFT JOIN
           (SELECT tmpReportOperation_two.AccountId
                 , tmpReportOperation_two.InfoMoneyId
                 , tmpReportOperation_two.InfoMoneyId_Detail
                 , tmpReportOperation_two.CashId
                 , tmpReportOperation_two.BankAccountId
                 , tmpReportOperation_two.JuridicalId
                 , tmpReportOperation_two.MemberId
                 , tmpReportOperation_two.UnitId
                 , tmpReportOperation_two.CarId
                 , tmpReportOperation_two.GoodsId
                 , CASE WHEN tmpAccountFind.AccountId IS NOT NULL THEN COALESCE (tmpReportOperation_two.PaidKindId, zc_Enum_PaidKind_SecondForm()) ELSE 0 END AS PaidKindId

                 , tmpReportOperation_two.JuridicalBasisId
                 , tmpReportOperation_two.BusinessId

                 , tmpReportOperation_two.AmountRemainsStart
                 , tmpReportOperation_two.AmountDebet
                 , tmpReportOperation_two.AmountKredit
                 , tmpReportOperation_two.AmountRemainsEnd

                 , tmpReportOperation_two.CountRemainsStart
                 , tmpReportOperation_two.CountDebet
                 , tmpReportOperation_two.CountKredit
                 , tmpReportOperation_two.CountRemainsEnd
            FROM
           (SELECT tmpMIContainer_Remains.AccountId
                 , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                 , 0 AS InfoMoneyId_Detail -- ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail
                 , ContainerLinkObject_Cash.ObjectId AS CashId
                 , ContainerLinkObject_BankAccount.ObjectId AS BankAccountId
                 , ContainerLinkObject_Juridical.ObjectId AS JuridicalId
                 , ContainerLinkObject_Member.ObjectId AS MemberId
                 , ContainerLinkObject_Unit.ObjectId AS UnitId
                 , ContainerLinkObject_Car.ObjectId  AS CarId
                 , ContainerLinkObject_Goods.ObjectId AS GoodsId
                 , ContainerLinkObject_PaidKind.ObjectId AS PaidKindId

                 , ContainerLO_JuridicalBasis.ObjectId AS JuridicalBasisId
                 , 0 AS BusinessId -- ContainerLO_Business.ObjectId AS BusinessId

                 , SUM (tmpMIContainer_Remains.AmountRemainsStart) AS AmountRemainsStart
                 , SUM (tmpMIContainer_Remains.AmountDebet) AS AmountDebet
                 , SUM (tmpMIContainer_Remains.AmountKredit) AS AmountKredit
                 , SUM (tmpMIContainer_Remains.AmountRemainsStart + tmpMIContainer_Remains.AmountDebet - tmpMIContainer_Remains.AmountKredit) AS AmountRemainsEnd

                 , 0 AS CountRemainsStart -- SUM (COALESCE (tmpMIContainer_RemainsCount.AmountRemainsStart, 0)) AS CountRemainsStart
                 , 0 AS CountDebet -- SUM (COALESCE (tmpMIContainer_RemainsCount.AmountDebet, 0)) AS CountDebet
                 , 0 AS CountKredit -- SUM (COALESCE (tmpMIContainer_RemainsCount.AmountKredit, 0)) AS CountKredit
                 , 0 AS CountRemainsEnd -- SUM (COALESCE (tmpMIContainer_RemainsCount.AmountRemainsStart, 0) + COALESCE (tmpMIContainer_Remains.AmountDebet, 0) - COALESCE (tmpMIContainer_Remains.AmountKredit, 0)) AS CountRemainsEnd
            FROM
                (SELECT Container.ObjectId AS AccountId
                      , Container.Id AS ContainerId
                      -- , Container.ParentId
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
                /*LEFT JOIN
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
                ) AS tmpMIContainer_RemainsCount ON tmpMIContainer_RemainsCount.ContainerId = tmpMIContainer_Remains.ParentId*/
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                              ON ContainerLinkObject_InfoMoney.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                /*LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                              ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()*/
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Cash
                                              ON ContainerLinkObject_Cash.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Cash.DescId = zc_ContainerLinkObject_Cash()
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_BankAccount
                                              ON ContainerLinkObject_BankAccount.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_BankAccount.DescId = zc_ContainerLinkObject_BankAccount()
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
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                              ON ContainerLinkObject_PaidKind.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                LEFT JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                              ON ContainerLO_JuridicalBasis.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                /*LEFT JOIN ContainerLinkObject AS ContainerLO_Business
                                              ON ContainerLO_Business.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()*/
            GROUP BY tmpMIContainer_Remains.AccountId
                   , ContainerLinkObject_InfoMoney.ObjectId
                   -- , ContainerLinkObject_InfoMoneyDetail.ObjectId
                   , ContainerLinkObject_Cash.ObjectId
                   , ContainerLinkObject_BankAccount.ObjectId
                   , ContainerLinkObject_Juridical.ObjectId
                   , ContainerLinkObject_Member.ObjectId
                   , ContainerLinkObject_Unit.ObjectId
                   , ContainerLinkObject_Car.ObjectId
                   , ContainerLinkObject_Goods.ObjectId
                   , ContainerLinkObject_PaidKind.ObjectId
                   , ContainerLO_JuridicalBasis.ObjectId
                   -- , ContainerLO_Business.ObjectId

           ) AS tmpReportOperation_two
           LEFT JOIN tmpAccountFind ON tmpAccountFind.AccountId = tmpReportOperation_two.AccountId

           ) AS tmpReportOperation ON tmpReportOperation.AccountId = Object_Account_View.AccountId
                                  AND (tmpReportOperation.PaidKindId = Object_Account_View.PaidKindId
                                       OR (tmpReportOperation.PaidKindId = 0
                                           AND ((Object_Account_View.PaidKindId = zc_Enum_PaidKind_FirstForm() AND Object_Account_View.isFirstForm = TRUE)
                                                OR (Object_Account_View.PaidKindId = zc_Enum_PaidKind_SecondForm() AND Object_Account_View.isFirstForm = FALSE)
                                               )
                                          )
                                      )

           LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpReportOperation.InfoMoneyId
           -- LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View_Detail ON Object_InfoMoney_View_Detail.InfoMoneyId = CASE WHEN COALESCE (tmpReportOperation.InfoMoneyId_Detail, 0) = 0 THEN tmpReportOperation.InfoMoneyId ELSE tmpReportOperation.InfoMoneyId_Detail END
           LEFT JOIN Object AS Object_by ON Object_by.Id = COALESCE (BankAccountId, COALESCE (CashId, COALESCE (JuridicalId, COALESCE (CarId, COALESCE (MemberId, UnitId)))))
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = GoodsId
           LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = JuridicalBasisId
           LEFT JOIN Object AS Object_Business ON Object_Business.Id = BusinessId
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Account_View.PaidKindId

           LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                ON ObjectLink_BankAccount_Bank.ObjectId = BankAccountId
                               AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
           LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

          ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Balance (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.05.14                                        * add BankAccountId and CashId
 29.03.14                                        * add PaidKindName
 27.01.14                                        * add zc_ContainerLinkObject_JuridicalBasis and zc_ContainerLinkObject_Business
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

-- тест
-- SELECT * FROM gpReport_Balance (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inSession:= '2') 
