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

    WITH tmpAnalyzerId AS (SELECT * FROM Constant_ProfitLoss_AnalyzerId_View)
           , tmpAnalyzer AS (SELECT * FROM tmpAnalyzerId WHERE isSale = TRUE AND (isCost = FALSE OR isSumm = FALSE) AND inDescId = zc_Movement_Sale()
                            UNION ALL
                             SELECT * FROM tmpAnalyzerId WHERE isSale = FALSE AND (isCost = FALSE OR isSumm = FALSE) AND inDescId = zc_Movement_ReturnIn()
                            ) 
           /*, tmpListContainer AS (SELECT ContainerLO_Juridical.ContainerId
                                       , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                  FROM ContainerLinkObject AS ContainerLO_Juridical
                                       INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                      ON ContainerLinkObject_InfoMoney.ContainerId = ContainerLO_Juridical.ContainerId
                                                                     AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                     AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                                       INNER JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                                      ON ContainerLinkObject_PaidKind.ContainerId = ContainerLO_Juridical.ContainerId
                                                                     AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                     AND (ContainerLinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                                  WHERE ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                    AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                            )*/
       , tmpOperationGroup AS
                      (SELECT ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                            , MIContainer.ObjectId_Analyzer AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                            , SUM (CASE WHEN tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE
                                             THEN MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END
                                        ELSE 0
                                   END) AS SummPartner
                            , SUM (CASE WHEN /*tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE AND*/ MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200() -- Разница с оптовыми ценами(акции)
                                             THEN MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                        ELSE 0
                                   END) AS SummPartner_10200
                            , SUM (CASE WHEN /*tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE AND*/ MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10300(), zc_Enum_AnalyzerId_ReturnInSumm_10300()) -- Скидка дополнительная
                                             THEN MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                        ELSE 0
                                   END) AS SummPartner_10300

                            , SUM (CASE WHEN tmpAnalyzer.isSumm = FALSE /*AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = inDescId*/
                                             THEN MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                        ELSE 0
                                   END) AS Amount
                            , SUM (CASE WHEN /*tmpAnalyzer.isSumm = FALSE AND*/ MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) /*AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = inDescId*/
                                             THEN MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                        ELSE 0
                                   END) AS AmountChangePercent
                            , SUM (CASE WHEN /*tmpAnalyzer.isSumm = FALSE AND*/ MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800()) /*AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = inDescId*/
                                             THEN MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                        ELSE 0
                                   END) AS AmountPartner

                            , SUM (CASE WHEN /*tmpAnalyzer.isSumm = FALSE AND*/ MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10500()) /*AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = inDescId*/
                                             THEN MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                        ELSE 0
                                   END) AS Amount_10500
                            , SUM (CASE WHEN /*tmpAnalyzer.isSumm = FALSE AND*/ MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) /*AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = inDescId*/
                                             THEN MIContainer.Amount
                                        ELSE 0
                                   END) AS Amount_40200

                            , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_PriceCorrective(), zc_Movement_Service())
                                             THEN MIContainer.Amount
                                        WHEN tmpAnalyzer.isSumm = TRUE -- OR MIContainer.DescId = zc_MIContainer_Summ() OR MIContainer.MovementDescId <> inDescId
                                             THEN 0
                                        /*WHEN tmpReportContainerSumm.AmountChangePercent = tmpReportContainerSumm.AmountPartner THEN tmpReportContainerSumm.SummPartner
                                             THEN 0*/
                                        WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE OR COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0
                                                  -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки для Суммы округленной до 2-х знаков
                                             THEN CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN CAST ( (1 + COALESCE (MovementFloat_ChangePercent.ValueData, 0) / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                       WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN CAST ( (1 + COALESCE (MovementFloat_ChangePercent.ValueData, 0) / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                       ELSE CAST (COALESCE (MIFloat_Price.ValueData, 0) / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2))
                                                  END
                                             -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учитывается в цене!!!
                                        ELSE CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN CAST ( (1 + COALESCE (MovementFloat_ChangePercent.ValueData, 0) / 100) * CAST ((1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                  WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN CAST ( (1 + COALESCE (MovementFloat_ChangePercent.ValueData, 0) / 100) * CAST ((1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                  ELSE CAST ((1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                                          * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800(), zc_Enum_AnalyzerId_SaleCount_40200(), zc_Enum_AnalyzerId_ReturnInCount_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                             END
                                             -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС округленной до 2-х знаков, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учитывается в цене!!!
                                             -- ...
                                   END) AS SummPartner_calc

                       FROM tmpAnalyzer
                            INNER JOIN MovementItemContainer AS MIContainer
                                                             ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                            AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                            -- AND MIContainer.DescId = zc_MIContainer_Summ()
                                                            -- AND MIContainer.MovementDescId <> zc_Movement_ReturnIn()
                            -- INNER JOIN tmpAnalyzer ON tmpAnalyzer.AnalyzerId = MIContainer.AnalyzerId

                                  INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                 ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_Analyzer
                                                                AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                 ON ContainerLinkObject_InfoMoney.ContainerId = MIContainer.ContainerId_Analyzer
                                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                                                                -- AND ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_30101()
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                                 ON ContainerLinkObject_PaidKind.ContainerId = MIContainer.ContainerId_Analyzer
                                                                AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                -- AND (ContainerLinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)

                             LEFT JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_Analyzer
                             LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
           
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MIContainer.MovementItemId
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                         ON MIFloat_CountForPrice.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                                    ON MovementFloat_CurrencyValue.MovementId =  MIContainer.MovementId
                                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                                    ON MovementFloat_ParValue.MovementId = MIContainer.MovementId
                                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                                         ON MovementLinkObject_CurrencyDocument.MovementId = MIContainer.MovementId
                                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()

                             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                       ON MovementBoolean_PriceWithVAT.MovementId =  MIContainer.MovementId
                                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                     ON MovementFloat_VATPercent.MovementId =  MIContainer.MovementId
                                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                     ON MovementFloat_ChangePercent.MovementId = MIContainer.MovementId
                                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                         WHERE (_tmpUnit.UnitId > 0 OR vbIsUnit = FALSE)
                           AND (_tmpGoods.GoodsId > 0 OR vbIsGoods = FALSE)
                       GROUP BY ContainerLinkObject_InfoMoney.ObjectId
                              , MIContainer.ObjectId_Analyzer
                              , MILinkObject_GoodsKind.ObjectId
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
