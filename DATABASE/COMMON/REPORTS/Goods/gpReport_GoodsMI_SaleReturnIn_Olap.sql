-- Function: gpReport_Goods_Movement ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnIn_Olap (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnIn_Olap (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnIn_Olap (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

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
    IN inIsJuridical_Branch Boolean   , -- ***
    IN inIsJuridical_where  Boolean   , -- ***
    IN inIsPartner_where    Boolean   , -- ***
    IN inIsGoods_where      Boolean   , -- ***
    IN inIsCost             Boolean   , -- ***
    IN inIsDate             Boolean   , -- ***
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar, GoodsGroupAnalystName TVarChar
             , GoodsTagName TVarChar, GoodsGroupStatName TVarChar
             , GoodsPlatformName TVarChar
             , JuridicalGroupName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
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
             , Promo_AmountPartner_Weight TFloat, Promo_AmountPartner_Sh TFloat, Sale_AmountPartner_Weight TFloat, Sale_AmountPartner_Sh TFloat, Sale_AmountPartnerR_Weight TFloat, Sale_AmountPartnerR_Sh TFloat
             , Return_Summ TFloat, Return_Summ_10300 TFloat, Return_Summ_10700 TFloat, Return_SummCost TFloat, Return_SummCost_40200 TFloat
             , Return_Amount_Weight TFloat, Return_Amount_Sh TFloat, Return_AmountPartner_Weight TFloat, Return_AmountPartner_Sh TFloat
             , Sale_Amount_10500_Weight TFloat
             , Sale_Amount_40200_Weight TFloat
             , Return_Amount_40200_Weight TFloat
             , ReturnPercent TFloat
             , isTop Boolean
             , PaidKindId Integer, PaidKindName TVarChar
             , OperDate TDateTime
             , DayOfWeekName_Full TVarChar
             -- сумма вх (схема павильоны)
             , Sale_SummIn_pav TFloat
             , ReturnIn_SummIn_pav TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId_Constraint_Branch Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- определяется уровень доступа
    vbObjectId_Constraint_Branch:= (SELECT DISTINCT Object_RoleAccessKeyGuide_View.BranchId
                                    FROM Object_RoleAccessKeyGuide_View
                                    WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0
                                      -- Отчет продажа/возврат - все филиалы
                                      AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 7376335)
                                   );
    -- !!!меняется параметр!!!
    IF vbObjectId_Constraint_Branch > 0 THEN inBranchId:= vbObjectId_Constraint_Branch; END IF;

    -- для оптимизации
    inJuridicalId:= COALESCE (inJuridicalId, 0);
    inInfoMoneyId:= COALESCE (inInfoMoneyId, 0);
    inPaidKindId := COALESCE (inPaidKindId, 0);
    inBranchId   := COALESCE (inBranchId, 0);


    -- Результат
    RETURN QUERY
    -- собираем все данные
    WITH _tmpGoods AS
          (SELECT lfObject_Goods_byGoodsGroup.GoodsId AS GoodsId
                , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                    AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
           WHERE (ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId OR COALESCE (inTradeMarkId, 0) = 0)
             AND inGoodsGroupId > 0 -- !!!

          UNION
                SELECT ObjectLink_Goods_TradeMark.ObjectId AS GoodsId
                     , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                FROM ObjectLink AS ObjectLink_Goods_TradeMark
                WHERE ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                  AND ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId
                  AND COALESCE (inGoodsGroupId, 0) = 0 AND inIsGoods_where = TRUE -- !!!
          UNION
                SELECT ObjectLink_Goods_TradeMark.ObjectId AS GoodsId
                     , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                FROM ObjectLink AS ObjectLink_Goods_TradeMark
                WHERE ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                  AND ObjectLink_Goods_TradeMark.ChildObjectId > 0
                  AND (inIsTradeMark = TRUE AND inIsGoods = FALSE)
                  AND inIsGoods_where = FALSE -- !!!
          )
        , _tmpMemberBranch AS (SELECT DISTINCT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                               FROM ObjectLink AS ObjectLink_Personal_Unit
                                    INNER JOIN Object AS Object_Personal ON Object_Personal.Id       = ObjectLink_Personal_Unit.ObjectId
                                                                        AND Object_Personal.isErased = FALSE
                                    INNER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                          ON ObjectLink_Unit_Branch.ObjectId      = ObjectLink_Personal_Unit.ChildObjectId
                                                         AND ObjectLink_Unit_Branch.DescId        = zc_ObjectLink_Unit_Branch()
                                                         AND ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Constraint_Branch
                                                         AND vbObjectId_Constraint_Branch         > 0
                                                         AND inIsJuridical_Branch                 = TRUE
                                    INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                          ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Personal_Unit.ObjectId
                                                         AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                               WHERE ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                              )
        , _tmpJuridicalBranch AS (
                                     SELECT DISTINCT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                     FROM _tmpMemberBranch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                                ON ObjectLink_Personal_Member.ChildObjectId = _tmpMemberBranch.MemberId
                                                               AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                                ON ObjectLink_Partner_PersonalTrade.ChildObjectId = ObjectLink_Personal_Member.ObjectId
                                                               AND ObjectLink_Partner_PersonalTrade.DescId        = zc_ObjectLink_Partner_Personal()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                               AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                    UNION
                                     SELECT DISTINCT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                     FROM _tmpMemberBranch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                                ON ObjectLink_Personal_Member.ChildObjectId = _tmpMemberBranch.MemberId
                                                               AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                                ON ObjectLink_Partner_PersonalTrade.ChildObjectId = ObjectLink_Personal_Member.ObjectId
                                                               AND ObjectLink_Partner_PersonalTrade.DescId        = zc_ObjectLink_Partner_PersonalTrade()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                               AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                    UNION
                                     SELECT DISTINCT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                                     FROM _tmpMemberBranch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                                ON ObjectLink_Personal_Member.ChildObjectId = _tmpMemberBranch.MemberId
                                                               AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                                ON ObjectLink_Contract_Personal.ChildObjectId = ObjectLink_Personal_Member.ObjectId
                                                               AND ObjectLink_Contract_Personal.DescId        = zc_ObjectLink_Contract_Personal()
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                                ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_Personal.ObjectId
                                                               AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
                                 )

        , _tmpPartner AS (
        -- заполнение по Контрагенту
           SELECT ObjectLink_Partner_Area.ObjectId AS PartnerId
                , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, 0) AS JuridicalId
                -- , COALESCE (ObjectLink_Partner_Area.ChildObjectId, 0)
           FROM ObjectLink AS ObjectLink_Partner_Area
                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_Area.ObjectId
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
           WHERE ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
             AND ObjectLink_Partner_Area.ChildObjectId = inAreaId
             AND inAreaId > 0 -- !!!
                         )
        , _tmpJuridical AS (
           -- по Юр Лицу
           SELECT DISTINCT _tmpPartner.JuridicalId
           FROM _tmpPartner
                LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                     ON ObjectLink_Juridical_Retail.ObjectId = _tmpPartner.JuridicalId
                                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           WHERE (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR COALESCE (inRetailId, 0) = 0)
             AND (_tmpPartner.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)

             UNION
               -- по Юр Лицу (только)
               SELECT Object.Id
               FROM Object
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                         ON ObjectLink_Juridical_Retail.ObjectId = Object.Id
                                        AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               WHERE Object.Id = inJuridicalId
                 AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR COALESCE (inRetailId, 0) = 0)
                 AND COALESCE (inAreaId, 0) = 0 AND inJuridicalId > 0 -- !!!

                  UNION
                   -- по inRetailId
                   SELECT ObjectLink_Juridical_Retail.ObjectId
                   FROM ObjectLink AS ObjectLink_Juridical_Retail
                   WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                     AND ObjectLink_Juridical_Retail.ChildObjectId = inRetailId
                     AND COALESCE (inAreaId, 0) = 0 AND COALESCE (inJuridicalId, 0) = 0 -- !!!
                           )

       , tmpInfoMoney AS (SELECT * FROM Object_InfoMoney_View WHERE InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000()) -- !!!Доходы!!!)
       , tmpOperationGroup AS
                        (SELECT SoldTable.BranchId
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
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.GoodsGroupId     ELSE 0 END AS GoodsGroupId
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.GoodsGroupStatId ELSE 0 END AS GoodsGroupStatId
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.GoodsTagId       ELSE 0 END AS GoodsTagId
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.GoodsId          ELSE 0 END AS GoodsId
                              , CASE WHEN inIsGoodsKind = TRUE THEN SoldTable.GoodsKindId      ELSE 0 END AS GoodsKindId
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.MeasureId        ELSE 0 END AS MeasureId

                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.RegionId       END AS RegionId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.ProvinceId     END AS ProvinceId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.CityKindId     END AS CityKindId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.CityId         END AS CityId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.ProvinceCityId END AS ProvinceCityId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.StreetKindId   END AS StreetKindId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.StreetId       END AS StreetId
                              , SoldTable.PaidKindId
                              , CASE WHEN inIsDate = TRUE THEN SoldTable.OperDate ELSE NULL END ::TDateTime AS OperDate

                              , SUM (SoldTable.Actions_Summ) AS Promo_Summ
                              , SUM (SoldTable.Sale_Summ)    AS Sale_Summ
                              , SUM (SoldTable.Return_Summ)  AS Return_Summ

                              , SUM (SoldTable.Sale_Summ_10200)   AS Sale_Summ_10200
                              , SUM (SoldTable.Sale_Summ_10250)   AS Sale_Summ_10250
                              , SUM (SoldTable.Sale_Summ_10300)   AS Sale_Summ_10300
                              , SUM (SoldTable.Return_Summ_10300) AS Return_Summ_10300
                              , SUM (SoldTable.Return_Summ_10700) AS Return_Summ_10700

                              , SUM (SoldTable.Sale_Amount_Weight)   AS Sale_Amount_Weight
                              , SUM (SoldTable.Sale_Amount_Sh)       AS Sale_Amount_Sh
                              , SUM (SoldTable.Return_Amount_Weight) AS Return_Amount_Weight
                              , SUM (SoldTable.Return_Amount_Sh)     AS Return_Amount_Sh

                              , SUM (SoldTable.Actions_Weight)              AS Promo_AmountPartner_Weight
                              , SUM (SoldTable.Actions_Sh)                  AS Promo_AmountPartner_Sh
                              , SUM (SoldTable.Sale_AmountPartner_Weight)   AS Sale_AmountPartner_Weight
                              , SUM (SoldTable.Sale_AmountPartner_Sh)       AS Sale_AmountPartner_Sh
                              , SUM (SoldTable.Return_AmountPartner_Weight) AS Return_AmountPartner_Weight
                              , SUM (SoldTable.Return_AmountPartner_Sh)     AS Return_AmountPartner_Sh

                              , SUM (SoldTable.Sale_Amount_10500_Weight)    AS Sale_Amount_10500_Weight
                              , SUM (SoldTable.Sale_Amount_40200_Weight)    AS Sale_Amount_40200_Weight
                              , SUM (SoldTable.Return_Amount_40200_Weight)  AS Return_Amount_40200_Weight

                              , SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Actions_SummCost    ELSE 0 END) AS Promo_SummCost
                              , SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Sale_SummCost       ELSE 0 END) AS Sale_SummCost
                              , SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Sale_SummCost_10500 ELSE 0 END) AS Sale_SummCost_10500
                              , SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Sale_SummCost_40200 ELSE 0 END) AS Sale_SummCost_40200

                              , SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Return_SummCost       ELSE 0 END) AS Return_SummCost
                              , SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Return_SummCost_40200 ELSE 0 END) AS Return_SummCost_40200
                              -- сумма вх (схема павильоны)
                              , SUM (SoldTable.Sale_SummIn_pav)     AS Sale_SummIn_pav
                              , SUM (SoldTable.ReturnIn_SummIn_pav) AS ReturnIn_SummIn_pav
                         FROM SoldTable
                              LEFT JOIN _tmpJuridical ON _tmpJuridical.JuridicalId = SoldTable.JuridicalId
                              LEFT JOIN _tmpJuridicalBranch ON _tmpJuridicalBranch.JuridicalId = SoldTable.JuridicalId
                              LEFT JOIN _tmpPartner ON _tmpPartner.PartnerId = SoldTable.PartnerId
                              LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = SoldTable.GoodsId

                         WHERE SoldTable.OperDate BETWEEN inStartDate AND inEndDate
                           AND (SoldTable.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                           AND (SoldTable.InfoMoneyId = inInfoMoneyId OR inInfoMoneyId = 0)
                           AND (SoldTable.PaidKindId  = inPaidKindId  OR inPaidKindId  = 0)
                           AND (SoldTable.BranchId = inBranchId OR inBranchId = 0 OR _tmpJuridicalBranch.JuridicalId IS NOT NULL)
                           AND (_tmpJuridical.JuridicalId > 0 OR inIsJuridical_where = FALSE)
                           AND (_tmpPartner.PartnerId     > 0 OR inIsPartner_where   = FALSE)
                           AND (_tmpGoods.GoodsId         > 0 OR inIsGoods_where     = FALSE)
                         GROUP BY SoldTable.BranchId
                              , CASE WHEN inIsPartner  = TRUE  THEN SoldTable.JuridicalGroupId   ELSE 0 END
                              , CASE WHEN inIsPartner  = TRUE  THEN SoldTable.JuridicalId        ELSE 0 END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.PartnerId          END
                              , SoldTable.InfoMoneyId
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.RetailId           END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.RetailReportId     END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.AreaId             END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.PartnerTagId       END
                              , CASE WHEN inIsContract = FALSE THEN 0 ELSE SoldTable.ContractId         END
                              , CASE WHEN inIsContract = FALSE THEN 0 ELSE SoldTable.ContractTagId      END
                              , CASE WHEN inIsContract = FALSE THEN 0 ELSE SoldTable.ContractTagGroupId END

                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.PersonalId           END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.UnitId_Personal      END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.BranchId_Personal    END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.PersonalTradeId      END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.UnitId_PersonalTrade END

                              , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN SoldTable.GoodsPlatformId     ELSE 0 END
                              , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN SoldTable.TradeMarkId         ELSE 0 END
                              , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN SoldTable.GoodsGroupAnalystId ELSE 0 END
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.GoodsGroupId     ELSE 0 END
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.GoodsGroupStatId ELSE 0 END
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.GoodsTagId       ELSE 0 END
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.GoodsId          ELSE 0 END
                              , CASE WHEN inIsGoodsKind = TRUE THEN SoldTable.GoodsKindId      ELSE 0 END
                              , CASE WHEN inIsGoods     = TRUE THEN SoldTable.MeasureId        ELSE 0 END

                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.RegionId       END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.ProvinceId     END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.CityKindId     END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.CityId         END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.ProvinceCityId END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.StreetKindId   END
                              , CASE WHEN inIsPartner  = FALSE THEN 0 ELSE SoldTable.StreetId       END
                              , SoldTable.PaidKindId
                              , CASE WHEN inIsDate = TRUE THEN SoldTable.OperDate ELSE NULL END
                         HAVING SUM (SoldTable.Actions_Summ) <> 0
                             OR SUM (SoldTable.Sale_Summ)    <> 0
                             OR SUM (SoldTable.Return_Summ)  <> 0

                             OR SUM (SoldTable.Sale_Summ_10200)   <> 0
                             OR SUM (SoldTable.Sale_Summ_10250)   <> 0
                             OR SUM (SoldTable.Sale_Summ_10300)   <> 0
                             OR SUM (SoldTable.Return_Summ_10300) <> 0
                             OR SUM (SoldTable.Return_Summ_10700) <> 0

                             OR SUM (SoldTable.Sale_Amount_Weight)   <> 0
                             OR SUM (SoldTable.Sale_Amount_Sh)       <> 0
                             OR SUM (SoldTable.Return_Amount_Weight) <> 0
                             OR SUM (SoldTable.Return_Amount_Sh)     <> 0

                             OR SUM (SoldTable.Actions_Weight)              <> 0
                             OR SUM (SoldTable.Actions_Sh)                  <> 0
                             OR SUM (SoldTable.Sale_AmountPartner_Weight)   <> 0
                             OR SUM (SoldTable.Sale_AmountPartner_Sh)       <> 0
                             OR SUM (SoldTable.Return_AmountPartner_Weight) <> 0
                             OR SUM (SoldTable.Return_AmountPartner_Sh)     <> 0

                             OR SUM (SoldTable.Sale_Amount_10500_Weight)    <> 0
                             OR SUM (SoldTable.Sale_Amount_40200_Weight)    <> 0
                             OR SUM (SoldTable.Return_Amount_40200_Weight)  <> 0

                             OR SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Actions_SummCost    ELSE 0 END) <> 0
                             OR SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Sale_SummCost       ELSE 0 END) <> 0
                             OR SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Sale_SummCost_10500 ELSE 0 END) <> 0
                             OR SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Sale_SummCost_40200 ELSE 0 END) <> 0

                             OR SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Return_SummCost       ELSE 0 END) <> 0
                             OR SUM (CASE WHEN inIsCost = TRUE THEN SoldTable.Return_SummCost_40200 ELSE 0 END) <> 0

                              -- сумма вх (схема павильоны)
                             OR SUM (SoldTable.Sale_SummIn_pav) <> 0
                             OR SUM (SoldTable.ReturnIn_SummIn_pav) <> 0
                        )

        -- выбираем данные по признаку товара ТОП из GoodsByGoodsKind
       , _tmpTOP AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                          , Object_GoodsByGoodsKind_View.GoodsKindId
                     FROM ObjectBoolean
                          LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean.ObjectId
                     WHERE ObjectBoolean.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Top()
                       AND COALESCE (ObjectBoolean.ValueData, FALSE) = TRUE
                     )


     ---
     SELECT Object_GoodsGroup.ValueData        AS GoodsGroupName
          , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
          , Object_Goods.Id                    AS GoodsId
          , Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName
          , Object_GoodsKind.Id                AS GoodsKindId
          , Object_GoodsKind.ValueData         AS GoodsKindName
          , Object_Measure.ValueData           AS MeasureName
          , Object_TradeMark.Id         AS TradeMarkId
          , Object_TradeMark.ValueData         AS TradeMarkName
          , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
          , Object_GoodsTag.ValueData          AS GoodsTagName
          , Object_GoodsGroupStat.ValueData    AS GoodsGroupStatName
          , Object_GoodsPlatform.ValueData     AS GoodsPlatformName

          , Object_JuridicalGroup.ValueData  AS JuridicalGroupName
          , Object_Branch.Id            AS BranchId
          , Object_Branch.ObjectCode    AS BranchCode
          , Object_Branch.ValueData     AS BranchName
          , Object_Juridical.Id         AS JuridicalId
          , Object_Juridical.ObjectCode AS JuridicalCode
          , Object_Juridical.ValueData  AS JuridicalName

          , Object_Retail.ValueData       AS RetailName
          , Object_RetailReport.ValueData AS RetailReportName

          , Object_Area.ValueData          AS AreaName
          , Object_PartnerTag.ValueData    AS PartnerTagName
          , ObjectFloat_Category.ValueData ::TFloat AS PartnerCategory
          , ObjectString_Address.ValueData AS Address
          , Object_Region.ValueData        AS RegionName
          , Object_Province.ValueData      AS ProvinceName
          , Object_CityKind.ValueData      AS CityKindName
          , Object_City.ValueData          AS CityName

          , Object_Partner.Id         AS PartnerId
          , Object_Partner.ObjectCode AS PartnerCode
          , Object_Partner.ValueData  AS PartnerName

          , Object_Contract.Id                AS ContractId
          , Object_Contract.ObjectCode        AS ContractCode
          , Object_Contract.ValueData         AS ContractNumber
          , Object_ContractTag.ValueData      AS ContractTagName
          , Object_ContractTagGroup.ValueData AS ContractTagGroupName

          , Object_Personal.ValueData        AS PersonalName
          , Object_UnitPersonal.ValueData    AS UnitName_Personal
          , Object_BranchPersonal.ValueData  AS BranchName_Personal

          , Object_PersonalTrade.ValueData     AS PersonalTradeName
          , Object_UnitPersonalTrade.ValueData AS UnitName_PersonalTrade

          , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyId                     AS InfoMoneyId
          , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
          , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all               AS InfoMoneyName_all

         , tmpOperationGroup.Promo_Summ         :: TFloat  AS Promo_Summ
         , tmpOperationGroup.Sale_Summ          :: TFloat  AS Sale_Summ
         , tmpOperationGroup.Sale_Summ          :: TFloat  AS Sale_SummReal
         , tmpOperationGroup.Sale_Summ_10200    :: TFloat  AS Sale_Summ_10200
         , tmpOperationGroup.Sale_Summ_10250    :: TFloat  AS Sale_Summ_10250
         , tmpOperationGroup.Sale_Summ_10300    :: TFloat  AS Sale_Summ_10300

         , tmpOperationGroup.Promo_SummCost     :: TFloat  AS Promo_SummCost
         , tmpOperationGroup.Sale_SummCost      :: TFloat  AS Sale_SummCost
         , tmpOperationGroup.Sale_SummCost_10500:: TFloat  AS Sale_SummCost_10500
         , tmpOperationGroup.Sale_SummCost_40200:: TFloat  AS Sale_SummCost_40200

         , tmpOperationGroup.Sale_Amount_Weight :: TFloat  AS Sale_Amount_Weight
         , tmpOperationGroup.Sale_Amount_Sh     :: TFloat  AS Sale_Amount_Sh

         , tmpOperationGroup.Promo_AmountPartner_Weight :: TFloat AS Promo_AmountPartner_Weight
         , tmpOperationGroup.Promo_AmountPartner_Sh     :: TFloat AS Promo_AmountPartner_Sh
         , tmpOperationGroup.Sale_AmountPartner_Weight  :: TFloat AS Sale_AmountPartner_Weight
         , tmpOperationGroup.Sale_AmountPartner_Sh      :: TFloat AS Sale_AmountPartner_Sh
         , tmpOperationGroup.Sale_AmountPartner_Weight  :: TFloat AS Sale_AmountPartnerR_Weight
         , tmpOperationGroup.Sale_AmountPartner_Sh      :: TFloat AS Sale_AmountPartnerR_Sh

         , tmpOperationGroup.Return_Summ          :: TFloat AS Return_Summ
         , tmpOperationGroup.Return_Summ_10300    :: TFloat AS Return_Summ_10300
         , tmpOperationGroup.Return_Summ_10700    :: TFloat AS Return_Summ_10700
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
         , CASE WHEN _tmpTOP.GoodsId IS NULL THEN FALSE ELSE TRUE END ::Boolean AS isTop

         , Object_PaidKind.Id        AS PaidKindId
         , Object_PaidKind.ValueData AS PaidKindName

         , tmpOperationGroup.OperDate    ::TDateTime
         , tmpWeekDay.DayOfWeekName_Full ::TVarChar AS DayOfWeekName_Full

         -- сумма вх (схема павильоны)
         , tmpOperationGroup.Sale_SummIn_pav     :: TFloat AS Sale_SummIn_pav
         , tmpOperationGroup.ReturnIn_SummIn_pav :: TFloat AS ReturnIn_SummIn_pav
     FROM tmpOperationGroup
          -- LEFT JOIN _tmp_noDELETE_Partner ON _tmp_noDELETE_Partner.FromId = tmpOperationGroup.PartnerId AND 1 = 0

          LEFT JOIN Object AS Object_Branch    ON Object_Branch.Id    = tmpOperationGroup.BranchId
          LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_PaidKind  ON Object_PaidKind.Id  = tmpOperationGroup.PaidKindId

          LEFT JOIN Object AS Object_GoodsPlatform     ON Object_GoodsPlatform.Id     = tmpOperationGroup.GoodsPlatformId
          LEFT JOIN Object AS Object_TradeMark         ON Object_TradeMark.Id         = tmpOperationGroup.TradeMarkId
          LEFT JOIN Object AS Object_GoodsGroupStat    ON Object_GoodsGroupStat.Id    = tmpOperationGroup.GoodsGroupStatId
          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = tmpOperationGroup.GoodsGroupAnalystId
          LEFT JOIN Object AS Object_GoodsTag          ON Object_GoodsTag.Id          = tmpOperationGroup.GoodsTagId
          LEFT JOIN Object AS Object_Measure           ON Object_Measure.Id           = tmpOperationGroup.MeasureId

          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpOperationGroup.GoodsGroupId
          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId
          LEFT JOIN Object AS Object_Partner   ON Object_Partner.Id   = tmpOperationGroup.PartnerId
          LEFT JOIN ObjectString AS ObjectString_Address
                                 ON ObjectString_Address.ObjectId = Object_Partner.Id
                                AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
          LEFT JOIN ObjectFloat AS ObjectFloat_Category
                                ON ObjectFloat_Category.ObjectId = Object_Partner.Id
                               AND ObjectFloat_Category.DescId = zc_ObjectFloat_Partner_Category()

          LEFT JOIN Object AS Object_Area ON Object_Area.Id = tmpOperationGroup.AreaId
          LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = tmpOperationGroup.PartnerTagId

          LEFT JOIN Object AS Object_Region       ON Object_Region.Id       = tmpOperationGroup.RegionId
          LEFT JOIN Object AS Object_Province     ON Object_Province.Id     = tmpOperationGroup.ProvinceId
          LEFT JOIN Object AS Object_CityKind     ON Object_CityKind.Id     = tmpOperationGroup.CityKindId
          LEFT JOIN Object AS Object_City         ON Object_City.Id         = tmpOperationGroup.CityId
          /*LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = tmpOperationGroup.ProvinceCityId
          LEFT JOIN Object AS Object_StreetKind   ON Object_StreetKind.Id   = tmpOperationGroup.StreetKindId
          LEFT JOIN Object AS Object_Street       ON Object_Street.Id       = tmpOperationGroup.StreetId*/

          LEFT JOIN Object AS Object_Retail         ON Object_Retail.Id         = tmpOperationGroup.RetailId
          LEFT JOIN Object AS Object_RetailReport   ON Object_RetailReport.Id   = tmpOperationGroup.RetailReportId
          LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = tmpOperationGroup.JuridicalGroupId

          LEFT JOIN Object AS Object_Contract         ON Object_Contract.Id         = tmpOperationGroup.ContractId
          LEFT JOIN Object AS Object_ContractTag      ON Object_ContractTag.Id      = tmpOperationGroup.ContractTagId
          LEFT JOIN Object AS Object_ContractTagGroup ON Object_ContractTagGroup.Id = tmpOperationGroup.ContractTagGroupId

          LEFT JOIN tmpInfoMoney AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId

          LEFT JOIN Object AS Object_Personal          ON Object_Personal.Id          = tmpOperationGroup.PersonalId
          LEFT JOIN Object AS Object_UnitPersonal      ON Object_UnitPersonal.Id      = tmpOperationGroup.UnitId_Personal
          LEFT JOIN Object AS Object_BranchPersonal    ON Object_BranchPersonal.Id    = tmpOperationGroup.BranchId_Personal
          LEFT JOIN Object AS Object_PersonalTrade     ON Object_PersonalTrade.Id     = tmpOperationGroup.PersonalTradeId
          LEFT JOIN Object AS Object_UnitPersonalTrade ON Object_UnitPersonalTrade.Id = tmpOperationGroup.UnitId_PersonalTrade

          LEFT JOIN _tmpTOP ON _tmpTOP.GoodsId = tmpOperationGroup.GoodsId
                           AND COALESCE (_tmpTOP.GoodsKindId,0) = COALESCE (tmpOperationGroup.GoodsKindId,0)

          LEFT JOIN zfCalc_DayOfWeekName (tmpOperationGroup.OperDate) AS tmpWeekDay ON 1=1
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.03.22         * 
 25.08.21         * add PaidKind
 03.06.21         * add isTop
 28.04.21         * add PartnerCategory
 29.04.21         *
 13.02.16                                        *
*/

/*
-- update SoldTable set areaId = 341611 where PartnerId = 1070965
-- select distinct areaId FROM SoldTable where PartnerId = 1070965 -- select max (operDate) FROM SoldTable where PartnerId = 1070965

    CREATE TEMP TABLE _tmpGoods (GoodsId Integer, TradeMarkId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpPartner (PartnerId Integer, JuridicalId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpJuridical (JuridicalId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpJuridicalBranch (JuridicalId Integer) ON COMMIT DROP;
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_SaleReturnIn_Olap (inStartDate:= '01.01.2019', inEndDate:= '01.01.2019', inBranchId:= 0, inAreaId:= 0, inRetailId:= 0, inJuridicalId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inTradeMarkId:= 0, inGoodsGroupId:= 0, inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inIsPartner:= TRUE, inIsTradeMark:= TRUE, inIsGoods:= TRUE, inIsGoodsKind:= TRUE, inIsContract:= FALSE, inIsJuridical_Branch:= FALSE, inIsJuridical_where:= FALSE, inIsPartner_where:= FALSE, inIsGoods_where:= FALSE, inIsCost:= FALSE, inSession:= zfCalc_UserAdmin());
