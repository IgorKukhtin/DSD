-- Function: gpInsert_JuridicalDefermentPayment()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalDefermentPayment (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalDefermentPayment(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inSession          TVarChar    -- сесси€ пользовател€
)
RETURNS VOID
AS
$BODY$
   DECLARE vbStartDate1 TDateTime;--нач. 1 период - 1 мес€ц
   DECLARE vbStartDate2 TDateTime;--нач. 2 период - 2 мес€ц
   DECLARE vbStartDate3 TDateTime;--нач. 3 период - 1 год
   DECLARE vbStartDate4 TDateTime;--нач. 4 период - нач.дата inStartDate
   DECLARE vbEndDate1 TDateTime;  --оконч. 1 период - 1 мес€ц 
   DECLARE vbEndDate2 TDateTime;  --оконч. 2 период -2 мес€ц назад
   DECLARE vbEndDate3 TDateTime;  --оконч. 3 период -1 год назад
   DECLARE vbEndDate4 TDateTime;  --оконч. 4 период -

   DECLARE vbUserId Integer;
BEGIN

   vbUserId:= lpGetUserBySession (inSession);

   -- последние данные мин за мес€ц обновл€ем
   vbStartDate1 := DATE_TRUNC ('MONTH', inEndDate) - INTERVAL '1 MONTH';  
   vbEndDate1   := inEndDate;
   
   vbStartDate2 := CASE WHEN vbStartDate1 <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE vbStartDate1 - INTERVAL '2 MONTH' END;
   vbEndDate2   := CASE WHEN vbStartDate1 <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE vbStartDate1 - INTERVAL '1 DAY' END;
   
   vbStartDate3 := CASE WHEN vbStartDate1 - INTERVAL '2 MONTH' <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE vbStartDate2 - INTERVAL '1 YEAR' END;
   vbEndDate3   := CASE WHEN vbStartDate1 - INTERVAL '2 MONTH' <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE vbStartDate2 - INTERVAL '1 DAY' END;
   
   vbStartDate4 := CASE WHEN vbStartDate2 - INTERVAL '1 YEAR' <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE inStartDate END;
   vbEndDate4   := CASE WHEN vbStartDate2 - INTERVAL '1 YEAR' <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE vbStartDate3 - INTERVAL '1 DAY' END;   

 --RAISE EXCEPTION 'ќшибка.ƒокумент 1 c <%> по <%>  /// 2 с  <%> по <%> ///3 с  <%> по <%> 4 с  <%> по <%>.', vbStartDate1,vbEndDate1 , vbStartDate2,vbEndDate2, vbStartDate3,vbEndDate3, vbStartDate4,vbEndDate4;
  
  
  --ключ  ContractId  + JuridicalId + PaidKindId + PartnerId
  
  CREATE TEMP TABLE _tmpData (JuridicalId Integer, ContractId Integer, PaidKindId Integer, PartnerId Integer, OperDate TDateTime, Amount TFloat, OperDateIn TDateTime, AmountIn TFloat) ON COMMIT DROP;
  INSERT INTO _tmpData (JuridicalId, ContractId, PaidKindId, PartnerId, OperDate, Amount, OperDateIn, AmountIn)
  WITH
    --поставщики
    tmpPost AS (SELECT lfSelect_Object_Juridical_byGroup.JuridicalId FROM lfSelect_Object_Juridical_byGroup (8357 ) AS lfSelect_Object_Juridical_byGroup)

   --выбираем все юр.лица и договора
  , tmpJuridical AS (SELECT tmpJuridical.JuridicalId
                          , ObjectLink_Contract_Juridical.ObjectId     AS ContractId
                          , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId
                          , tmpJuridical.isIncome
                     FROM
                         (SELECT Object_Juridical.Id AS JuridicalId
                               , CASE WHEN tmpPost.JuridicalId IS NULL THEN FALSE ELSE TRUE END AS isIncome -- поставщики
                          FROM Object AS Object_Juridical
                               LEFT JOIN tmpPost ON tmpPost.JuridicalId = Object_Juridical.Id
                          WHERE Object_Juridical.DescId = zc_Object_Juridical()
                           AND Object_Juridical.isErased = FALSE
                           ) AS tmpJuridical
                         JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                         ON ObjectLink_Contract_Juridical.ChildObjectId = tmpJuridical.JuridicalId
                                        AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
                         -- убрали ”даленные
                         JOIN Object AS Object_Contract
                                     ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                    AND Object_Contract.isErased = FALSE

                         LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                              ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                             AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                           
                         -- убрали «акрытые
                         LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                              ON ObjectLink_Contract_ContractStateKind.ObjectId      = ObjectLink_Contract_Juridical.ObjectId
                                             AND ObjectLink_Contract_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind()
                                             AND ObjectLink_Contract_ContractStateKind.ChildObjectId = zc_Enum_ContractStateKind_Close()
                     -- убрали «акрытые
                     WHERE ObjectLink_Contract_ContractStateKind.ChildObjectId IS NULL
                     )


   --находим последнии оплаты за 1 мес€ц
   , tmpLastPayment1 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.PaidKindId
                             , tmp.PartnerId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId          AS JuridicalId
                                   , CLO_Contract.ObjectId           AS ContractId
                                   , CLO_PaidKind.ObjectId   AS PaidKindId
                                   , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS PartnerId
                                   , CASE WHEN tmpJuridical.isIncome = FALSE AND MIContainer.isActive = FALSE THEN (-1 * MIContainer.Amount)
                                          WHEN tmpJuridical.isIncome = TRUE THEN MIContainer.Amount
                                          ELSE 0 END AS Amount 
                                   --, MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId)       AS OperDate_max
                                   , ROW_NUMBER () OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId ORDER BY MIContainer.OperDate desc, MIContainer.MovementId desc) AS Ord
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()

                                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                                 AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId, tmpJuridical.isIncome, tmpJuridical.PaidKindId
                                               FROM tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 
                                                              AND tmpJuridical.PaidKindId = CLO_PaidKind.ObjectId

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate1 AND vbEndDate1
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                              ) as tmp
                        WHERE tmp.Ord = 1 --tmp.OperDate = tmp.OperDate_max
                          AND COALESCE (tmp.Amount,0) <> 0
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.PaidKindId
                               , tmp.PartnerId
                        )

   -- по которым нет данных за 1 мес€ц в tmpLastPayment1
   , tmpJuridical_2 AS (select tmpJuridical.* 
                        from tmpJuridical
                             LEFT JOIN tmpLastPayment1 ON tmpLastPayment1.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment1.ContractId = tmpJuridical.ContractId
                                                      AND tmpLastPayment1.PaidKindId = tmpJuridical.PaidKindId
                        WHERE tmpLastPayment1.JuridicalId IS NULL
                       )

   --находим последнии оплаты за 2 мес€ца (
   , tmpLastPayment2 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.PaidKindId
                             , tmp.PartnerId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   , CLO_PaidKind.ObjectId   AS PaidKindId
                                   , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS PartnerId
                                   , CASE WHEN tmpJuridical.isIncome = FALSE AND MIContainer.isActive = FALSE THEN (-1 * MIContainer.Amount)
                                          WHEN tmpJuridical.isIncome = TRUE THEN MIContainer.Amount
                                          ELSE 0 END AS Amount
                                   --, MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId)       AS OperDate_max
                                   , ROW_NUMBER () OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId ORDER BY MIContainer.OperDate desc, MIContainer.MovementId desc) AS Ord
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()

                                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                                 AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId, tmpJuridical.isIncome, tmpJuridical.PaidKindId
                                               FROM tmpJuridical_2 AS tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 
                                                              AND tmpJuridical.PaidKindId = CLO_PaidKind.ObjectId

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate2 AND vbEndDate2
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.Ord = 1 --tmp.OperDate = tmp.OperDate_max
                          AND COALESCE (tmp.Amount,0) <> 0
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.PaidKindId
                               , tmp.PartnerId
                        )
   -- по которым нет данных за 3 мес€ц в tmpLastPayment1 и tmpLastPayment2
   , tmpJuridical_3 AS (SELECT tmpJuridical.* 
                        FROM tmpJuridical_2 AS tmpJuridical
                             LEFT JOIN tmpLastPayment2 ON tmpLastPayment2.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment2.ContractId = tmpJuridical.ContractId
                                                      AND tmpLastPayment2.PaidKindId = tmpJuridical.PaidKindId
                        WHERE tmpLastPayment2.JuridicalId IS NULL
                       )


---
   --находим последнии оплаты за 12 мес€цев (
   , tmpLastPayment3 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.PaidKindId
                             , tmp.PartnerId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   , CLO_PaidKind.ObjectId   AS PaidKindId
                                   , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS PartnerId
                                   , CASE WHEN tmpJuridical.isIncome = FALSE AND MIContainer.isActive = FALSE THEN (-1 * MIContainer.Amount)
                                          WHEN tmpJuridical.isIncome = TRUE THEN MIContainer.Amount
                                          ELSE 0 END AS Amount
                                   --, MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId)       AS OperDate_max
                                   , ROW_NUMBER () OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId ORDER BY MIContainer.OperDate desc, MIContainer.MovementId desc) AS Ord
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()

                                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                                 AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId, tmpJuridical.isIncome, tmpJuridical.PaidKindId
                                               FROM tmpJuridical_3 AS tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 
                                                              AND tmpJuridical.PaidKindId = CLO_PaidKind.ObjectId

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate3 AND vbEndDate3
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.Ord = 1 --tmp.OperDate = tmp.OperDate_max
                          AND COALESCE (tmp.Amount,0) <> 0
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.PaidKindId
                               , tmp.PartnerId
                        )

   -- по которым нет данных за 12 мес€цев в tmpLastPayment1 и tmpLastPayment2
   , tmpJuridical_4 AS (select tmpJuridical.* 
                        from tmpJuridical_3 AS tmpJuridical
                             LEFT JOIN tmpLastPayment3 ON tmpLastPayment3.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment3.ContractId = tmpJuridical.ContractId
                                                      AND tmpLastPayment3.PaidKindId = tmpJuridical.PaidKindId
                        WHERE tmpLastPayment3.JuridicalId IS NULL
                       )

   --находим последнии оплаты за 12 мес€цев (
   , tmpLastPayment4 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.PaidKindId
                             , tmp.PartnerId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   , CLO_PaidKind.ObjectId   AS PaidKindId
                                   , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS PartnerId
                                   , CASE WHEN tmpJuridical.isIncome = FALSE AND MIContainer.isActive = FALSE THEN (-1 * MIContainer.Amount)
                                          WHEN tmpJuridical.isIncome = TRUE THEN MIContainer.Amount
                                          ELSE 0 END AS Amount

                                   --, MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId)       AS OperDate_max
                                   , ROW_NUMBER () OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId ORDER BY MIContainer.OperDate desc, MIContainer.MovementId desc) AS Ord
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()

                                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                                 AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId, tmpJuridical.isIncome, tmpJuridical.PaidKindId
                                               FROM tmpJuridical_4 AS tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 
                                                              AND tmpJuridical.PaidKindId = CLO_PaidKind.ObjectId 

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate4 AND vbEndDate4
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                              ) as tmp
                        WHERE tmp.Ord = 1 --tmp.OperDate = tmp.OperDate_max
                          AND COALESCE (tmp.Amount,0) <> 0
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.PaidKindId
                               , tmp.PartnerId
                        )    

   /* **************************** */
   --как и в случае оплат ищем част€ми последнии приходы
   --находим последнии оплаты за 1 мес€ц
   , tmpLastIncome1 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.PaidKindId
                             , tmp.PartnerId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId          AS JuridicalId
                                   , CLO_Contract.ObjectId           AS ContractId
                                   , CLO_PaidKind.ObjectId   AS PaidKindId
                                   , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS PartnerId
                                   , SUM ( -1 * MIContainer.Amount) AS Amount 
                                   /*, SUM (CASE WHEN tmpJuridical.isIncome = FALSE AND MIContainer.isActive = FALSE THEN (-1 * MIContainer.Amount)
                                          WHEN tmpJuridical.isIncome = TRUE THEN MIContainer.Amount
                                          ELSE 0 END) AS Amount */
                                   --, MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId)       AS OperDate_max
                                   , ROW_NUMBER () OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId ORDER BY MIContainer.OperDate desc, MIContainer.MovementId desc) AS Ord
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()

                                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                                 AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId, tmpJuridical.isIncome, tmpJuridical.PaidKindId
                                               FROM tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 
                                                              AND tmpJuridical.PaidKindId = CLO_PaidKind.ObjectId

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Income())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate1 AND vbEndDate1
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                              GROUP BY MIContainer.OperDate
                                     , CLO_Juridical.ObjectId        
                                     , CLO_Contract.ObjectId          
                                     , CLO_PaidKind.ObjectId  
                                     , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END 
                                     , MIContainer.MovementId
                              ) as tmp
                        WHERE tmp.Ord = 1 --tmp.OperDate = tmp.OperDate_max
                          AND COALESCE (tmp.Amount,0) <> 0
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.PaidKindId
                               , tmp.PartnerId
                        )

   -- по которым нет данных за 1 мес€ц в tmpLastIncome1
   , tmpJuridical_2in AS (SELECT tmpJuridical.* 
                          FROM tmpJuridical
                               LEFT JOIN tmpLastIncome1 ON tmpLastIncome1.JuridicalId = tmpJuridical.JuridicalId
                                                       AND tmpLastIncome1.ContractId = tmpJuridical.ContractId
                                                       AND tmpLastIncome1.PaidKindId = tmpJuridical.PaidKindId
                          WHERE tmpLastIncome1.JuridicalId IS NULL
                         )

   --находим последнии оплаты за 2 мес€ца (
   , tmpLastIncome2 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.PaidKindId
                             , tmp.PartnerId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   , CLO_PaidKind.ObjectId   AS PaidKindId
                                   , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS PartnerId
                                   , SUM ( -1 * MIContainer.Amount) AS Amount 
                                   /*, SUM (CASE WHEN tmpJuridical.isIncome = FALSE AND MIContainer.isActive = FALSE THEN (-1 * MIContainer.Amount)
                                          WHEN tmpJuridical.isIncome = TRUE THEN MIContainer.Amount
                                          ELSE 0 END) AS Amount */
                                   --, MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId)       AS OperDate_max
                                   , ROW_NUMBER () OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId ORDER BY MIContainer.OperDate desc, MIContainer.MovementId desc) AS Ord
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()

                                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                                 AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId, tmpJuridical.isIncome, tmpJuridical.PaidKindId
                                               FROM tmpJuridical_2in AS tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 
                                                              AND tmpJuridical.PaidKindId = CLO_PaidKind.ObjectId

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Income())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate2 AND vbEndDate2
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                              GROUP BY MIContainer.OperDate
                                     , CLO_Juridical.ObjectId        
                                     , CLO_Contract.ObjectId          
                                     , CLO_PaidKind.ObjectId  
                                     , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END 
                                     , MIContainer.MovementId
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.Ord = 1 --tmp.OperDate = tmp.OperDate_max
                          AND COALESCE (tmp.Amount,0) <> 0
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.PaidKindId
                               , tmp.PartnerId
                        )
   -- по которым нет данных за 3 мес€ц в tmpLastIncome1 и tmpLastIncome2
   , tmpJuridical_3in AS (SELECT tmpJuridical.* 
                        FROM tmpJuridical_2in AS tmpJuridical
                             LEFT JOIN tmpLastIncome2 ON tmpLastIncome2.JuridicalId = tmpJuridical.JuridicalId
                                                     AND tmpLastIncome2.ContractId = tmpJuridical.ContractId
                                                     AND tmpLastIncome2.PaidKindId = tmpJuridical.PaidKindId
                        WHERE tmpLastIncome2.JuridicalId IS NULL
                       )


---
   --находим последнии оплаты за 12 мес€цев (
   , tmpLastIncome3 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.PaidKindId
                             , tmp.PartnerId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   , CLO_PaidKind.ObjectId   AS PaidKindId
                                   , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS PartnerId
                                   , SUM ( -1 * MIContainer.Amount) AS Amount 
                                   /*, SUM (CASE WHEN tmpJuridical.isIncome = FALSE AND MIContainer.isActive = FALSE THEN (-1 * MIContainer.Amount)
                                          WHEN tmpJuridical.isIncome = TRUE THEN MIContainer.Amount
                                          ELSE 0 END) AS Amount */
                                   --, MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId)       AS OperDate_max
                                   , ROW_NUMBER () OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId ORDER BY MIContainer.OperDate desc, MIContainer.MovementId desc) AS Ord
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()

                                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                                 AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId, tmpJuridical.isIncome, tmpJuridical.PaidKindId
                                               FROM tmpJuridical_3in AS tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 
                                                              AND tmpJuridical.PaidKindId = CLO_PaidKind.ObjectId

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Income())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate3 AND vbEndDate3
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
                              GROUP BY MIContainer.OperDate
                                     , CLO_Juridical.ObjectId        
                                     , CLO_Contract.ObjectId          
                                     , CLO_PaidKind.ObjectId  
                                     , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END 
                                     , MIContainer.MovementId
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.Ord = 1 --tmp.OperDate = tmp.OperDate_max
                          AND COALESCE (tmp.Amount,0) <> 0
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.PaidKindId
                               , tmp.PartnerId
                        )

   -- по которым нет данных за 12 мес€цев в tmpLastIncome1 и tmpLastIncome2
   , tmpJuridical_4in AS (select tmpJuridical.* 
                        from tmpJuridical_3in AS tmpJuridical
                             LEFT JOIN tmpLastIncome3 ON tmpLastIncome3.JuridicalId = tmpJuridical.JuridicalId
                                                     AND tmpLastIncome3.ContractId = tmpJuridical.ContractId
                                                     AND tmpLastIncome3.PaidKindId = tmpJuridical.PaidKindId
                        WHERE tmpLastIncome3.JuridicalId IS NULL
                       )

   --находим последнии оплаты за 12 мес€цев (
   , tmpLastIncome4 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.PaidKindId
                             , tmp.PartnerId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   , CLO_PaidKind.ObjectId   AS PaidKindId
                                   , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS PartnerId
                                   , SUM ( -1 * MIContainer.Amount) AS Amount 
                                   /*, SUM (CASE WHEN tmpJuridical.isIncome = FALSE AND MIContainer.isActive = FALSE THEN (-1 * MIContainer.Amount)
                                          WHEN tmpJuridical.isIncome = TRUE THEN MIContainer.Amount
                                          ELSE 0 END) AS Amount */

                                   --, MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId)       AS OperDate_max
                                   , ROW_NUMBER () OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId ORDER BY MIContainer.OperDate desc, MIContainer.MovementId desc) AS Ord
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()

                                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                                 AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId, tmpJuridical.isIncome, tmpJuridical.PaidKindId
                                               FROM tmpJuridical_4in AS tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 
                                                              AND tmpJuridical.PaidKindId = CLO_PaidKind.ObjectId 

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Income())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate4 AND vbEndDate4
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
                              GROUP BY MIContainer.OperDate
                                     , CLO_Juridical.ObjectId        
                                     , CLO_Contract.ObjectId          
                                     , CLO_PaidKind.ObjectId  
                                     , CASE WHEN CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() THEN MIContainer.ObjectId_Analyzer ELSE 0 END 
                                     , MIContainer.MovementId
                              ) as tmp
                        WHERE tmp.Ord = 1 --tmp.OperDate = tmp.OperDate_max
                          AND COALESCE (tmp.Amount,0) <> 0
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               , tmp.PaidKindId
                               , tmp.PartnerId
                        )
   , tmpLastPayment AS (SELECT tmpJuridical.JuridicalId
                                , tmpJuridical.ContractId
                                , COALESCE (tmpLastPayment1.PaidKindId, tmpLastPayment2.PaidKindId, tmpLastPayment3.PaidKindId, tmpLastPayment4.PaidKindId)  AS PaidKindId
                                , COALESCE (tmpLastPayment1.PartnerId, tmpLastPayment2.PartnerId, tmpLastPayment3.PartnerId, tmpLastPayment4.PartnerId)      AS PartnerId
                                , COALESCE (tmpLastPayment1.OperDate, tmpLastPayment2.OperDate, tmpLastPayment3.OperDate, tmpLastPayment4.OperDate)          AS OperDate
                                , COALESCE (tmpLastPayment1.Amount, tmpLastPayment2.Amount, tmpLastPayment3.Amount, tmpLastPayment4.Amount)                  AS Amount
                           FROM tmpJuridical
                                LEFT JOIN tmpLastPayment1 ON tmpLastPayment1.JuridicalId = tmpJuridical.JuridicalId
                                                         AND tmpLastPayment1.ContractId = tmpJuridical.ContractId
                                LEFT JOIN tmpLastPayment2 ON tmpLastPayment2.JuridicalId = tmpJuridical.JuridicalId
                                                         AND tmpLastPayment2.ContractId = tmpJuridical.ContractId
                                LEFT JOIN tmpLastPayment3 ON tmpLastPayment3.JuridicalId = tmpJuridical.JuridicalId
                                                         AND tmpLastPayment3.ContractId = tmpJuridical.ContractId
                                LEFT JOIN tmpLastPayment4 ON tmpLastPayment4.JuridicalId = tmpJuridical.JuridicalId
                                                         AND tmpLastPayment4.ContractId = tmpJuridical.ContractId
                           WHERE COALESCE (tmpLastPayment1.Amount, tmpLastPayment2.Amount, tmpLastPayment3.Amount, tmpLastPayment4.Amount) <> 0
                           ) 
   , tmpLastIncome AS (SELECT tmpJuridical.JuridicalId
                            , tmpJuridical.ContractId
                            , COALESCE (tmpLastIncome1.PaidKindId, tmpLastIncome2.PaidKindId, tmpLastIncome3.PaidKindId, tmpLastIncome4.PaidKindId)  AS PaidKindId
                            , COALESCE (tmpLastIncome1.PartnerId, tmpLastIncome2.PartnerId, tmpLastIncome3.PartnerId, tmpLastIncome4.PartnerId)      AS PartnerId
                            , COALESCE (tmpLastIncome1.OperDate, tmpLastIncome2.OperDate, tmpLastIncome3.OperDate, tmpLastIncome4.OperDate)          AS OperDate
                            , COALESCE (tmpLastIncome1.Amount, tmpLastIncome2.Amount, tmpLastIncome3.Amount, tmpLastIncome4.Amount)                  AS Amount
                       FROM tmpJuridical
                            LEFT JOIN tmpLastIncome1 ON tmpLastIncome1.JuridicalId = tmpJuridical.JuridicalId
                                                    AND tmpLastIncome1.ContractId = tmpJuridical.ContractId
                            LEFT JOIN tmpLastIncome2 ON tmpLastIncome2.JuridicalId = tmpJuridical.JuridicalId
                                                    AND tmpLastIncome2.ContractId = tmpJuridical.ContractId
                            LEFT JOIN tmpLastIncome3 ON tmpLastIncome3.JuridicalId = tmpJuridical.JuridicalId
                                                    AND tmpLastIncome3.ContractId = tmpJuridical.ContractId
                            LEFT JOIN tmpLastIncome4 ON tmpLastIncome4.JuridicalId = tmpJuridical.JuridicalId
                                                    AND tmpLastIncome4.ContractId = tmpJuridical.ContractId
                       WHERE COALESCE (tmpLastIncome1.Amount, tmpLastIncome2.Amount, tmpLastIncome3.Amount, tmpLastIncome4.Amount) <> 0
                       )
---
     --результат
     SELECT COALESCE (tmpLastPayment.JuridicalId, tmpLastIncome.JuridicalId)   AS JuridicalId
          , COALESCE (tmpLastPayment.ContractId, tmpLastIncome.ContractId)     AS ContractId
          , COALESCE (tmpLastPayment.PaidKindId, tmpLastIncome.PaidKindId)     AS PaidKindId
          , COALESCE (tmpLastPayment.PartnerId, tmpLastIncome.PartnerId)       AS PartnerId
          , tmpLastPayment.OperDate
          , tmpLastPayment.Amount
          --
          , tmpLastIncome.OperDate AS OperDateIn
          , tmpLastIncome.Amount   AS AmountIn
     FROM tmpLastPayment
        FULL JOIN tmpLastIncome ON tmpLastIncome.JuridicalId = tmpLastPayment.JuridicalId
                               AND tmpLastIncome.ContractId  = tmpLastPayment.ContractId
                               AND tmpLastIncome.PaidKindId  = tmpLastPayment.PaidKindId
                               AND tmpLastIncome.PartnerId   = tmpLastPayment.PartnerId
   
        ;

 --сохраненные данные
 CREATE TEMP TABLE _tmpObject (Id Integer, JuridicalId Integer, ContractId Integer, PaidKindId Integer, PartnerId Integer, OperDate TDateTime, Amount TFloat, OperDateIn TDateTime, AmountIn TFloat) ON COMMIT DROP;
  INSERT INTO _tmpObject (Id, JuridicalId, ContractId, PaidKindId, PartnerId, OperDate, Amount, OperDateIn, AmountIn)
  
  SELECT Object_JuridicalDefermentPayment.Id
       , ObjectLink_JuridicalDefermentPayment_Juridical.ChildObjectId AS JuridicalId
       , ObjectLink_JuridicalDefermentPayment_Contract.ChildObjectId  AS ContractId
       , ObjectLink_JuridicalDefermentPayment_PaidKind.ChildObjectId  AS PaidKindId
       , ObjectLink_JuridicalDefermentPayment_Partner.ChildObjectId   AS PartnerId
       , ObjectDate_JuridicalDefermentPayment_OperDate.ValueData      AS OperDate
       , ObjectFloat_JuridicalDefermentPayment_Amount.ValueData       AS Amount
       , ObjectDate_JuridicalDefermentPayment_OperDateIn.ValueData    AS OperDateIn
       , ObjectFloat_JuridicalDefermentPayment_AmountIn.ValueData     AS AmountIn
  FROM Object AS Object_JuridicalDefermentPayment
        LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_Juridical
                             ON ObjectLink_JuridicalDefermentPayment_Juridical.ObjectId = Object_JuridicalDefermentPayment.Id
                            AND ObjectLink_JuridicalDefermentPayment_Juridical.DescId = zc_ObjectLink_JuridicalDefermentPayment_Juridical()
  
        LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_Contract
                             ON ObjectLink_JuridicalDefermentPayment_Contract.ObjectId = Object_JuridicalDefermentPayment.Id
                            AND ObjectLink_JuridicalDefermentPayment_Contract.DescId = zc_ObjectLink_JuridicalDefermentPayment_Contract()

        LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_PaidKind
                             ON ObjectLink_JuridicalDefermentPayment_PaidKind.ObjectId = Object_JuridicalDefermentPayment.Id
                            AND ObjectLink_JuridicalDefermentPayment_PaidKind.DescId = zc_ObjectLink_JuridicalDefermentPayment_PaidKind()

        LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_Partner
                             ON ObjectLink_JuridicalDefermentPayment_Partner.ObjectId = Object_JuridicalDefermentPayment.Id
                            AND ObjectLink_JuridicalDefermentPayment_Partner.DescId = zc_ObjectLink_JuridicalDefermentPayment_Partner()
   
       LEFT JOIN ObjectDate AS ObjectDate_JuridicalDefermentPayment_OperDate
                            ON ObjectDate_JuridicalDefermentPayment_OperDate.ObjectId = Object_JuridicalDefermentPayment.Id
                           AND ObjectDate_JuridicalDefermentPayment_OperDate.DescId = zc_ObjectDate_JuridicalDefermentPayment_OperDate()

       LEFT JOIN ObjectFloat AS ObjectFloat_JuridicalDefermentPayment_Amount
                             ON ObjectFloat_JuridicalDefermentPayment_Amount.ObjectId = Object_JuridicalDefermentPayment.Id
                            AND ObjectFloat_JuridicalDefermentPayment_Amount.DescId = zc_ObjectFloat_JuridicalDefermentPayment_Amount() 

       LEFT JOIN ObjectDate AS ObjectDate_JuridicalDefermentPayment_OperDateIn
                            ON ObjectDate_JuridicalDefermentPayment_OperDateIn.ObjectId = Object_JuridicalDefermentPayment.Id
                           AND ObjectDate_JuridicalDefermentPayment_OperDateIn.DescId = zc_ObjectDate_JuridicalDefermentPayment_OperDateIn()

       LEFT JOIN ObjectFloat AS ObjectFloat_JuridicalDefermentPayment_AmountIn
                             ON ObjectFloat_JuridicalDefermentPayment_AmountIn.ObjectId = Object_JuridicalDefermentPayment.Id
                            AND ObjectFloat_JuridicalDefermentPayment_AmountIn.DescId = zc_ObjectFloat_JuridicalDefermentPayment_AmountIn()
  WHERE Object_JuridicalDefermentPayment.DescId = zc_Object_JuridicalDefermentPayment()
  ;

 --обновл€ем и + новые данные
 PERFORM lpInsertUpdate_Object_JuridicalDefermentPayment (inId          := COALESCE (_tmpObject.Id,0) ::Integer
                                                        , inJuridicalId := _tmpData.JuridicalId       ::Integer
                                                        , inContractId  := _tmpData.ContractId        ::Integer
                                                        , inPaidKindId  := _tmpData.PaidKindId        ::Integer
                                                        , inPartnerId   := _tmpData.PartnerId         ::Integer
                                                        , inOperDate    := _tmpData.OperDate          ::TDateTime
                                                        , inAmount      := _tmpData.Amount            ::TFloat
                                                        , inOperDateIn  := _tmpData.OperDateIn        ::TDateTime
                                                        , inAmountIn    := _tmpData.AmountIn          ::TFloat
                                                        , inUserId      := vbUserId                   ::Integer
                                               )
 FROM _tmpData
      LEFT JOIN _tmpObject ON _tmpObject.JuridicalId = _tmpData.JuridicalId
                          AND _tmpObject.ContractId  = _tmpData.ContractId
                          AND (_tmpObject.PaidKindId  = _tmpData.PaidKindId)
                          AND COALESCE (_tmpObject.PartnerId,0) = COALESCE (_tmpData.PartnerId,0)
 ;




END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 »—“ќ–»я –ј«–јЅќ“ »: ƒј“ј, ј¬“ќ–
               ‘елонюк ».¬.    ухтин ».¬.    лиментьев  .».
 02.12.21         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_JuridicalDefermentPayment (inStartDate:= '01.01.2023', inEndDate:= CURRENT_DATE, inSession:= '9457');

/*
  DELETE FROM ObjectLink WHERE ObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_JuridicalDefermentPayment());
  DELETE FROM ObjectLink WHERE ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_JuridicalDefermentPayment());
 
  DELETE FROM ObjectFloat WHERE ObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_JuridicalDefermentPayment());
 
  DELETE FROM ObjectDate WHERE ObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_JuridicalDefermentPayment());
  DELETE FROM Object WHERE Id IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_JuridicalDefermentPayment());
*/