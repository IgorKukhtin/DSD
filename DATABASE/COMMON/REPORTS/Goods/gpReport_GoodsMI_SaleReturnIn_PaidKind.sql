-- Function: gpReport_GoodsMI_SaleReturnIn() - Рабочая версия

DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnIn_PaidKind (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                              , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_SaleReturnIn_PaidKind (
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
    IN inIsOLAP       Boolean   , --
    IN inisPaidKind   Boolean   , --
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             
             , GoodsGroupAnalystName TVarChar, GoodsTagName TVarChar, GoodsGroupStatName TVarChar
             , GoodsPlatformName TVarChar
             , JuridicalGroupName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , BusinessId Integer, BusinessCode Integer, BusinessName TVarChar
             
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar/*, OKPO TVarChar*/
             , RetailName TVarChar, RetailReportName TVarChar
             , AreaName TVarChar, PartnerTagName TVarChar, PartnerCategory TFloat
             , Address TVarChar, RegionName TVarChar, ProvinceName TVarChar, CityKindName TVarChar, CityName TVarChar/*, ProvinceCityName TVarChar, StreetKindName TVarChar, StreetName TVarChar*/
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar, ContractTagGroupName TVarChar
             , PersonalName TVarChar, UnitName_Personal TVarChar, BranchName_Personal TVarChar
             , PersonalTradeName TVarChar, UnitName_PersonalTrade TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar

             , Promo_Summ TFloat, Sale_Summ TFloat, Sale_SummReal TFloat, Sale_Summ_10200 TFloat, Sale_Summ_10250 TFloat, Sale_Summ_10300 TFloat
             , Promo_SummCost TFloat, Sale_SummCost TFloat, Sale_SummCost_10500 TFloat, Sale_SummCost_40200 TFloat
             , Sale_Amount_Weight TFloat, Sale_Amount_Sh TFloat
             , Promo_AmountPartner_Weight TFloat, Promo_AmountPartner_Sh TFloat
             , Sale_AmountPartner_Weight TFloat, Sale_AmountPartner_Sh TFloat, Sale_AmountPartnerR_Weight TFloat, Sale_AmountPartnerR_Sh TFloat
             , Return_Summ TFloat, Return_Summ_10300 TFloat, Return_Summ_10700 TFloat, Return_SummCost TFloat, Return_SummCost_40200 TFloat
             , Return_Amount_Weight TFloat, Return_Amount_Sh TFloat, Return_AmountPartner_Weight TFloat, Return_AmountPartner_Sh TFloat
             , Sale_Amount_10500_Weight TFloat
             , Sale_Amount_40200_Weight TFloat
             , Return_Amount_40200_Weight TFloat
             , ReturnPercent TFloat
             , Sale_SummMVAT TFloat, Sale_SummVAT TFloat
             , Return_SummMVAT TFloat, Return_SummVAT TFloat
             , SaleReturn_Weight  TFloat -- Продажи за вычетом возврата, кг
             , SaleReturn_Summ    TFloat -- Продажи за вычетом возврата, грн
             , Sale_Summ_opt      TFloat -- сумма по опт прайсу, грн
             , Summ_51201         TFloat -- (111000) Услуги по маркетингу 
             , isTop Boolean
             , PaidKindId Integer, PaidKindName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

/*
 1) Sale_Summ_10200 - (10200)Разница с опт. грн (при прод.) 
 2) Sale_Summ_10250 - (10250)Скидка Акции, грн (при прод.) 
 3) и т.д.... для Sale_Amount_10500_Weight + Sale_Summ_10300 + Sale_SummCost + Sale_SummCost_10500 + Return_Summ + Return_Summ_10300 + Return_Summ_10700 + Return_SummCost
*/


       RETURN QUERY
       WITH -- данные  из отчета
       tmpReport AS (SELECT gpReport.GoodsGroupName, gpReport.GoodsGroupNameFull
                          , gpReport.GoodsId, gpReport.GoodsCode, gpReport.GoodsName
                          , gpReport.GoodsKindId, gpReport.GoodsKindName, gpReport.MeasureName
                          , gpReport.TradeMarkId, gpReport.TradeMarkName
                          , gpReport.GoodsGroupAnalystName, gpReport.GoodsTagName, gpReport.GoodsGroupStatName
                          , gpReport.GoodsPlatformName
                          
                          , gpReport.JuridicalGroupName
                          , gpReport.BranchId, gpReport.BranchCode, gpReport.BranchName
                          , gpReport.JuridicalId, gpReport.JuridicalCode, gpReport.JuridicalName
                          , gpReport.RetailName, gpReport.RetailReportName
                          , gpReport.AreaName, gpReport.PartnerTagName, gpReport.PartnerCategory
                          , gpReport.Address, gpReport.RegionName, gpReport.ProvinceName, gpReport.CityKindName, gpReport.CityName
                          , gpReport.PartnerId, gpReport.PartnerCode, gpReport.PartnerName
                          , gpReport.ContractId, gpReport.ContractCode, gpReport.ContractNumber, gpReport.ContractTagName, gpReport.ContractTagGroupName
                          , gpReport.PersonalName, gpReport.UnitName_Personal, gpReport.BranchName_Personal
                          , gpReport.PersonalTradeName, gpReport.UnitName_PersonalTrade
                          , gpReport.InfoMoneyGroupName, gpReport.InfoMoneyDestinationName
                          , gpReport.InfoMoneyId, gpReport.InfoMoneyCode, gpReport.InfoMoneyName, gpReport.InfoMoneyName_all
              
                          , (gpReport.Promo_Summ) :: TFloat AS Promo_Summ, (gpReport.Sale_Summ) :: TFloat AS Sale_Summ, (gpReport.Sale_SummReal) :: TFloat AS Sale_SummReal
                          , (gpReport.Sale_Summ_10200 * (-1)) :: TFloat AS Sale_Summ_10200
                          , (gpReport.Sale_Summ_10250 * (-1)) :: TFloat AS Sale_Summ_10250
                          , (gpReport.Sale_Summ_10300 * (-1)) :: TFloat AS Sale_Summ_10300
                          , (gpReport.Promo_SummCost) :: TFloat AS Promo_SummCost
                          , (gpReport.Sale_SummCost * (-1)) :: TFloat AS Sale_SummCost
                          , (gpReport.Sale_SummCost_10500 * (-1)) :: TFloat AS Sale_SummCost_10500
                          , (gpReport.Sale_SummCost_40200) :: TFloat AS Sale_SummCost_40200
                          , (gpReport.Sale_Amount_Weight) :: TFloat AS Sale_Amount_Weight, (gpReport.Sale_Amount_Sh) :: TFloat AS Sale_Amount_Sh
                          , (gpReport.Promo_AmountPartner_Weight) :: TFloat AS Promo_AmountPartner_Weight
                          , (gpReport.Promo_AmountPartner_Sh) :: TFloat AS Promo_AmountPartner_Sh, (gpReport.Sale_AmountPartner_Weight) :: TFloat AS Sale_AmountPartner_Weight
                          , (gpReport.Sale_AmountPartner_Sh) :: TFloat AS Sale_AmountPartner_Sh, (gpReport.Sale_AmountPartnerR_Weight) :: TFloat AS Sale_AmountPartnerR_Weight
                          , (gpReport.Sale_AmountPartnerR_Sh) :: TFloat AS Sale_AmountPartnerR_Sh
                          , (gpReport.Return_Summ * (-1)) :: TFloat AS Return_Summ
                          , (gpReport.Return_Summ_10300 * (-1)) :: TFloat AS Return_Summ_10300
                          , (gpReport.Return_Summ_10700 * (1)) :: TFloat AS Return_Summ_10700
                          , (gpReport.Return_SummCost * (1)) :: TFloat AS Return_SummCost
                          , (gpReport.Return_SummCost_40200) :: TFloat AS Return_SummCost_40200
                          , (gpReport.Return_Amount_Weight) :: TFloat AS Return_Amount_Weight, (gpReport.Return_Amount_Sh) :: TFloat AS Return_Amount_Sh
                          , (gpReport.Return_AmountPartner_Weight) :: TFloat AS Return_AmountPartner_Weight, (gpReport.Return_AmountPartner_Sh) :: TFloat AS Return_AmountPartner_Sh
                          , (gpReport.Sale_Amount_10500_Weight * (-1)) :: TFloat AS Sale_Amount_10500_Weight
                          , (gpReport.Sale_Amount_40200_Weight) :: TFloat AS Sale_Amount_40200_Weight
                          , (gpReport.Return_Amount_40200_Weight) :: TFloat AS Return_Amount_40200_Weight
                          , (gpReport.ReturnPercent) :: TFloat AS ReturnPercent
                          
                          , gpReport.Sale_SummMVAT  ::TFloat
                          , gpReport.Sale_SummVAT  ::TFloat
                          , gpReport.Return_SummMVAT  ::TFloat
                          , gpReport.Return_SummVAT  ::TFloat
                          , gpReport.SaleReturn_Weight   ::TFloat -- Продажи за вычетом возврата, кг
                          , gpReport.SaleReturn_Summ     ::TFloat -- Продажи за вычетом возврата, грн
                          , gpReport.Sale_Summ_opt       ::TFloat -- сумма по опт прайсу, грн

                          , 0 ::TFloat AS Summ_51201
                          , (gpReport.isTop) :: Boolean AS isTop
                          
                          , CASE WHEN inisPaidKind = TRUE THEN gpReport.PaidKindId ELSE 0 END PaidKindId
                          , CASE WHEN inisPaidKind = TRUE THEN gpReport.PaidKindName ELSE '' END PaidKindName
                     FROM gpReport_GoodsMI_SaleReturnIn (inStartDate
                                                       , inEndDate
                                                       , inBranchId
                                                       , inAreaId
                                                       , inRetailId
                                                       , inJuridicalId
                                                       , inPaidKindId
                                                       , inTradeMarkId
                                                       , inGoodsGroupId
                                                       , inInfoMoneyId
                                                       , inIsPartner
                                                       , inIsTradeMark
                                                       , inIsGoods
                                                       , inIsGoodsKind
                                                       , inIsContract
                                                       , inIsOLAP
                                                       , FALSE
                                                       , FALSE
                                                       , inSession
                                                        ) AS gpReport
                    )

    -- для вібора документов
     , tmp1 AS (SELECT *
                FROM Movement
                WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                and Movement.DescId = zc_Movement_ProfitLossService()
                AND Movement.StatusId = zc_Enum_Status_Complete()
                )
     , tmp2 AS (SELECT MovementItem.*
                FROM MovementItem
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmp1.Id FROM tmp1) AND MovementItem.DescId = zc_MI_Master()AND MovementItem.isErased = FALSE)

     , tmpPartnerAddress AS (SELECT * FROM Object_Partner_Address_View)
     , tmpPersonal_View AS (SELECT * FROM Object_Personal_View)

     , tmpMovementItemLinkObject AS (SELECT MovementItemLinkObject.* FROM MovementItemLinkObject
                                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmp2.Id FROM tmp2)
                                       AND MovementItemLinkObject.DescId IN (zc_MILinkObject_InfoMoney()
                                                                           , zc_MILinkObject_Contract()
                                                                           , zc_MILinkObject_Juridical()
                                                                           , zc_MILinkObject_Branch()
                                                                           , zc_MILinkObject_PaidKind()
                                                                             )
                                     )

       -- бонус в документах факт - zc_Movement_ProfitLossService
     , tmpProfitLossService AS (SELECT '' ::TVarChar AS GoodsGroupName, '' ::TVarChar AS GoodsGroupNameFull
                                     , 0 AS GoodsId, 0 AS GoodsCode, '' ::TVarChar AS GoodsName
                                     , 0 AS GoodsKindId, '' ::TVarChar AS GoodsKindName, '' ::TVarChar AS MeasureName
                                     , 0 AS TradeMarkId, '' ::TVarChar AS TradeMarkName
                                     , '' ::TVarChar AS GoodsGroupAnalystName, '' ::TVarChar AS GoodsTagName, '' ::TVarChar AS GoodsGroupStatName
                                     , '' ::TVarChar AS GoodsPlatformName
                                     
                                     , tmp.JuridicalGroupName
                                     , tmp.BranchId, tmp.BranchCode, tmp.BranchName
                                     , tmp.JuridicalId, tmp.JuridicalCode, tmp.JuridicalName
                                     , tmp.RetailName, tmp.RetailReportName
                                     , tmp.AreaName, tmp.PartnerTagName
                                     , tmp.PartnerCategory
                                     , tmp.Address
                                     , tmp.RegionName
                                     , tmp.ProvinceName
                                     , tmp.CityKindName
                                     , tmp.CityName
                                     , tmp.PartnerId
                                     , tmp.PartnerCode
                                     , tmp.PartnerName
                                     , tmp.ContractId, tmp.ContractCode, tmp.ContractInvNumber AS ContractNumber
                                     , tmp.ContractTagName, tmp.ContractTagGroupName
                                     , tmp.PersonalName
                                     , tmp.UnitName_Personal
                                     , tmp.BranchName_Personal
                           
                                     , tmp.PersonalTradeName
                                     , tmp.UnitName_PersonalTrade
                                     , tmp.InfoMoneyGroupName, tmp.InfoMoneyDestinationName
                                     , tmp.InfoMoneyId, tmp.InfoMoneyCode, tmp.InfoMoneyName, tmp.InfoMoneyName_all 

                                     , 0 :: TFloat AS Promo_Summ, 0 :: TFloat AS Sale_Summ, 0 :: TFloat AS Sale_SummReal, 0 :: TFloat AS Sale_Summ_10200, 0 :: TFloat AS Sale_Summ_10250, 0 :: TFloat AS Sale_Summ_10300
                                     , 0 :: TFloat AS Promo_SummCost, 0 :: TFloat AS Sale_SummCost, 0 :: TFloat AS Sale_SummCost_10500, 0 :: TFloat AS Sale_SummCost_40200
                                     , 0 :: TFloat AS Sale_Amount_Weight, 0 :: TFloat AS Sale_Amount_Sh
                                     , 0 :: TFloat AS Promo_AmountPartner_Weight, 0 :: TFloat AS Promo_AmountPartner_Sh, 0 :: TFloat AS Sale_AmountPartner_Weight, 0 :: TFloat AS Sale_AmountPartner_Sh, 0 :: TFloat AS Sale_AmountPartnerR_Weight, 0 :: TFloat AS Sale_AmountPartnerR_Sh
                                     , 0 :: TFloat AS Return_Summ, 0 :: TFloat AS Return_Summ_10300, 0 :: TFloat AS Return_Summ_10700, 0 :: TFloat AS Return_SummCost, 0 :: TFloat AS Return_SummCost_40200
                                     , 0 :: TFloat AS Return_Amount_Weight, 0 :: TFloat AS Return_Amount_Sh, 0 :: TFloat AS Return_AmountPartner_Weight, 0 :: TFloat AS Return_AmountPartner_Sh
                                     , 0 :: TFloat AS Sale_Amount_10500_Weight
                                     , 0 :: TFloat AS Sale_Amount_40200_Weight
                                     , 0 :: TFloat AS Return_Amount_40200_Weight
                                     , 0 :: TFloat AS ReturnPercent

                                     , 0 :: TFloat AS Sale_SummMVAT
                                     , 0 :: TFloat AS Sale_SummVAT
                                     , 0 :: TFloat AS Return_SummMVAT
                                     , 0 :: TFloat AS Return_SummVAT
                                     , 0 :: TFloat AS SaleReturn_Weight
                                     , 0 :: TFloat AS SaleReturn_Summ
                                     , 0 :: TFloat AS Sale_Summ_opt

                                     , (COALESCE (tmp.Amount,0) ) ::TFloat AS Summ_51201
                                     , FALSE :: Boolean AS isTop
                                     , CASE WHEN inisPaidKind = TRUE THEN tmp.PaidKindId ELSE 0 END PaidKindId
                                     , CASE WHEN inisPaidKind = TRUE THEN tmp.PaidKindName ELSE '' END PaidKindName

                                FROM (SELECT Object_JuridicalGroup.ValueData AS JuridicalGroupName
                                           , Object_Branch.Id                               AS BranchId
                                           , Object_Branch.ObjectCode                       AS BranchCode
                                           , Object_Branch.ValueData                        AS BranchName
                                           , Object_Juridical.Id                            AS JuridicalId
                                           , Object_Juridical.ObjectCode          ::Integer AS JuridicalCode
                                           , Object_Juridical.ValueData                     AS JuridicalName
                                           , View_Contract_InvNumber.ContractId
                                           , View_Contract_InvNumber.ContractCode
                                           , View_Contract_InvNumber.InvNumber              AS ContractInvNumber
                                           , View_Contract_InvNumber.ContractTagName
                                           , View_Contract_InvNumber.ContractTagGroupName
                                           , Object_PaidKind.Id                             AS PaidKindId
                                           , Object_PaidKind.ValueData                      AS PaidKindName
                                           , Object_Retail.Id                               AS RetailId
                                           , Object_Retail.ValueData                        AS RetailName
                                           , Object_RetailReport.ValueData AS RetailReportName
                                           , Object_Area.ValueData AS AreaName
                                           , Object_PartnerTag.ValueData AS PartnerTagName
                                           , ObjectFloat_Category.ValueData ::TFloat  AS PartnerCategory
                                           , ObjectString_Address.ValueData AS Address
                                           , View_Partner_Address.RegionName
                                           , View_Partner_Address.ProvinceName
                                           , View_Partner_Address.CityKindName
                                           , View_Partner_Address.CityName
                                           , View_Partner_Address.PartnerId
                                           , View_Partner_Address.PartnerCode
                                           , View_Partner_Address.PartnerName
                                           , View_Personal.PersonalName       AS PersonalName
                                           , View_Personal.UnitName           AS UnitName_Personal
                                           , Object_BranchPersonal.ValueData  AS BranchName_Personal
                                           , View_PersonalTrade.PersonalName  AS PersonalTradeName
                                           , View_PersonalTrade.UnitName      AS UnitName_PersonalTrade
                                           , Object_InfoMoney_View.InfoMoneyGroupName       AS InfoMoneyGroupName
                                           , Object_InfoMoney_View.InfoMoneyDestinationName AS InfoMoneyDestinationName
                                           , Object_InfoMoney_View.InfoMoneyId              AS InfoMoneyId
                                           , Object_InfoMoney_View.InfoMoneyCode            AS InfoMoneyCode
                                           , Object_InfoMoney_View.InfoMoneyName            AS InfoMoneyName
                                           , Object_InfoMoney_View.InfoMoneyName_all
                                           , tmp2.Amount
                                      FROM tmp1
                                          LEFT JOIN tmp2 ON tmp2.MovementId = tmp1.Id
                                          LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_InfoMoney
                                                                              ON MILinkObject_InfoMoney.MovementItemId = tmp2.Id
                                                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

                                          LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_PaidKind
                                                                              ON MILinkObject_PaidKind.MovementItemId = tmp2.Id
                                                                             AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                                                             AND inisPaidKind = TRUE
                                          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId
            
                                          LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Contract
                                                                              ON MILinkObject_Contract.MovementItemId = tmp2.Id
                                                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                          LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId
                              
                                          LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_ContractMaster
                                                                              ON MILinkObject_ContractMaster.MovementItemId = tmp2.Id
                                                                             AND MILinkObject_ContractMaster.DescId = zc_MILinkObject_ContractMaster()
                              
                                          LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Branch
                                                                              ON MILinkObject_Branch.MovementItemId = tmp2.Id
                                                                             AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                                          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId
                              
                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                               ON ObjectLink_Partner_Juridical.ObjectId = tmp2.ObjectId
                                                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId
                                          LEFT JOIN ObjectDesc AS ObjectDesc_Partner ON ObjectDesc_Partner.Id = Object_Partner.DescId
                                          
                                          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, tmp2.ObjectId)

                                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                                               ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                                                              AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
                                          LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

                                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                               ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_RetailReport
                                                               ON ObjectLink_Juridical_RetailReport.ObjectId = Object_Juridical.Id
                                                              AND ObjectLink_Juridical_RetailReport.DescId = zc_ObjectLink_Juridical_RetailReport()
                                          LEFT JOIN Object AS Object_RetailReport ON Object_RetailReport.Id = ObjectLink_Juridical_RetailReport.ChildObjectId

                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                                                               ON ObjectLink_Partner_Area.ObjectId = tmp2.ObjectId
                                                              AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
                                          LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId

                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                                                               ON ObjectLink_Partner_PartnerTag.ObjectId = tmp2.ObjectId
                                                              AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
                                          LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId

                                          LEFT JOIN ObjectFloat AS ObjectFloat_Category
                                                                ON ObjectFloat_Category.ObjectId = tmp2.ObjectId
                                                               AND ObjectFloat_Category.DescId = zc_ObjectFloat_Partner_Category()
                                          LEFT JOIN ObjectString AS ObjectString_Address
                                                                 ON ObjectString_Address.ObjectId = tmp2.ObjectId
                                                                AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
                                          LEFT JOIN tmpPartnerAddress AS View_Partner_Address ON View_Partner_Address.PartnerId = tmp2.ObjectId
      
                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                                               ON ObjectLink_Partner_Personal.ObjectId = tmp2.ObjectId
                                                              AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
                                          LEFT JOIN tmpPersonal_View AS View_Personal ON View_Personal.PersonalId = ObjectLink_Partner_Personal.ChildObjectId

                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                               ON ObjectLink_Partner_PersonalTrade.ObjectId = tmp2.ObjectId
                                                              AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                          LEFT JOIN tmpPersonal_View AS View_PersonalTrade ON View_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId

                                          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                               ON ObjectLink_Unit_Branch.ObjectId = View_Personal.UnitId
                                                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                          LEFT JOIN Object AS Object_BranchPersonal ON Object_BranchPersonal.Id = ObjectLink_Unit_Branch.ChildObjectId
                                     ) AS tmp
                                 WHERE (tmp.PaidKindId  = inPaidKindId  OR inPaidKindId  = 0)
                                   AND (tmp.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                                   AND (tmp.RetailId    = inRetailId    OR inRetailId   = 0)
                                )

          , tmpData AS (SELECT * FROM tmpReport
                       UNION ALL
                        SELECT * FROM tmpProfitLossService
                       )

       --
       SELECT gpReport.GoodsGroupName, gpReport.GoodsGroupNameFull
            , gpReport.GoodsId, gpReport.GoodsCode, gpReport.GoodsName
            , gpReport.GoodsKindId, gpReport.GoodsKindName, gpReport.MeasureName
            , gpReport.TradeMarkId, gpReport.TradeMarkName
            , gpReport.GoodsGroupAnalystName, gpReport.GoodsTagName, gpReport.GoodsGroupStatName
            , gpReport.GoodsPlatformName
            , gpReport.JuridicalGroupName
            , gpReport.BranchId, gpReport.BranchCode, gpReport.BranchName
            , 0 :: Integer AS BusinessId, 0 :: Integer AS BusinessCode, '' :: TVarChar AS BusinessName 
            , gpReport.JuridicalId, gpReport.JuridicalCode, gpReport.JuridicalName
            , gpReport.RetailName, gpReport.RetailReportName
            , gpReport.AreaName, gpReport.PartnerTagName, gpReport.PartnerCategory
            , gpReport.Address, gpReport.RegionName, gpReport.ProvinceName, gpReport.CityKindName, gpReport.CityName
            , gpReport.PartnerId, gpReport.PartnerCode, gpReport.PartnerName
            , gpReport.ContractId, gpReport.ContractCode, gpReport.ContractNumber, gpReport.ContractTagName, gpReport.ContractTagGroupName
            , gpReport.PersonalName, gpReport.UnitName_Personal, gpReport.BranchName_Personal
            , gpReport.PersonalTradeName, gpReport.UnitName_PersonalTrade
            , gpReport.InfoMoneyGroupName, gpReport.InfoMoneyDestinationName
            , gpReport.InfoMoneyId, gpReport.InfoMoneyCode, gpReport.InfoMoneyName, gpReport.InfoMoneyName_all

            , SUM (gpReport.Promo_Summ) :: TFloat AS Promo_Summ, SUM (gpReport.Sale_Summ) :: TFloat AS Sale_Summ, SUM (gpReport.Sale_SummReal) :: TFloat AS Sale_SummReal
            , SUM (gpReport.Sale_Summ_10200) :: TFloat AS Sale_Summ_10200
            , SUM (gpReport.Sale_Summ_10250) :: TFloat AS Sale_Summ_10250
            , SUM (gpReport.Sale_Summ_10300) :: TFloat AS Sale_Summ_10300
            , SUM (gpReport.Promo_SummCost) :: TFloat AS Promo_SummCost
            , SUM (gpReport.Sale_SummCost) :: TFloat AS Sale_SummCost
            , SUM (gpReport.Sale_SummCost_10500) :: TFloat AS Sale_SummCost_10500
            , SUM (gpReport.Sale_SummCost_40200) :: TFloat AS Sale_SummCost_40200
            , SUM (gpReport.Sale_Amount_Weight) :: TFloat AS Sale_Amount_Weight
            , SUM (gpReport.Sale_Amount_Sh) :: TFloat AS Sale_Amount_Sh
            , SUM (gpReport.Promo_AmountPartner_Weight) :: TFloat AS Promo_AmountPartner_Weight
            , SUM (gpReport.Promo_AmountPartner_Sh) :: TFloat AS Promo_AmountPartner_Sh
            , SUM (gpReport.Sale_AmountPartner_Weight) :: TFloat AS Sale_AmountPartner_Weight
            , SUM (gpReport.Sale_AmountPartner_Sh) :: TFloat AS Sale_AmountPartner_Sh
            , SUM (gpReport.Sale_AmountPartnerR_Weight) :: TFloat AS Sale_AmountPartnerR_Weight
            , SUM (gpReport.Sale_AmountPartnerR_Sh) :: TFloat AS Sale_AmountPartnerR_Sh
            , SUM (gpReport.Return_Summ) :: TFloat AS Return_Summ
            , SUM (gpReport.Return_Summ_10300) :: TFloat AS Return_Summ_10300
            , SUM (gpReport.Return_Summ_10700) :: TFloat AS Return_Summ_10700
            , SUM (gpReport.Return_SummCost) :: TFloat AS Return_SummCost
            , SUM (gpReport.Return_SummCost_40200) :: TFloat AS Return_SummCost_40200
            , SUM (gpReport.Return_Amount_Weight) :: TFloat AS Return_Amount_Weight
            , SUM (gpReport.Return_Amount_Sh) :: TFloat AS Return_Amount_Sh
            , SUM (gpReport.Return_AmountPartner_Weight) :: TFloat AS Return_AmountPartner_Weight
            , SUM (gpReport.Return_AmountPartner_Sh) :: TFloat AS Return_AmountPartner_Sh
            , SUM (gpReport.Sale_Amount_10500_Weight) :: TFloat AS Sale_Amount_10500_Weight
            , SUM (gpReport.Sale_Amount_40200_Weight) :: TFloat AS Sale_Amount_40200_Weight
            , SUM (gpReport.Return_Amount_40200_Weight) :: TFloat AS Return_Amount_40200_Weight
            , CAST (CASE WHEN SUM (gpReport.Sale_AmountPartner_Weight) > 0 THEN 100 * SUM (gpReport.Return_AmountPartner_Weight) / SUM (gpReport.Sale_AmountPartner_Weight) 
                         ELSE 0
                    END AS NUMERIC (16, 1)) :: TFloat AS ReturnPercent
            , 0 :: TFloat AS Sale_SummMVAT,   0 :: TFloat AS Sale_SummVAT
            , 0 :: TFloat AS Return_SummMVAT, 0 :: TFloat AS Return_SummVAT
            , SUM (gpReport.SaleReturn_Weight) :: TFloat AS SaleReturn_Weight  -- Продажи за вычетом возврата, кг
            , SUM (gpReport.SaleReturn_Summ)                            :: TFloat AS SaleReturn_Summ    -- Продажи за вычетом возврата, грн
            , SUM (gpReport.Sale_Summ_opt) ::TFloat AS Sale_Summ_opt  --сумма по опт прайсу
            , SUM (gpReport.Summ_51201) ::TFloat AS Summ_51201

            , gpReport.isTop
            , gpReport.PaidKindId ::Integer
            , gpReport.PaidKindName ::TVarChar

       FROM tmpData AS gpReport
       GROUP BY gpReport.GoodsGroupName, gpReport.GoodsGroupNameFull
              , gpReport.GoodsId, gpReport.GoodsCode, gpReport.GoodsName
              , gpReport.GoodsKindId, gpReport.GoodsKindName, gpReport.MeasureName
              , gpReport.TradeMarkId, gpReport.TradeMarkName
              , gpReport.GoodsGroupAnalystName, gpReport.GoodsTagName, gpReport.GoodsGroupStatName
              , gpReport.GoodsPlatformName
              , gpReport.JuridicalGroupName
              , gpReport.BranchId, gpReport.BranchCode, gpReport.BranchName
              , gpReport.JuridicalId, gpReport.JuridicalCode, gpReport.JuridicalName
              , gpReport.RetailName, gpReport.RetailReportName
              , gpReport.AreaName, gpReport.PartnerTagName, gpReport.PartnerCategory
              , gpReport.Address, gpReport.RegionName, gpReport.ProvinceName, gpReport.CityKindName, gpReport.CityName
              , gpReport.PartnerId, gpReport.PartnerCode, gpReport.PartnerName
              , gpReport.ContractId, gpReport.ContractCode, gpReport.ContractNumber, gpReport.ContractTagName, gpReport.ContractTagGroupName
              , gpReport.PersonalName, gpReport.UnitName_Personal, gpReport.BranchName_Personal
              , gpReport.PersonalTradeName, gpReport.UnitName_PersonalTrade
              , gpReport.InfoMoneyGroupName, gpReport.InfoMoneyDestinationName
              , gpReport.InfoMoneyId, gpReport.InfoMoneyCode, gpReport.InfoMoneyName, gpReport.InfoMoneyName_all
              , gpReport.isTop
              , gpReport.PaidKindId, gpReport.PaidKindName
               ;
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.08.21         * 
*/


-- тест
-- SELECT * FROM gpReport_GoodsMI_SaleReturnIn_PaidKind (inStartDate:= '01.08.2019', inEndDate:= '01.08.2019', inBranchId:= 0, inAreaId:= 0, inRetailId:= 0, inJuridicalId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inTradeMarkId:= 0, inGoodsGroupId:= 0, inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inIsPartner:= TRUE, inIsTradeMark:= TRUE, inIsGoods:= TRUE, inIsGoodsKind:= TRUE, inIsContract:= FALSE, inIsOLAP:= TRUE, inSession:= zfCalc_UserAdmin());
/*

SELECT * FROM gpReport_GoodsMI_SaleReturnIn_PaidKind (
inStartDate:= '01.08.2019', inEndDate:= '01.08.2019', inBranchId:= 0, inAreaId:= 0
, inRetailId:= 0, inJuridicalId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm()
, inTradeMarkId:= 0, inGoodsGroupId:= 0, inInfoMoneyId:= zc_Enum_InfoMoney_30101()
, inIsPartner:= TRUE, inIsTradeMark:= TRUE, inIsGoods:= TRUE, inIsGoodsKind:= TRUE
, inIsContract:= FALSE, inIsOLAP:= TRUE, inisPaidKind:= TRUE
, inSession:= zfCalc_UserAdmin());


select * from gpReport_GoodsMI_SaleReturnIn_PaidKind(
inStartDate := ('25.08.2021')::TDateTime , inEndDate := ('25.08.2021')::TDateTime , inBranchId := 308111110683 , inAreaId := 0 
, inRetailId := 0 , inJuridicalId := 0 , inPaidKindId := 0 
, inTradeMarkId := 0 , inGoodsGroupId := 0 , inInfoMoneyId := 0 
, inIsPartner := False, inIsTradeMark := False , inIsGoods := False , inIsGoodsKind := False
, inisContract := False , inIsOLAP := True , inisPaidKind := True
,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
*/