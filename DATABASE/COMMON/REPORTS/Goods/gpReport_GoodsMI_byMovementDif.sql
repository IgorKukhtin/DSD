-- Function: gpReport_GoodsMI_byMovementDif ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_byMovementDif (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_byMovementDif (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inJuridicalId  Integer   , 
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , PaidKindName TVarChar

             , GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
            
             , Price TFloat
             , Amount TFloat, AmountChangePercent TFloat, AmountPartner TFloat
             , Summ TFloat
              )   
AS
$BODY$
BEGIN

  /*IF COALESCE (inJuridicalId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Не выбрано юр.лицов!!!';
   END IF;*/
   
    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0 
    THEN 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId
           FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;


   -- Результат
    RETURN QUERY
    
    -- ограничиваем по Юр.лицу
   WITH tmpMovement AS (SELECT Movement.Id AS MovementId
                             , Movement.InvNumber
                             , Movement.OperDate 
                        FROM ContainerLinkObject AS ContainerLO_Juridical
                             JOIN ReportContainerLink ON ReportContainerLink.ContainerId = ContainerLO_Juridical.ContainerId
                             JOIN MovementItemReport AS MIReport ON MIReport.ReportContainerId = ReportContainerLink.ReportContainerId
                                                                AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
                             JOIN Movement ON Movement.Id = MIReport.MovementId
                                          AND Movement.DescId  = inDescId 
                        WHERE ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                          AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0)
                        GROUP BY Movement.Id 
                               , Movement.InvNumber
                               , Movement.OperDate    
                         )

      SELECT AllGroupMovement.InvNumber
           , AllGroupMovement.OperDate
           , AllGroupMovement.OperDatePartner
           , AllGroupMovement.JuridicalCode
           , AllGroupMovement.JuridicalName
           , AllGroupMovement.PartnerCode
           , AllGroupMovement.PartnerName
           , AllGroupMovement.PaidKindName
           , AllGroupMovement.GoodsGroupName 
           , AllGroupMovement.GoodsCode
           , AllGroupMovement.GoodsName
           , AllGroupMovement.GoodsKindName
           , AllGroupMovement.MeasureName
           , AllGroupMovement.Price               :: TFloat AS Price
           , AllGroupMovement.Amount              :: TFloat AS Amount
           , AllGroupMovement.AmountChangePercent :: TFloat AS AmountChangePercent
           , AllGroupMovement.AmountPartner       :: TFloat AS AmountPartner
           , AllGroupMovement.Summ                :: TFloat AS Summ
           /*, CAST (CASE WHEN (AllGroupMovement.Amount_Sh <> AllGroupMovement.AmountPartner_Sh 
                        OR AllGroupMovement.Amount_Weight <> AllGroupMovement.AmountPartner_Weight) 
                      THEN TRUE ELSE FALSE END AS Boolean) AS Difference*/
      FROM (SELECT tmpOperationGroup.InvNumber
                 , tmpOperationGroup.OperDate
                 , MovementDate_OperDatePartner.ValueData AS OperDatePartner

                 , Object_Juridical.ObjectCode AS JuridicalCode
                 , Object_Juridical.ValueData  AS JuridicalName
                 , Object_Partner.ObjectCode   AS PartnerCode
                 , Object_Partner.ValueData    AS PartnerName
                 , Object_PaidKind.ValueData   AS PaidKindName

                 , Object_GoodsGroup.ValueData AS GoodsGroupName 
                 , Object_Goods.ObjectCode     AS GoodsCode
                 , Object_Goods.ValueData      AS GoodsName
                 , Object_GoodsKind.ValueData  AS GoodsKindName
                 , Object_Measure.ValueData    AS MeasureName

                 , tmpOperationGroup.Price
                 , SUM (tmpOperationGroup.Amount)              AS Amount
                 , SUM (tmpOperationGroup.AmountChangePercent) AS AmountChangePercent
                 , SUM (tmpOperationGroup.AmountPartner)       AS AmountPartner
                 , SUM (tmpOperationGroup.Summ)                AS Summ
            FROM (SELECT tmpOperation.MovementId
                       , tmpOperation.InvNumber
                       , tmpOperation.OperDate
                       , MAX (tmpOperation.ContainerId) AS ContainerId
                       , tmpOperation.GoodsId
                       , tmpOperation.GoodsKindId
                       , tmpOperation.Price
                       , SUM (tmpOperation.Amount)              AS Amount
                       , SUM (tmpOperation.AmountChangePercent) AS AmountChangePercent
                       , SUM (tmpOperation.AmountPartner)       AS AmountPartner
                       , SUM (tmpOperation.Summ)                AS Summ
                  FROM (SELECT tmpMovement.MovementId AS MovementId
                             , tmpMovement.InvNumber
                             , tmpMovement.OperDate
                             , CASE WHEN MIReport.ActiveContainerId = ReportContainerLink.ContainerId THEN MIReport.PassiveContainerId ELSE MIReport.ActiveContainerId END AS ContainerId
                             , MovementItem.ObjectId AS GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             , COALESCE (MIFloat_Price.ValueData, 0) AS Price
                             , 0 AS  Amount
                             , 0 AS  AmountChangePercent
                             , 0 AS  AmountPartner
                             , SUM (MIReport.Amount * CASE WHEN (ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() AND inDescId = zc_Movement_Sale())
                                                      OR (ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive() AND inDescId = zc_Movement_ReturnIn())
                                                         THEN -1
                                                    ELSE 1
                                               END) AS Summ
                        FROM tmpMovement
                             JOIN MovementItemReport AS MIReport ON MIReport.MovementId = tmpMovement.MovementId
                                                                AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
                             JOIN ReportContainerLink ON ReportContainerLink.ReportContainerId = MIReport.ReportContainerId--ReportContainerLink.ContainerId = tmpListContainer.ContainerId

                             JOIN (SELECT Container.Id AS ContainerId
                                   FROM (SELECT ProfitLossId AS Id, isSale FROM Constant_ProfitLoss_Sale_ReturnIn_View) AS tmpProfitLoss
                                        JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                                                 ON ContainerLO_ProfitLoss.ObjectId = tmpProfitLoss.Id
                                                                AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                        JOIN Container ON Container.Id = ContainerLO_ProfitLoss.ContainerId
                                                      AND Container.ObjectId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                      AND Container.DescId = zc_Container_Summ()
                                  ) AS tmpListContainer ON  tmpListContainer.ContainerId = ReportContainerLink.ContainerId 
                             JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                              AND MovementItem.DescId =  zc_MI_Master()
                             JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                        GROUP BY tmpMovement.MovementId
                               , tmpMovement.InvNumber
                               , tmpMovement.OperDate
                               , MovementItem.ObjectId
                               , MILinkObject_GoodsKind.ObjectId
                               , CASE WHEN MIReport.ActiveContainerId = ReportContainerLink.ContainerId THEN MIReport.PassiveContainerId ELSE MIReport.ActiveContainerId END
                               , MIFloat_Price.ValueData
                       UNION ALL    
                        SELECT tmpMovement.MovementId AS MovementId
                             , tmpMovement.InvNumber
                             , tmpMovement.OperDate
                             , 0 AS ContainerId 
                             , Container.ObjectId                           AS GoodsId       
                             , COALESCE (ContainerLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                             , COALESCE (MIFloat_Price.ValueData, 0)                     AS Price
                             , SUM (MIContainer.Amount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END) AS Amount
                             , SUM (CASE WHEN inDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE MIContainer.Amount END) AS AmountChangePercent
                             , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0))       AS AmountPartner
                             , 0 AS Summ
                        FROM tmpMovement
                             JOIN MovementItemContainer AS MIContainer ON MIContainer.MovementId = tmpMovement.MovementId
                                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                             JOIN Container ON Container.Id = MIContainer.ContainerId
                                           AND Container.DescId = zc_Container_Count()
                             JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId

                             LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind
                                                           ON ContainerLO_GoodsKind.ContainerId = Container.Id
                                                          AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                         ON MIFloat_AmountChangePercent.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                        WHERE MIContainer.DescId = zc_MIContainer_Count()
                        GROUP BY tmpMovement.MovementId
                               , tmpMovement.InvNumber
                               , tmpMovement.OperDate
                               , Container.ObjectId 
                               , ContainerLO_GoodsKind.ObjectId
                               , MIFloat_Price.ValueData
                      ) AS tmpOperation
                  GROUP BY tmpOperation.MovementId
                         , tmpOperation.InvNumber
                         , tmpOperation.OperDate
                         , tmpOperation.GoodsId
                         , tmpOperation.GoodsKindId
                         , tmpOperation.Price
                 ) AS tmpOperationGroup

            LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpOperationGroup.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  tmpOperationGroup.MovementId
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = tmpOperationGroup.MovementId
                                        AND MovementLinkObject_Partner.DescId = CASE WHEN inDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                          ON ContainerLinkObject_Juridical.ContainerId = tmpOperationGroup.ContainerId
                                         AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ContainerLinkObject_Juridical.ObjectId 
         
            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                          ON ContainerLinkObject_PaidKind.ContainerId = tmpOperationGroup.ContainerId
                                         AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ContainerLinkObject_PaidKind.ObjectId 

      GROUP BY tmpOperationGroup.InvNumber
             , tmpOperationGroup.OperDate
             , MovementDate_OperDatePartner.ValueData
             , Object_Juridical.ObjectCode
             , Object_Juridical.ValueData
             , Object_Partner.ObjectCode
             , Object_Partner.ValueData 
             , Object_PaidKind.ValueData
             , Object_GoodsGroup.ValueData
             , Object_Goods.ObjectCode
             , Object_Goods.ValueData
             , Object_GoodsKind.ValueData 
             , Object_Measure.ValueData
             , tmpOperationGroup.Price
          ) AS AllGroupMovement 

      WHERE AllGroupMovement.AmountChangePercent <> AllGroupMovement.AmountPartner 
     ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_byMovementDif (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.04.14                                        * all
 04.04.14         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_byMovementDif (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inDescId:= 5, inJuridicalId:= 15616, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
