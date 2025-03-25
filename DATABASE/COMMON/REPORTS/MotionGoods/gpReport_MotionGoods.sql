-- Function: gpReport_MotionGoods_NEW()

--DROP FUNCTION IF EXISTS gpReport_MotionGoods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_MotionGoods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MotionGoods(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    -- группа подразделений на самом деле может быть и подразделением
    IN inLocationId         Integer,    --
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inGoodsId            Integer,    -- товар
    IN inUnitGroupId_by     Integer,    -- группа подразделений 1
    IN inLocationId_by      Integer,    -- место учета 1
    IN inIsInfoMoney        Boolean,    --
    IN inIsAllMO            Boolean,    -- все МО
    IN inIsAllAuto          Boolean,    -- все Авто    
    IN inIsOperDate_Partion Boolean,    -- по дате партии
    IN inIsPartionCell      Boolean,    -- по ячейкам
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (AccountGroupName TVarChar, AccountDirectionName TVarChar
             , AccountId Integer, AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
             , LocationDescName TVarChar, LocationId Integer, LocationCode Integer, LocationName TVarChar
             , CarCode Integer, CarName TVarChar
             , GoodsGroupId Integer, GoodsGroupCode Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode_basis Integer, GoodsName_basis TVarChar
             , GoodsCode_main Integer, GoodsName_main TVarChar
             , NormInDays_gk TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Name_Scale TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, GoodsKindName_complete TVarChar
             , MeasureName TVarChar
             , Weight TFloat, CountForWeight TFloat, WeightTare TFloat
             , InDate TDateTime, PartnerInName TVarChar
             , PartionGoodsId Integer, PartionGoodsName TVarChar
             , InvNumber_Partion  TVarChar
             , OperDate_Partion TDateTime
             , Price_Partion TFloat
             , Storage_Partion TVarChar
             , Unit_Partion TVarChar
             , PartNumber_Partion TVarChar
             , Model_Partion TVarChar

             , AssetToCode Integer, AssetToName TVarChar
             , PartionCellCode Integer, PartionCellName TVarChar

             , CountStart TFloat
             , CountStart_Weight TFloat
             , CountEnd TFloat
             , CountEnd_Weight TFloat
             , CountEnd_calc TFloat
             , CountEnd_calc_Weight TFloat

             , CountIncome TFloat
             , CountIncome_Weight TFloat
             , CountReturnOut TFloat
             , CountReturnOut_Weight TFloat

             , CountSendIn TFloat
             , CountSendIn_Weight TFloat
             , CountSendOut TFloat
             , CountSendOut_Weight TFloat

             , CountSendOnPriceIn TFloat
             , CountSendOnPriceIn_Weight TFloat
             
             , CountSendOnPrice_10500 TFloat
             , CountSendOnPrice_10500_Weight TFloat
             , CountSendOnPrice_40200 TFloat
             , CountSendOnPrice_40200_Weight TFloat
             
             , CountSendOnPriceOut              TFloat
             , CountSendOnPriceOut_Weight       TFloat
             , CountSendOnPriceOut_10900        TFloat
             , CountSendOnPriceOut_10900_W      TFloat

             , CountSale TFloat
             , CountSale_Weight TFloat
             , CountSale_10500 TFloat
             , CountSale_10500_Weight TFloat
             , CountSale_40208 TFloat
             , CountSale_40208_Weight TFloat

             , CountReturnIn TFloat
             , CountReturnIn_Weight TFloat
             , CountReturnIn_40208 TFloat
             , CountReturnIn_40208_Weight TFloat

             , CountLoss TFloat
             , CountLoss_Weight TFloat
             , CountInventory TFloat
             , CountInventory_Weight TFloat

             , CountProductionIn TFloat
             , CountProductionIn_Weight TFloat
             , CountProductionOut TFloat
             , CountProductionOut_Weight TFloat

             , CountTotalIn TFloat
             , CountTotalIn_Weight TFloat
             , CountTotalOut TFloat
             , CountTotalOut_Weight TFloat
             --
             , CountStart_byCount         TFloat
             , CountEnd_byCount           TFloat
             , CountIncome_byCount        TFloat
             , CountReturnOut_byCount     TFloat
             , CountSendIn_byCount        TFloat
             , CountSendOut_byCount       TFloat
             , CountSendOnPriceIn_byCount TFloat
             , CountSendOnPriceOut_byCount TFloat 
             , CountReturnIn_40208_byCount  TFloat
             , CountReturnIn_byCount        TFloat
             , CountSale_byCount            TFloat
             , CountSale_40208_byCount      TFloat
             , CountSale_10500_byCount      TFloat
             , CountProductionIn_byCount    TFloat
             , CountProductionOut_byCount   TFloat
             , CountLoss_byCount            TFloat
             , CountInventory_byCount       TFloat
                    
             --
             , SummStart TFloat
             , SummEnd TFloat
             , SummEnd_calc TFloat
             , SummIncome TFloat
             , SummReturnOut TFloat

             , SummSendIn TFloat
             , SummSendOut TFloat

             , SummSendOnPriceIn TFloat
             , SummSendOnPriceOut TFloat
             , SummSendOnPriceOut_10900 TFloat

             , SummSendOnPrice_10500  TFloat
             , SummSendOnPrice_40200  TFloat

             , SummSale TFloat
             , SummSale_10500 TFloat
             , SummSale_40208 TFloat
             , SummReturnIn TFloat
             , SummReturnIn_40208 TFloat
             , SummLoss TFloat
             , SummInventory TFloat
             , SummInventory_Basis TFloat
             , SummInventory_RePrice TFloat
             , SummProductionIn TFloat
             , SummProductionOut TFloat
             , SummTotalIn TFloat
             , SummTotalOut TFloat

             , PriceStart TFloat
             , PriceEnd TFloat
             , PriceIncome TFloat
             , PriceReturnOut TFloat
             , PriceSendIn TFloat
             , PriceSendOut TFloat
             , PriceSendOnPriceIn TFloat
             , PriceSendOnPriceOut TFloat
             , PriceSale TFloat
             , PriceReturnIn TFloat
             , PriceLoss TFloat
             , PriceInventory TFloat
             , PriceProductionIn TFloat
             , PriceProductionOut TFloat
             , PriceTotalIn TFloat
             , PriceTotalOut TFloat

             , CountProductionIn_by TFloat        -- приход с произв. (если с другого подр., т.е. не пересорт)
             , CountProductionIn_by_Weight TFloat --
             , SummProductionIn_by TFloat         -- приход с произв. (если с другого подр., т.е. не пересорт)
             , CountIn_by TFloat                  -- приход с "выбранного" подр.
             , CountIn_by_Weight TFloat           --
             , SummIn_by TFloat                   -- приход с "выбранного" подр.
             , CountOtherIn_by TFloat             -- приход другой
             , CountOtherIn_by_Weight TFloat      --
             , SummOtherIn_by TFloat              -- приход другой

             , CountOut_by TFloat             -- расход на "выбранное" подр.
             , CountOut_by_Weight TFloat      --
             , SummOut_by TFloat              -- расход на "выбранное" подр.
             , CountOtherOut_by TFloat        -- расход другой
             , CountOtherOut_by_Weight TFloat --
             , SummOtherOut_by TFloat         -- расход другой

             , PriceListStart TFloat
             , PriceListEnd TFloat

             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

             , ContainerId_Summ Integer, ContainerId_count Integer
             , ContainerId_count_max Integer, ContainerId_begin_max Integer
             , LineNum Integer
             , LocationName_inf TVarChar

              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsSummIn Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);
     
     -- !!!замена!!!
     IF inIsInfoMoney = TRUE THEN inIsOperDate_Partion:= TRUE; END IF;

     -- !!!замена!!!
     inisPartionCell:= inIsOperDate_Partion;
     
     -- !!!определяется!!!
     vbIsSummIn:= -- Отчеты руководитель сырья
                  NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND RoleId = 442647)
                  -- Ограничение просмотра с/с
              AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE AccessKeyId = zc_Enum_Process_AccessKey_NotCost() AND UserId = vbUserId)
             ;

    -- таблица -
    CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpLocation_by (LocationId Integer) ON COMMIT DROP;

    -- группа подразделений или подразделение или место учета (МО, Авто)
    IF inUnitGroupId <> 0 AND COALESCE (inLocationId, 0) = 0
    THEN
        INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
           SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
                , zc_ContainerLinkObject_Unit()       AS DescId
                , tmpDesc.ContainerDescId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
          ;
    ELSE
        IF inLocationId <> 0
        THEN
            INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
               SELECT Object.Id AS LocationId
                    , CASE WHEN Object.DescId = zc_Object_Unit()   THEN zc_ContainerLinkObject_Unit() 
                           WHEN Object.DescId = zc_Object_Car()    THEN zc_ContainerLinkObject_Car() 
                           WHEN Object.DescId = zc_Object_Member() THEN zc_ContainerLinkObject_Member()
                      END AS DescId
                    , tmpDesc.ContainerDescId
               FROM Object
                    -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
               WHERE Object.Id = inLocationId
              UNION
               -- !!!была ошибка в проводках!!!
               SELECT Object.Id AS LocationId
                    , zc_ContainerLinkObject_Member() AS DescId
                    , tmpDesc.ContainerDescId
               FROM Object
                    -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
               WHERE Object.Id     = inLocationId
                 AND Object.DescId = zc_Object_Car()  
             /*UNION
               SELECT lfSelect.UnitId               AS LocationId
                    , zc_ContainerLinkObject_Unit() AS DescId
                    , tmpDesc.ContainerDescId
               FROM lfSelect_Object_Unit_byGroup (inLocationId) AS lfSelect
                    -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1*/
              ;
        ELSE
            IF COALESCE (inUnitGroupId, 0) = 0 AND COALESCE (inLocationId, 0) = 0
           AND (inGoodsGroupId <> 0 OR inGoodsId <> 0)
            THEN
                INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
                 SELECT Object.Id                     AS LocationId
                      , zc_ContainerLinkObject_Unit() AS DescId
                      , tmpDesc.ContainerDescId
                 FROM Object
                      -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
                      LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
                 WHERE Object.DescId = zc_Object_Unit();
            END IF;
        END IF;
    END IF;

    -- добавили
    INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
       SELECT Object.Id
            , tmpCLODesc.DescId
            , tmpDesc.ContainerDescId
       FROM Object
            LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId) AS tmpDesc ON 1 = 1
            LEFT JOIN (SELECT zc_ContainerLinkObject_Car() AS DescId UNION SELECT zc_ContainerLinkObject_Member() AS DescId) AS tmpCLODesc ON 1 = 1
       WHERE Object.DescId IN (zc_Object_Member(), zc_Object_Personal(), zc_Object_Car())
       --     LEFT JOIN (SELECT zc_ContainerLinkObject_Member() AS DescId) AS tmpCLODesc ON 1 = 1
       --WHERE Object.DescId IN (zc_Object_Member(), zc_Object_Personal(), zc_Object_Car())
         AND vbIsSummIn  = TRUE
         AND (inIsAllMO  = TRUE
           OR inIsAllAuto = TRUE
             )
         AND COALESCE (inLocationId, 0) = 0

      /*UNION 
       SELECT Object.Id
            , tmpCLODesc.DescId
            , tmpDesc.ContainerDescId
       FROM Object
            LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId) AS tmpDesc ON 1 = 1
            LEFT JOIN (SELECT zc_ContainerLinkObject_Car() AS DescId) AS tmpCLODesc ON 1 = 1
       WHERE Object.DescId IN (zc_Object_Car())
         AND vbIsSummIn  = TRUE
         AND (inIsAllAuto = TRUE
             )
         AND COALESCE (inLocationId, 0) = 0*/

      /*UNION ALL
       SELECT 0 AS Id
            , tmpCLODesc.DescId
            , tmpDesc.ContainerDescId
       FROM Object
            LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId) AS tmpDesc ON 1 = 1
            LEFT JOIN (SELECT zc_ContainerLinkObject_Car() AS DescId UNION SELECT zc_ContainerLinkObject_Member() AS DescId) AS tmpCLODesc ON 1 = 1
       WHERE Object.Id = zc_Juridical_Basis()
         AND vbIsSummIn  = TRUE
         AND (inIsAllMO  = TRUE
           OR inIsAllAuto = TRUE)*/;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpLocation;


    -- группа подразделений или подразделение ...by
    IF inUnitGroupId_by <> 0
    THEN
        INSERT INTO _tmpLocation_by (LocationId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inUnitGroupId_by) AS lfSelect_Object_Unit_byGroup;
    ELSE
        IF inLocationId_by <> 0
        THEN
            INSERT INTO _tmpLocation_by (LocationId)
               SELECT inLocationId;
        END IF;
    END IF;
    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpLocation_by;


    -- Результат
    RETURN QUERY
    WITH tmpPriceStart AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                , lfObjectHistory_PriceListItem.GoodsKindId
                                , (lfObjectHistory_PriceListItem.ValuePrice * 1.2) :: TFloat AS Price
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inStartDate) AS lfObjectHistory_PriceListItem
                           WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                          )
       , tmpPriceEnd AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                              , lfObjectHistory_PriceListItem.GoodsKindId
                              , (lfObjectHistory_PriceListItem.ValuePrice * 1.2) :: TFloat AS Price
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inEndDate) AS lfObjectHistory_PriceListItem
                         WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                        )
       , tmpReport_all AS (SELECT * FROM lpReport_MotionGoods (inStartDate:= inStartDate, inEndDate:= inEndDate, inAccountGroupId:= inAccountGroupId, inUnitGroupId:= inUnitGroupId, inLocationId:= inLocationId, inGoodsGroupId:= inGoodsGroupId, inGoodsId:= inGoodsId, inIsInfoMoney:= inIsInfoMoney, inUserId:= vbUserId))
             
       , tmpReport_summ AS (SELECT * FROM tmpReport_all WHERE inIsInfoMoney = FALSE OR tmpReport_all.ContainerId_count <> tmpReport_all.ContainerId)
       , tmpReport_count AS (SELECT * FROM tmpReport_all WHERE inIsInfoMoney = TRUE AND tmpReport_all.ContainerId_count = tmpReport_all.ContainerId)
       , tmpReport AS (SELECT COALESCE (tmpReport_summ.AccountId,         tmpReport_count.AccountId)         AS AccountId
                            , COALESCE (tmpReport_summ.ContainerId_count, tmpReport_count.ContainerId_count) AS ContainerId_count
                            , COALESCE (tmpReport_summ.ContainerId,       tmpReport_count.ContainerId)       AS ContainerId

                            , COALESCE (tmpReport_summ.ContainerId_count_max,       tmpReport_count.ContainerId_count_max)       AS ContainerId_count_max
                            , COALESCE (tmpReport_summ.ContainerId_begin_max,       tmpReport_count.ContainerId_begin_max)       AS ContainerId_begin_max

                            , COALESCE (tmpReport_summ.LocationId,        tmpReport_count.LocationId)        AS LocationId
                            , COALESCE (tmpReport_summ.CarId,             tmpReport_count.CarId)             AS CarId
                            , COALESCE (tmpReport_summ.GoodsId,           tmpReport_count.GoodsId)           AS GoodsId
                            , COALESCE (tmpReport_summ.GoodsKindId,       tmpReport_count.GoodsKindId)       AS GoodsKindId
                            , COALESCE (tmpReport_summ.PartionGoodsId,    tmpReport_count.PartionGoodsId)    AS PartionGoodsId
                            , COALESCE (tmpReport_summ.AssetToId,         tmpReport_count.AssetToId)         AS AssetToId

                            , COALESCE (tmpReport_summ.LocationId_by,      tmpReport_count.LocationId_by)    AS LocationId_by

                            , COALESCE (tmpReport_count.CountStart,        tmpReport_summ.CountStart)        AS CountStart    
                            , COALESCE (tmpReport_count.CountEnd,          tmpReport_summ.CountEnd)          AS CountEnd      
                            , COALESCE (tmpReport_count.CountEnd_calc,     tmpReport_summ.CountEnd_calc)     AS CountEnd_calc 

                            , COALESCE (tmpReport_count.CountIncome,       tmpReport_summ.CountIncome)       AS CountIncome   
                            , COALESCE (tmpReport_count.CountReturnOut,    tmpReport_summ.CountReturnOut)    AS CountReturnOut

                            , COALESCE (tmpReport_count.CountSendIn,       tmpReport_summ.CountSendIn)       AS CountSendIn 
                            , COALESCE (tmpReport_count.CountSendOut,      tmpReport_summ.CountSendOut)      AS CountSendOut

                            , COALESCE (tmpReport_count.CountSendOnPriceIn,  tmpReport_summ.CountSendOnPriceIn)          AS CountSendOnPriceIn 
                            , COALESCE (tmpReport_count.CountSendOnPrice_10500,  tmpReport_summ.CountSendOnPrice_10500)  AS CountSendOnPrice_10500 
                            , COALESCE (tmpReport_count.CountSendOnPrice_40200,  tmpReport_summ.CountSendOnPrice_40200)  AS CountSendOnPrice_40200 

                            , COALESCE (tmpReport_count.CountSendOnPriceOut, tmpReport_summ.CountSendOnPriceOut)             AS CountSendOnPriceOut
                            , COALESCE (tmpReport_count.CountSendOnPriceOut_10900, tmpReport_summ.CountSendOnPriceOut_10900) AS CountSendOnPriceOut_10900

                            , COALESCE (tmpReport_count.CountSale,           tmpReport_summ.CountSale)           AS CountSale
                            , COALESCE (tmpReport_count.CountSale_10500,     tmpReport_summ.CountSale_10500)     AS CountSale_10500
                            , COALESCE (tmpReport_count.CountSale_40208,     tmpReport_summ.CountSale_40208)     AS CountSale_40208
                            , COALESCE (tmpReport_count.CountSaleReal,       tmpReport_summ.CountSaleReal)       AS CountSaleReal
                            , COALESCE (tmpReport_count.CountSaleReal_10500, tmpReport_summ.CountSaleReal_10500) AS CountSaleReal_10500
                            , COALESCE (tmpReport_count.CountSaleReal_40208, tmpReport_summ.CountSaleReal_40208) AS CountSaleReal_40208

                            , COALESCE (tmpReport_count.CountReturnIn,           tmpReport_summ.CountReturnIn)           AS CountReturnIn          
                            , COALESCE (tmpReport_count.CountReturnIn_40208,     tmpReport_summ.CountReturnIn_40208)     AS CountReturnIn_40208    
                            , COALESCE (tmpReport_count.CountReturnInReal,       tmpReport_summ.CountReturnInReal)       AS CountReturnInReal      
                            , COALESCE (tmpReport_count.CountReturnInReal_40208, tmpReport_summ.CountReturnInReal_40208) AS CountReturnInReal_40208

                            , COALESCE (tmpReport_count.CountLoss,      tmpReport_summ.CountLoss)      AS CountLoss     
                            , COALESCE (tmpReport_count.CountInventory, tmpReport_summ.CountInventory) AS CountInventory

                            , COALESCE (tmpReport_count.CountProductionIn,  tmpReport_summ.CountProductionIn)  AS CountProductionIn 
                            , COALESCE (tmpReport_count.CountProductionOut, tmpReport_summ.CountProductionOut) AS CountProductionOut

                            , COALESCE (tmpReport_summ.SummStart, 0)    AS SummStart   
                            , COALESCE (tmpReport_summ.SummEnd, 0)      AS SummEnd     
                            , COALESCE (tmpReport_summ.SummEnd_calc, 0) AS SummEnd_calc

                            , COALESCE (tmpReport_summ.SummIncome, 0)    AS SummIncome   
                            , COALESCE (tmpReport_summ.SummReturnOut, 0) AS SummReturnOut

                            , COALESCE (tmpReport_summ.SummSendIn, 0)  AS SummSendIn 
                            , COALESCE (tmpReport_summ.SummSendOut, 0) AS SummSendOut

                            , COALESCE (tmpReport_summ.SummSendOnPriceIn, 0)        AS SummSendOnPriceIn
                            , COALESCE (tmpReport_summ.SummSendOnPriceOut, 0)       AS SummSendOnPriceOut
                            , COALESCE (tmpReport_summ.SummSendOnPriceOut_10900, 0) AS SummSendOnPriceOut_10900

                            , COALESCE (tmpReport_summ.SummSendOnPrice_10500, 0) AS SummSendOnPrice_10500 
                            , COALESCE (tmpReport_summ.SummSendOnPrice_40200, 0) AS SummSendOnPrice_40200 

                            , COALESCE (tmpReport_summ.SummSale, 0)           AS SummSale           
                            , COALESCE (tmpReport_summ.SummSale_10500, 0)     AS SummSale_10500     
                            , COALESCE (tmpReport_summ.SummSale_40208, 0)     AS SummSale_40208     
                            , COALESCE (tmpReport_summ.SummSaleReal, 0)       AS SummSaleReal       
                            , COALESCE (tmpReport_summ.SummSaleReal_10500, 0) AS SummSaleReal_10500 
                            , COALESCE (tmpReport_summ.SummSaleReal_40208, 0) AS SummSaleReal_40208 

                            , COALESCE (tmpReport_summ.SummReturnIn, 0)           AS SummReturnIn          
                            , COALESCE (tmpReport_summ.SummReturnIn_40208, 0)     AS SummReturnIn_40208    
                            , COALESCE (tmpReport_summ.SummReturnInReal, 0)       AS SummReturnInReal      
                            , COALESCE (tmpReport_summ.SummReturnInReal_40208, 0) AS SummReturnInReal_40208

                            , COALESCE (tmpReport_summ.SummLoss, 0)              AS SummLoss             
                            , COALESCE (tmpReport_summ.SummInventory, 0)         AS SummInventory
                            , COALESCE (tmpReport_summ.SummInventory_Basis, 0)   AS SummInventory_Basis  
                            , COALESCE (tmpReport_summ.SummInventory_RePrice, 0) AS SummInventory_RePrice

                            , COALESCE (tmpReport_summ.SummProductionIn, 0)  AS SummProductionIn 
                            , COALESCE (tmpReport_summ.SummProductionOut, 0) AS SummProductionOut      
                            
                             --  CountCount
                            , COALESCE (tmpReport_count.CountStart_byCount,         tmpReport_summ.CountStart_byCount)         AS  CountStart_byCount        
                            , COALESCE (tmpReport_count.CountEnd_byCount,           tmpReport_summ.CountEnd_byCount)           AS  CountEnd_byCount          
                            , COALESCE (tmpReport_count.CountIncome_byCount,        tmpReport_summ.CountIncome_byCount)        AS  CountIncome_byCount      
                            , COALESCE (tmpReport_count.CountReturnOut_byCount,     tmpReport_summ.CountReturnOut_byCount)     AS  CountReturnOut_byCount    
                            , COALESCE (tmpReport_count.CountSendIn_byCount,        tmpReport_summ.CountSendIn_byCount)        AS  CountSendIn_byCount       
                            , COALESCE (tmpReport_count.CountSendOut_byCount,       tmpReport_summ.CountSendOut_byCount)       AS  CountSendOut_byCount      
                            , COALESCE (tmpReport_count.CountSendOnPriceIn_byCount, tmpReport_summ.CountSendOnPriceIn_byCount)   AS  CountSendOnPriceIn_byCount
                            , COALESCE (tmpReport_count.CountSendOnPriceOut_byCount, tmpReport_summ.CountSendOnPriceOut_byCount) AS  CountSendOnPriceOut_byCount

                       FROM tmpReport_summ
                            FULL JOIN tmpReport_count ON tmpReport_count.ContainerId_count = tmpReport_summ.ContainerId_count
                      )

       , tmpMIContainer_group AS (SELECT tmpMIContainer_all.AccountId
                                       , tmpMIContainer_all.ContainerId
                                       , tmpMIContainer_all.ContainerId_count
                                       , MAX (tmpMIContainer_all.ContainerId_count_max) AS ContainerId_count_max
                                       , MAX (tmpMIContainer_all.ContainerId_begin_max) AS ContainerId_begin_max

                                       , tmpMIContainer_all.LocationId
                                       , tmpMIContainer_all.CarId
                                       , tmpMIContainer_all.GoodsId
                                       , tmpMIContainer_all.GoodsKindId
                                       , tmpMIContainer_all.AssetToId

                                       , CASE WHEN inisPartionCell = TRUE AND inIsOperDate_Partion = TRUE THEN COALESCE(Object_PartionGoods.Id, 0) ELSE 0 END ::Integer AS PartionGoodsId

                                       , CASE WHEN Object_PartionCell.DescId = zc_Object_PartionCell() AND inisPartionCell = TRUE
                                                   THEN CASE WHEN Object_PartionGoods.ValueData <> '' THEN Object_PartionGoods.ValueData || ' ' ELSE '' END
                                                     || Object_PartionCell.ValueData || ' '
                                                     || CASE WHEN Object_GoodsKind.ValueData <> '' THEN Object_GoodsKind.ValueData || ' '
                                                             WHEN Object_GoodsKind_complete.ValueData <> '' THEN Object_GoodsKind_complete.ValueData || ' '
                                                             ELSE ''
                                                        END
 
                                              WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0 AND Object_PartionGoods.ObjectCode > 0
                                                   THEN zfCalc_PartionGoodsName_Asset (inMovementId      := Object_PartionGoods.ObjectCode          -- 
                                                                                     , inInvNumber       := Object_PartionGoods.ValueData           -- Инвентарный номер
                                                                                     , inOperDate        := ObjectDate_PartionGoods_Value.ValueData -- Дата ввода в эксплуатацию
                                                                                     , inUnitName        := Object_Unit.ValueData                   -- Подразделение использования
                                                                                     , inStorageName     := Object_Storage.ValueData                -- Место хранения
                                                                                     , inGoodsName       := ''                                      -- Основные средства или Товар
                                                                                      )
                                              WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0
                                                   THEN zfCalc_PartionGoodsName_InvNumber (inInvNumber       := Object_PartionGoods.ValueData             -- Инвентарный номер
                                                                                         , inOperDate        := ObjectDate_PartionGoods_Value.ValueData   -- Дата перемещения
                                                                                         , inPrice           := ObjectFloat_PartionGoods_Price.ValueData  -- Цена
                                                                                         , inUnitName_Partion:= Object_Unit.ValueData                     -- Подразделение(для цены)
                                                                                         , inStorageName     := Object_Storage.ValueData                  -- Место хранения
                                                                                         , inGoodsName       := ''                                        -- Товар
                                                                                          )
                                              -- для РК
                                              WHEN inIsOperDate_Partion = FALSE AND tmpMIContainer_all.LocationId = zc_Unit_RK() 
                                                   THEN ''
 
                                              ELSE COALESCE (Object_PartionGoods.ValueData, '') || CASE WHEN Object_GoodsKind_complete.ValueData <> '' THEN ' ' || Object_GoodsKind_complete.ValueData ELSE '' END
                                         END :: TVarChar AS PartionGoodsName
 

  
                                       , CASE WHEN inIsOperDate_Partion = TRUE OR tmpMIContainer_all.LocationId <> zc_Unit_RK() THEN Object_PartionGoods.ValueData ELSE NULL END :: TVarChar  AS InvNumber_Partion

                                       , CASE WHEN inIsOperDate_Partion = TRUE THEN ObjectDate_PartionGoods_Value.ValueData ELSE NULL END :: TDateTime AS OperDate_Partion
                                       , CASE WHEN inIsOperDate_Partion = TRUE OR tmpMIContainer_all.LocationId <> zc_Unit_RK() THEN ObjectFloat_PartionGoods_Price.ValueData ELSE 0  END :: TFloat    AS Price_Partion
                                       , CASE WHEN inIsOperDate_Partion = TRUE OR tmpMIContainer_all.LocationId <> zc_Unit_RK() THEN Object_Storage.ValueData                 ELSE '' END :: TVarChar  AS Storage_Partion

                                       , (COALESCE (Object_Unit.ValueData, '')
                                          || CASE -- для РК
                                                  WHEN inIsOperDate_Partion = FALSE AND tmpMIContainer_all.LocationId = zc_Unit_RK()
                                                       THEN ''
                                                  --
                                                  WHEN tmpMIContainer_all.PartionGoodsId > 0 AND COALESCE (Object_Unit.ValueData, '') = ''
                                                       THEN ' id=' || COALESCE (tmpMIContainer_all.PartionGoodsId, 0)
                                                  ELSE ''
                                             END
                                         ) :: TVarChar AS Unit_Partion

                                       , CASE WHEN inIsOperDate_Partion = TRUE OR tmpMIContainer_all.LocationId <> zc_Unit_RK() THEN ObjectString_PartNumber.ValueData ELSE '' END :: TVarChar  AS PartNumber_Partion
                                       , CASE WHEN inIsOperDate_Partion = TRUE OR tmpMIContainer_all.LocationId <> zc_Unit_RK() THEN Object_PartionModel.ValueData     ELSE '' END :: TVarChar  AS Model_Partion
         
                                       , Object_GoodsKind_complete.ValueData                                            AS GoodsKindName_complete
                                       , CASE WHEN inisPartionCell = TRUE THEN Object_PartionCell.Id ELSE 0 END         AS PartionCellId
                                       , CASE WHEN inisPartionCell = TRUE THEN Object_PartionCell.ObjectCode ELSE 0 END AS PartionCellCode 
                                       , STRING_AGG (DISTINCT COALESCE (Object_PartionCell.ValueData, ''), ';') ::TVarChar             AS PartionCellName

                                       , SUM (tmpMIContainer_all.CountStart)          AS CountStart
                                       , SUM (tmpMIContainer_all.CountEnd)            AS CountEnd
                                       , SUM (tmpMIContainer_all.CountEnd_calc)       AS CountEnd_calc

                                       , SUM (tmpMIContainer_all.CountIncome)         AS CountIncome
                                       , SUM (tmpMIContainer_all.CountReturnOut)      AS CountReturnOut

                                       , SUM (tmpMIContainer_all.CountSendIn)         AS CountSendIn
                                       , SUM (tmpMIContainer_all.CountSendOut)        AS CountSendOut

                                       , SUM (tmpMIContainer_all.CountSendOnPriceIn)  AS CountSendOnPriceIn

                                       , SUM (tmpMIContainer_all.CountSendOnPrice_10500)  AS CountSendOnPrice_10500
                                       , SUM (tmpMIContainer_all.CountSendOnPrice_40200)  AS CountSendOnPrice_40200

                                       , SUM (tmpMIContainer_all.CountSendOnPriceOut)       AS CountSendOnPriceOut
                                       , SUM (tmpMIContainer_all.CountSendOnPriceOut_10900) AS CountSendOnPriceOut_10900

                                       , SUM (tmpMIContainer_all.CountSale)           AS CountSale
                                       , SUM (tmpMIContainer_all.CountSale_10500)     AS CountSale_10500
                                       , SUM (tmpMIContainer_all.CountSale_40208)     AS CountSale_40208

                                       , SUM (tmpMIContainer_all.CountReturnIn)       AS CountReturnIn
                                       , SUM (tmpMIContainer_all.CountReturnIn_40208) AS CountReturnIn_40208

                                       , SUM (tmpMIContainer_all.CountLoss)           AS CountLoss
                                       , SUM (tmpMIContainer_all.CountInventory)      AS CountInventory

                                       , SUM (tmpMIContainer_all.CountProductionIn)   AS CountProductionIn
                                       , SUM (tmpMIContainer_all.CountProductionOut)  AS CountProductionOut

                                       , SUM (tmpMIContainer_all.CountProductionIn_by)  AS CountProductionIn_by
                                       , SUM (tmpMIContainer_all.SummProductionIn_by)   AS SummProductionIn_by

                                       , SUM (tmpMIContainer_all.CountIn_by)          AS CountIn_by -- приход с "выбранного" подр.
                                       , SUM (tmpMIContainer_all.SummIn_by)           AS SummIn_by -- приход с "выбранного" подр.

                                       , SUM (tmpMIContainer_all.CountOtherIn_by)     AS CountOtherIn_by -- приход другой
                                       , SUM (tmpMIContainer_all.SummOtherIn_by)      AS SummOtherIn_by -- приход другой

                                       , SUM (tmpMIContainer_all.CountOut_by)         AS CountOut_by -- расход на "выбранное" подр.
                                       , SUM (tmpMIContainer_all.SummOut_by)          AS SummOut_by -- расход на "выбранное" подр.

                                       , SUM (tmpMIContainer_all.CountOtherOut_by)    AS CountOtherOut_by -- расход другой
                                       , SUM (tmpMIContainer_all.SummOtherOut_by)     AS SummOtherOut_by -- расход другой

                                       , SUM (tmpMIContainer_all.CountTotalIn)        AS CountTotalIn
                                       , SUM (tmpMIContainer_all.CountTotalOut)       AS CountTotalOut

                                       , SUM (tmpMIContainer_all.SummStart)           AS SummStart
                                       , SUM (tmpMIContainer_all.SummEnd)             AS SummEnd
                                       , SUM (tmpMIContainer_all.SummEnd_calc)        AS SummEnd_calc
                                       , SUM (tmpMIContainer_all.SummIncome)          AS SummIncome
                                       , SUM (tmpMIContainer_all.SummReturnOut)       AS SummReturnOut
                                       , SUM (tmpMIContainer_all.SummSendIn)          AS SummSendIn
                                       , SUM (tmpMIContainer_all.SummSendOut)         AS SummSendOut
                                       , SUM (tmpMIContainer_all.SummSendOnPriceIn)   AS SummSendOnPriceIn

                                       , SUM (tmpMIContainer_all.SummSendOnPriceOut)        AS SummSendOnPriceOut
                                       , SUM (tmpMIContainer_all.SummSendOnPriceOut_10900)  AS SummSendOnPriceOut_10900

                                       , SUM (tmpMIContainer_all.SummSendOnPrice_10500)      AS SummSendOnPrice_10500
                                       , SUM (tmpMIContainer_all.SummSendOnPrice_40200)      AS SummSendOnPrice_40200

                                       , SUM (tmpMIContainer_all.SummSale)            AS SummSale
                                       , SUM (tmpMIContainer_all.SummSale_10500)      AS SummSale_10500
                                       , SUM (tmpMIContainer_all.SummSale_40208)      AS SummSale_40208
                                       , SUM (tmpMIContainer_all.SummReturnIn)        AS SummReturnIn
                                       , SUM (tmpMIContainer_all.SummReturnIn_40208)  AS SummReturnIn_40208
                                       , SUM (tmpMIContainer_all.SummLoss)            AS SummLoss
                                       , SUM (tmpMIContainer_all.SummInventory)       AS SummInventory
                                       , SUM (tmpMIContainer_all.SummInventory_Basis)   AS SummInventory_Basis
                                       , SUM (tmpMIContainer_all.SummInventory_RePrice) AS SummInventory_RePrice
                                       , SUM (tmpMIContainer_all.SummProductionIn)    AS SummProductionIn
                                       , SUM (tmpMIContainer_all.SummProductionOut)   AS SummProductionOut

                                       , SUM (tmpMIContainer_all.SummTotalIn)         AS SummTotalIn
                                       , SUM (tmpMIContainer_all.SummTotalOut)        AS SummTotalOut

                                       --  CountCount
                                       , SUM (tmpMIContainer_all.CountStart_byCount)          AS  CountStart_byCount        
                                       , SUM (tmpMIContainer_all.CountEnd_byCount)            AS  CountEnd_byCount          
                                       , SUM (tmpMIContainer_all.CountIncome_byCount)         AS  CountIncome_byCount      
                                       , SUM (tmpMIContainer_all.CountReturnOut_byCount)      AS  CountReturnOut_byCount    
                                       , SUM (tmpMIContainer_all.CountSendIn_byCount)         AS  CountSendIn_byCount       
                                       , SUM (tmpMIContainer_all.CountSendOut_byCount)        AS  CountSendOut_byCount      
                                       , SUM (tmpMIContainer_all.CountSendOnPriceIn_byCount)  AS  CountSendOnPriceIn_byCount
                                       , SUM (tmpMIContainer_all.CountSendOnPriceOut_byCount) AS  CountSendOnPriceOut_byCount
                                  FROM (SELECT tmpMIContainer_all.AccountId                 AS AccountId
                                             , tmpMIContainer_all.ContainerId
                                             , tmpMIContainer_all.ContainerId_count
                                             , MAX (tmpMIContainer_all.ContainerId_count_max) AS ContainerId_count_max
                                             , MAX (tmpMIContainer_all.ContainerId_begin_max) AS ContainerId_begin_max
                                             , tmpMIContainer_all.LocationId
                                             , tmpMIContainer_all.CarId
                                             , tmpMIContainer_all.GoodsId
                                             , tmpMIContainer_all.GoodsKindId
                                             , tmpMIContainer_all.PartionGoodsId
                                             , tmpMIContainer_all.AssetToId
                                             , SUM (tmpMIContainer_all.CountStart)          AS CountStart
                                             , SUM (tmpMIContainer_all.CountEnd)            AS CountEnd
                                             , SUM (tmpMIContainer_all.CountEnd_calc)       AS CountEnd_calc
                               
                                             , SUM (tmpMIContainer_all.CountIncome)         AS CountIncome
                                             , SUM (tmpMIContainer_all.CountReturnOut)      AS CountReturnOut
                               
                                             , SUM (tmpMIContainer_all.CountSendIn)         AS CountSendIn
                                             , SUM (tmpMIContainer_all.CountSendOut)        AS CountSendOut
                               
                                             , SUM (tmpMIContainer_all.CountSendOnPriceIn)  AS CountSendOnPriceIn
      
                                             , SUM (tmpMIContainer_all.CountSendOnPrice_10500)  AS CountSendOnPrice_10500
                                             , SUM (tmpMIContainer_all.CountSendOnPrice_40200)  AS CountSendOnPrice_40200
      
                                             , SUM (tmpMIContainer_all.CountSendOnPriceOut)       AS CountSendOnPriceOut
                                             , SUM (tmpMIContainer_all.CountSendOnPriceOut_10900) AS CountSendOnPriceOut_10900
                               
                                             , SUM (tmpMIContainer_all.CountSale)           AS CountSale
                                             , SUM (tmpMIContainer_all.CountSale_10500)     AS CountSale_10500
                                             , SUM (tmpMIContainer_all.CountSale_40208)     AS CountSale_40208
                               
                                             , SUM (tmpMIContainer_all.CountReturnIn)       AS CountReturnIn
                                             , SUM (tmpMIContainer_all.CountReturnIn_40208) AS CountReturnIn_40208
                               
                                             , SUM (tmpMIContainer_all.CountLoss)           AS CountLoss
                                             , SUM (tmpMIContainer_all.CountInventory)      AS CountInventory
                               
                                             , SUM (tmpMIContainer_all.CountProductionIn)   AS CountProductionIn
                                             , SUM (tmpMIContainer_all.CountProductionOut)  AS CountProductionOut
                               
                                             , SUM (CASE WHEN /*_tmpLocation.LocationId IS NULL AND */ 1=0 AND _tmpLocation_by.LocationId IS NULL THEN tmpMIContainer_all.CountProductionIn ELSE 0 END) AS CountProductionIn_by -- приход с произв. (если с другого подр., т.е. не пересорт)
                                             , SUM (CASE WHEN /*_tmpLocation.LocationId IS NULL AND */ 1=0 AND _tmpLocation_by.LocationId IS NULL THEN tmpMIContainer_all.SummProductionIn  ELSE 0 END) AS SummProductionIn_by  -- приход с произв. (если с другого подр., т.е. не пересорт)
                               
                                             , SUM (CASE WHEN _tmpLocation_by.LocationId > 0
                                                              THEN tmpMIContainer_all.CountSendIn
                                                                 + tmpMIContainer_all.CountProductionIn
                                                                 + tmpMIContainer_all.CountSendOnPriceIn
                                                         ELSE 0
                                                    END) AS CountIn_by -- приход с "выбранного" подр.
                                             , SUM (CASE WHEN _tmpLocation_by.LocationId > 0
                                                              THEN tmpMIContainer_all.SummSendIn
                                                                 + tmpMIContainer_all.SummProductionIn
                                                                 + tmpMIContainer_all.SummSendOnPriceIn
                                                         ELSE 0
                                                    END) AS SummIn_by -- приход с "выбранного" подр.
                               
                                             , SUM (CASE WHEN /*_tmpLocation.LocationId > 0 AND */ _tmpLocation_by.LocationId IS NULL THEN tmpMIContainer_all.CountProductionIn ELSE 0 END
                                                  + CASE WHEN _tmpLocation_by.LocationId IS NULL
                                                              THEN tmpMIContainer_all.CountSendIn
                                                                 + tmpMIContainer_all.CountSendOnPriceIn
                                                         ELSE 0
                                                    END
                                                  + tmpMIContainer_all.CountIncome
                                                   ) AS CountOtherIn_by -- приход другой
                                             , SUM (CASE WHEN /*_tmpLocation.LocationId > 0 AND */ _tmpLocation_by.LocationId IS NULL THEN tmpMIContainer_all.SummProductionIn ELSE 0 END
                                                  + CASE WHEN _tmpLocation_by.LocationId IS NULL
                                                              THEN tmpMIContainer_all.SummSendIn
                                                                 + tmpMIContainer_all.SummSendOnPriceIn
                                                         ELSE 0
                                                    END
                                                  + tmpMIContainer_all.SummIncome
                                                   ) AS SummOtherIn_by -- приход другой
                               
                                             , SUM (CASE WHEN _tmpLocation_by.LocationId > 0
                                                              THEN tmpMIContainer_all.CountSendOut
                                                                 + tmpMIContainer_all.CountProductionOut
                                                                 + tmpMIContainer_all.CountSendOnPriceOut
                                                         ELSE 0
                                                    END) AS CountOut_by -- расход на "выбранное" подр.
                                             , SUM (CASE WHEN _tmpLocation_by.LocationId > 0
                                                              THEN tmpMIContainer_all.SummSendOut
                                                                 + tmpMIContainer_all.SummProductionOut
                                                                 + tmpMIContainer_all.SummSendOnPriceOut
                                                         ELSE 0
                                                    END) AS SummOut_by -- расход на "выбранное" подр.
                               
                                             , SUM (CASE WHEN _tmpLocation_by.LocationId IS NULL
                                                              THEN tmpMIContainer_all.CountSendOut
                                                                 + tmpMIContainer_all.CountProductionOut
                                                                 + tmpMIContainer_all.CountSendOnPriceOut
                                                         ELSE 0
                                                    END
                                                  + tmpMIContainer_all.CountReturnOut
                                                   ) AS CountOtherOut_by -- расход другой
                                             , SUM (CASE WHEN _tmpLocation_by.LocationId IS NULL
                                                              THEN tmpMIContainer_all.SummSendOut
                                                                 + tmpMIContainer_all.SummProductionOut
                                                                 + tmpMIContainer_all.SummSendOnPriceOut
                                                         ELSE 0
                                                    END
                                                  + tmpMIContainer_all.SummReturnOut
                                                   ) AS SummOtherOut_by -- расход другой
                               
                                             , SUM (tmpMIContainer_all.CountIncome
                                                  + tmpMIContainer_all.CountSendIn
                                                  + tmpMIContainer_all.CountSendOnPriceIn
                                                  + tmpMIContainer_all.CountReturnIn
                                                  + tmpMIContainer_all.CountReturnIn_40208
                                                  + tmpMIContainer_all.CountProductionIn)   AS CountTotalIn
                                             , SUM (tmpMIContainer_all.CountReturnOut
                                                  + tmpMIContainer_all.CountSendOut
                                                  + tmpMIContainer_all.CountSendOnPriceOut
                                                  + tmpMIContainer_all.CountSale
                                                  + tmpMIContainer_all.CountSale_10500
                                                  - tmpMIContainer_all.CountSale_40208
                                                  + tmpMIContainer_all.CountLoss
                                                  + tmpMIContainer_all.CountProductionOut)  AS CountTotalOut
      
                                             , SUM (tmpMIContainer_all.SummStart)           AS SummStart
                                             , SUM (tmpMIContainer_all.SummEnd)             AS SummEnd
                                             , SUM (tmpMIContainer_all.SummEnd_calc)        AS SummEnd_calc
                                             , SUM (tmpMIContainer_all.SummIncome)          AS SummIncome
                                             , SUM (tmpMIContainer_all.SummReturnOut)       AS SummReturnOut
                                             , SUM (tmpMIContainer_all.SummSendIn)          AS SummSendIn
                                             , SUM (tmpMIContainer_all.SummSendOut)         AS SummSendOut
                                             , SUM (tmpMIContainer_all.SummSendOnPriceIn)   AS SummSendOnPriceIn
      
                                             , SUM (tmpMIContainer_all.SummSendOnPriceOut)        AS SummSendOnPriceOut
                                             , SUM (tmpMIContainer_all.SummSendOnPriceOut_10900)  AS SummSendOnPriceOut_10900
      
                                             , SUM (tmpMIContainer_all.SummSendOnPrice_10500)      AS SummSendOnPrice_10500
                                             , SUM (tmpMIContainer_all.SummSendOnPrice_40200)      AS SummSendOnPrice_40200
      
                                             , SUM (tmpMIContainer_all.SummSale)            AS SummSale
                                             , SUM (tmpMIContainer_all.SummSale_10500)      AS SummSale_10500
                                             , SUM (tmpMIContainer_all.SummSale_40208)      AS SummSale_40208
                                             , SUM (tmpMIContainer_all.SummReturnIn)        AS SummReturnIn
                                             , SUM (tmpMIContainer_all.SummReturnIn_40208)  AS SummReturnIn_40208
                                             , SUM (tmpMIContainer_all.SummLoss)            AS SummLoss
                                             , SUM (tmpMIContainer_all.SummInventory)       AS SummInventory
                                             , SUM (tmpMIContainer_all.SummInventory_Basis)   AS SummInventory_Basis
                                             , SUM (tmpMIContainer_all.SummInventory_RePrice) AS SummInventory_RePrice
                                             , SUM (tmpMIContainer_all.SummProductionIn)    AS SummProductionIn
                                             , SUM (tmpMIContainer_all.SummProductionOut)   AS SummProductionOut
      
                                             , SUM (tmpMIContainer_all.SummIncome
                                                  + tmpMIContainer_all.SummSendIn
                                                  + tmpMIContainer_all.SummSendOnPriceIn
                                                  + tmpMIContainer_all.SummReturnIn
                                                  + tmpMIContainer_all.SummReturnIn_40208
                                                  + tmpMIContainer_all.SummProductionIn)    AS SummTotalIn
                                             , SUM (tmpMIContainer_all.SummReturnOut
                                                  + tmpMIContainer_all.SummSendOut
                                                  + tmpMIContainer_all.SummSendOnPriceOut
                                                  + tmpMIContainer_all.SummSale
                                                  + tmpMIContainer_all.SummSale_10500
                                                  - tmpMIContainer_all.SummSale_40208
                                                  + tmpMIContainer_all.SummLoss
                                                  + tmpMIContainer_all.SummProductionOut)   AS SummTotalOut
      
                                             --  CountCount
                                             , SUM (tmpMIContainer_all.CountStart_byCount)          AS  CountStart_byCount        
                                             , SUM (tmpMIContainer_all.CountEnd_byCount)            AS  CountEnd_byCount          
                                             , SUM (tmpMIContainer_all.CountIncome_byCount)         AS  CountIncome_byCount      
                                             , SUM (tmpMIContainer_all.CountReturnOut_byCount)      AS  CountReturnOut_byCount    
                                             , SUM (tmpMIContainer_all.CountSendIn_byCount)         AS  CountSendIn_byCount       
                                             , SUM (tmpMIContainer_all.CountSendOut_byCount)        AS  CountSendOut_byCount      
                                             , SUM (tmpMIContainer_all.CountSendOnPriceIn_byCount)  AS  CountSendOnPriceIn_byCount
                                             , SUM (tmpMIContainer_all.CountSendOnPriceOut_byCount) AS  CountSendOnPriceOut_byCount
      
                                        FROM tmpReport AS tmpMIContainer_all
                                             -- LEFT JOIN _tmpLocation ON _tmpLocation.LocationId = tmpMIContainer_all.LocationId_by AND _tmpLocation.ContainerDescId = zc_Container_Count()
                                             LEFT JOIN _tmpLocation_by ON _tmpLocation_by.LocationId = tmpMIContainer_all.LocationId_by
                                        GROUP BY tmpMIContainer_all.AccountId
                                               , tmpMIContainer_all.ContainerId
                                               , tmpMIContainer_all.ContainerId_count
                                               , tmpMIContainer_all.LocationId
                                               , tmpMIContainer_all.CarId
                                               , tmpMIContainer_all.GoodsId
                                               , tmpMIContainer_all.GoodsKindId
                                               , tmpMIContainer_all.PartionGoodsId
                                               , tmpMIContainer_all.AssetToId 
                                        ) AS tmpMIContainer_all   
                                      LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer_all.GoodsKindId  

                                      LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                           ON ObjectLink_GoodsKindComplete.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                          AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                                      LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = ObjectLink_GoodsKindComplete.ChildObjectId

                                      LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_all.PartionGoodsId

                                      LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                                           ON ObjectLink_PartionCell.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                          AND ObjectLink_PartionCell.DescId = zc_ObjectLink_PartionGoods_PartionCell()
                                      LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = ObjectLink_PartionCell.ChildObjectId
                              
                                      LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                           ON ObjectLink_Goods.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                          AND ObjectLink_Goods.DescId = zc_ObjectLink_PartionGoods_Goods()
                                      LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                           ON ObjectLink_Unit.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                          AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                      LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId
                                      LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                           ON ObjectLink_Storage.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                          AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
                                      LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId
                                      LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                           ON ObjectDate_PartionGoods_Value.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                          AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                                      LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Price
                                                            ON ObjectFloat_PartionGoods_Price.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                           AND ObjectFloat_PartionGoods_Price.DescId = zc_ObjectFloat_PartionGoods_Price()

                                      LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                                           ON ObjectLink_PartionModel.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                          AND ObjectLink_PartionModel.DescId   = zc_ObjectLink_PartionGoods_PartionModel()
                                      LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId
                                      LEFT JOIN ObjectString AS ObjectString_PartNumber
                                                             ON ObjectString_PartNumber.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                            AND ObjectString_PartNumber.DescId   = zc_ObjectString_PartionGoods_PartNumber()

                                 GROUP BY tmpMIContainer_all.AccountId
                                        , tmpMIContainer_all.ContainerId
                                        , tmpMIContainer_all.ContainerId_count
                                        , tmpMIContainer_all.LocationId
                                        , tmpMIContainer_all.CarId
                                        , tmpMIContainer_all.GoodsId
                                        , tmpMIContainer_all.GoodsKindId
                                        , tmpMIContainer_all.AssetToId
 
                                        , CASE WHEN inisPartionCell = TRUE AND inIsOperDate_Partion = TRUE THEN COALESCE(Object_PartionGoods.Id, 0) ELSE 0 END

                                        , CASE WHEN Object_PartionCell.DescId = zc_Object_PartionCell() AND inisPartionCell = TRUE
                                                    THEN CASE WHEN Object_PartionGoods.ValueData <> '' THEN Object_PartionGoods.ValueData || ' ' ELSE '' END
                                                      || Object_PartionCell.ValueData || ' '
                                                      || CASE WHEN Object_GoodsKind.ValueData <> '' THEN Object_GoodsKind.ValueData || ' '
                                                              WHEN Object_GoodsKind_complete.ValueData <> '' THEN Object_GoodsKind_complete.ValueData || ' '
                                                              ELSE ''
                                                         END
  
                                               WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0 AND Object_PartionGoods.ObjectCode > 0
                                                    THEN zfCalc_PartionGoodsName_Asset (inMovementId      := Object_PartionGoods.ObjectCode          -- 
                                                                                      , inInvNumber       := Object_PartionGoods.ValueData           -- Инвентарный номер
                                                                                      , inOperDate        := ObjectDate_PartionGoods_Value.ValueData -- Дата ввода в эксплуатацию
                                                                                      , inUnitName        := Object_Unit.ValueData                   -- Подразделение использования
                                                                                      , inStorageName     := Object_Storage.ValueData                -- Место хранения
                                                                                      , inGoodsName       := ''                                      -- Основные средства или Товар
                                                                                       )
                                               WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0
                                                    THEN zfCalc_PartionGoodsName_InvNumber (inInvNumber       := Object_PartionGoods.ValueData             -- Инвентарный номер
                                                                                          , inOperDate        := ObjectDate_PartionGoods_Value.ValueData   -- Дата перемещения
                                                                                          , inPrice           := ObjectFloat_PartionGoods_Price.ValueData  -- Цена
                                                                                          , inUnitName_Partion:= Object_Unit.ValueData                     -- Подразделение(для цены)
                                                                                          , inStorageName     := Object_Storage.ValueData                  -- Место хранения
                                                                                          , inGoodsName       := ''                                        -- Товар
                                                                                           )

                                               -- для РК
                                               WHEN inIsOperDate_Partion = FALSE AND tmpMIContainer_all.LocationId = zc_Unit_RK() 
                                                    THEN ''

                                               ELSE COALESCE (Object_PartionGoods.ValueData, '') || CASE WHEN Object_GoodsKind_complete.ValueData <> '' THEN ' ' || Object_GoodsKind_complete.ValueData ELSE '' END
                                          END 
  
                                        , CASE WHEN inIsOperDate_Partion = TRUE OR tmpMIContainer_all.LocationId <> zc_Unit_RK() THEN Object_PartionGoods.ValueData ELSE NULL END
                                        , CASE WHEN inIsOperDate_Partion = TRUE THEN ObjectDate_PartionGoods_Value.ValueData ELSE NULL END

                                        , CASE WHEN inIsOperDate_Partion = TRUE OR tmpMIContainer_all.LocationId <> zc_Unit_RK() THEN ObjectFloat_PartionGoods_Price.ValueData ELSE 0 END
                                        , CASE WHEN inIsOperDate_Partion = TRUE OR tmpMIContainer_all.LocationId <> zc_Unit_RK() THEN Object_Storage.ValueData ELSE '' END
                                        , (COALESCE (Object_Unit.ValueData, '')
                                           || CASE -- для РК
                                                   WHEN inIsOperDate_Partion = FALSE AND tmpMIContainer_all.LocationId = zc_Unit_RK()
                                                        THEN ''
                                                   --
                                                   WHEN tmpMIContainer_all.PartionGoodsId > 0 AND COALESCE (Object_Unit.ValueData, '') = ''
                                                        THEN ' id=' || COALESCE (tmpMIContainer_all.PartionGoodsId, 0)
                                                   ELSE ''
                                              END
                                          ) 
                                        , CASE WHEN inIsOperDate_Partion = TRUE OR tmpMIContainer_all.LocationId <> zc_Unit_RK() THEN ObjectString_PartNumber.ValueData ELSE '' END
                                        , CASE WHEN inIsOperDate_Partion = TRUE OR tmpMIContainer_all.LocationId <> zc_Unit_RK() THEN Object_PartionModel.ValueData    ELSE '' END
          
                                        , Object_GoodsKind_complete.ValueData
                                        , CASE WHEN inisPartionCell = TRUE THEN Object_PartionCell.Id ELSE 0 END
                                        , CASE WHEN inisPartionCell = TRUE THEN Object_PartionCell.ObjectCode ELSE 0 END 
                                 )

   --
   , tmpGoodsByGoodsKindParam AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                       , Object_GoodsByGoodsKind_View.GoodsKindId
                                       , Object_Goods_basis.ObjectCode        AS GoodsCode_basis
                                       , Object_Goods_basis.ValueData         AS GoodsName_basis
                                       , Object_Goods_main.ObjectCode         AS GoodsCode_main
                                       , Object_Goods_main.ValueData          AS GoodsName_main
                                       , ObjectFloat_GK_NormInDays.ValueData  AS NormInDays_gk
                                  FROM Object_GoodsByGoodsKind_View
                                        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBasis
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsBasis.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsBasis.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsBasis()
                                        LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = ObjectLink_GoodsByGoodsKind_GoodsBasis.ChildObjectId
                                        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsMain
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsMain.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsMain.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsMain()
                                        LEFT JOIN Object AS Object_Goods_main ON Object_Goods_main.Id = ObjectLink_GoodsByGoodsKind_GoodsMain.ChildObjectId

                                        LEFT JOIN ObjectFloat AS ObjectFloat_GK_NormInDays
                                                              ON ObjectFloat_GK_NormInDays.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                             AND ObjectFloat_GK_NormInDays.DescId   = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()

                                  WHERE COALESCE (ObjectLink_GoodsByGoodsKind_GoodsBasis.ChildObjectId, 0) <> 0
                                     OR COALESCE (ObjectLink_GoodsByGoodsKind_GoodsMain.ChildObjectId, 0) <> 0
                                  )

       , tmpStorage AS (SELECT spSelect.*
                        FROM gpSelect_Object_Storage (inSession) AS spSelect
                        )

   -- Результат
   SELECT View_Account.AccountGroupName, View_Account.AccountDirectionName
        , View_Account.AccountId, View_Account.AccountCode, View_Account.AccountName, View_Account.AccountName_all
        , ObjectDesc.ItemName            AS LocationDescName
        , CAST (COALESCE(Object_Location.Id, 0) AS Integer)             AS LocationId
        , Object_Location.ObjectCode     AS LocationCode
        , CAST (COALESCE(Object_Location.ValueData,'') AS TVarChar)     AS LocationName
        , Object_Car.ObjectCode          AS CarCode
        , Object_Car.ValueData           AS CarName
        , Object_GoodsGroup.Id           AS GoodsGroupId 
        , CASE WHEN ObjectLink_GoodsGroup.ChildObjectId = 1918 THEN Object_GoodsGroup.ObjectCode ELSE 0 END ::Integer AS GoodsGroupCode  --для сортировки в печати
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

        , tmpGoodsByGoodsKindParam.GoodsCode_basis
        , tmpGoodsByGoodsKindParam.GoodsName_basis
        , tmpGoodsByGoodsKindParam.GoodsCode_main
        , tmpGoodsByGoodsKindParam.GoodsName_main
        , tmpGoodsByGoodsKindParam.NormInDays_gk  ::TFloat

        , CAST (COALESCE(Object_Goods.Id, 0) AS Integer)                 AS GoodsId
        , Object_Goods.ObjectCode        AS GoodsCode
        , CAST (COALESCE(Object_Goods.ValueData, '') AS TVarChar)        AS GoodsName
        , COALESCE (zfCalc_Text_replace (ObjectString_Goods_Scale.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_Scale
        , CAST (COALESCE(Object_GoodsKind.Id, 0) AS Integer)             AS GoodsKindId
        , CASE WHEN Object_GoodsKind.ValueData          <> '' THEN Object_GoodsKind.ValueData
               WHEN tmpMIContainer_group.GoodsKindName_complete <> '' THEN tmpMIContainer_group.GoodsKindName_complete
               ELSE ''
          END :: TVarChar AS GoodsKindName
        , CAST (COALESCE(tmpMIContainer_group.GoodsKindName_complete, '') AS TVarChar) AS GoodsKindName_complete
        , Object_Measure.ValueData           AS MeasureName
        , ObjectFloat_Weight.ValueData       AS Weight
        , ObjectFloat_CountForWeight.ValueData ::TFloat AS CountForWeight
        , ObjectFloat_WeightTare.ValueData     ::TFloat AS WeightTare

        , ObjectDate_In.ValueData       :: TDateTime AS InDate
        , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInName
           
        , tmpMIContainer_group.PartionGoodsId   :: Integer  AS PartionGoodsId
        , tmpMIContainer_group.PartionGoodsName :: TVarChar AS PartionGoodsName

        , tmpMIContainer_group.InvNumber_Partion :: TVarChar  AS InvNumber_Partion
        , tmpMIContainer_group.OperDate_Partion  :: TDateTime AS OperDate_Partion
        , tmpMIContainer_group.Price_Partion     :: TFloat    AS Price_Partion
        , tmpMIContainer_group.Storage_Partion   :: TVarChar  AS Storage_Partion
        , tmpMIContainer_group.Unit_Partion      :: TVarChar  AS Unit_Partion
        , tmpMIContainer_group.PartNumber_Partion  :: TVarChar  AS PartNumber_Partion
        , tmpMIContainer_group.Model_Partion     :: TVarChar  AS Model_Partion

        , Object_AssetTo.ObjectCode      AS AssetToCode
        , Object_AssetTo.ValueData       AS AssetToName

        , tmpMIContainer_group.PartionCellCode ::Integer   AS PartionCellCode
        , tmpMIContainer_group.PartionCellName ::TVarChar  AS PartionCellName
        

        , CAST (tmpMIContainer_group.CountStart          AS TFloat) AS CountStart
        , CAST (tmpMIContainer_group.CountStart * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END          AS TFloat) AS CountStart_Weight
        , CAST (tmpMIContainer_group.CountEnd            AS TFloat) AS CountEnd
        , CAST (tmpMIContainer_group.CountEnd * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END            AS TFloat) AS CountEnd_Weight
        , CAST (tmpMIContainer_group.CountEnd_calc       AS TFloat) AS CountEnd_calc
        , CAST (tmpMIContainer_group.CountEnd_calc * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END       AS TFloat) AS CountEnd_calc_Weight

        , CAST (tmpMIContainer_group.CountIncome         AS TFloat) AS CountIncome
        , CAST (tmpMIContainer_group.CountIncome * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END         AS TFloat) AS CountIncome_Weight
        , CAST (tmpMIContainer_group.CountReturnOut      AS TFloat) AS CountReturnOut
        , CAST (tmpMIContainer_group.CountReturnOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END      AS TFloat) AS CountReturnOut_Weight

        , CAST (tmpMIContainer_group.CountSendIn         AS TFloat) AS CountSendIn
        , CAST (tmpMIContainer_group.CountSendIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END         AS TFloat) AS CountSendIn_Weight
        , CAST (tmpMIContainer_group.CountSendOut        AS TFloat) AS CountSendOut
        , CAST (tmpMIContainer_group.CountSendOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END        AS TFloat) AS CountSendOut_Weight

        , CAST (tmpMIContainer_group.CountSendOnPriceIn  AS TFloat) AS CountSendOnPriceIn
        , CAST (tmpMIContainer_group.CountSendOnPriceIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END  AS TFloat) AS CountSendOnPriceIn_Weight

        , CAST (tmpMIContainer_group.CountSendOnPrice_10500  AS TFloat) AS CountSendOnPrice_10500
        , CAST (tmpMIContainer_group.CountSendOnPrice_10500 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END  AS TFloat) AS CountSendOnPrice_10500_Weight
        , CAST (tmpMIContainer_group.CountSendOnPrice_40200  AS TFloat) AS CountSendOnPrice_40200
        , CAST (tmpMIContainer_group.CountSendOnPrice_40200 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END  AS TFloat) AS CountSendOnPrice_40200_Weight
        
        
        , CAST (tmpMIContainer_group.CountSendOnPriceOut AS TFloat) AS CountSendOnPriceOut
        , CAST (tmpMIContainer_group.CountSendOnPriceOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS TFloat) AS CountSendOnPriceOut_Weight

        , CAST (tmpMIContainer_group.CountSendOnPriceOut_10900 AS TFloat) AS CountSendOnPriceOut_10900
        , CAST (tmpMIContainer_group.CountSendOnPriceOut_10900 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS TFloat) AS CountSendOnPriceOut_10900_W

        , CAST (tmpMIContainer_group.CountSale           AS TFloat) AS CountSale
        , CAST (tmpMIContainer_group.CountSale * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END           AS TFloat) AS CountSale_Weight
        , CAST (tmpMIContainer_group.CountSale_10500     AS TFloat) AS CountSale_10500
        , CAST (tmpMIContainer_group.CountSale_10500 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END     AS TFloat) AS CountSale_10500_Weight
        , CAST (tmpMIContainer_group.CountSale_40208     AS TFloat) AS CountSale_40208
        , CAST (tmpMIContainer_group.CountSale_40208 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END     AS TFloat) AS CountSale_40208_Weight

        , CAST (tmpMIContainer_group.CountReturnIn       AS TFloat) AS CountReturnIn
        , CAST (tmpMIContainer_group.CountReturnIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END       AS TFloat) AS CountReturnIn_Weight
        , CAST (tmpMIContainer_group.CountReturnIn_40208 AS TFloat) AS CountReturnIn_40208
        , CAST (tmpMIContainer_group.CountReturnIn_40208 * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS TFloat) AS CountReturnIn_40208_Weight

        , CAST (tmpMIContainer_group.CountLoss           AS TFloat) AS CountLoss
        , CAST (tmpMIContainer_group.CountLoss * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END           AS TFloat) AS CountLoss_Weight
        , CAST (tmpMIContainer_group.CountInventory      AS TFloat) AS CountInventory
        , CAST (tmpMIContainer_group.CountInventory * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END      AS TFloat) AS CountInventory_Weight

        , CAST (tmpMIContainer_group.CountProductionIn   AS TFloat) AS CountProductionIn
        , CAST (tmpMIContainer_group.CountProductionIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END   AS TFloat) AS CountProductionIn_Weight
        , CAST (tmpMIContainer_group.CountProductionOut  AS TFloat) AS CountProductionOut
        , CAST (tmpMIContainer_group.CountProductionOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END  AS TFloat) AS CountProductionOut_Weight

        , CAST (tmpMIContainer_group.CountTotalIn        AS TFloat) AS CountTotalIn
        , CAST (tmpMIContainer_group.CountTotalIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END        AS TFloat) AS CountTotalIn_Weight
        , CAST (tmpMIContainer_group.CountTotalOut       AS TFloat) AS CountTotalOut
        , CAST (tmpMIContainer_group.CountTotalOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END       AS TFloat) AS CountTotalOut_Weight

        --  CountCount
        , CAST (tmpMIContainer_group.CountStart_byCount         AS TFloat)  AS CountStart_byCount        
        , CAST (tmpMIContainer_group.CountEnd_byCount           AS TFloat)  AS CountEnd_byCount          
        , CAST (tmpMIContainer_group.CountIncome_byCount        AS TFloat)  AS CountIncome_byCount      
        , CAST (tmpMIContainer_group.CountReturnOut_byCount     AS TFloat)  AS CountReturnOut_byCount    
        , CAST (tmpMIContainer_group.CountSendIn_byCount        AS TFloat)  AS CountSendIn_byCount       
        , CAST (tmpMIContainer_group.CountSendOut_byCount       AS TFloat)  AS CountSendOut_byCount      
        , CAST (tmpMIContainer_group.CountSendOnPriceIn_byCount  AS TFloat)  AS CountSendOnPriceIn_byCount 
        , CAST (tmpMIContainer_group.CountSendOnPriceOut_byCount AS TFloat)  AS CountSendOnPriceOut_byCount
        , 0 :: TFloat AS CountReturnIn_40208_byCount
        , 0 :: TFloat AS CountReturnIn_byCount
        , 0 :: TFloat AS CountSale_byCount
        , 0 :: TFloat AS CountSale_40208_byCount
        , 0 :: TFloat AS CountSale_10500_byCount
        , 0 :: TFloat AS CountProductionIn_byCount
        , 0 :: TFloat AS CountProductionOut_byCount
        , 0 :: TFloat AS CountLoss_byCount
        , 0 :: TFloat AS CountInventory_byCount

        , CAST (tmpMIContainer_group.SummStart            AS TFloat) AS SummStart
        , CAST (tmpMIContainer_group.SummEnd              AS TFloat) AS SummEnd
        , CAST (tmpMIContainer_group.SummEnd_calc         AS TFloat) AS SummEnd_calc
        , CAST (tmpMIContainer_group.SummIncome           AS TFloat) AS SummIncome
        , CAST (tmpMIContainer_group.SummReturnOut        AS TFloat) AS SummReturnOut
        , CAST (tmpMIContainer_group.SummSendIn           AS TFloat) AS SummSendIn
        , CAST (tmpMIContainer_group.SummSendOut          AS TFloat) AS SummSendOut
        , CAST (tmpMIContainer_group.SummSendOnPriceIn    AS TFloat) AS SummSendOnPriceIn

        , CAST (tmpMIContainer_group.SummSendOnPriceOut         AS TFloat) AS SummSendOnPriceOut
        , CAST (tmpMIContainer_group.SummSendOnPriceOut_10900   AS TFloat) AS SummSendOnPriceOut_10900

        , CAST (tmpMIContainer_group.SummSendOnPrice_10500       AS TFloat) AS SummSendOnPrice_10500
        , CAST (tmpMIContainer_group.SummSendOnPrice_40200       AS TFloat) AS SummSendOnPrice_40200
        , CAST (tmpMIContainer_group.SummSale             AS TFloat) AS SummSale
        , CAST (tmpMIContainer_group.SummSale_10500       AS TFloat) AS SummSale_10500
        , CAST (tmpMIContainer_group.SummSale_40208       AS TFloat) AS SummSale_40208
        , CAST (tmpMIContainer_group.SummReturnIn         AS TFloat) AS SummReturnIn
        , CAST (tmpMIContainer_group.SummReturnIn_40208   AS TFloat) AS SummReturnIn_40208
        , CAST (tmpMIContainer_group.SummLoss             AS TFloat) AS SummLoss
        , CAST (tmpMIContainer_group.SummInventory        AS TFloat) AS SummInventory
        , CAST (tmpMIContainer_group.SummInventory_Basis  AS TFloat) AS SummInventory_Basis
        , CAST (tmpMIContainer_group.SummInventory_RePrice AS TFloat) AS SummInventory_RePrice
        , CAST (tmpMIContainer_group.SummProductionIn     AS TFloat) AS SummProductionIn
        , CAST (tmpMIContainer_group.SummProductionOut    AS TFloat) AS SummProductionOut
        , CAST (tmpMIContainer_group.SummTotalIn          AS TFloat) AS SummTotalIn
        , CAST (tmpMIContainer_group.SummTotalOut         AS TFloat) AS SummTotalOut

        , CAST (CASE WHEN tmpMIContainer_group.CountStart <> 0
                          THEN tmpMIContainer_group.SummStart / tmpMIContainer_group.CountStart
                     ELSE 0
                END AS TFloat) AS PriceStart
        , CAST (CASE WHEN tmpMIContainer_group.CountEnd <> 0
                          THEN tmpMIContainer_group.SummEnd / tmpMIContainer_group.CountEnd
                     ELSE 0
                END AS TFloat) AS PriceEnd

        , CAST (CASE WHEN tmpMIContainer_group.CountIncome <> 0
                          THEN tmpMIContainer_group.SummIncome / tmpMIContainer_group.CountIncome
                     ELSE 0
                END AS TFloat) AS PriceIncome
        , CAST (CASE WHEN tmpMIContainer_group.CountReturnOut <> 0
                          THEN tmpMIContainer_group.SummReturnOut / tmpMIContainer_group.CountReturnOut
                     ELSE 0
                END AS TFloat) AS PriceReturnOut

        , CAST (CASE WHEN tmpMIContainer_group.CountSendIn <> 0
                          THEN tmpMIContainer_group.SummSendIn / tmpMIContainer_group.CountSendIn
                     ELSE 0
                END AS TFloat) AS PriceSendIn
        , CAST (CASE WHEN tmpMIContainer_group.CountSendOut <> 0
                          THEN tmpMIContainer_group.SummSendOut / tmpMIContainer_group.CountSendOut
                     ELSE 0
                END AS TFloat) AS PriceSendOut

        , CAST (CASE WHEN tmpMIContainer_group.CountSendOnPriceIn <> 0
                          THEN tmpMIContainer_group.SummSendOnPriceIn / tmpMIContainer_group.CountSendOnPriceIn
                     ELSE 0
                END AS TFloat) AS PriceSendOnPriceIn
        , CAST (CASE WHEN tmpMIContainer_group.CountSendOnPriceOut <> 0
                          THEN tmpMIContainer_group.SummSendOnPriceOut / tmpMIContainer_group.CountSendOnPriceOut
                     ELSE 0
                END AS TFloat) AS PriceSendOnPriceOut

        , CAST (CASE WHEN tmpMIContainer_group.CountSale <> 0
                          THEN tmpMIContainer_group.SummSale / tmpMIContainer_group.CountSale
                     ELSE 0
                END AS TFloat) AS PriceSale
        , CAST (CASE WHEN tmpMIContainer_group.CountReturnIn <> 0
                          THEN tmpMIContainer_group.SummReturnIn / tmpMIContainer_group.CountReturnIn
                     ELSE 0
                END AS TFloat) AS PriceReturnIn

        , CAST (CASE WHEN tmpMIContainer_group.CountLoss <> 0
                          THEN tmpMIContainer_group.SummLoss / tmpMIContainer_group.CountLoss
                     ELSE 0
                END AS TFloat) AS PriceLoss
        , CAST (CASE WHEN tmpMIContainer_group.CountInventory <> 0
                          THEN tmpMIContainer_group.SummInventory / tmpMIContainer_group.CountInventory
                     ELSE 0
                END AS TFloat) AS PriceInventory
        , CAST (CASE WHEN tmpMIContainer_group.CountProductionIn <> 0
                          THEN tmpMIContainer_group.SummProductionIn / tmpMIContainer_group.CountProductionIn
                     ELSE 0
                END AS TFloat) AS PriceProductionIn
        , CAST (CASE WHEN tmpMIContainer_group.CountProductionOut <> 0
                          THEN tmpMIContainer_group.SummProductionOut / tmpMIContainer_group.CountProductionOut
                     ELSE 0
                END AS TFloat) AS PriceProductionOut

        , CAST (CASE WHEN tmpMIContainer_group.CountTotalIn <> 0
                          THEN tmpMIContainer_group.SummTotalIn / tmpMIContainer_group.CountTotalIn
                     ELSE 0
                END AS TFloat) AS PriceTotalIn
        , CAST (CASE WHEN tmpMIContainer_group.CountTotalOut <> 0
                          THEN tmpMIContainer_group.SummTotalOut / tmpMIContainer_group.CountTotalOut
                     ELSE 0
                END AS TFloat) AS PriceTotalOut

        , tmpMIContainer_group.CountProductionIn_by :: TFloat  -- приход с произв. (если с другого подр., т.е. не пересорт)
        , (tmpMIContainer_group.CountProductionIn_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountProductionIn_by_Weight
        , tmpMIContainer_group.SummProductionIn_by  :: TFloat -- приход с произв. (если с другого подр., т.е. не пересорт)
        , tmpMIContainer_group.CountIn_by           :: TFloat -- приход с "выбранного" подр.
        , (tmpMIContainer_group.CountIn_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountIn_by_Weight
        , tmpMIContainer_group.SummIn_by            :: TFloat -- приход с "выбранного" подр.
        , tmpMIContainer_group.CountOtherIn_by      :: TFloat -- приход другой
        , (tmpMIContainer_group.CountOtherIn_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOtherIn_by_Weight
        , tmpMIContainer_group.SummOtherIn_by       :: TFloat -- приход другой

        , tmpMIContainer_group.CountOut_by      :: TFloat -- расход на "выбранное" подр.
        , (tmpMIContainer_group.CountOut_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOut_by_Weight
        , tmpMIContainer_group.SummOut_by       :: TFloat -- расход на "выбранное" подр.
        , tmpMIContainer_group.CountOtherOut_by :: TFloat -- расход другой
        , (tmpMIContainer_group.CountOtherOut_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOtherOut_by_Weight
        , tmpMIContainer_group.SummOtherOut_by  :: TFloat -- расход другой

        , COALESCE (tmpPriceStart_kind.Price,tmpPriceStart.Price) AS PriceListStart
        , COALESCE (tmpPriceEnd_kind.Price, tmpPriceEnd.Price)   AS PriceListEnd

        , View_InfoMoney.InfoMoneyId
        , View_InfoMoney.InfoMoneyCode
        , View_InfoMoney.InfoMoneyGroupName
        , View_InfoMoney.InfoMoneyDestinationName
        , View_InfoMoney.InfoMoneyName
        , View_InfoMoney.InfoMoneyName_all

        , View_InfoMoneyDetail.InfoMoneyId              AS InfoMoneyId_Detail
        , View_InfoMoneyDetail.InfoMoneyCode            AS InfoMoneyCode_Detail
        , View_InfoMoneyDetail.InfoMoneyGroupName       AS InfoMoneyGroupName_Detail
        , View_InfoMoneyDetail.InfoMoneyDestinationName AS InfoMoneyDestinationName_Detail
        , View_InfoMoneyDetail.InfoMoneyName            AS InfoMoneyName_Detail
        , View_InfoMoneyDetail.InfoMoneyName_all        AS InfoMoneyName_all_Detail

        , CASE WHEN tmpMIContainer_group.ContainerId > 0       THEN tmpMIContainer_group.ContainerId       ELSE tmpMIContainer_group.ContainerId_count_max END :: Integer AS ContainerId_Summ
        , CASE WHEN tmpMIContainer_group.ContainerId_count > 0 THEN tmpMIContainer_group.ContainerId_count ELSE tmpMIContainer_group.ContainerId_begin_max END :: Integer AS ContainerId_count

        , tmpMIContainer_group.ContainerId_count_max :: Integer
        , tmpMIContainer_group.ContainerId_begin_max :: Integer

        , CAST (row_number() OVER () AS INTEGER)        AS LineNum

        , CAST( CASE WHEN COALESCE(Object_Car.ValueData,'') <> '' THEN Object_Car.ValueData ELSE COALESCE(Object_Location.ValueData,'') END  AS TVarChar)  AS LocationName_inf

      FROM tmpMIContainer_group

        LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                      ON CLO_InfoMoney.ContainerId = tmpMIContainer_group.ContainerId
                                     AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CLO_InfoMoney.ObjectId
        LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                      ON CLO_InfoMoneyDetail.ContainerId = tmpMIContainer_group.ContainerId
                                     AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = CLO_InfoMoneyDetail.ObjectId

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIContainer_group.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer_group.GoodsKindId
        LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = tmpMIContainer_group.LocationId
        -- LEFT JOIN ObjectDesc AS ObjectDesc_find ON ObjectDesc_find.Id = Object_Location_find.DescId
        LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = tmpMIContainer_group.LocationId
                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = CASE WHEN tmpMIContainer_group.CarId > 0 THEN tmpMIContainer_group.CarId WHEN Object_Location_find.DescId = zc_Object_Car() THEN Object_Location_find.Id END -- CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN tmpMIContainer_group.LocationId END
        LEFT JOIN Object AS Object_Location ON Object_Location.Id = CASE WHEN tmpMIContainer_group.LocationId = tmpMIContainer_group.CarId OR Object_Location_find.DescId = zc_Object_Car() THEN ObjectLink_Car_Unit.ChildObjectId ELSE tmpMIContainer_group.LocationId END -- CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN ObjectLink_Car_Unit.ChildObjectId ELSE tmpMIContainer_group.LocationId END
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = CASE WHEN tmpMIContainer_group.CarId > 0 THEN zc_Object_Car() ELSE Object_Location_find.DescId END

        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                             ON ObjectLink_GoodsGroup.ObjectId = Object_GoodsGroup.Id
                            AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                               ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

        LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                               ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_Scale.DescId = zc_ObjectString_Goods_Scale()

        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                              ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
        LEFT JOIN ObjectFloat AS ObjectFloat_WeightTare 
                              ON ObjectFloat_WeightTare.ObjectId = Object_Goods.Id
                             AND ObjectFloat_WeightTare.DescId = zc_ObjectFloat_Goods_WeightTare()

        LEFT JOIN ObjectFloat AS ObjectFloat_CountForWeight
                              ON ObjectFloat_CountForWeight.ObjectId = Object_Goods.Id 
                             AND ObjectFloat_CountForWeight.DescId = zc_ObjectFloat_Goods_CountForWeight()

        LEFT JOIN ObjectDate AS ObjectDate_In
                             ON ObjectDate_In.ObjectId = tmpMIContainer_group.GoodsId
                            AND ObjectDate_In.DescId = zc_ObjectDate_Goods_In()

        LEFT JOIN ObjectLink AS ObjectLink_Goods_PartnerIn
                             ON ObjectLink_Goods_PartnerIn.ObjectId = tmpMIContainer_group.GoodsId
                            AND ObjectLink_Goods_PartnerIn.DescId = zc_ObjectLink_Goods_PartnerIn()
        LEFT JOIN Object AS Object_PartnerIn ON Object_PartnerIn.Id = ObjectLink_Goods_PartnerIn.ChildObjectId
        LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = tmpMIContainer_group.AssetToId
        /*  --все свойства партии выше в группировке
        LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                             ON ObjectLink_GoodsKindComplete.ObjectId = tmpMIContainer_group.PartionGoodsId
                            AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
        LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = ObjectLink_GoodsKindComplete.ChildObjectId
        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_group.PartionGoodsId
        --LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = tmpMIContainer_group.AssetToId

        LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                             ON ObjectLink_PartionCell.ObjectId = tmpMIContainer_group.PartionGoodsId
                            AND ObjectLink_PartionCell.DescId = zc_ObjectLink_PartionGoods_PartionCell()
        LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = ObjectLink_PartionCell.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods
                             ON ObjectLink_Goods.ObjectId = tmpMIContainer_group.PartionGoodsId
                            AND ObjectLink_Goods.DescId = zc_ObjectLink_PartionGoods_Goods()
        LEFT JOIN ObjectLink AS ObjectLink_Unit
                             ON ObjectLink_Unit.ObjectId = tmpMIContainer_group.PartionGoodsId
                            AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Storage
                             ON ObjectLink_Storage.ObjectId = tmpMIContainer_group.PartionGoodsId
                            AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
        LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId
        LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                             ON ObjectDate_PartionGoods_Value.ObjectId = tmpMIContainer_group.PartionGoodsId
                            AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
        LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Price
                              ON ObjectFloat_PartionGoods_Price.ObjectId = tmpMIContainer_group.PartionGoodsId
                             AND ObjectFloat_PartionGoods_Price.DescId = zc_ObjectFloat_PartionGoods_Price()

        LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                             ON ObjectLink_PartionModel.ObjectId = tmpMIContainer_group.PartionGoodsId
                            AND ObjectLink_PartionModel.DescId   = zc_ObjectLink_PartionGoods_PartionModel()
        LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId
        LEFT JOIN ObjectString AS ObjectString_PartNumber
                               ON ObjectString_PartNumber.ObjectId = tmpMIContainer_group.PartionGoodsId
                              AND ObjectString_PartNumber.DescId   = zc_ObjectString_PartionGoods_PartNumber()
        */

        LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpMIContainer_group.AccountId

        -- привязываем цены 2 раза по виду товара и без
        LEFT JOIN tmpPriceStart ON tmpPriceStart.GoodsId = tmpMIContainer_group.GoodsId
                               AND tmpPriceStart.GoodsKindId IS NULL
        LEFT JOIN tmpPriceStart AS tmpPriceStart_kind
                                ON tmpPriceStart_kind.GoodsId = tmpMIContainer_group.GoodsId
                               AND COALESCE (tmpPriceStart_kind.GoodsKindId,0) = COALESCE (tmpMIContainer_group.GoodsKindId, 0)

        LEFT JOIN tmpPriceEnd ON tmpPriceEnd.GoodsId = tmpMIContainer_group.GoodsId
                             AND tmpPriceEnd.GoodsKindId IS NULL
        LEFT JOIN tmpPriceEnd AS tmpPriceEnd_kind
                              ON tmpPriceEnd_kind.GoodsId = tmpMIContainer_group.GoodsId
                             AND COALESCE (tmpPriceEnd_kind.GoodsKindId,0) = COALESCE (tmpMIContainer_group.GoodsKindId, 0)

        LEFT JOIN tmpGoodsByGoodsKindParam ON tmpGoodsByGoodsKindParam.GoodsId = tmpMIContainer_group.GoodsId
                                          AND COALESCE (tmpGoodsByGoodsKindParam.GoodsKindId, 0) = COALESCE (tmpMIContainer_group.GoodsKindId, 0)
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.01.24         *
 09.08.22         *  NormInDays_gk
 18.12.19         *
 14.11.18         *
 19.10.18         *
 11.07.15                                        * add GoodsKindName_complete
 09.05.15                                        *
*/

-- тест
-- SELECT * FROM gpReport_MotionGoods (inStartDate:= '01.01.2015', inEndDate:= '01.01.2015', inAccountGroupId:= 0, inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 0, inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= FALSE, inSession:= zfCalc_UserAdmin())
--SELECT * from gpReport_MotionGoods (inStartDate:= '01.12.2023', inEndDate:= '01.12.2023', inAccountGroupId:= 0, inUnitGroupId:= 8459, inLocationId:= 0, inGoodsGroupId:= 1860, inGoodsId:= 1, inUnitGroupId_by:= 0, inLocationId_by:= 0, inIsInfoMoney:= FALSE, inIsAllMO:= TRUE, inIsAllAuto:= TRUE, inIsOperDate_Partion:= TRUE, inIsPartionCell := TRUE, inSession := zfCalc_UserAdmin());
-- select * from gpReport_GoodsBalance(inStartDate := ('03.03.2024')::TDateTime , inEndDate := ('23.03.2024')::TDateTime , inAccountGroupId := 0 , inUnitGroupId := 0 , inLocationId := 8448 , inGoodsGroupId := 0 , inGoodsId := 2339 , inIsInfoMoney := 'False' , inIsAllMO := 'False', inIsOperDate_Partion:= TRUE, inIsPartionCell := TRUE, inIsAllAuto := 'False' ,  inSession := '5');
