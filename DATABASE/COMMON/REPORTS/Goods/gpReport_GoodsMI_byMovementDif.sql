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
    WITH tmpOperationGroup AS
                (SELECT Movement.InvNumber
                      , Movement.OperDate
                      , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                      , tmpReportContainerSumm.JuridicalId
                      , tmpReportContainerSumm.PartnerId
                      , tmpReportContainerSumm.InfoMoneyId
                      , tmpReportContainerSumm.UnitId
                      , tmpReportContainerSumm.GoodsId
                      , MIN (tmpReportContainerSumm.GoodsKindId) AS GoodsKindId
                      , COALESCE (MIFloat_Price.ValueData, 0) AS Price
                      , SUM (MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS Amount
                      , SUM (CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END) AS AmountChangePercent
                      , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                      , SUM (CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE OR COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0
                                            -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки для Суммы округленной до 2-х знаков !!!но скидка/наценка учитывается в цене!!!
                                       THEN CASE WHEN 1=0 AND MovementFloat_ChangePercent.ValueData < 0 THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                 WHEN 1=0 AND MovementFloat_ChangePercent.ValueData > 0 THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                                 ELSE CAST (CAST ( (1 + COALESCE (MovementFloat_ChangePercent.ValueData, 0) / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2)) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2))
                                            END
                                       -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учитывается в цене!!!
                                  ELSE CASE WHEN 1=0 AND MovementFloat_ChangePercent.ValueData < 0 THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * CAST ((1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                            WHEN 1=0 AND MovementFloat_ChangePercent.ValueData > 0 THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * CAST ((1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100) * CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                            ELSE CAST ((1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100) * CAST (CAST ( (1 + COALESCE (MovementFloat_ChangePercent.ValueData, 0) / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2)) * CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                       END
                                       -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС округленной до 2-х знаков, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учитывается в цене!!!
                                       -- ...
                             END) AS SummPartner_calc
                      , SUM (tmpReportContainerSumm.SummPartner) AS SummPartner
                 FROM (SELECT tmpReportContainer.JuridicalId
                            , tmpReportContainer.InfoMoneyId
                            , COALESCE (MovementLinkObject_Partner.ObjectId, 0) AS PartnerId
                            , COALESCE (MovementLinkObject_Unit.ObjectId, 0) AS UnitId
                            , MovementItem.Id AS MovementItemId
                            , MovementItem.ObjectId AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                            , SUM (CASE WHEN (tmpReportContainer.AccountKindId = zc_Enum_AccountKind_Active() AND inDescId = zc_Movement_Sale())
                                              OR (tmpReportContainer.AccountKindId = zc_Enum_AccountKind_Passive() AND inDescId = zc_Movement_ReturnIn())
                                             THEN -1
                                        ELSE 1
                                   END * MIReport.Amount) AS SummPartner
                       FROM (SELECT ContainerLO_Juridical.ObjectId AS JuridicalId
                                  , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                  , ReportContainerLink.ReportContainerId
                                  , ReportContainerLink.AccountKindId
                                  , tmpProfitLoss.MLO_DescId
                                  , tmpProfitLoss.MLO_Partner_DescId
                             FROM (SELECT ProfitLossId AS Id, zc_MovementLinkObject_From() AS MLO_DescId, zc_MovementLinkObject_To() AS MLO_Partner_DescId FROM Constant_ProfitLoss_Sale_ReturnIn_View WHERE isSale = TRUE AND isCost = FALSE AND inDescId = zc_Movement_Sale()
                                  UNION ALL
                                   SELECT ProfitLossId AS Id, zc_MovementLinkObject_To() AS MLO_DescId, zc_MovementLinkObject_From() AS MLO_Partner_DescId FROM Constant_ProfitLoss_Sale_ReturnIn_View WHERE isSale = FALSE AND isCost = FALSE AND inDescId = zc_Movement_ReturnIn()
                                  ) AS tmpProfitLoss
                                  INNER JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                                                 ON ContainerLO_ProfitLoss.ObjectId = tmpProfitLoss.Id
                                                                AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                  INNER JOIN Container ON Container.Id = ContainerLO_ProfitLoss.ContainerId
                                                      AND Container.ObjectId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                      AND Container.DescId = zc_Container_Summ()
                                  INNER JOIN ReportContainerLink ON ReportContainerLink.ContainerId = ContainerLO_ProfitLoss.ContainerId
                                  INNER JOIN ReportContainerLink AS ReportContainerLink_child ON ReportContainerLink_child.ReportContainerId = ReportContainerLink.ReportContainerId
                                                                                             AND ReportContainerLink_child.ContainerId <> ReportContainerLink.ContainerId
                                  INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                 ON ContainerLO_Juridical.ContainerId = ReportContainerLink_child.ContainerId
                                                                AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                 ON ContainerLinkObject_InfoMoney.ContainerId = ReportContainerLink_child.ContainerId
                                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                                 ON ContainerLinkObject_PaidKind.ContainerId = ReportContainerLink_child.ContainerId
                                                                AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                AND (ContainerLinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                             ) AS tmpReportContainer
                             INNER JOIN MovementItemReport AS MIReport ON MIReport.ReportContainerId = tmpReportContainer.ReportContainerId
                                                                      AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = MIReport.MovementId
                                                          AND MovementLinkObject_Unit.DescId = tmpReportContainer.MLO_DescId
                             INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                          ON MovementLinkObject_Partner.MovementId = MIReport.MovementId
                                                         AND MovementLinkObject_Partner.DescId = tmpReportContainer.MLO_Partner_DescId

                             INNER JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                                    AND MovementItem.DescId = zc_MI_Master()
                             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       GROUP BY tmpReportContainer.JuridicalId
                              , tmpReportContainer.InfoMoneyId
                              , MovementLinkObject_Partner.ObjectId
                              , MovementLinkObject_Unit.ObjectId
                              , MovementItem.Id
                              , MovementItem.ObjectId
                              , MILinkObject_GoodsKind.ObjectId
                      ) AS tmpReportContainerSumm
                      LEFT JOIN MovementItemContainer AS MIContainer 
                                                      ON MIContainer.MovementItemId = tmpReportContainerSumm.MovementItemId
                                                     AND MIContainer.DescId = zc_MIContainer_Count()
                      LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                      LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                ON MovementBoolean_PriceWithVAT.MovementId =  MIContainer.MovementId
                                               AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                      LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                              ON MovementFloat_VATPercent.MovementId =  MIContainer.MovementId
                                             AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                      LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                              ON MovementFloat_ChangePercent.MovementId = MIContainer.MovementId
                                             AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                      LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                             ON MovementDate_OperDatePartner.MovementId =  MIContainer.MovementId
                                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                      LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                  ON MIFloat_AmountChangePercent.MovementItemId = MIContainer.MovementItemId
                                                 AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MIContainer.MovementItemId
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                 GROUP BY Movement.InvNumber
                        , Movement.OperDate
                        , MovementDate_OperDatePartner.ValueData
                        , tmpReportContainerSumm.JuridicalId
                        , tmpReportContainerSumm.PartnerId
                        , tmpReportContainerSumm.InfoMoneyId
                        , tmpReportContainerSumm.UnitId
                        , tmpReportContainerSumm.GoodsId
--                        , tmpReportContainerSumm.GoodsKindId
                        , MIFloat_Price.ValueData
                 HAVING SUM (CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END)
                     <> SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0))
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
