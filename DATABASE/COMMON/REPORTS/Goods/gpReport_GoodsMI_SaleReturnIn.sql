-- Function: gpReport_Goods_Movement ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnIn (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_SaleReturnIn (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inJuridicalId  Integer   , 
    IN inGoodsGroupId Integer   ,
    IN inPaidKindId   Integer   , --
    IN inInfoMoneyId  Integer,    -- Управленческая статья  
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , Sale_Summ TFloat, Sale_Amount_Weight TFloat , Sale_Amount_Sh TFloat, Sale_AmountPartner_Weight TFloat , Sale_AmountPartner_Sh TFloat
             , Return_Summ TFloat, Return_Amount_Weight TFloat , Return_Amount_Sh TFloat, Return_AmountPartner_Weight TFloat , Return_AmountPartner_Sh TFloat 
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
    WITH tmpMovement AS (SELECT tmpListContainer.JuridicalId 
                              , MovementLinkObject_Partner.ObjectId AS PartnerId
                              , tmpListContainer.ContractId 
                              , tmpListContainer.InfoMoneyId

                              , MovementItem.Id AS MovementItemId
                              , MovementItem.ObjectId AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                              , tmpListContainer.MovementDescId

                              , SUM (CASE WHEN tmpListContainer.MovementDescId = zc_Movement_Sale() THEN MIReport.Amount * CASE WHEN tmpListContainer.AccountKindId = zc_Enum_AccountKind_Active() THEN -1 ELSE 1 END ELSE 0 END) AS Sale_Summ
                              , SUM (CASE WHEN tmpListContainer.MovementDescId = zc_Movement_ReturnIn() THEN MIReport.Amount * CASE WHEN tmpListContainer.AccountKindId = zc_Enum_AccountKind_Active() THEN 1 ELSE -1 END ELSE 0 END) AS Return_Summ

                              , 0 AS  Sale_Amount
                              , 0 AS  Return_Amount
                              , 0 AS  Sale_AmountPartner
                              , 0 AS  Return_AmountPartner
                         FROM (SELECT ReportContainerLink.ReportContainerId
                                    , ReportContainerLink.AccountKindId
                                    , ContainerLO_Juridical.ObjectId         AS JuridicalId
                                    , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                    , ContainerLinkObject_PaidKind.ObjectId  AS PaidKindId
                                    , ContainerLinkObject_Contract.ObjectId  AS ContractId
                                    , CASE WHEN isSale = TRUE THEN zc_Movement_Sale() ELSE zc_Movement_ReturnIn() END AS MovementDescId
                                    , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                               FROM (SELECT ProfitLossId AS Id, isSale FROM Constant_ProfitLoss_Sale_ReturnIn_View
                                    ) AS tmpProfitLoss
                                         JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                                                  ON ContainerLO_ProfitLoss.ObjectId = tmpProfitLoss.Id
                                                                 AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                         JOIN Container ON Container.Id = ContainerLO_ProfitLoss.ContainerId
                                                       AND Container.ObjectId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                       AND Container.DescId = zc_Container_Summ()
                                         JOIN ReportContainerLink ON ReportContainerLink.ContainerId = ContainerLO_ProfitLoss.ContainerId
                                         JOIN ReportContainerLink AS ReportContainerLink_Juridical ON ReportContainerLink_Juridical.ReportContainerId = ReportContainerLink.ReportContainerId
                                                                                                  AND ReportContainerLink_Juridical.ContainerId <> ReportContainerLink.ContainerId
                                         JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                  ON ContainerLO_Juridical.ContainerId = ReportContainerLink_Juridical.ContainerId
                                                                 AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                 AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                         JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                  ON ContainerLinkObject_InfoMoney.ContainerId = ReportContainerLink_Juridical.ContainerId
                                                                 AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                 AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                                         JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                                  ON ContainerLinkObject_PaidKind.ContainerId = ReportContainerLink_Juridical.ContainerId
                                                                 AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                 AND (ContainerLinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                                         LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Contract
                                                                  ON ContainerLinkObject_Contract.ContainerId = ReportContainerLink_Juridical.ContainerId
                                                                 AND ContainerLinkObject_Contract.DescId = zc_ContainerLinkObject_Contract()
                              ) AS tmpListContainer
                              JOIN MovementItemReport AS MIReport ON MIReport.ReportContainerId = tmpListContainer.ReportContainerId
                                                                 AND MIReport.OperDate BETWEEN inStartDate AND inEndDate

                              JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                               AND MovementItem.DescId =  zc_MI_Master()
                              JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                           ON MovementLinkObject_Partner.MovementId = MIReport.MovementId
                                                          AND MovementLinkObject_Partner.DescId = tmpListContainer.MLO_DescId
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                         GROUP BY tmpListContainer.JuridicalId 
                                , MovementLinkObject_Partner.ObjectId
                                , tmpListContainer.ContractId 
                                , tmpListContainer.InfoMoneyId
                                , MovementItem.Id 
                                , MovementItem.ObjectId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                , tmpListContainer.MovementDescId
                                 )
     SELECT Object_GoodsGroup.ValueData AS GoodsGroupName 
          , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
          , Object_Goods.ObjectCode     AS GoodsCode
          , Object_Goods.ValueData      AS GoodsName
          , Object_GoodsKind.ValueData  AS GoodsKindName
          , Object_Measure.ValueData    AS MeasureName
          , Object_TradeMark.ValueData  AS TradeMarkName

          , Object_Juridical.ObjectCode AS JuridicalCode
          , Object_Juridical.ValueData  AS JuridicalName
          , Object_Partner.ObjectCode   AS PartnerCode
          , Object_Partner.ValueData    AS PartnerName

          , View_Contract_InvNumber.ContractCode
          , View_Contract_InvNumber.InvNumber              AS ContractNumber
          , View_Contract_InvNumber.ContractTagName
          , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
          , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

         , CAST ((tmpOperationGroup.Sale_Summ) AS TFloat) AS Sale_Summ
         , CAST ((tmpOperationGroup.Sale_Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat) AS Sale_Amount_Weight 
         , CAST ((CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Sale_Amount ELSE 0 END) AS TFloat) AS Sale_Amount_Sh 

         , CAST ((tmpOperationGroup.Sale_AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat) AS Sale_AmountPartner_Weight 
         , CAST ((CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Sale_AmountPartner ELSE 0 END) AS TFloat) AS Sale_AmountPartner_Sh 

         , CAST ((tmpOperationGroup.Return_Summ) AS TFloat) AS Return_Summ
         , CAST ((tmpOperationGroup.Return_Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat) AS Return_Amount_Weight 
         , CAST ((CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Return_Amount ELSE 0 END) AS TFloat) AS Return_Amount_Sh 

         , CAST ((tmpOperationGroup.Return_AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat) AS Return_AmountPartner_Weight 
         , CAST ((CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Return_AmountPartner ELSE 0 END) AS TFloat) AS Return_AmountPartner_Sh 

     FROM (SELECT tmpOperation.JuridicalId
                , tmpOperation.PartnerId
                , tmpOperation.ContractId 
                , tmpOperation.InfoMoneyId

                , tmpOperation.GoodsId
                , tmpOperation.GoodsKindId

                , (SUM (tmpOperation.Sale_Summ))   AS Sale_Summ
                , (SUM (tmpOperation.Sale_Amount)) AS Sale_Amount

                , (SUM (tmpOperation.Return_Summ))   AS Return_Summ
                , (SUM (tmpOperation.Return_Amount)) AS Return_Amount

                , (SUM (tmpOperation.Sale_AmountPartner))   AS Sale_AmountPartner
                , (SUM (tmpOperation.Return_AmountPartner)) AS Return_AmountPartner
                
           FROM (SELECT tmpMovement.JuridicalId 
                      , tmpMovement.PartnerId
                      , tmpMovement.ContractId 
                      , tmpMovement.InfoMoneyId
                      , tmpMovement.GoodsId
                      , tmpMovement.GoodsKindId

                      , SUM (tmpMovement.Sale_Summ) AS Sale_Summ
                      , SUM (tmpMovement.Return_Summ) AS Return_Summ

                      , 0 AS  Sale_Amount
                      , 0 AS  Return_Amount
                      , 0 AS  Sale_AmountPartner
                      , 0 AS  Return_AmountPartner
                      
                 FROM tmpMovement
                 GROUP BY tmpMovement.JuridicalId 
                        , tmpMovement.PartnerId
                        , tmpMovement.ContractId 
                        , tmpMovement.InfoMoneyId
                        , tmpMovement.GoodsId
                        , tmpMovement.GoodsKindId

                UNION ALL    
                 SELECT tmpMovement.JuridicalId 
                      , tmpMovement.PartnerId
                      , tmpMovement.ContractId 
                      , tmpMovement.InfoMoneyId
                      , tmpMovement.GoodsId
                      , tmpMovement.GoodsKindId

                      , 0 AS Sale_Summ
                      , 0 AS Return_Summ

                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_Amount
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Return_Amount

                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS Sale_AmountPartner
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS Return_AmountPartner

                 FROM tmpMovement
                      LEFT JOIN MovementItemContainer AS MIContainer 
                                                 ON MIContainer.MovementItemId = tmpMovement.MovementItemId
                                                AND MIContainer.DescId = zc_MIContainer_Count()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = tmpMovement.MovementItemId
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                 GROUP BY tmpMovement.JuridicalId 
                        , tmpMovement.ContractId 
                        , tmpMovement.PartnerId
                        , tmpMovement.InfoMoneyId
                        , tmpMovement.GoodsId
                        , tmpMovement.GoodsKindId
                ) AS tmpOperation

           GROUP BY tmpOperation.JuridicalId
                  , tmpOperation.PartnerId
                  , tmpOperation.ContractId 
                  , tmpOperation.InfoMoneyId
                  , tmpOperation.GoodsId
                  , tmpOperation.GoodsKindId
                  
          ) AS tmpOperationGroup
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

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId 

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpOperationGroup.ContractId
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_SaleReturnIn (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.05.14                                        * add GoodsGroupNameFull
 28.03.14                                        * all
 06.02.14         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_SaleReturnIn (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inJuridicalId:= 0, inGoodsGroupId:= 0, inPaidKindId:= 0, inInfoMoneyId:= 0, inSession:= zfCalc_UserAdmin());
