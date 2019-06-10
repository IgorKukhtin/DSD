 -- Function: gpReport_GoodsMI_byMovement_TEST ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovement_TEST (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovement_TEST (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_byMovement_TEST (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   , -- zc_Movement_Sale or zc_Movement_ReturnIn
    IN inUnitId       Integer   , 
    IN inJuridicalId  Integer   , 
    IN inInfoMoneyId  Integer   , -- Управленческая статья  
    IN inPaidKindId   Integer   , --
    IN inGoodsGroupId Integer   ,
    IN inGoodsId      Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (ItemName TVarChar, InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , Price TFloat
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

   DECLARE vbIsGoods_show Boolean;
BEGIN

    vbIsGoods_show:= TRUE;

    -- !!!т.к. нельзя когда много данных в гриде!!!
    IF inStartDate + (INTERVAL '1 DAY') < inEndDate AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0 AND COALESCE (inJuridicalId, 0) = 0
    THEN
        -- inStartDate:= inEndDate + (INTERVAL '1 DAY');
        vbIsGoods_show:= FALSE;
    ELSE
    -- !!!т.к. нельзя когда много данных в гриде!!!
    IF inStartDate + (INTERVAL '32 DAY') < inEndDate AND COALESCE (inGoodsId, 0) = 0
    THEN
        -- inStartDate:= inEndDate + (INTERVAL '1 DAY');
        vbIsGoods_show:= FALSE;
    END IF;
    END IF;


    vbIsGoods:= FALSE;
    vbIsUnit:= FALSE;

    -- Ограничения по товарам
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
    IF inGoodsId <> 0
    THEN
        -- устанавливается признак
        vbIsGoods:= TRUE;
        -- заполнение
        INSERT INTO _tmpGoods (GoodsId, MeasureId, Weight)
           SELECT Object_Goods.Id, ObjectLink_Goods_Measure.ChildObjectId, COALESCE (ObjectFloat_Weight.ValueData, 0)
           FROM Object AS Object_Goods
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object_Goods.Id= inGoodsId;
    ELSE 
    IF inGoodsGroupId <> 0
    THEN
        -- устанавливается признак
        vbIsGoods:= TRUE;
        -- заполнение
        INSERT INTO _tmpGoods (GoodsId, MeasureId, Weight)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId, ObjectLink_Goods_Measure.ChildObjectId, COALESCE (ObjectFloat_Weight.ValueData, 0)
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
       ;
    ELSE 
        -- устанавливается признак
        vbIsGoods:= FALSE;
        -- заполнение
        INSERT INTO _tmpGoods (GoodsId, MeasureId, Weight)
           SELECT Object_Goods.Id, ObjectLink_Goods_Measure.ChildObjectId, COALESCE (ObjectFloat_Weight.ValueData, 0)
           FROM Object AS Object_Goods
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object_Goods.DescId = zc_Object_Goods();
    END IF;
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
       , tmpListContainerSumm AS
                      (SELECT COALESCE (ContainerLO_Juridical.ObjectId, 0) AS JuridicalId
                            , COALESCE (ContainerLinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
                            , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MovementItem.ObjectId ELSE MovementLinkObject_Partner.ObjectId END AS PartnerId
                            , COALESCE (MovementLinkObject_Unit.ObjectId, 0) AS UnitId
                            , MovementItem.Id AS MovementItemId
                            , MovementItem.MovementId
                            , MovementItem.ObjectId AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                            , SUM (CASE WHEN inDescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE -1 * MIContainer.Amount END) AS SummPartner
                            , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200() -- Разница с оптовыми ценами
                                             THEN CASE WHEN inDescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE -1 * MIContainer.Amount END
                                        ELSE 0
                                   END) AS SummPartner_10200
                            , SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10300(), zc_Enum_AnalyzerId_ReturnInSumm_10300()) -- Скидка дополнительная
                                             THEN CASE WHEN inDescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE -1 * MIContainer.Amount END
                                        ELSE 0
                                   END) AS SummPartner_10300

                            , COALESCE (MIFloat_Price.ValueData, 0)
                              -- так переводится факт цена в валюту zc_Enum_Currency_Basis
                            * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                              AS Price
                            , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice

                            , MovementBoolean_PriceWithVAT.ValueData               AS PriceWithVAT
                            , COALESCE (MovementFloat_VATPercent.ValueData, 0)     AS VATPercent
                            , COALESCE (MovementFloat_ChangePercent.ValueData, 0)  AS ChangePercent
                            , _tmpGoods.MeasureId
                            , _tmpGoods.Weight
                       FROM (SELECT AnalyzerId, zc_MovementLinkObject_From() AS MLO_DescId_Unit, zc_MovementLinkObject_To() AS MLO_DescId_Partner FROM tmpAnalyzerId WHERE isSumm = TRUE AND isSale = TRUE AND isCost = FALSE AND inDescId = zc_Movement_Sale()
                            UNION ALL
                             SELECT AnalyzerId, zc_MovementLinkObject_To() AS MLO_DescId_Unit, zc_MovementLinkObject_From() AS MLO_DescId_Partner FROM tmpAnalyzerId WHERE isSumm = TRUE AND isSale = FALSE AND isCost = FALSE AND inDescId = zc_Movement_ReturnIn()
                            ) AS tmpAnalyzer
                            INNER JOIN MovementItemContainer AS MIContainer
                                                             ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                            AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                            -- AND MIContainer.DescId = zc_MIContainer_Summ()
                            INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                           ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId
                                                          AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                          AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                            INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                           ON ContainerLinkObject_InfoMoney.ContainerId = ContainerLO_Juridical.ContainerId
                                                          AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                          AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                            INNER JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                           ON ContainerLinkObject_PaidKind.ContainerId = ContainerLO_Juridical.ContainerId
                                                          AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                          AND (ContainerLinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = MIContainer.MovementId
                                                         AND MovementLinkObject_Unit.DescId = tmpAnalyzer.MLO_DescId_Unit
                             LEFT JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId

                             LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                                   AND MovementItem.DescId = zc_MI_Master()
                             LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                          ON MovementLinkObject_Partner.MovementId = MIContainer.MovementId
                                                         AND MovementLinkObject_Partner.DescId = CASE WHEN MIContainer.MovementDescId = zc_Movement_PriceCorrective() THEN zc_MovementLinkObject_Partner() ELSE tmpAnalyzer.MLO_DescId_Partner END

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
                                                       ON MovementBoolean_PriceWithVAT.MovementId =  MIContainer.MovementId
                                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                     ON MovementFloat_VATPercent.MovementId =  MIContainer.MovementId
                                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                     ON MovementFloat_ChangePercent.MovementId = MIContainer.MovementId
                                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                             LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                                     ON MovementFloat_CurrencyValue.MovementId =  MIContainer.MovementId
                                                    AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                             LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                                     ON MovementFloat_ParValue.MovementId = MIContainer.MovementId
                                                    AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                                          ON MovementLinkObject_CurrencyDocument.MovementId = MIContainer.MovementId
                                                         AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()

                       WHERE (_tmpUnit.UnitId > 0 OR vbIsUnit = FALSE)
                         AND (_tmpGoods.GoodsId > 0 OR vbIsGoods = FALSE)
                       GROUP BY ContainerLO_Juridical.ObjectId
                              , ContainerLinkObject_InfoMoney.ObjectId
                              , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MovementItem.ObjectId ELSE MovementLinkObject_Partner.ObjectId END
                              , MovementLinkObject_Unit.ObjectId
                              , MovementItem.Id
                              , MovementItem.MovementId
                              , MovementItem.ObjectId
                              , MILinkObject_GoodsKind.ObjectId
                              , MIFloat_Price.ValueData
                              , MIFloat_CountForPrice.ValueData
                              , MovementBoolean_PriceWithVAT.ValueData
                              , MovementFloat_VATPercent.ValueData
                              , MovementFloat_ChangePercent.ValueData
                              , MovementLinkObject_CurrencyDocument.ObjectId
                              , MovementFloat_CurrencyValue.ValueData
                              , MovementFloat_ParValue.ValueData
                              , _tmpGoods.MeasureId
                              , _tmpGoods.Weight
                      )
       , tmpOperationGroup_all AS
                (SELECT tmpListContainerSumm.MovementId
                      , tmpListContainerSumm.JuridicalId
                      , tmpListContainerSumm.PartnerId
                      , tmpListContainerSumm.InfoMoneyId
                      , tmpListContainerSumm.UnitId
                      -- , tmpListContainerSumm.GoodsId
                      -- , tmpListContainerSumm.GoodsKindId
                      -- , tmpListContainerSumm.MeasureId
                      -- , tmpListContainerSumm.Price
                      , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.GoodsId     ELSE 0 END AS GoodsId
                      , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.GoodsKindId ELSE 0 END AS GoodsKindId
                      , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.MeasureId   ELSE 0 END AS MeasureId
                      , CASE WHEN vbIsGoods_show = TRUE THEN tmpListContainerSumm.Price       ELSE 0 END AS Price
                      , SUM (tmpListContainerSumm.Amount)              AS Amount
                      , SUM (tmpListContainerSumm.Amount_Sh)           AS Amount_Sh
                      , SUM (tmpListContainerSumm.AmountChangePercent)    AS AmountChangePercent
                      , SUM (tmpListContainerSumm.AmountChangePercent_Sh) AS AmountChangePercent_Sh
                      , SUM (tmpListContainerSumm.AmountPartner)       AS AmountPartner
                      , SUM (tmpListContainerSumm.AmountPartner_Sh)    AS AmountPartner_Sh
                      , SUM (tmpListContainerSumm.Amount_10500)        AS Amount_10500
                      , SUM (tmpListContainerSumm.Amount_10500_Sh)     AS Amount_10500_Sh
                      , SUM (tmpListContainerSumm.Amount_40200)        AS Amount_40200
                      , SUM (tmpListContainerSumm.Amount_40200_Sh)     AS Amount_40200_Sh
                      , SUM (tmpListContainerSumm.SummPartner)         AS SummPartner
                      , SUM (tmpListContainerSumm.SummPartner_calc)    AS SummPartner_calc
                      , SUM (tmpListContainerSumm.SummPartner_10200)   AS SummPartner_10200
                      , SUM (tmpListContainerSumm.SummPartner_10300)   AS SummPartner_10300
                 FROM (SELECT tmpListContainerSumm.MovementId
                            , tmpListContainerSumm.JuridicalId
                            , tmpListContainerSumm.PartnerId
                            , tmpListContainerSumm.InfoMoneyId
                            , tmpListContainerSumm.UnitId
                            , tmpListContainerSumm.GoodsId
                            , tmpListContainerSumm.GoodsKindId
                            , tmpListContainerSumm.MeasureId
                            , tmpListContainerSumm.Price
                            , SUM (tmpListContainerSumm.SummPartner)       AS SummPartner
                            , SUM (tmpListContainerSumm.SummPartner_10200) AS SummPartner_10200
                            , SUM (tmpListContainerSumm.SummPartner_10300) AS SummPartner_10300
                            , 0 AS Amount
                            , 0 AS Amount_Sh
                            , 0 AS AmountChangePercent
                            , 0 AS AmountChangePercent_Sh
                            , 0 AS AmountPartner
                            , 0 AS AmountPartner_Sh
                            , 0 AS Amount_10500
                            , 0 AS Amount_10500_Sh
                            , 0 AS Amount_40200
                            , 0 AS Amount_40200_Sh
                            , 0 AS SummPartner_calc
                       FROM tmpListContainerSumm
                       GROUP BY tmpListContainerSumm.MovementId
                              , tmpListContainerSumm.JuridicalId
                              , tmpListContainerSumm.PartnerId
                              , tmpListContainerSumm.InfoMoneyId
                              , tmpListContainerSumm.UnitId
                              , tmpListContainerSumm.GoodsId
                              , tmpListContainerSumm.GoodsKindId
                              , tmpListContainerSumm.MeasureId
                              , tmpListContainerSumm.Price
                      UNION ALL
                       SELECT tmpListContainerSumm.MovementId
                            , tmpListContainerSumm.JuridicalId
                            , tmpListContainerSumm.PartnerId
                            , tmpListContainerSumm.InfoMoneyId
                            , tmpListContainerSumm.UnitId
                            , tmpListContainerSumm.GoodsId
                            , tmpListContainerSumm.GoodsKindId
                            , tmpListContainerSumm.MeasureId
                            , tmpListContainerSumm.Price
                            , 0 AS SummPartner
                            , 0 AS SummPartner_10200
                            , 0 AS SummPartner_10300
                            , SUM (MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END * CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Weight ELSE 1 END) AS Amount
                            , SUM (CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS Amount_Sh

                            , SUM (CASE WHEN                                                      MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END * CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Weight ELSE 1 END) AS AmountChangePercent
                            , SUM (CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() AND MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS AmountChangePercent_Sh

                            , SUM (CASE WHEN                                                      MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END * CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Weight ELSE 1 END) AS AmountPartner
                            , SUM (CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() AND MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS AmountPartner_Sh

                            , SUM (CASE WHEN                                                      MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10500()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END  * CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Weight ELSE 1 END) AS Amount_10500
                            , SUM (CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() AND MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10500()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS Amount_10500_Sh

                            , SUM (CASE WHEN                                                      MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() THEN tmpListContainerSumm.Weight ELSE 1 END) AS Amount_40200
                            , SUM (CASE WHEN tmpListContainerSumm.MeasureId = zc_Measure_Sh() AND MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END) AS Amount_40200_Sh

                            , SUM (CASE WHEN tmpListContainerSumm.PriceWithVAT = TRUE OR tmpListContainerSumm.VATPercent = 0
                                                  -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки для Суммы округленной до 2-х знаков
                                             THEN CASE WHEN tmpListContainerSumm.ChangePercent < 0 THEN CAST ( (1 + tmpListContainerSumm.ChangePercent / 100) * CAST (tmpListContainerSumm.Price / tmpListContainerSumm.CountForPrice
                                                          -- * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                       WHEN tmpListContainerSumm.ChangePercent > 0 THEN CAST ( (1 + tmpListContainerSumm.ChangePercent / 100) * CAST (tmpListContainerSumm.Price / tmpListContainerSumm.CountForPrice
                                                          -- * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpListContainerSumm.Price / tmpListContainerSumm.CountForPrice
                                                          -- * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2))
                                                  END
                                             -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учитывается в цене!!!
                                        ELSE CASE WHEN tmpListContainerSumm.ChangePercent < 0 THEN CAST ( (1 + tmpListContainerSumm.ChangePercent / 100) * CAST ((1 + tmpListContainerSumm.VATPercent / 100) * CAST (tmpListContainerSumm.Price / tmpListContainerSumm.CountForPrice
                                                          -- * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                  WHEN tmpListContainerSumm.ChangePercent > 0 THEN CAST ( (1 + tmpListContainerSumm.ChangePercent / 100) * CAST ((1 + tmpListContainerSumm.VATPercent / 100) * CAST (tmpListContainerSumm.Price / tmpListContainerSumm.CountForPrice
                                                          -- * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                  ELSE CAST ((1 + tmpListContainerSumm.VATPercent / 100) * CAST (tmpListContainerSumm.Price / tmpListContainerSumm.CountForPrice
                                                          -- * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                             END
                                             -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС округленной до 2-х знаков, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учитывается в цене!!!
                                             -- ...
                                   END) AS SummPartner_calc
                       FROM tmpListContainerSumm
                            LEFT JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.MovementItemId = tmpListContainerSumm.MovementItemId
                                                           AND MIContainer.DescId = zc_MIContainer_Count()
                       GROUP BY tmpListContainerSumm.MovementId
                              , tmpListContainerSumm.JuridicalId
                              , tmpListContainerSumm.PartnerId
                              , tmpListContainerSumm.InfoMoneyId
                              , tmpListContainerSumm.UnitId
                              , tmpListContainerSumm.GoodsId
                              , tmpListContainerSumm.GoodsKindId
                              , tmpListContainerSumm.MeasureId
                              , tmpListContainerSumm.Price
                        ) AS tmpListContainerSumm
                 GROUP BY tmpListContainerSumm.MovementId
                        , tmpListContainerSumm.JuridicalId
                        , tmpListContainerSumm.PartnerId
                        , tmpListContainerSumm.InfoMoneyId
                        , tmpListContainerSumm.UnitId
                        , tmpListContainerSumm.GoodsId
                        , tmpListContainerSumm.GoodsKindId
                        , tmpListContainerSumm.MeasureId
                        , tmpListContainerSumm.Price
                )
       , tmpOperationGroup AS
                (SELECT MovementDesc.ItemName
                      , Movement.InvNumber
                      , Movement.OperDate
                      , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                      , tmpListContainerSumm.JuridicalId
                      , tmpListContainerSumm.PartnerId
                      , tmpListContainerSumm.InfoMoneyId
                      , tmpListContainerSumm.UnitId
                      , tmpListContainerSumm.GoodsId
                      , tmpListContainerSumm.GoodsKindId
                      , tmpListContainerSumm.MeasureId
                      , tmpListContainerSumm.Price
                      , SUM (tmpListContainerSumm.Amount)              AS Amount
                      , SUM (tmpListContainerSumm.Amount_Sh)           AS Amount_Sh
                      , SUM (tmpListContainerSumm.AmountChangePercent)    AS AmountChangePercent
                      , SUM (tmpListContainerSumm.AmountChangePercent_Sh) AS AmountChangePercent_Sh
                      , SUM (tmpListContainerSumm.AmountPartner)       AS AmountPartner
                      , SUM (tmpListContainerSumm.AmountPartner_Sh)    AS AmountPartner_Sh
                      , SUM (tmpListContainerSumm.Amount_10500)        AS Amount_10500
                      , SUM (tmpListContainerSumm.Amount_10500_Sh)     AS Amount_10500_Sh
                      , SUM (tmpListContainerSumm.Amount_40200)        AS Amount_40200
                      , SUM (tmpListContainerSumm.Amount_40200_Sh)     AS Amount_40200_Sh
                      , SUM (tmpListContainerSumm.SummPartner)         AS SummPartner
                      , SUM (tmpListContainerSumm.SummPartner_10200)   AS SummPartner_10200
                      , SUM (tmpListContainerSumm.SummPartner_10300)   AS SummPartner_10300
                      , SUM (CASE WHEN tmpListContainerSumm.AmountChangePercent = tmpListContainerSumm.AmountPartner THEN tmpListContainerSumm.SummPartner ELSE tmpListContainerSumm.SummPartner_calc END) AS SummPartner_calc
                 FROM tmpOperationGroup_all AS tmpListContainerSumm
                      LEFT JOIN Movement ON Movement.Id = tmpListContainerSumm.MovementId
                      LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                      LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                             ON MovementDate_OperDatePartner.MovementId =  tmpListContainerSumm.MovementId
                                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                 GROUP BY MovementDesc.ItemName
                        , Movement.InvNumber
                        , Movement.OperDate
                        , MovementDate_OperDatePartner.ValueData
                        , tmpListContainerSumm.JuridicalId
                        , tmpListContainerSumm.PartnerId
                        , tmpListContainerSumm.InfoMoneyId
                        , tmpListContainerSumm.UnitId
                        , tmpListContainerSumm.GoodsId
                        , tmpListContainerSumm.GoodsKindId
                        , tmpListContainerSumm.MeasureId
                        , tmpListContainerSumm.Price
                )

    SELECT tmpOperationGroup.ItemName
         , tmpOperationGroup.InvNumber
         , tmpOperationGroup.OperDate
         , tmpOperationGroup.OperDatePartner
         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName
         , Object_Partner.ObjectCode   AS PartnerCode
         , Object_Partner.ValueData    AS PartnerName
         , Object_Unit.ObjectCode      AS UnitCode
         , Object_Unit.ValueData       AS UnitName
         , Object_GoodsGroup.ValueData            AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_GoodsKind.ValueData             AS GoodsKindName
         , Object_Measure.ValueData               AS MeasureName

         , tmpOperationGroup.Price :: TFloat AS Price

         , tmpOperationGroup.Amount :: TFloat    AS Amount_Weight
         , tmpOperationGroup.Amount_Sh :: TFloat AS Amount_Sh

         , tmpOperationGroup.AmountChangePercent :: TFloat    AS AmountChangePercent_Weight
         , tmpOperationGroup.AmountChangePercent_Sh :: TFloat AS AmountChangePercent_Sh
         
         , tmpOperationGroup.AmountPartner    :: TFloat AS AmountPartner_Weight
         , tmpOperationGroup.AmountPartner_Sh :: TFloat AS AmountPartner_Sh

         , tmpOperationGroup.Amount_10500    :: TFloat AS Amount_10500_Weight
         , tmpOperationGroup.Amount_10500_Sh :: TFloat AS Amount_10500_Sh
         , tmpOperationGroup.Amount_40200    :: TFloat AS Amount_40200_Weight
         , tmpOperationGroup.Amount_40200_Sh :: TFloat AS Amount_40200_Sh

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
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpOperationGroup.UnitId

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpOperationGroup.MeasureId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_byMovement_TEST (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.12.14                                        * all
 12.11.14                                        * add inGoodsId
 18.05.14                                        * all
 06.05.14                                        * add From... and To...
 13.04.14                                        * add zc_MovementFloat_ChangePercent
 08.04.14                                        * all
 05.04.14         * add SummChangePercent , AmountChangePercent
 05.02.14         * add inJuridicalId
 22.01.14         *
*/

-- тест
-- SELECT SUM (AmountPartner_Weight), SUM (SummPartner) FROM gpReport_GoodsMI_byMovement_TEST (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inDescId:= zc_Movement_Sale(), inUnitId:= 0, inJuridicalId:= 0, inInfoMoneyId:= 0, inPaidKindId:= 0, inGoodsGroupId:= 0, inGoodsId:=0, inSession:= zfCalc_UserAdmin());
