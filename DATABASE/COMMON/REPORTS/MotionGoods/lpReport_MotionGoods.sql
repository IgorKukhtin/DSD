-- Function: lpReport_MotionGoods()

DROP FUNCTION IF EXISTS lpReport_MotionGoods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpReport_MotionGoods(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    -- ������ ������������� �� ����� ���� ����� ���� � ��������������
    IN inLocationId         Integer,    --
    IN inGoodsGroupId       Integer,    -- ������ ������
    IN inGoodsId            Integer,    -- �����
    IN inIsInfoMoney        Boolean,    --
    IN inUserId             Integer     -- ������������
)
RETURNS TABLE (AccountId Integer
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

             , CountSendOnPriceIn  TFloat
             , CountSendOnPriceOut TFloat

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

             , SummSendOnPriceIn TFloat
             , SummSendOnPriceOut TFloat

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
             , SummInventory_RePrice TFloat

             , SummProductionIn  TFloat
             , SummProductionOut TFloat

              )
AS
$BODY$
   DECLARE vbIsAssetTo Boolean;
   DECLARE vbIsCLO_Member Boolean;
BEGIN
    -- !!!��� �����!!!
    /*IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpLocation'))
    THEN
        CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;
        CREATE TEMP TABLE _tmpLocation_by (LocationId Integer) ON COMMIT DROP;
        --
        INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
           SELECT 8425 AS LocationId -- ����� �� �.�������
                , zc_ContainerLinkObject_Unit()       AS DescId
                , tmpDesc.ContainerDescId
           FROM (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId) AS tmpDesc
          ;
    END IF;*/
    -- !!!��� �����!!!


    vbIsCLO_Member:= EXISTS (SELECT 1 FROM _tmpLocation WHERE DescId <> zc_ContainerLinkObject_Unit());


    IF inStartDate < inEndDate - INTERVAL '2 MONTH' AND inUserId NOT IN (5, 9459, 106594) AND COALESCE (inGoodsId, 0) = 0
    THEN
        RAISE EXCEPTION '������. �������� ������ �� ����� ���� ������ ��� 2 ���.';
    END IF;



    IF NOT EXISTS (SELECT 1 FROM _tmpLocation)
    THEN
        -- ������ ������������� ��� ������������� ��� ����� ����� (��, ����)
        IF inUnitGroupId <> 0 AND COALESCE (inLocationId, 0) = 0
        THEN
            INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
               SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
                    , zc_ContainerLinkObject_Unit()       AS DescId
                    , tmpDesc.ContainerDescId
               FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE inUserId = zfCalc_UserAdmin() :: Integer) AS tmpDesc ON 1 = 1
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
                        -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!�������� ��� �/�, ��� ��������!!!
                        LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE inUserId = zfCalc_UserAdmin() :: Integer) AS tmpDesc ON 1 = 1
                   WHERE Object.Id = inLocationId
                 /*UNION
                   SELECT lfSelect.UnitId               AS LocationId
                        , zc_ContainerLinkObject_Unit() AS DescId
                        , tmpDesc.ContainerDescId
                   FROM lfSelect_Object_Unit_byGroup (inLocationId) AS lfSelect
                        -- LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1 -- !!!�������� ��� �/�, ��� ��������!!!
                        LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId UNION SELECT zc_Container_Summ() AS ContainerDescId WHERE vbIsSummIn = TRUE) AS tmpDesc ON 1 = 1*/
                  ;
            END IF;
        END IF;
    END IF;


    -- ������������ - ���� �� ������ �� � ��� ��� � ���� �������
    IF inAccountGroupId = -1 * zc_Enum_AccountGroup_10000()
    THEN
        inAccountGroupId:= 0;
        vbIsAssetTo:= TRUE;
    ELSE
        vbIsAssetTo:= FALSE;
    END IF;
    -- !!!����� ��� ����� �������!!!
    inAccountGroupId:= COALESCE (inAccountGroupId, 0);

    -- !!!�������� ��������� ��� �������!!!
    IF 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = inUserId AND BranchId <> 0 GROUP BY BranchId)
    THEN
        inAccountGroupId:= zc_Enum_AccountGroup_20000(); -- ������
        inIsInfoMoney:= FALSE;
    END IF;


    -- ������� -
    CREATE TEMP TABLE _tmpListContainer (LocationId Integer, ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, GoodsId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpContainer (ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, LocationId Integer, CarId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsId Integer, AssetToId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;


    -- ������ ������� ��� ����� ��� ��� ������ �� ��������
    IF inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
    THEN
        WITH tmpGoods AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect)
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
                            THEN zc_Enum_AccountGroup_110000() -- �������
                       ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                  END AS AccountGroupId
                , Container.Amount
                , _tmpLocation.DescId    AS Value1_ch
                , CLO_Member.ContainerId AS Value2_ch
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
                LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = CASE WHEN vbIsCLO_Member = TRUE THEN Container.Id ELSE NULL END
                                                           AND CLO_Member.DescId = zc_ContainerLinkObject_Member()

                LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = ContainerLinkObject.ContainerId
                                                            AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = ContainerLinkObject.ContainerId
                                                                 AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
           WHERE (
                  (_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountId > 0)
               OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- �������
                                                                         OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- �������
                                                                          ))
                 )
             AND (((Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000()) AND vbIsAssetTo = TRUE)
               OR vbIsAssetTo = FALSE)
             -- AND ((ContainerLinkObject.DescId <> zc_ContainerLinkObject_Member() AND CLO_Member.ContainerId IS NULL)
             --  OR ContainerLinkObject.DescId = zc_ContainerLinkObject_Member())
          )

        -- ���������
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
                                   SELECT Container.Id FROM Container WHERE Container.ObjectId = inGoodsId AND Container.DescId = zc_Container_Count()
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
                                 THEN zc_Enum_AccountGroup_110000() -- �������
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId
                     , Container.Amount
                     , _tmpLocation.DescId    AS Value1_ch
                     , CLO_Member.ContainerId AS Value2_ch
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
                     LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = CASE WHEN vbIsCLO_Member = TRUE THEN Container.Id ELSE NULL END
                                                                AND CLO_Member.DescId = zc_ContainerLinkObject_Member()

                     LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = ContainerLinkObject.ContainerId
                                                                 AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = ContainerLinkObject.ContainerId
                                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                     LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                WHERE (
                       (_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountId > 0)
                    OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- �������
                                                                              OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- �������
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
             INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
                SELECT tmp.LocationId, tmp.ContainerDescId, tmp.ContainerId_count, tmp.ContainerId_begin, tmp.GoodsId, tmp.AccountId, tmp.AccountGroupId, tmp.Amount
                FROM
               (SELECT _tmpLocation.LocationId
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
                                 THEN zc_Enum_AccountGroup_110000() -- �������
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
                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                     LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                               AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                               AND _tmpLocation.ContainerDescId = zc_Container_Summ()
                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                                 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                     LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = CASE WHEN vbIsCLO_Member = TRUE THEN Container.Id ELSE NULL END
                                                                AND CLO_Member.DescId = zc_ContainerLinkObject_Member()

                     LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = ContainerLinkObject.ContainerId
                                                                 AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = ContainerLinkObject.ContainerId
                                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                     LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                WHERE ((_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountId > 0)
                    OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- �������
                                                                              OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- �������
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

    -- 1. �������� ����� <����> ��� zc_Container_Count
    UPDATE _tmpListContainer SET AccountId = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
         INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- ����������
         INNER JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = _tmpListContainer_summ.ContainerId_begin
                                                              AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                                              AND CLO_InfoMoneyDetail.ObjectId = View_InfoMoney.InfoMoneyId
         /*INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ChildObjectId = _tmpListContainer_summ.GoodsId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                              AND ObjectLink_Goods_InfoMoney.ObjectId = View_InfoMoney.InfoMoneyId*/
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId = zc_Container_Count()
      AND _tmpListContainer_summ.ContainerDescId = zc_Container_Summ()
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId = zc_Enum_AccountGroup_10000(); -- ����������� ������

    -- 2.1. �������� ����� <����> ��� zc_Container_Count
    UPDATE _tmpListContainer SET AccountId = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId = zc_Container_Count()
      AND _tmpListContainer_summ.ContainerDescId = zc_Container_Summ()
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId <> zc_Enum_AccountGroup_110000() -- �������
      AND _tmpListContainer_summ.Amount <> 0
   ;
    -- 2.2. �������� ����� <����> ��� zc_Container_Count
    UPDATE _tmpListContainer SET AccountId = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId = zc_Container_Count()
      AND _tmpListContainer_summ.ContainerDescId = zc_Container_Summ()
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId <> zc_Enum_AccountGroup_110000() -- �������
   ;

    -- ��� ContainerId
    INSERT INTO _tmpContainer (ContainerDescId, ContainerId_count, ContainerId_begin, LocationId, CarId, GoodsId, GoodsKindId, PartionGoodsId, AssetToId, AccountId, AccountGroupId, Amount)
       SELECT _tmpListContainer.ContainerDescId
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

    -- ���������
    RETURN QUERY
          WITH tmpMIContainer AS (SELECT _tmpContainer.ContainerDescId
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
                                                   THEN -1
                                              WHEN MIContainer.MovementDescId IN (zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                               AND inIsInfoMoney = FALSE
                                                   THEN MIContainer.ObjectExtId_Analyzer -- MIContainer.AnalyzerId
                                              ELSE 0
                                         END AS LocationId_by
                                       -- , 0 AS LocationId_by


                                         -- ***COUNT***
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset())
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountIncome
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- ���-��, �������� ��� ����������/����������� �� ����
                                                    -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 -- 
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_10500() -- ���-��, �����������, ����������� �� ����, ������ �� ���
                                                    --AND MIContainer.isActive = TRUE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPrice_10500
                                         , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_40200() -- ���-��, �����������, ����������� �� ����, ������� � ����
                                                    --AND MIContainer.isActive = TRUE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPrice_40200
                                              
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- ���-��, �������� ��� ����������/����������� �� ����
                                                    -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 -- 
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSendOnPriceOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- ���-��, ����������, � ����������
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- �������
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- ���-��, ����������, ������ �� ���
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- �������
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- ���-��, ����������, ������� � ����
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- �������
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSale_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- ���-��, ����������, � ����������
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- ���-��, ����������, ������ �� ���
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- ���-��, ����������, ������� � ����
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountSaleReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!����!!! + ���-��, �������, �� ����������
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- �������
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- ���-��, �������, ������� � ����
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- �������
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnIn_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!����!!! + ���-��, �������, �� ����������
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnInReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- ���-��, �������, ������� � ����
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountReturnInReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND (MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_Transport())
                                                         OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() -- ���-��, �������� ��� ����������/����������� �� ����
                                                        )
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountLoss
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountInventory
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountProductionIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountProductionOut

                                         -- ***SUMM***
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset())
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummIncome
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = TRUE
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MovementBoolean_HistoryCost.ValueData = TRUE
                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000() -- ������� ������� ��������
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- ����� �/�, �������� ��� ����������/����������� �� ����
                                                   -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 -- 
                                                       THEN MIContainer.Amount
                                                  WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = TRUE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000() -- ������� ������� ��������
                                                   -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 -- 
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- ����� �/�, �������� ��� ����������/����������� �� ����
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPriceIn

                                        , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_10500() -- ����� �/�, ����������� �� ����,  ������ �� ���
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPrice_10500

                                         , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                  --AND MIContainer.isActive = TRUE
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendSumm_40200()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPrice_40200
                                                                                          
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE
                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000() -- ������� ������� ��������
                                                   -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 -- 
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- ����� �/�, �������� ��� ����������/����������� �� ����
                                                       THEN -1 * MIContainer.Amount
                                                  WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = FALSE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000() -- ������� ������� ��������
                                                   -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 -- 
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- ����� �/�, �������� ��� ����������/����������� �� ����
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSendOnPriceOut

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- ����� �/�, ����������, � ����������
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- ����� �/�, ����������, ������ �� ���
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- ����� �/�, ����������, ������� � ����
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSale_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- ����� �/�, ����������, � ����������
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- ����� �/�, ����������, ������ �� ���
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal_10500
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- ����� �/�, ����������, ������� � ����
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummSaleReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- ����� �/�, �������, �� ����������
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- ����� �/�, �������, ������� � ����
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnIn_40208

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- ����� �/�, �������, �� ����������
                                                   -- AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnInReal
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- ����� �/�, �������, ������� � ����
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummReturnInReal_40208


                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND (MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_Transport())
                                                        OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200() -- ����� �/�, �������� ��� ����������/����������� �� ����
                                                       )
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummLoss

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() -- ������� ������� ��������
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummInventory

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000() -- ������� ������� ��������
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS SummInventory_RePrice

                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                  ELSE 0
                                              END) AS SummProductionIn
                                       , SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                              END) AS SummProductionOut

                                         -- ***REMAINS***
                                       , -1 * SUM (MIContainer.Amount) AS RemainsStart
                                       , 0                             AS RemainsEnd

                                  FROM _tmpContainer
                                       INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                                      AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                                                 ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                                       LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                                 ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                  GROUP BY _tmpContainer.ContainerDescId
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
                                                     THEN -1
                                                WHEN MIContainer.MovementDescId IN (zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                 AND inIsInfoMoney = FALSE
                                                     THEN MIContainer.ObjectExtId_Analyzer -- MIContainer.AnalyzerId
                                                ELSE 0
                                           END
                                  HAVING -- ***COUNT***
                                         SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset())
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountIncome
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Send()
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- ���-��, �������� ��� ����������/����������� �� ����
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOnPriceIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_10500() -- ���-��, �����������, ����������� �� ����, ������ �� ���
                                                    --AND MIContainer.isActive = TRUE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 --AS CountSendOnPrice_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendCount_40200() -- ���-��, �����������, ����������� �� ����, ������� � ����
                                                    --AND MIContainer.isActive = TRUE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 --AS CountSendOnPrice_40200

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossCount_20200() -- ���-��, �������� ��� ����������/����������� �� ����
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSendOnPriceOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- ���-��, ����������, � ����������
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- �������
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- ���-��, ����������, ������ �� ���
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- �������
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- ���-��, ����������, ������� � ����
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- �������
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSale_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() -- ���-��, ����������, � ����������
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() -- ���-��, ����������, ������ �� ���
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200() -- ���-��, ����������, ������� � ����
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountSaleReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!����!!! + ���-��, �������, �� ����������
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- �������
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- ���-��, �������, ������� � ����
                                                    -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE) -- �������
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnIn_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ReturnInCount_10800()) -- !!!����!!! + ���-��, �������, �� ����������
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnInReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                    AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() -- ���-��, �������, ������� � ����
                                                    AND MIContainer.ContainerId_Analyzer <> 0
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountReturnInReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND (MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_Transport())
                                                         OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossCount_20200() -- ���-��, �������� ��� ����������/����������� �� ����
                                                        )
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountLoss
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountInventory
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountProductionIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Count()
                                                    -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                    AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                    AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) <> 0 -- AS CountProductionOut

                                         -- ***SUMM***
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset())
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummIncome
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = TRUE
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MovementBoolean_HistoryCost.ValueData = TRUE
                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- ����� �/�, �������� ��� ����������/����������� �� ����
                                                       THEN MIContainer.Amount
                                                  WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = TRUE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- ����� �/�, �������� ��� ����������/����������� �� ����
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendOnPriceIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND COALESCE (MovementBoolean_HistoryCost.ValueData, FALSE) = FALSE
                                                   AND _tmpContainer.AccountGroupId = zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- ����� �/�, �������� ��� ����������/����������� �� ����
                                                       THEN -1 * MIContainer.Amount
                                                  WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.isActive = FALSE
                                                   AND _tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_60000()  --
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_LossSumm_20200() -- ����� �/�, �������� ��� ����������/����������� �� ����
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSendOnPriceOut

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- ����� �/�, ����������, � ����������
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSale
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- ����� �/�, ����������, ������ �� ���
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSale_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- ����� �/�, ����������, ������� � ����
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSale_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() -- ����� �/�, ����������, � ����������
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSaleReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- ����� �/�, ����������, ������ �� ���
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSaleReal_10500
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- ����� �/�, ����������, ������� � ����
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummSaleReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- ����� �/�, �������, �� ����������
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- ����� �/�, �������, ������� � ����
                                                   -- AND (_tmpContainer.AccountGroupId <> zc_Enum_AccountGroup_110000() OR inIsInfoMoney = TRUE)
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnIn_40208

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() -- ����� �/�, �������, �� ����������
                                                   -- AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnInReal
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() -- ����� �/�, �������, ������� � ����
                                                   AND MIContainer.ContainerId_Analyzer <> 0
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummReturnInReal_40208


                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND (MIContainer.MovementDescId IN (zc_Movement_Loss(), zc_Movement_Transport())
                                                        OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_LossSumm_20200() -- ����� �/�, �������� ��� ����������/����������� �� ����
                                                       )
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummLoss

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AccountGroup_60000() -- ������� ������� ��������
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummInventory

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AccountGroup_60000() -- ������� ������� ��������
                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0 -- AS SummInventory_RePrice

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                  ELSE 0
                                              END) <> 0 -- AS SummProductionIn
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   -- AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                                   AND MIContainer.isActive = FALSE
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                              END) <> 0 -- AS SummProductionOut
                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                   AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_10500() -- ����� �/�, ����������� �� ����,  ������ �� ���
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END)  <> 0  -- AS SummSendOnPrice_10500

                                      OR SUM (CASE WHEN _tmpContainer.ContainerDescId = zc_Container_Summ()
                                                   AND MIContainer.MovementDescId = zc_Movement_SendOnPrice()
                                                  --AND MIContainer.isActive = TRUE
                                                   AND COALESCE (MIContainer.AnalyzerId, 0) = zc_Enum_AnalyzerId_SendSumm_40200()
                                                       THEN -1 * MIContainer.Amount
                                                  ELSE 0
                                             END) <> 0  -- AS SummSendOnPrice_40200
                                             
                                         -- ***REMAINS***
                                      OR SUM (MIContainer.Amount) <> 0 -- AS RemainsStart

                                 UNION ALL
                                  SELECT _tmpContainer.ContainerDescId
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
                                       , 0 AS SummInventory_RePrice

                                       , 0 AS SummProductionIn
                                       , 0 AS SummProductionOut
                                       
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
                                         , _tmpContainer.CarId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.GoodsKindId
                                         , _tmpContainer.PartionGoodsId
                                         , _tmpContainer.AssetToId
                                         , _tmpContainer.AccountId
                                         , _tmpContainer.AccountGroupId
                                         , _tmpContainer.Amount
                                  HAVING _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                 )

         -- ���������
         SELECT (tmpMIContainer_all.AccountId)       AS AccountId
              , tmpMIContainer_all.ContainerId_count AS ContainerId_count
              , tmpMIContainer_all.ContainerId_begin AS ContainerId
              , tmpMIContainer_all.LocationId
              , tmpMIContainer_all.CarId
              , tmpMIContainer_all.GoodsId
              , tmpMIContainer_all.GoodsKindId
              , tmpMIContainer_all.PartionGoodsId
              , tmpMIContainer_all.AssetToId

              , tmpMIContainer_all.LocationId_by

              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsStart ELSE 0 END) :: TFloat AS CountStart
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsEnd   ELSE 0 END) :: TFloat AS CountEnd
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Count() THEN tmpMIContainer_all.RemainsEnd - tmpMIContainer_all.CountInventory ELSE 0 END) :: TFloat AS CountEnd_calc

              , SUM (tmpMIContainer_all.CountIncome)             :: TFloat AS CountIncome
              , SUM (tmpMIContainer_all.CountReturnOut)          :: TFloat AS CountReturnOut

              , SUM (tmpMIContainer_all.CountSendIn)             :: TFloat AS CountSendIn
              , SUM (tmpMIContainer_all.CountSendOut)            :: TFloat AS CountSendOut

              , SUM (tmpMIContainer_all.CountSendOnPriceIn)      :: TFloat AS CountSendOnPriceIn
              , SUM (tmpMIContainer_all.CountSendOnPriceOut)     :: TFloat AS CountSendOnPriceOut

              , SUM (tmpMIContainer_all.CountSendOnPrice_10500)      :: TFloat AS CountSendOnPrice_10500
              , SUM (tmpMIContainer_all.CountSendOnPrice_40200)      :: TFloat AS CountSendOnPrice_40200
              
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

              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Summ() THEN tmpMIContainer_all.RemainsStart ELSE 0 END) :: TFloat AS SummStart
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Summ() THEN tmpMIContainer_all.RemainsEnd   ELSE 0 END) :: TFloat AS SummEnd
              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId = zc_Container_Summ() THEN tmpMIContainer_all.RemainsEnd - tmpMIContainer_all.SummInventory ELSE 0 END) :: TFloat AS SummEnd_calc

              , SUM (tmpMIContainer_all.SummIncome)              :: TFloat AS SummIncome
              , SUM (tmpMIContainer_all.SummReturnOut)           :: TFloat AS SummReturnOut
              , SUM (tmpMIContainer_all.SummSendIn)              :: TFloat AS SummSendIn
              , SUM (tmpMIContainer_all.SummSendOut)             :: TFloat AS SummSendOut
              , SUM (tmpMIContainer_all.SummSendOnPriceIn)       :: TFloat AS SummSendOnPriceIn
              , SUM (tmpMIContainer_all.SummSendOnPriceOut)      :: TFloat AS SummSendOnPriceOut

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
              , SUM (tmpMIContainer_all.SummInventory_RePrice)   :: TFloat AS SummInventory_RePrice
              , SUM (tmpMIContainer_all.SummProductionIn)        :: TFloat AS SummProductionIn
              , SUM (tmpMIContainer_all.SummProductionOut)       :: TFloat AS SummProductionOut

         FROM tmpMIContainer AS tmpMIContainer_all
         GROUP BY tmpMIContainer_all.AccountId 
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

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpReport_MotionGoods (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
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

-- ����
-- SELECT * FROM lpReport_MotionGoods (inStartDate:= '01.08.2018', inEndDate:= '31.08.2018', inAccountGroupId:= 9015, inUnitGroupId := 0 , inLocationId := 8425 , inGoodsGroupId := 0 , inGoodsId := 0,  inIsInfoMoney:= FALSE, inUserId := zfCalc_UserAdmin() :: Integer);
