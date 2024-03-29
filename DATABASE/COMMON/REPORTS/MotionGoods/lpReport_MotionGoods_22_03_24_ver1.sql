-- Function: lpReport_MotionGoods()
-- !!!!ТЕСТОВАЯ версия - добавлен OLAP!!!

DROP FUNCTION IF EXISTS lpReport_MotionGoods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpReport_MotionGoods(
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

    -- ускорение - ОЛАП
    vb_IsContainer_OLAP:= inEndDate < '01.01.2024' AND inUserId = 5;

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

    ELSE
        vb_IsContainer_OLAP:= FALSE;

    END IF;



    IF inAccountGroupId = -1 * zc_Enum_AccountGroup_20000()
    THEN
        vbIsAssetNoBalance:= TRUE;
        inAccountGroupId:= -1 * zc_Enum_AccountGroup_20000();
    END IF;

    -- !!!ДЛЯ ТЕСТА!!!
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpLocation'))
    AND inUserId = 5
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
       


    -- группа товаров или товар или все товары из проводок
    IF inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
    THEN
        WITH tmpGoods AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect WHERE vbIsAssetTo = FALSE
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
                           vb_IsContainer_OLAP

   , tmpContainer_OLAP AS (-- НЕ подключили !!!OLAP!!!
                           SELECT Container.*
                                , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN Container.ObjectId ELSE CLO_Goods.ObjectId END AS GoodsId_calc
                           FROM _tmpLocation
                                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                              AND ContainerLinkObject.DescId = _tmpLocation.DescId
                                LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                                          AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                                          AND _tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                LEFT JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                                   AND Container.DescId = _tmpLocation.ContainerDescId
                                INNER JOIN tmpGoods ON tmpGoods.GoodsId = CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN Container.ObjectId ELSE CLO_Goods.ObjectId END

                           -- НЕ подключили !!!OLAP!!!
                           WHERE vb_IsContainer_OLAP = FALSE


                          UNION ALL
                           -- подключили !!!OLAP!!!
                           SELECT Container.*
                                , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN Container.ObjectId ELSE CLO_Goods.ObjectId END AS GoodsId_calc
                           FROM _tmpLocation
                                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                              AND ContainerLinkObject.DescId = _tmpLocation.DescId
                                LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                                          AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                                          AND _tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                -- подключили !!!OLAP!!!
                                LEFT JOIN Container_data AS Container
                                                         ON Container.Id        = ContainerLinkObject.ContainerId
                                                        AND Container.DescId    = _tmpLocation.ContainerDescId
                                                        -- подключили !!!OLAP!!!
                                                        AND Container.StartDate = vbStartDate_olap
                                                        AND Container.VerId     = vbVerId_olap
                                INNER JOIN tmpGoods ON tmpGoods.GoodsId = CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN Container.ObjectId ELSE CLO_Goods.ObjectId END
                           -- подключили !!!OLAP!!!
                           WHERE vb_IsContainer_OLAP = TRUE
                          )

           , tmp AS
          (SELECT _tmpLocation.LocationId
                , _tmpLocation.ContainerDescId
                , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                            THEN ContainerLinkObject.ContainerId
                       ELSE COALESCE (Container.ParentId, 0)
                  END AS ContainerId_count
                , ContainerLinkObject.ContainerId AS ContainerId_begin

              --, tmpGoods.GoodsId
                , Container.GoodsId_calc AS GoodsId

                , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                            THEN COALESCE (CLO_Account.ObjectId, 0)
                       ELSE COALESCE (Container.ObjectId, 0)
                  END AS AccountId
                , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                            THEN zc_Enum_AccountGroup_110000() -- Транзит
                       ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                  END AS AccountGroupId
                  -- подключили !!!OLAP!!!
                , Container.Amount

                , _tmpLocation.DescId    AS Value1_ch
                , CLO_Member.ContainerId AS Value2_ch
           FROM _tmpLocation
                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                              AND ContainerLinkObject.DescId = _tmpLocation.DescId
                --LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                --                                          AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                --                                          AND _tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())

                -- подключили !!!OLAP!!!
                LEFT JOIN tmpContainer_OLAP AS Container
                                            ON Container.Id = ContainerLinkObject.ContainerId
                                           AND Container.DescId = _tmpLocation.ContainerDescId
                -- INNER JOIN tmpGoods ON tmpGoods.GoodsId = CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN Container.ObjectId ELSE CLO_Goods.ObjectId END

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
           WHERE (
                  (_tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) AND tmpAccount.AccountId > 0)
               OR (_tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                         OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                          ))
                 )
             AND (((Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000()) AND vbIsAssetTo = TRUE)
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
             WITH tmpContainer AS (SELECT CLO_Goods.ContainerId FROM ContainerLinkObject AS CLO_Goods WHERE CLO_Goods.ObjectId = inGoodsId AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
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
   , tmpContainer_OLAP AS (-- НЕ подключили !!!OLAP!!!
                           SELECT Container.*
                           FROM tmpContainer
                                INNER JOIN Container ON Container.Id = tmpContainer.ContainerId
                           -- НЕ подключили !!!OLAP!!!
                           WHERE vb_IsContainer_OLAP = FALSE


                          UNION ALL
                           -- подключили !!!OLAP!!!
                           SELECT Container.*
                                , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN Container.ObjectId ELSE CLO_Goods.ObjectId END AS GoodsId_calc
                           FROM tmpContainer
                                -- подключили !!!OLAP!!!
                                LEFT JOIN Container_data AS Container
                                                         ON Container.Id        = tmpContainer.ContainerId
                                                        -- подключили !!!OLAP!!!
                                                        AND Container.StartDate = vbStartDate_olap
                                                        AND Container.VerId     = vbVerId_olap
                           -- подключили !!!OLAP!!!
                           WHERE vb_IsContainer_OLAP = TRUE
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
                     , Container.Amount

                     , _tmpLocation.DescId    AS Value1_ch
                     , CLO_Member.ContainerId AS Value2_ch
                FROM tmpContainer
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = tmpContainer.ContainerId
                     INNER JOIN _tmpLocation ON _tmpLocation.LocationId = ContainerLinkObject.ObjectId
                                            AND _tmpLocation.DescId = ContainerLinkObject.DescId
                     -- подключили !!!OLAP!!!
                     INNER JOIN tmpContainer_OLAP AS Container
                                                  ON Container.Id     = tmpContainer.ContainerId
                                                 AND Container.DescId = _tmpLocation.ContainerDescId

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
                WHERE (
                       (_tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) AND tmpAccount.AccountId > 0)
                    OR (_tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                              OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                               ))
                      )
                  AND (((Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000()) AND vbIsAssetTo = TRUE)
                     OR vbIsAssetTo = FALSE)
                  -- AND ((_tmpLocation.DescId <> zc_ContainerLinkObject_Member() AND CLO_Member.ContainerId IS NULL)
                  --   OR _tmpLocation.DescId = zc_ContainerLinkObject_Member())
               ) AS tmp
                WHERE ((tmp.Value1_ch <> zc_ContainerLinkObject_Member() AND tmp.Value2_ch IS NULL)
                    OR tmp.Value1_ch = zc_ContainerLinkObject_Member())
              ;
         ELSE
             WITH tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId
                                 FROM (SELECT inAccountGroupId              AS AccountGroupId WHERE inAccountGroupId <> 0
                                 UNION SELECT zc_Enum_AccountGroup_10000()  AS AccountGroupId WHERE inAccountGroupId = 0
                                 UNION SELECT zc_Enum_AccountGroup_20000()  AS AccountGroupId WHERE inAccountGroupId = 0
                                 UNION SELECT zc_Enum_AccountGroup_60000()  AS AccountGroupId WHERE inAccountGroupId = 0
                                 UNION SELECT zc_Enum_AccountGroup_110000() AS AccountGroupId WHERE inAccountGroupId = 0
                                      ) AS tmp
                                      INNER JOIN Object_Account_View AS View_Account ON View_Account.AccountGroupId = tmp.AccountGroupId
                                )
   , tmpContainer_OLAP AS (-- НЕ подключили !!!OLAP!!!
                           SELECT Container.*
                           FROM _tmpLocation
                                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                              AND ContainerLinkObject.DescId = _tmpLocation.DescId
                                INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                                    AND Container.DescId = _tmpLocation.ContainerDescId

                           -- НЕ подключили !!!OLAP!!!
                           WHERE vb_IsContainer_OLAP = FALSE


                          UNION ALL
                           -- подключили !!!OLAP!!!
                           SELECT Container.*
                           FROM _tmpLocation
                                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                              AND ContainerLinkObject.DescId = _tmpLocation.DescId
                                -- подключили !!!OLAP!!!
                                LEFT JOIN Container_data AS Container
                                                         ON Container.Id        = ContainerLinkObject.ContainerId
                                                        AND Container.DescId    = _tmpLocation.ContainerDescId
                                                        -- подключили !!!OLAP!!!
                                                        AND Container.StartDate = vbStartDate_olap
                                                        AND Container.VerId     = vbVerId_olap
                           -- подключили !!!OLAP!!!
                           WHERE vb_IsContainer_OLAP = TRUE
                          )

             INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
                SELECT tmp.LocationId, tmp.ContainerDescId, tmp.ContainerId_count, tmp.ContainerId_begin, tmp.GoodsId, tmp.AccountId, tmp.AccountGroupId, tmp.Amount
                FROM
               (SELECT _tmpLocation.LocationId
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
                     , Container.Amount 
  
                     , _tmpLocation.DescId    AS Value1_ch
                     , CLO_Member.ContainerId AS Value2_ch
                FROM _tmpLocation
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                   AND ContainerLinkObject.DescId = _tmpLocation.DescId
                     -- подключили !!!OLAP!!!
                     INNER JOIN tmpContainer_OLAP AS Container
                                                  ON Container.Id     = ContainerLinkObject.ContainerId
                                                 AND Container.DescId = _tmpLocation.ContainerDescId

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
                WHERE ((_tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()) AND tmpAccount.AccountId > 0)
                    OR (_tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                                              OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
                                                                               ))
                      )
                  AND (((Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000()) AND vbIsAssetTo = TRUE)
                     OR vbIsAssetTo = FALSE)
                  -- AND ((ContainerLinkObject.DescId <> zc_ContainerLinkObject_Member() AND CLO_Member.ContainerId IS NULL)
                  --   OR ContainerLinkObject.DescId = zc_ContainerLinkObject_Member())
               ) AS tmp
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


    -- 2.3. убрали
    DELETE FROM _tmpListContainer
    WHERE _tmpListContainer.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
      AND COALESCE (_tmpListContainer.AccountId, 0) = 0
      AND EXISTS (SELECT 1 FROM Container WHERE Container.ParentId = _tmpListContainer.ContainerId_count)
      AND (vbIsAssetNoBalance = TRUE) --  OR inUserId = 5
      AND (EXISTS (SELECT 1 FROM _tmpLocation WHERE _tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset()))) --  OR inUserId = 5
     ;


    -- все ContainerId
    INSERT INTO _tmpContainer (ContainerDescId, ContainerDescId_count, ContainerId_count, ContainerId_begin, LocationId, CarId, GoodsId, GoodsKindId, PartionGoodsId, AssetToId, AccountId, AccountGroupId, Amount)
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
            LEFT JOIN Container ON Container.Id = _tmpListContainer.ContainerId_count
            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpListContainer.ContainerId_begin
                                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpListContainer.ContainerId_begin
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
            LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = _tmpListContainer.ContainerId_begin
                                                        AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
            LEFT JOIN ContainerLinkObject AS CLO_Car ON CLO_Car.ContainerId = _tmpListContainer.ContainerId_begin
                                                    AND CLO_Car.DescId = zc_ContainerLinkObject_Car()
            LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = _tmpListContainer.ContainerId_begin
                                                     AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
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

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MovementBoolean_HistoryCost.ValueData = TRUE
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
                                                   AND COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE
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
-- and (MIContainer.ContainerId = 2092731
-- or inUserId <> 5)
                                       LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                                                 ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                                       LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                                 ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()

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

         -- Результат
         SELECT (tmpMIContainer_all.AccountId)       AS AccountId
              , tmpMIContainer_all.ContainerDescId_count :: Integer AS ContainerDescId_count
              , tmpMIContainer_all.ContainerId_count AS ContainerId_count
              , tmpMIContainer_all.ContainerId_begin AS ContainerId
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
         GROUP BY tmpMIContainer_all.AccountId 
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
-- SELECT * FROM lpReport_MotionGoods (inStartDate:= '01.08.2025', inEndDate:= '01.08.2025', inAccountGroupId:= 9015, inUnitGroupId := 0 , inLocationId := 8425 , inGoodsGroupId := 0 , inGoodsId := 0,  inIsInfoMoney:= FALSE, inUserId := zfCalc_UserAdmin() :: Integer);
