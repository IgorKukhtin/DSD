-- Function: gpReport_Goods_Movement ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnIn_OLD_TWO (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_SaleReturnIn_OLD_TWO (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inBranchId     Integer   , -- Филиал
    IN inAreaId       Integer   , -- Регион (контрагенты -> юр лица)
    IN inRetailId     Integer   , -- Торговая сеть (юр лица)
    IN inJuridicalId  Integer   ,
    IN inPaidKindId   Integer   , --
    IN inTradeMarkId  Integer   ,
    IN inGoodsGroupId Integer   ,
    IN inInfoMoneyId  Integer   ,-- Управленческая статья
    IN inIsPartner    Boolean   , --
    IN inIsTradeMark  Boolean   , --
    IN inIsGoods      Boolean   , --
    IN inIsGoodsKind  Boolean   , --
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
             , Promo_AmountPartner_Weight TFloat, Promo_AmountPartner_Sh TFloat, Sale_Amount_Weight TFloat, Sale_Amount_Sh TFloat, Sale_AmountPartner_Weight TFloat, Sale_AmountPartner_Sh TFloat, Sale_AmountPartnerR_Weight TFloat, Sale_AmountPartnerR_Sh TFloat
             , Return_Summ TFloat, Return_Summ_10300 TFloat, Return_Summ_10700 TFloat, Return_SummCost TFloat, Return_SummCost_40200 TFloat
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
     
     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

/*
    -- !!!т.к. нельзя когда много данных в гриде!!!
    IF inStartDate + (INTERVAL '62 DAY') <= inEndDate AND inIsPartner = TRUE AND inIsGoods = TRUE
    THEN
        inStartDate:= inEndDate + (INTERVAL '1 DAY');
    END IF;
*/


    vbIsJuridicalBranch:= COALESCE (inBranchId, 0) = 0;

    -- определяется уровень доступа
    vbObjectId_Constraint_Branch:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
    -- !!!меняется параметр!!!
    IF vbObjectId_Constraint_Branch > 0 THEN inBranchId:= vbObjectId_Constraint_Branch; END IF;

    -- определяется уровень доступа для с/с
    vbIsCost:= EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin(), 10898, 326391) AND UserId = vbUserId); -- Отчеты (управленцы) + Аналитики по продажам


    vbIsGoods:= FALSE;
    vbIsPartner:= FALSE;
    vbIsJuridical:= FALSE;


    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer, TradeMarkId Integer) ON COMMIT DROP;

    IF inGoodsGroupId <> 0
    THEN
        -- устанавливается признак
        vbIsGoods:= TRUE;
        -- заполнение
        INSERT INTO _tmpGoods (GoodsId, TradeMarkId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId AS GoodsId
                , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                -- , COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0) AS MeasureId
                -- , COALESCE (ObjectFloat_Weight.ValueData, 0)           AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                    AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
/*                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()*/
           WHERE (ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId OR COALESCE (inTradeMarkId, 0) = 0)
       ;
    ELSE IF inTradeMarkId <> 0
         THEN
             -- устанавливается признак
             vbIsGoods:= TRUE;
             -- заполнение
             INSERT INTO _tmpGoods (GoodsId, TradeMarkId)
                SELECT ObjectLink_Goods_TradeMark.ObjectId AS GoodsId
                     , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                FROM ObjectLink AS ObjectLink_Goods_TradeMark
                WHERE ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                  AND ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId
            ;
         ELSE
             -- устанавливается признак
             vbIsGoods:= FALSE;
             -- заполнение
             INSERT INTO _tmpGoods (GoodsId, TradeMarkId)
                SELECT ObjectLink_Goods_TradeMark.ObjectId AS GoodsId
                     , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                FROM ObjectLink AS ObjectLink_Goods_TradeMark
                WHERE ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                  AND ObjectLink_Goods_TradeMark.ChildObjectId > 0
                  AND (inIsTradeMark = TRUE AND inIsGoods = FALSE)
            ;

         END IF;
    END IF;

    -- Ограничения
    CREATE TEMP TABLE _tmpPartner (PartnerId Integer, JuridicalId Integer/*, AreaId Integer*/) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpJuridical (JuridicalId Integer/*, RetailId Integer, JuridicalGroupId Integer, OKPO TVarChar*/) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpJuridicalBranch (JuridicalId Integer) ON COMMIT DROP;
    --
    IF vbIsJuridicalBranch = TRUE AND vbObjectId_Constraint_Branch <> 0
    THEN
        INSERT INTO _tmpJuridicalBranch (JuridicalId)
                                     SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
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
                                     GROUP BY ObjectLink_Contract_Juridical.ChildObjectId;
    END IF;
    --
    IF inAreaId <> 0
    THEN
        -- устанавливается признак
        vbIsPartner:= TRUE;
        -- заполнение по Контрагенту
        INSERT INTO _tmpPartner (PartnerId, JuridicalId/*, AreaId*/)
           SELECT ObjectLink_Partner_Area.ObjectId
                , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, 0)
                -- , COALESCE (ObjectLink_Partner_Area.ChildObjectId, 0)
           FROM ObjectLink AS ObjectLink_Partner_Area
                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_Area.ObjectId
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
           WHERE ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
             AND ObjectLink_Partner_Area.ChildObjectId = inAreaId
       ;
        -- устанавливается признак
        vbIsJuridical:= TRUE;
        -- заполнение по Юр Лицу
        INSERT INTO _tmpJuridical (JuridicalId/*, RetailId, JuridicalGroupId, OKPO*/)
           SELECT _tmpPartner.JuridicalId
                -- , COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0)
                -- , COALESCE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId, 0)
                -- , COALESCE (ObjectHistory_JuridicalDetails_View.OKPO, '')
           FROM _tmpPartner
                LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                     ON ObjectLink_Juridical_Retail.ObjectId = _tmpPartner.JuridicalId
                                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                     ON ObjectLink_Juridical_JuridicalGroup.ObjectId = _tmpPartner.JuridicalId
                                    AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
                LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = _tmpPartner.JuridicalId*/
           WHERE (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR COALESCE (inRetailId, 0) = 0)
             AND (_tmpPartner.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
           GROUP BY _tmpPartner.JuridicalId
       ;
    ELSE
        -- по Юр Лицу (только)
        IF inJuridicalId <> 0
        THEN
            -- устанавливается признак
            vbIsJuridical:= TRUE;
            -- заполнение
            INSERT INTO _tmpJuridical (JuridicalId/*, RetailId, JuridicalGroupId, OKPO*/)
               SELECT Object.Id
                    -- , COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0)
                    -- , COALESCE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId, 0)
                    -- , COALESCE (ObjectHistory_JuridicalDetails_View.OKPO, '')
               FROM Object
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                         ON ObjectLink_Juridical_Retail.ObjectId = Object.Id
                                        AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                         ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object.Id
                                        AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
                    LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object.Id*/
               WHERE Object.Id = inJuridicalId
                 AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR COALESCE (inRetailId, 0) = 0)
           ;
        ELSE
            IF inRetailId <> 0
            THEN
                -- устанавливается признак
                vbIsJuridical:= TRUE;
                -- заполнение
                INSERT INTO _tmpJuridical (JuridicalId/*, RetailId, JuridicalGroupId, OKPO*/)
                   SELECT ObjectLink_Juridical_Retail.ObjectId
                        /*, COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0)
                        , COALESCE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId, 0)
                        , COALESCE (ObjectHistory_JuridicalDetails_View.OKPO, '')*/
                   FROM ObjectLink AS ObjectLink_Juridical_Retail
                        /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
                        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = ObjectLink_Juridical_Retail.ObjectId*/
                   WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                     AND ObjectLink_Juridical_Retail.ChildObjectId = inRetailId
                  ;
            END IF;
        END IF;
    END IF;

/*
    CREATE TEMP TABLE tmpAnalyzer (AnalyzerId Integer, isSale Boolean, isCost Boolean, isSumm Boolean, MLO_DescId Integer) ON COMMIT DROP;
    INSERT INTO tmpAnalyzer (AnalyzerId, isSale, isCost, isSumm, MLO_DescId)
         SELECT AnalyzerId, isSale, isCost, isSumm
              , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
         FROM Constant_ProfitLoss_AnalyzerId_View
         WHERE isCost = FALSE OR (isCost = TRUE AND vbIsCost = TRUE);
    ANALYZE tmpAnalyzer;*/

    ANALYZE _tmpGoods;
    ANALYZE _tmpPartner;
    ANALYZE _tmpJuridical;
    ANALYZE _tmpJuridicalBranch;


    -- Результат
    RETURN QUERY

    -- собираем все данные
    WITH tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                              , CASE WHEN isSale = TRUE THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END AS MLO_DescId
                         FROM Constant_ProfitLoss_AnalyzerId_View
                         WHERE isCost = FALSE OR (isCost = TRUE AND vbIsCost = TRUE)
                        ) 
       , tmpPartnerAddress AS (SELECT * FROM Object_Partner_Address_View)
       -- , tmpPersonal AS (SELECT * FROM Object_Personal_View)

, tmpOperationGroup2 AS (SELECT MIContainer.ContainerId_Analyzer
                              , MIContainer.ObjectId_Analyzer                 AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                              , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MIContainer.ObjectId_Analyzer ELSE MovementLinkObject_Partner.ObjectId END AS PartnerId
                              , COALESCE (MILinkObject_Branch.ObjectId, 0)   AS BranchId
                              , COALESCE (ContainerLO_Juridical.ObjectId, 0) AS JuridicalId
                              , COALESCE (ContainerLO_InfoMoney.ObjectId, 0) AS InfoMoneyId
                              , 0 AS ChildAccountId -- MIContainer.AccountId

                              , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                              , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200() THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ_10200
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10250() THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ_10250
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ_10300
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN 1 * MIContainer.Amount ELSE 0 END) AS Return_Summ_10300
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() THEN 1 * MIContainer.Amount ELSE 0 END) AS Return_Summ_10700

                              , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_Amount
                              , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_Amount

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_AmountPartner
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_AmountPartner

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500()     THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_Amount_10500
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Amount_40200
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_Amount_40200

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_SummCost
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_SummCost_10500
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() THEN      COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_SummCost_40200

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Return_SummCost
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Return_SummCost_40200
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


                         WHERE (_tmpJuridical.JuridicalId > 0 OR vbIsJuridical = FALSE)
                           AND (MILinkObject_Branch.ObjectId = inBranchId OR COALESCE (inBranchId, 0) = 0 OR _tmpJuridicalBranch.JuridicalId IS NOT NULL)
                         GROUP BY MIContainer.ContainerId_Analyzer
                                , MIContainer.ObjectId_Analyzer                 
                                , MILinkObject_GoodsKind.ObjectId
                                , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MIContainer.ObjectId_Analyzer ELSE MovementLinkObject_Partner.ObjectId END
                                , MILinkObject_Branch.ObjectId
                                , ContainerLO_Juridical.ObjectId
                                , ContainerLO_InfoMoney.ObjectId
                                -- , MIContainer.AccountId
                        )

 , tmpOperationGroup AS (SELECT CASE WHEN inIsPartner = TRUE THEN tmpOperationGroup2.JuridicalId ELSE 0 END AS JuridicalId
                              , CASE WHEN inIsPartner = TRUE THEN ContainerLinkObject_Contract.ObjectId ELSE 0 END AS ContractId
                              , CASE WHEN inIsPartner = FALSE THEN 0 ELSE tmpOperationGroup2.PartnerId END AS PartnerId

                              , tmpOperationGroup2.InfoMoneyId
                              , tmpOperationGroup2.BranchId
                              , tmpOperationGroup2.ChildAccountId

                              , _tmpGoods.TradeMarkId
                              , CASE WHEN inIsGoods = TRUE THEN tmpOperationGroup2.GoodsId ELSE 0 END     AS GoodsId
                              , CASE WHEN inIsGoodsKind = TRUE THEN tmpOperationGroup2.GoodsKindId ELSE 0 END AS GoodsKindId

                              , SUM (tmpOperationGroup2.Sale_Summ) AS Sale_Summ
                              , SUM (tmpOperationGroup2.Return_Summ) AS Return_Summ

                              , SUM (tmpOperationGroup2.Sale_Summ_10200) AS Sale_Summ_10200
                              , SUM (tmpOperationGroup2.Sale_Summ_10250) AS Sale_Summ_10250
                              , SUM (tmpOperationGroup2.Sale_Summ_10300) AS Sale_Summ_10300
                              , SUM (tmpOperationGroup2.Return_Summ_10300) AS Return_Summ_10300
                              , SUM (tmpOperationGroup2.Return_Summ_10700) AS Return_Summ_10700

                              , SUM (tmpOperationGroup2.Sale_Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Sale_Amount_Weight
                              , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperationGroup2.Sale_Amount ELSE 0 END) AS Sale_Amount_Sh
                              , SUM (tmpOperationGroup2.Return_Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Return_Amount_Weight
                              , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperationGroup2.Return_Amount ELSE 0 END) AS Return_Amount_Sh

                              , SUM (tmpOperationGroup2.Sale_AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Sale_AmountPartner_Weight
                              , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperationGroup2.Sale_AmountPartner ELSE 0 END) AS Sale_AmountPartner_Sh
                              , SUM (tmpOperationGroup2.Return_AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Return_AmountPartner_Weight
                              , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperationGroup2.Return_AmountPartner ELSE 0 END) AS Return_AmountPartner_Sh

                              , SUM (tmpOperationGroup2.Sale_Amount_10500 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Sale_Amount_10500_Weight
                              , SUM (tmpOperationGroup2.Sale_Amount_40200 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Sale_Amount_40200_Weight
                              , SUM (tmpOperationGroup2.Return_Amount_40200 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Return_Amount_40200_Weight

                              , SUM (tmpOperationGroup2.Sale_SummCost) AS Sale_SummCost
                              , SUM (tmpOperationGroup2.Sale_SummCost_10500) AS Sale_SummCost_10500
                              , SUM (tmpOperationGroup2.Sale_SummCost_40200) AS Sale_SummCost_40200

                              , SUM (tmpOperationGroup2.Return_SummCost) AS Return_SummCost
                              , SUM (tmpOperationGroup2.Return_SummCost_40200) AS Return_SummCost_40200
                         FROM tmpOperationGroup2
                              LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Contract
                                                            ON ContainerLinkObject_Contract.ContainerId = tmpOperationGroup2.ContainerId_Analyzer
                                                           AND ContainerLinkObject_Contract.DescId = zc_ContainerLinkObject_Contract()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = tmpOperationGroup2.GoodsId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                    ON ObjectFloat_Weight.ObjectId = tmpOperationGroup2.GoodsId
                                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                              LEFT JOIN _tmpPartner ON _tmpPartner.PartnerId = tmpOperationGroup2.PartnerId
                              LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpOperationGroup2.GoodsId


                         WHERE (_tmpPartner.PartnerId > 0 OR vbIsPartner = FALSE)
                           AND (_tmpGoods.GoodsId > 0 OR vbIsGoods = FALSE)
                         GROUP BY CASE WHEN inIsPartner = TRUE THEN tmpOperationGroup2.JuridicalId ELSE 0 END
                                , CASE WHEN inIsPartner = TRUE THEN ContainerLinkObject_Contract.ObjectId ELSE 0 END
                                , CASE WHEN inIsPartner = FALSE THEN 0 ELSE tmpOperationGroup2.PartnerId END
                                , tmpOperationGroup2.InfoMoneyId
                                , tmpOperationGroup2.BranchId
                                , tmpOperationGroup2.ChildAccountId
                                , _tmpGoods.TradeMarkId
                                , CASE WHEN inIsGoods = TRUE THEN tmpOperationGroup2.GoodsId ELSE 0 END    
                                , CASE WHEN inIsGoodsKind = TRUE THEN tmpOperationGroup2.GoodsKindId ELSE 0 END
                        )

     SELECT Object_GoodsGroup.ValueData        AS GoodsGroupName
          , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
          , Object_Goods.Id                    AS GoodsId
          , Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName
          , Object_GoodsKind.Id                AS GoodsKindId
          , Object_GoodsKind.ValueData         AS GoodsKindName
          , Object_Measure.ValueData           AS MeasureName
          , Object_TradeMark.Id                AS TradeMarkId
          , Object_TradeMark.ValueData         AS TradeMarkName
          , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
          , Object_GoodsTag.ValueData          AS GoodsTagName
          , Object_GoodsGroupStat.ValueData    AS GoodsGroupStatName
          , Object_GoodsPlatform.ValueData     AS GoodsPlatformName

          , Object_JuridicalGroup.ValueData  AS JuridicalGroupName
          , Object_Branch.Id            AS BranchId
          , Object_Branch.ObjectCode    AS BranchCode
          , Object_Branch.ValueData     AS BranchName
          , 0 :: Integer AS BusinessId, 0 :: Integer AS BusinessCode, '' :: TVarChar AS BusinessName 
          , Object_Juridical.Id         AS JuridicalId
          , Object_Juridical.ObjectCode AS JuridicalCode
          , Object_Juridical.ValueData  AS JuridicalName

          , Object_Retail.ValueData       AS RetailName
          , Object_RetailReport.ValueData AS RetailReportName

          , View_Partner_Address.AreaName
          , View_Partner_Address.PartnerTagName
          , ObjectFloat_Category.ValueData ::TFloat AS PartnerCategory
          , ObjectString_Address.ValueData    AS Address
          , View_Partner_Address.RegionName
          , View_Partner_Address.ProvinceName
          , View_Partner_Address.CityKindName
          , View_Partner_Address.CityName

          , View_Partner_Address.PartnerId
          , View_Partner_Address.PartnerCode
          , View_Partner_Address.PartnerName

          , View_Contract_InvNumber.ContractId
          , View_Contract_InvNumber.ContractCode
          , View_Contract_InvNumber.InvNumber AS ContractNumber
          , View_Contract_InvNumber.ContractTagName
          , View_Contract_InvNumber.ContractTagGroupName

          , View_Personal.PersonalName       AS PersonalName
          , View_Personal.UnitName           AS UnitName_Personal
          , Object_BranchPersonal.ValueData  AS BranchName_Personal

          , View_PersonalTrade.PersonalName  AS PersonalTradeName
          , View_PersonalTrade.UnitName      AS UnitName_PersonalTrade

          , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyId                     AS InfoMoneyId
          , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
          , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all               AS InfoMoneyName_all

         , 0                                    :: TFloat  AS Promo_Summ
         , tmpOperationGroup.Sale_Summ          :: TFloat  AS Sale_Summ
         , tmpOperationGroup.Sale_Summ          :: TFloat  AS Sale_SummReal
         , tmpOperationGroup.Sale_Summ_10200    :: TFloat  AS Sale_Summ_10200
         , tmpOperationGroup.Sale_Summ_10250    :: TFloat  AS Sale_Summ_10250
         , tmpOperationGroup.Sale_Summ_10300    :: TFloat  AS Sale_Summ_10300

         , 0                                    :: TFloat  AS Promo_SummCost
         , tmpOperationGroup.Sale_SummCost      :: TFloat  AS Sale_SummCost
         , tmpOperationGroup.Sale_SummCost_10500:: TFloat  AS Sale_SummCost_10500
         , tmpOperationGroup.Sale_SummCost_40200:: TFloat  AS Sale_SummCost_40200

         , tmpOperationGroup.Sale_Amount_Weight :: TFloat  AS Sale_Amount_Weight
         , tmpOperationGroup.Sale_Amount_Sh     :: TFloat  AS Sale_Amount_Sh

         , 0                                           :: TFloat AS Promo_AmountPartner_Weight
         , 0                                           :: TFloat AS Promo_AmountPartner_Sh
         , tmpOperationGroup.Sale_AmountPartner_Weight :: TFloat AS Sale_AmountPartner_Weight
         , tmpOperationGroup.Sale_AmountPartner_Sh     :: TFloat AS Sale_AmountPartner_Sh
         , tmpOperationGroup.Sale_AmountPartner_Weight :: TFloat AS Sale_AmountPartnerR_Weight
         , tmpOperationGroup.Sale_AmountPartner_Sh     :: TFloat AS Sale_AmountPartnerR_Sh

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

     FROM tmpOperationGroup
          LEFT JOIN _tmp_noDELETE_Partner ON _tmp_noDELETE_Partner.FromId = tmpOperationGroup.PartnerId AND 1 = 0

          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpOperationGroup.BranchId
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                               ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, tmpOperationGroup.TradeMarkId)

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                               ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
          LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                               ON ObjectLink_Goods_GoodsGroupStat.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
          LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_Goods_GoodsGroupStat.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                               ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
          LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN tmpPartnerAddress AS View_Partner_Address ON View_Partner_Address.PartnerId = COALESCE (_tmp_noDELETE_Partner.ToId, tmpOperationGroup.PartnerId)
          LEFT JOIN ObjectString AS ObjectString_Address
                                 ON ObjectString_Address.ObjectId = COALESCE (_tmp_noDELETE_Partner.ToId, tmpOperationGroup.PartnerId)
                                AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = COALESCE (_tmp_noDELETE_Partner.ToId, tmpOperationGroup.PartnerId)

          LEFT JOIN ObjectFloat AS ObjectFloat_Category
                                ON ObjectFloat_Category.ObjectId = Object_Partner.Id
                               AND ObjectFloat_Category.DescId = zc_ObjectFloat_Partner_Category()

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
                               ON ObjectLink_Partner_Personal.ObjectId = COALESCE (_tmp_noDELETE_Partner.ToId, tmpOperationGroup.PartnerId)
                              AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
          LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = ObjectLink_Partner_Personal.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = View_Personal.UnitId
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          LEFT JOIN Object AS Object_BranchPersonal ON Object_BranchPersonal.Id = ObjectLink_Unit_Branch.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                               ON ObjectLink_Partner_PersonalTrade.ObjectId = COALESCE (_tmp_noDELETE_Partner.ToId, tmpOperationGroup.PartnerId)
                              AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
          LEFT JOIN Object_Personal_View AS View_PersonalTrade ON View_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId

          LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpOperationGroup.ChildAccountId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.04.21         * add PartnerCategory
 27.08.15                                        *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_SaleReturnIn_OLD_TWO (inStartDate:= '01.01.2019', inEndDate:= '01.01.2019', inBranchId:= 0, inAreaId:= 0, inRetailId:= 0, inJuridicalId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inTradeMarkId:= 0, inGoodsGroupId:= 0, inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inIsPartner:= TRUE, inIsTradeMark:= TRUE, inIsGoods:= TRUE, inIsGoodsKind:= TRUE, inSession:= zfCalc_UserAdmin());
