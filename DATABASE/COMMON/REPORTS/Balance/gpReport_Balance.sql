-- Function: gpReport_Balance()

DROP FUNCTION IF EXISTS gpReport_Balance (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Balance(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (RootName TVarChar, AccountCode Integer, AccountGroupName TVarChar, AccountDirectionName TVarChar, AccountName  TVarChar
             , AccountGroupName_original TVarChar, AccountDirectionName_original TVarChar, AccountName_original  TVarChar
             , AccountOnComplete Boolean, InfoMoneyName TVarChar, InfoMoneyName_Detail TVarChar
             , ByObjectItemName TVarChar, ByObjectName TVarChar, GoodsItemName TVarChar, GoodsName TVarChar
             , PaidKindName TVarChar
             , JuridicalBasisCode Integer, JuridicalBasisName TVarChar
             , BusinessCode Integer, BusinessName TVarChar
             , AmountDebetStart TFloat, AmountKreditStart TFloat, AmountDebet TFloat, AmountKredit TFloat, AmountDebetEnd TFloat, AmountKreditEnd TFloat
             , AmountActiveStart TFloat, AmountPassiveStart TFloat, AmountActiveEnd TFloat, AmountPassiveEnd TFloat
             , CountStart TFloat, CountDebet TFloat, CountKredit TFloat, CountEnd TFloat
             , ContainerId Integer
             , isPrintDetail Boolean
             , RootName_Detail TVarChar
             , AccountDirectionName_Detail TVarChar
             , AccountGroupName_Detail TVarChar
             , AccountName_Detail TVarChar
             , AccountDirectionName_print TVarChar
             , AccountGroupName_print TVarChar
             , AccountName_print TVarChar
             , Num_Detail Integer
             , Koeff_50401 Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccountName_70301 TVarChar;
   DECLARE vbAccountGroupName_70301 TVarChar;
   DECLARE vbAccountDirectionName_70301 TVarChar;
   DECLARE vbAccountName_print  TVarChar;
   DECLARE vbAccountGroupName_print  TVarChar;
   DECLARE vbAccountDirectionName_print  TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Balance());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


-- if vbUserId = 973007
/*if vbUserId <> 5
then
    RAISE EXCEPTION 'Извините. Отчет временно не доступен.', 'Повторите действие после 15:00.';
end if;*/


     -- Ограниченние - нет доступа к Баланс
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657331)
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав к отчету Баланс.';
     END IF;


     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;

     SELECT  Object_Account_View.AccountName, Object_Account_View.AccountGroupName, Object_Account_View.AccountDirectionName
           , Object_Account_View.AccountName_original, Object_Account_View.AccountGroupName_original, Object_Account_View.AccountDirectionName_original
     INTO vbAccountName_70301
        , vbAccountGroupName_70301
        , vbAccountDirectionName_70301
        , vbAccountName_print
        , vbAccountGroupName_print
        , vbAccountDirectionName_print
     FROM Object_Account_View 
     WHERE  Object_Account_View.AccountCode = 70301;

     -- Результат
     RETURN QUERY

       -- некоторые счета делим на Нал/Бн
       WITH tmpAccount AS (SELECT Object_Account_View.* FROM Object_Account_View)

          , tmpAccountDirection AS (SELECT 30100 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm  -- ++ Дебиторы + покупатели
                                   UNION
                                    SELECT 30200 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm  -- ++ Дебиторы + наши компании
                                   UNION
                                    SELECT 30300 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm  -- ++ Дебиторы + Дебиторы по услугам
                                   UNION
                                    SELECT 30400 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm  -- ++ Дебиторы + Прочие дебиторы
                                   UNION
                                    SELECT 30500 AS AccountDirectionCode, FALSE AS isFirstForm, FALSE AS isFirstForm_pav, TRUE AS isSecondForm -- -+ сотрудники (подотчетные лица)
                                   UNION
                                    SELECT 30600 AS AccountDirectionCode, FALSE AS isFirstForm, FALSE AS isFirstForm_pav, TRUE AS isSecondForm -- -+ сотрудники (недостачи, порча)
                                   UNION
                                    SELECT 30700 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, FALSE AS isSecondForm -- +- векселя полученные

                                   UNION
                                    SELECT 70100 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm  -- ++ Кредиторы + поставщики
                                   UNION
                                    SELECT 70200 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm  -- ++ Кредиторы + Кредиторы по услугам
                                   UNION
                                    SELECT 70300 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm  -- ++ Кредиторы + Кредиторы по маркетингу
                                   UNION
                                    SELECT 70400 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm  -- ++ Коммунальные услуги
                                   UNION
                                    SELECT 70500 AS AccountDirectionCode, FALSE AS isFirstForm, FALSE AS isFirstForm_pav, TRUE AS isSecondForm -- -+ Сотрудники
                                   UNION
                                    SELECT 70600 AS AccountDirectionCode, FALSE AS isFirstForm, FALSE AS isFirstForm_pav, TRUE AS isSecondForm -- -+ сотрудники (заготовители)
                                   UNION
                                    SELECT 70700 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm  -- ++ Административные ОС
                                   UNION
                                    SELECT 70800 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm  -- ++ Производственные ОС
                                   UNION
                                    SELECT 70900 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm  -- ++ НМА
                                   UNION
                                    SELECT 71000 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, FALSE AS isSecondForm -- +- векселя выданные

                                   UNION
                                    SELECT 80100 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm -- ++ Кредиты банков
                                   UNION
                                    SELECT 80200 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm -- ++ Прочие кредиты
                                   UNION
                                    SELECT 80300 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm -- ++ ???
                                   UNION
                                    SELECT 80400 AS AccountDirectionCode, TRUE AS isFirstForm, TRUE AS isFirstForm_pav, TRUE AS isSecondForm -- ++ проценты по кредитам
                                   )
          , tmpAccount_two AS (SELECT tmpAccount.*, COALESCE (tmpAccountDirection.AccountDirectionCode, 0) AS AccountDirectionCode_find, isFirstForm, isFirstForm_pav, isSecondForm
                               FROM tmpAccount
                                    LEFT JOIN tmpAccountDirection ON tmpAccountDirection.AccountDirectionCode = tmpAccount.AccountDirectionCode
                              )
          , tmpAccountFind AS (SELECT * FROM tmpAccount_two WHERE AccountDirectionCode_find <> 0)

          , tmpAccountAll AS (SELECT tmpAccount_two.*, COALESCE (tmpPaidKind.PaidKindId, 0) AS PaidKindId
                              FROM tmpAccount_two
                                   LEFT JOIN (SELECT zc_Enum_PaidKind_FirstForm()     AS PaidKindId
                                    UNION ALL SELECT zc_Enum_PaidKind_SecondForm()    AS PaidKindId
                                    UNION ALL SELECT zc_Enum_PaidKind_FirstForm_pav() AS PaidKindId
                                             ) AS tmpPaidKind ON tmpAccount_two.AccountDirectionCode_find <> 0 AND ((isFirstForm      = TRUE AND tmpPaidKind.PaidKindId = zc_Enum_PaidKind_FirstForm())
                                                                                                                 OR (isFirstForm_pav  = TRUE AND tmpPaidKind.PaidKindId = zc_Enum_PaidKind_FirstForm_pav())
                                                                                                                 OR (isSecondForm     = TRUE AND tmpPaidKind.PaidKindId = zc_Enum_PaidKind_SecondForm())
                                                                                                                   )
                             )
       -- результат
       SELECT
             CAST (CASE WHEN Object_Account_View.AccountCode >= 70000 THEN 'ПАССИВЫ' ELSE 'АКТИВЫ' END AS TVarChar) AS RootName

           , Object_Account_View.AccountCode
           , Object_Account_View.AccountGroupName
           , Object_Account_View.AccountDirectionName
           , Object_Account_View.AccountName
           --для печатной формы без кода
           , Object_Account_View.AccountGroupName_original
           , Object_Account_View.AccountDirectionName_original
           , Object_Account_View.AccountName_original

           , Object_Account_View.onComplete AS AccountOnComplete

           --, lfObject_InfoMoney.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
           --, lfObject_InfoMoney_Detail.InfoMoneyCode AS InfoMoneyCode_Detail
           , Object_InfoMoney_View.InfoMoneyName AS InfoMoneyName_Detail
           -- , Object_InfoMoney_View_Detail.InfoMoneyName AS InfoMoneyName_Detail

           , ObjectDesc_by.ItemName    AS ByObjectItemName
           -- , Object_by.ObjectCode         AS ByObjectCode
           , (COALESCE (Object_Bank.ValueData || ' * ', '') || Object_by.ValueData || COALESCE (' * ' || Object_Currency.ValueData, '')) :: TVarChar AS ByObjectName

           , ObjectDesc_Goods.ItemName AS GoodsItemName
           -- , Object_Goods.ObjectCode      AS GoodsCode
           , Object_Goods.ValueData       AS GoodsName

           , Object_PaidKind.ValueData   AS PaidKindName

           , Object_JuridicalBasis.ObjectCode AS JuridicalBasisCode
           , Object_JuridicalBasis.ValueData  AS JuridicalBasisName
           , Object_Business.ObjectCode       AS BusinessCode
           , Object_Business.ValueData        AS BusinessName

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
           
           , COALESCE (Object_Account_View.isPrintDetail, FALSE) :: Boolean AS isPrintDetail
           -- для сортировки
           , CAST (CASE WHEN Object_Account_View.AccountCode >= 70000 OR Object_Account_View.AccountCode = 50401 THEN 'ПАССИВЫ' ELSE 'АКТИВЫ' END AS TVarChar) AS RootName_Detail
           , CASE WHEN Object_Account_View.AccountId = zc_Enum_Account_50401() THEN vbAccountDirectionName_70301 ELSE Object_Account_View.AccountDirectionName END :: TVarChar  AS  AccountDirectionName_Detail
           , CASE WHEN Object_Account_View.AccountId = zc_Enum_Account_50401() THEN vbAccountGroupName_70301 ELSE Object_Account_View.AccountGroupName END :: TVarChar  AS  AccountGroupName_Detail
          
           , CASE WHEN COALESCE (Object_Account_View.isPrintDetail, FALSE) = FALSE 
                  THEN 'Прочее' 
                  ELSE CASE WHEN Object_Account_View.AccountId = zc_Enum_Account_50401() THEN vbAccountName_70301 ELSE Object_Account_View.AccountName END 
                  END  :: TVarChar AS AccountName_Detail
                  
           -- для вывода на печать
           , CASE WHEN Object_Account_View.AccountId = zc_Enum_Account_50401() THEN vbAccountDirectionName_print ELSE Object_Account_View.AccountDirectionName_original END :: TVarChar  AS  AccountDirectionName__print
           , CASE WHEN Object_Account_View.AccountId = zc_Enum_Account_50401() THEN vbAccountGroupName_print ELSE Object_Account_View.AccountGroupName_original END         :: TVarChar  AS  AccountGroupName__print
          
           , CASE WHEN COALESCE (Object_Account_View.isPrintDetail, FALSE) = FALSE 
                  THEN 'Прочее' 
                  ELSE CASE WHEN Object_Account_View.AccountId = zc_Enum_Account_50401() THEN vbAccountName_print ELSE Object_Account_View.AccountName_original END 
                  END  :: TVarChar AS AccountName__print


           , CASE WHEN COALESCE (Object_Account_View.isPrintDetail, FALSE) = FALSE THEN 999 ELSE 1 END :: integer AS Num_Detail
           , CASE WHEN Object_Account_View.AccountId = zc_Enum_Account_50401() THEN -1 ELSE 1 END :: integer AS Koeff_50401
       FROM
           tmpAccountAll AS Object_Account_View
           LEFT JOIN
           (SELECT tmpReportOperation_two.AccountId
                 , tmpReportOperation_two.InfoMoneyId
                 , tmpReportOperation_two.InfoMoneyId_Detail
                 , tmpReportOperation_two.CashId
                 , tmpReportOperation_two.CurrencyId
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

                 , tmpReportOperation_two.ContainerId
            FROM
           (SELECT tmpMIContainer_Remains.AccountId
                 , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                 , 0 AS InfoMoneyId_Detail -- ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail
                 , ContainerLinkObject_Cash.ObjectId AS CashId
                 , ContainerLinkObject_Currency.ObjectId AS CurrencyId
                 , ContainerLinkObject_BankAccount.ObjectId AS BankAccountId
                 , ContainerLinkObject_Juridical.ObjectId AS JuridicalId
                 , ContainerLinkObject_Member.ObjectId AS MemberId
                 , ContainerLinkObject_Unit.ObjectId AS UnitId
                 , ContainerLinkObject_Car.ObjectId  AS CarId
                 , 0 AS GoodsId -- ContainerLinkObject_Goods.ObjectId AS GoodsId
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

                 , MAX (tmpMIContainer_Remains.ContainerId) AS ContainerId
            FROM
                (SELECT Container.ObjectId AS AccountId
                      , Container.Id AS ContainerId
                      -- , Container.ParentId
                      , COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.AccountId      = zc_Enum_Account_100301()
                                             AND MIContainer.isActive = TRUE
                                                 THEN 1 * MIContainer.Amount

                                            WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.AccountId = zc_Enum_Account_100301()
                                             AND MIContainer.isActive = FALSE
                                                 THEN 0

                                            WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId = zc_Movement_ProfitLossResult()
                                                 THEN 0

                                            WHEN MIContainer.Amount > 0
                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                 THEN  1 * MIContainer.Amount
                                            ELSE 0
                                       END), 0) AS AmountDebet
                      , COALESCE (SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.AccountId = zc_Enum_Account_100301()
                                             AND MIContainer.isActive = TRUE
                                                 THEN 0

                                            WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.AccountId = zc_Enum_Account_100301()
                                             AND MIContainer.isActive = FALSE
                                                 THEN -1 * MIContainer.Amount

                                            WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId = zc_Movement_ProfitLossResult()
                                                 THEN -1 * MIContainer.Amount

                                            WHEN MIContainer.Amount < 0
                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                 THEN -1 * MIContainer.Amount
                                            ELSE 0
                                       END), 0) AS AmountKredit
                      -- , COALESCE (SUM (CASE WHEN  MIContainer.isActive = TRUE  AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_100301()  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  1 * MIContainer.Amount ELSE 0 END), 0) AS AmountDebet
                      -- , COALESCE (SUM (CASE WHEN (MIContainer.isActive = FALSE OR  COALESCE (MIContainer.AccountId, 0) =  zc_Enum_Account_100301()) AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount ELSE 0 END), 0) AS AmountKredit
                      , COALESCE (Container.Amount,0) - COALESCE (SUM (MIContainer.Amount), 0) AS AmountRemainsStart
                 FROM Container
                      LEFT JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.Containerid = Container.Id
                                                     AND MIContainer.OperDate >= inStartDate
                                                   --AND MIContainer.MovementDescId <> zc_Movement_ProfitLossResult()
                 WHERE Container.DescId = zc_Container_Summ()
                 GROUP BY Container.ObjectId
                        , COALESCE (Container.Amount,0)
                        , Container.Id
                        -- , Container.ParentId
                 HAVING (COALESCE (Container.Amount,0) - COALESCE (SUM (MIContainer.Amount), 0) <> 0) -- AmountRemainsStart <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountDebet <> 0
                     OR (COALESCE (SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -MIContainer.Amount ELSE 0 END), 0) <> 0) -- AmountKredit <> 0
                ) AS tmpMIContainer_Remains
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                              ON ContainerLinkObject_InfoMoney.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                -- !!!прибыль текущего периода!!!
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                              ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                             AND ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401()

                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Currency
                                              ON ContainerLinkObject_Currency.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Currency.DescId      = zc_ContainerLinkObject_Currency()
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
                                             AND ContainerLinkObject_Member.ObjectId > 0
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                              ON ContainerLinkObject_Unit.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                              ON ContainerLinkObject_Car.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                                             AND ContainerLinkObject_Car.ObjectId > 0
                /*LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                              ON ContainerLinkObject_Goods.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()*/
                LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                              ON ContainerLinkObject_PaidKind.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                LEFT JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                              ON ContainerLO_JuridicalBasis.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                /*LEFT JOIN ContainerLinkObject AS ContainerLO_Business
                                              ON ContainerLO_Business.ContainerId = tmpMIContainer_Remains.ContainerId
                                             AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()*/
            -- !!!прибыль текущего периода!!!
            WHERE ContainerLinkObject_InfoMoneyDetail.ContainerId IS NULL

            GROUP BY tmpMIContainer_Remains.AccountId
                   , ContainerLinkObject_InfoMoney.ObjectId
                   -- , ContainerLinkObject_InfoMoneyDetail.ObjectId
                   , ContainerLinkObject_Cash.ObjectId
                   , ContainerLinkObject_Currency.ObjectId
                   , ContainerLinkObject_BankAccount.ObjectId
                   , ContainerLinkObject_Juridical.ObjectId
                   , ContainerLinkObject_Member.ObjectId
                   , ContainerLinkObject_Unit.ObjectId
                   , ContainerLinkObject_Car.ObjectId
                   -- , ContainerLinkObject_Goods.ObjectId
                   , ContainerLinkObject_PaidKind.ObjectId
                   , ContainerLO_JuridicalBasis.ObjectId
                   -- , ContainerLO_Business.ObjectId

           ) AS tmpReportOperation_two
           LEFT JOIN tmpAccountFind ON tmpAccountFind.AccountId = tmpReportOperation_two.AccountId

           ) AS tmpReportOperation ON tmpReportOperation.AccountId = Object_Account_View.AccountId
                                  AND (tmpReportOperation.PaidKindId = Object_Account_View.PaidKindId
                                       OR (tmpReportOperation.PaidKindId = 0
                                           AND ((Object_Account_View.PaidKindId = zc_Enum_PaidKind_FirstForm()     AND Object_Account_View.isFirstForm     = TRUE)
                                             OR (Object_Account_View.PaidKindId = zc_Enum_PaidKind_FirstForm_pav() AND Object_Account_View.isFirstForm_pav = FALSE)
                                             OR (Object_Account_View.PaidKindId = zc_Enum_PaidKind_SecondForm()    AND Object_Account_View.isFirstForm     = FALSE)
                                               )
                                          )
                                      )
                                  -- AND tmpReportOperation.InfoMoneyId        <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
      
           LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpReportOperation.InfoMoneyId
           -- LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View_Detail ON Object_InfoMoney_View_Detail.InfoMoneyId = CASE WHEN COALESCE (tmpReportOperation.InfoMoneyId_Detail, 0) = 0 THEN tmpReportOperation.InfoMoneyId ELSE tmpReportOperation.InfoMoneyId_Detail END
           -- LEFT JOIN Object AS Object_by ON Object_by.Id = COALESCE (BankAccountId, COALESCE (CashId, COALESCE (JuridicalId, CASE WHEN CarId <> 0 THEN CarId WHEN MemberId <> 0 THEN MemberId ELSE UnitId END)))
           LEFT JOIN Object AS Object_by ON Object_by.Id = COALESCE (BankAccountId
                                                         , COALESCE (CashId
                                                         , COALESCE (JuridicalId
                                                         , COALESCE (CASE WHEN -- сотрудники (подотчетные лица)
                                                                               Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_30500()
                                                                               AND 1=1
                                                                               THEN NULL
                                                                          ELSE CarId
                                                                     END
                                                         , COALESCE (MemberId, UnitId)))))
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = GoodsId
           LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = CurrencyId

           LEFT JOIN ObjectDesc AS ObjectDesc_by    ON ObjectDesc_by.Id    = Object_by.DescId
           LEFT JOIN ObjectDesc AS ObjectDesc_Goods ON ObjectDesc_Goods.Id = Object_Goods.DescId

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
 21.01.19         *
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
-- SELECT * FROM gpReport_Balance (inStartDate:= '01.08.2024', inEndDate:= '31.08.2024', inSession:= zfCalc_UserAdmin())
