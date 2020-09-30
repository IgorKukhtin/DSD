--select * from gpReport_CheckBonusTest3('01.08.2020' := ('01.08.2020')::TDateTime , inEndDate := ('31.08.2020')::TDateTime , 4 := 4 , 971365 := 971365 , 0 := 0 , false/*inismovement*/ := 'False' ,  inSession := '5');


      WITH 
           tmpContract_full AS (SELECT View_Contract.*
                                FROM Object_Contract_View AS View_Contract
                                WHERE (View_Contract.JuridicalId = 971365 OR COALESCE (971365, 0) = 0)
                                )
         , tmpContract_all AS (SELECT *
                               FROM tmpContract_full
                               WHERE tmpContract_full.PaidKindId = 4 OR COALESCE (4, 0)  = 0
                              )
           -- все договора - не закрытые или для Базы
         , tmpContract_find AS (SELECT View_Contract.*
                                FROM tmpContract_full AS View_Contract
                                WHERE View_Contract.isErased = FALSE
                                  AND (View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                    OR View_Contract.InfoMoneyId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                   , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                    )
                                      )
                               )
           -- учитываем zc_Object_ContractPartner - т.е. БАЗУ берем только по этим точкам - если они установлены, иначе по всем
         , tmpContractPartner AS (WITH
                                      -- сохраненные ContractPartner
                                      tmp1 AS (SELECT ObjectLink_ContractPartner_Contract.ChildObjectId AS ContractId
                                                    , ObjectLink_ContractPartner_Partner.ChildObjectId  AS PartnerId
                                                    , tmpContract_full.JuridicalId
                                                    , tmpContract_full.PaidKindId
                                               FROM ObjectLink AS ObjectLink_ContractPartner_Contract
                                                    INNER JOIN tmpContract_full ON tmpContract_full.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId
                                                                               --AND tmpContract_full.PaidKindId <> zc_Enum_PaidKind_FirstForm()

                                                    LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                                         ON ObjectLink_ContractPartner_Partner.ObjectId = ObjectLink_ContractPartner_Contract.ObjectId
                                                                        AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                               WHERE ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                                               )
                                      --  Partner для договоров, для которых нет ContractPartner
                                    , tmp2 AS (SELECT ObjectLink_Contract_Juridical.ObjectId AS ContractId
                                                    , ObjectLink_Partner_Juridical.ObjectId  AS PartnerId
                                                    , tmpContract_full.JuridicalId
                                                    , tmpContract_full.PaidKindId
                                               FROM tmpContract_full
                                                    LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                                         ON ObjectLink_Contract_Juridical.ObjectId = tmpContract_full.ContractId --ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId      --  AS JuridicalId-- ObjectLink_Contract_Juridical.ObjectId = Object_Contract_InvNumber_View.ContractId 
                                                                        AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                         ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                   LEFT JOIN (SELECT DISTINCT tmp1.JuridicalId, tmp1.PaidKindId FROM tmp1) AS tmpContract 
                                                                                                          ON tmpContract.JuridicalId = tmpContract_full.JuridicalId
                                                                                                         AND tmpContract.PaidKindId = tmpContract_full.PaidKindId
                                                    --LEFT JOIN (SELECT DISTINCT tmp1.ContractId FROM tmp1) AS tmpContract ON tmpContract.ContractId = tmpContract_full.ContractId --ObjectLink_Contract_Juridical.ObjectId -- ContractId
                                                WHERE tmpContract.JuridicalId IS NULL
                                                )

                                  SELECT tmp1.ContractId
                                       , tmp1.PartnerId
                                       , tmp1.PaidKindId
                                       , tmp1.JuridicalId
                                  FROM tmp1
                                UNION
                                  SELECT tmp2.ContractId
                                       , tmp2.PartnerId
                                       , tmp2.PaidKindId
                                       , tmp2.JuridicalId
                                  FROM tmp2
                                  )

         -- формируется список договоров, у которых есть условие по "Бонусам"
       , tmpContractConditionKind AS (SELECT -- условие договора
                                             ObjectLink_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                                           , View_Contract.JuridicalId
                                           , View_Contract.InvNumber             AS InvNumber_master
                                           , View_Contract.ContractTagId         AS ContractTagId_master
                                           , View_Contract.ContractTagName       AS ContractTagName_master
                                           , View_Contract.ContractStateKindCode AS ContractStateKindCode_master
                                           , View_Contract.ContractId            AS ContractId_master
                                             -- статья из договора
                                           , View_InfoMoney.InfoMoneyId AS InfoMoneyId_master
                                             -- статья по которой будет поиск Базы
                                           , CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                       THEN zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                  WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                       THEN zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                  -- !!!для других статей - любая база!!!
                                                  WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- Маркетинг
                                                       THEN 0
                                                  -- !!!если это База - тогда и другую базу подтянем!!!
                                                  WHEN View_InfoMoney.InfoMoneyGroupId NOT IN (zc_Enum_InfoMoneyGroup_30000()) -- Доходы
                                                       THEN 0
                                                  ELSE COALESCE (View_InfoMoney.InfoMoneyId, 0)
                                             END AS InfoMoneyId_child

                                             -- статья из условия - ограничение при поиске Базы
                                           , COALESCE (ObjectLink_ContractCondition_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_Condition
                                             -- форма оплаты
                                           , View_Contract.PaidKindId AS PaidKindId
                                             -- форма оплаты из усл.договора для расчета базы 
                                           , ObjectLink_ContractCondition_PaidKind.ChildObjectId AS PaidKindId_ContractCondition
                                             -- вид бонуса
                                           , ObjectLink_ContractCondition_BonusKind.ChildObjectId    AS BonusKindId
                                           , COALESCE (ObjectFloat_Value.ValueData, 0)               AS Value
                                           , COALESCE (ObjectFloat_PercentRetBonus.ValueData,0)      AS PercentRetBonus
                                           , COALESCE (Object_Comment.ValueData, '')                 AS Comment

                                             -- !!!прописано - где брать "базу"!!!
                                           , ObjectLink_ContractCondition_ContractSend.ChildObjectId AS ContractId_send

                                      FROM ObjectLink AS ObjectLink_ContractConditionKind
                                           INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractConditionKind.ObjectId
                                                                                        AND Object_ContractCondition.isErased = FALSE
                                           INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                                ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                           INNER JOIN tmpContract_find AS View_Contract ON View_Contract.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                                                  --  AND (View_Contract.JuridicalId = 971365 OR 971365 = 0)

                                           INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                                                  ON ObjectFloat_Value.ObjectId = Object_ContractCondition.Id
                                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                                 AND ObjectFloat_Value.ValueData <> 0  

                                           LEFT JOIN ObjectFloat AS ObjectFloat_PercentRetBonus
                                                                 ON ObjectFloat_PercentRetBonus.ObjectId = Object_ContractCondition.Id
                                                                AND ObjectFloat_PercentRetBonus.DescId = zc_ObjectFloat_ContractCondition_PercentRetBonus()

                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                                                ON ObjectLink_ContractCondition_ContractSend.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()

                                           LEFT JOIN Object AS Object_Comment ON Object_Comment.Id = Object_ContractCondition.Id
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                                ON ObjectLink_ContractCondition_BonusKind.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_BonusKind.DescId   = zc_ObjectLink_ContractCondition_BonusKind()
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                                                                ON ObjectLink_ContractCondition_InfoMoney.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_InfoMoney.DescId   = zc_ObjectLink_ContractCondition_InfoMoney()
                                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId

                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                                                                ON ObjectLink_ContractCondition_PaidKind.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_PaidKind.DescId = zc_ObjectLink_ContractCondition_PaidKind()
                                           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_ContractCondition_PaidKind.ChildObjectId

                                      WHERE ObjectLink_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                              )
                                        AND ObjectLink_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                     )
      -- для договоров (если !!!заполнены уп-статьи для условий!!!) надо найти бонусный договор (по 4-м ключам + пусто в "Типы условий договоров")
      -- т.е. условие есть в базовых, но надо подставить "маркет-договор" и начисления провести на него
    , tmpContractBonus AS (SELECT tmpContract_find.ContractId_master
                                , tmpContract_find.ContractId_find
                                , View_Contract_InvNumber_find.InfoMoneyId AS InfoMoneyId_find
                                , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find
                           FROM (-- базовые договора в которых "бонусное" условие + прописано какой подставить "маркет-договор"
                                 SELECT DISTINCT
                                        tmpContractConditionKind.ContractId_master
                                      , tmpContractConditionKind.ContractId_send AS ContractId_find
                                 FROM tmpContractConditionKind
                                 WHERE tmpContractConditionKind.ContractId_send > 0
                                UNION
                                 -- остальные базовые договора для которых находим "маркет-договор"
                                 SELECT tmpContractConditionKind.ContractId_master
                                      , MAX (COALESCE (View_Contract_find_tag.ContractId, View_Contract_find.ContractId)) AS ContractId_find
                                 FROM tmpContractConditionKind
                                      -- все другие ContractCondition с этим видом бонуса
                                      INNER JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                            ON ObjectLink_ContractCondition_BonusKind.ChildObjectId = tmpContractConditionKind.BonusKindId
                                                           AND ObjectLink_ContractCondition_BonusKind.DescId        = zc_ObjectLink_ContractCondition_BonusKind()
                                      -- вид бонуса НЕ удален
                                      INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_ContractCondition_BonusKind.ObjectId
                                                                                   AND Object_ContractCondition.isErased = FALSE
                                      -- с этим процентом
                                      INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId  = ObjectLink_ContractCondition_BonusKind.ObjectId
                                                            AND ObjectFloat_Value.DescId    = zc_ObjectFloat_ContractCondition_Value()
                                                            AND ObjectFloat_Value.ValueData = tmpContractConditionKind.Value

                                      -- получили сам договор
                                      INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                            ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_BonusKind.ObjectId
                                                           AND ObjectLink_ContractCondition_Contract.DescId   = zc_ObjectLink_ContractCondition_Contract()

                                      -- ПОИСК 1 - по 3 - м условиям, главное - ContractTagId_master
                                      LEFT JOIN tmpContract_all AS View_Contract_find_tag
                                                                ON View_Contract_find_tag.JuridicalId   = tmpContractConditionKind.JuridicalId
                                                               AND View_Contract_find_tag.InfoMoneyId   = tmpContractConditionKind.InfoMoneyId_Condition
                                                               AND View_Contract_find_tag.ContractTagId = tmpContractConditionKind.ContractTagId_master
                                                               AND tmpContractConditionKind.ContractId_send IS NULL
                                                               -- как-то работало и без этого условия
                                                               AND View_Contract_find_tag.ContractId    = ObjectLink_ContractCondition_Contract.ChildObjectId

                                      -- ПОИСК 2 - по 3 - м условиям - любой, т.е. в нем будет другой ContractTagId_master
                                      LEFT JOIN tmpContract_all AS View_Contract_find
                                                                ON View_Contract_find.JuridicalId = tmpContractConditionKind.JuridicalId
                                                               AND View_Contract_find.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_Condition
                                                               AND View_Contract_find.ContractId  = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                               AND View_Contract_find_tag.ContractId        IS NULL
                                                               AND tmpContractConditionKind.ContractId_send IS NULL
                                      LEFT JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                           ON ObjectLink_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                          AND ObjectLink_ContractConditionKind.DescId   = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                 WHERE -- есть статья в условии договора
                                       tmpContractConditionKind.InfoMoneyId_Condition <> 0
                                       -- !!!НЕТ самого условия договора!!!
                                   AND COALESCE (ObjectLink_ContractConditionKind.ChildObjectId, 0) = 0
                                       -- !!!НЕ прописано - где брать "базу"!!!
                                   AND tmpContractConditionKind.ContractId_send IS NULL

                                 GROUP BY tmpContractConditionKind.ContractId_master
                                ) AS tmpContract_find
                                LEFT JOIN tmpContract_all AS View_Contract_InvNumber_find ON View_Contract_InvNumber_find.ContractId = tmpContract_find.ContractId_find
                           WHERE tmpContract_find.ContractId_find <> 0
                          )
      -- для всех юр лиц, у кого есть "Бонусы" формируется список всех других договоров (по ним будем делать расчет "базы")
    , tmpContract AS (SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.InvNumber_master
                           , tmpContractConditionKind.InvNumber_master  AS InvNumber_child
                           , tmpContractConditionKind.ContractId_master
                           , tmpContractConditionKind.ContractId_master AS ContractId_child
                           , tmpContractConditionKind.ContractTagName_master       AS ContractTagName_child
                           , tmpContractConditionKind.ContractStateKindCode_master AS ContractStateKindCode_child
                           , tmpContractConditionKind.InfoMoneyId_master
                           , tmpContractConditionKind.InfoMoneyId_child
                           , tmpContractConditionKind.InfoMoneyId_Condition
                           , tmpContractConditionKind.PaidKindId
                           , tmpContractConditionKind.PaidKindId        AS PaidKindId_byBase
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                      FROM tmpContractConditionKind
                      WHERE tmpContractConditionKind.InfoMoneyId_master = tmpContractConditionKind.InfoMoneyId_child -- это будут не бонусные договора (но в них есть бонусы)
                    UNION ALL
                      SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.InvNumber_master
                           , View_Contract_child.InvNumber             AS InvNumber_child
                           , tmpContractConditionKind.ContractId_master
                           , View_Contract_child.ContractId            AS ContractId_child
                           , View_Contract_child.ContractTagName       AS ContractTagName_child
                           , View_Contract_child.ContractStateKindCode AS ContractStateKindCode_child
                           , tmpContractConditionKind.InfoMoneyId_master
                           , tmpContractConditionKind.InfoMoneyId_child
                           , tmpContractConditionKind.InfoMoneyId_Condition
                           , tmpContractConditionKind.PaidKindId
                           -- берем ФО из усл.договора для нач. базы если не пусто , если фо не выбрана берем из догоовра 
                           --(т.е. договор по форме НАЛ, отчет по форме НАЛ, а базу надо будет вытянуть по форме БН)
                           , CASE WHEN COALESCE (tmpContractConditionKind.PaidKindId_ContractCondition, 0) <> 0 THEN tmpContractConditionKind.PaidKindId_ContractCondition ELSE tmpContractConditionKind.PaidKindId END AS PaidKindId_byBase
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                      FROM tmpContractConditionKind
                           INNER JOIN tmpContract_full AS View_Contract_child
                                                       ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                                      AND View_Contract_child.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child -- это будут бонусные договора
                     )
        
      -- группируем договора, т.к. "базу" будем формировать по 4-м ключам
    ,tmpContractGroup AS (SELECT tmpContract.JuridicalId
                               , tmpContract.ContractId_child
                               , tmpContract.InfoMoneyId_child
                               , tmpContract.PaidKindId_byBase
                           FROM tmpContract
                           -- WHERE (tmpContract.PaidKindId = 4 OR 4 = 0)
                           --  AND (tmpContract.JuridicalId = 971365 OR 971365 = 0)
                           GROUP BY tmpContract.JuridicalId
                                  , tmpContract.ContractId_child
                                  , tmpContract.InfoMoneyId_child
                                  , tmpContract.PaidKindId_byBase
                          )
                          
      -- список ContractId по которым будет расчет "базы"
    , tmpAccount AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит

    , tmpContainerAll AS (SELECT Container.*
                             , ContainerLO_Juridical.ObjectId  AS JuridicalId
                             , ContainerLO_Contract.ObjectId   AS ContractId
                             , ContainerLO_InfoMoney.ObjectId  AS InfoMoneyId
                             , ContainerLO_PaidKind.ObjectId   AS PaidKindId

                        FROM Container
                            JOIN ContainerLinkObject AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = Container.Id
                                                                             AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
                            JOIN ContainerLinkObject AS ContainerLO_Contract ON ContainerLO_Contract.ContainerId = Container.Id
                                                                            AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract() 
                            JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = Container.Id
                                                                             AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()                               
                            JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = Container.Id
                                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind() 
                        WHERE Container.ObjectId IN (SELECT DISTINCT tmpAccount.AccountId FROM tmpAccount)
                          AND Container.DescId = zc_Container_Summ()
                        )

    , tmpContainer1 AS (SELECT  DISTINCT
                              tmpContainerAll.Id  AS ContainerId
                            , tmpContractGroup.JuridicalId
                            , tmpContractGroup.ContractId_child
                            , tmpContractGroup.InfoMoneyId_child
                            , tmpContractGroup.PaidKindId_byBase
                            , ContainerLO_Branch.ObjectId      AS BranchId
                        FROM tmpContainerAll 
                            -- ограничение по 4-м ключам
                            JOIN tmpContractGroup ON tmpContractGroup.JuridicalId       = tmpContainerAll.JuridicalId 
                                                 AND tmpContractGroup.ContractId_child  = tmpContainerAll.ContractId
                                                 AND tmpContractGroup.InfoMoneyId_child = tmpContainerAll.InfoMoneyId
                                                 AND tmpContractGroup.PaidKindId_byBase = tmpContainerAll.PaidKindId
                            LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                          ON ContainerLO_Branch.ContainerId = tmpContainerAll.Id
                                                         AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                       -- WHERE COALESCE (ContainerLO_Branch.ObjectId,0) = 0 OR 0 = 0
                       )

     , tmpCLO_Partner AS (SELECT ContainerLinkObject.*
                          FROM ContainerLinkObject
                          WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer1.ContainerId
                                                                    FROM tmpContainer1
                                                                    WHERE tmpContainer1.PaidKindId_byBase = zc_Enum_PaidKind_SecondForm()
                                                                    )
                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Partner()
                            AND ContainerLinkObject.ObjectId IN (SELECT DISTINCT tmpContractPartner.PartnerId FROM tmpContractPartner)
                          )
     , tmpContainer AS (SELECT tmpContainer1.*
                             , 0 AS PartnerId    
                       FROM tmpContainer1
                       WHERE tmpContainer1.PaidKindId_byBase = zc_Enum_PaidKind_FirstForm()
                       UNION
                       -- для НАЛ ограничиваем контрагентами
                       SELECT tmpContainer.*
                            , CLO_Partner.ObjectId AS PartnerId  --, 0 AS PartnerId    --,
                       FROM tmpContainer1 As tmpContainer
                           INNER JOIN tmpCLO_Partner AS CLO_Partner
                                                     ON CLO_Partner.ContainerId = tmpContainer.ContainerId
                                                    AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                                    AND CLO_Partner.ObjectId IN (SELECT DISTINCT tmpContractPartner.PartnerId FROM tmpContractPartner)
                       WHERE tmpContainer.PaidKindId_byBase <> zc_Enum_PaidKind_FirstForm()
                       )

      , tmpMovementCont AS
 (SELECT tmpContainer.JuridicalId
                                 , tmpContainer.ContractId_child
                                 , tmpContainer.InfoMoneyId_child
                                 , tmpContainer.PaidKindId_byBase
                                 , COALESCE (ObjectLink_Cash_Branch.ChildObjectId, MILinkObject_Branch.ObjectId, ObjectLink_Unit_Branch.ChildObjectId, tmpContainer.BranchId, 0) AS BranchId
                                 , CASE WHEN false/*inismovement*/ = FALSE THEN tmpContainer.PartnerId
                                        ELSE CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                                   END  AS PartnerId
                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN COALESCE(MIContainer.Amount,0) ELSE 0 END) AS Sum_Sale -- Только продажи
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN COALESCE(MIContainer.Amount,0) ELSE 0 END) AS Sum_SaleReturnIn -- продажи - возвраты
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash()/*, zc_Movement_SendDebt()*/)
                                                  THEN -1 * COALESCE(MIContainer.Amount,0)
                                             ELSE 0
                                        END) AS Sum_Account -- оплаты

                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE(MIContainer.Amount,0) ELSE 0 END) AS Sum_Return  -- возврат
                                 , CASE WHEN false/*inismovement*/ = TRUE THEN MIContainer.MovementDescId ELSE 0 END  AS MovementDescId
                                 , CASE WHEN false/*inismovement*/ = TRUE THEN MIContainer.MovementId ELSE 0 END      AS MovementId

                            FROM MovementItemContainer AS MIContainer
                                 JOIN tmpContainer ON tmpContainer.ContainerId = MIContainer.ContainerId

                                 LEFT JOIN MovementLinkObject AS MLO_Unit
                                                              ON MLO_Unit.MovementId = MIContainer.MovementId
                                                             AND MLO_Unit.DescId = CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_From()
                                                                                        WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_To()
                                                                                   END
                                 LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId 
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MIContainer.MovementDescId = zc_Movement_Cash()

                                 /*LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                  ON MILinkObject_Unit.MovementItemId = MIContainer.MovementItemId   --BankAccount
                                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                 AND MIContainer.MovementDescId = zc_Movement_BankAccount()*/
                                 -- для оплат берем филиал по отв. сотруджнику
                                 LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                      ON ObjectLink_Contract_Personal.ObjectId = tmpContainer.ContractId_child
                                                     AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                                     AND MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash()/*, zc_Movement_SendDebt()*/)
                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                      ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Contract_Personal.ChildObjectId
                                                     AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()

                                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                      ON ObjectLink_Unit_Branch.ObjectId = COALESCE (MLO_Unit.ObjectId, ObjectLink_Personal_Unit.ChildObjectId)
                                                     AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                                  ON MILinkObject_Branch.MovementItemId = MIContainer.MovementItemId   -- SendDebt
                                                                 AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                                                                 AND MovementItem.DescId = zc_MI_Master()
                                                                 AND MIContainer.MovementDescId = zc_Movement_SendDebt()

                                 LEFT JOIN ObjectLink AS ObjectLink_Cash_Branch
                                                      ON ObjectLink_Cash_Branch.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
                                                     AND MIContainer.MovementDescId = zc_Movement_Cash()
                                 LEFT JOIN (SELECT DISTINCT tmpContractPartner.PartnerId, tmpContractPartner.JuridicalId, tmpContractPartner.PaidKindId FROM tmpContractPartner
                                           ) AS tmpPartner 
                                             ON (tmpPartner.PartnerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END)
                                            AND tmpPartner.PaidKindId = tmpContainer.PaidKindId_byBase
                                 LEFT JOIN Object ON Object.Id = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                            WHERE MIContainer.DescId = zc_MIContainer_Summ()
                              AND (MIContainer.OperDate >= '01.08.2020' AND MIContainer.OperDate < '01.09.2020')
                              AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_BankAccount(),zc_Movement_Cash()/*, zc_Movement_SendDebt()*/)  -- взаимозачет убираем, чтоб он не влиял на бонусы
                              AND (COALESCE (ObjectLink_Cash_Branch.ChildObjectId, MILinkObject_Branch.ObjectId, ObjectLink_Unit_Branch.ChildObjectId,tmpContainer.BranchId,0) = 0 OR 0 = 0)
                              AND (tmpPartner.PartnerId IS NOT NULL OR COALESCE (4, 0) = zc_Enum_PaidKind_FirstForm() OR Object.DescId = zc_Object_Juridical()) --PartnerId
                            GROUP BY tmpContainer.JuridicalId
                                   , tmpContainer.ContractId_child
                                   , tmpContainer.InfoMoneyId_child
                                   , tmpContainer.PaidKindId_byBase
                                   , CASE WHEN false/*inismovement*/ = TRUE THEN MIContainer.MovementDescId ELSE 0 END
                                   , CASE WHEN false/*inismovement*/ = TRUE THEN MIContainer.MovementId ELSE 0 END
                                   , COALESCE ( ObjectLink_Cash_Branch.ChildObjectId, MILinkObject_Branch.ObjectId, ObjectLink_Unit_Branch.ChildObjectId,tmpContainer.BranchId,0)
                                   , CASE WHEN false/*inismovement*/ = FALSE THEN tmpContainer.PartnerId
                                          ELSE CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                                     END
                            )

/*
SELECT tmpContainer.JuridicalId
                                 , tmpContainer.ContractId_child
                                 , tmpContainer.InfoMoneyId_child
                                 , tmpContainer.PaidKindId_byBase
                                 , COALESCE (ObjectLink_Cash_Branch.ChildObjectId, MILinkObject_Branch.ObjectId, ObjectLink_Unit_Branch.ChildObjectId, tmpContainer.BranchId, 0) AS BranchId
                                 , CASE WHEN false/*inismovement*/ = FALSE THEN tmpContainer.PartnerId
                                        ELSE CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                                   END  AS PartnerId
                                 ,  (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN COALESCE(MIContainer.Amount,0) ELSE 0 END) AS Sum_Sale -- Только продажи
                                 , (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN COALESCE(MIContainer.Amount,0) ELSE 0 END) AS Sum_SaleReturnIn -- продажи - возвраты
                                 , (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash()/*, zc_Movement_SendDebt()*/)
                                                  THEN -1 * COALESCE(MIContainer.Amount,0)
                                             ELSE 0
                                        END) AS Sum_Account -- оплаты
, MIContainer.MovementDescId
, CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END

,tmpPartner.*
                            FROM MovementItemContainer AS MIContainer
                                 JOIN tmpContainer ON tmpContainer.ContainerId = MIContainer.ContainerId

                                 LEFT JOIN MovementLinkObject AS MLO_Unit
                                                              ON MLO_Unit.MovementId = MIContainer.MovementId
                                                             AND MLO_Unit.DescId = CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_From()
                                                                                        WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_To()
                                                                                   END
                                 LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId 
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MIContainer.MovementDescId = zc_Movement_Cash()

                                 /*LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                  ON MILinkObject_Unit.MovementItemId = MIContainer.MovementItemId   --BankAccount
                                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                 AND MIContainer.MovementDescId = zc_Movement_BankAccount()*/
                                 -- для оплат берем филиал по отв. сотруджнику
                                 LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                      ON ObjectLink_Contract_Personal.ObjectId = tmpContainer.ContractId_child
                                                     AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                                     AND MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash()/*, zc_Movement_SendDebt()*/)
                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                      ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Contract_Personal.ChildObjectId
                                                     AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()

                                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                      ON ObjectLink_Unit_Branch.ObjectId = COALESCE (MLO_Unit.ObjectId, ObjectLink_Personal_Unit.ChildObjectId)
                                                     AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                                  ON MILinkObject_Branch.MovementItemId = MIContainer.MovementItemId   -- SendDebt
                                                                 AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                                                                 AND MovementItem.DescId = zc_MI_Master()
                                                                 AND MIContainer.MovementDescId = zc_Movement_SendDebt()

                                 LEFT JOIN ObjectLink AS ObjectLink_Cash_Branch
                                                      ON ObjectLink_Cash_Branch.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
                                                     AND MIContainer.MovementDescId = zc_Movement_Cash()
                                 LEFT JOIN (SELECT DISTINCT tmpContractPartner.PartnerId, tmpContractPartner.JuridicalId, tmpContractPartner.PaidKindId FROM tmpContractPartner
                                           ) AS tmpPartner 
                                             ON ((tmpPartner.PartnerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END)
                                              OR (tmpPartner.JuridicalId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END)
                                                )
                                            AND tmpPartner.PaidKindId = tmpContainer.PaidKindId_byBase
                            WHERE MIContainer.DescId = zc_MIContainer_Summ()
                              AND (MIContainer.OperDate >= '01.08.2020' AND MIContainer.OperDate < '01.09.2020')
                              AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_BankAccount(),zc_Movement_Cash()/*, zc_Movement_SendDebt()*/)  -- взаимозачет убираем, чтоб он не влиял на бонусы
                              AND (COALESCE (ObjectLink_Cash_Branch.ChildObjectId, MILinkObject_Branch.ObjectId, ObjectLink_Unit_Branch.ChildObjectId,tmpContainer.BranchId,0) = 0 OR 0 = 0)
                             --AND (COALESCE( CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END,0) = 0) --PartnerId
                        
*/
/*    GROUP BY tmpContainer.JuridicalId
                                   , tmpContainer.ContractId_child
                                   , tmpContainer.InfoMoneyId_child
                                   , tmpContainer.PaidKindId_byBase
                                   , CASE WHEN false/*inismovement*/ = TRUE THEN MIContainer.MovementDescId ELSE 0 END
                                   , CASE WHEN false/*inismovement*/ = TRUE THEN MIContainer.MovementId ELSE 0 END
                                   , COALESCE ( ObjectLink_Cash_Branch.ChildObjectId, MILinkObject_Branch.ObjectId, ObjectLink_Unit_Branch.ChildObjectId,tmpContainer.BranchId,0)
                                   , CASE WHEN false/*inismovement*/ = FALSE THEN tmpContainer.PartnerId
                                          ELSE CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                                     END*/

select * from tmpMovementCont
--SELECT * FROM tmpContractPartner

--select * from MovementDesc where id =14
/*
select *
from Object
where id in (971365,
971365,
971365
)*/