-- Function: gpReport_ProfitLossService ()

DROP FUNCTION IF EXISTS gpReport_ProfitLossService (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLossService (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, MovementDescName TVarChar
              -- юр.л. - условие
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
               -- юр.л. - база
             , JuridicalId_baza Integer, JuridicalCode_baza Integer, JuridicalName_baza TVarChar
               -- договор (база)
             , ContractChildCode Integer, ContractChildName TVarChar
               -- договор (начисление)
             , ContractCode Integer, ContractName TVarChar
               -- договор (условие)
             , ContractCode_Master Integer, ContractName_Master TVarChar
               -- Типы условий договоров
             , ContractConditionKindName TVarChar

             , PaidKindName TVarChar, PaidKindName_Child TVarChar
             , InfoMoneyName TVarChar, InfoMoneyName_Child TVarChar

             , MovementId_doc Integer, OperDate_Doc TDateTime, InvNumber_doc TVarChar, InvNumber_full_doc TVarChar, MovementDescName_doc TVarChar
             --, TradeMarkName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , MeasureName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsGroupPropertyId Integer, GoodsGroupPropertyName TVarChar
             , GoodsGroupPropertyId_Parent Integer, GoodsGroupPropertyName_Parent TVarChar
             , AmountIn TFloat, AmountOut TFloat, Amount TFloat

               -- Компенсация за вес, кг - ***Акция
             , AmountMarket        TFloat
               -- Компенсация,грн - ***Акция
             , SummMarket          TFloat
               -- Стоимость участия,грн - ***Акция
             , CostPromo_m         TFloat
               -- Стоимость участия - ***Трейд-маркетинг
             , CostPromo_mi        TFloat

             , SummAmount          TFloat -- сумма продажи
             , TotalSumm           TFloat -- итого продажа по юр.лицо + договор
             , TotalSumm_tm        TFloat --
             , TotalSumm_gp        TFloat --
             , TotalSumm_gpp       TFloat --

             , Persent_part        TFloat
             , Persent_part_tm     TFloat
             , Persent_part_gp     TFloat
             , Persent_part_gpp    TFloat

               -- Расчет - Компенсация, грн
             , SummMarket_calc     TFloat --
               -- Расчет - Стоимость участия,грн (Акция)
             , CostPromo_m_calc    TFloat --
               -- Расчет - Стоимость участия, грн (Трейд-маркетинг)
             , CostPromo_mi_calc   TFloat --
             )

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
      WITH
      -- Затраты - ProfitLossService + Service
      tmpMovement_all AS (SELECT Movement.*
                          FROM Movement
                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.DescId   IN (zc_Movement_ProfitLossService(), zc_Movement_Service())
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                         )
      -- база - Акция / Трейд-маркетинг
    , tmpMLM_doc AS (SELECT MLM.*
                     FROM MovementLinkMovement AS MLM
                     WHERE MLM.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                       AND MLM.DescId = zc_MovementLinkMovement_Doc()
                       AND MLM.MovementChildId > 0
                    )
      -- база ТМ - по всем продажам
    , tmpMLO_TM AS (SELECT MovementLinkObject.*
                    FROM MovementLinkObject
                    WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                      AND MovementLinkObject.DescId = zc_MovementLinkObject_TradeMark()
                      AND MovementLinkObject.ObjectId > 0
                   )
     -- Затраты - Только то что будем распределять - ProfitLossService + Service
   , tmpMovement_find AS (SELECT Movement.*
                               , tmpMLM_doc.MovementChildId AS MovementId_doc
                               , tmpMLO_TM.ObjectId         AS TradeMarkId
                          FROM tmpMovement_all AS Movement
                               LEFT JOIN tmpMLM_doc ON tmpMLM_doc.MovementId = Movement.Id
                               LEFT JOIN tmpMLO_TM  ON tmpMLO_TM.MovementId  = Movement.Id
                          WHERE tmpMLM_doc.MovementId > 0
                             OR tmpMLO_TM.MovementId  > 0
                         )
      -- сумма начислений - Затраты - только если ТМ + договор база?
    , tmpMI AS (SELECT MovementItem.MovementId
                     , MovementItem.Id
                     , MovementItem.ObjectId
                     , CASE WHEN 1=0 -- MovementItem.Amount > 0
                                 THEN MovementItem.Amount
                            ELSE 0
                       END::TFloat AS AmountIn
                     , CASE WHEN 1=1 -- MovementItem.Amount < 0
                                 THEN -1 * MovementItem.Amount - MovementItem.Amount
                            ELSE 0
                       END::TFloat AS AmountOut
                     , -1 * MovementItem.Amount AS Amount
                FROM MovementItem
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_find.Id FROM tmpMovement_find)
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
                  AND MovementItem.Amount <> 0
               )
      -- св-ва  - Затраты
    , tmpMILO AS (SELECT MovementItemLinkObject.*
                  FROM MovementItemLinkObject
                  WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                    AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Contract()
                                                        , zc_MILinkObject_ContractMaster()
                                                        , zc_MILinkObject_ContractChild()
                                                        , zc_MILinkObject_InfoMoney()
                                                        , zc_MILinkObject_PaidKind()
                                                        , zc_MILinkObject_ContractConditionKind()
                                                         )
                  )
      -- Затраты Только то что будем распределять - ProfitLossService + Service
    , tmpMovement AS (SELECT Movement.Id              AS MovementId
                             -- ProfitLossService or Service
                           , Movement.DescId          AS MovementDescId
                             --
                           , Movement.OperDate
                           , Movement.InvNumber
                           , Movement.MovementId_doc
                           , Movement.TradeMarkId

                           , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId, 0)                AS JuridicalId
                           , CASE WHEN ObjectLink_Partner_Juridical.ChildObjectId > 0 THEN MovementItem.ObjectId ELSE 0 END AS PartnerId

                             -- Договор (начисление)
                           , MILinkObject_Contract.ObjectId        AS ContractId
                             -- Договор (база)
                           , MILinkObject_ContractChild.ObjectId   AS ContractChildId
                             -- Договор (условие)
                             --
                           , MILinkObject_ContractMaster.ObjectId  AS ContractMasterId
                             -- Типы условий договоров
                           , MILinkObject_ContractConditionKind.ObjectId  AS ContractConditionKindId

                           , MILinkObject_InfoMoney.ObjectId              AS InfoMoneyId
                           , MILinkObject_PaidKind.ObjectId               AS PaidKindId
                           , MovementItem.AmountIn
                           , MovementItem.AmountOut
                           , MovementItem.Amount

                      FROM tmpMovement_find AS Movement
                           LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

                           -- юр лицо, если выбран контрагент то его юр лицо
                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                           -- Договор(база)
                           LEFT JOIN tmpMILO AS MILinkObject_ContractChild
                                             ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()

                           LEFT JOIN tmpMILO AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                           -- Договор(условия)
                           LEFT JOIN tmpMILO AS MILinkObject_ContractMaster
                                             ON MILinkObject_ContractMaster.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractMaster.DescId = zc_MILinkObject_ContractMaster()
                           -- Договор (начисление)
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                            ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Contract.DescId         = zc_MILinkObject_Contract()
                           -- форма оплаты
                           LEFT JOIN tmpMILO AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()

                           -- Типы условий договоров
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                            ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
                     )
      -- элементы Акция / Трейд-маркетинг
    , tmpMI_doc AS (SELECT MovementItem.*
                           -- № п/п
                         , ROW_NUMBER() OVER (PARTITION BY MovementItem.MovementId ORDER BY MovementItem.Id ASC) AS Ord
                    FROM MovementItem
                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMLM_doc.MovementChildId FROM tmpMLM_doc)
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                    )
      -- Акция - Стоимость участия
    , tmpMovementFloat_CostPromo AS (SELECT MovementFloat.*
                                     FROM MovementFloat
                                     WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMLM_doc.MovementChildId FROM tmpMLM_doc)
                                       AND MovementFloat.DescId     = zc_MovementFloat_CostPromo()  -- Стоимость участия - ***Акция
                                       AND MovementFloat.ValueData  <> 0
                                    )
      -- Суммы - элементы Акция / Трейд-маркетинг
    , tmpMIFloat_doc AS (SELECT MovementItemFloat.*
                         FROM MovementItemFloat
                         WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_doc.Id FROM tmpMI_doc)
                           AND MovementItemFloat.DescId IN (zc_MIFloat_AmountMarket()  -- Компенсация за вес, кг - ***Акция
                                                          , zc_MIFloat_SummOutMarket() -- Компенсация,грн - ***Акция
                                                          , zc_MIFloat_SummInMarket()  -- Корректировка компенсации,грн - ***Акция
                                                          , zc_MIFloat_Summ()          -- Стоимость участия - ***Трейд-маркетинг
                                                           )
                           AND MovementItemFloat.ValueData <> 0
                        )
      -- Св-ва - элементы Акция / Трейд-маркетинг
    , tmpMILO_doc AS (SELECT MovementItemLinkObject.*
                      FROM MovementItemLinkObject
                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_doc.Id FROM tmpMI_doc)
                        AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()           -- Вид товара
                                                            , zc_MILinkObject_TradeMark()           -- Торговая марка
                                                            , zc_MILinkObject_GoodsGroupProperty()  -- Аналитический классификатор
                                                            , zc_MILinkObject_GoodsGroupDirection() -- Аналитическая группа Направление
                                                            )

                     )
      -- Акция / Трейд-маркетинг
    , tmpData AS (SELECT tmpMovement.MovementId
                       , tmpMovement.MovementDescId
                       , tmpMovement.OperDate
                       , tmpMovement.InvNumber
                       , tmpMovement.MovementId_doc

                         -- ТМ в строчке Акция / Трейд-маркетинг
                       , COALESCE (MILinkObject_TradeMark.ObjectId, 0) AS TradeMarkId_mi

                         -- ТМ в документе затрат
                       , COALESCE (tmpMovement.TradeMarkId)            AS TradeMarkId

                         -- Аналитический классификатор - уровень-1 - в строчке Акция / Трейд-маркетинг
                       , Object_GoodsGroupPropertyParent.Id            AS GoodsGroupPropertyId_Parent
                         -- Аналитический классификатор - уровень-2 - в строчке Акция / Трейд-маркетинг
                       , Object_GoodsGroupProperty.Id                  AS GoodsGroupPropertyId
                         -- Аналитическая группа Направление - в строчке Акция / Трейд-маркетинг
                       , MILinkObject_GoodsGroupDirection.ObjectId     AS GoodsGroupDirectionId

                         -- Юр лицо / контрагент - в документе затрат
                       , tmpMovement.JuridicalId
                       , tmpMovement.PartnerId
                         -- Договор (начисление затрат)
                       , tmpMovement.ContractId
                         -- Договор (база - в начисление затрат)
                       , tmpMovement.ContractChildId
                         -- Договор (условие - в начисление затрат)
                       , tmpMovement.ContractMasterId
                         -- Информативно (в начисление затрат)
                       , tmpMovement.PaidKindId
                         -- Информативно (в начисление затрат)
                       , tmpMovement.InfoMoneyId
                         -- Информативно (в начисление затрат)
                       , tmpMovement.ContractConditionKindId

                         -- ФО в документе Акция / Трейд-маркетинг
                       , MLO_PaidKind.ObjectId AS PaidKindId_baza
                         -- Торговая сеть - 1:N или не указан
                       , 0 AS RetaillId_baza
                         -- Юр.л. - 1:N или не указан
                       , 0 AS JuridicalId_baza
                         -- Контрагент - 1:N или не указан
                       , 0 AS PartnerId_baza
                         -- Договор - 1:N или 1:1 или не указан
                       , COALESCE (MLO_Contract.ObjectId, 0) AS ContractId_baza

                         -- база
                       , MovementItem.ObjectId AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                         -- Затраты
                       , tmpMovement.AmountIn
                       , tmpMovement.AmountOut
                       , tmpMovement.Amount

                         -- Компенсация за вес, кг - ***Акция
                       , COALESCE (MIFloat_AmountMarket.ValueData, 0) ::TFloat AS AmountMarket

                         -- Компенсация,грн - ***Акция
                       , (COALESCE (MIFloat_SummOutMarket.ValueData, 0) - COALESCE (MIFloat_SummInMarket.ValueData, 0)) ::TFloat AS SummMarket

                         -- Стоимость участия,грн - ***Акция
                       , CASE WHEN COALESCE (MovementItem.Ord, 0) <= 1
                                   THEN COALESCE (tmpMovementFloat_CostPromo.ValueData, 0)
                              ELSE 0
                         END ::TFloat AS CostPromo_m

                         -- Стоимость участия - ***Трейд-маркетинг
                       , COALESCE (MIFloat_Summ.ValueData, 0) ::TFloat AS CostPromo_mi

                  FROM tmpMovement
                       -- Акция - Стоимость участия
                       LEFT JOIN tmpMovementFloat_CostPromo ON tmpMovementFloat_CostPromo.MovementId = tmpMovement.MovementId_doc

                       -- Форма оплаты для базы - Акция / Трейд-маркетинг
                       LEFT JOIN MovementLinkObject AS MLO_PaidKind
                                                    ON MLO_PaidKind.MovementId = tmpMovement.MovementId_doc
                                                   AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()

                       -- Договор для базы - Трейд-маркетинг
                       LEFT JOIN MovementLinkObject AS MLO_Contract
                                                    ON MLO_Contract.MovementId = tmpMovement.MovementId_doc
                                                   AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()

                       -- строчка Акция / Трейд-маркетинг
                       LEFT JOIN tmpMI_doc AS MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_doc
                       -- база
                       LEFT JOIN tmpMILO_doc AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       -- Компенсация за вес, кг - ***Акция
                       LEFT JOIN tmpMIFloat_doc AS MIFloat_AmountMarket
                                                ON MIFloat_AmountMarket.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountMarket.DescId = zc_MIFloat_AmountMarket()
                       -- Компенсация,грн - ***Акция
                       LEFT JOIN tmpMIFloat_doc AS MIFloat_SummOutMarket
                                                ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                               AND MIFloat_SummOutMarket.DescId = zc_MIFloat_SummOutMarket()
                       -- Корректировка компенсации,грн - ***Акция
                       LEFT JOIN tmpMIFloat_doc AS MIFloat_SummInMarket
                                                ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                               AND MIFloat_SummInMarket.DescId = zc_MIFloat_SummInMarket()
                       -- Стоимость участия - ***Трейд-маркетинг
                       LEFT JOIN tmpMIFloat_doc AS MIFloat_Summ
                                                ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                               AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                       -- из док Акция - по ТМ нужно будет делать распределение
                       LEFT JOIN tmpMILO_doc AS MILinkObject_TradeMark
                                             ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                                            AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()
                                            -- !!!если не указан товар!!!
                                            AND COALESCE (MovementItem.ObjectId, 0) = 0

                       -- Аналитический классификатор
                       LEFT JOIN tmpMILO_doc AS MILinkObject_GoodsGroupProperty
                                             ON MILinkObject_GoodsGroupProperty.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsGroupProperty.DescId = zc_MILinkObject_GoodsGroupProperty()
                                            -- !!!если не указан товар!!!
                                            AND COALESCE (MovementItem.ObjectId, 0) = 0
                       -- Аналитический классификатор, если это уровень - 2, найдем уровень - 1
                       LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                            ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = MILinkObject_GoodsGroupProperty.ObjectId
                                           AND ObjectLink_GoodsGroupProperty_Parent.DescId   = zc_ObjectLink_GoodsGroupProperty_Parent()
                       -- уровень - 1
                       LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = COALESCE (ObjectLink_GoodsGroupProperty_Parent.ChildObjectId, MILinkObject_GoodsGroupProperty.ObjectId)
                       -- уровень - 2
                       LEFT JOIN Object AS Object_GoodsGroupProperty       ON Object_GoodsGroupProperty.Id = MILinkObject_GoodsGroupProperty.ObjectId
                                                                          AND ObjectLink_GoodsGroupProperty_Parent.ChildObjectId > 0
                       -- Аналитическая группа Направление
                       LEFT JOIN tmpMILO_doc AS MILinkObject_GoodsGroupDirection
                                             ON MILinkObject_GoodsGroupDirection.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsGroupDirection.DescId         = zc_MILinkObject_GoodsGroupDirection()
                                            -- !!!если не указан товар!!!
                                            AND COALESCE (MovementItem.ObjectId, 0) = 0
                  )


      -- продажи / возвраты
    , tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                           , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                      FROM Constant_ProfitLoss_AnalyzerId_View
                      WHERE Constant_ProfitLoss_AnalyzerId_View.isCost = FALSE
                     )
      -- данные о продаже  и возврате
    , tmpContainer AS (SELECT tmp.JuridicalId
                            , tmp.ContractId
                            , tmp.GoodsId
                            , tmp.GoodsKindId
                            , tmp.TradeMarkId
                            , ObjectLink_GoodsGroupProperty_Parent.ChildObjectId AS GoodsGroupPropertyId_Parent
                            , ObjectLink_Goods_GoodsGroupProperty.ChildObjectId  AS GoodsGroupPropertyId
                            , tmp.SummAmount
                            , tmp.Sale_Summ
                            , tmp.Return_Summ
                            --
                            /*
                            , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId) AS TotalSumm
                            , SUM (tmp.Sale_Summ)   OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId) AS TotalSummSale
                            , SUM (tmp.Return_Summ) OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId) AS TotalSummReturn
                            , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.TradeMarkId) AS TotalSumm_tm
                            , SUM (tmp.Sale_Summ)   OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.TradeMarkId) AS TotalSummSale_tm
                            , SUM (tmp.Return_Summ) OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.TradeMarkId) AS TotalSummReturn_tm
                           -- , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.GoodsId, tmp.GoodsKindId) AS TotalSumm_goods
                           */
                       FROM (SELECT ContainerLO_Juridical.ObjectId        AS JuridicalId
                                  , ContainerLinkObject_Contract.ObjectId AS ContractId
                                  , MIContainer.ObjectId_analyzer         AS GoodsId
                                  , MIContainer.ObjectIntId_analyzer      AS GoodsKindId
                                  , ObjectLink_Goods_TradeMark.ChildObjectId AS TradeMarkId

                                  , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_AmountPartner
                                  , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_AmountPartner

                                  , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                                  , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ

                                  , SUM (CASE WHEN tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN MIContainer.Amount ELSE 0 END) AS SummAmount        --итого прожажа минус возвраты
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
                                                                 AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                    LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                         ON ObjectLink_Goods_TradeMark.ObjectId = MIContainer.ObjectId_analyzer
                                                        AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                                   -- Договор(база)
                                    INNER JOIN (SELECT DISTINCT
                                                       tmpMovement.ContractChildId
                                                     , tmpMovement.JuridicalId
                                                     , tmpMovement.GoodsId
                                                     , tmpMovement.GoodsKindId
                                                     , tmpMovement.TradeMarkId
                                                FROM tmpData AS tmpMovement
                                                WHERE 1=0
                                               ) AS tmpMovement
                                                 ON tmpMovement.JuridicalId = ContainerLO_Juridical.ObjectId
                                                AND tmpMovement.ContractChildId = ContainerLinkObject_Contract.ObjectId
                                                AND ((tmpMovement.GoodsId = MIContainer.ObjectId_analyzer AND tmpMovement.GoodsKindId = MIContainer.ObjectIntId_analyzer AND COALESCE (tmpMovement.TradeMarkId,0) = 0)
                                                                )
                             GROUP BY ContainerLO_Juridical.ObjectId
                                    , MIContainer.ObjectId_analyzer
                                    , MIContainer.ObjectIntId_analyzer
                                    , ContainerLinkObject_Contract.ObjectId
                                    , ObjectLink_Goods_TradeMark.ChildObjectId
                             ) AS tmp
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                                  ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
                             --LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

                             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                                  ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId
                                                 AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
                             --LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId

                      )
    , tmpSaleReturn AS (SELECT tmp.JuridicalId
                             , tmp.ContractId
                             , tmp.GoodsId
                             , tmp.GoodsKindId
                             , tmp.TradeMarkId
                             , tmp.GoodsGroupPropertyId_Parent
                             , tmp.GoodsGroupPropertyId
                             , tmp.SummAmount
                             , tmp.Sale_Summ
                             , tmp.Return_Summ
                             --итого по юр.лицо + договор
                             , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId) AS TotalSumm
                             --итого по юр.лицо + договор + торговая марка
                             , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.TradeMarkId) AS TotalSumm_tm
                             --итого по юр.лицо + договор + GoodsGroupPropertyId
                             , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.GoodsGroupPropertyId) AS TotalSumm_gp
                             --итого по юр.лицо + договор + GoodsGroupPropertyId_Parent
                             , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.GoodsGroupPropertyId_Parent) AS TotalSumm_gpp
                        FROM tmpContainer AS tmp
                        )

    , tmpRes AS (--определение доли для товара, если выбран в акции
                 SELECT tmpData.MovementId
                      , tmpData.MovementDescId
                      , tmpData.OperDate
                      , tmpData.InvNumber
                      , tmpData.JuridicalId
                      , tmpData.ContractId
                      , tmpData.ContractChildId
                      , tmpData.ContractMasterId
                      , tmpData.PaidKindId
                      , tmpData.InfoMoneyId
                      , tmpData.ContractConditionKindId
                      , tmpData.MovementId_doc
                      , tmpSaleReturn.JuridicalId    AS JuridicalId_baza
                      , tmpData.TradeMarkId
                      , tmpData.GoodsGroupPropertyId_Parent
                      , tmpData.GoodsGroupPropertyId
                      , tmpData.GoodsId
                      , tmpData.GoodsKindId

                      , tmpData.Amount
                      , tmpData.AmountIn
                      , tmpData.AmountOut

                        -- Компенсация за вес, кг - ***Акция
                      , tmpData.AmountMarket
                        -- Компенсация,грн - ***Акция
                      , tmpData.SummMarket
                        -- Стоимость участия,грн - ***Акция
                      , tmpData.CostPromo_m
                        -- Стоимость участия - ***Трейд-маркетинг
                      , tmpData.CostPromo_mi

                      , tmpSaleReturn.SummAmount
                      , tmpSaleReturn.Sale_Summ
                      , tmpSaleReturn.Return_Summ
                      , tmpSaleReturn.TotalSumm
                      , 0 AS TotalSumm_tm
                      , 0 AS TotalSumm_gp
                      , 0 AS TotalSumm_gpp
                      , CASE WHEN COALESCE (tmpData.SummMarket,0) <> 0 THEN 100 ELSE CASE WHEN COALESCE(tmpSaleReturn.TotalSumm,0) <> 0 THEN (tmpSaleReturn.SummAmount * 100 / tmpSaleReturn.TotalSumm) ELSE 0 END END AS Persent_part
                      , 0 AS Persent_part_tm
                      , 0 AS Persent_part_gp
                      , 0 AS Persent_part_gpp
                 FROM tmpData
                      --
                      LEFT JOIN tmpSaleReturn ON tmpSaleReturn.JuridicalId = tmpData.JuridicalId
                                             AND tmpSaleReturn.ContractId = tmpData.ContractChildId
                                             AND tmpSaleReturn.GoodsId = tmpData.GoodsId
                                             AND COALESCE (tmpSaleReturn.GoodsKindId,0) = COALESCE (tmpData.GoodsKindId,0)
                 WHERE COALESCE (tmpData.GoodsId,0) <> 0
              UNION
                 --определение доли для торговой марки,
                 SELECT tmpData.MovementId
                      , tmpData.MovementDescId
                      , tmpData.OperDate
                      , tmpData.InvNumber
                      , tmpData.JuridicalId
                      , tmpData.ContractId
                      , tmpData.ContractChildId
                      , tmpData.ContractMasterId
                      , tmpData.PaidKindId
                      , tmpData.InfoMoneyId
                      , tmpData.ContractConditionKindId
                      , tmpData.MovementId_doc
                      , tmpSaleReturn.JuridicalId  AS JuridicalId_baza
                      , tmpData.TradeMarkId
                      , tmpData.GoodsGroupPropertyId_Parent
                      , tmpData.GoodsGroupPropertyId
                      , tmpSaleReturn.GoodsId
                      , tmpSaleReturn.GoodsKindId
                      , tmpData.Amount
                      , tmpData.AmountIn
                      , tmpData.AmountOut

                        -- Компенсация за вес, кг - ***Акция
                      , tmpData.AmountMarket
                        -- Компенсация,грн - ***Акция
                      , tmpData.SummMarket
                        -- Стоимость участия,грн - ***Акция
                      , tmpData.CostPromo_m
                        -- Стоимость участия - ***Трейд-маркетинг
                      , tmpData.CostPromo_mi

                      , tmpSaleReturn.SummAmount
                      , tmpSaleReturn.Sale_Summ
                      , tmpSaleReturn.Return_Summ
                      , 0 AS TotalSumm
                      , tmpSaleReturn.TotalSumm_tm
                      , 0 AS TotalSumm_gp
                      , 0 AS TotalSumm_gpp
                      , 0 AS Persent_part
                      , CASE WHEN COALESCE(tmpSaleReturn.TotalSumm_tm,0) <> 0 THEN (tmpSaleReturn.SummAmount * 100 / tmpSaleReturn.TotalSumm_tm) ELSE 0 END AS Persent_part_tm
                      , 0 AS Persent_part_gp
                      , 0 AS Persent_part_gpp
                 FROM tmpData
                      --
                      LEFT JOIN tmpSaleReturn ON tmpSaleReturn.JuridicalId = tmpData.JuridicalId
                                             AND tmpSaleReturn.ContractId = tmpData.ContractChildId
                                             AND tmpSaleReturn.TradeMarkId = tmpData.TradeMarkId
                 WHERE COALESCE (tmpData.TradeMarkId,0) <> 0
                   AND COALESCE (tmpData.GoodsId,0) = 0
              UNION
                --определение доли для аналит. классификатора,
                 SELECT tmpData.MovementId
                      , tmpData.MovementDescId
                      , tmpData.OperDate
                      , tmpData.InvNumber
                      , tmpData.JuridicalId
                      , tmpData.ContractId
                      , tmpData.ContractChildId
                      , tmpData.ContractMasterId
                      , tmpData.PaidKindId
                      , tmpData.InfoMoneyId
                      , tmpData.ContractConditionKindId
                      , tmpData.MovementId_doc
                      , tmpSaleReturn.JuridicalId  AS JuridicalId_baza
                      , tmpData.TradeMarkId
                      , tmpData.GoodsGroupPropertyId_Parent
                      , tmpData.GoodsGroupPropertyId
                      , tmpSaleReturn.GoodsId
                      , tmpSaleReturn.GoodsKindId
                      , tmpData.Amount
                      , tmpData.AmountIn
                      , tmpData.AmountOut

                        -- Компенсация за вес, кг - ***Акция
                      , tmpData.AmountMarket
                        -- Компенсация,грн - ***Акция
                      , tmpData.SummMarket
                        -- Стоимость участия,грн - ***Акция
                      , tmpData.CostPromo_m
                        -- Стоимость участия - ***Трейд-маркетинг
                      , tmpData.CostPromo_mi

                      , tmpSaleReturn.SummAmount
                      , tmpSaleReturn.Sale_Summ
                      , tmpSaleReturn.Return_Summ
                      , 0 AS TotalSumm
                      , 0 AS TotalSumm_tm
                      , tmpSaleReturn.TotalSumm_gp
                      , 0 AS TotalSumm_gpp
                      , 0 AS Persent_part
                      , 0 AS Persent_part_tm
                      , CASE WHEN COALESCE(tmpSaleReturn.TotalSumm_gp,0) <> 0 THEN (tmpSaleReturn.SummAmount * 100 / tmpSaleReturn.TotalSumm_gp) ELSE 0 END AS Persent_part_gp
                      , 0 AS Persent_part_gpp
                 FROM tmpData
                      --
                      LEFT JOIN tmpSaleReturn ON tmpSaleReturn.JuridicalId = tmpData.JuridicalId
                                             AND tmpSaleReturn.ContractId = tmpData.ContractChildId
                                             AND tmpSaleReturn.GoodsGroupPropertyId = tmpData.GoodsGroupPropertyId
                 WHERE COALESCE (tmpData.GoodsGroupPropertyId,0) <> 0
                   AND COALESCE (tmpData.GoodsId,0) = 0
              UNION
                 --определение доли для группы аналит. классификатора,
                 SELECT tmpData.MovementId
                      , tmpData.MovementDescId
                      , tmpData.OperDate
                      , tmpData.InvNumber
                      , tmpData.JuridicalId
                      , tmpData.ContractId
                      , tmpData.ContractChildId
                      , tmpData.ContractMasterId
                      , tmpData.PaidKindId
                      , tmpData.InfoMoneyId
                      , tmpData.ContractConditionKindId
                      , tmpData.MovementId_doc
                      , tmpSaleReturn.JuridicalId  AS JuridicalId_baza
                      , tmpData.TradeMarkId
                      , tmpData.GoodsGroupPropertyId_Parent
                      , tmpData.GoodsGroupPropertyId
                      , tmpSaleReturn.GoodsId
                      , tmpSaleReturn.GoodsKindId

                      , tmpData.Amount
                      , tmpData.AmountIn
                      , tmpData.AmountOut

                        -- Компенсация за вес, кг - ***Акция
                      , tmpData.AmountMarket
                        -- Компенсация,грн - ***Акция
                      , tmpData.SummMarket
                        -- Стоимость участия,грн - ***Акция
                      , tmpData.CostPromo_m
                        -- Стоимость участия - ***Трейд-маркетинг
                      , tmpData.CostPromo_mi

                      , tmpSaleReturn.SummAmount
                      , tmpSaleReturn.Sale_Summ
                      , tmpSaleReturn.Return_Summ

                      , 0 AS TotalSumm
                      , 0 AS TotalSumm_tm
                      , 0 AS TotalSumm_gp
                      , tmpSaleReturn.TotalSumm_gpp
                      , 0 AS Persent_part
                      , 0 AS Persent_part_tm
                      , 0 AS Persent_part_gp
                      , CASE WHEN COALESCE(tmpSaleReturn.TotalSumm_gpp,0) <> 0 THEN (tmpSaleReturn.SummAmount * 100 / tmpSaleReturn.TotalSumm_gpp) ELSE 0 END AS Persent_part_gpp
                 FROM tmpData
                      --
                      LEFT JOIN tmpSaleReturn ON tmpSaleReturn.JuridicalId = tmpData.JuridicalId
                                             AND tmpSaleReturn.ContractId = tmpData.ContractChildId
                                             AND tmpSaleReturn.GoodsGroupPropertyId = tmpData.GoodsGroupPropertyId
                 WHERE COALESCE (tmpData.GoodsGroupPropertyId_Parent,0) <> 0
                   AND COALESCE (tmpData.GoodsId,0) = 0
                 )


             SELECT tmpData.MovementId
                  , tmpData.OperDate
                  , tmpData.InvNumber
                  , MovementDesc.ItemName       AS MovementDescName
                    -- юр.л. - условие
                  , Object_Juridical.Id         AS JuridicalId
                  , Object_Juridical.ObjectCode AS JuridicalCode
                  , Object_Juridical.ValueData  AS JuridicalName

                    -- юр.л. - база
                  , Object_Juridical_baza.Id         AS JuridicalId_baza
                  , Object_Juridical_baza.ObjectCode AS JuridicalCode_baza
                  , Object_Juridical_baza.ValueData  AS JuridicalName_baza

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

                  , Object_PaidKind.ValueData       ::TVarChar AS PaidKindName
                  , Object_PaidKind_Child.ValueData ::TVarChar AS PaidKindName_Child

                  , View_InfoMoney.InfoMoneyName_all AS InfoMoneyName
                  , Object_InfoMoneyChild_View.InfoMoneyName_all AS InfoMoneyName_Child

                  , CASE WHEN COALESCE (Movement_Doc.Id,0) <> 0 THEN Movement_Doc.Id ELSE -1 END ::Integer AS MovementId_doc
                  , Movement_Doc.OperDate       AS OperDate_Doc
                  , Movement_Doc.InvNumber      AS InvNumber_doc
                  , zfCalc_PartionMovementName (Movement_Doc.DescId, MovementDesc_Doc.ItemName, Movement_Doc.InvNumber, Movement_Doc.OperDate) :: TVarChar AS InvNumber_full_doc
                  , MovementDesc_Doc.ItemName   AS MovementDescName_doc
                  --, Object_TradeMark.ValueData  AS TradeMarkName

                  , Object_Goods.Id             AS GoodsId
                  , Object_Goods.ObjectCode     AS GoodsCode
                  , Object_Goods.ValueData      AS GoodsName
                  , Object_GoodsKind.ValueData  AS GoodsKindName

                  , Object_Measure.ValueData           AS MeasureName
                  , Object_TradeMark.Id                AS TradeMarkId
                  , Object_TradeMark.ValueData         AS TradeMarkName
                  , Object_GoodsGroup.ValueData        AS GoodsGroupName
                  , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
                  , Object_GoodsGroupProperty.Id              AS GoodsGroupPropertyId
                  , Object_GoodsGroupProperty.ValueData       AS GoodsGroupPropertyName
                  , Object_GoodsGroupPropertyParent.Id        AS GoodsGroupPropertyId_Parent
                  , Object_GoodsGroupPropertyParent.ValueData AS GoodsGroupPropertyName_Parent

                  , tmpData.AmountIn         :: TFloat --дебет сумма док. начисления
                  , tmpData.AmountOut        :: TFloat --кредит сумма док. начисления
                  , tmpData.Amount           :: TFloat --сумма док. начисления

                    -- Компенсация за вес, кг - ***Акция
                  , tmpData.AmountMarket
                    -- Компенсация,грн - ***Акция
                  , tmpData.SummMarket
                    -- Стоимость участия,грн - ***Акция
                  , tmpData.CostPromo_m
                    -- Стоимость участия - ***Трейд-маркетинг
                  , tmpData.CostPromo_mi

                  , tmpData.SummAmount       :: TFloat --сумма продажи
                  , tmpData.TotalSumm        :: TFloat --Итого сумма продажи по юр лицо + договор
                  , tmpData.TotalSumm_tm     :: TFloat --
                  , tmpData.TotalSumm_gp     :: TFloat --
                  , tmpData.TotalSumm_gpp    :: TFloat --

                  , tmpData.Persent_part     :: TFloat
                  , tmpData.Persent_part_tm  :: TFloat
                  , tmpData.Persent_part_gp  :: TFloat
                  , tmpData.Persent_part_gpp :: TFloat

/*                  , CASE WHEN COALESCE (tmpData.TradeMarkId,0) = 0 AND COALESCE (tmpData.GoodsGroupPropertyId,0) = 0 AND COALESCE (tmpData.GoodsGroupPropertyId_Parent,0) = 0
                         THEN CASE WHEN COALESCE (tmpData.SummMarket,0) <> 0 THEN tmpData.SummMarket ELSE (ABS(tmpData.Amount) * tmpData.Persent_part)/100 END
                         ELSE 0
                    END  :: TFloat  AS SummMarket_calc

                  , CASE WHEN COALESCE (tmpData.TradeMarkId,0) <> 0 THEN (COALESCE (tmpData.SummMarket, ABS(tmpData.Amount)) * tmpData.Persent_part_tm)/100 ELSE 0 END                   :: TFloat  AS SummMarket_tm_calc
                  , CASE WHEN COALESCE (tmpData.GoodsGroupPropertyId,0) <> 0 THEN (COALESCE (tmpData.SummMarket, ABS(tmpData.Amount)) * tmpData.Persent_part_gp)/100 ELSE 0 END          :: TFloat  AS SummMarket_gp_calc
                  , CASE WHEN COALESCE (tmpData.GoodsGroupPropertyId_Parent,0) <> 0 THEN (COALESCE (tmpData.SummMarket, ABS(tmpData.Amount)) * tmpData.Persent_part_gpp)/100 ELSE 0 END  :: TFloat  AS SummMarket_gpp_calc*/

                    -- Расчет - Компенсация, грн
                  , tmpData.SummMarket     :: TFloat AS SummMarket_calc
                    -- Расчет - Стоимость участия,грн (Акция)
                  , tmpData.CostPromo_m     :: TFloat AS CostPromo_m_calc
                    -- Расчет - Стоимость участия, грн (Трейд-маркетинг)
                  , tmpData.CostPromo_mi    :: TFloat AS CostPromo_mi_calc
                  
             FROM tmpRes AS tmpData
                LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId
               -- LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

                LEFT JOIN Movement AS Movement_Doc ON Movement_Doc.Id = tmpData.MovementId_doc
                LEFT JOIN MovementDesc AS MovementDesc_Doc ON MovementDesc_Doc.Id = Movement_Doc.DescId

                -- кому начислили
                LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
                -- УП статья (условие)
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpData.InfoMoneyId
                -- ФО документ затрат
                LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId
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

                -- Договор (начисление)
                LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpData.ContractId
                -- Договор (условие)
                LEFT JOIN Object AS Object_Contract_Master ON Object_Contract_Master.Id = tmpData.ContractMasterId
                -- Типы условий договоров
                LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpData.ContractConditionKindId

                -- юр.л. - база
                LEFT JOIN Object AS Object_Juridical_baza ON Object_Juridical_baza.Id = tmpData.JuridicalId_baza

                LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                     ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical_baza.Id
                                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId


                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                     ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
                LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                     ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                    AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
                LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId


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
 09.08.24         *
*/

-- тест
-- SELECT * FROM gpReport_ProfitLossService (inStartDate:= '01.09.2024', inEndDate:= '30.09.2024', inSession:= zfCalc_UserAdmin());
