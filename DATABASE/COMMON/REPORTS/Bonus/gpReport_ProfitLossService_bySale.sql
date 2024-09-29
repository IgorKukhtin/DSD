-- Function: gpReport_ProfitLossService_bySale ()

DROP FUNCTION IF EXISTS gpReport_ProfitLossService_bySale (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ProfitLossService_bySale (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLossService_bySale (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalId       Integer   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar
             , RetailId Integer, RetailName TVarChar
               -- юр.л. - условие
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
               -- юр.л. - база
             , JuridicalId_baza Integer, JuridicalCode_baza Integer, JuridicalName_baza TVarChar
             , PartnerId_baza Integer, PartnerName_baza TVarChar
               -- договор (база)
             , ContractChildCode Integer, ContractChildName TVarChar
               -- договор (начисление)
             , ContractCode Integer, ContractName TVarChar
               -- договор (условие)
             , ContractCode_Master Integer, ContractName_Master TVarChar
               -- Типы условий договоров
             , ContractConditionKindName TVarChar
               -- Виды бонусов
             , BonusKindName TVarChar
               --
             , PersonalName TVarChar, PersonalTradeName TVarChar
             , PaidKindName TVarChar, PaidKindName_Child TVarChar
             , InfoMoneyName TVarChar, InfoMoneyName_Child TVarChar

             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , MeasureName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar

             , AmountIn TFloat, AmountOut TFloat, Amount TFloat
             , Sale_Summ TFloat
             , Return_Summ Tfloat
             , SummAmount  Tfloat
             , AmountIn_calc  Tfloat
             , AmountOut_calc  Tfloat
             , Amount_calc     Tfloat
             , Persent TFloat
             , Amount_501 TFloat
             , Amount_502 TFloat
             , Amount_503 TFloat
             , Amount_512 TFloat
             , Amount_601 TFloat
             , Amount_504 TFloat
             )

AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE inIsGroup Boolean;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);
     
     inIsGroup:= TRUE;

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
      WITH
      -- Документ - затраты
      tmpMovementFull AS (SELECT Movement.*
                          FROM Movement
                               LEFT JOIN MovementLinkMovement AS MLM_Doc
                                                              ON MLM_Doc.MovementId = Movement.Id
                                                             AND MLM_Doc.DescId = zc_MovementLinkMovement_Doc()

                               LEFT JOIN MovementLinkObject AS MLO_TradeMark
                                                            ON MLO_TradeMark.MovementId = Movement.Id
                                                           AND MLO_TradeMark.DescId = zc_MovementLinkObject_TradeMark()
                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.DescId = zc_Movement_ProfitLossService()
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND COALESCE (MLM_Doc.MovementChildId, 0) = 0
                            AND COALESCE (MLO_TradeMark.ObjectId, 0) = 0
                         )

      -- сумма начислений - затраты
    , tmpMI AS (SELECT MovementItem.MovementId
                     , MovementItem.Id
                       --
                     , MovementItem.ObjectId
                       -- Юридические лица, Контрагент
                     , CASE WHEN MovementItem.Amount > 0
                                 THEN 0 -- MovementItem.Amount
                            ELSE 0
                       END::TFloat                                    AS AmountIn
                     , CASE WHEN 1=1 -- MovementItem.Amount < 0
                                 THEN -1 * MovementItem.Amount
                            ELSE 0
                       END::TFloat                                    AS AmountOut
                     , -1 * MovementItem.Amount                       AS Amount
                FROM MovementItem
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementFull.Id FROM tmpMovementFull)
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
                  AND COALESCE (MovementItem.Amount,0) <> 0
                )

      -- Затраты
    , tmpMovement AS (SELECT Movement.Id              AS MovementId
                           , Movement.DescId          AS MovementDescId
                           , Movement.OperDate
                           , Movement.InvNumber
                             --
                           , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId, 0) AS JuridicalId
                             --
                           , CASE WHEN Object_Partner.DescId = zc_Object_Partner() THEN MovementItem.ObjectId ELSE 0 END AS PartnerId
                             -- Договор (начисление)
                           , MILinkObject_Contract.ObjectId        AS ContractId
                             -- Договор (база)
                           , MILinkObject_ContractChild.ObjectId   AS ContractChildId
                             -- Договор (условие)
                           , MILinkObject_ContractMaster.ObjectId  AS ContractMasterId

                             -- % бонуса
                           , COALESCE (MIFloat_BonusValue.ValueData, 0)    AS BonusValue
                             -- Типы условий договоров
                           , MILinkObject_ContractConditionKind.ObjectId   AS ContractConditionKindId
                             -- Виды бонусов
                           , COALESCE (MILinkObject_BonusKind.ObjectId, 0) AS BonusKindId

                             --
                           , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
                           , MILinkObject_PaidKind.ObjectId  AS PaidKindId
                             --
                           , MovementItem.AmountIn
                           , MovementItem.AmountOut
                           , MovementItem.Amount

                      FROM tmpMovementFull AS Movement
                          INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId

                          -- Договор (начисление)
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                           ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Contract.DescId         = zc_MILinkObject_Contract()
                          -- Договор(база)
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                           ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ContractChild.DescId         = zc_MILinkObject_ContractChild()
                          -- Договор(условия)
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractMaster
                                                           ON MILinkObject_ContractMaster.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ContractMaster.DescId         = zc_MILinkObject_ContractMaster()

                          -- форма оплаты
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                           ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()

                          -- Виды бонусов
                          LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                                      ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                                     AND MIFloat_BonusValue.DescId         = zc_MIFloat_BonusValue()
                          -- Виды бонусов
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                                           ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_BonusKind.DescId         = zc_MILinkObject_BonusKind()
                          -- Типы условий договоров
                          INNER JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                            ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
                                                           AND MILinkObject_ContractConditionKind.ObjectId IN (zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSalePart()
                                                                                                              )

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()


                      WHERE (COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId, 0) = inJuridicalId OR inJuridicalId = 0)
-- and Movement.Id = 29240028  
 and Movement.Id = 29240044 
                     )
      -- Договор (условие) - ограничение по котрагенту - ВСЕ условия
    , tmpContractMaster_all  AS (SELECT DISTINCT tmpMovement.ContractChildId, tmpMovement.ContractMasterId
                                 FROM tmpMovement
                                )
    , tmpContractMaster_all_partner AS (SELECT DISTINCT
                                               tmpContractMaster.ContractChildId
                                             , tmpContractMaster.ContractMasterId
                                               -- нашли подключенного контрагента
                                             , ObjectLink_ContractPartner_Partner.ChildObjectId AS PartnerId
                                        FROM tmpContractMaster_all AS tmpContractMaster
                                             INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                                   ON ObjectLink_ContractPartner_Contract.ChildObjectId = tmpContractMaster.ContractMasterId
                                                                  AND ObjectLink_ContractPartner_Contract.DescId   = zc_ObjectLink_ContractPartner_Contract()
                                             INNER JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id       = ObjectLink_ContractPartner_Contract.ObjectId
                                                                                        -- контрагент подключен к договору
                                                                                        AND Object_ContractPartner.isErased = FALSE
                                             -- нашли подключенного контрагента
                                             INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                                   ON ObjectLink_ContractPartner_Partner.ObjectId      = Object_ContractPartner.Id
                                                                  AND ObjectLink_ContractPartner_Partner.DescId        = zc_ObjectLink_ContractPartner_Partner()
                                                                  AND ObjectLink_ContractPartner_Partner.ChildObjectId > 0

                                       )
      -- Договор (условие) - ограничение по котрагенту - ОДНО условие
    , tmpContractMaster  AS (SELECT DISTINCT tmpMovement.ContractChildId, tmpMovement.ContractMasterId, tmpMovement.ContractConditionKindId, tmpMovement.BonusKindId, tmpMovement.BonusValue
                             FROM tmpMovement
                             --WHERE tmpMovement.BonusValue > 0
                            )
    , tmpContractMaster_partner AS (SELECT DISTINCT
                                           tmpContractMaster.ContractChildId
                                         , tmpContractMaster.ContractMasterId
                                           --
                                         , tmpContractMaster.ContractConditionKindId
                                         , tmpContractMaster.BonusKindId
                                         , tmpContractMaster.BonusValue
                                           -- нашли подключенного контрагента
                                         , ObjectLink_ContractConditionPartner_Partner.ChildObjectId AS PartnerId
                                    FROM tmpContractMaster
                                             -- Условия договора
                                             INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                                   ON ObjectLink_ContractCondition_Contract.ChildObjectId = tmpContractMaster.ContractMasterId
                                                                  AND ObjectLink_ContractCondition_Contract.DescId        = zc_ObjectLink_ContractCondition_Contract()
                                             INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_ContractCondition_Contract.ObjectId
                                                                                          -- условие не удалено
                                                                                          AND Object_ContractCondition.isErased = FALSE

                                             -- Типы условий договоров
                                             LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                                  ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = Object_ContractCondition.Id
                                                                 AND ObjectLink_ContractCondition_ContractConditionKind.DescId   = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                             -- Виды бонусов
                                             LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                                  ON ObjectLink_ContractCondition_BonusKind.ObjectId = Object_ContractCondition.Id
                                                                 AND ObjectLink_ContractCondition_BonusKind.DescId   = zc_ObjectLink_ContractCondition_BonusKind()
                                             -- % бонуса
                                             LEFT JOIN ObjectFloat AS ObjectFloat_ContractCondition_Value
                                                                   ON ObjectFloat_ContractCondition_Value.ObjectId = Object_ContractCondition.Id
                                                                  AND ObjectFloat_ContractCondition_Value.DescId   = zc_ObjectFloat_ContractCondition_Value()


                                             INNER JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                                                   ON ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId = Object_ContractCondition.Id
                                                                  AND ObjectLink_ContractConditionPartner_ContractCondition.DescId        = zc_ObjectLink_ContractConditionPartner_ContractCondition()


                                             INNER JOIN Object AS Object_ContractConditionPartner ON Object_ContractConditionPartner.Id       = ObjectLink_ContractConditionPartner_ContractCondition.ObjectId
                                                                                                 -- контрагент подключен к условие договора
                                                                                                 AND Object_ContractConditionPartner.isErased = FALSE
                                             -- нашли подключенного контрагента
                                             INNER JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                                                   ON ObjectLink_ContractConditionPartner_Partner.ObjectId      = Object_ContractConditionPartner.Id
                                                                  AND ObjectLink_ContractConditionPartner_Partner.DescId        = zc_ObjectLink_ContractConditionPartner_Partner()
                                                                  AND ObjectLink_ContractConditionPartner_Partner.ChildObjectId > 0
                                    -- Виды бонусов
                                    WHERE  COALESCE (ObjectLink_ContractCondition_BonusKind.ChildObjectId, 0) = tmpContractMaster.BonusKindId
                                       -- Типы условий договоров
                                       AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId   = tmpContractMaster.ContractConditionKindId
                                       -- % бонуса
                                       AND  ObjectFloat_ContractCondition_Value.ValueData                     = tmpContractMaster.BonusValue
                                   )
      -- продажи
    , tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                           , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                      FROM Constant_ProfitLoss_AnalyzerId_View
                      WHERE Constant_ProfitLoss_AnalyzerId_View.isCost = FALSE
                     )
      -- ПРОДАЖИ - группировка для бонусов по PartnerId
    , tmpContainer_partner AS (SELECT tmp.JuridicalId
                                    , tmp.PartnerId
                                    , tmp.ContractId
                                    , tmp.GoodsId
                                    , tmp.GoodsKindId
                                    , Object_Personal.ValueData       AS PersonalName
                                    , Object_PersonalTrade.ValueData  AS PersonalTradeName

                                    , tmp.SummAmount
                                    , tmp.Sale_Summ
                                    , tmp.Return_Summ

                                    , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.PartnerId) AS TotalSumm
                                    , SUM (tmp.Sale_Summ)   OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.PartnerId) AS TotalSummSale
                                    , SUM (tmp.Return_Summ) OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.PartnerId) AS TotalSummReturn

                       FROM (SELECT ContainerLO_Juridical.ObjectId        AS JuridicalId
                                  , MIContainer.ObjectExtId_Analyzer      AS PartnerId
                                  , ContainerLinkObject_Contract.ObjectId AS ContractId
                                  , MIContainer.ObjectId_analyzer         AS GoodsId
                                  , MIContainer.ObjectIntId_analyzer      AS GoodsKindId

                                  , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_AmountPartner
                                  , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_AmountPartner

                                  , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                                  , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ

                                  , SUM (CASE WHEN tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN MIContainer.Amount ELSE 0 END) AS SummAmount
                             FROM tmpAnalyzer
                                  INNER JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                                  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate     --'01.06.2024' AND '31.08.2024'--
                                                                  AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                  LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Contract
                                                                ON ContainerLinkObject_Contract.ContainerId = MIContainer.ContainerId_Analyzer
                                                               AND ContainerLinkObject_Contract.DescId      = zc_ContainerLinkObject_Contract()
                                  LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_Analyzer
                                                               AND ContainerLO_Juridical.DescId      = zc_ContainerLinkObject_Juridical()
                                  -- Договор(база)
                                  INNER JOIN (SELECT DISTINCT tmpMovement.ContractChildId
                                              FROM tmpMovement
                                             ) AS tmpMovement ON tmpMovement.ContractChildId = ContainerLinkObject_Contract.ObjectId

                             GROUP BY ContainerLO_Juridical.ObjectId
                                    , MIContainer.ObjectExtId_Analyzer
                                    , MIContainer.ObjectId_analyzer
                                    , MIContainer.ObjectIntId_analyzer
                                    , ContainerLinkObject_Contract.ObjectId
                             ) AS tmp
                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                                 ON ObjectLink_Partner_Personal.ObjectId = tmp.PartnerId
                                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
                            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Partner_Personal.ChildObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = tmp.PartnerId
                                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Partner_PersonalTrade.ChildObjectId
                      )
      -- ПРОДАЖИ - группировка для бонусов по ContractId
    , tmpContainer AS (SELECT tmp.JuridicalId
                            , tmp.PartnerId
                            , tmp.ContractId
                            , tmp.GoodsId
                            , tmp.GoodsKindId
                            --, STRING_AGG (DISTINCT tmp.PersonalName, ';')      AS PersonalName
                            --, STRING_AGG (DISTINCT tmp.PersonalTradeName, ';') AS PersonalTradeName
                            , tmp.PersonalName
                            , tmp.PersonalTradeName

                            ,  (tmp.SummAmount)  AS SummAmount
                            ,  (tmp.Sale_Summ)   AS Sale_Summ
                            ,  (tmp.Return_Summ) AS Return_Summ

                            , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId) AS TotalSumm
                            , SUM (tmp.Sale_Summ)   OVER (PARTITION BY tmp.ContractId) AS TotalSummSale
                            , SUM (tmp.Return_Summ) OVER (PARTITION BY tmp.ContractId) AS TotalSummReturn

                       FROM tmpContainer_partner AS tmp
                     /*GROUP BY tmp.JuridicalId
                              , tmp.PartnerId
                              , tmp.ContractId
                              , tmp.GoodsId
                              , tmp.GoodsKindId*/
                       )
      -- ПРОДАЖИ - если по Контрагенту ограничение в условиях - группировка для бонусов по ContractId
    , tmpContainer_partner_where_all AS (SELECT tmp.JuridicalId
                                              , tmp.PartnerId
                                                --
                                              , tmp.ContractId
                                              , tmpContractMaster_all_partner.ContractMasterId
                                                --
                                              , tmp.GoodsId
                                              , tmp.GoodsKindId
                                            --, STRING_AGG (DISTINCT tmp.PersonalName, ';')      AS PersonalName
                                            --, STRING_AGG (DISTINCT tmp.PersonalTradeName, ';') AS PersonalTradeName
                                              , tmp.PersonalName
                                              , tmp.PersonalTradeName
                  
                                              ,  (tmp.SummAmount)  AS SummAmount
                                              ,  (tmp.Sale_Summ)   AS Sale_Summ
                                              ,  (tmp.Return_Summ) AS Return_Summ
                  
                                              , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId) AS TotalSumm
                                              , SUM (tmp.Sale_Summ)   OVER (PARTITION BY tmp.ContractId) AS TotalSummSale
                                              , SUM (tmp.Return_Summ) OVER (PARTITION BY tmp.ContractId) AS TotalSummReturn
                  
                                         FROM tmpContainer_partner AS tmp
                                               -- нашли подключенного контрагента - ВСЕ условия
                                              JOIN tmpContractMaster_all_partner ON tmpContractMaster_all_partner.ContractChildId = tmp.ContractId
                                                                                AND tmpContractMaster_all_partner.PartnerId       = tmp.PartnerId
                                         /*GROUP BY tmp.JuridicalId
                                                , tmp.PartnerId
                                                , tmp.ContractId
                                                , tmpContractMaster_all_partner.ContractMasterId
                                                , tmp.GoodsId
                                                , tmp.GoodsKindId*/
                                         )
      -- ПРОДАЖИ - если по Контрагенту ограничение в договорах - ОДНО условие - группировка для бонусов по ContractId
    , tmpContainer_partner_where_one AS (SELECT tmp.JuridicalId
                                              , tmp.PartnerId
                                              --
                                              , tmp.ContractId
                                              , tmpContractMaster_partner.ContractMasterId
                                                --
                                              , tmpContractMaster_partner.ContractConditionKindId
                                              , tmpContractMaster_partner.BonusKindId
                                              , tmpContractMaster_partner.BonusValue
                                                --
                                              , tmp.GoodsId
                                              , tmp.GoodsKindId
                                            --, STRING_AGG (DISTINCT tmp.PersonalName, ';')      AS PersonalName
                                            --, STRING_AGG (DISTINCT tmp.PersonalTradeName, ';') AS PersonalTradeName
                                              , tmp.PersonalName
                                              , tmp.PersonalTradeName
                  
                                              ,  (tmp.SummAmount)  AS SummAmount
                                              ,  (tmp.Sale_Summ)   AS Sale_Summ
                                              ,  (tmp.Return_Summ) AS Return_Summ
                  
                                              ,  SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId) AS TotalSumm
                                              ,  SUM (tmp.Sale_Summ)   OVER (PARTITION BY tmp.ContractId) AS TotalSummSale
                                              ,  SUM (tmp.Return_Summ) OVER (PARTITION BY tmp.ContractId) AS TotalSummReturn
                  
                                         FROM tmpContainer_partner AS tmp
                                               -- нашли подключенного контрагента - ОДНО условие
                                              JOIN tmpContractMaster_partner ON tmpContractMaster_partner.ContractChildId = tmp.ContractId
                                                                            AND tmpContractMaster_partner.PartnerId       = tmp.PartnerId
                                         /*GROUP BY tmp.JuridicalId
                                                , tmp.PartnerId
                                                , tmp.ContractId
                                                , tmpContractMaster_partner.ContractMasterId
                                                  --
                                                , tmpContractMaster_partner.ContractConditionKindId
                                                , tmpContractMaster_partner.BonusKindId
                                                , tmpContractMaster_partner.BonusValue
                                                  --
                                                , tmp.GoodsId
                                                , tmp.GoodsKindId*/
                                         )

    , tmpData AS (SELECT tmpMovement.MovementId
                       , tmpMovement.MovementDescId
                       , tmpMovement.OperDate
                       , tmpMovement.InvNumber
                         -- юр.л. - условие
                       , tmpMovement.JuridicalId
                       , tmpMovement.PartnerId
                         --
                       , tmpMovement.ContractId
                       , tmpMovement.ContractChildId
                       , tmpMovement.ContractMasterId
                       , tmpMovement.PaidKindId
                       , tmpMovement.InfoMoneyId
                         -- Типы условий договоров
                       , tmpMovement.ContractConditionKindId
                         -- Виды бонусов
                       , tmpMovement.BonusKindId
                         -- % бонуса
                       , tmpMovement.BonusValue

                       , COALESCE (tmpContainer_partner_where_one.JuridicalId, tmpContainer_partner_where_all.JuridicalId, tmpContainer.JuridicalId, tmpContainer_partner.JuridicalId) AS JuridicalId_baza
                       , COALESCE (tmpContainer_partner_where_one.PartnerId, tmpContainer_partner_where_all.PartnerId, tmpContainer.PartnerId, tmpContainer_partner.PartnerId)         AS PartnerId_baza
                       , COALESCE (tmpContainer_partner_where_one.GoodsId, tmpContainer_partner_where_all.GoodsId, tmpContainer.GoodsId, tmpContainer_partner.GoodsId)                 AS GoodsId
                       , COALESCE (tmpContainer_partner_where_one.GoodsKindId, tmpContainer_partner_where_all.GoodsKindId, tmpContainer.GoodsKindId, tmpContainer_partner.GoodsKindId) AS GoodsKindId

                       , tmpMovement.AmountIn
                       , tmpMovement.AmountOut
                       , tmpMovement.Amount

                         -- Итог
                       , CASE WHEN tmpMovement.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSaleReturn())
                                   THEN COALESCE (tmpContainer_partner_where_one.TotalSumm, tmpContainer_partner_where_all.TotalSumm, tmpContainer.TotalSumm, tmpContainer_partner.TotalSumm,0)
                              ELSE COALESCE (tmpContainer_partner_where_one.TotalSummSale, tmpContainer_partner_where_all.TotalSummSale, tmpContainer.TotalSummSale, tmpContainer_partner.TotalSummSale,0)
                         END AS TotalSumm
                         -- продажа
                       , COALESCE (tmpContainer_partner_where_one.TotalSummSale, tmpContainer_partner_where_all.TotalSummSale, tmpContainer.TotalSummSale, tmpContainer_partner.TotalSummSale,0)         AS TotalSummSale
                         -- возврат
                       , CASE WHEN tmpMovement.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSaleReturn())
                                   THEN COALESCE (tmpContainer_partner_where_one.TotalSummReturn, tmpContainer_partner_where_all.TotalSummReturn, tmpContainer.TotalSummReturn, tmpContainer_partner.TotalSummReturn,0)
                              ELSE 0
                         END AS TotalSummReturn
                       
                         -- продажа
                       , COALESCE (tmpContainer_partner_where_one.Sale_Summ, tmpContainer_partner_where_all.Sale_Summ, tmpContainer.Sale_Summ, tmpContainer_partner.Sale_Summ,0)          AS Sale_Summ
                         -- возврат
                       , CASE WHEN tmpMovement.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSaleReturn())
                                   THEN COALESCE (tmpContainer_partner_where_one.Return_Summ, tmpContainer_partner_where_all.Return_Summ, tmpContainer.Return_Summ, tmpContainer_partner.Return_Summ ,0)
                              ELSE 0 
                         END AS Return_Summ
                         -- Итог
                       , CASE WHEN tmpMovement.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSaleReturn())
                                   THEN COALESCE (tmpContainer_partner_where_one.SummAmount, tmpContainer_partner_where_all.SummAmount, tmpContainer.SummAmount, tmpContainer_partner.SummAmount,0)
                              ELSE COALESCE (tmpContainer_partner_where_one.Sale_Summ, tmpContainer_partner_where_all.Sale_Summ, tmpContainer.Sale_Summ, tmpContainer_partner.Sale_Summ,0)
                         END AS SummAmount

                         -- Коэфф
                       , CASE WHEN CASE WHEN tmpMovement.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSaleReturn())
                                             THEN COALESCE (tmpContainer_partner_where_one.TotalSumm, tmpContainer_partner_where_all.TotalSumm, tmpContainer.TotalSumm, tmpContainer_partner.TotalSumm,0)
                                        ELSE COALESCE (tmpContainer_partner_where_one.TotalSummSale, tmpContainer_partner_where_all.TotalSummSale, tmpContainer.TotalSummSale, tmpContainer_partner.TotalSummSale,0)
                                   END <> 0
                                   THEN CASE WHEN tmpMovement.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSaleReturn())
                                                  THEN COALESCE (tmpContainer_partner_where_one.SummAmount, tmpContainer_partner_where_all.SummAmount, tmpContainer.SummAmount, tmpContainer_partner.SummAmount,0)
                                             ELSE COALESCE (tmpContainer_partner_where_one.Sale_Summ, tmpContainer_partner_where_all.Sale_Summ, tmpContainer.Sale_Summ, tmpContainer_partner.Sale_Summ,0)
                                        END * 100
                                      / CASE WHEN tmpMovement.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSaleReturn())
                                                  THEN COALESCE (tmpContainer_partner_where_one.TotalSumm, tmpContainer_partner_where_all.TotalSumm, tmpContainer.TotalSumm, tmpContainer_partner.TotalSumm,0)
                                             ELSE COALESCE (tmpContainer_partner_where_one.TotalSummSale, tmpContainer_partner_where_all.TotalSummSale, tmpContainer.TotalSummSale, tmpContainer_partner.TotalSummSale,0)
                                        END
                             ELSE 0
                         END AS PartPersent

                       , COALESCE (tmpContainer_partner_where_one.PersonalName, tmpContainer_partner_where_all.PersonalName, tmpContainer.PersonalName, tmpContainer_partner.PersonalName, '') AS PersonalName
                       , COALESCE (tmpContainer_partner_where_one.PersonalTradeName, tmpContainer_partner_where_all.PersonalTradeName, tmpContainer.PersonalTradeName, tmpContainer_partner.PersonalTradeName, '') AS PersonalTradeName

                  -- Затраты
                  FROM tmpMovement

                       -- 1.1. условия
                       LEFT JOIN (SELECT DISTINCT tmpContractMaster_partner.ContractChildId, tmpContractMaster_partner.ContractMasterId, tmpContractMaster_partner.ContractConditionKindId, tmpContractMaster_partner.BonusKindId, tmpContractMaster_partner.BonusValue
                                  FROM tmpContractMaster_partner
                                 ) AS tmp_1_check
                                   ON tmp_1_check.ContractChildId         = tmpMovement.ContractChildId
                                  AND tmp_1_check.ContractMasterId        = tmpMovement.ContractMasterId
                                  AND tmp_1_check.ContractConditionKindId = tmpMovement.ContractConditionKindId
                                  AND tmp_1_check.BonusKindId             = tmpMovement.BonusKindId
                                  AND tmp_1_check.BonusValue              = tmpMovement.BonusValue
                                  -- только если в условии нет PartnerId
                                  AND tmpMovement.PartnerId = 0
                       -- 1.2. ПРОДАЖИ - если по Контрагенту ограничение в договорах - ОДНО условие - группировка для бонусов по ContractId
                       LEFT JOIN tmpContainer_partner_where_one ON tmpContainer_partner_where_one.ContractId       = tmpMovement.ContractChildId
                                                               AND tmpContainer_partner_where_one.ContractMasterId = tmpMovement.ContractMasterId
                                                               -- только если в условии нет PartnerId
                                                               AND tmpMovement.PartnerId = 0
                                                               -- только для условия
                                                               AND tmpContainer_partner_where_one.ContractConditionKindId = tmpMovement.ContractConditionKindId
                                                               AND tmpContainer_partner_where_one.BonusKindId             = tmpMovement.BonusKindId
                                                               AND tmpContainer_partner_where_one.BonusValue              = tmpMovement.BonusValue

                       -- 2.1. условия
                       LEFT JOIN (SELECT DISTINCT tmpContractMaster_all_partner.ContractChildId, tmpContractMaster_all_partner.ContractMasterId
                                  FROM tmpContractMaster_all_partner
                                 ) AS tmp_2_check
                                   ON tmp_2_check.ContractChildId  = tmpMovement.ContractChildId
                                  AND tmp_2_check.ContractMasterId = tmpMovement.ContractMasterId
                                  -- только если в условии нет PartnerId
                                  AND tmpMovement.PartnerId = 0
                       -- 2.2. ПРОДАЖИ - если по Контрагенту ограничение в условиях - группировка для бонусов по ContractId
                       LEFT JOIN tmpContainer_partner_where_all ON tmpContainer_partner_where_all.ContractId       = tmpMovement.ContractChildId
                                                               AND tmpContainer_partner_where_all.ContractMasterId = tmpMovement.ContractMasterId
                                                               -- только если в условии нет PartnerId
                                                               AND tmpMovement.PartnerId = 0
                                                               -- если нет в 1.
                                                               -- AND tmpContainer_partner_where_one.ContractId IS NULL
                                                               AND tmp_1_check.ContractMasterId IS NULL

                       -- 3. ПРОДАЖИ - если группировка для бонусов по ContractId
                       LEFT JOIN tmpContainer ON tmpContainer.ContractId = tmpMovement.ContractChildId
                                             -- только если в условии нет PartnerId
                                             AND tmpMovement.PartnerId = 0

                                             -- если нет в 1.
                                             -- AND  tmpContainer_partner_where_one.ContractId IS NULL
                                             AND tmp_1_check.ContractMasterId IS NULL

                                             -- если нет в 2.
                                             -- AND  tmpContainer_partner_where_all.ContractId IS NULL
                                             AND tmp_2_check.ContractMasterId IS NULL

                       -- 4. ПРОДАЖИ - группировка для бонусов по PartnerId - 2 ключа в базе
                       LEFT JOIN tmpContainer_partner ON tmpContainer_partner.ContractId = tmpMovement.ContractChildId
                                                     -- !!!если в условии есть PartnerId!!!
                                                     AND tmpContainer_partner.PartnerId  = tmpMovement.PartnerId
                                                     AND tmpMovement.PartnerId > 0

                  )
             -- Результат
             SELECT tmpData.MovementId
                  , tmpData.OperDate
                  , tmpData.InvNumber
                  , Object_Retail.Id            AS RetailId
                  , Object_Retail.ValueData     AS RetailNamе

                    -- юр.л. - условие
                  , Object_Juridical.Id         AS JuridicalId
                  , Object_Juridical.ObjectCode AS JuridicalCode
                  , Object_Juridical.ValueData  AS JuridicalName
                  , Object_Partner.Id                AS PartnerId
                  , Object_Partner.ValueData         AS PartnerName

                    -- юр.л. - база
                  , Object_Juridical_baza.Id         AS JuridicalId_baza
                  , Object_Juridical_baza.ObjectCode AS JuridicalCode_baza
                  , Object_Juridical_baza.ValueData  AS JuridicalName_baza

                  , Object_Partner_baza.Id           AS PartnerId_baza
                  , CASE WHEN tmpContractMaster_partner_check.ContractMasterId > 0
                          AND tmpContractMaster_partner.PartnerId IS NULL
                              -- если по условию контрагент не подключен
                              THEN '--1-' || Object_Partner_baza.ValueData

                         WHEN tmpContractMaster_all_partner_check.ContractMasterId > 0
                          AND tmpContractMaster_all_partner.PartnerId IS NULL
                              -- если по договору контрагент не подключен
                              THEN '--2-' || Object_Partner_baza.ValueData
                         ELSE Object_Partner_baza.ValueData
                    END  :: TVarChar AS PartnerName_baza

                    -- договор (база)
                  , Object_ContractChild.ObjectCode AS ContractChildCode
                  , Object_ContractChild.ValueData  AS ContractChildName
                    -- договор (начисление)
                  , Object_Contract.ObjectCode AS ContractCode
                  , Object_Contract.ValueData  AS ContractName
                    -- договор (условие)
                  , Object_Contract_Master.ObjectCode AS ContractCode_Master
                  , Object_Contract_Master.ValueData  AS ContractName_Master

                    -- Типы условий договоров
                  , Object_ContractConditionKind.ValueData  AS ContractConditionKindName
                    -- Виды бонусов
                  , Object_BonusKind.ValueData              AS BonusKindName

                  , tmpData.PersonalName      ::TVarChar
                  , tmpData.PersonalTradeName ::TVarChar

                  , Object_PaidKind.ValueData       ::TVarChar AS PaidKindName
                  , Object_PaidKind_Child.ValueData ::TVarChar AS PaidKindName_Child

                  , View_InfoMoney.InfoMoneyName_all AS InfoMoneyName
                  , Object_InfoMoneyChild_View.InfoMoneyName_all AS InfoMoneyName_Child

                  , Object_Goods.Id             AS GoodsId
                  , Object_Goods.ObjectCode     AS GoodsCode
                  , Object_Goods.ValueData      AS GoodsName
                  , Object_GoodsKind.ValueData  AS GoodsKindName

                  , Object_Measure.ValueData           AS MeasureName
                  , Object_TradeMark.Id                AS TradeMarkId
                  , Object_TradeMark.ValueData         AS TradeMarkName
                  , Object_GoodsGroup.ValueData        AS GoodsGroupName
                  , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

                  , tmpData.AmountIn  :: TFloat
                  , tmpData.AmountOut :: TFloat
                  , tmpData.Amount    :: TFloat

                  , COALESCE (tmpData.Sale_Summ,0)   ::TFloat    AS Sale_Summ
                  , COALESCE (tmpData.Return_Summ,0) ::TFloat    AS Return_Summ
                  , COALESCE (tmpData.SummAmount,0)  ::TFloat    AS SummAmount

                  , CAST (tmpData.PartPersent * tmpData.AmountIn / 100 AS NUMERIC (16,2))  ::TFloat AS AmountIn_calc
                  , CAST (tmpData.PartPersent * tmpData.AmountOut / 100 AS NUMERIC (16,2)) ::TFloat AS AmountOut_calc
                  , CAST (tmpData.PartPersent * tmpData.Amount / 100 AS NUMERIC (16,2)) ::TFloat AS Amount_calc
                  , tmpData.PartPersent ::TFloat AS Persent

                    --бонус за продукцию
                  , CASE WHEN tmpData.InfoMoneyId = zc_Enum_InfoMoney_21501() THEN CAST (tmpData.PartPersent * tmpData.Amount / 100 AS NUMERIC (16,2)) ELSE 0 END ::TFloat AS Amount_501
                    -- бонус за мясное сырье
                  , CASE WHEN tmpData.InfoMoneyId = zc_Enum_InfoMoney_21502() THEN CAST (tmpData.PartPersent * tmpData.Amount / 100 AS NUMERIC (16,2)) ELSE 0 END ::TFloat AS Amount_502
                    -- бонус за рекламу
                  , CASE WHEN tmpData.InfoMoneyId = 8952                      THEN CAST (tmpData.PartPersent * tmpData.Amount / 100 AS NUMERIC (16,2)) ELSE 0 END ::TFloat AS Amount_503
                    -- маркетинговый бюджет
                  , CASE WHEN tmpData.InfoMoneyId = zc_Enum_InfoMoney_21512() THEN CAST (tmpData.PartPersent * tmpData.Amount / 100 AS NUMERIC (16,2)) ELSE 0 END ::TFloat AS Amount_512
                    -- расходы учредитедей
                  , CASE WHEN tmpData.InfoMoneyId = zc_Enum_InfoMoney_80601() THEN CAST (tmpData.PartPersent * tmpData.Amount / 100 AS NUMERIC (16,2)) ELSE 0 END ::TFloat AS Amount_601
                    -- Услуги - Акции
                  , CASE WHEN tmpData.InfoMoneyId = 8953                      THEN CAST (tmpData.PartPersent * tmpData.Amount / 100 AS NUMERIC (16,2)) ELSE 0 END ::TFloat AS Amount_504

             FROM tmpData
                -- кому начислили
                LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id     = tmpData.PartnerId
                -- УП статья (условие)
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpData.InfoMoneyId
                -- ФО документ затрат
                LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId

                -- Договор (начисление)
                LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpData.ContractId
                -- Договор (условие)
                LEFT JOIN Object AS Object_Contract_Master ON Object_Contract_Master.Id = tmpData.ContractMasterId

                -- Типы условий договоров
                LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpData.ContractConditionKindId
                -- Виды бонусов
                LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = tmpData.BonusKindId

                -- юр.л. - база
                LEFT JOIN Object AS Object_Juridical_baza ON Object_Juridical_baza.Id = tmpData.JuridicalId_baza
                LEFT JOIN Object AS Object_Partner_baza ON Object_Partner_baza.Id     = tmpData.PartnerId_baza

                -- Договор (условие) - ограничение PartnerId - ВСЕ условия
                LEFT JOIN (SELECT DISTINCT tmpContractMaster_all_partner.ContractMasterId FROM tmpContractMaster_all_partner
                          ) AS tmpContractMaster_all_partner_check
                            ON tmpContractMaster_all_partner_check.ContractMasterId = tmpData.ContractMasterId
                --
                LEFT JOIN tmpContractMaster_all_partner ON tmpContractMaster_all_partner.ContractMasterId = tmpData.ContractMasterId
                                                       AND tmpContractMaster_all_partner.ContractChildId  = tmpData.ContractChildId
                                                       AND tmpContractMaster_all_partner.PartnerId        = tmpData.PartnerId_baza

                -- Договор (условие) - ограничение PartnerId - ОДНО условие
                LEFT JOIN (SELECT DISTINCT tmpContractMaster_partner.ContractMasterId, ContractConditionKindId, BonusKindId, BonusValue FROM tmpContractMaster_partner
                          ) AS tmpContractMaster_partner_check
                            ON tmpContractMaster_partner_check.ContractMasterId        = tmpData.ContractMasterId
                           AND tmpContractMaster_partner_check.ContractConditionKindId = tmpData.ContractConditionKindId
                           AND tmpContractMaster_partner_check.BonusKindId             = tmpData.BonusKindId
                           AND tmpContractMaster_partner_check.BonusValue              = tmpData.BonusValue
                --
                LEFT JOIN tmpContractMaster_partner ON tmpContractMaster_partner.ContractMasterId        = tmpData.ContractMasterId
                                                   AND tmpContractMaster_partner.ContractChildId         = tmpData.ContractChildId
                                                   AND tmpContractMaster_partner.PartnerId               = tmpData.PartnerId_baza
                                                   AND tmpContractMaster_partner.ContractConditionKindId = tmpData.ContractConditionKindId
                                                   AND tmpContractMaster_partner.BonusKindId             = tmpData.BonusKindId
                                                   AND tmpContractMaster_partner.BonusValue              = tmpData.BonusValue

                -- договор (база)
                LEFT JOIN Object AS Object_ContractChild ON Object_ContractChild.Id = tmpData.ContractChildId
                -- ???ФО договор база - может надо из проводок
                LEFT JOIN ObjectLink AS ObjectLink_ContractChild_PaidKind
                                     ON ObjectLink_ContractChild_PaidKind.ObjectId = tmpData.ContractChildId
                                    AND ObjectLink_ContractChild_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                LEFT JOIN Object AS Object_PaidKind_Child ON Object_PaidKind_Child.Id = ObjectLink_ContractChild_PaidKind.ChildObjectId

                -- ???УП статья (дог.база) - может надо из проводок
                LEFT JOIN ObjectLink AS ObjectLink_ContractChild_InfoMoney
                                     ON ObjectLink_ContractChild_InfoMoney.ObjectId = tmpData.ContractChildId
                                    AND ObjectLink_ContractChild_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                LEFT JOIN Object_InfoMoney_View AS Object_InfoMoneyChild_View ON Object_InfoMoneyChild_View.InfoMoneyId = ObjectLink_ContractChild_InfoMoney.ChildObjectId


                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

                LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                     ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical_baza.Id
                                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                       ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
               ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.09.24         *
*/

/*
zc_Enum_InfoMoney_21501(), --1)Бонус за продукцию
zc_Enum_InfoMoney_21502(), --2)Бонус за мясное сырье
zc_Enum_InfoMoney_21512(), --4) Маркетинговый бюджет
zc_Enum_InfoMoney_80601(), --3)Расходы учредителей
8952 zc_Enum_InfoMoney_21503() --5)Реклама
8953 zc_Enum_InfoMoney_21504() --6) услуги акции
*/

-- тест
-- SELECT * FROM gpReport_ProfitLossService_bySale (inStartDate:= '01.10.2024', inEndDate:= '01.10.2024', inJuridicalId:= 5388644, inSession:= zfCalc_UserAdmin());
