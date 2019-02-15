-- Function: gpReport_Goods_Movement ()
DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnIn_BUH (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI_SaleReturnIn_BUH (
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
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar, GoodsGroupAnalystName TVarChar, GoodsTagName TVarChar, GoodsGroupStatName TVarChar
             , GoodsPlatformName TVarChar
             , JuridicalGroupName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar/*, OKPO TVarChar*/
             , RetailName TVarChar, RetailReportName TVarChar
             , AreaName TVarChar, PartnerTagName TVarChar
             , Address TVarChar, RegionName TVarChar, ProvinceName TVarChar, CityKindName TVarChar, CityName TVarChar/*, ProvinceCityName TVarChar, StreetKindName TVarChar, StreetName TVarChar*/
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar, ContractTagGroupName TVarChar
             , PersonalName TVarChar, UnitName_Personal TVarChar, BranchName_Personal TVarChar
             , PersonalTradeName TVarChar, UnitName_PersonalTrade TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar

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
             , Sale_SummMVAT TFloat, Sale_SummVAT TFloat
             , Return_SummMVAT TFloat, Return_SummVAT TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   --DECLARE vbIsPartner_where Boolean;
   --DECLARE vbIsJuridical_where Boolean;
   DECLARE vbIsJuridical_Branch Boolean;
   DECLARE vbIsCost Boolean;

   DECLARE vbObjectId_Constraint_Branch Integer;
   DECLARE vbIsGoods Boolean;
   DECLARE vbIsPartner Boolean;
   DECLARE vbIsJuridicalBranch Boolean;
   DECLARE vbIsJuridical Boolean;
   DECLARE vbisgoods_where Boolean;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

/* ******************************************************** */
    -- определяется уровень доступа
   vbObjectId_Constraint_Branch:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0);
    -- !!!меняется параметр!!!
    IF vbObjectId_Constraint_Branch > 0 THEN inBranchId:= vbObjectId_Constraint_Branch; END IF;

    -- определяется уровень доступа для с/с
    vbIsCost:= EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin(), 10898, 326391) AND UserId = vbUserId); -- Отчеты (управленцы) + Аналитики по продажам

    vbIsGoods:= FALSE;
    vbIsPartner:= FALSE;
    vbIsJuridical:= FALSE;
    ---
    vbIsJuridicalBranch:= COALESCE (inBranchId, 0) = 0;
    --
    IF inAreaId <> 0
    THEN
        -- устанавливается признак
        vbIsPartner:= TRUE;
        -- устанавливается признак
        vbIsJuridical:= TRUE;
    ELSE
        -- по Юр Лицу (только)
        IF inJuridicalId <> 0
        THEN
            -- устанавливается признак
            vbIsJuridical:= TRUE;
        ELSE
            IF inRetailId <> 0
            THEN
                -- устанавливается признак
                vbIsJuridical:= TRUE;
            END IF;
        END IF;
    END IF;
                  
/* ******************************************************** */
   RETURN QUERY
    WITH
    _tmpGoods AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId AS GoodsId
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
                        AND COALESCE (inGoodsGroupId, 0) = 0 AND vbIsGoods_where = TRUE -- !!!
                UNION
                      SELECT ObjectLink_Goods_TradeMark.ObjectId AS GoodsId
                           , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                      FROM ObjectLink AS ObjectLink_Goods_TradeMark
                      WHERE ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                        AND ObjectLink_Goods_TradeMark.ChildObjectId > 0
                        AND (inIsTradeMark = TRUE AND inIsGoods = FALSE)
                        AND vbIsGoods_where = FALSE -- !!!
                )

  , _tmpJuridicalBranch AS (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                            FROM ObjectLink AS ObjectLink_Unit_Branch
                                 INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                       ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                      AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                 INNER JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                       ON ObjectLink_Partner_PersonalTrade.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                      AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                 INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Constraint_Branch
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND vbIsJuridical_Branch = TRUE AND vbObjectId_Constraint_Branch <> 0 -- !!!
                            GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
                           UNION
                            SELECT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                            FROM ObjectLink AS ObjectLink_Unit_Branch
                                 INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                       ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                      AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                 INNER JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                       ON ObjectLink_Contract_Personal.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                      AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                 INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                       ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_Personal.ObjectId
                                                      AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                            WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Constraint_Branch
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND vbIsJuridical_Branch = TRUE AND vbObjectId_Constraint_Branch <> 0 -- !!!
                            GROUP BY ObjectLink_Contract_Juridical.ChildObjectId
                           )

  , _tmpPartner AS (-- заполнение по Контрагенту
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
  , _tmpJuridical AS (-- по Юр Лицу
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

  , tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                         , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                    FROM Constant_ProfitLoss_AnalyzerId_View
                    WHERE isCost = FALSE OR (isCost = TRUE AND vbIsCost = TRUE)
                   ) 
  , tmpOperationGroup2 AS (SELECT MIContainer.ContainerId_Analyzer
                                , MIContainer.ObjectId_Analyzer                 AS GoodsId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MIContainer.ObjectId_Analyzer ELSE MovementLinkObject_Partner.ObjectId END AS PartnerId
                                , COALESCE (MILinkObject_Branch.ObjectId, 0)   AS BranchId
                                , COALESCE (ContainerLO_Juridical.ObjectId, 0) AS JuridicalId
                                , COALESCE (ContainerLO_InfoMoney.ObjectId, 0) AS InfoMoneyId
  
                                , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                                , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ
  
                                , CAST (SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() 
                                                  THEN  -1 * MIContainer.Amount * (CASE WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE THEN MIFloat_Price.ValueData 
                                                                                        ELSE CAST ( (MIFloat_Price.ValueData) / (1 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, COALESCE (MovementFloat_VATPercent.ValueData, 0)) / 100) AS NUMERIC (16, 2))
                                                                                   END)
                                                  ELSE 0 END) AS NUMERIC (16, 2)) AS Sale_SummMVAT
                                , CAST (SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() 
                                                  THEN MIContainer.Amount * (CASE WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE THEN MIFloat_Price.ValueData 
                                                                                  ELSE CAST ( (MIFloat_Price.ValueData) / (1 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, COALESCE (MovementFloat_VATPercent.ValueData, 0)) / 100) AS NUMERIC (16, 2))
                                                                             END)
                                                  ELSE 0 END) AS NUMERIC (16, 2)) AS Return_SummMVAT
                           FROM tmpAnalyzer
                                INNER JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                                AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                               ON ContainerLO_Juridical.ContainerId = MIContainer.ContainerId_Analyzer
                                                              AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                              AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                INNER JOIN ContainerLinkObject AS ContainerLO_InfoMoney
                                                               ON ContainerLO_InfoMoney.ContainerId = MIContainer.ContainerId_Analyzer
                                                              AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                              AND (ContainerLO_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                                INNER JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                               ON ContainerLO_PaidKind.ContainerId = MIContainer.ContainerId_Analyzer
                                                              AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                              AND (ContainerLO_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                             ON MovementLinkObject_Partner.MovementId = MIContainer.MovementId
                                                            AND MovementLinkObject_Partner.DescId = CASE WHEN MIContainer.MovementDescId = zc_Movement_PriceCorrective() THEN zc_MovementLinkObject_Partner() ELSE tmpAnalyzer.MLO_DescId END
  
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MIContainer.MovementItemId
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                                 ON MILinkObject_Branch.MovementItemId = MIContainer.MovementItemId
                                                                AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
  
                                LEFT JOIN _tmpJuridical ON _tmpJuridical.JuridicalId = ContainerLO_Juridical.ObjectId
                                LEFT JOIN _tmpJuridicalBranch ON _tmpJuridicalBranch.JuridicalId = ContainerLO_Juridical.ObjectId
  
                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MIContainer.MovementItemId
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
  
                                LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                          ON MovementBoolean_PriceWithVAT.MovementId = MIContainer.MovementId
                                                         AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
  
                                LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                        ON MovementFloat_VATPercent.MovementId = MIContainer.MovementId
                                                       AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                             ON MovementLinkObject_NDSKind.MovementId = MIContainer.MovementId
                                                            AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                  
                           WHERE (_tmpJuridical.JuridicalId > 0 OR vbIsJuridical = FALSE)
                             AND (MILinkObject_Branch.ObjectId = inBranchId OR COALESCE (inBranchId, 0) = 0 OR _tmpJuridicalBranch.JuridicalId IS NOT NULL)
                           GROUP BY MIContainer.ContainerId_Analyzer
                                  , MIContainer.ObjectId_Analyzer                 
                                  , MILinkObject_GoodsKind.ObjectId
                                  , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MIContainer.ObjectId_Analyzer ELSE MovementLinkObject_Partner.ObjectId END
                                  , MILinkObject_Branch.ObjectId
                                  , ContainerLO_Juridical.ObjectId
                                  , ContainerLO_InfoMoney.ObjectId
                          )

  , tmpOperationGroup AS (SELECT CASE WHEN inIsPartner = TRUE THEN tmpOperationGroup2.JuridicalId ELSE 0 END AS JuridicalId
                               , CASE WHEN inIsPartner = TRUE THEN ContainerLinkObject_Contract.ObjectId ELSE 0 END AS ContractId
                               , CASE WHEN inIsPartner = FALSE THEN 0 ELSE tmpOperationGroup2.PartnerId END AS PartnerId
                               , tmpOperationGroup2.InfoMoneyId
                               , tmpOperationGroup2.BranchId
                               , 0 as TradeMarkId
                               , CASE WHEN inIsGoods = TRUE THEN tmpOperationGroup2.GoodsId ELSE 0 END     AS GoodsId
                               , CASE WHEN inIsGoodsKind = TRUE THEN tmpOperationGroup2.GoodsKindId ELSE 0 END AS GoodsKindId
 
                               , SUM (tmpOperationGroup2.Sale_SummMVAT) AS Sale_SummMVAT
                               , SUM (tmpOperationGroup2.Sale_Summ - tmpOperationGroup2.Sale_SummMVAT) AS Sale_SummVAT
                               , SUM (tmpOperationGroup2.Return_SummMVAT) aS Return_SummMVAT
                               , SUM (tmpOperationGroup2.Return_Summ - tmpOperationGroup2.Return_SummMVAT) AS Return_SummVAT
                          FROM tmpOperationGroup2
                               LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Contract
                                                             ON ContainerLinkObject_Contract.ContainerId = tmpOperationGroup2.ContainerId_Analyzer
                                                            AND ContainerLinkObject_Contract.DescId = zc_ContainerLinkObject_Contract()
 
                               LEFT JOIN _tmpPartner ON _tmpPartner.PartnerId = tmpOperationGroup2.PartnerId
                               LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpOperationGroup2.GoodsId
                          WHERE (_tmpPartner.PartnerId > 0 OR vbIsPartner = FALSE)
                            AND (_tmpGoods.GoodsId > 0 OR vbIsGoods = FALSE)
                          GROUP BY CASE WHEN inIsPartner = TRUE THEN tmpOperationGroup2.JuridicalId ELSE 0 END
                                 , CASE WHEN inIsPartner = TRUE THEN ContainerLinkObject_Contract.ObjectId ELSE 0 END
                                 , CASE WHEN inIsPartner = FALSE THEN 0 ELSE tmpOperationGroup2.PartnerId END
                                 , tmpOperationGroup2.InfoMoneyId
                                 , tmpOperationGroup2.BranchId
                                 , _tmpGoods.TradeMarkId
                                 , CASE WHEN inIsGoods = TRUE THEN tmpOperationGroup2.GoodsId ELSE 0 END    
                                 , CASE WHEN inIsGoodsKind = TRUE THEN tmpOperationGroup2.GoodsKindId ELSE 0 END
                          )
  ,_tmpMI AS (SELECT Object_Juridical.ObjectCode        AS JuridicalCode
                   , Object_Juridical.ValueData         AS JuridicalName
                   , Object_Contract.ObjectCode         AS ContractCode
                   , Object_Contract.ValueData          AS ContractNumber
                   , tmpOperationGroup.PartnerId
                   , Object_InfoMoney.ObjectCode        AS InfoMoneyCode
                   , Object_InfoMoney.ValueData         AS InfoMoneyName
                   , Object_Branch.ObjectCode           AS BranchCode
                   , Object_Branch.ValueData            AS BranchName
                   , Object_TradeMark.ValueData         AS TradeMarkName
         
                   , Object_Goods.ObjectCode            AS GoodsCode
                   , Object_Goods.ValueData             AS GoodsName
                   , Object_GoodsKind.ValueData         AS GoodsKindName
          
                  , tmpOperationGroup.Sale_SummMVAT      :: TFloat
                  , tmpOperationGroup.Sale_SummVAT       :: TFloat
                  , tmpOperationGroup.Return_SummMVAT    :: TFloat
                  , tmpOperationGroup.Return_SummVAT     :: TFloat
              FROM tmpOperationGroup
                   LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpOperationGroup.BranchId
                   LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
         
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                        ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                   LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, tmpOperationGroup.TradeMarkId)
         
                   LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId
         
                   LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpOperationGroup.ContractId
                   LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpOperationGroup.InfoMoneyId
              ) 
       -- результат
       SELECT tmp.*
            , _tmpMI.Sale_SummMVAT, _tmpMI.Sale_SummVAT
            , _tmpMI.Return_SummMVAT, _tmpMI.Return_SummVAT
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
                                         , inSession
                                          ) AS tmp
           LEFT JOIN _tmpMI ON COALESCE (_tmpMI.JuridicalName,'')  = COALESCE (tmp.JuridicalName, '')
                           AND ((COALESCE (_tmpMI.ContractNumber,'') = COALESCE (tmp.ContractNumber,'')) OR tmp.ContractNumber IS NULL)
                           AND COALESCE (_tmpMI.PartnerId ,0)      = COALESCE (tmp.PartnerId,0)
                           AND COALESCE (_tmpMI.InfoMoneyName,'')  = COALESCE (tmp.InfoMoneyName,'')
                           AND COALESCE (_tmpMI.BranchName,'')     = COALESCE (tmp.BranchName,'')
                           AND COALESCE (_tmpMI.TradeMarkName,'')  = COALESCE (tmp.TradeMarkName,'')
                           AND COALESCE (_tmpMI.GoodsName,'')      = COALESCE (tmp.GoodsName,'') 
                           AND COALESCE (_tmpMI.GoodsKindName, '') = COALESCE (tmp.GoodsKindName, '') --and 1=0
;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.02.19         *
*/
-- тест
--
--select * from gpReport_GoodsMI_SaleReturnIn_BUH(inStartDate := ('01.02.2019')::TDateTime , inEndDate := ('03.02.2019')::TDateTime , inBranchId := 0 , inAreaId := 0 , inRetailId := 0 , inJuridicalId := 0 , inPaidKindId := 0 , inTradeMarkId := 0 , inGoodsGroupId := 1832 , inInfoMoneyId := 0 , inIsPartner := 'True' , inIsTradeMark := 'False' , inIsGoods := 'False' , inIsGoodsKind := 'False' , inisContract := 'False' , inIsOLAP := 'True' ,  inSession := '140094');
--select * from gpReport_GoodsMI_SaleReturnIn_BUH   (inStartDate := ('01.02.2019')::TDateTime , inEndDate := ('01.02.2019')::TDateTime , inBranchId := 0 , inAreaId := 0 , inRetailId := 0 , inJuridicalId := 0 , inPaidKindId := 0 , inTradeMarkId := 0 , inGoodsGroupId := 1832 , inInfoMoneyId := 0 , inIsPartner := 'True' , inIsTradeMark := 'False' , inIsGoods := 'False' , inIsGoodsKind := 'False' , inisContract := 'False' , inIsOLAP := 'True' ,  inSession := '140094') ttt

