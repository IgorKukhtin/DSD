 -- FunctiON: lpReport_CheckBonus_test ()

DROP FUNCTION IF EXISTS lpReport_CheckBonus_test (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION lpReport_CheckBonus_test (
    IN inStartDate           TDateTime ,
    IN inEndDate             TDateTime ,
    IN inPaidKindID          Integer   ,
    IN inJuridicalId         Integer   ,
    IN inBranchId            Integer   ,
    IN inMemberId            Integer   ,
    IN inisMovement          Boolean   , -- по документам
    IN inisDetail            Boolean   , -- детализация  выводим группу тов, произ площадку, Goods_Business, GoodsTag, GoodsGroupAnalyst
    IN inisGoods             Boolean   , -- выводим товар + вид товара
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate_Movement TDateTime, OperDatePartner TDateTime, InvNumber_Movement TVarChar, DescName_Movement TVarChar
             , ContractId_master Integer, ContractId_child Integer, ContractId_find Integer, InvNumber_master TVarChar, InvNumber_child TVarChar, InvNumber_find TVarChar
             , ContractTagName_child TVarChar, ContractStateKindCode_child Integer
             , InfoMoneyId_master Integer, InfoMoneyId_child Integer, InfoMoneyId_find Integer
             , InfoMoneyName_master TVarChar, InfoMoneyName_child TVarChar, InfoMoneyName_find TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , PaidKindId_Child Integer, PaidKindName_Child TVarChar
             , ConditionKindId Integer, ConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , BranchId_inf Integer, BranchName_inf TVarChar
             , RetailName TVarChar
             , PersonalTradeId Integer, PersonalTradeCode Integer, PersonalTradeName TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar

             , PartnerId Integer, PartnerName TVarChar
             , AreaId Integer, AreaName TVarChar
             , Value TFloat
             , PercentRetBonus TFloat
             , PercentRetBonus_fact TFloat
             , PercentRetBonus_diff TFloat

             , PercentRetBonus_fact_weight TFloat
             , PercentRetBonus_diff_weight TFloat

             , Sum_CheckBonus      TFloat
             , Sum_CheckBonusFact  TFloat
             , Sum_Bonus           TFloat
             , Sum_BonusFact       TFloat
             , Sum_SaleFact        TFloat
             , Sum_Account         TFloat
             , Sum_AccountSendDebt TFloat
             , Sum_Sale            TFloat
             , Sum_Return          TFloat
             , Sum_SaleReturnIn    TFloat

             , Sum_CheckBonus_curr      TFloat
             , Sum_Bonus_curr           TFloat
             , Sum_Account_curr         TFloat
             , Sum_AccountSendDebt_curr TFloat
             , Sum_Sale_curr            TFloat
             , Sum_Return_curr          TFloat
             , Sum_SaleReturnIn_curr    TFloat

             , Sum_Sale_weight     TFloat
             , Sum_ReturnIn_weight TFloat

             , Comment TVarChar
             , ReportBonusId Integer
             , isSend Boolean
             , FromName_Movement          TVarChar
             , ToName_Movement            TVarChar
             , PaidKindName_Movement      TVarChar
             , ContractCode_Movement      TVarChar
             , ContractName_Movement      TVarChar
             , ContractTagName_Movement   TVarChar
             , TotalCount_Movement        TFloat
             , TotalCountPartner_Movement TFloat
             , TotalSumm_Movement         TFloat
             , ContractConditionId        Integer
             , isSalePart Boolean
             , AmountKg  TFloat
             , AmountSh  TFloat
             , PartKg    TFloat

            , GoodsCode Integer
            , GoodsName TVarChar
            , GoodsKindName TVarChar
            , GoodsGroupName        TVarChar
            , GoodsGroupNameFull    TVarChar
            , BusinessName          TVarChar
            , GoodsTagName          TVarChar
            , GoodsPlatformName     TVarChar
            , GoodsGroupAnalystName TVarChar
            , CurrencyId_child   Integer 
            , CurrencyName_child TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
--    DECLARE inisMovement  Boolean ; -- по документам
    DECLARE vbEndDate     TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     --inisMovement:= FALSE;
     vbEndDate := inEndDate + INTERVAL '1 Day';

    RETURN QUERY
      WITH
           tmpPersonal_byMember AS (SELECT ObjectLink_Personal_Member.ObjectId AS PersonalId
                                    FROM ObjectLink AS ObjectLink_Personal_Member
                                    WHERE ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                      AND ObjectLink_Personal_Member.ChildObjectId = inMemberId
                                      AND COALESCE (inMemberId,0) <> 0
                                   /*UNION
                                    SELECT Object_Personal.Id AS PersonalId
                                    FROM Object AS Object_Personal
                                    WHERE Object_Personal.DescId = zc_Object_Personal()
                                      AND COALESCE (inMemberId,0) = 0*/
                                    )

         , tmpContract_full AS (SELECT View_Contract.*
                                FROM Object_Contract_View AS View_Contract
                                WHERE (View_Contract.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                )
         , tmpContract_all AS (SELECT *
                               FROM tmpContract_full
                               -- !!!отключил, теперь только через условие!!!
                               -- WHERE tmpContract_full.PaidKindId = inPaidKindId OR COALESCE (inPaidKindId, 0)  = 0
                              )
           -- все Договора - не закрытые или для Базы
         , tmpContract_find AS (SELECT View_Contract.*
                                FROM tmpContract_full AS View_Contract
                                WHERE View_Contract.isErased = FALSE
                                  AND (View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                    OR View_Contract.InfoMoneyId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                   , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                    )
                                      )
                               )
      -- Условия Договора на Дату
    , tmpContractCondition_all AS (SELECT Object_ContractCondition_View.ContractId
                                        , Object_ContractCondition_View.ContractConditionId
                                        , Object_ContractCondition_View.ContractConditionKindId

                                          -- Форма оплаты - в какой надо взять Базу
                                        , CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                 OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                 OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                                                    -- по !!!Условию!!! или по Договору
                                                    THEN COALESCE (Object_ContractCondition_View.PaidKindId_Condition, Object_ContractCondition_View.PaidKindId)
                                               -- по Договору
                                               ELSE Object_ContractCondition_View.PaidKindId
                                          END AS PaidKindId_byBase

                                          -- Форма оплаты - в какой надо начислить БОНУСЫ
                                        , CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                 OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                 OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                                                    -- по Договору
                                                    THEN Object_ContractCondition_View.PaidKindId
                                               -- !!!по Условию!!!
                                               WHEN Object_ContractCondition_View.PaidKindId_Condition > 0
                                                    THEN Object_ContractCondition_View.PaidKindId_Condition
                                               -- по Договору
                                               ELSE Object_ContractCondition_View.PaidKindId
                                          END AS PaidKindId_calc

                                          -- Значение - % бонуса
                                        , Object_ContractCondition_View.Value
                                   FROM Object_ContractCondition_View
                                        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = Object_ContractCondition_View.InfoMoneyId
                                   WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                                 , zc_Enum_ContractConditionKind_BonusMonthlyPayment()
                                                                                                 , 0
                                                                                               --, zc_Enum_ContractConditionKind_BonusPercentSalePart()
                                                                                                  )
                                     AND Object_ContractCondition_View.Value <> 0
                                   --AND inStartDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                     AND inEndDate   BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                )
          -- Условия Договора на Дату
        , tmpContractCondition AS (SELECT tmpContractCondition_all.ContractId
                                        , tmpContractCondition_all.ContractConditionId
                                        , tmpContractCondition_all.ContractConditionKindId
                                          -- Форма оплаты - в какой надо взять Базу
                                        , tmpContractCondition_all.PaidKindId_byBase
                                          -- Форма оплаты - в какой надо начислить БОНУСЫ
                                        , tmpContractCondition_all.PaidKindId_calc
                                          -- Значение - % бонуса
                                        , tmpContractCondition_all.Value
                                   FROM tmpContractCondition_all
                                   -- здесь ограничение по ФО
                                   WHERE tmpContractCondition_all.PaidKindId_calc = inPaidKindId
                                  )
           -- zc_Object_ContractPartner - т.е. БАЗУ берем только по этим точкам - если они установлены, иначе по всем
         , tmpContractPartner_all AS
                        (SELECT tmpContract_full.ContractId AS ContractId
                              , tmpContract_full.JuridicalId
                              , COALESCE (ObjectLink_ContractPartner_Partner.ChildObjectId,ObjectLink_Partner_Juridical.ObjectId)   AS PartnerId
                                -- Форма оплаты - в какой надо взять Базу
                              , tmpContractCondition.PaidKindId_byBase
                                -- Форма оплаты - в какой надо начислить БОНУСЫ
                              , tmpContractCondition.PaidKindId_calc
                              
                              -- если нужно считать по условиям - для НАЛ
                              --, CASE WHEN tmpContractCondition.PaidKindId_calc = zc_Enum_PaidKind_SecondForm() THEN tmpContractCondition.ContractConditionId ELSE 0 END AS ContractConditionId
                              --07,01,2022 - для БН тоже огр. по выбранным контрагентам
                              , tmpContractCondition.ContractConditionId
                         FROM tmpContract_full

                                  INNER JOIN tmpContractCondition
                                          ON tmpContractCondition.ContractId = tmpContract_full.ContractId
                                         AND tmpContractCondition.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                            , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                                                                            , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                            , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                             )
                                  -- Контрагенты в Договоре
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                       ON ObjectLink_ContractPartner_Contract.ChildObjectId = tmpContractCondition.ContractId
                                                      AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()

                                  LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                       ON ObjectLink_ContractPartner_Partner.ObjectId = ObjectLink_ContractPartner_Contract.ObjectId
                                                      AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()

                                   -- Юр лицо в Договоре
                                  LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                       ON ObjectLink_Contract_Juridical.ObjectId = tmpContract_full.ContractId --ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId      --  AS JuridicalId-- ObjectLink_Contract_Juridical.ObjectId = Object_Contract_InvNumber_View.ContractId
                                                      AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                      -- если такиех нет, берем ВСЕХ контрагентов
                                                      AND ObjectLink_ContractPartner_Partner.ChildObjectId IS NULL
                                  -- ВСЕ Контрагенты
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                     --!!!WHERE tmpContract_full.PaidKindId = inPaidKindId
                         )
           -- Для нал еще zc_Object_ContractConditionPartner - если выбраны то бонусы только на них считаем
              -- 07.01.2020 - для БН аналогично как и НАЛ
         , tmpCCPartner AS (SELECT tmp.ContractId
                                 , tmp.ContractConditionId
                                 , tmp.JuridicalId
                                 , tmp.PaidKindId_byBase
                                 , tmp.PaidKindId_calc
                                 , ObjectLink_ContractConditionPartner_Partner.ChildObjectId AS PartnerId
                            FROM (SELECT DISTINCT tmpContractPartner_all.ContractId, tmpContractPartner_all.ContractConditionId, tmpContractPartner_all.JuridicalId, tmpContractPartner_all.PaidKindId_byBase, tmpContractPartner_all.PaidKindId_calc
                                  FROM tmpContractPartner_all
                                 ) AS tmp
                                 LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                                      ON ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId = tmp.ContractConditionId
                                                     AND ObjectLink_ContractConditionPartner_ContractCondition.DescId        = zc_ObjectLink_ContractConditionPartner_ContractCondition()
                                 INNER JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                                       ON ObjectLink_ContractConditionPartner_Partner.ObjectId = ObjectLink_ContractConditionPartner_ContractCondition.ObjectId
                                                      AND ObjectLink_ContractConditionPartner_Partner.DescId   = zc_ObjectLink_ContractConditionPartner_Partner()
                           )

           -- объединяеем Контрагентов
         , tmpContractPartner AS (-- условия договора + zc_Object_ContractConditionPartner
                                  SELECT tmpContractPartner_all.ContractId
                                       , tmpContractPartner_all.JuridicalId
                                       , tmpContractPartner_all.PartnerId
                                       , tmpContractPartner_all.PaidKindId_byBase
                                       , tmpContractPartner_all.PaidKindId_calc
                                         -- значение только для НАЛ
                                       , tmpContractPartner_all.ContractConditionId
                              
                                  FROM tmpContractPartner_all
                                       INNER JOIN tmpCCPartner ON tmpCCPartner.ContractConditionId = tmpContractPartner_all.ContractConditionId
                                                              AND tmpCCPartner.PartnerId           = tmpContractPartner_all.PartnerId
                                --WHERE COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) <> 0

                                 UNION
                                  -- если нет в zc_Object_ContractConditionPartner - берем ВСЕХ
                                  SELECT tmpContractPartner_all.ContractId
                                       , tmpContractPartner_all.JuridicalId
                                       , tmpContractPartner_all.PartnerId
                                       , tmpContractPartner_all.PaidKindId_byBase
                                       , tmpContractPartner_all.PaidKindId_calc
                                         -- значение только для НАЛ
                                       , tmpContractPartner_all.ContractConditionId
                                  FROM tmpContractPartner_all
                                       LEFT JOIN tmpCCPartner ON tmpCCPartner.ContractConditionId = tmpContractPartner_all.ContractConditionId
                                                             AND tmpCCPartner.PartnerId           = tmpContractPartner_all.PartnerId
                                --WHERE COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) = 0
                                  WHERE tmpCCPartner.PartnerId IS NULL
                                    -- т.е. для "других" условий
                                    AND tmpContractPartner_all.ContractConditionId NOT IN (SELECT DISTINCT tmpCCPartner.ContractConditionId FROM tmpCCPartner)

                                 UNION
                                  -- если вдруг в zc_Object_ContractConditionPartner есть контрагенты, которых нет в договоре
                                  SELECT tmpCCPartner.ContractId
                                       , tmpCCPartner.JuridicalId
                                       , tmpCCPartner.PartnerId
                                       , tmpCCPartner.PaidKindId_byBase
                                       , tmpCCPartner.PaidKindId_calc
                                         -- если нужно считать по условиям - для НАЛ
                                       --, CASE WHEN tmpCCPartner.PaidKindId_calc = zc_Enum_PaidKind_SecondForm() THEN tmpCCPartner.ContractConditionId ELSE 0 END AS ContractConditionId
                                       , tmpCCPartner.ContractConditionId
                                  FROM tmpCCPartner
                                       LEFT JOIN tmpContractPartner_all ON tmpContractPartner_all.ContractConditionId = tmpCCPartner.ContractConditionId
                                                                        AND tmpContractPartner_all.PartnerId           = tmpCCPartner.PartnerId
                                  WHERE tmpContractPartner_all.PartnerId IS NULL
                                  --AND COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) <> 0
                                 )

       -- формируется список договоров, у которых есть условие по "Бонусам" ежемесячный платеж
     , tmpCCK_BonusMonthlyPayment AS (SELECT -- условие договора
                                             tmpContractCondition.ContractConditionKindId
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
                                                    OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
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
                                             -- Форма оплаты - в какой надо взять Базу
                                           , tmpContractCondition.PaidKindId_byBase
                                             -- Форма оплаты - в какой надо начислить БОНУСЫ
                                           , tmpContractCondition.PaidKindId_calc
                                             -- вид бонуса
                                           , ObjectLink_ContractCondition_BonusKind.ChildObjectId    AS BonusKindId
                                           , COALESCE (tmpContractCondition.Value, 0)                AS Value
                                           , COALESCE (ObjectFloat_PercentRetBonus.ValueData,0)      AS PercentRetBonus
                                           , COALESCE (Object_Comment.ValueData, '')                 AS Comment

                                             -- !!!прописано - где брать "базу" или маркет-договор начисления!!!
                                        --, ObjectLink_ContractCondition_ContractSend.ChildObjectId AS ContractId_send

                                             -- если нужно считать по условиям - для НАЛ
                                          -- , CASE WHEN tmpContractCondition.PaidKindId_calc = zc_Enum_PaidKind_SecondForm() THEN tmpContractCondition.ContractConditionId ELSE 0 END AS ContractConditionId
                                           , tmpContractCondition.ContractConditionId

                                      FROM tmpContractCondition
                                           -- а это сам договор, в котором бонусное условие
                                           INNER JOIN tmpContract_find AS View_Contract
                                                                       ON View_Contract.ContractId = tmpContractCondition.ContractId
                                                                      --AND View_Contract.PaidKindId = tmpContractCondition.PaidKindId_calc
                                           -- % возврата план
                                           LEFT JOIN ObjectFloat AS ObjectFloat_PercentRetBonus
                                                                 ON ObjectFloat_PercentRetBonus.ObjectId = tmpContractCondition.ContractConditionId
                                                                AND ObjectFloat_PercentRetBonus.DescId = zc_ObjectFloat_ContractCondition_PercentRetBonus()

                                           -- !!!прописано - где брать "базу" или маркет-договор начисления!!!
                                         --LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                         --                     ON ObjectLink_ContractCondition_ContractSend.ObjectId = tmpContractCondition.ContractConditionId
                                         --                    AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
                                           -- для ContractId_send
                                         --LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_send
                                         --                     ON ObjectLink_Contract_InfoMoney_send.ObjectId = ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                         --                    AND ObjectLink_Contract_InfoMoney_send.DescId   = zc_ObjectLink_Contract_InfoMoney()

                                           LEFT JOIN Object AS Object_Comment ON Object_Comment.Id = tmpContractCondition.ContractConditionId

                                           -- Вид бонуса
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                                ON ObjectLink_ContractCondition_BonusKind.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_BonusKind.DescId   = zc_ObjectLink_ContractCondition_BonusKind()
                                           -- УП статья в условии договора
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                                                                ON ObjectLink_ContractCondition_InfoMoney.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_InfoMoney.DescId   = zc_ObjectLink_ContractCondition_InfoMoney()
                                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId

                                      -- только такое уловия
                                      WHERE tmpContractCondition.ContractConditionKindId = zc_Enum_ContractConditionKind_BonusMonthlyPayment()
                                     )
         -- список договоров, у которых есть условие по "Бонусам"
       , tmpContractConditionKind AS (SELECT -- условие договора
                                             tmpContractCondition.ContractConditionKindId AS ContractConditionKindId
                                           , View_Contract.JuridicalId
                                           , View_Contract.InvNumber             AS InvNumber_master
                                           , View_Contract.ContractTagId         AS ContractTagId_master
                                           , View_Contract.ContractTagName       AS ContractTagName_master
                                           , View_Contract.ContractStateKindCode AS ContractStateKindCode_master
                                             -- договор, в котором бонусное условие
                                           , View_Contract.ContractId            AS ContractId_master
                                             -- статья из договора
                                           , View_InfoMoney.InfoMoneyId AS InfoMoneyId_master
                                             -- статья по которой будет поиск Базы
                                           , CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                    OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
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

                                             -- статья из условия - ограничение при поиске маркет-договор начисления
                                           , COALESCE (ObjectLink_ContractCondition_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_Condition
                                             -- Форма оплаты - в какой надо взять Базу
                                           , tmpContractCondition.PaidKindId_byBase
                                             -- Форма оплаты - в какой надо начислить БОНУСЫ
                                           , tmpContractCondition.PaidKindId_calc
                                             -- вид бонуса
                                           , ObjectLink_ContractCondition_BonusKind.ChildObjectId    AS BonusKindId
                                           , COALESCE (tmpContractCondition.Value, 0)                AS Value
                                           , COALESCE (ObjectFloat_PercentRetBonus.ValueData,0)      AS PercentRetBonus
                                           , COALESCE (Object_Comment.ValueData, '')                 AS Comment

                                           -- !!!прописано - где брать "базу" или маркет-договор начисления!!!
                                           --, ObjectLink_ContractCondition_ContractSend.ChildObjectId AS ContractId_send
                                             -- !!!прописано - где брать маркет-договор начисления!!!
                                           , CASE WHEN ObjectLink_Contract_InfoMoney_send.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                          , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                           )
                                                   AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                                                    , zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                                                    , zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                                                                                     )
                                                  THEN 0
                                                  ELSE ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                             END AS ContractId_send

                                             -- !!!прописано - где брать "базу"!!!
                                           , CASE WHEN ObjectLink_Contract_InfoMoney_send.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                          , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                           )
                                                   AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                                                    , zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                                                    , zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                                                                                     )
                                                  THEN ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                                  ELSE 0
                                             END AS ContractId_baza

                                             -- если нужно считать по условиям - для НАЛ
                                           --, CASE WHEN tmpContractCondition.PaidKindId_calc = zc_Enum_PaidKind_SecondForm() THEN tmpContractCondition.ContractConditionId ELSE 0 END AS ContractConditionId
                                           , tmpContractCondition.ContractConditionId

                                      FROM tmpContractCondition
                                           -- а это сам договор, в котором бонусное условие
                                           INNER JOIN tmpContract_find AS View_Contract ON View_Contract.ContractId = tmpContractCondition.ContractId
                                                                                     --AND View_Contract.PaidKindId = inPaidKindId
                                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId

                                           LEFT JOIN Object AS Object_Comment ON Object_Comment.Id = tmpContractCondition.ContractConditionId
                                           -- % возврата план
                                           LEFT JOIN ObjectFloat AS ObjectFloat_PercentRetBonus
                                                                 ON ObjectFloat_PercentRetBonus.ObjectId = tmpContractCondition.ContractConditionId
                                                                AND ObjectFloat_PercentRetBonus.DescId   = zc_ObjectFloat_ContractCondition_PercentRetBonus()

                                           -- !!!прописано - где брать "базу" или маркет-договор начисления!!!
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                                                ON ObjectLink_ContractCondition_ContractSend.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
                                           -- для ContractId_send
                                           LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_send
                                                                ON ObjectLink_Contract_InfoMoney_send.ObjectId = ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                                               AND ObjectLink_Contract_InfoMoney_send.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                           -- Вид бонуса
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                                ON ObjectLink_ContractCondition_BonusKind.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_BonusKind.DescId   = zc_ObjectLink_ContractCondition_BonusKind()
                                           -- УП статья в условии договора
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                                                                ON ObjectLink_ContractCondition_InfoMoney.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_InfoMoney.DescId   = zc_ObjectLink_ContractCondition_InfoMoney()
                                      -- только такие уловия
                                      WHERE tmpContractCondition.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                           , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                                                                           , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                           , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                            )
                                     )
      -- для договоров (если !!!заполнены уп-статьи для условий!!!) надо найти бонусный договор (по 4-м ключам + пусто в "Типы условий договоров")
      -- т.е. условие есть в базовых, но надо подставить "маркет-договор" и начисления провести на него
     , tmpContractBonus AS (SELECT DISTINCT
                                  tmpContract_find.ContractId_master
                                , tmpContract_find.ContractId_find
                                , View_Contract_InvNumber_find.InfoMoneyId AS InfoMoneyId_find
                                , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find
                                  -- условия
                                , tmpContract_find.ContractConditionId
                           FROM (-- базовые договора в которых "бонусное" условие + ContractId_send
                                 SELECT DISTINCT
                                        tmpContractConditionKind.ContractId_master AS ContractId_master
                                        --
                                      , tmpContractConditionKind.ContractId_send   AS ContractId_find
                                        --
                                      , tmpContractConditionKind.ContractConditionId

                                 FROM tmpContractConditionKind
                                      LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_send
                                                           ON ObjectLink_Contract_InfoMoney_send.ObjectId = tmpContractConditionKind.ContractId_send
                                                          AND ObjectLink_Contract_InfoMoney_send.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                 -- !!!прописано - где брать "маркет-договор"!!!
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
                                      -- условие договора НЕ удален
                                      INNER JOIN tmpContractCondition ON tmpContractCondition.ContractConditionId = ObjectLink_ContractCondition_BonusKind.ObjectId
                                                                      -- с этим процентом
                                                                      AND tmpContractCondition.Value = tmpContractConditionKind.Value
                                      -- ПОИСК 1 - по 3 - м условиям, главное - ContractTagId_master
                                      LEFT JOIN tmpContract_all AS View_Contract_find_tag
                                                                ON View_Contract_find_tag.JuridicalId   = tmpContractConditionKind.JuridicalId
                                                               AND View_Contract_find_tag.InfoMoneyId   = tmpContractConditionKind.InfoMoneyId_Condition
                                                               AND View_Contract_find_tag.ContractTagId = tmpContractConditionKind.ContractTagId_master
                                                               AND tmpContractConditionKind.ContractId_send IS NULL
                                                               -- как-то работало и без этого условия
                                                               AND View_Contract_find_tag.ContractId    = tmpContractCondition.ContractId

                                      -- ПОИСК 2 - по 3 - м условиям - любой, т.е. в нем будет другой ContractTagId_master
                                      LEFT JOIN tmpContract_all AS View_Contract_find
                                                                ON View_Contract_find.JuridicalId = tmpContractConditionKind.JuridicalId
                                                               AND View_Contract_find.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_Condition
                                                               AND View_Contract_find.ContractId  = tmpContractCondition.ContractId
                                                               AND View_Contract_find_tag.ContractId        IS NULL
                                                               AND tmpContractConditionKind.ContractId_send IS NULL
                                 WHERE -- есть статья в условии договора
                                       tmpContractConditionKind.InfoMoneyId_Condition <> 0
                                       -- !!!НЕТ самого условия договора!!!
                                   AND COALESCE (tmpContractCondition.ContractConditionKindId, 0) = 0
                                       -- !!!НЕ прописано - где брать "маркет-договор"!!!
                                   AND tmpContractConditionKind.ContractId_send IS NULL
                                       -- !!!НЕ прописано - где брать "базу"!!!
                                   AND tmpContractConditionKind.ContractId_baza IS NULL

                                 GROUP BY tmpContractConditionKind.ContractId_master, tmpContractConditionKind.ContractConditionId
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
                             -- Форма оплаты - в какой надо взять Базу
                           , tmpContractConditionKind.PaidKindId_byBase
                             -- Форма оплаты - в какой надо начислить БОНУСЫ
                           , tmpContractConditionKind.PaidKindId_calc
                             --
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                           , tmpContractConditionKind.ContractConditionId
                      FROM tmpContractConditionKind
                      -- это будут не бонусные договора (но в них есть бонусы)
                      WHERE tmpContractConditionKind.InfoMoneyId_master = tmpContractConditionKind.InfoMoneyId_child

                    UNION ALL
                      SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.InvNumber_master
                             -- замена
                           , View_Contract_child.InvNumber             AS InvNumber_child
                             --
                           , tmpContractConditionKind.ContractId_master
                             -- замена
                           , View_Contract_child.ContractId            AS ContractId_child
                             -- замена
                           , View_Contract_child.ContractTagName       AS ContractTagName_child
                             -- замена
                           , View_Contract_child.ContractStateKindCode AS ContractStateKindCode_child
                             --
                           , tmpContractConditionKind.InfoMoneyId_master
                           , tmpContractConditionKind.InfoMoneyId_child
                             --
                           , tmpContractConditionKind.InfoMoneyId_Condition
                             -- Форма оплаты - в какой надо взять Базу
                           , tmpContractConditionKind.PaidKindId_byBase
                             -- Форма оплаты - в какой надо начислить БОНУСЫ
                           , tmpContractConditionKind.PaidKindId_calc
                             --
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                           , tmpContractConditionKind.ContractConditionId
                      FROM tmpContractConditionKind
                           LEFT JOIN tmpContract_full AS View_Contract_child ON View_Contract_child.ContractId = tmpContractConditionKind.ContractId_baza
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child
                        -- в бонусном договоре точно указано где взять базу
                        AND tmpContractConditionKind.ContractId_baza > 0

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
                             -- Форма оплаты - в какой надо взять Базу
                           , tmpContractConditionKind.PaidKindId_byBase
                             -- Форма оплаты - в какой надо начислить БОНУСЫ
                           , tmpContractConditionKind.PaidKindId_calc
                             --
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                           , tmpContractConditionKind.ContractConditionId
                      FROM tmpContractConditionKind
                           INNER JOIN tmpContract_full AS View_Contract_child
                                                       ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                                      AND View_Contract_child.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child
                      -- это будут бонусные договора
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child
                        -- НЕ указано где взять базу
                        AND tmpContractConditionKind.ContractId_baza = 0
                     )

      -- группируем договора, т.к. "базу" будем формировать по 4-м ключам
    , tmpContractGroup AS (SELECT DISTINCT
                                  tmpContract.JuridicalId
                                , tmpContract.ContractId_master
                                , tmpContract.ContractId_child
                                , tmpContract.InfoMoneyId_child
                                , tmpContract.PaidKindId_calc
                                , tmpContract.PaidKindId_byBase
                                , tmpContract.ContractConditionId
                           FROM tmpContract
                           -- WHERE (tmpContract.PaidKindId = inPaidKindId OR inPaidKindId = 0)
                           --  AND (tmpContract.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                          )

      -- список AccountId по которым будет расчет "базы" - без Транзит
    , tmpAccount AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId <> zc_Enum_AccountGroup_110000())

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
                            AND Container.DescId IN (zc_Container_Summ(), zc_Container_SummCurrency())
                         )

    , tmpContainer1 AS (SELECT DISTINCT
                               tmpContainerAll.Id  AS ContainerId
                             , tmpContainerAll.ParentId
                             , tmpContractGroup.JuridicalId
                             , tmpContractGroup.ContractId_master
                             , tmpContractGroup.ContractId_child
                             , tmpContractGroup.InfoMoneyId_child
                             , tmpContractGroup.PaidKindId_calc
                             , tmpContractGroup.PaidKindId_byBase
                             , tmpContractGroup.ContractConditionId
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
                       -- WHERE COALESCE (ContainerLO_Branch.ObjectId,0) = inBranchId OR inBranchId = 0
                       )

     , tmpContainer AS (SELECT tmpContainer1.*
                             , 0 AS PartnerId
                       FROM tmpContainer1
                       )

     , tmpContainerBasis AS (SELECT tmpContainer.JuridicalId
                                  , tmpContainer.ContractId_child
                                  , tmpContainer.ContractId_master
                                  , tmpContainer.InfoMoneyId_child
                                  , tmpContainer.PaidKindId_calc
                                  , tmpContainer.PaidKindId_byBase
                                  , tmpContainer.ContractConditionId

                                  , COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) AS BranchId
                                  , CASE WHEN Object.DescId = zc_Object_Partner() THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                                         ELSE 0
                                    END    AS PartnerId
                                    -- Только продажи
                                  ,  (CASE WHEN (MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_PriceCorrective()) AND tmpContainer.PaidKindId_calc = zc_Enum_PaidKind_SecondForm())
                                             OR (MIContainer.MovementDescId IN (zc_Movement_Sale()) AND tmpContainer.PaidKindId_calc <> zc_Enum_PaidKind_SecondForm())
                                                THEN COALESCE (MIContainer.Amount,0)
                                           ELSE 0
                                      END) AS Sum_Sale
                                    -- продажи - возвраты
                                  ,  (CASE WHEN (MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) AND tmpContainer.PaidKindId_calc = zc_Enum_PaidKind_SecondForm())
                                             OR (MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) AND tmpContainer.PaidKindId_calc <> zc_Enum_PaidKind_SecondForm())
                                                THEN COALESCE (MIContainer.Amount, 0)
                                           ELSE 0
                                      END) AS Sum_SaleReturnIn
                                    -- оплаты
                                  ,  (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
                                                   THEN -1 * COALESCE (MIContainer.Amount, 0)
                                              ELSE 0
                                         END) AS Sum_Account
                                    -- оплаты + взаимозачет
                                  ,  (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())
                                                   THEN -1 * COALESCE (MIContainer.Amount, 0)
                                              ELSE 0
                                         END) AS Sum_AccountSendDebt

                                  ,  (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sum_Return  -- возврат

                                  ,  0 AS Sum_Sale_curr
                                  ,  0 AS Sum_SaleReturnIn_curr
                                  ,  0 AS Sum_Account_curr
                                  ,  0 AS Sum_AccountSendDebt_curr
                                  ,  0 AS Sum_Return_curr

                                  , MIContainer.MovementDescId  AS MovementDescId
                                  , MIContainer.MovementId      AS MovementId

                                --если детализация или по товарам + товар - потом его свойства
                                  , MIContainer.ObjectId_analyzer    AS GoodsId
                                  , MIContainer.ObjectintId_analyzer AS GoodsKindId
                                  , MIContainer.ContainerId
                             FROM MovementItemContainer AS MIContainer
                                  JOIN tmpContainer ON tmpContainer.ContainerId = MIContainer.ContainerId

                                  LEFT JOIN Object ON Object.Id = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END

                                  -- для Базы БН получаем филиал по сотруднику из договора, по ведомости
                                  LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                                       ON ObjectLink_Contract_PersonalTrade.ObjectId = tmpContainer.ContractId_master
                                                      AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                                                      AND tmpContainer.PaidKindId_byBase = zc_Enum_PaidKind_FirstForm()

                                  -- для Базы нал берем филиал по сотруднику из контрагента, по ведомости
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                       ON ObjectLink_Partner_PersonalTrade.ObjectId = CASE WHEN Object.DescId = zc_Object_Partner() THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END ELSE 0 END
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
                               AND (MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < vbEndDate)
                               AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt(), zc_Movement_PriceCorrective())  -- взаимозачет убираем, чтоб он не влиял на бонусы
                               AND (COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) = inBranchId OR inBranchId = 0)
                             )

      , tmpContainerCurr AS (SELECT tmpContainer.JuridicalId
                                          , tmpContainer.ContractId_child
                                          , tmpContainer.ContractId_master
                                          , tmpContainer.InfoMoneyId_child
                                          , tmpContainer.PaidKindId_calc
                                          , tmpContainer.PaidKindId_byBase
                                          , tmpContainer.ContractConditionId

                                          , COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) AS BranchId
                                          , CASE WHEN Object.DescId = zc_Object_Partner() THEN Object.Id
                                                 ELSE 0
                                            END    AS PartnerId

                                          ,  0 AS Sum_Sale
                                          ,  0 AS Sum_SaleReturnIn
                                          ,  0 AS Sum_Account
                                          ,  0 AS Sum_AccountSendDebt
                                          ,  0 AS Sum_Return

                                            -- Только продажи
                                          ,  (CASE WHEN (MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_PriceCorrective()) AND tmpContainer.PaidKindId_calc = zc_Enum_PaidKind_SecondForm())
                                                     OR (MIContainer.MovementDescId IN (zc_Movement_Sale()) AND tmpContainer.PaidKindId_calc <> zc_Enum_PaidKind_SecondForm())
                                                        THEN COALESCE (MIContainer.Amount,0)
                                                   ELSE 0
                                              END) AS Sum_Sale_curr
                                            -- продажи - возвраты
                                          ,  (CASE WHEN (MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) AND tmpContainer.PaidKindId_calc = zc_Enum_PaidKind_SecondForm())
                                                     OR (MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) AND tmpContainer.PaidKindId_calc <> zc_Enum_PaidKind_SecondForm())
                                                        THEN COALESCE (MIContainer.Amount, 0)
                                                   ELSE 0
                                              END) AS Sum_SaleReturnIn_curr
                                            -- оплаты
                                          ,  (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
                                                           THEN -1 * COALESCE (MIContainer.Amount, 0)
                                                      ELSE 0
                                                 END) AS Sum_Account_curr
                                            -- оплаты + взаимозачет
                                          ,  (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())
                                                           THEN -1 * COALESCE (MIContainer.Amount, 0)
                                                      ELSE 0
                                                 END) AS Sum_AccountSendDebt_curr

                                          ,  (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sum_Return_curr  -- возврат

                                          , MIContainer.MovementDescId  AS MovementDescId
                                          , MIContainer.MovementId      AS MovementId

                                        --если детализация или по товарам + товар - потом его свойства
                                          , MIContainer.ObjectId_analyzer    AS GoodsId
                                          , MIContainer.ObjectintId_analyzer AS GoodsKindId
                                          , MIContainer.ContainerId
                                     FROM MovementItemContainer AS MIContainer
                                          JOIN tmpContainer ON tmpContainer.ContainerId = MIContainer.ContainerId

                                          --по проводкам по Container.ParentId - пробуем получить Контрагента
                                          LEFT JOIN (SELECT DISTINCT tmpContainerBasis.ContainerId
                                                                    , tmpContainerBasis.MovementId
                                                                    , tmpContainerBasis.JuridicalId
                                                                    , tmpContainerBasis.ContractId_master
                                                                    , tmpContainerBasis.ContractId_child
                                                                    , tmpContainerBasis.PaidKindId_byBase
                                                                    , tmpContainerBasis.ContractConditionId
                                                                    , tmpContainerBasis.PartnerId
                                                               FROM tmpContainerBasis) AS tmpPartner ON tmpPartner.ContainerId        = tmpContainer.ParentId
                                                                                                    AND tmpPartner.MovementId         = MIContainer.MovementId
                                                                                                    AND tmpPartner.JuridicalId        = tmpContainer.JuridicalId
                                                                                                    AND tmpPartner.ContractId_master  = tmpContainer.ContractId_master
                                                                                                    AND tmpPartner.ContractId_child   = tmpContainer.ContractId_child
                                                                                                    AND tmpPartner.PaidKindId_byBase  = tmpContainer.PaidKindId_byBase
                                                                                                    AND tmpPartner.ContractConditionId= tmpContainer.ContractConditionId

                                          LEFT JOIN Object ON Object.Id = COALESCE (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END , tmpPartner.PartnerId)

                                          -- для Базы БН получаем филиал по сотруднику из договора, по ведомости
                                          LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                                               ON ObjectLink_Contract_PersonalTrade.ObjectId = tmpContainer.ContractId_master
                                                              AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                                                              AND tmpContainer.PaidKindId_byBase = zc_Enum_PaidKind_FirstForm()

                                          -- для Базы нал берем филиал по сотруднику из контрагента, по ведомости
                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                               ON ObjectLink_Partner_PersonalTrade.ObjectId = CASE WHEN Object.DescId = zc_Object_Partner() THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END ELSE 0 END
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

                                     WHERE MIContainer.DescId = zc_MIContainer_SummCurrency()
                                       AND (MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < vbEndDate)
                                       AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt(), zc_Movement_PriceCorrective())  -- взаимозачет убираем, чтоб он не влиял на бонусы
                                       AND (COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) = inBranchId OR inBranchId = 0)
                             )

        -- получили базу по MovementId
      , tmpMovementContALL AS (SELECT tmp.JuridicalId
                                    , tmp.ContractId_child
                                    , tmp.ContractId_master
                                    , tmp.InfoMoneyId_child
                                    , tmp.PaidKindId_calc
                                    , tmp.PaidKindId_byBase
                                    , tmp.ContractConditionId
                                    , tmp.BranchId
                                    , tmp.PartnerId
                                    , SUM (tmp.Sum_Sale)            AS Sum_Sale
                                    , SUM (tmp.Sum_SaleReturnIn)    AS Sum_SaleReturnIn
                                    , SUM (tmp.Sum_Account)         AS Sum_Account
                                    , SUM (tmp.Sum_AccountSendDebt) AS Sum_AccountSendDebt
                                    , SUM (tmp.Sum_Return)          AS Sum_Return -- возврат

                                    , SUM (tmp.Sum_Sale_curr)            AS Sum_Sale_curr
                                    , SUM (tmp.Sum_SaleReturnIn_curr)    AS Sum_SaleReturnIn_curr
                                    , SUM (tmp.Sum_Account_curr)         AS Sum_Account_curr
                                    , SUM (tmp.Sum_AccountSendDebt_curr) AS Sum_AccountSendDebt_curr
                                    , SUM (tmp.Sum_Return_curr)          AS Sum_Return_curr

                                    , tmp.MovementDescId
                                    , tmp.MovementId
                                    , CASE WHEN inisDetail = TRUE OR inisGoods = TRUE THEN tmp.GoodsId ELSE 0 END AS GoodsId
                                    , CASE WHEN inisGoods = TRUE THEN tmp.GoodsKindId ELSE 0 END                  AS GoodsKindId
                               FROM (SELECT *
                                     FROM tmpContainerBasis
                                 UNION ALL
                                     SELECT *
                                     FROM tmpContainerCurr
                                     ) AS tmp
                               GROUP BY tmp.JuridicalId
                                      , tmp.ContractId_child
                                      , tmp.InfoMoneyId_child
                                      , tmp.PaidKindId_calc
                                      , tmp.PaidKindId_byBase
                                      , tmp.MovementDescId
                                      , tmp.MovementId
                                      , tmp.BranchId
                                      , tmp.PartnerId
                                      , tmp.ContractConditionId
                                      , tmp.ContractId_master
                                      , CASE WHEN inisDetail = TRUE OR inisGoods = TRUE THEN tmp.GoodsId ELSE 0 END
                                      , CASE WHEN inisGoods = TRUE THEN tmp.GoodsKindId ELSE 0 END
                              )

      , tmpMI_ContALL AS (SELECT MovementItem.*
                          FROM MovementItem
                          WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementContALL.MovementId FROM tmpMovementContALL)
                         )
      , tmpMIOL_GoodsKind AS (SELECT MovementItemLinkObject.*
                              FROM MovementItemLinkObject
                              WHERE MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                 AND MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_ContALL.Id FROM tmpMI_ContALL)
                              )

        -- по документам нужно получить вес
      , tmpWeight AS (SELECT tmp.MovementId
                           -- если детализация или по товарам + товар - потом его свойства
                           , CASE WHEN inisDetail = TRUE OR inisGoods = TRUE THEN MovementItem.ObjectId ELSE 0 END AS GoodsId
                           , CASE WHEN inisGoods = TRUE THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END            AS GoodsKindId

                           , SUM (CASE WHEN tmp.MovementDescId = zc_Movement_Sale() THEN COALESCE(MIFloat_AmountPartner.ValueData,0) ELSE 0 END
                                * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                 ) AS Sale_AmountPartner_Weight

                           , SUM (CASE WHEN tmp.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE(MIFloat_AmountPartner.ValueData,0) ELSE 0 END
                                * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                 ) AS Return_AmountPartner_Weight
                      FROM (SELECT DISTINCT tmpMovementContALL.MovementId, tmpMovementContALL.MovementDescId  --, tmpMovementContALL.GoodsId, tmpMovementContALL.GoodsKindId
                            FROM tmpMovementContALL
                            ) AS tmp
                            LEFT JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                            LEFT JOIN tmpMIOL_GoodsKind AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                      GROUP BY tmp.MovementId
                             , CASE WHEN inisDetail = TRUE OR inisGoods = TRUE THEN MovementItem.ObjectId ELSE 0 END
                             , CASE WHEN inisGoods = TRUE THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END
                      )

        -- ограничиваем контрагентами там где они есть и где ноль всегда показываем
      , tmpMovementCont AS (SELECT tmpMovementContALL.*
                            FROM tmpMovementContALL
                                 INNER JOIN tmpContractPartner ON tmpContractPartner.ContractConditionId = tmpMovementContALL.ContractConditionId
                                                              AND tmpContractPartner.PaidKindId_byBase   = tmpMovementContALL.PaidKindId_byBase
                                                              AND tmpContractPartner.PartnerId           = tmpMovementContALL.PartnerId
                                                              AND tmpContractPartner.ContractId          = tmpMovementContALL.ContractId_master
                           UNION
                            SELECT tmpMovementContALL.*
                            FROM tmpMovementContALL
                            WHERE tmpMovementContALL.PartnerId = 0
                            )
       -- Для товаров выбираем необх. свойства
      , tmpGoodsParam AS (SELECT tmpGoods.GoodsId
                               , Object_GoodsGroup.ValueData     AS GoodsGroupName
                               , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                               , Object_Business.ValueData       AS BusinessName
                               , Object_GoodsTag.ValueData       AS GoodsTagName
                               , Object_GoodsPlatform.ValueData  AS GoodsPlatformName
                               , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
                          FROM (SELECT DISTINCT tmpMovementCont.GoodsId FROM tmpMovementCont) AS tmpGoods
 
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                    ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                               LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                  
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                                    ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
                               LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                    ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                               LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

                               LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                      ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                     AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                                    ON ObjectLink_Goods_GoodsPlatform.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                               LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                                    ON ObjectLink_Goods_Business.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                               LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Goods_Business.ChildObjectId
                          )

       -- сгруппировываем данные и подвязываем вес
      , tmpGroupMov AS (SELECT tmpGroup.JuridicalId
                             , tmpGroup.PartnerId
                             , tmpGroup.ContractId_master
                             , tmpGroup.ContractId_child
                             , tmpGroup.InfoMoneyId_child
                             , tmpGroup.PaidKindId_calc
                             , tmpGroup.PaidKindId_byBase
                             , tmpGroup.ContractConditionId
                             , tmpGroup.BranchId
                             , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementId ELSE 0 END      AS MovementId
                             , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementDescId ELSE 0 END  AS MovementDescId

                             , SUM (tmpGroup.Sum_Sale)            AS Sum_Sale
                             , SUM (tmpGroup.Sum_SaleReturnIn)    AS Sum_SaleReturnIn
                             , SUM (tmpGroup.Sum_Account)         AS Sum_Account
                             , SUM (tmpGroup.Sum_AccountSendDebt) AS Sum_AccountSendDebt
                             , SUM (tmpGroup.Sum_Return)          AS Sum_Return

                             , SUM (tmpGroup.Sum_Sale_curr)            AS Sum_Sale_curr
                             , SUM (tmpGroup.Sum_SaleReturnIn_curr)    AS Sum_SaleReturnIn_curr
                             , SUM (tmpGroup.Sum_Account_curr)         AS Sum_Account_curr
                             , SUM (tmpGroup.Sum_AccountSendDebt_curr) AS Sum_AccountSendDebt_curr
                             , SUM (tmpGroup.Sum_Return_curr)          AS Sum_Return_curr

                             , SUM (tmpWeight.Sale_AmountPartner_Weight)   AS Sum_Sale_weight
                             , SUM (tmpWeight.Return_AmountPartner_Weight) AS Sum_ReturnIn_weight
                             
                             , CASE WHEN inisGoods = TRUE THEN tmpGroup.GoodsId ELSE 0 END AS GoodsId
                             , tmpGroup.GoodsKindId
                             , tmpGoodsParam.GoodsGroupName
                             , tmpGoodsParam.GoodsGroupNameFull
                             , tmpGoodsParam.BusinessName
                             , tmpGoodsParam.GoodsTagName
                             , tmpGoodsParam.GoodsPlatformName
                             , tmpGoodsParam.GoodsGroupAnalystName
                        FROM tmpMovementCont AS tmpGroup
                             LEFT JOIN tmpWeight ON tmpWeight.MovementId = tmpGroup.MovementId
                                                AND COALESCE (tmpWeight.GoodsId,0) = COALESCE (tmpGroup.GoodsId,0)
                                                AND COALESCE (tmpWeight.GoodsKindId,0) = COALESCE (tmpGroup.GoodsKindId,0)
                             LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = tmpGroup.GoodsId
                        WHERE tmpGroup.BranchId = inBranchId OR inBranchId = 0
                        GROUP BY tmpGroup.JuridicalId
                               , tmpGroup.PartnerId
                               , tmpGroup.ContractId_child
                               , tmpGroup.InfoMoneyId_child
                               , tmpGroup.PaidKindId_calc
                               , tmpGroup.PaidKindId_byBase
                               , tmpGroup.ContractConditionId
                               , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementId ELSE 0 END
                               , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementDescId ELSE 0 END
                               , tmpGroup.BranchId
                               , tmpGroup.ContractId_master
                               , CASE WHEN inisGoods = TRUE THEN tmpGroup.GoodsId ELSE 0 END
                               , tmpGroup.GoodsKindId
                               , tmpGoodsParam.GoodsGroupName
                               , tmpGoodsParam.GoodsGroupNameFull
                               , tmpGoodsParam.BusinessName
                               , tmpGoodsParam.GoodsTagName
                               , tmpGoodsParam.GoodsPlatformName
                               , tmpGoodsParam.GoodsGroupAnalystName

                       )

      , tmpMovement AS (SELECT tmpGroup.JuridicalId
                             , tmpGroup.PartnerId
                             , tmpGroup.ContractId_child
                             , tmpGroup.ContractId_master
                             , tmpGroup.InfoMoneyId_child
                             , tmpGroup.PaidKindId_calc
                             , tmpGroup.PaidKindId_byBase
                             , tmpGroup.ContractConditionId
                             , tmpGroup.BranchId
                             , tmpGroup.MovementId
                             , tmpGroup.MovementDescId
                             , tmpGroup.Sum_Sale
                             , tmpGroup.Sum_Return
                             , tmpGroup.Sum_SaleReturnIn
                             , tmpGroup.Sum_Account
                             , tmpGroup.Sum_AccountSendDebt
                             , tmpGroup.Sum_Sale_curr
                             , tmpGroup.Sum_Return_curr
                             , tmpGroup.Sum_SaleReturnIn_curr
                             , tmpGroup.Sum_Account_curr
                             , tmpGroup.Sum_AccountSendDebt_curr
                             , tmpGroup.Sum_Sale_weight
                             , tmpGroup.Sum_ReturnIn_weight
                             , tmpGroup.GoodsId
                             , tmpGroup.GoodsKindId
                             , tmpGroup.GoodsGroupName
                             , tmpGroup.GoodsGroupNameFull
                             , tmpGroup.BusinessName
                             , tmpGroup.GoodsTagName
                             , tmpGroup.GoodsPlatformName
                             , tmpGroup.GoodsGroupAnalystName
                              -- расчитывем % возврата факт = факт возврата / факт отгрузки * 100
                             , CASE WHEN COALESCE (tmpGroup.Sum_Sale,0) <> 0 THEN tmpGroup.Sum_Return / tmpGroup.Sum_Sale * 100 ELSE 0 END AS PercentRetBonus_fact
                             , CASE WHEN COALESCE (tmpGroup.Sum_Sale_weight,0) <> 0 THEN tmpGroup.Sum_ReturnIn_weight / tmpGroup.Sum_Sale_weight * 100 ELSE 0 END AS PercentRetBonus_fact_weight
                        FROM tmpGroupMov AS tmpGroup
                       )

           , tmpAll as(SELECT tmp.*
                       FROM (SELECT tmpContract.InvNumber_master
                                  , tmpContract.InvNumber_child
                                  , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0 AND tmpContractBonus.ContractId_find > 0
                                              THEN tmpContractBonus.InvNumber_find
                                         ELSE tmpContract.InvNumber_master
                                    END AS InvNumber_find

                                  , COALESCE (tmpContract.ContractTagName_child, '') AS ContractTagName_child
                                  , COALESCE (tmpContract.ContractStateKindCode_child, 0) AS ContractStateKindCode_child

                                  , tmpContract.ContractId_master
                                  , tmpContract.ContractId_child
                                  , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0 AND tmpContractBonus.ContractId_find > 0
                                              THEN tmpContractBonus.ContractId_find
                                         ELSE tmpContract.ContractId_master
                                    END AS ContractId_find

                                  , tmpContract.InfoMoneyId_master
                                  , tmpContract.InfoMoneyId_child
                                  , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0 AND tmpContractBonus.ContractId_find > 0
                                              THEN tmpContractBonus.InfoMoneyId_find
                                         WHEN tmpContract.InfoMoneyId_master = zc_Enum_InfoMoney_30101() -- Готовая продукция
                                              THEN zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                         WHEN tmpContract.InfoMoneyId_master = zc_Enum_InfoMoney_30201() -- Мясное сырье
                                              THEN zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                         ELSE tmpContract.InfoMoneyId_master
                                    END AS InfoMoneyId_find

                                  , tmpContract.JuridicalId AS JuridicalId
                                  , CASE WHEN tmpContract.ContractConditionKindID IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                    , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt())
                                          AND tmpContract.PaidKindId_byBase = zc_Enum_PaidKind_FirstForm()
                                              THEN 0
                                         ELSE tmpMovement.PartnerId
                                    END AS PartnerId

                                  -- подменяем обратно ФО bз усл.договора на ФО из договора
                                  --, tmpContract.PaidKindId                                 --tmpMovement.PaidKindId AS PaidKindId
                                  --, View_Contract_InvNumber_child.PaidKindId   AS PaidKindId_child  --, tmpContract.PaidKindId_byBase  AS PaidKindId_child     -- ФО договора базы

                                    -- Форма оплаты - в какой надо начислить БОНУСЫ
                                  , tmpMovement.PaidKindId_calc   AS PaidKindId
                                    -- Форма оплаты - в какой надо взять Базу
                                  , tmpMovement.PaidKindId_byBase AS PaidKindId_child

                                    --
                                  , tmpContract.ContractConditionKindId
                                  , tmpContract.BonusKindId
                                  , COALESCE (tmpContract.Value,0) AS Value
                                  , COALESCE (tmpContract.PercentRetBonus,0)            ::TFloat AS PercentRetBonus
                                  , COALESCE (tmpMovement.PercentRetBonus_fact,0)       ::TFloat AS PercentRetBonus_fact
                                  , COALESCE (tmpMovement.PercentRetBonus_fact_weight,0)::TFloat AS PercentRetBonus_fact_weight

                                  , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale()            THEN tmpMovement.Sum_Sale
                                               WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn()      THEN tmpMovement.Sum_SaleReturnIn
                                               WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount()         THEN tmpMovement.Sum_Account
                                               WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt() THEN tmpMovement.Sum_AccountSendDebt
                                          ELSE 0 END  AS TFloat) AS Sum_CheckBonus

                                    -- когда % возврата факт превышает % возврата план, бонус не начисляется
                                  , CAST (CASE WHEN (COALESCE (tmpContract.PercentRetBonus,0) <> 0 AND tmpMovement.PercentRetBonus_fact_weight > tmpContract.PercentRetBonus) THEN 0
                                               ELSE
                                                  CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale()            THEN (tmpMovement.Sum_Sale            / 100 * tmpContract.Value)
                                                       WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn()      THEN (tmpMovement.Sum_SaleReturnIn    / 100 * tmpContract.Value)
                                                       WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount()         THEN (tmpMovement.Sum_Account         / 100 * tmpContract.Value)
                                                       WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt() THEN (tmpMovement.Sum_AccountSendDebt / 100 * tmpContract.Value)
                                                  ELSE 0 END
                                          END  AS NUMERIC (16, 0)) AS Sum_Bonus

                                  --в валюте
                                  , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale()            THEN tmpMovement.Sum_Sale_curr
                                               WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn()      THEN tmpMovement.Sum_SaleReturnIn_curr
                                               WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount()         THEN tmpMovement.Sum_Account_curr
                                               WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt() THEN tmpMovement.Sum_AccountSendDebt_curr
                                          ELSE 0 END  AS TFloat) AS Sum_CheckBonus_curr
                                 --в валюте
                                  , CAST (CASE WHEN (COALESCE (tmpContract.PercentRetBonus,0) <> 0 AND tmpMovement.PercentRetBonus_fact_weight > tmpContract.PercentRetBonus) THEN 0
                                               ELSE
                                                  CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale()            THEN (tmpMovement.Sum_Sale_curr            / 100 * tmpContract.Value)
                                                       WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn()      THEN (tmpMovement.Sum_SaleReturnIn_curr    / 100 * tmpContract.Value)
                                                       WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount()         THEN (tmpMovement.Sum_Account_curr         / 100 * tmpContract.Value)
                                                       WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt() THEN (tmpMovement.Sum_AccountSendDebt_curr / 100 * tmpContract.Value)
                                                  ELSE 0 END
                                          END  AS NUMERIC (16, 0)) AS Sum_Bonus_curr

                                  , 0 :: TFloat                    AS Sum_BonusFact
                                  , 0 :: TFloat                    AS Sum_CheckBonusFact
                                  , 0 :: TFloat                    AS Sum_SaleFact
                                  , COALESCE (tmpMovement.Sum_Account,0)         AS Sum_Account
                                  , COALESCE (tmpMovement.Sum_AccountSendDebt,0) AS Sum_AccountSendDebt
                                  , COALESCE (tmpMovement.Sum_Sale,0)            AS Sum_Sale
                                  , COALESCE (tmpMovement.Sum_Return,0)          AS Sum_Return
                                  , COALESCE (tmpMovement.Sum_SaleReturnIn,0)    AS Sum_SaleReturnIn

                                  , COALESCE (tmpMovement.Sum_Account_curr,0)         AS Sum_Account_curr
                                  , COALESCE (tmpMovement.Sum_AccountSendDebt_curr,0) AS Sum_AccountSendDebt_curr
                                  , COALESCE (tmpMovement.Sum_Sale_curr,0)            AS Sum_Sale_curr
                                  , COALESCE (tmpMovement.Sum_Return_curr,0)          AS Sum_Return_curr
                                  , COALESCE (tmpMovement.Sum_SaleReturnIn_curr,0)    AS Sum_SaleReturnIn_curr

                                  , COALESCE (tmpMovement.Sum_Sale_weight,0)     AS Sum_Sale_weight
                                  , COALESCE (tmpMovement.Sum_ReturnIn_weight,0) AS Sum_ReturnIn_weight

                                  , COALESCE (tmpContract.Comment, '')  AS Comment

                                  , COALESCE (tmpMovement.MovementId,0) AS MovementId
                                  , tmpMovement.MovementDescId
                                  , COALESCE (tmpMovement.BranchId,0)   AS BranchId
                                --, CASE WHEN vbUserId = 5 THEN tmpContract.ContractConditionId ELSE 0 END AS ContractConditionId
                                  , 0                                   AS ContractConditionId

                                  , tmpMovement.GoodsId
                                  , tmpMovement.GoodsKindId
                                  , tmpMovement.GoodsGroupName
                                  , tmpMovement.GoodsGroupNameFull
                                  , tmpMovement.BusinessName
                                  , tmpMovement.GoodsTagName
                                  , tmpMovement.GoodsPlatformName
                                  , tmpMovement.GoodsGroupAnalystName
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

                     UNION ALL
                       -- бонус в документах факт - zc_Movement_ProfitLossService
                       SELECT View_Contract_InvNumber_master.InvNumber AS InvNumber_master
                            , CASE WHEN COALESCE (MILinkObject_ContractChild.ObjectId,0) <> 0 THEN View_Contract_InvNumber_child.InvNumber ELSE View_Contract_InvNumber_master.InvNumber END AS InvNumber_child
                            , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find

                            , COALESCE (View_Contract_InvNumber_child.ContractTagName, '')  AS ContractTagName_child
                            , COALESCE (View_Contract_InvNumber_child.ContractStateKindCode, 0) AS ContractStateKindCode_child

                            , COALESCE (MILinkObject_ContractMaster.ObjectId, MILinkObject_Contract.ObjectId, MILinkObject_ContractChild.ObjectId) AS ContractId_master
                            , COALESCE (MILinkObject_ContractChild.ObjectId, MILinkObject_ContractMaster.ObjectId, MILinkObject_Contract.ObjectId) AS ContractId_child
                            , MILinkObject_Contract.ObjectId                 AS ContractId_find

                            , View_Contract_InvNumber_master.InfoMoneyId     AS InfoMoneyId_master
                            , View_Contract_InvNumber_child.InfoMoneyId      AS InfoMoneyId_child
                            , MILinkObject_InfoMoney.ObjectId                AS InfoMoneyId_find

                            , Object_Juridical.Id                            AS JuridicalId
                            --, CASE WHEN View_Contract_InvNumber_child.PaidKindId = zc_Enum_PaidKind_FirstForm() THEN 0 ELSE COALESCE (ObjectLink_Partner_Juridical.ObjectId,0) END AS PartnerId
                            , COALESCE (ObjectLink_Partner_Juridical.ObjectId,0) AS PartnerId
                              -- Форма оплаты - в какой надо начислить БОНУСЫ
                            , MILinkObject_PaidKind.ObjectId                 AS PaidKindId
                              -- Форма оплаты - в какой надо взять Базу
                            , View_Contract_InvNumber_child.PaidKindId       AS PaidKindId_child
                              --
                            , MILinkObject_ContractConditionKind.ObjectId    AS ContractConditionKindId
                            , MILinkObject_BonusKind.ObjectId                AS BonusKindId
                            , COALESCE (MIFloat_BonusValue.ValueData,0)      AS Value
                            , 0 ::TFloat                                     AS PercentRetBonus
                            , 0 ::TFloat                                     AS PercentRetBonus_fact
                            , 0 ::TFloat                                     AS PercentRetBonus_fact_weight

                            , 0 :: TFloat                                    AS Sum_CheckBonus
                            , 0 :: TFloat                                    AS Sum_Bonus
                            , 0 :: TFloat                                    AS Sum_CheckBonus_curr
                            , 0 :: TFloat                                    AS Sum_Bonus_curr
                            , MovementItem.Amount                            AS Sum_BonusFact
                            , MIFloat_Summ.ValueData                         AS Sum_CheckBonusFact
                            , MIFloat_AmountPartner.ValueData                AS Sum_SaleFact
                            , 0 :: TFloat                                    AS Sum_Account
                            , 0 :: TFloat                                    AS Sum_AccountSendDebt
                            , 0 :: TFloat                                    AS Sum_Sale
                            , 0 :: TFloat                                    AS Sum_Return
                            , 0 :: TFloat                                    AS Sum_SaleReturnIn

                            , 0 :: TFloat                                    AS Sum_Account_curr
                            , 0 :: TFloat                                    AS Sum_AccountSendDebt_curr
                            , 0 :: TFloat                                    AS Sum_Sale_curr
                            , 0 :: TFloat                                    AS Sum_Return_curr
                            , 0 :: TFloat                                    AS Sum_SaleReturnIn_curr
                                  
                            , 0 :: TFloat                                    AS Sum_Sale_weight
                            , 0 :: TFloat                                    AS Sum_ReturnIn_weight
                            , COALESCE (MIString_Comment.ValueData,'')       AS Comment

                            , CASE WHEN inisMovement = TRUE THEN Movement.Id ELSE 0 END      AS MovementId
                            , CASE WHEN inisMovement = TRUE THEN Movement.DescId ELSE 0 END  AS MovementDescId
                            , COALESCE (MILinkObject_Branch.ObjectId,0)      AS BranchId
                            , 0 AS ContractConditionId

                            , 0  :: Integer  AS GoodsId
                            , 0  :: Integer  AS GoodsKindId
                            , '' :: TVarChar AS GoodsGroupName
                            , '' :: TVarChar AS GoodsGroupNameFull
                            , '' :: TVarChar AS BusinessName
                            , '' :: TVarChar AS GoodsTagName
                            , '' :: TVarChar AS GoodsPlatformName
                            , '' :: TVarChar AS GoodsGroupAnalystName
                     FROM Movement
                            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)

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

                            LEFT JOIN tmpContract_all  AS View_Contract_InvNumber_find   ON View_Contract_InvNumber_find.ContractId   = MILinkObject_Contract.ObjectId
                            LEFT JOIN tmpContract_all  AS View_Contract_InvNumber_master ON View_Contract_InvNumber_master.ContractId = COALESCE (MILinkObject_ContractMaster.ObjectId, MILinkObject_Contract.ObjectId, MILinkObject_ContractChild.ObjectId)
                            LEFT JOIN tmpContract_full AS View_Contract_InvNumber_child  ON View_Contract_InvNumber_child.ContractId  = COALESCE (MILinkObject_ContractChild.ObjectId, MILinkObject_ContractMaster.ObjectId, MILinkObject_Contract.ObjectId)

                            --LEFT JOIN (SELECT tmpMovement.JuridicalId, MAX (tmpMovement.PartnerId) AS PartnerId FROM tmpMovement GROUP BY tmpMovement.JuridicalId) tmpInf ON tmpInf.JuridicalId = MovementItem.ObjectId
                       WHERE Movement.DescId = zc_Movement_ProfitLossService()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND (Movement.OperDate >= inStartDate AND Movement.OperDate < vbEndDate)
                         AND MILinkObject_InfoMoney.ObjectId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                               , zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                               , zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                                                                )
                         AND (Object_Juridical.Id = inJuridicalId OR inJuridicalId = 0)
                         AND (COALESCE (MILinkObject_Branch.ObjectId,0) = inBranchId OR inBranchId = 0)
                         -- оплата по долевым в процке gpReport_CheckBonus_PersentSalePart
                         AND COALESCE (MILinkObject_ContractConditionKind.ObjectId,0) <> zc_Enum_ContractConditionKind_BonusPercentSalePart()
                         AND MILinkObject_PaidKind.ObjectId = inPaidKindId

                      UNION ALL
                       -- бонус - ежемесячный платеж
                       SELECT tmpData.InvNumber_master   AS InvNumber_master
                            , tmpData.InvNumber_master   AS InvNumber_child
                            , tmpData.InvNumber_master   AS InvNumber_find

                            , '' ::TVarChar              AS ContractTagName_child
                            , 0                          AS ContractStateKindCode_child

                            , tmpData.ContractId_master  AS ContractId_master
                            , tmpData.ContractId_master  AS ContractId_child
                            , tmpData.ContractId_master  AS ContractId_find

                            , tmpData.InfoMoneyId_master AS InfoMoneyId_master
                            , tmpData.InfoMoneyId_master AS InfoMoneyId_child
                            , tmpData.InfoMoneyId_master AS InfoMoneyId_find

                            , tmpData.JuridicalId               AS JuridicalId
                            , 0                                 AS PartnerId

                            --, tmpData.PaidKindId                AS PaidKindId
                            --, CASE WHEN tmpData.PaidKindId_ContractCondition > 0 THEN tmpData.PaidKindId_ContractCondition ELSE tmpData.PaidKindId END AS PaidKindId_child
                                    -- Форма оплаты - в какой надо начислить БОНУСЫ
                            , tmpData.PaidKindId_calc           AS PaidKindId
                              -- Форма оплаты - в какой надо взять Базу
                            , tmpData.PaidKindId_byBase         AS PaidKindId_child

                            , tmpData.ContractConditionKindId   AS ContractConditionKindId
                            , tmpData.BonusKindId               AS BonusKindId
                            , COALESCE (tmpData.Value,0)        AS Value
                            , 0 ::TFloat                        AS PercentRetBonus
                            , 0 ::TFloat                        AS PercentRetBonus_fact
                            , 0 ::TFloat                        AS PercentRetBonus_fact_weight

                            , 0 :: TFloat                       AS Sum_CheckBonus
                            , COALESCE (tmpData.Value,0)        AS Sum_Bonus
                            , 0 :: TFloat                       AS Sum_CheckBonus_curr
                            , 0 :: TFloat                       AS Sum_Bonus_curr
                            , 0 :: TFloat                       AS Sum_BonusFact
                            , 0 :: TFloat                       AS Sum_CheckBonusFact
                            , 0 :: TFloat                       AS Sum_SaleFact
                            , 0 :: TFloat                       AS Sum_Account
                            , 0 :: TFloat                       AS Sum_AccountSendDebt
                            , 0 :: TFloat                       AS Sum_Sale
                            , 0 :: TFloat                       AS Sum_Return
                            , 0 :: TFloat                       AS Sum_SaleReturnIn

                            , 0 :: TFloat                       AS Sum_Account_curr
                            , 0 :: TFloat                       AS Sum_AccountSendDebt_curr
                            , 0 :: TFloat                       AS Sum_Sale_curr
                            , 0 :: TFloat                       AS Sum_Return_curr
                            , 0 :: TFloat                       AS Sum_SaleReturnIn_curr

                            , 0 :: TFloat                       AS Sum_Sale_weight
                            , 0 :: TFloat                       AS Sum_ReturnIn_weight
                            , COALESCE (tmpData.Comment,'')     AS Comment
                            , 0                                 AS MovementId
                            , 0                                 AS MovementDescId
                            , COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) AS BranchId

                            , 0 AS ContractConditionId

                            , 0  :: Integer  AS GoodsId
                            , 0  :: Integer  AS GoodsKindId
                            , '' :: TVarChar AS GoodsGroupName
                            , '' :: TVarChar AS GoodsGroupNameFull
                            , '' :: TVarChar AS BusinessName
                            , '' :: TVarChar AS GoodsTagName
                            , '' :: TVarChar AS GoodsPlatformName
                            , '' :: TVarChar AS GoodsGroupAnalystName
                       FROM tmpCCK_BonusMonthlyPayment AS tmpData
                            -- для Базы БН получаем филиал по сотруднику из договора, по ведомости
                            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                                 ON ObjectLink_Contract_PersonalTrade.ObjectId = tmpData.ContractId_master
                                                AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                                                --AND tmpContainer.PaidKindId_byBase = zc_Enum_PaidKind_FirstForm()

                            LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                 ON ObjectLink_Personal_PersonalServiceList.ObjectId = COALESCE (ObjectLink_Contract_PersonalTrade.ChildObjectId, 0)
                                                AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                            LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch
                                                 ON ObjectLink_PersonalServiceList_Branch.ObjectId = ObjectLink_Personal_PersonalServiceList.ChildObjectId
                                                AND ObjectLink_PersonalServiceList_Branch.DescId = zc_ObjectLink_PersonalServiceList_Branch()
                       WHERE (COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) = inBranchId OR inBranchId = 0)
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

                         , CASE WHEN COALESCE (tmpAll.PercentRetBonus,0) = 0 THEN tmpContract.PercentRetBonus ELSE tmpAll.PercentRetBonus END AS PercentRetBonus
                         , tmpAll.PercentRetBonus_fact
                         , tmpAll.PercentRetBonus_fact_weight
                         , tmpAll.Sum_CheckBonus
                         , tmpAll.Sum_CheckBonusFact
                         , tmpAll.Sum_Bonus
                         , tmpAll.Sum_BonusFact
                         , tmpAll.Sum_SaleFact
                         , tmpAll.Sum_Account
                         , tmpAll.Sum_AccountSendDebt
                         , tmpAll.Sum_Sale
                         , tmpAll.Sum_Return
                         , tmpAll.Sum_SaleReturnIn

                         , tmpAll.Sum_CheckBonus_curr
                         , tmpAll.Sum_Bonus_curr
                         , tmpAll.Sum_Account_curr
                         , tmpAll.Sum_AccountSendDebt_curr
                         , tmpAll.Sum_Sale_curr
                         , tmpAll.Sum_Return_curr
                         , tmpAll.Sum_SaleReturnIn_curr

                         , tmpAll.Sum_Sale_weight
                         , tmpAll.Sum_ReturnIn_weight
                         , tmpAll.Comment
                         , tmpAll.ContractConditionId

                         , tmpAll.GoodsId
                         , tmpAll.GoodsKindId
                         , tmpAll.GoodsGroupName
                         , tmpAll.GoodsGroupNameFull
                         , tmpAll.BusinessName
                         , tmpAll.GoodsTagName
                         , tmpAll.GoodsPlatformName
                         , tmpAll.GoodsGroupAnalystName
                    FROM (SELECT tmpAll.ContractId_master
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
                         , CASE WHEN tmpAll.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN tmpAll.PartnerId ELSE 0 END AS PartnerId
                         , tmpAll.PaidKindId
                         , tmpAll.PaidKindId_child
                         , tmpAll.ContractConditionKindId
                         , tmpAll.BonusKindId
                         , tmpAll.MovementId
                         , tmpAll.MovementDescId
                         , tmpAll.BranchId
                         , tmpAll.Value

                         , MAX (tmpAll.PercentRetBonus)    AS PercentRetBonus
                         , MAX (tmpAll.PercentRetBonus_fact)        AS PercentRetBonus_fact
                         , MAX (tmpAll.PercentRetBonus_fact_weight) AS PercentRetBonus_fact_weight
                         , SUM (tmpAll.Sum_CheckBonus)      AS Sum_CheckBonus
                         , SUM (tmpAll.Sum_CheckBonusFact)  AS Sum_CheckBonusFact
                         , SUM (tmpAll.Sum_Bonus)           AS Sum_Bonus
                         , SUM (tmpAll.Sum_BonusFact)*(-1)  AS Sum_BonusFact
                         , SUM (tmpAll.Sum_CheckBonus_curr) AS Sum_CheckBonus_curr
                         , SUM (tmpAll.Sum_Bonus_curr)      AS Sum_Bonus_curr
                         , SUM (tmpAll.Sum_SaleFact)        AS Sum_SaleFact
                         , SUM (tmpAll.Sum_Account)         AS Sum_Account
                         , SUM (tmpAll.Sum_AccountSendDebt) AS Sum_AccountSendDebt
                         , SUM (tmpAll.Sum_Sale)            AS Sum_Sale
                         , SUM (tmpAll.Sum_Return)          AS Sum_Return
                         , SUM (tmpAll.Sum_SaleReturnIn)    AS Sum_SaleReturnIn

                         , SUM (tmpAll.Sum_Account_curr)         AS Sum_Account_curr
                         , SUM (tmpAll.Sum_AccountSendDebt_curr) AS Sum_AccountSendDebt_curr
                         , SUM (tmpAll.Sum_Sale_curr)            AS Sum_Sale_curr
                         , SUM (tmpAll.Sum_Return_curr)          AS Sum_Return_curr
                         , SUM (tmpAll.Sum_SaleReturnIn_curr)    AS Sum_SaleReturnIn_curr


                         , SUM (COALESCE (tmpAll.Sum_Sale_weight,0))     AS Sum_Sale_weight
                         , SUM (COALESCE (tmpAll.Sum_ReturnIn_weight,0)) AS Sum_ReturnIn_weight

                         , MAX (tmpAll.Comment) :: TVarChar AS Comment
                         , tmpAll.ContractConditionId

                         , tmpAll.GoodsId
                         , tmpAll.GoodsKindId
                         , tmpAll.GoodsGroupName
                         , tmpAll.GoodsGroupNameFull
                         , tmpAll.BusinessName
                         , tmpAll.GoodsTagName
                         , tmpAll.GoodsPlatformName
                         , tmpAll.GoodsGroupAnalystName
                    FROM tmpAll
                    WHERE/* (tmpAll.Sum_CheckBonus <> 0
                       OR tmpAll.Sum_Bonus <> 0
                       OR tmpAll.Sum_BonusFact <> 0)
                      AND */
                         (tmpAll.PaidKindId = inPaidKindId OR inPaidKindId = 0)
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
                            , CASE WHEN tmpAll.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN tmpAll.PartnerId ELSE 0 END
                            , tmpAll.PaidKindId
                            , tmpAll.ContractConditionKindId
                            , tmpAll.BonusKindId
                            , tmpAll.Value
                            , tmpAll.MovementId
                            , tmpAll.MovementDescId
                            , tmpAll.BranchId
                            , tmpAll.PaidKindId_child
                            , tmpAll.ContractConditionId
                            , tmpAll.GoodsId
                            , tmpAll.GoodsKindId
                            , tmpAll.GoodsGroupName
                            , tmpAll.GoodsGroupNameFull
                            , tmpAll.BusinessName
                            , tmpAll.GoodsTagName
                            , tmpAll.GoodsPlatformName
                            , tmpAll.GoodsGroupAnalystName
                    ) AS tmpAll
                         --если есть только факт начисления получим некоторые св-ва по договору
                         LEFT JOIN (SELECT tmpContract.JuridicalId
                                         , tmpContract.ContractId_child
                                         , tmpContract.InfoMoneyId_child
                                         , tmpContract.PaidKindId_byBase
                                         , MAX (COALESCE (tmpContract.PercentRetBonus,0)) AS PercentRetBonus
                                       FROM tmpContract
                                       GROUP BY tmpContract.JuridicalId
                                              , tmpContract.ContractId_child
                                              , tmpContract.InfoMoneyId_child
                                              , tmpContract.PaidKindId_byBase
                                       ) AS tmpContract ON tmpContract.JuridicalId = tmpAll.JuridicalId
                                                       AND tmpContract.ContractId_child = tmpAll.ContractId_child
                                                       AND tmpContract.InfoMoneyId_child = tmpAll.InfoMoneyId_child
                                                       AND tmpContract.PaidKindId_byBase = tmpAll.PaidKindId_child
                                                       AND COALESCE (tmpAll.PercentRetBonus,0) = 0
                    WHERE (tmpAll.Sum_CheckBonus <> 0
                       OR tmpAll.Sum_Bonus <> 0
                       OR tmpAll.Sum_Bonus_curr <> 0
                       OR tmpAll.Sum_CheckBonus_curr <> 0
                       OR tmpAll.Sum_BonusFact <> 0)
                     --OR vbUserId = 5
                    )

      , tmpMovementParams AS (SELECT tmpMov.MovementId
                                   , MovementDesc.ItemName
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                                   , COALESCE (Object_From.Id, Object_MoneyPlace.Id)                AS FromId
                                   , COALESCE (Object_From.ValueData, Object_MoneyPlace.ValueData)  AS FromName
                                   , Object_To.Id                               AS ToId
                                   , Object_To.ValueData                        AS ToName
                                   , Object_PaidKind.Id                         AS PaidKindId
                                   , Object_PaidKind.ValueData                  AS PaidKindName

                                   , View_Contract_InvNumber.ContractId         AS ContractId
                                   , View_Contract_InvNumber.ContractCode       AS ContractCode
                                   , View_Contract_InvNumber.InvNumber          AS ContractName
                                   , View_Contract_InvNumber.ContractTagName    AS ContractTagName

                                   , MovementFloat_TotalCount.ValueData         AS TotalCount
                                   , MovementFloat_TotalCountPartner.ValueData  AS TotalCountPartner
                                   , CASE WHEN tmpMov.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) THEN (-1) * MovementFloat_TotalSumm.ValueData
                                          WHEN tmpMov.MovementDescId = zc_Movement_Sale() THEN MovementFloat_TotalSumm.ValueData
                                          WHEN tmpMov.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt()) THEN MovementItem.Amount --MovementFloat_TotalSumm
                                     END AS TotalSumm
                              FROM (SELECT DISTINCT tmpData.MovementId, tmpData.MovementDescId FROM tmpData) AS tmpMov
                                  LEFT JOIN Movement ON Movement.Id = tmpMov.MovementId
                                  LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMov.MovementDescId
                                  LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                         ON MovementDate_OperDatePartner.MovementId = tmpMov.MovementId
                                                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END
                                  LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
                                  LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                               ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                              AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                  LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                  LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

                                  LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                                          ON MovementFloat_TotalCount.MovementId = Movement.Id
                                                         AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
                                  LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                                          ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                                         AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()

                                  LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                          ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                         AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                  LEFT JOIN MovementFloat AS MovementFloat_AmountSumm
                                                          ON MovementFloat_AmountSumm.MovementId = Movement.Id
                                                         AND MovementFloat_AmountSumm.DescId = zc_MovementFloat_Amount()
                                                         AND tmpMov.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())

                                  LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND tmpMov.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())

                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                   ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                  LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

                              WHERE inisMovement = TRUE
                              )

    , tmpObjectBonus AS (SELECT ObjectLink_Juridical.ChildObjectId             AS JuridicalId
                              , COALESCE (ObjectLink_Partner.ChildObjectId, 0) AS PartnerId
                              , ObjectLink_ContractMaster.ChildObjectId        AS ContractId_master
                              , ObjectLink_ContractChild.ChildObjectId         AS ContractId_child
                                -- на всякий случай
                              , MAX (Object_ReportBonus.Id)                    AS Id
                              , Object_ReportBonus.isErased
                         FROM Object AS Object_ReportBonus
                              INNER JOIN ObjectDate AS ObjectDate_Month
                                                    ON ObjectDate_Month.ObjectId = Object_ReportBonus.Id
                                                   AND ObjectDate_Month.DescId = zc_Object_ReportBonus_Month()
                                                   AND ObjectDate_Month.ValueData =  DATE_TRUNC ('MONTH', inEndDate)
                              INNER JOIN ObjectLink AS ObjectLink_Juridical
                                                    ON ObjectLink_Juridical.ObjectId = Object_ReportBonus.Id
                                                   AND ObjectLink_Juridical.DescId = zc_ObjectLink_ReportBonus_Juridical()
                              LEFT JOIN ObjectLink AS ObjectLink_Partner
                                                   ON ObjectLink_Partner.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectLink_Partner.DescId = zc_ObjectLink_ReportBonus_Partner()

                              INNER JOIN ObjectLink AS ObjectLink_ContractMaster
                                                    ON ObjectLink_ContractMaster.ObjectId = Object_ReportBonus.Id
                                                   AND ObjectLink_ContractMaster.DescId = zc_ObjectLink_ReportBonus_ContractMaster()
                              INNER JOIN ObjectLink AS ObjectLink_ContractChild
                                                    ON ObjectLink_ContractChild.ObjectId = Object_ReportBonus.Id
                                                   AND ObjectLink_ContractChild.DescId = zc_ObjectLink_ReportBonus_ContractChild()

                         WHERE Object_ReportBonus.DescId   = zc_Object_ReportBonus()
                           AND inPaidKindID                = zc_Enum_PaidKind_SecondForm()
                           -- если НЕ удален, переносить НЕ надо
                           AND Object_ReportBonus.isErased = FALSE
                         --AND 1=0
                         GROUP BY ObjectLink_Juridical.ChildObjectId
                                , COALESCE (ObjectLink_Partner.ChildObjectId, 0)
                                , ObjectLink_ContractMaster.ChildObjectId
                                , ObjectLink_ContractChild.ChildObjectId
                                , Object_ReportBonus.isErased
                         )

     -- супервайзер для строк где нет контрагента берем по MAX из всех контрагентов юр лица
    , tmpPersonal AS  (SELECT tmp.JuridicalId
                            , MAX (ObjectLink_Partner_Personal.ChildObjectId) AS PersonalId
                       FROM (SELECT tmpData.JuridicalId FROM tmpData WHERE COALESCE (tmpData.PartnerId ,0) =0) AS tmp
                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = tmp.JuridicalId
                                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                                 ON ObjectLink_Partner_Personal.ObjectId = ObjectLink_Partner_Juridical.ObjectId
                                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
                       WHERE inPaidKindId = zc_Enum_PaidKind_SecondForm()
                       GROUP BY tmp.JuridicalId
                       )



      -- Результат
      SELECT  tmpMovementParams.OperDate        :: TDateTime AS OperDate_Movement
            , tmpMovementParams.OperDatePartner :: TDateTime AS OperDatePartner
            , tmpMovementParams.InvNumber                    AS InvNumber_Movement
            , tmpMovementParams.ItemName                     AS DescName_Movement
            , tmpData.ContractId_master
            , tmpData.ContractId_child
            , tmpData.ContractId_find
            , tmpData.InvNumber_master ::TVarChar
            , tmpData.InvNumber_child  ::TVarChar
            , tmpData.InvNumber_find   ::TVarChar

            , tmpData.ContractTagName_child        ::TVarChar
            , tmpData.ContractStateKindCode_child

            , Object_InfoMoney_master.Id                    AS InfoMoneyId_master
            , Object_InfoMoney_child.Id                     AS InfoMoneyId_child
            , Object_InfoMoney_find.Id                      AS InfoMoneyId_find

            , Object_InfoMoney_master.ValueData             AS InfoMoneyName_master
            , Object_InfoMoney_child.ValueData              AS InfoMoneyName_child
            , Object_InfoMoney_find.ValueData               AS InfoMoneyName_find

            , Object_Juridical.Id                           AS JuridicalId
            , Object_Juridical.ValueData                    AS JuridicalName

            , Object_PaidKind.Id                            AS PaidKindId
            , Object_PaidKind.ValueData                     AS PaidKindName
            , Object_PaidKind_Child.Id                      AS PaidKindId_Child
            , Object_PaidKind_Child.ValueData               AS PaidKindName_Child

            , Object_ContractConditionKind.Id               AS ConditionKindId
            , Object_ContractConditionKind.ValueData        AS ConditionKindName

            , Object_BonusKind.Id                           AS BonusKindId
            , Object_BonusKind.ValueData                    AS BonusKindName

            , Object_Branch.Id                              AS BranchId
            , Object_Branch.ValueData                       AS BranchName
            , Object_Branch_inf.Id                          AS BranchId_inf
            , Object_Branch_inf.ValueData                   AS BranchName_inf

            , Object_Retail.ValueData                       AS RetailName
            , Object_PersonalTrade.PersonalId               AS PersonalTradeId
            , Object_PersonalTrade.PersonalCode             AS PersonalTradeCode
          --, case when vbUserId = 5 then tmpData.ContractId_master else Object_PersonalTrade.PersonalCode end :: Integer AS PersonalTradeCode

            , Object_PersonalTrade.PersonalName             AS PersonalTradeName
            , Object_Personal.PersonalId                    AS PersonalId
            , Object_Personal.PersonalCode                  AS PersonalCode
            , Object_Personal.PersonalName                  AS PersonalName
            , Object_Partner.Id                             AS PartnerId
            , Object_Partner.ValueData  ::TVarChar          AS PartnerName

            , Object_Area.Id                  AS AreaId
            , Object_Area.ValueData           AS AreaName

            , CAST (tmpData.Value AS TFloat)                AS Value
            , CAST (tmpData.PercentRetBonus AS TFloat)      AS PercentRetBonus
            , CAST (tmpData.PercentRetBonus_fact AS TFloat) AS PercentRetBonus_fact
            , CAST (COALESCE (tmpData.PercentRetBonus_fact,0) - COALESCE (tmpData.PercentRetBonus, 0) AS TFloat) :: TFloat AS PercentRetBonus_diff

            , CAST (tmpData.PercentRetBonus_fact_weight AS TFloat) AS PercentRetBonus_fact_weight
            , CAST (COALESCE (tmpData.PercentRetBonus_fact_weight,0) - COALESCE (tmpData.PercentRetBonus, 0) AS TFloat) :: TFloat AS PercentRetBonus_diff_weight

            , CAST (tmpData.Sum_CheckBonus      AS TFloat) AS Sum_CheckBonus
            , CAST (tmpData.Sum_CheckBonusFact  AS TFloat) AS Sum_CheckBonusFact
            , CAST (tmpData.Sum_Bonus           AS TFloat) AS Sum_Bonus
            , CAST (tmpData.Sum_BonusFact       AS TFloat) AS Sum_BonusFact
            , CAST (tmpData.Sum_SaleFact        AS TFloat) AS Sum_SaleFact
            , CAST (tmpData.Sum_Account         AS TFloat) AS Sum_Account
            , CAST (tmpData.Sum_AccountSendDebt AS TFloat) AS Sum_AccountSendDebt
            , CAST (tmpData.Sum_Sale            AS TFloat) AS Sum_Sale
            , CAST (tmpData.Sum_Return          AS TFloat) AS Sum_Return
            , CAST (tmpData.Sum_SaleReturnIn    AS TFloat) AS Sum_SaleReturnIn

            , CAST (tmpData.Sum_CheckBonus_curr      AS TFloat) AS Sum_CheckBonus_curr
            , CAST (tmpData.Sum_Bonus_curr           AS TFloat) AS Sum_Bonus_curr
            , CAST (tmpData.Sum_Account_curr         AS TFloat) AS Sum_Account_curr
            , CAST (tmpData.Sum_AccountSendDebt_curr AS TFloat) AS Sum_AccountSendDebt_curr
            , CAST (tmpData.Sum_Sale_curr            AS TFloat) AS Sum_Sale_curr
            , CAST (tmpData.Sum_Return_curr          AS TFloat) AS Sum_Return_curr
            , CAST (tmpData.Sum_SaleReturnIn_curr    AS TFloat) AS Sum_SaleReturnIn_curr

            , CAST (tmpData.Sum_Sale_weight     AS TFloat) AS Sum_Sale_weight
            , CAST (tmpData.Sum_ReturnIn_weight AS TFloat) AS Sum_ReturnIn_weight

            , tmpData.Comment :: TVarChar                 AS Comment

            , tmpObjectBonus.Id :: Integer AS ReportBonusId
            , CASE WHEN tmpObjectBonus.isErased = FALSE THEN FALSE ELSE TRUE END :: Boolean AS isSend

            , tmpMovementParams.FromName         :: TVarChar AS FromName_Movement
            , tmpMovementParams.ToName           :: TVarChar AS ToName_Movement
            , tmpMovementParams.PaidKindName     :: TVarChar AS PaidKindName_Movement
            , tmpMovementParams.ContractCode     :: TVarChar AS ContractCode_Movement
            , tmpMovementParams.ContractName     :: TVarChar AS ContractName_Movement
            , tmpMovementParams.ContractTagName  :: TVarChar AS ContractTagName_Movement
            , tmpMovementParams.TotalCount       :: TFloat   AS TotalCount_Movement
            , tmpMovementParams.TotalCountPartner:: TFloat   AS TotalCountPartner_Movement
            , tmpMovementParams.TotalSumm        :: TFloat   AS TotalSumm_Movement
            , tmpData.ContractConditionId        :: Integer  AS ContractConditionId
            , false                              :: Boolean  AS isSalePart
            , 0  :: TFloat   AS AmountKg
            , 0  :: TFloat   AS AmountSh
            , 0  :: TFloat   AS PartKg

            , Object_Goods.ObjectCode       ::Integer  AS GoodsCode
            , Object_Goods.ValueData        ::TVarChar AS GoodsName
            , Object_GoodsKind.ValueData    ::TVarChar AS GoodsKindName
            , tmpData.GoodsGroupName        ::TVarChar
            , tmpData.GoodsGroupNameFull    ::TVarChar
            , tmpData.BusinessName          ::TVarChar
            , tmpData.GoodsTagName          ::TVarChar
            , tmpData.GoodsPlatformName     ::TVarChar
            , tmpData.GoodsGroupAnalystName ::TVarChar
            
            , Object_Currency_child.Id        ::Integer  AS CurrencyId_child
            , Object_Currency_child.ValueData ::TVarChar AS CurrencyName_child
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

            LEFT JOIN tmpMovementParams ON tmpMovementParams.MovementId = tmpData.MovementId

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
            LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = COALESCE (ObjectLink_Partner_PersonalTrade.ChildObjectId, ObjectLink_Contract_PersonalTrade.ChildObjectId)

            --показываем информативно Филиал по подразделению Сотрудника ТП
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_PersonalTrade.UnitId
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch_inf ON Object_Branch_inf.Id = ObjectLink_Unit_Branch.ChildObjectId

            LEFT JOIN tmpObjectBonus ON tmpObjectBonus.JuridicalId = Object_Juridical.Id
                                    AND tmpObjectBonus.PartnerId   = COALESCE (Object_Partner.Id, 0)
                                    AND tmpObjectBonus.ContractId_master = tmpData.ContractId_master
                                    AND tmpObjectBonus.ContractId_child  = tmpData.ContractId_child

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                                 ON ObjectLink_Partner_Area.ObjectId = tmpObjectBonus.PartnerId
                                AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId

            --
            LEFT JOIN tmpPersonal ON tmpPersonal.JuridicalId = tmpData.JuridicalId
            --для нал берем из контрагента
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                 ON ObjectLink_Partner_Personal.ObjectId = tmpData.PartnerId
                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
            LEFT JOIN Object_Personal_View AS Object_Personal ON Object_Personal.PersonalId = COALESCE (ObjectLink_Partner_Personal.ChildObjectId, tmpPersonal.PersonalId)

            -- ограничиваем по супервайзерам, если выбрали физ.лицо
            LEFT JOIN tmpPersonal_byMember ON tmpPersonal_byMember.PersonalId = Object_Personal.PersonalId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                                 ON ObjectLink_Contract_Currency.ObjectId = tmpData.ContractId_child
                                AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
            LEFT JOIN Object AS Object_Currency_child ON Object_Currency_child.Id = ObjectLink_Contract_Currency.ChildObjectId

       WHERE ((tmpPersonal_byMember.PersonalId IS NOT NULL AND inPaidKindId = zc_Enum_PaidKind_SecondForm()) OR inMemberId = 0)
         OR  inPaidKindId = zc_Enum_PaidKind_FirstForm()
       --

     UNION
       SELECT NULL :: TDateTime AS OperDate_Movement
            , NULL :: TDateTime AS OperDatePartner
            , NULL :: TVarChar  AS InvNumber_Movement
            , NULL :: TVarChar  AS DescName_Movement
            , tmpData.ContractId_master
            , tmpData.ContractId_child
            , tmpData.ContractId_find
            , tmpData.InvNumber_master ::TVarChar
            , tmpData.InvNumber_child  ::TVarChar
            , tmpData.InvNumber_find   ::TVarChar

            , tmpData.ContractTagName_child        ::TVarChar
            , tmpData.ContractStateKindCode_child

            , tmpData.InfoMoneyId_master
            , tmpData.InfoMoneyId_child
            , tmpData.InfoMoneyId_find

            , tmpData.InfoMoneyName_master
            , tmpData.InfoMoneyName_child
            , tmpData.InfoMoneyName_find

            , tmpData.JuridicalId
            , tmpData.JuridicalName

            , tmpData.PaidKindId
            , tmpData.PaidKindName
            , tmpData.PaidKindId_Child
            , tmpData.PaidKindName_Child

            , tmpData.ConditionKindId
            , tmpData.ConditionKindName

            , tmpData.BonusKindId
            , tmpData.BonusKindName

            , tmpData.BranchId
            , tmpData.BranchName
            , tmpData.BranchId_inf
            , tmpData.BranchName_inf

            , tmpData.RetailName
            , tmpData.PersonalTradeId
            , tmpData.PersonalTradeCode
            , tmpData.PersonalTradeName
            , tmpData.PersonalId
            , tmpData.PersonalCode
            , tmpData.PersonalName
            , tmpData.PartnerId
            , tmpData.PartnerName

            , tmpData.AreaId
            , tmpData.AreaName

            , tmpData.Value
            , tmpData.PercentRetBonus
            , tmpData.PercentRetBonus_fact
            , tmpData.PercentRetBonus_diff

            , tmpData.PercentRetBonus_fact_weight
            , tmpData.PercentRetBonus_diff_weight

            , tmpData.Sum_CheckBonus
            , tmpData.Sum_CheckBonusFact
            , tmpData.Sum_Bonus
            , tmpData.Sum_BonusFact
            , tmpData.Sum_SaleFact
            , 0  :: TFloat   AS Sum_Account
            , 0  :: TFloat   AS Sum_AccountSendDebt
            , tmpData.Sum_Sale
            , tmpData.Sum_Return
            , tmpData.Sum_SaleReturnIn

            , 0  :: TFloat AS Sum_CheckBonus_curr
            , 0  :: TFloat AS Sum_Bonus_curr
            , 0  :: TFloat AS Sum_Account_curr
            , 0  :: TFloat AS Sum_AccountSendDebt_curr
            , 0  :: TFloat AS Sum_Sale_curr
            , 0  :: TFloat AS Sum_Return_curr
            , 0  :: TFloat AS Sum_SaleReturnIn_curr

            , tmpData.Sum_Sale_weight
            , tmpData.Sum_ReturnIn_weight

            , tmpData.Comment :: TVarChar
            , tmpObjectBonus.Id  AS ReportBonusId
            , CASE WHEN tmpObjectBonus.isErased = FALSE THEN FALSE ELSE TRUE END :: Boolean AS isSend

            , ''  :: TVarChar AS FromName_Movement
            , ''  :: TVarChar AS ToName_Movement
            , ''  :: TVarChar AS PaidKindName_Movement
            , ''  :: TVarChar AS ContractCode_Movement
            , ''  :: TVarChar AS ContractName_Movement
            , ''  :: TVarChar AS ContractTagName_Movement
            , 0  :: TFloat   AS TotalCount_Movement
            , 0  :: TFloat   AS TotalCountPartner_Movement
            , 0  :: TFloat   AS TotalSumm_Movement
            , 0  :: Integer  AS ContractConditionId
            , TRUE :: Boolean AS isSalePart
            , tmpData.AmountKg  ::TFloat
            , tmpData.AmountSh  ::TFloat
            , tmpData.PartKg    ::TFloat

            , 0 ::Integer  GoodsCode
            , ''::TVarChar GoodsName
            , ''::TVarChar GoodsKindName
            , ''::TVarChar GoodsGroupName
            , ''::TVarChar GoodsGroupNameFull
            , ''::TVarChar BusinessName
            , ''::TVarChar GoodsTagName
            , ''::TVarChar GoodsPlatformName
            , ''::TVarChar GoodsGroupAnalystName

            , Object_Currency_child.Id        ::Integer  AS CurrencyId_child
            , Object_Currency_child.ValueData ::TVarChar AS CurrencyName_child

            /*, tmpData.GoodsCode             ::Integer
            , tmpData.GoodsName             ::TVarChar
            , tmpData.GoodsKindName         ::TVarChar 
            , tmpData.GoodsGroupName        ::TVarChar
            , tmpData.GoodsGroupNameFull    ::TVarChar
            , tmpData.BusinessName          ::TVarChar
            , tmpData.GoodsTagName          ::TVarChar
            , tmpData.GoodsPlatformName     ::TVarChar
            , tmpData.GoodsGroupAnalystName ::TVarChar*/
       FROM gpReport_CheckBonus_PersentSalePart (inStartDate    := inStartDate
                                               , inEndDate      := inEndDate
                                               , inPaidKindId   := inPaidKindId
                                               , inJuridicalId  := inJuridicalId
                                               , inBranchId     := inBranchId
                                               , inMemberId     := inMemberId
                                               , inSession      := inSession
                                                ) AS tmpData

            LEFT JOIN tmpObjectBonus ON tmpObjectBonus.JuridicalId = tmpData.JuridicalId
                                    AND tmpObjectBonus.PartnerId   = COALESCE (tmpData.PartnerId, 0)
                                    AND tmpObjectBonus.ContractId_master = tmpData.ContractId_master
                                    AND tmpObjectBonus.ContractId_child  = tmpData.ContractId_child

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                                 ON ObjectLink_Contract_Currency.ObjectId = tmpData.ContractId_child
                                AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
            LEFT JOIN Object AS Object_Currency_child ON Object_Currency_child.Id = ObjectLink_Contract_Currency.ChildObjectId

          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.20         *
 20.05.20         * add inBranchId
 14.06.17         *
 20.05.14                                        * add View_Contract_find_tag
 08.05.14                                        * add <> 0
 01.05.14         *
 26.04.14                                        * add ContractTagName_child and ContractStateKindCode_child
 17.04.14                                        * all
 10.04.14         *
*/

-- тест
-- select * from lpReport_CheckBonus_test (inStartDate:= '15.03.2016', inEndDate:= '15.03.2016', inPaidKindID:= zc_Enum_PaidKind_FirstForm(), inJuridicalId:= 0, inBranchId:= 0, inSession:= zfCalc_UserAdmin());
-- select * from lpReport_CheckBonus_test(inStartDate := ('28.05.2020')::TDateTime , inEndDate := ('28.05.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 344240 , inBranchId := 0 ,  inSession := '5');--
--select * from lpReport_CheckBonus_test(inStartDate := ('01.07.2020')::TDateTime , inEndDate := ('03.07.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 0 , inBranchId := 0 ,  inSession := '5');
-- select Sum_SaleReturnIn, ContractConditionId, * from lpReport_CheckBonus_test (inStartDate := ('01.11.2020')::TDateTime , inEndDate := ('30.11.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 2012467 , inBranchId := 0 , inisMovement := 'False' ,  inSession := '5');
--select Sum_SaleReturnIn, ContractConditionId, * from lpReport_CheckBonus_test (inStartDate := ('01.11.2020')::TDateTime , inEndDate := ('02.11.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 2012467 , inBranchId := 0 , inMemberId :=0, inisMovement := 'False' ,  inSession := '5');
/*select *
from lpReport_CheckBonus_test (inStartDate:= '01.11.2021', inEndDate:= '30.11.2021', inPaidKindID:= zc_Enum_PaidKind_SecondForm(), inJuridicalId:= 6629649, inBranchId:= 0, inMemberId:= 0,inisMovement:= false,inisDetail := false, inisGoods:= false, inSession:= zfCalc_UserAdmin())
union all
select *
from lpReport_CheckBonus_test (inStartDate:= '01.07.2021', inEndDate:= '31.07.2021', inPaidKindID:= zc_Enum_PaidKind_SecondForm(), inJuridicalId:= 0, inBranchId:= 0, inMemberId:= 0,inisMovement:= false, inisDetail:= FAlse, inisGoods:=FAlse, inSession:= zfCalc_UserAdmin())
order by 1
*/