-- Function: gpSelect_Object_PromoContract_BonusDetail()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo_BonusDetail (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PromoContract_BonusDetail (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_PromoContract_BonusDetail(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;
    DECLARE Cursor4 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;


   CREATE TEMP TABLE tmpPromoPartner ON COMMIT DROP AS
      (WITH 
       -- все контрагенты Акции
         tmpPromoPartner_all AS (SELECT tmp.PartnerId
                                      , tmp.ContractId
                                 FROM lpSelect_Movement_PromoPartner_Detail (inMovementId:= inMovementId) AS tmp
                                )
         -- все юр.лица Акции + если заполнен договор
        SELECT DISTINCT
               ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
             , tmpPromoPartner_all.ContractId
        FROM tmpPromoPartner_all
             INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = tmpPromoPartner_all.PartnerId
                                  AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
       );


   CREATE TEMP TABLE _tmpContractAll ON COMMIT DROP AS
      (WITH 
         -- список юр.лиц
         tmpJuridical AS (SELECT DISTINCT tmpPromoPartner.JuridicalId FROM tmpPromoPartner)
        -- все договора
       SELECT View_Contract.*
       FROM Object_Contract_View AS View_Contract
       WHERE View_Contract.JuridicalId IN (SELECT tmpJuridical.JuridicalId FROM tmpJuridical)
       );


   CREATE TEMP TABLE tmpContract_res ON COMMIT DROP AS
      (WITH 
        -- все договора - ТОЛЬКО БН
         tmpContract_full AS (SELECT View_Contract.*
                              FROM _tmpContractAll AS View_Contract
                              WHERE View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm()
                             )
          -- все договора
        , tmpContract_all AS (SELECT * FROM tmpContract_full)
          -- все договора - не закрытые, для условий
        , tmpContract_find AS (SELECT View_Contract.*
                               FROM tmpContract_full AS View_Contract
                               WHERE View_Contract.isErased = FALSE
                                 AND (View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                   OR View_Contract.InfoMoneyId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                  , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                   )
                                     )
                              )
         -- список договоров, у которых есть условие по "Бонусам"
       , tmpContractConditionKind AS (SELECT -- условие договора
                                             ObjectLink_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                                           , View_Contract.JuridicalId
                                             -- договор, в котором бонусное условие
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

                                      FROM ObjectLink AS ObjectLink_ContractConditionKind
                                           -- условие договора, не удалено
                                           INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_ContractConditionKind.ObjectId
                                                                                        AND Object_ContractCondition.isErased = FALSE

                                           INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                                 ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                                                                AND ObjectLink_ContractCondition_Contract.DescId   = zc_ObjectLink_ContractCondition_Contract()
                                           -- а это сам договор, в котором бонусное условие
                                           INNER JOIN tmpContract_find AS View_Contract ON View_Contract.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId

                                           -- Значение - %
                                           INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                                  ON ObjectFloat_Value.ObjectId  = Object_ContractCondition.Id
                                                                 AND ObjectFloat_Value.DescId    = zc_ObjectFloat_ContractCondition_Value()
                                                                 AND ObjectFloat_Value.ValueData <> 0

                                           -- !!!прописано - где брать "базу" или маркет-договор начисления!!!
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                                                ON ObjectLink_ContractCondition_ContractSend.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
                                           -- для ContractId_send
                                           LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_send
                                                                ON ObjectLink_Contract_InfoMoney_send.ObjectId = ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                                               AND ObjectLink_Contract_InfoMoney_send.DescId   = zc_ObjectLink_Contract_InfoMoney()

                                      -- только такие уловия
                                      WHERE ObjectLink_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                             , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                              )
                                        AND ObjectLink_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                     )
      -- для всех юр лиц, у кого есть "Бонусы" формируется список всех других договоров (по ним будем делать расчет "базы")
       , tmpContract AS (SELECT tmpContractConditionKind.JuridicalId
                              , tmpContractConditionKind.ContractId_master
                              , tmpContractConditionKind.ContractId_master AS ContractId_child
                         FROM tmpContractConditionKind
                         -- это будут не бонусные договора (но в них есть бонусы)
                         WHERE tmpContractConditionKind.InfoMoneyId_master = tmpContractConditionKind.InfoMoneyId_child
   
                        UNION ALL
                         SELECT tmpContractConditionKind.JuridicalId
                              , tmpContractConditionKind.ContractId_master
                              , View_Contract_child.ContractId             AS ContractId_child
                         FROM tmpContractConditionKind
                              LEFT JOIN tmpContract_full AS View_Contract_child ON View_Contract_child.ContractId = tmpContractConditionKind.ContractId_baza
                         WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child
                           -- в бонусном договоре точно указано где взять базу
                           AND tmpContractConditionKind.ContractId_baza > 0
   
                        UNION ALL
                         SELECT tmpContractConditionKind.JuridicalId
                              , tmpContractConditionKind.ContractId_master
                              , View_Contract_child.ContractId             AS ContractId_child
                         FROM tmpContractConditionKind
                              INNER JOIN tmpContract_full AS View_Contract_child
                                                          ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                                         AND View_Contract_child.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child
                         -- это будут бонусные договора
                         WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child
                           -- НЕ указано где взять базу
                           AND tmpContractConditionKind.ContractId_baza = 0
                        )
      -- группируем договора
       , tmpContractGroup AS (SELECT DISTINCT
                                     tmpContract.ContractId_master
                                   , tmpContract.ContractId_child
                              FROM tmpContract
                                   -- если был установлен Договор
                                   INNER JOIN tmpPromoPartner ON tmpPromoPartner.ContractId = tmpContract.ContractId_child
                             UNION
                              SELECT DISTINCT
                                     tmpContract.ContractId_master
                                   , tmpContract.ContractId_child
                              FROM tmpContract
                                   -- все Юр Лица, если НЕ был установлен Договор
                                   INNER JOIN tmpPromoPartner ON tmpPromoPartner.JuridicalId = tmpContract.JuridicalId
                                                             AND tmpPromoPartner.ContractId  = 0
                             )
       -- список договоров
       , tmpContractList AS (SELECT DISTINCT
                                    tmpContractGroup.ContractId_master AS ContractId
                             FROM tmpContractGroup
                            UNION
                             SELECT DISTINCT
                                    tmpContractGroup.ContractId_child  AS ContractId
                             FROM tmpContractGroup
                            )
       , tmpMI AS (SELECT MovementItem.*
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId     = zc_MI_Master()
                     AND MovementItem.isErased   = FALSE
                  )
         -- Товары в договорах(Спецификация)
       , tmpContractGoods AS (SELECT DISTINCT
                                     tmpContractList.ContractId
                              FROM tmpContractList
                                   INNER JOIN ObjectLink AS ObjectLink_ContractGoods_Contract
                                                         ON ObjectLink_ContractGoods_Contract.ChildObjectId = tmpContractList.ContractId
                                                        AND ObjectLink_ContractGoods_Contract.DescId        = zc_ObjectLink_ContractGoods_Contract()
                                   INNER JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                                         ON ObjectLink_ContractGoods_Goods.ObjectId = ObjectLink_ContractGoods_Contract.ObjectId
                                                        AND ObjectLink_ContractGoods_Goods.DescId   = zc_ObjectLink_ContractGoods_Goods()
                                   INNER JOIN tmpMI ON tmpMI.ObjectId = ObjectLink_ContractGoods_Goods.ChildObjectId
                             )
       
       SELECT DISTINCT
             tmpContractGroup.ContractId_master
           , tmpContractGroup.ContractId_child
       FROM tmpContractGroup
            INNER JOIN tmpContractGoods ON (tmpContractGoods.ContractId = tmpContractGroup.ContractId_master
                                        OR tmpContractGoods.ContractId = tmpContractGroup.ContractId_child)
       );



    --1)ContractId_master - договора с маркет условиями
    OPEN Cursor1 FOR
       SELECT tmpContract_res.ContractId_master AS Id
            , tmpContract_res.ContractId_master AS ContractId
            , tmpContract.ContractCode  
            , tmpContract.InvNumber
            , tmpContract.isErased
            , tmpContract.StartDate
            , tmpContract.EndDate
      
            , Object_Juridical.Id             AS JuridicalId
            , Object_Juridical.ObjectCode     AS JuridicalCode
            , Object_Juridical.ValueData      AS JuridicalName
            , Object_JuridicalGroup.ValueData AS JuridicalGroupName
            , Object_Retail.Id                AS RetailId
            , Object_Retail.ValueData         AS RetailName
       
            , Object_JuridicalBasis.Id           AS JuridicalBasisId
            , Object_JuridicalBasis.ValueData    AS JuridicalBasisName
       
            , Object_PaidKind.Id        AS PaidKindId
            , Object_PaidKind.ValueData AS PaidKindName

            , Object_InfoMoney.Id         AS InfoMoneyId
            , Object_InfoMoney.ObjectCode AS InfoMoneyCode
            , Object_InfoMoney.ValueData  AS InfoMoneyName
     
            , tmpContract.ContractStateKindId
            , tmpContract.ContractStateKindCode
            , tmpContract.ContractStateKindName
     
            , tmpContract.ContractTagGroupId
            , tmpContract.ContractTagGroupCode
            , tmpContract.ContractTagGroupName
     
            , tmpContract.ContractTagId
            , tmpContract.ContractTagCode
            , tmpContract.ContractTagName
     
            , tmpContract.ContractKindId
            , tmpContract.ContractKindCode
            , tmpContract.ContractKindName
       FROM tmpContract_res
            LEFT JOIN _tmpContractAll AS tmpContract ON tmpContract.ContractId = tmpContract_res.ContractId_master
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpContract.PaidKindId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpContract.InfoMoneyId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpContract.JuridicalId
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = tmpContract.JuridicalBasisId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = tmpContract.JuridicalId
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = tmpContract.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
      ;
    RETURN NEXT Cursor1;

    -- 2) условия по договорам ContractId_master
    OPEN Cursor2 FOR
     SELECT 
           Object_ContractCondition.Id          AS Id
         , ObjectFloat_Value.ValueData          AS Value  
         , COALESCE (ObjectFloat_PercentRetBonus.ValueData,0) :: TFloat AS PercentRetBonus

         ,ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId

         , Object_ContractConditionKind.Id          AS ContractConditionKindId
         , Object_ContractConditionKind.ValueData   AS ContractConditionKindName

         , Object_BonusKind.Id                  AS BonusKindId
         , Object_BonusKind.ValueData           AS BonusKindName

         , Object_InfoMoney.Id                  AS InfoMoneyId
         , Object_InfoMoney.ValueData           AS InfoMoneyName
         
         , Object_PaidKind.Id                   AS PaidKindId
         , Object_PaidKind.ValueData            AS PaidKindName
        
         , Object_ContractSend.Id               AS ContractSendId
         , Object_ContractSend.ValueData        AS ContractSendName

         , Object_ContractSendStateKind.ObjectCode  AS ContractStateKindCode_Send
         , Object_ContractSendTag.ValueData         AS ContractTagName_Send
         , Object_InfoMoneySend.ObjectCode      AS InfoMoneyCode_Send
         , Object_InfoMoneySend.ValueData       AS InfoMoneyName_Send 
    
         , Object_JuridicalSend.ObjectCode      AS JuridicalCode_Send
         , Object_JuridicalSend.ValueData       AS JuridicalName_Send
         
         , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())  :: TDateTime AS StartDate
         , COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())      :: TDateTime AS EndDate

         , Object_ContractCondition.ValueData   AS Comment
         
        
     FROM Object AS Object_ContractCondition
     
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                               ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
          INNER JOIN tmpContract_res ON tmpContract_res.ContractId_master = ObjectLink_ContractCondition_Contract.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                               ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
          LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
  
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                               ON ObjectLink_ContractCondition_BonusKind.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
          LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = ObjectLink_ContractCondition_BonusKind.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                               ON ObjectLink_ContractCondition_InfoMoney.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_InfoMoney.DescId = zc_ObjectLink_ContractCondition_InfoMoney()
          LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_ContractCondition_InfoMoney.ChildObjectId
           
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                               ON ObjectLink_ContractCondition_ContractSend.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
          LEFT JOIN Object AS Object_ContractSend ON Object_ContractSend.Id = ObjectLink_ContractCondition_ContractSend.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractSend_Juridical
                               ON ObjectLink_ContractSend_Juridical.ObjectId = Object_ContractSend.Id 
                              AND ObjectLink_ContractSend_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
          LEFT JOIN Object AS Object_JuridicalSend ON Object_JuridicalSend.Id = ObjectLink_ContractSend_Juridical.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractSend_ContractTag
                               ON ObjectLink_ContractSend_ContractTag.ObjectId = Object_ContractSend.Id
                              AND ObjectLink_ContractSend_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
          LEFT JOIN Object AS Object_ContractSendTag ON Object_ContractSendTag.Id = ObjectLink_ContractSend_ContractTag.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractSend_ContractStateKind
                               ON ObjectLink_ContractSend_ContractStateKind.ObjectId = Object_ContractSend.Id
                              AND ObjectLink_ContractSend_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind() 
          LEFT JOIN Object AS Object_ContractSendStateKind ON Object_ContractSendStateKind.Id = ObjectLink_ContractSend_ContractStateKind.ChildObjectId


          LEFT JOIN ObjectLink AS ObjectLink_ContractSend_InfoMoney
                               ON ObjectLink_ContractSend_InfoMoney.ObjectId = Object_ContractSend.Id
                              AND ObjectLink_ContractSend_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
          LEFT JOIN Object AS Object_InfoMoneySend ON Object_InfoMoneySend.Id = ObjectLink_ContractSend_InfoMoney.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                               ON ObjectLink_ContractCondition_PaidKind.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_PaidKind.DescId = zc_ObjectLink_ContractCondition_PaidKind()
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_ContractCondition_PaidKind.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                ON ObjectFloat_Value.ObjectId = Object_ContractCondition.Id 
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()

          LEFT JOIN ObjectFloat AS ObjectFloat_PercentRetBonus 
                                ON ObjectFloat_PercentRetBonus.ObjectId = Object_ContractCondition.Id 
                               AND ObjectFloat_PercentRetBonus.DescId = zc_ObjectFloat_ContractCondition_PercentRetBonus()

          LEFT JOIN ObjectDate AS ObjectDate_StartDate
                               ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractCondition_StartDate()
          LEFT JOIN ObjectDate AS ObjectDate_EndDate
                               ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractCondition_EndDate()

     WHERE Object_ContractCondition.DescId = zc_Object_ContractCondition()
       AND Object_ContractCondition.isErased = FALSE

      ;

    RETURN NEXT Cursor2;
    -- 3)ContractId_child - договора с товарами 
    OPEN Cursor3 FOR
       SELECT tmpContract_res.ContractId_master
            , tmpContract_res.ContractId_child AS ContractId
            , tmpContract.ContractCode  
            , tmpContract.InvNumber
            , tmpContract.isErased
            , tmpContract.StartDate
            , tmpContract.EndDate
      
            , Object_Juridical.Id             AS JuridicalId
            , Object_Juridical.ObjectCode     AS JuridicalCode
            , Object_Juridical.ValueData      AS JuridicalName
            , Object_JuridicalGroup.ValueData AS JuridicalGroupName
            , Object_Retail.Id                AS RetailId
            , Object_Retail.ValueData         AS RetailName
       
            , Object_JuridicalBasis.Id           AS JuridicalBasisId
            , Object_JuridicalBasis.ValueData    AS JuridicalBasisName
       
            , Object_PaidKind.Id        AS PaidKindId
            , Object_PaidKind.ValueData AS PaidKindName

            , Object_InfoMoney.Id         AS InfoMoneyId
            , Object_InfoMoney.ObjectCode AS InfoMoneyCode
            , Object_InfoMoney.ValueData  AS InfoMoneyName
     
            , tmpContract.ContractStateKindId
            , tmpContract.ContractStateKindCode
            , tmpContract.ContractStateKindName
     
            , tmpContract.ContractTagGroupId
            , tmpContract.ContractTagGroupCode
            , tmpContract.ContractTagGroupName
     
            , tmpContract.ContractTagId
            , tmpContract.ContractTagCode
            , tmpContract.ContractTagName
     
            , tmpContract.ContractKindId
            , tmpContract.ContractKindCode
            , tmpContract.ContractKindName
       FROM tmpContract_res
            LEFT JOIN _tmpContractAll AS tmpContract ON tmpContract.ContractId = tmpContract_res.ContractId_child
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpContract.PaidKindId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpContract.InfoMoneyId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpContract.JuridicalId
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = tmpContract.JuridicalBasisId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = tmpContract.JuridicalId
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = tmpContract.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
      ;

    RETURN NEXT Cursor3;
 
   --4) zc_Object_ContractGoods - Товары в договорах(Спецификация)
    OPEN Cursor4 FOR
     WITH
     tmpContractGoods AS (SELECT Object_ContractGoods.*
                               , ContractGoods_Contract.ChildObjectId             AS ContractId
                               , ObjectLink_Contract_PriceList.ChildObjectId      AS PriceListId
                               , ObjectLink_Contract_PriceListGoods.ChildObjectId AS PriceListGoodsId
                               , ObjectLink_Contract_GoodsProperty.ChildObjectId  AS GoodsPropertyId
                               , ObjectLink_ContractGoods_Goods.ChildObjectId     AS GoodsId
                               , ObjectLink_ContractGoods_GoodsKind.ChildObjectId AS GoodsKindId
                               , ObjectDate_Start.ValueData          ::TDateTime  AS StartDate
                               , ObjectDate_End.ValueData            ::TDateTime  AS EndDate
                               , ObjectFloat_Price.ValueData                      AS Price
                               , MAX (ObjectDate_End.ValueData) OVER (PARTITION BY ContractGoods_Contract.ChildObjectId, ObjectLink_Contract_PriceList.ChildObjectId, ObjectLink_ContractGoods_Goods.ChildObjectId, ObjectLink_ContractGoods_GoodsKind.ChildObjectId) AS EndDate_last
                          FROM Object AS Object_ContractGoods
                               LEFT JOIN ObjectLink AS ContractGoods_Contract
                                                    ON ContractGoods_Contract.ObjectId = Object_ContractGoods.Id
                                                   AND ContractGoods_Contract.DescId = zc_ObjectLink_ContractGoods_Contract()
                               INNER JOIN tmpContract_res ON tmpContract_res.ContractId_child = ContractGoods_Contract.ChildObjectId

                               INNER JOIN ObjectLink AS ObjectLink_Contract_PriceListGoods
                                                     ON ObjectLink_Contract_PriceListGoods.ObjectId = ContractGoods_Contract.ChildObjectId
                                                    AND ObjectLink_Contract_PriceListGoods.DescId = zc_ObjectLink_Contract_PriceListGoods()
                                                    --AND (ObjectLink_Contract_PriceListGoods.ChildObjectId = inPriceListId OR inPriceListId = 0)
                               INNER JOIN ObjectLink AS ObjectLink_Contract_GoodsProperty
                                                     ON ObjectLink_Contract_GoodsProperty.ObjectId = ContractGoods_Contract.ChildObjectId
                                                    AND ObjectLink_Contract_GoodsProperty.DescId = zc_ObjectLink_Contract_GoodsProperty()
                                                    --AND (ObjectLink_Contract_GoodsProperty.ChildObjectId = inGoodsPropertyId OR inGoodsPropertyId = 0)

                               LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                                    ON ObjectLink_Contract_PriceList.ObjectId = ContractGoods_Contract.ChildObjectId
                                                   AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
            
                               LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                                    ON ObjectLink_ContractGoods_Goods.ObjectId = Object_ContractGoods.Id
                                                   AND ObjectLink_ContractGoods_Goods.DescId = zc_ObjectLink_ContractGoods_Goods()

                               LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_GoodsKind
                                                    ON ObjectLink_ContractGoods_GoodsKind.ObjectId = Object_ContractGoods.Id
                                                   AND ObjectLink_ContractGoods_GoodsKind.DescId = zc_ObjectLink_ContractGoods_GoodsKind()

                               LEFT JOIN ObjectDate AS ObjectDate_Start
                                                    ON ObjectDate_Start.ObjectId = Object_ContractGoods.Id
                                                   AND ObjectDate_Start.DescId = zc_ObjectDate_ContractGoods_Start()
                               LEFT JOIN ObjectDate AS ObjectDate_End
                                                    ON ObjectDate_End.ObjectId = Object_ContractGoods.Id
                                                   AND ObjectDate_End.DescId = zc_ObjectDate_ContractGoods_End()

                               LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                                     ON ObjectFloat_Price.ObjectId = Object_ContractGoods.Id 
                                                    AND ObjectFloat_Price.DescId = zc_ObjectFloat_ContractGoods_Price() 
                          WHERE Object_ContractGoods.DescId = zc_Object_ContractGoods()
                            AND (Object_ContractGoods.isErased = FALSE )
                         )
       --
       SELECT
             Object_ContractGoods.Id          AS Id
           , Object_ContractGoods.ObjectCode  AS Code
           , Object_ContractGoods.Price         AS Price
           , CAST ( ((Object_ContractGoods.Price - tmp.Price) / 100) * tmp.Price AS NUMERIC (16,2)) ::TFloat AS Persent
         
           , Object_Contract_View.ContractId    AS ContractId
           , Object_Contract_View.ContractCode  AS ContractCode
           , Object_Contract_View.InvNumber     AS InvNumber

           , Object_PriceList.Id                AS PriceListId 
           , Object_PriceList.ValueData         AS PriceListName
           , Object_PriceListGoods.Id           AS PriceListGoodsId 
           , Object_PriceListGoods.ValueData    AS PriceListGoodsName
           , Object_GoodsProperty.Id            AS GoodsPropertyId
           , Object_GoodsProperty.ValueData     AS GoodsPropertyName

           , Object_GoodsGroup.Id        AS GoodsGroupId
           , Object_GoodsGroup.ValueData AS GoodsGroupName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.Id               AS MeasureId
           , Object_Measure.ValueData        AS MeasureName

           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , Object_GoodsKind.Id              AS GoodsKindId
           , Object_GoodsKind.ValueData       AS GoodsKindName
           , Object_TradeMark.Id              AS TradeMarkId
           , Object_TradeMark.ValueData       AS TradeMarkName
           
           , Object_ContractGoods.StartDate ::TDateTime  AS StartDate
           , Object_ContractGoods.EndDate   ::TDateTime  AS EndDate
       
           , Object_ContractGoods.isErased    AS isErased


           , ObjectString_InvNumberArchive.ValueData   AS InvNumberArchive

           , View_Contract_InvNumber_Key.ContractKeyId
           , View_Contract_InvNumber_Key.ContractId_Key        AS ContractId_Key
           , View_Contract_InvNumber_Key.ContractCode          AS Code_Key
           , View_Contract_InvNumber_Key.InvNumber             AS InvNumber_Key
           , View_Contract_InvNumber_Key.ContractStateKindCode AS ContractStateKindCode_Key

           , ObjectString_Comment.ValueData            AS Comment 
           , ObjectString_BankAccount.ValueData        AS BankAccountExternal
           , ObjectString_GLNCode.ValueData            AS GLNCode 

           , ObjectDate_Signing.ValueData     AS SigningDate
           , Object_Contract_View.StartDate   AS StartDate_contract
           , Object_Contract_View.EndDate     AS EndDate_contract
       
           , Object_ContractKind.Id          AS ContractKindId
           , Object_ContractKind.ValueData   AS ContractKindName
           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ObjectCode     AS JuridicalCode
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_JuridicalGroup.ValueData AS JuridicalGroupName

           , Object_JuridicalBasis.Id           AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData    AS JuridicalBasisName

           , Object_JuridicalDocument.Id             AS JuridicalDocumentId
           , Object_JuridicalDocument.ObjectCode     AS JuridicalDocumentCode
           , Object_JuridicalDocument.ValueData      AS JuridicalDocumentName

           , Object_PaidKind.Id            AS PaidKindId
           , Object_PaidKind.ValueData     AS PaidKindName

           , Object_InfoMoney_View.InfoMoneyGroupCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationCode
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName

           , Object_Personal_View.PersonalId    AS PersonalId
           , Object_Personal_View.PersonalCode  AS PersonalCode
           , Object_Personal_View.PersonalName  AS PersonalName
           
           , Object_PersonalTrade.PersonalId    AS PersonalTradeId
           , Object_PersonalTrade.PersonalCode  AS PersonalTradeCode
           , Object_PersonalTrade.PersonalName  AS PersonalTradeName
    
           , Object_PersonalCollation.PersonalId    AS PersonalCollationId
           , Object_PersonalCollation.PersonalCode  AS PersonalCollationCode
           , Object_PersonalCollation.PersonalName  AS PersonalCollationName
    
           , Object_BankAccount.Id              AS BankAccountId
           , Object_BankAccount.ValueData       AS BankAccountName
    
           , Object_Contract_View.ContractTagId
           , Object_Contract_View.ContractTagName
           , Object_Contract_View.ContractTagGroupName
    
           , Object_AreaContract.Id             AS AreaContractId
           , Object_AreaContract.ValueData      AS AreaContractName
    
           , Object_ContractArticle.Id          AS ContractArticleId
           , Object_ContractArticle.ValueData   AS ContractArticleName
    
           , Object_Contract_View.ContractStateKindId
           , Object_Contract_View.ContractStateKindCode
    
           , ObjectHistory_JuridicalDetails_View.OKPO
    
           , Object_Bank.Id          AS BankId
           , Object_Bank.ValueData   AS BankName
    
           , Object_Insert.ValueData   AS InsertName
           , Object_Update.ValueData   AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate
           
           , COALESCE (ObjectBoolean_Default.ValueData, False)      AS isDefault
           , COALESCE (ObjectBoolean_DefaultOut.ValueData, False)   AS isDefaultOut
           , COALESCE (ObjectBoolean_Standart.ValueData, False)     AS isStandart
    
           , COALESCE (ObjectBoolean_Personal.ValueData, False) AS isPersonal
           , COALESCE (ObjectBoolean_Unique.ValueData, False)   AS isUnique
           
           , ObjectFloat_DocumentCount.ValueData AS DocumentCount
           , ObjectDate_Document.ValueData AS DateDocument

    FROM tmpContractGoods AS Object_ContractGoods

            LEFT JOIN _tmpContractAll AS Object_Contract_View ON Object_Contract_View.ContractId = Object_ContractGoods.ContractId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Object_ContractGoods.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Object_ContractGoods.GoodsKindId
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = Object_ContractGoods.PriceListId
            LEFT JOIN Object AS Object_PriceListGoods ON Object_PriceListGoods.Id = Object_ContractGoods.PriceListGoodsId
            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = Object_ContractGoods.GoodsPropertyId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND Object_Contract_View.InvNumber <> '-'
            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                                 ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
            LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId
    
            LEFT JOIN ObjectFloat AS ObjectFloat_DocumentCount
                                  ON ObjectFloat_DocumentCount.ObjectId = Object_Contract_View.ContractId
                                 AND ObjectFloat_DocumentCount.DescId = zc_ObjectFloat_Contract_DocumentCount()
            LEFT JOIN ObjectDate AS ObjectDate_Document
                                 ON ObjectDate_Document.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Document.DescId = zc_ObjectDate_Contract_Document()
    
            LEFT JOIN ObjectString AS ObjectString_InvNumberArchive
                                   ON ObjectString_InvNumberArchive.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectString_InvNumberArchive.DescId = zc_objectString_Contract_InvNumberArchive()
    
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()
    
            LEFT JOIN ObjectString AS ObjectString_BankAccount
                                   ON ObjectString_BankAccount.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectString_BankAccount.DescId = zc_objectString_Contract_BankAccount()
                                  
            LEFT JOIN ObjectString AS ObjectString_GLNCode
                                   ON ObjectString_GLNCode.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectString_GLNCode.DescId = zc_objectString_Contract_GLNCode()
    
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                                    ON ObjectBoolean_Default.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_Contract_Default()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_DefaultOut
                                    ON ObjectBoolean_DefaultOut.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_DefaultOut.DescId = zc_ObjectBoolean_Contract_DefaultOut()
    
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Standart
                                    ON ObjectBoolean_Standart.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_Standart.DescId = zc_ObjectBoolean_Contract_Standart()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal
                                    ON ObjectBoolean_Personal.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_Personal.DescId = zc_ObjectBoolean_Contract_Personal()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Unique
                                    ON ObjectBoolean_Unique.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_Unique.DescId = zc_ObjectBoolean_Contract_Unique()
            
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId
            
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                 ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Contract_View.JuridicalId
                                AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId
    
            LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                 ON ObjectLink_Contract_Personal.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
            LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId               
    
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                 ON ObjectLink_Contract_PersonalTrade.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
            LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Contract_PersonalTrade.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                 ON ObjectLink_Contract_PersonalCollation.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
            LEFT JOIN Object_Personal_View AS Object_PersonalCollation ON Object_PersonalCollation.PersonalId = ObjectLink_Contract_PersonalCollation.ChildObjectId        
            
            LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                 ON ObjectLink_Contract_BankAccount.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()
            LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Contract_BankAccount.ChildObjectId
                    
            LEFT JOIN ObjectLink AS ObjectLink_Contract_AreaContract
                                 ON ObjectLink_Contract_AreaContract.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_AreaContract.DescId = zc_ObjectLink_Contract_AreaContract()
            LEFT JOIN Object AS Object_AreaContract ON Object_AreaContract.Id = ObjectLink_Contract_AreaContract.ChildObjectId                     
                
            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractArticle
                                 ON ObjectLink_Contract_ContractArticle.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_ContractArticle.DescId = zc_ObjectLink_Contract_ContractArticle()
            LEFT JOIN Object AS Object_ContractArticle ON Object_ContractArticle.Id = ObjectLink_Contract_ContractArticle.ChildObjectId                               
          
            LEFT JOIN ObjectLink AS ObjectLink_Contract_Bank
                                 ON ObjectLink_Contract_Bank.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_Bank.DescId = zc_ObjectLink_Contract_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Contract_Bank.ChildObjectId   
    
            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                                 ON ObjectDate_Protocol_Insert.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                 ON ObjectDate_Protocol_Update.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
    
            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   
    
            LEFT JOIN ObjectLink AS ObjectLink_Update
                                 ON ObjectLink_Update.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId   

            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                 ON ObjectLink_Contract_JuridicalDocument.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
            LEFT JOIN Object AS Object_JuridicalDocument ON Object_JuridicalDocument.Id = ObjectLink_Contract_JuridicalDocument.ChildObjectId

            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
            LEFT JOIN Object_Contract_InvNumber_Key_View AS View_Contract_InvNumber_Key ON View_Contract_InvNumber_Key.ContractId = Object_Contract_View.ContractId

            LEFT JOIN tmpContractGoods AS tmp
                                       ON tmp.ContractId = Object_ContractGoods.ContractId
                                      AND tmp.PriceListId = Object_ContractGoods.PriceListId
                                      AND tmp.GoodsId = Object_ContractGoods.GoodsId
                                      AND COALESCE (tmp.GoodsKindId,0) = COALESCE (Object_ContractGoods.GoodsKindId,0)
                                      AND tmp.EndDate + interval '1 day' = Object_ContractGoods.StartDate
   /* WHERE (inisShowAll = FALSE AND Object_ContractGoods.EndDate = Object_ContractGoods.EndDate_last)
       OR (inisShowAll = TRUE)
       */
      ;

    RETURN NEXT Cursor4;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.21         *
*/

-- SELECT * FROM gpSelect_Object_PromoContract_BonusDetail (inMovementId := 17484511, inSession:= '5');