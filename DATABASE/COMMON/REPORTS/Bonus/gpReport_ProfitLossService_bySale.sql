-- Function: gpReport_ProfitLossService_bySale ()

DROP FUNCTION IF EXISTS gpReport_ProfitLossService_bySale (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ProfitLossService_bySale (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLossService_bySale (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , -- 
    IN inJuridicalId       Integer   , 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar
             , RetailId Integer, RetailName TVarChar
             , JuridicalId Integer,  JuridicalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , ContractChildCode Integer, ContractChildName TVarChar
             , PersonalName      TVarChar
             , PersonalTradeName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , MeasureName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , Sale_Summ TFloat
             , Return_Summ Tfloat
             , SummAmount  Tfloat
             , AmountIn_calc  Tfloat
             , AmountOut_calc  Tfloat
             , Persent TFloat
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
      tmpMovementFull AS (SELECT Movement.*
                          FROM Movement
                               LEFT JOIN MovementLinkMovement AS MLM_Doc
                                                              ON MLM_Doc.MovementId = Movement.Id
                                                             AND MLM_Doc.DescId = zc_MovementLinkMovement_Doc() 
     
                               LEFT JOIN MovementLinkObject AS MLO_TradeMark
                                                            ON MLO_TradeMark.MovementId = Movement.Id
                                                           AND MLO_TradeMark.DescId = zc_MovementLinkObject_TradeMark()                          
                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.DescId = zc_Movement_ProfitLossService()
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND COALESCE (MLM_Doc.MovementChildId, 0) = 0
                            AND COALESCE (MLO_TradeMark.ObjectId, 0) = 0
                          )
    
   --сумма начислений
    , tmpMI AS (SELECT MovementItem.MovementId
                     , MovementItem.Id
                     , MovementItem.ObjectId
                     , CASE WHEN MovementItem.Amount > 0
                                 THEN MovementItem.Amount
                            ELSE 0
                       END::TFloat                                    AS AmountIn
                     , CASE WHEN MovementItem.Amount < 0
                                 THEN -1 * MovementItem.Amount
                            ELSE 0
                       END::TFloat                                    AS AmountOut
                FROM MovementItem
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementFull.Id FROM tmpMovementFull) 
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
                  AND COALESCE (MovementItem.Amount,0) <> 0
                ) 
                
                
            
    --
    , tmpMovement AS (SELECT Movement.Id              AS MovementId
                           , Movement.DescId          AS MovementDescId
                           , Movement.OperDate
                           , Movement.InvNumber
                           , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId, 0)             AS JuridicalId
                           , CASE WHEN Object_Partner.DescId = zc_Object_Partner() THEN MovementItem.ObjectId ELSE 0 END AS PartnerId
                           , MILinkObject_ContractChild.ObjectId  AS ContractChildId    
                           , MovementItem.AmountIn
                           , MovementItem.AmountOut
                      FROM tmpMovementFull AS Movement
                          INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id 

                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                              ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()  
                      WHERE COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId, 0) = inJuridicalId OR inJuridicalId = 0
          --  LEFT JOIN tmpObject_Contract AS View_Contract_InvNumber_child ON View_Contract_InvNumber_child.ContractId = MILinkObject_ContractChild.ObjectId
--                          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)
                      )
    --
     --продажи                         
    , tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                           , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                      FROM Constant_ProfitLoss_AnalyzerId_View  
                      WHERE Constant_ProfitLoss_AnalyzerId_View.isCost = FALSE
                     )
    , tmpContainer_partner AS (SELECT tmp.*
                            , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.PartnerId) AS TotalSumm
                            , SUM (tmp.Sale_Summ)   OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.PartnerId) AS TotalSummSale
                            , SUM (tmp.Return_Summ) OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.PartnerId) AS TotalSummReturn
                          --  , SUM (tmp.SummAmount)  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.PartnerId) AS TotalSumm_partner
                           -- , SUM (tmp.Sale_Summ)   OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.PartnerId) AS TotalSummSale_partner
                           -- , SUM (tmp.Return_Summ) OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId, tmp.PartnerId) AS TotalSummReturn_partner 
                              , Object_Personal.ValueData       AS PersonalName
                              , Object_PersonalTrade.ValueData  AS PersonalTradeName
                       FROM (SELECT ContainerLO_Juridical.ObjectId   AS JuridicalId
                                  , MIContainer.ObjectExtId_Analyzer AS PartnerId 
                                  , ContainerLinkObject_Contract.ObjectId AS ContractId
                                  , MIContainer.ObjectId_analyzer    AS GoodsId
                                  , MIContainer.ObjectIntId_analyzer AS GoodsKindId
      
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
                                                                 AND ContainerLinkObject_Contract.DescId = zc_ContainerLinkObject_Contract()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                  ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_Analyzer
                                                                 AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()  
                                    INNER JOIN (SELECT DISTINCT tmpMovement.JuridicalId , tmpMovement.ContractChildId FROM tmpMovement) AS tmp ON tmp.JuridicalId = ContainerLO_Juridical.ObjectId

                             GROUP BY ContainerLO_Juridical.ObjectId
                                    , MIContainer.ObjectExtId_Analyzer
                                    , MIContainer.ObjectId_analyzer
                                    , MIContainer.ObjectIntId_analyzer
                                    , ContainerLinkObject_Contract.ObjectId
                             ) AS tmp
                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                                 ON ObjectLink_Partner_Personal.ObjectId = tmp.PartnerId
                                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
                            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Partner_Personal.ChildObjectId
                  
                            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = tmp.PartnerId
                                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Partner_PersonalTrade.ChildObjectId
                      )

    , tmpContainer AS (SELECT tmp.JuridicalId
                            , tmp.ContractId
                            , tmp.GoodsId  
                            , tmp.GoodsKindId   
                            , SUM (tmp.SummAmount)  AS SummAmount
                            , SUM (tmp.Sale_Summ)   AS Sale_Summ
                            , SUM (tmp.Return_Summ) AS Return_Summ
                            , SUM (SUM (tmp.SummAmount))  OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId) AS TotalSumm
                            , SUM (SUM (tmp.Sale_Summ))   OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId) AS TotalSummSale
                            , SUM (SUM (tmp.Return_Summ)) OVER (PARTITION BY tmp.ContractId, tmp.JuridicalId) AS TotalSummReturn 
                            , STRING_AGG (DISTINCT tmp.PersonalName, ';')      AS PersonalName
                            , STRING_AGG (DISTINCT tmp.PersonalTradeName, ';') AS PersonalTradeName 
                       FROM tmpContainer_partner AS tmp
                       GROUP BY tmp.JuridicalId
                              , tmp.ContractId
                              , tmp.GoodsId  
                              , tmp.GoodsKindId 
                       )

    , tmpData AS (SELECT tmpMovement.MovementId
                       , tmpMovement.MovementDescId
                       , tmpMovement.OperDate
                       , tmpMovement.InvNumber
                       , tmpMovement.JuridicalId
                       , tmpMovement.PartnerId 
                       , tmpMovement.ContractChildId 
                       , COALESCE (tmpContainer.GoodsId, tmpContainer_partner.GoodsId) AS GoodsId  
                       , COALESCE (tmpContainer.GoodsKindId, tmpContainer_partner.GoodsKindId, 0) AS GoodsKindId 
                       , tmpMovement.AmountIn
                       , tmpMovement.AmountOut
                       , COALESCE (tmpContainer.TotalSumm, tmpContainer_partner.TotalSumm,0)             AS TotalSumm
                       , COALESCE (tmpContainer.TotalSummSale, tmpContainer_partner.TotalSummSale,0)     AS TotalSummSale
                       , COALESCE (tmpContainer.TotalSummReturn, tmpContainer_partner.TotalSummReturn,0) AS TotalSummReturn

                       , COALESCE (tmpContainer.Sale_Summ, tmpContainer_partner.Sale_Summ,0)          AS Sale_Summ
                       , COALESCE (tmpContainer.Return_Summ, tmpContainer_partner.Return_Summ ,0)     AS Return_Summ
                       , COALESCE (tmpContainer.SummAmount, tmpContainer_partner.SummAmount,0)        AS SummAmount 
                       
                       , CASE WHEN COALESCE (tmpContainer.TotalSumm, tmpContainer_partner.TotalSumm,0) <> 0 THEN COALESCE (tmpContainer.SummAmount, tmpContainer_partner.SummAmount,0) * 100 / COALESCE (tmpContainer.TotalSumm, tmpContainer_partner.TotalSumm,0) ELSE 0 END AS PartPersent
                       
                       , COALESCE (tmpContainer.PersonalName, tmpContainer_partner.PersonalName, '') AS PersonalName
                       , COALESCE (tmpContainer.PersonalTradeName, tmpContainer_partner.PersonalTradeName, '') AS PersonalTradeName            
                  FROM tmpMovement
                  
                   LEFT JOIN tmpContainer ON tmpContainer.JuridicalId = tmpMovement.JuridicalId
                                         AND tmpContainer.ContractId = tmpMovement.ContractChildId
                                         AND COALESCE (tmpMovement.PartnerId,0) = 0  
                   LEFT JOIN tmpContainer_partner ON tmpContainer_partner.JuridicalId = tmpMovement.JuridicalId
                                                 AND tmpContainer_partner.ContractId = tmpMovement.ContractChildId
                                                 AND (tmpContainer_partner.PartnerId = tmpMovement.PartnerId AND COALESCE (tmpMovement.PartnerId,0) <> 0)
                  )


             SELECT tmpData.MovementId
                  , tmpData.OperDate
                  , tmpData.InvNumber
                  , Object_Retail.Id            AS RetailId
                  , Object_Retail.ValueData     AS RetailNamе 
             
                  , Object_Juridical.Id         AS JuridicalId
                  , Object_Juridical.ValueData  AS JuridicalName
                  , Object_Partner.Id           AS PartnerId
                  , Object_Partner.ValueData    AS PartnerName
                  , Object_ContractChild.ObjectCode AS ContractChildCode
                  , Object_ContractChild.ValueData  AS ContractChildName 
                  
                  , tmpData.PersonalName      ::TVarChar
                  , tmpData.PersonalTradeName ::TVarChar

                  , Object_Goods.Id             AS GoodsId
                  , Object_Goods.ObjectCode     AS GoodsCode
                  , Object_Goods.ValueData      AS GoodsName
                  , Object_GoodsKind.ValueData  AS GoodsKindName

                  , Object_Measure.ValueData           AS MeasureName
                  , Object_TradeMark.Id                AS TradeMarkId
                  , Object_TradeMark.ValueData         AS TradeMarkName
                  , Object_GoodsGroup.ValueData        AS GoodsGroupName
                  , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

                  , tmpData.AmountIn
                  , tmpData.AmountOut 

                  , COALESCE (tmpData.Sale_Summ,0)   ::TFloat    AS Sale_Summ
                  , COALESCE (tmpData.Return_Summ,0) ::TFloat    AS Return_Summ
                  , COALESCE (tmpData.SummAmount,0)  ::TFloat    AS SummAmount   
                  
                  , CAST (tmpData.PartPersent * tmpData.AmountIn / 100 AS NUMERIC (16,2))  ::TFloat AS AmountIn_calc
                  , CAST (tmpData.PartPersent * tmpData.AmountOut / 100 AS NUMERIC (16,2)) ::TFloat AS AmountOut_calc
                  , tmpData.PartPersent ::TFloat AS Persent
             FROM tmpData 
                LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
                LEFT JOIN Object AS Object_ContractChild ON Object_ContractChild.Id = tmpData.ContractChildId
                
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

                LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                     ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
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
 18.09.24         *
*/

-- тест
--SELECT * FROM gpReport_ProfitLossService_bySale (inStartDate:= '01.09.2024', inEndDate:= '15.09.2024', inSession:= zfCalc_UserAdmin());
--
SELECT * FROM gpReport_ProfitLossService_bySale (inStartDate:= '01.09.2024', inEndDate:= '01.010.2024', inJuridicalId:= 5388644, inSession:= zfCalc_UserAdmin());