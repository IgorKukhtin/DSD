-- Function: gpReport_GoodsMI ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inDescId            Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inJuridicalId       Integer   ,
    IN inPaidKindId        Integer   ,
    IN inInfoMoneyId       Integer   ,
    IN inUnitGroupId       Integer   ,
    IN inUnitId            Integer   ,
    IN inGoodsGroupId      Integer   ,
    IN inIsPartner         Boolean   , --
    IN inIsTradeMark       Boolean   , --
    IN inIsGoods           Boolean   , --
    IN inIsGoodsKind       Boolean   , --
    IN inIsPartionGoods    Boolean   , --
    IN inIsDate            Boolean   , -- 
    IN inisReason          Boolean   , -- развернуть по причинам
    IN inIsErased          Boolean   , -- показать удаленные Да / Нет  
    IN inIsContract        Boolean   , -- по договорам
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , PartionGoods TVarChar
             , LocationId Integer, LocationCode Integer, LocationName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , RetailName TVarChar
             , AreaName TVarChar, PartnerTagName TVarChar
             , PaidKindId TVarChar, PaidKindName TVarChar
             , BusinessName TVarChar
             , BranchName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar

             , OperCount_total          TFloat  -- вес склад (итог: с потерями и скидкой)
             , OperCount_real           TFloat  -- вес склад
             , OperCount_110000_A       TFloat  -- вес склад транзит приход
             , OperCount_110000_P       TFloat  -- вес склад транзит расход
             , OperCount                TFloat  -- *вес склад (по дате покупателя, т.е. информативно)

             , OperCount_Change          TFloat  -- *вес Скидка за вес (по дате склада, т.е. информативно)
             , OperCount_Change_110000_A TFloat  -- *вес Скидка за вес транзит приход (по дате склада, т.е. информативно)
             , OperCount_Change_110000_P TFloat  -- *вес Скидка за вес транзит расход (по дате склада, т.е. информативно)
             , OperCount_Change_real     TFloat  -- вес Скидка за вес (по дате покупателя, т.е. факт)

             , OperCount_40200          TFloat  -- *вес Разница в весе (по дате склада, т.е. информативно)
             , OperCount_40200_110000_A TFloat  -- *вес Разница в весе транзит приход (по дате склада, т.е. информативно)
             , OperCount_40200_110000_P TFloat  -- *вес Разница в весе транзит расход (по дате склада, т.е. информативно)
             , OperCount_40200_real     TFloat  -- вес Разница в весе (по дате покупателя, т.е. факт)

             , OperCount_Loss           TFloat  -- !!!Кол-во!!! списание
             , SummIn_Loss              TFloat  -- филиальная (для подразделений завода здесь заводская)
             , SummIn_Loss_zavod        TFloat  -- к филиальной добавили заводскую

             , OperCount_Partner          TFloat  -- *вес покупателя (по дате склада, т.е. информативно)
             , OperCount_Partner_110000_A TFloat  -- *вес покупателя транзит приход (по дате склада, т.е. информативно)
             , OperCount_Partner_110000_P TFloat  -- *вес покупателя транзит расход (по дате склада, т.е. информативно)
             , OperCount_Partner_real     TFloat  -- вес покупателя (по дате покупателя, т.е. факт)
             , OperCount_sh_Partner_real  TFloat  -- шт. покупателя (по дате покупателя, т.е. факт)

             , SummIn_branch_total          TFloat  -- склад (итог: с потерями и скидкой) Себестоимость филиальная (для подразделений завода здесь заводская)
             , SummIn_zavod_total           TFloat  -- склад (итог: с потерями и скидкой) Себестоимость к заводская
             , SummIn_branch_real           TFloat  -- склад Себестоимость филиальная (для подразделений завода здесь заводская)
             , SummIn_zavod_real            TFloat  -- склад Себестоимость к заводская
             , SummIn_110000_A              TFloat  -- склад Себестоимость транзит приход (филиальная + заводская)
             , SummIn_110000_P              TFloat  -- склад Себестоимость транзит расход (филиальная + заводская)
             , SummIn_branch                TFloat  -- *склад Себестоимость филиальная (для подразделений завода здесь заводская) + (по дате покупателя, т.е. информативно)
             , SummIn_zavod                 TFloat  -- *склад Себестоимость к заводская + (по дате покупателя, т.е. информативно)

             , SummIn_Change_branch         TFloat  -- *Скидка за вес Себестоимость филиальная (для подразделений завода здесь заводская) + (по дате склада, т.е. информативно)
             , SummIn_Change_zavod          TFloat  -- *Скидка за вес Себестоимость заводская + (по дате склада, т.е. информативно)
             , SummIn_Change_110000_A       TFloat  -- *Скидка за вес склад Себестоимость транзит приход (филиальная + заводская) + (по дате склада, т.е. информативно)
             , SummIn_Change_110000_P       TFloat  -- *Скидка за вес склад Себестоимость транзит расход (филиальная + заводская) + (по дате склада, т.е. информативно)
             , SummIn_Change_branch_real    TFloat  -- Скидка за вес Себестоимость филиальная (для подразделений завода здесь заводская) + (по дате покупателя, т.е. факт)
             , SummIn_Change_zavod_real     TFloat  -- Скидка за вес Себестоимость заводская + (по дате покупателя, т.е. факт)

             , SummIn_40200_branch          TFloat  -- *Разница в весе Себестоимость филиальная (для подразделений завода здесь заводская) + (по дате склада, т.е. информативно)
             , SummIn_40200_zavod           TFloat  -- *Разница в весе Себестоимость заводская + (по дате склада, т.е. информативно)
             , SummIn_40200_110000_A        TFloat  -- *Разница в весе склад Себестоимость транзит приход (филиальная + заводская) + (по дате склада, т.е. информативно)
             , SummIn_40200_110000_P        TFloat  -- *Разница в весе склад Себестоимость транзит расход (филиальная + заводская) + (по дате склада, т.е. информативно)
             , SummIn_40200_branch_real     TFloat  -- Разница в весе Себестоимость филиальная (для подразделений завода здесь заводская) + (по дате покупателя, т.е. факт)
             , SummIn_40200_zavod_real      TFloat  -- Разница в весе Себестоимость заводская + (по дате покупателя, т.е. факт)

             , SummIn_Partner_branch        TFloat  -- *Покупатель Себестоимость филиальная (для подразделений завода здесь заводская) + (по дате склада, т.е. информативно)
             , SummIn_Partner_zavod         TFloat  -- *Покупатель Себестоимость заводская + (по дате склада, т.е. информативно)
             , SummIn_Partner_110000_A      TFloat  -- *Покупатель Себестоимость транзит приход (филиальная + заводская) + (по дате склада, т.е. информативно)
             , SummIn_Partner_110000_P      TFloat  -- *Покупатель Себестоимость транзит расход (филиальная + заводская) + (по дате склада, т.е. информативно)
             , SummIn_Partner_branch_real   TFloat  -- Покупатель Себестоимость филиальная (для подразделений завода здесь заводская) + (по дате покупателя, т.е. факт)
             , SummIn_Partner_zavod_real    TFloat  -- Покупатель Себестоимость заводская + (по дате покупателя, т.е. факт)

             , SummOut_PriceList            TFloat  -- *сумма По прайсу (по дате склада, т.е. информативно)
             , SummOut_PriceList_110000_A   TFloat  -- *сумма По прайсу транзит приход (по дате склада, т.е. информативно)
             , SummOut_PriceList_110000_P   TFloat  -- *сумма По прайсу транзит расход (по дате склада, т.е. информативно)
             , SummOut_PriceList_real       TFloat  -- сумма По прайсу (по дате покупателя, т.е. факт)

             , SummOut_Diff                 TFloat  -- *Разница с оптовыми ценами (по дате склада, т.е. информативно)
             , SummOut_Diff_110000_A        TFloat  -- *Разница с оптовыми ценами транзит приход (по дате склада, т.е. информативно)
             , SummOut_Diff_110000_P        TFloat  -- *Разница с оптовыми ценами транзит расход (по дате склада, т.е. информативно)
             , SummOut_Diff_real            TFloat  -- Разница с оптовыми ценами (по дате покупателя, т.е. факт)

             , SummOut_Promo                TFloat  -- *Скидка Акция (по дате склада, т.е. информативно)
             , SummOut_Promo_110000_A       TFloat  -- *Скидка Акция транзит приход (по дате склада, т.е. информативно)
             , SummOut_Promo_110000_P       TFloat  -- *Скидка Акция транзит расход (по дате склада, т.е. информативно)
             , SummOut_Promo_real           TFloat  -- Скидка Акция (по дате покупателя, т.е. факт)

             , SummOut_Change               TFloat  -- *Скидка дополнительная (по дате склада, т.е. информативно)
             , SummOut_Change_110000_A      TFloat  -- *Скидка дополнительная транзит приход (по дате склада, т.е. информативно)
             , SummOut_Change_110000_P      TFloat  -- *Скидка дополнительная транзит расход (по дате склада, т.е. информативно)
             , SummOut_Change_real          TFloat  -- Скидка дополнительная (по дате покупателя, т.е. факт)

             , SummOut_Partner              TFloat  -- *Покупатель сумма (по дате склада, т.е. информативно)
             , SummOut_Partner_110000_A     TFloat  -- *Покупатель сумма транзит приход (по дате склада, т.е. информативно)
             , SummOut_Partner_110000_P     TFloat  -- *Покупатель сумма транзит расход (по дате склада, т.е. информативно)
             , SummOut_Partner_real         TFloat  -- Покупатель сумма (по дате покупателя, т.е. факт)

             , SummProfit_branch            TFloat  --
             , SummProfit_zavod             TFloat  --
             , SummProfit_branch_real       TFloat  --
             , SummProfit_zavod_real        TFloat  --
             , PriceIn_branch               TFloat  --
             , PriceIn_zavod                TFloat  --
             , PriceOut_Partner             TFloat  --
             , PriceList_Partner            TFloat  --
             , Tax_branch                   TFloat  --
             , Tax_zavod                    TFloat  --    
             
             , OperCount_del     TFloat
             , OperCount_sh_del  TFloat

             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , InfoMoneyGroupName_goods TVarChar, InfoMoneyDestinationName_goods TVarChar, InfoMoneyCode_goods Integer, InfoMoneyName_goods TVarChar
             , OperDate          TDateTime
             , OperDatePartner   TDateTime 
             , ReasonName TVarChar --причина возврата 
             , SubjectDocName TVarChar
             )
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

      -- !!!Только просмотр Аудитор!!!
      PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     /*IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- таблица -
         CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitId_by Integer, isActive Boolean) ON COMMIT DROP;
     END IF;*/


    -- Результат
    RETURN QUERY

     WITH -- Ограничения по товару
          _tmpGoods AS -- (GoodsId, InfoMoneyId, TradeMarkId, MeasureId, Weight)
          (SELECT lfSelect.GoodsId, COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, 0) AS InfoMoneyId, COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) AS TradeMarkId
                , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                , ObjectFloat_Weight.ValueData           AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = lfSelect.GoodsId
                                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = lfSelect.GoodsId
                                    AND ObjectLink_Goods_TradeMark.DescId   = zc_ObjectLink_Goods_TradeMark()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE inGoodsGroupId <> 0
        UNION
           SELECT Object.Id AS GoodsId, COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, 0) AS InfoMoneyId, COALESCE (ObjectLink_Goods_TradeMark.ChildObjectId, 0) AS TradeMarkId
                , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                , ObjectFloat_Weight.ValueData           AS Weight
           FROM Object
                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = Object.Id
                                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                     ON ObjectLink_Goods_TradeMark.ObjectId = Object.Id
                                    AND ObjectLink_Goods_TradeMark.DescId   = zc_ObjectLink_Goods_TradeMark()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object.Id
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object.DescId = zc_Object_Goods()
             AND COALESCE (inGoodsGroupId, 0) = 0
        UNION
           SELECT Object.Id AS GoodsId, 0 AS InfoMoneyId, 0 AS TradeMarkId
                , 0 AS MeasureId
                , 0 AS Weight
           FROM Object
           WHERE Object.DescId = zc_Object_Asset()
             AND COALESCE (inGoodsGroupId, 0) = 0
         UNION
           SELECT Object.Id AS GoodsId, 0 AS InfoMoneyId, 0 AS TradeMarkId, 0 AS MeasureId, 0 AS Weight FROM Object WHERE Object.DescId = zc_Object_Fuel()
         )

    -- , tmpBranch AS (SELECT TRUE AS Value WHERE 1 = 0 AND NOT EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0))
    , _tmpUnit AS
          (-- группа подразделений
           SELECT lfSelect_Object_Unit_byGroup.UnitId AS UnitId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
           WHERE inUnitGroupId <> 0 AND COALESCE (inUnitId, 0) = 0

          UNION
           -- Подразделение
           SELECT Object.Id AS UnitId
           FROM Object
           WHERE Object.Id = inUnitId
             -- AND COALESCE (inUnitGroupId, 0) = 0

          UNION
           -- или место учета (МО, Авто)
           SELECT Object.Id AS UnitId FROM Object WHERE Object.DescId = zc_Object_Unit() AND COALESCE (inUnitGroupId, 0) = 0 AND COALESCE (inUnitId, 0) = 0
          UNION
           SELECT Object.Id AS UnitId FROM Object  WHERE Object.DescId = zc_Object_Member() AND COALESCE (inUnitGroupId, 0) = 0 AND COALESCE (inUnitId, 0) = 0
          UNION
           SELECT Object.Id AS UnitId FROM Object  WHERE Object.DescId = zc_Object_Car() AND COALESCE (inUnitGroupId, 0) = 0 AND COALESCE (inUnitId, 0) = 0
          )

         --
       , tmpAnalyzer AS (SELECT AnalyzerId, isSale, isCost, isSumm, FALSE AS isLoss
                         FROM Constant_ProfitLoss_AnalyzerId_View
                         WHERE DescId = zc_Object_AnalyzerId()
                           AND ((isSale = TRUE AND inDescId = zc_Movement_Sale()) OR (isSale = FALSE AND inDescId = zc_Movement_ReturnIn()))
                        UNION
                         SELECT zc_Enum_AnalyzerId_LossCount_20200() AS AnalyzerId -- Кол-во, списание при реализации/перемещении по цене
                              , FALSE AS isSale, FALSE AS isCost, FALSE AS isSumm, TRUE AS isLoss
                        UNION
                         SELECT zc_Enum_AnalyzerId_LossSumm_20200() AS AccountId --  Сумма с/с, списание при реализации/перемещении по цене
                              , FALSE AS isSale, TRUE AS isCost, FALSE AS isSumm, TRUE AS isLoss
                        )
        , tmpAccount AS (SELECT Object_Account_View.AccountGroupId, Object_Account_View.AccountId
                         FROM Object_Account_View
                         WHERE Object_Account_View.AccountGroupId IN (zc_Enum_AccountGroup_60000()  -- Прибыль будущих периодов
                                                                    , zc_Enum_AccountGroup_110000() -- Транзит
                                                                     )
                        UNION
                         SELECT 0 AS AccountGroupId, zc_Enum_AnalyzerId_SummIn_110101() AS AccountId -- Сумма, забалансовый счет, приход транзит, хотя поле пишется в AccountId, при этом ContainerId - стандартный и в нем другой AccountId
                        UNION
                         SELECT 0 AS AccountGroupId, zc_Enum_AnalyzerId_SummOut_110101() AS AccountId -- Сумма, забалансовый счет, расходтранзит, хотя поле пишется в AccountId, при этом ContainerId - стандартный и в нем другой AccountId
                        )

        --выбор удаленных документов  inIsErased = True
        , tmpMovementErased AS (
                                SELECT tmp.OperDate
                                     , tmp.StatusCode
                                     , tmp.UnitId   AS LocationId
                                     , tmp.FromId   AS PartnerId 
                                     , tmp.JuridicalId
                                     , tmp.PaidKindId
                                     , tmp.GoodsId
                                     , tmp.GoodsKindId 
                                     , tmp.InfoMoneyId_goods
                                     , tmp.OperCount
                                     , tmp.OperCount_sh  
                                     , tmp.ReasonName
                                     , tmp.SubjectDocName
                                FROM (SELECT tmpMovement.UnitId
                                           , tmpMovement.FromId
                                           , tmpMovement.JuridicalId
                                           , CASE WHEN inIsDate = TRUE THEN tmpMovement.OperDate ELSE NULL END AS OperDate 
                                           , Object_Status.ObjectCode AS StatusCode 
                                           , tmpMovement.PaidKindId
                                           , CASE WHEN inIsGoods = TRUE THEN MovementItem.ObjectId ELSE 0 END AS GoodsId
                                           , CASE WHEN inIsGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ELSE NULL END AS GoodsKindId 
                                           , _tmpGoods.InfoMoneyId AS InfoMoneyId_goods
                                           , SUM (COALESCE (MovementItem.Amount,0) * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS OperCount
                                           , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MovementItem.Amount,0) ELSE 0 END) AS OperCount_sh    
                                           
                                           --причина возврата
                                           , STRING_AGG (DISTINCT Object_Reason.ValueData, '; ')     ::TVarChar AS ReasonName
                                           , STRING_AGG (DISTINCT Object_SubjectDoc.ValueData, '; ')  ::TVarChar AS SubjectDocName

                                      FROM (SELECT Movement.*
                                                 , MovementLinkObject_To.ObjectId   AS UnitId
                                                 , MovementLinkObject_From.ObjectId AS FromId
                                                 , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                                 , MovementLinkObject_PaidKind.ObjectId AS PaidKindId
                                            FROM Movement 
                                             INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = CASE WHEN inDescId = zc_Movement_ReturnIn() THEN MovementLinkObject_To.ObjectId ELSE zc_MovementLinkObject_From() END

                                             INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_To.ObjectId

                                             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                  ON ObjectLink_Partner_Juridical.ObjectId = CASE WHEN inDescId = zc_Movement_ReturnIn() THEN MovementLinkObject_From.ObjectId ELSE zc_MovementLinkObject_To() END
                                                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                             
                                             LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                          ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                                         AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                                            WHERE inIsErased = TRUE
                                              AND Movement.DescId = inDescId
                                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                              AND Movement.StatusId = zc_Enum_Status_Erased()
                                              AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                                              AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
                                            ) AS tmpMovement
                                           INNER JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement.StatusId
                                           INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                                  AND MovementItem.isErased = FALSE
                                                                  AND MovementItem.DescId = zc_MI_Master()
                                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

                                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                                                        ON MovementLinkObject_SubjectDoc.MovementId = tmpMovement.Id
                                                                       AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
                                                                       AND inDescId = zc_Movement_ReturnIn()
                     
                                           LEFT JOIN MovementItem AS MI_Detail ON MI_Detail.ParentId = MovementItem.Id
                                                                 AND MI_Detail.DescId   = zc_MI_Detail()
                                                                 AND MovementItem.isErased = FALSE  
                                                                 AND inDescId = zc_Movement_ReturnIn()
                                           LEFT JOIN MovementItemLinkObject AS MILO_Reason
                                                                            ON MILO_Reason.MovementItemId = MI_Detail.Id
                                                                           AND MILO_Reason.DescId = zc_MILinkObject_Reason()
                                           LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = MILO_Reason.ObjectId
                     
                                           LEFT JOIN MovementItemLinkObject AS MILO_SubjectDoc
                                                                            ON MILO_SubjectDoc.MovementItemId = MovementItem.Id
                                                                           AND MILO_SubjectDoc.DescId = zc_MILinkObject_SubjectDoc()
                                           LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = COALESCE (MILO_SubjectDoc.ObjectId, MovementLinkObject_SubjectDoc.ObjectId)

                                      GROUP BY tmpMovement.UnitId
                                           , tmpMovement.FromId
                                           , CASE WHEN inIsDate = TRUE THEN tmpMovement.OperDate ELSE NULL END
                                           , Object_Status.ObjectCode
                                           , CASE WHEN inIsGoods = TRUE THEN MovementItem.ObjectId ELSE 0 END
                                           , CASE WHEN inIsGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ELSE NULL END
                                           , tmpMovement.PaidKindId
                                           , _tmpGoods.InfoMoneyId 
                                           , tmpMovement.JuridicalId
                                      ) AS tmp
                                )
        

       -- Результат
      SELECT Object_GoodsGroup.Id                    AS GoodsGroupId
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.Id                            AS GoodsId
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName
         , Object_TradeMark.ValueData                 AS TradeMarkName
         , Object_PartionGoods.ValueData              AS PartionGoods

         , Object_Location.Id         AS LocationId
         , Object_Location.ObjectCode AS LocationCode
         , Object_Location.ValueData  AS LocationName

         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName

         , Object_Partner.Id            AS PartnerId
         , Object_Partner.ObjectCode    AS PartnerCode
         , Object_Partner.ValueData     AS PartnerName

         , Object_Retail.ValueData     AS RetailName
         , Object_Area.ValueData       AS AreaName
         , Object_PartnerTag.ValueData AS PartnerTagName

         , Object_PaidKind.Id :: TVarChar AS PaidKindId
         , Object_PaidKind.ValueData      AS PaidKindName
         , Object_Business.ValueData      AS BusinessName
         , Object_Branch.ValueData        AS BranchName

         , Object_Contract.Id             AS ContractId
         , Object_Contract.ObjectCode     AS ContractCode
         , Object_Contract.ValueData      AS ContractName

           -- 1.1. вес, без AnalyzerId, т.е. это со склада, на транзит, с транзита
         , (tmpOperationGroup.OperCount_real) :: TFloat AS OperCount_total
         , ((tmpOperationGroup.OperCount_real     - tmpOperationGroup.OperCount_Change          + tmpOperationGroup.OperCount_40200          * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END)) :: TFloat AS OperCount_real
         , ((tmpOperationGroup.OperCount_110000_A - tmpOperationGroup.OperCount_Change_110000_A + tmpOperationGroup.OperCount_40200_110000_A * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END)) :: TFloat AS OperCount_110000_A
         , ((tmpOperationGroup.OperCount_110000_P - tmpOperationGroup.OperCount_Change_110000_P + tmpOperationGroup.OperCount_40200_110000_P * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END)) :: TFloat AS OperCount_110000_P
         , ((tmpOperationGroup.OperCount          - tmpOperationGroup.OperCount_Change_real     + tmpOperationGroup.OperCount_40200_real     * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END)) :: TFloat AS OperCount

           -- 2.1. вес - Скидка за вес
         , (tmpOperationGroup.OperCount_Change)          :: TFloat AS OperCount_Change
         , (tmpOperationGroup.OperCount_Change_110000_A) :: TFloat AS OperCount_Change_110000_A
         , (tmpOperationGroup.OperCount_Change_110000_P) :: TFloat AS OperCount_Change_110000_P
         , (tmpOperationGroup.OperCount_Change_real)     :: TFloat AS OperCount_Change_real

           -- 3.1. Кол-во Разница в весе
         , (tmpOperationGroup.OperCount_40200)          :: TFloat AS OperCount_40200
         , (tmpOperationGroup.OperCount_40200_110000_A) :: TFloat AS OperCount_40200_110000_A
         , (tmpOperationGroup.OperCount_40200_110000_P) :: TFloat AS OperCount_40200_110000_P
         , (tmpOperationGroup.OperCount_40200_real)     :: TFloat AS OperCount_40200_real

           -- 4.1. Кол-во списание
         , tmpOperationGroup.OperCount_Loss :: TFloat AS OperCount_Loss
           -- 4.2. Себестоимость - списание
         , tmpOperationGroup.SummIn_Loss                                          :: TFloat AS SummIn_Loss        -- филиальная (для подразделений завода здесь заводская)
         , (tmpOperationGroup.SummIn_Loss + tmpOperationGroup.SummIn_Loss_60000)  :: TFloat AS SummIn_Loss_zavod  -- к филиальной добавили заводскую

           -- 5.1. Кол-во у покупателя
         , (tmpOperationGroup.OperCount_Partner)          :: TFloat AS OperCount_Partner
         , (tmpOperationGroup.OperCount_Partner_110000_A) :: TFloat AS OperCount_Partner_110000_A
         , (tmpOperationGroup.OperCount_Partner_110000_P) :: TFloat AS OperCount_Partner_110000_P
         , (tmpOperationGroup.OperCount_Partner_real)     :: TFloat AS OperCount_Partner_real
         , tmpOperationGroup.OperCount_sh_Partner_real    :: TFloat AS OperCount_sh_Partner_real

           -- 1.2. Себестоимость, без AnalyzerId, т.е. филиальная + заводская и это со склада, на транзит, с транзита (!!!в транзите филиальной нет!!!)
         , (tmpOperationGroup.SummIn_real)                                        :: TFloat AS SummIn_branch_total  -- склад (итог: с потерями и скидкой) Себестоимость филиальная (для подразделений завода здесь заводская)
         , (tmpOperationGroup.SummIn_real + tmpOperationGroup.SummIn_60000)       :: TFloat AS SummIn_zavod_total   -- склад (итог: с потерями и скидкой) Себестоимость к заводская

         , (tmpOperationGroup.SummIn_real  - tmpOperationGroup.SummIn_Change       + tmpOperationGroup.SummIn_40200       * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END) :: TFloat AS SummIn_branch_real   -- филиальная (для подразделений завода здесь заводская)
         , (tmpOperationGroup.SummIn_real  - tmpOperationGroup.SummIn_Change       + tmpOperationGroup.SummIn_40200       * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END
          + tmpOperationGroup.SummIn_60000 - tmpOperationGroup.SummIn_Change_60000 + tmpOperationGroup.SummIn_40200_60000 * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END) :: TFloat AS SummIn_zavod_real    -- к филиальной добавили заводскую

         , (tmpOperationGroup.SummIn_110000_A + tmpOperationGroup.SummIn_60000_A) :: TFloat AS SummIn_110000_A -- здесь уже филиальная + заводская
         , (tmpOperationGroup.SummIn_110000_P + tmpOperationGroup.SummIn_60000_P) :: TFloat AS SummIn_110000_P -- здесь уже филиальная + заводская
         , (tmpOperationGroup.SummIn - tmpOperationGroup.SummIn_60000 + tmpOperationGroup.SummIn_60000_A - tmpOperationGroup.SummIn_60000_P) :: TFloat AS SummIn_branch   -- филиальная (для подразделений завода здесь заводская)
         , (tmpOperationGroup.SummIn)                                             :: TFloat AS SummIn_zavod    -- к филиальной добавили заводскую

           -- 2.2. Себестоимость - Скидка за вес
         , tmpOperationGroup.SummIn_Change                                                :: TFloat AS SummIn_Change_branch  --
         , (tmpOperationGroup.SummIn_Change + tmpOperationGroup.SummIn_Change_60000)      :: TFloat AS SummIn_Change_zavod   -- филиальная (для подразделений завода здесь заводская)
         , tmpOperationGroup.SummIn_Change_110000_A                                       :: TFloat AS SummIn_Change_110000_A -- здесь уже филиальная + заводская
         , tmpOperationGroup.SummIn_Change_110000_P                                       :: TFloat AS SummIn_Change_110000_P -- здесь уже филиальная + заводская
         , (tmpOperationGroup.SummIn_Change_real - tmpOperationGroup.SummIn_Change_60000) :: TFloat AS SummIn_Change_branch_real  --
         , (tmpOperationGroup.SummIn_Change_real)                                         :: TFloat AS SummIn_Change_zavod_real   -- филиальная (для подразделений завода здесь заводская)

           -- 3.2. Себестоимость - Разница в весе
         , tmpOperationGroup.SummIn_40200                                                :: TFloat AS SummIn_40200_branch  --
         , (tmpOperationGroup.SummIn_40200 + tmpOperationGroup.SummIn_40200_60000)       :: TFloat AS SummIn_40200_zavod   -- филиальная (для подразделений завода здесь заводская)
         , tmpOperationGroup.SummIn_40200_110000_A                                       :: TFloat AS SummIn_40200_110000_A -- здесь уже филиальная + заводская
         , tmpOperationGroup.SummIn_40200_110000_P                                       :: TFloat AS SummIn_40200_110000_P -- здесь уже филиальная + заводская
         , (tmpOperationGroup.SummIn_40200_real - tmpOperationGroup.SummIn_40200_60000)  :: TFloat AS SummIn_40200_branch_real  --
         , (tmpOperationGroup.SummIn_40200_real)                                         :: TFloat AS SummIn_40200_zavod_real   -- филиальная (для подразделений завода здесь заводская)

           -- 5.2. Себестоимость у покупателя
         , tmpOperationGroup.SummIn_Partner                                                       :: TFloat AS SummIn_Partner_branch   -- филиальная (для подразделений завода здесь заводская)
         , (tmpOperationGroup.SummIn_Partner + tmpOperationGroup.SummIn_Partner_60000)            :: TFloat AS SummIn_Partner_zavod    -- к филиальной добавили заводскую
         , (tmpOperationGroup.SummIn_Partner_110000_A + tmpOperationGroup.SummIn_Partner_60000_A) :: TFloat AS SummIn_Partner_110000_A -- здесь уже филиальная + заводская
         , (tmpOperationGroup.SummIn_Partner_110000_P + tmpOperationGroup.SummIn_Partner_60000_P) :: TFloat AS SummIn_Partner_110000_P -- здесь уже филиальная + заводская
         , (tmpOperationGroup.SummIn_Partner_real - tmpOperationGroup.SummIn_Partner_60000 + tmpOperationGroup.SummIn_Partner_60000_A - tmpOperationGroup.SummIn_Partner_60000_P) :: TFloat AS SummIn_Partner_branch_real   -- филиальная (для подразделений завода здесь заводская)
         , (tmpOperationGroup.SummIn_Partner_real)                                                :: TFloat AS SummIn_Partner_zavod_real    -- к филиальной добавили заводскую

           -- 5.3.1. Сумма у покупателя По прайсу
         -- , tmpOperationGroup.SummOut_PriceList                                               :: TFloat AS SummOut_PriceList
         , (tmpOperationGroup.SummOut_PriceList_real + tmpOperationGroup.SummOut_PriceList_110000_A - tmpOperationGroup.SummOut_PriceList_110000_P) :: TFloat AS SummOut_PriceList
         , tmpOperationGroup.SummOut_PriceList_110000_A                                      :: TFloat AS SummOut_PriceList_110000_A
         , tmpOperationGroup.SummOut_PriceList_110000_P                                      :: TFloat AS SummOut_PriceList_110000_P
         , tmpOperationGroup.SummOut_PriceList_real                                          :: TFloat AS SummOut_PriceList_real

           -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами
         -- , tmpOperationGroup.SummOut_Diff                                               :: TFloat AS SummOut_Diff
         , (tmpOperationGroup.SummOut_Diff_real + tmpOperationGroup.SummOut_Diff_110000_A - tmpOperationGroup.SummOut_Diff_110000_P) :: TFloat AS SummOut_Diff
         , tmpOperationGroup.SummOut_Diff_110000_A                                      :: TFloat AS SummOut_Diff_110000_A
         , tmpOperationGroup.SummOut_Diff_110000_P                                      :: TFloat AS SummOut_Diff_110000_P
         , tmpOperationGroup.SummOut_Diff_real                                          :: TFloat AS SummOut_Diff_real

           -- 5.3.3. Сумма у покупателя Скидка Акция
         -- , tmpOperationGroup.SummOut_Promo                                               :: TFloat AS SummOut_Promo
         , (tmpOperationGroup.SummOut_Promo_real + tmpOperationGroup.SummOut_Promo_110000_A - tmpOperationGroup.SummOut_Promo_110000_P) :: TFloat AS SummOut_Promo
         , tmpOperationGroup.SummOut_Promo_110000_A                                      :: TFloat AS SummOut_Promo_110000_A
         , tmpOperationGroup.SummOut_Promo_110000_P                                      :: TFloat AS SummOut_Promo_110000_P
         , tmpOperationGroup.SummOut_Promo_real                                          :: TFloat AS SummOut_Promo_real

           -- 5.3.4. Сумма у покупателя Скидка / Наценка дополнительная
         -- , tmpOperationGroup.SummOut_Change                                               :: TFloat AS SummOut_Change
         , (tmpOperationGroup.SummOut_Change_real + tmpOperationGroup.SummOut_Change_110000_A - tmpOperationGroup.SummOut_Change_110000_P) :: TFloat AS SummOut_Change
         , tmpOperationGroup.SummOut_Change_110000_A                                      :: TFloat AS SummOut_Change_110000_A
         , tmpOperationGroup.SummOut_Change_110000_P                                      :: TFloat AS SummOut_Change_110000_P
         , tmpOperationGroup.SummOut_Change_real                                          :: TFloat AS SummOut_Change_real

           -- 5.3.5. Сумма у покупателя
         , (tmpOperationGroup.SummOut_Partner_real + tmpOperationGroup.SummOut_Partner_110000_A - tmpOperationGroup.SummOut_Partner_110000_P) :: TFloat AS SummOut_Partner
         , tmpOperationGroup.SummOut_Partner_110000_A                                     :: TFloat AS SummOut_Partner_110000_A
         , tmpOperationGroup.SummOut_Partner_110000_P                                     :: TFloat AS SummOut_Partner_110000_P
         , tmpOperationGroup.SummOut_Partner_real                                         :: TFloat AS SummOut_Partner_real

           -- ***Прибыль
         , CAST ((tmpOperationGroup.SummOut_Partner_real + tmpOperationGroup.SummOut_Partner_110000_A - tmpOperationGroup.SummOut_Partner_110000_P)
                - tmpOperationGroup.SummIn_Partner
               * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END AS NUMERIC (16, 1)) :: TFloat AS SummProfit_branch
         , CAST ((tmpOperationGroup.SummOut_Partner_real + tmpOperationGroup.SummOut_Partner_110000_A - tmpOperationGroup.SummOut_Partner_110000_P)
               - (tmpOperationGroup.SummIn_Partner + tmpOperationGroup.SummIn_Partner_60000)
               * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END AS NUMERIC (16, 1)) :: TFloat AS SummProfit_zavod
           -- Прибыль
         , CAST ((tmpOperationGroup.SummOut_Partner_real - tmpOperationGroup.SummIn_Partner_real
                + tmpOperationGroup.SummIn_Partner_60000 - tmpOperationGroup.SummIn_Partner_60000_A + tmpOperationGroup.SummIn_Partner_60000_P)
               * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END AS NUMERIC (16, 1)) :: TFloat AS SummProfit_branch_real
         , CAST ((tmpOperationGroup.SummOut_Partner_real - tmpOperationGroup.SummIn_Partner_real) * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END AS NUMERIC (16, 1)) :: TFloat AS SummProfit_zavod_real

           -- Цена с/с
         , CAST (CASE WHEN tmpOperationGroup.OperCount_Partner_real <> 0 THEN (tmpOperationGroup.SummIn_Partner_real - tmpOperationGroup.SummIn_Partner_60000 + tmpOperationGroup.SummIn_Partner_60000_A - tmpOperationGroup.SummIn_Partner_60000_P) / tmpOperationGroup.OperCount_Partner_real ELSE 0 END AS NUMERIC (16, 1)) :: TFloat AS PriceIn_branch
         , CAST (CASE WHEN tmpOperationGroup.OperCount_Partner_real <> 0 THEN  tmpOperationGroup.SummIn_Partner_real                                           / tmpOperationGroup.OperCount_Partner_real ELSE 0 END AS NUMERIC (16, 1)) :: TFloat AS PriceIn_zavod

           -- Цена покупателя
         , CAST (CASE WHEN tmpOperationGroup.OperCount_Partner_real <> 0 THEN tmpOperationGroup.SummOut_Partner_real   / tmpOperationGroup.OperCount_Partner_real ELSE 0 END AS NUMERIC (16, 2)) :: TFloat AS PriceOut_Partner
         , CAST (CASE WHEN tmpOperationGroup.OperCount_Partner_real <> 0 THEN tmpOperationGroup.SummOut_PriceList_real / tmpOperationGroup.OperCount_Partner_real ELSE 0 END AS NUMERIC (16, 2)) :: TFloat AS PriceList_Partner

           -- % рент
         , CAST (CASE WHEN tmpOperationGroup.SummIn_Partner_real - tmpOperationGroup.SummIn_Partner_60000 + tmpOperationGroup.SummIn_Partner_60000_A - tmpOperationGroup.SummIn_Partner_60000_P = 0
                       AND tmpOperationGroup.SummOut_Partner_real > 0
                           THEN 100
                      WHEN tmpOperationGroup.SummIn_Partner_real - tmpOperationGroup.SummIn_Partner_60000 + tmpOperationGroup.SummIn_Partner_60000_A - tmpOperationGroup.SummIn_Partner_60000_P <> 0
                           THEN 100 * (tmpOperationGroup.SummOut_Partner_real
                                     - tmpOperationGroup.SummIn_Partner_real + tmpOperationGroup.SummIn_Partner_60000 - tmpOperationGroup.SummIn_Partner_60000_A + tmpOperationGroup.SummIn_Partner_60000_P)
                                    / (tmpOperationGroup.SummIn_Partner_real - tmpOperationGroup.SummIn_Partner_60000 + tmpOperationGroup.SummIn_Partner_60000_A - tmpOperationGroup.SummIn_Partner_60000_P)
                      ELSE 0
                 END AS NUMERIC (16, 1)) :: TFloat AS Tax_branch
           -- % рент
         , CAST (CASE WHEN tmpOperationGroup.SummIn_Partner_real = 0 AND tmpOperationGroup.SummOut_Partner_real > 0
                           THEN 100
                      WHEN tmpOperationGroup.SummIn_Partner_real <> 0
                           THEN 100 * (tmpOperationGroup.SummOut_Partner_real - tmpOperationGroup.SummIn_Partner_real) / tmpOperationGroup.SummIn_Partner_real
                      ELSE 0
                 END AS NUMERIC (16, 1)) :: TFloat AS Tax_zavod  
                 
         , 0 ::TFloat AS OperCount_del
         , 0 ::TFloat AS OperCount_sh_del

         , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
         , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

         , View_InfoMoney_Goods.InfoMoneyGroupName              AS InfoMoneyGroupName_goods
         , View_InfoMoney_Goods.InfoMoneyDestinationName        AS InfoMoneyDestinationName_goods
         , View_InfoMoney_Goods.InfoMoneyCode                   AS InfoMoneyCode_goods
         , View_InfoMoney_Goods.InfoMoneyName                   AS InfoMoneyName_goods

         , tmpOperationGroup.OperDate          ::TDateTime
         , tmpOperationGroup.OperDatePartner   ::TDateTime 
         
         , tmpOperationGroup.ReasonName     ::TVarChar
         , tmpOperationGroup.SubjectDocName ::TVarChar
     FROM (SELECT tmpContainer.LocationId
                , tmpContainer.OperDate
                , tmpContainer.OperDatePartner
                -- , tmpContainer.GoodsId
                , CASE WHEN inIsGoods = TRUE THEN tmpContainer.GoodsId ELSE 0 END AS GoodsId
                , tmpContainer.GoodsKindId
                , tmpContainer.PartnerId
                , tmpContainer.BusinessId
                , tmpContainer.BranchId  
                , CASE WHEN inIsContract = TRUE THEN ContainerLinkObject_Contract.ObjectId ELSE 0 END AS ContractId
                -- , tmpContainer.InfoMoneyId_goods
                -- , tmpContainer.TradeMarkId
                , _tmpGoods.InfoMoneyId AS InfoMoneyId_goods
                , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN _tmpGoods.TradeMarkId ELSE 0 END AS TradeMarkId

                , CASE WHEN inIsPartner = TRUE THEN COALESCE (ContainerLO_Juridical.ObjectId,  COALESCE (ContainerLO_Member.ObjectId, 0)) ELSE 0 END AS JuridicalId
                , CASE WHEN ContainerLO_Member.ObjectId > 0 THEN zc_Enum_PaidKind_SecondForm() ELSE COALESCE (ContainerLO_PaidKind.ObjectId, 0)  END AS PaidKindId
                , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                , CLO_PartionGoods.ObjectId              AS PartionGoodsId   
                
                --причина возврата
                , STRING_AGG (DISTINCT tmpContainer.ReasonName, '; ')     ::TVarChar AS ReasonName
                , STRING_AGG (DISTINCT tmpContainer.SubjectDocName, '; ') ::TVarChar AS SubjectDocName

                  -- 1.1. Кол-во, без AnalyzerId
                , SUM (tmpContainer.OperCount * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS OperCount
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.OperCount * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  /*CASE WHEN inDescId = zc_Movement_Sale() THEN TRUE  ELSE FALSE END*/ THEN tmpContainer.OperCount * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS OperCount_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE /*CASE WHEN inDescId = zc_Movement_Sale() THEN FALSE ELSE TRUE  END*/ THEN tmpContainer.OperCount * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END ELSE 0 END) AS OperCount_110000_P  -- меняется знак т.к. возврат
                  -- 1.2. Себестоимость, без AnalyzerId
                , SUM (tmpContainer.SummIn) AS SummIn
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.SummIn * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.SummIn * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END ELSE 0 END) AS SummIn_110000_P  -- меняется знак т.к. возврат
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  THEN tmpContainer.SummIn * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_60000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() THEN tmpContainer.SummIn * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END ELSE 0 END) AS SummIn_60000_P  -- меняется знак т.к. возврат

                  -- 1.3. Сумма, без AnalyzerId (на самом деле для OperCount_Partner)
                , SUM (tmpContainer.SummOut_Partner) AS SummOut_Partner_real
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = CASE WHEN inDescId = zc_Movement_Sale() THEN TRUE  ELSE FALSE END THEN tmpContainer.SummOut_Partner * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END ELSE 0 END) AS SummOut_Partner_110000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = CASE WHEN inDescId = zc_Movement_Sale() THEN FALSE ELSE TRUE  END THEN tmpContainer.SummOut_Partner * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummOut_Partner_110000_P  -- меняется знак т.к. возврат

                  -- 2.1. Кол-во - Скидка за вес
                , SUM (tmpContainer.OperCount_Change * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS OperCount_Change_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.OperCount_Change * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_Change
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.OperCount_Change * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS OperCount_Change_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.OperCount_Change * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END ELSE 0 END) AS OperCount_Change_110000_P  -- меняется знак т.к. возврат
                  -- 2.2. Себестоимость - Скидка за вес
                , SUM (tmpContainer.SummIn_Change) AS SummIn_Change_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.SummIn_Change * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_Change_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.SummIn_Change * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END ELSE 0 END) AS SummIn_Change_110000_P  -- меняется знак т.к. возврат

                  -- 3.1. Кол-во Разница в весе
                , SUM (tmpContainer.OperCount_40200 * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS OperCount_40200_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.OperCount_40200 * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_40200
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.OperCount_40200 * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS OperCount_40200_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.OperCount_40200 * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END ELSE 0 END) AS OperCount_40200_110000_P -- меняется знак т.к. возврат
                  -- 3.2. Себестоимость - Разница в весе
                , SUM (tmpContainer.SummIn_40200) AS SummIn_40200_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.SummIn_40200 * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_40200_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.SummIn_40200 * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END ELSE 0 END) AS SummIn_40200_110000_P  -- меняется знак т.к. возврат

                  -- 4.1. Кол-во списание
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.OperCount_Loss * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_Loss
                  -- 4.2. Себестоимость - списание
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Loss ELSE 0 END) AS SummIn_Loss
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_Loss ELSE 0 END) AS SummIn_Loss_60000

                  -- 5.1. Кол-во у покупателя
                , SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpContainer.OperCount_Partner ELSE 0 END)                    AS OperCount_sh_Partner_real
                , SUM (tmpContainer.OperCount_Partner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END) AS OperCount_Partner_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.OperCount_Partner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END ELSE 0 END) AS OperCount_Partner
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.OperCount_Partner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS OperCount_Partner_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.OperCount_Partner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END ELSE 0 END) AS OperCount_Partner_110000_P -- меняется знак т.к. возврат
                  -- 5.2. Себестоимость у покупателя
                , SUM (tmpContainer.SummIn_Partner) AS SummIn_Partner_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.SummIn_Partner * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_Partner_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.SummIn_Partner * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END ELSE 0 END) AS SummIn_Partner_110000_P -- меняется знак т.к. возврат
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  THEN tmpContainer.SummIn_Partner * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_Partner_60000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() THEN tmpContainer.SummIn_Partner * CASE WHEN inDescId = zc_Movement_Sale() THEN 1 ELSE -1 END ELSE 0 END) AS SummIn_Partner_60000_P -- меняется знак т.к. возврат

                  -- 5.3.1. Сумма у покупателя По прайсу
                , SUM (tmpContainer.SummOut_PriceList) AS SummOut_PriceList_real
                -- , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.SummOut_PriceList ELSE 0 END) AS SummOut_PriceList
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = CASE WHEN inDescId = zc_Movement_Sale() THEN TRUE  ELSE FALSE END THEN tmpContainer.SummOut_PriceList * CASE WHEN inDescId = zc_Movement_Sale() THEN  1 ELSE -1 END ELSE 0 END) AS SummOut_PriceList_110000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = CASE WHEN inDescId = zc_Movement_Sale() THEN FALSE ELSE TRUE  END THEN tmpContainer.SummOut_PriceList * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE  1 END ELSE 0 END) AS SummOut_PriceList_110000_P

                  -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами
                , SUM (tmpContainer.SummOut_Diff) AS SummOut_Diff_real
                -- , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.SummOut_Diff ELSE 0 END) AS SummOut_Diff
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = CASE WHEN inDescId = zc_Movement_Sale() THEN TRUE  ELSE FALSE END THEN tmpContainer.SummOut_Diff * CASE WHEN inDescId = zc_Movement_Sale() THEN  1 ELSE -1 END ELSE 0 END) AS SummOut_Diff_110000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = CASE WHEN inDescId = zc_Movement_Sale() THEN FALSE ELSE TRUE  END THEN tmpContainer.SummOut_Diff * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE  1 END ELSE 0 END) AS SummOut_Diff_110000_P

                  -- 5.3.3. Сумма у покупателя Скидка Акция
                , SUM (tmpContainer.SummOut_Promo) AS SummOut_Promo_real
                -- , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.SummOut_Promo ELSE 0 END) AS SummOut_Promo
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = CASE WHEN inDescId = zc_Movement_Sale() THEN TRUE  ELSE FALSE END THEN tmpContainer.SummOut_Promo * CASE WHEN inDescId = zc_Movement_Sale() THEN  1 ELSE -1 END ELSE 0 END) AS SummOut_Promo_110000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = CASE WHEN inDescId = zc_Movement_Sale() THEN FALSE ELSE TRUE  END THEN tmpContainer.SummOut_Promo * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE  1 END ELSE 0 END) AS SummOut_Promo_110000_P

                  -- 5.3.4. Сумма у покупателя Скидка дополнительная
                , SUM (tmpContainer.SummOut_Change) AS SummOut_Change_real
                -- , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.SummOut_Change ELSE 0 END) AS SummOut_Change
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = CASE WHEN inDescId = zc_Movement_Sale() THEN TRUE  ELSE FALSE END THEN tmpContainer.SummOut_Change * CASE WHEN inDescId = zc_Movement_Sale() THEN  1 ELSE -1 END ELSE 0 END) AS SummOut_Change_110000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = CASE WHEN inDescId = zc_Movement_Sale() THEN FALSE ELSE TRUE  END THEN tmpContainer.SummOut_Change * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE  1 END ELSE 0 END) AS SummOut_Change_110000_P

           FROM (SELECT MIContainer.WhereObjectId_analyzer  AS LocationId
                      , CASE WHEN inIsPartionGoods = TRUE THEN MIContainer.ContainerId          ELSE 0 END AS ContainerId
                      -- , CASE WHEN inIsGoods        = TRUE THEN MIContainer.ObjectId_analyzer    ELSE 0 END AS GoodsId
                      , MIContainer.ObjectId_analyzer AS GoodsId
                      , CASE WHEN inIsGoodsKind    = TRUE THEN MIContainer.ObjectIntId_analyzer ELSE 0 END AS GoodsKindId
                      , CASE WHEN inIsPartner      = TRUE THEN MIContainer.ObjectExtId_analyzer ELSE 0 END AS PartnerId
                      , MIContainer.ContainerId_analyzer
                      , MIContainer.ContainerIntId_analyzer
                      , MIContainer.isActive

                      , COALESCE (MIContainer.AccountId, 0) AS AccountId
                      , COALESCE (MLO_Business.ObjectId, 0) AS BusinessId
                      , COALESCE (MLO_Branch.ObjectId, 0)   AS BranchId
                      -- , _tmpGoods.InfoMoneyId AS InfoMoneyId_goods
                      -- , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN _tmpGoods.TradeMarkId ELSE 0 END AS TradeMarkId  
                      
                      , CASE WHEN inIsDate = TRUE THEN Movement.OperDate ELSE NULL END AS OperDate
                      , CASE WHEN inIsDate = TRUE THEN MIContainer.OperDate ELSE NULL END AS OperDatePartner

                        -- 1.1. Кол-во, без AnalyzerId
                      , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale()     AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossCount_20200() THEN -1 * MIContainer.Amount
                                  WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossCount_20200() THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount
                        -- 1.2. Себестоимость, без AnalyzerId
                      , SUM (CASE WHEN tmpAnalyzer.isCost = TRUE AND MIContainer.MovementDescId = zc_Movement_Sale()     AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossSumm_20200() THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.isCost = TRUE AND MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossSumm_20200() THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn
                        -- 1.3. Сумма, без AnalyzerId (на самом деле для OperCount_Partner)
                      , SUM (CASE WHEN tmpAnalyzer.isCost = FALSE AND MIContainer.MovementDescId = zc_Movement_Sale()     AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossSumm_20200() THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  WHEN tmpAnalyzer.isCost = FALSE AND MIContainer.MovementDescId = zc_Movement_ReturnIn() AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossSumm_20200() THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  ELSE 0
                             END) AS SummOut_Partner

                        -- 2.1. Кол-во - Скидка за вес
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_Change
                        -- 2.2. Себестоимость - Скидка за вес
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_Change

                        -- 3.1. Кол-во Разница в весе
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN 1 * MIContainer.Amount -- !!! для возврата со знаком - наоборот, т.к. приход!!!
                                  ELSE 0
                             END) AS OperCount_40200
                        -- 3.2. Себестоимость - Разница в весе
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() THEN 1 * MIContainer.Amount -- !!! для возврата со знаком - наоборот, т.к. приход!!!
                                  ELSE 0
                             END) AS SummIn_40200

                        -- 4.1. Кол-во списание
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() THEN -1 * MIContainer.Amount ELSE 0 END) AS OperCount_Loss
                        -- 4.2. Себестоимость - списание
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200()  THEN -1 * MIContainer.Amount ELSE 0 END) AS SummIn_Loss

                        -- 5.1. Кол-во у покупателя
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount
                                  WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_Partner
                        -- 5.2. Себестоимость у покупателя
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400()     THEN -1 * MIContainer.Amount
                                  WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_Partner
                        -- 5.3.1. Сумма у покупателя По прайсу
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100()     THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  ELSE 0
                             END) AS SummOut_PriceList
                        -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10200() THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  ELSE 0
                             END) AS SummOut_Diff
                        -- 5.3.3. Сумма у покупателя Скидка Акция
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10250()     THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  ELSE 0
                             END) AS SummOut_Promo
                        -- 5.3.4. Сумма у покупателя Скидка / Наценка дополнительная
                      , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  ELSE 0
                             END) AS SummOut_Change 
                       --причина возврата
                      , Object_Reason.ValueData     ::TVarChar AS ReasonName
                      , Object_SubjectDoc.ValueData ::TVarChar AS SubjectDocName 

                 FROM tmpAnalyzer
                      INNER JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                      INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                      --INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                      LEFT JOIN MovementItemLinkObject AS MLO_Business ON MLO_Business.MovementItemId = MIContainer.MovementItemId
                                                                      AND MLO_Business.DescId = zc_MILinkObject_Business()
                      LEFT JOIN MovementItemLinkObject AS MLO_Branch ON MLO_Branch.MovementItemId = MIContainer.MovementItemId
                                                                    AND MLO_Branch.DescId = zc_MILinkObject_Branch()

                      LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                                        AND inIsDate = TRUE

                      LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                                   ON MovementLinkObject_SubjectDoc.MovementId = MIContainer.MovementId
                                                  AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
                                                  AND inDescId = zc_Movement_ReturnIn()

                      LEFT JOIN MovementItem ON MovementItem.ParentId = MIContainer.MovementItemId
                                            AND MovementItem.DescId   = zc_MI_Detail()
                                            AND MovementItem.isErased = FALSE  
                                            AND inDescId = zc_Movement_ReturnIn()
                      LEFT JOIN MovementItemLinkObject AS MILO_Reason
                                                       ON MILO_Reason.MovementItemId = MovementItem.Id
                                                      AND MILO_Reason.DescId = zc_MILinkObject_Reason()
                      LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = MILO_Reason.ObjectId

                      LEFT JOIN MovementItemLinkObject AS MILO_SubjectDoc
                                                       ON MILO_SubjectDoc.MovementItemId = MovementItem.Id
                                                      AND MILO_SubjectDoc.DescId = zc_MILinkObject_SubjectDoc()
                      LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = COALESCE (MILO_SubjectDoc.ObjectId, MovementLinkObject_SubjectDoc.ObjectId)
                 GROUP BY MIContainer.WhereObjectId_analyzer
                        -- , CASE WHEN inIsGoods        = TRUE THEN MIContainer.ObjectId_analyzer    ELSE 0 END
                        , MIContainer.ObjectId_analyzer
                        , CASE WHEN inIsGoodsKind    = TRUE THEN MIContainer.ObjectIntId_analyzer ELSE 0 END
                        , CASE WHEN inIsPartner      = TRUE THEN MIContainer.ObjectExtId_analyzer ELSE 0 END
                        , CASE WHEN inIsPartionGoods = TRUE THEN MIContainer.ContainerId          ELSE 0 END
                        , MIContainer.ContainerId_analyzer
                        , MIContainer.ContainerIntId_analyzer
                        , MIContainer.AccountId
                        , MIContainer.isActive
                        , MLO_Business.ObjectId
                        , MLO_Branch.ObjectId
                        -- , _tmpGoods.InfoMoneyId
                        -- , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN _tmpGoods.TradeMarkId ELSE 0 END 
                      , CASE WHEN inIsDate = TRUE THEN Movement.OperDate ELSE NULL END
                      , CASE WHEN inIsDate = TRUE THEN MIContainer.OperDate ELSE NULL END
                      --, CASE WHEN inisReason = TRUE THEN Object_Reason.Id ELSE NULL END   -- свернуть в след. запросе
                      , Object_Reason.ValueData 
                      , Object_SubjectDoc.ValueData 
                      
                  ) AS tmpContainer
                      INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpContainer.GoodsId

                      LEFT JOIN tmpAccount ON tmpAccount.AccountId = tmpContainer.AccountId
                      LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                    ON CLO_PartionGoods.ContainerId = tmpContainer.ContainerIntId_analyzer
                                                   AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

                      LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                    ON ContainerLO_Juridical.ContainerId = tmpContainer.ContainerId_analyzer
                                                   AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                      LEFT JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                    ON ContainerLO_PaidKind.ContainerId =  tmpContainer.ContainerId_analyzer
                                                   AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                      LEFT JOIN ContainerLinkObject AS ContainerLO_Member
                                                    ON ContainerLO_Member.ContainerId =  tmpContainer.ContainerId_analyzer
                                                   AND ContainerLO_Member.DescId = zc_ContainerLinkObject_Member()
                      INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                     ON ContainerLinkObject_InfoMoney.ContainerId = tmpContainer.ContainerId_analyzer
                                                    AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                    AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)

                      LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Contract
                                                    ON ContainerLinkObject_Contract.ContainerId = tmpContainer.ContainerId_Analyzer
                                                   AND ContainerLinkObject_Contract.DescId = zc_ContainerLinkObject_Contract()
                                                   AND inIsContract = TRUE

                      WHERE (ContainerLO_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0)
                        AND (ContainerLO_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0 OR (ContainerLO_Member.ObjectId > 0 AND inPaidKindId = zc_Enum_PaidKind_SecondForm()))

                      GROUP BY tmpContainer.LocationId
                             -- , tmpContainer.GoodsId
                             , CASE WHEN inIsGoods = TRUE THEN tmpContainer.GoodsId ELSE 0 END
                             , tmpContainer.GoodsKindId
                             , tmpContainer.PartnerId
                             , tmpContainer.BusinessId
                             , tmpContainer.BranchId
                             , CASE WHEN inIsContract = TRUE THEN ContainerLinkObject_Contract.ObjectId ELSE 0 END
                             -- , tmpContainer.InfoMoneyId_goods
                             -- , tmpContainer.TradeMarkId
                             , _tmpGoods.InfoMoneyId
                             , CASE WHEN inIsTradeMark = TRUE OR inIsGoods = TRUE THEN _tmpGoods.TradeMarkId ELSE 0 END
                             , CASE WHEN ContainerLO_Member.ObjectId > 0 THEN zc_Enum_PaidKind_SecondForm() ELSE COALESCE (ContainerLO_PaidKind.ObjectId,0) END
                             , CASE WHEN inIsPartner = TRUE THEN COALESCE (ContainerLO_Juridical.ObjectId,  COALESCE (ContainerLO_Member.ObjectId, 0 )) ELSE 0 END
                             , CLO_PartionGoods.ObjectId
                             , ContainerLinkObject_InfoMoney.ObjectId
                             , tmpContainer.OperDate
                             , tmpContainer.OperDatePartner
                             , CASE WHEN inisReason = TRUE THEN tmpContainer.ReasonName ELSE NULL END
                    ) AS tmpOperationGroup

          LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpOperationGroup.LocationId
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpOperationGroup.PaidKindId
          LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmpOperationGroup.BusinessId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpOperationGroup.BranchId
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpOperationGroup.ContractId

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpOperationGroup.TradeMarkId
          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Goods ON View_InfoMoney_Goods.InfoMoneyId = tmpOperationGroup.InfoMoneyId_goods

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                              ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                              ON ObjectLink_Partner_PartnerTag.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
         LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId 
     UNION
      SELECT Object_GoodsGroup.Id                    AS GoodsGroupId
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.Id                            AS GoodsId
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName
         , Object_TradeMark.ValueData                 AS TradeMarkName
         , NULL ::TVarChar            AS PartionGoods

         , Object_Location.Id         AS LocationId
         , Object_Location.ObjectCode AS LocationCode
         , Object_Location.ValueData  AS LocationName

         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName

         , Object_Partner.Id            AS PartnerId
         , Object_Partner.ObjectCode    AS PartnerCode
         , Object_Partner.ValueData     AS PartnerName

         , Object_Retail.ValueData     AS RetailName
         , Object_Area.ValueData       AS AreaName
         , Object_PartnerTag.ValueData AS PartnerTagName

         , Object_PaidKind.Id :: TVarChar AS PaidKindId
         , Object_PaidKind.ValueData      AS PaidKindName
         , Object_Business.ValueData ::TVarChar     AS BusinessName   -- Object_Business.ValueData
         , Object_Branch.ValueData   ::TVarChar     AS BranchName     --Object_Branch.ValueData

         , Object_Contract.Id             AS ContractId
         , Object_Contract.ObjectCode     AS ContractCode
         , Object_Contract.ValueData      AS ContractName

           -- 1.1. вес, без AnalyzerId, т.е. это со склада, на транзит, с транзита
         , 0 :: TFloat AS OperCount_total
         , 0 :: TFloat AS OperCount_real
         , 0 :: TFloat AS OperCount_110000_A
         , 0 :: TFloat AS OperCount_110000_P
         , 0 :: TFloat AS OperCount

           -- 2.1. вес - Скидка за вес
         , 0 :: TFloat AS OperCount_Change
         , 0 :: TFloat AS OperCount_Change_110000_A
         , 0 :: TFloat AS OperCount_Change_110000_P
         , 0 :: TFloat AS OperCount_Change_real

           -- 3.1. Кол-во Разница в весе
         , 0 :: TFloat AS OperCount_40200
         , 0 :: TFloat AS OperCount_40200_110000_A
         , 0 :: TFloat AS OperCount_40200_110000_P
         , 0 :: TFloat AS OperCount_40200_real

           -- 4.1. Кол-во списание
         , 0 :: TFloat AS OperCount_Loss
           -- 4.2. Себестоимость - списание
         , 0  :: TFloat AS SummIn_Loss        -- филиальная (для подразделений завода здесь заводская)
         , 0  :: TFloat AS SummIn_Loss_zavod  -- к филиальной добавили заводскую

           -- 5.1. Кол-во у покупателя
         , 0 :: TFloat AS OperCount_Partner
         , 0 :: TFloat AS OperCount_Partner_110000_A
         , 0 :: TFloat AS OperCount_Partner_110000_P
         , 0 :: TFloat AS OperCount_Partner_real
         , 0 :: TFloat AS OperCount_sh_Partner_real

           -- 1.2. Себестоимость, без AnalyzerId, т.е. филиальная + заводская и это со склада, на транзит, с транзита (!!!в транзите филиальной нет!!!)
         , 0  :: TFloat AS SummIn_branch_total  -- склад (итог: с потерями и скидкой) Себестоимость филиальная (для подразделений завода здесь заводская)
         , 0  :: TFloat AS SummIn_zavod_total   -- склад (итог: с потерями и скидкой) Себестоимость к заводская

         , 0 :: TFloat AS SummIn_branch_real   -- филиальная (для подразделений завода здесь заводская)
         , 0 :: TFloat AS SummIn_zavod_real    -- к филиальной добавили заводскую

         , 0 :: TFloat AS SummIn_110000_A -- здесь уже филиальная + заводская
         , 0 :: TFloat AS SummIn_110000_P -- здесь уже филиальная + заводская
         , 0 :: TFloat AS SummIn_branch   -- филиальная (для подразделений завода здесь заводская)
         , 0 :: TFloat AS SummIn_zavod    -- к филиальной добавили заводскую

           -- 2.2. Себестоимость - Скидка за вес
         , 0 :: TFloat AS SummIn_Change_branch  --
         , 0 :: TFloat AS SummIn_Change_zavod   -- филиальная (для подразделений завода здесь заводская)
         , 0 :: TFloat AS SummIn_Change_110000_A -- здесь уже филиальная + заводская
         , 0 :: TFloat AS SummIn_Change_110000_P -- здесь уже филиальная + заводская
         , 0 :: TFloat AS SummIn_Change_branch_real  --
         , 0 :: TFloat AS SummIn_Change_zavod_real   -- филиальная (для подразделений завода здесь заводская)

           -- 3.2. Себестоимость - Разница в весе
         , 0  :: TFloat AS SummIn_40200_branch  --
         , 0  :: TFloat AS SummIn_40200_zavod   -- филиальная (для подразделений завода здесь заводская)
         , 0  :: TFloat AS SummIn_40200_110000_A -- здесь уже филиальная + заводская
         , 0  :: TFloat AS SummIn_40200_110000_P -- здесь уже филиальная + заводская
         , 0  :: TFloat AS SummIn_40200_branch_real  --
         , 0  :: TFloat AS SummIn_40200_zavod_real   -- филиальная (для подразделений завода здесь заводская)

           -- 5.2. Себестоимость у покупателя
         , 0 :: TFloat AS SummIn_Partner_branch   -- филиальная (для подразделений завода здесь заводская)
         , 0 :: TFloat AS SummIn_Partner_zavod    -- к филиальной добавили заводскую
         , 0 :: TFloat AS SummIn_Partner_110000_A -- здесь уже филиальная + заводская
         , 0 :: TFloat AS SummIn_Partner_110000_P -- здесь уже филиальная + заводская
         , 0 :: TFloat AS SummIn_Partner_branch_real   -- филиальная (для подразделений завода здесь заводская)
         , 0 :: TFloat AS SummIn_Partner_zavod_real    -- к филиальной добавили заводскую

           -- 5.3.1. Сумма у покупателя По прайсу
         , 0 :: TFloat AS SummOut_PriceList
         , 0 :: TFloat AS SummOut_PriceList_110000_A
         , 0 :: TFloat AS SummOut_PriceList_110000_P
         , 0 :: TFloat AS SummOut_PriceList_real

           -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами
         , 0 :: TFloat AS SummOut_Diff
         , 0  :: TFloat AS SummOut_Diff_110000_A
         , 0  :: TFloat AS SummOut_Diff_110000_P
         , 0  :: TFloat AS SummOut_Diff_real

           -- 5.3.3. Сумма у покупателя Скидка Акция
         , 0 :: TFloat AS SummOut_Promo
         , 0 :: TFloat AS SummOut_Promo_110000_A
         , 0 :: TFloat AS SummOut_Promo_110000_P
         , 0 :: TFloat AS SummOut_Promo_real

           -- 5.3.4. Сумма у покупателя Скидка / Наценка дополнительная
         , 0 :: TFloat AS SummOut_Change
         , 0 :: TFloat AS SummOut_Change_110000_A
         , 0 :: TFloat AS SummOut_Change_110000_P
         , 0 :: TFloat AS SummOut_Change_real

           -- 5.3.5. Сумма у покупателя
         , 0 :: TFloat AS SummOut_Partner
         , 0 :: TFloat AS SummOut_Partner_110000_A
         , 0 :: TFloat AS SummOut_Partner_110000_P
         , 0 :: TFloat AS SummOut_Partner_real

           -- ***Прибыль
         , 0 :: TFloat AS SummProfit_branch
         , 0 :: TFloat AS SummProfit_zavod
           -- Прибыль
         , 0 :: TFloat AS SummProfit_branch_real
         , 0 :: TFloat AS SummProfit_zavod_real

           -- Цена с/с
         , 0 :: TFloat AS PriceIn_branch
         , 0 :: TFloat AS PriceIn_zavod

           -- Цена покупателя
         , 0 :: TFloat AS PriceOut_Partner
         , 0 :: TFloat AS PriceList_Partner

           -- % рент
         , 0 :: TFloat AS Tax_branch
           -- % рент
         , 0 :: TFloat AS Tax_zavod

         , tmp.OperCount    ::TFloat AS OperCount_del
         , tmp.OperCount_sh ::TFloat AS OperCount_sh_del

         , Null ::TVarChar              AS InfoMoneyGroupName
         , Null ::TVarChar              AS InfoMoneyDestinationName
         , Null ::Integer               AS InfoMoneyCode
         , Null ::TVarChar              AS InfoMoneyName

         , View_InfoMoney_Goods.InfoMoneyGroupName              AS InfoMoneyGroupName_goods
         , View_InfoMoney_Goods.InfoMoneyDestinationName        AS InfoMoneyDestinationName_goods
         , View_InfoMoney_Goods.InfoMoneyCode                   AS InfoMoneyCode_goods
         , View_InfoMoney_Goods.InfoMoneyName                   AS InfoMoneyName_goods

         , tmp.OperDate          ::TDateTime
         , tmp.OperDate ::TDateTime AS OperDatePartner 
         
         , tmp.ReasonName     ::TVarChar
         , tmp.SubjectDocName ::TVarChar
      FROM tmpMovementErased AS tmp
          LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmp.LocationId
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmp.PartnerId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmp.JuridicalId

          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmp.PaidKindId       
          
         -- LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmpOperationGroup.BusinessId
         -- LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpOperationGroup.BranchId

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmp.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmp.GoodsKindId
          --LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmp.TradeMarkId
          --LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId
          --LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Goods ON View_InfoMoney_Goods.InfoMoneyId = tmp.InfoMoneyId_goods

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                               ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                               ON ObjectLink_Partner_PartnerTag.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
          LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId      
          
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                               ON ObjectLink_Unit_Business.ObjectId = Object_Location.Id
                              AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
          LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Unit_Business.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = Object_Location.Id
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

          INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                ON ObjectLink_Contract_Juridical.ChildObjectId = Object_Juridical.Id
                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_Contract_Juridical.ObjectId            
  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.04.25         - inIsContract
 02.08.15         * add inIsPartner, inIsTradeMark, inIsGoods, inIsGoodsKind, inIsPartionGoods
 27.07.14                                        * all
 22.07.15         *
 15.12.14                                        * all
 13.05.14                                        * all
 16.04.14         add inUnitId
 13.04.14                                        * add zc_MovementFloat_ChangePercent
 08.04.14                                        * all
 05.04.14         * add SummPartner_calc. AmountChangePercent
 04.02.14         *
 01.02.14                                        * All
 22.01.14         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI (inStartDate:= '01.11.2017', inEndDate:= '01.11.2017', inDescId:= 5, inJuridicalId:=0, inPaidKindId:=0, inInfoMoneyId:=0, inUnitGroupId:=0, inUnitId:= 8459, inGoodsGroupId:= 0, inIsPartner:= TRUE, inIsTradeMark:= TRUE, inIsGoods:= TRUE, inIsGoodsKind:= TRUE, inIsPartionGoods:= TRUE, inSession:= zfCalc_UserAdmin()); -- Склад Реализации

/*
SELECT * FROM gpReport_GoodsMI (inStartDate:= '18.06.2024', inEndDate:= '18.06.2024', inDescId:= zc_Movement_ReturnIn(), inJuridicalId:=0, inPaidKindId:=0, inInfoMoneyId:=0
, inUnitGroupId:=0, inUnitId:= 346094 , inGoodsGroupId:= 0, inIsPartner:= TRUE, inIsTradeMark:= TRUE, inIsGoods:= TRUE, inIsGoodsKind:= TRUE, inIsPartionGoods:= TRUE, inIsDate:= FALSE, inisReason:= false
, inIsErased := TRUE, inSession:= zfCalc_UserAdmin()); -- Склад Реализации

select * from gpReport_GoodsMI(inStartDate := ('09.04.2025')::TDateTime , inEndDate := ('09.04.2025')::TDateTime , inDescId := 5 , inJuridicalId := 0 , inPaidKindId := 0 
, inInfoMoneyId := 0 , inUnitGroupId := 0 , inUnitId := 8459 , inGoodsGroupId := 0 , inIsPartner := 'True' , inIsTradeMark := 'False' , inIsGoods := 'True' , inIsGoodsKind := 'False'
 , inIsPartionGoods := 'False' , inIsDate := 'False' , inisReason := 'False' , inIsErased := 'False' , inIsContract:= 'True',  inSession := '9457');
*/