 -- vbIsSummIn:=  SELECT NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = 5 AND RoleId = 442647); -- пФЮЕФЩ ТХЛПЧПДЙФЕМШ УЩТШС  


        with
            _tmpLocation AS (
               SELECT Object.Id AS LocationId
                    , CASE WHEN Object.DescId = zc_Object_Unit()   THEN zc_ContainerLinkObject_Unit()
                           WHEN Object.DescId = zc_Object_Car()    THEN zc_ContainerLinkObject_Car() 
                           WHEN Object.DescId = zc_Object_Member() THEN zc_ContainerLinkObject_Member()
                      END AS DescId
                    , tmpDesc.ContainerDescId
               FROM Object
                    LEFT JOIN (SELECT zc_Container_Count()      AS ContainerDescId
                         UNION SELECT zc_Container_Summ()       AS ContainerDescId WHERE true = TRUE
                         UNION SELECT zc_Container_CountAsset() AS ContainerDescId
                         UNION SELECT zc_Container_SummAsset()  AS ContainerDescId WHERE true = TRUE
                              ) AS tmpDesc ON 1 = 1
               WHERE Object.Id = 8447
              )
              
  , _tmpLocation_by AS (SELECT 0 AS LocationId 
                        WHERE 1 = 0
                        )

--SELECT EXISTS (SELECT 1 FROM _tmpLocation WHERE DescId <> zc_ContainerLinkObject_Unit());

/*
, tmpPriceStart AS (SELECT NULL :: Integer AS GoodsId, NULL :: TFloat AS Price WHERE 1 = 0)
         , tmpPriceEnd AS (SELECT NULL :: Integer AS GoodsId, NULL :: TFloat AS Price WHERE 1 = 0)  
         
         -- !!!ЛТЙЧП ИБТДЛПДЙН пу Й ЧУЕ ЮФП ДМС ОЙИ!!!
       , tmpReport_all AS (SELECT tmp.* FROM lpReport_MotionGoods (inStartDate:= ('01.07.2026')::TDateTime, inEndDate:= ('14.07.2026')::TDateTime, inAccountGroupId:= -1 * zc_Enum_AccountGroup_10000()
                                                                 , inUnitGroupId:= 0, inLocationId:= 8447, inGoodsGroupId:= 0
                                                                 , inGoodsId:= 0, inIsInfoMoney:= False, inUserId:= 5) AS tmp 
--                           WHERE vbUserId <> 5
                         UNION ALL
                           SELECT tmp.* FROM lpReport_MotionGoods (inStartDate:= ('01.07.2026')::TDateTime, inEndDate:= ('14.07.2026')::TDateTime
                                                                 , inAccountGroupId:= -1 * zc_Enum_AccountGroup_20000()
                                                                 , inUnitGroupId:= 0, inLocationId:= 8447
                                                                   -- ДПВБЧЙФШ "нонб + пу"
                                                                 , inGoodsGroupId:= CASE WHEN 0 = 0 AND 0 = 0 THEN 9354099 ELSE 0 END
                                                                 , inGoodsId:= 0, inIsInfoMoney:= False, inUserId:= 5) AS tmp 
                             WHERE (0 = 0 OR 0 = 9354099) AND 0 = 0
                             AND 1=0
                           --WHERE 0 = 0 AND 0 = 0   
                         UNION ALL
                           SELECT tmp.* FROM lpReport_MotionGoods (inStartDate:= ('01.07.2026')::TDateTime, inEndDate:= ('14.07.2026')::TDateTime
                                                                 , inAccountGroupId:= -1 * zc_Enum_AccountGroup_20000()
                                                                 , inUnitGroupId:= 0, inLocationId:= 8447
                                                                   -- ДПВБЧЙФШ "ыйощ", ЕУМЙ ЧЩВТБМЙ чуе ЙМЙ "нонб + пу"
                                                                 , inGoodsGroupId:= CASE WHEN (0 = 0 OR 0 = 9354099) AND 0 = 0 THEN 7597944 ELSE 0 END
                                                                 , inGoodsId:= 0, inIsInfoMoney:= False, inUserId:= 5) AS tmp 
                           --WHERE (0 = 0 OR 0 = 9354099) AND 0 = 0
                           WHERE (0 = 0 OR 0 = 9354099) AND 0 = 0
                          )
        
        
       , tmpReport_summ AS (SELECT * FROM tmpReport_all WHERE False = FALSE OR ContainerId_count <> ContainerId)
       , tmpReport_count AS (SELECT * FROM tmpReport_all WHERE False = TRUE AND ContainerId_count = ContainerId)
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

   -- тЕЪХМШФБФ
   SELECT View_Account.AccountGroupName, View_Account.AccountDirectionName
        , View_Account.AccountId, View_Account.AccountCode, View_Account.AccountName
        , (CASE WHEN tmpMIContainer_group.ContainerDescId_count IN (zc_Container_CountAsset(), zc_Container_SummAsset()) THEN '*Ъ* ' ELSE '' END || COALESCE (View_Account.AccountName_all, '')) :: TVarChar AS AccountName_all
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
        , COALESCE(ObjectDate_PartionGoods_Value.ValueData,Null) ::TDateTime AS PartionGoodsDate   --ДБФБ ЧЧПДБ Ч ЬЛУРМХБФБГЙА
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

        , Object_Car.ValueData           AS CarName  --ЗПУ ОПНЕТ БЧФП
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

        , tmpMIContainer_group.CountProductionIn_by :: TFloat  -- РТЙИПД У РТПЙЪЧ. (ЕУМЙ У ДТХЗПЗП РПДТ., Ф.Е. ОЕ РЕТЕУПТФ)
        , (tmpMIContainer_group.CountProductionIn_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountProductionIn_by_Weight
        , tmpMIContainer_group.SummProductionIn_by  :: TFloat -- РТЙИПД У РТПЙЪЧ. (ЕУМЙ У ДТХЗПЗП РПДТ., Ф.Е. ОЕ РЕТЕУПТФ)
        , tmpMIContainer_group.CountIn_by           :: TFloat -- РТЙИПД У "ЧЩВТБООПЗП" РПДТ.
        , (tmpMIContainer_group.CountIn_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountIn_by_Weight
        , tmpMIContainer_group.SummIn_by            :: TFloat -- РТЙИПД У "ЧЩВТБООПЗП" РПДТ.
        , tmpMIContainer_group.CountOtherIn_by      :: TFloat -- РТЙИПД ДТХЗПК
        , (tmpMIContainer_group.CountOtherIn_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOtherIn_by_Weight
        , tmpMIContainer_group.SummOtherIn_by       :: TFloat -- РТЙИПД ДТХЗПК

        , tmpMIContainer_group.CountOut_by      :: TFloat -- ТБУИПД ОБ "ЧЩВТБООПЕ" РПДТ.
        , (tmpMIContainer_group.CountOut_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOut_by_Weight
        , tmpMIContainer_group.SummOut_by       :: TFloat -- ТБУИПД ОБ "ЧЩВТБООПЕ" РПДТ.
        , tmpMIContainer_group.CountOtherOut_by :: TFloat -- ТБУИПД ДТХЗПК
        , (tmpMIContainer_group.CountOtherOut_by * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOtherOut_by_Weight
        , tmpMIContainer_group.SummOtherOut_by  :: TFloat -- ТБУИПД ДТХЗПК

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

              , SUM (CASE WHEN /*_tmpLocation.LocationId IS NULL AND */ 1=0 AND _tmpLocation_by.LocationId IS NULL THEN tmpMIContainer_all.CountProductionIn ELSE 0 END) AS CountProductionIn_by -- РТЙИПД У РТПЙЪЧ. (ЕУМЙ У ДТХЗПЗП РПДТ., Ф.Е. ОЕ РЕТЕУПТФ)
              , SUM (CASE WHEN /*_tmpLocation.LocationId IS NULL AND */ 1=0 AND _tmpLocation_by.LocationId IS NULL THEN tmpMIContainer_all.SummProductionIn  ELSE 0 END) AS SummProductionIn_by  -- РТЙИПД У РТПЙЪЧ. (ЕУМЙ У ДТХЗПЗП РПДТ., Ф.Е. ОЕ РЕТЕУПТФ)

              , SUM (CASE WHEN _tmpLocation_by.LocationId > 0
                               THEN tmpMIContainer_all.CountSendIn
                                  + tmpMIContainer_all.CountProductionIn
                                  + tmpMIContainer_all.CountSendOnPriceIn
                          ELSE 0
                     END) AS CountIn_by -- РТЙИПД У "ЧЩВТБООПЗП" РПДТ.
              , SUM (CASE WHEN _tmpLocation_by.LocationId > 0
                               THEN tmpMIContainer_all.SummSendIn
                                  + tmpMIContainer_all.SummProductionIn
                                  + tmpMIContainer_all.SummSendOnPriceIn
                          ELSE 0
                     END) AS SummIn_by -- РТЙИПД У "ЧЩВТБООПЗП" РПДТ.

              , SUM (CASE WHEN /*_tmpLocation.LocationId > 0 AND */ _tmpLocation_by.LocationId IS NULL THEN tmpMIContainer_all.CountProductionIn ELSE 0 END
                   + CASE WHEN _tmpLocation_by.LocationId IS NULL
                               THEN tmpMIContainer_all.CountSendIn
                                  + tmpMIContainer_all.CountSendOnPriceIn
                          ELSE 0
                     END
                   + tmpMIContainer_all.CountIncome
                    ) AS CountOtherIn_by -- РТЙИПД ДТХЗПК
              , SUM (CASE WHEN /*_tmpLocation.LocationId > 0 AND */ _tmpLocation_by.LocationId IS NULL THEN tmpMIContainer_all.SummProductionIn ELSE 0 END
                   + CASE WHEN _tmpLocation_by.LocationId IS NULL
                               THEN tmpMIContainer_all.SummSendIn
                                  + tmpMIContainer_all.SummSendOnPriceIn
                          ELSE 0
                     END
                   + tmpMIContainer_all.SummIncome
                    ) AS SummOtherIn_by -- РТЙИПД ДТХЗПК

              , SUM (CASE WHEN _tmpLocation_by.LocationId > 0
                               THEN tmpMIContainer_all.CountSendOut
                                  + tmpMIContainer_all.CountProductionOut
                                  + tmpMIContainer_all.CountSendOnPriceOut
                          ELSE 0
                     END) AS CountOut_by -- ТБУИПД ОБ "ЧЩВТБООПЕ" РПДТ.
              , SUM (CASE WHEN _tmpLocation_by.LocationId > 0
                               THEN tmpMIContainer_all.SummSendOut
                                  + tmpMIContainer_all.SummProductionOut
                                  + tmpMIContainer_all.SummSendOnPriceOut
                          ELSE 0
                     END) AS SummOut_by -- ТБУИПД ОБ "ЧЩВТБООПЕ" РПДТ.

              , SUM (CASE WHEN _tmpLocation_by.LocationId IS NULL
                               THEN tmpMIContainer_all.CountSendOut
                                  + tmpMIContainer_all.CountProductionOut
                                  + tmpMIContainer_all.CountSendOnPriceOut
                          ELSE 0
                     END
                   + tmpMIContainer_all.CountReturnOut
                    ) AS CountOtherOut_by -- ТБУИПД ДТХЗПК
              , SUM (CASE WHEN _tmpLocation_by.LocationId IS NULL
                               THEN tmpMIContainer_all.SummSendOut
                                  + tmpMIContainer_all.SummProductionOut
                                  + tmpMIContainer_all.SummSendOnPriceOut
                          ELSE 0
                     END
                   + tmpMIContainer_all.SummReturnOut
                    ) AS SummOtherOut_by -- ТБУИПД ДТХЗПК

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
        --ЕУМЙ НЕУФП ХЮЕФБ ЧПДЙФЕМШ ФП РП ОЕНХ РПМХЮБЕН БЧФП
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
*/



  -- нонб + пу
               ,   tmpGoods_os AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (9354099) AS lfSelect) -- нонб + пу
                , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId
                                 FROM (SELECT 0              AS AccountGroupId WHERE 0 <> 0
                                 UNION SELECT zc_Enum_AccountGroup_10000()  AS AccountGroupId WHERE 0 = 0
                                 UNION SELECT zc_Enum_AccountGroup_20000()  AS AccountGroupId WHERE 0 = 0
                                 UNION SELECT zc_Enum_AccountGroup_60000()  AS AccountGroupId WHERE 0 = 0
                                 UNION SELECT zc_Enum_AccountGroup_110000() AS AccountGroupId WHERE 0 = 0
                                      ) AS tmp
                                      INNER JOIN Object_Account_View AS View_Account ON View_Account.AccountGroupId = tmp.AccountGroupId
                                )
             , _tmpListContainer AS ( --LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
                SELECT tmp.LocationId, tmp.ContainerDescId, tmp.ContainerId_count, tmp.ContainerId_begin, tmp.GoodsId, tmp.AccountId, tmp.AccountGroupId, tmp.Amount
                FROM
               ( 
WITH 
tmp AS (SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN ContainerLinkObject.ContainerId
                            ELSE COALESCE (Container.ParentId, 0)
                       END AS ContainerId_count
                     , ContainerLinkObject.ContainerId AS ContainerId_begin
                     
                     , Container.Amount 
                     , _tmpLocation.DescId    AS Value1_ch
                    
                     , Container.ObjectId
                FROM _tmpLocation
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                   AND ContainerLinkObject.DescId = _tmpLocation.DescId
                     INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                         AND Container.DescId = _tmpLocation.ContainerDescId 
             )
             
 , tmpCLO_Account AS (SELECT *
                       FROM ContainerLinkObject
                       WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmp.ContainerId_begin FROM tmp)
                         AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Account()
                        )           
 , tmpCLO_Goods AS (SELECT *
                       FROM ContainerLinkObject
                       WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmp.ContainerId_begin FROM tmp) 
                         AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Goods()
                        )
 , tmpCLO_Member AS (SELECT *
                       FROM ContainerLinkObject
                       WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmp.ContainerId_begin FROM tmp) 
                         AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Member()
                        )     
 , tmpCLO_AssetTo AS (SELECT *
                       FROM ContainerLinkObject
                       WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmp.ContainerId_begin FROM tmp) 
                         AND ContainerLinkObject.DescId = zc_ContainerLinkObject_AssetTo()
                        )                                              
 , tmpCLO_PartionGoods AS (SELECT *
                       FROM ContainerLinkObject
                       WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmp.ContainerId_begin FROM tmp)
                         AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                        )   
                        
        SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , _tmpLocation.ContainerId_count
                     , _tmpLocation.ContainerId_begin
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN COALESCE (_tmpLocation.ObjectId, 0) ELSE COALESCE (CLO_Goods.ObjectId, 0) END AS GoodsId
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN COALESCE (CLO_Account.ObjectId, 0)
                            ELSE COALESCE (_tmpLocation.ObjectId, 0)
                       END AS AccountId
                     , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN zc_Enum_AccountGroup_110000() -- фТБОЪЙФ
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId
                     , _tmpLocation.Amount 
                     , _tmpLocation.Value1_ch
                     , CLO_Member.ContainerId AS Value2_ch
                FROM tmp AS _tmpLocation               
                       
                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = _tmpLocation.ObjectId                                                                                               and 1 = 0
                     LEFT JOIN tmpCLO_Goods AS CLO_Goods ON CLO_Goods.ContainerId = _tmpLocation.ContainerId_begin
                                                               AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                               AND _tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())                                   and 1 = 0
                     LEFT JOIN tmpCLO_Account AS CLO_Account ON CLO_Account.ContainerId = _tmpLocation.ContainerId_begin
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                                 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())                                   and 1 = 0
                     LEFT JOIN tmpCLO_Member AS CLO_Member ON CLO_Member.ContainerId = CASE WHEN false = TRUE THEN _tmpLocation.ContainerId_begin ELSE NULL END
                                                                AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                                AND CLO_Member.ObjectId > 0                                                                  and 1 = 0

                     LEFT JOIN tmpCLO_AssetTo AS CLO_AssetTo ON CLO_AssetTo.ContainerId = _tmpLocation.ContainerId_begin
                                                                 AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()                                   and 1 = 0
                     LEFT JOIN tmpCLO_PartionGoods AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpLocation.ContainerId_begin
                                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()                                   and 1 = 0
                     LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId                                    and 1 = 0

                     LEFT JOIN tmpGoods_os ON tmpGoods_os.GoodsId = CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN _tmpLocation.ObjectId ELSE CLO_Goods.ObjectId END
                  
                WHERE ((_tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) AND tmpAccount.AccountId > 0)
                    OR (_tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) AND ((CLO_Account.ContainerId > 0 AND 0 = zc_Enum_AccountGroup_110000()) -- фТБОЪЙФ
                                                                              OR (CLO_Account.ContainerId IS NULL AND 0 <> zc_Enum_AccountGroup_110000()) -- фТБОЪЙФ
                                                                               ))
                      )
                  AND (((Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000()
                      OR tmpGoods_os.GoodsId > 0
                        ) AND TRUE = TRUE)
                     OR TRUE = FALSE)
                  -- AND (( _tmpLocation.Value1_ch <> zc_ContainerLinkObject_Member() AND CLO_Member.ContainerId IS NULL)
                  --   OR  _tmpLocation.Value1_ch = zc_ContainerLinkObject_Member())
             
                    
/*SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN ContainerLinkObject.ContainerId
                            ELSE COALESCE (Container.ParentId, 0)
                       END AS ContainerId_count
                     , ContainerLinkObject.ContainerId AS ContainerId_begin
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN COALESCE (Container.ObjectId, 0) ELSE COALESCE (CLO_Goods.ObjectId, 0) END AS GoodsId
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN COALESCE (CLO_Account.ObjectId, 0)
                            ELSE COALESCE (Container.ObjectId, 0)
                       END AS AccountId
                     , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN zc_Enum_AccountGroup_110000() -- фТБОЪЙФ
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId
                     , Container.Amount 
                     , _tmpLocation.DescId    AS Value1_ch
                     , CLO_Member.ContainerId AS Value2_ch
                FROM _tmpLocation
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                   AND ContainerLinkObject.DescId = _tmpLocation.DescId
                     INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                         AND Container.DescId = _tmpLocation.ContainerDescId                           
                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId                                                                            --                   and 1 = 0
                     LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                               AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                               AND _tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())                  --                 and 1 = 0
                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                                 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())                   --                and 1 = 0
                     LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = CASE WHEN false = TRUE THEN Container.Id ELSE NULL END
                                                                AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                                AND CLO_Member.ObjectId > 0                                                             --     and 1 = 0

                     LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = ContainerLinkObject.ContainerId
                                                                 AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()                                --   and 1 = 0
                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = ContainerLinkObject.ContainerId
                                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()                       --            and 1 = 0
                     LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId                                --    and 1 = 0

                     LEFT JOIN tmpGoods_os ON tmpGoods_os.GoodsId = CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN Container.ObjectId ELSE CLO_Goods.ObjectId END

                WHERE ((_tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) AND tmpAccount.AccountId > 0)
                    OR (_tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) AND ((CLO_Account.ContainerId > 0 AND 0 = zc_Enum_AccountGroup_110000()) -- фТБОЪЙФ
                                                                              OR (CLO_Account.ContainerId IS NULL AND 0 <> zc_Enum_AccountGroup_110000()) -- фТБОЪЙФ
                                                                               ))
                      )
                  AND (((Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000()
                      OR tmpGoods_os.GoodsId > 0
                        ) AND TRUE = TRUE)
                     OR TRUE = FALSE)
                  -- AND ((ContainerLinkObject.DescId <> zc_ContainerLinkObject_Member() AND CLO_Member.ContainerId IS NULL)
                  --   OR ContainerLinkObject.DescId = zc_ContainerLinkObject_Member())
              */ ) AS tmp
                WHERE ((tmp.Value1_ch <> zc_ContainerLinkObject_Member() AND tmp.Value2_ch IS NULL)
                    OR tmp.Value1_ch = zc_ContainerLinkObject_Member())
             
 )

SELECT * 
FROm _tmpListContainer




/*
 ВСЯ процедура


-- Function: lpReport_MotionGoods()
-- !!!!НОВАЯ версия - добавлен OLAP!!!

DROP FUNCTION IF EXISTS lpReport_MotionGoods22 (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpReport_MotionGoods22(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    -- группа подразделений на самом деле может быть и подразделением
    IN inLocationId         Integer,    --
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inGoodsId            Integer,    -- товар
    IN inIsInfoMoney        Boolean,    --
    IN inUserId             Integer     -- пользователь
)
RETURNS TABLE (AccountId Integer
             , ContainerDescId_count Integer
             , ContainerId_count Integer
             , ContainerId Integer
             , ContainerId_count_max Integer
             , ContainerId_begin_max Integer

             , LocationId Integer
             , CarId Integer
             , GoodsId Integer, GoodsKindId Integer
             , PartionGoodsId Integer, AssetToId Integer

             , LocationId_by Integer

             , CountStart     TFloat
             , CountEnd       TFloat
             , CountEnd_calc  TFloat

             , CountIncome    TFloat
             , CountReturnOut TFloat

             , CountSendIn  TFloat
             , CountSendOut TFloat

             , CountSendOnPriceIn        TFloat
             , CountSendOnPriceOut       TFloat
             , CountSendOnPriceOut_10900 TFloat

             , CountSendOnPrice_10500   TFloat
             , CountSendOnPrice_40200   TFloat

             , CountSale           TFloat
             , CountSale_10500     TFloat
             , CountSale_40208     TFloat
             , CountSaleReal       TFloat
             , CountSaleReal_10500 TFloat
             , CountSaleReal_40208 TFloat

             , CountReturnIn           TFloat
             , CountReturnIn_40208     TFloat
             , CountReturnInReal       TFloat
             , CountReturnInReal_40208 TFloat

             , CountLoss      TFloat
             , CountInventory TFloat

             , CountProductionIn  TFloat
             , CountProductionOut TFloat

             , SummStart    TFloat
             , SummEnd      TFloat
             , SummEnd_calc TFloat

             , SummIncome    TFloat
             , SummReturnOut TFloat

             , SummSendIn  TFloat
             , SummSendOut TFloat

             , SummSendOnPriceIn        TFloat
             , SummSendOnPriceOut       TFloat
             , SummSendOnPriceOut_10900 TFloat

             , SummSendOnPrice_10500  TFloat
             , SummSendOnPrice_40200  TFloat

             , SummSale            TFloat
             , SummSale_10500      TFloat
             , SummSale_40208      TFloat
             , SummSaleReal        TFloat
             , SummSaleReal_10500  TFloat
             , SummSaleReal_40208  TFloat

             , SummReturnIn           TFloat
             , SummReturnIn_40208     TFloat
             , SummReturnInReal       TFloat
             , SummReturnInReal_40208 TFloat

             , SummLoss              TFloat
             , SummInventory         TFloat
             , SummInventory_Basis   TFloat
             , SummInventory_RePrice TFloat

             , SummProductionIn  TFloat
             , SummProductionOut TFloat

              --  CountCount
             , CountStart_byCount         TFloat
             , CountEnd_byCount           TFloat
             , CountIncome_byCount        TFloat
             , CountReturnOut_byCount     TFloat
             , CountSendIn_byCount        TFloat
             , CountSendOut_byCount       TFloat
             , CountSendOnPriceIn_byCount  TFloat
             , CountSendOnPriceOut_byCount TFloat

              )
AS
$BODY$
   DECLARE vbIsAssetTo Boolean;
   DECLARE vbIsCLO_Member Boolean;
   DECLARE vbIsAssetNoBalance Boolean;

   DECLARE vb_IsContainer_OLAP Boolean;
   DECLARE vbStartDate_olap    TDateTime;
   DECLARE vbVerId_olap        Integer;
BEGIN
    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, inUserId);


    -- !!!Нет прав!!! - Ограниченние - нет доступа к Отчету по остаткам
    IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 11086934)
    THEN
        RAISE EXCEPTION 'Ошибка.Нет прав.';
    END IF;


    -- ускорение - ОЛАП + Голота К.О. + Только просмотр Аудитор + Просмотр СБ
    vb_IsContainer_OLAP:= inEndDate < '01.01.2024' AND (inUserId IN (5, 6604558, 10352030)
                                                     OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId IN (10597056, 447972))
                                                       )
                                                   --AND inUserId <> 5
                                                  ;

    -- ускорение - ОЛАП + Голота К.О. + Только просмотр Аудитор + Просмотр СБ
    IF vb_IsContainer_OLAP = FALSE AND 1=1 AND inLocationId <> 12452787 --
    THEN
        vb_IsContainer_OLAP:= inEndDate <= '30.06.2026' AND (inUserId IN (5, 6604558, 10352030)
                                                          OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId IN (10597056, 447972))
                                                            )
                                                      --AND inUserId <> 5
                                                       ;
    END IF;


    IF 1=0
    THEN
        vb_IsContainer_OLAP:= FALSE;
    ELSE
        -- 01.01.2021
        IF vb_IsContainer_OLAP = TRUE AND inEndDate < '01.01.2021'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.01.2021' AND Container_data.VerId > 0)
        THEN
            vbStartDate_olap:= '01.01.2021';
            --
            vbVerId_olap:= (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.01.2022
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate < '01.01.2022'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.01.2022' AND Container_data.VerId > 0)
        THEN
            vbStartDate_olap:= '01.01.2022';
            --
            vbVerId_olap:= (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.01.2023
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate < '01.01.2023'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.01.2023' AND Container_data.VerId > 0)
        THEN
            vbStartDate_olap:= '01.01.2023';
            --
            vbVerId_olap:= (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.01.2024
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate < '01.01.2024'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.01.2024' AND Container_data.VerId > 0)
        THEN
            vbStartDate_olap:= '01.01.2024';
            --
            vbVerId_olap:= (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.12.2024
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '30.11.2024'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.12.2024' AND Container_data.VerId > 0)
           AND COALESCE (inGoodsId, 0) = 0
        THEN
            vbStartDate_olap:= '01.12.2024';
            --
            vbVerId_olap:= 2; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.01.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '31.12.2024'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.01.2025' AND Container_data.VerId = 3)
           AND COALESCE (inGoodsId, 0) = 0
        THEN
            vbStartDate_olap:= '01.01.2025';
            --
            vbVerId_olap:= 3; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.02.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '31.01.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.02.2025' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.02.2025';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);


        -- 01.03.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '28.02.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.03.2025' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.03.2025';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.04.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '31.03.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.04.2025' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.04.2025';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.05.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '30.04.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.05.2025' AND Container_data.VerId = 2)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.05.2025';
            --
            vbVerId_olap:= 2; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.06.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '31.05.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.06.2025' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.06.2025';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);


        -- 01.07.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '30.06.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.07.2025' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.07.2025';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.08.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '31.07.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.08.2025' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.08.2025';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.09.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '31.08.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.09.2025' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.09.2025';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.10.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '30.09.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.10.2025' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.10.2025';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.11.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '31.10.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.11.2025' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.11.2025';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.12.2025
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '30.11.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.12.2025' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.12.2025';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.01.2026
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '31.12.2025'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.01.2026' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.01.2026';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.02.2026
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '31.01.2026'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.02.2026' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.02.2026';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.03.2026
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '28.02.2026'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.03.2026' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.03.2026';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.04.2026
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '31.03.2026'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.04.2026' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.04.2026';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.05.2026
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '30.04.2026'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.05.2026' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.05.2026';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.06.2026
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '31.05.2026'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.06.2026' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.06.2026';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        -- 01.07.2026
        ELSEIF vb_IsContainer_OLAP = TRUE AND inEndDate <= '30.06.2026'
           AND EXISTS (SELECT 1 FROM Container_data WHERE Container_data.StartDate = '01.07.2026' AND Container_data.VerId = 1)
           AND COALESCE (inGoodsId, 0) = 0
           AND 1=1
        THEN
            vbStartDate_olap:= '01.07.2026';
            --
            vbVerId_olap:= 1; -- (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId > 0);

        ELSE
            vb_IsContainer_OLAP:= FALSE;

        END IF;
    END IF;

-- RAISE EXCEPTION 'Ошибка.<%>  <%>', vb_IsContainer_OLAP, vbStartDate_olap;


    IF inAccountGroupId = -1 * zc_Enum_AccountGroup_20000()
    THEN
        vbIsAssetNoBalance:= TRUE;
        inAccountGroupId:= -1 * zc_Enum_AccountGroup_20000();
    END IF;

    -- !!!ДЛЯ ТЕСТА!!!
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpLocation'))
       AND inUserId in (5, 343013)
    THEN
        CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;
        CREATE TEMP TABLE _tmpLocation_by (LocationId Integer) ON COMMIT DROP;
        --
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
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId
                         UNION SELECT zc_Container_CountAsset() AS ContainerDescId UNION SELECT zc_Container_SummAsset() AS ContainerDescId
                              ) AS tmpDesc ON 1 = 1
               WHERE Object.Id = inLocationId
              ;
        END IF;
    END IF;
    -- !!!ДЛЯ ТЕСТА!!!


    vbIsCLO_Member:= EXISTS (SELECT 1 FROM _tmpLocation WHERE DescId <> zc_ContainerLinkObject_Unit());

    -- Дмитриева О.В.
    IF inStartDate < inEndDate - INTERVAL '2 MONTH' AND inUserId NOT IN (zfCalc_UserAdmin() :: Integer, zfCalc_UserMain(), 106594) AND COALESCE (inGoodsId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Заданный период не может быть больше чем 2 мес.';
    END IF;



    IF NOT EXISTS (SELECT 1 FROM _tmpLocation)
    THEN
        -- группа подразделений или подразделение или место учета (МО, Авто)
        IF inUnitGroupId <> 0 AND COALESCE (inLocationId, 0) = 0
        THEN
            INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
               SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
                    , zc_ContainerLinkObject_Unit()       AS DescId
                    , tmpDesc.ContainerDescId
               FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId
                         --UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE inUserId = zfCalc_UserAdmin() :: Integer
                               ) AS tmpDesc ON 1 = 1
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
                        LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId
                             --UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE inUserId = zfCalc_UserAdmin() :: Integer
                             UNION SELECT zc_Container_CountAsset() AS ContainerDescId
                             --UNION SELECT zc_Container_SummAsset() AS ContainerDescId WHERE inUserId = zfCalc_UserAdmin() :: Integer
                                  ) AS tmpDesc ON 1 = 1
                   WHERE Object.Id = inLocationId
                 /*UNION
                   SELECT lfSelect.UnitId               AS LocationId
                        , zc_ContainerLinkObject_Unit() AS DescId
                        , tmpDesc.ContainerDescId
                   FROM lfSelect_Object_Unit_byGroup (inLocationId) AS lfSelect
                        -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
                        LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1*/
                  ;
            END IF;
        END IF;
    END IF;


    -- определяется - надо ли товары с пустым счетом
    /*IF inAccountGroupId = -1 * zc_Enum_AccountGroup_20000()
    THEN
        inAccountGroupId:= zc_Enum_AccountGroup_20000();
        vbIsAssetNoBalance:= TRUE;

    ELSE*/
    -- определяется - надо ли ТОЛЬКО ОС и все что с ними связано
    IF inAccountGroupId = -1 * zc_Enum_AccountGroup_10000()
    THEN
        inAccountGroupId:= 0;
        vbIsAssetTo:= TRUE;
    ELSE
        vbIsAssetTo:= FALSE;
    END IF;
    -- !!!может так будет быстрее!!!
    inAccountGroupId:= COALESCE (inAccountGroupId, 0);

    -- !!!меняются параметры для филиала!!!
    IF 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = inUserId AND BranchId <> 0 GROUP BY BranchId)
    THEN
        inAccountGroupId:= zc_Enum_AccountGroup_20000(); -- Запасы
        inIsInfoMoney:= FALSE;
    END IF;


    -- таблица -
    --CREATE TEMP TABLE _tmpListContainer (LocationId Integer, ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, GoodsId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    --CREATE TEMP TABLE _tmpContainer (ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, LocationId Integer, CarId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsId Integer, AssetToId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpListContainer'))
     THEN
         DELETE FROM _tmpListContainer;
     ELSE
         CREATE TEMP TABLE _tmpListContainer (LocationId Integer, ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, GoodsId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    END IF;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpContainer'))
     THEN
         DELETE FROM _tmpContainer;
     ELSE
        CREATE TEMP TABLE _tmpContainer (ContainerDescId Integer, ContainerDescId_count Integer, ContainerId_count Integer, ContainerId_begin Integer, LocationId Integer, CarId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsId Integer, AssetToId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    END IF;


    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmp_Container_data'))
     THEN
         DELETE FROM tmp_Container_data;
     ELSE
         -- подключили !!!OLAP!!!
         CREATE TEMP TABLE tmp_Container_data (StartDate             TDateTime ,
                                               VerId                 Integer ,
                                               Id                    SERIAL ,
                                               DescId                INTEGER ,
                                               ObjectId              Integer ,
                                               Amount                TFloat  ,
                                               Amount_data_real      TFloat  ,
                                               ParentId              Integer ,
     
                                               KeyValue              TVarChar,
                                               MasterKeyValue        BigInt,
                                               ChildKeyValue         BigInt,
                                               WhereObjectId         Integer
                                              ) ON COMMIT DROP;
    END IF;

    -- подключили !!!OLAP!!!
    IF vb_IsContainer_OLAP = TRUE
    THEN
        -- подключили !!!OLAP!!!
        INSERT INTO tmp_Container_data SELECT * FROM Container_data WHERE Container_data.StartDate = vbStartDate_olap AND Container_data.VerId = vbVerId_olap;
        --
        ANALYZE tmp_Container_data;

    END IF;


    -- группа товаров или товар или все товары из проводок
    IF inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
    THEN
        WITH -- МНМА + ОС
             tmpGoods_os AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (9354099) AS lfSelect) -- МНМА + ОС
           , tmpGoods AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect WHERE vbIsAssetTo = FALSE
                         UNION ALL
                         -- если отбор по группе ОС
                          SELECT ObjectLink_Asset_AssetGroup.ObjectId AS GoodsId
                          FROM ObjectLink AS ObjectLink_Asset_AssetGroup
                          WHERE ObjectLink_Asset_AssetGroup.DescId = zc_ObjectLink_Asset_AssetGroup()
                            AND ObjectLink_Asset_AssetGroup.ChildObjectId = inGoodsGroupId
                            AND vbIsAssetTo = TRUE
                         )

           , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId
                            FROM (SELECT inAccountGroupId              AS AccountGroupId WHERE inAccountGroupId <> 0
                            UNION SELECT zc_Enum_AccountGroup_10000()  AS AccountGroupId WHERE inAccountGroupId = 0
                            UNION SELECT zc_Enum_AccountGroup_20000()  AS AccountGroupId WHERE inAccountGroupId = 0
                            UNION SELECT zc_Enum_AccountGroup_60000()  AS AccountGroupId WHERE inAccountGroupId = 0
                            UNION SELECT zc_Enum_AccountGroup_110000() AS AccountGroupId WHERE inAccountGroupId = 0
                                 ) AS tmp
                                 INNER JOIN Object_Account_View AS View_Account ON View_Account.AccountGroupId = tmp.AccountGroupId
                           )
           , tmp AS
          (SELECT _tmpLocation.LocationId
                , _tmpLocation.ContainerDescId
                  -- всегда ContainerId_count
                , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                            THEN ContainerLinkObject.ContainerId
                       ELSE COALESCE (Container.ParentId, 0)
                  END AS ContainerId_count
                  -- по нему движение: Count + Summ
                , ContainerLinkObject.ContainerId AS ContainerId_begin
                  --
                , tmpGoods.GoodsId
                , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                            THEN COALESCE (CLO_Account.ObjectId, 0)
                       ELSE COALESCE (Container.ObjectId, 0)
                  END AS AccountId
                , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                            THEN zc_Enum_AccountGroup_110000() -- Транзит
                       ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                  END AS AccountGroupId

                  -- подключили !!!OLAP!!!
                , CASE WHEN vb_IsContainer_OLAP = TRUE THEN COALESCE (Container_data.Amount, 0) ELSE Container.Amount END AS Amount

                , _tmpLocation.DescId    AS Value1_ch
                , CLO_Member.ContainerId AS Value2_ch

           FROM _tmpLocation
                -- все по месту учета: Count + Summ
                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                              AND ContainerLinkObject.DescId   = _tmpLocation.DescId
                -- для Суммового нашли товар
                LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                          AND CLO_Goods.DescId      = zc_ContainerLinkObject_Goods()
                                                          AND _tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())

                -- Все: Count + Summ
                LEFT JOIN Container ON Container.Id     = ContainerLinkObject.ContainerId
                                   AND Container.DescId = _tmpLocation.ContainerDescId
                -- подключили !!!OLAP!!!
                LEFT JOIN tmp_Container_data AS Container_data
                -- LEFT JOIN Container_data
                                             ON Container_data.Id        = Container.Id
                                            -- подключили !!!OLAP!!!
                                            AND Container_data.StartDate = vbStartDate_olap
                                            AND Container_data.VerId     = vbVerId_olap
                                            AND vb_IsContainer_OLAP      = TRUE

                -- ограничили Товаром
                INNER JOIN tmpGoods ON tmpGoods.GoodsId = CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                                    THEN Container.ObjectId
                                                               ELSE CLO_Goods.ObjectId
                                                          END
                LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                            AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                            AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = CASE WHEN vbIsCLO_Member = TRUE THEN Container.Id ELSE NULL END
                                                           AND CLO_Member.DescId = zc_ContainerLinkObject_Member()

                LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = ContainerLinkObject.ContainerId
                                                            AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = ContainerLinkObject.ContainerId
                                                                 AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId

                LEFT JOIN tmpGoods_os ON tmpGoods_os.GoodsId = tmpGoods.GoodsId

           WHERE (
                  (_tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) AND tmpAccount.AccountId > 0)
               OR (_tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                         OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                          ))
                 )
             AND (((Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000()
                 OR tmpGoods_os.GoodsId > 0
                   ) AND vbIsAssetTo = TRUE)
               OR vbIsAssetTo = FALSE)
             -- AND ((ContainerLinkObject.DescId <> zc_ContainerLinkObject_Member() AND CLO_Member.ContainerId IS NULL)
             --  OR ContainerLinkObject.DescId = zc_ContainerLinkObject_Member())
          )

        -- Результат
        INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
           SELECT tmp.LocationId, tmp.ContainerDescId, tmp.ContainerId_count, tmp.ContainerId_begin, tmp.GoodsId, tmp.AccountId, tmp.AccountGroupId, tmp.Amount
           FROM tmp
           WHERE ((tmp.Value1_ch <> zc_ContainerLinkObject_Member() AND tmp.Value2_ch IS NULL)
               OR tmp.Value1_ch = zc_ContainerLinkObject_Member())
          ;

    ELSE IF inGoodsId <> 0
         THEN
             WITH -- МНМА + ОС
                  tmpGoods_os AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (9354099) AS lfSelect WHERE lfSelect.GoodsId = inGoodsId)
                , tmpContainer AS (SELECT CLO_Goods.ContainerId FROM ContainerLinkObject AS CLO_Goods WHERE CLO_Goods.ObjectId = inGoodsId AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                 UNION
                                   SELECT Container.Id FROM Container WHERE Container.ObjectId = inGoodsId AND Container.DescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                  )
                , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId
                                 FROM (SELECT inAccountGroupId              AS AccountGroupId WHERE inAccountGroupId <> 0
                                 UNION SELECT zc_Enum_AccountGroup_10000()  AS AccountGroupId WHERE inAccountGroupId = 0
                                 UNION SELECT zc_Enum_AccountGroup_20000()  AS AccountGroupId WHERE inAccountGroupId = 0
                                 UNION SELECT zc_Enum_AccountGroup_60000()  AS AccountGroupId WHERE inAccountGroupId = 0
                                 UNION SELECT zc_Enum_AccountGroup_110000() AS AccountGroupId WHERE inAccountGroupId = 0
                                      ) AS tmp
                                      INNER JOIN Object_Account_View AS View_Account ON View_Account.AccountGroupId = tmp.AccountGroupId
                                )
             INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
                SELECT tmp.LocationId, tmp.ContainerDescId, tmp.ContainerId_count, tmp.ContainerId_begin, tmp.GoodsId, tmp.AccountId, tmp.AccountGroupId, tmp.Amount
                FROM
               (SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN tmpContainer.ContainerId
                            ELSE COALESCE (Container.ParentId, 0)
                       END AS ContainerId_count
                     , tmpContainer.ContainerId AS ContainerId_begin
                     , inGoodsId AS GoodsId
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN COALESCE (CLO_Account.ObjectId, 0)
                            ELSE COALESCE (Container.ObjectId, 0)
                       END AS AccountId
                     , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN zc_Enum_AccountGroup_110000() -- Транзит
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId

                       -- подключили !!!OLAP!!!
                     , CASE WHEN vb_IsContainer_OLAP = TRUE THEN COALESCE (Container_data.Amount, 0) ELSE Container.Amount END AS Amount

                     , _tmpLocation.DescId    AS Value1_ch
                     , CLO_Member.ContainerId AS Value2_ch
                FROM tmpContainer
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = tmpContainer.ContainerId
                     INNER JOIN _tmpLocation ON _tmpLocation.LocationId = ContainerLinkObject.ObjectId
                                            AND _tmpLocation.DescId = ContainerLinkObject.DescId

                     INNER JOIN Container ON Container.Id     = tmpContainer.ContainerId
                                         AND Container.DescId = _tmpLocation.ContainerDescId
                     -- подключили !!!OLAP!!!
                     LEFT JOIN tmp_Container_data AS Container_data
                     --LEFT JOIN Container_data
                                                  ON Container_data.Id        = Container.Id
                                                 -- подключили !!!OLAP!!!
                                                 AND Container_data.StartDate = vbStartDate_olap
                                                 AND Container_data.VerId     = vbVerId_olap
                                                 AND vb_IsContainer_OLAP      = TRUE

                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                                 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                     LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = CASE WHEN vbIsCLO_Member = TRUE THEN Container.Id ELSE NULL END
                                                                AND CLO_Member.DescId = zc_ContainerLinkObject_Member()

                     LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = ContainerLinkObject.ContainerId
                                                                 AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = ContainerLinkObject.ContainerId
                                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                     LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId

                     LEFT JOIN tmpGoods_os ON tmpGoods_os.GoodsId = inGoodsId

                WHERE (
                       (_tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) AND tmpAccount.AccountId > 0)
                    OR (_tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                              OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                               ))
                      )
                  AND (((Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000()
                      OR tmpGoods_os.GoodsId > 0
                        ) AND vbIsAssetTo = TRUE)
                     OR vbIsAssetTo = FALSE)
                  -- AND ((_tmpLocation.DescId <> zc_ContainerLinkObject_Member() AND CLO_Member.ContainerId IS NULL)
                  --   OR _tmpLocation.DescId = zc_ContainerLinkObject_Member())
               ) AS tmp
                WHERE ((tmp.Value1_ch <> zc_ContainerLinkObject_Member() AND tmp.Value2_ch IS NULL)
                    OR tmp.Value1_ch = zc_ContainerLinkObject_Member())
              ;
         ELSE
             WITH -- МНМА + ОС
                  tmpGoods_os AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (9354099) AS lfSelect) -- МНМА + ОС
                , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId
                                 FROM (SELECT inAccountGroupId              AS AccountGroupId WHERE inAccountGroupId <> 0
                                 UNION SELECT zc_Enum_AccountGroup_10000()  AS AccountGroupId WHERE inAccountGroupId = 0
                                 UNION SELECT zc_Enum_AccountGroup_20000()  AS AccountGroupId WHERE inAccountGroupId = 0
                                 UNION SELECT zc_Enum_AccountGroup_60000()  AS AccountGroupId WHERE inAccountGroupId = 0
                                 UNION SELECT zc_Enum_AccountGroup_110000() AS AccountGroupId WHERE inAccountGroupId = 0
                                      ) AS tmp
                                      INNER JOIN Object_Account_View AS View_Account ON View_Account.AccountGroupId = tmp.AccountGroupId
                                )
             INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
                SELECT tmp.LocationId, tmp.ContainerDescId, tmp.ContainerId_count, tmp.ContainerId_begin, tmp.GoodsId, tmp.AccountId, tmp.AccountGroupId, tmp.Amount
                FROM
               (WITH 
                tmpContainer AS (SELECT _tmpLocation.LocationId
                                      , _tmpLocation.ContainerDescId
                                      , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                  THEN ContainerLinkObject.ContainerId
                                             ELSE COALESCE (Container.ParentId, 0)
                                        END AS ContainerId_count
                                      , ContainerLinkObject.ContainerId AS ContainerId_begin
                                      
                                        -- подключили !!!OLAP!!!
                                      , CASE WHEN vb_IsContainer_OLAP = TRUE THEN COALESCE (Container_data.Amount, 0) ELSE Container.Amount END AS Amount 
                                      , _tmpLocation.DescId    AS Value1_ch
                                     
                                      , Container.ObjectId
                                 FROM _tmpLocation
                                      INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                                    AND ContainerLinkObject.DescId = _tmpLocation.DescId
                                      INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                                          AND Container.DescId = _tmpLocation.ContainerDescId 
                                      -- подключили !!!OLAP!!!
                                      LEFT JOIN tmp_Container_data AS Container_data
                                      --LEFT JOIN Container_data
                                                                   ON Container_data.Id        = Container.Id
                                                                   -- подключили !!!OLAP!!!
                                                                   AND Container_data.StartDate = vbStartDate_olap
                                                                   AND Container_data.VerId     = vbVerId_olap
                                                                   AND vb_IsContainer_OLAP      = TRUE
                                 )

              , tmpCLO_Account AS (SELECT *
                                   FROM ContainerLinkObject
                                   WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId_begin FROM tmpContainer)
                                     AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Account()
                                    )           
              , tmpCLO_Goods AS (SELECT *
                                 FROM ContainerLinkObject
                                 WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId_begin FROM tmpContainer) 
                                   AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Goods()
                                  )
              , tmpCLO_Member AS (SELECT *
                                  FROM ContainerLinkObject
                                  WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId_begin FROM tmpContainer) 
                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Member()
                                   )     
              , tmpCLO_AssetTo AS (SELECT *
                                   FROM ContainerLinkObject
                                   WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId_begin FROM tmpContainer) 
                                     AND ContainerLinkObject.DescId = zc_ContainerLinkObject_AssetTo()
                                    )                                              
              , tmpCLO_PartionGoods AS (SELECT *
                                        FROM ContainerLinkObject
                                        WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId_begin FROM tmpContainer)
                                          AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                         )

                SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , _tmpLocation.ContainerId_count
                     , _tmpLocation.ContainerId_begin
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN COALESCE (_tmpLocation.ObjectId, 0) ELSE COALESCE (CLO_Goods.ObjectId, 0) END AS GoodsId
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN COALESCE (CLO_Account.ObjectId, 0)
                            ELSE COALESCE (_tmpLocation.ObjectId, 0)
                       END AS AccountId
                     , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN zc_Enum_AccountGroup_110000() -- фТБОЪЙФ
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId
                     , _tmpLocation.Amount 
                     , _tmpLocation.Value1_ch
                     , CLO_Member.ContainerId AS Value2_ch
                FROM tmpContainer AS _tmpLocation               
                       
                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = _tmpLocation.ObjectId
                     LEFT JOIN tmpCLO_Goods AS CLO_Goods 
                                            ON CLO_Goods.ContainerId = _tmpLocation.ContainerId_begin
                                           AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                           AND _tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                     LEFT JOIN tmpCLO_Account AS CLO_Account 
                                              ON CLO_Account.ContainerId = _tmpLocation.ContainerId_begin
                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                             AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                     LEFT JOIN tmpCLO_Member AS CLO_Member 
                                             ON CLO_Member.ContainerId = CASE WHEN false = TRUE THEN _tmpLocation.ContainerId_begin ELSE NULL END
                                            AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
                                            AND CLO_Member.ObjectId > 0

                     LEFT JOIN tmpCLO_AssetTo AS CLO_AssetTo ON CLO_AssetTo.ContainerId = _tmpLocation.ContainerId_begin
                                                                 AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                     LEFT JOIN tmpCLO_PartionGoods AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpLocation.ContainerId_begin
                                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                     LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId

                     LEFT JOIN tmpGoods_os ON tmpGoods_os.GoodsId = CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN _tmpLocation.ObjectId ELSE CLO_Goods.ObjectId END
                WHERE ((_tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) AND tmpAccount.AccountId > 0)
                    OR (_tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                              OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                               ))
                      )
                  AND (((Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000()
                      OR tmpGoods_os.GoodsId > 0
                        ) AND vbIsAssetTo = TRUE)
                     OR vbIsAssetTo = FALSE)
               
               
               /*
               SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN ContainerLinkObject.ContainerId
                            ELSE COALESCE (Container.ParentId, 0)
                       END AS ContainerId_count
                     , ContainerLinkObject.ContainerId AS ContainerId_begin
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN COALESCE (Container.ObjectId, 0) ELSE COALESCE (CLO_Goods.ObjectId, 0) END AS GoodsId
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN COALESCE (CLO_Account.ObjectId, 0)
                            ELSE COALESCE (Container.ObjectId, 0)
                       END AS AccountId
                     , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN zc_Enum_AccountGroup_110000() -- Транзит
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId

                       -- подключили !!!OLAP!!!
                     , CASE WHEN vb_IsContainer_OLAP = TRUE THEN COALESCE (Container_data.Amount, 0) ELSE Container.Amount END AS Amount

                     , _tmpLocation.DescId    AS Value1_ch
                     , CLO_Member.ContainerId AS Value2_ch
                FROM _tmpLocation
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                   AND ContainerLinkObject.DescId = _tmpLocation.DescId
                     INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                         AND Container.DescId = _tmpLocation.ContainerDescId
                     -- подключили !!!OLAP!!!
                     LEFT JOIN tmp_Container_data AS Container_data
                     --LEFT JOIN Container_data
                                                  ON Container_data.Id        = Container.Id
                                                  -- подключили !!!OLAP!!!
                                                  AND Container_data.StartDate = vbStartDate_olap
                                                  AND Container_data.VerId     = vbVerId_olap
                                                  AND vb_IsContainer_OLAP      = TRUE

                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                     LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                               AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                               AND _tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                                 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                     LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = CASE WHEN vbIsCLO_Member = TRUE THEN Container.Id ELSE NULL END
                                                                AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                                AND CLO_Member.ObjectId > 0

                     LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = ContainerLinkObject.ContainerId
                                                                 AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = ContainerLinkObject.ContainerId
                                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                     LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId

                     LEFT JOIN tmpGoods_os ON tmpGoods_os.GoodsId = CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN Container.ObjectId ELSE CLO_Goods.ObjectId END

                WHERE ((_tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) AND tmpAccount.AccountId > 0)
                    OR (_tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                              OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                               ))
                      )
                  AND (((Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000()
                      OR tmpGoods_os.GoodsId > 0
                        ) AND vbIsAssetTo = TRUE)
                     OR vbIsAssetTo = FALSE)
                  -- AND ((ContainerLinkObject.DescId <> zc_ContainerLinkObject_Member() AND CLO_Member.ContainerId IS NULL)
                  --   OR ContainerLinkObject.DescId = zc_ContainerLinkObject_Member())
              */ ) AS tmp
                WHERE ((tmp.Value1_ch <> zc_ContainerLinkObject_Member() AND tmp.Value2_ch IS NULL)
                    OR tmp.Value1_ch = zc_ContainerLinkObject_Member())
               ;
         END IF;
    END IF;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpListContainer;

if inUserId = 5 and 1=0
then
RAISE EXCEPTION '<%   %>', (select count(*) from _tmpListContainer where _tmpListContainer.AccountId = 0)
, (select count(*) from _tmpListContainer )
;
end if;

    -- 1. пытаемся найти <Счет> для zc_Container_Count
    UPDATE _tmpListContainer SET AccountId      = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
         INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
         INNER JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = _tmpListContainer_summ.ContainerId_begin
                                                              AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                                              AND CLO_InfoMoneyDetail.ObjectId = View_InfoMoney.InfoMoneyId
         /*INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ChildObjectId = _tmpListContainer_summ.GoodsId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                              AND ObjectLink_Goods_InfoMoney.ObjectId = View_InfoMoney.InfoMoneyId*/
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
      AND _tmpListContainer_summ.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId = zc_Enum_AccountGroup_10000(); -- Необоротные активы

    -- 2.1. пытаемся найти <Счет> для zc_Container_Count
    UPDATE _tmpListContainer SET AccountId = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
      AND _tmpListContainer_summ.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId <> zc_Enum_AccountGroup_110000() -- Транзит
      AND _tmpListContainer_summ.Amount <> 0
   ;
    -- 2.2. пытаемся найти <Счет> для zc_Container_Count
    UPDATE _tmpListContainer SET AccountId      = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM (SELECT _tmpListContainer.ContainerId_count, _tmpListContainer.AccountId, _tmpListContainer.AccountGroupId, _tmpListContainer.ContainerDescId
                 -- № п/п
               , ROW_NUMBER() OVER (PARTITION BY _tmpListContainer.ContainerId_count ORDER BY _tmpListContainer.ContainerId_begin DESC) AS Ord
          FROM _tmpListContainer
          WHERE _tmpListContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
            AND _tmpListContainer.AccountGroupId  <> zc_Enum_AccountGroup_110000() -- Транзит
         ) AS _tmpListContainer_summ
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
      -- AND _tmpListContainer_summ.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId <> zc_Enum_AccountGroup_110000() -- Транзит
      AND _tmpListContainer_summ.Ord = 1 -- !!!последний!!!
   ;

    -- 2.3. пытаемся найти <Счет> для zc_Container_Count
    UPDATE _tmpListContainer SET AccountId      = _tmpListContainer_find.AccountId
                               , AccountGroupId = _tmpListContainer_find.AccountGroupId
    FROM (SELECT _tmpListContainer.GoodsId, _tmpListContainer.AccountId, _tmpListContainer.AccountGroupId
                 -- № п/п
               , ROW_NUMBER() OVER (PARTITION BY _tmpListContainer.GoodsId ORDER BY _tmpListContainer.AccountId ASC) AS Ord
          FROM _tmpListContainer
               INNER JOIN _tmpListContainer AS _tmpListContainer_check
                                            ON _tmpListContainer_check.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                           AND _tmpListContainer_check.AccountId = 0
                                           AND _tmpListContainer_check.GoodsId   = _tmpListContainer.GoodsId
          WHERE _tmpListContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
            AND _tmpListContainer.AccountId > 0

         ) AS _tmpListContainer_find
    WHERE _tmpListContainer.GoodsId = _tmpListContainer_find.GoodsId
      AND _tmpListContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
      -- AND _tmpListContainer_summ.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_find.Ord = 1 -- !!!последний!!!
   ;

    -- 2.4. убрали
    DELETE FROM _tmpListContainer
    WHERE _tmpListContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
      AND COALESCE (_tmpListContainer.AccountId, 0) = 0
      AND EXISTS (SELECT 1 FROM Container WHERE Container.ParentId = _tmpListContainer.ContainerId_count)
      AND (vbIsAssetNoBalance = TRUE) --  OR inUserId = 5
      AND (EXISTS (SELECT 1 FROM _tmpLocation WHERE _tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()))) --  OR inUserId = 5
     ;


    -- все ContainerId
    INSERT INTO _tmpContainer (ContainerDescId, ContainerDescId_count, ContainerId_count, ContainerId_begin, LocationId, CarId, GoodsId, GoodsKindId, PartionGoodsId, AssetToId, AccountId, AccountGroupId, Amount)
       WITH 
       tmpContainer AS (SELECT *
                        FROM Container
                        WHERE Container.Id IN (SELECT DISTINCT_tmpListContainer.ContainerId_count FROM DISTINCT_tmpListContainer)
                        )

     , tmpCLO_GoodsKind AS (SELECT *
                            FROM ContainerLinkObject
                            WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId_count FROM tmpContainer) 
                              AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Goods()
                             )
     , tmpCLO_Car AS (SELECT *
                      FROM ContainerLinkObject
                      WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId_begin FROM tmpContainer)
                        AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Car()
                       )           
     , tmpCLO_Unit AS (SELECT *
                       FROM ContainerLinkObject
                       WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId_begin FROM tmpContainer) 
                         AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                        )     
     , tmpCLO_AssetTo AS (SELECT *
                          FROM ContainerLinkObject
                          WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId_begin FROM tmpContainer) 
                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_AssetTo()
                           )                                              
     , tmpCLO_PartionGoods AS (SELECT *
                               FROM ContainerLinkObject
                               WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId_begin FROM tmpContainer)
                                 AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                )
       SELECT _tmpListContainer.ContainerDescId
            , Container.DescId AS ContainerDescId_count
            , _tmpListContainer.ContainerId_count
            , _tmpListContainer.ContainerId_begin
            , CASE WHEN _tmpListContainer.LocationId = 0 THEN COALESCE (CLO_Unit.ObjectId, 0) ELSE _tmpListContainer.LocationId END AS LocationId
            , COALESCE (CLO_Car.ObjectId, 0) AS CarId
            , _tmpListContainer.GoodsId
            , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
            , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
            , COALESCE (CLO_AssetTo.ObjectId, 0) AS AssetToId
            , _tmpListContainer.AccountId
            , _tmpListContainer.AccountGroupId
            , _tmpListContainer.Amount
       FROM _tmpListContainer
            LEFT JOIN tmpContainer ON Container.Id = _tmpListContainer.ContainerId_count
            LEFT JOIN tmpCLO_GoodsKind AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpListContainer.ContainerId_count -- _tmpListContainer.ContainerId_count -- _tmpListContainer.ContainerId_begin
                                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
            LEFT JOIN tmpCLO_AssetTo AS CLO_AssetTo ON CLO_AssetTo.ContainerId = _tmpListContainer.ContainerId_begin
                                                        AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
            LEFT JOIN tmpCLO_Car AS CLO_Car ON CLO_Car.ContainerId = _tmpListContainer.ContainerId_begin
                                                    AND CLO_Car.DescId = zc_ContainerLinkObject_Car()
            LEFT JOIN tmpCLO_Unit AS CLO_Unit ON CLO_Unit.ContainerId = _tmpListContainer.ContainerId_begin
                                                     AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
            LEFT JOIN tmpCLO_PartionGoods AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpListContainer.ContainerId_begin
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
       ;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpContainer;

    -- Результат
    RETURN QUERY
          WITH
             tmpPriceList_Basis AS (SELECT ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                                         , COALESCE (ObjectLink_PriceListItem_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                         , ObjectHistory_PriceListItem.StartDate
                                         , ObjectHistory_PriceListItem.EndDate
                                         , (ObjectHistoryFloat_PriceListItem_Value.ValueData * 1.2) :: TFloat AS ValuePrice
                                         , ObjectLink_PriceListItem_PriceList.ObjectId AS PriceListItemId

                                     FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                                          LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                               ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                              AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                          LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                               ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                              AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

                                          LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                                  ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                                 AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                                 AND inEndDate >= ObjectHistory_PriceListItem.StartDate AND inStartDate < ObjectHistory_PriceListItem.EndDate

                                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                       ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                      AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                                     WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                                       AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                       AND COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) <> 0
                                       )

             , tmpMIContainer AS (SELECT _tmpContainer.ContainerDescId
                                       , _tmpContainer.ContainerDescId_count
                                       , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END AS ContainerId_count
                                       , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END AS ContainerId_begin
                                       , MAX (_tmpContainer.ContainerId_count)AS ContainerId_count_max
--                                     , MAX (case when MIContainer.MovementDescId = zc_Movement_Sale() then MIContainer.MovementId else 0 end)AS ContainerId_count_max
                                       , MAX (_tmpContainer.ContainerId_begin) AS ContainerId_begin_max

                                       , _tmpContainer.LocationId
                                       , _tmpContainer.CarId
                                       , _tmpContainer.GoodsId
                                       , _tmpContainer.GoodsKindId
                                       , _tmpContainer.PartionGoodsId
                                       , _tmpContainer.AssetToId
                                       , _tmpContainer.AccountId
                                       , _tmpContainer.AccountGroupId

                                       , CASE WHEN MovementBoolean_Peresort.ValueData = TRUE
                                               AND inIsInfoMoney = FALSE
                                                   THEN -1
                                              WHEN MIContainer.MovementDescId IN (zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND inIsInfoMoney = FALSE
                                                   THEN MIContainer.ObjectExtId_Analyzer -- MIContainer.AnalyzerId
                                              ELSE 0
                                         END AS LocationId_by
                                       -- , 0 AS LocationId_by


                                         -- ***COUNT***
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset())
                                                    -- НЕ заправка со склада - расход
                                                    AND (MIContainer.isActive = TRUE OR MIContainer.Amount >= 0)
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountIncome
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount

                                                   -- заправка со склада - расход
                                                   WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset())
                                                    AND (MIContainer.isActive = FALSE AND MIContainer.Amount < 0)
                                                        THEN -1 * MIContainer.Amount

                                                   ELSE 0
                                              END) AS CountSendOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 --
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_10500() -- Кол-во, перемещение, перемещение по цене, Скидка за вес
                                                    --AND MIContainer.isActive = TRUE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPrice_10500
                                         , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_40200() -- Кол-во, перемещение, перемещение по цене, Разница в весе
                                                    --AND MIContainer.isActive = TRUE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPrice_40200

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 --
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceOut
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_10900() -- Кол-во, Утилизация возвратов при реализации/перемещении по цене
                                                    -- AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceOut_10900

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!Тара!!! + Кол-во, возврат, от покупателя
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnIn_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!Тара!!! + Кол-во, возврат, от покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnInReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnInReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND (MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_LossAsset(), zc_Movement_Transport())
                                                         OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                        )
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountLoss
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountInventory
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountProductionIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountProductionOut

                                         -- ***SUMM***
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset())
                                                   -- НЕ заправка со склада - расход
                                                   AND (MIContainer.isActive = TRUE OR MIContainer.Amount >= 0)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummIncome
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                   AND MIContainer.isActive = TRUE
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount

                                                   -- заправка со склада - расход
                                                   WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset())
                                                   AND (MIContainer.isActive = FALSE AND MIContainer.Amount < 0)
                                                       THEN -1 * MIContainer.Amount

                                                  ELSE 0
                                             END) AS SummSendOut

                                       , SUM (CASE /*WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
and MIContainer.Id = 37276849975
and inUserId = 5
then 1*/
                                                   WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND (MovementBoolean_HistoryCost.ValueData = TRUE AND MLO_To.ObjectId = MIContainer.WhereObjectId_analyzer)
                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                   -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 --
                                                       THEN MIContainer.Amount

                                                  WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = TRUE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                   -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPriceIn

                                        , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_10500() -- Сумма с/с, перемещение по цене,  Скидка за вес
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPrice_10500

                                         , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                  --AND MIContainer.isActive = TRUE
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendSumm_40200()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPrice_40200

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND (COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE OR MLO_To.ObjectId <> MIContainer.WhereObjectId_analyzer)

                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                   -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = FALSE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                   -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPriceOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   -- AND MIContainer.isActive = FALSE
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_10900() -- Сумма с/с, Утилизация возвратов при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPriceOut_10900

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnIn_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   -- AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnInReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnInReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND (MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_LossAsset(), zc_Movement_Transport())
                                                        OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       )
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummLoss

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummInventory

                                       , SUM (COALESCE (tmpPriceList_Basis_gk.ValuePrice, tmpPriceList_Basis.ValuePrice) *
                                              CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS SummInventory_Basis

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummInventory_RePrice

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                  ELSE 0
                                              END) AS SummProductionIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                              END) AS SummProductionOut

                                         -- ***REMAINS***
                                       , -1 * SUM (MIContainer.Amount) AS RemainsStart
                                       , 0                             AS RemainsEnd

                                       --  CountCount
                                      , 0 AS CountStart_byCount
                                      , 0 AS CountEnd_byCount
                                      , 0 AS CountIncome_byCount
                                      , 0 AS CountReturnOut_byCount
                                      , 0 AS CountSendIn_byCount
                                      , 0 AS CountSendOut_byCount
                                      , 0 AS CountSendOnPriceIn_byCount
                                      , 0 AS CountSendOnPriceOut_byCount

                                  FROM _tmpContainer
                                       INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
-- and (MIContainer.MovementId not IN (28101616  ) -- , 28086493
-- or inUserId <> 5
-- )
                                       LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                                                 ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                                       LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                                 ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()

                                       LEFT JOIN MovementLinkObject AS MLO_To
                                                                    ON MLO_To.MovementId          = MIContainer.MovementId
                                                                   AND MLO_To.DescId              = zc_MovementLinkObject_To()
                                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()

                                       LEFT JOIN tmpPriceList_Basis AS tmpPriceList_Basis_gk
                                                                    ON tmpPriceList_Basis_gk.GoodsId = _tmpContainer.GoodsId
                                                                   AND (tmpPriceList_Basis_gk.StartDate <= MIContainer.OperDate AND MIContainer.OperDate < tmpPriceList_Basis_gk.EndDate)
                                                                   AND tmpPriceList_Basis_gk.GoodsKindId = _tmpContainer.GoodsKindId
                                       LEFT JOIN tmpPriceList_Basis ON tmpPriceList_Basis.GoodsId = _tmpContainer.GoodsId
                                                                   AND (tmpPriceList_Basis.StartDate <= MIContainer.OperDate AND MIContainer.OperDate < tmpPriceList_Basis.EndDate)
                                                                   AND tmpPriceList_Basis.GoodsKindId = 0

                                  GROUP BY _tmpContainer.ContainerDescId
                                         , _tmpContainer.ContainerDescId_count
                                         , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END
                                         , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END
                                         , _tmpContainer.LocationId
                                         , _tmpContainer.CarId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.GoodsKindId
                                         , _tmpContainer.PartionGoodsId
                                         , _tmpContainer.AssetToId
                                         , _tmpContainer.AccountId
                                         , _tmpContainer.AccountGroupId
                                         , CASE WHEN MovementBoolean_Peresort.ValueData = TRUE
                                                 AND inIsInfoMoney = FALSE
                                                     THEN -1
                                                WHEN MIContainer.MovementDescId IN (zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                 AND inIsInfoMoney = FALSE
                                                     THEN MIContainer.ObjectExtId_Analyzer -- MIContainer.AnalyzerId
                                                ELSE 0
                                           END
                                  HAVING -- ***COUNT***
                                         SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset())
                                                    -- НЕ заправка со склада - расход
                                                    AND (MIContainer.isActive = TRUE OR MIContainer.Amount >= 0)
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountIncome
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount

                                                   -- заправка со склада - расход
                                                   WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset())
                                                    AND (MIContainer.isActive = FALSE AND MIContainer.Amount < 0)
                                                        THEN -1 * MIContainer.Amount

                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOnPriceIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_10500() -- Кол-во, перемещение, перемещение по цене, Скидка за вес
                                                    --AND MIContainer.isActive = TRUE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 --AS CountSendOnPrice_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_40200() -- Кол-во, перемещение, перемещение по цене, Разница в весе
                                                    --AND MIContainer.isActive = TRUE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 --AS CountSendOnPrice_40200

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOnPriceOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_10900() -- Кол-во, Утилизация возвратов при реализации/перемещении по цене
                                                    -- AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOnPriceOut_10900

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- Кол-во, реализация, Скидка за вес
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- Кол-во, реализация, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!Тара!!! + Кол-во, возврат, от покупателя
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- Транзит
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnIn_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!Тара!!! + Кол-во, возврат, от покупателя
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnInReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- Кол-во, возврат, Разница в весе
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnInReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND (MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_LossAsset(), zc_Movement_Transport())
                                                         OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() -- Кол-во, списание при реализации/перемещении по цене
                                                        )
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountLoss
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountInventory
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountProductionIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountProductionOut

                                         -- ***SUMM***
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset())
                                                   -- НЕ заправка со склада - расход
                                                   AND (MIContainer.isActive = TRUE OR MIContainer.Amount >= 0)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummIncome
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                   AND MIContainer.isActive = TRUE
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                   -- заправка со склада - расход
                                                   WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeCost(), zc_Movement_IncomeAsset())
                                                   AND (MIContainer.isActive = FALSE AND MIContainer.Amount < 0)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MovementBoolean_HistoryCost.ValueData = TRUE
                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN MIContainer.Amount
                                                  WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = TRUE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendOnPriceIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE
                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = FALSE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendOnPriceOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   -- AND MIContainer.isActive = FALSE
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_10900() -- Сумма с/с, Утилизация возвратов при реализации/перемещении по цене
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendOnPriceOut_10900

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSale
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSale_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSale_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- Сумма с/с, реализация, у покупателя
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSaleReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Сумма с/с, реализация, Скидка за вес
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSaleReal_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Сумма с/с, реализация, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSaleReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnIn_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- Сумма с/с, возврат, от покупателя
                                                   -- AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnInReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- Сумма с/с, возврат, Разница в весе
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnInReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND (MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_LossAsset(), zc_Movement_Transport())
                                                        OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200() -- Сумма с/с, списание при реализации/перемещении по цене
                                                       )
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummLoss

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummInventory

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummInventory_RePrice

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                  ELSE 0
                                              END) <> 0 -- AS SummProductionIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                              END) <> 0 -- AS SummProductionOut
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_10500() -- Сумма с/с, перемещение по цене,  Скидка за вес
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END)  <> 0  -- AS SummSendOnPrice_10500

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                  --AND MIContainer.isActive = TRUE
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendSumm_40200()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0  -- AS SummSendOnPrice_40200

                                         -- ***REMAINS***
                                      OR SUM (MIContainer.Amount) <> 0 -- AS RemainsStart
                                  --остатки
                                 UNION ALL
                                  SELECT _tmpContainer.ContainerDescId
                                       , _tmpContainer.ContainerDescId_count
                                       , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END AS ContainerId_count
                                       , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END AS ContainerId_begin
                                       , MAX (_tmpContainer.ContainerId_count) AS ContainerId_count_max
                                       , MAX (_tmpContainer.ContainerId_begin) AS ContainerId_begin_max

                                       , _tmpContainer.LocationId
                                       , _tmpContainer.CarId
                                       , _tmpContainer.GoodsId
                                       , _tmpContainer.GoodsKindId
                                       , _tmpContainer.PartionGoodsId
                                       , _tmpContainer.AssetToId
                                       , _tmpContainer.AccountId
                                       , _tmpContainer.AccountGroupId

                                       , 0 AS LocationId_by

                                         -- ***COUNT***
                                       , 0 AS CountIncome
                                       , 0 AS CountReturnOut

                                       , 0 AS CountSendIn
                                       , 0 AS CountSendOut

                                       , 0 AS CountSendOnPriceIn
                                       , 0 AS CountSendOnPrice_10500
                                       , 0 AS CountSendOnPrice_40200
                                       , 0 AS CountSendOnPriceOut
                                       , 0 AS CountSendOnPriceOut_10900

                                       , 0 AS CountSale
                                       , 0 AS CountSale_10500
                                       , 0 AS CountSale_40208

                                       , 0 AS CountSaleReal
                                       , 0 AS CountSaleReal_10500
                                       , 0 AS CountSaleReal_40208

                                       , 0 AS CountReturnIn
                                       , 0 AS CountReturnIn_40208

                                       , 0 AS CountReturnInReal
                                       , 0 AS CountReturnInReal_40208

                                       , 0 AS CountLoss
                                       , 0 AS CountInventory
                                       , 0 AS CountProductionIn
                                       , 0 AS CountProductionOut

                                         -- ***SUMM***
                                       , 0 AS SummIncome
                                       , 0 AS SummReturnOut

                                       , 0 AS SummSendIn
                                       , 0 AS SummSendOut

                                       , 0 AS SummSendOnPriceIn
                                       , 0 AS SummSendOnPrice_10500
                                       , 0 AS SummSendOnPrice_40200
                                       , 0 AS SummSendOnPriceOut
                                       , 0 AS SummSendOnPriceOut_10900

                                       , 0 AS SummSale
                                       , 0 AS SummSale_10500
                                       , 0 AS SummSale_40208

                                       , 0 AS SummSaleReal
                                       , 0 AS SummSaleReal_10500
                                       , 0 AS SummSaleReal_40208

                                       , 0 AS SummReturnIn
                                       , 0 AS SummReturnIn_40208

                                       , 0 AS SummReturnInReal
                                       , 0 AS SummReturnInReal_40208

                                       , 0 AS SummLoss
                                       , 0 AS SummInventory
                                       , 0 AS SummInventory_Basis
                                       , 0 AS SummInventory_RePrice

                                       , 0 AS SummProductionIn
                                       , 0 AS SummProductionOut

                                         -- ***REMAINS***
                                       , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                                       , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsEnd

                                       --  CountCount
                                      , 0 AS CountStart_byCount
                                      , 0 AS CountEnd_byCount
                                      , 0 AS CountIncome_byCount
                                      , 0 AS CountReturnOut_byCount
                                      , 0 AS CountSendIn_byCount
                                      , 0 AS CountSendOut_byCount
                                      , 0 AS CountSendOnPriceIn_byCount
                                      , 0 AS CountSendOnPriceOut_byCount
                                  FROM _tmpContainer AS _tmpContainer
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                                     AND MIContainer.OperDate > inEndDate
                                                                                     AND (MIContainer.OperDate < vbStartDate_olap
                                                                                       OR vb_IsContainer_OLAP  = FALSE
                                                                                         )

                                  GROUP BY _tmpContainer.ContainerDescId
                                         , _tmpContainer.ContainerDescId_count
                                         , _tmpContainer.ContainerId_count
                                         , _tmpContainer.ContainerId_begin
                                         , _tmpContainer.LocationId
                                         , _tmpContainer.CarId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.GoodsKindId
                                         , _tmpContainer.PartionGoodsId
                                         , _tmpContainer.AssetToId
                                         , _tmpContainer.AccountId
                                         , _tmpContainer.AccountGroupId
                                         , _tmpContainer.Amount
                                  HAVING _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0

                                 UNION ALL
                                  -- CountCount
                                  SELECT _tmpContainer.ContainerDescId
                                       , _tmpContainer.ContainerDescId_count
                                       , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END AS ContainerId_count
                                       , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END AS ContainerId_begin
                                       , MAX (_tmpContainer.ContainerId_count) AS ContainerId_count_max
                                       , MAX (_tmpContainer.ContainerId_begin) AS ContainerId_begin_max

                                       , _tmpContainer.LocationId
                                       , _tmpContainer.CarId
                                       , _tmpContainer.GoodsId
                                       , _tmpContainer.GoodsKindId
                                       , _tmpContainer.PartionGoodsId
                                       , _tmpContainer.AssetToId
                                       , _tmpContainer.AccountId
                                       , _tmpContainer.AccountGroupId

                                       , 0 AS LocationId_by

                                         -- ***COUNT***
                                       , 0 AS CountIncome
                                       , 0 AS CountReturnOut

                                       , 0 AS CountSendIn
                                       , 0 AS CountSendOut

                                       , 0 AS CountSendOnPriceIn
                                       , 0 AS CountSendOnPrice_10500
                                       , 0 AS CountSendOnPrice_40200
                                       , 0 AS CountSendOnPriceOut
                                       , 0 AS CountSendOnPriceOut_10900

                                       , 0 AS CountSale
                                       , 0 AS CountSale_10500
                                       , 0 AS CountSale_40208

                                       , 0 AS CountSaleReal
                                       , 0 AS CountSaleReal_10500
                                       , 0 AS CountSaleReal_40208

                                       , 0 AS CountReturnIn
                                       , 0 AS CountReturnIn_40208

                                       , 0 AS CountReturnInReal
                                       , 0 AS CountReturnInReal_40208

                                       , 0 AS CountLoss
                                       , 0 AS CountInventory
                                       , 0 AS CountProductionIn
                                       , 0 AS CountProductionOut

                                         -- ***SUMM***
                                       , 0 AS SummIncome
                                       , 0 AS SummReturnOut

                                       , 0 AS SummSendIn
                                       , 0 AS SummSendOut

                                       , 0 AS SummSendOnPriceIn
                                       , 0 AS SummSendOnPrice_10500
                                       , 0 AS SummSendOnPrice_40200
                                       , 0 AS SummSendOnPriceOut
                                       , 0 AS SummSendOnPriceOut_10900

                                       , 0 AS SummSale
                                       , 0 AS SummSale_10500
                                       , 0 AS SummSale_40208

                                       , 0 AS SummSaleReal
                                       , 0 AS SummSaleReal_10500
                                       , 0 AS SummSaleReal_40208

                                       , 0 AS SummReturnIn
                                       , 0 AS SummReturnIn_40208

                                       , 0 AS SummReturnInReal
                                       , 0 AS SummReturnInReal_40208

                                       , 0 AS SummLoss
                                       , 0 AS SummInventory
                                       , 0 AS SummInventory_Basis
                                       , 0 AS SummInventory_RePrice

                                       , 0 AS SummProductionIn
                                       , 0 AS SummProductionOut

                                         -- ***REMAINS***
                                       , 0 AS  RemainsStart
                                       , 0 AS  RemainsEnd

                                       --  CountCount
                                      , Container.Amount - SUM ( COALESCE (MIContainer.Amount,0))                                                                                                                                        AS CountStart_byCount
                                      , Container.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END)                                                                                           AS CountEnd_byCount
                                      , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = TRUE  AND MIContainer.MovementDescId = zc_Movement_Income()      THEN COALESCE (MIContainer.Amount,0) ELSE 0 END)    AS CountIncome_byCount
                                      , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = TRUE  AND MIContainer.MovementDescId = zc_Movement_ReturnOut()   THEN COALESCE (MIContainer.Amount,0) ELSE 0 END)    AS CountReturnOut_byCount
                                      , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = TRUE  AND MIContainer.MovementDescId = zc_Movement_Send()        THEN COALESCE (MIContainer.Amount,0) ELSE 0 END)    AS CountSendIn_byCount
                                      , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = FALSE AND MIContainer.MovementDescId = zc_Movement_Send()        THEN COALESCE (MIContainer.Amount,0) ELSE 0 END)    AS CountSendOut_byCount
                                      , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = TRUE  AND MIContainer.MovementDescId = zc_Movement_SendOnPrice() THEN COALESCE (MIContainer.Amount,0) ELSE 0 END)    AS CountSendOnPriceIn_byCount
                                      , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = FALSE AND MIContainer.MovementDescId = zc_Movement_SendOnPrice() THEN COALESCE (MIContainer.Amount,0) ELSE 0 END)    AS CountSendOnPriceOut_byCount
                                  FROM _tmpContainer
                                        INNER JOIN Container ON Container.ParentId = _tmpContainer.ContainerId_begin
                                                            AND Container.DescId = zc_Container_CountCount()
                                        LEFT JOIN MovementItemContainer AS MIContainer
                                                                        ON MIContainer.ContainerId = Container.Id
                                                                       AND MIContainer.DescId = zc_MIContainer_CountCount()
                                                                       AND MIContainer.OperDate >= inStartDate
                                                                       AND (MIContainer.OperDate < vbStartDate_olap
                                                                         OR vb_IsContainer_OLAP  = FALSE
                                                                           )
                                  GROUP BY _tmpContainer.ContainerDescId
                                         , _tmpContainer.ContainerDescId_count
                                         , _tmpContainer.ContainerId_count
                                         , _tmpContainer.ContainerId_begin
                                         , _tmpContainer.LocationId
                                         , _tmpContainer.CarId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.GoodsKindId
                                         , _tmpContainer.PartionGoodsId
                                         , _tmpContainer.AssetToId
                                         , _tmpContainer.AccountId
                                         , _tmpContainer.AccountGroupId
                                         , Container.Amount
                                  HAVING Container.Amount - SUM ( COALESCE (MIContainer.Amount,0)) <> 0
                                      OR Container.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END) <> 0
                                      OR SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = TRUE  AND MIContainer.MovementDescId = zc_Movement_Income()    THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) <> 0
                                      OR SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = TRUE  AND MIContainer.MovementDescId = zc_Movement_ReturnOut() THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) <> 0
                                      OR SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = TRUE  AND MIContainer.MovementDescId = zc_Movement_Send()      THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) <> 0
                                      OR SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = FALSE AND MIContainer.MovementDescId = zc_Movement_Send()      THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) <> 0
                                      OR SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = TRUE  AND MIContainer.MovementDescId = zc_Movement_SendOnPrice() THEN COALESCE (MIContainer.Amount,0) ELSE 0 END)<> 0
                                      OR SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = FALSE AND MIContainer.MovementDescId = zc_Movement_SendOnPrice() THEN COALESCE (MIContainer.Amount,0) ELSE 0 END)<> 0
                                 )

       , tmpErr_replace AS (SELECT DISTINCT tmpMIContainer.AccountId, tmpMIContainer.ContainerId_count
                            FROM tmpMIContainer
                            WHERE tmpMIContainer.AccountId = 9086 -- 20101 Продукция
                            --AND inUserId <> 5
                            --AND 1=0
                           )

         -- Результат
         SELECT (COALESCE (tmpErr_replace.AccountId, tmpMIContainer_all.AccountId))       AS AccountId
              , tmpMIContainer_all.ContainerDescId_count :: Integer AS ContainerDescId_count
              , tmpMIContainer_all.ContainerId_count           :: Integer AS ContainerId_count
              , tmpMIContainer_all.ContainerId_begin           :: Integer AS ContainerId
              , MAX (tmpMIContainer_all.ContainerId_count_max) :: Integer AS ContainerId_count_max
              , MAX (tmpMIContainer_all.ContainerId_begin_max) :: Integer AS ContainerId_begin_max

              , tmpMIContainer_all.LocationId
              , tmpMIContainer_all.CarId
              , tmpMIContainer_all.GoodsId
              , tmpMIContainer_all.GoodsKindId
              , tmpMIContainer_all.PartionGoodsId
              , tmpMIContainer_all.AssetToId

              , tmpMIContainer_all.LocationId_by

              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN tmpMIContainer_all.RemainsStart ELSE 0 END) :: TFloat AS CountStart
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN tmpMIContainer_all.RemainsEnd   ELSE 0 END) :: TFloat AS CountEnd
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN tmpMIContainer_all.RemainsEnd - tmpMIContainer_all.CountInventory ELSE 0 END) :: TFloat AS CountEnd_calc

              , SUM (tmpMIContainer_all.CountIncome)             :: TFloat AS CountIncome
              , SUM (tmpMIContainer_all.CountReturnOut)          :: TFloat AS CountReturnOut

              , SUM (tmpMIContainer_all.CountSendIn)             :: TFloat AS CountSendIn
              , SUM (tmpMIContainer_all.CountSendOut)            :: TFloat AS CountSendOut

              , SUM (tmpMIContainer_all.CountSendOnPriceIn)        :: TFloat AS CountSendOnPriceIn
              , SUM (tmpMIContainer_all.CountSendOnPriceOut)       :: TFloat AS CountSendOnPriceOut
              , SUM (tmpMIContainer_all.CountSendOnPriceOut_10900) :: TFloat AS CountSendOnPriceOut_10900

              , SUM (tmpMIContainer_all.CountSendOnPrice_10500)    :: TFloat AS CountSendOnPrice_10500
              , SUM (tmpMIContainer_all.CountSendOnPrice_40200)    :: TFloat AS CountSendOnPrice_40200

              , SUM (tmpMIContainer_all.CountSale)               :: TFloat AS CountSale
              , SUM (tmpMIContainer_all.CountSale_10500)         :: TFloat AS CountSale_10500
              , SUM (tmpMIContainer_all.CountSale_40208)         :: TFloat AS CountSale_40208
              , SUM (tmpMIContainer_all.CountSaleReal)           :: TFloat AS CountSaleReal
              , SUM (tmpMIContainer_all.CountSaleReal_10500)     :: TFloat AS CountSaleReal_10500
              , SUM (tmpMIContainer_all.CountSaleReal_40208)     :: TFloat AS CountSaleReal_40208

              , SUM (tmpMIContainer_all.CountReturnIn)           :: TFloat AS CountReturnIn
              , SUM (tmpMIContainer_all.CountReturnIn_40208)     :: TFloat AS CountReturnIn_40208
              , SUM (tmpMIContainer_all.CountReturnInReal)       :: TFloat AS CountReturnInReal
              , SUM (tmpMIContainer_all.CountReturnInReal_40208) :: TFloat AS CountReturnInReal_40208

              , SUM (tmpMIContainer_all.CountLoss)               :: TFloat AS CountLoss
              , SUM (tmpMIContainer_all.CountInventory)          :: TFloat AS CountInventory

              , SUM (tmpMIContainer_all.CountProductionIn)       :: TFloat AS CountProductionIn
              , SUM (tmpMIContainer_all.CountProductionOut)      :: TFloat AS CountProductionOut

              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) THEN tmpMIContainer_all.RemainsStart ELSE 0 END) :: TFloat AS SummStart
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) THEN tmpMIContainer_all.RemainsEnd   ELSE 0 END) :: TFloat AS SummEnd
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) THEN tmpMIContainer_all.RemainsEnd - tmpMIContainer_all.SummInventory ELSE 0 END) :: TFloat AS SummEnd_calc

              , SUM (tmpMIContainer_all.SummIncome)              :: TFloat AS SummIncome
              , SUM (tmpMIContainer_all.SummReturnOut)           :: TFloat AS SummReturnOut
              , SUM (tmpMIContainer_all.SummSendIn)              :: TFloat AS SummSendIn
              , SUM (tmpMIContainer_all.SummSendOut)             :: TFloat AS SummSendOut
              , SUM (tmpMIContainer_all.SummSendOnPriceIn)       :: TFloat AS SummSendOnPriceIn
              , SUM (tmpMIContainer_all.SummSendOnPriceOut)      :: TFloat AS SummSendOnPriceOut
              , SUM (tmpMIContainer_all.SummSendOnPriceOut_10900):: TFloat AS SummSendOnPriceOut_10900

              , SUM (tmpMIContainer_all.SummSendOnPrice_10500)   :: TFloat AS SummSendOnPrice_10500
              , SUM (tmpMIContainer_all.SummSendOnPrice_40200)   :: TFloat AS SummSendOnPrice_40200

              , SUM (tmpMIContainer_all.SummSale)                :: TFloat AS SummSale
              , SUM (tmpMIContainer_all.SummSale_10500)          :: TFloat AS SummSale_10500
              , SUM (tmpMIContainer_all.SummSale_40208)          :: TFloat AS SummSale_40208
              , SUM (tmpMIContainer_all.SummSaleReal)            :: TFloat AS SummSaleReal
              , SUM (tmpMIContainer_all.SummSaleReal_10500)      :: TFloat AS SummSaleReal_10500
              , SUM (tmpMIContainer_all.SummSaleReal_40208)      :: TFloat AS SummSaleReal_40208
              , SUM (tmpMIContainer_all.SummReturnIn)            :: TFloat AS SummReturnIn
              , SUM (tmpMIContainer_all.SummReturnIn_40208)      :: TFloat AS SummReturnIn_40208
              , SUM (tmpMIContainer_all.SummReturnInReal)        :: TFloat AS SummReturnInReal
              , SUM (tmpMIContainer_all.SummReturnInReal_40208)  :: TFloat AS SummReturnInReal_40208
              , SUM (tmpMIContainer_all.SummLoss)                :: TFloat AS SummLoss
              , SUM (tmpMIContainer_all.SummInventory)           :: TFloat AS SummInventory
              , SUM (tmpMIContainer_all.SummInventory_Basis)     :: TFloat AS SummInventory_Basis
              , SUM (tmpMIContainer_all.SummInventory_RePrice)   :: TFloat AS SummInventory_RePrice
              , SUM (tmpMIContainer_all.SummProductionIn)        :: TFloat AS SummProductionIn
              , SUM (tmpMIContainer_all.SummProductionOut)       :: TFloat AS SummProductionOut

               --  CountCount
              , SUM (tmpMIContainer_all.CountStart_byCount)          :: TFloat AS  CountStart_byCount
              , SUM (tmpMIContainer_all.CountEnd_byCount)            :: TFloat AS  CountEnd_byCount
              , SUM (tmpMIContainer_all.CountIncome_byCount)         :: TFloat AS  CountIncome_byCount
              , SUM (tmpMIContainer_all.CountReturnOut_byCount)      :: TFloat AS  CountReturnOut_byCount
              , SUM (tmpMIContainer_all.CountSendIn_byCount)         :: TFloat AS  CountSendIn_byCount
              , SUM (tmpMIContainer_all.CountSendOut_byCount)        :: TFloat AS  CountSendOut_byCount
              , SUM (tmpMIContainer_all.CountSendOnPriceIn_byCount)  :: TFloat AS  CountSendOnPriceIn_byCount
              , SUM (tmpMIContainer_all.CountSendOnPriceOut_byCount) :: TFloat AS  CountSendOnPriceOut_byCount
 
         FROM tmpMIContainer AS tmpMIContainer_all
              LEFT JOIN tmpErr_replace ON tmpErr_replace.ContainerId_count = tmpMIContainer_all.ContainerId_count
                                      AND tmpMIContainer_all.AccountId     = 256303 -- 20105 Ирна
         GROUP BY COALESCE (tmpErr_replace.AccountId, tmpMIContainer_all.AccountId)
                , tmpMIContainer_all.ContainerDescId_count
                , tmpMIContainer_all.ContainerId_count
                , tmpMIContainer_all.ContainerId_begin
                , tmpMIContainer_all.LocationId
                , tmpMIContainer_all.CarId
                , tmpMIContainer_all.GoodsId
                , tmpMIContainer_all.GoodsKindId
                , tmpMIContainer_all.PartionGoodsId
                , tmpMIContainer_all.AssetToId
                , tmpMIContainer_all.LocationId_by
      ;

      --DROP TABLE _tmpListContainer;
      --DROP TABLE _tmpcontainer;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.11.18         * SummInventory_Basis
 09.05.15                                        * ALL
 15.02.15                                        * add zc_Enum_AnalyzerId_Loss...
 01.02.15                                                       *
 14.11.14                                                       * add LineNum
 23.10.14                                        * add inAccountGroupId and inIsInfoMoney
 23.08.14                                        * add Account...
 12.08.14                                        * add ContainerId
 01.06.14                                        * ALL
 31.08.13         *
*/

-- тест
-- SELECT sum (CountStart), sum (CountEnd), sum (SummStart), sum (SummEnd), sum (SummIncome), sum (SummSendIn) FROM lpReport_MotionGoods (inStartDate:= '31.12.2022', inEndDate:= '31.12.2022', inAccountGroupId:= 9015, inUnitGroupId := 0 , inLocationId := 8425 , inGoodsGroupId := 0 , inGoodsId := 0,  inIsInfoMoney:= FALSE, inUserId := zfCalc_UserAdmin() :: Integer);
-- SELECT * FROM lpReport_MotionGoods (inStartDate:= '01.08.2025', inEndDate:= '01.08.2025', inAccountGroupId:= 9015, inUnitGroupId := 0 , inLocationId := 8425 , inGoodsGroupId := 0 , inGoodsId := 0,  inIsInfoMoney:= FALSE, inUserId := zfCalc_UserAdmin() :: Integer);


SELECT tmp.* FROM lpReport_MotionGoods22 (inStartDate:= ('01.07.2026')::TDateTime, inEndDate:= ('14.07.2026')::TDateTime, inAccountGroupId:= -1 * zc_Enum_AccountGroup_10000()
                                                                 , inUnitGroupId:= 0, inLocationId:= 8447, inGoodsGroupId:= 0
                                                                 , inGoodsId:= 0, inIsInfoMoney:= False, inUserId:= 5) AS tmp 
                                                                 
                                                                 */