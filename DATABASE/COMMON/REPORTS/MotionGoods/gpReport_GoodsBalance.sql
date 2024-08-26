-- Function: gpReport_GoodsBalance()

--DROP FUNCTION IF EXISTS gpReport_GoodsBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsBalance (
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    -- группа подразделений на самом деле может быть и подразделением
    IN inLocationId         Integer,    --
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inGoodsId            Integer,    -- товар
    IN inIsInfoMoney        Boolean,    --
    IN inIsAllMO            Boolean,    -- все МО
    IN inIsAllAuto          Boolean,    -- все Авто
    IN inIsOperDate_Partion Boolean,    -- по дате партии
    IN inisPartionCell      Boolean,    -- по ячейкам
    IN inSession            TVarChar   -- пользователь
)
RETURNS TABLE (AccountGroupName TVarChar, AccountDirectionName TVarChar
             , AccountId Integer, AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
             , LocationDescName TVarChar, LocationId Integer, LocationCode Integer, LocationName TVarChar
             , CarCode Integer, CarName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode_basis Integer, GoodsName_basis TVarChar
             , GoodsCode_main Integer, GoodsName_main TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Name_Scale TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, GoodsKindName_complete TVarChar, MeasureName TVarChar
             , BarCode_Main TVarChar
             , Weight TFloat, WeightTare TFloat
             , InDate TDateTime, PartnerInName TVarChar
             , PartionGoodsDate TDateTime, PartionGoodsName TVarChar, AssetToName TVarChar
             , PartionCellCode Integer, PartionCellName TVarChar
             , DriverName TVarChar, UnitName_to TVarChar

             , CountReal        TFloat  -- остаток текущий
             , CountReal_sh     TFloat  -- остаток текущий
             , CountReal_Weight TFloat  -- остаток текущий
             , PriceReal        TFloat

             , CountStart        TFloat
             , CountStart_sh     TFloat
             , CountStart_Weight TFloat
             , PriceStart        TFloat

             , CountEnd        TFloat
             , CountEnd_sh     TFloat
             , CountEnd_Weight TFloat
             , PriceEnd        TFloat
             
             , SummStart TFloat
             , SummEnd   TFloat
             , SummReal  TFloat
             , SummPriceListStart  TFloat 
             , SummPriceListEnd   TFloat

             , PriceListStart TFloat
             , PriceListEnd TFloat
          
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

             , SummIn TFloat
             , CountIn TFloat
             , CountIn_sh TFloat
             , CountIn_Weight TFloat
             , PriceIn TFloat

             , CountTotalIn_Weight TFloat
             , SummTotalIn TFloat

             , SummOut TFloat
             , CountOut TFloat
             , CountOut_sh TFloat
             , CountOut_Weight TFloat
             , PriceOut TFloat

             , CountIn_calc TFloat
             , CountIn_sh_calc TFloat
             , CountIn_Weight_calc TFloat

             , CountOut_calc TFloat
             , CountOut_sh_calc TFloat
             , CountOut_Weight_calc TFloat

             , CountEnd_calc TFloat
             , CountEnd_sh_calc TFloat
             , CountEnd_Weight_calc TFloat

             , CountLoss_sh     TFloat
             , CountLoss_Weight TFloat
             , SummLoss         TFloat
             , PriceLoss        TFloat

             , CountInventory_sh     TFloat
             , CountInventory_Weight TFloat
             , SummInventory         TFloat
             , PriceInventory        TFloat
             , SummInventory_RePrice TFloat
             , SummInventory_Basis   TFloat

             , TaxExit_norm      TFloat -- % вых по норме
             , TaxExit_norm_real TFloat -- % вых по фактической норме (по кутерам)
             , TaxExit_real      TFloat -- % вых по факту
             , CuterCount         TFloat -- 
             , CountIn_byPF       TFloat -- 
             , Value_receipt      TFloat -- 
             , CuterCount_receipt TFloat -- 

             , CountIn_Weight_end_gp  TFloat -- Прогноз прихода с пр-ва (ГП), расчет для CountEnd
             , CountOut_norm_pf       TFloat -- Расход ПФ(ГП) по норме на пр-во ГП, расчет для CountIn_Weight_gp
             , CountIn_Weight_norm_gp TFloat -- Приход по норме с пр-ва (ГП), расчет для CountOut_byPF
             , CountIn_Weight_gp      TFloat -- Приход с пр-ва (ГП)

             , CountOut_byPF      TFloat -- Расход ПФ(ГП) за период на пр-во
             , Count_byCount      TFloat -- Расход ПФ(ГП) за весь период на пр-во
             , Count_onCount      TFloat -- Кол-во батонов в Расходе ПФ(ГП) за весь период
             , Count_onCount_in   TFloat -- Кол-во батонов в ПРиходе ПФ(ГП) за текущий период
             , Count_onCount_out  TFloat -- Кол-во батонов в расходе ПФ(ГП) за текущий период
             , CountInventory_byCount TFloat -- Кол-во батонов инвентаризация за текущий период
             , CountStart_byCount TFloat -- Нач остаток батонов в ПФ(ГП)
             , CountEnd_byCount   TFloat -- Кон остаток батонов в ПФ(ГП)
             , Weight_byCount     TFloat -- вес 1 батона

             , LineNum Integer
             , isReprice Boolean
             , isPriceStart_diff Boolean
             , isPriceEnd_diff Boolean

             , TermProduction TFloat
             , isPartionClose_calc Boolean

             , ColorB_GreenL Integer, ColorB_Yelow Integer, ColorB_Cyan Integer

             , StorageId           Integer
             , StorageName         TVarChar
             , PartionModelId      Integer
             , PartionModelName    TVarChar
             , UnitId_Partion      Integer
             , UnitName_Partion    TVarChar
             , BranchName_Partion  TVarChar
             , PartNumber_Partion   TVarChar
             , AreaUnitName_storage TVarChar
             , Room_storage         TVarChar
             , Address_storage      TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsPropertyId_basis Integer;
  DECLARE vbIsSummIn Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);
    
    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- !!!Нет прав!!! - Ограниченние - нет доступа к Отчету по остаткам
    IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11086934)
    THEN
        RAISE EXCEPTION 'Ошибка.Нет прав.';
    END IF;

    -- замена
    IF vbUserId <> 5
    THEN inIsInfoMoney:= FALSE;
    END IF;
   

    -- !!!определяется!!!
    vbIsSummIn:= -- Отчеты руководитель сырья
                 NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND RoleId = 442647)
                 -- Ограничение просмотра с/с
             AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE AccessKeyId = zc_Enum_Process_AccessKey_NotCost() AND UserId = vbUserId)
            ;

    -- !!!может так будет быстрее!!!
    inAccountGroupId:= COALESCE (inAccountGroupId, 0);

    vbGoodsPropertyId_basis := zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0);

    -- !!!меняются параметры для филиала!!!
    IF 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
    THEN
        inAccountGroupId:= zc_Enum_AccountGroup_20000(); -- Запасы
        inIsInfoMoney:= FALSE;
    END IF;

    -- таблица -
    -- CREATE TEMP TABLE _tmpListContainer (LocationId Integer, ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, GoodsId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    -- CREATE TEMP TABLE _tmpContainer (ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, LocationId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsId Integer, AssetToId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    -- CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;


    RETURN QUERY


    -- группа подразделений или подразделение или место учета (МО, Авто)
     WITH _tmpLocation AS -- (LocationId, DescId, ContainerDescId)
          (SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
                , zc_ContainerLinkObject_Unit()       AS DescId
                , tmpDesc.ContainerDescId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId /*UNION SELECT zc_Container_Summ() AS ContainerDescId*/) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
           WHERE inUnitGroupId <> 0 AND COALESCE (inLocationId, 0) = 0

          UNION
           SELECT Object.Id AS LocationId
                , CASE WHEN Object.DescId = zc_Object_Unit()   THEN zc_ContainerLinkObject_Unit() 
                       WHEN Object.DescId = zc_Object_Car()    THEN zc_ContainerLinkObject_Car() 
                       WHEN Object.DescId = zc_Object_Member() THEN zc_ContainerLinkObject_Member()
                  END AS DescId
                , tmpDesc.ContainerDescId
           FROM Object
                -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
           WHERE Object.Id    = inLocationId
             AND inLocationId > 0
          UNION
           SELECT Object.Id AS LocationId
                , zc_ContainerLinkObject_Unit() AS DescId
                , tmpDesc.ContainerDescId
           FROM Object
                -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
           WHERE Object.DescId = zc_Object_Unit()
             AND COALESCE (inUnitGroupId, 0) = 0 AND COALESCE (inLocationId, 0) = 0
             AND (inGoodsGroupId <> 0 OR inGoodsId <> 0)
             AND inIsAllMO = FALSE AND inIsAllAuto = FALSE

             /*UNION
               SELECT lfSelect.UnitId               AS LocationId
                    , zc_ContainerLinkObject_Unit() AS DescId
                    , tmpDesc.ContainerDescId
               FROM lfSelect_Object_Unit_byGroup (inLocationId) AS lfSelect
                    -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!временно без с/с, для скорости!!!
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
               WHERE inLocationId > 0*/

        /*ELSE
              SELECT tmp.LocationId, tmp.DescId, tmpDesc.ContainerDescId
              FROM
               -- Склад специй и запчастей
              (SELECT lfSelect.UnitId AS LocationId, zc_ContainerLinkObject_Unit() AS DescId FROM lfSelect_Object_Unit_byGroup (8454) AS lfSelect WHERE inAccountGroupId = 0 AND inGoodsGroupId = 1941 -- СД-ОБЩАЯ
              UNION ALL
               SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Member() AS DescId  FROM Object WHERE Object.DescId = zc_Object_Member() AND inAccountGroupId = 0 AND inGoodsGroupId = 1941 -- СД-ОБЩАЯ
              UNION ALL
               SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Car() AS DescId  FROM Object WHERE Object.DescId = zc_Object_Car() AND inAccountGroupId = 0 AND inGoodsGroupId = 1941 -- СД-ОБЩАЯ
              ) AS tmp
              LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1
              WHERE COALESCE (inUnitGroupId, 0) = 0 AND COALESCE (inLocationId, 0) = 0
             ;*/

    -- добавили
    UNION -- INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
       SELECT Object.Id
            , tmpCLODesc.DescId
            , tmpDesc.ContainerDescId
       FROM Object
            LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId) AS tmpDesc ON 1 = 1
            LEFT JOIN (SELECT zc_ContainerLinkObject_Car() AS DescId UNION SELECT zc_ContainerLinkObject_Member() AS DescId) AS tmpCLODesc ON 1 = 1
       WHERE Object.DescId IN (zc_Object_Member(), zc_Object_Car())
         AND vbIsSummIn  = TRUE
         AND (inIsAllMO  = TRUE
           OR inIsAllAuto = TRUE)
    )

    -- !!!!!!!!!!!!!!!!!!!!!!!
    -- ANALYZE _tmpLocation;


    -- группа товаров или товар или все товары из проводок
     , tmpObjectGoods AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                          WHERE inGoodsGroupId > 0
                          )
     , tmpGoods AS (SELECT tmpObjectGoods.GoodsId FROM tmpObjectGoods
                   UNION ALL
                    SELECT DISTINCT ObjectLink.ChildObjectId FROM ObjectLink INNER JOIN tmpObjectGoods ON tmpObjectGoods.GoodsId = ObjectLink.ObjectId WHERE ObjectLink.DescId = zc_ObjectLink_Goods_Fuel() AND ObjectLink.ChildObjectId > 0
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
     , tmpContainer AS (SELECT CLO_Goods.ContainerId FROM ContainerLinkObject AS CLO_Goods WHERE CLO_Goods.ObjectId = inGoodsId AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                         UNION
                           SELECT Container.Id FROM Container WHERE Container.ObjectId = inGoodsId AND Container.DescId = zc_Container_Count()
                          )
     , _tmpListContainer_all AS -- (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
          (SELECT _tmpLocation.LocationId
                , _tmpLocation.ContainerDescId
                , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                            THEN ContainerLinkObject.ContainerId
                       ELSE COALESCE (Container.ParentId, 0)
                  END AS ContainerId_count
                , ContainerLinkObject.ContainerId AS ContainerId_begin
                , tmpGoods.GoodsId
                , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                            THEN COALESCE (CLO_Account.ObjectId, 0)
                       ELSE COALESCE (Container.ObjectId, 0)
                  END AS AccountId
                , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                            THEN zc_Enum_AccountGroup_110000() -- Транзит
                       ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                  END AS AccountGroupId
                , Container.Amount
           FROM _tmpLocation
                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                              AND ContainerLinkObject.DescId   = _tmpLocation.DescId
                LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                          AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                          AND _tmpLocation.ContainerDescId = zc_Container_Summ()
                LEFT JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                   AND Container.DescId = _tmpLocation.ContainerDescId
                INNER JOIN tmpGoods ON tmpGoods.GoodsId = CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count() THEN Container.ObjectId ELSE CLO_Goods.ObjectId END
                LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                            AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                            AND _tmpLocation.ContainerDescId = zc_Container_Count()
           WHERE ((_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountId > 0)
              OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                        OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                         ))
                 )
             AND inGoodsGroupId > 0 AND COALESCE (inGoodsId, 0) = 0


             -- INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
              UNION ALL
                SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN tmpContainer.ContainerId
                            ELSE COALESCE (Container.ParentId, 0)
                       END AS ContainerId_count
                     , tmpContainer.ContainerId AS ContainerId_begin
                     , inGoodsId AS GoodsId
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN COALESCE (CLO_Account.ObjectId, 0)
                            ELSE COALESCE (Container.ObjectId, 0)
                       END AS AccountId
                     , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN zc_Enum_AccountGroup_110000() -- Транзит
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId
                     , Container.Amount
                FROM tmpContainer
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = tmpContainer.ContainerId
                     INNER JOIN _tmpLocation ON _tmpLocation.LocationId = ContainerLinkObject.ObjectId
                                            AND _tmpLocation.DescId = ContainerLinkObject.DescId
                     INNER JOIN Container ON Container.Id = tmpContainer.ContainerId
                                         AND Container.DescId = _tmpLocation.ContainerDescId
                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                                 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                WHERE ((_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountId > 0)
                   OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                             OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                              ))
                     )
                AND inGoodsId > 0

               UNION ALL
                SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN ContainerLinkObject.ContainerId
                            ELSE COALESCE (Container.ParentId, 0)
                       END AS ContainerId_count
                     , ContainerLinkObject.ContainerId AS ContainerId_begin
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count() THEN COALESCE (Container.ObjectId, 0) ELSE COALESCE (CLO_Goods.ObjectId, 0) END AS GoodsId
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN COALESCE (CLO_Account.ObjectId, 0)
                            ELSE COALESCE (Container.ObjectId, 0)
                       END AS AccountId
                     , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN zc_Enum_AccountGroup_110000() -- Транзит
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId
                     , Container.Amount
                FROM _tmpLocation
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                   AND ContainerLinkObject.DescId = _tmpLocation.DescId
                     INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                         AND Container.DescId = _tmpLocation.ContainerDescId
                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                     LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                               AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                               AND _tmpLocation.ContainerDescId = zc_Container_Summ()
                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                                 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                WHERE ((_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountId > 0)
                   OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                             OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                              ))
                     )
                AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
               )

    -- !!!!!!!!!!!!!!!!!!!!!!!
    -- ANALYZE _tmpListContainer;
    -- !!!!!!!!!!!!!!!!!!!!!!!

    -- пытаемся найти <Счет> для zc_Container_Count
    -- UPDATE _tmpListContainer SET AccountId = _tmpListContainer_summ.AccountId
    --                            , AccountGroupId = _tmpListContainer_summ.AccountGroupId
     , tmpAccount_new AS
                   (SELECT  _tmpListContainer.ContainerId_count
                          , _tmpListContainer_summ.AccountId
                          , _tmpListContainer_summ.AccountGroupId
                            --  № п/п
                          , ROW_NUMBER() OVER (PARTITION BY _tmpListContainer.ContainerId_count ORDER BY _tmpListContainer_summ.AccountId ASC) AS Ord
                    FROM _tmpListContainer_all AS _tmpListContainer
                         INNER JOIN _tmpListContainer_all AS _tmpListContainer_summ
                                                          ON _tmpListContainer_summ.ContainerId_count = _tmpListContainer.ContainerId_count
                                                         AND _tmpListContainer_summ.ContainerDescId   = zc_Container_Summ()
                                                         AND _tmpListContainer_summ.AccountGroupId    <> zc_Enum_AccountGroup_110000() -- Транзит
                    WHERE _tmpListContainer.ContainerDescId = zc_Container_Count()
                      AND _tmpListContainer.AccountId = 0
                   )

     , _tmpListContainer AS --
       (SELECT _tmpListContainer.LocationId
             , _tmpListContainer.ContainerDescId
             , _tmpListContainer.ContainerId_count
             , _tmpListContainer.ContainerId_begin
             , _tmpListContainer.GoodsId
             , CASE WHEN _tmpListContainer.AccountId      > 0 THEN _tmpListContainer.AccountId      ELSE COALESCE (tmpAccount_new.AccountId, 0)      END AS AccountId
             , CASE WHEN _tmpListContainer.AccountGroupId > 0 THEN _tmpListContainer.AccountGroupId ELSE COALESCE (tmpAccount_new.AccountGroupId, 0) END AS AccountGroupId
             , _tmpListContainer.Amount
        FROM _tmpListContainer_all AS _tmpListContainer
             LEFT JOIN tmpAccount_new ON tmpAccount_new.ContainerId_count = _tmpListContainer.ContainerId_count
                                     AND tmpAccount_new.Ord = 1
       )

    -- все ContainerId
     , _tmpContainer AS --  (ContainerDescId, ContainerId_count, ContainerId_begin, LocationId, GoodsId, GoodsKindId, PartionGoodsId, AssetToId, AccountId, AccountGroupId, Amount)
      (SELECT _tmpListContainer.ContainerDescId
            , _tmpListContainer.ContainerId_count
            , _tmpListContainer.ContainerId_begin
            , _tmpListContainer.LocationId
            , _tmpListContainer.GoodsId
            , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
            , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
            , COALESCE (CLO_AssetTo.ObjectId, 0) AS AssetToId
            , _tmpListContainer.AccountId
            , _tmpListContainer.AccountGroupId
            , _tmpListContainer.Amount
       FROM _tmpListContainer
            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpListContainer.ContainerId_begin
                                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpListContainer.ContainerId_begin
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
            LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = _tmpListContainer.ContainerId_begin
                                                        AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
       )


       -- Результат
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectString_BarCode.ValueData       AS BarCode
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           -- AND Object_GoodsPropertyValue.ValueData <> ''
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
       )

     , tmpPriceList_Basis AS (SELECT ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                                   , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                                   , ObjectHistory_PriceListItem.StartDate
                                   , ObjectHistory_PriceListItem.EndDate
                                   , (ObjectHistoryFloat_PriceListItem_Value.ValueData * 1.2) :: TFloat AS ValuePrice

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

     , tmpMIContainer AS (-- Остатки + Движение товара :  zc_Container_Count and zc_Container_Summ
                          SELECT _tmpContainer.ContainerDescId
                               , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END AS ContainerId_count
                               , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END AS ContainerId_begin
                               , _tmpContainer.LocationId
                               , _tmpContainer.GoodsId
                               , _tmpContainer.GoodsKindId
                               , _tmpContainer.PartionGoodsId
                               , _tmpContainer.AssetToId
                               , _tmpContainer.AccountId
                               , _tmpContainer.AccountGroupId

                               , _tmpContainer.Amount AS AmountReal

                               , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                               , _tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS RemainsEnd

                               , SUM (CASE WHEN /*MIContainer.isActive = TRUE*/  MIContainer.Amount > 0 AND MIContainer.OperDate <= inEndDate AND MIContainer.MovementDescId <> zc_Movement_Inventory() THEN      MIContainer.Amount ELSE 0 END) AS AmountIn
                               , SUM (CASE WHEN /*MIContainer.isActive = FALSE*/ MIContainer.Amount < 0 AND MIContainer.OperDate <= inEndDate AND MIContainer.MovementDescId <> zc_Movement_Inventory() THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountOut

                               , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() AND MIContainer.OperDate <= inEndDate  AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() THEN MIContainer.Amount ELSE 0 END) AS AmountInventory
                               , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() AND MIContainer.OperDate <= inEndDate  AND MIContainer.AnalyzerId               =  zc_Enum_AccountGroup_60000() THEN MIContainer.Amount ELSE 0 END) AS AmountInventory_RePrice -- Переоценка, т.е. AnalyzerId = Прибыль будущих периодов 
                               , SUM (COALESCE (tmpPriceList_Basis_kind.ValuePrice, tmpPriceList_Basis.ValuePrice) * 
                                      CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() AND _tmpContainer.ContainerDescId = zc_Container_Count() 
                                            AND MIContainer.OperDate <= inEndDate  AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() THEN MIContainer.Amount ELSE 0 END ) AS SummInventory_Basis
                               , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Loss()      AND MIContainer.OperDate <= inEndDate  THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountLoss


                          FROM _tmpContainer
                               LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                             AND MIContainer.OperDate >= inStartDate
                               LEFT JOIN tmpPriceList_Basis ON tmpPriceList_Basis.GoodsId = _tmpContainer.GoodsId
                                                           AND tmpPriceList_Basis.GoodsKindId IS NULL
                                                           AND (tmpPriceList_Basis.StartDate <= MIContainer.OperDate AND MIContainer.OperDate < tmpPriceList_Basis.EndDate)
                               LEFT JOIN tmpPriceList_Basis AS tmpPriceList_Basis_kind 
                                                            ON tmpPriceList_Basis_kind.GoodsId = _tmpContainer.GoodsId
                                                           AND COALESCE (tmpPriceList_Basis_kind.GoodsKindId,0) = COALESCE (_tmpContainer.GoodsKindId,0)
                                                           AND (tmpPriceList_Basis_kind.StartDate <= MIContainer.OperDate AND MIContainer.OperDate < tmpPriceList_Basis_kind.EndDate)
                          GROUP BY _tmpContainer.ContainerDescId
                                 , _tmpContainer.ContainerId_count
                                 , _tmpContainer.ContainerId_begin
                                 , _tmpContainer.LocationId
                                 , _tmpContainer.GoodsId
                                 , _tmpContainer.GoodsKindId
                                 , _tmpContainer.PartionGoodsId
                                 , _tmpContainer.AssetToId
                                 , _tmpContainer.AccountId
                                 , _tmpContainer.AccountGroupId
                                 , _tmpContainer.Amount
                          HAVING _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                              OR _tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) <> 0
                              OR SUM (CASE WHEN MIContainer.Amount > 0 AND MIContainer.OperDate <= inEndDate THEN MIContainer.Amount ELSE 0 END) <> 0
                              OR SUM (CASE WHEN MIContainer.Amount < 0 AND MIContainer.OperDate <= inEndDate THEN -1 * MIContainer.Amount ELSE 0 END) <> 0
                              -- **** OR _tmpContainer.Amount <> 0
                         )

     , tmpMIContainer_all AS (-- Остатки + Движение товара, т.е. собираются в 1 строку zc_Container_Count and zc_Container_Summ
                              SELECT  tmpMIContainer.LocationId
                                    , tmpMIContainer.GoodsId
                                    , tmpMIContainer.GoodsKindId
                                    , tmpMIContainer.PartionGoodsId
     
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.AmountLoss ELSE 0 END) AS CountLoss
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Summ()  THEN tmpMIContainer.AmountLoss ELSE 0 END) AS SummLoss
     
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.AmountInventory ELSE 0 END) AS CountInventory
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Summ()  THEN tmpMIContainer.AmountInventory ELSE 0 END) AS SummInventory
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Summ()  THEN tmpMIContainer.AmountInventory_RePrice ELSE 0 END) AS SummInventory_RePrice
                                    , SUM (tmpMIContainer.SummInventory_Basis)                                                                                     AS SummInventory_Basis
     
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.AmountIn ELSE 0 END) AS CountIn
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Summ()  THEN tmpMIContainer.AmountIn ELSE 0 END) AS SummIn
     
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.AmountOut   ELSE 0 END) AS CountOut
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Summ()  THEN tmpMIContainer.AmountOut   ELSE 0 END) AS SummOut
     
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.AmountReal ELSE 0 END) AS CountReal
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Summ()  THEN tmpMIContainer.AmountReal ELSE 0 END) AS SummReal
     
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.RemainsStart ELSE 0 END) AS CountStart
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Summ()  THEN tmpMIContainer.RemainsStart ELSE 0 END) AS SummStart
     
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.RemainsEnd   ELSE 0 END) AS CountEnd
                                    , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Summ()  THEN tmpMIContainer.RemainsEnd   ELSE 0 END) AS SummEnd
                               FROM tmpMIContainer
                               GROUP BY tmpMIContainer.LocationId
                                      , tmpMIContainer.GoodsId
                                      , tmpMIContainer.GoodsKindId
                                      , tmpMIContainer.PartionGoodsId
                               )

     , tmpUnitBaza AS (-- Подразделения для расчета "нормы" !!!временно!!!
                        SELECT Object.Id AS UnitId
                        FROM Object
                        WHERE (Object.Id = 8458    AND inLocationId <> 981821) -- Склад База ГП     + ЦЕХ шприц. мясо
                           OR (Object.Id = 951601  AND inLocationId =  981821) -- ЦЕХ упаковки мясо + ЦЕХ шприц. мясо
                           OR (Object.Id = 8020714 AND inLocationId <> 981821) -- 
                           OR (Object.Id = 8020711 AND inLocationId <> 981821) -- 
                      )
     , tmpPriceStart AS (-- Цены Прайс начальные !!!временно * 1.2!!!
                        SELECT lfObjectHistory_PriceListItem.GoodsId
                             , lfObjectHistory_PriceListItem.GoodsKindId 
                             , (lfObjectHistory_PriceListItem.ValuePrice * 1.2) :: TFloat AS Price
                        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inStartDate) AS lfObjectHistory_PriceListItem
                        WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                     )
     , tmpPriceEnd AS (-- Цены Прайс конечные !!!временно * 1.2!!!
                      SELECT lfObjectHistory_PriceListItem.GoodsId
                           , lfObjectHistory_PriceListItem.GoodsKindId
                           , (lfObjectHistory_PriceListItem.ValuePrice * 1.2) :: TFloat AS Price
                      FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inEndDate + INTERVAL '1 DAY') AS lfObjectHistory_PriceListItem
                      WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                     ) 

     , tmpMovement_all AS (-- Не проведенное движение по zc_Movement_ProductionSeparate
                           SELECT MovementLinkObject_Unit.ObjectId                     AS LocationId
                                , MovementItem.ObjectId                                AS GoodsId
                                , COALESCE (MovementString_PartionGoods.ValueData, '') AS PartionGoodsName
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)        AS GoodsKindId
                                , SUM (CASE WHEN MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()   AND MovementItem.DescId = zc_MI_Child()  THEN MovementItem.Amount Else 0 END) AS CountIn_calc
                                , SUM (CASE WHEN MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From() AND MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount Else 0 END) AS CountOut_calc
                           FROM Movement 
                                LEFT JOIN MovementString AS MovementString_PartionGoods
                                                         ON MovementString_PartionGoods.MovementId =  Movement.Id
                                                        AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.isErased = FALSE
                                                  
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                             AND Movement.DescId   = zc_Movement_ProductionSeparate()
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                             AND MovementLinkObject_Unit.ObjectId IN (SELECT _tmpLocation.LocationId FROM _tmpLocation)

                           GROUP BY MovementLinkObject_Unit.ObjectId
                                  , MovementItem.ObjectId
                                  , COALESCE (MovementString_PartionGoods.ValueData, '')
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          )

     , tmpContainer_Count AS (-- Партиии для получения документов zc_Movement_ProductionUnion (по ним нужны будут приходы и расходы)
                              SELECT _tmpContainer.LocationId
                                   , _tmpContainer.ContainerId_begin
                                   , _tmpContainer.GoodsId
                                   , _tmpContainer.GoodsKindId
                                   , CLO_PartionGoods.ObjectId AS PartionGoodsId
                              FROM _tmpContainer
                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                  ON CLO_PartionGoods.ContainerId = _tmpContainer.ContainerId_begin
                                                                 AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                   INNER JOIN ObjectDate AS ObjectDate_PartionGoods_Value ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                                         AND ObjectDate_PartionGoods_Value.ValueData > inStartDate - INTERVAL '100 DAY'  -- zc_DateStart()
                                                                                         AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                                   LEFT JOIN ObjectLink AS ObjectLink_PartionGoods_Unit
                                                        ON ObjectLink_PartionGoods_Unit.ObjectId = CLO_PartionGoods.ObjectId
                                                       AND ObjectLink_PartionGoods_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                              WHERE _tmpContainer.ContainerDescId = zc_Container_Count()
                                AND ObjectLink_PartionGoods_Unit.ObjectId IS NULL -- т.е. вообще нет этого св-ва
                                AND inStartDate >= DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '4 MONTH'
                              GROUP BY _tmpContainer.LocationId
                                     , _tmpContainer.ContainerId_begin
                                     , _tmpContainer.GoodsId
                                     , _tmpContainer.GoodsKindId
                                     , CLO_PartionGoods.ObjectId
                             )
     , tmpMIContainer_Count_all AS (-- Получить расход ПФ(ГП) за период + расходы партий на производство (за весь период) + кол-во в приходе (за весь период)
                                    SELECT tmpContainer_Count.LocationId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.PartionGoodsId
                                         , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN MIContainer.MovementItemId ELSE NULL END AS MovementItemId
                                         , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN MIContainer.MovementId     ELSE NULL END AS MovementId
                                         , -1 * SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE AND tmpUnitBaza.UnitId > 0 /*MIContainer.WhereObjectId_Analyzer <> MIContainer.ObjectExtId_Analyzer*/ THEN MIContainer.Amount ELSE 0 END) AS CountOut_byPF
        
                                         , -1 * SUM (CASE WHEN MIContainer.isActive = FALSE THEN MIContainer.Amount                    ELSE 0 END) AS CountOut_byCount
                                         ,      SUM (CASE WHEN MIContainer.isActive = FALSE THEN COALESCE (MIFloat_Count.ValueData, 0) ELSE 0 END) AS Count_onCount

                                        -- ,      SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN COALESCE (MIFloat_Count.ValueData, 0) ELSE 0 END)AS Count_onCount_out
                                        -- ,      SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE THEN COALESCE (MIFloat_Count.ValueData, 0) ELSE 0 END) AS Count_onCount_in
                                                                                          
                                         ,      SUM (CASE WHEN MIContainer.isActive = TRUE THEN MIContainer.Amount                         ELSE 0 END) AS CountIn_byPF
                                         ,      SUM (CASE WHEN MIContainer.isActive = TRUE THEN COALESCE (MIFloat_CuterCount.ValueData, 0) ELSE 0 END) AS CuterCount
                                    FROM tmpContainer_Count
                                         INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId    = tmpContainer_Count.ContainerId_begin
                                                                                        -- AND MIContainer.isActive       = FALSE
                                                                                        AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                         LEFT JOIN tmpUnitBaza ON tmpUnitBaza.UnitId = MIContainer.ObjectExtId_Analyzer
                                         LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                                     ON MIFloat_Count.MovementItemId = MIContainer.MovementItemId
                                                                    AND MIFloat_Count.DescId         = zc_MIFloat_Count()
                                                                    --AND MIContainer.isActive         = FALSE
                                         LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                                     ON MIFloat_CuterCount.MovementItemId = MIContainer.MovementItemId
                                                                    AND MIFloat_CuterCount.DescId         = zc_MIFloat_CuterCount()
                                                                    AND MIContainer.isActive              = TRUE
                                    GROUP BY tmpContainer_Count.LocationId
                                           , tmpContainer_Count.GoodsId
                                           , tmpContainer_Count.GoodsKindId
                                           , tmpContainer_Count.PartionGoodsId
                                           , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN MIContainer.MovementItemId ELSE NULL END
                                           , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = FALSE THEN MIContainer.MovementId     ELSE NULL END
                                   )
                                   
     , tmpContainer_CountCount AS (SELECT tmp.LocationId
                                        , tmp.GoodsId
                                        , tmp.GoodsKindId
                                        , tmp.PartionGoodsId
                                        , SUM (tmp.AmountStart) AS AmountStart_byCount
                                        , SUM (tmp.AmountEnd)   AS AmountEnd_byCount 
                                        , SUM (tmp.AmountIn)    AS AmountIn_byCount
                                        , SUM (tmp.AmountOut)   AS AmountOut_byCount
                                        , SUM (tmp.AmountInventory) AS AmountInventory_byCount
                                   FROM (SELECT tmpContainer_Count.LocationId
                                              , tmpContainer_Count.GoodsId
                                              , tmpContainer_Count.GoodsKindId
                                              , tmpContainer_Count.PartionGoodsId
                                              , Container.Amount - SUM ( COALESCE (MIContainer.Amount,0))                                                                               AS AmountStart
                                              , Container.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END)                                  AS AmountEnd
                                              , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId <> zc_Movement_Inventory() THEN COALESCE (MIContainer.Amount,0) ELSE 0 END)       AS AmountIn
                                              , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.isActive = FALSE AND MIContainer.MovementDescId <> zc_Movement_Inventory() THEN -1 * COALESCE (MIContainer.Amount,0) ELSE 0 END) AS AmountOut
                                         
                                              , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Inventory() AND MIContainer.OperDate <= inEndDate THEN MIContainer.Amount ELSE 0 END) AS AmountInventory

                                         FROM tmpContainer_Count
                                               INNER JOIN Container ON Container.ParentId = tmpContainer_Count.ContainerId_begin
                                                                   AND Container.DescId = zc_Container_CountCount()
                                               LEFT JOIN MovementItemContainer AS MIContainer 
                                                                               ON MIContainer.ContainerId = Container.Id
                                                                              AND MIContainer.DescId = zc_MIContainer_CountCount()
                                                                              AND MIContainer.OperDate >= inStartDate
                                         GROUP BY tmpContainer_Count.LocationId
                                                , tmpContainer_Count.GoodsId
                                                , tmpContainer_Count.GoodsKindId
                                                , tmpContainer_Count.PartionGoodsId
                                                , Container.Amount
                                         ) AS tmp
                                   GROUP BY tmp.LocationId
                                          , tmp.GoodsId
                                          , tmp.GoodsKindId
                                          , tmp.PartionGoodsId
                                   )

     , tmpMIContainer_GP_all AS (-- Приход с производства ГП
                                 SELECT tmpMIContainer_Count_all.LocationId
                                      , tmpMIContainer_Count_all.GoodsId
                                      , tmpMIContainer_Count_all.GoodsKindId
                                      , tmpMIContainer_Count_all.PartionGoodsId
                                      , MIContainer.ContainerId
                                      , MIContainer.ObjectId_Analyzer  AS GoodsId_gp
                                      , SUM (MIContainer.Amount)       AS CountIn
                                 FROM tmpMIContainer_Count_all
                                       INNER JOIN MovementItem ON MovementItem.Id = tmpMIContainer_Count_all.MovementItemId
                                                              AND MovementItem.Amount <> 0
                                       INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.MovementId     = tmpMIContainer_Count_all.MovementId
                                                                                      AND MIContainer.MovementItemId = MovementItem.ParentId
                                                                                      AND MIContainer.DescId       = zc_MIContainer_Count()
                                                                                      AND MIContainer.ObjectIntId_Analyzer <> zc_GoodsKind_WorkProgress() -- !!!захардкодил, т.е. нужны только если расход на ГП!!!
                                 GROUP BY tmpMIContainer_Count_all.LocationId
                                        , tmpMIContainer_Count_all.GoodsId
                                        , tmpMIContainer_Count_all.GoodsKindId
                                        , tmpMIContainer_Count_all.PartionGoodsId
                                        , MIContainer.ContainerId
                                        , MIContainer.ObjectId_Analyzer
                                )
     , tmpMIContainer_GP AS (-- Приход с производства ГП + нашли GoodsKindId_gp
                             SELECT tmpMIContainer_GP_all.LocationId
                                  , tmpMIContainer_GP_all.GoodsId
                                  , tmpMIContainer_GP_all.GoodsKindId
                                  , tmpMIContainer_GP_all.PartionGoodsId
                                  , tmpMIContainer_GP_all.GoodsId_gp
                                  , CLO_GoodsKind.ObjectId AS GoodsKindId_gp
                                  , tmpMIContainer_GP_all.CountIn
                             FROM tmpMIContainer_GP_all
                                  LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                ON CLO_GoodsKind.ContainerId = tmpMIContainer_GP_all.ContainerId
                                                               AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                            )
     , tmpMIContainer_Count AS (-- Расчет расход ПФ(ГП) за период + расходы батонов на производство (за весь период) + кол-во в приходе (за весь период)
                                SELECT tmpMIContainer_Count_all.LocationId
                                     , tmpMIContainer_Count_all.GoodsId
                                     , tmpMIContainer_Count_all.GoodsKindId
                                     , tmpMIContainer_Count_all.PartionGoodsId
                                     , SUM (tmpMIContainer_Count_all.CountOut_byPF)    AS CountOut_byPF
                                     , SUM (tmpMIContainer_Count_all.CountOut_byCount) AS CountOut_byCount
                                     , SUM (tmpMIContainer_Count_all.Count_onCount)    AS CountOut_onCount
                                     --, SUM (tmpMIContainer_Count_all.Count_onCount_in) AS Count_onCount_in
                                     --, SUM (tmpMIContainer_Count_all.Count_onCount_out) AS Count_onCount_out
                                     , SUM (tmpMIContainer_Count_all.CountIn_byPF)     AS CountIn_byPF
                                     , SUM (tmpMIContainer_Count_all.CuterCount)       AS CuterCount
                                FROM tmpMIContainer_Count_all
                                GROUP BY tmpMIContainer_Count_all.LocationId
                                       , tmpMIContainer_Count_all.GoodsId
                                       , tmpMIContainer_Count_all.GoodsKindId
                                       , tmpMIContainer_Count_all.PartionGoodsId
                                )
     , tmpNorm_GP AS (-- Нормы ГП
                      SELECT tmp.GoodsId AS GoodsId_gp, tmp.GoodsKindId AS GoodsKindId_gp, MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                      FROM (SELECT tmpMIContainer_GP.GoodsId_gp AS GoodsId, tmpMIContainer_GP.GoodsKindId_gp AS GoodsKindId
                            FROM tmpMIContainer_GP
                            GROUP BY tmpMIContainer_GP.GoodsId_gp, tmpMIContainer_GP.GoodsKindId_gp
                           ) AS tmp
                           INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                 ON ObjectLink_Receipt_Goods.ChildObjectId = tmp.GoodsId
                                                AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                           INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                 ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmp.GoodsKindId
                           INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                              AND Object_Receipt.isErased = FALSE
                           INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                    ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                   AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                   AND ObjectBoolean_Main.ValueData = TRUE
                      GROUP BY tmp.GoodsId, tmp.GoodsKindId
                     )

         , tmpResult AS (-- ВСЕ данные, т.е. собираются в 1 строку
                         SELECT tmpAll.LocationId
                              , tmpAll.GoodsId
                              , tmpAll.GoodsKindId
                              , tmpAll.GoodsKindId_complete
                              , CASE WHEN inisPartionCell = TRUE THEN Object_PartionCell.Id ELSE 0 END AS PartionCellId
                              , CASE WHEN inisPartionCell = TRUE THEN Object_PartionCell.ObjectCode ELSE 0 END AS PartionCellCode 
                              , STRING_AGG (DISTINCT COALESCE (Object_PartionCell.ValueData, ''), ';') ::TVarChar AS PartionCellName

                                -- для РК
                              , CASE WHEN inIsOperDate_Partion = FALSE AND tmpAll.LocationId = zc_Unit_RK() 
                                          THEN ''
                                     ELSE tmpAll.PartionGoodsName
                                END AS PartionGoodsName

                              --, tmpAll.PartionGoodsDate
                              , CASE WHEN inIsOperDate_Partion = TRUE THEN tmpAll.PartionGoodsDate ELSE NULL END ::TDateTime AS PartionGoodsDate

                               --cвойства из партий
                              , tmpAll.StorageId
                              , tmpAll.StorageName
                              , tmpAll.PartionModelId
                              , tmpAll.PartionModelName
                              , tmpAll.UnitId
                              , tmpAll.UnitName
                              , tmpAll.PartNumber

                              , SUM (tmpAll.CountIn_byPF)     AS CountIn_byPF
                              , SUM (tmpAll.CuterCount)       AS CuterCount
                              , SUM (tmpAll.CountOut_byPF)    AS CountOut_byPF
                              , SUM (tmpAll.CountOut_byCount) AS CountOut_byCount
                              , SUM (tmpAll.CountOut_onCount) AS CountOut_onCount
                              , SUM (tmpAll.Count_onCount_in)  AS Count_onCount_in
                              , SUM (tmpAll.Count_onCount_out) AS Count_onCount_out
                              , SUM (tmpAll.CountStart_byCount) AS CountStart_byCount
                              , SUM (tmpAll.CountEnd_byCount)   AS CountEnd_byCount
                              , SUM (tmpAll.CountInventory_byCount) AS CountInventory_byCount

                              , SUM (tmpAll.CountIn_calc)  AS CountIn_calc
                              , SUM (tmpAll.CountOut_calc) AS CountOut_calc

                              , SUM (tmpAll.CountIn)  AS CountIn
                              , SUM (tmpAll.SummIn)   AS SummIn
                              , SUM (tmpAll.CountOut) AS CountOut
                              , SUM (tmpAll.SummOut)  AS SummOut

                              , SUM (tmpAll.CountLoss) AS CountLoss
                              , SUM (tmpAll.SummLoss)  AS SummLoss
                              , SUM (tmpAll.CountInventory) AS CountInventory
                              , SUM (tmpAll.SummInventory)  AS SummInventory
                              , SUM (tmpAll.SummInventory_RePrice) AS SummInventory_RePrice
                              , SUM (tmpAll.SummInventory_Basis)   AS SummInventory_Basis

                              , SUM (tmpAll.CountIn_Weight_gp) AS CountIn_Weight_gp
                              , SUM (tmpAll.CountOut_norm_pf)  AS CountOut_norm_pf
                              , SUM (tmpAll.SummIn_gp)         AS SummIn_gp

                              , SUM (tmpAll.CountReal) AS CountReal
                              , SUM (tmpAll.SummReal)  AS SummReal

                              , SUM (tmpAll.CountStart) AS CountStart
                              , SUM (tmpAll.CountEnd)   AS CountEnd
     
                              , SUM (tmpAll.SummStart) AS SummStart
                              , SUM (tmpAll.SummEnd)   AS SummEnd

                              , SUM (tmpAll.CountStart + tmpAll.CountInventory + tmpAll.CountIn + tmpAll.CountIn_calc - tmpAll.CountOut - tmpAll.CountOut_calc) AS CountEnd_calc

                         FROM (-- Не проведенное движение по zc_Movement_ProductionSeparate
                               SELECT tmpMovement_all.LocationId
                                    , tmpMovement_all.GoodsId
                                    , tmpMovement_all.GoodsKindId
                                    , 0 AS GoodsKindId_complete
                                    , 0 AS PartionCellId
                                    , CASE WHEN ObjectBoolean_PartionCount.ValueData = TRUE THEN zfFormat_PartionGoods (tmpMovement_all.PartionGoodsName) ELSE '' END AS PartionGoodsName
                                    , zc_DateStart() AS PartionGoodsDate

                                    , (tmpMovement_all.CountIn_calc)  AS  CountIn_calc
                                    , (tmpMovement_all.CountOut_calc) AS  CountOut_calc

                                    , 0 AS CountIn
                                    , 0 AS SummIn
                                    , 0 AS CountOut
                                    , 0 AS SummOut

                                    , 0 AS CountLoss
                                    , 0 AS SummLoss
                                    , 0 AS CountInventory
                                    , 0 AS SummInventory
                                    , 0 AS SummInventory_RePrice
                                    , 0 AS SummInventory_Basis


                                    , 0 AS CountReal
                                    , 0 AS SummReal
                                    , 0 AS CountStart
                                    , 0 AS CountEnd
                                    , 0 AS SummStart
                                    , 0 AS SummEnd

                                    , 0 AS CountIn_Weight_gp
                                    , 0 AS CountOut_norm_pf
                                    , 0 AS SummIn_gp

                                    , 0 AS CountIn_byPF
                                    , 0 AS CuterCount
                                    , 0 AS CountOut_byPF
                                    , 0 AS CountOut_byCount
                                    , 0 AS CountOut_onCount
                                    , 0 AS Count_onCount_in
                                    , 0 AS Count_onCount_out
                                    , 0 AS CountStart_byCount
                                    , 0 AS CountEnd_byCount
                                    , 0 AS CountInventory_byCount
                                    
                                    --
                                    , 0  AS StorageId
                                    , '' AS StorageName
                                    , 0  AS PartionModelId
                                    , '' AS PartionModelName
                                    , 0  AS UnitId
                                    , '' AS UnitName
                                    , '' AS PartNumber
                               FROM tmpMovement_all
                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                                            ON ObjectBoolean_PartionCount.ObjectId = tmpMovement_all.GoodsId
                                                           AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                              UNION ALL
                               -- данные для кол-во в приходе (за весь период) + расход ПФ(ГП) за период + кол-ва батонов (за весь период)
                               SELECT tmpMIContainer_Count.LocationId
                                    , tmpMIContainer_Count.GoodsId
                                    , tmpMIContainer_Count.GoodsKindId
                                    , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)           AS GoodsKindId_complete
                                    , COALESCE (ObjectLink_PartionCell.ChildObjectId, 0)                 AS PartionCellId
                                    , COALESCE (Object_PartionGoods.ValueData, '')                       AS PartionGoodsName
                                    , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateStart()) AS PartionGoodsDate

                                    , 0 AS CountIn_calc
                                    , 0 AS CountOut_calc

                                    , 0 AS CountIn
                                    , 0 AS SummIn
                                    , 0 AS CountOut
                                    , 0 AS SummOut

                                    , 0 AS CountLoss
                                    , 0 AS SummLoss
                                    , 0 AS CountInventory
                                    , 0 AS SummInventory
                                    , 0 AS SummInventory_RePrice
                                    , 0 AS SummInventory_Basis

                                    , 0 AS CountReal
                                    , 0 AS SummReal
                                    , 0 AS CountStart
                                    , 0 AS CountEnd
                                    , 0 AS SummStart
                                    , 0 AS SummEnd

                                    , 0 AS CountIn_Weight_gp
                                    , 0 AS CountOut_norm_pf
                                    , 0 AS SummIn_gp

                                    , tmpMIContainer_Count.CountIn_byPF     AS CountIn_byPF
                                    , tmpMIContainer_Count.CuterCount       AS CuterCount
                                    , tmpMIContainer_Count.CountOut_byPF    AS CountOut_byPF
                                    , tmpMIContainer_Count.CountOut_byCount AS CountOut_byCount
                                    , tmpMIContainer_Count.CountOut_onCount AS CountOut_onCount
                                    , 0  AS Count_onCount_in
                                    , 0  AS Count_onCount_out
                                    , 0 AS CountStart_byCount
                                    , 0 AS CountEnd_byCount
                                    , 0 AS CountInventory_byCount
                                    --
                                    , Object_Storage.Id                 AS StorageId
                                    , Object_Storage.ValueData          AS StorageName
                                    , Object_PartionModel.Id            AS PartionModelId
                                    , Object_PartionModel.ValueData     AS PartionModelName
                                    , Object_Unit.Id                    AS UnitId
                                    , Object_Unit.ValueData             AS UnitName
                                    , ObjectString_PartNumber.ValueData AS PartNumber
                               FROM tmpMIContainer_Count
                                    LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_Count.PartionGoodsId
                                    LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                         ON ObjectDate_PartionGoods_Value.ObjectId = tmpMIContainer_Count.PartionGoodsId
                                                        AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                         ON ObjectLink_GoodsKindComplete.ObjectId = tmpMIContainer_Count.PartionGoodsId
                                                        AND ObjectLink_GoodsKindComplete.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete() 
                                    LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                                         ON ObjectLink_PartionCell.ObjectId = tmpMIContainer_Count.PartionGoodsId
                                                        AND ObjectLink_PartionCell.DescId   = zc_ObjectLink_PartionGoods_PartionCell()
                                    --
                                    LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                         ON ObjectLink_Storage.ObjectId = tmpMIContainer_Count.PartionGoodsId
                                                        AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
                                    LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId                                    

                                    LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                         ON ObjectLink_Unit.ObjectId = tmpMIContainer_Count.PartionGoodsId
                                                        AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                    LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                                    LEFT JOIN ObjectString AS ObjectString_PartNumber
                                                           ON ObjectString_PartNumber.ObjectId = tmpMIContainer_Count.PartionGoodsId                   -- Сер.номер
                                                          AND ObjectString_PartNumber.DescId = zc_ObjectString_PartionGoods_PartNumber()

                                    LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                                         ON ObjectLink_PartionModel.ObjectId = tmpMIContainer_Count.PartionGoodsId		               -- модель
                                                        AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_PartionModel()
                                    LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId

                              UNION ALL
                               -- Остатки + Движение товара
                               SELECT tmpMIContainer_all.LocationId
                                    , tmpMIContainer_all.GoodsId
                                    , tmpMIContainer_all.GoodsKindId
                                    , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)           AS GoodsKindId_complete
                                    , COALESCE (ObjectLink_PartionCell.ChildObjectId, 0)                 AS PartionCellId
                                    , CASE WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0 AND Object_PartionGoods.ObjectCode > 0
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
                                                ELSE COALESCE (Object_PartionGoods.ValueData, '')
                                      END AS PartionGoodsName
                                    , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateStart()) AS PartionGoodsDate

                                    , 0 AS CountIn_calc
                                    , 0 AS CountOut_calc

                                    , tmpMIContainer_all.CountIn
                                    , tmpMIContainer_all.SummIn
                                    , tmpMIContainer_all.CountOut
                                    , tmpMIContainer_all.SummOut

                                    , tmpMIContainer_all.CountLoss
                                    , tmpMIContainer_all.SummLoss
                                    , tmpMIContainer_all.CountInventory
                                    , tmpMIContainer_all.SummInventory
                                    , tmpMIContainer_all.SummInventory_RePrice
                                    , tmpMIContainer_all.SummInventory_Basis

                                    , tmpMIContainer_all.CountReal
                                    , tmpMIContainer_all.SummReal
                                    , tmpMIContainer_all.CountStart
                                    , tmpMIContainer_all.CountEnd

                                    , tmpMIContainer_all.SummStart
                                    , tmpMIContainer_all.SummEnd

                                    , 0 AS CountIn_Weight_gp
                                    , 0 AS CountOut_norm_pf
                                    , 0 AS SummIn_gp

                                    , 0 AS CountIn_byPF
                                    , 0 AS CuterCount
                                    , 0 AS CountOut_byPF
                                    , 0 AS CountOut_byCount
                                    , 0 AS CountOut_onCount
                                    , 0 AS Count_onCount_in
                                    , 0 AS Count_onCount_out
                                    , 0 AS CountStart_byCount
                                    , 0 AS CountEnd_byCount
                                    , 0 AS CountInventory_byCount

                                    --
                                    , Object_Storage.Id                 AS StorageId
                                    , Object_Storage.ValueData          AS StorageName
                                    , Object_PartionModel.Id            AS PartionModelId
                                    , Object_PartionModel.ValueData     AS PartionModelName
                                    , Object_Unit.Id                    AS UnitId
                                    , Object_Unit.ValueData             AS UnitName
                                    , ObjectString_PartNumber.ValueData AS PartNumber
                               FROM tmpMIContainer_all
                                    LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_all.PartionGoodsId
                                    LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                         ON ObjectDate_PartionGoods_Value.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                        AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()

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
                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Price
                                                          ON ObjectFloat_PartionGoods_Price.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_Price.DescId = zc_ObjectFloat_PartionGoods_Price()

                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                         ON ObjectLink_GoodsKindComplete.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                        AND ObjectLink_GoodsKindComplete.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                                    LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                                         ON ObjectLink_PartionCell.ObjectId = tmpMIContainer_all.PartionGoodsId
                                                        AND ObjectLink_PartionCell.DescId   = zc_ObjectLink_PartionGoods_PartionCell()

                                    LEFT JOIN ObjectString AS ObjectString_PartNumber
                                                           ON ObjectString_PartNumber.ObjectId = tmpMIContainer_all.PartionGoodsId                    -- Сер.номер
                                                          AND ObjectString_PartNumber.DescId = zc_ObjectString_PartionGoods_PartNumber()

                                    LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                                         ON ObjectLink_PartionModel.ObjectId = tmpMIContainer_all.PartionGoodsId		               -- модель
                                                        AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_PartionModel()
                                    LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId
                              UNION ALL
                               -- Приход с производства ГП
                               SELECT tmpMIContainer_GP.LocationId
                                    , tmpMIContainer_GP.GoodsId
                                    , tmpMIContainer_GP.GoodsKindId
                                    , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)           AS GoodsKindId_complete
                                    , COALESCE (ObjectLink_PartionCell.ChildObjectId, 0)                 AS PartionCellId
                                    , COALESCE (Object_PartionGoods.ValueData, '')                       AS PartionGoodsName
                                    , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateStart()) AS PartionGoodsDate

                                    , 0 AS CountIn_calc
                                    , 0 AS CountOut_calc

                                    , 0 AS CountIn
                                    , 0 AS SummIn
                                    , 0 AS CountOut
                                    , 0 AS SummOut

                                    , 0 AS CountLoss
                                    , 0 AS SummLoss
                                    , 0 AS CountInventory
                                    , 0 AS SummInventory
                                    , 0 AS SummInventory_RePrice
                                    , 0 AS SummInventory_Basis

                                    , 0 AS CountReal
                                    , 0 AS SummReal
                                    , 0 AS CountStart
                                    , 0 AS CountEnd
                                    , 0 AS SummStart
                                    , 0 AS SummEnd

                                    , tmpMIContainer_GP.CountIn * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS CountIn_Weight_gp
                                      -- Расход ПФ(ГП) по норме на пр-во ГП, расчет для CountIn_Weight_gp
                                    , CASE WHEN ObjectFloat_TaxLoss.ValueData <> 100
                                                THEN tmpMIContainer_GP.CountIn / (1 - ObjectFloat_TaxLoss.ValueData / 100)
                                           ELSE 0
                                      END AS CountOut_norm_pf

                                    , 0 AS SummIn_gp

                                    , 0 AS CountIn_byPF
                                    , 0 AS CuterCount
                                    , 0 AS CountOut_byPF
                                    , 0 AS CountOut_byCount
                                    , 0 AS CountOut_onCount
                                    , 0 AS Count_onCount_in
                                    , 0 AS Count_onCount_out
                                    , 0 AS CountStart_byCount
                                    , 0 AS CountEnd_byCount
                                    , 0 AS CountInventory_byCount

                                     --
                                    , Object_Storage.Id                 AS StorageId
                                    , Object_Storage.ValueData          AS StorageName
                                    , Object_PartionModel.Id            AS PartionModelId
                                    , Object_PartionModel.ValueData     AS PartionModelName
                                    , Object_Unit.Id                    AS UnitId
                                    , Object_Unit.ValueData             AS UnitName
                                    , ObjectString_PartNumber.ValueData AS PartNumber
                               FROM tmpMIContainer_GP
                                    LEFT JOIN tmpNorm_GP ON tmpNorm_GP.GoodsId_gp     = tmpMIContainer_GP.GoodsId_gp
                                                        AND tmpNorm_GP.GoodsKindId_gp = tmpMIContainer_GP.GoodsKindId_gp
                                    LEFT JOIN ObjectFloat AS ObjectFloat_TaxLoss
                                                          ON ObjectFloat_TaxLoss.ObjectId = tmpNorm_GP.ReceiptId
                                                         AND ObjectFloat_TaxLoss.DescId = zc_ObjectFloat_Receipt_TaxLoss()
                                    LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMIContainer_GP.GoodsId_gp
                                                                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                          ON ObjectFloat_Weight.ObjectId = tmpMIContainer_GP.GoodsId_gp
                                                         AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                                    LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_GP.PartionGoodsId
                                    LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                         ON ObjectDate_PartionGoods_Value.ObjectId = tmpMIContainer_GP.PartionGoodsId
                                                        AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                         ON ObjectLink_GoodsKindComplete.ObjectId = tmpMIContainer_GP.PartionGoodsId
                                                        AND ObjectLink_GoodsKindComplete.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                                    LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                                         ON ObjectLink_PartionCell.ObjectId = tmpMIContainer_GP.PartionGoodsId
                                                        AND ObjectLink_PartionCell.DescId   = zc_ObjectLink_PartionGoods_PartionCell()

                                    --
                                    LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                         ON ObjectLink_Storage.ObjectId = tmpMIContainer_GP.PartionGoodsId
                                                        AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
                                    LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId                                    

                                    LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                         ON ObjectLink_Unit.ObjectId = tmpMIContainer_GP.PartionGoodsId
                                                        AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                    LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                                    LEFT JOIN ObjectString AS ObjectString_PartNumber
                                                           ON ObjectString_PartNumber.ObjectId = tmpMIContainer_GP.PartionGoodsId                   -- Сер.номер
                                                          AND ObjectString_PartNumber.DescId = zc_ObjectString_PartionGoods_PartNumber()

                                    LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                                         ON ObjectLink_PartionModel.ObjectId = tmpMIContainer_GP.PartionGoodsId		               -- модель
                                                        AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_PartionModel()
                                    LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId

                              UNION ALL
                               -- остатки и движение батонов
                               SELECT tmpContainer_CountCount.LocationId
                                    , tmpContainer_CountCount.GoodsId
                                    , tmpContainer_CountCount.GoodsKindId
                                    , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)           AS GoodsKindId_complete
                                    , COALESCE (ObjectLink_PartionCell.ChildObjectId, 0)                 AS PartionCellId
                                    , COALESCE (Object_PartionGoods.ValueData, '')                       AS PartionGoodsName
                                    , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateStart()) AS PartionGoodsDate

                                    , 0 AS CountIn_calc
                                    , 0 AS CountOut_calc

                                    , 0 AS CountIn
                                    , 0 AS SummIn
                                    , 0 AS CountOut
                                    , 0 AS SummOut

                                    , 0 AS CountLoss
                                    , 0 AS SummLoss
                                    , 0 AS CountInventory
                                    , 0 AS SummInventory
                                    , 0 AS SummInventory_RePrice
                                    , 0 AS SummInventory_Basis

                                    , 0 AS CountReal
                                    , 0 AS SummReal
                                    , 0 AS CountStart
                                    , 0 AS CountEnd
                                    , 0 AS SummStart
                                    , 0 AS SummEnd

                                    , 0 AS CountIn_Weight_gp
                                    , 0 AS CountOut_norm_pf
                                    , 0 AS SummIn_gp

                                    , 0 AS CountIn_byPF
                                    , 0 AS CuterCount
                                    , 0 AS CountOut_byPF
                                    , 0 AS CountOut_byCount
                                    , 0 AS CountOut_onCount
                                    , tmpContainer_CountCount.AmountIn_byCount    AS Count_onCount_in
                                    , tmpContainer_CountCount.AmountOut_byCount   AS Count_onCount_out
                                    , tmpContainer_CountCount.AmountStart_byCount AS CountStart_byCount
                                    , tmpContainer_CountCount.AmountEnd_byCount   AS CountEnd_byCount
                                    , tmpContainer_CountCount.AmountInventory_byCount AS CountInventory_byCount

                                     --
                                    , Object_Storage.Id                 AS StorageId
                                    , Object_Storage.ValueData          AS StorageName
                                    , Object_PartionModel.Id            AS PartionModelId
                                    , Object_PartionModel.ValueData     AS PartionModelName
                                    , Object_Unit.Id                    AS UnitId
                                    , Object_Unit.ValueData             AS UnitName
                                    , ObjectString_PartNumber.ValueData AS PartNumber
                               FROM tmpContainer_CountCount
                                    LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpContainer_CountCount.PartionGoodsId
                                    LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                         ON ObjectDate_PartionGoods_Value.ObjectId = tmpContainer_CountCount.PartionGoodsId
                                                        AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                         ON ObjectLink_GoodsKindComplete.ObjectId = tmpContainer_CountCount.PartionGoodsId
                                                        AND ObjectLink_GoodsKindComplete.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                                    LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                                         ON ObjectLink_PartionCell.ObjectId = tmpContainer_CountCount.PartionGoodsId
                                                        AND ObjectLink_PartionCell.DescId   = zc_ObjectLink_PartionGoods_PartionCell()

                                    --
                                    LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                         ON ObjectLink_Storage.ObjectId = tmpContainer_CountCount.PartionGoodsId
                                                        AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
                                    LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId                                    

                                    LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                         ON ObjectLink_Unit.ObjectId = tmpContainer_CountCount.PartionGoodsId
                                                        AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                    LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                                    LEFT JOIN ObjectString AS ObjectString_PartNumber
                                                           ON ObjectString_PartNumber.ObjectId = tmpContainer_CountCount.PartionGoodsId                   -- Сер.номер
                                                          AND ObjectString_PartNumber.DescId = zc_ObjectString_PartionGoods_PartNumber()

                                    LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                                         ON ObjectLink_PartionModel.ObjectId = tmpContainer_CountCount.PartionGoodsId	               -- модель
                                                        AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_PartionModel()
                                    LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId
                                                        
                              ) AS tmpAll
                             LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = tmpAll.PartionCellId
                        GROUP BY tmpAll.LocationId
                               , tmpAll.GoodsId
                               , tmpAll.GoodsKindId
                               , tmpAll.GoodsKindId_complete
                               --, tmpAll.PartionCellId
                               , CASE WHEN inIsOperDate_Partion = FALSE AND tmpAll.LocationId = zc_Unit_RK() 
                                           THEN ''
                                      ELSE tmpAll.PartionGoodsName
                                 END
                               --, tmpAll.PartionGoodsDate
                               , tmpAll.StorageId
                               , tmpAll.StorageName
                               , tmpAll.PartionModelId
                               , tmpAll.PartionModelName
                               , tmpAll.UnitId
                               , tmpAll.UnitName
                               , tmpAll.PartNumber
                               , CASE WHEN inisPartionCell = TRUE THEN Object_PartionCell.Id ELSE 0 END
                               , CASE WHEN inisPartionCell = TRUE THEN Object_PartionCell.ObjectCode ELSE 0 END
                               , CASE WHEN inIsOperDate_Partion = TRUE THEN tmpAll.PartionGoodsDate ELSE NULL END
                        )
      , tmpNorm_PF AS (-- Нормы ПФ (ГП)
                       SELECT tmp.GoodsId, tmp.GoodsKindId, tmp.GoodsKindId_complete, MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                       FROM (SELECT tmpResult.GoodsId, tmpResult.GoodsKindId, tmpResult.GoodsKindId_complete
                             FROM tmpResult
                             WHERE tmpResult.GoodsKindId = zc_GoodsKind_WorkProgress()
                               -- AND tmpResult.CountOut_byPF <> 0
                             GROUP BY tmpResult.GoodsId, tmpResult.GoodsKindId, tmpResult.GoodsKindId_complete
                            ) AS tmp
                            INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                  ON ObjectLink_Receipt_Goods.ChildObjectId = tmp.GoodsId
                                                 AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                            INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                  ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                 AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                 AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmp.GoodsKindId
                            LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                                                 ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()

                            INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                               AND Object_Receipt.isErased = FALSE
                            INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                     ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                    AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                    AND ObjectBoolean_Main.ValueData = TRUE
                       WHERE COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) = tmp.GoodsKindId_complete
                       GROUP BY tmp.GoodsId, tmp.GoodsKindId, tmp.GoodsKindId_complete
                      )

      , tmpGoods_Term AS (-- TermProduction
                          SELECT tmp.GoodsId, tmp.GoodsKindId, MIN (tmp.TermProduction) AS TermProduction
                          FROM (SELECT tmpNorm_PF.GoodsId, tmpNorm_PF.GoodsKindId, COALESCE (ObjectFloat_TermProduction.ValueData, 0) AS TermProduction
                                FROM tmpNorm_PF
                                     LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                                          ON ObjectLink_OrderType_Goods.ChildObjectId = tmpNorm_PF.GoodsId
                                                         AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                                     LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                                           ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                                          AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction() 
                               UNION
                                SELECT tmpNorm_PF.GoodsId, tmpNorm_PF.GoodsKindId, COALESCE (ObjectFloat_TermProduction.ValueData, 0) AS TermProduction
                                FROM tmpNorm_PF
                                     INNER JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                                           ON ObjectLink_Receipt_Parent.ChildObjectId = tmpNorm_PF.ReceiptId
                                                          AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
                                     INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Parent.ObjectId
                                                                        AND Object_Receipt.isErased = FALSE
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                              ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                             AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                             AND ObjectBoolean_Main.ValueData = TRUE
                                     INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                           ON ObjectLink_Receipt_Goods.ObjectId = ObjectLink_Receipt_Parent.ObjectId
                                                          AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                     LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                                          ON ObjectLink_OrderType_Goods.ChildObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                                         AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                                     LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                                           ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                                          AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction() 
                               ) AS tmp
                          GROUP BY tmp.GoodsId, tmp.GoodsKindId
                         )
      , tmpPersonal AS (SELECT lfSelect.MemberId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                        FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                       )

      --
      , tmpGoodsByGoodsKindParam AS (SELECT Object_GoodsByGoodsKind_View.GoodsId     AS GoodsId
                                          , Object_GoodsByGoodsKind_View.GoodsKindId AS GoodsKindId
                                          , Object_Goods_basis.ObjectCode        AS GoodsCode_basis
                                          , Object_Goods_basis.ValueData         AS GoodsName_basis
                                          , Object_Goods_main.ObjectCode         AS GoodsCode_main
                                          , Object_Goods_main.ValueData          AS GoodsName_main
                                     FROM Object_GoodsByGoodsKind_View
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBasis
                                                                ON ObjectLink_GoodsByGoodsKind_GoodsBasis.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                               AND ObjectLink_GoodsByGoodsKind_GoodsBasis.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsBasis()
                                           LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = ObjectLink_GoodsByGoodsKind_GoodsBasis.ChildObjectId
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsMain
                                                                ON ObjectLink_GoodsByGoodsKind_GoodsMain.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                               AND ObjectLink_GoodsByGoodsKind_GoodsMain.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsMain()
                                           LEFT JOIN Object AS Object_Goods_main ON Object_Goods_main.Id = ObjectLink_GoodsByGoodsKind_GoodsMain.ChildObjectId
                                     WHERE COALESCE (ObjectLink_GoodsByGoodsKind_GoodsBasis.ChildObjectId, 0) <> 0
                                        OR COALESCE (ObjectLink_GoodsByGoodsKind_GoodsMain.ChildObjectId, 0) <> 0
                                     )

       , tmpStorage AS (SELECT spSelect.*
                        FROM gpSelect_Object_Storage (inSession) AS spSelect
                        )

     -- !!!РЕЗУЛЬТАТ!!!
     SELECT View_Account.AccountGroupName, View_Account.AccountDirectionName
        , View_Account.AccountId, View_Account.AccountCode, View_Account.AccountName, View_Account.AccountName_all
        , ObjectDesc.ItemName            AS LocationDescName
        , CAST (COALESCE(Object_Location.Id, 0) AS Integer)             AS LocationId
        , Object_Location.ObjectCode     AS LocationCode
        , CAST (COALESCE(Object_Location.ValueData,'') AS TVarChar)     AS LocationName
        , Object_Car.ObjectCode          AS CarCode
        , Object_Car.ValueData           AS CarName
        , Object_GoodsGroup.Id           AS GoodsGroupId
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

        , tmpGoodsByGoodsKindParam.GoodsCode_basis
        , tmpGoodsByGoodsKindParam.GoodsName_basis
        , tmpGoodsByGoodsKindParam.GoodsCode_main
        , tmpGoodsByGoodsKindParam.GoodsName_main

        , CAST (COALESCE(Object_Goods.Id, 0) AS Integer)                 AS GoodsId
-- , (select count(*) from tmpMIContainer_GP_all) :: Integer AS GoodsCode
        , Object_Goods.ObjectCode        AS GoodsCode
        , CAST (COALESCE(Object_Goods.ValueData, '') AS TVarChar)        AS GoodsName
        , COALESCE (zfCalc_Text_replace (ObjectString_Goods_Scale.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_Scale
        , CAST (COALESCE(Object_GoodsKind.Id, 0) AS Integer)             AS GoodsKindId
        , CAST (COALESCE(Object_GoodsKind.ValueData, '') AS TVarChar)    AS GoodsKindName
        , CAST (COALESCE(Object_GoodsKind_complete.ValueData, '') AS TVarChar) AS GoodsKindName_complete
        
        , Object_Measure.ValueData       AS MeasureName
        
        , CASE WHEN tmpObject_GoodsPropertyValue_basis.BarCode <> '' THEN tmpObject_GoodsPropertyValue_basis.BarCode ELSE '0000000000000' END :: TVarChar AS BarCode_Main

        , ObjectFloat_Weight.ValueData     AS Weight
        , ObjectFloat_WeightTare.ValueData ::TFloat AS WeightTare

        , ObjectDate_In.ValueData       :: TDateTime AS InDate
        , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInName
        
        , CASE WHEN tmpResult.PartionGoodsDate = zc_DateStart() THEN NULL ELSE tmpResult.PartionGoodsDate END :: TDateTime AS PartionGoodsDate
        , tmpResult.PartionGoodsName :: TVarChar  AS PartionGoodsName
        , Object_AssetTo.ValueData       AS AssetToName

        , tmpResult.PartionCellCode  ::Integer  AS PartionCellCode
        , tmpResult.PartionCellName  ::TVarChar AS PartionCellName

        , Object_Personal_Driver.ValueData AS DriverName
        , Object_Unit_to.ValueData         AS UnitName_to

        , tmpResult.CountReal :: TFloat AS CountReal
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountReal ELSE 0 END :: TFloat AS CountReal_sh
        , (tmpResult.CountReal * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountReal_Weight
        , CASE WHEN tmpResult.CountReal <> 0 THEN tmpResult.SummReal / tmpResult.CountReal ELSE 0 END :: TFloat AS PriceReal

        , tmpResult.CountStart :: TFloat AS CountStart
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountStart ELSE 0 END :: TFloat AS CountStart_sh
        , (tmpResult.CountStart * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountStart_Weight
        , CASE WHEN tmpResult.CountStart <> 0 THEN tmpResult.SummStart / tmpResult.CountStart ELSE 0 END :: TFloat AS PriceStart

        , tmpResult.CountEnd  :: TFloat AS CountEnd
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountEnd ELSE 0 END :: TFloat AS CountEnd_sh
        , (tmpResult.CountEnd * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountEnd_Weight
        , CASE WHEN tmpResult.CountEnd <> 0 THEN tmpResult.SummEnd / tmpResult.CountEnd ELSE 0 END :: TFloat AS PriceEnd
    
        , tmpResult.SummStart :: TFloat AS SummStart
        , tmpResult.SummEnd   :: TFloat AS SummEnd
        , tmpResult.SummReal  :: TFloat AS SummReal
        , (tmpResult.CountStart * tmpPriceStart.Price) :: TFloat AS SummPriceListStart
        , (tmpResult.CountEnd   * tmpPriceEnd.Price)   :: TFloat AS SummPriceListEnd

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

        , tmpResult.SummIn :: TFloat   AS SummIn
        , tmpResult.CountIn :: TFloat  AS CountIn
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountIn ELSE 0 END :: TFloat AS CountIn_sh
        , (tmpResult.CountIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountIn_Weight
        , CASE WHEN tmpResult.CountIn <> 0 THEN tmpResult.SummIn / tmpResult.CountIn ELSE 0 END :: TFloat AS PriceIn

        , (tmpResult.CountIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountTotalIn_Weight
        , tmpResult.SummIn :: TFloat   AS SummTotalIn
        
        , tmpResult.SummOut :: TFloat   AS SummOut
        , tmpResult.CountOut :: TFloat  AS CountOut
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountOut ELSE 0 END :: TFloat AS CountOut_sh
        , (tmpResult.CountOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOut_Weight
        , CASE WHEN tmpResult.CountOut <> 0 THEN tmpResult.SummOut / tmpResult.CountOut ELSE 0 END :: TFloat AS PriceOut

        , tmpResult.CountIn_calc :: TFloat  AS CountIn_calc
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountIn_calc ELSE 0 END :: TFloat AS CountIn_sh_calc
        , (tmpResult.CountIn_calc * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountIn_Weight_calc

        , tmpResult.CountOut_calc :: TFloat AS CountOut_calc
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountOut_calc ELSE 0 END :: TFloat AS CountOut_sh_calc
        , (tmpResult.CountOut_calc * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOut_Weight_calc

        , tmpResult.CountEnd_calc :: TFloat AS CountEnd_calc
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountEnd_calc ELSE 0 END :: TFloat AS CountEnd_sh_calc
        , (tmpResult.CountEnd_calc * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountEnd_Weight_calc

        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountLoss ELSE 0 END :: TFloat AS CountLoss_sh
        , (tmpResult.CountLoss * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountLoss_Weight
        , tmpResult.SummLoss  :: TFloat AS SummLoss
        , CASE WHEN tmpResult.CountLoss <> 0 THEN tmpResult.SummLoss / tmpResult.CountLoss ELSE 0 END :: TFloat AS PriceLoss

        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountInventory ELSE 0 END :: TFloat AS CountInventory_sh
        , (tmpResult.CountInventory * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountInventory_Weight
        , tmpResult.SummInventory         :: TFloat AS SummInventory
        , CASE WHEN tmpResult.CountInventory <> 0 THEN tmpResult.SummInventory / tmpResult.CountInventory ELSE 0 END :: TFloat AS PriceInventory
        , tmpResult.SummInventory_RePrice :: TFloat AS SummInventory_RePrice
        , tmpResult.SummInventory_Basis   :: TFloat AS SummInventory_Basis


        , ObjectFloat_TaxExit.ValueData AS TaxExit_norm -- % вых по норме
        , CASE WHEN tmpResult.CuterCount <> 0 AND ObjectFloat_Value.ValueData <> 0
                    THEN tmpResult.CountIn_byPF / tmpResult.CuterCount * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData
               ELSE 0
          END :: TFloat AS TaxExit_norm_real -- % вых по фактической норме (по кутерам)
        , CASE WHEN (tmpResult.CuterCount * tmpResult.CountOut_byPF) <> 0
                    -- т.е. ГП / кол кутеров:  tmpResult.CountIn_Weight_gp / (tmpResult.CountOut_byPF / (CuterCount * tmpResult.CountOut_byPF / CountIn_byPF))
                    -- THEN tmpResult.CountIn_Weight_gp * CuterCount / CountIn_byPF
                    -- т.е. ГП / кол кутеров:  tmpResult.CountIn_Weight_gp * CountIn_byPF / (CuterCount * tmpResult.CountOut_byPF)
                    THEN tmpResult.CountIn_Weight_gp * tmpResult.CountIn_byPF  / (tmpResult.CuterCount * tmpResult.CountOut_byPF)
               ELSE 0
          END :: TFloat AS TaxExit_real -- % вых по факту
        , tmpResult.CuterCount        :: TFloat AS CuterCount
        , tmpResult.CountIn_byPF      :: TFloat AS CountIn_byPF
        , ObjectFloat_Value.ValueData :: TFloat AS Value_receipt
        , 1                           :: TFloat AS CuterCount_receipt

          -- Прогноз прихода с пр-ва (ГП), расчет для CountEnd
        , CASE WHEN tmpResult.CountEnd > 0 AND ObjectFloat_Value.ValueData <> 0
                    THEN tmpResult.CountEnd * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData
               ELSE 0
          END :: TFloat AS CountIn_Weight_end_gp

          -- Расход ПФ(ГП) по норме на пр-во ГП, расчет для CountIn_Weight_gp
        , tmpResult.CountOut_norm_pf :: TFloat AS CountOut_norm_pf

          -- Приход по норме с пр-ва (ГП), расчет для CountOut_byPF ИЛИ для CountOut_byPF + CountEnd
        , CASE WHEN 1 = 0 AND (tmpResult.PartionGoodsDate + (COALESCE (tmpGoods_Term.TermProduction, 0) :: TVarChar || ' DAY') :: INTERVAL) <= inEndDate
                    THEN (tmpResult.CountOut_byPF + tmpResult.CountEnd) * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData
               WHEN ObjectFloat_Value.ValueData <> 0
                    THEN tmpResult.CountOut_byPF * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData
               ELSE 0
          END :: TFloat AS CountIn_Weight_norm_gp

          -- Приход с пр-ва (ГП)
        , tmpResult.CountIn_Weight_gp  :: TFloat AS CountIn_Weight_gp


        , tmpResult.CountOut_byPF    :: TFloat AS CountOut_byPF  -- Расход ПФ(ГП) за период на пр-во
        , tmpResult.CountOut_byCount :: TFloat AS Count_byCount  -- Расход ПФ(ГП) за весь период на пр-во
        , tmpResult.CountOut_onCount :: TFloat AS Count_onCount  -- Кол-во батонов в Расходе ПФ(ГП) за весь период
        , tmpResult.Count_onCount_in  :: TFloat AS Count_onCount_in   -- Кол-во батонов в приходе ПФ(ГП) за текущий период
        , tmpResult.Count_onCount_out :: TFloat AS Count_onCount_out  -- Кол-во батонов в расходе ПФ(ГП) за текущий период
        , tmpResult.CountInventory_byCount :: TFloat AS CountInventory_byCount -- Кол-во батонов инвентаризация
        --, CAST (CASE WHEN tmpResult.CountOut_byCount <> 0 THEN tmpResult.CountOut_onCount * tmpResult.CountStart / tmpResult.CountOut_byCount ELSE 0 END AS NUMERIC (16, 0)) :: TFloat AS CountStart_byCount -- Нач остаток батонов в ПФ(ГП)
        --, CAST (CASE WHEN tmpResult.CountOut_byCount <> 0 THEN tmpResult.CountOut_onCount * tmpResult.CountEnd   / tmpResult.CountOut_byCount ELSE 0 END AS NUMERIC (16, 0)) :: TFloat AS CountEnd_byCount   -- Кон остаток батонов в ПФ(ГП)
        --, CAST (CASE WHEN tmpResult.CountStart <> 0 THEN COALESCE (tmpResult.CountOut_onCount,0) - COALESCE (tmpResult.Count_onCount_in,0) ELSE 0 END AS NUMERIC (16, 0)) :: TFloat AS CountStart_byCount  -- Нач остаток батонов в ПФ(ГП)
        --, CAST (CASE WHEN tmpResult.CountEnd   <> 0 THEN COALESCE (tmpResult.CountOut_onCount,0) - COALESCE (tmpResult.Count_onCount_out,0) ELSE 0 END AS NUMERIC (16, 0)) :: TFloat AS CountEnd_byCount   -- Кон остаток батонов в ПФ(ГП)
        , CAST (tmpResult.CountStart_byCount AS NUMERIC (16, 0)) :: TFloat AS CountStart_byCount  -- Нач остаток батонов в ПФ(ГП)
        , CAST (tmpResult.CountEnd_byCount   AS NUMERIC (16, 0)) :: TFloat AS CountEnd_byCount   -- Кон остаток батонов в ПФ(ГП)


        , CAST (CASE WHEN tmpResult.CountOut_onCount <> 0 THEN tmpResult.CountOut_byCount / tmpResult.CountOut_onCount ELSE 0 END AS NUMERIC (16, 2)) :: TFloat AS Weight_byCount -- вес 1 батона



        , CAST (row_number() OVER () AS INTEGER)        AS LineNum

        , CASE WHEN COALESCE (tmpPriceStart_kind.Price, tmpPriceStart.Price, 0) <> COALESCE (tmpPriceEnd_kind.Price, tmpPriceEnd.Price, 0) THEN TRUE ELSE FALSE END isReprice
        , CASE WHEN tmpResult.CountStart = 0 AND ABS (tmpResult.SummStart) < 0.01
                    THEN FALSE
               WHEN tmpResult.CountStart = 0
                    THEN TRUE
               WHEN ABS (tmpResult.SummStart / tmpResult.CountStart - COALESCE (tmpPriceStart_kind.Price, tmpPriceStart.Price, 0)) > 0.01
                    THEN TRUE
               ELSE FALSE
          END :: Boolean AS isPriceStart_diff
        , CASE WHEN tmpResult.CountEnd = 0 AND ABS (tmpResult.SummEnd) < 0.01
                    THEN FALSE
               WHEN tmpResult.CountEnd = 0
                    THEN TRUE
               WHEN ABS (tmpResult.SummEnd / tmpResult.CountEnd - COALESCE (tmpPriceEnd_kind.Price, tmpPriceEnd.Price, 0)) > 0.01
                    THEN TRUE
               ELSE FALSE
          END :: Boolean AS isPriceEnd_diff
    
        , tmpGoods_Term.TermProduction :: TFloat AS TermProduction
        , CASE WHEN (tmpResult.PartionGoodsDate + (COALESCE (tmpGoods_Term.TermProduction, 0) :: TVarChar || ' DAY') :: INTERVAL) <= inEndDate
                    THEN TRUE
               ELSE FALSE
          END AS isPartionClose_calc

        , zc_Color_GreenL() :: Integer AS ColorB_GreenL
        , zc_Color_Yelow()  :: Integer AS ColorB_Yelow
        , zc_Color_Cyan()   :: Integer AS ColorB_Cyan

        , tmpResult.StorageId
        , tmpResult.StorageName      ::TVarChar
        , tmpResult.PartionModelId
        , tmpResult.PartionModelName ::TVarChar
        , tmpResult.UnitId                      AS UnitId_Partion
        , tmpResult.UnitName         ::TVarChar AS UnitName_Partion
        , Object_Branch.ValueData    ::TVarChar AS BranchName_Partion
        , tmpResult.PartNumber       ::TVarChar AS PartNumber_Partion
        , tmpStorage.AreaUnitName ::TVarChar AS AreaUnitName_storage
        , tmpStorage.Room         ::TVarChar AS Room_storage
        , tmpStorage.Address      ::TVarChar AS Address_storage
      FROM tmpResult
        LEFT JOIN tmpGoods_Term ON tmpGoods_Term.GoodsId     = tmpResult.GoodsId
                               AND tmpGoods_Term.GoodsKindId = tmpResult.GoodsKindId
        LEFT JOIN tmpNorm_PF ON tmpNorm_PF.GoodsId              = tmpResult.GoodsId
                            AND tmpNorm_PF.GoodsKindId          = tmpResult.GoodsKindId
                            AND tmpNorm_PF.GoodsKindId_complete = tmpResult.GoodsKindId_complete

        LEFT JOIN ObjectFloat AS ObjectFloat_Value
                              ON ObjectFloat_Value.ObjectId = tmpNorm_PF.ReceiptId
                             AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
        LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                              ON ObjectFloat_TaxExit.ObjectId = tmpNorm_PF.ReceiptId
                             AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()

        LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                      ON CLO_InfoMoney.ContainerId = NULL
                                     AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CLO_InfoMoney.ObjectId

        LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                      ON CLO_InfoMoneyDetail.ContainerId = NULL
                                     AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = CLO_InfoMoneyDetail.ObjectId

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId
        LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = tmpResult.GoodsKindId_complete
        --LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = tmpResult.PartionCellId

        -- LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = NULL
        -- LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = NULL
        --                                           AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
        LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpResult.LocationId
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpResult.LocationId
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location.DescId -- Object_Location_find.DescId

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

        LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                               ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_Scale.DescId = zc_ObjectString_Goods_Scale()

        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                              ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
        LEFT JOIN ObjectFloat AS ObjectFloat_WeightTare 
                              ON ObjectFloat_WeightTare.ObjectId = Object_Goods.Id
                             AND ObjectFloat_WeightTare.DescId = zc_ObjectFloat_Goods_WeightTare()

        LEFT JOIN ObjectDate AS ObjectDate_In
                             ON ObjectDate_In.ObjectId = tmpResult.GoodsId
                            AND ObjectDate_In.DescId = zc_ObjectDate_Goods_In()

        LEFT JOIN ObjectLink AS ObjectLink_Goods_PartnerIn
                             ON ObjectLink_Goods_PartnerIn.ObjectId = tmpResult.GoodsId
                            AND ObjectLink_Goods_PartnerIn.DescId = zc_ObjectLink_Goods_PartnerIn()
        LEFT JOIN Object AS Object_PartnerIn ON Object_PartnerIn.Id = ObjectLink_Goods_PartnerIn.ChildObjectId

        LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = NULL

        LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = NULL

        -- цены привязываем 2 раза по виду товара и без
        LEFT JOIN tmpPriceStart ON tmpPriceStart.GoodsId = tmpResult.GoodsId
                               AND tmpPriceStart.GoodsKindId IS NULL
        LEFT JOIN tmpPriceStart AS tmpPriceStart_kind
                                ON tmpPriceStart_kind.GoodsId = tmpResult.GoodsId
                               AND COALESCE (tmpPriceStart_kind.GoodsKindId,0) = COALESCE (tmpResult.GoodsKindId,0)
        -- цены привязываем 2 раза по виду товара и без                      
        LEFT JOIN tmpPriceEnd ON tmpPriceEnd.GoodsId = tmpResult.GoodsId
                             AND tmpPriceEnd.GoodsKindId IS NULL
        LEFT JOIN tmpPriceEnd AS tmpPriceEnd_kind
                              ON tmpPriceEnd_kind.GoodsId = tmpResult.GoodsId
                             AND COALESCE (tmpPriceEnd_kind.GoodsKindId,0) = COALESCE (tmpResult.GoodsKindId,0)

        LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpResult.GoodsId
                                                    AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpResult.GoodsKindId

        LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver
                             ON ObjectLink_Car_PersonalDriver.ObjectId = Object_Location.Id
                            AND ObjectLink_Car_PersonalDriver.DescId   = zc_ObjectLink_Car_PersonalDriver()
        LEFT JOIN Object AS Object_Personal_Driver ON Object_Personal_Driver.Id = ObjectLink_Car_PersonalDriver.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = Object_Location.Id
                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
        LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Location.Id
        LEFT JOIN Object AS Object_Unit_to ON Object_Unit_to.Id = COALESCE (tmpPersonal.UnitId, ObjectLink_Car_Unit.ChildObjectId)

        LEFT JOIN tmpGoodsByGoodsKindParam ON tmpGoodsByGoodsKindParam.GoodsId = tmpResult.GoodsId
                                          AND COALESCE (tmpGoodsByGoodsKindParam.GoodsKindId, 0) = COALESCE (tmpResult.GoodsKindId, 0)

        LEFT JOIN tmpStorage ON tmpStorage.Id = tmpResult.StorageId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = tmpResult.UnitId
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
      WHERE tmpResult.CountReal <> 0
         OR tmpResult.SummReal <> 0

         OR tmpResult.CountStart <> 0
         OR tmpResult.SummStart <> 0

         OR tmpResult.CountEnd <> 0
         OR tmpResult.CountEnd_calc <> 0
         OR tmpResult.SummEnd <> 0

         OR tmpResult.CountIn <> 0
         OR tmpResult.SummIn <> 0

         OR tmpResult.CountOut <> 0
         OR tmpResult.SummOut <> 0

         OR tmpResult.CountIn_calc <> 0
         OR tmpResult.CountOut_calc <> 0

         OR tmpResult.CountIn_Weight_gp <> 0
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.01.24         *
 18.12.19         *
 12.11.18         *
 19.10.18         *
 29.07.16         * add tmpObject_GoodsPropertyValue_basis
 01.07.15         *
 02.05.15         * 
*/

-- тест
-- SELECT * FROM gpReport_GoodsBalance (inStartDate:= '01.09.2018', inEndDate:= '01.09.2018', inAccountGroupId:= 0, inUnitGroupId := 8459 , inLocationId := 0 , inGoodsGroupId := 1860 , inGoodsId := 0 , inIsInfoMoney:= TRUE, inIsAllMO:= TRUE, inIsAllAuto:= TRUE, inSession := '5');
--  select * from gpReport_GoodsBalance(inStartDate := ('03.03.2024')::TDateTime , inEndDate := ('23.03.2024')::TDateTime , inAccountGroupId := 0 , inUnitGroupId := 0 , inLocationId := 8448 , inGoodsGroupId := 0 , inGoodsId := 2339 , inIsInfoMoney := 'False' , inIsAllMO := 'False' , inIsAllAuto := 'False' , inIsOperDate_Partion:= TRUE, inIsPartionCell := TRUE,  inSession := '5');
