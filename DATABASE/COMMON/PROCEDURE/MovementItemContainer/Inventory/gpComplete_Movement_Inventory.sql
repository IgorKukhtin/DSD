-- Function: gpComplete_Movement_Inventory()

DROP FUNCTION IF EXISTS gpComplete_Movement_Inventory  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Inventory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
 RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbMovementDescId Integer;

  DECLARE vbWhereObjectId_Analyzer Integer;

  DECLARE vbIsGoodsGroup Boolean;

  DECLARE vbStatusId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbUnitId Integer;
  DECLARE vbCarId Integer;
  DECLARE vbMemberId Integer;
  DECLARE vbBranchId Integer;
  DECLARE vbAccountDirectionId Integer;
  DECLARE vbIsPartionDate_Unit Boolean;
  DECLARE vbJuridicalId_Basis Integer;
  DECLARE vbBusinessId Integer;
  DECLARE vbUnitId_Car Integer;

  DECLARE vbPriceListId Integer;

  DECLARE vbProfitLossGroupId Integer;
  DECLARE vbProfitLossDirectionId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF inSession = zc_Enum_Process_Auto_PrimeCost() :: TVarChar
     THEN vbUserId:= inSession :: Integer;
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Inventory());
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Inventory_CreateTemp();


     -- ��� ��������� ����� ��� ������� �������
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Car() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS CarId
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS MemberId
          , COALESCE (ObjectLink_ObjectFrom_Branch.ChildObjectId, 0) AS BranchId
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()
                                THEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId
                           WHEN Object_From.DescId = zc_Object_Car()
                                THEN zc_Enum_AccountDirection_20500() -- "������"; 20500; "���������� (��)"
                           WHEN Object_From.DescId = zc_Object_Member()
                                THEN zc_Enum_AccountDirection_20500() -- "������"; 20500; "���������� (��)"
                      END, 0) AS AccountDirectionId -- !!!�� ������������� ��������, �.�. ��� ����� �������� �� InfoMoneyDestinationId (������)!!!
          , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE)  AS isPartionDate_Unit
          , COALESCE (ObjectLink_ObjectFrom_Juridical.ChildObjectId, zc_Juridical_Basis()) AS JuridicalId_Basis
          , COALESCE (ObjectLink_ObjectFrom_Business.ChildObjectId, 0)  AS BusinessId

          , COALESCE (ObjectLink_CarFrom_Unit.ChildObjectId, 0) AS UnitId_Car

          , CASE WHEN COALESCE (ObjectLink_ObjectFrom_Branch.ChildObjectId, zc_Branch_Basis()) <> zc_Branch_Basis()
                  AND Object_From.DescId = zc_Object_Unit()
                      THEN COALESCE (MovementLinkObject_PriceList.ObjectId, zc_PriceList_Basis())
                 ELSE 0
            END AS PriceListId

            INTO vbMovementDescId, vbStatusId, vbOperDate
               , vbUnitId, vbCarId, vbMemberId, vbBranchId, vbAccountDirectionId, vbIsPartionDate_Unit, vbJuridicalId_Basis, vbBusinessId
               , vbUnitId_Car
               , vbPriceListId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                       ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                      AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()

          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                               ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_From
                                  ON ObjectBoolean_PartionDate_From.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_PartionDate_From.DescId = zc_ObjectBoolean_Unit_PartionDate()
                                 AND Object_From.DescId = zc_Object_Unit()

          LEFT JOIN ObjectLink AS ObjectLink_CarFrom_Unit
                               ON ObjectLink_CarFrom_Unit.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_CarFrom_Unit.DescId = zc_ObjectLink_Car_Unit()
                              AND Object_From.DescId = zc_Object_Car()

          LEFT JOIN ObjectLink AS ObjectLink_ObjectFrom_Branch
                               ON ObjectLink_ObjectFrom_Branch.ObjectId = COALESCE (ObjectLink_CarFrom_Unit.ChildObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_ObjectFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
          LEFT JOIN ObjectLink AS ObjectLink_ObjectFrom_Juridical
                               ON ObjectLink_ObjectFrom_Juridical.ObjectId = COALESCE (ObjectLink_CarFrom_Unit.ChildObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_ObjectFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_ObjectFrom_Business
                               ON ObjectLink_ObjectFrom_Business.ObjectId = COALESCE (ObjectLink_CarFrom_Unit.ChildObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_ObjectFrom_Business.DescId = zc_ObjectLink_Unit_Business()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_Inventory()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- !!!���� �������� �������� - �����!!!
     IF vbStatusId = zc_Enum_Status_Complete() THEN RETURN; END IF;
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- !!!����������� �� �������!!!
     IF EXISTS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup WHERE UnitId = vbUnitId) -- ��� �������+���-��
       AND 1 <> EXTRACT (DAY FROM (vbOperDate :: Date + 1))
     THEN
         vbIsGoodsGroup:= TRUE;
         -- 
         INSERT INTO _tmpGoods_Complete_Inventory (GoodsId)
            SELECT GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (1945) -- ��-�����
           UNION
            SELECT GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (1942) -- ��-��������
           ;
     ELSE
         vbIsGoodsGroup:= FALSE;
     END IF;


     -- ������������ ��������� ��� �������� �� �������
     IF EXISTS (SELECT 1
                FROM (SELECT (lfGet_Object_Unit_byProfitLossDirection (tmpUnit.UnitId)).ProfitLossGroupId AS ProfitLossGroupId
                      FROM (SELECT vbUnitId AS UnitId WHERE vbUnitId <> 0 UNION ALL SELECT vbUnitId_Car AS UnitId WHERE vbUnitId_Car <> 0 -- UNION ALL SELECT vbUnitId_Personal AS UnitId WHERE vbUnitId_Personal <> 0
                           ) AS tmpUnit
                     ) AS tmp
                WHERE tmp.ProfitLossGroupId = zc_Enum_ProfitLossGroup_40000()) -- 40000; "������� �� ����"
     THEN
         -- ����� ��� ����������/������������� (�� �������)
         vbProfitLossGroupId := zc_Enum_ProfitLossGroup_40000(); -- ������� �� ����
         vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_40400(); -- ������ ������ (��������+��������������)
     ELSE
         -- ����� ��� ����������/����������/������������� (�� ������)
         vbProfitLossGroupId := zc_Enum_ProfitLossGroup_20000(); -- �������������������� �������
         IF vbMemberId = 0
         THEN vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_20500(); -- ������ ������ (��������+��������������)
         ELSE
         --
         IF vbOperDate < '01.07.2015' -- !!!�������� ��� ���������� ����!!!
            OR inMovementId = 2184096 -- ������ �������� - 31.07.2015
         THEN vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_20500(); -- ������ ������ (��������+��������������)
         --
         IF vbOperDate <= '01.06.2014' -- !!!�������� ��� ������� ����!!!
         THEN vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_20500(); -- ������ ������ (��������+��������������)
         ELSE IF vbOperDate <= '01.04.2015' -- !!!�������� ��� ������� ����!!!
              THEN vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_20100(); -- ���������� ������������
              ELSE vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_20500(); -- ������ ������ (��������+��������������)
         END IF;
         END IF;
         END IF;
         END IF;
     END IF;


     -- ��������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperSumm
                         , InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId
                         , UnitId_Item, StorageId_Item, UnitId_Partion, Price_Partion
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId)
        SELECT (_tmp.MovementItemId) AS MovementItemId

             , (_tmp.ContainerId) AS ContainerId_Goods -- !!!
             , _tmp.GoodsId
             , _tmp.GoodsKindId
             , CASE WHEN _tmp.GoodsKindId <> zc_GoodsKind_WorkProgress() THEN NULL ELSE _tmp.GoodsKindId_complete END
             , _tmp.AssetId
             , _tmp.PartionGoods
             , _tmp.PartionGoodsDate

             , (_tmp.OperCount)
             , (_tmp.OperSumm)

               -- �������������� ����������
             , _tmp.InfoMoneyDestinationId
               -- ������ ����������
             , _tmp.InfoMoneyId

               -- �������� ������ !!!����������!!! �� 1)���������� ��� 2)������ ��� 3)����������/������������
             , CASE WHEN _tmp.BusinessId = 0 THEN vbBusinessId ELSE _tmp.BusinessId END AS BusinessId

             , _tmp.UnitId_Item
             , _tmp.StorageId_Item
               -- !!!�������� ��� ������� ����!!!
             , CASE WHEN vbMemberId <> 0 THEN vbMemberId ELSE 0 END AS UnitId_Partion
             , (_tmp.Price_Partion)

             , _tmp.isPartionCount
             , _tmp.isPartionSumm 
               -- ������ ������, ���������� �����
             , 0 AS PartionGoodsId
        FROM 
             (SELECT MovementItem.Id AS MovementItemId

                   , COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, MovementItem.ObjectId, 0) AS GoodsId
                   , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ELSE 0 END AS GoodsKindId -- ���� + ������� ���������
                   , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_complete

                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , COALESCE (MILinkObject_Unit.ObjectId, 0) AS UnitId_Item
                   , COALESCE (MILinkObject_Storage.ObjectId, 0) AS StorageId_Item
                   , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

                   , COALESCE (MIFloat_ContainerId.ValueData, 0) AS ContainerId

                   , MovementItem.Amount AS OperCount
                   , CASE WHEN vbOperDate = '30.06.2015' AND MovementItem.Amount <> 0 THEN CAST (COALESCE (MIFloat_Summ.ValueData, 0) / MovementItem.Amount AS NUMERIC (16, 4)) ELSE COALESCE (MIFloat_Price.ValueData, 0) END AS Price_Partion
                   , COALESCE (MIFloat_Summ.ValueData, 0) AS OperSumm

                     -- �������������� ����������
                  , CASE WHEN Object.DescId = zc_Object_Fuel() THEN COALESCE (View_InfoMoney_Fuel.InfoMoneyDestinationId, 0)
                         ELSE COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0)
                    END AS InfoMoneyDestinationId
                     -- ������ ����������
                  , CASE WHEN Object.DescId = zc_Object_Fuel() THEN COALESCE (View_InfoMoney_Fuel.InfoMoneyId, 0)
                         ELSE COALESCE (View_InfoMoney.InfoMoneyId, 0)
                    END AS InfoMoneyId

                    -- ������ �� ������ ����� ������ ���� �� <��� �������>
                  , CASE WHEN Object.DescId = zc_Object_Fuel() THEN 0
                         ELSE COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0)
                    END AS BusinessId

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                   LEFT JOIN _tmpGoods_Complete_Inventory ON _tmpGoods_Complete_Inventory.GoodsId = MovementItem.ObjectId

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                        ON ObjectLink_Goods_Fuel.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                                       AND vbCarId <> 0
                   LEFT JOIN Object ON Object.Id = COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, MovementItem.ObjectId)

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                    ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                    ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                                    ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()

                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                               ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                              AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                   LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                               ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                              AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                           ON ObjectBoolean_PartionCount.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                           ON ObjectBoolean_PartionSumm.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                        ON ObjectLink_Goods_Business.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                    AND Object.DescId <> zc_Object_Fuel()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Fuel ON View_InfoMoney_Fuel.InfoMoneyId = zc_Enum_InfoMoney_20401()
                                                                         AND Object.DescId = zc_Object_Fuel()
              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Inventory()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                AND (_tmpGoods_Complete_Inventory.GoodsId > 0 OR vbIsGoodsGroup = FALSE)
             ) AS _tmp
              ;

     -- ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                AND vbAccountDirectionId = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                               WHEN vbIsPartionDate_Unit = TRUE
                                                AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ������������� + ����
                                                                                      , zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                      , zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                                    THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem.PartionGoodsDate
                                                                                         , inGoodsKindId_complete := _tmpItem.GoodsKindId_complete
                                                                                          )
                                               WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ������������� + ����
                                                                                      , zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                      , zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                                    THEN 0

                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                 OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                 OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                   THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= CASE WHEN vbMemberId <> 0 THEN _tmpItem.UnitId_Partion ELSE NULL END
                                                                                        , inGoodsId       := CASE WHEN vbMemberId <> 0 THEN _tmpItem.GoodsId ELSE NULL END
                                                                                        , inStorageId     := CASE WHEN vbMemberId <> 0 THEN _tmpItem.StorageId_Item ELSE NULL END
                                                                                        , inInvNumber     := CASE WHEN vbMemberId <> 0 THEN _tmpItem.PartionGoods ELSE NULL END
                                                                                        , inOperDate      := CASE WHEN vbMemberId <> 0 THEN _tmpItem.PartionGoodsDate ELSE NULL END
                                                                                        , inPrice         := CASE WHEN vbMemberId <> 0 THEN _tmpItem.Price_Partion ELSE NULL END
                                                                                         )
                                               ELSE lpInsertFind_Object_PartionGoods ('')
                                          END
     WHERE _tmpItem.ContainerId_Goods = 0 -- !!!
      AND (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
          )
     ;

     -- ����������
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId WHEN vbMemberId <> 0 THEN vbMemberId WHEN vbCarId <> 0 THEN vbCarId END;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := CASE WHEN vbMemberId <> 0 THEN _tmpItem.UnitId_Item ELSE vbUnitId END
                                                                                , inCarId                  := vbCarId
                                                                                , inMemberId               := vbMemberId
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
     WHERE _tmpItem.ContainerId_Goods = 0;
                                             
     -- ��������� ������� - �������������� ��������� ������� �� ����� vbOperDate, � ������� ����� MovementItemId (��� �� ��������� ������� ������� � �����������), �.�. ���� � ��� �� ����� ����� ���� ������ ��������� ��� �� ������������� � MAX (_tmpItem.MovementItemId)
     INSERT INTO _tmpRemainsCount (MovementItemId, ContainerId_Goods, GoodsId, OperCount)
        SELECT COALESCE (tmpMI_find.MovementItemId, 0) AS MovementItemId
             , tmpContainer.ContainerId_Goods
             , tmpContainer.GoodsId
             , tmpContainer.OperCount
        FROM (SELECT tmpContainerLinkObject_From.ContainerId AS ContainerId_Goods
                   , Container.ObjectId AS GoodsId
                   , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS OperCount
              FROM (SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId =  vbUnitId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit() AND vbUnitId <> 0
                   UNION
                    SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId =  vbMemberId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Member() AND vbMemberId <> 0
                   UNION
                    SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId =  vbCarId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Car() AND vbCarId <> 0
                   ) AS tmpContainerLinkObject_From
                   -- !!!����������� JOIN, ��� � "������������" ������ �������� ��������!!!
                   JOIN Container ON Container.Id = tmpContainerLinkObject_From.ContainerId
                                 AND Container.DescId = zc_Container_Count()
                   LEFT JOIN ContainerLinkObject AS CLO_Account
                                                 ON CLO_Account.ContainerId = Container.Id
                                                AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                   LEFT JOIN _tmpGoods_Complete_Inventory ON _tmpGoods_Complete_Inventory.GoodsId = Container.ObjectId
                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.Containerid = Container.Id
                                                  AND MIContainer.OperDate > vbOperDate
              WHERE CLO_Account.ContainerId IS NULL -- !!!�.�. ��� ����� �������!!!
               AND (_tmpGoods_Complete_Inventory.GoodsId > 0 OR vbIsGoodsGroup = FALSE)
              GROUP BY tmpContainerLinkObject_From.ContainerId
                     , Container.ObjectId
                     , Container.Amount
              HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
             ) AS tmpContainer
             LEFT JOIN (SELECT MAX (_tmpItem.MovementItemId) AS MovementItemId, _tmpItem.ContainerId_Goods FROM _tmpItem GROUP BY _tmpItem.ContainerId_Goods
                       ) AS tmpMI_find ON tmpMI_find.ContainerId_Goods = tmpContainer.ContainerId_Goods
     ;

     -- ��������� ������� - �������� ��������� ������� �� ����� vbOperDate (ContainerId_Goods - ������ � ������� �������� ��������)
     INSERT INTO _tmpRemainsSumm (ContainerId_Goods, ContainerId, AccountId, GoodsId, OperSumm)
        SELECT tmpContainer.ContainerId_Goods
             , tmpContainer.ContainerId
             , tmpContainer.AccountId
             , Container_Count.ObjectId
             , tmpContainer.OperSumm
        FROM (SELECT tmpContainerLinkObject_From.ContainerId
                   , Container.ObjectId AS AccountId
                   , Container.ParentId AS ContainerId_Goods
                   , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS OperSumm
              FROM (SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId =  vbUnitId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit() AND vbUnitId <> 0
                   UNION
                    SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId =  vbMemberId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Member() AND vbMemberId <> 0
                   UNION
                    SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId =  vbCarId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Car() AND vbCarId <> 0
                   ) AS tmpContainerLinkObject_From
                   -- !!!����������� JOIN and ParentId, ��� � "������������" ������ �������� ��������!!!
                   JOIN Container ON Container.Id = tmpContainerLinkObject_From.ContainerId
                                 AND Container.DescId = zc_Container_Summ()
                                 AND Container.ParentId IS NOT NULL
                   JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container.ObjectId
                                                           AND View_Account.AccountGroupId <> zc_Enum_AccountGroup_110000() -- !!!�.�. ��� ����� �������!!!
                   INNER JOIN ContainerLinkObject AS CLO_Goods
                                                  ON CLO_Goods.ContainerId = Container.Id
                                                 AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                   LEFT JOIN _tmpGoods_Complete_Inventory ON _tmpGoods_Complete_Inventory.GoodsId = CLO_Goods.ObjectId
                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.Containerid = Container.Id
                                                  AND MIContainer.OperDate > vbOperDate
              WHERE (_tmpGoods_Complete_Inventory.GoodsId > 0 OR vbIsGoodsGroup = FALSE)
              GROUP BY tmpContainerLinkObject_From.ContainerId
                     , Container.ObjectId
                     , Container.ParentId
                     , Container.Amount
              HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
             ) AS tmpContainer
             LEFT JOIN Container AS Container_Count ON Container_Count.Id = tmpContainer.ContainerId_Goods
     ;

     -- ��������� �� �������� ��������� ������� � �������������� ��������� ������� �� ������ ������� ���, � ������� ����� MovementItemId (��� �� ��������� ������� ������� � �����������)
     INSERT INTO _tmpRemainsCount (MovementItemId, ContainerId_Goods, GoodsId, OperCount)
        SELECT COALESCE (tmpMI_find.MovementItemId, 0) AS MovementItemId
             , _tmpRemainsSumm.ContainerId_Goods
             , _tmpRemainsSumm.GoodsId
             , 0 AS OperCount
        FROM _tmpRemainsSumm
             LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
             LEFT JOIN (SELECT MAX (_tmpItem.MovementItemId) AS MovementItemId, _tmpItem.ContainerId_Goods FROM _tmpItem GROUP BY _tmpItem.ContainerId_Goods
                       ) AS tmpMI_find ON tmpMI_find.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
        WHERE _tmpRemainsCount.ContainerId_Goods IS NULL
        GROUP BY tmpMI_find.MovementItemId
               , _tmpRemainsSumm.ContainerId_Goods
               , _tmpRemainsSumm.GoodsId;

     -- ��������� ����� �������� ��������� (MovementItem) ��� ��� �������, �� ������� ���� ��������� ������� �� ��� �� ������� � �������� (ContainerId_Goods=0, ������ �� ��������� ������� = 0 � ��� �� ���������)
     UPDATE _tmpRemainsCount SET MovementItemId = lpInsertUpdate_MovementItem (ioId         := 0
                                                                             , inDescId     := zc_MI_Master()
                                                                             , inObjectId   := _tmpRemainsCount.GoodsId
                                                                             , inMovementId := inMovementId
                                                                             , inAmount     := 0
                                                                             , inParentId   := NULL
                                                                              )
     WHERE _tmpRemainsCount.MovementItemId = 0;

     -- ��������� � ������ ��� �������� �� ������, ������� ������ ��� ���� ��������� � �������� ����� (MovementItem), ������ !!!���!!! �������� ��� �������� �������� (�.�. ��� �� �����)
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperSumm
                         , InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId
                         , UnitId_Item, StorageId_Item, UnitId_Partion, Price_Partion
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId)
        SELECT _tmpRemainsCount.MovementItemId
             , _tmpRemainsCount.ContainerId_Goods
             , _tmpRemainsCount.GoodsId
             , ContainerLinkObject_GoodsKind.ObjectId AS GoodsKindId
             , 0 AS GoodsKindId_complete
             , ContainerLinkObject_AssetTo.ObjectId AS AssetId
             , '' AS PartionGoods
             , zc_DateEnd() AS PartionGoodsDate
             , 0 AS OperCount
             , 0 AS OperSumm
               -- �������������� ����������
             , CASE WHEN Object.DescId = zc_Object_Fuel() THEN COALESCE (View_InfoMoney_Fuel.InfoMoneyDestinationId, 0)
                    ELSE COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0)
               END AS InfoMoneyDestinationId
               -- ������ ����������
             , CASE WHEN Object.DescId = zc_Object_Fuel() THEN COALESCE (View_InfoMoney_Fuel.InfoMoneyId, 0)
                    ELSE COALESCE (View_InfoMoney.InfoMoneyId, 0)
               END AS InfoMoneyId
             , 0 AS BusinessId
             , 0 AS UnitId_Item, 0 AS StorageId_Item, 0 AS UnitId_Partion, 0 AS Price_Partion
             , FALSE AS isPartionCount -- ��� ��������� ����� ��� �� �����, �.�. ��� ���� ContainerId_Goods
             , FALSE AS isPartionSumm  -- ��� ��������� ����� ��� �� �����, �.�. ��� ���� ContainerId_Goods
             , ContainerLinkObject_PartionGoods.ObjectId AS PartionGoodsId
        FROM _tmpRemainsCount
             LEFT JOIN _tmpItem ON _tmpItem.ContainerId_Goods = _tmpRemainsCount.ContainerId_Goods
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                           ON ContainerLinkObject_GoodsKind.ContainerId = _tmpRemainsCount.ContainerId_Goods
                                          AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PartionGoods
                                           ON ContainerLinkObject_PartionGoods.ContainerId = _tmpRemainsCount.ContainerId_Goods
                                          AND ContainerLinkObject_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_AssetTo
                                           ON ContainerLinkObject_AssetTo.ContainerId = _tmpRemainsCount.ContainerId_Goods
                                          AND ContainerLinkObject_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                  ON ObjectLink_Goods_Fuel.ObjectId = _tmpRemainsCount.GoodsId
                                 AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                                 AND vbCarId <> 0
             LEFT JOIN Object ON Object.Id = COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, _tmpRemainsCount.GoodsId)

             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Fuel ON View_InfoMoney_Fuel.InfoMoneyId = zc_Enum_InfoMoney_20401()
                                                                   AND Object.DescId = zc_Object_Fuel()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = _tmpRemainsCount.GoodsId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                 AND Object.DescId <> zc_Object_Fuel()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

        WHERE _tmpItem.ContainerId_Goods IS NULL;

     -- ��������
     IF 1 = 0 AND EXISTS (SELECT 1 FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION '������.������� ��� ������ ������ <%> <%> <%> <%> �� ��������.<%>', lfGet_Object_ValueData ((SELECT GoodsId FROM _tmpItem WHERE ContainerId_Goods = (SELECT ContainerId_Goods FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1) LIMIT 1))
                                                                                           , lfGet_Object_ValueData ((SELECT GoodsKindId FROM _tmpItem WHERE ContainerId_Goods = (SELECT ContainerId_Goods FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1) LIMIT 1))
                                                                                           , lfGet_Object_ValueData ((SELECT GoodsKindId_complete FROM _tmpItem WHERE ContainerId_Goods = (SELECT ContainerId_Goods FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1) LIMIT 1))
                                                                                           , lfGet_Object_ValueData ((SELECT PartionGoodsId FROM _tmpItem WHERE ContainerId_Goods = (SELECT ContainerId_Goods FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1) LIMIT 1))
                                                                                           , (SELECT ContainerId_Goods FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1)
                                                                                            ;
     END IF;

     -- ����������� �������� ��� ��������������� ����� !!!������!!! ���� ���� ������� �� �������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS AccountId              -- ��� �����
            , 0                                       AS AnalyzerId             -- ��� ���������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer   -- !!!���!!!
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , 0                                       AS ObjectExtId_Analyzer   -- !!!���!!!
            , 0                                       AS ParentId
            , _tmpItem.OperCount - COALESCE (_tmpRemainsCount.OperCount, 0)
            , vbOperDate
            , TRUE
       FROM _tmpItem
            LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.MovementItemId = _tmpItem.MovementItemId
       WHERE (_tmpItem.OperCount - COALESCE (_tmpRemainsCount.OperCount, 0)) <> 0;



     -- 3. Start

     -- 3.1. ��������� ������� - �������� �������� ���������, !!!���!!! ������� ��� ������������ �������� � ��������� (���� ContainerId=0 ����� ������� �� �� _tmpItem)
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_ProfitLoss, ContainerId, AccountId, OperSumm)
        WITH tmp_all AS 
       (SELECT _tmp.MovementItemId
             , _tmp.ContainerId
             , _tmp.AccountId
             , SUM (_tmp.OperSumm) AS OperSumm
        FROM  -- 1.1. ��� ��������� �������
             (SELECT _tmpItem.MovementItemId
                   , CASE WHEN vbPriceListId <> 0 AND View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() /*AND vbOperDate = '30.06.2015'*/ -- ������� ������� �������� + �� ��������
                               THEN 0 -- !!!���� ��� ����������� ������!!
                          ELSE COALESCE (Container_Summ.Id, 0)
                     END AS ContainerId
                   , CASE WHEN vbPriceListId <> 0 AND View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() /*AND vbOperDate = '30.06.2015'*/ -- ������� ������� �������� + �� ��������
                               THEN 0 -- !!!���� ��� ����������� ������!!
                          ELSE COALESCE (Container_Summ.ObjectId, 0)
                     END  AS AccountId
                     -- ������� �� ����� ������ ���� ��������� ���� ���, � ����� ������������� �� HistoryCost
                   -- , CASE WHEN vbOperDate <= '01.06.2014' THEN _tmpItem.OperSumm ELSE _tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) END AS OperSumm
                   , CASE WHEN vbPriceListId <> 0 AND View_Account.AccountDirectionId = zc_Enum_AccountDirection_60200() /*AND vbOperDate = '30.06.2015'*/ -- ������� ������� �������� + �� ��������
                               THEN 0 -- !!!���� ��� ����������� ������!!
                          WHEN vbOperDate IN ('31.05.2014', '31.05.2015', '30.06.2015') AND vbPriceListId = 0 
                               THEN _tmpItem.OperSumm
                          WHEN inMovementId = 2184096 -- ������ �������� - 31.07.2015
                               THEN _tmpItem.OperSumm
                          ELSE CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                     END AS OperSumm
              FROM _tmpItem
                   LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpItem.ContainerId_Goods
                   LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                        AND Container_Summ.DescId = zc_Container_Summ()
                                                        AND (vbOperDate >= '01.07.2015' OR vbPriceListId <> 0) 
                                                        AND inMovementId <> 2184096 -- ������ �������� - 31.07.2015
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container_Summ.ObjectId
             UNION ALL
              -- 1.2. ��� ��������� ������� (�� ���� �������) - !!!��� ������� + "����" ���� ����� '01.07.2015'!!!
              SELECT _tmpRemainsCount.MovementItemId
                   , COALESCE (Container_Summ.Id, 0) AS ContainerId
                   , COALESCE (Container_Summ.ObjectId, 0) AS AccountId
                   , -1 * CASE WHEN vbOperDate <= '01.06.2014' THEN 0 ELSE CAST (_tmpRemainsCount.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)) END AS OperSumm
              FROM _tmpRemainsCount
                   LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpRemainsCount.ContainerId_Goods
                                                        AND Container_Summ.DescId = zc_Container_Summ()
                                                        AND vbOperDate >= '01.06.2014'
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
              WHERE (vbPriceListId = 0 AND vbOperDate >= '01.07.2015')
                 AND inMovementId <> 2184096 -- ������ �������� - 31.07.2015
                 AND vbUnitId NOT IN (301309 -- ����� �� �.���������
                                    , 309599 -- ����� ��������� �.���������
                                    , 346093 -- ����� �� �.������
                                    , 346094 -- ����� ��������� �.������
                                     )
             UNION ALL
              -- 2.2. ��� ��������� ������� (�� ���� �������) -- !!!��� "�����" ���� �� '01.07.2015'!!!!
               SELECT _tmpRemainsCount.MovementItemId
                   , _tmpRemainsSumm.ContainerId
                   , _tmpRemainsSumm.AccountId
                   , -1 * _tmpRemainsSumm.OperSumm AS OperSumm
              FROM _tmpRemainsSumm
                   LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
              WHERE (vbPriceListId = 0 AND vbOperDate < '01.07.2015')
                 OR inMovementId = 2184096 -- ������ �������� - 31.07.2015
                 OR (vbPriceListId <> 0)
                     /*AND vbUnitId NOT IN (301309 -- ����� �� �.���������
                                        , 309599 -- ����� ��������� �.���������
                                        , 346093 -- ����� �� �.������
                                        , 346094 -- ����� ��������� �.������
                                         )*/

             UNION ALL
              -- ��� ��������� ������� (�� ���� �������) - !!!
              SELECT _tmpRemainsCount.MovementItemId
                   , 0 AS ContainerId
                   , 0 AS AccountId
                   , CASE WHEN View_Account.AccountDirectionId = zc_Enum_AccountDirection_60200() 
                               THEN 0 * CAST (_tmpRemainsCount.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                          ELSE -1 * CAST (_tmpRemainsCount.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                     END AS OperSumm
              FROM _tmpRemainsCount
                   LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpRemainsCount.ContainerId_Goods
                                                        AND Container_Summ.DescId = zc_Container_Summ()
                                                        AND vbOperDate >= '01.06.2014'
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container_Summ.ObjectId
              WHERE vbUnitId IN (301309 -- ����� �� �.���������
                               , 309599 -- ����� ��������� �.���������
                               , 346093 -- ����� �� �.������
                               , 346094 -- ����� ��������� �.������
                                )
             UNION ALL
              -- ��� ��������� ������� (�� ���� �������) -- !!!
               SELECT _tmpRemainsCount.MovementItemId
                   , 0 AS ContainerId
                   , 0 AS AccountId
                   , CASE WHEN View_Account.AccountDirectionId = zc_Enum_AccountDirection_60200() 
                               THEN 0 * _tmpRemainsSumm.OperSumm
                          ELSE 1 * _tmpRemainsSumm.OperSumm
                     END AS OperSumm
              FROM _tmpRemainsSumm
                   LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = _tmpRemainsSumm.AccountId
              WHERE vbUnitId IN (301309 -- ����� �� �.���������
                               , 309599 -- ����� ��������� �.���������
                               , 346093 -- ����� �� �.������
                               , 346094 -- ����� ��������� �.������
                                )
             ) AS _tmp
        WHERE  zc_isHistoryCost() = TRUE
        GROUP BY _tmp.MovementItemId
               , _tmp.ContainerId
                , _tmp.AccountId
       )
        SELECT tmp_all.MovementItemId
             , 0 AS ContainerId_ProfitLoss
             , tmp_all.ContainerId
             , tmp_all.AccountId
             , tmp_all.OperSumm - COALESCE (HistoryCost.Summ_diff, 0) AS OperSumm -- !!!���� ���� "�����������" ��� ����������, �������� �����!!!
        FROM tmp_all
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId         = tmp_all.ContainerId
                                  AND HistoryCost.MovementItemId_diff = tmp_all.MovementItemId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
       ;


     -- 3.2. ������������ ���� ��� �������� �� ��������� �����
     UPDATE _tmpItemSumm SET AccountId = _tmpItem_byAccount.AccountId
     FROM _tmpItem
          JOIN (SELECT CASE WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                 THEN CASE WHEN tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- ���������������� ������������
                                                THEN zc_Enum_Account_10201() -- ���������������� �� + �������� ��������*****
                                           ELSE zc_Enum_Account_10101() -- ���������������� �� + �������� ��������*****
                                      END
                            ELSE lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������ -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                            , inAccountDirectionId     := CASE WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                                                                                    THEN zc_Enum_AccountDirection_20900() -- ��������� ����
                                                                                               WHEN vbMemberId <> 0
                                                                                                AND tmpItem_group.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "�������� �����"; 10100; "������ �����"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_20700() -- "�������������"; 20700; "������"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_20900() -- "�������������"; 20900; "����"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_21000() -- "�������������"; 21000; "�����"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_21100() -- "�������������"; 21100; "�������"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                                                                            , zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                                                                                                                             )
                                                                                                    THEN 0 -- !!!�� � ���������� (��), � ����� ������!!! zc_Enum_AccountDirection_20600() -- "������"; 20600; "���������� (�����������)"
                                                                                               ELSE vbAccountDirectionId
                                                                                          END
                                                            , inInfoMoneyDestinationId := tmpItem_group.InfoMoneyDestinationId_calc
                                                            , inInfoMoneyId            := NULL
                                                            , inUserId                 := vbUserId
                                                             )
                       END AS AccountId
                     , tmpItem_group.InfoMoneyDestinationId
                     , tmpItem_group.InfoMoneyId
                FROM (SELECT _tmpItem.InfoMoneyDestinationId
                           , _tmpItem.InfoMoneyId
                           , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                    OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                    OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                    OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                       THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������

                                  WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                       THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������

                                  WHEN vbAccountDirectionId = zc_Enum_AccountDirection_20300() -- ������ + �� ��������
                                   AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21400() -- ������������� + ������ ����������
                                       THEN zc_Enum_InfoMoneyDestination_10200() -- �������� ����� + ������ �����

                                  -- ��������
                                  WHEN (vbAccountDirectionId = zc_Enum_AccountDirection_20800() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()) -- ������ + �� �� �������� AND �������� ����� + ������ �����
                                       THEN zc_Enum_InfoMoneyDestination_10200() -- �������� ����� + ������ �����

                                  ELSE _tmpItem.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                      FROM _tmpItem
                           JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
                                            AND _tmpItemSumm.OperSumm <> 0
                                            AND _tmpItemSumm.ContainerId = 0
                      GROUP BY _tmpItem.InfoMoneyDestinationId
                             , _tmpItem.InfoMoneyId
                             , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                      OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                      OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                      OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                      OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                      OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                         THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������

                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                         THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������

                                    WHEN vbAccountDirectionId = zc_Enum_AccountDirection_20300() -- ������ + �� ��������
                                     AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21400() -- ������������� + ������ ����������
                                         THEN zc_Enum_InfoMoneyDestination_10200() -- �������� ����� + ������ �����

                                    -- ��������
                                    WHEN (vbAccountDirectionId = zc_Enum_AccountDirection_20800() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()) -- ������ + �� �� �������� AND �������� ����� + ������ �����
                                         THEN zc_Enum_InfoMoneyDestination_10200() -- �������� ����� + ������ �����

                                    ELSE _tmpItem.InfoMoneyDestinationId
                               END
                     ) AS tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.InfoMoneyId = _tmpItem.InfoMoneyId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSumm.OperSumm <> 0
       AND _tmpItemSumm.ContainerId = 0;

     -- 3.3. ������� ���������� ��� ��������� ����� + ��������� <������� �/�>, ������ !!!������!!! ����� ContainerId=0 � !!!����!!! ������� �� �������
     UPDATE _tmpItemSumm SET ContainerId = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                             , inUnitId                 := CASE WHEN vbMemberId <> 0 THEN _tmpItem.UnitId_Item ELSE vbUnitId END
                                                                             , inCarId                  := vbCarId
                                                                             , inMemberId               := vbMemberId
                                                                             , inBranchId               := vbBranchId
                                                                             , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                             , inBusinessId             := _tmpItem.BusinessId
                                                                             , inAccountId              := _tmpItemSumm.AccountId
                                                                             , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                             , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                             , inInfoMoneyId_Detail     := _tmpItem.InfoMoneyId
                                                                             , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                             , inGoodsId                := _tmpItem.GoodsId
                                                                             , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                             , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                             , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                             , inAssetId                := _tmpItem.AssetId
                                                                              )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSumm.OperSumm <> 0
       AND _tmpItemSumm.ContainerId = 0;


     -- 3.4. ����������� �������� ��� ��������� ����� !!!������!!! ���� ���� ������� �� �������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId
            , _tmpItemSumm.ContainerId
            , _tmpItemSumm.AccountId                  AS AccountId              -- ���� ���� ������
            , 0                                       AS AnalyzerId             -- ��� ���������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer   -- !!!���!!!
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , 0                                       AS ObjectExtId_Analyzer   -- !!!���!!!
            , 0                                       AS ParentId
            , _tmpItemSumm.OperSumm
            , vbOperDate
            , TRUE
       FROM _tmpItemSumm
            JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
       WHERE _tmpItemSumm.OperSumm <> 0;


     -- 3.5. ������� ���������� ��� �������� - ������� !!!������!!! ���� ���� ������� �� �������
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss = _tmpItem_byContainer.ContainerId_ProfitLoss
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "������� �������� �������"
                                        , inJuridicalId_basis := _tmpItem_byProfitLoss.JuridicalId_basis
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_byProfitLoss.ContainerId
           FROM (SELECT CASE WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                              AND vbOperDate < '01.06.2014' -- !!!�������� ��� ������� ����!!!
                                 THEN CASE WHEN tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- ���������������� ������������
                                                     -- !!!�������� ��� ������� ����!!!
                                                THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60201) -- ����������� + ���������������� �� + �������� ��������*****
                                                -- !!!�������� ��� ������� ����!!!
                                           ELSE (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60101) -- ����������� + ���������������� �� + �������� ��������*****
                                      END
                             WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                              AND vbOperDate < '01.04.2015' -- !!!�������� ��� ������� ����!!!
                                 THEN CASE WHEN tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- ���������������� ������������
                                                     -- !!!�������� ��� ������� ����!!!
                                                THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60201) -- ����������� + ���������������� �� + �������� ��������*****
                                                -- !!!�������� ��� ������� ����!!!
                                           ELSE (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60101) -- ����������� + ���������������� �� + �������� ��������*****
                                      END
                             WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                              AND vbOperDate < '01.07.2015' -- !!!�������� ��� ���������� ����!!!
                                 THEN CASE WHEN tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- ���������������� ������������
                                                     -- !!!�������� ��� ������� ����!!!
                                                THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60201) -- ����������� + ���������������� �� + �������� ��������*****
                                                -- !!!�������� ��� ������� ����!!!
                                           ELSE (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60101) -- ����������� + ���������������� �� + �������� ��������*****
                                      END

                             WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21400() -- ������ ����������
                              AND vbOperDate < '01.08.2015' -- !!!�������� ��� ���������� ����!!!
                                 THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20502) -- �������������������� ������� + ������ ������ (��������+��������������) + ������ �����


                             WHEN(tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                               OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                               OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                 )
                              AND vbOperDate < '01.06.2014' -- !!!�������� ��� ������� ����!!!
                                       -- !!!�������� ��� ������� ����!!!
                                  -- THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20509) -- �������������������� ������� + ������ ������ (��������+��������������) + ���
                                       -- !!!�������� ��� ������� ����!!!
                                  THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20508) -- �������������������� ������� + ������ ������ (��������+��������������) + ������ ���

                             WHEN(tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                               OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                               OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                 )
                              AND vbOperDate < '01.07.2015' -- !!!�������� ��� ���������� ����!!!
                                  THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20508) -- �������������������� ������� + ������ ������ (��������+��������������) + ������ ���

                             
                             WHEN tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                              AND vbOperDate < '01.06.2014' -- !!!�������� ��� ������� ����!!!
                                       -- !!!�������� ��� ������� ����!!!
                                  THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20504) -- �������������������� ������� + ������ ������ (��������+��������������) + ���������

                             WHEN vbAccountDirectionId = zc_Enum_AccountDirection_20300() -- ������ + �� ��������
                              AND vbOperDate < '01.06.2014' -- !!!�������� ��� ������� ����!!!
                                       -- !!!�������� ��� ������� ����!!!
                                  THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20502) -- �������������������� ������� + ������ ������ (��������+��������������) + ������ �����

                             WHEN tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                              AND vbOperDate >= '01.06.2014' -- !!!��������!!!
                                       -- !!!��������!!!
                                  THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20504) -- �������������������� ������� + ������ ������ (��������+��������������) + ���������

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := CASE WHEN vbUnitId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Unit() AND ObjectCode IN (32031 -- ����� ���������
                                                                                                                                                                                            , 32032 -- ����� ����
                                                                                                                                                                                            , 32033 -- ����� �����
                                                                                                                                                                                            , 22122 -- ����� ��������� �.���������
                                                                                                                                                                                            , 8461  -- ����� ��������� �.������
                                                                                                                                                                                             )
                                                                                                                    )
                                                                                                        AND vbOperDate >= '01.06.2014' -- !!!�������� ����� ������� ����!!!
                                                                                                        AND tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                                        THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLossGroup() AND ObjectCode = 10000) -- ��������� �������� ������������
                                                                                                   ELSE vbProfitLossGroupId
                                                                                              END
                                                                , inProfitLossDirectionId  := CASE WHEN vbUnitId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Unit() AND ObjectCode IN (32031 -- ����� ���������
                                                                                                                                                                                            , 32032 -- ����� ����
                                                                                                                                                                                            , 32033 -- ����� �����
                                                                                                                                                                                            , 22122 -- ����� ��������� �.���������
                                                                                                                                                                                            , 8461  -- ����� ��������� �.������
                                                                                                                                                                                             )
                                                                                                                    )
                                                                                                        AND vbOperDate >= '01.06.2014' -- !!!�������� ����� ������� ����!!!
                                                                                                        AND tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                                        THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLossDirection() AND ObjectCode = 10900) -- ��������� �������� ������������ + ���������� ���������

                                                                                                   WHEN (tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                                                                      OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                                                                      OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                                                                        )
                                                                                                        AND vbOperDate < '01.04.2015' -- !!!�������� ��� �� ������� ����!!!
                                                                                                        AND vbProfitLossDirectionId = zc_Enum_ProfitLossDirection_20500() -- ������ ������ (��������+��������������)
                                                                                                        THEN zc_Enum_ProfitLossDirection_20100() -- ���������� ������������

                                                                                                   ELSE vbProfitLossDirectionId
                                                                                              END
                                                                , inInfoMoneyDestinationId := tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := vbUserId
                                                                 )
                        END AS ProfitLossId
                      , tmpItem_group.ContainerId
                      , tmpItem_group.InfoMoneyDestinationId
                      , ContainerLinkObject_JuridicalBasis.ObjectId AS JuridicalId_basis
                      , ContainerLinkObject_Business.ObjectId AS BusinessId
                 FROM (SELECT _tmpItemSumm.ContainerId
                            , View_InfoMoney.InfoMoneyDestinationId
                            , View_InfoMoney.InfoMoneyId
                            , CASE WHEN (ContainerLinkObject_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                     OR (ContainerLinkObject_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                     OR (ContainerLinkObject_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                     OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                     OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                     OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                        THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                        THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                   ELSE View_InfoMoney.InfoMoneyDestinationId
                              END AS InfoMoneyDestinationId_calc
                       FROM _tmpItemSumm
                            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                                          ON ContainerLinkObject_GoodsKind.ContainerId = _tmpItemSumm.ContainerId
                                                         AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                          ON ContainerLinkObject_InfoMoney.ContainerId = _tmpItemSumm.ContainerId
                                                         AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ContainerLinkObject_InfoMoney.ObjectId
                       WHERE _tmpItemSumm.OperSumm <> 0
                      ) AS tmpItem_group
                      LEFT JOIN ContainerLinkObject AS ContainerLinkObject_JuridicalBasis
                                                    ON ContainerLinkObject_JuridicalBasis.ContainerId = tmpItem_group.ContainerId
                                                     AND ContainerLinkObject_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                      LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Business
                                                    ON ContainerLinkObject_Business.ContainerId = tmpItem_group.ContainerId
                                                   AND ContainerLinkObject_Business.DescId = zc_ContainerLinkObject_Business()
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byContainer
     WHERE _tmpItemSumm.ContainerId = _tmpItem_byContainer.ContainerId;

     -- 3.6. ����������� �������� - ������� !!!������!!! ���� ���� ������� �� �������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpItem_group.MovementItemId
            , tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId              -- ������� �������� �������
            , 0                                       AS AnalyzerId             -- !!!���!!!
            , tmpItem_group.GoodsId                   AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer   -- � ���� �� �����
            , tmpItem_group.GoodsKindId               AS ObjectIntId_Analyzer   -- ��� ������
            , 0                                       AS ObjectExtId_Analyzer   -- !!!���!!!
            , 0                                       AS ParentId
            , -1 * tmpItem_group.OperSumm
            , vbOperDate
            , FALSE
       FROM (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_ProfitLoss
                  , _tmpItem.GoodsId
                  , _tmpItem.GoodsKindId
                  , SUM (_tmpItemSumm.OperSumm) AS OperSumm
             FROM _tmpItemSumm
                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             WHERE _tmpItemSumm.OperSumm <> 0
             GROUP BY _tmpItemSumm.MovementItemId
                    , _tmpItemSumm.ContainerId_ProfitLoss
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
            ) AS tmpItem_group
       ;
     -- 3. Finish


     -- 4. Start ����������
     IF vbOperDate >= '01.06.2014' AND vbPriceListId <> 0
        AND vbUnitId IN (301309 -- ����� �� �.���������
                       , 309599 -- ����� ��������� �.���������
                       , 346093 -- ����� �� �.������
                       , 346094 -- ����� ��������� �.������
                        )
     THEN

     -- 4.1. ��������� ������� - �������� �������� ���������, ��� ����������
     INSERT INTO _tmpItemSummRePrice (MovementItemId, ContainerId_Active, AccountId_Active, ContainerId_Passive, AccountId_Passive, OperSumm)
        SELECT _tmp.MovementItemId
             , 0 AS ContainerId_Active
             , 0 AS AccountId_Active
             , 0 AS ContainerId_Passive
             , 0 AS AccountId_Passive
             , SUM (_tmp.OperSumm) AS OperSumm
        FROM  -- ��� ��������� ������� �� ����� �/� (�� ���� �������)
/*             (SELECT _tmpItem.MovementItemId
                     -- ������� �� ����� ������ ���� ��������� ���� ���, � ����� ������������� �� HistoryCost
                   , -1 * _tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS OperSumm
              FROM _tmpItem
                   LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                        AND Container_Summ.DescId = zc_Container_Summ()
                                                        AND vbOperDate >= '01.06.2014'
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container_Summ.ObjectId
              WHERE View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() -- ������� ������� �������� + �� ��������
*/
             (SELECT _tmpItem.MovementItemId
                   -- , CASE WHEN vbOperDate <= '01.06.2014' THEN _tmpItem.OperSumm ELSE _tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) END AS OperSumm
                   , -1 * CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                     AS OperSumm
              FROM _tmpItem
                   LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpItem.ContainerId_Goods
                   LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                        AND Container_Summ.DescId = zc_Container_Summ()
                                                        AND (vbOperDate >= '01.07.2015' OR vbPriceListId <> 0) 
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container_Summ.ObjectId
              WHERE View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() -- ������� ������� �������� + �� ��������
             UNION ALL
              -- ��� ��������� ������� (�� ���� �������) - !!!��� �������!!!
              SELECT _tmpRemainsCount.MovementItemId
                   , -1 * CAST (-1 * _tmpRemainsCount.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)) AS OperSumm
              FROM _tmpRemainsCount
                   LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpRemainsCount.ContainerId_Goods
                                                        AND Container_Summ.DescId = zc_Container_Summ()
                                                        AND vbOperDate >= '01.06.2014'
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container_Summ.ObjectId
              WHERE View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() -- ������� ������� �������� + �� ��������
             UNION ALL
              -- ��� ��������� ������� (�� ���� �������) -- !!!��� "�����" ����!!!!
               SELECT _tmpRemainsCount.MovementItemId
                   , -1 * _tmpRemainsSumm.OperSumm AS OperSumm
              FROM _tmpRemainsSumm
                   LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = _tmpRemainsSumm.AccountId
              WHERE View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() -- ������� ������� �������� + �� ��������
            UNION ALL
              -- ��� ��������� ������� �� ������ !!!���� ���!!!
              SELECT _tmpItem.MovementItemId
                   , CAST (_tmpItem.OperCount * COALESCE (lfObjectHistory_PriceListItem.ValuePrice, 0) * 1.2 AS NUMERIC (16,4)) AS OperSumm
              FROM _tmpItem
                   LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate + INTERVAL '1 DAY')
                          AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = _tmpItem.GoodsId
             ) AS _tmp
        GROUP BY _tmp.MovementItemId;


     DELETE FROM _tmpItemSummRePrice WHERE MovementItemId IN (SELECT MovementItemId FROM _tmpItem WHERE InfoMoneyId = 0);

     -- 4.2. ������������ ���� ��� �������� �� ��������� �����
     UPDATE _tmpItemSummRePrice	 SET AccountId_Active = _tmpItem_byAccount.AccountId_Active, AccountId_Passive = _tmpItem_byAccount.AccountId_Passive
     FROM _tmpItem
          JOIN (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������
                                                  , inAccountDirectionId     := vbAccountDirectionId
                                                  , inInfoMoneyDestinationId := tmpItem_group.InfoMoneyDestinationId_calc
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := vbUserId
                                                   ) AS AccountId_Active
                     , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_60000() -- ������� ������� ��������
                                                  , inAccountDirectionId     := zc_Enum_AccountDirection_60200() -- ������� ������� �������� + �� ��������
                                                  , inInfoMoneyDestinationId := tmpItem_group.InfoMoneyDestinationId_calc
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := vbUserId
                                                   ) AS AccountId_Passive
                     , tmpItem_group.InfoMoneyId
                FROM (SELECT _tmpItem.InfoMoneyDestinationId
                           , _tmpItem.InfoMoneyId
                           , CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                       THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                  ELSE _tmpItem.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                      FROM _tmpItem
                           JOIN _tmpItemSummRePrice ON _tmpItemSummRePrice.MovementItemId = _tmpItem.MovementItemId
                                                   AND _tmpItemSummRePrice.OperSumm <> 0
                      GROUP BY _tmpItem.InfoMoneyDestinationId
                             , _tmpItem.InfoMoneyId
                     ) AS tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.InfoMoneyId = _tmpItem.InfoMoneyId
     WHERE _tmpItemSummRePrice.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSummRePrice.OperSumm <> 0
    ;

     -- 4.3. ������� ���������� ��� ��������� ����� + ��������� <������� �/�>, ������ !!!������!!! ����� ContainerId=0 � !!!����!!! ������� �� �������
     UPDATE _tmpItemSummRePrice SET ContainerId_Active =
                                           lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                             , inUnitId                 := CASE WHEN vbMemberId <> 0 THEN _tmpItem.UnitId_Item ELSE vbUnitId END
                                                                             , inCarId                  := vbCarId
                                                                             , inMemberId               := vbMemberId
                                                                             , inBranchId               := vbBranchId
                                                                             , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                             , inBusinessId             := _tmpItem.BusinessId
                                                                             , inAccountId              := _tmpItemSummRePrice.AccountId_Active
                                                                             , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                             , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                             , inInfoMoneyId_Detail     := zc_Enum_InfoMoney_80401()
                                                                             , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                             , inGoodsId                := _tmpItem.GoodsId
                                                                             , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                             , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                             , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                             , inAssetId                := _tmpItem.AssetId
                                                                              )
                                  , ContainerId_Passive =
                                           lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                             , inUnitId                 := CASE WHEN vbMemberId <> 0 THEN _tmpItem.UnitId_Item ELSE vbUnitId END
                                                                             , inCarId                  := vbCarId
                                                                             , inMemberId               := vbMemberId
                                                                             , inBranchId               := vbBranchId
                                                                             , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                             , inBusinessId             := _tmpItem.BusinessId
                                                                             , inAccountId              := _tmpItemSummRePrice.AccountId_Passive
                                                                             , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                             , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                             , inInfoMoneyId_Detail     := zc_Enum_InfoMoney_80401()
                                                                             , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                             , inGoodsId                := _tmpItem.GoodsId
                                                                             , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                             , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                             , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                             , inAssetId                := _tmpItem.AssetId
                                                                              )
     FROM _tmpItem
     WHERE _tmpItemSummRePrice.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSummRePrice.OperSumm <> 0
    ;


     -- 4.4. ����������� �������� ��� ��������� ����� !!!������!!! ���� ���� �������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSummRePrice.MovementItemId
            , CASE WHEN tmp.myNumber = 1 THEN _tmpItemSummRePrice.ContainerId_Active ELSE _tmpItemSummRePrice.ContainerId_Passive END AS ContainerId
            , CASE WHEN tmp.myNumber = 1 THEN _tmpItemSummRePrice.AccountId_Active   ELSE _tmpItemSummRePrice.AccountId_Passive   END AS AccountId    -- ���� ���� ������
            , zc_Enum_AccountGroup_60000()            AS AnalyzerId             -- ���� ���������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer   -- !!!���!!!
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , 0                                       AS ObjectExtId_Analyzer   -- !!!���!!!
            , 0                                       AS ParentId
            , CASE WHEN tmp.myNumber = 1 THEN _tmpItemSummRePrice.OperSumm ELSE -1 * _tmpItemSummRePrice.OperSumm END AS OperSumm
            , vbOperDate
            , CASE WHEN (tmp.myNumber = 1 AND _tmpItemSummRePrice.OperSumm > 0) OR (tmp.myNumber = 2 AND _tmpItemSummRePrice.OperSumm < 0) THEN TRUE ELSE FALSE END AS IsActive
       FROM (SELECT 1 AS myNumber UNION ALL SELECT 2 AS myNumber) AS tmp
            INNER JOIN _tmpItemSummRePrice ON _tmpItemSummRePrice.OperSumm <> 0
            INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSummRePrice.MovementItemId
    ;

     -- 4.5. ����������� �������� ��� ������ (���������: ���� ������ � ���� ������� ������� ��������)
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem_byProfitLoss.MovementItemId
                                              , inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                              , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                              , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                              , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                    , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                    , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                    , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                             , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                             , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                             , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT ABS (_tmpItemSummRePrice.OperSumm) AS OperSumm
                , CASE WHEN _tmpItemSummRePrice.OperSumm > 0 THEN _tmpItemSummRePrice.ContainerId_Active  WHEN _tmpItemSummRePrice.OperSumm < 0 THEN _tmpItemSummRePrice.ContainerId_Passive END AS ActiveContainerId
                , CASE WHEN _tmpItemSummRePrice.OperSumm > 0 THEN _tmpItemSummRePrice.ContainerId_Passive WHEN _tmpItemSummRePrice.OperSumm < 0 THEN _tmpItemSummRePrice.ContainerId_Active  END AS PassiveContainerId
                , CASE WHEN _tmpItemSummRePrice.OperSumm > 0 THEN _tmpItemSummRePrice.AccountId_Active    WHEN _tmpItemSummRePrice.OperSumm < 0 THEN _tmpItemSummRePrice.AccountId_Passive   END AS ActiveAccountId
                , CASE WHEN _tmpItemSummRePrice.OperSumm > 0 THEN _tmpItemSummRePrice.AccountId_Passive   WHEN _tmpItemSummRePrice.OperSumm < 0 THEN _tmpItemSummRePrice.AccountId_Active    END AS PassiveAccountId
                , _tmpItemSummRePrice.MovementItemId
           FROM _tmpItemSummRePrice
           WHERE _tmpItemSummRePrice.OperSumm <> 0
           ) AS _tmpItem_byProfitLoss
    ;

     END IF; -- ��������� ������� - �������� �������� ���������, ��� ����������

     -- 4. Finish - ����������


     -- ����������� �������� ��� ������ (���������: ����� � ����)
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem_byProfitLoss.MovementItemId
                                              , inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                              , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                              , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                              , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                    , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                    , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                    , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                             , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                             , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                             , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT ABS (_tmpItemSumm.OperSumm) AS OperSumm
                , CASE WHEN _tmpItemSumm.OperSumm > 0 THEN _tmpItemSumm.ContainerId            WHEN _tmpItemSumm.OperSumm < 0 THEN _tmpItemSumm.ContainerId_ProfitLoss END AS ActiveContainerId
                , CASE WHEN _tmpItemSumm.OperSumm > 0 THEN _tmpItemSumm.ContainerId_ProfitLoss WHEN _tmpItemSumm.OperSumm < 0 THEN _tmpItemSumm.ContainerId            END AS PassiveContainerId
                , CASE WHEN _tmpItemSumm.OperSumm > 0 THEN _tmpItemSumm.AccountId              WHEN _tmpItemSumm.OperSumm < 0 THEN zc_Enum_Account_100301 ()           END AS ActiveAccountId  -- 100301; "������� �������� �������"
                , CASE WHEN _tmpItemSumm.OperSumm > 0 THEN zc_Enum_Account_100301 ()           WHEN _tmpItemSumm.OperSumm < 0 THEN _tmpItemSumm.AccountId              END AS PassiveAccountId -- 100301; "������� �������� �������"
                , _tmpItemSumm.MovementItemId
           FROM _tmpItemSumm
           WHERE _tmpItemSumm.OperSumm <> 0
           ) AS _tmpItem_byProfitLoss;



     -- !!!����������� �������� <ContainerId>!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), _tmpItem.MovementItemId, _tmpItem.ContainerId_Goods)
     FROM _tmpItem;

     -- !!!����������� �������� <����>!!!
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Price(), _tmpItem.PartionGoodsId, Price_Partion)
     FROM _tmpItem
     WHERE _tmpItem.PartionGoodsId > 0
        AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                              , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                              , zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                               );



     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Inventory()
                                , inUserId     := vbUserId
                                 );
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 25.05.14                                        * add lpComplete_Movement
 21.12.13                                        * Personal -> Member
 13.10.13                                        * add vbCarId
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 03.10.13                                        * add inCarId := NULL
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 16.09.13                                        * add zc_Enum_InfoMoneyDestination_20500
 14.09.13                                        * add zc_ObjectLink_Goods_Business
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 01.09.13                                        * change isActive
 26.08.13                                        * add zc_InfoMoneyDestination_WorkProgress
 23.08.13                                        *
*/
/*
UPDATE MovementItem SET isErased = TRUE
from Movement
WHERE Movement.Id = MovementId
  AND Movement.OperDate BETWEEN '01.07.2015' AND '31.07.2015'
  AND Movement.DescId = zc_Movement_Inventory()
  AND Movement.StatusId = zc_Enum_Status_Complete()
  AND isErased = FALSE
  AND MovementItem.Amount = 0
  AND Movement.Id = 1902144
*/
-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 29207, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Inventory (inMovementId:= 1902144, inIsLastComplete:= FALSE, inSession:= zc_Enum_Process_Auto_PrimeCost() :: TVarChar)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 29207, inSession:= '2')

