-- Function: gpReport_GoodsMI_byMovementDif ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovementDif (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_byMovementDif (
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
             , SummPartner_calc TFloat
             , SummPartner TFloat
             , SummDif TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             )   
AS
$BODY$
BEGIN
    -- Ограничения по товарам
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;

    -- Ограничения по подразделениям
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    IF inUnitId <> 0
    THEN
        INSERT INTO _tmpUnit (UnitId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup;
    ELSE
        INSERT INTO _tmpUnit (UnitId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Unit();
    END IF;


    -- Результат
    RETURN QUERY
   WITH tmpMI_diff AS  (SELECT MovementItem.MovementId
                             , MovementItem.Id AS MovementItemId
                             , MovementItem.ObjectId AS GoodsId
                        FROM Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                         ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = inDescId
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MovementItem.Amount END
                              <> COALESCE (MIFloat_AmountPartner.ValueData, 0)
                       )

       , tmpProfitLoss AS (SELECT ProfitLossId AS Id, zc_MovementLinkObject_From() AS MLO_DescId, zc_MovementLinkObject_To() AS MLO_Partner_DescId  FROM Constant_ProfitLoss_Sale_ReturnIn_View WHERE isSale = TRUE AND isCost = FALSE AND inDescId = zc_Movement_Sale()
                          UNION ALL
                           SELECT ProfitLossId AS Id, zc_MovementLinkObject_To() AS MLO_DescId, zc_MovementLinkObject_From() AS MLO_Partner_DescId FROM Constant_ProfitLoss_Sale_ReturnIn_View WHERE isSale = FALSE AND isCost = FALSE AND inDescId = zc_Movement_ReturnIn()
                          )
           , tmpMIReport AS (SELECT tmpMI_diff.MovementItemId
                                  , tmpMI_diff.MovementId
                                  , tmpMI_diff.GoodsId
                                  , CASE WHEN MIReport.ActiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                              THEN zc_Enum_AccountKind_Passive()
                                         WHEN MIReport.PassiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                              THEN zc_Enum_AccountKind_Active()
                                    END AS AccountKindId
                                  , CASE WHEN MIReport.ActiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                              THEN MIReport.PassiveContainerId
                                         WHEN MIReport.PassiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                              THEN MIReport.ActiveContainerId
                                    END AS ContainerId
                                  , CASE WHEN MIReport.ActiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                              THEN MIReport.ActiveContainerId
                                         WHEN MIReport.PassiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                              THEN MIReport.PassiveContainerId
                                    END AS ContainerId_ProfitLoss
                                  , MIReport.Amount
                             FROM tmpMI_diff
                                  INNER JOIN MovementItemReport AS MIReport ON MIReport.MovementItemId = tmpMI_diff.MovementItemId
                             WHERE MIReport.ActiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                OR MIReport.PassiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                            )
       , tmpReportContainerSumm AS
                      (SELECT ContainerLO_Juridical.ObjectId AS JuridicalId
                            , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                            , COALESCE (MovementLinkObject_Partner.ObjectId, 0) AS PartnerId
                            , COALESCE (MovementLinkObject_Unit.ObjectId, 0) AS UnitId
                            , tmpMIReport.MovementId
                            , tmpMIReport.MovementItemId
                            , tmpMIReport.GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                            , COALESCE (MIFloat_Price.ValueData, 0)
                            * CASE WHEN COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis() THEN 1 ELSE CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_CurrencyValue.ValueData / MovementFloat_ParValue.ValueData ELSE 0 END END
                              AS Price
                            , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice
                            , SUM (CASE WHEN (tmpMIReport.AccountKindId = zc_Enum_AccountKind_Active() AND inDescId = zc_Movement_Sale())
                                              OR (tmpMIReport.AccountKindId = zc_Enum_AccountKind_Passive() AND inDescId = zc_Movement_ReturnIn())
                                             THEN 1
                                        ELSE -1
                                   END * tmpMIReport.Amount) AS SummPartner
                            , MovementBoolean_PriceWithVAT.ValueData               AS PriceWithVAT
                            , COALESCE (MovementFloat_VATPercent.ValueData, 0)     AS VATPercent
                            , COALESCE (MovementFloat_ChangePercent.ValueData, 0)  AS ChangePercent
                       FROM tmpMIReport
                             INNER JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                                            ON ContainerLO_ProfitLoss.ContainerId = tmpMIReport.ContainerId_ProfitLoss
                                                           AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                             INNER JOIN tmpProfitLoss ON tmpProfitLoss.Id = ContainerLO_ProfitLoss.ObjectId

                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = tmpMIReport.MovementId
                                                          AND MovementLinkObject_Unit.DescId = tmpProfitLoss.MLO_DescId
                             INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId

                             INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                            ON ContainerLO_Juridical.ContainerId = tmpMIReport.ContainerId
                                                           AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                           AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                             INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                            ON ContainerLinkObject_InfoMoney.ContainerId = tmpMIReport.ContainerId
                                                           AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                           AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                             INNER JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                            ON ContainerLinkObject_PaidKind.ContainerId = tmpMIReport.ContainerId
                                                           AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                           AND (ContainerLinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = tmpMIReport.MovementItemId
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = tmpMIReport.MovementItemId
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                         ON MIFloat_CountForPrice.MovementItemId = tmpMIReport.MovementItemId
                                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                          ON MovementLinkObject_Partner.MovementId = tmpMIReport.MovementId
                                                         AND MovementLinkObject_Partner.DescId = tmpProfitLoss.MLO_Partner_DescId
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
                       GROUP BY ContainerLO_Juridical.ObjectId
                              , ContainerLinkObject_InfoMoney.ObjectId
                              , MovementLinkObject_Partner.ObjectId
                              , MovementLinkObject_Unit.ObjectId
                              , tmpMIReport.MovementId
                              , tmpMIReport.MovementItemId
                              , tmpMIReport.GoodsId
                              , MILinkObject_GoodsKind.ObjectId
                              , MIFloat_Price.ValueData
                              , MIFloat_CountForPrice.ValueData
                              , MovementLinkObject_CurrencyDocument.ObjectId
                              , MovementFloat_CurrencyValue.ValueData
                              , MovementFloat_ParValue.ValueData
                              , MovementBoolean_PriceWithVAT.ValueData
                              , MovementFloat_VATPercent.ValueData
                              , MovementFloat_ChangePercent.ValueData
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
                      , MIN (tmpReportContainerSumm.GoodsKindId) AS GoodsKindId
                      , tmpReportContainerSumm.Price
                      , SUM (tmpReportContainerSumm.Amount) AS Amount
                      , SUM (tmpReportContainerSumm.AmountChangePercent) AS AmountChangePercent
                      , SUM (tmpReportContainerSumm.AmountPartner) AS AmountPartner
                      , SUM (tmpReportContainerSumm.SummPartner_calc) AS SummPartner_calc
                      , SUM (tmpReportContainerSumm.SummPartner) AS SummPartner
                 FROM (SELECT tmpReportContainerSumm.MovementId
                            , tmpReportContainerSumm.JuridicalId
                            , tmpReportContainerSumm.InfoMoneyId
                            , tmpReportContainerSumm.PartnerId
                            , tmpReportContainerSumm.UnitId
                            , tmpReportContainerSumm.GoodsId
                            , tmpReportContainerSumm.GoodsKindId
                            , tmpReportContainerSumm.Price
                            , tmpReportContainerSumm.CountForPrice
                            , SUM (tmpReportContainerSumm.SummPartner) AS SummPartner
                            , 0 AS Amount
                            , 0 AS AmountChangePercent
                            , 0 AS AmountPartner
                            , 0 AS SummPartner_calc
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
                      UNION ALL
                       SELECT tmpReportContainerSumm.MovementId
                            , tmpReportContainerSumm.JuridicalId
                            , tmpReportContainerSumm.InfoMoneyId
                            , tmpReportContainerSumm.PartnerId
                            , tmpReportContainerSumm.UnitId
                            , tmpReportContainerSumm.GoodsId
                            , tmpReportContainerSumm.GoodsKindId
                            , tmpReportContainerSumm.Price
                            , tmpReportContainerSumm.CountForPrice
                            , 0 AS SummPartner
                            , SUM (MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS Amount
                            , SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS AmountChangePercent
                            , SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800())                                      THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS AmountPartner
                            , SUM (CASE WHEN tmpReportContainerSumm.PriceWithVAT = TRUE OR tmpReportContainerSumm.VATPercent = 0
                                                  -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки для Суммы округленной до 2-х знаков
                                             THEN CASE WHEN tmpReportContainerSumm.ChangePercent < 0 THEN CAST ( (1 + tmpReportContainerSumm.ChangePercent / 100) * CAST (tmpReportContainerSumm.Price / CASE WHEN tmpReportContainerSumm.CountForPrice > 0 THEN tmpReportContainerSumm.CountForPrice ELSE 1 END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                       WHEN tmpReportContainerSumm.ChangePercent > 0 THEN CAST ( (1 + tmpReportContainerSumm.ChangePercent / 100) * CAST (tmpReportContainerSumm.Price / CASE WHEN tmpReportContainerSumm.CountForPrice > 0 THEN tmpReportContainerSumm.CountForPrice ELSE 1 END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpReportContainerSumm.Price / CASE WHEN tmpReportContainerSumm.CountForPrice > 0 THEN tmpReportContainerSumm.CountForPrice ELSE 1 END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2))
                                                  END
                                             -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учитывается в цене!!!
                                        ELSE CASE WHEN tmpReportContainerSumm.ChangePercent < 0 THEN CAST ( (1 + tmpReportContainerSumm.ChangePercent / 100) * CAST ((1 + tmpReportContainerSumm.VATPercent / 100) * CAST (tmpReportContainerSumm.Price / CASE WHEN tmpReportContainerSumm.CountForPrice > 0 THEN tmpReportContainerSumm.CountForPrice ELSE 1 END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                  WHEN tmpReportContainerSumm.ChangePercent > 0 THEN CAST ( (1 + tmpReportContainerSumm.ChangePercent / 100) * CAST ((1 + tmpReportContainerSumm.VATPercent / 100) * CAST (tmpReportContainerSumm.Price / CASE WHEN tmpReportContainerSumm.CountForPrice > 0 THEN tmpReportContainerSumm.CountForPrice ELSE 1 END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                  ELSE CAST ((1 + tmpReportContainerSumm.VATPercent / 100) * CAST (tmpReportContainerSumm.Price / CASE WHEN tmpReportContainerSumm.CountForPrice > 0 THEN tmpReportContainerSumm.CountForPrice ELSE 1 END
                                                          * CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_ProfitLossDirection_10400(), zc_Enum_ProfitLossDirection_10800(), zc_Enum_ProfitLossDirection_40200()) THEN MIContainer.Amount ELSE 0 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END
                                                            AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                             END
                                             -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС округленной до 2-х знаков, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учитывается в цене!!!
                                             -- ...
                                   END) AS SummPartner_calc
                       FROM tmpReportContainerSumm
                            LEFT JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.MovementItemId = tmpReportContainerSumm.MovementItemId
                                                           AND MIContainer.DescId = zc_MIContainer_Count()
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
--                        , tmpReportContainerSumm.GoodsKindId
                      , tmpReportContainerSumm.Price
                 /*HAVING SUM (tmpReportContainerSumm.AmountChangePercent)
                     <> SUM (tmpReportContainerSumm.AmountPartner)*/
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
         , tmpOperationGroup.SummPartner_calc :: TFloat   AS SummPartner_calc
         , tmpOperationGroup.SummPartner :: TFloat        AS SummPartner
         , (tmpOperationGroup.SummPartner - tmpOperationGroup.SummPartner_calc) :: TFloat AS SummDif

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
ALTER FUNCTION gpReport_GoodsMI_byMovementDif (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.05.14                                        * all
 08.04.14                                        * all
 04.04.14         *
*/

-- тест
-- SELECT SUM (AmountPartner_Weight), SUM (SummPartner) FROM gpReport_GoodsMI_byMovementDif (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inDescId:= zc_Movement_Sale(), inUnitId:= 0, inJuridicalId:= 0, inInfoMoneyId:= 0, inPaidKindId:= 0, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
