-- Function: gpInsert_DefermentPaymentOLAPTable (TDateTime, TDateTime, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS  gpInsert_DefermentPaymentOLAPTable (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_DefermentPaymentOLAPTable(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountId          Integer,    --
    IN inJuridicalId        Integer,    --
    IN inSession            TVarChar
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_DefermentPaymentOLAPTable());

   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('_tmpReport'))
   THEN
        DELETE FROM _tmpReport;
   ELSE
        -- выбираем данные из отчета
        CREATE TEMP TABLE _tmpReport (ContainerId       Integer
                                    , OperDate          TDateTime
                                    , StartContractDate TDateTime
                                    , AccountId         Integer
                                    , JuridicalId       Integer
                                    , PartnerId         Integer
                                    , BranchId          Integer
                                    , PaidKindId        Integer
                                    , ContractId        Integer
                                    , DebtRemains       TFloat
                                    , SaleSumm          TFloat
                                     ) ON COMMIT DROP;
   END IF;



     WITH tmpDate AS (SELECT GENERATE_SERIES (inStartDate, inEndDate, '1 DAY' :: INTERVAL) AS OperDate
                     )
          -- Условия договора на Дату
        , tmpContractCondition AS (SELECT Object_ContractCondition_View.ContractId
                                        , ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                                        , tmpDate.OperDate
                                        , zfCalc_DetermentPaymentDate (COALESCE (ContractConditionKindId, 0), Value :: Integer, tmpDate.OperDate) :: Date AS StartContractDate
                                        , Object_ContractCondition_View.ContractConditionKindId
                                        , Object_ContractCondition_View.Value :: Integer AS DayCount
                                   FROM tmpDate
                                        INNER JOIN Object_ContractCondition_View
                                                ON Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                                               AND Object_ContractCondition_View.Value <> 0
                                               AND tmpDate.OperDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                        INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                              ON ObjectLink_Contract_Juridical.ObjectId = Object_ContractCondition_View.ContractId
                                                             AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                             AND (ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)

                                )
          -- список Container
        , tmpContainer AS (SELECT Container.Id       AS ContainerId
                                , Container.ObjectId AS AccountId
                                , Container.Amount
                                , tmpContractCondition_only.ContractId
                                , tmpContractCondition_only.JuridicalId
                           FROM (SELECT DISTINCT tmpContractCondition.ContractId, tmpContractCondition.JuridicalId FROM tmpContractCondition) AS tmpContractCondition_only
                                 INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                ON CLO_Contract.ObjectId = tmpContractCondition_only.ContractId
                                                               AND CLO_Contract.DescId   = zc_ContainerLinkObject_Contract()
                                 INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                                ON CLO_Juridical.ContainerId = CLO_Contract.ContainerId
                                                               AND CLO_Juridical.ObjectId    = tmpContractCondition_only.JuridicalId
                                                               AND CLO_Juridical.DescId      = zc_ContainerLinkObject_Juridical()
                                 INNER JOIN Container ON Container.Id     = CLO_Contract.ContainerId
                                                     AND Container.DescId = zc_Container_Summ()
                                                     AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                          )
        , tmpMIContainer AS (SELECT MIContainer.ContainerId
                                  , CASE WHEN MIContainer.OperDate < inEndDate THEN MIContainer.OperDate ELSE NULL END AS OperDate
                                  , SUM (CASE WHEN MIContainer.OperDate >= inEndDate THEN MIContainer.Amount ELSE 0 END) AS Amount_Debt
                                  , SUM (CASE WHEN MIContainer.OperDate < inEndDate THEN MIContainer.Amount ELSE 0 END)  AS Amount_onDay
                                  , SUM (CASE WHEN MIContainer.OperDate < inEndDate AND MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS Amount_sale
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId FROM tmpContainer)
                               AND MIContainer.OperDate >= (SELECT MIN (tmpContractCondition.StartContractDate) FROM tmpContractCondition)
                             GROUP BY MIContainer.ContainerId
                                    , CASE WHEN MIContainer.OperDate < inEndDate THEN MIContainer.OperDate ELSE NULL END
                            )
        , tmpData AS (SELECT tmpContainer.ContainerId
                           , tmpContainer.AccountId
                           , tmpContainer.ContractId
                           , tmpContainer.JuridicalId
                             -- долг на дату
                           , tmpContainer.Amount - COALESCE (SUM (COALESCE(tmpMIContainer.Amount_Debt, 0)), 0) AS Amount
                      FROM tmpContainer
                           LEFT JOIN tmpMIContainer ON tmpMIContainer.ContainerId = tmpContainer.ContainerId
                                                   AND tmpMIContainer.Amount_Debt <> 0
                      GROUP BY tmpContainer.ContainerId
                             , tmpContainer.AccountId
                             , tmpContainer.ContractId
                             , tmpContainer.JuridicalId
                             , tmpContainer.Amount
                     )
        , tmpData_all AS (SELECT tmpData.ContainerId
                               , tmpData.AccountId
                               , tmpContractCondition.ContractId
                               , tmpContractCondition.JuridicalId
                               , tmpContractCondition.OperDate
                               , tmpContractCondition.StartContractDate

                                 -- долг на дату
                               , tmpData.Amount
                               - COALESCE ((SELECT SUM (tmpMIContainer.Amount_onDay)
                                            FROM tmpMIContainer
                                            WHERE tmpMIContainer.ContainerId = tmpData.ContainerId
                                              AND tmpMIContainer.OperDate >= tmpContractCondition.OperDate
                                           ), 0) AS DebtRemains

                                 -- продано за период
                               , COALESCE ((SELECT SUM (tmpMIContainer.Amount_sale)
                                            FROM tmpMIContainer
                                            WHERE tmpMIContainer.ContainerId = tmpData.ContainerId
                                              AND tmpMIContainer.OperDate >= tmpContractCondition.StartContractDate AND tmpMIContainer.OperDate < tmpContractCondition.OperDate
                                           ), 0) AS SaleSumm

                          FROM tmpContractCondition
                               INNER JOIN tmpData ON tmpData.ContractId  = tmpContractCondition.ContractId
                                                 AND tmpData.JuridicalId = tmpContractCondition.JuridicalId
                         )
          --
          INSERT INTO _tmpReport (ContainerId, OperDate, StartContractDate
                                , AccountId, JuridicalId, PartnerId, BranchId, PaidKindId, ContractId
                                , DebtRemains, SaleSumm
                                 )
          SELECT tmpData_all.ContainerId
               , tmpData_all.OperDate
               , tmpData_all.StartContractDate
               , tmpData_all.AccountId
               , tmpData_all.JuridicalId
               , 0 AS PartnerId
               , 0 AS BranchId
               , COALESCE (CLO_PaidKind.ObjectId, 0) AS PaidKindId
               , View_Contract_ContractKey.ContractId_Key AS ContractId -- tmpData_all.ContractId
               , COALESCE (tmpData_all.DebtRemains, 0)
               , COALESCE (tmpData_all.SaleSumm, 0)

          FROM tmpData_all
               LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                             ON CLO_PaidKind.ContainerId = tmpData_all.ContainerId
                                            AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
               -- !!!Группируем Договора!!!
               LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = tmpData_all.ContractId
          ;



     -- Обновляем те записи которые уже есть в таблице
     DELETE FROM DefermentPaymentOLAPTable
     WHERE OperDate BETWEEN inStartDate AND inEndDate
       AND (DefermentPaymentOLAPTable.AccountId   = inAccountId   OR inAccountId   = 0)
       AND (DefermentPaymentOLAPTable.JuridicalId = inJuridicalId OR inJuridicalId = 0)
     ;


     -- добавляем строки
     INSERT INTO DefermentPaymentOLAPTable (ContainerId, OperDate, StartContractDate
                                          , AccountId, JuridicalId, PartnerId, BranchId, PaidKindId, ContractId
                                          , DebtRemains, SaleSumm
                                           )
      SELECT _tmpReport.ContainerId, _tmpReport.OperDate, _tmpReport.StartContractDate
           , _tmpReport.AccountId, _tmpReport.JuridicalId, _tmpReport.PartnerId, _tmpReport.BranchId, _tmpReport.PaidKindId, _tmpReport.ContractId
           , _tmpReport.DebtRemains, _tmpReport.SaleSumm
      FROM _tmpReport
      WHERE _tmpReport.DebtRemains <> 0
         OR _tmpReport.SaleSumm    <> 0
     ;

    -- RAISE EXCEPTION 'Ошибка.<%>', (select count(*) from _tmpReport);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.01.22                                        *
*/

-- тест - 030101 Дебиторы Покупатели  Продукция
-- SELECT * FROM DefermentPaymentOLAPTable JOIN Object ON Object.Id = ContractId where OperDate = '22.01.2022' and PaidKindId = zc_Enum_PaidKind_FirstForm() AND AccountId = 9128
-- SELECT * FROM gpInsert_DefermentPaymentOLAPTable('22.01.2022',  '24.01.2022', 9128, 862910, zfCalc_UserAdmin())
