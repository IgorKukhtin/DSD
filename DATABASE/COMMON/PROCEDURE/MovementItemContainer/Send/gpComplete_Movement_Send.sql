-- Function: gpComplete_Movement_Send()

-- DROP FUNCTION gpComplete_Movement_Send (Integer, TVarChar);
-- DROP FUNCTION gpComplete_Movement_Send (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Send(
    IN inMovementId        Integer              , -- ���� ���������
    IN inIsLastComplete    Boolean DEFAULT False, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
-- RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId_From Integer, MemberId_From Integer, UnitId_To Integer, MemberId_To Integer, BranchId_To Integer, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate_From TDateTime, PartionGoodsDate_To TDateTime, OperCount TFloat, AccountDirectionId_From Integer, AccountDirectionId_To Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, JuridicalId_basis_To Integer, BusinessId_To Integer, isPartionCount Boolean, isPartionSumm Boolean, isPartionDate_From Boolean, isPartionDate_To Boolean, PartionGoodsId_From Integer, PartionGoodsId_To Integer)
-- RETURNS TABLE (MovementItemId Integer, MIContainerId_To Integer, ContainerId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Movement_Income());
     vbUserId:=2; -- CAST (inSession AS Integer);


     -- ������� - ��������� �������
     CREATE TEMP TABLE _tmpContainer (DescId Integer, ObjectId Integer) ON COMMIT DROP;
     -- ������� - ��������� <������� �/�>
     CREATE TEMP TABLE _tmpObjectCost (DescId Integer, ObjectId Integer) ON COMMIT DROP;
     -- ������� - ��������� <�������� ��� ������>
     CREATE TEMP TABLE _tmpChildReportContainer (AccountKindId Integer, ContainerId Integer, AccountId Integer) ON COMMIT DROP;
     -- ������� - 
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

     -- ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId_From Integer, MemberId_From Integer, UnitId_To Integer, MemberId_To Integer, BranchId_To Integer
                               , MIContainerId_To Integer, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate_From TDateTime, PartionGoodsDate_To TDateTime
                               , OperCount TFloat
                               , AccountDirectionId_From Integer, AccountDirectionId_To Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , JuridicalId_basis_To Integer, BusinessId_To Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isPartionDate_From Boolean, isPartionDate_To Boolean
                               , PartionGoodsId_From Integer, PartionGoodsId_To Integer) ON COMMIT DROP;
     -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, MIContainerId_To Integer, ContainerId_To Integer, AccountId_To Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat) ON COMMIT DROP;

     -- ��������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId, MovementId, OperDate, UnitId_From, MemberId_From, UnitId_To, MemberId_To, BranchId_To
                         , MIContainerId_To, ContainerId_GoodsFrom, ContainerId_GoodsTo, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate_From, PartionGoodsDate_To
                         , OperCount
                         , AccountDirectionId_From, AccountDirectionId_To, InfoMoneyDestinationId, InfoMoneyId
                         , JuridicalId_basis_To, BusinessId_To
                         , isPartionCount, isPartionSumm, isPartionDate_From, isPartionDate_To
                         , PartionGoodsId_From, PartionGoodsId_To)
        SELECT
              _tmp.MovementItemId
            , _tmp.MovementId
            , _tmp.OperDate
            , _tmp.UnitId_From
            , _tmp.MemberId_From
            , _tmp.UnitId_To
            , _tmp.MemberId_To
            , _tmp.BranchId_To

            , 0 AS MIContainerId_To
            , 0 AS ContainerId_GoodsFrom
            , 0 AS ContainerId_GoodsTo
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate_From
            , _tmp.PartionGoodsDate_To

            , _tmp.OperCount

              -- ��������� ������ - ����������� (�� ����)
            , _tmp.AccountDirectionId_From
              -- ��������� ������ - ����������� (����)
            , _tmp.AccountDirectionId_To
              -- �������������� ���������� (?�� ����? � ����)
            , _tmp.InfoMoneyDestinationId
              -- ������ ���������� (?�� ����? � ����)
            , _tmp.InfoMoneyId

            , _tmp.JuridicalId_basis_To
            , _tmp.BusinessId_To

            , _tmp.isPartionCount
            , _tmp.isPartionSumm
            , _tmp.isPartionDate_From
            , _tmp.isPartionDate_To
              -- ������ ������, ���������� �����
            , 0 AS PartionGoodsId_From
            , 0 AS PartionGoodsId_To
        FROM 
             (SELECT
                    MovementItem.Id AS MovementItemId
                  , MovementItem.MovementId
                  , Movement.OperDate
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId_From
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From
                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS UnitId_To
                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_To
                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Branch.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_To

                  , MovementItem.ObjectId AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                  , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate_From
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate_To

                  , MovementItem.Amount AS OperCount

                  -- ��������� ������ - ����������� (�� ����)
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()
                                       THEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId
                                   WHEN Object_From.DescId = zc_Object_Personal()
                                       THEN CASE WHEN lfObject_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "�������� �����"; 10100; "������ �����"
                                                                                                  , zc_Enum_InfoMoneyDestination_20700() -- "�������������"; 20700; "������"
                                                                                                  , zc_Enum_InfoMoneyDestination_20900() -- "�������������"; 20900; "����"
                                                                                                  , zc_Enum_InfoMoneyDestination_21000() -- "�������������"; 21000; "�����"
                                                                                                  , zc_Enum_InfoMoneyDestination_21100() -- "�������������"; 21100; "�������"
                                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
                                                                                                   )
                                                     THEN 0 -- !!!�� ���� �� ����� �� ����� ����!!! zc_Enum_AccountDirection_20600() -- "������"; 20600; "���������� (�����������)"
                                                 ELSE zc_Enum_AccountDirection_20500() -- "������"; 20500; "���������� (��)"
                                            END
                              END, 0) AS AccountDirectionId_From
                  -- ��������� ������ - ����������� (����)
                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit()
                                       THEN ObjectLink_UnitTo_AccountDirection.ChildObjectId
                                   WHEN Object_To.DescId = zc_Object_Personal()
                                       THEN CASE WHEN lfObject_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "�������� �����"; 10100; "������ �����"
                                                                                                  , zc_Enum_InfoMoneyDestination_20700() -- "�������������"; 20700; "������"
                                                                                                  , zc_Enum_InfoMoneyDestination_20900() -- "�������������"; 20900; "����"
                                                                                                  , zc_Enum_InfoMoneyDestination_21000() -- "�������������"; 21000; "�����"
                                                                                                  , zc_Enum_InfoMoneyDestination_21100() -- "�������������"; 21100; "�������"
                                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
                                                                                                   )
                                                     THEN 0 -- !!!�� ���� �� ����� �� ����� ����!!! zc_Enum_AccountDirection_20600() -- "������"; 20600; "���������� (�����������)"
                                                 ELSE zc_Enum_AccountDirection_20500() -- "������"; 20500; "���������� (��)"
                                            END
                              END, 0) AS AccountDirectionId_To
                  -- �������������� ���������� (?�� ����? � ����)
                  , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                  -- ������ ���������� (?�� ����? � ����)
                  , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Juridical.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_basis_To
                    -- ����� ������ �� ������ ��� ������������/����������
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Business.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Business.ChildObjectId ELSE 0 END, 0)) AS BusinessId_To

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)     AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)      AS isPartionSumm
                  , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE) AS isPartionDate_From
                  , COALESCE (ObjectBoolean_PartionDate_To.ValueData, FALSE)   AS isPartionDate_To

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = MovementItem.MovementId
                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                   LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                   LEFT JOIN ObjectLink AS ObjectLink_PersonalFrom_Member
                                        ON ObjectLink_PersonalFrom_Member.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectLink_PersonalFrom_Member.DescId = zc_ObjectLink_Personal_Member()
                                       AND Object_From.DescId = zc_Object_Personal()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                        ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                                       AND Object_From.DescId = zc_Object_Unit()

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = MovementItem.MovementId
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                   LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                                        ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_UnitTo_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                                       AND Object_To.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                        ON ObjectLink_UnitTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                       AND Object_To.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Juridical
                                        ON ObjectLink_UnitTo_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_UnitTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                       AND Object_To.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Business
                                        ON ObjectLink_UnitTo_Business.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_UnitTo_Business.DescId = zc_ObjectLink_Unit_Business()
                                       AND Object_To.DescId = zc_Object_Unit()

                   LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Member
                                        ON ObjectLink_PersonalTo_Member.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_PersonalTo_Member.DescId = zc_ObjectLink_Personal_Member()
                                       AND Object_To.DescId = zc_Object_Personal()
                   LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Unit
                                        ON ObjectLink_PersonalTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_PersonalTo_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                       AND Object_To.DescId = zc_Object_Personal()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalTo_Branch
                                        ON ObjectLink_UnitPersonalTo_Branch.ObjectId = ObjectLink_PersonalTo_Unit.ChildObjectId
                                       AND ObjectLink_UnitPersonalTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                       AND Object_To.DescId = zc_Object_Personal()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalTo_Juridical
                                        ON ObjectLink_UnitPersonalTo_Juridical.ObjectId = ObjectLink_PersonalTo_Unit.ChildObjectId
                                       AND ObjectLink_UnitPersonalTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                       AND Object_To.DescId = zc_Object_Personal()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalTo_Business
                                        ON ObjectLink_UnitPersonalTo_Business.ObjectId = ObjectLink_PersonalTo_Unit.ChildObjectId
                                       AND ObjectLink_UnitPersonalTo_Business.DescId = zc_ObjectLink_Unit_Business()
                                       AND Object_To.DescId = zc_Object_Personal()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_From
                                           ON ObjectBoolean_PartionDate_From.ObjectId = MovementLinkObject_From.ObjectId
                                          AND ObjectBoolean_PartionDate_From.DescId = zc_ObjectBoolean_Unit_PartionDate()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_To
                                           ON ObjectBoolean_PartionDate_To.ObjectId = MovementLinkObject_To.ObjectId
                                          AND ObjectBoolean_PartionDate_To.DescId = zc_ObjectBoolean_Unit_PartionDate()
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
                   LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Send()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp;


     -- ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId_From = CASE WHEN OperDate >= zc_DateStart_PartionGoods()
                                                     AND AccountDirectionId_From = zc_Enum_AccountDirection_20200() -- "������"; 20200; "�� �������"
                                                     AND (isPartionCount OR isPartionSumm)
                                                        THEN lpInsertFind_Object_PartionGoods (PartionGoods)
                                                    WHEN isPartionDate_From
                                                     AND InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
                                                        THEN lpInsertFind_Object_PartionGoods (PartionGoodsDate_From)
                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
                         , PartionGoodsId_To = CASE WHEN OperDate >= zc_DateStart_PartionGoods()
                                                     AND AccountDirectionId_To = zc_Enum_AccountDirection_20200() -- "������"; 20200; "�� �������"
                                                     AND (isPartionCount OR isPartionSumm)
                                                        THEN lpInsertFind_Object_PartionGoods (PartionGoods)
                                                    WHEN isPartionDate_To
                                                     AND InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
                                                        THEN lpInsertFind_Object_PartionGoods (PartionGoodsDate_To)
                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
     WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- "�������� �����"; 10100; "������ �����"
        OR InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
     ;


     -- ��� �����
     -- RETURN QUERY SELECT _tmpItem.MovementItemId, _tmpItem.MovementId, _tmpItem.OperDate, _tmpItem.UnitId_From, _tmpItem.MemberId_From, _tmpItem.UnitId_To, _tmpItem.MemberId_To, _tmpItem.BranchId_To, _tmpItem.ContainerId_GoodsFrom, _tmpItem.ContainerId_GoodsTo, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.AssetId, _tmpItem.PartionGoods, _tmpItem.PartionGoodsDate_From, _tmpItem.PartionGoodsDate_To, _tmpItem.OperCount, _tmpItem.AccountDirectionId_From, _tmpItem.AccountDirectionId_To, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.JuridicalId_basis_To, _tmpItem.BusinessId_To, _tmpItem.isPartionCount, _tmpItem.isPartionSumm, _tmpItem.isPartionDate_From, _tmpItem.isPartionDate_To, _tmpItem.PartionGoodsId_From, _tmpItem.PartionGoodsId_To FROM _tmpItem;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1.1.1. ������������ ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := _tmpItem.OperDate
                                                                                    , inUnitId                 := _tmpItem.UnitId_From
                                                                                    , inCarId                  := NULL
                                                                                    , inMemberId               := _tmpItem.MemberId_From
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId_From
                                                                                    , inAssetId                := _tmpItem.AssetId
                                                                                     )
                       , ContainerId_GoodsTo   = lpInsertUpdate_ContainerCount_Goods (inOperDate               := _tmpItem.OperDate
                                                                                    , inUnitId                 := _tmpItem.UnitId_To
                                                                                    , inCarId                  := NULL
                                                                                    , inMemberId               := _tmpItem.MemberId_To
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                    , inAssetId                := _tmpItem.AssetId
                                                                                     );

     -- 1.1.2. ����������� �������� ��� ��������������� ����� - ���� + ������������ MIContainer.Id (��������������)
     UPDATE _tmpItem SET MIContainerId_To = lpInsertUpdate_MovementItemContainer (ioId             := 0
                                                                                , inDescId         := zc_MIContainer_Count()
                                                                                , inMovementId     := MovementId
                                                                                , inMovementItemId := MovementItemId
                                                                                , inParentId       := NULL
                                                                                , inContainerId    := ContainerId_GoodsTo -- ��� ���������� ����
                                                                                , inAmount         := OperCount
                                                                                , inOperDate       := OperDate
                                                                                , inIsActive       := TRUE
                                                                                 );
     -- 1.1.3. ����������� �������� ��� ��������������� ����� - �� ����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, MovementId, MovementItemId, ContainerId_GoodsFrom, MIContainerId_To AS ParentId, -1 * OperCount, OperDate, FALSE
       FROM _tmpItem;


     -- 1.2. ����� ����������: ��������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ��������� !!!(����� ����)!!!
     INSERT INTO _tmpItemSumm (MovementItemId, MIContainerId_To, ContainerId_To, AccountId_To, ContainerId_From, AccountId_From, InfoMoneyId_Detail_From, OperSumm)
        SELECT
              _tmpItem.MovementItemId
            , 0 AS MIContainerId_To
            , 0 AS ContainerId_To
            , 0 AS AccountId_To
            , Container_Summ.Id AS ContainerId_From
            , Container_Summ.ObjectId AS AccountId_From
            , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
            , SUM (ABS (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0))) AS OperSumm
        FROM _tmpItem
             JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_GoodsFrom
                                             AND Container_Summ.DescId = zc_Container_Summ()
             JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                      ON ContainerLinkObject_InfoMoneyDetail.ContainerId = Container_Summ.Id
                                     AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
             JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = Container_Summ.Id
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()
             LEFT JOIN HistoryCost ON HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND _tmpItem.OperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND (ContainerLinkObject_InfoMoneyDetail.ObjectId = 0 OR zc_isHistoryCost_byInfoMoneyDetail()= TRUE)
          AND (inIsLastComplete = FALSE OR (_tmpItem.OperCount * HistoryCost.Price) <> 0) -- !!!�����������!!! ��������� ���� ���� ��� �� ��������� ��� (��� ����� ��� ������� �/�)
          AND InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
        GROUP BY _tmpItem.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , ContainerLinkObject_InfoMoneyDetail.ObjectId
        ;


     -- ��� �����
     -- RETURN QUERY SELECT _tmpItemSumm.MovementItemId, _tmpItemSumm.MIContainerId_To, _tmpItemSumm.ContainerId_From, _tmpItemSumm.InfoMoneyId_Detail_From, _tmpItemSumm.OperSumm FROM _tmpItemSumm;
     -- return;


     -- 1.3.1. ������������ ���� ��� �������� �� ��������� ����� - ����
     UPDATE _tmpItemSumm SET AccountId_To = _tmpItem_byAccount.AccountId
     FROM _tmpItem
          JOIN (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������ -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                  , inAccountDirectionId     := _tmpItem_group.AccountDirectionId_To
                                                  , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := vbUserId
                                                   ) AS AccountId
                     , _tmpItem_group.AccountDirectionId_To
                     , _tmpItem_group.InfoMoneyDestinationId
                FROM (SELECT _tmpItem.AccountDirectionId_To
                           , _tmpItem.InfoMoneyDestinationId
                           , CASE WHEN GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_InfoMoneyDestination_WorkProgress() ELSE InfoMoneyDestinationId END AS InfoMoneyDestinationId_calc
                      FROM _tmpItem
                      WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
                      GROUP BY _tmpItem.AccountDirectionId_To
                             , _tmpItem.InfoMoneyDestinationId
                             , CASE WHEN GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_InfoMoneyDestination_WorkProgress() ELSE InfoMoneyDestinationId END
                     ) AS _tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.AccountDirectionId_To = _tmpItem.AccountDirectionId_To
                                      AND _tmpItem_byAccount.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 1.3.2. ������������ ContainerId ��� �������� �� ��������� ����� - ����  + ����������� ��������� <������� �/�>
     UPDATE _tmpItemSumm SET ContainerId_To = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := _tmpItem.OperDate
                                                                                , inUnitId                 := _tmpItem.UnitId_To
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := _tmpItem.MemberId_To
                                                                                , inBranchId               := _tmpItem.BranchId_To
                                                                                , inJuridicalId_basis      := _tmpItem.JuridicalId_Basis_To
                                                                                , inBusinessId             := _tmpItem.BusinessId_To
                                                                                , inAccountId              := _tmpItemSumm.AccountId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                , inInfoMoneyId_Detail     := _tmpItemSumm.InfoMoneyId_Detail_From
                                                                                , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTo
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                 )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 1.3.3. ����������� �������� ��� ��������� ����� - ���� + ������������ MIContainer.Id
     UPDATE _tmpItemSumm SET MIContainerId_To = lpInsertUpdate_MovementItemContainer (ioId:= 0
                                                                                    , inDescId:= zc_MIContainer_Summ()
                                                                                    , inMovementId:= MovementId
                                                                                    , inMovementItemId:= _tmpItem.MovementItemId 
                                                                                    , inParentId:= NULL
                                                                                    , inContainerId:= _tmpItemSumm.ContainerId_To
                                                                                    , inAmount:= OperSumm
                                                                                    , inOperDate:= OperDate
                                                                                    , inIsActive:= TRUE
                                                                                     )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 1.3.4. ����������� �������� ��� ��������� ����� - �� ����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, MovementId, _tmpItem.MovementItemId, ContainerId_From, _tmpItemSumm.MIContainerId_To AS ParentId, -1 * OperSumm, OperDate, FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;


     -- 2. ����������� �������� ��� ������ (���������: ����� ������ � ����� ������)
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId := _tmpItem.MovementId
                                              , inMovementItemId := _tmpItemSumm.MovementItemId
                                              , inActiveContainerId  := _tmpItemSumm.ContainerId_To
                                              , inPassiveContainerId := _tmpItemSumm.ContainerId_From
                                              , inActiveAccountId    := _tmpItemSumm.AccountId_To
                                              , inPassiveAccountId   := _tmpItemSumm.AccountId_From
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItemSumm.ContainerId_To
                                                                                                    , inPassiveContainerId := _tmpItemSumm.ContainerId_From
                                                                                                    , inActiveAccountId    := _tmpItemSumm.AccountId_To
                                                                                                    , inPassiveAccountId   := _tmpItemSumm.AccountId_From
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItemSumm.ContainerId_To
                                                                                                             , inPassiveContainerId := _tmpItemSumm.ContainerId_From
                                                                                                             , inActiveAccountId    := _tmpItemSumm.AccountId_To
                                                                                                             , inPassiveAccountId   := _tmpItemSumm.AccountId_From
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                     )
                                              , inAmount := _tmpItemSumm.OperSumm
                                              , inOperDate := _tmpItem.OperDate
                                               )
     FROM _tmpItemSumm
          JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
     ;


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ����� - ����������� ������ ������ ���������
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_Send() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.12.13                                        * Personal -> Member
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 03.10.13                                        * add inCarId := NULL
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 15.09.13                                        * add zc_Enum_Account_20901
 14.09.13                                        * add zc_ObjectLink_Goods_Business
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 26.08.13                                        * add zc_InfoMoneyDestination_WorkProgress
 11.08.13                                        * add inIsLastComplete
 10.08.13                                        * � ��������� ��� ��������������� � ��������� �����: Master - ������, Child - ������ (�.�. ����������� �� ����� 1:1)
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 07.08.13                                        * add inParentId and inIsActive
 24.07.13                                        * !�����������! ��������� ����
 20.07.13                                        * add MovementItemId
 20.07.13                                        * all ������ ������, ���� ���� ...
 19.07.13                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
