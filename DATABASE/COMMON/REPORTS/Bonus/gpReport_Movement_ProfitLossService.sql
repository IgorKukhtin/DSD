-- FunctiON: gpReport_Movement_ProfitLossService()
DROP FUNCTION IF EXISTS gpReport_Movement_ProfitLossService (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean,  Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_ProfitLossService (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_ProfitLossService (
    IN inStartDate           TDateTime ,
    IN inEndDate             TDateTime ,
    IN inBranchId            Integer   , -- ***Филиал
    IN inAreaId              Integer   , -- ***Регион (контрагенты -> юр лица)
    IN inRetailId            Integer   , -- ***Торговая сеть (юр лица)
    IN inJuridicalId         Integer   , --
    IN inPaidKindId          Integer   , --
--    IN inTradeMarkId         Integer   , -- ***
--    IN inGoodsGroupId        Integer   , --
--    IN inInfoMoneyId         Integer   , -- Управленческая статья
    IN inIsPartner           Boolean   , --
--    IN inIsTradeMark         Boolean   , --
    IN inIsGoods             Boolean   , --
    IN inIsGoodsKind         Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate_Movement TDateTime, InvNumber_Movement TVarChar, DescName_Movement TVarChar
             , ContractId_master Integer, ContractId_child Integer, ContractId_find Integer, InvNumber_master TVarChar, InvNumber_child TVarChar, InvNumber_find TVarChar
             , ContractTagName_child TVarChar, ContractStateKindCode_child Integer
             , InfoMoneyId_master Integer, InfoMoneyId_find Integer
             , InfoMoneyName_master TVarChar, InfoMoneyName_child TVarChar, InfoMoneyName_find TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ConditionKindId Integer, ConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , Value TFloat
             , Sum_CheckBonus TFloat
             , Sum_CheckBonusFact TFloat
             , Sum_Bonus TFloat
             , Sum_BonusFact TFloat
             , Sum_SaleFact TFloat

             , Comment   TVarChar
             , PartnerId Integer
             , PartnerName TVarChar
            
             , GoodsId Integer
             , GoodsName TVarChar
             , GoodsKindId Integer
             , GoodsKindName TVarChar
           
            )  
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsGoods_where Boolean;
   DECLARE vbIsPartner_where Boolean;
   DECLARE vbIsJuridical_where Boolean;
   DECLARE inisMovement Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    vbIsGoods_where:= FALSE;
    vbIsPartner_where:= FALSE;
    vbIsJuridical_where:= FALSE;
    inisMovement:= FALSE;


    -- Ограничения по товару
  /*  IF inGoodsGroupId <> 0
    THEN
        -- устанавливается признак
        vbIsGoods_where:= TRUE;

    ELSE IF inTradeMarkId <> 0
         THEN
             -- устанавливается признак
             vbIsGoods_where:= TRUE;

         ELSE
             -- устанавливается признак
             vbIsGoods_where:= FALSE;

         END IF;
    END IF;

    -- Ограничения
    IF inAreaId <> 0
    THEN
        -- устанавливается признак
        vbIsPartner_where:= TRUE;
        -- устанавливается признак
        vbIsJuridical_where:= TRUE;

    ELSE
        -- по Юр Лицу (только)
        IF inJuridicalId <> 0
        THEN
            -- устанавливается признак
            vbIsJuridical_where:= TRUE;

        ELSE
            IF inRetailId <> 0
            THEN
                -- устанавливается признак
                vbIsJuridical_where:= TRUE;

            END IF;
        END IF;
    END IF;
*/
    RETURN QUERY
      WITH 
 /*     tmpGoods AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId AS GoodsId
                        , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                   FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                             ON ObjectLink_Goods_TradeMark.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                            AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                   WHERE (ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId OR COALESCE (inTradeMarkId, 0) = 0)
                     AND inGoodsGroupId > 0 -- !!!
        
                  UNION
                   SELECT ObjectLink_Goods_TradeMark.ObjectId AS GoodsId
                        , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                   FROM ObjectLink AS ObjectLink_Goods_TradeMark
                   WHERE ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                     AND ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId
                     AND COALESCE (inGoodsGroupId, 0) = 0 AND vbIsGoods_where = TRUE -- !!!
                  UNION
                   SELECT ObjectLink_Goods_TradeMark.ObjectId AS GoodsId
                        , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                   FROM ObjectLink AS ObjectLink_Goods_TradeMark
                   WHERE ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                     AND ObjectLink_Goods_TradeMark.ChildObjectId > 0
                     AND (inIsTradeMark = TRUE AND inIsGoods = FALSE)
                     AND vbIsGoods_where = FALSE -- !!!
                  )

        , tmpPartner AS (
                          -- заполнение по Контрагенту
                          SELECT ObjectLink_Partner_Area.ObjectId AS PartnerId
                               , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, 0) AS JuridicalId
                               -- , COALESCE (ObjectLink_Partner_Area.ChildObjectId, 0)
                          FROM ObjectLink AS ObjectLink_Partner_Area
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_Area.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                          WHERE ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
                            AND ObjectLink_Partner_Area.ChildObjectId = inAreaId
                            AND inAreaId > 0 -- !!!
                         )

        , tmpJuridical AS (
                            -- по Юр Лицу
                            SELECT DISTINCT _tmpPartner.JuridicalId
                            FROM tmpPartner AS  _tmpPartner
                                 LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = _tmpPartner.JuridicalId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            WHERE (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR COALESCE (inRetailId, 0) = 0)
                              AND (_tmpPartner.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                 
                              UNION
                                -- по Юр Лицу (только)
                                SELECT Object.Id
                                FROM Object
                                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                          ON ObjectLink_Juridical_Retail.ObjectId = Object.Id
                                                         AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                WHERE Object.Id = inJuridicalId
                                  AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR COALESCE (inRetailId, 0) = 0)
                                  AND COALESCE (inAreaId, 0) = 0 AND inJuridicalId > 0 -- !!!
                 
                                   UNION
                                    -- по inRetailId
                                    SELECT ObjectLink_Juridical_Retail.ObjectId
                                    FROM ObjectLink AS ObjectLink_Juridical_Retail
                                    WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                      AND ObjectLink_Juridical_Retail.ChildObjectId = inRetailId
                                      AND COALESCE (inAreaId, 0) = 0 AND COALESCE (inJuridicalId, 0) = 0 -- !!!
                           )
        ,*/ tmpContract_all AS (SELECT View_Contract.* FROM Object_Contract_View AS View_Contract
                               WHERE (View_Contract.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                 AND (View_Contract.PaidKindId  = inPaidKindId  OR COALESCE (inPaidKindId, 0)  = 0)
                              )
           -- все договора - не закрытые или для Базы
         , tmpContract_find AS (SELECT View_Contract.*
                                FROM tmpContract_all AS View_Contract
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
                                   WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                                 , zc_Enum_ContractConditionKind_BonusMonthlyPayment()
                                                                                                 , 0
                                                                                                  )
                                     AND Object_ContractCondition_View.Value <> 0
                                   --AND inStartDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                     AND inEndDate   BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
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

                                           , View_Contract.PaidKindId
                                             -- форма оплаты из усл.договора
                                           , tmpContractCondition.PaidKindId_Condition               AS PaidKindId_ContractCondition

                                             -- вид бонуса
                                           , ObjectLink_ContractCondition_BonusKind.ChildObjectId    AS BonusKindId
                                           , COALESCE (tmpContractCondition.Value, 0)                AS Value
                                           , COALESCE (Object_Comment.ValueData, '')                 AS Comment

                                           -- !!!прописано - где брать "базу"!!!
                                           --, ObjectLink_ContractCondition_ContractSend.ChildObjectId AS ContractId_send
                                             -- !!!прописано - где брать маркет-договор начисления!!!
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
                                                                                  --  AND (View_Contract.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId

                                           LEFT JOIN Object AS Object_Comment ON Object_Comment.Id = tmpContractCondition.ContractConditionId

                                           -- !!!прописано - где брать "базу" или маркет-договор начисления!!!
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                                                ON ObjectLink_ContractCondition_ContractSend.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_ContractSend.DescId   = zc_ObjectLink_ContractCondition_ContractSend()
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
    , tmpContractBonus AS (SELECT tmpContract_find.ContractId_master
                                , tmpContract_find.ContractId_find
                                , View_Contract_InvNumber_find.InfoMoneyId AS InfoMoneyId_find
                                , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find
                           FROM (-- базовые договора в которых "бонусное" условие + прописано какой подставить "маркет-договор"
                                 SELECT DISTINCT
                                        tmpContractConditionKind.ContractId_master
                                        --
                                      , tmpContractConditionKind.ContractId_send AS ContractId_find
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
                           , tmpContractConditionKind.PaidKindId
                           , tmpContractConditionKind.PaidKindId        AS PaidKindId_byBase
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
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
                           , tmpContractConditionKind.PaidKindId
                           -- берем ФО из усл.договора для нач. базы если не пусто , если фо не выбрана берем из догоовра
                           --(т.е. договор по форме НАЛ, отчет по форме НАЛ, а базу надо будет вытянуть по форме БН)
                           , CASE WHEN COALESCE (tmpContractConditionKind.PaidKindId_ContractCondition, 0) <> 0 THEN tmpContractConditionKind.PaidKindId_ContractCondition ELSE tmpContractConditionKind.PaidKindId END AS PaidKindId_byBase
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.Comment
                           , tmpContractConditionKind.ContractConditionId
                      FROM tmpContractConditionKind
                           LEFT JOIN tmpContract_all AS View_Contract_child ON View_Contract_child.ContractId = tmpContractConditionKind.ContractId_baza
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
                           , tmpContractConditionKind.PaidKindId
                           -- берем ФО из усл.договора для нач. базы если не пусто , если фо не выбрана берем из догоовра
                           --(т.е. договор по форме НАЛ, отчет по форме НАЛ, а базу надо будет вытянуть по форме БН)
                           , CASE WHEN COALESCE (tmpContractConditionKind.PaidKindId_ContractCondition, 0) <> 0 THEN tmpContractConditionKind.PaidKindId_ContractCondition ELSE tmpContractConditionKind.PaidKindId END AS PaidKindId_byBase
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.Comment
                           , tmpContractConditionKind.ContractConditionId
                      FROM tmpContractConditionKind
                           INNER JOIN tmpContract_all AS View_Contract_child
                                                      ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                                     AND View_Contract_child.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child
                      -- это будут бонусные договора
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child
                        -- НЕ указано где взять базу
                        AND tmpContractConditionKind.ContractId_baza = 0
                     )
        
      -- группируем договора, т.к. "базу" будем формировать по 4-м ключам
    , tmpContractGroup AS (SELECT tmpContract.JuridicalId
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

    , tmpContainer1 AS (SELECT DISTINCT
                               tmpContainerAll.Id  AS ContainerId
                             , tmpContractGroup.JuridicalId
                             , tmpContractGroup.ContractId_master
                             , tmpContractGroup.ContractId_child
                             , tmpContractGroup.InfoMoneyId_child
                             , tmpContainerAll.PaidKindId
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
        -- получили базу по MovementId
      , tmpMovement AS (SELECT tmpGroup.JuridicalId
                             , tmpGroup.ContractId_child 
                             , tmpGroup.InfoMoneyId_child
                             , tmpGroup.PaidKindId
                             , tmpGroup.MovementId
                             , tmpGroup.MovementDescId
                             , tmpGroup.PartnerId
                             , tmpGroup.GoodsId
                             , tmpGroup.GoodsKindId 
                             , SUM (tmpGroup.Sum_Sale) AS Sum_Sale
                             , SUM (tmpGroup.Sum_SaleReturnIn) AS Sum_SaleReturnIn
                             , SUM (tmpGroup.Sum_Account) AS Sum_Account
                        FROM (SELECT tmpContainer.JuridicalId
                                   , tmpContainer.ContractId_child
                                   , tmpContainer.InfoMoneyId_child
                                   , tmpContainer.PaidKindId
                                   , CASE WHEN inIsPartner = TRUE THEN MIContainer.ObjectextId_Analyzer ELSE 0 END  AS PartnerId
                                   , CASE WHEN inIsGoods = TRUE THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS GoodsId
                                   , CASE WHEN inIsGoodsKind = TRUE THEN MIContainer.ObjectintId_Analyzer ELSE 0 END AS GoodsKindId 
                                   
                                   , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS Sum_Sale -- Только продажи
                                   , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MIContainer.Amount ELSE 0 END) AS Sum_SaleReturnIn -- продажи - возвраты
                                   , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())
                                                    THEN -1 * MIContainer.Amount
                                               ELSE 0
                                          END) AS Sum_Account -- оплаты
                                   , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementDescId ELSE 0 END  AS MovementDescId
                                   , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END      AS MovementId

                              FROM tmpContainer
                                   JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                             AND MIContainer.DescId = zc_MIContainer_Summ()
                                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                             AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_BankAccount(),zc_Movement_Cash(), zc_Movement_SendDebt())

                              GROUP BY tmpContainer.JuridicalId
                                     , tmpContainer.ContractId_child
                                     , tmpContainer.InfoMoneyId_child
                                     , tmpContainer.PaidKindId
                                   , CASE WHEN inIsPartner = TRUE THEN MIContainer.ObjectextId_Analyzer ELSE 0 END
                                   , CASE WHEN inIsGoods = TRUE THEN MIContainer.ObjectId_Analyzer ELSE 0 END
                                   , CASE WHEN inIsGoodsKind = TRUE THEN MIContainer.ObjectintId_Analyzer ELSE 0 END
                                     , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementDescId ELSE 0 END
                                     , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END
                             ) AS tmpGroup
                        GROUP BY tmpGroup.JuridicalId
                               , tmpGroup.ContractId_child
                               , tmpGroup.InfoMoneyId_child
                               , tmpGroup.PaidKindId
                               , tmpGroup.MovementId
                               , tmpGroup.MovementDescId
                               , tmpGroup.PartnerId
                               , tmpGroup.GoodsId
                               , tmpGroup.GoodsKindId
                       )

      , tmpProfitLossService AS (SELECT View_Contract_InvNumber_master.InvNumber AS InvNumber_master
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
                                      , MILinkObject_PaidKind.ObjectId                 AS PaidKindId
                                      , MILinkObject_ContractConditionKind.ObjectId    AS ContractConditionKindId
                                      , MILinkObject_BonusKind.ObjectId                AS BonusKindId
                                      , MILinkObject_Branch.ObjectId                   AS BranchId
                                      , MIFloat_BonusValue.ValueData                   AS Value
          
                                      , 0 :: TFloat                                    AS Sum_CheckBonus
                                      , 0 :: TFloat                                    AS Sum_Bonus
                                      , MovementItem.Amount                            AS Sum_BonusFact
                                      , MIFloat_Summ.ValueData                         AS Sum_CheckBonusFact
                                      , MIFloat_AmountPartner.ValueData                AS Sum_SaleFact
            
                                      , MIString_Comment.ValueData                     AS Comment
          
                                      , CASE WHEN inisMovement = TRUE THEN Movement.Id ELSE 0 END      AS MovementId
                                      , CASE WHEN inisMovement = TRUE THEN Movement.DescId ELSE 0 END  AS MovementDescId
                                      , 0 AS PartnerId
                                      , 0 AS GoodsId
                                      , 0 AS GoodsKindId
                                 FROM Movement 
                                      LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          
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
                                      LEFT JOIN tmpContract_all AS View_Contract_InvNumber_child ON View_Contract_InvNumber_child.ContractId = MILinkObject_ContractChild.ObjectId
                     
                                 WHERE Movement.DescId = zc_Movement_ProfitLossService()
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                   AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                   AND MILinkObject_InfoMoney.ObjectId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                             , zc_Enum_InfoMoney_21502()) -- Маркетинг + Бонусы за мясное сырье
                                 )

           , tmpAll as(SELECT tmpContract.InvNumber_master
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
                            , tmpMovement.PaidKindId  AS PaidKindId
                            , tmpContract.ContractConditionKindId
                            , tmpContract.BonusKindId
                            , tmpProfitLossService.BranchId
                            , tmpContract.Value

                            , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale() THEN tmpMovement.Sum_Sale 
                                         WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn() THEN tmpMovement.Sum_SaleReturnIn
                                         WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN tmpMovement.Sum_Account
                                    ELSE 0 END  AS TFloat) AS Sum_CheckBonus
                            , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale() THEN (tmpMovement.Sum_Sale/100 * tmpContract.Value)
                                         WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn() THEN (tmpMovement.Sum_SaleReturnIn/100 * tmpContract.Value) 
                                         WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN (tmpMovement.Sum_Account/100 * tmpContract.Value)
                                    ELSE 0 END AS NUMERIC (16, 2)) AS Sum_Bonus

                            , tmpProfitLossService.Sum_BonusFact      :: TFloat                  AS Sum_BonusFact
                            , tmpProfitLossService.Sum_CheckBonusFact :: TFloat                  AS Sum_CheckBonusFact
                            , tmpProfitLossService.Sum_SaleFact       :: TFloat                  AS Sum_SaleFact

                            , tmpContract.Comment
                  
                            , tmpMovement.MovementId
                            , tmpMovement.MovementDescId

                            , tmpMovement.PartnerId
                            , tmpMovement.GoodsId
                            , tmpMovement.GoodsKindId

                       FROM tmpContract
                            INNER JOIN tmpMovement ON tmpMovement.JuridicalId       = tmpContract.JuridicalId
                                                  AND tmpMovement.ContractId_child  = tmpContract.ContractId_child
                                                  AND tmpMovement.InfoMoneyId_child = tmpContract.InfoMoneyId_child
                                                  AND tmpMovement.PaidKindId        = tmpContract.PaidKindId
                            LEFT JOIN tmpContractBonus ON tmpContractBonus.ContractId_master = tmpContract.ContractId_master

                            LEFT JOIN tmpProfitLossService ON tmpProfitLossService.JuridicalId       = tmpContract.JuridicalId
                                                          AND tmpProfitLossService.ContractId_child  = tmpContract.ContractId_child
                                                          AND tmpProfitLossService.InfoMoneyId_child = tmpContract.InfoMoneyId_child
                                                          AND tmpProfitLossService.PaidKindId        = tmpContract.PaidKindId
                                                          AND tmpProfitLossService.ContractConditionKindId = tmpContract.ContractConditionKindId
                                                          AND tmpProfitLossService.BonusKindId       = tmpContract.BonusKindId
                                                          AND tmpProfitLossService.Value             = tmpContract.Value
                      )


      SELECT  Movement.OperDate                             AS OperDate_Movement
            , Movement.InvNumber                            AS InvNumber_Movement
            , MovementDesc.ItemName                         AS DescName_Movement
            , tmpAll.ContractId_master
            , tmpAll.ContractId_child
            , tmpAll.ContractId_find
            , tmpAll.InvNumber_master
            , tmpAll.InvNumber_child
            , tmpAll.InvNumber_find

            , tmpAll.ContractTagName_child
            , tmpAll.ContractStateKindCode_child

            , Object_InfoMoney_master.Id                    AS InfoMoneyId_master
            , Object_InfoMoney_find.Id                      AS InfoMoneyId_find

            , Object_InfoMoney_master.ValueData             AS InfoMoneyName_master
            , Object_InfoMoney_child.ValueData              AS InfoMoneyName_child
            , Object_InfoMoney_find.ValueData               AS InfoMoneyName_find

            , Object_Juridical.Id                           AS JuridicalId
            , Object_Juridical.ValueData                    AS JuridicalName

            , Object_PaidKind.Id                            AS PaidKindId
            , Object_PaidKind.ValueData                     AS PaidKindName

            , Object_ContractConditionKind.Id               AS ConditionKindId
            , Object_ContractConditionKind.ValueData        AS ConditionKindName

            , Object_BonusKind.Id                           AS BonusKindId
            , Object_BonusKind.ValueData                    AS BonusKindName

            , Object_Branch.Id                              AS BranchId
            , Object_Branch.ValueData                       AS BranchName

            , CAST (tmpAll.Value AS TFloat)                 AS Value

            , CAST (SUM (tmpAll.Sum_CheckBonus) AS TFloat)     AS Sum_CheckBonus
            , CAST (SUM (tmpAll.Sum_CheckBonusFact) AS TFloat) AS Sum_CheckBonusFact
            , CAST (SUM (tmpAll.Sum_Bonus) AS TFloat)          AS Sum_Bonus
            , CAST (SUM (tmpAll.Sum_BonusFact)*(-1) AS TFloat) AS Sum_BonusFact
            , CAST (SUM (tmpAll.Sum_SaleFact)       AS TFloat) AS Sum_SaleFact
            , MAX (tmpAll.Comment) :: TVarChar                 AS Comment
            
            , Object_Partner.Id          :: integer            AS PartnerId
            , Object_Partner.ValueData   :: TVarChar           AS PartnerName
            , Object_Goods.Id            :: integer            AS GoodsId
            , Object_Goods.ValueData     :: TVarChar           AS GoodsName
            , Object_GoodsKind.Id        :: integer            AS GoodsKindId
            , Object_GoodsKind.ValueData :: TVarChar           AS GoodsKindName
                        
      FROM tmpAll

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpAll.JuridicalId 
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpAll.PaidKindId
            LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = tmpAll.BonusKindId
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpAll.ContractConditionKindId
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpAll.BranchId
            
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpAll.PartnerId 
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpAll.GoodsId 
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpAll.GoodsKindId 

            LEFT JOIN Object AS Object_InfoMoney_master ON Object_InfoMoney_master.Id = tmpAll.InfoMoneyId_master
            LEFT JOIN Object AS Object_InfoMoney_child ON Object_InfoMoney_child.Id = tmpAll.InfoMoneyId_child
            LEFT JOIN Object AS Object_InfoMoney_find ON Object_InfoMoney_find.Id = tmpAll.InfoMoneyId_find

            LEFT JOIN Movement ON Movement.Id = tmpAll.MovementId
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpAll.MovementDescId
            
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

              , Object_InfoMoney_master.Id
              , Object_InfoMoney_find.Id

              , Object_InfoMoney_master.ValueData
              , Object_InfoMoney_child.ValueData
              , Object_InfoMoney_find.ValueData

              , Object_Juridical.Id
              , Object_Juridical.ValueData

              , Object_PaidKind.Id
              , Object_PaidKind.ValueData

              , Object_ContractConditionKind.Id
              , Object_ContractConditionKind.ValueData

              , Object_BonusKind.Id
              , Object_BonusKind.ValueData

              , tmpAll.Value

              , Movement.OperDate
              , Movement.InvNumber 
              , MovementDesc.ItemName
            , Object_Partner.Id  
            , Object_Partner.ValueData 
            , Object_Goods.Id 
            , Object_Goods.ValueData   
            , Object_GoodsKind.Id 
            , Object_GoodsKind.ValueData 
            , Object_Branch.Id
            , Object_Branch.ValueData

      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.19         *
*/
-- тест
--

/*
select * from gpReport_Movement_ProfitLossService (inStartDate:= '31.08.2019', inEndDate:= '31.08.2019', inBranchId:= 0, inAreaId:= 0, inRetailId:= 0, inJuridicalId:= 15616 , inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inIsPartner:= TRUE, inIsGoods:= TRUE, inIsGoodsKind:= TRUE, inSession:= zfCalc_UserAdmin())
where ContractId_master = 3510226 and PartnerId = 18113
order by PartnerName, GoodsName
*/
