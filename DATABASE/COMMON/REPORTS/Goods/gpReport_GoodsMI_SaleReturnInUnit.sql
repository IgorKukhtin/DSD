-- Function: gpReport_Goods_Movement ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_SaleReturnInUnit (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_SaleReturnInUnit (
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
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar, GoodsGroupAnalystName TVarChar, GoodsTagName TVarChar/*, GoodsGroupStatName TVarChar*/
             , GoodsPlatformName TVarChar
             , JuridicalGroupName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar/*, OKPO TVarChar*/
             , RetailName TVarChar/*, RetailReportName TVarChar*/
             , AreaName TVarChar, PartnerTagName TVarChar
             , Address TVarChar/*, RegionName TVarChar, ProvinceName TVarChar, CityKindName TVarChar, CityName TVarChar, ProvinceCityName TVarChar, StreetKindName TVarChar, StreetName TVarChar*/
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             /*, ContractCode Integer, ContractNumber TVarChar, ContractTagName TVarChar, ContractTagGroupName TVarChar
             , PersonalName TVarChar, UnitName_Personal TVarChar, BranchName_Personal TVarChar
             , PersonalTradeName TVarChar, UnitName_PersonalTrade TVarChar*/
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar

             , Sale_Summ TFloat, Sale_SummReal TFloat, Sale_Summ_10200 TFloat, Sale_Summ_10250 TFloat, Sale_Summ_10300 TFloat
             , Sale_SummCost TFloat, Sale_SummCost_10500 TFloat, Sale_SummCost_40200 TFloat
             , Sale_Amount_Weight TFloat, Sale_Amount_Sh TFloat, Sale_AmountPartner_Weight TFloat, Sale_AmountPartner_Sh TFloat, Sale_AmountPartnerR_Weight TFloat, Sale_AmountPartnerR_Sh TFloat
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
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- Ограничения по товару
    IF inGoodsGroupId <> 0
    THEN
        -- устанавливается признак
        vbIsGoods:= TRUE;

    ELSE IF inTradeMarkId <> 0
         THEN
             -- устанавливается признак
             vbIsGoods:= TRUE;

         ELSE
             -- устанавливается признак
             vbIsGoods:= FALSE;

         END IF;
    END IF;



    -- результат
    RETURN QUERY
       WITH _tmpGoods_report AS
          (SELECT lfObject_Goods_byGoodsGroup.GoodsId AS GoodsId
                , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                -- , COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0) AS MeasureId
                -- , COALESCE (ObjectFloat_Weight.ValueData, 0)           AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = lfObject_Goods_byGoodsGroup.GoodsId
                                    AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
           WHERE (ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId OR COALESCE (inTradeMarkId, 0) = 0)
             AND inGoodsGroupId <> 0 -- !!!

          UNION
                SELECT ObjectLink_Goods_TradeMark.ObjectId AS GoodsId
                     , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                FROM ObjectLink AS ObjectLink_Goods_TradeMark
                WHERE ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                  AND ObjectLink_Goods_TradeMark.ChildObjectId = inTradeMarkId
                  AND COALESCE (inGoodsGroupId, 0) = 0 AND vbIsGoods = TRUE -- !!!
          UNION
                SELECT ObjectLink_Goods_TradeMark.ObjectId AS GoodsId
                     , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) ELSE 0 END AS TradeMarkId
                FROM ObjectLink AS ObjectLink_Goods_TradeMark
                WHERE ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                  AND ObjectLink_Goods_TradeMark.ChildObjectId > 0
                  AND (inIsTradeMark = TRUE AND inIsGoods = FALSE)
                  AND vbIsGoods = FALSE -- !!!
          )

          , tmp_Unit AS  (SELECT 8459 AS UnitId -- Склад Реализации
                         UNION 
                          SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8460) AS lfSelect_Object_Unit_byGroup) -- Возвраты общие
       , tmpInfoMoney AS (SELECT * FROM Object_InfoMoney_View WHERE InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000()) -- !!!Доходы!!!)
       , tmpPartnerAddress AS (SELECT * FROM Object_Partner_Address_View)
       , tmpAnalyzer AS (SELECT Constant_ProfitLoss_AnalyzerId_View.*
                         FROM Constant_ProfitLoss_AnalyzerId_View
                         WHERE isCost = FALSE
                        ) 
        , tmpAccount AS (SELECT Object_Account_View.AccountGroupId, Object_Account_View.AccountId
                         FROM Object_Account_View
                         WHERE Object_Account_View.AccountGroupId IN (zc_Enum_AccountGroup_60000()  -- Прибыль будущих периодов
                                                                    , zc_Enum_AccountGroup_110000() -- Транзит
                                                                     )
                        )

          , tmp_Send AS  (SELECT CASE WHEN inIsPartner = TRUE AND tmp_Unit_To.UnitId IS NULL
                                           THEN MovementLinkObject_From.ObjectId
                                      WHEN inIsPartner = TRUE AND tmp_Unit_From.UnitId IS NULL
                                           THEN MovementLinkObject_To.ObjectId
                                      ELSE 0
                                 END AS FromId


                               , CASE WHEN inIsPartner = TRUE AND tmp_Unit_To.UnitId IS NULL
                                           THEN MovementLinkObject_To.ObjectId
                                      WHEN inIsPartner = TRUE AND tmp_Unit_From.UnitId IS NULL
                                           THEN MovementLinkObject_From.ObjectId
                                      ELSE 0
                                 END AS ToId

                               , MovementItem.ObjectId AS GoodsId
                               , CASE WHEN inIsGoodsKind = TRUE THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END AS GoodsKindId
                                 -- продажи
                               , SUM (CASE WHEN tmp_Unit_From.UnitId > 0 THEN MovementItem.Amount ELSE 0 END) AS Amount_Count_unit
                               , SUM (CASE WHEN tmp_Unit_From.UnitId > 0 THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE 0 END) AS Amount_Count
                               , SUM (CASE WHEN tmp_Unit_From.UnitId > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)       ELSE 0 END) AS AmountReal_Count
                                 -- сумма для кол-во со скидкой вес
                               , SUM (/*CASE WHEN tmp_Unit_From.UnitId > 0 THEN / *COALESCE (MIFloat_AmountPartner.ValueData, 0)* / COALESCE (MIFloat_AmountChangePercent.ValueData, 0) ELSE 0 END
                                    * CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                           ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                      END * 1.2*/
                                      CASE WHEN tmp_Unit_From.UnitId > 0 THEN COALESCE (MIFloat_SummFrom.ValueData, 0) ELSE 0 END
                                     ) AS Amount_Summ
                                 -- сумма для кол-во у покупателя
                               , SUM (CASE WHEN tmp_Unit_From.UnitId > 0 THEN COALESCE (MIFloat_Summ.ValueData, 0) ELSE 0 END) AS Amount_SummReal
                               , SUM (CASE WHEN tmp_Unit_From.UnitId > 0 THEN COALESCE (MIFloat_SummPriceList.ValueData, 0) ELSE 0 END) AS Sale_Summ_10100
                                 -- возвраты
                               , SUM (CASE WHEN tmp_Unit_To.UnitId > 0 THEN MovementItem.Amount ELSE 0 END) AS Amount_CountRet_unit
                               , SUM (CASE WHEN tmp_Unit_To.UnitId > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) /*MovementItem.Amount*/ ELSE 0 END) AS Amount_CountRet
                               , SUM (/*CASE WHEN tmp_Unit_To.UnitId > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) / *MovementItem.Amount* / ELSE 0 END
                                    * CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                           ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                      END * 1.2*/
                                      CASE WHEN tmp_Unit_To.UnitId > 0 THEN COALESCE (MIFloat_Summ.ValueData, 0) ELSE 0 END
                                     ) AS Amount_SummRet
                               , SUM (CASE WHEN tmp_Unit_To.UnitId > 0 THEN COALESCE (MIFloat_SummPriceList.ValueData, 0) ELSE 0 END) AS Return_Summ_10700


                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN tmp_Unit AS tmp_Unit_From ON tmp_Unit_From.UnitId = MovementLinkObject_From.ObjectId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN tmp_Unit AS tmp_Unit_To ON tmp_Unit_To.UnitId = MovementLinkObject_To.ObjectId

                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                               LEFT JOIN _tmpGoods_report ON _tmpGoods_report.GoodsId = MovementItem.ObjectId

                               LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                               LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                           ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()

                               /*LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()*/

                               LEFT JOIN MovementItemFloat AS MIFloat_SummFrom
                                                           ON MIFloat_SummFrom.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummFrom.DescId = zc_MIFloat_SummFrom()
                               LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                           ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummPriceList
                                                           ON MIFloat_SummPriceList.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummPriceList.DescId = zc_MIFloat_SummPriceList()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND Movement.DescId = zc_Movement_SendOnPrice()
                            AND (_tmpGoods_report.GoodsId > 0 OR vbIsGoods = FALSE)
                            AND (tmp_Unit_From.UnitId > 0
                              OR tmp_Unit_To.UnitId > 0)
                            AND (inBranchId = zc_Branch_Basis() OR COALESCE (inBranchId, 0) = 0)
                          GROUP BY CASE WHEN inIsPartner = TRUE AND tmp_Unit_To.UnitId IS NULL
                                             THEN MovementLinkObject_From.ObjectId
                                        WHEN inIsPartner = TRUE AND tmp_Unit_From.UnitId IS NULL
                                             THEN MovementLinkObject_To.ObjectId
                                        ELSE 0
                                   END
                                 , CASE WHEN inIsPartner = TRUE AND tmp_Unit_To.UnitId IS NULL
                                             THEN MovementLinkObject_To.ObjectId
                                        WHEN inIsPartner = TRUE AND tmp_Unit_From.UnitId IS NULL
                                             THEN MovementLinkObject_From.ObjectId
                                        ELSE 0
                                   END
                                 , CASE WHEN inIsPartner = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END
                                 , MovementItem.ObjectId
                                 , CASE WHEN inIsGoodsKind = TRUE THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END
                         )
, tmpOperationGroup2 AS (SELECT MIContainer.ObjectId_Analyzer                 AS GoodsId
                              , MIContainer.ObjectIntId_Analyzer              AS GoodsKindId -- COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                              , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer /*MovementLinkObject_Partner.ObjectId*/ END AS PartnerId
                              , 0                                            AS BranchId
                              , COALESCE (ContainerLO_Juridical.ObjectId, 0) AS JuridicalId
                              , COALESCE (ContainerLO_InfoMoney.ObjectId, 0) AS InfoMoneyId

                              , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     AND tmpAccount.AccountGroupId IS NULL THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_AmountPartner
                              , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() AND tmpAccount.AccountGroupId IS NULL THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_AmountPartner
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500()     AND tmpAccount.AccountGroupId IS NULL THEN -1 * MIContainer.Amount ELSE 0 END) AS Sale_Amount_10500
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     AND tmpAccount.AccountGroupId IS NULL THEN  1 * MIContainer.Amount ELSE 0 END) AS Sale_Amount_40200
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() AND tmpAccount.AccountGroupId IS NULL THEN  1 * MIContainer.Amount ELSE 0 END) AS Return_Amount_40200

                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400()     AND tmpAccount.AccountGroupId IS NULL THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_SummCost
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() AND tmpAccount.AccountGroupId IS NULL THEN  1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Return_SummCost
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500()     AND tmpAccount.AccountGroupId IS NULL THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_SummCost_10500
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200()     AND tmpAccount.AccountGroupId IS NULL THEN  1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Sale_SummCost_40200
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() AND tmpAccount.AccountGroupId IS NULL THEN  1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS Return_SummCost_40200

                                -- Сумма Реализация
                              , 0 AS Sale_Summ
                                -- Сумма Реализация
                              , SUM (CASE WHEN tmpAnalyzer.isCost = FALSE AND MIContainer.MovementDescId = zc_Movement_Sale()     AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossSumm_20200() THEN 1 * MIContainer.Amount ELSE 0 END
                                   + CASE WHEN tmpAnalyzer.isCost = FALSE AND MIContainer.MovementDescId = zc_Movement_Sale()     AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossSumm_20200() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND MIContainer.isActive = TRUE  THEN  1 * MIContainer.Amount ELSE 0 END
                                   - CASE WHEN tmpAnalyzer.isCost = FALSE AND MIContainer.MovementDescId = zc_Movement_Sale()     AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossSumm_20200() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END
                                    ) AS Sale_SummReal
                                -- Сумма Возврат
                              , SUM (CASE WHEN tmpAnalyzer.isCost = FALSE AND MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossSumm_20200() THEN -1 * MIContainer.Amount ELSE 0 END
                                   + CASE WHEN tmpAnalyzer.isCost = FALSE AND MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossSumm_20200() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND MIContainer.isActive = FALSE /* TRUE  */ THEN  1 * MIContainer.Amount ELSE 0 END
                                   - CASE WHEN tmpAnalyzer.isCost = FALSE AND MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossSumm_20200() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND MIContainer.isActive = TRUE  /* FALSE */ THEN -1 * MIContainer.Amount ELSE 0 END
                                    ) AS Return_Summ

                                -- Сумма Реализация - По прайсу
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100()     THEN 1 * MIContainer.Amount ELSE 0 END
                                   + CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100()     AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND MIContainer.isActive = TRUE  THEN  1 * MIContainer.Amount ELSE 0 END
                                   - CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100()     AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END
                                    ) AS Sale_Summ_PriceList
                                -- Сумма Возврат - По прайсу
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() THEN -1 * MIContainer.Amount ELSE 0 END
                                   + CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND MIContainer.isActive = FALSE THEN  1 * MIContainer.Amount ELSE 0 END
                                   - CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND MIContainer.isActive = TRUE  THEN -1 * MIContainer.Amount ELSE 0 END
                                    ) AS Return_Summ_PriceList


                                 -- Сумма Реализация - Разница с оптовыми ценами
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200()     THEN 1 * MIContainer.Amount ELSE 0 END
                                   + CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200()     AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND MIContainer.isActive = TRUE  THEN  1 * MIContainer.Amount ELSE 0 END
                                   - CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200()     AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END
                                    ) AS Sale_Summ_10200
                                -- Сумма Реализация - Скидка Акция
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10250()     THEN -1 * MIContainer.Amount ELSE 0 END
                                   + CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10250()     AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND MIContainer.isActive = TRUE  THEN -1 * MIContainer.Amount ELSE 0 END
                                   - CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10250()     AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND MIContainer.isActive = FALSE THEN  1 * MIContainer.Amount ELSE 0 END
                                    ) AS Sale_Summ_10250
                                -- Сумма Возврат - Разница с оптовыми ценами
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10200() THEN 1 * MIContainer.Amount ELSE 0 END
                                   + CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10200() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END
                                   - CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10200() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND MIContainer.isActive = TRUE  THEN  1 * MIContainer.Amount ELSE 0 END
                                    ) AS Return_Summ_10200

                                -- Сумма Реализация - Скидка / Наценка дополнительная
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()     THEN 1 * MIContainer.Amount ELSE 0 END
                                   + CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()     AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND MIContainer.isActive = TRUE  THEN  1 * MIContainer.Amount ELSE 0 END
                                   - CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()     AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END
                                    ) AS Sale_Summ_10300
                                -- Сумма Возврат - Скидка / Наценка дополнительная
                              , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN 1 * MIContainer.Amount ELSE 0 END
                                   + CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END
                                   - CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() AND MIContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND MIContainer.isActive = TRUE  THEN  1 * MIContainer.Amount ELSE 0 END
                                    ) AS Return_Summ_10300

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
                              INNER JOIN tmp_Unit ON tmp_Unit.UnitId = MIContainer.WhereObjectId_analyzer
                              LEFT JOIN tmpAccount ON tmpAccount.AccountId = MIContainer.AccountId

                         GROUP BY MIContainer.ObjectId_Analyzer
                                , MIContainer.ObjectIntId_Analyzer
                                , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                                , ContainerLO_Juridical.ObjectId
                                , ContainerLO_InfoMoney.ObjectId
                        UNION ALL
                         SELECT MovementItem.ObjectId AS GoodsId
                              , CASE WHEN inIsGoodsKind = TRUE  THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END AS GoodsKindId
                              , CASE WHEN inIsPartner   = FALSE THEN 0 ELSE MovementLinkObject_To.ObjectId  END AS PartnerId
                              , 0 AS BranchId
                              , CASE WHEN inIsPartner = TRUE THEN ObjectLink_Juridical.ChildObjectId ELSE 0 END AS JuridicalId
                              , ObjectLink_InfoMoney.ChildObjectId AS InfoMoneyId

                              , 0 AS Sale_AmountPartner
                              , 0 AS Return_AmountPartner
                              , 0 AS Sale_Amount_10500
                              , 0 AS Sale_Amount_40200
                              , 0 AS Return_Amount_40200

                              , 0 AS Sale_SummCost
                              , 0 AS Return_SummCost
                              , 0 AS Sale_SummCost_10500
                              , 0 AS Sale_SummCost_40200
                              , 0 AS Return_SummCost_40200

                                -- Сумма Реализация
                              , SUM (COALESCE (MIFloat_SummFrom.ValueData, 0)) AS Sale_Summ
                                -- Сумма Реализация
                              , 0 AS Sale_SummReal
                                -- Сумма Возврат
                              , 0 AS Return_Summ

                                -- Сумма Реализация - По прайсу
                              , 0 AS Sale_Summ_PriceList
                                -- Сумма Возврат - По прайсу
                              , 0 AS Return_Summ_PriceList


                                -- Сумма Реализация - Разница с оптовыми ценами
                              , 0 AS Sale_Summ_10200
                                -- Сумма Реализация - Скидка Акция
                              , 0 AS Sale_Summ_10250
                                -- Сумма Возврат - Разница с оптовыми ценами
                              , 0 AS Return_Summ_10200

                                -- Сумма Реализация - Скидка / Наценка дополнительная
                              , 0 AS Sale_Summ_10300
                                -- Сумма Возврат - Скидка / Наценка дополнительная
                              , 0 AS Return_Summ_10300

                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               INNER JOIN tmp_Unit AS tmp_Unit_From ON tmp_Unit_From.UnitId = MovementLinkObject_From.ObjectId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                    ON ObjectLink_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                               LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                                    ON ObjectLink_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                                   AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()

                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                               LEFT JOIN _tmpGoods_report ON _tmpGoods_report.GoodsId = MovementItem.ObjectId

                               LEFT JOIN MovementItemFloat AS MIFloat_SummFrom
                                                           ON MIFloat_SummFrom.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummFrom.DescId = zc_MIFloat_SummFrom()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND Movement.DescId = zc_Movement_Sale()
                            AND (_tmpGoods_report.GoodsId > 0 OR vbIsGoods = FALSE)
                            AND (inBranchId = zc_Branch_Basis() OR COALESCE (inBranchId, 0) = 0)

                          GROUP BY MovementItem.ObjectId
                                 , CASE WHEN inIsGoodsKind = TRUE THEN MILinkObject_GoodsKind.ObjectId ELSE 0 END
                                 , CASE WHEN inIsPartner = FALSE THEN 0 ELSE MovementLinkObject_To.ObjectId END
                                 , CASE WHEN inIsPartner = TRUE THEN ObjectLink_Juridical.ChildObjectId ELSE 0 END
                                 , ObjectLink_InfoMoney.ChildObjectId
                        )

 , tmpOperationGroup AS (SELECT CASE WHEN inIsPartner = TRUE THEN tmpOperationGroup2.JuridicalId ELSE 0 END AS JuridicalId
                              , 0 AS ContractId
                              , CASE WHEN inIsPartner = FALSE THEN 0 ELSE tmpOperationGroup2.PartnerId END AS PartnerId

                              , tmpOperationGroup2.InfoMoneyId
                              , tmpOperationGroup2.BranchId

                              , _tmpGoods_report.TradeMarkId
                              , CASE WHEN inIsGoods = TRUE     THEN tmpOperationGroup2.GoodsId     ELSE 0 END AS GoodsId
                              , CASE WHEN inIsGoodsKind = TRUE THEN tmpOperationGroup2.GoodsKindId ELSE 0 END AS GoodsKindId

                              , SUM (tmpOperationGroup2.Sale_Summ)     AS Sale_Summ
                              , SUM (tmpOperationGroup2.Sale_SummReal) AS Sale_SummReal
                              , SUM (tmpOperationGroup2.Return_Summ)   AS Return_Summ

                              , SUM (tmpOperationGroup2.Sale_Summ_PriceList)   AS Sale_Summ_PriceList
                              , SUM (tmpOperationGroup2.Return_Summ_PriceList) AS Return_Summ_PriceList

                              , SUM (tmpOperationGroup2.Sale_Summ_10200)   AS Sale_Summ_10200
                              , SUM (tmpOperationGroup2.Sale_Summ_10250)   AS Sale_Summ_10250
                              , SUM (tmpOperationGroup2.Return_Summ_10200) AS Return_Summ_10200
                              , SUM (tmpOperationGroup2.Sale_Summ_10300)   AS Sale_Summ_10300
                              , SUM (tmpOperationGroup2.Return_Summ_10300) AS Return_Summ_10300

                              , SUM (tmpOperationGroup2.Sale_AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Sale_AmountPartner_Weight
                              , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperationGroup2.Sale_AmountPartner ELSE 0 END) AS Sale_AmountPartner_Sh

                              , SUM (tmpOperationGroup2.Return_AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Return_AmountPartner_Weight
                              , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperationGroup2.Return_AmountPartner ELSE 0 END) AS Return_AmountPartner_Sh

                              , SUM (tmpOperationGroup2.Sale_Amount_10500 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Sale_Amount_10500_Weight
                              , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperationGroup2.Sale_Amount_10500 ELSE 0 END) AS Sale_Amount_10500_Sh

                              , SUM (tmpOperationGroup2.Sale_Amount_40200 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Sale_Amount_40200_Weight
                              , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperationGroup2.Sale_Amount_40200 ELSE 0 END) AS Sale_Amount_40200_Sh

                              , SUM (tmpOperationGroup2.Return_Amount_40200 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Return_Amount_40200_Weight
                              , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpOperationGroup2.Return_Amount_40200 ELSE 0 END) AS Return_Amount_40200_Sh

                         FROM tmpOperationGroup2
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = tmpOperationGroup2.GoodsId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                    ON ObjectFloat_Weight.ObjectId = tmpOperationGroup2.GoodsId
                                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                              LEFT JOIN _tmpGoods_report ON _tmpGoods_report.GoodsId = tmpOperationGroup2.GoodsId

                         WHERE (_tmpGoods_report.GoodsId > 0 OR vbIsGoods = FALSE)

                         GROUP BY CASE WHEN inIsPartner = TRUE THEN tmpOperationGroup2.JuridicalId ELSE 0 END
                                , CASE WHEN inIsPartner = FALSE THEN 0 ELSE tmpOperationGroup2.PartnerId END
                                , tmpOperationGroup2.InfoMoneyId
                                , tmpOperationGroup2.BranchId
                                , _tmpGoods_report.TradeMarkId
                                , CASE WHEN inIsGoods = TRUE THEN tmpOperationGroup2.GoodsId ELSE 0 END    
                                , CASE WHEN inIsGoodsKind = TRUE THEN tmpOperationGroup2.GoodsKindId ELSE 0 END
                        )

    SELECT Object_GoodsGroup.ValueData         AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

          , Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName
          , Object_GoodsKind.ValueData         AS GoodsKindName
          , Object_Measure.ValueData           AS MeasureName

          , Object_TradeMark.ValueData         AS TradeMarkName
          , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
          , Object_GoodsTag.ValueData          AS GoodsTagName

          , Object_GoodsPlatform.ValueData     AS GoodsPlatformName
          , Object_JuridicalGroup.ValueData    AS JuridicalGroupName

          , Object_Branch.ObjectCode    AS BranchCode
          , Object_Branch.ValueData     AS BranchName

          , Object_Juridical.ObjectCode AS JuridicalCode
          , Object_Juridical.ValueData  AS JuridicalName

          , Object_Retail.ValueData       AS RetailName

          , View_Partner_Address.AreaName
          , View_Partner_Address.PartnerTagName

          , ObjectString_Address.ValueData AS Address

          , View_Partner_Address.PartnerId
          , View_Partner_Address.PartnerCode
          , View_Partner_Address.PartnerName

             , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
             , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
             , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
             , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
             , View_InfoMoney.InfoMoneyName_all               AS InfoMoneyName_all


             , tmpOperationGroup.Sale_Summ       :: TFloat AS Sale_Summ
             , tmpOperationGroup.Sale_SummReal   :: TFloat AS Sale_SummReal
             , tmpOperationGroup.Sale_Summ_10200 :: TFloat AS Sale_Summ_10200, tmpOperationGroup.Sale_Summ_10250 :: TFloat AS Sale_Summ_10250, tmpOperationGroup.Sale_Summ_10300 :: TFloat AS Sale_Summ_10300
             , 0 :: TFloat AS Sale_SummCost, 0 :: TFloat AS Sale_SummCost_10500, 0 :: TFloat AS Sale_SummCost_40200

             , (tmpOperationGroup.Sale_AmountPartner_Weight + tmpOperationGroup.Sale_Amount_10500_Weight - tmpOperationGroup.Sale_Amount_40200_Weight) :: TFloat  AS Sale_Amount_Weight
             , (tmpOperationGroup.Sale_AmountPartner_Sh     + tmpOperationGroup.Sale_Amount_10500_Sh     - tmpOperationGroup.Sale_Amount_40200_Sh    ) :: TFloat  AS Sale_Amount_Sh
             , (tmpOperationGroup.Sale_AmountPartner_Weight - tmpOperationGroup.Sale_Amount_40200_Weight) :: TFloat AS Sale_AmountPartner_Weight
             , (tmpOperationGroup.Sale_AmountPartner_Sh     - tmpOperationGroup.Sale_Amount_40200_Sh    ) :: TFloat AS Sale_AmountPartner_Sh
             , tmpOperationGroup.Sale_AmountPartner_Weight :: TFloat AS Sale_AmountPartnerR_Weight
             , tmpOperationGroup.Sale_AmountPartner_Sh     :: TFloat AS Sale_AmountPartnerR_Sh

             , tmpOperationGroup.Return_Summ :: TFloat AS Return_Summ, tmpOperationGroup.Return_Summ_10300 :: TFloat AS Return_Summ_10300, tmpOperationGroup.Return_Summ_PriceList :: TFloat AS Return_Summ_10700
             , 0 :: TFloat AS Return_SummCost, 0 :: TFloat AS Return_SummCost_40200

             , (tmpOperationGroup.Return_AmountPartner_Weight + tmpOperationGroup.Return_Amount_40200_Weight) :: TFloat AS Return_Amount_Weight
             , (tmpOperationGroup.Return_AmountPartner_Sh     + tmpOperationGroup.Return_Amount_40200_Sh)     :: TFloat AS Return_Amount_Sh
             , tmpOperationGroup.Return_AmountPartner_Weight :: TFloat AS Return_AmountPartner_Weight, tmpOperationGroup.Return_AmountPartner_Sh :: TFloat AS Return_AmountPartner_Sh

             , tmpOperationGroup.Sale_Amount_10500_Weight   :: TFloat AS Sale_Amount_10500_Weight
             , tmpOperationGroup.Sale_Amount_40200_Weight   :: TFloat AS Sale_Amount_40200_Weight
             , tmpOperationGroup.Return_Amount_40200_Weight :: TFloat AS Return_Amount_40200_Weight

             , CAST (CASE WHEN tmpOperationGroup.Sale_AmountPartner_Weight > 0 THEN 100 * tmpOperationGroup.Return_AmountPartner_Weight / tmpOperationGroup.Sale_AmountPartner_Weight ELSE 0 END AS NUMERIC (16, 1)) :: TFloat AS ReturnPercent

       FROM tmpOperationGroup
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

          LEFT JOIN tmpPartnerAddress AS View_Partner_Address ON View_Partner_Address.PartnerId = tmpOperationGroup.PartnerId
          LEFT JOIN ObjectString AS ObjectString_Address
                                 ON ObjectString_Address.ObjectId = tmpOperationGroup.PartnerId
                                AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                               ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
          LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

          LEFT JOIN tmpInfoMoney AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId

    UNION ALL

     SELECT Object_GoodsGroup.ValueData        AS GoodsGroupName
          , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
          , Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName
          , Object_GoodsKind.ValueData         AS GoodsKindName
          , Object_Measure.ValueData           AS MeasureName
          , Object_TradeMark.ValueData         AS TradeMarkName
          , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
          , Object_GoodsTag.ValueData          AS GoodsTagName
          /*, Object_GoodsGroupStat.ValueData    AS GoodsGroupStatName*/
          , Object_GoodsPlatform.ValueData     AS GoodsPlatformName

          , '' :: TVarChar AS JuridicalGroupName
          , Object_Branch.ObjectCode    AS BranchCode
          , Object_Branch.ValueData     AS BranchName

          , Object_Unit_Parent.ObjectCode    AS JuridicalCode
          , Object_Unit_Parent.ValueData     AS JuridicalName

          , '' :: TVarChar AS RetailName
          /*, '' :: TVarChar AS RetailReportName*/

          , Object_Area.ValueData :: TVarChar AS AreaName
          , '' :: TVarChar AS PartnerTagName
          , '' :: TVarChar AS Address
          /*, '' :: TVarChar AS RegionName
          , '' :: TVarChar AS ProvinceName
          , '' :: TVarChar AS CityKindName
          , '' :: TVarChar AS CityName
          , '' :: TVarChar AS ProvinceCityName
          , '' :: TVarChar AS StreetKindName
          , '' :: TVarChar AS StreetName*/

          , Object_Partner.Id            AS PartnerId
          , Object_Partner.ObjectCode    AS PartnerCode
          , Object_Partner.ValueData     AS PartnerName

          /*, 0 :: Integer   ContractCode
          , '' :: TVarChar AS ContractNumber
          , '' :: TVarChar ContractTagName
          , '' :: TVarChar ContractTagGroupName

          , '' :: TVarChar AS PersonalName
          , '' :: TVarChar AS UnitName_Personal
          , '' :: TVarChar AS BranchName_Personal

          , '' :: TVarChar AS PersonalTradeName
          , '' :: TVarChar AS UnitName_PersonalTrade*/

          , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
          , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all               AS InfoMoneyName_all

         , tmpOperationGroup.Amount_Summ         :: TFloat AS Sale_Summ
         , tmpOperationGroup.Amount_SummReal     :: TFloat AS Sale_SummReal
         , (tmpOperationGroup.Sale_Summ_10100 - tmpOperationGroup.Amount_SummReal) :: TFloat AS Sale_Summ_10200
         , 0 :: TFloat  AS Sale_Summ_10250
         , 0 :: TFloat  AS Sale_Summ_10300
         , 0 :: TFloat  AS Sale_SummCost
         , 0 :: TFloat  AS Sale_SummCost_10500
         , 0 :: TFloat  AS Sale_SummCost_40200

         , tmpOperationGroup.Amount_CountWeight_unit :: TFloat  AS Sale_Amount_Weight
         , tmpOperationGroup.Amount_CountSh_unit     :: TFloat  AS Sale_Amount_Sh

         , tmpOperationGroup.Amount_CountWeight     :: TFloat AS Sale_AmountPartner_Weight
         , tmpOperationGroup.Amount_CountSh         :: TFloat AS Sale_AmountPartner_Sh
         , tmpOperationGroup.AmountReal_CountWeight :: TFloat AS Sale_AmountPartnerR_Weight
         , tmpOperationGroup.AmountReal_CountSh     :: TFloat AS Sale_AmountPartnerR_Sh

         , tmpOperationGroup.Amount_SummRet :: TFloat AS Return_Summ
         , 0 :: TFloat AS Return_Summ_10300
         , tmpOperationGroup.Return_Summ_10700 :: TFloat AS Return_Summ_10700
         , 0 :: TFloat AS Return_SummCost
         , 0 :: TFloat AS Return_SummCost_40200

         , tmpOperationGroup.Amount_CountRetWeight_unit :: TFloat AS Return_Amount_Weight
         , tmpOperationGroup.Amount_CountRetSh_unit :: TFloat AS Return_Amount_Sh

         , tmpOperationGroup.Amount_CountRetWeight :: TFloat AS Return_AmountPartner_Weight
         , tmpOperationGroup.Amount_CountRetSh :: TFloat AS Return_AmountPartner_Sh

         , (tmpOperationGroup.Amount_CountWeight_unit - tmpOperationGroup.Amount_CountWeight) :: TFloat AS Sale_Amount_10500_Weight
         , (tmpOperationGroup.AmountReal_CountWeight  - tmpOperationGroup.Amount_CountWeight) :: TFloat AS Sale_Amount_40200_Weight
         , 0 :: TFloat AS Return_Amount_40200_Weight

         , 0 :: TFloat AS ReturnPercent

     FROM (SELECT tmp_Send.FromId
                , tmp_Send.ToId
                , CASE WHEN inIsGoods = TRUE OR inIsTradeMark = TRUE THEN tmp_Send.GoodsId ELSE 0 END AS GoodsId
                , tmp_Send.GoodsKindId

                  -- продажи
                , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmp_Send.Amount_Count_unit ELSE 0 END)                                AS Amount_CountSh_unit
                , SUM (tmp_Send.Amount_Count_unit * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_CountWeight_unit
                , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmp_Send.Amount_Count ELSE 0 END)                                     AS Amount_CountSh
                , SUM (tmp_Send.Amount_Count * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)      AS Amount_CountWeight
                , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmp_Send.AmountReal_Count ELSE 0 END)                                 AS AmountReal_CountSh
                , SUM (tmp_Send.AmountReal_Count * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  AS AmountReal_CountWeight

                , SUM (tmp_Send.Amount_Summ)     AS Amount_Summ
                , SUM (tmp_Send.Amount_SummReal) AS Amount_SummReal
                , SUM (tmp_Send.Sale_Summ_10100) AS Sale_Summ_10100

                  -- возвраты
                , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmp_Send.Amount_CountRet_unit ELSE 0 END)                                AS Amount_CountRetSh_unit
                , SUM (tmp_Send.Amount_CountRet_unit * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_CountRetWeight_unit
                , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmp_Send.Amount_CountRet ELSE 0 END)                                AS Amount_CountRetSh
                , SUM (tmp_Send.Amount_CountRet * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_CountRetWeight
                , SUM (tmp_Send.Amount_SummRet)    AS Amount_SummRet
                , SUM (tmp_Send.Return_Summ_10700) AS Return_Summ_10700
           FROM tmp_Send
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmp_Send.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = tmp_Send.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           GROUP BY tmp_Send.FromId
                  , tmp_Send.ToId
                  , CASE WHEN inIsGoods = TRUE OR inIsTradeMark = TRUE THEN tmp_Send.GoodsId ELSE 0 END
                  , tmp_Send.GoodsKindId
          ) AS tmpOperationGroup
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                               ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                               ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
          LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

          /*LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                               ON ObjectLink_Goods_GoodsGroupStat.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
          LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_Goods_GoodsGroupStat.ChildObjectId*/

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                               ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
          LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId
            
          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.ToId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = zc_Branch_Basis()

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                               ON ObjectLink_Unit_Parent.ObjectId = tmpOperationGroup.ToId
                              AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
          LEFT JOIN Object AS Object_Unit_Parent ON Object_Unit_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                               ON ObjectLink_Unit_Area.ObjectId = tmpOperationGroup.ToId
                              AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
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
-- SELECT * FROM gpReport_GoodsMI_SaleReturnInUnit (inStartDate:= '01.04.2017', inEndDate:= '30.04.2017', inBranchId:= 0, inAreaId:= 1, inRetailId:= 0, inJuridicalId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(), inTradeMarkId:= 0, inGoodsGroupId:= 0, inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inIsPartner:= TRUE, inIsTradeMark:= FALSE, inIsGoods:= FALSE, inIsGoodsKind:= FALSE, inSession:= zfCalc_UserAdmin());
