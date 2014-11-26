-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS FillSoldTable (TVarChar);

CREATE OR REPLACE FUNCTION FillSoldTable(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID
-- RETURNS SETOF refcursor
AS
$BODY$
BEGIN
  DELETE FROM SoldTable;


  INSERT INTO SoldTable (JuridicalId, PartnerId, ContractId, InfoMoneyId, PaidKindId, BranchId
                       , GoodsId, GoodsKindId, OperDate, InvNumber
                       , AreaId, PartnerTagId, RegionId, ProvinceId, CityKindId, CityId, ProvinceCityId, StreetKindId, StreetId
                       , Sale_Summ, Sale_SummCost, Sale_Amount_Weight, Sale_Amount_Sh
                       , Return_Summ, Return_SummCost, Return_Amount_Weight, Return_Amount_Sh
                       , SaleReturn_Summ, SaleReturn_SummCost, SaleReturn_Amount_Weight, SaleReturn_Amount_Sh
                       , Bonus, Plan_Weight, Plan_Summ, Actions_Weight, Actions_Summ
                       , Sale_AmountPartner_Weight, Sale_AmountPartner_Sh, Return_AmountPartner_Weight, Return_AmountPartner_Sh)


    WITH tmpReportContainerLink AS (SELECT isSale
                                         , ReportContainerLink.ReportContainerId
                                         , ReportContainerLink.AccountKindId
                                         , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() THEN zc_Enum_AccountKind_Passive() ELSE zc_Enum_AccountKind_Active() END AS AccountKindId_alternative
                                    FROM (SELECT ProfitLossId AS Id, isSale FROM Constant_ProfitLoss_Sale_ReturnIn_View WHERE isCost = FALSE
                                         ) AS tmpProfitLoss
                                         JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                                                  ON ContainerLO_ProfitLoss.ObjectId = tmpProfitLoss.Id
                                                                 AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                         JOIN Container ON Container.Id = ContainerLO_ProfitLoss.ContainerId
                                                       AND Container.ObjectId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                       AND Container.DescId = zc_Container_Summ()
                                         JOIN ReportContainerLink ON ReportContainerLink.ContainerId = ContainerLO_ProfitLoss.ContainerId
                                   )
       , tmpReportContainerLinkCost AS (SELECT isSale
                                             , ReportContainerLink.ReportContainerId
                                             , ReportContainerLink.AccountKindId
                                             , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() THEN zc_Enum_AccountKind_Passive() ELSE zc_Enum_AccountKind_Active() END AS AccountKindId_alternative
                                        FROM (SELECT ProfitLossId AS Id, isSale FROM Constant_ProfitLoss_Sale_ReturnIn_View WHERE isCost = TRUE
                                             ) AS tmpProfitLoss
                                             JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                                                      ON ContainerLO_ProfitLoss.ObjectId = tmpProfitLoss.Id
                                                                     AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                             JOIN Container ON Container.Id = ContainerLO_ProfitLoss.ContainerId
                                                           AND Container.ObjectId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                           AND Container.DescId = zc_Container_Summ()
                                             JOIN ReportContainerLink ON ReportContainerLink.ContainerId = ContainerLO_ProfitLoss.ContainerId
                                   )
       , tmpMovement AS (SELECT tmpListContainer.JuridicalId 
                              , MovementLinkObject_Partner.ObjectId AS PartnerId
                              , tmpListContainer.ContractId 
                              , tmpListContainer.InfoMoneyId
                              , tmpListContainer.PaidKindId
                              , Movement.OperDate
                              , Movement.InvNumber
                              
                              , MovementItem.Id AS MovementItemId
                              , MovementItem.ObjectId AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                              , COALESCE (MILinkObject_Branch.ObjectId, 0)    AS BranchId
                              , tmpListContainer.MovementDescId

                              , SUM (CASE WHEN tmpListContainer.MovementDescId = zc_Movement_Sale() THEN MIReport.Amount * CASE WHEN tmpListContainer.AccountKindId = zc_Enum_AccountKind_Active() THEN -1 ELSE 1 END ELSE 0 END) AS Sale_Summ
                              , SUM (CASE WHEN tmpListContainer.MovementDescId = zc_Movement_ReturnIn() THEN MIReport.Amount * CASE WHEN tmpListContainer.AccountKindId = zc_Enum_AccountKind_Active() THEN 1 ELSE -1 END ELSE 0 END) AS Return_Summ

                              , 0 AS  Sale_Amount
                              , 0 AS  Return_Amount
                              , 0 AS  Sale_AmountPartner
                              , 0 AS  Return_AmountPartner
                         FROM (SELECT tmpReportContainerLink.ReportContainerId
                                    , tmpReportContainerLink.AccountKindId
                                    , ContainerLO_Juridical.ObjectId         AS JuridicalId
                                    , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                    , ContainerLinkObject_PaidKind.ObjectId  AS PaidKindId
                                    , ContainerLinkObject_Contract.ObjectId  AS ContractId
                                    , CASE WHEN isSale = TRUE THEN zc_Movement_Sale() ELSE zc_Movement_ReturnIn() END AS MovementDescId
                                    , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                               FROM tmpReportContainerLink
                                         JOIN ReportContainerLink AS ReportContainerLink_alternative ON ReportContainerLink_alternative.ReportContainerId = tmpReportContainerLink.ReportContainerId
                                                                                                    AND ReportContainerLink_alternative.AccountKindId = tmpReportContainerLink.AccountKindId_alternative
                                         JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                  ON ContainerLO_Juridical.ContainerId = ReportContainerLink_alternative.ContainerId
                                                                 AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                         JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                  ON ContainerLinkObject_InfoMoney.ContainerId = ReportContainerLink_alternative.ContainerId
                                                                 AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                         JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                                  ON ContainerLinkObject_PaidKind.ContainerId = ReportContainerLink_alternative.ContainerId
                                                                 AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                         LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Contract
                                                                  ON ContainerLinkObject_Contract.ContainerId = ReportContainerLink_alternative.ContainerId
                                                                 AND ContainerLinkObject_Contract.DescId = zc_ContainerLinkObject_Contract()
                              
                              ) AS tmpListContainer
                              JOIN MovementItemReport AS MIReport ON MIReport.ReportContainerId = tmpListContainer.ReportContainerId

                              JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                               AND MovementItem.DescId =  zc_MI_Master()
                              JOIN Movement ON Movement.Id = MovementItem.MovementId
           
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                           ON MovementLinkObject_Partner.MovementId = MIReport.MovementId
                                                          AND MovementLinkObject_Partner.DescId = tmpListContainer.MLO_DescId
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                               ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                         GROUP BY tmpListContainer.JuridicalId 
                                , MovementLinkObject_Partner.ObjectId
                                , tmpListContainer.ContractId 
                                , tmpListContainer.InfoMoneyId
                                , tmpListContainer.PaidKindId
                                , Movement.OperDate
                                , Movement.InvNumber
                                , MovementItem.Id 
                                , MovementItem.ObjectId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                , COALESCE (MILinkObject_Branch.ObjectId, 0)
                                , tmpListContainer.MovementDescId
       )
       
        SELECT tmpResult.JuridicalId
      , tmpResult.PartnerId
      , tmpResult.ContractId 
      , tmpResult.InfoMoneyId
      , tmpResult.PaidKindId
      , tmpResult.BranchId

      , tmpResult.GoodsId
      , tmpResult.GoodsKindId
      , tmpResult.OperDate
      , tmpResult.InvNumber

      , View_Partner_Address.AreaId                
      , View_Partner_Address.PartnerTagId          
      , View_Partner_Address.RegionId              
      , View_Partner_Address.ProvinceId            
      , View_Partner_Address.CityKindId            
      , View_Partner_Address.CityId                
      , View_Partner_Address.ProvinceCityId        
      , View_Partner_Address.StreetKindId          
      , View_Partner_Address.StreetId              

      , tmpResult.Sale_Summ
      , tmpResult.Sale_SummCost
      , tmpResult.Sale_Amount_Weight
      , tmpResult.Sale_Amount_Sh

      , tmpResult.Return_Summ
      , tmpResult.Return_SummCost
      , tmpResult.Return_Amount_Weight
      , tmpResult.Return_Amount_Sh

      , (tmpResult.Sale_Summ - tmpResult.Return_Summ)                   AS SaleReturn_Summ
      , (tmpResult.Sale_SummCost - tmpResult.Return_SummCost)           AS SaleReturn_SummCost
      , (tmpResult.Sale_Amount_Weight - tmpResult.Return_Amount_Weight) AS SaleReturn_Amount_Weight 
      , (tmpResult.Sale_Amount_Sh - tmpResult.Return_Amount_Sh)         AS SaleReturn_Amount_Sh
      
      , 0, 0, 0, 0, 0

      , tmpResult.Sale_AmountPartner_Weight
      , tmpResult.Sale_AmountPartner_Sh
      , tmpResult.Return_AmountPartner_Weight
      , tmpResult.Return_AmountPartner_Sh
      FROM 
      ( SELECT tmpOperation.JuridicalId
                , tmpOperation.PartnerId
                , tmpOperation.ContractId 
                , tmpOperation.InfoMoneyId
                , tmpOperation.PaidKindId
                , tmpOperation.BranchId

                , tmpOperation.GoodsId
                , tmpOperation.GoodsKindId
                , tmpOperation.OperDate
                , tmpOperation.InvNumber

                , SUM (tmpOperation.Sale_Summ)          AS Sale_Summ
                , SUM (tmpOperation.Sale_SummCost)      AS Sale_SummCost
                , SUM (tmpOperation.Sale_Amount_Weight) AS Sale_Amount_Weight
                , SUM (tmpOperation.Sale_Amount_Sh)     AS Sale_Amount_Sh

                , SUM (tmpOperation.Return_Summ)          AS Return_Summ
                , SUM (tmpOperation.Return_SummCost)      AS Return_SummCost
                , SUM (tmpOperation.Return_Amount_Weight) AS Return_Amount_Weight
                , SUM (tmpOperation.Return_Amount_Sh)     AS Return_Amount_Sh

                , SUM (tmpOperation.Sale_AmountPartner_Weight)   AS Sale_AmountPartner_Weight
                , SUM (tmpOperation.Sale_AmountPartner_Sh)       AS Sale_AmountPartner_Sh
                , SUM (tmpOperation.Return_AmountPartner_Weight) AS Return_AmountPartner_Weight
                , SUM (tmpOperation.Return_AmountPartner_Sh)     AS Return_AmountPartner_Sh
                
           FROM (SELECT tmpMovement.JuridicalId 
                      , tmpMovement.PartnerId 
                      , tmpMovement.ContractId  
                      , tmpMovement.InfoMoneyId
                      , tmpMovement.PaidKindId
                      , tmpMovement.BranchId
                      , tmpMovement.GoodsId 
                      , tmpMovement.GoodsKindId 
                      , tmpMovement.OperDate
                      , tmpMovement.InvNumber

                      , SUM (tmpMovement.Sale_Summ) AS Sale_Summ
                      , SUM (tmpMovement.Return_Summ) AS Return_Summ

                      , 0 AS  Sale_Amount_Weight
                      , 0 AS  Sale_Amount_Sh
                      , 0 AS  Return_Amount_Weight
                      , 0 AS  Return_Amount_Sh

                      , 0 AS  Sale_AmountPartner_Weight
                      , 0 AS  Sale_AmountPartner_Sh
                      , 0 AS  Return_AmountPartner_Weight
                      , 0 AS  Return_AmountPartner_Sh
                      
                      , 0 AS Sale_SummCost
                      , 0 AS Return_SummCost

                 FROM tmpMovement
                 GROUP BY tmpMovement.JuridicalId 
                        , tmpMovement.PartnerId 
                        , tmpMovement.ContractId
                        , tmpMovement.InfoMoneyId
                        , tmpMovement.PaidKindId
                        , tmpMovement.BranchId
                        , tmpMovement.GoodsId
                        , tmpMovement.GoodsKindId 
                        , tmpMovement.OperDate
                        , tmpMovement.InvNumber

                UNION ALL
                 SELECT tmpMovement.JuridicalId 
                      , tmpMovement.PartnerId 
                      , tmpMovement.ContractId
                      , tmpMovement.InfoMoneyId
                      , tmpMovement.PaidKindId
                      , tmpMovement.BranchId
                      , tmpMovement.GoodsId
                      , tmpMovement.GoodsKindId
                      , tmpMovement.OperDate
                      , tmpMovement.InvNumber
                      , 0 AS Sale_Summ
                      , 0 AS Return_Summ

                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() THEN -1 * COALESCE (MIContainer.Amount, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ELSE 0 END) AS Sale_Amount_Weight
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_Amount_Sh

                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE (MIContainer.Amount, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ELSE 0 END) AS Return_Amount_Weight
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Return_Amount_Sh

                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ELSE 0 END) AS Sale_AmountPartner_Weight
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS Sale_AmountPartner_Sh

                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ELSE 0 END) AS Return_AmountPartner_Weight
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS Return_AmountPartner_Sh

                      , 0 AS Sale_SummCost
                      , 0 AS Return_SummCost

                 FROM tmpMovement
                      LEFT JOIN MovementItemContainer AS MIContainer 
                                                      ON MIContainer.MovementItemId = tmpMovement.MovementItemId
                                                     AND MIContainer.DescId = zc_MIContainer_Count()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = tmpMovement.MovementItemId
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                      LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMovement.GoodsId
                                                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                      LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                            ON ObjectFloat_Weight.ObjectId = tmpMovement.GoodsId
                                           AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                 GROUP BY tmpMovement.JuridicalId 
                        , tmpMovement.PartnerId 
                        , tmpMovement.ContractId
                        , tmpMovement.InfoMoneyId
                        , tmpMovement.PaidKindId
                        , tmpMovement.BranchId
                        , tmpMovement.GoodsId
                        , tmpMovement.GoodsKindId
                        , tmpMovement.OperDate
                        , tmpMovement.InvNumber
                UNION ALL
                 SELECT tmpMovement.JuridicalId 
                      , tmpMovement.PartnerId 
                      , tmpMovement.ContractId
                      , tmpMovement.InfoMoneyId
                      , tmpMovement.PaidKindId
                      , tmpMovement.BranchId
                      , tmpMovement.GoodsId
                      , tmpMovement.GoodsKindId
                      , tmpMovement.OperDate
                      , tmpMovement.InvNumber
                      , 0 AS Sale_Summ
                      , 0 AS Return_Summ

                      , 0 AS Sale_Amount_Weight
                      , 0 AS Sale_Amount_Sh
                      , 0 AS Return_Amount_Weight
                      , 0 AS Return_Amount_Sh

                      , 0 AS Sale_AmountPartner_Weight
                      , 0 AS Sale_AmountPartner_Sh
                      , 0 AS Return_AmountPartner_Weight
                      , 0 AS Return_AmountPartner_Sh

                      , SUM (CASE WHEN isSale = TRUE  THEN MIReport.Amount * CASE WHEN tmpReportContainerLinkCost.AccountKindId = zc_Enum_AccountKind_Active() THEN 1 ELSE -1 END ELSE 0 END) AS Sale_SummCost
                      , SUM (CASE WHEN isSale = FALSE THEN MIReport.Amount * CASE WHEN tmpReportContainerLinkCost.AccountKindId = zc_Enum_AccountKind_Active() THEN -1 ELSE 1 END ELSE 0 END) AS Return_SummCost

                 FROM tmpMovement
                      INNER JOIN MovementItemReport AS MIReport ON MIReport.MovementItemId = tmpMovement.MovementItemId
                      INNER JOIN tmpReportContainerLinkCost ON tmpReportContainerLinkCost.ReportContainerId = MIReport.ReportContainerId
                      INNER JOIN ReportContainerLink AS ReportContainerLink_alternative ON ReportContainerLink_alternative.ReportContainerId = tmpReportContainerLinkCost.ReportContainerId
                                                                                       AND ReportContainerLink_alternative.AccountKindId = tmpReportContainerLinkCost.AccountKindId_alternative
                      INNER JOIN ContainerLinkObject AS ContainerLO_Goods
                                                     ON ContainerLO_Goods.ContainerId = ReportContainerLink_alternative.ContainerId
                                                    AND ContainerLO_Goods.DescId = zc_ContainerLinkObject_Goods()

                 GROUP BY tmpMovement.JuridicalId 
                        , tmpMovement.PartnerId 
                        , tmpMovement.ContractId
                        , tmpMovement.InfoMoneyId
                        , tmpMovement.PaidKindId
                        , tmpMovement.BranchId
                        , tmpMovement.GoodsId
                        , tmpMovement.GoodsKindId
                        , tmpMovement.OperDate
                        , tmpMovement.InvNumber
           ) AS tmpOperation

           GROUP BY tmpOperation.JuridicalId
                  , tmpOperation.PartnerId
                  , tmpOperation.ContractId 
                  , tmpOperation.InfoMoneyId
                  , tmpOperation.PaidKindId
                  , tmpOperation.BranchId
                  , tmpOperation.GoodsId
                  , tmpOperation.GoodsKindId
                  , tmpOperation.OperDate
                  , tmpOperation.InvNumber) AS tmpResult

       LEFT JOIN Object_Partner_Address_View AS View_Partner_Address ON View_Partner_Address.PartnerId = tmpResult.PartnerId
 UNION SELECT 
     LinkObject_Juridical.ObjectId AS JuridicalId, 0 AS PartnerId, LinkObject_Contract.ObjectId AS ContractId, 0 AS InfoMoneyId, LinkObject_PaidKind.ObjectId, 0 AS  BranchId
                       , 0 AS GoodsId, 0 AS GoodsKindId, MovementItemContainer.OperDate, ''::TVarChar AS InvNumber
                       , 0 AS AreaId, 0 AS PartnerTagId, 0 AS RegionId, 0 AS ProvinceId, 0 AS CityKindId, 0 AS CityId, 0 AS ProvinceCityId, 0 AS StreetKindId, 0 AS StreetId
                       , 0 AS Sale_Summ, 0 AS Sale_SummCost, 0 AS Sale_Amount_Weight, 0 AS Sale_Amount_Sh
                       , 0 AS Return_Summ, 0 AS Return_SummCost, 0 AS Return_Amount_Weight, 0 AS Return_Amount_Sh
                       , 0 AS SaleReturn_Summ, 0 AS SaleReturn_SummCost, 0 AS SaleReturn_Amount_Weight, 0 AS SaleReturn_Amount_Sh
                       , - SUM(MovementItemContainer.Amount) AS Bonus, 0 AS Plan_Weight, 0 AS Plan_Summ, 0 AS Actions_Weight, 0 AS Actions_Summ
                       , 0 AS Sale_AmountPartner_Weight, 0 AS Sale_AmountPartner_Sh, 0 AS Return_AmountPartner_Weight, 0 AS Return_AmountPartner_Sh
     
   FROM movement 
        JOIN MovementItemContainer ON MovementItemContainer.movementid = movement.id AND MovementItemContainer.DescId = 2
        JOIN Container ON Container.Id = MovementItemContainer.containerid 
                      AND Container.ObjectId = 82414 --AND Container.ObjectId IN (SELECT AccountId  FROM Object_Account_View WHERE AccountDirectionId = zc_Enum_AccountDirection_70300())
        JOIN ContainerLinkObject AS LinkObject_Juridical ON LinkObject_Juridical.ContainerId = Container.Id AND LinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
        JOIN ContainerLinkObject AS LinkObject_PaidKind ON LinkObject_PaidKind.ContainerId = Container.Id AND LinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
        JOIN ContainerLinkObject AS LinkObject_Contract ON LinkObject_Contract.ContainerId = Container.Id AND LinkObject_Contract.DescId = zc_ContainerLinkObject_Contract()
   
  WHERE movement.descid = zc_Movement_ProfitLossService()
   GROUP BY MovementItemContainer.OperDate
          , LinkObject_PaidKind.ObjectId 
          , LinkObject_Juridical.ObjectId
          , LinkObject_Contract.ObjectId;

  UPDATE SoldTable SET SaleBonus = Sale_Summ - COALESCE(Bonus, 0);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION FillSoldTable (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.11.14                         *  
 25.11.14                                        * add Sale_SummCost Return_SummCost 
 19.11.14                         * add 
*/
-- тест
-- SELECT * FROM FillSoldTable (zfCalc_UserAdmin()) 
-- SELECT * FROM SoldTable