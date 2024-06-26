-- Function: gpReport_GoodsMI_SaleReturnIn_BUH ()

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

             , VATPercent TFloat

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
             , MovementId_test Integer
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

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- определяется уровень доступа
    vbObjectId_Constraint_Branch:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0);
    -- !!!меняется параметр!!!
    IF vbObjectId_Constraint_Branch > 0 THEN inBranchId:= vbObjectId_Constraint_Branch; END IF;

    -- определяется уровень доступа для с/с
    vbIsCost:= FALSE;

    vbIsGoods:= FALSE;
    vbIsPartner:= FALSE;
    vbIsJuridical:= FALSE;


    -- Ограничения по товару
    IF inGoodsGroupId <> 0
    THEN
        -- устанавливается признак
        vbIsGoods_where:= TRUE;

    ELSE IF inTradeMarkId <> 0
         THEN
             -- устанавливается признак
             vbIsGoods_where:= TRUE;

         ELSE
             -- устанавливается признак
             vbIsGoods_where:= FALSE;

         END IF;
    END IF;

    --
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
                    WHERE isCost = FALSE
                      AND Constant_ProfitLoss_AnalyzerId_View.AnalyzerId IN (zc_Enum_AnalyzerId_SaleCount_10400(), zc_Enum_AnalyzerId_ReturnInCount_10800())
                   )
  , tmpOperationGroup2 AS (SELECT MIContainer.ContainerId_Analyzer
                                , MIContainer.ObjectId_Analyzer                  AS GoodsId
                                , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MIContainer.ObjectId_Analyzer ELSE MovementLinkObject_Partner.ObjectId END AS PartnerId
                                , COALESCE (MILinkObject_Branch.ObjectId, 0)     AS BranchId
                                , COALESCE (ContainerLO_Juridical.ObjectId, 0)   AS JuridicalId
                                , COALESCE (ContainerLO_InfoMoney.ObjectId, 0)   AS InfoMoneyId
                                , CASE WHEN vbUserId = 5 THEN COALESCE (MovementFloat_VATPercent.ValueData, 0) ELSE 0 END AS VATPercent

                                -- , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Summ
                                -- , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Return_Summ

                                , 0 AS Sale_SummMVAT

                                , SUM (CAST (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()
                                                  THEN  -1 * MIContainer.Amount
                                                           * CASE WHEN COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0 THEN 0
                                                                  WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE
                                                                      THEN zfCalc_PriceTruncate (inOperDate     := MovementDate_OperDatePartner.ValueData
                                                                                               , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                                               , inPrice        := MIFloat_Price.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                                                                               , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                                                                )
                                                                         * MovementFloat_VATPercent.ValueData / 100
                                                                 ELSE zfCalc_PriceTruncate (inOperDate     := MovementDate_OperDatePartner.ValueData
                                                                                          , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                                          , inPrice        := MIFloat_Price.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                                                                          , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                                                           )
                                                                    / (1 + 100 / MovementFloat_VATPercent.ValueData)
                                                             END
                                                  ELSE 0
                                             END AS NUMERIC (16, 2))) AS Sale_SummVAT
                                , SUM (CAST (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800()
                                                  THEN MIContainer.Amount
                                                     * CASE WHEN COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0 THEN 0
                                                            WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE
                                                                 THEN zfCalc_PriceTruncate (inOperDate     := MovementDate_OperDatePartner.ValueData
                                                                                          , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                                          , inPrice        := MIFloat_Price.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                                                                          , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                                                           )
                                                                    * MovementFloat_VATPercent.ValueData / 100
                                                            ELSE zfCalc_PriceTruncate (inOperDate     := MovementDate_OperDatePartner.ValueData
                                                                                     , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                                     , inPrice        := MIFloat_Price.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                                                                     , inIsWithVAT    := MovementBoolean_PriceWithVAT.ValueData
                                                                                      )
                                                               / (1 + 100 / MovementFloat_VATPercent.ValueData)
                                                       END
                                                  ELSE 0
                                             END AS NUMERIC (16, 2))) AS Return_SummVAT
                                , MAX (MIContainer.MovementId) AS MovementId_test
                                , 0 AS MovementDescId
                           FROM tmpAnalyzer
                                INNER JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                                AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
/*and MIContainer.ObjectId_Analyzer IN (2404,
2163,
8015,
431552,
3056,
2795,
8255,
3456960,
3456962,
3456965,
3713924)*/
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

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                                 ON MILinkObject_Branch.MovementItemId = MIContainer.MovementItemId
                                                                AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

                                LEFT JOIN _tmpJuridical ON _tmpJuridical.JuridicalId = ContainerLO_Juridical.ObjectId
                                LEFT JOIN _tmpJuridicalBranch ON _tmpJuridicalBranch.JuridicalId = ContainerLO_Juridical.ObjectId

                                LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                            ON MIFloat_ChangePercent.MovementItemId = MIContainer.MovementItemId
                                                           AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MIContainer.MovementItemId
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                            ON MIFloat_CountForPrice.MovementItemId = MIContainer.MovementItemId
                                                           AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()

                                LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                       ON MovementDate_OperDatePartner.MovementId =  MIContainer.MovementId
                                                      AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                          ON MovementBoolean_PriceWithVAT.MovementId = MIContainer.MovementId
                                                         AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                        ON MovementFloat_VATPercent.MovementId = MIContainer.MovementId
                                                       AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

                           WHERE (_tmpJuridical.JuridicalId > 0 OR vbIsJuridical = FALSE)
                             AND (MILinkObject_Branch.ObjectId = inBranchId OR COALESCE (inBranchId, 0) = 0 OR _tmpJuridicalBranch.JuridicalId IS NOT NULL)
                           --AND (vbUserId <> 5 OR MIContainer.MovementId = 21845765)
                            -- AND (vbUserId <> 5 OR MIContainer.MovementId = 28222484)
                            --AND (vbUserId <> 5)
                             
                           GROUP BY MIContainer.ContainerId_Analyzer
                                  , MIContainer.ObjectId_Analyzer
                                  , MIContainer.ObjectIntId_Analyzer
                                  , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MIContainer.ObjectId_Analyzer ELSE MovementLinkObject_Partner.ObjectId END
                                  , MILinkObject_Branch.ObjectId
                                  , ContainerLO_Juridical.ObjectId
                                  , ContainerLO_InfoMoney.ObjectId
                                  , CASE WHEN vbUserId = 5 THEN COALESCE (MovementFloat_VATPercent.ValueData, 0) ELSE 0 END

                          UNION ALL
                           SELECT -1 * MovementLinkObject_Contract.ObjectId        AS ContainerId_Analyzer
                                , MovementItem.ObjectId                            AS GoodsId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)    AS GoodsKindId
                                , MovementLinkObject_Partner.ObjectId              AS PartnerId
                             -- , zc_Branch_Basis()                                AS BranchId
                                , 0                                                AS BranchId
                                , MovementLinkObject_From.ObjectId                 AS JuridicalId
                                , COALESCE (ObjectLink_InfoMoney.ChildObjectId, 0) AS InfoMoneyId
                                , CASE WHEN vbUserId = 5 THEN COALESCE (MovementFloat_VATPercent.ValueData, 0) ELSE 0 END AS VATPercent

                             -- , 0 AS Sale_Summ
                             -- , 0 AS Return_Summ

                                , 0 AS Sale_SummMVAT
                                  -- Sale_SummVAT
                                , CAST (-1 * MovementItem.Amount
                                           * CASE WHEN COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0 THEN 0
                                                  WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE
                                                       THEN MIFloat_Price.ValueData * MovementFloat_VATPercent.ValueData / 100
                                                          / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                                  ELSE MIFloat_Price.ValueData / (1 + 100 / MovementFloat_VATPercent.ValueData)
                                                     / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                             END AS NUMERIC (16, 2)) AS Sale_SummVAT

                                , 0 AS Return_SummVAT
                                , Movement.Id AS MovementId_test
                                , 0 AS MovementDescId
                           FROM Movement
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
/*and MovementItem.ObjectId in (2404,
2163,
8015,
431552,
3056,
2795,
8255,
3456960,
3456962,
3456965,
3713924)*/
                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                                -- LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                --                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                --                            AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                                LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                          ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                                         AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                        ON MovementFloat_VATPercent.MovementId = Movement.Id
                                                       AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                            AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                             ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                            AND MovementLinkObject_Partner.DescId     = zc_MovementLinkObject_Partner()
                                LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                                     ON ObjectLink_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                                    AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.DescId   = zc_Movement_PriceCorrective()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND (MovementLinkObject_From.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                             AND (ObjectLink_InfoMoney.ChildObjectId    = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                             AND (COALESCE (inPaidKindId, 0) <> zc_Enum_PaidKind_SecondForm())
                             --AND (vbUserId <> 5 OR Movement.Id = 28222484)


                          UNION ALL
                           SELECT -1 * MovementLinkObject_Contract.ObjectId        AS ContainerId_Analyzer
                                , MovementItem.ObjectId                            AS GoodsId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)    AS GoodsKindId
                                , MovementLinkObject_To.ObjectId                   AS PartnerId
                                , zc_Branch_Basis()                                AS BranchId
                              --, 0                                                AS BranchId
                                , MovementLinkObject_To.ObjectId                   AS JuridicalId
                                , COALESCE (ObjectLink_InfoMoney.ChildObjectId, 0) AS InfoMoneyId
                                , CASE WHEN vbUserId = 5 THEN COALESCE (MovementFloat_VATPercent.ValueData, 0) ELSE 0 END AS VATPercent

                                  -- сумма без НДС для скидки
                                , CAST (-1 * MovementItem.Amount
                                      * CAST (MIFloat_Price.ValueData * COALESCE (MovementFloat_ChangePercent.ValueData, 0) / 100
                                        AS NUMERIC (16, 2))
                                  AS NUMERIC (16, 2)) AS Sale_SummMVAT

                                  -- сумма НДС для скидки
                                , CAST (CAST (-1 * MovementItem.Amount
                                            * CAST (MIFloat_Price.ValueData * COALESCE (MovementFloat_ChangePercent.ValueData, 0) / 100
                                              AS NUMERIC (16, 2))
                                        AS NUMERIC (16, 2))
                                      * COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100
                                  AS NUMERIC (16, 2)) AS Sale_SummVAT

                                , 0 AS Return_SummVAT
                                , Movement.Id AS MovementId_test
                                , Movement.DescId AS MovementDescId


                           FROM Movement
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE  
                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                                LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                          ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                                         AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                        ON MovementFloat_VATPercent.MovementId = Movement.Id
                                                       AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                                LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                        ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                       AND MovementFloat_ChangePercent.DescId     = zc_MovementFloat_ChangePercent()

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                            AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                                            AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                                     ON ObjectLink_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                                    AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.DescId   = zc_Movement_ChangePercent()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND (MovementLinkObject_To.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                             AND (ObjectLink_InfoMoney.ChildObjectId    = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                             AND (COALESCE (inPaidKindId, 0) <> zc_Enum_PaidKind_SecondForm())
--                           AND vbUserId <> 5
                          )

  , tmpOperationGroup AS (SELECT CASE WHEN inIsPartner = TRUE THEN tmpOperationGroup2.JuridicalId ELSE 0 END AS JuridicalId
                               , CASE WHEN inIsContract = TRUE
                                           THEN CASE WHEN tmpOperationGroup2.ContainerId_Analyzer < 0 THEN -1 * tmpOperationGroup2.ContainerId_Analyzer ELSE ContainerLinkObject_Contract.ObjectId END
                                      ELSE 0
                                 END AS ContractId
                               , CASE WHEN inIsPartner = FALSE THEN 0 ELSE tmpOperationGroup2.PartnerId END AS PartnerId
                               , tmpOperationGroup2.InfoMoneyId
                               , tmpOperationGroup2.VATPercent
                               , tmpOperationGroup2.BranchId
                               , _tmpGoods.TradeMarkId
                               , CASE WHEN inIsGoods = TRUE     THEN tmpOperationGroup2.GoodsId ELSE 0 END     AS GoodsId
                               , CASE WHEN inIsGoodsKind = TRUE OR inIsGoods = TRUE THEN tmpOperationGroup2.GoodsKindId ELSE 0 END AS GoodsKindId            -- когда нет галки "по видам", но есть "по товарам" - вывести виды через STRING_AGG

--                             , SUM (tmpOperationGroup2.Sale_Summ - tmpOperationGroup2.Sale_SummVAT)     AS Sale_SummMVAT

                                 -- сумма без НДС для скидки - !!!ТОЛЬКО!!!
                               , SUM (tmpOperationGroup2.Sale_SummMVAT)                                   AS Sale_SummMVAT
                                 -- сумма НДС
                               , SUM (tmpOperationGroup2.Sale_SummVAT)                                    AS Sale_SummVAT
                                 -- сумма НДС
                               , SUM (tmpOperationGroup2.Return_SummVAT)                                  AS Return_SummVAT
                                 --
                               , MAX (tmpOperationGroup2.MovementId_test) AS MovementId_test
                               , tmpOperationGroup2.MovementDescId
                          FROM tmpOperationGroup2
                               LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Contract
                                                             ON ContainerLinkObject_Contract.ContainerId = tmpOperationGroup2.ContainerId_Analyzer
                                                            AND ContainerLinkObject_Contract.DescId      = zc_ContainerLinkObject_Contract()

                               LEFT JOIN _tmpPartner ON _tmpPartner.PartnerId = tmpOperationGroup2.PartnerId
                               LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpOperationGroup2.GoodsId
                          WHERE (_tmpPartner.PartnerId > 0 OR vbIsPartner = FALSE)
                            AND (_tmpGoods.GoodsId > 0 OR vbIsGoods = FALSE)
                          GROUP BY CASE WHEN inIsPartner = TRUE THEN tmpOperationGroup2.JuridicalId ELSE 0 END
                                 , CASE WHEN inIsContract = TRUE
                                           THEN CASE WHEN tmpOperationGroup2.ContainerId_Analyzer < 0 THEN -1 * tmpOperationGroup2.ContainerId_Analyzer ELSE ContainerLinkObject_Contract.ObjectId END
                                        ELSE 0
                                   END
                                 , CASE WHEN inIsPartner = FALSE THEN 0 ELSE tmpOperationGroup2.PartnerId END
                                 , tmpOperationGroup2.InfoMoneyId
                                 , tmpOperationGroup2.VATPercent
                                 , tmpOperationGroup2.BranchId
                                 , _tmpGoods.TradeMarkId
                                 , CASE WHEN inIsGoods = TRUE THEN tmpOperationGroup2.GoodsId ELSE 0 END
                                 , CASE WHEN inIsGoodsKind = TRUE OR inIsGoods = TRUE THEN tmpOperationGroup2.GoodsKindId ELSE 0 END
                                 , tmpOperationGroup2.MovementDescId
                          HAVING SUM (tmpOperationGroup2.Sale_SummVAT)   <> 0
                              OR SUM (tmpOperationGroup2.Return_SummVAT) <> 0
                          )
  ,_tmpMI AS (SELECT tmpOperationGroup.JuridicalId
                   , Object_Juridical.ObjectCode        AS JuridicalCode
                   , Object_Juridical.ValueData         AS JuridicalName
                   , tmpOperationGroup.ContractId
                   , Object_Contract.ObjectCode         AS ContractCode
                   , Object_Contract.ValueData          AS ContractNumber
                   , tmpOperationGroup.PartnerId
                   , tmpOperationGroup.InfoMoneyId
                   , Object_InfoMoney.ObjectCode        AS InfoMoneyCode
                   , Object_InfoMoney.ValueData         AS InfoMoneyName
                   , tmpOperationGroup.VATPercent
                   , tmpOperationGroup.BranchId
         
                   , Object_Branch.ObjectCode           AS BranchCode
                   , Object_Branch.ValueData            AS BranchName
                   , Object_TradeMark.Id                AS TradeMarkId
                   , Object_TradeMark.ValueData         AS TradeMarkName
  
                   , tmpOperationGroup.GoodsId
                   , Object_Goods.ObjectCode            AS GoodsCode
                   , Object_Goods.ValueData             AS GoodsName
                   , tmpOperationGroup.GoodsKindId
                   , Object_GoodsKind.ValueData         AS GoodsKindName
                     -- сумма без НДС для скидки - !!!ТОЛЬКО!!!
                   , tmpOperationGroup.Sale_SummMVAT
                     -- сумма НДС
                   , tmpOperationGroup.Sale_SummVAT       :: TFloat
                     -- сумма НДС
                   , tmpOperationGroup.Return_SummVAT     :: TFloat
                     -- 
                   , tmpOperationGroup.MovementId_test
                     -- 
                   , tmpOperationGroup.MovementDescId
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
              
   --
    , tmpReport AS (SELECT  tmp.goodsid
                          , tmp.GoodsCode
                          , tmp.GoodsName  
                          , tmp.GoodsKindId
                          , tmp.GoodsKindName
                          , tmp.TradeMarkId
                          , tmp.TradeMarkName
                          , tmp.BranchId
                          , tmp.BranchCode
                          , tmp.BranchName
                          , tmp.JuridicalId
                          , tmp.JuridicalCode
                          , tmp.JuridicalName
                         -- , tmp.RetailName
                         -- , tmp.RetailReportName
                         -- , tmp.AreaName, tmp.PartnerTagName
                         -- , tmp.Address, tmp.RegionName, tmp.ProvinceName, tmp.CityKindName, tmp.CityName
                          , tmp.PartnerId
                          , tmp.PartnerCode
                          , tmp.PartnerName
                          , tmp.ContractId
                          , tmp.ContractCode 
                          , tmp.ContractNumber
                          , tmp.ContractTagName
                          , tmp.ContractTagGroupName
                          , tmp.InfoMoneyId
                            -- !!!
                          , 0 AS VATPercent

                         -- , tmp.PersonalName, tmp.UnitName_Personal, tmp.BranchName_Personal
                         -- , tmp.PersonalTradeName, tmp.UnitName_PersonalTrade
                          
                          , SUM (tmp.Promo_Summ                    ) AS       Promo_Summ                
                          , SUM (tmp.Sale_Summ                     ) AS       Sale_Summ                 
                          , SUM (tmp.Sale_SummReal                 ) AS       Sale_SummReal             
                          , SUM (tmp.Sale_Summ_10200               ) AS       Sale_Summ_10200           
                          , SUM (tmp.Sale_Summ_10250               ) AS       Sale_Summ_10250           
                          , SUM (tmp.Sale_Summ_10300               ) AS       Sale_Summ_10300           
                          , SUM (tmp.Promo_SummCost                ) AS       Promo_SummCost            
                          , SUM (tmp.Sale_SummCost                 ) AS       Sale_SummCost             
                          , SUM (tmp.Sale_SummCost_10500           ) AS       Sale_SummCost_10500       
                          , SUM (tmp.Sale_SummCost_40200           ) AS       Sale_SummCost_40200       
                          , SUM (tmp.Sale_Amount_Weight            ) AS       Sale_Amount_Weight        
                          , SUM (tmp.Sale_Amount_Sh                ) AS       Sale_Amount_Sh            
                          , SUM (tmp.Promo_AmountPartner_Weight    ) AS       Promo_AmountPartner_Weight
                          , SUM (tmp.Promo_AmountPartner_Sh        ) AS       Promo_AmountPartner_Sh    
                          , SUM (tmp.Sale_AmountPartner_Weight     ) AS       Sale_AmountPartner_Weight 
                          , SUM (tmp.Sale_AmountPartner_Sh         ) AS       Sale_AmountPartner_Sh     
                          , SUM (tmp.Sale_AmountPartnerR_Weight    ) AS       Sale_AmountPartnerR_Weight
                          , SUM (tmp.Sale_AmountPartnerR_Sh        ) AS       Sale_AmountPartnerR_Sh    
                          , SUM (tmp.Return_Summ                   ) AS       Return_Summ               
                          , SUM (tmp.Return_Summ_10300             ) AS       Return_Summ_10300         
                          , SUM (tmp.Return_Summ_10700             ) AS       Return_Summ_10700         
                          , SUM (tmp.Return_SummCost               ) AS       Return_SummCost           
                          , SUM (tmp.Return_SummCost_40200         ) AS       Return_SummCost_40200     
                          , SUM (tmp.Return_Amount_Weight          ) AS       Return_Amount_Weight      
                          , SUM (tmp.Return_Amount_Sh              ) AS       Return_Amount_Sh          
                          , SUM (tmp.Return_AmountPartner_Weight   ) AS       Return_AmountPartner_Weight
                          , SUM (tmp.Return_AmountPartner_Sh       ) AS       Return_AmountPartner_Sh   
                          , SUM (tmp.Sale_Amount_10500_Weight      ) AS       Sale_Amount_10500_Weight  
                          , SUM (tmp.Sale_Amount_40200_Weight      ) AS       Sale_Amount_40200_Weight  
                          , SUM (tmp.Return_Amount_40200_Weight    ) AS       Return_Amount_40200_Weight
                          , SUM (tmp.ReturnPercent                 ) AS       ReturnPercent
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
                                                      , true  --inIsGoodsKind                 --   -- когда нет галки "по видам", но есть "по товарам" - вывести виды через STRING_AGG  -- всегда по видам товара, а потом свернуть.
                                                      , inIsContract
                                                      , inIsOLAP
                                                      , FALSE
                                                      , FALSE
                                                      , inSession
                                                       ) AS tmp
                    GROUP BY tmp.goodsid, tmp.GoodsCode
                          , tmp.GoodsName  
                          , tmp.GoodsKindId
                          , tmp.GoodsKindName
                          , tmp.TradeMarkName
                          , tmp.BranchId
                          , tmp.BranchCode
                          , tmp.BranchName
                          , tmp.JuridicalId
                          , tmp.JuridicalCode
                          , tmp.JuridicalName
                          , tmp.TradeMarkId              
                         -- , tmp.RetailName
                         -- , tmp.RetailReportName
                         -- , tmp.AreaName, tmp.PartnerTagName
                         -- , tmp.Address, tmp.RegionName, tmp.ProvinceName, tmp.CityKindName, tmp.CityName
                          , tmp.InfoMoneyId
                          , tmp.PartnerId
                          , tmp.PartnerCode
                          , tmp.PartnerName
                          , tmp.ContractId
                          , tmp.ContractCode 
                          , tmp.ContractNumber
                          , tmp.ContractTagName
                          , tmp.ContractTagGroupName
       ) 

      , tmpPartnerAddress AS (SELECT * 
                              FROM Object_Partner_Address_View
                              )
      , tmpVATPercent AS (SELECT _tmpMI.JuridicalId, /*_tmpMI.ContractId,*/ MAX (_tmpMI.VATPercent) AS VATPercent
                          FROM _tmpMI
                          WHERE _tmpMI.VATPercent > 0
                          GROUP BY _tmpMI.JuridicalId/*, _tmpMI.ContractId*/
                         )


       -- результат
       SELECT tmp.GoodsGroupName, tmp.GoodsGroupNameFull
            , tmp.GoodsCode
            , tmp.GoodsName
            --, tmp.GoodsKindName  
            , STRING_AGG (DISTINCT COALESCE (tmp.GoodsKindName,''), '; ') ::TVarChar AS GoodsKindName
            , tmp.MeasureName
            , tmp.TradeMarkName
            , tmp.GoodsGroupAnalystName, tmp.GoodsTagName
            , tmp.GoodsGroupStatName
            , tmp.GoodsPlatformName
            , tmp.JuridicalGroupName
            , tmp.BranchCode
            , tmp.BranchName
            , tmp.JuridicalCode
            , tmp.JuridicalName
            , tmp.RetailName, tmp.RetailReportName
            , tmp.AreaName, tmp.PartnerTagName
            , tmp.Address, tmp.RegionName, tmp.ProvinceName, tmp.CityKindName, tmp.CityName
            , tmp.PartnerId, tmp.PartnerCode, tmp.PartnerName
            , tmp.ContractCode
            , tmp.ContractNumber
            , tmp.ContractTagName, tmp.ContractTagGroupName
            , tmp.PersonalName, tmp.UnitName_Personal, tmp.BranchName_Personal
            , tmp.PersonalTradeName, tmp.UnitName_PersonalTrade
            , tmp.InfoMoneyGroupName, tmp.InfoMoneyDestinationName
            , tmp.InfoMoneyCode
            , tmp.InfoMoneyName
            , tmp.InfoMoneyName_all

            , tmp.VATPercent :: TFloat AS VATPercent

            , SUM (COALESCE (tmp.Promo_Summ, 0))   :: TFloat
              --
              -- сумма c НДС
            , SUM (COALESCE (tmp.Sale_Summ, 0))   :: TFloat
              --
              -- сумма c НДС
            , SUM (COALESCE (tmp.Sale_SummReal, 0))   :: TFloat
              --
            , SUM (COALESCE (tmp.Sale_Summ_10200, 0))   :: TFloat, SUM (COALESCE (tmp.Sale_Summ_10250, 0))   :: TFloat, SUM (COALESCE (tmp.Sale_Summ_10300, 0))   :: TFloat
            , SUM (COALESCE (tmp.Promo_SummCost, 0))   :: TFloat, SUM (COALESCE (tmp.Sale_SummCost, 0))   :: TFloat, SUM (COALESCE (tmp.Sale_SummCost_10500, 0))   :: TFloat, SUM (COALESCE (tmp.Sale_SummCost_40200, 0))   :: TFloat
            , SUM (COALESCE (tmp.Sale_Amount_Weight, 0))   :: TFloat, SUM (COALESCE (tmp.Sale_Amount_Sh, 0))   :: TFloat
            , SUM (COALESCE (tmp.Promo_AmountPartner_Weight, 0))   :: TFloat, SUM (COALESCE (tmp.Promo_AmountPartner_Sh, 0))   :: TFloat, SUM (COALESCE (tmp.Sale_AmountPartner_Weight, 0))   :: TFloat
            , SUM (COALESCE (tmp.Sale_AmountPartner_Sh, 0))   :: TFloat, SUM (COALESCE (tmp.Sale_AmountPartnerR_Weight, 0))   :: TFloat, SUM (COALESCE (tmp.Sale_AmountPartnerR_Sh, 0))   :: TFloat
            , SUM (COALESCE (tmp.Return_Summ, 0))   :: TFloat, SUM (COALESCE (tmp.Return_Summ_10300, 0))   :: TFloat, SUM (COALESCE (tmp.Return_Summ_10700, 0))   :: TFloat, SUM (COALESCE (tmp.Return_SummCost, 0))   :: TFloat, SUM (COALESCE (tmp.Return_SummCost_40200, 0))   :: TFloat
            , SUM (COALESCE (tmp.Return_Amount_Weight, 0))   :: TFloat, SUM (COALESCE (tmp.Return_Amount_Sh, 0))   :: TFloat, SUM (COALESCE (tmp.Return_AmountPartner_Weight, 0))   :: TFloat, SUM (COALESCE (tmp.Return_AmountPartner_Sh, 0))   :: TFloat
            , SUM (COALESCE (tmp.Sale_Amount_10500_Weight, 0))   :: TFloat
            , SUM (COALESCE (tmp.Sale_Amount_40200_Weight, 0))   :: TFloat
            , SUM (COALESCE (tmp.Return_Amount_40200_Weight, 0))   :: TFloat
            , MAX (tmp.ReturnPercent)  :: TFloat
              --
              -- сумма без НДС
            , SUM (COALESCE (tmp.Sale_SummMVAT, 0))   :: TFloat
              --
              -- сумма НДС
            , SUM (COALESCE (tmp.Sale_SummVAT, 0))   :: TFloat
              --
              -- сумма без НДС
            , SUM (COALESCE (tmp.Return_Summ, 0) - COALESCE (tmp.Return_SummVAT, 0)) :: TFloat AS Return_SummMVAT
              --
              -- сумма НДС
            , SUM (COALESCE (tmp.Return_SummVAT, 0)) :: TFloat
              --
            , MAX (tmp.MovementId_test) :: Integer AS MovementId_test
       FROM (
       SELECT Object_GoodsGroup.ValueData AS GoodsGroupName, ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
            , COALESCE (_tmpMI.MovementId_test, 0) AS MovementId_test
            /*, CASE WHEN COALESCE (tmp.Sale_Summ, 0) = 0 AND COALESCE (_tmpMI.Sale_SummVAT, 0) > 0
                   THEN _tmpMI.MovementId_test
                   ELSE COALESCE (_tmpMI.GoodsCode, tmp.GoodsCode)
              END:: Integer AS GoodsCode */   
            , COALESCE (_tmpMI.GoodsCode, tmp.GoodsCode)  :: Integer AS GoodsCode
            , COALESCE (_tmpMI.GoodsName, tmp.GoodsName)         :: TVarChar AS GoodsName
            , COALESCE (_tmpMI.GoodsKindId, tmp.GoodsKindId)                 AS GoodsKindId
            , COALESCE (_tmpMI.GoodsKindName, tmp.GoodsKindName) :: TVarChar AS GoodsKindName
           -- , tmp.GoodsKindName :: TVarChar AS GoodsKindName
            , Object_Measure.ValueData            AS MeasureName
            , COALESCE (_tmpMI.TradeMarkName, tmp.TradeMarkName) :: TVarChar AS TradeMarkName
            , Object_GoodsGroupAnalyst.ValueData  AS GoodsGroupAnalystName
            , Object_GoodsTag.ValueData           AS GoodsTagName
            , Object_GoodsGroupStat.ValueData     AS GoodsGroupStatName
            , Object_GoodsPlatform.ValueData      AS GoodsPlatformName
            , Object_JuridicalGroup.ValueData     AS JuridicalGroupName

            , COALESCE (_tmpMI.BranchCode, tmp.BranchCode)         :: Integer  AS BranchCode
            , COALESCE (_tmpMI.BranchName, tmp.BranchName)         :: TVarChar AS BranchName
            , COALESCE (_tmpMI.JuridicalCode, tmp.JuridicalCode)   :: Integer  AS JuridicalCode
            , COALESCE (_tmpMI.JuridicalName, tmp.JuridicalName)   :: TVarChar AS JuridicalName

           -- , COALESCE (tmp.RetailName, Object_Retail.ValueData)             :: TVarChar AS RetailName
           -- , COALESCE (tmp.RetailReportName, Object_RetailReport.ValueData) :: TVarChar AS RetailReportName  
           , Object_Retail.ValueData       :: TVarChar AS RetailName
           , Object_RetailReport.ValueData :: TVarChar AS RetailReportName

           /* , tmp.AreaName, tmp.PartnerTagName
            , tmp.Address, tmp.RegionName, tmp.ProvinceName, tmp.CityKindName, tmp.CityName
            */

            , View_Partner_Address.AreaName
            , View_Partner_Address.PartnerTagName
            , ObjectString_Address.ValueData AS Address
            , View_Partner_Address.RegionName
            , View_Partner_Address.ProvinceName
            , View_Partner_Address.CityKindName
            , View_Partner_Address.CityName

            , COALESCE (tmp.PartnerId,   Object_Partner.Id)         :: Integer AS PartnerId
            , COALESCE (tmp.PartnerCode, Object_Partner.ObjectCode) :: Integer AS PartnerCode
            , COALESCE (tmp.PartnerName, Object_Partner.ValueData) :: TVarChar AS PartnerName

            , COALESCE (_tmpMI.ContractCode, tmp.ContractCode)     :: Integer  AS ContractCode
            , COALESCE (_tmpMI.ContractNumber, tmp.ContractNumber) :: TVarChar AS ContractNumber
            , tmp.ContractTagName, tmp.ContractTagGroupName
            --, tmp.PersonalName, tmp.UnitName_Personal, tmp.BranchName_Personal
            --, tmp.PersonalTradeName, tmp.UnitName_PersonalTrade
            , View_Personal.PersonalName       AS PersonalName
            , View_Personal.UnitName           AS UnitName_Personal
            , Object_BranchPersonal.ValueData  AS BranchName_Personal
            , View_PersonalTrade.PersonalName  AS PersonalTradeName
            , View_PersonalTrade.UnitName      AS UnitName_PersonalTrade

            , View_InfoMoney.InfoMoneyGroupName, View_InfoMoney.InfoMoneyDestinationName
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
            , View_InfoMoney.InfoMoneyName_all

            , COALESCE (tmpVATPercent.VATPercent, 0) AS VATPercent

            , tmp.Promo_Summ
              --
              -- сумма c НДС
            , CASE WHEN _tmpMI.MovementDescId = zc_Movement_ChangePercent()
                        --  так для док.скидки
                        THEN 0 -- COALESCE (_tmpMI.Sale_SummMVAT, 0) + COALESCE (_tmpMI.Sale_SummVAT, 0)
                   ELSE tmp.Sale_Summ
              END :: TFloat AS Sale_Summ
              --
              -- сумма c НДС
            , CASE WHEN _tmpMI.MovementDescId = zc_Movement_ChangePercent()
                        --  так для док.скидки
                        THEN 0 -- COALESCE (_tmpMI.Sale_SummMVAT, 0) + COALESCE (_tmpMI.Sale_SummVAT, 0)
                   ELSE tmp.Sale_SummReal
              END :: TFloat AS Sale_SummReal
              --
            , tmp.Sale_Summ_10200, tmp.Sale_Summ_10250, tmp.Sale_Summ_10300
            , tmp.Promo_SummCost, tmp.Sale_SummCost, tmp.Sale_SummCost_10500, tmp.Sale_SummCost_40200
            , tmp.Sale_Amount_Weight, tmp.Sale_Amount_Sh
            , tmp.Promo_AmountPartner_Weight, tmp.Promo_AmountPartner_Sh, tmp.Sale_AmountPartner_Weight
            , tmp.Sale_AmountPartner_Sh, tmp.Sale_AmountPartnerR_Weight, tmp.Sale_AmountPartnerR_Sh
            , tmp.Return_Summ, tmp.Return_Summ_10300, tmp.Return_Summ_10700, tmp.Return_SummCost, tmp.Return_SummCost_40200
            , tmp.Return_Amount_Weight, tmp.Return_Amount_Sh, tmp.Return_AmountPartner_Weight, tmp.Return_AmountPartner_Sh
            , tmp.Sale_Amount_10500_Weight
            , tmp.Sale_Amount_40200_Weight
            , tmp.Return_Amount_40200_Weight
            , tmp.ReturnPercent
              --
              -- сумма без НДС
            , CASE WHEN _tmpMI.MovementDescId = zc_Movement_ChangePercent()
                        --  так для док.скидки
                        THEN -1 * COALESCE (_tmpMI.Sale_SummVAT, 0) -- COALESCE (_tmpMI.Sale_SummMVAT, 0)
                   ELSE (COALESCE (tmp.Sale_Summ, 0)   - COALESCE (_tmpMI.Sale_SummVAT, 0))
              END :: TFloat AS Sale_SummMVAT
              --
              -- сумма НДС
            , _tmpMI.Sale_SummVAT   :: TFloat AS Sale_SummVAT
              --
              -- сумма без НДС
            , (COALESCE (tmp.Return_Summ, 0) - COALESCE (_tmpMI.Return_SummVAT, 0)) :: TFloat AS Return_SummMVAT
              --
              -- сумма НДС
            , _tmpMI.Return_SummVAT :: TFloat AS Return_SummVAT

       FROM tmpReport AS tmp
           FULL JOIN _tmpMI ON COALESCE (_tmpMI.JuridicalId,0)  = COALESCE (tmp.JuridicalId, 0)
                           AND COALESCE (_tmpMI.ContractId,0)   = COALESCE (tmp.ContractId,0)
                           AND COALESCE (_tmpMI.PartnerId ,0)   = COALESCE (tmp.PartnerId, 0)
                           AND COALESCE (_tmpMI.InfoMoneyId,0)  = COALESCE (tmp.InfoMoneyId,0)
                           AND COALESCE (_tmpMI.BranchId,0)     = COALESCE (tmp.BranchId,0)
                           AND COALESCE (_tmpMI.TradeMarkId,0)  = COALESCE (tmp.TradeMarkId,0)
                           AND COALESCE (_tmpMI.GoodsId, 0)     = COALESCE (tmp.GoodsId, 0)
                           AND COALESCE (_tmpMI.GoodsKindId, 0) = COALESCE (tmp.GoodsKindId, 0)
                           AND _tmpMI.MovementDescId <> zc_Movement_ChangePercent()
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = _tmpMI.PartnerId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                               ON ObjectLink_Goods_GoodsGroupStat.ObjectId = COALESCE (_tmpMI.GoodsId, tmp.GoodsId)
                              AND ObjectLink_Goods_GoodsGroupStat.DescId   = zc_ObjectLink_Goods_GoodsGroupStat()
          LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_Goods_GoodsGroupStat.ChildObjectId

          LEFT JOIN tmpVATPercent ON tmpVATPercent.JuridicalId = COALESCE (_tmpMI.JuridicalId, tmp.JuridicalId)
                               --AND tmpVATPercent.ContractId  = COALESCE (_tmpMI.ContractId, tmp.ContractId)

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (_tmpMI.JuridicalId, tmp.JuridicalId)
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_RetailReport
                               ON ObjectLink_Juridical_RetailReport.ObjectId = COALESCE (_tmpMI.JuridicalId, tmp.JuridicalId)
                              AND ObjectLink_Juridical_RetailReport.DescId = zc_ObjectLink_Juridical_RetailReport()
          LEFT JOIN Object AS Object_RetailReport ON Object_RetailReport.Id = ObjectLink_Juridical_RetailReport.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = COALESCE (_tmpMI.GoodsId, tmp.GoodsId)
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = COALESCE (_tmpMI.GoodsId, tmp.GoodsId)
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                               ON ObjectLink_Goods_GoodsPlatform.ObjectId = COALESCE (_tmpMI.GoodsId, tmp.GoodsId)
                              AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
          LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                               ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = COALESCE (_tmpMI.GoodsId, tmp.GoodsId)
                              AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                               ON ObjectLink_Goods_GoodsTag.ObjectId = COALESCE (_tmpMI.GoodsId, tmp.GoodsId)
                              AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
          LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = COALESCE (_tmpMI.GoodsId, tmp.GoodsId)
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                               ON ObjectLink_Juridical_JuridicalGroup.ObjectId = COALESCE (_tmpMI.JuridicalId, tmp.JuridicalId)
                              AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
          LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (_tmpMI.InfoMoneyId, tmp.InfoMoneyId)

          LEFT JOIN tmpPartnerAddress AS View_Partner_Address ON View_Partner_Address.PartnerId = COALESCE (tmp.PartnerId, Object_Partner.Id)
          LEFT JOIN ObjectString AS ObjectString_Address
                                 ON ObjectString_Address.ObjectId = COALESCE (tmp.PartnerId, Object_Partner.Id)
                                AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                               ON ObjectLink_Partner_Personal.ObjectId = COALESCE (tmp.PartnerId, Object_Partner.Id)
                              AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
          LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = ObjectLink_Partner_Personal.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = View_Personal.UnitId
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          LEFT JOIN Object AS Object_BranchPersonal ON Object_BranchPersonal.Id = ObjectLink_Unit_Branch.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                               ON ObjectLink_Partner_PersonalTrade.ObjectId = COALESCE (tmp.PartnerId, Object_Partner.Id)
                              AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
          LEFT JOIN Object_Personal_View AS View_PersonalTrade ON View_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId
          
         ) AS tmp
       GROUP BY tmp.GoodsGroupName, tmp.GoodsGroupNameFull
            , tmp.GoodsCode
            , tmp.GoodsName
            , CASE WHEN inIsGoodsKind = FALSE THEN 0 ELSE tmp.GoodsKindId END
            --, tmp.GoodsKindName
            , tmp.MeasureName
            , tmp.TradeMarkName
            , tmp.GoodsGroupAnalystName, tmp.GoodsTagName
            , tmp.GoodsGroupStatName
            , tmp.GoodsPlatformName
            , tmp.JuridicalGroupName
            , tmp.BranchCode
            , tmp.BranchName
            , tmp.JuridicalCode
            , tmp.JuridicalName
            , tmp.RetailName, tmp.RetailReportName
            , tmp.AreaName, tmp.PartnerTagName
            , tmp.Address, tmp.RegionName, tmp.ProvinceName, tmp.CityKindName, tmp.CityName
            , tmp.PartnerId, tmp.PartnerCode, tmp.PartnerName
            , tmp.ContractCode
            , tmp.ContractNumber
            , tmp.ContractTagName, tmp.ContractTagGroupName
            , tmp.PersonalName, tmp.UnitName_Personal, tmp.BranchName_Personal
            , tmp.PersonalTradeName, tmp.UnitName_PersonalTrade
            , tmp.InfoMoneyGroupName, tmp.InfoMoneyDestinationName
            , tmp.InfoMoneyCode
            , tmp.InfoMoneyName
            , tmp.InfoMoneyName_all
            , tmp.VATPercent
           ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.23         *
 15.02.19         *
*/
-- тест
--
-- SELECT * FROM gpReport_GoodsMI_SaleReturnIn_BUH (inStartDate:= '31.05.2024', inEndDate:= '31.05.2024', inBranchId:= 0, inAreaId:= 0, inRetailId:= 0, inJuridicalId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inTradeMarkId:= 0, inGoodsGroupId:= 0, inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inIsPartner:= TRUE, inIsTradeMark:= TRUE, inIsGoods:= TRUE, inIsGoodsKind:= TRUE, inIsContract:= FALSE, inIsOLAP:= TRUE, inSession:= zfCalc_UserAdmin());
/*

select 1 AS yy, * from gpReport_GoodsMI_SaleReturnIn_BUH(inStartDate := ('01.10.2023')::TDateTime , inEndDate := ('31.12.2023')::TDateTime , inBranchId := 0 , inAreaId := 0 , inRetailId := 0 , inJuridicalId := 6329185  , inPaidKindId := 3 
, inTradeMarkId := 0 , inGoodsGroupId := 0 , inInfoMoneyId := 8962 , inIsPartner := 'True' , inIsTradeMark := 'False' , inIsGoods := 'False' , inIsGoodsKind := 'False' , inisContract := 'False' , inIsOLAP := 'True' ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e')as  tmp



union 
select 2 AS yy, * from gpReport_GoodsMI_SaleReturnIn_BUH_old(inStartDate := ('01.10.2023')::TDateTime , inEndDate := ('31.12.2023')::TDateTime , inBranchId := 0 , inAreaId := 0 , inRetailId := 0 , inJuridicalId := 6329185 , inPaidKindId := 3 
, inTradeMarkId := 0 , inGoodsGroupId := 0 , inInfoMoneyId := 8962 , inIsPartner := 'True' , inIsTradeMark := 'False' , inIsGoods := 'False' , inIsGoodsKind := 'False' , inisContract := 'False' , inIsOLAP := 'True' ,  inSession :=  '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');


--where partnerid = 5727453
*/