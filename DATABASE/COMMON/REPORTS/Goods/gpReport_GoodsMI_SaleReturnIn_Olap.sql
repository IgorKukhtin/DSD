-- Function: gpReport_Goods_Movement ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnIn_Olap (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnIn_Olap (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI_SaleReturnIn_Olap (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inBranchId     Integer   , -- ***Филиал
    IN inAreaId       Integer   , -- ***Регион (контрагенты -> юр лица)
    IN inRetailId     Integer   , -- ***Торговая сеть (юр лица)
    IN inJuridicalId  Integer   , --
    IN inPaidKindId   Integer   , --
    IN inTradeMarkId  Integer   , -- *** 
    IN inGoodsGroupId Integer   , -- 
    IN inInfoMoneyId  Integer   , -- Управленческая статья
    IN inIsPartner    Boolean   , --
    IN inIsTradeMark  Boolean   , --
    IN inIsGoods      Boolean   , --
    IN inIsGoodsKind  Boolean   , --
    IN inIsContract   Boolean   , --
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar, GoodsGroupAnalystName TVarChar, GoodsTagName TVarChar, GoodsGroupStatName TVarChar
             , GoodsPlatformName TVarChar
             , JuridicalGroupName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar, OKPO TVarChar
             , RetailName TVarChar, RetailReportName TVarChar
             , AreaName TVarChar, PartnerTagName TVarChar
             , Address TVarChar, RegionName TVarChar, ProvinceName TVarChar, CityKindName TVarChar, CityName TVarChar, ProvinceCityName TVarChar, StreetKindName TVarChar, StreetName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar, ContractTagGroupName TVarChar
             , PersonalName TVarChar, UnitName_Personal TVarChar, BranchName_Personal TVarChar
             , PersonalTradeName TVarChar, UnitName_PersonalTrade TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AccountName TVarChar
             , Sale_Summ TFloat, Sale_Summ_10200 TFloat, Sale_Summ_10250 TFloat, Sale_Summ_10300 TFloat, Sale_SummCost TFloat, Sale_SummCost_10500 TFloat, Sale_SummCost_40200 TFloat
             , Sale_Amount_Weight TFloat, Sale_Amount_Sh TFloat, Sale_AmountPartner_Weight TFloat, Sale_AmountPartner_Sh TFloat
             , Return_Summ TFloat, Return_Summ_10300 TFloat, Return_SummCost TFloat, Return_SummCost_40200 TFloat
             , Return_Amount_Weight TFloat, Return_Amount_Sh TFloat, Return_AmountPartner_Weight TFloat, Return_AmountPartner_Sh TFloat
             , Sale_Amount_10500_Weight TFloat
             , Sale_Amount_40200_Weight TFloat
             , Return_Amount_40200_Weight TFloat
             , ReturnPercent TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsGoods Boolean;
   DECLARE vbIsPartner Boolean;
   DECLARE vbIsJuridical Boolean;
   DECLARE vbIsJuridicalBranch Boolean;
   DECLARE vbIsCost Boolean;

   DECLARE vbObjectId_Constraint_Branch Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);



    -- Результат
    RETURN QUERY

    -- собираем все данные
    WITH  tmpOperationGroup2 AS
                        (SELECT SoldTable.AccountId AS ChildAccountId
                              , SoldTable.BranchId
                              , CASE WHEN inIsPartner  = TRUE  THEN SoldTable.JuridicalGroupId   ELSE 0 END AS JuridicalGroupId
                              , CASE WHEN inIsPartner  = TRUE  THEN SoldTable.JuridicalId        ELSE 0 END AS JuridicalId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.PartnerId          END AS PartnerId
                              , SoldTable.InfoMoneyId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.RetailId           END AS RetailId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.RetailReportId     END AS RetailReportId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.AreaId             END AS AreaId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.PartnerTagId       END AS PartnerTagId
                              , CASE WHEN inIsContract = FALSE THEN 0 ELSE SoldTable.ContractId         END AS ContractId
                              , CASE WHEN inIsContract = FALSE THEN 0 ELSE SoldTable.ContractTagId      END AS ContractTagId
                              , CASE WHEN inIsContract = FALSE THEN 0 ELSE SoldTable.ContractTagGroupId END AS ContractTagGroupId

                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.PersonalId           END AS PersonalId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.UnitId_Personal      END AS UnitId_Personal
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.BranchId_Personal    END AS BranchId_Personal
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.PersonalTradeId      END AS PersonalTradeId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.UnitId_PersonalTrade END AS UnitId_PersonalTrade

                              , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN SoldTable.GoodsPlatformId     ELSE 0 END AS GoodsPlatformId
                              , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN SoldTable.TradeMarkId         ELSE 0 END AS TradeMarkId
                              , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN SoldTable.GoodsGroupAnalystId ELSE 0 END AS GoodsGroupAnalystId
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.GoodsTagId     ELSE 0 END AS GoodsTagId
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.GoodsId     ELSE 0 END AS GoodsId
                              , CASE WHEN inIsGoodsKind = TRUE THEN SoldTable.GoodsKindId ELSE 0 END AS GoodsKindId

                              , SUM (SoldTable.Sale_Summ) AS Sale_Summ
                              , SUM (SoldTable.Return_Summ) AS Return_Summ

                              , SUM (SoldTable.Sale_Summ_10200)   AS Sale_Summ_10200
                              , SUM (SoldTable.Sale_Summ_10250)   AS Sale_Summ_10250
                              , SUM (SoldTable.Sale_Summ_10300)   AS Sale_Summ_10300
                              , SUM (SoldTable.Return_Summ_10300) AS Return_Summ_10300

                              , SUM (SoldTable.Sale_Amount_Weight)   AS Sale_Amount_Weight
                              , SUM (SoldTable.Sale_Amount_Sh)       AS Sale_Amount_Sh
                              , SUM (SoldTable.Return_Amount_Weight) AS Return_Amount_Weight
                              , SUM (SoldTable.Return_Amount_Sh)     AS Return_Amount_Sh

                              , SUM (SoldTable.Sale_AmountPartner_Weight)   AS Sale_AmountPartner_Weight
                              , SUM (SoldTable.Sale_AmountPartner_Sh)       AS Sale_AmountPartner_Sh
                              , SUM (SoldTable.Return_AmountPartner_Weight) AS Return_AmountPartner_Weight
                              , SUM (SoldTable.Return_AmountPartner_Sh)     AS Return_AmountPartner_Sh

                              , SUM (SoldTable.Sale_Amount_10500_Weight)    AS Sale_Amount_10500_Weight
                              , SUM (SoldTable.Sale_Amount_40200_Weight)    AS Sale_Amount_40200_Weight
                              , SUM (SoldTable.Return_Amount_40200_Weight)  AS Return_Amount_40200_Weight

                              , SUM (SoldTable.Sale_SummCost) AS Sale_SummCost
                              , SUM (SoldTable.Sale_SummCost_10500) AS Sale_SummCost_10500
                              , SUM (SoldTable.Sale_SummCost_40200) AS Sale_SummCost_40200

                              , SUM (SoldTable.Return_SummCost) AS Return_SummCost
                              , SUM (SoldTable.Return_SummCost_40200) AS Return_SummCost_40200
                         FROM SoldTable
                              LEFT JOIN _tmpJuridical ON _tmpJuridical.JuridicalId = SoldTable.JuridicalId
                              LEFT JOIN _tmpJuridicalBranch ON _tmpJuridicalBranch.JuridicalId = SoldTable.JuridicalId
                              LEFT JOIN _tmpPartner ON _tmpPartner.PartnerId = SoldTable.PartnerId
                              LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = SoldTable.GoodsId

                         WHERE (SoldTable.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                           AND (SoldTable.InfoMoneyId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                           AND (SoldTable.PaidKindId  = inPaidKindId  OR COALESCE (inPaidKindId, 0)  = 0)
                           AND (_tmpJuridical.JuridicalId > 0 OR vbIsJuridical = FALSE)
                           AND (SoldTable.BranchId = inBranchId OR COALESCE (inBranchId, 0) = 0 OR _tmpJuridicalBranch.JuridicalId IS NOT NULL)
                           AND (_tmpPartner.PartnerId > 0 OR vbIsPartner = FALSE)
                           AND (_tmpGoods.GoodsId > 0 OR vbIsGoods = FALSE)
                         GROUP BY CASE WHEN inIsPartner  = TRUE  THEN SoldTable.JuridicalId ELSE 0 END
                                , CASE WHEN inIsContract = TRUE  THEN SoldTable.ContractId  ELSE 0 END
                                , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.PartnerId   END

                                , SoldTable.InfoMoneyId
                                , SoldTable.BranchId
                                , SoldTable.AccountId

                                , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN SoldTable.TradeMarkId ELSE 0 END
                                , CASE WHEN inIsGoods     = TRUE THEN SoldTable.GoodsId     ELSE 0 END
                                , CASE WHEN inIsGoodsKind = TRUE THEN SoldTable.GoodsKindId ELSE 0 END
                        )
     SELECT Object_GoodsGroup.ValueData        AS GoodsGroupName
          , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
          , Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName
          , Object_GoodsKind.ValueData         AS GoodsKindName
          , Object_Measure.ValueData           AS MeasureName
          , Object_TradeMark.ValueData         AS TradeMarkName
          , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
          , Object_GoodsTag.ValueData          AS GoodsTagName
          , Object_GoodsGroupStat.ValueData    AS GoodsGroupStatName
          , Object_GoodsPlatform.ValueData     AS GoodsPlatformName

          , Object_JuridicalGroup.ValueData  AS JuridicalGroupName
          , Object_Branch.ObjectCode    AS BranchCode
          , Object_Branch.ValueData     AS BranchName
          , Object_Juridical.ObjectCode AS JuridicalCode
          , Object_Juridical.ValueData  AS JuridicalName
          , ObjectHistory_JuridicalDetails_View.OKPO

          , Object_Retail.ValueData       AS RetailName
          , Object_RetailReport.ValueData AS RetailReportName

          , View_Partner_Address.AreaName
          , View_Partner_Address.PartnerTagName
          , ObjectString_Address.ValueData AS Address
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
          , View_Contract_InvNumber.ContractTagGroupName

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

          , Object_Account_View.AccountName_all AS AccountName

         , tmpOperationGroup.Sale_Summ          :: TFloat  AS Sale_Summ
         , tmpOperationGroup.Sale_Summ_10200    :: TFloat  AS Sale_Summ_10200
         , tmpOperationGroup.Sale_Summ_10250    :: TFloat  AS Sale_Summ_10250
         , tmpOperationGroup.Sale_Summ_10300    :: TFloat  AS Sale_Summ_10300
         , tmpOperationGroup.Sale_SummCost      :: TFloat  AS Sale_SummCost
         , tmpOperationGroup.Sale_SummCost_10500:: TFloat  AS Sale_SummCost_10500
         , tmpOperationGroup.Sale_SummCost_40200:: TFloat  AS Sale_SummCost_40200

         , tmpOperationGroup.Sale_Amount_Weight :: TFloat  AS Sale_Amount_Weight
         , tmpOperationGroup.Sale_Amount_Sh     :: TFloat  AS Sale_Amount_Sh

         , tmpOperationGroup.Sale_AmountPartner_Weight :: TFloat AS Sale_AmountPartner_Weight
         , tmpOperationGroup.Sale_AmountPartner_Sh     :: TFloat AS Sale_AmountPartner_Sh

         , tmpOperationGroup.Return_Summ          :: TFloat AS Return_Summ
         , tmpOperationGroup.Return_Summ_10300    :: TFloat AS Return_Summ_10300
         , tmpOperationGroup.Return_SummCost      :: TFloat AS Return_SummCost
         , tmpOperationGroup.Return_SummCost_40200:: TFloat AS Return_SummCost_40200

         , tmpOperationGroup.Return_Amount_Weight :: TFloat AS Return_Amount_Weight
         , tmpOperationGroup.Return_Amount_Sh     :: TFloat AS Return_Amount_Sh

         , tmpOperationGroup.Return_AmountPartner_Weight :: TFloat AS Return_AmountPartner_Weight
         , tmpOperationGroup.Return_AmountPartner_Sh     :: TFloat AS Return_AmountPartner_Sh

         , tmpOperationGroup.Sale_Amount_10500_Weight    :: TFloat AS Sale_Amount_10500_Weight
         , tmpOperationGroup.Sale_Amount_40200_Weight    :: TFloat AS Sale_Amount_40200_Weight
         , tmpOperationGroup.Return_Amount_40200_Weight  :: TFloat AS Return_Amount_40200_Weight

         , CAST (CASE WHEN tmpOperationGroup.Sale_AmountPartner_Weight > 0 THEN 100 * tmpOperationGroup.Return_AmountPartner_Weight / tmpOperationGroup.Sale_AmountPartner_Weight ELSE 0 END AS NUMERIC (16, 1)) :: TFloat AS ReturnPercent

     FROM tmpOperationGroup
          -- LEFT JOIN _tmp_noDELETE_Partner ON _tmp_noDELETE_Partner.FromId = tmpOperationGroup.PartnerId AND 1 = 0

          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpOperationGroup.BranchId
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId

          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = tmpOperationGroup.GoodsGroupAnalystId
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpOperationGroup.TradeMarkId

          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpOperationGroup.MeasureId

          LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = tmpOperationGroup.GoodsTagId
          LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = tmpOperationGroup.GoodsGroupStatId

          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpOperationGroup.GoodsGroupId

          LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = tmpOperationGroup.GoodsPlatformId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId

          LEFT JOIN Object AS Object_Area ON Object_Area.Id = tmpOperationGroup.AreaId
          LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = tmpOperationGroup.PartnerTagId

          LEFT JOIN ObjectString AS ObjectString_Address
                                 ON ObjectString_Address.ObjectId = Object_Partner.Id
                                AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

          LEFT JOIN Object AS Object_Region       ON Object_Region.Id       = tmpOperationGroup.RegionId
          LEFT JOIN Object AS Object_Province     ON Object_Province.Id     = tmpOperationGroup.ProvinceId
          LEFT JOIN Object AS Object_CityKind     ON Object_CityKind.Id     = tmpOperationGroup.CityKindId
          LEFT JOIN Object AS Object_City         ON Object_City.Id         = tmpOperationGroup.CityId
          LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = tmpOperationGroup.ProvinceCityId
          LEFT JOIN Object AS Object_StreetKind   ON Object_StreetKind.Id   = tmpOperationGroup.StreetKindId
          LEFT JOIN Object AS Object_Street       ON Object_Street.Id       = tmpOperationGroup.StreetId


          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpOperationGroup.RetailId
          LEFT JOIN Object AS Object_RetailReport ON Object_RetailReport.Id = tmpOperationGroup.RetailReportId
          LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = tmpOperationGroup.JuridicalGroupId

          LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpOperationGroup.ContractId
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId

          LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = tmpOperationGroup.PersonalId
          LEFT JOIN Object AS Object_BranchPersonal ON Object_BranchPersonal.Id = tmpOperationGroup.BranchId_Personal
          LEFT JOIN Object_Personal_View AS View_PersonalTrade ON View_PersonalTrade.PersonalId = tmpOperationGroup.PersonalTradeId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.01.16         *
 22.03.15                                        * add inIsGoodsKind
 11.01.15                                        * all
 12.12.14                                        * all
 27.10.14                                        * add inIsPartner AND inIsGoods
 13.09.14                                        * add GoodsTagName and GroupStatName and BranchName and JuridicalGroupName
 11.07.14                                        * add RetailName and OKPO
 06.05.14                                        * add GoodsGroupNameFull
 28.03.14                                        * all
 06.02.14         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_SaleReturnIn_Olap (inStartDate:= '01.02.2016', inEndDate:= '01.02.2016', inBranchId:= 0, inAreaId:= 0, inRetailId:= 0, inJuridicalId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inTradeMarkId:= 0, inGoodsGroupId:= 0, inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inIsPartner:= TRUE, inIsTradeMark:= TRUE, inIsGoods:= TRUE, inIsGoodsKind:= TRUE, inIsContract:= FALSE, inSession:= zfCalc_UserAdmin());
