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
             , AmountIn TFloat, AmountOut TFloat, Amount TFloat
             , AmountMarket TFloat
             , SummInMarket Tfloat
             , SummOutMarket  Tfloat 
             , SummAmount         Tfloat --сумма продажи
             , TotalSumm          TFloat
             , Persent_part       Tfloat
             , Persent_part_tm    Tfloat             
             , SummMarket_calc  Tfloat
             , SummMarket_tm_calc Tfloat    
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
      --ProfitLossService
      tmpMovementFull AS (SELECT Movement.*
                          FROM Movement
                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.DescId = zc_Movement_ProfitLossService()
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          )
      --Акция / Трейд-маркетинг
    , tmpMLM_doc AS (SELECT MLM.*
                     FROM MovementLinkMovement AS MLM
                     WHERE MLM.DescId = zc_MovementLinkMovement_Doc()
                       AND MLM.MovementId IN (SELECT DISTINCT tmpMovementFull.Id FROM tmpMovementFull)
                       AND COALESCE (MLM.MovementChildId,0) > 0
                     )

    , tmpMLO AS (SELECT MovementLinkObject.*
                     FROM MovementLinkObject
                     WHERE MovementLinkObject.DescId = zc_MovementLinkObject_TradeMark()
                       AND MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovementFull.Id FROM tmpMovementFull)
                     )

    --сумма начислений bp ProfitLossService
    , tmpMI AS (SELECT MovementItem.MovementId
                     , MovementItem.Id
                     , MovementItem.ObjectId
                     , CASE WHEN MovementItem.Amount > 0
                                 THEN MovementItem.Amount
                            ELSE 0
                       END::TFloat AS AmountIn
                     , CASE WHEN MovementItem.Amount < 0
                                 THEN -1 * MovementItem.Amount
                            ELSE 0
                       END::TFloat AS AmountOut
                     , MovementItem.Amount                    
                FROM MovementItem
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementFull.Id FROM tmpMovementFull) 
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
                  AND COALESCE (MovementItem.Amount,0) <> 0
                )
    , tmpMILO AS (
                  SELECT MovementItemLinkObject.* 
                  FROM MovementItemLinkObject
                  WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                    AND MovementItemLinkObject.DescId IN (zc_MILinkObject_ContractChild() 
                                                        , zc_MILinkObject_InfoMoney()
                                                        , zc_MILinkObject_PaidKind()
                                                        , zc_MILinkObject_ContractMaster()
                                                        , zc_MILinkObject_Contract()
                                                        , zc_MILinkObject_ContractConditionKind()
                                                        )
                  )
    , tmpMovement AS (SELECT Movement.Id              AS MovementId
                           , Movement.DescId          AS MovementDescId
                           , Movement.OperDate
                           , Movement.InvNumber
                           , MLM_Doc.MovementChildId  AS MovementId_doc
                           , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId, 0) AS JuridicalId
                           , MovementLinkObject_TradeMark.ObjectId        AS TradeMarkId
                             -- Договор (начисление)
                           , MILinkObject_Contract.ObjectId        AS ContractId
                             -- Договор (база)
                           , MILinkObject_ContractChild.ObjectId   AS ContractChildId
                             -- Договор (условие)
                           , MILinkObject_ContractMaster.ObjectId  AS ContractMasterId
                             -- Типы условий договоров
                           , MILinkObject_ContractConditionKind.ObjectId  AS ContractConditionKindId     

                           , MILinkObject_InfoMoney.ObjectId              AS InfoMoneyId
                           , MILinkObject_PaidKind.ObjectId               AS PaidKindId
                           , MovementItem.AmountIn
                           , MovementItem.AmountOut
                           , MovementItem.Amount
                      FROM tmpMovementFull AS Movement
                          LEFT JOIN tmpMLM_doc AS MLM_Doc
                                               ON MLM_Doc.MovementId = Movement.Id
                                              AND MLM_Doc.DescId = zc_MovementLinkMovement_Doc() 

                          LEFT JOIN tmpMLO AS MovementLinkObject_TradeMark
                                           ON MovementLinkObject_TradeMark.MovementId = Movement.Id
                                          AND MovementLinkObject_TradeMark.DescId = zc_MovementLinkObject_TradeMark()

                          LEFT JOIN tmpMI AS MovementItem 
                                          ON MovementItem.MovementId = Movement.Id
                          --юр лицо , если выбран контрагент то его юр лицо
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
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
                      WHERE MLM_Doc.MovementChildId IS NOT NULL OR MovementLinkObject_TradeMark.ObjectId


                      )

    , tmpMI_doc AS (SELECT MovementItem.*
                    FROM MovementItem
                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMLM_doc.MovementChildId FROM tmpMLM_doc) 
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = FALSE
                    )

    , tmpMIFloat_doc AS (SELECT MovementItemFloat.*
                         FROM MovementItemFloat
                         WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_doc.Id FROM tmpMI_doc)
                           AND MovementItemFloat.DescId IN (zc_MIFloat_AmountMarket()
                                                          , zc_MIFloat_SummOutMarket()
                                                          , zc_MIFloat_SummInMarket() 
                                                          , zc_MIFloat_Summ()
                                                           )
                           AND COALESCE (MovementItemFloat.ValueData,0) <> 0
                        )

    , tmpMILO_doc AS (SELECT MovementItemLinkObject.*
                      FROM MovementItemLinkObject
                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_doc.Id FROM tmpMI_doc)
                        AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                     )

    , tmpData AS (SELECT tmpMovement.MovementId
                       , tmpMovement.MovementDescId
                       , tmpMovement.OperDate
                       , tmpMovement.InvNumber
                       , tmpMovement.MovementId_doc
                       , tmpMovement.TradeMarkId
                       , tmpMovement.JuridicalId
                       , tmpMovement.ContractId
                       , tmpMovement.ContractChildId
                       , tmpMovement.ContractMasterId
                       , tmpMovement.PaidKindId
                       , tmpMovement.InfoMoneyId
                       , tmpMovement.ContractConditionKindId
                       , MovementItem.ObjectId AS GoodsId  
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 

                       , tmpMovement.AmountIn
                       , tmpMovement.AmountOut   
                       , tmpMovement.Amount
                       , MIFloat_AmountMarket.ValueData  ::TFloat AS AmountMarket
                       , COALESCE (MIFloat_SummOutMarket.ValueData, MIFloat_Summ.ValueData) ::TFloat AS SummOutMarket
                       , MIFloat_SummInMarket.ValueData  ::TFloat AS SummInMarket 
                       --, MIFloat_Summ.ValueData          ::TFloat AS Summ --
             
                  FROM tmpMovement
                   LEFT JOIN tmpMI_doc AS MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_doc

                   LEFT JOIN tmpMILO_doc AS MILinkObject_GoodsKind
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN tmpMIFloat_doc AS MIFloat_AmountMarket
                                            ON MIFloat_AmountMarket.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountMarket.DescId = zc_MIFloat_AmountMarket()
                   LEFT JOIN tmpMIFloat_doc AS MIFloat_SummOutMarket
                                            ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                           AND MIFloat_SummOutMarket.DescId = zc_MIFloat_SummOutMarket()
                   LEFT JOIN tmpMIFloat_doc AS MIFloat_SummInMarket
                                            ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                           AND MIFloat_SummInMarket.DescId = zc_MIFloat_SummInMarket()
                   LEFT JOIN tmpMIFloat_doc AS MIFloat_Summ
                                            ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                           AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                           
             --  из док АКции - по ним нужно будет делать распределение 
             LEFT JOIN MovementItemLinkObject AS MILinkObject_TradeMark
                                              ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                                             AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()  
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = COALESCE (MILinkObject_TradeMark.ObjectId, ObjectLink_Goods_TradeMark.ChildObjectId)
             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupProperty
                                              ON MILinkObject_GoodsGroupProperty.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupProperty.DescId = zc_MILinkObject_GoodsGroupProperty()  
                                             AND COALESCE (MovementItem.ObjectId,0) = 0

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                  ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
             LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                  ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                 AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
             LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = COALESCE (ObjectLink_GoodsGroupProperty_Parent.ChildObjectId, MILinkObject_GoodsGroupProperty.ObjectId)
             --                                
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupDirection
                                              ON MILinkObject_GoodsGroupDirection.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupDirection.DescId = zc_MILinkObject_GoodsGroupDirection() 
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                  ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
             LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = COALESCE (MILinkObject_GoodsGroupDirection.ObjectId, ObjectLink_Goods_GoodsGroupDirection.ChildObjectId)
                                           
                                           
                  )
 
      -- продажи / возвраты
    , tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                           , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                      FROM Constant_ProfitLoss_AnalyzerId_View
                      WHERE Constant_ProfitLoss_AnalyzerId_View.isCost = FALSE
                     )
    , tmpContainer AS (SELECT tmp.JuridicalId
                            , tmp.ContractId
                            , tmp.GoodsId
                            , tmp.GoodsKindId 
                            , tmp.TradeMarkId
                            , tmp.SummAmount
                            , tmp.Sale_Summ
                            , tmp.Return_Summ
                            , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId) AS TotalSumm
                            , SUM (tmp.Sale_Summ)   OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId) AS TotalSummSale
                            , SUM (tmp.Return_Summ) OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId) AS TotalSummReturn
                            , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.TradeMarkId) AS TotalSumm_tm
                            , SUM (tmp.Sale_Summ)   OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.TradeMarkId) AS TotalSummSale_tm
                            , SUM (tmp.Return_Summ) OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.TradeMarkId) AS TotalSummReturn_tm
                           -- , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.GoodsId, tmp.GoodsKindId) AS TotalSumm_goods
                       FROM (SELECT ContainerLO_Juridical.ObjectId        AS JuridicalId
                                  , ContainerLinkObject_Contract.ObjectId AS ContractId
                                  , MIContainer.ObjectId_analyzer         AS GoodsId
                                  , MIContainer.ObjectIntId_analyzer      AS GoodsKindId
                                  , ObjectLink_Goods_TradeMark.ChildObjectId AS TradeMarkId

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
                                                                 AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                    LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                         ON ObjectLink_Goods_TradeMark.ObjectId = MIContainer.ObjectId_analyzer
                                                        AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()                                                                 
                                    -- Договор(база)
                                    INNER JOIN (SELECT DISTINCT tmpMovement.ContractChildId
                                                     , tmpMovement.JuridicalId
                                                     , tmpMovement.GoodsId
                                                     , tmpMovement.GoodsKindId
                                                     , tmpMovement.TradeMarkId
                                                FROM tmpData AS tmpMovement) AS tmpMovement
                                                                  ON tmpMovement.JuridicalId = ContainerLO_Juridical.ObjectId
                                                                 AND tmpMovement.ContractChildId = ContainerLinkObject_Contract.ObjectId
                                                                 AND ((tmpMovement.GoodsId = MIContainer.ObjectId_analyzer AND tmpMovement.GoodsKindId = MIContainer.ObjectIntId_analyzer AND COALESCE (tmpMovement.TradeMarkId,0) = 0) 
                                                                     OR (COALESCE (tmpMovement.TradeMarkId,0) <> 0 AND ObjectLink_Goods_TradeMark.ChildObjectId = tmpMovement.TradeMarkId)
                                                                     )
                             GROUP BY ContainerLO_Juridical.ObjectId
                                    , MIContainer.ObjectId_analyzer
                                    , MIContainer.ObjectIntId_analyzer
                                    , ContainerLinkObject_Contract.ObjectId
                                    , ObjectLink_Goods_TradeMark.ChildObjectId
                             ) AS tmp
                      )

    , tmpRes AS (SELECT tmpData.MovementId
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
                      , tmpData.TradeMarkId
                      , tmpData.MovementId_doc
                      , tmpContainer.JuridicalId    AS JuridicalId_baza
                      , tmpData.GoodsId
                      , tmpData.GoodsKindId
                      , tmpData.Amount
                      , tmpData.AmountIn
                      , tmpData.AmountOut
                      , tmpData.AmountMarket
                      , tmpData.SummOutMarket
                      , tmpData.SummInMarket
                      , tmpContainer.SummAmount
                      , tmpContainer.Sale_Summ
                      , tmpContainer.Return_Summ
                      , tmpContainer.TotalSumm
                      , tmpContainer.TotalSummSale
                      , tmpContainer.TotalSummReturn
                      , tmpContainer.TotalSumm_tm
                      , tmpContainer.TotalSummSale_tm
                      , tmpContainer.TotalSummReturn_tm
                     -- , tmpContainer.TotalSumm_goods
                      , CASE WHEN COALESCE (tmpData.SummOutMarket,0) <> 0 THEN 100 ELSE CASE WHEN COALESCE(tmpContainer.TotalSumm,0) <> 0 THEN (tmpContainer.SummAmount * 100 / tmpContainer.TotalSumm) ELSE 0 END END AS Persent_part
                      , CASE WHEN COALESCE(tmpContainer.TotalSumm_tm,0) <> 0 THEN (tmpContainer.SummAmount * 100 / tmpContainer.TotalSumm_tm) ELSE 0 END AS Persent_part_tm                       
                 FROM tmpData 
                      --
                      LEFT JOIN tmpContainer ON tmpContainer.JuridicalId = tmpData.JuridicalId
                                            AND tmpContainer.ContractId = tmpData.ContractChildId
                                            AND ((tmpContainer.GoodsId = tmpData.GoodsId AND COALESCE (tmpContainer.GoodsKindId,0) = COALESCE (tmpData.GoodsKindId,0))
                                              OR (tmpContainer.TradeMarkId = tmpData.TradeMarkId AND COALESCE (tmpData.TradeMarkId,0) <> 0)
                                                )
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

                  , tmpData.AmountIn         :: Tfloat --дебет сумма док. начисления
                  , tmpData.AmountOut        :: Tfloat --кредит сумма док. начисления
                  , tmpData.Amount           :: Tfloat --сумма док. начисления
                  , tmpData.AmountMarket     :: Tfloat -- Комп. за вес, кг
                  , tmpData.SummInMarket     :: Tfloat --Корр. компенс., грн
                  , tmpData.SummOutMarket    :: Tfloat --Компенсация, грн 
                  , tmpData.SummAmount       :: Tfloat --сумма продажи   
                  , tmpData.TotalSumm        :: Tfloat --Итого сумма продажи по юр лицо + договор
                  , tmpData.Persent_part     :: Tfloat
                  , tmpData.Persent_part_tm  :: Tfloat
                  

                  , CASE WHEN COALESCE (tmpData.TradeMarkId,0) = 0 
                         THEN CASE WHEN COALESCE (tmpData.SummOutMarket,0) <> 0 THEN tmpData.SummOutMarket ELSE (ABS(tmpData.Amount) * tmpData.Persent_part)/100 END
                         ELSE 0 
                    END  :: Tfloat  AS SummMarket_calc 
                  , CASE WHEN COALESCE (tmpData.TradeMarkId,0) <> 0 THEN (COALESCE (tmpData.SummOutMarket,ABS(tmpData.Amount)) * tmpData.Persent_part_tm)/100 ELSE 0 END  :: Tfloat  AS SummMarket_tm_calc
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
