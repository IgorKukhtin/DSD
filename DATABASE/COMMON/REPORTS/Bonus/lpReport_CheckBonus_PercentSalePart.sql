-- FunctiON: gpReport_CheckBonus_PersentSalePart ()

--DROP FUNCTION IF EXISTS gpReport_CheckBonus_PersentSalePart (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckBonus_PersentSalePart (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckBonus_PersentSalePart (
    IN inStartDate           TDateTime ,
    IN inEndDate             TDateTime ,
    IN inPaidKindId          Integer   ,
    IN inJuridicalId         Integer   ,
    IN inBranchId            Integer   ,
    IN inMemberId          Integer   ,
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContractId_master Integer, ContractId_child Integer, ContractId_find Integer
             , InvNumber_master TVarChar, InvNumber_child TVarChar, InvNumber_find TVarChar
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

             , Sum_Sale            TFloat
             , Sum_Return          TFloat
             , Sum_SaleReturnIn    TFloat
             , Sum_Sale_weight     TFloat
             , Sum_ReturnIn_weight TFloat
             , Comment TVarChar
             , ReportBonusId Integer
             , isSend Boolean

             , AmountKg  TFloat
             , AmountSh  TFloat
             , PartKg    TFloat
              )
AS
$BODY$
--    DECLARE inisMovement  Boolean ; -- по документам
    DECLARE vbEndDate     TDateTime;
BEGIN

     --только для бонус НАЛ
     IF COALESCE (inPaidKindId,0) <> zc_Enum_PaidKind_SecondForm()
     THEN
         RETURN;
     END IF;

     --inisMovement:= FALSE;
     vbEndDate := inEndDate + INTERVAL '1 Day';

    RETURN QUERY
      WITH
           tmpPersonal_byMember AS (SELECT ObjectLink_Personal_Member.ObjectId AS PersonalId
                                    FROM ObjectLink AS ObjectLink_Personal_Member
                                    WHERE ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                      AND ObjectLink_Personal_Member.ChildObjectId = inMemberId
                                      AND COALESCE (inMemberId,0) <> 0
                                    )

         , tmpContract_full AS (SELECT View_Contract.*
                                FROM Object_Contract_View AS View_Contract
                                WHERE (View_Contract.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                )
         , tmpContract_all AS (SELECT *
                               FROM tmpContract_full
                               WHERE tmpContract_full.PaidKindId = inPaidKindId OR COALESCE (inPaidKindId, 0)  = 0
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

          -- Условия договора на Дату
        , tmpContractCondition AS (SELECT Object_ContractCondition_View.ContractId
                                        , Object_ContractCondition_View.ContractConditionId
                                        , Object_ContractCondition_View.ContractConditionKindId
                                        , Object_ContractCondition_View.PaidKindId_Condition
                                        , Object_ContractCondition_View.Value
                                   FROM Object_ContractCondition_View
                                   WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSalePart()
                                                                                                  )
                                     AND Object_ContractCondition_View.Value <> 0
                                   --AND inStartDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                     AND inEndDate   BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                )
           -- учитываем zc_Object_ContractPartner - т.е. БАЗУ берем только по этим точкам - если они установлены, иначе по всем
         , tmpContractPartner_only AS
                        (SELECT tmpContract_full.ContractId AS ContractId
                              , tmpContract_full.JuridicalId
                              , COALESCE (ObjectLink_ContractPartner_Partner.ChildObjectId,ObjectLink_Partner_Juridical.ObjectId)   AS PartnerId

                              , CASE WHEN tmpContractCondition.PaidKindId_Condition <> 0
                                     THEN tmpContractCondition.PaidKindId_Condition
                                     ELSE tmpContract_full.PaidKindId
                                END AS PaidKindId_byBase
                                -- если нужно считать по условиям - для НАЛ
                              , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN tmpContractCondition.ContractConditionId ELSE 0 END AS ContractConditionId

                                -- !!!прописано - где брать "базу"!!!
                              , CASE WHEN ObjectLink_Contract_InfoMoney_send.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                             , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                              )
                                      AND tmpContract_full.InfoMoneyId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                                         , zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                                          )
                                     THEN ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                     ELSE 0
                                 END AS ContractId_baza

                         FROM tmpContract_full

                                  INNER JOIN tmpContractCondition
                                          ON tmpContractCondition.ContractId = tmpContract_full.ContractId
                                         AND tmpContractCondition.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSalePart()
                                                                                             )

                                  LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                       ON ObjectLink_ContractPartner_Contract.ChildObjectId = tmpContractCondition.ContractId
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

                                  -- !!!прописано - где брать "базу" или маркет-договор начисления!!!
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                                       ON ObjectLink_ContractCondition_ContractSend.ObjectId = tmpContractCondition.ContractConditionId
                                                      AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
                                  -- для ContractId_send
                                  LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_send
                                                       ON ObjectLink_Contract_InfoMoney_send.ObjectId = ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                                      AND ObjectLink_Contract_InfoMoney_send.DescId   = zc_ObjectLink_Contract_InfoMoney()

                         WHERE tmpContract_full.PaidKindId = inPaidKindId
                        )
           -- Для нал еще выбираем контрагентов из условий договора, если выбраны. то бонусы только на них считаем
         , tmpCCPartner AS (SELECT tmp.ContractId
                                 , tmp.ContractConditionId
                                 , tmp.JuridicalId
                                 , tmp.PaidKindId_byBase
                                 , ObjectLink_ContractConditionPartner_Partner.ChildObjectId AS PartnerId
                            FROM (SELECT DISTINCT tmpContractPartner_only.ContractId, tmpContractPartner_only.ContractConditionId, tmpContractPartner_only.JuridicalId, tmpContractPartner_only.PaidKindId_byBase
                                  FROM tmpContractPartner_only
                                 ) AS tmp
                                 LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                                      ON ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId = tmp.ContractConditionId
                                                     AND ObjectLink_ContractConditionPartner_ContractCondition.DescId = zc_ObjectLink_ContractConditionPartner_ContractCondition()

                                 INNER JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                                       ON ObjectLink_ContractConditionPartner_Partner.ObjectId = ObjectLink_ContractConditionPartner_ContractCondition.ObjectId
                                                      AND ObjectLink_ContractConditionPartner_Partner.DescId = zc_ObjectLink_ContractConditionPartner_Partner()
                           )

         -- объединяеем 2 таблички
         , tmpContractPartner AS (-- ограничение контрагентами из условий договора
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
                                  SELECT tmpCCPartner.ContractId
                                       , tmpCCPartner.JuridicalId
                                       , tmpCCPartner.PartnerId
                                       , tmpCCPartner.PaidKindId_byBase
                                         -- если нужно считать по условиям
                                       , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN tmpCCPartner.ContractConditionId ELSE 0 END AS ContractConditionId

                                       -- !!!прописано - где брать "базу"!!!
                                      , CASE WHEN ObjectLink_Contract_InfoMoney_send.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                     , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                      )
                                              AND tmpContract_full.InfoMoneyId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                                                 , zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                                                  )
                                             THEN ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                             ELSE 0
                                        END AS ContractId_baza

                                  FROM tmpCCPartner
                                       LEFT JOIN tmpContractPartner_only ON tmpContractPartner_only.ContractConditionId = tmpCCPartner.ContractConditionId
                                                                        AND tmpContractPartner_only.PartnerId           = tmpCCPartner.PartnerId

                                       INNER JOIN tmpContract_full ON tmpContract_full.ContractId = tmpCCPartner.ContractId
                                       -- !!!прописано - где брать "базу" или маркет-договор начисления!!!
                                       LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                                            ON ObjectLink_ContractCondition_ContractSend.ObjectId = tmpCCPartner.ContractConditionId
                                                           AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
                                       -- для ContractId_send
                                       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_send
                                                            ON ObjectLink_Contract_InfoMoney_send.ObjectId = ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                                           AND ObjectLink_Contract_InfoMoney_send.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                  WHERE tmpContractPartner_only.PartnerId IS NULL
                                  --AND COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) <> 0
                                 )

         -- формируется список договоров, у которых есть условие по "Бонусам"
       , tmpContractConditionKind AS (SELECT -- условие договора
                                             tmpContractCondition.ContractConditionKindId AS ContractConditionKindId
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
                                           , tmpContractCondition.PaidKindId_Condition               AS PaidKindId_ContractCondition
                                             -- вид бонуса
                                           , ObjectLink_ContractCondition_BonusKind.ChildObjectId    AS BonusKindId
                                           , COALESCE (tmpContractCondition.Value, 0)                AS Value
                                           , COALESCE (ObjectFloat_PercentRetBonus.ValueData,0)      AS PercentRetBonus
                                           , COALESCE (Object_Comment.ValueData, '')                 AS Comment

                                           -- !!!прописано - где брать "базу"!!!
                                           --, ObjectLink_ContractCondition_ContractSend.ChildObjectId AS ContractId_send
                                           , CASE WHEN ObjectLink_Contract_InfoMoney_send.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                          , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                           )
                                                   AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                                                    , zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
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
                                                                                     )
                                                  THEN ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                                  ELSE 0
                                             END AS ContractId_baza

                                             -- если нужно считать по условиям - для НАЛ
                                           , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN tmpContractCondition.ContractConditionId ELSE 0 END AS ContractConditionId

                                      FROM tmpContractCondition
                                           -- а это сам договор, в котором бонусное условие
                                           INNER JOIN tmpContract_find AS View_Contract ON View_Contract.ContractId = tmpContractCondition.ContractId
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
                                      WHERE tmpContractCondition.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSalePart())
                                     )

      -- только бонусные договора
    , tmpContract AS (SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.InvNumber_master
                           , Object_Contract.ValueData                AS InvNumber_child
                           , tmpContractConditionKind.ContractId_master
                           , tmpContractConditionKind.ContractId_baza AS ContractId_child
                           , tmpContractConditionKind.ContractTagName_master       AS ContractTagName_child
                           , tmpContractConditionKind.ContractStateKindCode_master AS ContractStateKindCode_child
                           , tmpContractConditionKind.InfoMoneyId_master
                           , tmpContractConditionKind.InfoMoneyId_child
                           , tmpContractConditionKind.InfoMoneyId_Condition
                           , tmpContractConditionKind.PaidKindId
                           , tmpContractConditionKind.PaidKindId_ContractCondition        AS PaidKindId_byBase
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                           , tmpContractConditionKind.ContractConditionId
                      FROM tmpContractConditionKind
                           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpContractConditionKind.ContractId_baza
                     )

      -- группируем договора, т.к. "базу" будем формировать по 4-м ключам
    , tmpContractGroup AS (SELECT tmpContract.JuridicalId
                                , tmpContract.ContractId_master
                                , tmpContract.ContractId_child
                                , tmpContract.InfoMoneyId_child
                                , tmpContract.PaidKindId_byBase
                                , tmpContract.ContractConditionId
                           FROM tmpContract
                           GROUP BY tmpContract.JuridicalId
                                  , tmpContract.ContractId_master
                                  , tmpContract.ContractId_child
                                  , tmpContract.InfoMoneyId_child
                                  , tmpContract.PaidKindId_byBase
                                  , tmpContract.ContractConditionId
                          )

      -- выбираем по юр.лицу всех контрагентов, РЦ , торг.сеть  --- по ним выбираем внешние продажи , рассчитываем %бонуса
    , tmpRetail AS (SELECT tmpJur.JuridicalId
                         , ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                         , ObjectLink_Partner_Juridical.ObjectId     AS PartnerId
                    FROM (SELECT DISTINCT tmp.JuridicalId FROM tmpContractGroup AS tmp) AS tmpJur
                         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = tmpJur.JuridicalId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                         LEFT JOIN Object AS Object_Retail_Partner ON Object_Retail_Partner.Id = ObjectLink_Juridical_Retail.ChildObjectId

                         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                              ON ObjectLink_Partner_Juridical.ChildObjectId = tmpJur.JuridicalId
                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                    )

     -- получаем расчетные данные из отчета по внешним продажам
    , tmpReport AS (--Готовая продукция
                    SELECT tmpReport.PartnerId_from AS PartnerId
                         , tmpReport.ContractId
                         , (tmpReport.AmountKg) AS AmountKg                    -- Кол-во, кг - внешняя продажа
                         , (tmpReport.AmountSh) AS AmountSh                    -- кол-во, шт - внешняя продажа
                         , (tmpReport.PartKg) AS PartKg                      -- Доля продаж в кг
                         , tmpReport.PartnerRealId
                         , (tmpReport.TotalSumm_calc) AS TotalSumm_calc              -- Расчетная сумма продаж, грн  БАЗА
                         , (tmpReport.TotalWeight_calc) AS TotalWeight_calc            -- Расчетная сумма продаж, кг
                         , SUM(tmpReport.SaleReturn_Summ) AS SaleReturn_Summ             -- Чистая продажа, грн
                         , SUM(tmpReport.Sale_Summ) AS Sale_Summ                   -- Продажа, грн
                         , SUM(tmpReport.Return_Summ)AS Return_Summ                 -- Возврат, грн
                         , SUM(tmpReport.SaleReturn_Weight) AS SaleReturn_Weight           -- Чистая продажа, кг
                         , SUM(tmpReport.Sale_Weight) AS Sale_Weight                 -- продажа, кг
                         , SUM(tmpReport.Return_Weight)  AS Return_Weight             -- возврат , кг
                    FROM (SELECT DISTINCT tmpRetail.RetailId FROM tmpRetail) AS tmp
                         LEFT JOIN gpReport_SaleExternal (inStartDate    := inStartDate    ::TDateTime
                                                        , inEndDate      := inEndDate      ::TDateTime
                                                        , inRetailId     := tmp.RetailId   ::Integer
                                                        , inJuridicalId  := CASE WHEN tmp.RetailId = 310859 THEN 15196 ELSE 0 END ::Integer   -- для Новуса ограничиваем еще юрлицом
                                                        , inGoodsGroupId :=  1832           ::Integer       --1832  Готовая продукция
                                                        , inisContract   := true           ::Boolean       --разворачивать по договорам
                                                        , inSession      := inSession      ::TVarChar
                                                        ) AS tmpReport ON 1=1
                    GROUP BY tmpReport.PartnerId_from
                           , tmpReport.ContractId
                           , (tmpReport.AmountKg)
                           , (tmpReport.AmountSh)
                           , (tmpReport.PartKg)
                           , tmpReport.PartnerRealId
                           , (tmpReport.TotalSumm_calc)
                           , (tmpReport.TotalWeight_calc)
                   UNION
                    -- + Тушенка
                    SELECT tmpReport.PartnerId_from AS PartnerId
                         , tmpReport.ContractId
                         , (tmpReport.AmountKg) AS AmountKg                    -- Кол-во, кг - внешняя продажа
                         , (tmpReport.AmountSh) AS AmountSh                    -- кол-во, шт - внешняя продажа
                         , (tmpReport.PartKg) AS PartKg                      -- Доля продаж в кг
                         , tmpReport.PartnerRealId
                         , (tmpReport.TotalSumm_calc) AS TotalSumm_calc              -- Расчетная сумма продаж, грн  БАЗА
                         , (tmpReport.TotalWeight_calc) AS TotalWeight_calc            -- Расчетная сумма продаж, кг
                         , SUM(tmpReport.SaleReturn_Summ) AS SaleReturn_Summ             -- Чистая продажа, грн
                         , SUM(tmpReport.Sale_Summ) AS Sale_Summ                   -- Продажа, грн
                         , SUM(tmpReport.Return_Summ)AS Return_Summ                 -- Возврат, грн
                         , SUM(tmpReport.SaleReturn_Weight) AS SaleReturn_Weight           -- Чистая продажа, кг
                         , SUM(tmpReport.Sale_Weight) AS Sale_Weight                 -- продажа, кг
                         , SUM(tmpReport.Return_Weight)  AS Return_Weight             -- возврат , кг
                    FROM (SELECT DISTINCT tmpRetail.RetailId FROM tmpRetail) AS tmp
                         LEFT JOIN gpReport_SaleExternal (inStartDate    := inStartDate    ::TDateTime
                                                        , inEndDate      := inEndDate      ::TDateTime
                                                        , inRetailId     := tmp.RetailId   ::Integer
                                                        , inJuridicalId  := CASE WHEN tmp.RetailId = 310859 THEN 15196 ELSE 0 END ::Integer   -- для Новуса ограничиваем еще юрлицом
                                                        , inGoodsGroupId :=  1979           ::Integer       --1979 Тущенка
                                                        , inisContract   := true           ::Boolean       --разворачивать по договорам
                                                        , inSession      := inSession      ::TVarChar
                                                        ) AS tmpReport ON 1=1
                    GROUP BY tmpReport.PartnerId_from
                           , tmpReport.ContractId
                           , (tmpReport.AmountKg)
                           , (tmpReport.AmountSh)
                           , (tmpReport.PartKg)
                           , tmpReport.PartnerRealId
                           , (tmpReport.TotalSumm_calc)
                           , (tmpReport.TotalWeight_calc)
                   )

        --ограничиваем контрагентами и привязываем свойства договора
      , tmpMovementCont AS (SELECT tmpContractGroup.JuridicalId
                                 , tmpContractGroup.ContractId_master
                                 , COALESCE (tmpContractPartner.ContractId_baza, tmpContractGroup.ContractId_master) AS ContractId_child  --tmpContractGroup.ContractId_child
                                 , 0 AS InfoMoneyId_child --tmpContractGroup.InfoMoneyId_child
                                 , tmpContractPartner.PaidKindId_byBase --tmpContractGroup.PaidKindId_byBase
                                 , tmpContractGroup.ContractConditionId
                                 --, tmpReport.PartnerRealName  --- ?? может и не нужно показывать
                                 , tmpReport.PartnerId
                                 , tmpReport.TotalSumm_calc    AS Sum_CheckBonus --расчетная база
                                 , tmpReport.AmountKg
                                 , tmpReport.AmountSh
                                 , tmpReport.PartKg
                                 , tmpReport.TotalWeight_calc
                                 , tmpReport.SaleReturn_Summ   AS Sum_SaleReturnIn --
                                 , tmpReport.Sale_Summ         AS Sum_Sale
                                 , tmpReport.Return_Summ       AS Sum_Return
                                 , tmpReport.SaleReturn_Weight
                                 , tmpReport.Sale_Weight       AS Sum_Sale_weight
                                 , tmpReport.Return_Weight     AS Sum_ReturnIn_weight
                                 , (tmpContract.Value * tmpReport.TotalSumm_calc / 100)   AS Sum_Bonus -- Начисления (расчет)
                                 , tmpContract.PercentRetBonus
                                 , tmpContract.Value
                                 , tmpContract.BonusKindId
                            FROM tmpReport
                             INNER JOIN tmpContractPartner ON tmpContractPartner.PartnerId = tmpReport.PartnerId
                                                          AND (tmpContractPartner.ContractId_baza = tmpReport.ContractId OR COALESCE (tmpContractPartner.ContractId_baza,0) = 0 OR COALESCE (tmpReport.ContractId,0) = 0 )
                             LEFT JOIN (SELECT DISTINCT tmpContractGroup.ContractId_master
                                             , tmpContractGroup.ContractConditionId
                                             , tmpContractGroup.JuridicalId
                                             , tmpContractGroup.PaidKindId_byBase
                                        FROM tmpContractGroup) AS tmpContractGroup
                                                               ON tmpContractGroup.ContractConditionId = tmpContractPartner.ContractConditionId
                                                              AND tmpContractGroup.ContractId_master = tmpContractPartner.ContractId
                             LEFT JOIN (SELECT DISTINCT tmpContract.ContractId_master
                                             , tmpContract.PaidKindId_byBase
                                             , tmpContract.ContractConditionId
                                             , tmpContract.JuridicalId
                                             , tmpContract.PercentRetBonus
                                             , tmpContract.Value
                                             , tmpContract.BonusKindId
                                        FROM tmpContract) AS tmpContract
                                                          ON tmpContract.JuridicalId       = tmpContractGroup.JuridicalId
                                                         AND (tmpContract.PaidKindId_byBase = tmpContractGroup.PaidKindId_byBase OR COALESCE (tmpContract.PaidKindId_byBase,0) = 0)
                                                         AND tmpContract.ContractConditionId = tmpContractGroup.ContractConditionId
                                                         AND tmpContract.ContractId_master = tmpContractGroup.ContractId_master
                            )

       -- сгруппировываем данные
      , tmpGroupMov AS (SELECT tmpGroup.JuridicalId
                             , tmpGroup.PartnerId
                             , tmpGroup.ContractId_master
                             , tmpGroup.ContractId_child
                             , tmpGroup.InfoMoneyId_child
                             , tmpGroup.PaidKindId_byBase
                             , tmpGroup.ContractConditionId
                             , tmpGroup.PercentRetBonus
                             , tmpGroup.Value
                             , tmpGroup.BonusKindId
                             , tmpGroup.AmountKg
                             , tmpGroup.AmountSh
                             , tmpGroup.PartKg
                             , COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) AS BranchId

                             , SUM (tmpGroup.Sum_CheckBonus)      AS Sum_CheckBonus
                             , SUM (tmpGroup.Sum_Bonus)           AS Sum_Bonus

                             , SUM (tmpGroup.Sum_Sale)            AS Sum_Sale
                             , SUM (tmpGroup.Sum_SaleReturnIn)    AS Sum_SaleReturnIn
                             , SUM (tmpGroup.Sum_Return)          AS Sum_Return

                             , SUM (tmpGroup.Sum_Sale_weight)     AS Sum_Sale_weight
                             , SUM (tmpGroup.Sum_ReturnIn_weight) AS Sum_ReturnIn_weight

                        FROM tmpMovementCont AS tmpGroup
                             -- для Базы БН получаем филиал по сотруднику из договора, по ведомости
                             LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                                  ON ObjectLink_Contract_PersonalTrade.ObjectId = tmpGroup.ContractId_master
                                                 AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()

                             LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                  ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Contract_PersonalTrade.ChildObjectId
                                                 AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                             LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch
                                                  ON ObjectLink_PersonalServiceList_Branch.ObjectId = ObjectLink_Personal_PersonalServiceList.ChildObjectId
                                                 AND ObjectLink_PersonalServiceList_Branch.DescId = zc_ObjectLink_PersonalServiceList_Branch()
                        WHERE (COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) = inBranchId OR inBranchId = 0)
                        GROUP BY tmpGroup.JuridicalId
                               , tmpGroup.PartnerId
                               , tmpGroup.ContractId_master
                               , tmpGroup.ContractId_child
                               , tmpGroup.InfoMoneyId_child
                               , tmpGroup.PaidKindId_byBase
                               , tmpGroup.ContractConditionId
                               , COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0)
                               , tmpGroup.PercentRetBonus
                               , tmpGroup.Value
                               , tmpGroup.BonusKindId
                               , tmpGroup.AmountKg
                               , tmpGroup.AmountSh
                               , tmpGroup.PartKg
                       )

      , tmpMovement AS (SELECT tmpGroup.JuridicalId
                             , tmpGroup.PartnerId
                             , tmpGroup.ContractId_child
                             , tmpGroup.ContractId_master
                             , tmpGroup.InfoMoneyId_child
                             , tmpGroup.PaidKindId_byBase
                             , tmpGroup.ContractConditionId
                             , tmpGroup.BranchId
                             , tmpGroup.PercentRetBonus
                             , tmpGroup.Value
                             , tmpGroup.Sum_Sale
                             , tmpGroup.Sum_Return
                             , tmpGroup.Sum_SaleReturnIn
                             , tmpGroup.Sum_Sale_weight
                             , tmpGroup.Sum_ReturnIn_weight
                             , tmpGroup.Sum_CheckBonus
                             , tmpGroup.Sum_Bonus
                             , tmpGroup.BonusKindId
                             , tmpGroup.AmountKg
                             , tmpGroup.AmountSh
                             , tmpGroup.PartKg
                             --расчитывем % возврата факт = факт возврата / факт отгрузки * 100
                             , CASE WHEN COALESCE (tmpGroup.Sum_Sale,0) <> 0 THEN tmpGroup.Sum_Return / tmpGroup.Sum_Sale * 100 ELSE 0 END AS PercentRetBonus_fact
                             , CASE WHEN COALESCE (tmpGroup.Sum_Sale_weight,0) <> 0 THEN tmpGroup.Sum_ReturnIn_weight / tmpGroup.Sum_Sale_weight * 100 ELSE 0 END AS PercentRetBonus_fact_weight
                        FROM tmpGroupMov AS tmpGroup
                       )


           , tmpAll as(SELECT tmp.*
                       FROM (SELECT tmpContract.InvNumber_master
                                  , CASE WHEN COALESCE(tmpContract.ContractId_child,0) <> 0 THEN tmpContract.InvNumber_child ELSE tmpContract.InvNumber_master END AS InvNumber_child
                                  , tmpContract.InvNumber_master AS InvNumber_find

                                  , tmpContract.ContractTagName_child
                                  , tmpContract.ContractStateKindCode_child

                                  , tmpContract.ContractId_master
                                  , CASE WHEN COALESCE(tmpContract.ContractId_child,0) <> 0 THEN tmpContract.ContractId_child ELSE tmpContract.ContractId_master END AS ContractId_child
                                  , tmpContract.ContractId_master AS ContractId_find

                                  , tmpContract.InfoMoneyId_master
                                  , tmpContract.InfoMoneyId_child
                                  , tmpContract.InfoMoneyId_master AS InfoMoneyId_find

                                  , tmpContract.JuridicalId AS JuridicalId
                                  , tmpMovement.PartnerId
                                  -- подменяем обратно ФО bз усл.договора на ФО из договора
                                  , tmpContract.PaidKindId -- tmpMovement.PaidKindId AS PaidKindId
                                    -- ФО договора базы
                                  , CASE WHEN COALESCE (tmpContract.PaidKindId_byBase, 0) = 0
                                              -- что б не разъехались строки расчет и факт - замена
                                              THEN tmpContract.PaidKindId
                                         ELSE tmpContract.PaidKindId_byBase
                                    END AS PaidKindId_child
                                  , tmpContract.ContractConditionKindId
                                  , tmpMovement.BonusKindId
                                  , COALESCE (tmpContract.Value,0) AS Value
                                  , COALESCE (tmpContract.PercentRetBonus,0)            ::TFloat AS PercentRetBonus
                                  , COALESCE (tmpMovement.PercentRetBonus_fact,0)       ::TFloat AS PercentRetBonus_fact
                                  , COALESCE (tmpMovement.PercentRetBonus_fact_weight,0)::TFloat AS PercentRetBonus_fact_weight

                                  , tmpMovement.Sum_CheckBonus

                                    -- когда % возврата факт превышает % возврата план, бонус не начисляется
                                  , CAST (CASE WHEN (COALESCE (tmpContract.PercentRetBonus,0) <> 0 AND tmpMovement.PercentRetBonus_fact_weight > tmpContract.PercentRetBonus) THEN 0
                                               ELSE tmpMovement.Sum_Bonus
                                          END  AS NUMERIC (16, 0)) AS Sum_Bonus
                                  , 0 :: TFloat                    AS Sum_BonusFact
                                  , 0 :: TFloat                    AS Sum_CheckBonusFact
                                  , 0 :: TFloat                    AS Sum_SaleFact

                                  , COALESCE (tmpMovement.Sum_Sale,0)            AS Sum_Sale
                                  , COALESCE (tmpMovement.Sum_Return,0)          AS Sum_Return
                                  , COALESCE (tmpMovement.Sum_SaleReturnIn,0)    AS Sum_SaleReturnIn
                                  , COALESCE (tmpMovement.Sum_Sale_weight,0)     AS Sum_Sale_weight
                                  , COALESCE (tmpMovement.Sum_ReturnIn_weight,0) AS Sum_ReturnIn_weight

                                  , COALESCE (tmpContract.Comment, '')  AS Comment

                                  , COALESCE (tmpMovement.BranchId,0)   AS BranchId

                                  , tmpMovement.AmountKg
                                  , tmpMovement.AmountSh
                                  , tmpMovement.PartKg
                             FROM tmpContract
                                  INNER JOIN tmpMovement ON tmpMovement.JuridicalId       = tmpContract.JuridicalId
                                                        AND (tmpMovement.PaidKindId_byBase = tmpContract.PaidKindId_byBase OR COALESCE (tmpContract.PaidKindId_byBase,0) = 0)
                                                        AND tmpMovement.ContractConditionId = tmpContract.ContractConditionId
                                                        AND tmpMovement.ContractId_master = tmpContract.ContractId_master

                             ) AS tmp

                    UNION ALL
                       SELECT View_Contract_InvNumber_master.InvNumber AS InvNumber_master
                            , View_Contract_InvNumber_child.InvNumber  AS InvNumber_child
                            , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find

                            , View_Contract_InvNumber_child.ContractTagName  AS ContractTagName_child
                            , View_Contract_InvNumber_child.ContractStateKindCode AS ContractStateKindCode_child

                            , COALESCE (MILinkObject_ContractMaster.ObjectId, MILinkObject_Contract.ObjectId, MILinkObject_ContractChild.ObjectId) AS ContractId_master
                            , COALESCE (MILinkObject_ContractChild.ObjectId, MILinkObject_ContractMaster.ObjectId, MILinkObject_Contract.ObjectId)  AS ContractId_child
                            , MILinkObject_Contract.ObjectId                 AS ContractId_find

                            , View_Contract_InvNumber_master.InfoMoneyId     AS InfoMoneyId_master
                            , View_Contract_InvNumber_child.InfoMoneyId      AS InfoMoneyId_child
                            , MILinkObject_InfoMoney.ObjectId                AS InfoMoneyId_find

                            , Object_Juridical.Id                            AS JuridicalId
                            --, CASE WHEN View_Contract_InvNumber_child.PaidKindId = zc_Enum_PaidKind_FirstForm() THEN 0 ELSE COALESCE (ObjectLink_Partner_Juridical.ObjectId,0) END AS PartnerId
                            , COALESCE (ObjectLink_Partner_Juridical.ObjectId,0) AS PartnerId
                            , MILinkObject_PaidKind.ObjectId                 AS PaidKindId
                            , View_Contract_InvNumber_child.PaidKindId       AS PaidKindId_child
                            , MILinkObject_ContractConditionKind.ObjectId    AS ContractConditionKindId
                            , MILinkObject_BonusKind.ObjectId                AS BonusKindId
                            , COALESCE (MIFloat_BonusValue.ValueData,0)      AS Value
                            , 0 ::TFloat                                     AS PercentRetBonus
                            , 0 ::TFloat                                     AS PercentRetBonus_fact
                            , 0 ::TFloat                                     AS PercentRetBonus_fact_weight
                            , 0 :: TFloat                                    AS Sum_CheckBonus
                            , 0 :: TFloat                                    AS Sum_Bonus
                            , MovementItem.Amount                            AS Sum_BonusFact
                            , MIFloat_Summ.ValueData                         AS Sum_CheckBonusFact
                            , MIFloat_AmountPartner.ValueData                AS Sum_SaleFact
                            , 0 :: TFloat                                    AS Sum_Sale
                            , 0 :: TFloat                                    AS Sum_Return
                            , 0 :: TFloat                                    AS Sum_SaleReturnIn
                            , 0 :: TFloat                                    AS Sum_Sale_weight
                            , 0 :: TFloat                                    AS Sum_ReturnIn_weight
                            , COALESCE (MIString_Comment.ValueData,'')       AS Comment
                            , COALESCE (MILinkObject_Branch.ObjectId,0)      AS BranchId
                            , 0 :: TFloat                                    AS AmountKg
                            , 0 :: TFloat                                    AS AmountSh
                            , 0 :: TFloat                                    AS PartKg
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

                       WHERE Movement.DescId = zc_Movement_ProfitLossService()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND (Movement.OperDate >= inStartDate AND Movement.OperDate < vbEndDate)
                         AND MILinkObject_InfoMoney.ObjectId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                               , zc_Enum_InfoMoney_21502()) -- Маркетинг + Бонусы за мясное сырье
                         AND (Object_Juridical.Id = inJuridicalId OR inJuridicalId = 0)
                         AND (COALESCE (MILinkObject_Branch.ObjectId,0) = inBranchId OR inBranchId = 0)
                         AND MILinkObject_ContractConditionKind.ObjectId = zc_Enum_ContractConditionKind_BonusPercentSalePart()
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
                           -- если была замена ContractId_child, меняем и Статью
                         , CASE WHEN tmpAll.ContractId_master = tmpAll.ContractId_child THEN tmpAll.InfoMoneyId_master ELSE tmpAll.InfoMoneyId_child END AS InfoMoneyId_child
                           --
                         , tmpAll.InfoMoneyId_find
                         , tmpAll.JuridicalId
                         , tmpAll.PartnerId
                         , tmpAll.PaidKindId
                         , tmpAll.PaidKindId_child
                         , tmpAll.ContractConditionKindId
                         , tmpAll.BonusKindId
                         , tmpAll.BranchId
                         , tmpAll.Value
                         , tmpAll.AmountKg
                         , tmpAll.AmountSh
                         , tmpAll.PartKg
                         , MAX (tmpAll.PercentRetBonus)    AS PercentRetBonus
                         , MAX (tmpAll.PercentRetBonus_fact)        AS PercentRetBonus_fact
                         , MAX (tmpAll.PercentRetBonus_fact_weight) AS PercentRetBonus_fact_weight
                         , SUM (tmpAll.Sum_CheckBonus)      AS Sum_CheckBonus
                         , SUM (tmpAll.Sum_CheckBonusFact)  AS Sum_CheckBonusFact
                         , SUM (tmpAll.Sum_Bonus)           AS Sum_Bonus
                         , SUM (tmpAll.Sum_BonusFact)*(-1)  AS Sum_BonusFact
                         , SUM (tmpAll.Sum_SaleFact)        AS Sum_SaleFact
                         , SUM (tmpAll.Sum_Sale)            AS Sum_Sale
                         , SUM (tmpAll.Sum_Return)          AS Sum_Return
                         , SUM (tmpAll.Sum_SaleReturnIn)    AS Sum_SaleReturnIn

                         , SUM (COALESCE (tmpAll.Sum_Sale_weight,0))     AS Sum_Sale_weight
                         , SUM (COALESCE (tmpAll.Sum_ReturnIn_weight,0)) AS Sum_ReturnIn_weight

                         , MAX (tmpAll.Comment) :: TVarChar AS Comment
                    FROM tmpAll
                    GROUP BY  tmpAll.ContractId_master
                            , tmpAll.ContractId_child
                            , tmpAll.ContractId_find
                            , tmpAll.InvNumber_master
                            , tmpAll.InvNumber_child
                            , tmpAll.InvNumber_find
                            , tmpAll.ContractTagName_child
                            , tmpAll.ContractStateKindCode_child
                            , tmpAll.InfoMoneyId_master
                            , CASE WHEN tmpAll.ContractId_master = tmpAll.ContractId_child THEN tmpAll.InfoMoneyId_master ELSE tmpAll.InfoMoneyId_child END
                            , tmpAll.InfoMoneyId_find
                            , tmpAll.JuridicalId
                            , tmpAll.PartnerId
                            , tmpAll.PaidKindId
                            , tmpAll.ContractConditionKindId
                            , tmpAll.BonusKindId
                            , tmpAll.Value
                            , tmpAll.BranchId
                            , tmpAll.PaidKindId_child
                            , tmpAll.AmountKg
                            , tmpAll.AmountSh
                            , tmpAll.PartKg
                    )


    , tmpObjectBonus AS (SELECT DISTINCT
                                ObjectLink_Juridical.ChildObjectId             AS JuridicalId
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
                              LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                   ON ObjectLink_Juridical.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectLink_Juridical.DescId = zc_ObjectLink_ReportBonus_Juridical()
                              LEFT JOIN ObjectLink AS ObjectLink_Partner
                                                   ON ObjectLink_Partner.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectLink_Partner.DescId = zc_ObjectLink_ReportBonus_Partner()

                              LEFT JOIN ObjectLink AS ObjectLink_ContractMaster
                                                   ON ObjectLink_ContractMaster.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectLink_ContractMaster.DescId = zc_ObjectLink_ReportBonus_ContractMaster()
                              LEFT JOIN ObjectLink AS ObjectLink_ContractChild
                                                   ON ObjectLink_ContractChild.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectLink_ContractChild.DescId = zc_ObjectLink_ReportBonus_ContractChild()
                         WHERE Object_ReportBonus.DescId   = zc_Object_ReportBonus()
                         --AND inPaidKindId                = zc_Enum_PaidKind_SecondForm()
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
      SELECT  tmpData.ContractId_master
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
            , Object_PersonalTrade.PersonalId             AS PersonalTradeId
            , Object_PersonalTrade.PersonalCode             AS PersonalTradeCode
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

            , CAST (tmpData.Sum_Sale            AS TFloat) AS Sum_Sale
            , CAST (tmpData.Sum_Return          AS TFloat) AS Sum_Return
            , CAST (tmpData.Sum_SaleReturnIn    AS TFloat) AS Sum_SaleReturnIn

            , CAST (tmpData.Sum_Sale_weight     AS TFloat) AS Sum_Sale_weight
            , CAST (tmpData.Sum_ReturnIn_weight AS TFloat) AS Sum_ReturnIn_weight

            , tmpData.Comment :: TVarChar                 AS Comment

            , tmpObjectBonus.Id :: Integer AS ReportBonusId
            , CASE WHEN tmpObjectBonus.isErased = FALSE THEN FALSE ELSE TRUE END :: Boolean AS isSend

            , tmpData.AmountKg  :: TFloat
            , tmpData.AmountSh  :: TFloat
            , tmpData.PartKg    :: TFloat

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
      WHERE ((tmpPersonal_byMember.PersonalId IS NOT NULL AND inPaidKindId = zc_Enum_PaidKind_SecondForm()) OR inMemberId = 0)
           OR tmpData.PaidKindId = zc_Enum_PaidKind_FirstForm()
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.12.20         *
*/

-- select * from gpReport_CheckBonus_PersentSalePart (inStartDate := ('01.12.2020')::TDateTime , inEndDate := ('02.12.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId :=  15158 /*15158 / 862910*/  , inBranchId := 0 , inMemberId:= 0, inSession := '5');
