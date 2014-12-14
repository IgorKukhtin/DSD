 -- Function: gpReport_Goods_Movement ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnIn (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnIn (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_SaleReturnIn (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inJuridicalId  Integer   ,
    IN inGoodsGroupId Integer   ,
    IN inPaidKindId   Integer   , --
    IN inInfoMoneyId  Integer,    -- Управленческая статья
    IN inIsPartner    Boolean,    --
    IN inIsGoods      Boolean,    --
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar, GoodsTagName TVarChar, GoodsGroupStatName TVarChar
             , JuridicalGroupName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar, OKPO TVarChar
             , RetailName TVarChar, RetailReportName TVarChar
             , AreaName TVarChar, PartnerTagName TVarChar
             , RegionName TVarChar, ProvinceName TVarChar, CityKindName TVarChar, CityName TVarChar, ProvinceCityName TVarChar, StreetKindName TVarChar, StreetName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar
             , PersonalName TVarChar, UnitName_Personal TVarChar, BranchName_Personal TVarChar
             , PersonalTradeName TVarChar, UnitName_PersonalTrade TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , Sale_Summ TFloat, Sale_SummCost TFloat, Sale_Amount_Weight TFloat , Sale_Amount_Sh TFloat, Sale_AmountPartner_Weight TFloat , Sale_AmountPartner_Sh TFloat
             , Return_Summ TFloat, Return_SummCost TFloat, Return_Amount_Weight TFloat , Return_Amount_Sh TFloat, Return_AmountPartner_Weight TFloat , Return_AmountPartner_Sh TFloat
              )
AS
$BODY$
BEGIN

  /*IF COALESCE (inJuridicalId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Не выбрано юр.лицов!!!';
   END IF;*/

    -- !!!т.к. нельзя когда много данных в гриде!!!
    IF inStartDate + (INTERVAL '62 DAY') <= inEndDate AND inIsPartner = TRUE AND inIsGoods = TRUE
    THEN
        inStartDate:= inEndDate + (INTERVAL '1 DAY');
    END IF;

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer, TradeMarkId Integer, GoodsTagId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId, TradeMarkId, GoodsTagId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId
                , COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0)
                , COALESCE (ObjectLink_Goods_GoodsTag.ChildObjectId, 0)
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                    AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                     ON ObjectLink_Goods_GoodsTag.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                    AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
       ;
    ELSE
        INSERT INTO _tmpGoods (GoodsId, TradeMarkId, GoodsTagId)
           SELECT Object.Id
                , COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0)
                , COALESCE (ObjectLink_Goods_GoodsTag.ChildObjectId, 0)
           FROM Object
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = Object.Id
                                    AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                     ON ObjectLink_Goods_GoodsTag.ObjectId = Object.Id
                                    AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
           WHERE Object.DescId = zc_Object_Goods()
       ;
    END IF;


   -- Результат
    RETURN QUERY

    -- ограничиваем по Юр.лицу
    WITH tmpMovement AS (SELECT tmpListContainer.JuridicalId
                              , MovementLinkObject_Partner.ObjectId AS PartnerId
                              , tmpListContainer.ContractId
                              , tmpListContainer.InfoMoneyId

                              , _tmpGoods.TradeMarkId
                              , _tmpGoods.GoodsTagId

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
                         FROM (SELECT ReportContainerLink.ReportContainerId
                                    , ReportContainerLink.AccountKindId
                                    , ContainerLO_Juridical.ObjectId         AS JuridicalId
                                    , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                    , ContainerLinkObject_PaidKind.ObjectId  AS PaidKindId
                                    , ContainerLinkObject_Contract.ObjectId  AS ContractId
                                    , CASE WHEN isSale = TRUE THEN zc_Movement_Sale() ELSE zc_Movement_ReturnIn() END AS MovementDescId
                                    , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                               FROM (SELECT ProfitLossId AS Id, isSale FROM Constant_ProfitLoss_Sale_ReturnIn_View WHERE isCost = FALSE
                                    ) AS tmpProfitLoss
                                         JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                                                  ON ContainerLO_ProfitLoss.ObjectId = tmpProfitLoss.Id
                                                                 AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                         JOIN ReportContainerLink ON ReportContainerLink.ContainerId = ContainerLO_ProfitLoss.ContainerId
                                                                 AND ReportContainerLink.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                         JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                  ON ContainerLO_Juridical.ContainerId = ReportContainerLink.ChildContainerId
                                                                 AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                 AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                         JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                  ON ContainerLinkObject_InfoMoney.ContainerId = ReportContainerLink.ChildContainerId
                                                                 AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                 AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                                         JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                                  ON ContainerLinkObject_PaidKind.ContainerId = ReportContainerLink.ChildContainerId
                                                                 AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                 AND (ContainerLinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                                         LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Contract
                                                                       ON ContainerLinkObject_Contract.ContainerId = ReportContainerLink.ChildContainerId
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
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                               ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                         GROUP BY tmpListContainer.JuridicalId
                                , MovementLinkObject_Partner.ObjectId
                                , tmpListContainer.ContractId
                                , tmpListContainer.InfoMoneyId
                                , _tmpGoods.TradeMarkId
                                , _tmpGoods.GoodsTagId
                                , MovementItem.Id
                                , MovementItem.ObjectId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                , COALESCE (MILinkObject_Branch.ObjectId, 0)
                                , tmpListContainer.MovementDescId
                                 )
     SELECT Object_GoodsGroup.ValueData AS GoodsGroupName
          , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
          , Object_Goods.ObjectCode     AS GoodsCode
          , Object_Goods.ValueData      AS GoodsName
          , Object_GoodsKind.ValueData  AS GoodsKindName
          , Object_Measure.ValueData    AS MeasureName
          , Object_TradeMark.ValueData  AS TradeMarkName
          , Object_GoodsTag.ValueData   AS GoodsTagName
          , Object_GoodsGroupStat.ValueData  AS GoodsGroupStatName

          , Object_JuridicalGroup.ValueData  AS JuridicalGroupName
          , Object_Branch.ObjectCode    AS BranchCode
          , Object_Branch.ValueData     AS BranchName
          , Object_Juridical.ObjectCode AS JuridicalCode
          , Object_Juridical.ValueData  AS JuridicalName
          , ObjectHistory_JuridicalDetails_View.OKPO

          , Object_Retail.ValueData       AS RetailName
          , Object_RetailReport.ValueData AS RetailReportName
/*
       , Object_Area.ValueData                AS AreaName
       , Object_PartnerTag.ValueData          AS PartnerTagName
       , Object_Region.ValueData              AS RegionName
       , Object_Province.ValueData            AS ProvinceName
       , Object_CityKind.ValueData            AS CityKindName
       , Object_Street_View.CityName          AS CityName
       , Object_Street_View.ProvinceCityName  AS ProvinceCityName
       , Object_Street_View.StreetKindName    AS StreetKindName
       , Object_Street_View.Name              AS StreetName

       , Object_Partner.Id                          AS PartnerId
       , Object_Partner.ObjectCode                  AS PartnerCode
       , Object_Partner.ValueData                   AS PartnerName*/

          , View_Partner_Address.AreaName
          , View_Partner_Address.PartnerTagName
          , View_Partner_Address.RegionName
          , View_Partner_Address.ProvinceName
          , View_Partner_Address.CityKindName
          , View_Partner_Address.CityName
          , View_Partner_Address.ProvinceCityName
          , View_Partner_Address.StreetKindName
          , View_Partner_Address.StreetName

          , View_Partner_Address.PartnerId
          , View_Partner_Address.PartnerCode
          , View_Partner_Address.PartnerName

          , View_Contract_InvNumber.ContractCode
          , View_Contract_InvNumber.InvNumber              AS ContractNumber
          , View_Contract_InvNumber.ContractTagName

          , View_Personal.PersonalName       AS PersonalName
          , View_Personal.UnitName           AS UnitName_Personal
          , Object_BranchPersonal.ValueData  AS BranchName_Personal

          , View_PersonalTrade.PersonalName  AS PersonalTradeName
          , View_PersonalTrade.UnitName      AS UnitName_PersonalTrade

          , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
          , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all               AS InfoMoneyName_all

         , tmpOperationGroup.Sale_Summ          :: TFloat  AS Sale_Summ
         , 0 :: TFloat  AS Sale_SummCost
         , tmpOperationGroup.Sale_Amount_Weight :: TFloat  AS Sale_Amount_Weight
         , tmpOperationGroup.Sale_Amount_Sh     :: TFloat  AS Sale_Amount_Sh

         , tmpOperationGroup.Sale_AmountPartner_Weight :: TFloat AS Sale_AmountPartner_Weight
         , tmpOperationGroup.Sale_AmountPartner_Sh     :: TFloat AS Sale_AmountPartner_Sh

         , tmpOperationGroup.Return_Summ          :: TFloat AS Return_Summ
         , 0 :: TFloat  AS Return_SummCost
         , tmpOperationGroup.Return_Amount_Weight :: TFloat AS Return_Amount_Weight
         , tmpOperationGroup.Return_Amount_Sh     :: TFloat AS Return_Amount_Sh

         , tmpOperationGroup.Return_AmountPartner_Weight :: TFloat AS Return_AmountPartner_Weight
         , tmpOperationGroup.Return_AmountPartner_Sh     :: TFloat AS Return_AmountPartner_Sh

     FROM (SELECT tmpOperation.JuridicalId
                , tmpOperation.PartnerId
                , tmpOperation.ContractId
                , tmpOperation.InfoMoneyId
                , tmpOperation.BranchId

                , tmpOperation.TradeMarkId
                , tmpOperation.GoodsTagId

                , tmpOperation.GoodsId
                , tmpOperation.GoodsKindId

                , SUM (tmpOperation.Sale_Summ)          AS Sale_Summ
                , SUM (tmpOperation.Sale_Amount_Weight) AS Sale_Amount_Weight
                , SUM (tmpOperation.Sale_Amount_Sh)     AS Sale_Amount_Sh

                , SUM (tmpOperation.Return_Summ)          AS Return_Summ
                , SUM (tmpOperation.Return_Amount_Weight) AS Return_Amount_Weight
                , SUM (tmpOperation.Return_Amount_Sh)     AS Return_Amount_Sh

                , SUM (tmpOperation.Sale_AmountPartner_Weight)   AS Sale_AmountPartner_Weight
                , SUM (tmpOperation.Sale_AmountPartner_Sh)       AS Sale_AmountPartner_Sh
                , SUM (tmpOperation.Return_AmountPartner_Weight) AS Return_AmountPartner_Weight
                , SUM (tmpOperation.Return_AmountPartner_Sh)     AS Return_AmountPartner_Sh

           FROM (SELECT CASE WHEN inIsPartner = TRUE THEN tmpMovement.JuridicalId ELSE 0 END AS JuridicalId
                      , CASE WHEN inIsPartner = TRUE THEN tmpMovement.PartnerId ELSE 0 END AS PartnerId
                      , CASE WHEN inIsPartner = TRUE THEN tmpMovement.ContractId  ELSE 0 END AS ContractId
                      , tmpMovement.InfoMoneyId
                      , tmpMovement.BranchId
                      , tmpMovement.TradeMarkId
                      , tmpMovement.GoodsTagId
                      , CASE WHEN inIsGoods = TRUE THEN tmpMovement.GoodsId ELSE 0 END AS GoodsId
                      , CASE WHEN inIsGoods = TRUE THEN tmpMovement.GoodsKindId ELSE 0 END AS GoodsKindId

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

                 FROM tmpMovement
                 GROUP BY CASE WHEN inIsPartner = TRUE THEN tmpMovement.JuridicalId ELSE 0 END
                        , CASE WHEN inIsPartner = TRUE THEN tmpMovement.PartnerId ELSE 0 END
                        , CASE WHEN inIsPartner = TRUE THEN tmpMovement.ContractId  ELSE 0 END
                        , tmpMovement.InfoMoneyId
                        , tmpMovement.BranchId
                        , tmpMovement.TradeMarkId
                        , tmpMovement.GoodsTagId
                        , CASE WHEN inIsGoods = TRUE THEN tmpMovement.GoodsId ELSE 0 END
                        , CASE WHEN inIsGoods = TRUE THEN tmpMovement.GoodsKindId ELSE 0 END

                UNION ALL
                 SELECT CASE WHEN inIsPartner = TRUE THEN tmpMovement.JuridicalId ELSE 0 END AS JuridicalId
                      , CASE WHEN inIsPartner = TRUE THEN tmpMovement.PartnerId ELSE 0 END AS PartnerId
                      , CASE WHEN inIsPartner = TRUE THEN tmpMovement.ContractId  ELSE 0 END AS ContractId
                      , tmpMovement.InfoMoneyId
                      , tmpMovement.BranchId
                      , tmpMovement.TradeMarkId
                      , tmpMovement.GoodsTagId
                      , CASE WHEN inIsGoods = TRUE THEN tmpMovement.GoodsId ELSE 0 END AS GoodsId
                      , CASE WHEN inIsGoods = TRUE THEN tmpMovement.GoodsKindId ELSE 0 END AS GoodsKindId

                      , 0 AS Sale_Summ
                      , 0 AS Return_Summ

                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() THEN -1 * COALESCE (MIContainer.Amount, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ELSE 0 END) AS Sale_Amount_Weight
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_Amount_Sh

                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE (MIContainer.Amount, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ELSE 0 END) AS Return_Amount_Weight
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Return_Amount_Sh

                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() THEN CASE WHEN MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10400() THEN -1 * COALESCE (MIContainer.Amount, 0) WHEN MIContainer.AnalyzerId <> 0 THEN 0 ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ELSE 0 END) AS Sale_AmountPartner_Weight
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_Sale() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN CASE WHEN MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10400() THEN -1 * COALESCE (MIContainer.Amount, 0) WHEN MIContainer.AnalyzerId <> 0 THEN 0 ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) END ELSE 0 END) AS Sale_AmountPartner_Sh

                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() THEN CASE WHEN MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10800() THEN COALESCE (MIContainer.Amount, 0) WHEN MIContainer.AnalyzerId <> 0 THEN 0 ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ELSE 0 END) AS Return_AmountPartner_Weight
                      , SUM (CASE WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN CASE WHEN MIContainer.AnalyzerId = zc_Enum_ProfitLossDirection_10800() THEN COALESCE (MIContainer.Amount, 0) WHEN MIContainer.AnalyzerId <> 0 THEN 0 ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) END ELSE 0 END) AS Return_AmountPartner_Sh

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

                 GROUP BY CASE WHEN inIsPartner = TRUE THEN tmpMovement.JuridicalId ELSE 0 END
                        , CASE WHEN inIsPartner = TRUE THEN tmpMovement.PartnerId ELSE 0 END
                        , CASE WHEN inIsPartner = TRUE THEN tmpMovement.ContractId  ELSE 0 END
                        , tmpMovement.InfoMoneyId
                        , tmpMovement.BranchId
                        , tmpMovement.TradeMarkId
                        , tmpMovement.GoodsTagId
                        , CASE WHEN inIsGoods = TRUE THEN tmpMovement.GoodsId ELSE 0 END
                        , CASE WHEN inIsGoods = TRUE THEN tmpMovement.GoodsKindId ELSE 0 END
                ) AS tmpOperation

           GROUP BY tmpOperation.JuridicalId
                  , tmpOperation.PartnerId
                  , tmpOperation.ContractId
                  , tmpOperation.InfoMoneyId
                  , tmpOperation.BranchId
                  , tmpOperation.TradeMarkId
                  , tmpOperation.GoodsTagId
                  , tmpOperation.GoodsId
                  , tmpOperation.GoodsKindId

          ) AS tmpOperationGroup

          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpOperationGroup.BranchId
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId

          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpOperationGroup.TradeMarkId
          LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = tmpOperationGroup.GoodsTagId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                               ON ObjectLink_Goods_GoodsGroupStat.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
          LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_Goods_GoodsGroupStat.ChildObjectId


          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN Object_Partner_Address_View AS View_Partner_Address ON View_Partner_Address.PartnerId = tmpOperationGroup.PartnerId

         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId
--**
/*
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                              ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                              ON ObjectLink_Partner_PartnerTag.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
         LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                              ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
         LEFT JOIN Object_Street_View ON Object_Street_View.Id = ObjectLink_Partner_Street.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_City_CityKind
                              ON ObjectLink_City_CityKind.ObjectId = Object_Street_View.CityId
                             AND ObjectLink_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
         LEFT JOIN Object AS Object_CityKind ON Object_CityKind.Id = ObjectLink_City_CityKind.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_City_Region
                             ON ObjectLink_City_Region.ObjectId = Object_Street_View.CityId
                            AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
         LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_City_Region.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_City_Province
                              ON ObjectLink_City_Province.ObjectId = Object_Street_View.CityId
                             AND ObjectLink_City_Province.DescId = zc_ObjectLink_City_Province()
         LEFT JOIN Object AS Object_Province ON Object_Province.Id = ObjectLink_City_Province.ChildObjectId
*/
--**

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_RetailReport
                               ON ObjectLink_Juridical_RetailReport.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_RetailReport.DescId = zc_ObjectLink_Juridical_RetailReport()
          LEFT JOIN Object AS Object_RetailReport ON Object_RetailReport.Id = ObjectLink_Juridical_RetailReport.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                               ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
          LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

          LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id
          LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpOperationGroup.ContractId
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                              ON ObjectLink_Partner_Personal.ObjectId = tmpOperationGroup.PartnerId
                             AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
         LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = ObjectLink_Partner_Personal.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                              ON ObjectLink_Unit_Branch.ObjectId = View_Personal.UnitId
                             AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
         LEFT JOIN Object AS Object_BranchPersonal ON Object_BranchPersonal.Id = ObjectLink_Unit_Branch.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                              ON ObjectLink_Partner_PersonalTrade.ObjectId = tmpOperationGroup.PartnerId
                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
         LEFT JOIN Object_Personal_View AS View_PersonalTrade ON View_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_SaleReturnIn (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.10.14                                        * add inIsPartner AND inIsGoods
 13.09.14                                        * add GoodsTagName and GroupStatName and BranchName and JuridicalGroupName
 11.07.14                                        * add RetailName and OKPO
 06.05.14                                        * add GoodsGroupNameFull
 28.03.14                                        * all
 06.02.14         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_SaleReturnIn (inStartDate:= '01.11.2014', inEndDate:= '30.11.2014', inJuridicalId:= 0, inGoodsGroupId:= 0, inPaidKindId:= 0, inInfoMoneyId:= 0, inIsPartner:= TRUE,  inIsGoods:= TRUE,  inSession:= zfCalc_UserAdmin());