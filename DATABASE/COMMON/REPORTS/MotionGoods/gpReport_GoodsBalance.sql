-- Function: gpReport_GoodsBalance()


DROP FUNCTION IF EXISTS gpReport_GoodsBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsBalance(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    -- группа подразделений на самом деле может быть и подразделением
    IN inLocationId         Integer,    --
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inGoodsId            Integer,    -- товар
    IN inIsInfoMoney        Boolean,    --
    IN inSession            TVarChar   -- пользователь
)
RETURNS TABLE (AccountGroupName TVarChar, AccountDirectionName TVarChar
             , AccountId Integer, AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
             , LocationDescName TVarChar, LocationId Integer, LocationCode Integer, LocationName TVarChar
             , CarCode Integer, CarName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , Weight TFloat
             , PartionGoodsId Integer, PartionGoodsName TVarChar, AssetToName TVarChar

             , CountStart TFloat
             , CountStart_Weight TFloat
             , CountEnd TFloat
             , CountEnd_Weight TFloat
             
             , SummStart TFloat
             , SummEnd TFloat

             , PriceStart TFloat
             , PriceEnd TFloat
          
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

         --    , ContainerId_Summ Integer
             , LineNum Integer

             , CountOUT TFloat, CountIn TFloat
             --рассчет
             , CountRemains TFloat, PriceRemains TFloat , SummRemains TFloat   -- остаток текущий
             , CountOut_Remains TFloat, CountIn_Remains TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);
   
 -- !!!может так будет быстрее!!!
    inAccountGroupId:= COALESCE (inAccountGroupId, 0);

    -- !!!меняются параметры для филиала!!!
    IF 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
    THEN
        inAccountGroupId:= zc_Enum_AccountGroup_20000(); -- Запасы
        inIsInfoMoney:= FALSE;
    END IF;


    -- таблица -
    CREATE TEMP TABLE _tmpListContainer (LocationId Integer, ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, GoodsId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpContainer (ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, LocationId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsId Integer, AssetToId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;

    -- группа подразделений или подразделение или место учета (МО, Авто)
    IF inUnitGroupId <> 0
    THEN
        INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
           SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
                , zc_ContainerLinkObject_Unit()       AS DescId
                , tmpDesc.ContainerDescId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId) AS tmpDesc ON 1 = 1
          ;
    ELSE
        IF inLocationId <> 0
        THEN
            INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
               SELECT Object.Id AS LocationId
                    , CASE WHEN Object.DescId = zc_Object_Unit() THEN zc_ContainerLinkObject_Unit() 
                           WHEN Object.DescId = zc_Object_Car() THEN zc_ContainerLinkObject_Car() 
                           WHEN Object.DescId = zc_Object_Member() THEN zc_ContainerLinkObject_Member()
                      END AS DescId
                    , tmpDesc.ContainerDescId
               FROM Object
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId) AS tmpDesc ON 1 = 1
               WHERE Object.Id = inLocationId;
        ELSE
            WITH tmpBranch AS (SELECT TRUE AS Value WHERE 1 = 0 AND NOT EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0))
            INSERT INTO _tmpLocation (LocationId)
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Unit()
              UNION ALL
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Member()
              UNION ALL
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Car();
        END IF;
    END IF;
    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpLocation;


    -- группа товаров или товар или все товары из проводок
    IF inGoodsGroupId <> 0
    THEN
        WITH tmpGoods AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup)
           , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId FROM Object_Account_View AS View_Account WHERE View_Account.AccountGroupId = inAccountGroupId)

        INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
           SELECT _tmpLocation.LocationId
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
                                              AND ContainerLinkObject.DescId = _tmpLocation.DescId
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
           WHERE (_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountId > 0)
              OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                        OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                         ))
              OR inAccountGroupId = 0
          ;
    ELSE IF inGoodsId <> 0
         THEN
             WITH tmpContainer AS (SELECT CLO_Goods.ContainerId FROM ContainerLinkObject AS CLO_Goods WHERE CLO_Goods.ObjectId = inGoodsId AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                 UNION
                                   SELECT Container.Id FROM Container WHERE Container.ObjectId = inGoodsId AND Container.DescId = zc_Container_Count()
                                  )
                , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId FROM Object_Account_View AS View_Account WHERE View_Account.AccountGroupId IN (inAccountGroupId, zc_Enum_AccountGroup_60000())) -- Прибыль будущих периодов

             INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
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
                WHERE (_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountGroupId = inAccountGroupId)
                   OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                             OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                              ))
                   OR inAccountGroupId = 0
               ;
         ELSE
             WITH tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId FROM Object_Account_View AS View_Account WHERE View_Account.AccountGroupId = inAccountGroupId)

             INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
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
                WHERE (_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountId > 0)
                   OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                             OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                              ))
                   OR inAccountGroupId = 0
               ;
         END IF;
    END IF;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpListContainer;

    -- пытаемся найти <Счет> для zc_Container_Count
    UPDATE _tmpListContainer SET AccountId = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId = zc_Container_Count()
      AND _tmpListContainer_summ.ContainerDescId = zc_Container_Summ()
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId <> zc_Enum_AccountGroup_110000() -- Транзит
   ;

    -- все ContainerId
    INSERT INTO _tmpContainer (ContainerDescId, ContainerId_count, ContainerId_begin, LocationId, GoodsId, GoodsKindId, PartionGoodsId, AssetToId, AccountId, AccountGroupId, Amount)
       SELECT _tmpListContainer.ContainerDescId
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
       ;

    -- Результат
    RETURN QUERY
          WITH tmpMIContainer AS (SELECT _tmpContainer.ContainerDescId
                                       , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END AS ContainerId_count
                                       , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END AS ContainerId_begin
                                       , _tmpContainer.LocationId
                                       , _tmpContainer.GoodsId
                                       , _tmpContainer.GoodsKindId
                                       , _tmpContainer.PartionGoodsId
                                       , _tmpContainer.AssetToId
                                       , _tmpContainer.AccountId
                                       , _tmpContainer.AccountGroupId

                                         -- ***REMAINS***
                                       , -1 * SUM (MIContainer.Amount) AS RemainsStart
                                       , 0                             AS RemainsEnd

                                  FROM _tmpContainer
                                       INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                      
                                  GROUP BY  _tmpContainer.ContainerDescId
                                         , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END
                                         , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END
                                         , _tmpContainer.LocationId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.GoodsKindId
                                         , _tmpContainer.PartionGoodsId
                                         , _tmpContainer.AssetToId
                                         , _tmpContainer.AccountId
                                         , _tmpContainer.AccountGroupId
            
                                         -- ***REMAINS***
                                  HAVING SUM (MIContainer.Amount) <> 0 -- AS RemainsStart

                                 UNION ALL
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

                                      
                                         -- ***REMAINS***
                                       , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                                       , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsEnd
                                  FROM _tmpContainer AS _tmpContainer
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                                     AND MIContainer.OperDate > inEndDate
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
                                 )

         -- Результат
              , tmpMIContainer_all AS (SELECT (tmpMIContainer_all.AccountId)       AS AccountId
              , tmpMIContainer_all.ContainerId_begin AS ContainerId
              , tmpMIContainer_all.LocationId
              , tmpMIContainer_all.GoodsId
              , tmpMIContainer_all.GoodsKindId
              , tmpMIContainer_all.PartionGoodsId
              , tmpMIContainer_all.AssetToId

             -- , tmpMIContainer_all.LocationId_by

              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsStart ELSE 0 END) :: TFloat AS CountStart
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsEnd   ELSE 0 END) :: TFloat AS CountEnd
             -- , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsEnd + tmpMIContainer_all.CountInventory ELSE 0 END) :: TFloat AS CountEnd_calc

     
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Summ() THEN tmpMIContainer_all.RemainsStart ELSE 0 END) :: TFloat AS SummStart
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Summ() THEN tmpMIContainer_all.RemainsEnd   ELSE 0 END) :: TFloat AS SummEnd
            --  , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Summ() THEN tmpMIContainer_all.RemainsEnd + tmpMIContainer_all.SummInventory + tmpMIContainer_all.SummInventory ELSE 0 END) :: TFloat AS SummEnd_calc
          
         FROM tmpMIContainer AS tmpMIContainer_all
         GROUP BY tmpMIContainer_all.AccountId 
                , tmpMIContainer_all.ContainerId_begin
                , tmpMIContainer_all.LocationId
                , tmpMIContainer_all.GoodsId
                , tmpMIContainer_all.GoodsKindId
                , tmpMIContainer_all.PartionGoodsId
                , tmpMIContainer_all.AssetToId
             
          )

         , tmpPriceStart AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                , (lfObjectHistory_PriceListItem.ValuePrice * 1.2) :: TFloat AS Price
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inStartDate) AS lfObjectHistory_PriceListItem
                           WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                          )
         , tmpPriceEnd AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                , (lfObjectHistory_PriceListItem.ValuePrice * 1.2) :: TFloat AS Price
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inEndDate) AS lfObjectHistory_PriceListItem
                           WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                          )   

       , tmpMovement AS (SELECT MovementItem.ObjectId  AS GoodsId
                              , MovementLinkObject_From.ObjectId AS LocationId
                              , SUM (CASE WHEN MovementLinkObject_From.DescId = zc_MovementLinkObject_From() THEN MovementItem.Amount Else 0 END) AS  CalcAmountOUT     --расход
                              , SUM (CASE WHEN MovementLinkObject_From.DescId = zc_MovementLinkObject_To() THEN MovementItem.Amount Else 0 END) AS  CalcAmountIn        --приход
                         FROM Movement 
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id

                              LEFT JOIN MovementItem On MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.isErased = False
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    
                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                           AND Movement.DescId   = zc_Movement_ProductionSeparate()
                           AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           AND MovementLinkObject_From.ObjectId in (SELECT _tmpLocation.LocationId FROM _tmpLocation) --133049
                           AND MovementItem.ObjectId  = inGoodsId -- 4183 --6749
                         GROUP BY MovementItem.ObjectId, MovementLinkObject_From.ObjectId
                         )
                         


     SELECT View_Account.AccountGroupName, View_Account.AccountDirectionName
        , View_Account.AccountId, View_Account.AccountCode, View_Account.AccountName, View_Account.AccountName_all
        , ObjectDesc.ItemName            AS LocationDescName
        , CAST (COALESCE(Object_Location.Id, 0) AS Integer)             AS LocationId
        , Object_Location.ObjectCode     AS LocationCode
        , CAST (COALESCE(Object_Location.ValueData,'') AS TVarChar)     AS LocationName
        , Object_Car.ObjectCode          AS CarCode
        , Object_Car.ValueData           AS CarName
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
        , CAST (COALESCE(Object_Goods.Id, 0) AS Integer)                 AS GoodsId
        , Object_Goods.ObjectCode        AS GoodsCode
        , CAST (COALESCE(Object_Goods.ValueData, '') AS TVarChar)        AS GoodsName
        , CAST (COALESCE(Object_GoodsKind.Id, 0) AS Integer)             AS GoodsKindId
        , CAST (COALESCE(Object_GoodsKind.ValueData, '') AS TVarChar)    AS GoodsKindName
        , Object_Measure.ValueData       AS MeasureName
        , ObjectFloat_Weight.ValueData   AS Weight
        , CAST (COALESCE(Object_PartionGoods.Id, 0) AS Integer)           AS PartionGoodsId
        , CAST (COALESCE(Object_PartionGoods.ValueData,'') AS TVarChar)  AS PartionGoodsName
        , Object_AssetTo.ValueData       AS AssetToName

        , CAST (tmpMIContainer_all.CountStart          AS TFloat) AS CountStart
        , CAST (tmpMIContainer_all.CountStart * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END          AS TFloat) AS CountStart_Weight
        , CAST (tmpMIContainer_all.CountEnd            AS TFloat) AS CountEnd
        , CAST (tmpMIContainer_all.CountEnd * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END            AS TFloat) AS CountEnd_Weight
    
        , CAST (tmpMIContainer_all.SummStart            AS TFloat) AS SummStart
        , CAST (tmpMIContainer_all.SummEnd              AS TFloat) AS SummEnd
    
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

       , CAST (row_number() OVER () AS INTEGER)        AS LineNum
       
       , tmpMovement.CalcAmountOUT ::TFloat AS CountOut
       , tmpMovement.CalcAmountIN ::TFloat  AS CountIn
       
        , CAST (0 AS TFloat)  AS CountRemains
        , CAST (0 AS TFloat)  AS PriceRemains
        , CAST (0 AS TFloat)  AS SummRemains
        , CAST (0 AS TFloat)  AS CountOut_Remains
        , CAST (0 AS TFloat)  AS CountIn_Remains

      FROM tmpMIContainer_all

        LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                      ON CLO_InfoMoney.ContainerId = tmpMIContainer_all.ContainerId
                                     AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CLO_InfoMoney.ObjectId

        LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                      ON CLO_InfoMoneyDetail.ContainerId = tmpMIContainer_all.ContainerId
                                     AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = CLO_InfoMoneyDetail.ObjectId

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIContainer_all.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMIContainer_all.GoodsKindId
        LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = tmpMIContainer_all.LocationId
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location_find.DescId
        LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = tmpMIContainer_all.LocationId
                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
        LEFT JOIN Object AS Object_Location ON Object_Location.Id = CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN ObjectLink_Car_Unit.ChildObjectId ELSE tmpMIContainer_all.LocationId END
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = CASE WHEN Object_Location_find.DescId = zc_Object_Car() THEN tmpMIContainer_all.LocationId END

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
        LEFT JOIN ObjectFloat AS ObjectFloat_Weight ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_all.PartionGoodsId
        LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = tmpMIContainer_all.AssetToId

        LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpMIContainer_all.AccountId

        LEFT JOIN tmpPriceStart ON tmpPriceStart.GoodsId = tmpMIContainer_all.GoodsId
        LEFT JOIN tmpPriceEnd ON tmpPriceEnd.GoodsId = tmpMIContainer_all.GoodsId

        LEFT JOIN tmpMovement on tmpMovement.GoodsId = tmpMIContainer_all.GoodsId
                             AND tmpMovement.LocationId = tmpMIContainer_all.LocationId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpReport_GoodsBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.07.15         *
 02.05.15         * 

*/

-- тест
-- SELECT * FROM gpReport_GoodsBalance (inStartDate:= '01.01.2015', inEndDate:= '01.01.2015', inAccountGroupId:= 0, inUnitGroupId:= 0, inLocationId:= 0, inGoodsGroupId:= 0, inGoodsId:= 0, inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= FALSE, inSession:= '2')
-- SELECT * from gpReport_GoodsBalance (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inAccountGroupId:= 0, inUnitGroupId := 8459 , inLocationId := 0 , inGoodsGroupId := 1860 , inGoodsId := 0 , inUnitGroupId_by:=0, inLocationId_by:= 0, inIsInfoMoney:= TRUE, inSession := '5');
