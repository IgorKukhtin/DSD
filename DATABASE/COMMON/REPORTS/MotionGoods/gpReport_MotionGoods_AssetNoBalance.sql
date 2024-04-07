-- Function: gpReport_MotionGoods_AssetNoBalance()

DROP FUNCTION IF EXISTS gpReport_MotionGoods_AssetNoBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MotionGoods_AssetNoBalance(
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
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (AccountGroupName TVarChar, AccountDirectionName TVarChar
             , AccountId Integer, AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
             , LocationDescName TVarChar, LocationId Integer, LocationCode Integer, LocationName TVarChar

             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsDescName TVarChar, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , Weight TFloat
             , PartionGoodsId Integer, PartionGoodsName TVarChar
             , PartionGoodsDate TDateTime                       -- дата ввода в эксплуатацию 
             , MovementPartionGoods_InvNumber TVarChar 
             , PartionModelName_asset TVarChar, KW_asset TFloat
             , AssetToCode Integer, AssetToName TVarChar
             , AssetToGroupName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , StorageName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , CarName TVarChar, EngineNum TVarChar, VIN TVarChar, RegistrationCertificate TVarChar
             , CarModelCode Integer, CarModelName TVarChar 
             , CarTypeCode Integer, CarTypeName TVarChar
             , BodyTypeCode Integer, BodyTypeName TVarChar
             , Year_car TFloat
             
             , Release_Partion TDateTime
             , Price_Partion        TFloat
             , PartNumber_Partion   TVarChar
             , Model_Partion        TVarChar  
             , PartnerName_Partion      TVarChar
             , UnitName_Storage     TVarChar
             , BranchName_Storage   TVarChar 
             , AreaUnitName_Storage TVarChar
             , Room_Storage         TVarChar
             , Address_Storage      TVarChar

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
             
             , CountSendOnPriceOut TFloat
             , CountSendOnPriceOut_Weight TFloat

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

             , SummStart TFloat
             , SummEnd TFloat
             , SummEnd_calc TFloat
             , SummIncome TFloat
             , SummReturnOut TFloat
             , SummSendIn TFloat
             , SummSendOut TFloat
             , SummSendOnPriceIn TFloat
             , SummSendOnPriceOut TFloat
             , SummSendOnPrice_10500  TFloat
             , SummSendOnPrice_40200  TFloat
             , SummSale TFloat
             , SummSale_10500 TFloat
             , SummSale_40208 TFloat
             , SummReturnIn TFloat
             , SummReturnIn_40208 TFloat
             , SummLoss TFloat
             , SummInventory TFloat
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

             , ContainerId_Summ Integer
             , LineNum Integer 
             , NumGroup_print Integer

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


    -- !!!замена - Необоротные активы!!!
    -- IF COALESCE (inAccountGroupId, 0) = 0 THEN inAccountGroupId:= zc_Enum_AccountGroup_10000(); END IF;


    -- !!!определяется!!!
    vbIsSummIn:= NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND RoleId = 442647); -- Отчеты руководитель сырья

    -- таблица -
    --CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;
    --CREATE TEMP TABLE _tmpLocation_by (LocationId Integer) ON COMMIT DROP;
    
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpLocation'))
     THEN
         DELETE FROM _tmpLocation;
     ELSE
         CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;
    END IF;
    
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpLocation_by'))
     THEN
         DELETE FROM _tmpLocation_by;
     ELSE
        CREATE TEMP TABLE _tmpLocation_by (LocationId Integer) ON COMMIT DROP; 
    END IF;


    -- группа подразделений или подразделение или место учета (МО, Авто)
    IF inUnitGroupId <> 0 AND COALESCE (inLocationId, 0) = 0
    THEN
        INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
           SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
                , zc_ContainerLinkObject_Unit()       AS DescId
                , tmpDesc.ContainerDescId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE
                     UNION SELECT zc_Container_CountAsset() AS ContainerDescId UNION SELECT zc_Container_SummAsset() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
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
                    LEFT JOIN (SELECT zc_Container_Count()      AS ContainerDescId
                         UNION SELECT zc_Container_Summ()       AS ContainerDescId WHERE vbIsSummIn = TRUE
                         UNION SELECT zc_Container_CountAsset() AS ContainerDescId
                         UNION SELECT zc_Container_SummAsset()  AS ContainerDescId WHERE vbIsSummIn = TRUE
                              ) AS tmpDesc ON 1 = 1
               WHERE Object.Id = inLocationId
              ;
        ELSE
            -- inLocationId:= -1;
            INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
              SELECT tmp.LocationId, tmp.DescId, tmpDesc.ContainerDescId
              FROM (SELECT zc_Juridical_Basis() AS LocationId, zc_ContainerLinkObject_Unit() AS DescId
                   UNION ALL
                    SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Unit() AS DescId FROM Object WHERE Object.DescId = zc_Object_Unit()
                   UNION ALL
                    SELECT Object.Id, zc_ContainerLinkObject_Member() AS DescId FROM Object WHERE Object.DescId = zc_Object_Member()
                   ) AS tmp
                   LEFT JOIN (SELECT zc_Container_Count()      AS ContainerDescId
                        UNION SELECT zc_Container_Summ()       AS ContainerDescId WHERE vbIsSummIn = TRUE
                        UNION SELECT zc_Container_CountAsset() AS ContainerDescId
                        UNION SELECT zc_Container_SummAsset()  AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
             ;
        END IF;
    END IF;
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
    WITH tmpPriceStart AS (SELECT NULL :: Integer AS GoodsId, NULL :: TFloat AS Price WHERE 1 = 0)
         , tmpPriceEnd AS (SELECT NULL :: Integer AS GoodsId, NULL :: TFloat AS Price WHERE 1 = 0)  
         
         -- !!!криво хардкодим ОС и все что для них!!!
       , tmpReport_all AS (SELECT tmp.* FROM lpReport_MotionGoods (inStartDate:= inStartDate, inEndDate:= inEndDate, inAccountGroupId:= -1 * zc_Enum_AccountGroup_10000()
                                                                 , inUnitGroupId:= inUnitGroupId, inLocationId:= inLocationId, inGoodsGroupId:= inGoodsGroupId
                                                                 , inGoodsId:= inGoodsId, inIsInfoMoney:= inIsInfoMoney, inUserId:= vbUserId) AS tmp 
--                           WHERE vbUserId <> 5
                         UNION ALL
                           SELECT tmp.* FROM lpReport_MotionGoods (inStartDate:= inStartDate, inEndDate:= inEndDate
                                                                 , inAccountGroupId:= -1 * zc_Enum_AccountGroup_20000()
                                                                 , inUnitGroupId:= inUnitGroupId, inLocationId:= inLocationId
                                                                   -- добавить "МНМА + ОС"
                                                                 , inGoodsGroupId:= CASE WHEN inGoodsGroupId = 0 AND inGoodsId = 0 THEN 9354099 ELSE inGoodsGroupId END
                                                                 , inGoodsId:= inGoodsId, inIsInfoMoney:= inIsInfoMoney, inUserId:= vbUserId) AS tmp 
                             WHERE (inGoodsGroupId = 0 OR inGoodsGroupId = 9354099) AND inGoodsId = 0
                             AND 1=0
                           --WHERE inGoodsGroupId = 0 AND inGoodsId = 0   
                         UNION ALL
                           SELECT tmp.* FROM lpReport_MotionGoods (inStartDate:= inStartDate, inEndDate:= inEndDate
                                                                 , inAccountGroupId:= -1 * zc_Enum_AccountGroup_20000()
                                                                 , inUnitGroupId:= inUnitGroupId, inLocationId:= inLocationId
                                                                   -- добавить "ШИНЫ", если выбрали ВСЕ или "МНМА + ОС"
                                                                 , inGoodsGroupId:= CASE WHEN (inGoodsGroupId = 0 OR inGoodsGroupId = 9354099) AND inGoodsId = 0 THEN 7597944 ELSE inGoodsGroupId END
                                                                 , inGoodsId:= inGoodsId, inIsInfoMoney:= inIsInfoMoney, inUserId:= vbUserId) AS tmp 
                           --WHERE (inGoodsGroupId = 0 OR inGoodsGroupId = 9354099) AND inGoodsId = 0
                           WHERE (inGoodsGroupId = 0 OR inGoodsGroupId = 9354099) AND inGoodsId = 0
                          )
        
        
       , tmpReport_summ AS (SELECT * FROM tmpReport_all WHERE inIsInfoMoney = FALSE OR ContainerId_count <> ContainerId)
       , tmpReport_count AS (SELECT * FROM tmpReport_all WHERE inIsInfoMoney = TRUE AND ContainerId_count = ContainerId)
       , tmpReport AS (SELECT COALESCE (tmpReport_summ.AccountId,         tmpReport_count.AccountId)         AS AccountId
                            , COALESCE (tmpReport_summ.ContainerDescId_count, tmpReport_count.ContainerDescId_count) AS ContainerDescId_count
                            , COALESCE (tmpReport_summ.ContainerId_count, tmpReport_count.ContainerId_count) AS ContainerId_count
                            , COALESCE (tmpReport_summ.ContainerId,       tmpReport_count.ContainerId)       AS ContainerId
                            , COALESCE (tmpReport_summ.LocationId,        tmpReport_count.LocationId)        AS LocationId
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

                            , COALESCE (tmpReport_count.CountSendOnPriceIn,  tmpReport_summ.CountSendOnPriceIn)  AS CountSendOnPriceIn 
                            , COALESCE (tmpReport_count.CountSendOnPrice_10500,  tmpReport_summ.CountSendOnPrice_10500)  AS CountSendOnPrice_10500 
                            , COALESCE (tmpReport_count.CountSendOnPrice_40200,  tmpReport_summ.CountSendOnPrice_40200)  AS CountSendOnPrice_40200 
                            , COALESCE (tmpReport_count.CountSendOnPriceOut, tmpReport_summ.CountSendOnPriceOut) AS CountSendOnPriceOut

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

                            , COALESCE (tmpReport_count.CountLoss,      tmpReport_summ.CountLoss) * (-1)       AS CountLoss     
                            , COALESCE (tmpReport_count.CountInventory, tmpReport_summ.CountInventory)         AS CountInventory

                            , COALESCE (tmpReport_count.CountProductionIn,  tmpReport_summ.CountProductionIn)  AS CountProductionIn 
                            , COALESCE (tmpReport_count.CountProductionOut, tmpReport_summ.CountProductionOut) AS CountProductionOut

                            , COALESCE (tmpReport_summ.SummStart, 0)    AS SummStart   
                            , COALESCE (tmpReport_summ.SummEnd, 0)      AS SummEnd     
                            , COALESCE (tmpReport_summ.SummEnd_calc, 0) AS SummEnd_calc

                            , COALESCE (tmpReport_summ.SummIncome, 0)    AS SummIncome   
                            , COALESCE (tmpReport_summ.SummReturnOut, 0) AS SummReturnOut

                            , COALESCE (tmpReport_summ.SummSendIn, 0)  AS SummSendIn 
                            , COALESCE (tmpReport_summ.SummSendOut, 0) AS SummSendOut

                            , COALESCE (tmpReport_summ.SummSendOnPriceIn, 0)  AS SummSendOnPriceIn
                            , COALESCE (tmpReport_summ.SummSendOnPriceOut, 0) AS SummSendOnPriceOut

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

                            , COALESCE (tmpReport_summ.SummLoss, 0) * (-1)       AS SummLoss             
                            , COALESCE (tmpReport_summ.SummInventory, 0)         AS SummInventory        
                            , COALESCE (tmpReport_summ.SummInventory_RePrice, 0) AS SummInventory_RePrice

                            , COALESCE (tmpReport_summ.SummProductionIn, 0)  AS SummProductionIn 
                            , COALESCE (tmpReport_summ.SummProductionOut, 0) AS SummProductionOut
                       FROM tmpReport_summ
                            FULL JOIN tmpReport_count ON tmpReport_count.ContainerId_count = tmpReport_summ.ContainerId_count
                     )
       , tmpCarDriver AS (SELECT tmp.*
                          FROM (SELECT ObjectLink_Car_PersonalDriver.ChildObjectId AS PersonalDriverId
                                     , View_PersonalDriver.MemberId                AS MemberId
                                     , Object_Car.Id                               AS CarId
                                     , ROW_NUMBER () OVER (PARTITION BY View_PersonalDriver.MemberId) AS Ord
                                FROM Object AS Object_Car
                                    INNER JOIN ObjectLink AS ObjectLink_Car_PersonalDriver 
                                                          ON ObjectLink_Car_PersonalDriver.ObjectId = Object_Car.Id
                                                         AND ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
                                    LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = ObjectLink_Car_PersonalDriver.ChildObjectId
                                WHERE Object_Car.isErased = FALSE
                                  AND Object_Car.DescId = zc_Object_Car()
                                ) AS tmp
                          WHERE tmp.Ord = 1
                          )

   -- Результат
   SELECT View_Account.AccountGroupName, View_Account.AccountDirectionName
        , View_Account.AccountId, View_Account.AccountCode, View_Account.AccountName
        , (CASE WHEN tmpMIContainer_group.ContainerDescId_count IN (zc_Container_CountAsset(), zc_Container_SummAsset()) THEN '*з* ' ELSE '' END || COALESCE (View_Account.AccountName_all, '')) :: TVarChar AS AccountName_all
        , ObjectDesc.ItemName            AS LocationDescName
        , CAST (COALESCE(Object_Location.Id, 0) AS Integer)             AS LocationId
        , Object_Location.ObjectCode     AS LocationCode
        , CAST (COALESCE(Object_Location.ValueData,'') AS TVarChar)     AS LocationName

        , Object_GoodsGroup.Id           AS GoodsGroupId
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData         AS GoodsGroupNameFull
        , ObjectDesc_Goods.ItemName      AS GoodsDescName
        , CAST (COALESCE(Object_Goods.Id, 0) AS Integer)     AS GoodsId
        , Object_Goods.ObjectCode        AS GoodsCode
        , CAST (COALESCE(Object_Goods.ValueData, '') AS TVarChar)        AS GoodsName
        , CAST (COALESCE(Object_GoodsKind.Id, 0) AS Integer)             AS GoodsKindId
        , CAST (COALESCE(Object_GoodsKind.ValueData, '') AS TVarChar)    AS GoodsKindName
        
        , Object_Measure.ValueData       AS MeasureName  
        , ObjectFloat_Weight.ValueData   AS Weight

        , CAST (COALESCE(Object_PartionGoods.Id, 0) AS Integer)              AS PartionGoodsId
        , COALESCE ( ObjectString_Asset_InvNumber.ValueData, Object_PartionGoods.ValueData,'') :: TVarChar AS PartionGoodsName
        , COALESCE(ObjectDate_PartionGoods_Value.ValueData,Null) ::TDateTime AS PartionGoodsDate   --дата ввода в эксплуатацию
        , zfCalc_PartionMovementName (Movement_PartionGoods.DescId, MovementDesc_PartionGoods.ItemName, Movement_PartionGoods.InvNumber, Movement_PartionGoods.OperDate) AS MovementPartionGoods_InvNumber

        , Object_Asset_PartionModel.ValueData   ::TVarChar AS PartionModelName_asset
        , COALESCE (ObjectFloat_KW.ValueData,0) :: TFloat  AS KW_asset

        , Object_AssetTo.ObjectCode      AS AssetToCode
        , Object_AssetTo.ValueData       AS AssetToName
        , Object_AssetToGroup.ValueData  AS AssetToGroupName

        , Object_Partner.ObjectCode      AS PartnerCode
        , Object_Partner.ValueData       AS PartnerName

        , Object_Storage.ValueData       AS StorageName
        , Object_Unit.ObjectCode         AS UnitCode
        , Object_Unit.ValueData          AS UnitName

        , Object_Car.ValueData           AS CarName  --гос номер авто
        , ObjectString_EngineNum.ValueData  :: TVarChar AS EngineNum  
        , ObjectString_VIN.ValueData        :: TVarChar AS VIN
        , RegistrationCertificate.ValueData :: TVarChar AS RegistrationCertificate
        , Object_CarModel.ObjectCode AS CarModelCode
        , Object_CarModel.ValueData  AS CarModelName 
        , Object_CarType.ObjectCode  AS CarTypeCode
        , Object_CarType.ValueData   AS CarTypeName
        , Object_BodyType.ObjectCode AS BodyTypeCode
        , Object_BodyType.ValueData  AS BodyTypeName 
        , COALESCE (ObjectFloat_Year.ValueData,0) :: TFloat  AS Year_car

        , ObjectDate_Release.ValueData             ::TDateTime  AS Release_Partion
        , ObjectFloat_PartionGoods_Price.ValueData :: TFloat    AS Price_Partion
        , ObjectString_PartNumber.ValueData        :: TVarChar  AS PartNumber_Partion
        , Object_PartionModel.ValueData            :: TVarChar  AS Model_Partion
        , Object_Partner_Partion.ValueData         :: TVarChar  AS PartnerName_Partion
        , Object_Unit_Storage.ValueData            :: TVarChar  AS UnitName_Storage
        , Object_Branch_Storage.ValueData          :: TVarChar  AS BranchName_Storage
        , Object_AreaUnit_Storage.ValueData        :: TVarChar  AS AreaUnitName_Storage
        , ObjectString_Storage_Room.ValueData      :: TVarChar  AS Room_Storage
        , ObjectString_Storage_Address.ValueData   :: TVarChar  AS Address_Storage
                

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

        , CAST (tmpMIContainer_group.SummStart            AS TFloat) AS SummStart
        , CAST (tmpMIContainer_group.SummEnd              AS TFloat) AS SummEnd
        , CAST (tmpMIContainer_group.SummEnd_calc         AS TFloat) AS SummEnd_calc
        , CAST (tmpMIContainer_group.SummIncome           AS TFloat) AS SummIncome
        , CAST (tmpMIContainer_group.SummReturnOut        AS TFloat) AS SummReturnOut
        , CAST (tmpMIContainer_group.SummSendIn           AS TFloat) AS SummSendIn
        , CAST (tmpMIContainer_group.SummSendOut          AS TFloat) AS SummSendOut
        , CAST (tmpMIContainer_group.SummSendOnPriceIn    AS TFloat) AS SummSendOnPriceIn
        , CAST (tmpMIContainer_group.SummSendOnPriceOut   AS TFloat) AS SummSendOnPriceOut
        , CAST (tmpMIContainer_group.SummSendOnPrice_10500       AS TFloat) AS SummSendOnPrice_10500
        , CAST (tmpMIContainer_group.SummSendOnPrice_40200       AS TFloat) AS SummSendOnPrice_40200
        , CAST (tmpMIContainer_group.SummSale             AS TFloat) AS SummSale
        , CAST (tmpMIContainer_group.SummSale_10500       AS TFloat) AS SummSale_10500
        , CAST (tmpMIContainer_group.SummSale_40208       AS TFloat) AS SummSale_40208
        , CAST (tmpMIContainer_group.SummReturnIn         AS TFloat) AS SummReturnIn
        , CAST (tmpMIContainer_group.SummReturnIn_40208   AS TFloat) AS SummReturnIn_40208
        , CAST (tmpMIContainer_group.SummLoss             AS TFloat) AS SummLoss
        , CAST (tmpMIContainer_group.SummInventory        AS TFloat) AS SummInventory
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

        , tmpPriceStart.Price AS PriceListStart
        , tmpPriceEnd.Price   AS PriceListEnd

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

        , tmpMIContainer_group.ContainerId              AS ContainerId_Summ
        , CAST (row_number() OVER () AS INTEGER)        AS LineNum

        , CASE WHEN COALESCE (Object_Car.Id,0) <> 0 THEN 1
               WHEN Object_Goods.DescId = zc_Object_Asset() THEN 2
               ELSE 3
          END                                 ::Integer AS NumGroup_print
      FROM 
        (SELECT (tmpMIContainer_all.AccountId) AS AccountId
              , tmpMIContainer_all.ContainerDescId_count
              , tmpMIContainer_all.ContainerId
              , tmpMIContainer_all.LocationId
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
              , SUM (tmpMIContainer_all.CountSendOnPriceOut) AS CountSendOnPriceOut

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
                   + tmpMIContainer_all.CountProductionIn
                   + tmpMIContainer_all.CountLoss)           AS CountTotalIn
              , SUM (tmpMIContainer_all.CountReturnOut
                   + tmpMIContainer_all.CountSendOut
                   + tmpMIContainer_all.CountSendOnPriceOut
                   + tmpMIContainer_all.CountSale
                   + tmpMIContainer_all.CountSale_10500
                   - tmpMIContainer_all.CountSale_40208
                   --+ tmpMIContainer_all.CountLoss
                   + tmpMIContainer_all.CountProductionOut)  AS CountTotalOut

              , SUM (tmpMIContainer_all.SummStart)           AS SummStart
              , SUM (tmpMIContainer_all.SummEnd)             AS SummEnd
              , SUM (tmpMIContainer_all.SummEnd_calc)        AS SummEnd_calc
              , SUM (tmpMIContainer_all.SummIncome)          AS SummIncome
              , SUM (tmpMIContainer_all.SummReturnOut)       AS SummReturnOut
              , SUM (tmpMIContainer_all.SummSendIn)          AS SummSendIn
              , SUM (tmpMIContainer_all.SummSendOut)         AS SummSendOut
              , SUM (tmpMIContainer_all.SummSendOnPriceIn)   AS SummSendOnPriceIn
              , SUM (tmpMIContainer_all.SummSendOnPriceOut)  AS SummSendOnPriceOut

              , SUM (tmpMIContainer_all.SummSendOnPrice_10500)      AS SummSendOnPrice_10500
              , SUM (tmpMIContainer_all.SummSendOnPrice_40200)      AS SummSendOnPrice_40200

              , SUM (tmpMIContainer_all.SummSale)            AS SummSale
              , SUM (tmpMIContainer_all.SummSale_10500)      AS SummSale_10500
              , SUM (tmpMIContainer_all.SummSale_40208)      AS SummSale_40208
              , SUM (tmpMIContainer_all.SummReturnIn)        AS SummReturnIn
              , SUM (tmpMIContainer_all.SummReturnIn_40208)  AS SummReturnIn_40208
              , SUM (tmpMIContainer_all.SummLoss)            AS SummLoss
              , SUM (tmpMIContainer_all.SummInventory)       AS SummInventory
              , SUM (tmpMIContainer_all.SummInventory_RePrice) AS SummInventory_RePrice
              , SUM (tmpMIContainer_all.SummProductionIn)    AS SummProductionIn
              , SUM (tmpMIContainer_all.SummProductionOut)   AS SummProductionOut

              , SUM (tmpMIContainer_all.SummIncome
                   + tmpMIContainer_all.SummSendIn
                   + tmpMIContainer_all.SummSendOnPriceIn
                   + tmpMIContainer_all.SummReturnIn
                   + tmpMIContainer_all.SummReturnIn_40208
                   + tmpMIContainer_all.SummProductionIn
                   + tmpMIContainer_all.SummLoss)            AS SummTotalIn
              , SUM (tmpMIContainer_all.SummReturnOut
                   + tmpMIContainer_all.SummSendOut
                   + tmpMIContainer_all.SummSendOnPriceOut
                   + tmpMIContainer_all.SummSale
                   + tmpMIContainer_all.SummSale_10500
                   - tmpMIContainer_all.SummSale_40208
                  -- + tmpMIContainer_all.SummLoss
                   + tmpMIContainer_all.SummProductionOut)   AS SummTotalOut

         FROM tmpReport AS tmpMIContainer_all
             LEFT JOIN _tmpLocation_by ON _tmpLocation_by.LocationId = tmpMIContainer_all.LocationId_by
         GROUP BY tmpMIContainer_all.AccountId
                , tmpMIContainer_all.ContainerDescId_count
                , tmpMIContainer_all.ContainerId
                , tmpMIContainer_all.LocationId
                , tmpMIContainer_all.GoodsId
                , tmpMIContainer_all.GoodsKindId
                , tmpMIContainer_all.PartionGoodsId
                , tmpMIContainer_all.AssetToId
        ) AS tmpMIContainer_group

        LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                      ON CLO_InfoMoney.ContainerId = tmpMIContainer_group.ContainerId
                                     AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CLO_InfoMoney.ObjectId
        LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                      ON CLO_InfoMoneyDetail.ContainerId = tmpMIContainer_group.ContainerId
                                     AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = CLO_InfoMoneyDetail.ObjectId

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIContainer_group.GoodsId
        LEFT JOIN ObjectDesc AS ObjectDesc_Goods ON ObjectDesc_Goods.Id = Object_Goods.DescId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer_group.GoodsKindId
        LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = tmpMIContainer_group.LocationId
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location_find.DescId

        LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpMIContainer_group.LocationId
        --если место учета водитель то по нему получаем авто
        LEFT JOIN tmpCarDriver ON tmpCarDriver.MemberId = tmpMIContainer_group.LocationId 

        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId in (zc_ObjectLink_Goods_GoodsGroup(), zc_ObjectLink_Asset_AssetGroup())
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Asset_InvNumber ON ObjectString_Asset_InvNumber.ObjectId = Object_Goods.Id
                                                              AND ObjectString_Asset_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()

        LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                               ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
        LEFT JOIN ObjectFloat AS ObjectFloat_Weight ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

        LEFT JOIN ObjectLink AS ObjectLink_Asset_Car
                             ON ObjectLink_Asset_Car.ObjectId = Object_Goods.Id
                            AND ObjectLink_Asset_Car.DescId = zc_ObjectLink_Asset_Car()
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = COALESCE (ObjectLink_Asset_Car.ChildObjectId, tmpCarDriver.CarId)

        LEFT JOIN ObjectLink AS Car_CarModel
                             ON Car_CarModel.ObjectId = Object_Car.Id
                            AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
        LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId
 
        LEFT JOIN ObjectLink AS Car_CarType
                             ON Car_CarType.ObjectId = Object_Car.Id
                            AND Car_CarType.DescId = zc_ObjectLink_Car_CarType()
        LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = Car_CarType.ChildObjectId
 
        LEFT JOIN ObjectLink AS Car_BodyType
                             ON Car_BodyType.ObjectId = Object_Car.Id
                            AND Car_BodyType.DescId = zc_ObjectLink_Car_BodyType()
        LEFT JOIN Object AS Object_BodyType ON Object_BodyType.Id = Car_BodyType.ChildObjectId
 
        LEFT JOIN ObjectString AS ObjectString_EngineNum
                               ON ObjectString_EngineNum.ObjectId = Object_Car.Id
                              AND ObjectString_EngineNum.DescId = zc_ObjectString_Car_EngineNum()

        LEFT JOIN ObjectString AS RegistrationCertificate 
                               ON RegistrationCertificate.ObjectId = Object_Car.Id 
                              AND RegistrationCertificate.DescId = zc_ObjectString_Car_RegistrationCertificate()
        LEFT JOIN ObjectString AS ObjectString_VIN
                               ON ObjectString_VIN.ObjectId = Object_Car.Id
                              AND ObjectString_VIN.DescId = zc_ObjectString_Car_VIN()
        LEFT JOIN ObjectFloat AS ObjectFloat_Year
                              ON ObjectFloat_Year.ObjectId = Object_Car.Id
                             AND ObjectFloat_Year.DescId = zc_ObjectFloat_Car_Year()

        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_group.PartionGoodsId
        LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = tmpMIContainer_group.AssetToId

        LEFT JOIN ObjectLink AS ObjectLink_AssetTo_GoodsGroup
                             ON ObjectLink_AssetTo_GoodsGroup.ObjectId = Object_AssetTo.Id
                            AND ObjectLink_AssetTo_GoodsGroup.DescId = zc_ObjectLink_Asset_AssetGroup()
        LEFT JOIN Object AS Object_AssetToGroup ON Object_AssetToGroup.Id = ObjectLink_AssetTo_GoodsGroup.ChildObjectId

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

        LEFT JOIN ObjectDate AS ObjectDate_Release
                             ON ObjectDate_Release.ObjectId = ObjectLink_Goods.ChildObjectId
                            AND ObjectDate_Release.DescId = zc_ObjectDate_Asset_Release()  

        LEFT JOIN ObjectLink AS ObjectLink_Asset_PartionModel
                             ON ObjectLink_Asset_PartionModel.ObjectId = ObjectLink_Goods.ChildObjectId
                            AND ObjectLink_Asset_PartionModel.DescId = zc_ObjectLink_Asset_PartionModel()
        LEFT JOIN Object AS Object_Asset_PartionModel ON Object_Asset_PartionModel.Id = ObjectLink_Asset_PartionModel.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_KW
                              ON ObjectFloat_KW.ObjectId = ObjectLink_Goods.ChildObjectId
                             AND ObjectFloat_KW.DescId = zc_ObjectFloat_Asset_KW()
  
        LEFT JOIN ObjectString AS ObjectString_Storage_Address
                               ON ObjectString_Storage_Address.ObjectId = Object_Storage.Id 
                              AND ObjectString_Storage_Address.DescId = zc_ObjectString_Storage_Address()
        LEFT JOIN ObjectString AS ObjectString_Storage_Room
                               ON ObjectString_Storage_Room.ObjectId = Object_Storage.Id 
                              AND ObjectString_Storage_Room.DescId = zc_ObjectString_Storage_Room()
        LEFT JOIN ObjectLink AS ObjectLink_Storage_AreaUnit
                             ON ObjectLink_Storage_AreaUnit.ObjectId = Object_Storage.Id 
                            AND ObjectLink_Storage_AreaUnit.DescId = zc_ObjectLink_Storage_AreaUnit()
        LEFT JOIN Object AS Object_AreaUnit_Storage ON Object_AreaUnit_Storage.Id = ObjectLink_Storage_AreaUnit.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Storage_Unit
                             ON ObjectLink_Storage_Unit.ObjectId = Object_Storage.Id 
                            AND ObjectLink_Storage_Unit.DescId = zc_ObjectLink_Storage_Unit()
        LEFT JOIN Object AS Object_Unit_Storage ON Object_Unit_Storage.Id = ObjectLink_Storage_Unit.ChildObjectId
 
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
        LEFT JOIN Object AS Object_Branch_Storage ON Object_Branch_Storage.Id = ObjectLink_Unit_Branch.ChildObjectId

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

        LEFT JOIN ObjectLink AS ObjectLink_PartionGoods_Partner
                             ON ObjectLink_PartionGoods_Partner.ObjectId = tmpMIContainer_group.PartionGoodsId
                            AND ObjectLink_PartionGoods_Partner.DescId   = zc_ObjectLink_PartionGoods_Partner()
        LEFT JOIN Object AS Object_Partner_Partion ON Object_Partner_Partion.Id = ObjectLink_PartionGoods_Partner.ChildObjectId

        LEFT JOIN Movement AS Movement_PartionGoods ON Movement_PartionGoods.Id = Object_PartionGoods.ObjectCode
        LEFT JOIN MovementDesc AS MovementDesc_PartionGoods ON MovementDesc_PartionGoods.Id = Movement_PartionGoods.DescId

        LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement_PartionGoods.Id
                                                AND MLO_From.DescId = zc_MovementLinkObject_From()
        LEFT JOIN MovementItem AS MI_From ON MI_From.MovementId = Movement_PartionGoods.Id
                                         AND MI_From.DescId = zc_MI_Master()
                                         AND Movement_PartionGoods.DescId = zc_Movement_Service()
       LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = COALESCE (MI_From.ObjectId, MLO_From.ObjectId)

       LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpMIContainer_group.AccountId

       LEFT JOIN tmpPriceStart ON tmpPriceStart.GoodsId = tmpMIContainer_group.GoodsId
       LEFT JOIN tmpPriceEnd ON tmpPriceEnd.GoodsId = tmpMIContainer_group.GoodsId
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.05.23         *
 28.07.20         *
*/

-- тест
-- SELECT * FROM gpReport_MotionGoods_AssetNoBalance (inStartDate:= '01.01.2015', inEndDate:= '01.01.2015', inAccountGroupId:= 0, inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 0, inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * from gpReport_MotionGoods_AssetNoBalance (inStartDate:= '01.08.2015', inEndDate:= '01.08.2015', inAccountGroupId:= 0, inUnitGroupId:= 8459, inLocationId:= 0, inGoodsGroupId:= 1860, inGoodsId:= 1, inUnitGroupId_by:= 0, inLocationId_by:= 0, inIsInfoMoney:= TRUE, inSession := zfCalc_UserAdmin());

/*
, когда место учета - авто и когда zc_ObjectLink_Asset_Car
*/