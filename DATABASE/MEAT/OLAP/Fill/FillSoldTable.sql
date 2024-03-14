-- Function: FillSoldTable

DROP FUNCTION IF EXISTS FillSoldTable (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION FillSoldTable(
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOId
-- RETURNS SETOF refcursor
AS
$BODY$
BEGIN
  -- inStartDate:='01.06.2014';
  --
  DELETE FROM SoldTable WHERE OperDate BETWEEN inStartDate AND inEndDate;


/*
update SoldTable set GoodsByGoodsKindId = tmpGoodsByGoodsKind.Id
FROM (with tmpGoodsByGoodsKind AS (SELECT
                                      ObjectLink_GoodsByGoodsKind_Goods.ObjectId          AS Id 
                                    , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     AS GoodsId
                                    , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                                FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                     JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                               )
      select * from tmpGoodsByGoodsKind
     ) AS tmpGoodsByGoodsKind
where tmpGoodsByGoodsKind.GoodsId     = SoldTable .GoodsId
  AND tmpGoodsByGoodsKind.GoodsKindId = SoldTable .GoodsKindId
  AND SoldTable.OperDate BETWEEN '01.12.2020' AND '01.01.2021'
  AND GoodsByGoodsKindId IS NULL

*/
  --
  INSERT INTO SoldTable (OperDate
                       , AccountId
                       , BranchId, JuridicalGroupId, JuridicalId, PartnerId, InfoMoneyId, PaidKindId, PaidKindId_bonus, RetailId, RetailReportId
                       , AreaId, PartnerTagId
                       , ContractId, ContractTagId, ContractTagGroupId
                       , PersonalId, UnitId_Personal, BranchId_Personal, PersonalTradeId, UnitId_PersonalTrade
                       , BusinessId, GoodsPlatformId, TradeMarkId, GoodsGroupAnalystId, GoodsTagId, GoodsGroupId, GoodsGroupStatId, GoodsId, GoodsKindId, MeasureId
                       , RegionId, ProvinceId, CityKindId, CityId, ProvinceCityId, StreetKindId, StreetId

                       , Actions_Weight, Actions_Sh, Actions_SummCost, Actions_Summ
                       , Sale_Summ, Sale_Summ_10200, Sale_Summ_10250, Sale_Summ_10300, Sale_SummCost, Sale_SummCost_10500, Sale_SummCost_40200
                       , Sale_Amount_Weight, Sale_Amount_Sh, Sale_AmountPartner_Weight, Sale_AmountPartner_Sh, Sale_Amount_10500_Weight, Sale_Amount_40200_Weight
                       , Return_Summ, Return_Summ_10300, Return_Summ_10700, Return_SummCost, Return_SummCost_40200
                       , Return_Amount_Weight, Return_Amount_Sh, Return_AmountPartner_Weight, Return_AmountPartner_Sh, Return_Amount_40200_Weight
                       , SaleReturn_Summ, SaleReturn_Summ_10300, SaleReturn_SummCost, SaleReturn_SummCost_40200, SaleReturn_Amount_Weight, SaleReturn_Amount_Sh
                       , BonusBasis, Bonus, Plan_Weight, Plan_Summ
                       , Money_Summ, SendDebt_Summ, Money_SendDebt_Summ
                       
                       , Sale_SummIn_pav, ReturnIn_SummIn_pav

                       , ContractConditionKindId, BonusKindId, BonusTax
                       , GoodsByGoodsKindId
                        )

   WITH tmpPartnerAddress AS (SELECT * FROM Object_Partner_Address_View)
      , tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.* FROM Constant_ProfitLoss_AnalyzerId_View)
      , tmpGoodsByGoodsKind AS (SELECT
                                      ObjectLink_GoodsByGoodsKind_Goods.ObjectId          AS Id 
                                    , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     AS GoodsId
                                    , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                                FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                     JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                               )

      , tmpOperation_SaleReturn
                     AS (SELECT MIContainer.OperDate
                              , CLO_Juridical.ObjectId                AS JuridicalId
                              , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer /*MovementLinkObject_Partner.ObjectId*/ END AS PartnerId
                              , CLO_InfoMoney.ObjectId                AS InfoMoneyId
                              , CLO_PaidKind.ObjectId                 AS PaidKindId
                              , MILinkObject_Branch.ObjectId          AS BranchId
                              , CLO_Contract.ObjectId                 AS ContractId

                              , MIContainer.ObjectId_Analyzer         AS GoodsId
                              , MIContainer.ObjectIntId_Analyzer      AS GoodsKindId

                              , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE AND MIFloat_PromoMovement.ValueData > 0 THEN 1 * MIContainer.Amount ELSE 0 END) AS Actions_Summ
                              , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                              , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200() THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ_10200
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10250() THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ_10250
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ_10300
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN 1 * MIContainer.Amount ELSE 0 END) AS Return_Summ_10300
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() THEN 1 * MIContainer.Amount ELSE 0 END) AS Return_Summ_10700

                              , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_Amount
                              , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_Amount

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() AND MIFloat_PromoMovement.ValueData > 0 THEN -1 * MIContainer.Amount ELSE 0 END) AS Actions_AmountPartner
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_AmountPartner
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_AmountPartner

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500()     THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_Amount_10500
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Amount_40200
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_Amount_40200

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() AND MIFloat_PromoMovement.ValueData > 0 THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Actions_SummCost
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_SummCost
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_SummCost_10500
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() THEN      COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_SummCost_40200

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Return_SummCost
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Return_SummCost_40200

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount * COALESCE (MIFloat_PriceIn.ValueData, 0) * 1.2 ELSE 0 END) AS Sale_SummIn_pav
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount * COALESCE (MIFloat_PriceIn.ValueData, 0) * 1.2 ELSE 0 END) AS ReturnIn_SummIn_pav

                         FROM tmpAnalyzer
                              INNER JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                              AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                             ON CLO_Juridical.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                            AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                              INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                             ON CLO_InfoMoney.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                            AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                              INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                             ON CLO_PaidKind.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                            AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                              LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                            ON CLO_Contract.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                           AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                               ON MILinkObject_Branch.MovementItemId = MIContainer.MovementItemId
                                                              AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                              LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                          ON MIFloat_PromoMovement.MovementItemId = MIContainer.MovementItemId
                                                         AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceIn
                                                          ON MIFloat_PriceIn.MovementItemId = MIContainer.MovementItemId
                                                         AND MIFloat_PriceIn.DescId         = zc_MIFloat_PriceIn()
                         GROUP BY MIContainer.OperDate
                                , CLO_Juridical.ObjectId
                                , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer /*MovementLinkObject_Partner.ObjectId*/ END
                                , CLO_InfoMoney.ObjectId
                                , CLO_PaidKind.ObjectId
                                , MILinkObject_Branch.ObjectId
                                , CLO_Contract.ObjectId
                                , MIContainer.ObjectId_Analyzer
                                , MIContainer.ObjectIntId_Analyzer
                        )

          , tmpBonus AS (SELECT MovementItemContainer.OperDate  AS OperDate
                              , CLO_Juridical.ObjectId          AS JuridicalId
                              , 0                               AS PartnerId
                              , CLO_InfoMoney.ObjectId          AS InfoMoneyId
                              , COALESCE (ObjectLink_Contract_PaidKind.ChildObjectId, CLO_PaidKind.ObjectId) AS PaidKindId
                              , CLO_PaidKind.ObjectId           AS PaidKindId_bonus
                              , 0                               AS BranchId
                              , COALESCE (MILinkObject_ContractChild.ObjectId, CLO_Contract.ObjectId) AS ContractId

                            --, COALESCE (MIDate_OperDate.ValueData, MovementItemContainer.OperDate)      AS OperDate
                            --, COALESCE (MILinkObject_Juridical.ObjectId, CLO_Juridical.ObjectId)        AS JuridicalId
                            --, COALESCE (MILinkObject_Partner.ObjectId, 0)                               AS PartnerId
                            --, COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, CLO_InfoMoney.ObjectId) AS InfoMoneyId
                            --, COALESCE (MovementLinkObject_PaidKind.ObjectId, CLO_PaidKind.ObjectId)    AS PaidKindId
                            --, COALESCE (MILinkObject_Branch.ObjectId, 0)                                AS BranchId
                            --, COALESCE (MILinkObject_ContractChild.ObjectId, CLO_Contract.ObjectId)     AS ContractId

                            --, COALESCE (MILinkObject_Goods.ObjectId, 0)                                 AS GoodsId
                            --, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                             AS GoodsKindId

                              , 0 AS GoodsId
                              , 0 AS GoodsKindId

                              , COALESCE (MILinkObject_ContractConditionKind.ObjectId,0)                  AS ContractConditionKindId
                              , COALESCE (MILinkObject_BonusKind.ObjectId,0)                              AS BonusKindId
                              , COALESCE (MIFloat_BonusValue.ValueData,0)                                 AS BonusTax

                              , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                             --THEN COALESCE (MovementItem.Amount, -1 * MovementItemContainer.Amount)
                                               THEN -1 * MovementItemContainer.Amount
                                          ELSE 0
                                     END) AS BonusBasis
                              , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                               THEN 0
                                        --ELSE COALESCE (MovementItem.Amount, -1 * MovementItemContainer.Amount)
                                          ELSE -1 * MovementItemContainer.Amount
                                     END) AS Bonus
                         FROM Movement
                              INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                              AND MovementItemContainer.DescId = zc_MIContainer_Summ()
                                                              AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
                              INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                                  AND Container.ObjectId = zc_Enum_Account_50401() -- !!!Расходы будущих периодов + Услуги по маркетингу!!!

                              LEFT JOIN ContainerLinkObject AS CLO_Juridical ON CLO_Juridical.ContainerId = Container.Id AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                              LEFT JOIN ContainerLinkObject AS CLO_PaidKind  ON CLO_PaidKind.ContainerId  = Container.Id AND CLO_PaidKind.DescId  = zc_ContainerLinkObject_PaidKind()
                              LEFT JOIN ContainerLinkObject AS CLO_Contract  ON CLO_Contract.ContainerId  = Container.Id AND CLO_Contract.DescId  = zc_ContainerLinkObject_Contract()
                              LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                               ON MILinkObject_ContractChild.MovementItemId = MovementItemContainer.MovementItemId
                                                              AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
                              LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                                   ON ObjectLink_Contract_PaidKind.ObjectId = MILinkObject_ContractChild.ObjectId
                                                  AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                              LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                                        ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                                       AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()

                              LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                               ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                                               ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_BonusKind.DescId = zc_MILinkObject_BonusKind()
                              LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                                          ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                                         AND MIFloat_BonusValue.DescId = zc_MIFloat_BonusValue()

/*                            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Child()
                                                    AND MovementItem.isErased = FALSE
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                                               ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                               ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                               ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                               ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

                              LEFT JOIN MovementItemDate AS MIDate_OperDate
                                                         ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                                        AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                          ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                           ON MovementLinkObject_PaidKind.MovementId = MIFloat_MovementId.ValueData :: Integer
                                                          AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                              LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                   ON ObjectLink_Contract_InfoMoney.ObjectId = MILinkObject_ContractChild.ObjectId
                                                  AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()*/

                         WHERE Movement.DescId = zc_Movement_ProfitLossService()
                         GROUP BY MovementItemContainer.OperDate --,MIDate_OperDate.ValueData
                                , CLO_Juridical.ObjectId -- MILinkObject_Juridical.ObjectId
                              --, MILinkObject_Partner.ObjectId
                                , CLO_InfoMoney.ObjectId -- ObjectLink_Contract_InfoMoney.ChildObjectId
                                , CLO_PaidKind.ObjectId -- MovementLinkObject_PaidKind.ObjectId
                              --, MILinkObject_Branch.ObjectId
                                , CLO_Contract.ObjectId, MILinkObject_ContractChild.ObjectId

                              --, MILinkObject_Goods.ObjectId
                              --, MILinkObject_GoodsKind.ObjectId

                                , MILinkObject_ContractConditionKind.ObjectId
                                , MILinkObject_BonusKind.ObjectId
                                , MIFloat_BonusValue.ValueData
                                , ObjectLink_Contract_PaidKind.ChildObjectId
                        UNION ALL
                         SELECT MovementItemContainer.OperDate  AS OperDate
                              , CLO_Juridical.ObjectId          AS JuridicalId
                              , CLO_Partner.ObjectId            AS PartnerId
                              , CLO_InfoMoney.ObjectId          AS InfoMoneyId
                              , COALESCE (ObjectLink_Contract_PaidKind.ChildObjectId, CLO_PaidKind.ObjectId) AS PaidKindId
                              , CLO_PaidKind.ObjectId           AS PaidKindId_bonus
                              , CLO_Branch.ObjectId             AS BranchId
                              , COALESCE (MILinkObject_ContractChild.ObjectId, CLO_Contract.ObjectId) AS ContractId

                              , 0 AS GoodsId
                              , 0 AS GoodsKindId

                              , COALESCE (MILinkObject_ContractConditionKind.ObjectId,0)                  AS ContractConditionKindId
                              , COALESCE (MILinkObject_BonusKind.ObjectId,0)                              AS BonusKindId
                              , COALESCE (MIFloat_BonusValue.ValueData,0)                                 AS BonusTax

                              , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                               THEN -1 * MovementItemContainer.Amount
                                          ELSE 0
                                     END) AS BonusBasis
                              , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                               THEN 0
                                          ELSE -1 * MovementItemContainer.Amount
                                     END) AS Bonus
                         FROM Movement
                              INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                              AND MovementItemContainer.DescId = zc_MIContainer_Summ()
                                                              AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
                              INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                                  AND Container.ObjectId = zc_Enum_Account_70301() -- !!!
                              -- НАЛ
                              INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                             ON CLO_PaidKind.ContainerId = Container.Id
                                                            AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                                            AND CLO_PaidKind.ObjectId    = zc_Enum_PaidKind_SecondForm()

                              LEFT JOIN ContainerLinkObject AS CLO_Juridical ON CLO_Juridical.ContainerId = Container.Id AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                              LEFT JOIN ContainerLinkObject AS CLO_Contract  ON CLO_Contract.ContainerId  = Container.Id AND CLO_Contract.DescId  = zc_ContainerLinkObject_Contract()
                              LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                              LEFT JOIN ContainerLinkObject AS CLO_Partner   ON CLO_Partner.ContainerId   = Container.Id AND CLO_Partner.DescId   = zc_ContainerLinkObject_Partner()
                              LEFT JOIN ContainerLinkObject AS CLO_Branch    ON CLO_Branch.ContainerId    = Container.Id AND CLO_Branch.DescId    = zc_ContainerLinkObject_Branch()

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                               ON MILinkObject_ContractChild.MovementItemId = MovementItemContainer.MovementItemId
                                                              AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
                              LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                                   ON ObjectLink_Contract_PaidKind.ObjectId = MILinkObject_ContractChild.ObjectId
                                                  AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                              LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                                        ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                                       AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()

                              LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                               ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                                               ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_BonusKind.DescId = zc_MILinkObject_BonusKind()
                              LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                                          ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                                         AND MIFloat_BonusValue.DescId = zc_MIFloat_BonusValue()

                         WHERE Movement.DescId = zc_Movement_ProfitLossService()
                         GROUP BY MovementItemContainer.OperDate
                                , CLO_Juridical.ObjectId
                                , CLO_Partner.ObjectId
                                , CLO_InfoMoney.ObjectId
                                , CLO_PaidKind.ObjectId
                                , CLO_Branch.ObjectId
                                , MILinkObject_ContractChild.ObjectId, CLO_Contract.ObjectId

                                , MILinkObject_ContractConditionKind.ObjectId
                                , MILinkObject_BonusKind.ObjectId
                                , MIFloat_BonusValue.ValueData
                                , ObjectLink_Contract_PaidKind.ChildObjectId
                        )
          , tmpOperation_all AS
           (SELECT tmpOperation_SaleReturn.OperDate

                 , tmpOperation_SaleReturn.JuridicalId
                 , tmpOperation_SaleReturn.PartnerId
                 , tmpOperation_SaleReturn.InfoMoneyId
                 , tmpOperation_SaleReturn.PaidKindId
                 , 0 AS PaidKindId_bonus
                 , tmpOperation_SaleReturn.BranchId
                 , tmpOperation_SaleReturn.ContractId

                 , tmpOperation_SaleReturn.GoodsId
                 , tmpOperation_SaleReturn.GoodsKindId

                 , (tmpOperation_SaleReturn.Actions_Summ) AS Actions_Summ
                 , (tmpOperation_SaleReturn.Sale_Summ)    AS Sale_Summ
                 , (tmpOperation_SaleReturn.Return_Summ)  AS Return_Summ

                 , (tmpOperation_SaleReturn.Sale_Summ_10200)   AS Sale_Summ_10200
                 , (tmpOperation_SaleReturn.Sale_Summ_10250)   AS Sale_Summ_10250
                 , (tmpOperation_SaleReturn.Sale_Summ_10300)   AS Sale_Summ_10300
                 , (tmpOperation_SaleReturn.Return_Summ_10300) AS Return_Summ_10300
                 , (tmpOperation_SaleReturn.Return_Summ_10700) AS Return_Summ_10700

                 , (tmpOperation_SaleReturn.Sale_Amount)    AS Sale_Amount
                 , (tmpOperation_SaleReturn.Return_Amount)  AS Return_Amount

                 , (tmpOperation_SaleReturn.Actions_AmountPartner) AS Actions_AmountPartner
                 , (tmpOperation_SaleReturn.Sale_AmountPartner)    AS Sale_AmountPartner
                 , (tmpOperation_SaleReturn.Return_AmountPartner)  AS Return_AmountPartner

                 , (tmpOperation_SaleReturn.Sale_Amount_10500)
                 , (tmpOperation_SaleReturn.Sale_Amount_40200)
                 , (tmpOperation_SaleReturn.Return_Amount_40200)

                 , (tmpOperation_SaleReturn.Actions_SummCost)    AS Actions_SummCost
                 , (tmpOperation_SaleReturn.Sale_SummCost)       AS Sale_SummCost
                 , (tmpOperation_SaleReturn.Sale_SummCost_10500) AS Sale_SummCost_10500
                 , (tmpOperation_SaleReturn.Sale_SummCost_40200) AS Sale_SummCost_40200

                 , (tmpOperation_SaleReturn.Return_SummCost)       AS Return_SummCost
                 , (tmpOperation_SaleReturn.Return_SummCost_40200) AS Return_SummCost_40200

                 , (tmpOperation_SaleReturn.Sale_SummIn_pav)       AS Sale_SummIn_pav
                 , (tmpOperation_SaleReturn.ReturnIn_SummIn_pav)   AS ReturnIn_SummIn_pav

                 , 0 AS BonusBasis
                 , 0 AS Bonus

                 , 0          AS ContractConditionKindId
                 , 0          AS BonusKindId
                 , 0 ::TFloat AS BonusTax
            FROM tmpOperation_SaleReturn
                 /*INNER JOIN ObjectLink AS ObjectLink_InfoMoneyDestination
                                       ON ObjectLink_InfoMoneyDestination.ObjectId = tmpOperation_SaleReturn.InfoMoneyId
                                      AND ObjectLink_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                      AND ObjectLink_InfoMoneyDestination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100() -- !!!Доходы + Продукция!!!
                                                                                          , zc_Enum_InfoMoneyDestination_30200() -- !!!Доходы + Мясное сырье!!!
                                                                                          , zc_Enum_InfoMoneyDestination_30300() -- !!!Доходы + Переработка!!!
                                                                                          , zc_Enum_InfoMoneyDestination_30500() -- !!!Доходы + Прочие доходы!!!
                                                                                           )*/
           UNION ALL
            SELECT tmpBonus.OperDate

                 , tmpBonus.JuridicalId
                 , tmpBonus.PartnerId
                 , tmpBonus.InfoMoneyId
                 , tmpBonus.PaidKindId
                 , tmpBonus.PaidKindId_bonus
                 , tmpBonus.BranchId
                 , tmpBonus.ContractId

                 , tmpBonus.GoodsId
                 , tmpBonus.GoodsKindId

                 , 0 AS Actions_Summ
                 , 0 AS Sale_Summ
                 , 0 AS Return_Summ

                 , 0 AS Sale_Summ_10200
                 , 0 AS Sale_Summ_10250
                 , 0 AS Sale_Summ_10300
                 , 0 AS Return_Summ_10300
                 , 0 AS Return_Summ_10700

                 , 0 AS Sale_Amount
                 , 0 AS Return_Amount

                 , 0 AS Actions_AmountPartner
                 , 0 AS Sale_AmountPartner
                 , 0 AS Return_AmountPartner

                 , 0 AS Sale_Amount_10500
                 , 0 AS Sale_Amount_40200
                 , 0 AS Return_Amount_40200

                 , 0 AS Actions_SummCost
                 , 0 AS Sale_SummCost
                 , 0 AS Sale_SummCost_10500
                 , 0 AS Sale_SummCost_40200

                 , 0 AS Return_SummCost
                 , 0 AS Return_SummCost_40200

                 , 0 AS Sale_SummIn_pav
                 , 0 AS ReturnIn_SummIn_pav

                 , (tmpBonus.BonusBasis) AS BonusBasis
                 , (tmpBonus.Bonus)      AS Bonus

                 , tmpBonus.ContractConditionKindId
                 , tmpBonus.BonusKindId
                 , tmpBonus.BonusTax  :: TFloat

            FROM tmpBonus)

          , tmpOperation AS
           (SELECT tmpOperation_all.OperDate

                 , tmpOperation_all.JuridicalId
                 , tmpOperation_all.PartnerId
                 , tmpOperation_all.InfoMoneyId
                 , tmpOperation_all.PaidKindId
                 , tmpOperation_all.PaidKindId_bonus
                 , tmpOperation_all.BranchId
                 , tmpOperation_all.ContractId

                 , tmpOperation_all.GoodsId
                 , tmpOperation_all.GoodsKindId

                 , SUM (tmpOperation_all.Actions_Summ) AS Actions_Summ
                 , SUM (tmpOperation_all.Sale_Summ)    AS Sale_Summ
                 , SUM (tmpOperation_all.Return_Summ)  AS Return_Summ

                 , SUM (tmpOperation_all.Sale_Summ_10200)   AS Sale_Summ_10200
                 , SUM (tmpOperation_all.Sale_Summ_10250)   AS Sale_Summ_10250
                 , SUM (tmpOperation_all.Sale_Summ_10300)   AS Sale_Summ_10300
                 , SUM (tmpOperation_all.Return_Summ_10300) AS Return_Summ_10300
                 , SUM (tmpOperation_all.Return_Summ_10700) AS Return_Summ_10700

                 , SUM (tmpOperation_all.Sale_Amount)   AS Sale_Amount
                 , SUM (tmpOperation_all.Return_Amount) AS Return_Amount

                 , SUM (tmpOperation_all.Actions_AmountPartner) AS Actions_AmountPartner
                 , SUM (tmpOperation_all.Sale_AmountPartner)    AS Sale_AmountPartner
                 , SUM (tmpOperation_all.Return_AmountPartner)  AS Return_AmountPartner

                 , SUM (tmpOperation_all.Sale_Amount_10500)   AS Sale_Amount_10500
                 , SUM (tmpOperation_all.Sale_Amount_40200)   AS Sale_Amount_40200
                 , SUM (tmpOperation_all.Return_Amount_40200) AS Return_Amount_40200

                 , SUM (tmpOperation_all.Actions_SummCost)    AS Actions_SummCost
                 , SUM (tmpOperation_all.Sale_SummCost)       AS Sale_SummCost
                 , SUM (tmpOperation_all.Sale_SummCost_10500) AS Sale_SummCost_10500
                 , SUM (tmpOperation_all.Sale_SummCost_40200) AS Sale_SummCost_40200

                 , SUM (tmpOperation_all.Return_SummCost)       AS Return_SummCost
                 , SUM (tmpOperation_all.Return_SummCost_40200) AS Return_SummCost_40200

                 , SUM (tmpOperation_all.Sale_SummIn_pav)       AS Sale_SummIn_pav
                 , SUM (tmpOperation_all.ReturnIn_SummIn_pav)   AS ReturnIn_SummIn_pav

                 , SUM (tmpOperation_all.BonusBasis) AS BonusBasis
                 , SUM (tmpOperation_all.Bonus)      AS Bonus

                 , tmpOperation_all.ContractConditionKindId
                 , tmpOperation_all.BonusKindId
                 , tmpOperation_all.BonusTax

            FROM tmpOperation_all
            GROUP BY tmpOperation_all.OperDate

                   , tmpOperation_all.JuridicalId
                   , tmpOperation_all.PartnerId
                   , tmpOperation_all.InfoMoneyId
                   , tmpOperation_all.PaidKindId
                   , tmpOperation_all.PaidKindId_bonus
                   , tmpOperation_all.BranchId
                   , tmpOperation_all.ContractId

                   , tmpOperation_all.GoodsId
                   , tmpOperation_all.GoodsKindId

                   , tmpOperation_all.ContractConditionKindId
                   , tmpOperation_all.BonusKindId
                   , tmpOperation_all.BonusTax
            )

      -- РЕЗУЛЬТАТ
      SELECT tmpResult.OperDate
           , 0 AS AccountId

           , tmpResult.BranchId
           , ObjectLink_JuridicalGroup.ChildObjectId AS JuridicalGroupId
           , tmpResult.JuridicalId
           , tmpResult.PartnerId
           , tmpResult.InfoMoneyId
           , tmpResult.PaidKindId
           , tmpResult.PaidKindId_bonus
           , ObjectLink_Juridical_Retail.ChildObjectId             AS RetailId
           , ObjectLink_Juridical_RetailReport.ChildObjectId       AS RetailReportId
           , View_Partner_Address.AreaId
           , View_Partner_Address.PartnerTagId
           , tmpResult.ContractId
           , ObjectLink_Contract_ContractTag.ChildObjectId         AS ContractTagId
           , ObjectLink_ContractTag_ContractTagGroup.ChildObjectId AS ContractTagGroupId

           , ObjectLink_Partner_Personal.ChildObjectId             AS PersonalId
           , ObjectLink_Personal_Unit.ChildObjectId                AS UnitId_Personal
           , ObjectLink_Unit_Branch.ChildObjectId                  AS BranchId_Personal
           , ObjectLink_Partner_PersonalTrade.ChildObjectId        AS PersonalTradeId
           , ObjectLink_PersonalTrade_Unit.ChildObjectId           AS UnitId_PersonalTrade

           , ObjectLink_Goods_Business.ChildObjectId               AS BusinessId
           , ObjectLink_Goods_GoodsPlatform.ChildObjectId          AS GoodsPlatformId
           , ObjectLink_Goods_TradeMark.ChildObjectId              AS TradeMarkId
           , ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId      AS GoodsGroupAnalystId
           , ObjectLink_Goods_GoodsTag.ChildObjectId               AS GoodsTagId
           , ObjectLink_Goods_GoodsGroup.ChildObjectId             AS GoodsGroupId
           , ObjectLink_Goods_GoodsGroupStat.ChildObjectId         AS GoodsGroupStatId
           , tmpResult.GoodsId
           , tmpResult.GoodsKindId
           , ObjectLink_Goods_Measure.ChildObjectId                AS MeasureId

           , View_Partner_Address.RegionId
           , View_Partner_Address.ProvinceId
           , View_Partner_Address.CityKindId
           , View_Partner_Address.CityId
           , View_Partner_Address.ProvinceCityId
           , View_Partner_Address.StreetKindId
           , View_Partner_Address.StreetId

           , tmpResult.Actions_AmountPartner_Weight AS Actions_Weight
           , tmpResult.Actions_AmountPartner_Sh     AS Actions_Sh
           , tmpResult.Actions_SummCost
           , tmpResult.Actions_Summ

           , tmpResult.Sale_Summ
           , tmpResult.Sale_Summ_10200
           , tmpResult.Sale_Summ_10250
           , tmpResult.Sale_Summ_10300
           , tmpResult.Sale_SummCost
           , tmpResult.Sale_SummCost_10500
           , tmpResult.Sale_SummCost_40200

           , tmpResult.Sale_Amount_Weight
           , tmpResult.Sale_Amount_Sh
           , tmpResult.Sale_AmountPartner_Weight
           , tmpResult.Sale_AmountPartner_Sh
           , tmpResult.Sale_Amount_10500_Weight
           , tmpResult.Sale_Amount_40200_Weight

           , tmpResult.Return_Summ
           , tmpResult.Return_Summ_10300
           , tmpResult.Return_Summ_10700
           , tmpResult.Return_SummCost
           , tmpResult.Return_SummCost_40200

           , tmpResult.Return_Amount_Weight
           , tmpResult.Return_Amount_Sh
           , tmpResult.Return_AmountPartner_Weight
           , tmpResult.Return_AmountPartner_Sh
           , tmpResult.Return_Amount_40200_Weight

           , (tmpResult.Sale_Summ - tmpResult.Return_Summ)                     AS SaleReturn_Summ
           , (tmpResult.Sale_Summ_10300 - tmpResult.Return_Summ_10300)         AS SaleReturn_Summ_10300
           , (tmpResult.Sale_SummCost - tmpResult.Return_SummCost)             AS SaleReturn_SummCost
           , (tmpResult.Sale_SummCost_40200 + tmpResult.Return_SummCost_40200) AS SaleReturn_SummCost_40200 -- !!!здесь сумма!!!
           , (tmpResult.Sale_AmountPartner_Weight - tmpResult.Return_AmountPartner_Weight)   AS SaleReturn_Amount_Weight
           , (tmpResult.Sale_AmountPartner_Sh - tmpResult.Return_AmountPartner_Sh)           AS SaleReturn_Amount_Sh

           , (tmpResult.BonusBasis)   AS BonusBasis
           , (tmpResult.Bonus)        AS Bonus

           , 0, 0
           , 0, 0, 0

           , tmpResult.Sale_SummIn_pav
           , tmpResult.ReturnIn_SummIn_pav

           , tmpResult.ContractConditionKindId
           , tmpResult.BonusKindId
           , tmpResult.BonusTax
           
           , COALESCE (tmpGoodsByGoodsKind.Id, 0) AS GoodsByGoodsKindId

      FROM (SELECT tmpOperation.OperDate

                 , tmpOperation.JuridicalId
                 , tmpOperation.PartnerId
                 , tmpOperation.InfoMoneyId
                 , tmpOperation.PaidKindId
                 , tmpOperation.PaidKindId_bonus
                 , tmpOperation.BranchId
                 , tmpOperation.ContractId

                 , tmpOperation.GoodsId
                 , tmpOperation.GoodsKindId

                 , tmpOperation.ContractConditionKindId
                 , tmpOperation.BonusKindId
                 , tmpOperation.BonusTax

                 , SUM (tmpOperation.Actions_Summ) AS Actions_Summ
                 , SUM (tmpOperation.Sale_Summ)    AS Sale_Summ
                 , SUM (tmpOperation.Return_Summ)  AS Return_Summ

                 , SUM (tmpOperation.Sale_Summ_10200)   AS Sale_Summ_10200
                 , SUM (tmpOperation.Sale_Summ_10250)   AS Sale_Summ_10250
                 , SUM (tmpOperation.Sale_Summ_10300)   AS Sale_Summ_10300
                 , SUM (tmpOperation.Return_Summ_10300) AS Return_Summ_10300
                 , SUM (tmpOperation.Return_Summ_10700) AS Return_Summ_10700

                 , SUM (tmpOperation.Sale_Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Sale_Amount_Weight
                 , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperation.Sale_Amount ELSE 0 END) AS Sale_Amount_Sh
                 , SUM (tmpOperation.Return_Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Return_Amount_Weight
                 , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperation.Return_Amount ELSE 0 END) AS Return_Amount_Sh

                 , SUM (tmpOperation.Sale_AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Sale_AmountPartner_Weight
                 , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperation.Sale_AmountPartner ELSE 0 END) AS Sale_AmountPartner_Sh
                 , SUM (tmpOperation.Return_AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Return_AmountPartner_Weight
                 , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperation.Return_AmountPartner ELSE 0 END) AS Return_AmountPartner_Sh

                 , SUM (tmpOperation.Actions_AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Actions_AmountPartner_Weight
                 , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperation.Actions_AmountPartner ELSE 0 END) AS Actions_AmountPartner_Sh

                 , SUM (tmpOperation.Sale_Amount_10500 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Sale_Amount_10500_Weight
                 , SUM (tmpOperation.Sale_Amount_40200 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Sale_Amount_40200_Weight
                 , SUM (tmpOperation.Return_Amount_40200 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Return_Amount_40200_Weight

                 , SUM (tmpOperation.Actions_SummCost)    AS Actions_SummCost
                 , SUM (tmpOperation.Sale_SummCost)       AS Sale_SummCost
                 , SUM (tmpOperation.Sale_SummCost_10500) AS Sale_SummCost_10500
                 , SUM (tmpOperation.Sale_SummCost_40200) AS Sale_SummCost_40200

                 , SUM (tmpOperation.Return_SummCost)       AS Return_SummCost
                 , SUM (tmpOperation.Return_SummCost_40200) AS Return_SummCost_40200

                 , SUM (tmpOperation.Sale_SummIn_pav)       AS Sale_SummIn_pav
                 , SUM (tmpOperation.ReturnIn_SummIn_pav)   AS ReturnIn_SummIn_pav

                 , SUM (tmpOperation.BonusBasis) AS BonusBasis
                 , SUM (tmpOperation.Bonus)      AS Bonus

            FROM tmpOperation
                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                      ON ObjectLink_Goods_Measure.ObjectId = tmpOperation.GoodsId
                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                       ON ObjectFloat_Weight.ObjectId = tmpOperation.GoodsId
                                      AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            GROUP BY tmpOperation.OperDate

                   , tmpOperation.JuridicalId
                   , tmpOperation.PartnerId
                   , tmpOperation.InfoMoneyId
                   , tmpOperation.PaidKindId
                   , tmpOperation.PaidKindId_bonus
                   , tmpOperation.BranchId
                   , tmpOperation.ContractId

                   , tmpOperation.GoodsId
                   , tmpOperation.GoodsKindId

                   , tmpOperation.ContractConditionKindId
                   , tmpOperation.BonusKindId
                   , tmpOperation.BonusTax
           ) AS tmpResult

           LEFT JOIN tmpPartnerAddress AS View_Partner_Address ON View_Partner_Address.PartnerId = tmpResult.PartnerId

           LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                ON ObjectLink_Goods_Business.ObjectId = tmpResult.GoodsId
                               AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                ON ObjectLink_Goods_GoodsPlatform.ObjectId = tmpResult.GoodsId
                               AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                ON ObjectLink_Goods_TradeMark.ObjectId = tmpResult.GoodsId
                               AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = tmpResult.GoodsId
                               AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                ON ObjectLink_Goods_GoodsTag.ObjectId = tmpResult.GoodsId
                               AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpResult.GoodsId
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                                ON ObjectLink_Goods_GoodsGroupStat.ObjectId = tmpResult.GoodsId
                               AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                ON ObjectLink_Goods_Measure.ObjectId = tmpResult.GoodsId
                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

           LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                ON ObjectLink_Contract_ContractTag.ObjectId = tmpResult.ContractId
                               AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
           LEFT JOIN ObjectLink AS ObjectLink_ContractTag_ContractTagGroup
                                ON ObjectLink_ContractTag_ContractTagGroup.ObjectId = ObjectLink_Contract_ContractTag.ChildObjectId
                               AND ObjectLink_ContractTag_ContractTagGroup.DescId = zc_ObjectLink_ContractTag_ContractTagGroup()

           LEFT JOIN ObjectLink AS ObjectLink_JuridicalGroup
                                ON ObjectLink_JuridicalGroup.ObjectId = tmpResult.JuridicalId
                               AND ObjectLink_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = tmpResult.JuridicalId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_RetailReport
                                ON ObjectLink_Juridical_RetailReport.ObjectId = tmpResult.JuridicalId
                               AND ObjectLink_Juridical_RetailReport.DescId = zc_ObjectLink_Juridical_RetailReport()

           LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                ON ObjectLink_Partner_Personal.ObjectId = tmpResult.PartnerId
                               AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
           LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Partner_Personal.ChildObjectId
                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                               AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

           LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                ON ObjectLink_Partner_PersonalTrade.ObjectId = tmpResult.PartnerId
                               AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
           LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Unit
                                ON ObjectLink_PersonalTrade_Unit.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                               AND ObjectLink_PersonalTrade_Unit.DescId = zc_ObjectLink_Personal_Unit()
           LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = tmpResult.GoodsId
                                        AND tmpGoodsByGoodsKind.GoodsKindId = tmpResult.GoodsKindId

     UNION ALL
      -- еще РЕЗУЛЬТАТ
      SELECT MovementItemContainer.OperDate
           , 0                                                     AS AccountId

           , 0                                                     AS BranchId
           , ObjectLink_JuridicalGroup.ChildObjectId               AS JuridicalGroupId
           , CLO_Juridical.ObjectId                                AS JuridicalId
           , 0                                                     AS PartnerId
           , CLO_InfoMoney.ObjectId                                AS InfoMoneyId
           , CLO_PaidKind.ObjectId                                 AS PaidKindId
           , 0                                                     AS PaidKindId_bonus
           , ObjectLink_Juridical_Retail.ChildObjectId             AS RetailId
           , ObjectLink_Juridical_RetailReport.ChildObjectId       AS RetailReportId
           , 0 AS AreaId
           , 0 AS PartnerTagId
           , CLO_Contract.ObjectId                                 AS ContractId
           , ObjectLink_Contract_ContractTag.ChildObjectId         AS ContractTagId
           , ObjectLink_ContractTag_ContractTagGroup.ChildObjectId AS ContractTagGroupId

           , 0 AS PersonalId, 0 AS UnitId_Personal, 0 AS BranchId_Personal, 0 AS PersonalTradeId, 0 AS UnitId_PersonalTrade
           , 0 AS BusinessId, 0 AS GoodsPlatformId, 0 AS TradeMarkId, 0 AS GoodsGroupAnalystId, 0 AS GoodsTagId, 0 AS GoodsGroupId, 0 AS GoodsGroupStatId, 0 AS GoodsId, 0 AS GoodsKindId, 0 AS MeasureId
           , 0 AS RegionId, 0 AS ProvinceId, 0 AS CityKindId, 0 AS CityId, 0 AS ProvinceCityId, 0 AS StreetKindId, 0 AS StreetId

           , 0 AS Actions_Weight, 0 AS Actions_Sh, 0 AS Actions_SummCost, 0 AS Actions_Summ
           , 0 AS Sale_Summ, 0 AS Sale_Summ_10200, 0 AS Sale_Summ_10250, 0 AS Sale_Summ_10300, 0 AS Sale_SummCost, 0 AS Sale_SummCost_10500, 0 AS Sale_SummCost_40200
           , 0 AS Sale_Amount_Weight, 0 AS Sale_Amount_Sh, 0 AS Sale_AmountPartner_Weight, 0 AS Sale_AmountPartner_Sh, 0 AS Sale_Amount_10500_Weight, 0 AS Sale_Amount_40200_Weight
           , 0 AS Return_Summ, 0 AS Return_Summ_10300, 0 AS Return_Summ_10700, 0 AS Return_SummCost, 0 AS Return_SummCost_40200
           , 0 AS Return_Amount_Weight, 0 AS Return_Amount_Sh, 0 AS Return_AmountPartner_Weight, 0 AS Return_AmountPartner_Sh, 0 AS Return_Amount_40200_Weight
           , 0 AS SaleReturn_Summ, 0 AS SaleReturn_Summ_10300, 0 AS SaleReturn_SummCost, 0 AS SaleReturn_SummCost_40200, 0 AS SaleReturn_Amount_Weight, 0 AS SaleReturn_Amount_Sh
           , 0 AS BonusBasis, 0 AS Bonus
           , 0 AS Plan_Weight, 0 AS Plan_Summ
           , -1 * SUM (CASE WHEN Movement.DescId IN (zc_Movement_Cash(), zc_Movement_BankAccount()) THEN MovementItemContainer.Amount ELSE 0 END) AS Money_Summ
           , -1 * SUM (CASE WHEN Movement.DescId = zc_Movement_SendDebt() THEN MovementItemContainer.Amount ELSE 0 END) AS SendDebt_Summ
           , -1 * SUM (MovementItemContainer.Amount) AS Money_SendDebt_Summ

           , 0 AS Sale_SummIn_pav
           , 0 AS ReturnIn_SummIn_pav

           , 0 AS ContractConditionKindId
           , 0 AS BonusKindId
           , 0 ::TFloat AS BonusTax
           
           , 0 AS GoodsByGoodsKindId

   FROM Movement
        JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                  AND MovementItemContainer.DescId = zc_MIContainer_Summ()
                                  AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
        JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                      AND Container.DescId = zc_Container_Summ()
        INNER JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        INNER JOIN ObjectLink AS ObjectLink_InfoMoneyDestination
                              ON ObjectLink_InfoMoneyDestination.ObjectId = CLO_InfoMoney.ObjectId
                             AND ObjectLink_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                             AND ObjectLink_InfoMoneyDestination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100() -- !!!Доходы + Продукция!!!
                                                                                 , zc_Enum_InfoMoneyDestination_30200() -- !!!Доходы + Мясное сырье!!!
                                                                                 , zc_Enum_InfoMoneyDestination_30300() -- !!!Доходы + Переработка!!!
                                                                                  )

        LEFT JOIN ContainerLinkObject AS CLO_Juridical ON CLO_Juridical.ContainerId = Container.Id AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
        LEFT JOIN ContainerLinkObject AS CLO_PaidKind ON CLO_PaidKind.ContainerId = Container.Id AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
        LEFT JOIN ContainerLinkObject AS CLO_Contract ON CLO_Contract.ContainerId = Container.Id AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()

           LEFT JOIN ObjectLink AS ObjectLink_JuridicalGroup
                                ON ObjectLink_JuridicalGroup.ObjectId = CLO_Juridical.ObjectId
                               AND ObjectLink_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = CLO_Juridical.ObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_RetailReport
                                ON ObjectLink_Juridical_RetailReport.ObjectId = CLO_Juridical.ObjectId
                               AND ObjectLink_Juridical_RetailReport.DescId = zc_ObjectLink_Juridical_RetailReport()
           LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                ON ObjectLink_Contract_ContractTag.ObjectId = CLO_Contract.ObjectId
                               AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
           LEFT JOIN ObjectLink AS ObjectLink_ContractTag_ContractTagGroup
                                ON ObjectLink_ContractTag_ContractTagGroup.ObjectId = CLO_Contract.ObjectId
                               AND ObjectLink_ContractTag_ContractTagGroup.DescId = zc_ObjectLink_ContractTag_ContractTagGroup()
    WHERE Movement.DescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_SendDebt())
    GROUP BY MovementItemContainer.OperDate
           , CLO_PaidKind.ObjectId
           , CLO_Juridical.ObjectId
           , CLO_Juridical.ObjectId
           , CLO_Contract.ObjectId
           , CLO_InfoMoney.ObjectId
           , ObjectLink_JuridicalGroup.ChildObjectId
           , ObjectLink_Juridical_Retail.ChildObjectId
           , ObjectLink_Juridical_RetailReport.ChildObjectId
           , ObjectLink_Contract_ContractTag.ChildObjectId
           , ObjectLink_ContractTag_ContractTagGroup.ChildObjectId
   ;


    --
    UPDATE SoldTable SET               -- Прибыль (только реализ)
                         Sale_Profit = COALESCE(Sale_Summ, 0) - COALESCE(Sale_SummCost, 0)
                                       -- Прибыль с учетом бонусов (только реализ)
                  , SaleBonus_Profit = COALESCE(Sale_Summ, 0) - COALESCE(Sale_SummCost, 0) - COALESCE(BonusBasis, 0) - COALESCE(Bonus, 0)
                                       -- Прибыль с учетом !!!возврата!!!
                 , SaleReturn_Profit = COALESCE(Sale_Summ, 0) - COALESCE(Sale_SummCost, 0) - COALESCE(Return_Summ, 0)
                                       -- Прибыль с учетом !!!возврата!!! и бонусов
            , SaleReturnBonus_Profit = COALESCE(Sale_Summ, 0) - COALESCE(Sale_SummCost, 0) - COALESCE(Return_Summ, 0) - COALESCE(BonusBasis, 0) - COALESCE(Bonus, 0)
    WHERE OperDate BETWEEN inStartDate AND inEndDate;



    IF DATE_TRUNC ('MONTH', CURRENT_TIMESTAMP) = DATE_TRUNC ('MONTH', inEndDate)
       AND (EXTRACT (HOUR FROM CURRENT_TIMESTAMP) > 8 OR EXTRACT (DAY FROM CURRENT_TIMESTAMP) > 1)
    THEN
        -- сохранили <По какую дату включительно сформированы данные Олап Продажа/возврат>
        PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GlobalConst_ActualBankStatement(), zc_Enum_GlobalConst_EndDateOlapSR(), inEndDate);

        -- сохранили <Дата формирования данных Олап Продажа/возврат>
        PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GlobalConst_ActualBankStatement(), zc_Enum_GlobalConst_ProtocolDateOlapSR(), CURRENT_TIMESTAMP);

    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION FillSoldTable (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.01.15                                        * all
 26.11.14                         *
 25.11.14                                        * add Sale_SummCost Return_SummCost
 19.11.14                         * add
*/
/*
SELECT object_p.ValueData, object_g.ValueData, object_gk.ValueData, sum (Sale_Summ)
, DATE_TRUNC ('month', OperDate)
FROM SoldTable
left join object as object_p on object_p.Id = PartnerId
left join object as object_g on object_g.Id = GoodsId
left join object as object_gk on object_gk.Id = GoodsKindId
where OperDate BETWEEN '01.06.2014' and  '31.12.2014'
group by object_p.ValueData, object_g.ValueData , object_gk.ValueData
, DATE_TRUNC ('month', OperDate)
*/

/*
-- !!!check goods params
--
--      select * from Object where id = 8451
-- update SoldTable set GoodsByGoodsKindId = tmpGoodsByGoodsKind.Id
 select distinct SoldTable .GoodsId FROM SoldTable, 
-- FROM 
    (select Object.Id AS GoodsId
           , ObjectLink_Goods_Business.ChildObjectId               AS BusinessId
           , ObjectLink_Goods_GoodsPlatform.ChildObjectId          AS GoodsPlatformId
           , ObjectLink_Goods_TradeMark.ChildObjectId              AS TradeMarkId
           , ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId      AS GoodsGroupAnalystId
           , ObjectLink_Goods_GoodsTag.ChildObjectId               AS GoodsTagId
           , ObjectLink_Goods_GoodsGroup.ChildObjectId             AS GoodsGroupId
           , ObjectLink_Goods_GoodsGroupStat.ChildObjectId         AS GoodsGroupStatId
           , ObjectLink_Goods_Measure.ChildObjectId                AS MeasureId
      from Object
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                ON ObjectLink_Goods_Business.ObjectId = Object.Id
                               AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object.Id
                               AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                ON ObjectLink_Goods_TradeMark.ObjectId = Object.Id
                               AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object.Id
                               AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                ON ObjectLink_Goods_GoodsTag.ObjectId = Object.Id
                               AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object.Id
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                                ON ObjectLink_Goods_GoodsGroupStat.ObjectId = Object.Id
                               AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
      
     ) AS tmp
where tmp.GoodsId  = SoldTable .GoodsId
  AND SoldTable.OperDate BETWEEN '01.01.2022' AND '31.08.2022'
  AND (coalesce (tmp.BusinessId, 0) <> tmp.BusinessId
    OR coalesce (tmp.GoodsPlatformId, 0) <> tmp.GoodsPlatformId
    OR coalesce (tmp.TradeMarkId, 0) <> tmp.TradeMarkId
    OR coalesce (tmp.GoodsGroupAnalystId, 0) <> tmp.GoodsGroupAnalystId
    OR coalesce (tmp.GoodsTagId, 0) <> tmp.GoodsTagId
    OR coalesce (tmp.GoodsGroupId, 0) <> tmp.GoodsGroupId
    OR coalesce (tmp.GoodsGroupStatId, 0) <> tmp.GoodsGroupStatId
    OR coalesce (tmp.MeasureId, 0) <> tmp.MeasureId
      )
*/
-- тест
-- SELECT * FROM SoldTable where OperDate = '03.09.2015'
-- SELECT * FROM FillSoldTable ('01.11.2022', '30.11.2022', zfCalc_UserAdmin())
