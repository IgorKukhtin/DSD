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
                                        , ObjectLink_Contract_Juridical.JuridicalId
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
                                                             AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Personal_Unit()
                                                             AND (ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)

                                )
          -- список Container
        , tmpContainer AS (SELECT Container.Id
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
                                  , CASE WHEN MIContainer.OperDate <= inEndDate THEN MIContainer.OperDate ELSE NULL END AS OperDate
                                  , SUM (CASE WHEN MIContainer.OperDate >= inEndDate THEN MIContainer.Amount ELSE 0 END) AS Amount_Debt
                                  , SUM (CASE WHEN MIContainer.OperDate < inEndDate THEN MIContainer.Amount ELSE 0 END)  AS Amount_onDay
                                  , SUM (CASE WHEN MIContainer.OperDate < inEndDate AND MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS Amount_sale
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                               AND MIContainer.OperDate >= (SELECT MIN (tmpContractCondition.StartContractDate) FROM tmpContractCondition)
                            )
        , tmpData AS (SELECT tmpContainer.ContainerId
                           , tmpContainer.AccountId
                           , tmpContainer.ContractId
                           , tmpContainer.JuridicalId
                             -- долг на дату
                           , tmpContainer.Amount - COALESCE (SUM (COALESCE(tmpMIContainer.Amount_Debt, 0)), 0) AS Amount
                      FROM tmpContainer
                           LEFT JOIN tmpMIContainer ON tmpMIContainer.ContainerId = tmpContainer.Id
                                                   AND tmpMIContainer.Amount_Debt <> 0
                      GROUP BY tmpContainer.ContainerId
                             , tmpContainer.ContractId
                             , tmpContainer.JuridicalId
                             , tmpContainer.Amount
                     )
        , tmpData_all AS (SELECT tmpData.ContainerId
                               , tmpContractCondition.ContractId
                               , tmpContractCondition.JuridicalId
                               , tmpContractCondition.OperDate
                               , tmpContractCondition.StartContractDate

                                 -- долг на дату
                               , tmpData.Amount
                               - COALESCE ((SELECT SUM (tmpMIContainer.Amount_Debt)
                                            FROM tmpMIContainer
                                            WHERE tmpMIContainer.ContainerId = tmpData.ContainerId
                                              AND tmpMIContainer.OperDate >= tmpContractCondition.OperDate
                                           ), 0) AS AS DebtRemains

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
               , CLO_PaidKind.ObjectId AS PaidKindId
               , tmpData_all.ContractId
               , tmpData_all.DebtRemains
               , tmpData_all.SaleSumm

          FROM tmpData_all
               INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                              ON CLO_PaidKind.ContainerId = tmpData_all.ContainerId
                                             AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
          ;


          -- Обновляем те записи которые уже есть в таблице
          UPDATE DefermentPaymentOLAPTable
           SET OperDate                  = tmp.OperDate
             , UnitId                    = tmp.UnitId
             , GoodsId                   = tmp.GoodsId
             , GoodsKindId               = tmp.GoodsKindId
             , AmountStart               = tmp.AmountStart
             , AmountEnd                 = tmp.AmountEnd
             , AmountIncome              = tmp.AmountIncome
             , AmountReturnOut           = tmp.AmountReturnOut
             , AmountSendIn              = tmp.AmountSendIn
             , AmountSendOut             = tmp.AmountSendOut
             , AmountSendOnPriceIn       = tmp.AmountSendOnPriceIn
             , AmountSendOnPriceOut      = tmp.AmountSendOnPriceOut
             , AmountSendOnPriceOut_10900= tmp.AmountSendOnPriceOut_10900
             , AmountSendOnPrice_10500   = tmp.AmountSendOnPrice_10500
             , AmountSendOnPrice_40200   = tmp.AmountSendOnPrice_40200
             , AmountSale                = tmp.AmountSale
             , AmountSale_10500          = tmp.AmountSale_10500
             , AmountSale_40208          = tmp.AmountSale_40208
             , AmountSaleReal            = tmp.AmountSaleReal
             , AmountSaleReal_10500      = tmp.AmountSaleReal_10500
             , AmountSaleReal_40208      = tmp.AmountSaleReal_40208
             , AmountReturnIn            = tmp.AmountReturnIn
             , AmountReturnIn_40208      = tmp.AmountReturnIn_40208
             , AmountReturnInReal        = tmp.AmountReturnInReal
             , AmountReturnInReal_40208  = tmp.AmountReturnInReal_40208
             , AmountLoss                = tmp.AmountLoss
             , AmountInventory           = tmp.AmountInventory
             , AmountProductionIn        = tmp.AmountProductionIn
             , AmountProductionOut       = tmp.AmountProductionOut
          FROM _tmpReport AS tmp
          WHERE tmp.GoodsId     = DefermentPaymentOLAPTable.GoodsId
            AND tmp.GoodsKindId = DefermentPaymentOLAPTable.GoodsKindId
            AND tmp.UnitId      = DefermentPaymentOLAPTable.UnitId
            AND tmp.OperDate    = DefermentPaymentOLAPTable.OperDate;

     -- добавляем новые строки
     INSERT INTO DefermentPaymentOLAPTable (OperDate, UnitId, GoodsId, GoodsKindId, AmountStart, AmountEnd, AmountIncome, AmountReturnOut, AmountSendIn, AmountSendOut
                                , AmountSendOnPriceIn, AmountSendOnPriceOut, AmountSendOnPriceOut_10900, AmountSendOnPrice_10500, AmountSendOnPrice_40200
                                , AmountSale, AmountSale_10500, AmountSale_40208, AmountSaleReal, AmountSaleReal_10500, AmountSaleReal_40208
                                , AmountReturnIn, AmountReturnIn_40208, AmountReturnInReal, AmountReturnInReal_40208
                                , AmountLoss, AmountInventory, AmountProductionIn, AmountProductionOut)
      SELECT tmp.OperDate
           , tmp.UnitId
           , tmp.GoodsId
           , tmp.GoodsKindId
           , tmp.AmountStart
           , tmp.AmountEnd
           , tmp.AmountIncome
           , tmp.AmountReturnOut
           , tmp.AmountSendIn
           , tmp.AmountSendOut
           , tmp.AmountSendOnPriceIn
           , tmp.AmountSendOnPriceOut
           , tmp.AmountSendOnPriceOut_10900
           , tmp.AmountSendOnPrice_10500
           , tmp.AmountSendOnPrice_40200
           , tmp.AmountSale
           , tmp.AmountSale_10500
           , tmp.AmountSale_40208
           , tmp.AmountSaleReal
           , tmp.AmountSaleReal_10500
           , tmp.AmountSaleReal_40208
           , tmp.AmountReturnIn
           , tmp.AmountReturnIn_40208
           , tmp.AmountReturnInReal
           , tmp.AmountReturnInReal_40208
           , tmp.AmountLoss
           , tmp.AmountInventory
           , tmp.AmountProductionIn
           , tmp.AmountProductionOut
      FROM _tmpReport AS tmp
           LEFT JOIN DefermentPaymentOLAPTable ON tmp.GoodsId     = DefermentPaymentOLAPTable.GoodsId
                                     AND tmp.GoodsKindId = DefermentPaymentOLAPTable.GoodsKindId
                                     AND tmp.UnitId      = DefermentPaymentOLAPTable.UnitId
                                     AND tmp.OperDate    = DefermentPaymentOLAPTable.OperDate
      WHERE DefermentPaymentOLAPTable.GoodsId IS NULL
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.08.19         *
*/

-- тест
-- select * from DefermentPaymentOLAPTable where DefermentPaymentOLAPTable.OperDate = '02.08.2019'

--select * from gpInsert_DefermentPaymentOLAPTable('01.08.2019',  '03.08.2019', 8459, '3')