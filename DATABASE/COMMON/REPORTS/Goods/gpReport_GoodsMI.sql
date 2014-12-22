-- Function: gpReport_GoodsMI ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   , -- zc_Movement_Sale or zc_Movement_ReturnIn
    IN inUnitId       Integer   , 
    IN inJuridicalId  Integer   , 
    IN inInfoMoneyId  Integer   , -- Управленческая статья  
    IN inPaidKindId   Integer   , --
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , Amount_Weight TFloat, Amount_Sh TFloat
             , AmountChangePercent_Weight TFloat, AmountChangePercent_Sh TFloat
             , AmountPartner_Weight TFloat, AmountPartner_Sh TFloat
             , Amount_10500_Weight TFloat, Amount_10500_Sh TFloat
             , Amount_40200_Weight TFloat, Amount_40200_Sh TFloat
             , SummPartner_calc TFloat
             , SummPartner TFloat, SummPartner_10200 TFloat, SummPartner_10300 TFloat
             , SummDiff TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             )   
AS
$BODY$
   DECLARE vbIsGoods Boolean;
   DECLARE vbIsUnit Boolean;
BEGIN
    vbIsGoods:= FALSE;
    vbIsUnit:= FALSE;

    -- Ограничения по товарам
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        -- устанавливается признак
        vbIsGoods:= TRUE;
        -- заполнение
        INSERT INTO _tmpGoods (GoodsId)
           SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    /*ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();*/
    END IF;

    -- Ограничения по подразделениям
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    IF inUnitId <> 0
    THEN
        -- устанавливается признак
        vbIsUnit:= TRUE;
        -- заполнение
        INSERT INTO _tmpUnit (UnitId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup;
    /*ELSE
        INSERT INTO _tmpUnit (UnitId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Unit();*/
    END IF;


    -- Результат
    RETURN QUERY
    WITH tmpReportContainerSumm AS
                      (SELECT tmpListContainer.InfoMoneyId
                            , MovementItem.Id AS MovementItemId
                            , MovementItem.MovementId
                            , MovementItem.ObjectId AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                            , SUM (CASE WHEN (tmpListContainer.AccountKindId = zc_Enum_AccountKind_Active() AND inDescId = zc_Movement_Sale())
                                              OR (tmpListContainer.AccountKindId = zc_Enum_AccountKind_Passive() AND inDescId = zc_Movement_ReturnIn())
                                             THEN -1
                                        ELSE 1
                                   END * MIReport.Amount) AS SummPartner
                            , SUM (CASE WHEN tmpListContainer.ProfitLossDirectionId <> zc_Enum_ProfitLossDirection_10200()
                                             THEN 0
                                        WHEN (tmpListContainer.AccountKindId = zc_Enum_AccountKind_Active() AND inDescId = zc_Movement_Sale())
                                              OR (tmpListContainer.AccountKindId = zc_Enum_AccountKind_Passive() AND inDescId = zc_Movement_ReturnIn())
                                             THEN 1
                                        ELSE -1
                                   END * MIReport.Amount) AS SummPartner_10200
                            , SUM (CASE WHEN tmpListContainer.ProfitLossDirectionId <> zc_Enum_ProfitLossDirection_10300()
                                             THEN 0
                                        WHEN (tmpListContainer.AccountKindId = zc_Enum_AccountKind_Active() AND inDescId = zc_Movement_Sale())
                                              OR (tmpListContainer.AccountKindId = zc_Enum_AccountKind_Passive() AND inDescId = zc_Movement_ReturnIn())
                                             THEN 1
                                        ELSE -1
                                   END * MIReport.Amount) AS SummPartner_10300

                            , COALESCE (MIFloat_Price.ValueData, 0)                                                         AS Price
                            , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice

                            , MovementBoolean_PriceWithVAT.ValueData               AS PriceWithVAT
                            , COALESCE (MovementFloat_VATPercent.ValueData, 0)     AS VATPercent
                            , COALESCE (MovementFloat_ChangePercent.ValueData, 0)  AS ChangePercent

                       FROM (SELECT tmpProfitLoss.ProfitLossDirectionId
                                  , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                  , ReportContainerLink.ReportContainerId
                                  , ReportContainerLink.AccountKindId
                                  , tmpProfitLoss.MLO_DescId
                             FROM (SELECT ProfitLossId, ProfitLossDirectionId, zc_MovementLinkObject_From() AS MLO_DescId FROM Constant_ProfitLoss_Sale_ReturnIn_View WHERE isSale = TRUE AND isCost = FALSE AND inDescId = zc_Movement_Sale()
                                  UNION ALL
                                   SELECT ProfitLossId, ProfitLossDirectionId, zc_MovementLinkObject_To() AS MLO_DescId FROM Constant_ProfitLoss_Sale_ReturnIn_View WHERE isSale = FALSE AND isCost = FALSE AND inDescId = zc_Movement_ReturnIn()
                                  ) AS tmpProfitLoss
                                  INNER JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                                                 ON ContainerLO_ProfitLoss.ObjectId = tmpProfitLoss.ProfitLossId
                                                                AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                  INNER JOIN ReportContainerLink ON ReportContainerLink.ContainerId = ContainerLO_ProfitLoss.ContainerId
                                                                AND ReportContainerLink.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                  INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                 ON ContainerLO_Juridical.ContainerId = ReportContainerLink.ChildContainerId
                                                                AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                 ON ContainerLinkObject_InfoMoney.ContainerId = ReportContainerLink.ChildContainerId
                                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                                 ON ContainerLinkObject_PaidKind.ContainerId = ReportContainerLink.ChildContainerId
                                                                AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                AND (ContainerLinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                             ) AS tmpListContainer
                             INNER JOIN MovementItemReport AS MIReport ON MIReport.ReportContainerId = tmpListContainer.ReportContainerId
                                                                      AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = MIReport.MovementId
                                                         AND MovementLinkObject_Unit.DescId = tmpListContainer.MLO_DescId
                             LEFT JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId

                             INNER JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                                    AND MovementItem.DescId = zc_MI_Master()
                             LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                         ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                       ON MovementBoolean_PriceWithVAT.MovementId =  MIReport.MovementId
                                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                     ON MovementFloat_VATPercent.MovementId =  MIReport.MovementId
                                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                     ON MovementFloat_ChangePercent.MovementId = MIReport.MovementId
                                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                         WHERE (_tmpUnit.UnitId > 0 OR vbIsUnit = FALSE)
                           AND (_tmpGoods.GoodsId > 0 OR vbIsGoods = FALSE)
                       GROUP BY tmpListContainer.InfoMoneyId
                              , MovementItem.Id
                              , MovementItem.MovementId
                              , MovementItem.ObjectId
                              , MILinkObject_GoodsKind.ObjectId
                              , MIFloat_Price.ValueData
                              , MIFloat_CountForPrice.ValueData
                              , MovementBoolean_PriceWithVAT.ValueData
                              , MovementFloat_VATPercent.ValueData
                              , MovementFloat_ChangePercent.ValueData
                      )
       , tmpOperationGroup_all AS
                (SELECT tmpReportContainerSumm.InfoMoneyId
                      , tmpReportContainerSumm.GoodsId   
                      , tmpReportContainerSumm.GoodsKindId
                      , SUM (tmpReportContainerSumm.Amount)              AS Amount
                      , SUM (tmpReportContainerSumm.AmountChangePercent) AS AmountChangePercent
                      , SUM (tmpReportContainerSumm.AmountPartner)       AS AmountPartner
                      , SUM (tmpReportContainerSumm.Amount_10500)        AS Amount_10500
                      , SUM (tmpReportContainerSumm.Amount_40200)        AS Amount_40200
                      , SUM (tmpReportContainerSumm.SummPartner_calc)    AS SummPartner_calc
                      , SUM (tmpReportContainerSumm.SummPartner)         AS SummPartner
                      , SUM (tmpReportContainerSumm.SummPartner_10200)   AS SummPartner_10200
                      , SUM (tmpReportContainerSumm.SummPartner_10300)   AS SummPartner_10300
                 FROM (SELECT tmpReportContainerSumm.MovementId
                            , tmpReportContainerSumm.InfoMoneyId
                            , tmpReportContainerSumm.GoodsId
                            , tmpReportContainerSumm.GoodsKindId
                            , tmpReportContainerSumm.Price
                            , SUM (tmpReportContainerSumm.SummPartner)       AS SummPartner
                            , SUM (tmpReportContainerSumm.SummPartner_10200) AS SummPartner_10200
                            , SUM (tmpReportContainerSumm.SummPartner_10300) AS SummPartner_10300
                            , 0 AS Amount
                            , 0 AS AmountChangePercent
                            , 0 AS AmountPartner
                            , 0 AS Amount_10500
                            , 0 AS Amount_40200
                            , 0 AS SummPartner_calc
                       FROM tmpReportContainerSumm
                       GROUP BY tmpReportContainerSumm.MovementId
                              , tmpReportContainerSumm.InfoMoneyId
                              , tmpReportContainerSumm.GoodsId
                              , tmpReportContainerSumm.GoodsKindId
                              , tmpReportContainerSumm.Price
                      UNION ALL
                       SELECT tmpReportContainerSumm.MovementId
                            , tmpReportContainerSumm.InfoMoneyId
                            , tmpReportContainerSumm.GoodsId
                            , tmpReportContainerSumm.GoodsKindId
                            , tmpReportContainerSumm.Price
                            , 0 AS SummPartner
                            , 0 AS SummPartner_10200
                            , 0 AS SummPartner_10300

                            , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS Amount
                            , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS AmountChangePercent
                            , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800())                                                                                 THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS AmountPartner
                            , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10500())                                                                                                                           THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS Amount_10500
                            , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200())                                                                                 THEN MIContainer.Amount ELSE 0 END)                                                              AS Amount_40200
                            , SUM (CASE WHEN MIContainer.DescId <> zc_MIContainer_Count() 
                                             THEN 0
                                        WHEN tmpReportContainerSumm.PriceWithVAT = TRUE OR tmpReportContainerSumm.VATPercent = 0
                                                  -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки для Суммы округленной до 2-х знаков
                                             THEN CASE WHEN tmpReportContainerSumm.ChangePercent < 0 THEN CAST ( (1 + tmpReportContainerSumm.ChangePercent / 100) * CAST (tmpReportContainerSumm.Price / tmpReportContainerSumm.CountForPrice
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                       WHEN tmpReportContainerSumm.ChangePercent > 0 THEN CAST ( (1 + tmpReportContainerSumm.ChangePercent / 100) * CAST (tmpReportContainerSumm.Price / tmpReportContainerSumm.CountForPrice
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpReportContainerSumm.Price / tmpReportContainerSumm.CountForPrice
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2))
                                                  END
                                             -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учитывается в цене!!!
                                        ELSE CASE WHEN tmpReportContainerSumm.ChangePercent < 0 THEN CAST ( (1 + tmpReportContainerSumm.ChangePercent / 100) * CAST ((1 + tmpReportContainerSumm.VATPercent / 100) * CAST (tmpReportContainerSumm.Price / tmpReportContainerSumm.CountForPrice
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                  WHEN tmpReportContainerSumm.ChangePercent > 0 THEN CAST ( (1 + tmpReportContainerSumm.ChangePercent / 100) * CAST ((1 + tmpReportContainerSumm.VATPercent / 100) * CAST (tmpReportContainerSumm.Price / tmpReportContainerSumm.CountForPrice
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                  ELSE CAST ((1 + tmpReportContainerSumm.VATPercent / 100) * CAST (tmpReportContainerSumm.Price / tmpReportContainerSumm.CountForPrice
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                             END
                                             -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС округленной до 2-х знаков, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учитывается в цене!!!
                                             -- ...
                                   END) AS SummPartner_calc
                       FROM tmpReportContainerSumm
                            LEFT JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.MovementItemId = tmpReportContainerSumm.MovementItemId
                                                           -- AND (MIContainer.DescId = zc_MIContainer_Count() OR inDescId = zc_Movement_ReturnIn())
                                                           AND MIContainer.DescId = zc_MIContainer_Count()
                            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                                    ON MovementFloat_CurrencyValue.MovementId =  MIContainer.MovementId
                                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                                    ON MovementFloat_ParValue.MovementId = MIContainer.MovementId
                                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                                         ON MovementLinkObject_CurrencyDocument.MovementId = MIContainer.MovementId
                                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                        GROUP BY tmpReportContainerSumm.MovementId
                               , tmpReportContainerSumm.InfoMoneyId
                               , tmpReportContainerSumm.GoodsId
                               , tmpReportContainerSumm.GoodsKindId
                               , tmpReportContainerSumm.Price
                        ) AS tmpReportContainerSumm
                 GROUP BY tmpReportContainerSumm.MovementId
                        , tmpReportContainerSumm.InfoMoneyId
                        , tmpReportContainerSumm.GoodsId
                        , tmpReportContainerSumm.GoodsKindId
                        , tmpReportContainerSumm.Price
                )
       , tmpOperationGroup AS
                (SELECT tmpReportContainerSumm.InfoMoneyId
                      , tmpReportContainerSumm.GoodsId
                      , tmpReportContainerSumm.GoodsKindId
                      , SUM (tmpReportContainerSumm.Amount)              AS Amount
                      , SUM (tmpReportContainerSumm.AmountChangePercent) AS AmountChangePercent
                      , SUM (tmpReportContainerSumm.AmountPartner)       AS AmountPartner
                      , SUM (tmpReportContainerSumm.Amount_10500)        AS Amount_10500
                      , SUM (tmpReportContainerSumm.Amount_40200)        AS Amount_40200
                      , SUM (tmpReportContainerSumm.SummPartner)         AS SummPartner
                      , SUM (tmpReportContainerSumm.SummPartner_10200)   AS SummPartner_10200
                      , SUM (tmpReportContainerSumm.SummPartner_10300)   AS SummPartner_10300
                      , SUM (CASE WHEN tmpReportContainerSumm.AmountChangePercent = tmpReportContainerSumm.AmountPartner THEN tmpReportContainerSumm.SummPartner ELSE tmpReportContainerSumm.SummPartner_calc END) AS SummPartner_calc
                 FROM tmpOperationGroup_all AS tmpReportContainerSumm
                 GROUP BY tmpReportContainerSumm.InfoMoneyId
                        , tmpReportContainerSumm.GoodsId
                        , tmpReportContainerSumm.GoodsKindId
                )

    SELECT Object_GoodsGroup.ValueData            AS GoodsGroupName 
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_GoodsKind.ValueData             AS GoodsKindName
         , Object_Measure.ValueData               AS MeasureName
         , Object_TradeMark.ValueData             AS TradeMarkName

         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat                                AS Amount_Sh

         , (tmpOperationGroup.AmountChangePercent * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountChangePercent_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountChangePercent ELSE 0 END) :: TFloat                                AS AmountChangePercent_Sh
         
         , (tmpOperationGroup.AmountPartner * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPartner_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountPartner ELSE 0 END) :: TFloat                                AS AmountPartner_Sh

         , (tmpOperationGroup.Amount_10500 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_10500_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount_10500 ELSE 0 END) :: TFloat                                AS Amount_10500_Sh
         , (tmpOperationGroup.Amount_40200 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_40200_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount_40200 ELSE 0 END) :: TFloat                                AS Amount_40200_Sh

         , tmpOperationGroup.SummPartner_calc :: TFloat   AS SummPartner_calc
         , tmpOperationGroup.SummPartner :: TFloat        AS SummPartner
         , tmpOperationGroup.SummPartner_10200 :: TFloat  AS SummPartner_10200
         , tmpOperationGroup.SummPartner_10300 :: TFloat  AS SummPartner_10300
         , (tmpOperationGroup.SummPartner - tmpOperationGroup.SummPartner_calc) :: TFloat  AS SummDiff

         , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
         , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

     FROM tmpOperationGroup
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight	
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
   ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.12.14                                        * all
 13.05.14                                        * all
 16.04.14         add inUnitId
 13.04.14                                        * add zc_MovementFloat_ChangePercent
 08.04.14                                        * all
 05.04.14         * add SummPartner_calc. AmountChangePercent
 04.02.14         * 
 01.02.14                                        * All
 22.01.14         *
*/

-- тест
-- SELECT SUM (AmountPartner_Weight), SUM (SummPartner) FROM gpReport_GoodsMI (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inDescId:= zc_Movement_Sale(), inUnitId:= 0, inJuridicalId:= 0, inInfoMoneyId:= 0, inPaidKindId:= 0, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
