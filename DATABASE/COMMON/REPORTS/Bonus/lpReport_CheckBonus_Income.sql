

-- FunctiON: lpReport_CheckBonus_Income ()

DROP FUNCTION IF EXISTS lpReport_CheckBonus_Income (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpReport_CheckBonus_Income (
    IN inStartDate           TDateTime ,
    IN inEndDate             TDateTime ,
    IN inPaidKindId          Integer   ,
    IN inJuridicalId         Integer   ,
    IN inBranchId            Integer   ,
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate_Movement TDateTime, InvNumber_Movement TVarChar, DescName_Movement TVarChar
             , ContractId_master Integer, ContractId_child Integer, ContractId_find Integer, InvNumber_master TVarChar, InvNumber_child TVarChar, InvNumber_find TVarChar
             , ContractTagName_child TVarChar, ContractStateKindCode_child Integer
             , InfoMoneyId_master Integer, InfoMoneyId_find Integer
             , InfoMoneyName_master TVarChar, InfoMoneyName_child TVarChar, InfoMoneyName_find TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , PaidKindName_Child TVarChar
             , ConditionKindId Integer, ConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , RetailName TVarChar
             , PersonalCode Integer, PersonalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , Value TFloat
             , PercentRetBonus TFloat
             , PercentRetBonus_fact TFloat
             , Sum_CheckBonus TFloat
             , Sum_CheckBonusFact TFloat
             , Sum_Bonus TFloat
             , Sum_BonusFact TFloat
             , Sum_IncomeFact TFloat
             , Sum_Account TFloat
             , Sum_IncomeReturnOut TFloat
             , Amount_in TFloat
             , Amount_out TFloat
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE inisMovement  Boolean ; -- по документам
BEGIN

   IF (COALESCE (inPaidKindId,0) = 0)
   THEN
        RAISE EXCEPTION 'Ошибка.Не выбрана форма оплаты';
   END IF;

   inisMovement:= FALSE;

   -- удаляем временные таблицы если уже есть такие
   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpJuridical') THEN Drop TABLE tmpJuridical; END IF;
   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpContract_full') THEN Drop TABLE tmpContract_full; END IF;
   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpContract_all') THEN Drop TABLE tmpContract_all; END IF;
   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpContract_find') THEN Drop TABLE tmpContract_find; END IF;
   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpContractPartner') THEN Drop TABLE tmpContractPartner; END IF;
   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpContract') THEN Drop TABLE tmpContract; END IF;
   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpContractConditionKind') THEN Drop TABLE tmpContractConditionKind; END IF;
   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpContractBonus') THEN Drop TABLE tmpContractBonus; END IF;
   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpBase') THEN Drop TABLE tmpBase; END IF;
   
   --поставщики
   CREATE TEMP TABLE tmpJuridical ON COMMIT DROP AS (SELECT ObjectLink_Juridical_JuridicalGroup.ObjectId AS JuridicalId
                                                     FROM ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                                     WHERE ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
                                                         AND ObjectLink_Juridical_JuridicalGroup.ChildObjectId = 8357
                                                     );

   CREATE TEMP TABLE tmpContract_full ON COMMIT DROP AS (SELECT View_Contract.*
                                                         FROM Object_Contract_View AS View_Contract
                                                            --только поставщики
                                                            INNER JOIN tmpJuridical ON tmpJuridical.JuridicalId = View_Contract.JuridicalId
                                                         WHERE (View_Contract.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                                         );
   CREATE TEMP TABLE tmpContract_all ON COMMIT DROP AS (SELECT *
                                                        FROM tmpContract_full
                                                        WHERE tmpContract_full.PaidKindId = inPaidKindId OR COALESCE (inPaidKindId, 0)  = 0
                                                       );
   -- все договора - не закрытые или для Базы
   CREATE TEMP TABLE tmpContract_find ON COMMIT DROP AS (SELECT View_Contract.*
                                                         FROM tmpContract_full AS View_Contract
                                                         WHERE View_Contract.isErased = FALSE
                                                           AND (View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                             OR View_Contract.InfoMoneyId = 5572061 -- 30503()   -- Бонусы от поставщиков
                                                               )
                                                        );

   CREATE TEMP TABLE tmpContractPartner ON COMMIT DROP AS (
           WITH
           -- сохраненные ContractPartner
           tmpContractPartner_only AS 
                        (SELECT tmpContract_full.ContractId AS ContractId
                              , tmpContract_full.JuridicalId
                              , COALESCE (ObjectLink_ContractPartner_Partner.ChildObjectId,ObjectLink_Partner_Juridical.ObjectId)   AS PartnerId

                              , CASE WHEN COALESCE (ObjectLink_ContractCondition_PaidKind.ChildObjectId,0) <> 0
                                     THEN ObjectLink_ContractCondition_PaidKind.ChildObjectId
                                     ELSE tmpContract_full.PaidKindId
                                END AS PaidKindId_byBase
                                -- если нужно считать по условиям - для НАЛ
                              , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN ObjectLink_ContractCondition_Contract.ObjectId ELSE 0 END AS ContractConditionId
                         FROM tmpContract_full
                                     
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                       ON ObjectLink_ContractCondition_Contract.ChildObjectId = tmpContract_full.ContractId
                                                      AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                                                       ON ObjectLink_ContractCondition_PaidKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                      AND ObjectLink_ContractCondition_PaidKind.DescId = zc_ObjectLink_ContractCondition_PaidKind()
                        
                                  INNER JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                        ON ObjectLink_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                       AND ObjectLink_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                      AND ObjectLink_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                           , zc_Enum_ContractConditionKind_BonusPercentIncome()
                                                                                                           , zc_Enum_ContractConditionKind_BonusPercentIncomeReturn()
                                                                                                           , zc_Enum_ContractConditionKind_BonusPercentIncomeReturnS()
                                                                                                           )
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                       ON ObjectLink_ContractPartner_Contract.ChildObjectId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                      AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                              
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                       ON ObjectLink_ContractPartner_Partner.ObjectId = ObjectLink_ContractPartner_Contract.ObjectId
                                                      AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                        
                                   -- если нет ObjectLink_ContractPartner_Partner.ChildObjectId берем всех контрагентов по юр лицу
                                  LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                       ON ObjectLink_Contract_Juridical.ObjectId = tmpContract_full.ContractId --ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId      --  AS JuridicalId-- ObjectLink_Contract_Juridical.ObjectId = Object_Contract_InvNumber_View.ContractId 
                                                      AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                      AND COALESCE (ObjectLink_ContractPartner_Partner.ChildObjectId,0) = 0
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                         WHERE tmpContract_full.PaidKindId = inPaidKindId
                         )
           -- Для нал еще выбираем контрагентов из условий договора, если выбраны. то бонусы только на них считаем
         , tmpCCPartner AS (SELECT tmp.ContractConditionId
                                 , ObjectLink_ContractConditionPartner_Partner.ChildObjectId AS PartnerId
                            FROM (SELECT DISTINCT tmpContractPartner_only.ContractConditionId FROM tmpContractPartner_only) AS tmp
                                 LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                                      ON ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId = tmp.ContractConditionId
                                                     AND ObjectLink_ContractConditionPartner_ContractCondition.DescId = zc_ObjectLink_ContractConditionPartner_ContractCondition()
            
                                 INNER JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                                       ON ObjectLink_ContractConditionPartner_Partner.ObjectId = ObjectLink_ContractConditionPartner_ContractCondition.ObjectId
                                                      AND ObjectLink_ContractConditionPartner_Partner.DescId = zc_ObjectLink_ContractConditionPartner_Partner()
                           )

         -- объединяеем 2 таблички
         --ограничение контрагентами из условий договора
          SELECT tmpContractPartner_only.*
          FROM tmpContractPartner_only
               INNER JOIN tmpCCPartner ON tmpCCPartner.ContractConditionId = tmpContractPartner_only.ContractConditionId
                                      AND tmpCCPartner.PartnerId = tmpContractPartner_only.PartnerId
        --WHERE COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) <> 0
        UNION
         -- если нет контрагентов в усл. договора берем всех выше найденных
         SELECT tmpContractPartner_only.*
         FROM tmpContractPartner_only
               LEFT JOIN tmpCCPartner ON tmpCCPartner.ContractConditionId = tmpContractPartner_only.ContractConditionId
                                     AND tmpCCPartner.PartnerId = tmpContractPartner_only.PartnerId
       --WHERE COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) = 0
         WHERE tmpCCPartner.PartnerId IS NULL
          AND tmpContractPartner_only.ContractConditionId NOT IN (SELECT DISTINCT tmpCCPartner.ContractConditionId FROM tmpCCPartner)

        UNION
         -- если вдруг в условии договора есть контрагенты, которых нет в договоре
         SELECT tmpContract_full.ContractId AS ContractId
              , tmpContract_full.JuridicalId
              , tmpCCPartner.PartnerId
              , CASE WHEN COALESCE (ObjectLink_ContractCondition_PaidKind.ChildObjectId,0) <> 0
                     THEN ObjectLink_ContractCondition_PaidKind.ChildObjectId
                     ELSE tmpContract_full.PaidKindId
                END AS PaidKindId_byBase
                -- если нужно считать по условиям
              , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN ObjectLink_ContractCondition_Contract.ObjectId ELSE 0 END AS ContractConditionId
         FROM tmpCCPartner
               LEFT JOIN tmpContractPartner_only ON tmpContractPartner_only.ContractConditionId = tmpCCPartner.ContractConditionId
                                                AND tmpContractPartner_only.PartnerId = tmpCCPartner.PartnerId
               LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                                    ON ObjectLink_ContractCondition_PaidKind.ObjectId = tmpCCPartner.ContractConditionId
                                   AND ObjectLink_ContractCondition_PaidKind.DescId = zc_ObjectLink_ContractCondition_PaidKind()                                  
               LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                    ON ObjectLink_ContractCondition_Contract.ObjectId = tmpCCPartner.ContractConditionId
                                   AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
               INNER JOIN tmpContract_full ON tmpContract_full.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
         WHERE tmpContractPartner_only.PartnerId IS NULL
           );

   CREATE TEMP TABLE tmpContractConditionKind ON COMMIT DROP AS (
         -- формируется список договоров, у которых есть условие по "Бонусам"
                SELECT -- условие договора
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
                     , /*CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
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
                       END*/ 0 AS InfoMoneyId_child

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

                       -- если нужно считать по условиям - для НАЛ
                     , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN Object_ContractCondition.Id ELSE 0 END AS ContractConditionId


                FROM ObjectLink AS ObjectLink_ContractConditionKind
                     INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractConditionKind.ObjectId
                                                                  AND Object_ContractCondition.isErased = FALSE
                     INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                          ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                                         AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                     INNER JOIN tmpContract_find AS View_Contract ON View_Contract.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                            --  AND (View_Contract.JuridicalId = inJuridicalId OR inJuridicalId = 0)

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
                                                                       , zc_Enum_ContractConditionKind_BonusPercentIncome()
                                                                       , zc_Enum_ContractConditionKind_BonusPercentIncomeReturn()
                                                                       , zc_Enum_ContractConditionKind_BonusPercentIncomeReturnS()
                                                                        )

                  AND ObjectLink_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                );

   CREATE TEMP TABLE tmpContractBonus ON COMMIT DROP AS (
      -- для договоров (если !!!заполнены уп-статьи для условий!!!) надо найти бонусный договор (по 4-м ключам + пусто в "Типы условий договоров")
      -- т.е. условие есть в базовых, но надо подставить "маркет-договор" и начисления провести на него
      SELECT tmpContract_find.ContractId_master
           , tmpContract_find.ContractId_find
           , View_Contract_InvNumber_find.InfoMoneyId AS InfoMoneyId_find
           , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find
           , tmpContract_find.ContractConditionId
      FROM (-- базовые договора в которых "бонусное" условие + прописано какой подставить "маркет-договор"
            SELECT DISTINCT
                   tmpContractConditionKind.ContractId_master
                 , tmpContractConditionKind.ContractId_send AS ContractId_find
                 , tmpContractConditionKind.ContractConditionId
            FROM tmpContractConditionKind
            WHERE tmpContractConditionKind.ContractId_send > 0
           UNION
            -- остальные базовые договора для которых находим "маркет-договор"
            SELECT tmpContractConditionKind.ContractId_master
                 , MAX (COALESCE (View_Contract_find_tag.ContractId, View_Contract_find.ContractId)) AS ContractId_find
                 , tmpContractConditionKind.ContractConditionId
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

            GROUP BY tmpContractConditionKind.ContractId_master, tmpContractConditionKind.ContractConditionId
           ) AS tmpContract_find
           LEFT JOIN tmpContract_all AS View_Contract_InvNumber_find ON View_Contract_InvNumber_find.ContractId = tmpContract_find.ContractId_find
      WHERE tmpContract_find.ContractId_find <> 0
     );

     CREATE TEMP TABLE tmpContract ON COMMIT DROP AS (
         -- для всех юр лиц, у кого есть "Бонусы" формируется список всех других договоров (по ним будем делать расчет "базы")
         SELECT tmpContractConditionKind.JuridicalId
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
              , tmpContractConditionKind.ContractConditionId
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
              , View_Contract_child.InfoMoneyId           AS InfoMoneyId_child  -- , tmpContractConditionKind.InfoMoneyId_child
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
              , tmpContractConditionKind.ContractConditionId
         FROM tmpContractConditionKind
              INNER JOIN tmpContract_full AS View_Contract_child
                                          ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                        -- AND View_Contract_child.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child
         WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child -- это будут бонусные договора
         );

   --- БАЗА
   CREATE TEMP TABLE tmpBase ON COMMIT DROP AS (
      WITH
      -- группируем договора, т.к. "базу" будем формировать по 4-м ключам
      tmpContractGroup AS (SELECT tmpContract.JuridicalId
                               , tmpContract.ContractId_master
                               , tmpContract.ContractId_child
                               , tmpContract.InfoMoneyId_child
                               , tmpContract.PaidKindId_byBase
                               , tmpContract.ContractConditionId
                           FROM tmpContract
                           -- WHERE (tmpContract.PaidKindId = inPaidKindId OR inPaidKindId = 0)
                           --  AND (tmpContract.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                           GROUP BY tmpContract.JuridicalId
                                  , tmpContract.ContractId_master
                                  , tmpContract.ContractId_child
                                  , tmpContract.InfoMoneyId_child
                                  , tmpContract.PaidKindId_byBase
                                  , tmpContract.ContractConditionId
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
                            , tmpContractGroup.ContractId_master
                            , tmpContractGroup.ContractId_child
                            , tmpContractGroup.InfoMoneyId_child
                            , tmpContractGroup.PaidKindId_byBase
                            , COALESCE (ContainerLO_Branch.ObjectId,0) AS BranchId
                            , tmpContractGroup.ContractConditionId
                        FROM tmpContainerAll
                            -- ограничение по 4-м ключам
                            JOIN tmpContractGroup ON tmpContractGroup.JuridicalId       = tmpContainerAll.JuridicalId
                                                 AND tmpContractGroup.ContractId_child  = tmpContainerAll.ContractId
                                                 AND tmpContractGroup.InfoMoneyId_child = tmpContainerAll.InfoMoneyId
                                                 AND tmpContractGroup.PaidKindId_byBase = tmpContainerAll.PaidKindId
                            LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                          ON ContainerLO_Branch.ContainerId = tmpContainerAll.Id
                                                         AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                       -- WHERE COALESCE (ContainerLO_Branch.ObjectId,0) = inBranchId OR inBranchId = 0
                       )

     /*, tmpCLO_Partner AS (SELECT ContainerLinkObject.*
                          FROM ContainerLinkObject
                          WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer1.ContainerId
                                                                    FROM tmpContainer1
                                                                    WHERE tmpContainer1.PaidKindId_byBase = zc_Enum_PaidKind_SecondForm())
                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Partner()
                            AND ContainerLinkObject.ObjectId IN (SELECT DISTINCT tmpContractPartner.PartnerId FROM tmpContractPartner)
                          )*/
     , tmpContainer AS (SELECT tmpContainer1.*
                             , 0 AS PartnerId
                       FROM tmpContainer1
                       )
     , tmpResult AS (SELECT tmpContainer.JuridicalId
                          , tmpContainer.ContractId_master
                          , tmpContainer.ContractId_child
                          , tmpContainer.InfoMoneyId_child
                          , tmpContainer.PaidKindId_byBase
                          , tmpContainer.ContractConditionId
                          , COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) AS BranchId
                          , CASE WHEN Object.DescId = zc_Object_Partner() THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                                 ELSE 0
                            END    AS PartnerId
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN (-1) * MIContainer.Amount ELSE 0 END) AS Sum_Income -- Только приходы
                          , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()) THEN (-1) * MIContainer.Amount ELSE 0 END) AS Sum_IncomeReturnOut -- приход - возвраты
                          , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())
                                           THEN MIContainer.Amount ---1 *
                                      ELSE 0
                                 END) AS Sum_Account -- оплаты

                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnOut() THEN MIContainer.Amount ELSE 0 END) AS Sum_Return  -- возврат

                          , MIContainer.MovementDescId   AS MovementDescId
                          , MIContainer.MovementId       AS MovementId


                     FROM MovementItemContainer AS MIContainer
                          JOIN tmpContainer ON tmpContainer.ContainerId = MIContainer.ContainerId

                          LEFT JOIN Object ON Object.Id = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END

                          -- для Базы БН получаем филиал по сотруднику из договора, по ведомости 
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                               ON ObjectLink_Contract_PersonalTrade.ObjectId = tmpContainer.ContractId_master
                                              AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                                              AND tmpContainer.PaidKindId_byBase = zc_Enum_PaidKind_FirstForm()
                          
                          -- для Базы нал берем филиал по сотруднику из контрагента, по ведомости
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                               ON ObjectLink_Partner_PersonalTrade.ObjectId = CASE WHEN Object.DescId = zc_Object_Partner() THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END ELSE 0 END
                                              AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                              AND (tmpContainer.PaidKindId_byBase = zc_Enum_PaidKind_SecondForm()
                                                  OR COALESCE (ObjectLink_Contract_PersonalTrade.ChildObjectId,0) = 0 
                                                  )

                          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = COALESCE (ObjectLink_Contract_PersonalTrade.ChildObjectId, ObjectLink_Partner_PersonalTrade.ChildObjectId)
                                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch
                                               ON ObjectLink_PersonalServiceList_Branch.ObjectId = ObjectLink_Personal_PersonalServiceList.ChildObjectId
                                              AND ObjectLink_PersonalServiceList_Branch.DescId = zc_ObjectLink_PersonalServiceList_Branch()


                     WHERE MIContainer.DescId = zc_MIContainer_Summ()
                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                       AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_BankAccount(),zc_Movement_Cash(), zc_Movement_SendDebt())
                       AND (COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) = inBranchId OR inBranchId = 0)
                     GROUP BY tmpContainer.JuridicalId
                            , tmpContainer.ContractId_master
                            , tmpContainer.ContractId_child
                            , tmpContainer.InfoMoneyId_child
                            , tmpContainer.PaidKindId_byBase
                            , tmpContainer.ContractConditionId
                            , MIContainer.MovementDescId
                            , MIContainer.MovementId
                            , COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0)
                            , CASE WHEN Object.DescId = zc_Object_Partner() THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                                   ELSE 0
                              END
                     )


, tmpResult_amount AS (SELECT tmp.MovementId
                            , SUM (CASE WHEN tmp.MovementDescId = zc_Movement_Income() THEN COALESCE (MovementItem.Amount, 0)
                                        ELSE 0
                                   END
                                   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ) AS Amount_in

                            , SUM (CASE WHEN tmp.MovementDescId = zc_Movement_ReturnOut() THEN COALESCE (MovementItem.Amount, 0)
                                        ELSE 0
                                   END
                                   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ) AS Amount_out


                       FROM (SELECT DISTINCT tmpResult.MovementId, tmpResult.MovementDescId FROM tmpResult WHERE tmpResult.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut())) AS tmp
                            LEFT JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                       GROUP BY tmp.MovementId
                      )

        -- ограничиваем контрагентами там где они есть и где ноль всегда показываем      
      , tmpResult_ AS (SELECT tmpResult.* 
                            FROM tmpResult
                                 INNER JOIN tmpContractPartner ON tmpContractPartner.ContractConditionId = tmpResult.ContractConditionId
                                                              AND tmpContractPartner.PaidKindId_byBase   = tmpResult.PaidKindId_byBase
                                                              AND tmpContractPartner.PartnerId           = tmpResult.PartnerId
                                                              AND tmpContractPartner.ContractId          = tmpResult.ContractId_master
                           UNION 
                            SELECT tmpResult.*
                            FROM tmpResult
                            WHERE tmpResult.PartnerId = 0
                            )

      -- Результат
      SELECT tmpResult.JuridicalId
           , tmpResult.ContractId_master
           , tmpResult.ContractId_child
           , tmpResult.InfoMoneyId_child
           , tmpResult.PaidKindId_byBase
           , tmpResult.ContractConditionId
           , tmpResult.BranchId
           , 0 AS PartnerId --, tmpResult.PartnerId
           , tmpResult.Sum_Income -- Только приходы
           , tmpResult.Sum_IncomeReturnOut -- приход - возвраты
           , tmpResult.Sum_Account -- оплаты

           , tmpResult.Sum_Return  -- возврат

           , COALESCE (tmpResult_amount.Amount_in, 0)  AS Amount_in

           , COALESCE (tmpResult_amount.Amount_out, 0) AS Amount_out

           , tmpResult.MovementDescId
           , tmpResult.MovementId


      FROM tmpResult_ AS tmpResult
           LEFT JOIN tmpResult_amount ON tmpResult_amount.MovementId = tmpResult.MovementId
      );

    RETURN QUERY
      WITH
        tmpMovement AS (SELECT tmpGroup.JuridicalId
                             , tmpGroup.PartnerId
                             , tmpGroup.ContractId_master
                             , tmpGroup.ContractId_child
                             , tmpGroup.InfoMoneyId_child
                             , tmpGroup.PaidKindId_byBase
                             , tmpGroup.ContractConditionId
                             , tmpGroup.BranchId
                             , tmpGroup.MovementId
                             , tmpGroup.MovementDescId
                             , tmpGroup.Sum_Income
                             , tmpGroup.Sum_IncomeReturnOut
                             , tmpGroup.Sum_Account
                             , tmpGroup.Amount_in
                             , tmpGroup.Amount_out
                             --расчитывем % возврата факт = факт возврата / факт отгрузки * 100
                             , CASE WHEN COALESCE (tmpGroup.Sum_Income,0) <> 0 THEN tmpGroup.Sum_Return / tmpGroup.Sum_Income * 100 ELSE 0 END AS PercentRetBonus_fact
                        FROM
                            (SELECT tmpGroup.JuridicalId
                                  , tmpGroup.PartnerId
                                  , tmpGroup.ContractId_master
                                  , tmpGroup.ContractId_child
                                  , tmpGroup.InfoMoneyId_child
                                  , tmpGroup.PaidKindId_byBase
                                  , tmpGroup.ContractConditionId
                                  , tmpGroup.BranchId
                                  , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementId ELSE 0 END     AS MovementId
                                  , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementDescId ELSE 0 END AS MovementDescId
                                  , SUM (tmpGroup.Sum_Income)          AS Sum_Income
                                  , SUM (tmpGroup.Sum_IncomeReturnOut) AS Sum_IncomeReturnOut
                                  , SUM (tmpGroup.Sum_Account)         AS Sum_Account
                                  , SUM (tmpGroup.Sum_Return)          AS Sum_Return
                                  , SUM (tmpGroup.Amount_in)           AS Amount_in
                                  , SUM (tmpGroup.Amount_out)          AS Amount_out
                             FROM tmpBase AS tmpGroup
                             GROUP BY tmpGroup.JuridicalId
                                    , tmpGroup.PartnerId
                                    , tmpGroup.ContractId_child
                                    , tmpGroup.InfoMoneyId_child
                                    , tmpGroup.PaidKindId_byBase
                                    , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementId ELSE 0 END
                                    , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementDescId ELSE 0 END
                                    , tmpGroup.BranchId
                                    , tmpGroup.ContractConditionId
                                    , tmpGroup.ContractId_master
                             ) AS tmpGroup
                       )

      , tmpAll AS(SELECT tmp.*
                  FROM (SELECT tmpContract.InvNumber_master
                             , tmpContract.InvNumber_child
                             , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0
                                         THEN tmpContractBonus.InvNumber_find
                                    ELSE tmpContract.InvNumber_master
                               END AS InvNumber_find
      
                             , tmpContract.ContractTagName_child
                             , tmpContract.ContractStateKindCode_child
      
                             , tmpContract.ContractId_master
                             , tmpContract.ContractId_child
                             , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0
                                         THEN tmpContractBonus.ContractId_find
                                    ELSE tmpContract.ContractId_master
                               END AS ContractId_find
      
                             , tmpContract.InfoMoneyId_master
                             , tmpContract.InfoMoneyId_child
                             , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0
                                         THEN tmpContractBonus.InfoMoneyId_find
                                    WHEN tmpContract.InfoMoneyId_master = zc_Enum_InfoMoney_30101() -- Готовая продукция
                                         THEN zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                    WHEN tmpContract.InfoMoneyId_master = zc_Enum_InfoMoney_30201() -- Мясное сырье
                                         THEN zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                    ELSE tmpContract.InfoMoneyId_master
                               END AS InfoMoneyId_find
      
                             , tmpContract.JuridicalId AS JuridicalId
                             , tmpMovement.PartnerId
                             -- подменяем обратно ФО bз усл.договора на ФО из договора
                             , tmpContract.PaidKindId                                 --tmpMovement.PaidKindId AS PaidKindId
                             , View_Contract_InvNumber_child.PaidKindId   AS PaidKindId_child  --, tmpContract.PaidKindId_byBase  AS PaidKindId_child     -- ФО договора базы
                             , tmpContract.ContractConditionKindId
                             , tmpContract.BonusKindId
                             , COALESCE (tmpContract.Value,0) AS Value
                             , COALESCE (tmpContract.PercentRetBonus,0)     ::TFloat AS PercentRetBonus
                             , COALESCE (tmpMovement.PercentRetBonus_fact,0)::TFloat AS PercentRetBonus_fact
      
                             , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentIncome() THEN COALESCE (tmpMovement.Amount_in,0)                     --  база приход кг -tmpMovement.Sum_Income
                                          WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentIncomeReturn() THEN  (COALESCE (tmpMovement.Amount_in,0) - COALESCE (tmpMovement.Amount_out,0)) --база приход-возврат кг  --  tmpMovement.Sum_IncomeReturnOut
                                          WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN tmpMovement.Sum_Account
                                          WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentIncomeReturnS() THEN COALESCE (tmpMovement.Sum_IncomeReturnOut,0)
                                     ELSE 0 END  AS TFloat) AS Sum_CheckBonus
      
                             --когда % возврата факт превышает % возврата план, бонус не начисляется
                             , CAST (CASE WHEN (COALESCE (tmpContract.PercentRetBonus,0) <> 0 AND tmpMovement.PercentRetBonus_fact > tmpContract.PercentRetBonus) THEN 0
                                          ELSE
                                             CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentIncome()        THEN COALESCE (tmpMovement.Amount_in,0) * tmpContract.Value                                                ----(tmpMovement.Sum_Income/100 * tmpContract.Value)
                                                  WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentIncomeReturn()  THEN (COALESCE (tmpMovement.Amount_in,0) - COALESCE (tmpMovement.Amount_out,0)) * tmpContract.Value        ----(tmpMovement.Sum_IncomeReturnOut/100 * tmpContract.Value)
                                                  WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount()       THEN (tmpMovement.Sum_Account/100 * tmpContract.Value)
                                                  WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentIncomeReturnS() THEN COALESCE (tmpMovement.Sum_IncomeReturnOut,0) / 100 * tmpContract.Value 
                                             ELSE 0 END
                                     END  AS NUMERIC (16, 0)) AS Sum_Bonus
      
                             , 0 :: TFloat                  AS Sum_BonusFact
                             , 0 :: TFloat                  AS Sum_CheckBonusFact
                             , 0 :: TFloat                  AS Sum_IncomeFact
                             , COALESCE (tmpMovement.Sum_Account) AS Sum_Account
                             , COALESCE (tmpMovement.Sum_IncomeReturnOut) AS Sum_IncomeReturnOut
      
                             , tmpMovement.Amount_in
                             , tmpMovement.Amount_out
      
                             , COALESCE (tmpContract.Comment, '')  AS Comment
      
                             , COALESCE (tmpMovement.MovementId,0) AS MovementId
                             , tmpMovement.MovementDescId
                             , COALESCE (tmpMovement.BranchId,0)   AS BranchId
                        FROM tmpContract
                                  INNER JOIN tmpMovement ON tmpMovement.JuridicalId         = tmpContract.JuridicalId
                                                        AND tmpMovement.ContractId_child    = tmpContract.ContractId_child
                                                        AND tmpMovement.InfoMoneyId_child   = tmpContract.InfoMoneyId_child
                                                        AND tmpMovement.PaidKindId_byBase   = tmpContract.PaidKindId_byBase
                                                        AND tmpMovement.ContractConditionId = tmpContract.ContractConditionId
                                                        AND tmpMovement.ContractId_master   = tmpContract.ContractId_master
                                  LEFT JOIN tmpContractBonus ON tmpContractBonus.ContractId_master = tmpContract.ContractId_master
                                                            -- еще условие
                                                            AND tmpContractBonus.ContractConditionId = tmpContract.ContractConditionId
                                  LEFT JOIN tmpContract_full AS View_Contract_InvNumber_child  ON View_Contract_InvNumber_child.ContractId  = tmpContract.ContractId_child
                        ) AS tmp
                        --LEFT JOIN tmpContractPartner ON (tmpContractPartner.ContractId = tmp.ContractId_master AND tmpContractPartner.PartnerId = tmp.PartnerId)
                  --WHERE tmpContractPartner.ContractId IS NOT NULL OR COALESCE (tmp.PaidKindId_child, 0) = zc_Enum_PaidKind_FirstForm()
                UNION ALL
                  SELECT View_Contract_InvNumber_master.InvNumber AS InvNumber_master
                       , View_Contract_InvNumber_child.InvNumber AS InvNumber_child
                       , View_Contract_InvNumber_find.InvNumber AS InvNumber_find

                       , View_Contract_InvNumber_child.ContractTagName  AS ContractTagName_child
                       , View_Contract_InvNumber_child.ContractStateKindCode AS ContractStateKindCode_child

                       , MILinkObject_ContractMaster.ObjectId           AS ContractId_master
                       , MILinkObject_ContractChild.ObjectId            AS ContractId_child
                       , MILinkObject_Contract.ObjectId                 AS ContractId_find

                       , View_Contract_InvNumber_master.InfoMoneyId     AS InfoMoneyId_master
                       , View_Contract_InvNumber_child.InfoMoneyId      AS InfoMoneyId_child
                       , MILinkObject_InfoMoney.ObjectId                AS InfoMoneyId_find

                       , MovementItem.ObjectId                          AS JuridicalId
                       , 0                 AS PartnerId
                       , MILinkObject_PaidKind.ObjectId                 AS PaidKindId
                       , View_Contract_InvNumber_child.PaidKindId       AS PaidKindId_child
                       , MILinkObject_ContractConditionKind.ObjectId    AS ContractConditionKindId
                       , MILinkObject_BonusKind.ObjectId                AS BonusKindId
                       , COALESCE (MIFloat_BonusValue.ValueData,0)      AS Value
                       , 0 ::TFloat                                     AS PercentRetBonus
                       , 0 ::TFloat                                     AS PercentRetBonus_fact

                       , 0 :: TFloat                                    AS Sum_CheckBonus
                       , 0 :: TFloat                                    AS Sum_Bonus
                       , MovementItem.Amount                            AS Sum_BonusFact
                       , MIFloat_Summ.ValueData                         AS Sum_CheckBonusFact
                       , MIFloat_AmountPartner.ValueData                AS Sum_IncomeFact
                       , 0 :: TFloat                                    AS Sum_Account
                       , 0 :: TFloat                                    AS Sum_IncomeReturnOut
                       , 0 :: TFloat                                    AS Amount_in
                       , 0 :: TFloat                                    AS Amount_out

                       , COALESCE (MIString_Comment.ValueData,'')       AS Comment

                       , CASE WHEN inisMovement = TRUE THEN Movement.Id ELSE 0 END      AS MovementId
                       , CASE WHEN inisMovement = TRUE THEN Movement.DescId ELSE 0 END  AS MovementDescId
                       , COALESCE (MILinkObject_Branch.ObjectId,0)      AS BranchId
                FROM Movement
                       LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                       INNER JOIN tmpJuridical ON tmpJuridical.JuridicalId = MovementItem.ObjectId

                       LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                                   ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                                  AND MIFloat_BonusValue.DescId = zc_MIFloat_BonusValue()
                       LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                   ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                  AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                       LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                   ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                       LEFT JOIN MovementItemString AS MIString_Comment
                                                    ON MIString_Comment.MovementItemId = MovementItem.Id
                                                   AND MIString_Comment.DescId = zc_MIString_Comment()

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                        ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                        ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractMaster
                                                        ON MILinkObject_ContractMaster.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ContractMaster.DescId = zc_MILinkObject_ContractMaster()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                        ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                        ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                        ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                                        ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_BonusKind.DescId = zc_MILinkObject_BonusKind()

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                        ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

                       LEFT JOIN tmpContract_all AS View_Contract_InvNumber_find ON View_Contract_InvNumber_find.ContractId = MILinkObject_Contract.ObjectId
                       LEFT JOIN tmpContract_all AS View_Contract_InvNumber_master ON View_Contract_InvNumber_master.ContractId = MILinkObject_ContractMaster.ObjectId
                       LEFT JOIN tmpContract_full AS View_Contract_InvNumber_child ON View_Contract_InvNumber_child.ContractId = MILinkObject_ContractChild.ObjectId

                       --LEFT JOIN (SELECT tmpMovement.JuridicalId, MAX (tmpMovement.PartnerId) AS PartnerId FROM tmpMovement GROUP BY tmpMovement.JuridicalId) tmpInf ON tmpInf.JuridicalId = MovementItem.ObjectId
                  WHERE Movement.DescId = zc_Movement_ProfitIncomeService()
                    AND Movement.StatusId = zc_Enum_Status_Complete()
                    AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                    AND MILinkObject_InfoMoney.ObjectId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                          , zc_Enum_InfoMoney_21502()) -- Маркетинг + Бонусы за мясное сырье
                    AND (MovementItem.ObjectId = inJuridicalId OR inJuridicalId = 0)
                    -- AND MILinkObject_ContractConditionKind.ObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount(), zc_Enum_ContractConditionKind_BonusPercentIncomeReturn(), zc_Enum_ContractConditionKind_BonusPercentIncome())
                 )
      , tmpData AS (SELECT tmpAll.ContractId_master
                         , tmpAll.ContractId_child
                         , tmpAll.ContractId_find
                         , tmpAll.InvNumber_master
                         , tmpAll.InvNumber_child
                         , tmpAll.InvNumber_find
                         , tmpAll.ContractTagName_child
                         , tmpAll.ContractStateKindCode_child
                         , tmpAll.InfoMoneyId_master
                         , tmpAll.InfoMoneyId_child
                         , tmpAll.InfoMoneyId_find
                         , tmpAll.JuridicalId
                         , tmpAll.PartnerId
                         , tmpAll.PaidKindId
                         , tmpAll.PaidKindId_child
                         , tmpAll.ContractConditionKindId
                         , tmpAll.BonusKindId
                         , tmpAll.MovementId
                         , tmpAll.MovementDescId
                         , tmpAll.BranchId
                         , tmpAll.Value

                         , MAX (tmpAll.PercentRetBonus)     AS PercentRetBonus
                         , MAX (tmpAll.PercentRetBonus_fact) AS PercentRetBonus_fact  --*(-1)
                         , SUM (tmpAll.Sum_CheckBonus)      AS Sum_CheckBonus
                         , SUM (tmpAll.Sum_CheckBonusFact)  AS Sum_CheckBonusFact
                         , SUM (tmpAll.Sum_Bonus)           AS Sum_Bonus
                         , SUM (tmpAll.Sum_BonusFact)       AS Sum_BonusFact    --*(-1)
                         , SUM (tmpAll.Sum_IncomeFact)      AS Sum_IncomeFact
                         , SUM (tmpAll.Sum_Account)         AS Sum_Account
                         , SUM (tmpAll.Sum_IncomeReturnOut) AS Sum_IncomeReturnOut
                         , SUM (tmpAll.Amount_in)           AS Amount_in
                         , SUM (tmpAll.Amount_out)          AS Amount_out
                         , MAX (tmpAll.Comment) :: TVarChar AS Comment
                    FROM tmpAll
                    WHERE (tmpAll.Sum_CheckBonus > 0
                       OR tmpAll.Sum_Bonus > 0
                       OR tmpAll.Sum_BonusFact <> 0)
                      AND (tmpAll.PaidKindId = inPaidKindId OR inPaidKindId = 0)
                      AND (tmpAll.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                
                    GROUP BY  tmpAll.ContractId_master
                            , tmpAll.ContractId_child
                            , tmpAll.ContractId_find
                            , tmpAll.InvNumber_master
                            , tmpAll.InvNumber_child
                            , tmpAll.InvNumber_find
                            , tmpAll.ContractTagName_child
                            , tmpAll.ContractStateKindCode_child
                            , tmpAll.InfoMoneyId_master
                            , tmpAll.InfoMoneyId_child
                            , tmpAll.InfoMoneyId_find
                            , tmpAll.JuridicalId
                            , tmpAll.PartnerId
                            , tmpAll.PaidKindId
                            , tmpAll.ContractConditionKindId
                            , tmpAll.BonusKindId
                            , tmpAll.Value
                            , tmpAll.MovementId
                            , tmpAll.MovementDescId
                            , tmpAll.BranchId
                            , tmpAll.PaidKindId_child
                    )


      SELECT  Movement.OperDate                             AS OperDate_Movement
            , Movement.InvNumber                            AS InvNumber_Movement
            , MovementDesc.ItemName                         AS DescName_Movement
            , tmpData.ContractId_master
            , tmpData.ContractId_child
            , tmpData.ContractId_find
            , tmpData.InvNumber_master ::TVarChar
            , tmpData.InvNumber_child  ::TVarChar
            , tmpData.InvNumber_find   ::TVarChar

            , tmpData.ContractTagName_child        ::TVarChar
            , tmpData.ContractStateKindCode_child

            , Object_InfoMoney_master.Id                    AS InfoMoneyId_master
            , Object_InfoMoney_find.Id                      AS InfoMoneyId_find

            , Object_InfoMoney_master.ValueData             AS InfoMoneyName_master
            , Object_InfoMoney_child.ValueData              AS InfoMoneyName_child
            , Object_InfoMoney_find.ValueData               AS InfoMoneyName_find

            , Object_Juridical.Id                           AS JuridicalId
            , Object_Juridical.ValueData                    AS JuridicalName

            , Object_PaidKind.Id                            AS PaidKindId
            , Object_PaidKind.ValueData                     AS PaidKindName
            , Object_PaidKind_Child.ValueData               AS PaidKindName_Child

            , Object_ContractConditionKind.Id               AS ConditionKindId
            , Object_ContractConditionKind.ValueData        AS ConditionKindName

            , Object_BonusKind.Id                           AS BonusKindId
            , Object_BonusKind.ValueData                    AS BonusKindName

            , Object_Branch.Id                              AS BranchId
            , Object_Branch.ValueData                       AS BranchName

            , Object_Retail.ValueData                       AS RetailName
            , Object_Personal_View.PersonalCode             AS PersonalCode
            , Object_Personal_View.PersonalName             AS PersonalName
            , Object_Partner.Id                             AS PartnerId
            , Object_Partner.ValueData  ::TVarChar          AS PartnerName

            , CAST (tmpData.Value AS TFloat)                AS Value
            , CAST (tmpData.PercentRetBonus AS TFloat)      AS PercentRetBonus
            , CAST (tmpData.PercentRetBonus_fact AS TFloat) AS PercentRetBonus_fact

            , CAST (tmpData.Sum_CheckBonus AS TFloat)       AS Sum_CheckBonus
            , CAST (tmpData.Sum_CheckBonusFact AS TFloat)   AS Sum_CheckBonusFact
            , CAST (tmpData.Sum_Bonus      AS TFloat)       AS Sum_Bonus
            , CAST (tmpData.Sum_BonusFact  AS TFloat)       AS Sum_BonusFact
            , CAST (tmpData.Sum_IncomeFact   AS TFloat)     AS Sum_IncomeFact
            , CAST (tmpData.Sum_Account    AS TFloat)       AS Sum_Account
            , CAST (tmpData.Sum_IncomeReturnOut AS TFloat)  AS Sum_IncomeReturnOut

            , CAST (tmpData.Amount_in AS TFloat)            AS Amount_in
            , CAST (tmpData.Amount_out AS TFloat)           AS Amount_out
            , tmpData.Comment :: TVarChar                   AS Comment
      FROM tmpData
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId
            LEFT JOIN Object AS Object_PaidKind_Child ON Object_PaidKind_Child.Id = tmpData.PaidKindId_child
            LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = tmpData.BonusKindId
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpData.ContractConditionKindId
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpData.BranchId

            LEFT JOIN Object AS Object_InfoMoney_master ON Object_InfoMoney_master.Id = tmpData.InfoMoneyId_master
            LEFT JOIN Object AS Object_InfoMoney_child ON Object_InfoMoney_child.Id = tmpData.InfoMoneyId_child
            LEFT JOIN Object AS Object_InfoMoney_find ON Object_InfoMoney_find.Id = tmpData.InfoMoneyId_find

            LEFT JOIN Movement ON Movement.Id = tmpData.MovementId
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = tmpData.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

            --для бн берем из договора
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                 ON ObjectLink_Contract_PersonalTrade.ObjectId = tmpData.ContractId_master
                                AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                                AND tmpData.PaidKindId_child = zc_Enum_PaidKind_FirstForm()
            --LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId 
            --для нал берем из контрагента          
            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = tmpData.PartnerId
                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                AND (tmpData.PaidKindId_child = zc_Enum_PaidKind_SecondForm()
                                   OR COALESCE (ObjectLink_Contract_PersonalTrade.ChildObjectId,0) = 0
                                     )
            LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = COALESCE (ObjectLink_Partner_PersonalTrade.ChildObjectId, ObjectLink_Contract_PersonalTrade.ChildObjectId)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.20         * lpReport_CheckBonus_Income
*/

-- тест
-- select * from lpReport_CheckBonus_Income (inStartDate:= '15.03.2016', inEndDate:= '15.03.2016', inPaidKindID:= zc_Enum_PaidKind_FirstForm(), inJuridicalId:= 0, inBranchId:= 0, inSession:= zfCalc_UserAdmin());
-- select * from lpReport_CheckBonus_Income(inStartDate := ('28.05.2020')::TDateTime , inEndDate := ('28.05.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 344240 , inBranchId := 0 ,  inSession := '5');--
-- select * from lpReport_CheckBonus_Income(inStartDate := ('01.05.2020')::TDateTime , inEndDate := ('30.06.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 3834632 , inBranchId := 0 ,  inSession := '5');

--select * from lpReport_CheckBonus_Income(inStartDate := ('01.12.2020')::TDateTime , inEndDate := ('31.12.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 473873 , inBranchId := 0 ,  inSession := '5');
