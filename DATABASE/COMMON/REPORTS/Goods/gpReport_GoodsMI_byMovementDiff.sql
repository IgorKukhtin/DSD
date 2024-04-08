-- Function: gpReport_GoodsMI_byMovementDiff ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovementDif (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovementDiff (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_byMovementDiff (
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
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , Price TFloat
             , Amount_Weight TFloat, Amount_Sh TFloat
             , AmountChangePercent_Weight TFloat, AmountChangePercent_Sh TFloat
             , AmountPartner_Weight TFloat, AmountPartner_Sh TFloat
             , Amount_40200_Weight TFloat, Amount_40200_Sh TFloat
             , SummPartner_calc TFloat
             , SummPartner TFloat
             , SummDiff TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             )   
AS
$BODY$
   DECLARE vbIsGoods Boolean;
   DECLARE vbIsUnit Boolean;
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    vbIsGoods:= FALSE;
    vbIsUnit:= FALSE;

    -- Ограничения по товарам
  --CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        -- устанавливается признак
        vbIsGoods:= TRUE;
        -- заполнение
      --INSERT INTO _tmpGoods (GoodsId)
      --   SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    /*ELSE 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();*/
    END IF;

    -- Ограничения по подразделениям
  --CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    IF inUnitId <> 0
    THEN
        -- устанавливается признак
        vbIsUnit:= TRUE;
        -- заполнение
      --INSERT INTO _tmpUnit (UnitId)
      --   SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup;
    /*ELSE
        INSERT INTO _tmpUnit (UnitId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Unit();*/
    END IF;


    -- Результат
    RETURN QUERY
    WITH _tmpGoods AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect WHERE inGoodsGroupId <> 0)
       , _tmpUnit AS (SELECT lflfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lflfSelect WHERE inUnitId <> 0)

       , tmpAnalyzer AS (SELECT AnalyzerId, isSale, isCost, isSumm, FALSE AS isLoss
                         FROM Constant_ProfitLoss_AnalyzerId_View
                         WHERE (isSale = TRUE  AND isCost = FALSE AND inDescId = zc_Movement_Sale())
                            OR (isSale = FALSE AND isCost = FALSE AND inDescId = zc_Movement_ReturnIn())
                        )
       , tmpMI_diff AS (SELECT MovementItem.MovementId
                             , MovementItem.Id AS MovementItemId
                             , MovementItem.ObjectId AS GoodsId
                        FROM MovementDate AS MovementDate_OperDatePartner
                             INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                                AND Movement.DescId = inDescId
                                                AND Movement.StatusId = zc_Enum_Status_Complete()
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                             LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                         ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                        WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                          AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                          AND (_tmpGoods.GoodsId > 0 OR vbIsGoods = FALSE)
                          AND CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MovementItem.Amount END
                              <> COALESCE (MIFloat_AmountPartner.ValueData, 0)
                       )
           , tmpMIReport AS (SELECT tmpMI_diff.MovementItemId
                                  , tmpMI_diff.MovementId
                                  , tmpMI_diff.GoodsId
                                  , MIContainer.ObjectIntId_analyzer AS GoodsKindId
                                  , MIContainer.ContainerId
                                  , MIContainer.ContainerId_analyzer
                                  , MIContainer.AnalyzerId
                                  , MIContainer.WhereObjectId_analyzer AS UnitId
                                  , MIContainer.ObjectExtId_analyzer   AS PartnerId
                                  , MIContainer.MovementDescId
                                  , MIContainer.DescId
                                  , MIContainer.Amount
                             FROM tmpMI_diff
                                  INNER JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.MovementItemId = tmpMI_diff.MovementItemId
                                                                  AND MIContainer.MovementId     = tmpMI_diff.MovementId
                                  INNER JOIN tmpAnalyzer ON tmpAnalyzer.AnalyzerId = MIContainer.AnalyzerId
                                  LEFT JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                             WHERE (_tmpUnit.UnitId > 0 OR vbIsUnit = FALSE)
                            )
       , tmpReportContainerSumm AS
                      (SELECT ContainerLO_Juridical.ObjectId         AS JuridicalId
                            , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                            , tmpMIReport.PartnerId
                            , tmpMIReport.UnitId
                            , tmpMIReport.MovementId
                            , tmpMIReport.MovementItemId
                            , tmpMIReport.GoodsId
                            , tmpMIReport.GoodsKindId

                            , COALESCE (MIFloat_Price.ValueData, 0)
                              -- так переводится в валюту zc_Enum_Currency_Basis
                            * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                              AS Price
                            , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice

                               -- 1.3. Сумма, без AnalyzerId (на самом деле для OperCount_Partner)
                            , (CASE WHEN tmpMIReport.MovementDescId = zc_Movement_Sale()     AND tmpMIReport.DescId = zc_MIContainer_Summ() THEN  1 * tmpMIReport.Amount -- знак наоборот т.к. это проводка покупателя
                                    WHEN tmpMIReport.MovementDescId = zc_Movement_ReturnIn() AND tmpMIReport.DescId = zc_MIContainer_Summ() THEN -1 * tmpMIReport.Amount -- знак наоборот т.к. это проводка покупателя
                                    ELSE 0
                               END) AS SummPartner

                               -- 1.1. Кол-во, без AnalyzerId
                            , (CASE WHEN tmpMIReport.MovementDescId = zc_Movement_Sale()     AND tmpMIReport.DescId = zc_MIContainer_Count() THEN -1 * tmpMIReport.Amount
                                    WHEN tmpMIReport.MovementDescId = zc_Movement_ReturnIn() AND tmpMIReport.DescId = zc_MIContainer_Count() THEN  1 * tmpMIReport.Amount
                                    ELSE 0
                               END) AS Amount

                              -- 2.1.1. Кол-во - со Скидкой за вес
                            , (CASE WHEN tmpMIReport.MovementDescId = zc_Movement_Sale()     AND tmpMIReport.DescId = zc_MIContainer_Count() AND tmpMIReport.AnalyzerId NOT IN (zc_Enum_AnalyzerId_SaleCount_10500()) THEN -1 * tmpMIReport.Amount
                                    WHEN tmpMIReport.MovementDescId = zc_Movement_ReturnIn() AND tmpMIReport.DescId = zc_MIContainer_Count() THEN  1 * tmpMIReport.Amount
                                    ELSE 0
                               END) AS AmountChangePercent
                              -- 2.1.2. Кол-во - Скидка за вес
                            , (CASE WHEN tmpMIReport.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() THEN -1 * tmpMIReport.Amount
                                    ELSE 0
                               END) AS Amount_10500

                              -- 3.1. Кол-во Разница в весе
                            , (CASE WHEN tmpMIReport.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN 1 * tmpMIReport.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                    WHEN tmpMIReport.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN 1 * tmpMIReport.Amount -- !!! для возврата со знаком - наоборот, т.к. приход!!!
                                    ELSE 0
                               END) AS Amount_40200

                              -- 5.1. Кол-во у покупателя
                            , (CASE WHEN tmpMIReport.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * tmpMIReport.Amount
                                    WHEN tmpMIReport.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * tmpMIReport.Amount
                                    ELSE 0
                               END) AS AmountPartner


                            , MovementBoolean_PriceWithVAT.ValueData               AS PriceWithVAT
                            , COALESCE (MovementFloat_VATPercent.ValueData, 0)     AS VATPercent
                            , COALESCE (MovementFloat_ChangePercent.ValueData, 0)  AS ChangePercent
                       FROM tmpMIReport

                             LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                            ON ContainerLO_Juridical.ContainerId = tmpMIReport.ContainerId_analyzer
                                                           AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                            ON ContainerLinkObject_InfoMoney.ContainerId = tmpMIReport.ContainerId_analyzer
                                                           AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                            ON ContainerLinkObject_PaidKind.ContainerId = tmpMIReport.ContainerId_analyzer
                                                           AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = tmpMIReport.MovementItemId
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                         ON MIFloat_CountForPrice.MovementItemId = tmpMIReport.MovementItemId
                                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                             LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                                     ON MovementFloat_CurrencyValue.MovementId = tmpMIReport.MovementId
                                                    AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                             LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                                     ON MovementFloat_ParValue.MovementId = tmpMIReport.MovementId
                                                    AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                                          ON MovementLinkObject_CurrencyDocument.MovementId = tmpMIReport.MovementId
                                                         AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()

                             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                       ON MovementBoolean_PriceWithVAT.MovementId =  tmpMIReport.MovementId
                                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                     ON MovementFloat_VATPercent.MovementId =  tmpMIReport.MovementId
                                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                     ON MovementFloat_ChangePercent.MovementId = tmpMIReport.MovementId
                                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                       WHERE (ContainerLinkObject_PaidKind.ObjectId  = inPaidKindId  OR COALESCE (inPaidKindId, 0)  = 0)
                         AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                         AND (ContainerLO_Juridical.ObjectId         = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                      )

       , tmpOperationGroup AS
                (SELECT Movement.InvNumber
                      , Movement.OperDate
                      , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                      , tmpReportContainerSumm.JuridicalId
                      , tmpReportContainerSumm.PartnerId
                      , tmpReportContainerSumm.InfoMoneyId
                      , tmpReportContainerSumm.UnitId
                      , tmpReportContainerSumm.GoodsId
                      , (tmpReportContainerSumm.GoodsKindId) AS GoodsKindId
                      , tmpReportContainerSumm.Price
                      , SUM (tmpReportContainerSumm.Amount)              AS Amount
                      , SUM (tmpReportContainerSumm.AmountChangePercent) AS AmountChangePercent
                      , SUM (tmpReportContainerSumm.AmountPartner)       AS AmountPartner
                      , SUM (tmpReportContainerSumm.Amount_40200)        AS Amount_40200
                      , SUM (tmpReportContainerSumm.SummPartner_calc)    AS SummPartner_calc
                      , SUM (tmpReportContainerSumm.SummPartner)         AS SummPartner
                 FROM (SELECT tmpReportContainerSumm.MovementId
                            , tmpReportContainerSumm.JuridicalId
                            , tmpReportContainerSumm.InfoMoneyId
                            , tmpReportContainerSumm.PartnerId
                            , tmpReportContainerSumm.UnitId
                            , tmpReportContainerSumm.GoodsId
                            , tmpReportContainerSumm.GoodsKindId
                            , tmpReportContainerSumm.Price
                            , tmpReportContainerSumm.CountForPrice
                            , SUM (tmpReportContainerSumm.SummPartner)         AS SummPartner
                            , SUM (tmpReportContainerSumm.Amount)              AS Amount
                            , SUM (tmpReportContainerSumm.AmountChangePercent) AS AmountChangePercent
                            , SUM (tmpReportContainerSumm.AmountPartner)       AS AmountPartner
                            , SUM (tmpReportContainerSumm.Amount_40200)        AS Amount_40200

                            , SUM (CASE WHEN tmpReportContainerSumm.PriceWithVAT = TRUE OR tmpReportContainerSumm.VATPercent = 0
                                                  -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки для Суммы округленной до 2-х знаков
                                             THEN CASE WHEN tmpReportContainerSumm.ChangePercent <> 0 THEN CAST ( (1 + tmpReportContainerSumm.ChangePercent / 100) * (tmpReportContainerSumm.Price / tmpReportContainerSumm.CountForPrice) AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpReportContainerSumm.Price / tmpReportContainerSumm.CountForPrice AS NUMERIC (16, 2))
                                                  END
                                                * tmpReportContainerSumm.AmountChangePercent
                                                  -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учитывается в цене!!!
                                             ELSE CASE WHEN tmpReportContainerSumm.ChangePercent <> 0 THEN CAST ( (1 + tmpReportContainerSumm.ChangePercent / 100) * (tmpReportContainerSumm.Price / tmpReportContainerSumm.CountForPrice) * (1 + tmpReportContainerSumm.VATPercent / 100) AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpReportContainerSumm.Price / tmpReportContainerSumm.CountForPrice * (1 + tmpReportContainerSumm.VATPercent / 100) AS NUMERIC (16, 2))
                                                  END
                                                * tmpReportContainerSumm.AmountChangePercent
                                             -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС округленной до 2-х знаков, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учитывается в цене!!!
                                             -- ...
                                   END) AS SummPartner_calc
                       FROM tmpReportContainerSumm
                       GROUP BY tmpReportContainerSumm.MovementId
                              , tmpReportContainerSumm.JuridicalId
                              , tmpReportContainerSumm.InfoMoneyId
                              , tmpReportContainerSumm.PartnerId
                              , tmpReportContainerSumm.UnitId
                              , tmpReportContainerSumm.GoodsId
                              , tmpReportContainerSumm.GoodsKindId
                              , tmpReportContainerSumm.Price
                              , tmpReportContainerSumm.CountForPrice
                      ) AS tmpReportContainerSumm
                      LEFT JOIN Movement ON Movement.Id = tmpReportContainerSumm.MovementId

                      LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                             ON MovementDate_OperDatePartner.MovementId =  tmpReportContainerSumm.MovementId
                                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                 GROUP BY Movement.InvNumber
                        , Movement.OperDate
                        , MovementDate_OperDatePartner.ValueData
                        , tmpReportContainerSumm.JuridicalId
                        , tmpReportContainerSumm.PartnerId
                        , tmpReportContainerSumm.InfoMoneyId
                        , tmpReportContainerSumm.UnitId
                        , tmpReportContainerSumm.GoodsId
                        , tmpReportContainerSumm.GoodsKindId
                        , tmpReportContainerSumm.Price
                )

    SELECT tmpOperationGroup.InvNumber
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

         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat                                AS Amount_Sh

         , (tmpOperationGroup.AmountChangePercent * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountChangePercent_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountChangePercent ELSE 0 END) :: TFloat                                AS AmountChangePercent_Sh
         
         , (tmpOperationGroup.AmountPartner * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPartner_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.AmountPartner ELSE 0 END) :: TFloat                                AS AmountPartner_Sh

         , (tmpOperationGroup.Amount_40200 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_40200_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount_40200 ELSE 0 END) :: TFloat                                AS Amount_40200_Sh

         , tmpOperationGroup.SummPartner_calc :: TFloat   AS SummPartner_calc
         , tmpOperationGroup.SummPartner :: TFloat        AS SummPartner
         , (tmpOperationGroup.SummPartner - tmpOperationGroup.SummPartner_calc) :: TFloat AS SummDiff

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

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.12.14                                        * all
 18.05.14                                        * all
 08.04.14                                        * all
 04.04.14         *
*/

-- тест
-- SELECT SUM (AmountPartner_Weight), SUM (SummPartner) FROM gpReport_GoodsMI_byMovementDiff (inStartDate:= '01.01.2020', inEndDate:= '01.01.2020', inDescId:= zc_Movement_Sale(), inUnitId:= 0, inJuridicalId:= 0, inInfoMoneyId:= 0, inPaidKindId:= 0, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
