-- Function: gpReport_GoodsMI ()
--SELECT * FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()

DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_GoodsMI (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inDescId            Integer   ,  --sale(продажа покупателю) = 5, returnin (возврат покупателя) = 6
    IN inGoodsGroupId      Integer   ,
    IN inUnitGroupId       Integer   ,
    IN inUnitId            Integer   ,
    IN inPaidKindId        Integer   ,
    IN inJuridicalId       Integer   ,
    IN inInfoMoneyId       Integer   ,
    IN inIsPartner         Boolean   , --
    IN inIsTradeMark       Boolean   , --
    IN inIsGoods           Boolean   , --
    IN inIsGoodsKind       Boolean   , --
    IN inIsPartionGoods    Boolean   , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , PartionGoods TVarChar
             , LocationCode Integer, LocationName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , PaidKindName TVarChar
             , BusinessName TVarChar
             , BranchName TVarChar

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
             , PriceIn_branch               TFloat  -- 
             , PriceIn_zavod                TFloat  -- 
             , PriceOut_Partner             TFloat  -- 
             , PriceList_Partner            TFloat  -- 
             , Tax_branch                   TFloat  -- 
             , Tax_zavod                    TFloat  -- 

             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , InfoMoneyGroupName_goods TVarChar, InfoMoneyDestinationName_goods TVarChar, InfoMoneyCode_goods Integer, InfoMoneyName_goods TVarChar
             ) 
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);
   
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    
  
    -- Ограничения по товару
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId
           FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods()
         UNION
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Fuel();
    END IF;

    

    -- группа подразделений или подразделение или место учета (МО, Авто)
    IF inUnitGroupId <> 0 AND COALESCE (inUnitId, 0) = 0
    THEN
        INSERT INTO _tmpUnit (UnitId)
           SELECT lfSelect_Object_Unit_byGroup.UnitId AS UnitId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup;
    ELSE
        IF inUnitId <> 0
        THEN
            INSERT INTO _tmpUnit (UnitId)
               SELECT Object.Id AS UnitId
               FROM Object
               WHERE Object.Id = inUnitId;
        ELSE
           WITH tmpBranch AS (SELECT TRUE AS Value WHERE 1 = 0 AND NOT EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0))
            INSERT INTO _tmpUnit (UnitId)
               /*SELECT Id FROM Object WHERE DescId = zc_Object_Unit()
              UNION ALL*/
               SELECT Id FROM Object  WHERE DescId = zc_Object_Member()
              UNION ALL
               SELECT Id FROM Object  WHERE DescId = zc_Object_Car();
              
        END IF;
    END IF;


   -- Результат
    RETURN QUERY
    WITH tmpAnalyzer AS (SELECT AnalyzerId, isSale, isCost, isSumm, FALSE AS isLoss
                         FROM Constant_ProfitLoss_AnalyzerId_View
                         WHERE (isSale = TRUE AND inDescId = zc_Movement_Sale()) OR (isSale = FALSE AND inDescId = zc_Movement_ReturnIn())
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
       SELECT Object_GoodsGroup.ValueData            AS GoodsGroupName 
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_GoodsKind.ValueData             AS GoodsKindName
         , Object_Measure.ValueData               AS MeasureName
         , Object_TradeMark.ValueData             AS TradeMarkName
         , CAST ('' AS TVarChar )                 AS PartionGoods

         , Object_Location.ObjectCode AS LocationCode
         , Object_Location.ValueData  AS LocationName

         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName

         , Object_Partner.Id           AS PartnerId
         , Object_Partner.ObjectCode   AS PartnerCode
         , Object_Partner.ValueData    AS PartnerName

         , Object_PaidKind.ValueData   AS PaidKindName
         , Object_Business.ValueData   AS BusinessName
         , Object_Branch.ValueData     AS BranchName

           -- 1.1. вес, без AnalyzerId, т.е. это со склада, на транзит, с транзита
         , ((tmpOperationGroup.OperCount_real     - tmpOperationGroup.OperCount_Change          + tmpOperationGroup.OperCount_40200)          * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_real
         , ((tmpOperationGroup.OperCount_110000_A - tmpOperationGroup.OperCount_Change_110000_A + tmpOperationGroup.OperCount_40200_110000_A) * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_110000_A
         , ((tmpOperationGroup.OperCount_110000_P - tmpOperationGroup.OperCount_Change_110000_P + tmpOperationGroup.OperCount_40200_110000_P) * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_110000_P
         , ((tmpOperationGroup.OperCount          - tmpOperationGroup.OperCount_Change_real     + tmpOperationGroup.OperCount_40200_real)     * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount

           -- 2.1. вес - Скидка за вес
         , (tmpOperationGroup.OperCount_Change          * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_Change
         , (tmpOperationGroup.OperCount_Change_110000_A * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_Change_110000_A
         , (tmpOperationGroup.OperCount_Change_110000_P * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_Change_110000_P
         , (tmpOperationGroup.OperCount_Change_real     * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_Change_real

           -- 3.1. Кол-во Разница в весе
         , (tmpOperationGroup.OperCount_40200          * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_40200
         , (tmpOperationGroup.OperCount_40200_110000_A * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_40200_110000_A
         , (tmpOperationGroup.OperCount_40200_110000_P * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_40200_110000_P
         , (tmpOperationGroup.OperCount_40200_real     * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_40200_real

           -- 4.1. Кол-во списание
         , tmpOperationGroup.OperCount_Loss :: TFloat AS OperCount_Loss
           -- 4.2. Себестоимость - списание
         , tmpOperationGroup.SummIn_Loss                                          :: TFloat AS SummIn_Loss        -- филиальная (для подразделений завода здесь заводская)
         , (tmpOperationGroup.SummIn_Loss + tmpOperationGroup.SummIn_Loss_60000)  :: TFloat AS SummIn_Loss_zavod  -- к филиальной добавили заводскую

           -- 5.1. Кол-во у покупателя
         , (tmpOperationGroup.OperCount_Partner          * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_Partner
         , (tmpOperationGroup.OperCount_Partner_110000_A * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_Partner_110000_A
         , (tmpOperationGroup.OperCount_Partner_110000_P * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_Partner_110000_P
         , (tmpOperationGroup.OperCount_Partner_real     * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS OperCount_Partner_real

           -- 1.2. Себестоимость, без AnalyzerId, т.е. филиальная + заводская и это со склада, на транзит, с транзита (!!!в транзите филиальной нет!!!)
         , (tmpOperationGroup.SummIn_real)                                        :: TFloat AS SummIn_branch_real   -- филиальная (для подразделений завода здесь заводская)
         , (tmpOperationGroup.SummIn_real + tmpOperationGroup.SummIn_60000)       :: TFloat AS SummIn_zavod_real    -- к филиальной добавили заводскую
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

           -- 5.3.3. Сумма у покупателя Скидка / Наценка дополнительная
         -- , tmpOperationGroup.SummOut_Change                                               :: TFloat AS SummOut_Change
         , (tmpOperationGroup.SummOut_Change_real + tmpOperationGroup.SummOut_Change_110000_A - tmpOperationGroup.SummOut_Change_110000_P) :: TFloat AS SummOut_Change
         , tmpOperationGroup.SummOut_Change_110000_A                                      :: TFloat AS SummOut_Change_110000_A
         , tmpOperationGroup.SummOut_Change_110000_P                                      :: TFloat AS SummOut_Change_110000_P
         , tmpOperationGroup.SummOut_Change_real                                          :: TFloat AS SummOut_Change_real

           -- 5.3.4. Сумма у покупателя
         , (tmpOperationGroup.SummOut_Partner_real + tmpOperationGroup.SummOut_Partner_110000_A - tmpOperationGroup.SummOut_Partner_110000_P) :: TFloat AS SummOut_Partner
         , tmpOperationGroup.SummOut_Partner_110000_A                                     :: TFloat AS SummOut_Partner_110000_A
         , tmpOperationGroup.SummOut_Partner_110000_P                                     :: TFloat AS SummOut_Partner_110000_P
         , tmpOperationGroup.SummOut_Partner_real                                         :: TFloat AS SummOut_Partner_real

         , CAST (tmpOperationGroup.SummOut_Partner_real - tmpOperationGroup.SummIn_Partner_real + tmpOperationGroup.SummIn_Partner_60000 - tmpOperationGroup.SummIn_Partner_60000_A + tmpOperationGroup.SummIn_Partner_60000_P AS NUMERIC (16, 1)) :: TFloat AS SummProfit_branch
         , CAST (tmpOperationGroup.SummOut_Partner_real - tmpOperationGroup.SummIn_Partner_real                                          AS NUMERIC (16, 1)) :: TFloat AS SummProfit_zavod

         , CAST (CASE WHEN tmpOperationGroup.OperCount_Partner_real <> 0 THEN (tmpOperationGroup.SummIn_Partner_real - tmpOperationGroup.SummIn_Partner_60000 + tmpOperationGroup.SummIn_Partner_60000_A - tmpOperationGroup.SummIn_Partner_60000_P) / tmpOperationGroup.OperCount_Partner_real ELSE 0 END AS NUMERIC (16, 1)) :: TFloat AS PriceIn_branch
         , CAST (CASE WHEN tmpOperationGroup.OperCount_Partner_real <> 0 THEN  tmpOperationGroup.SummIn_Partner_real                                           / tmpOperationGroup.OperCount_Partner_real ELSE 0 END AS NUMERIC (16, 1)) :: TFloat AS PriceIn_zavod

         , CAST (CASE WHEN tmpOperationGroup.OperCount_Partner_real <> 0 THEN tmpOperationGroup.SummOut_Partner_real   / tmpOperationGroup.OperCount_Partner_real ELSE 0 END AS NUMERIC (16, 2)) :: TFloat AS PriceOut_Partner
         , CAST (CASE WHEN tmpOperationGroup.OperCount_Partner_real <> 0 THEN tmpOperationGroup.SummOut_PriceList_real / tmpOperationGroup.OperCount_Partner_real ELSE 0 END AS NUMERIC (16, 2)) :: TFloat AS PriceList_Partner

         , CAST (CASE WHEN tmpOperationGroup.SummIn_Partner_real - tmpOperationGroup.SummIn_Partner_60000 + tmpOperationGroup.SummIn_Partner_60000_A - tmpOperationGroup.SummIn_Partner_60000_P = 0
                       AND tmpOperationGroup.SummOut_Partner_real > 0
                           THEN 100
                      WHEN tmpOperationGroup.SummIn_Partner_real - tmpOperationGroup.SummIn_Partner_60000 + tmpOperationGroup.SummIn_Partner_60000_A - tmpOperationGroup.SummIn_Partner_60000_P <> 0
                           THEN 100 * (tmpOperationGroup.SummOut_Partner_real
                                     - tmpOperationGroup.SummIn_Partner_real + tmpOperationGroup.SummIn_Partner_60000 - tmpOperationGroup.SummIn_Partner_60000_A + tmpOperationGroup.SummIn_Partner_60000_P)
                                    / (tmpOperationGroup.SummIn_Partner_real - tmpOperationGroup.SummIn_Partner_60000 + tmpOperationGroup.SummIn_Partner_60000_A - tmpOperationGroup.SummIn_Partner_60000_P)
                      ELSE 0
                 END AS NUMERIC (16, 1)) :: TFloat AS Tax_branch
         , CAST (CASE WHEN tmpOperationGroup.SummIn_Partner_real = 0 AND tmpOperationGroup.SummOut_Partner_real > 0
                           THEN 100
                      WHEN tmpOperationGroup.SummIn_Partner_real <> 0
                           THEN 100 * (tmpOperationGroup.SummOut_Partner_real - tmpOperationGroup.SummIn_Partner_real) / tmpOperationGroup.SummIn_Partner_real
                      ELSE 0
                 END AS NUMERIC (16, 1)) :: TFloat AS Tax_zavod

         , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
         , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

         , View_InfoMoney_Goods.InfoMoneyGroupName              AS InfoMoneyGroupName_goods
         , View_InfoMoney_Goods.InfoMoneyDestinationName        AS InfoMoneyDestinationName_goods
         , View_InfoMoney_Goods.InfoMoneyCode                   AS InfoMoneyCode_goods
         , View_InfoMoney_Goods.InfoMoneyName                   AS InfoMoneyName_goods

     FROM (SELECT tmpContainer.LocationId
                , tmpContainer.GoodsId
                , tmpContainer.GoodsKindId
                , tmpContainer.PartnerId
                , tmpContainer.BusinessId
                , tmpContainer.BranchId
                , COALESCE (ContainerLO_Juridical.ObjectId,  COALESCE (ContainerLO_Member.ObjectId, 0 )) AS JuridicalId
                , CASE WHEN ContainerLO_Member.ObjectId > 0 THEN zc_Enum_PaidKind_SecondForm() ELSE COALESCE (ContainerLO_PaidKind.ObjectId,0) END AS PaidKindId
                , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId

                  -- 1.1. Кол-во, без AnalyzerId
                , SUM (tmpContainer.OperCount) AS OperCount
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.OperCount ELSE 0 END) AS OperCount_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.OperCount * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS OperCount_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.OperCount ELSE 0 END) AS OperCount_110000_P
                  -- 1.2. Себестоимость, без AnalyzerId
                , SUM (tmpContainer.SummIn) AS SummIn
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.SummIn * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_110000_P
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  THEN tmpContainer.SummIn * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_60000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_60000_P

                  -- 1.3. Сумма, без AnalyzerId (на самом деле для OperCount_Partner)
                , SUM (tmpContainer.SummOut_Partner) AS SummOut_Partner_real
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = TRUE  THEN tmpContainer.SummOut_Partner ELSE 0 END) AS SummOut_Partner_110000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = FALSE THEN tmpContainer.SummOut_Partner * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummOut_Partner_110000_P

                  -- 2.1. Кол-во - Скидка за вес
                , SUM (tmpContainer.OperCount_Change) AS OperCount_Change_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.OperCount_Change ELSE 0 END) AS OperCount_Change
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.OperCount_Change * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS OperCount_Change_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.OperCount_Change ELSE 0 END) AS OperCount_Change_110000_P
                  -- 2.2. Себестоимость - Скидка за вес
                , SUM (tmpContainer.SummIn_Change) AS SummIn_Change_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.SummIn_Change * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_Change_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.SummIn_Change ELSE 0 END) AS SummIn_Change_110000_P

                  -- 3.1. Кол-во Разница в весе
                , SUM (tmpContainer.OperCount_40200) AS OperCount_40200_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.OperCount_40200 ELSE 0 END) AS OperCount_40200
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.OperCount_40200 * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS OperCount_40200_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.OperCount_40200 ELSE 0 END) AS OperCount_40200_110000_P
                  -- 3.2. Себестоимость - Разница в весе
                , SUM (tmpContainer.SummIn_40200) AS SummIn_40200_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.SummIn_40200 * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_40200_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.SummIn_40200 ELSE 0 END) AS SummIn_40200_110000_P

                  -- 4.1. Кол-во списание
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.OperCount_Loss ELSE 0 END) AS OperCount_Loss
                  -- 4.2. Себестоимость - списание
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Loss ELSE 0 END) AS SummIn_Loss
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_Loss ELSE 0 END) AS SummIn_Loss_60000

                  -- 5.1. Кол-во у покупателя
                , SUM (tmpContainer.OperCount_Partner) AS OperCount_Partner_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.OperCount_Partner ELSE 0 END) AS OperCount_Partner
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.OperCount_Partner * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS OperCount_Partner_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.OperCount_Partner ELSE 0 END) AS OperCount_Partner_110000_P
                  -- 5.2. Себестоимость у покупателя
                , SUM (tmpContainer.SummIn_Partner) AS SummIn_Partner_real
                , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL                         THEN tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_60000()  THEN tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner_60000
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = TRUE  THEN tmpContainer.SummIn_Partner * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_Partner_110000_A
                , SUM (CASE WHEN tmpAccount.AccountGroupId = zc_Enum_AccountGroup_110000() AND tmpContainer.isActive = FALSE THEN tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner_110000_P
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  THEN tmpContainer.SummIn_Partner * CASE WHEN inDescId = zc_Movement_Sale() THEN -1 ELSE 1 END ELSE 0 END) AS SummIn_Partner_60000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() THEN tmpContainer.SummIn_Partner ELSE 0 END) AS SummIn_Partner_60000_P

                  -- 5.3.1. Сумма у покупателя По прайсу
                , SUM (tmpContainer.SummOut_PriceList) AS SummOut_PriceList_real
                -- , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.SummOut_PriceList ELSE 0 END) AS SummOut_PriceList
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = TRUE THEN tmpContainer.SummOut_PriceList ELSE 0 END) AS SummOut_PriceList_110000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = TRUE THEN tmpContainer.SummOut_PriceList ELSE 0 END) AS SummOut_PriceList_110000_P
                  -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами
                , SUM (tmpContainer.SummOut_Diff) AS SummOut_Diff_real
                -- , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.SummOut_Diff ELSE 0 END) AS SummOut_Diff
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = TRUE THEN tmpContainer.SummOut_Diff ELSE 0 END) AS SummOut_Diff_110000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = TRUE THEN tmpContainer.SummOut_Diff ELSE 0 END) AS SummOut_Diff_110000_P
                  -- 5.3.3. Сумма у покупателя Скидка дополнительная
                , SUM (tmpContainer.SummOut_Change) AS SummOut_Change_real
                -- , SUM (CASE WHEN tmpAccount.AccountGroupId IS NULL THEN tmpContainer.SummOut_Change ELSE 0 END) AS SummOut_Change
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpContainer.isActive = TRUE THEN tmpContainer.SummOut_Change ELSE 0 END) AS SummOut_Change_110000_A
                , SUM (CASE WHEN tmpContainer.AccountId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpContainer.isActive = TRUE THEN tmpContainer.SummOut_Change ELSE 0 END) AS SummOut_Change_110000_P

           FROM (SELECT MIContainer.WhereObjectId_analyzer  AS LocationId
                      , MIContainer.ContainerId             AS ContainerId
                      , MIContainer.ObjectId_analyzer       AS GoodsId
                      , MIContainer.ObjectIntId_analyzer    AS GoodsKindId
                      , MIContainer.ObjectExtId_analyzer    AS PartnerId
                      , MIContainer.ContainerId_analyzer
                      , MIContainer.isActive
                      , COALESCE (MIContainer.AccountId, 0) AS AccountId
                      , COALESCE (MLO_Business.ObjectId, 0) AS BusinessId
                      , COALESCE (MLO_Branch.ObjectId, 0)   AS BranchId

                        -- 1.1. Кол-во, без AnalyzerId
                      , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE AND tmpAnalyzer.isLoss = FALSE THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE AND tmpAnalyzer.isLoss = FALSE THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount
                        -- 1.2. Себестоимость, без AnalyzerId
                      , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE AND tmpAnalyzer.isLoss = FALSE
                                   AND COALESCE (tmpAnalyzer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_SaleSumm_10500(), zc_Enum_AnalyzerId_SaleSumm_40200())
                                       THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE AND tmpAnalyzer.isLoss = FALSE
                                   AND COALESCE (tmpAnalyzer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ReturnInSumm_40200()
                                       THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn
                        -- 1.3. Сумма, без AnalyzerId (на самом деле для OperCount_Partner)
                      , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE AND tmpAnalyzer.isLoss = FALSE THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE AND tmpAnalyzer.isLoss = FALSE THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  ELSE 0
                             END) AS SummOut_Partner

                        -- 2.1. Кол-во - Скидка за вес
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_Change
                        -- 2.2. Себестоимость - Скидка за вес
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_Change

                        -- 3.1. Кол-во Разница в весе
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN 1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_40200
                        -- 3.2. Себестоимость - Разница в весе
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() THEN 1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_40200

                        -- 4.1. Кол-во списание
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_Loss
                        -- 4.2. Себестоимость - списание
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200() THEN -1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_Loss

                        -- 5.1. Кол-во у покупателя
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS OperCount_Partner
                        -- 5.2. Себестоимость у покупателя
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400()     THEN -1 * MIContainer.Amount
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() THEN  1 * MIContainer.Amount
                                  ELSE 0
                             END) AS SummIn_Partner
                        -- 5.3.1. Сумма у покупателя По прайсу
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100()     THEN  1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() THEN -1 * MIContainer.Amount -- знак наоборот т.к. это проводка покупателя
                                  ELSE 0
                             END) AS SummOut_PriceList
                        -- 5.3.2. Сумма у покупателя Разница с оптовыми ценами
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10200() THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  ELSE 0
                             END) AS SummOut_Diff
                        -- 5.3.3. Сумма у покупателя Скидка / Наценка дополнительная
                      , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                  ELSE 0
                             END) AS SummOut_Change

                 FROM tmpAnalyzer
                      INNER JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                      INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                      INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                      LEFT JOIN MovementItemLinkObject AS MLO_Business ON MLO_Business.MovementItemId = MIContainer.MovementItemId
                                                                      AND MLO_Business.DescId = zc_MILinkObject_Business()
                      LEFT JOIN MovementItemLinkObject AS MLO_Branch ON MLO_Branch.MovementItemId = MIContainer.MovementItemId
                                                                    AND MLO_Branch.DescId = zc_MILinkObject_Branch()

                 GROUP BY MIContainer.ContainerId
                        , MIContainer.WhereObjectId_analyzer
                        , MIContainer.ObjectId_analyzer
                        , MIContainer.ObjectIntId_analyzer
                        , MIContainer.ObjectExtId_analyzer
                        , MIContainer.ContainerId_analyzer       
                        , MIContainer.AccountId
                        , MIContainer.isActive
                        , MLO_Business.ObjectId
                        , MLO_Branch.ObjectId
                      
                  ) AS tmpContainer
     
                      LEFT JOIN tmpAccount ON tmpAccount.AccountId = tmpContainer.AccountId

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
                  
                      WHERE (ContainerLO_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0)
                        AND (ContainerLO_PaidKind.ObjectId = inPaidKindId OR inPaidKindId=0 OR (ContainerLO_Member.ObjectId > 0 AND inPaidKindId = zc_Enum_PaidKind_SecondForm()))

                      GROUP BY tmpContainer.LocationId
                             , tmpContainer.GoodsId
                             , tmpContainer.GoodsKindId
                             , tmpContainer.PartnerId
                             , tmpContainer.BusinessId
                             , tmpContainer.BranchId
                             , CASE WHEN ContainerLO_Member.ObjectId > 0 THEN zc_Enum_PaidKind_SecondForm() ELSE COALESCE (ContainerLO_PaidKind.ObjectId,0) END
                             , COALESCE (ContainerLO_Juridical.ObjectId,  COALESCE (ContainerLO_Member.ObjectId, 0 ))
                             , ContainerLinkObject_InfoMoney.ObjectId

                    ) AS tmpOperationGroup

          LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpOperationGroup.LocationId
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpOperationGroup.PaidKindId
          LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmpOperationGroup.BusinessId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpOperationGroup.BranchId

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

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
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight	
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Goods ON View_InfoMoney_Goods.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
          
  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
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
-- SELECT * FROM gpReport_GoodsMI (inStartDate:= '01.07.2015', inEndDate:= '01.07.2015',  inDescId:= 5, inGoodsGroupId:= 0, inUnitGroupId:=0, inUnitId:= 8459, inPaidKindId:=0, inJuridicalId:=0, inInfoMoneyId:=0, inSession:= zfCalc_UserAdmin());
