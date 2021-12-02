-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS lpReport_JuridicalDefermentPayment22 (TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpReport_JuridicalDefermentPayment22(
    IN inOperDate         TDateTime , -- 
    IN inEmptyParam       TDateTime , -- 
    IN inStartDate_sale   TDateTime , -- 
    IN inEndDate_sale     TDateTime , --
    IN inAccountId        Integer   , --
    IN inPaidKindId       Integer   , --
    IN inBranchId         Integer   , --
    IN inJuridicalGroupId Integer   , --
    IN inUserId           Integer    -- сессия пользователя
)
RETURNS TABLE (AccountId Integer, AccountName TVarChar, JuridicalId Integer, JuridicalName TVarChar, RetailName TVarChar, RetailName_main TVarChar, OKPO TVarChar, JuridicalGroupName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar
             , ContractTagGroupName TVarChar, ContractTagName TVarChar, ContractStateKindCode Integer
             , ContractJuridicalDocId Integer, ContractJuridicalDocCode Integer, ContractJuridicalDocName TVarChar
             , PersonalName TVarChar
             , PersonalTradeName TVarChar
             , PersonalCollationName TVarChar
             , PersonalTradeName_Partner TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , DebetRemains TFloat, KreditRemains TFloat
             , SaleSumm TFloat, DefermentPaymentRemains TFloat
             , SaleSumm1 TFloat, SaleSumm2 TFloat, SaleSumm3 TFloat, SaleSumm4 TFloat, SaleSumm5 TFloat
             , Condition TVarChar, StartContractDate TDateTime, Remains TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AreaName TVarChar, AreaName_Partner TVarChar
             , BranchName_personal       TVarChar
             , BranchName_personal_trade TVarChar
             , PaymentDate TDateTime
             , PaymentAmount TFloat
              )
AS
$BODY$
   DECLARE vbLenght Integer;
BEGIN
 
  WITH
   --выбираем все юр.лица и договора
    tmpJuridical AS (SELECT tmpJuridical.JuridicalId
                          , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                     FROM
                         (SELECT Object_Juridical.Id AS JuridicalId
                          FROM Object AS Object_Juridical
                          WHERE Object_Juridical.DescId = zc_Object_Juridical()
                           AND Object_Juridical.isErased = FALSE
                           ) AS tmpJuridical
                         JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                         ON ObjectLink_Contract_Juridical.ChildObjectId = tmpJuridical.JuridicalId
                                        AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
                         -- убрали Удаленные
                         JOIN Object AS Object_Contract
                                     ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                    AND Object_Contract.isErased = FALSE
                         -- убрали Закрытые
                         LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                              ON ObjectLink_Contract_ContractStateKind.ObjectId      = ObjectLink_Contract_Juridical.ObjectId
                                             AND ObjectLink_Contract_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind()
                                             AND ObjectLink_Contract_ContractStateKind.ChildObjectId = zc_Enum_ContractStateKind_Close()
                     -- убрали Закрытые
                     WHERE ObjectLink_Contract_ContractStateKind.ChildObjectId IS NULL
                     )


   --находим последнии оплаты за 1 месяц
   , tmpLastPayment1 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.AccountId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   , Container.ObjectId     AS AccountId
                                   , (-1 * MIContainer.Amount) AS Amount
                                   , MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId) AS OperDate_max
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                       
                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId
                                               FROM tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN '01.11.2021' AND '02.12.2021'
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.OperDate = tmp.OperDate_max
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.AccountId
                        )
   -- по которым нет данных за 1 месяц в tmpLastPayment1
   , tmpJuridical_2 AS (select tmpJuridical.* 
                        from tmpJuridical
                             LEFT JOIN tmpLastPayment1 ON tmpLastPayment1.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment1.ContractId = tmpJuridical.ContractId
                        WHERE tmpLastPayment1.JuridicalId IS NULL
                       )

   --находим последнии оплаты за 2 месяца (
   , tmpLastPayment2 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.AccountId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   , Container.ObjectId     AS AccountId
                                   , (-1 * MIContainer.Amount) AS Amount
                                   , MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId) AS OperDate_max
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                       
                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId
                                               FROM tmpJuridical_2 AS tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN '01.08.2021' AND '31.10.2021'
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.OperDate = tmp.OperDate_max
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.AccountId
                        )
   -- по которым нет данных за 3 месяц в tmpLastPayment1 и tmpLastPayment2
   , tmpJuridical_3 AS (select tmpJuridical.* 
                        from tmpJuridical_2 AS tmpJuridical
                             LEFT JOIN tmpLastPayment2 ON tmpLastPayment2.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment2.ContractId = tmpJuridical.ContractId
                        WHERE tmpLastPayment2.JuridicalId IS NULL
                       )


---
   --находим последнии оплаты за 6 месяца (
   , tmpLastPayment3 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.AccountId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   , Container.ObjectId     AS AccountId
                                   , (-1 * MIContainer.Amount) AS Amount
                                   , MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId) AS OperDate_max
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                       
                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId
                                               FROM tmpJuridical_3 AS tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN '01.01.2020' AND '31.07.2021'
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.OperDate = tmp.OperDate_max
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.AccountId
                        )
   -- по которым нет данных за 3 месяц в tmpLastPayment1 и tmpLastPayment2
   , tmpJuridical_4 AS (select tmpJuridical.* 
                        from tmpJuridical_3 AS tmpJuridical
                             LEFT JOIN tmpLastPayment3 ON tmpLastPayment3.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment3.ContractId = tmpJuridical.ContractId
                        WHERE tmpLastPayment3.JuridicalId IS NULL
                       )

     select tmpJuridical.JuridicalId
, tmpJuridical.ContractId
, COALESCE (tmpLastPayment1.OperDate, tmpLastPayment2.OperDate, tmpLastPayment3.OperDate) AS OperDate
, COALESCE (tmpLastPayment1.Amount, tmpLastPayment2.Amount, tmpLastPayment3.Amount) AS Amount
      from tmpJuridical
                             LEFT JOIN tmpLastPayment1 ON tmpLastPayment1.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment1.ContractId = tmpJuridical.ContractId
                             LEFT JOIN tmpLastPayment2 ON tmpLastPayment2.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment2.ContractId = tmpJuridical.ContractId
                             LEFT JOIN tmpLastPayment3 ON tmpLastPayment3.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment3.ContractId = tmpJuridical.ContractId
WHERE COALESCE (tmpLastPayment1.Amount, tmpLastPayment2.Amount, tmpLastPayment3.Amount) <> 0
                        

;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.12.21         *
*/

-- тест
-- SELECT * FROM lpReport_JuridicalDefermentPayment22 (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inStartDate_sale:= CURRENT_DATE, inEndDate_sale:= CURRENT_DATE, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_SecondForm(), inBranchId:= 0, inJuridicalGroupId:= null, inUserId:= 5);
SELECT * FROM lpReport_JuridicalDefermentPayment22 (inOperDate:= CURRENT_DATE, inEmptyParam:= NULL :: TDateTime, inStartDate_sale:= '01.11.2021', inEndDate_sale:= '30.11.2021', inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_SecondForm(), inBranchId:= 0, inJuridicalGroupId:= 0, inUserId:= 5);
