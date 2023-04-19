-- Function: lpComplete_Movement_Send()

DROP FUNCTION IF EXISTS lpComplete_Movement_Send (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send(
    IN inMovementId  Integer, -- ���� ���������
    IN inUserId      Integer  -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbIsHistoryCost Boolean; -- ����� �������� �/� ��� ����� ������������

  DECLARE vbMovementDescId Integer;

  DECLARE vbWhereObjectId_Analyzer_From  Integer;
  DECLARE vbWhereObjectId_Analyzer_To    Integer;

  DECLARE vbIsPartionGoodsKind_Unit_From Boolean;
  DECLARE vbIsPartionGoodsKind_Unit_To   Boolean;

  DECLARE vbIsAssetBalance_to Boolean;
BEGIN
     -- ��� ��������� ����� ���
     vbMovementDescId:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);
     
     -- ���� ���� ������� ������� � ��������� � ������ ������ ���-��
     vbIsAssetBalance_to:= COALESCE ('30.01.2021' = (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_SendAsset()), FALSE)
   --AND 1=0
    ;


     -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = zc_Enum_Role_Admin())
     THEN
          vbIsHistoryCost:= TRUE;
     ELSE
         -- !!! ��� ��������� ���� ����� �������� �/�!!!
         IF 0 < (SELECT 1 FROM Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide WHERE View_RoleAccessKeyGuide.UserId = inUserId AND View_RoleAccessKeyGuide.BranchId <> 0 GROUP BY View_RoleAccessKeyGuide.BranchId LIMIT 1)
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382)) -- ��������� �����
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (97837)) -- ��������� �����
         THEN vbIsHistoryCost:= FALSE;
         ELSE vbIsHistoryCost:= TRUE;
         END IF;
     END IF;


     -- ��������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId, MovementId, OperDate, UnitId_From, MemberId_From, CarId_From, BranchId_From, UnitId_To, MemberId_To, CarId_To, BranchId_To
                         , ContainerDescId, MIContainerId_To, MIContainerId_count_To, ContainerId_GoodsFrom, ContainerId_GoodsTo, ContainerId_countFrom, ContainerId_countTo, ObjectDescId, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate_From, PartionGoodsDate_To
                         , OperCount, OperCountCount
                         , AccountDirectionId_From, AccountDirectionId_To, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , JuridicalId_basis_To, BusinessId_To
                         , StorageId_mi, PartionGoodsId_mi
                         , isPartionCount, isPartionSumm, isPartionDate_From, isPartionDate_To, isPartionGoodsKind_From, isPartionGoodsKind_To
                         , PartionGoodsId_From, PartionGoodsId_To
                         , ProfitLossGroupId, ProfitLossDirectionId, UnitId_ProfitLoss, BranchId_ProfitLoss, BusinessId_ProfitLoss
                          )
        WITH tmpMember AS (SELECT lfSelect.MemberId, lfSelect.UnitId
                           FROM lfSelect_Object_Member_findPersonal (lfGet_User_Session (inUserId)) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
           , tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                            , MovementItem.MovementId
                            , Movement.OperDate
                            , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()   THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId_From
                            , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS MemberId_From
                            , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Car()    THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS CarId_From
                            , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()   THEN ObjectLink_UnitFrom_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_From

                            , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit()   THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS UnitId_To
                            , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS MemberId_To
                            , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Car()    THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS CarId_To
                            , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit()   THEN ObjectLink_UnitTo_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_To

                            , Object_Goods.DescId AS ObjectDescId
                            , MovementItem.ObjectId AS GoodsId
                            , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ���������
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                                   WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_30102()) -- �������
                                    AND MILinkObject_GoodsKind.ObjectId <> zc_GoodsKind_Basis()
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                   ELSE 0
                              END AS GoodsKindId
                            , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_complete
                            , CASE WHEN vbMovementDescId = zc_Movement_SendAsset() AND Object_Goods.DescId = zc_Object_Asset() THEN Object_Goods.Id ELSE 0 END AS AssetId
                            , COALESCE (MILinkObject_Storage.ObjectId, 0)    AS StorageId_mi
                            , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                            , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate_From
                            , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate_To

                            , COALESCE (MIFloat_ContainerId.ValueData, 0) :: Integer AS ContainerId_asset
                            , COALESCE (CLO_PartionGoods.ObjectId, 0)                AS PartionGoodsId_asset

                              -- ��� ����������
                            , CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_20202()
                                    AND MILinkObject_PartionGoods.ObjectId > 0
                                        THEN MILinkObject_PartionGoods.ObjectId
                                   ELSE 0
                              END AS PartionGoodsId_mi

                            , MovementItem.Amount AS OperCount
                            , COALESCE (MIFloat_Count.ValueData, 0) AS OperCountCount

                            -- ��������� ������ - ����������� (�� ����)
                            , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()
                                                 THEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId
                                             WHEN Object_From.DescId = zc_Object_Member()
                                               OR Object_From.DescId = zc_Object_Car()
                                                 THEN CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "�������� �����"; 10100; "������ �����"
                                                                                                        , zc_Enum_InfoMoneyDestination_20700() -- "�������������"; 20700; "������"
                                                                                                        , zc_Enum_InfoMoneyDestination_20900() -- "�������������"; 20900; "����"
                                                                                                        , zc_Enum_InfoMoneyDestination_21000() -- "�������������"; 21000; "�����"
                                                                                                        , zc_Enum_InfoMoneyDestination_21100() -- "�������������"; 21100; "�������"
                                                                                                        , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                                        , zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                                                                                         )
                                                               THEN 0 -- !!!�� � ���������� (��), � ����� ������!!! zc_Enum_AccountDirection_20600() -- "������"; 20600; "���������� (�����������)"
                                                           ELSE zc_Enum_AccountDirection_20500() -- "������"; 20500; "���������� (��)"
                                                      END
                                        END, 0) AS AccountDirectionId_From
                            -- ��������� ������ - ����������� (����)
                            , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit()
                                                 THEN ObjectLink_UnitTo_AccountDirection.ChildObjectId
                                             WHEN Object_To.DescId = zc_Object_Member()
                                               OR Object_To.DescId = zc_Object_Car()
                                                 THEN CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "�������� �����"; 10100; "������ �����"
                                                                                                        , zc_Enum_InfoMoneyDestination_20700() -- "�������������"; 20700; "������"
                                                                                                        , zc_Enum_InfoMoneyDestination_20900() -- "�������������"; 20900; "����"
                                                                                                        , zc_Enum_InfoMoneyDestination_21000() -- "�������������"; 21000; "�����"
                                                                                                        , zc_Enum_InfoMoneyDestination_21100() -- "�������������"; 21100; "�������"
                                                                                                        , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                                        , zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                                                                                         )
                                                               THEN 0 -- !!!�� � ���������� (��), � ����� ������!!! zc_Enum_AccountDirection_20600() -- "������"; 20600; "���������� (�����������)"
                                                           ELSE zc_Enum_AccountDirection_20500() -- "������"; 20500; "���������� (��)"
                                                      END
                                        END, 0) AS AccountDirectionId_To
                              -- �������������� ������
                            , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
                            -- �������������� ���������� (?�� ����? � ����)
                            , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                            -- ������ ���������� (?�� ����? � ����)
                            , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                            , COALESCE (ObjectLink_UnitTo_Juridical.ChildObjectId, zc_Juridical_Basis()) AS JuridicalId_basis_To
                              -- ����� ������ �� ������ ��� ������������
                            , COALESCE (ObjectLink_Goods_Business.ChildObjectId, COALESCE (ObjectLink_UnitTo_Business.ChildObjectId, 0)) AS BusinessId_To

                            , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)     AS isPartionCount
                            , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)      AS isPartionSumm
                            , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE) AS isPartionDate_From
                            , COALESCE (ObjectBoolean_PartionDate_To.ValueData, FALSE)   AS isPartionDate_To
                            , COALESCE (ObjectBoolean_PartionGoodsKind_From.ValueData, TRUE) AS isPartionGoodsKind_From
                            , COALESCE (ObjectBoolean_PartionGoodsKind_To.ValueData, TRUE)   AS isPartionGoodsKind_To

                              -- ������ ���� - ����� �����������
                            , CASE WHEN Movement.OperDate >= '01.05.2017'
                                    AND Object_From.Id IN (8455 , 8456) -- ����� ������ + ����� ���������
                                    AND Object_To_find.DescId IN (zc_Object_Member()) -- , zc_Object_Car()
                                    AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- �������� � �������
                                                                                , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                                                , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                                                 )
                                        THEN COALESCE (lfSelect.ProfitLossGroupId, 1)
                              END AS ProfitLossGroupId
                              -- ��������� ���� - �����������
                            , COALESCE (lfSelect.ProfitLossDirectionId, 0) AS ProfitLossDirectionId

                              -- ��� ����
                            , tmpMemberTo.UnitId                                  AS UnitId_ProfitLoss
                              -- ��� ����
                            , ObjectLink_UnitTo_Branch_ProfitLoss.ChildObjectId   AS BranchId_ProfitLoss
                              -- ��� ����
                            , ObjectLink_UnitTo_Business_ProfitLoss.ChildObjectId AS BusinessId_ProfitLoss

                        FROM Movement
                             JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                              ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                                              ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                              ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()

                             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                         ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Count.DescId         = zc_MIFloat_Count()

                             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                         AND MIString_PartionGoods.DescId         = zc_MIString_PartionGoods()
                                                         AND MIString_PartionGoods.ValueData      <> '0'
                             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                        ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                         ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                        AND vbMovementDescId                   = zc_Movement_SendAsset()
                             LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                           ON CLO_PartionGoods.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = MovementItem.MovementId
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                             LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver_from
                                                  ON ObjectLink_Car_PersonalDriver_from.ObjectId = MovementLinkObject_From.ObjectId
                                                 AND ObjectLink_Car_PersonalDriver_from.DescId = zc_ObjectLink_Car_PersonalDriver()
                             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_from
                                                  ON ObjectLink_Personal_Member_from.ObjectId = ObjectLink_Car_PersonalDriver_from.ChildObjectId
                                                 AND ObjectLink_Personal_Member_from.DescId = zc_ObjectLink_Personal_Member()
                             -- LEFT JOIN Object AS Object_From ON Object_From.Id = COALESCE (ObjectLink_Personal_Member_from.ChildObjectId, MovementLinkObject_From.ObjectId)
                             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                             LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                                  ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                                 AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                                 AND Object_From.DescId = zc_Object_Unit()
                             LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                                  ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                                 AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                                                 AND Object_From.DescId = zc_Object_Unit()

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = MovementItem.MovementId
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                             LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver_to
                                                  ON ObjectLink_Car_PersonalDriver_to.ObjectId = MovementLinkObject_To.ObjectId
                                                 AND ObjectLink_Car_PersonalDriver_to.DescId = zc_ObjectLink_Car_PersonalDriver()
                             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_to
                                                  ON ObjectLink_Personal_Member_to.ObjectId = ObjectLink_Car_PersonalDriver_to.ChildObjectId
                                                 AND ObjectLink_Personal_Member_to.DescId = zc_ObjectLink_Personal_Member()
                             -- LEFT JOIN Object AS Object_To ON Object_To.Id = COALESCE (ObjectLink_Personal_Member_to.ChildObjectId, MovementLinkObject_To.ObjectId)
                             LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                             LEFT JOIN Object AS Object_To_find ON Object_To_find.Id = MovementLinkObject_To.ObjectId

                             -- ��� ������
                             LEFT JOIN tmpMember AS tmpMemberTo ON tmpMemberTo.MemberId = MovementLinkObject_To.ObjectId
                             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfSelect ON lfSelect.UnitId = tmpMemberTo.UnitId
                             LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch_ProfitLoss
                                                  ON ObjectLink_UnitTo_Branch_ProfitLoss.ObjectId = tmpMemberTo.UnitId
                                                 AND ObjectLink_UnitTo_Branch_ProfitLoss.DescId = zc_ObjectLink_Unit_Branch()
                             LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Business_ProfitLoss
                                                  ON ObjectLink_UnitTo_Business_ProfitLoss.ObjectId = tmpMemberTo.UnitId
                                                 AND ObjectLink_UnitTo_Business_ProfitLoss.DescId = zc_ObjectLink_Unit_Business()

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

                             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_From
                                                     ON ObjectBoolean_PartionDate_From.ObjectId = MovementLinkObject_From.ObjectId
                                                    AND ObjectBoolean_PartionDate_From.DescId = zc_ObjectBoolean_Unit_PartionDate()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_To
                                                     ON ObjectBoolean_PartionDate_To.ObjectId = MovementLinkObject_To.ObjectId
                                                    AND ObjectBoolean_PartionDate_To.DescId = zc_ObjectBoolean_Unit_PartionDate()

                             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind_From
                                                     ON ObjectBoolean_PartionGoodsKind_From.ObjectId = MovementLinkObject_From.ObjectId
                                                    AND ObjectBoolean_PartionGoodsKind_From.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind_To
                                                     ON ObjectBoolean_PartionGoodsKind_To.ObjectId = MovementLinkObject_To.ObjectId
                                                    AND ObjectBoolean_PartionGoodsKind_To.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()

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

                             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                             ON View_InfoMoney.InfoMoneyId = CASE WHEN Object_Goods.DescId = zc_Object_Asset()
                                                                                                       THEN -- !!!�������� �����������!!! - ����������� ���������� + ���������������� ������������
                                                                                                            zc_Enum_InfoMoney_70102()
                                                                                                  ELSE ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                             END
                        WHERE Movement.Id = inMovementId
                          AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                       )
, tmpContainer_asset AS (SELECT tmpMI.ContainerId_asset
                              , Container_count.DescId AS ContainerDescId
                                -- ���� �� ������ ������ - ����������� ���������� + ���������������� ������������
                              , COALESCE (CLO_InfoMoney.ObjectId, zc_Enum_InfoMoney_70102()) AS InfoMoneyId
                              , ROW_NUMBER()     OVER (PARTITION BY tmpMI.ContainerId_asset ORDER BY CLO_InfoMoney.ObjectId ASC) AS Ord -- !!!�� ������ ������!!!
                         FROM tmpMI
                              LEFT JOIN Container AS Container_count ON Container_count.Id = tmpMI.ContainerId_asset
                              LEFT JOIN Container ON Container.ParentId = tmpMI.ContainerId_asset
                                                 AND Container.DescId   IN (zc_Container_Summ(), zc_Container_SummAsset())
                              LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                            ON CLO_InfoMoney.ContainerId = Container.Id
                                                           AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                         WHERE tmpMI.ContainerId_asset > 0
                        )
, tmpContainer_all AS (SELECT tmpMI.MovementItemId
                            , tmpMI.GoodsId
                            , tmpMI.OperCount  AS Amount
                            , tmp.ContainerId  AS ContainerId
                            , tmp.Amount       AS Amount_container
                            , SUM (tmp.Amount) OVER (PARTITION BY tmpMI.GoodsId
                                                     ORDER BY CASE WHEN tmpMI.PartionGoods = tmp.PartionGoods AND tmpMI.PartionGoods <> '' THEN 0 ELSE 1 END
                                                            , tmp.PartionGoodsDate
                                                            , tmp.ContainerId
                                                    )  AS AmountSUM --
                            , ROW_NUMBER()     OVER (PARTITION BY tmpMI.GoodsId
                                                     ORDER BY CASE WHEN tmpMI.PartionGoods = tmp.PartionGoods AND tmpMI.PartionGoods <> '' THEN 0 ELSE 1 END
                                                            , tmp.PartionGoodsDate DESC
                                                            , tmp.ContainerId DESC
                                                    ) AS Ord      -- !!!���� �������� ���������!!!
                            , tmp.PartionGoodsId
                       FROM tmpMI
                            INNER JOIN (SELECT tmpMI.MovementItemId                                  AS MovementItemId
                                             , Container.Id                                          AS ContainerId
                                             , Container.Amount                                      AS Amount
                                             , COALESCE (CLO_PartionGoods.ObjectId, 0)               AS PartionGoodsId
                                             , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                                             , COALESCE (Object_PartionGoods.ValueData, '')          AS PartionGoods
                                        FROM tmpMI
                                             INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                                 AND Container.DescId   = zc_Container_Count()
                                                                 AND Container.Amount   > 0
                                             INNER JOIN ContainerLinkObject AS CLO_Member
                                                                            ON CLO_Member.ContainerId = Container.Id
                                                                           AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                                                                                      -- !!!���� ������ � ���������!!!
                                                                           AND CLO_Member.ObjectId    = (SELECT DISTINCT CASE WHEN tmpMI.MemberId_From > 0 THEN tmpMI.MemberId_From ELSE tmpMI.CarId_From END FROM tmpMI WHERE tmpMI.MemberId_From <> 0 OR tmpMI.CarId_From <> 0)
                                             -- !!!
                                             LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                           ON CLO_PartionGoods.ContainerId = Container.Id
                                                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                             LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                                     AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                             LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                                        WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                                             , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                                             , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                                             , zc_Enum_InfoMoneyDestination_70100() -- ���������� + ����������� ����������
                                                                             , zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                                             , zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                                             , zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                                             , zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                                              )
                                          -- ������ �� ����������� ��
                                          AND tmpMI.ContainerId_asset = 0
                                          -- ������
                                          AND (Object_PartionGoods.ValueData = tmpMI.PartionGoods OR tmpMI.PartionGoods = '')

                                       UNION ALL
                                        SELECT tmpMI.MovementItemId                                  AS MovementItemId
                                             , Container.Id                                          AS ContainerId
                                             , Container.Amount                                      AS Amount
                                             , COALESCE (CLO_PartionGoods.ObjectId, 0)               AS PartionGoodsId
                                             , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                                             , COALESCE (Object_PartionGoods.ValueData, '')          AS PartionGoods
                                        FROM tmpMI
                                             INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                                 AND Container.DescId   = zc_Container_Count()
                                                                 AND Container.Amount   > 0
                                             INNER JOIN ContainerLinkObject AS CLO_Car
                                                                            ON CLO_Car.ContainerId = Container.Id
                                                                           AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
                                                                           AND CLO_Car.ObjectId    = (SELECT DISTINCT tmpMI.CarId_From FROM tmpMI WHERE tmpMI.CarId_From <> 0)
                                             -- !!!
                                             LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                           ON CLO_PartionGoods.ContainerId = Container.Id
                                                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                             LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                                     AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                             LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                                        WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                                             , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                                             , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                                             , zc_Enum_InfoMoneyDestination_70100() -- ���������� + ����������� ����������
                                                                             , zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                                             , zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                                             , zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                                             , zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                                              )
                                          -- ������ �� ����������� ��
                                          AND tmpMI.ContainerId_asset = 0
                                          -- ������
                                          AND (Object_PartionGoods.ValueData = tmpMI.PartionGoods OR tmpMI.PartionGoods = '')

                                       ) AS tmp ON tmp.MovementItemId = tmpMI.MovementItemId
                      )
    , tmpContainer AS (SELECT DD.ContainerId
                            , DD.GoodsId
                            , DD.MovementItemId
                            , DD.PartionGoodsId
                            , CASE WHEN DD.Amount - DD.AmountSUM > 0 AND DD.Ord <> 1
                                        THEN DD.Amount_container
                                   ELSE DD.Amount - DD.AmountSUM + DD.Amount_container
                              END AS Amount
                       FROM (SELECT * FROM tmpContainer_all) AS DD
                       WHERE DD.Amount - (DD.AmountSUM - DD.Amount_container) > 0
                      )
        -- ���������
        SELECT
              _tmp.MovementItemId
            , _tmp.MovementId
            , _tmp.OperDate
            , _tmp.UnitId_From
            , _tmp.MemberId_From
            , _tmp.CarId_From
            , _tmp.BranchId_From

            , _tmp.UnitId_To
            , _tmp.MemberId_To
            , _tmp.CarId_To
            , _tmp.BranchId_To
            
            , tmpContainer_asset.ContainerDescId

              -- ���������� �����
            , 0 AS MIContainerId_To
            , 0 AS MIContainerId_count_To
              -- !!!��� ������ ������ ��� ��!!!
            , CASE WHEN vbMovementDescId = zc_Movement_SendAsset() THEN _tmp.ContainerId_asset ELSE COALESCE (tmpContainer.ContainerId, 0) END AS ContainerId_GoodsFrom
            , 0 AS ContainerId_GoodsTo
            , 0 AS ContainerId_countFrom
            , 0 AS ContainerId_countTo

            , _tmp.ObjectDescId
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.GoodsKindId_complete
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate_From
            , _tmp.PartionGoodsDate_To

              -- !!!��� ������ ������!!!
            , COALESCE (tmpContainer.Amount, _tmp.OperCount) AS OperCount
            , _tmp.OperCountCount                            AS OperCountCount

              -- ��������� ������ - ����������� (�� ����)
            , _tmp.AccountDirectionId_From
              -- ��������� ������ - ����������� (����)
            , _tmp.AccountDirectionId_To
              -- �������������� ������
            , COALESCE (View_InfoMoney.InfoMoneyGroupId, _tmp.InfoMoneyGroupId) AS InfoMoneyGroupId
              -- �������������� ���������� (?�� ����? � ����)
            , COALESCE (View_InfoMoney.InfoMoneyDestinationId, _tmp.InfoMoneyDestinationId) AS InfoMoneyDestinationId
              -- ������ ���������� (?�� ����? � ����)
            , COALESCE (View_InfoMoney.InfoMoneyId, _tmp.InfoMoneyId) AS InfoMoneyId

            , _tmp.JuridicalId_basis_To
            , _tmp.BusinessId_To

            , _tmp.StorageId_mi
              -- !!!��� ������ ������!!!
            , COALESCE (tmpContainer.PartionGoodsId, 0) AS PartionGoodsId_mi

            , _tmp.isPartionCount
            , _tmp.isPartionSumm
            , _tmp.isPartionDate_From
            , _tmp.isPartionDate_To
            , _tmp.isPartionGoodsKind_From
            , _tmp.isPartionGoodsKind_To
              -- ������ ������, ���������� �����
            , CASE WHEN vbMovementDescId = zc_Movement_SendAsset()
                        THEN _tmp.PartionGoodsId_asset
                   -- ����������
                   WHEN _tmp.PartionGoodsId_mi > 0 AND _tmp.InfoMoneyId = zc_Enum_InfoMoney_20202()
                        THEN _tmp.PartionGoodsId_mi
                   ELSE 0
              END AS PartionGoodsId_From

            , CASE WHEN vbMovementDescId = zc_Movement_SendAsset() THEN _tmp.PartionGoodsId_asset ELSE 0 END AS PartionGoodsId_To

              -- ������ ����
            , _tmp.ProfitLossGroupId
              -- ��������� ���� - �����������
            , _tmp.ProfitLossDirectionId
              -- ��� ����
            , _tmp.UnitId_ProfitLoss
              -- ��� ����
            , _tmp.BranchId_ProfitLoss
              -- ��� ����
            , _tmp.BusinessId_ProfitLoss

        FROM tmpMI AS _tmp
             LEFT JOIN tmpContainer       ON tmpContainer.MovementItemId          = _tmp.MovementItemId
                                       --AND _tmp.InfoMoneyId <> zc_Enum_InfoMoney_20202() -- ����������
             LEFT JOIN tmpContainer_asset ON tmpContainer_asset.ContainerId_asset = _tmp.ContainerId_asset
                                         AND tmpContainer_asset.Ord               = 1
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                             ON View_InfoMoney.InfoMoneyId = tmpContainer_asset.InfoMoneyId
       ;

     -- �������� - ��� ��
     IF EXISTS (SELECT 1
                FROM _tmpItem
                WHERE _tmpItem.ObjectDescId = zc_Object_Asset()
                   AND (COALESCE (_tmpItem.ContainerId_GoodsFrom, 0) = 0 OR COALESCE (_tmpItem.PartionGoodsId_From, 0) = 0 OR COALESCE (_tmpItem.PartionGoodsId_To, 0) = 0)
               )
     THEN
          RAISE EXCEPTION '������.��� �� <%> ������ ���� ������� ������.'
                        , lfGet_Object_ValueData_sh ((SELECT _tmpItem.GoodsId
                                                      FROM _tmpItem
                                                      WHERE _tmpItem.ObjectDescId = zc_Object_Asset()
                                                        AND (COALESCE (_tmpItem.ContainerId_GoodsFrom, 0) = 0
                                                          OR COALESCE (_tmpItem.PartionGoodsId_From, 0)   = 0
                                                          OR COALESCE (_tmpItem.PartionGoodsId_To, 0)     = 0)
                                                      LIMIT 1
                                                     ))
                                                     ;
     END IF;


     -- ����� ������ - ��� ����.�������
     IF vbMovementDescId = zc_Movement_Send() AND 1=1 -- AND inUserId = zfCalc_UserAdmin() :: Integer
        -- ��� �������� �������
        AND (8006902 = (SELECT DISTINCT _tmpItem.UnitId_From FROM _tmpItem)
        -- 
        OR  (8451 = (SELECT DISTINCT _tmpItem.UnitId_From FROM _tmpItem) -- ��� ��������
         AND 8459 = (SELECT DISTINCT _tmpItem.UnitId_To   FROM _tmpItem) -- ����������� ��������
         AND EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_30102()) -- �������
            ))
     THEN
         -- !!!��������� - �����������/������� �����������!!! - �� ��������� "�����������" - !!!����� - ����� ��������� _tmpMIContainer_insert, ������� ������ �� ��������!!!, �� ����� ���������� _tmpItem
         PERFORM lpComplete_Movement_Send_PackTush (inMovementId := inMovementId
                                                  , inUnitId     := (SELECT DISTINCT _tmpItem.UnitId_From FROM _tmpItem)
                                                  , inUserId     := inUserId
                                                   );
     -- ����� ������ - ��� �����
     ELSEIF vbMovementDescId = zc_Movement_Send() AND 1=1 -- inUserId <> zfCalc_UserAdmin() :: Integer
     THEN
         -- !!!��������� - �����������/������� �����������!!! - �� ��������� "�����������" - !!!����� - ����� ��������� _tmpMIContainer_insert, ������� ������ �� ��������!!!, �� ����� ���������� _tmpItem
         PERFORM lpComplete_Movement_Send_Recalc_sub (inMovementId := inMovementId
                                                    , inUnitId     := (SELECT DISTINCT _tmpItem.UnitId_From FROM _tmpItem)
                                                    , inUserId     := inUserId
                                                     );
     END IF;


IF inUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION '������.<%>  %   %', (select _tmpItem.PartionGoods from _tmpItem)
    , (select _tmpItem.PartionGoodsId_mi from _tmpItem)
    , (select _tmpItem.PartionGoodsId_From from _tmpItem)
    ;
end if;

     -- �1 - ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId_From = CASE -- ���������� + PartionGoodsId_asset
                                                    WHEN _tmpItem.PartionGoodsId_From > 0
                                                         THEN _tmpItem.PartionGoodsId_From

                                                    -- �������� � ������� + ����
                                                    WHEN _tmpItem.OperDate >= zc_DateStart_PartionGoods_20103()
                                                     AND _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20103()
                                                        THEN lpInsertFind_Object_PartionGoods (inValue:= _tmpItem.PartionGoods)

                                                    WHEN (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                         )
                                                      AND (_tmpItem.PartionGoodsId_mi   > 0
                                                        OR _tmpItem.ContainerId_GoodsFrom > 0
                                                          )
                                                   -- AND _tmpItem.MemberId_From          > 0
                                                        THEN _tmpItem.PartionGoodsId_mi

                                                    -- ����������
                                                    WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20202() AND _tmpItem.PartionGoods <> ''
                                                         THEN lpInsertFind_Object_PartionGoods (inValue       := _tmpItem.PartionGoods
                                                                                              , inOperDate    := zc_DateStart()
                                                                                              , inInfoMoneyId := zc_Enum_InfoMoney_20202()
                                                                                               )

                                                    WHEN _tmpItem.ObjectDescId     = zc_Object_Asset()
                                                      OR _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- ����������
                                                      OR ((_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                          )
                                                         AND (_tmpItem.MemberId_From > 0
                                                           OR _tmpItem.CarId_From    > 0
                                                             )
                                                         )

                                                         THEN (SELECT tmp.PartionGoodsId
                                                               FROM
                                                              (SELECT CASE WHEN CLO_PartionGoods.ObjectId         = ObjectLink_Goods.ObjectId
                                                                            AND COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.CarId_From
                                                                            AND Container.Amount > 0
                                                                            AND _tmpItem.ObjectDescId <> zc_Object_Asset()
                                                                                -- !!!���� ������ � ���������!!!
                                                                                THEN -1 * Container.Id
                                                                           ELSE CLO_PartionGoods.ObjectId -- ObjectLink_Goods.ObjectId
                                                                      END AS PartionGoodsId
                                                                    , CASE WHEN CLO_PartionGoods.ObjectId         = ObjectLink_Goods.ObjectId
                                                                              AND COALESCE (CLO_Unit.ObjectId, 0)   = _tmpItem.UnitId_From
                                                                              AND COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.MemberId_From
                                                                              AND Container.Amount > 0
                                                                                  THEN 1
                                                                             WHEN CLO_PartionGoods.ObjectId         = ObjectLink_Goods.ObjectId
                                                                              AND COALESCE (CLO_Car.ObjectId, 0)    = _tmpItem.CarId_From
                                                                              AND Container.Amount > 0
                                                                                  THEN 2
                                                                             -- !!!���� ������ � ���������!!!
                                                                             WHEN CLO_PartionGoods.ObjectId         = ObjectLink_Goods.ObjectId
                                                                              AND COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.CarId_From
                                                                              AND Container.Amount > 0
                                                                              AND _tmpItem.ObjectDescId <> zc_Object_Asset()
                                                                                  THEN 3

                                                                             WHEN COALESCE (CLO_Car.ObjectId, 0)    = _tmpItem.CarId_From
                                                                                  THEN 211
                                                                             WHEN COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.CarId_From
                                                                                  THEN 212
                                                                             WHEN COALESCE (CLO_Unit.ObjectId, 0)   = _tmpItem.UnitId_From
                                                                              AND COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.MemberId_From
                                                                                  THEN 213
                                                                             ELSE 301
                                                                        END AS NPP
                                                                      , Container.Amount
                                                               FROM ObjectLink AS ObjectLink_Goods
                                                                    INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                                          ON ObjectLink_Unit.ObjectId = ObjectLink_Goods.ObjectId
                                                                                         AND ObjectLink_Unit.DescId   = zc_ObjectLink_PartionGoods_Unit()
                                                                    INNER JOIN ObjectLink AS ObjectLink_Storage
                                                                                          ON ObjectLink_Storage.ObjectId = ObjectLink_Goods.ObjectId
                                                                                         AND ObjectLink_Storage.DescId   = zc_ObjectLink_PartionGoods_Storage()
                                                                    LEFT JOIN Container ON Container.ObjectId = ObjectLink_Goods.ChildObjectId
                                                                                       AND Container.DescId   = zc_Container_Count()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                                                  ON CLO_Unit.ContainerId = Container.Id
                                                                                                 AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_Member
                                                                                                  ON CLO_Member.ContainerId = Container.Id
                                                                                                 AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_Car
                                                                                                  ON CLO_Car.ContainerId = Container.Id
                                                                                                 AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                 AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                               WHERE ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                                 AND ObjectLink_Goods.ChildObjectId = _tmpItem.GoodsId
                                                              UNION ALL
                                                               -- ��� ������ - ������ ������ + � CLO_Member = CarId_From
                                                               SELECT -1 * Container.Id AS PartionGoodsId -- !!!���� ������ � ���������!!!
                                                                    , 101 AS NPP
                                                                    , Container.Amount
                                                               FROM Container
                                                                    INNER JOIN ContainerLinkObject AS CLO_Member
                                                                                                   ON CLO_Member.ContainerId = Container.Id
                                                                                                  AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                                                                                  AND CLO_Member.ObjectId    = _tmpItem.CarId_From
                                                                    /*INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                   ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                  AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                                                  AND CLO_PartionGoods.ObjectId    = 0*/
                                                               WHERE Container.ObjectId  = _tmpItem.GoodsId
                                                                 AND Container.DescId    = zc_Container_Count()
                                                                 AND Container.Amount    > 0
                                                                 AND _tmpItem.CarId_From > 0
                                                              ) AS tmp
                                                               ORDER BY tmp.NPP ASC
                                                                      , tmp.Amount DESC
                                                               LIMIT 1
                                                              )
                                                    WHEN _tmpItem.OperDate >= zc_DateStart_PartionGoods()
                                                     AND _tmpItem.AccountDirectionId_From = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN _tmpItem.isPartionDate_From = TRUE
                                                     AND _tmpItem.PartionGoodsDate_From <> zc_DateEnd()
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem.PartionGoodsDate_From
                                                                                             , inGoodsKindId_complete := _tmpItem.GoodsKindId_complete
                                                                                              )
                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                                        THEN 0

                                                    WHEN (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                         )
                                                        THEN _tmpItem.PartionGoodsId_mi

                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
                         , PartionGoodsId_To = CASE WHEN _tmpItem.PartionGoodsId_To > 0
                                                         THEN _tmpItem.PartionGoodsId_To

                                                    -- ����������
                                                    WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20202() AND _tmpItem.PartionGoods <> '' AND _tmpItem.PartionGoodsId_mi <> 0
                                                         AND 0 < (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem.PartionGoodsId_mi AND OL.DescId  = zc_ObjectLink_PartionGoods_Unit())
                                                         THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem.PartionGoodsId_mi AND OL.DescId  = zc_ObjectLink_PartionGoods_Unit())
                                                                                              , inGoodsId       := _tmpItem.GoodsId
                                                                                              , inStorageId     := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem.PartionGoodsId_mi AND OL.DescId  = zc_ObjectLink_PartionGoods_Storage())
                                                                                              , inInvNumber     := _tmpItem.PartionGoods
                                                                                              , inOperDate      := (SELECT OD.ValueData  FROM ObjectDate  AS OD  WHERE OD.ObjectId  = _tmpItem.PartionGoodsId_mi AND OD.DescId  = zc_ObjectDate_PartionGoods_Value())
                                                                                              , inPrice         := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = _tmpItem.PartionGoodsId_mi AND OFl.DescId = zc_ObjectFloat_PartionGoods_Price())
                                                                                               )

                                                    -- ����������
                                                    WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20202() AND _tmpItem.PartionGoods <> '' AND _tmpItem.PartionGoodsId_from <> 0
                                                         AND 0 < (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem.PartionGoodsId_from AND OL.DescId  = zc_ObjectLink_PartionGoods_Unit())
                                                         THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem.PartionGoodsId_from AND OL.DescId  = zc_ObjectLink_PartionGoods_Unit())
                                                                                              , inGoodsId       := _tmpItem.GoodsId
                                                                                              , inStorageId     := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem.PartionGoodsId_from AND OL.DescId  = zc_ObjectLink_PartionGoods_Storage())
                                                                                              , inInvNumber     := CASE WHEN _tmpItem.PartionGoods ILIKE '����%' THEN '' ELSE _tmpItem.PartionGoods END
                                                                                              , inOperDate      := (SELECT OD.ValueData  FROM ObjectDate  AS OD  WHERE OD.ObjectId  = _tmpItem.PartionGoodsId_from AND OD.DescId  = zc_ObjectDate_PartionGoods_Value())
                                                                                              , inPrice         := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = _tmpItem.PartionGoodsId_from AND OFl.DescId = zc_ObjectFloat_PartionGoods_Price())
                                                                                               )

                                                    -- ����������
                                                    WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20202() AND _tmpItem.PartionGoods <> ''
                                                         THEN lpInsertFind_Object_PartionGoods (inValue       := _tmpItem.PartionGoods
                                                                                              , inOperDate    := zc_DateStart()
                                                                                              , inInfoMoneyId := zc_Enum_InfoMoney_20202()
                                                                                               )

                                                    -- �������� � ������� + ����
                                                    WHEN _tmpItem.OperDate >= zc_DateStart_PartionGoods_20103()
                                                     AND _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20103()
                                                        THEN lpInsertFind_Object_PartionGoods (inValue:= _tmpItem.PartionGoods)

                                                    WHEN (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                         )
                                                      AND _tmpItem.PartionGoodsId_mi > 0
                                                      AND _tmpItem.MemberId_From       > 0
                                                      AND _tmpItem.MemberId_To         > 0
                                                        THEN _tmpItem.PartionGoodsId_mi

                                                    WHEN _tmpItem.ObjectDescId     = zc_Object_Asset()
                                                      OR _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- ����������
                                                      OR ((_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                          )
                                                         AND (_tmpItem.MemberId_From > 0
                                                           OR _tmpItem.CarId_From    > 0
                                                             )
                                                         AND _tmpItem.UnitId_To     = 0
                                                         -- AND _tmpItem.CarId_To      = 0
                                                         )
                                                         THEN (SELECT CLO_PartionGoods.ObjectId -- ObjectLink_Goods.ObjectId
                                                               FROM ObjectLink AS ObjectLink_Goods
                                                                    INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                                          ON ObjectLink_Unit.ObjectId = ObjectLink_Goods.ObjectId
                                                                                         AND ObjectLink_Unit.DescId   = zc_ObjectLink_PartionGoods_Unit()
                                                                    INNER JOIN ObjectLink AS ObjectLink_Storage
                                                                                          ON ObjectLink_Storage.ObjectId = ObjectLink_Goods.ObjectId
                                                                                         AND ObjectLink_Storage.DescId   = zc_ObjectLink_PartionGoods_Storage()
                                                                    LEFT JOIN Container ON Container.ObjectId = ObjectLink_Goods.ChildObjectId
                                                                                       AND Container.DescId   = zc_Container_Count()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                                                  ON CLO_Unit.ContainerId = Container.Id
                                                                                                 AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_Member
                                                                                                  ON CLO_Member.ContainerId = Container.Id
                                                                                                 AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_Car
                                                                                                  ON CLO_Car.ContainerId = Container.Id
                                                                                                 AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                 AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                               WHERE ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                                 AND ObjectLink_Goods.ChildObjectId = _tmpItem.GoodsId
                                                               ORDER BY CASE WHEN CLO_PartionGoods.ObjectId         = ObjectLink_Goods.ObjectId
                                                                              AND COALESCE (CLO_Unit.ObjectId, 0)   = _tmpItem.UnitId_From
                                                                              AND COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.MemberId_From
                                                                              AND Container.Amount > 0
                                                                                  THEN 1
                                                                             WHEN CLO_PartionGoods.ObjectId         = ObjectLink_Goods.ObjectId
                                                                              AND COALESCE (CLO_Car.ObjectId, 0)    = _tmpItem.CarId_From
                                                                              AND Container.Amount > 0
                                                                                  THEN 2
                                                                             -- !!!���� ������ � ���������!!!
                                                                             WHEN CLO_PartionGoods.ObjectId         = ObjectLink_Goods.ObjectId
                                                                              AND COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.CarId_From
                                                                              AND Container.Amount > 0
                                                                                  THEN 3

                                                                             WHEN COALESCE (CLO_Car.ObjectId, 0)    = _tmpItem.CarId_From
                                                                                  THEN 11
                                                                             WHEN COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.CarId_From
                                                                                  THEN 12
                                                                             WHEN COALESCE (CLO_Unit.ObjectId, 0)   = _tmpItem.UnitId_From
                                                                              AND COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.MemberId_From
                                                                                  THEN 13
                                                                             ELSE 21
                                                                        END ASC
                                                                      , Container.Amount DESC
                                                               LIMIT 1
                                                              )

                                                    WHEN  (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                          )
                                                      AND _tmpItem.UnitId_To > 0
                                                      AND EXISTS (SELECT CLO_PartionGoods.ObjectId
                                                                  FROM ObjectLink AS ObjectLink_Goods
                                                                       INNER JOIN Container ON Container.ObjectId = ObjectLink_Goods.ChildObjectId
                                                                                           AND Container.DescId   = zc_Container_Count()
                                                                                           AND Container.Amount   > 0
                                                                       INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                                                      ON CLO_Unit.ContainerId = Container.Id
                                                                                                     AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                                                     AND CLO_Unit.ObjectId    = _tmpItem.UnitId_To
                                                                       LEFT JOIN ContainerLinkObject AS CLO_Member
                                                                                                     ON CLO_Member.ContainerId = Container.Id
                                                                                                    AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                                                       INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                      ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                  WHERE ObjectLink_Goods.DescId           = zc_ObjectLink_PartionGoods_Goods()
                                                                    AND ObjectLink_Goods.ChildObjectId    = _tmpItem.GoodsId
                                                                    AND COALESCE (CLO_Member.ObjectId, 0) = 0
                                                                 )

                                                         THEN (SELECT CLO_PartionGoods.ObjectId
                                                               FROM ObjectLink AS ObjectLink_Goods
                                                                    INNER JOIN Container ON Container.ObjectId = ObjectLink_Goods.ChildObjectId
                                                                                        AND Container.DescId   = zc_Container_Count()
                                                                                        AND Container.Amount   > 0
                                                                    INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                                                   ON CLO_Unit.ContainerId = Container.Id
                                                                                                  AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                                                  AND CLO_Unit.ObjectId    = _tmpItem.UnitId_To
                                                                    LEFT JOIN ContainerLinkObject AS CLO_Member
                                                                                                  ON CLO_Member.ContainerId = Container.Id
                                                                                                 AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                                                    INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                   ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                  AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                               WHERE ObjectLink_Goods.DescId           = zc_ObjectLink_PartionGoods_Goods()
                                                                 AND ObjectLink_Goods.ChildObjectId    = _tmpItem.GoodsId
                                                                 AND COALESCE (CLO_Member.ObjectId, 0) = 0
                                                               ORDER BY Container.Amount DESC
                                                               LIMIT 1
                                                              )

                                                    WHEN _tmpItem.OperDate >= zc_DateStart_PartionGoods()
                                                     AND _tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN _tmpItem.isPartionDate_To = TRUE
                                                     AND _tmpItem.PartionGoodsDate_To <> zc_DateEnd()
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem.PartionGoodsDate_To
                                                                                             , inGoodsKindId_complete := _tmpItem.GoodsKindId_complete
                                                                                              )
                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                                        THEN 0

                                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                        THEN CASE WHEN _tmpItem.UnitId_From <> 0 AND _tmpItem.MemberId_To <> 0
                                                                       THEN -- !!!������ ���������, ����� ���� ����� ������ ����
                                                                            lpInsertFind_Object_PartionGoods (inUnitId_Partion:= _tmpItem.UnitId_From
                                                                                                            , inGoodsId       := _tmpItem.GoodsId
                                                                                                            , inStorageId     := _tmpItem.StorageId_mi
                                                                                                            , inInvNumber     := _tmpItem.PartionGoods
                                                                                                            , inOperDate      := _tmpItem.OperDate
                                                                                                            , inPrice         := 0
                                                                                                             )
                                                                  WHEN _tmpItem.MemberId_To <> 0
                                                                       THEN -- !!!������ ��������� - ����� ��������� StorageId
                                                                            lpInsertFind_Object_PartionGoods (inUnitId_Partion:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem.PartionGoodsId_mi AND OL.DescId = zc_ObjectLink_PartionGoods_Unit())
                                                                                                            , inGoodsId       := CASE WHEN _tmpItem.PartionGoodsId_mi > 0 THEN _tmpItem.GoodsId ELSE 0 END
                                                                                                            , inStorageId     := _tmpItem.StorageId_mi
                                                                                                            , inInvNumber     := (SELECT Object.ValueData FROM Object WHERE Object.Id = _tmpItem.PartionGoodsId_mi)
                                                                                                            , inOperDate      := (SELECT OD.ValueData  FROM ObjectDate  AS OD  WHERE OD.ObjectId  = _tmpItem.PartionGoodsId_mi AND OD.DescId  = zc_ObjectDate_PartionGoods_Value())
                                                                                                            , inPrice         := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = _tmpItem.PartionGoodsId_mi AND OFl.DescId = zc_ObjectFloat_PartionGoods_Price())
                                                                                                             )
                                                                  WHEN _tmpItem.UnitId_To <> 0 OR _tmpItem.CarId_To <> 0
                                                                       THEN -- !!!���� ��������� �� ����� - ����� ������ ������
                                                                            0

                                                                  -- !!!������ �� �������� - �.�. ��� � �������, ���� ���� �� ���������
                                                                  ELSE _tmpItem.PartionGoodsId_mi
                                                             END
                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
        OR _tmpItem.ObjectDescId           = zc_Object_Asset()
    ;


     -- �2.1. - ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId_From = lpInsertFind_Object_PartionGoods (inValue:= _tmpItem.PartionGoods)
     WHERE _tmpItem.PartionGoodsId_From = 0
       AND _tmpItem.PartionGoods <> ''
       AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
     ;

     -- �2.2. - ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId_To = _tmpItem.PartionGoodsId_From
     WHERE _tmpItem.PartionGoodsId_From > 0
       AND _tmpItem.PartionGoodsId_To   = 0
       AND _tmpItem.PartionGoods <> ''
       AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
     ;



/* if inMovementId = 24211744 --AND 1=0
 then
    RAISE EXCEPTION '<%>  %', (select distinct _tmpItem.PartionGoodsId_From from _tmpItem where _tmpItem.MovementItemId = 248384532 )
    , (select _tmpItem.PartionGoods from _tmpItem where _tmpItem.MovementItemId = 248384532 );

 end if;*/


     -- �������� - �.�.��� ���� ��-������ ����� ������ ������ - ���� ��� � ����� ��� ����������
     IF EXISTS (SELECT _tmpItem.GoodsId
                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.PartionGoodsId_From, _tmpItem.InfoMoneyDestinationId FROM _tmpItem
                     ) AS _tmpItem
                WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                        , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                        , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                        , zc_Enum_InfoMoneyDestination_70100() -- ���������� + ����������� ����������
                                                        , zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                        , zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                        , zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                        , zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                         )
                GROUP BY _tmpItem.GoodsId, _tmpItem.PartionGoodsId_From
                HAVING COUNT(*) > 1)
     THEN
          RAISE EXCEPTION '������.� ��������� ������ ����������� ����� <%> <%> <%>.'
              , lfGet_Object_ValueData ((SELECT _tmpItem.GoodsId
                                         FROM (SELECT _tmpItem.GoodsId, _tmpItem.PartionGoodsId_From
                                               FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.PartionGoodsId_From, _tmpItem.InfoMoneyDestinationId FROM _tmpItem
                                                    ) AS _tmpItem
                                               WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                                                       , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                                                       , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                                                       , zc_Enum_InfoMoneyDestination_70100() -- ���������� + ����������� ����������
                                                                                       , zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                                                       , zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                                                       , zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                                                       , zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                                                        )
                                               GROUP BY _tmpItem.GoodsId, _tmpItem.PartionGoodsId_From
                                               HAVING COUNT(*) > 1
                                              ) AS _tmpItem
                                              ORDER BY _tmpItem.GoodsId
                                              LIMIT 1
                                        ))
              , (SELECT MIN (COALESCE (_tmpItem.PartionGoodsId_From, 0))
                 FROM (SELECT _tmpItem.GoodsId, _tmpItem.PartionGoodsId_From
                       FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.PartionGoodsId_From, _tmpItem.InfoMoneyDestinationId FROM _tmpItem
                            ) AS _tmpItem
                       WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                               , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                               , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                               , zc_Enum_InfoMoneyDestination_70100() -- ���������� + ����������� ����������
                                                               , zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                               , zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                               , zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                               , zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                                )
                       GROUP BY _tmpItem.GoodsId, _tmpItem.PartionGoodsId_From
                       HAVING COUNT(*) > 1
                      ) AS _tmpItem
                      GROUP BY _tmpItem.GoodsId
                      ORDER BY _tmpItem.GoodsId
                      LIMIT 1
                )
              , (SELECT MAX (COALESCE (_tmpItem.PartionGoodsId_From, 0))
                 FROM (SELECT _tmpItem.GoodsId, _tmpItem.PartionGoodsId_From
                       FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.PartionGoodsId_From, _tmpItem.InfoMoneyDestinationId FROM _tmpItem
                            ) AS _tmpItem
                       WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                               , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                               , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                               , zc_Enum_InfoMoneyDestination_70100() -- ���������� + ����������� ����������
                                                               , zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                               , zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                               , zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                               , zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                                )
                       GROUP BY _tmpItem.GoodsId, _tmpItem.PartionGoodsId_From
                       HAVING COUNT(*) > 1
                      ) AS _tmpItem
                      GROUP BY _tmpItem.GoodsId
                      ORDER BY _tmpItem.GoodsId
                      LIMIT 1
                )
               ;
     END IF;


     -- ����������
     vbWhereObjectId_Analyzer_From:= CASE WHEN (SELECT DISTINCT UnitId_From   FROM _tmpItem) <> 0 THEN (SELECT DISTINCT UnitId_From   FROM _tmpItem)
                                          WHEN (SELECT DISTINCT MemberId_From FROM _tmpItem) <> 0 THEN (SELECT DISTINCT MemberId_From FROM _tmpItem)
                                          WHEN (SELECT DISTINCT CarId_From    FROM _tmpItem) <> 0 THEN (SELECT DISTINCT CarId_From    FROM _tmpItem)
                                     END;
     vbWhereObjectId_Analyzer_To:= CASE WHEN (SELECT DISTINCT UnitId_To   FROM _tmpItem) <> 0 THEN (SELECT DISTINCT UnitId_To   FROM _tmpItem)
                                        WHEN (SELECT DISTINCT MemberId_To FROM _tmpItem) <> 0 THEN (SELECT DISTINCT MemberId_To FROM _tmpItem)
                                        WHEN (SELECT DISTINCT CarId_To    FROM _tmpItem) <> 0 THEN (SELECT DISTINCT CarId_To    FROM _tmpItem)
                                   END;
     -- ����������
     vbIsPartionGoodsKind_Unit_From:= COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbWhereObjectId_Analyzer_From AND OB.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()), FALSE);
     vbIsPartionGoodsKind_Unit_To  := COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbWhereObjectId_Analyzer_To   AND OB.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()), FALSE);



     IF 1=1 -- inUserId <> zfCalc_UserAdmin() :: Integer
     THEN
         -- !!!��������� - �����������/������� �����������!!! - �� ��������� "����������" - !!!����� - ����� ��������� _tmpMIContainer_insert, ������� ������ �� ��������!!!, �� ����� ���������� _tmpItem
         PERFORM lpComplete_Movement_Sale_Recalc (inMovementId := inMovementId
                                                , inUnitId     := vbWhereObjectId_Analyzer_From
                                                , inUserId     := inUserId
                                                 );
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1.1.1. ������������ ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_GoodsFrom = CASE WHEN _tmpItem.ContainerId_GoodsFrom > 0 THEN _tmpItem.ContainerId_GoodsFrom
                                                      WHEN _tmpItem.PartionGoodsId_From   < 0 THEN -1 * _tmpItem.PartionGoodsId_From -- !!!���� ������ � ���������!!!
                                                  ELSE
                                                 lpInsertUpdate_ContainerCount_Goods (inOperDate               := _tmpItem.OperDate
                                                                                    , inUnitId                 := CASE WHEN _tmpItem.MemberId_From <> 0 THEN 0 /*_tmpItem.UnitId_Item*/ ELSE _tmpItem.UnitId_From END
                                                                                    , inCarId                  := _tmpItem.CarId_From
                                                                                    , inMemberId               := _tmpItem.MemberId_From
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := CASE WHEN vbIsPartionGoodsKind_Unit_From = FALSE
                                                                                                                        -- ������ �����
                                                                                                                        AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                                                                            THEN 0

                                                                                                                       -- �������
                                                                                                                       WHEN _tmpItem.InfoMoneyId IN (zc_Enum_InfoMoney_30102())
                                                                                                                        AND _tmpItem.OperDate >= '01.05.2022'
                                                                                                                        AND _tmpItem.UnitId_From <> 8006902 -- ��� �������� �������
                                                                                                                        AND _tmpItem.UnitId_From <> 8451    -- ��� ��������
                                                                                                                            THEN 0

                                                                                                                       ELSE _tmpItem.GoodsKindId
                                                                                                                  END
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId_From
                                                                                    , inAssetId                := -- !!!����� ������ - ��������!!!
                                                                                                                  CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                            THEN _tmpItem.AssetId
                                                                                                                     /*WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                            THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                                  FROM Container
                                                                                                                                       INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                      ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                     AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId_From
                                                                                                                                                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                                                                                       INNER JOIN ContainerLinkObject AS CLO_AssetTo
                                                                                                                                                                      ON CLO_AssetTo.ContainerId = Container.Id
                                                                                                                                                                     AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()
                                                                                                                                  WHERE Container.ObjectId = _tmpItem.GoodsId
                                                                                                                                    AND Container.DescId   = zc_Container_Count()
                                                                                                                                  ORDER BY Container.Amount DESC, COALESCE (CLO_AssetTo.ObjectId, 0) DESC
                                                                                                                                  LIMIT 1
                                                                                                                                 )*/
                                                                                                                       ELSE _tmpItem.AssetId
                                                                                                                  END
                                                                                    , inBranchId               := _tmpItem.BranchId_From
                                                                                    , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                     )
                                                 END
                       , ContainerId_GoodsTo   = CASE WHEN _tmpItem.ContainerDescId = zc_Container_CountAsset() AND vbIsAssetBalance_to = FALSE
                                                 THEN 
                                                 lpInsertUpdate_ContainerCount_Asset (inOperDate               := _tmpItem.OperDate
                                                                                    , inUnitId                 := CASE WHEN _tmpItem.MemberId_To <> 0 THEN 0 /*_tmpItem.UnitId_Item*/ ELSE _tmpItem.UnitId_To END
                                                                                    , inCarId                  := _tmpItem.CarId_To
                                                                                    , inMemberId               := _tmpItem.MemberId_To
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := CASE WHEN vbIsPartionGoodsKind_Unit_To = FALSE
                                                                                                                        -- ������ �����
                                                                                                                        AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                                                                            THEN 0
                                                                                                                       ELSE _tmpItem.GoodsKindId
                                                                                                                  END
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                    , inAssetId                := -- !!!����� ������ - ��������!!!
                                                                                                                  CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                            THEN _tmpItem.AssetId
                                                                                                                     /*WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                            THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                                  FROM Container
                                                                                                                                       INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                      ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                     AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId_To
                                                                                                                                                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                                                                                       INNER JOIN ContainerLinkObject AS CLO_AssetTo
                                                                                                                                                                      ON CLO_AssetTo.ContainerId = Container.Id
                                                                                                                                                                     AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()
                                                                                                                                  WHERE Container.ObjectId = _tmpItem.GoodsId
                                                                                                                                    AND Container.DescId   = zc_Container_Count()
                                                                                                                                  ORDER BY Container.Amount DESC, COALESCE (CLO_AssetTo.ObjectId, 0) DESC
                                                                                                                                  LIMIT 1
                                                                                                                                 )*/
                                                                                                                       ELSE _tmpItem.AssetId
                                                                                                                  END
                                                                                    , inBranchId               := _tmpItem.BranchId_To
                                                                                    , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                     )
                                                 ELSE
                                                 lpInsertUpdate_ContainerCount_Goods (inOperDate               := _tmpItem.OperDate
                                                                                    , inUnitId                 := CASE WHEN _tmpItem.MemberId_To <> 0 THEN 0 /*_tmpItem.UnitId_Item*/ ELSE _tmpItem.UnitId_To END
                                                                                    , inCarId                  := _tmpItem.CarId_To
                                                                                    , inMemberId               := _tmpItem.MemberId_To
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := CASE WHEN vbIsPartionGoodsKind_Unit_To = FALSE
                                                                                                                        -- ������ �����
                                                                                                                        AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                                                                            THEN 0

                                                                                                                       -- �������
                                                                                                                       WHEN _tmpItem.InfoMoneyId IN (zc_Enum_InfoMoney_30102())
                                                                                                                        AND _tmpItem.OperDate >= '01.05.2022'
                                                                                                                        AND _tmpItem.UnitId_To <> 8006902 -- ��� �������� �������
                                                                                                                            THEN 0

                                                                                                                       ELSE _tmpItem.GoodsKindId
                                                                                                                  END
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                    , inAssetId                := -- !!!����� ������ - ��������!!!
                                                                                                                  CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                            THEN _tmpItem.AssetId
                                                                                                                     /*WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                            THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                                  FROM Container
                                                                                                                                       INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                      ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                     AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId_To
                                                                                                                                                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                                                                                       INNER JOIN ContainerLinkObject AS CLO_AssetTo
                                                                                                                                                                      ON CLO_AssetTo.ContainerId = Container.Id
                                                                                                                                                                     AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()
                                                                                                                                  WHERE Container.ObjectId = _tmpItem.GoodsId
                                                                                                                                    AND Container.DescId   = zc_Container_Count()
                                                                                                                                  ORDER BY Container.Amount DESC, COALESCE (CLO_AssetTo.ObjectId, 0) DESC
                                                                                                                                  LIMIT 1
                                                                                                                                 )*/
                                                                                                                       ELSE _tmpItem.AssetId
                                                                                                                  END
                                                                                    , inBranchId               := _tmpItem.BranchId_To
                                                                                    , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                     )
                                                 END;

/*IF  inUserId = 5 
THEN
    RAISE EXCEPTION '������.<%>', (select min(_tmpItem.ContainerId_GoodsFrom) from _tmpItem);
END IF;
*/

     -- 1.1.1. ������������ ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_countFrom = lpInsertFind_Container (inContainerDescId   := zc_Container_CountCount()
                                                                       , inParentId          := _tmpItem.ContainerId_GoodsFrom
                                                                       , inObjectId          := _tmpItem.GoodsId
                                                                       , inJuridicalId_basis := NULL
                                                                       , inBusinessId        := NULL
                                                                       , inObjectCostDescId  := NULL
                                                                       , inObjectCostId      := NULL
                                                                        )
                        , ContainerId_countTo  = lpInsertFind_Container (inContainerDescId   := zc_Container_CountCount()
                                                                       , inParentId          := _tmpItem.ContainerId_GoodsTo
                                                                       , inObjectId          := _tmpItem.GoodsId
                                                                       , inJuridicalId_basis := NULL
                                                                       , inBusinessId        := NULL
                                                                       , inObjectCostDescId  := NULL
                                                                       , inObjectCostId      := NULL
                                                                        )
     WHERE _tmpItem.OperCountCount <> 0;


     -- 1.2. ����� ����������: ��������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ��������� !!!(����� ����)!!!
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerDescId, MIContainerId_To, ContainerId_To, AccountId_To, ContainerId_ProfitLoss, ContainerId_GoodsFrom, ContainerId_From, AccountId_From, InfoMoneyId_Detail_From, OperSumm)
        SELECT
              _tmpItem.MovementItemId
            , zc_Container_Summ() AS ContainerDescId
            , 0 AS MIContainerId_To
            , 0 AS ContainerId_To
            , 0 AS AccountId_To
            , 0 AS ContainerId_ProfitLoss
            , _tmpItem.ContainerId_GoodsFrom
            , Container_Summ.Id AS ContainerId_From
            , Container_Summ.ObjectId AS AccountId_From
            , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
            , SUM ( CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)) -- ABS
                 /*+ CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                             THEN HistoryCost.Summ_diff -- !!!���� ���� "�����������" ��� ����������, �������� �����!!!
                        ELSE 0
                   END*/) AS OperSumm
        FROM _tmpItem
             JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_GoodsFrom
                                             AND Container_Summ.DescId = zc_Container_Summ()
             JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                      ON ContainerLinkObject_InfoMoneyDetail.ContainerId = Container_Summ.Id
                                     AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = Container_Summ.Id
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id -- ContainerObjectCost_Basis.ObjectCostId
                                  AND _tmpItem.OperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE /*zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND (ContainerLinkObject_InfoMoneyDetail.ObjectId = 0 OR zc_isHistoryCost_byInfoMoneyDetail()= TRUE)
          -- AND (inIsLastComplete = FALSE OR (_tmpItem.OperCount * HistoryCost.Price) <> 0) -- !!!�����������!!! ��������� ���� ���� ��� �� ��������� ��� (��� ����� ��� ������� �/�)
          AND*/ (_tmpItem.OperCount * HistoryCost.Price) <> 0 -- !!!��!!! ��������� ����
          AND _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
          AND vbIsHistoryCost= TRUE -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
        GROUP BY _tmpItem.MovementItemId
               , _tmpItem.ContainerId_GoodsFrom
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , ContainerLinkObject_InfoMoneyDetail.ObjectId
       UNION ALL
        -- ���� � ���������
        SELECT
              _tmpItem.MovementItemId
            , zc_Container_SummAsset() AS ContainerDescId
            , 0 AS MIContainerId_To
            , 0 AS ContainerId_To
            , 0 AS AccountId_To
            , 0 AS ContainerId_ProfitLoss
            , _tmpItem.ContainerId_GoodsFrom
              -- ������ ��������
            , Container_Summ.Id AS ContainerId_From
            , Container_Summ.ObjectId AS AccountId_From
            , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From

            , CASE WHEN _tmpItem.OperCount = Container_GoodsAsset.Amount OR Container_GoodsAsset.Amount = 0
                        THEN Container_Summ.Amount
                   ELSE Container_Summ.Amount / Container_GoodsAsset.Amount * _tmpItem.OperCount
              END AS OperSumm
        FROM _tmpItem
             -- ��� �������
             INNER JOIN Container AS Container_GoodsAsset ON Container_GoodsAsset.Id     = _tmpItem.ContainerId_GoodsFrom
                                                         AND Container_GoodsAsset.DescId = zc_Container_CountAsset()
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_GoodsFrom
                                                  AND Container_Summ.DescId   = zc_Container_SummAsset()
             JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                      ON ContainerLinkObject_InfoMoneyDetail.ContainerId = Container_Summ.Id
                                     AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
        WHERE vbIsHistoryCost= TRUE -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
          AND vbMovementDescId = zc_Movement_SendAsset()
          AND CASE WHEN _tmpItem.OperCount = Container_GoodsAsset.Amount OR Container_GoodsAsset.Amount = 0
                        THEN Container_Summ.Amount
                   ELSE Container_Summ.Amount / Container_GoodsAsset.Amount * _tmpItem.OperCount
              END <> 0
        --AND inUserId = 5 -- !!! ��������, �.�. ��� �/� � HistoryCost ��� "�������" �������
        ;



     -- 1.3.1. ������������ ���� ��� �������� �� ��������� ����� - ����
     UPDATE _tmpItemSumm SET AccountId_To = CASE WHEN _tmpItemSumm.AccountId_From IN (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_60000()) -- ������� ������� ��������
                                                     THEN _tmpItemSumm.AccountId_From -- !!!�.�. ���� �� ��������!!!

                                                 WHEN _tmpItem.AccountDirectionId_From = zc_Enum_AccountDirection_20700() -- ������ + �� ��������
                                                  AND _tmpItem.AccountDirectionId_To   = zc_Enum_AccountDirection_20700() -- ������ + �� ��������
                                                     THEN _tmpItemSumm.AccountId_From -- !!!�.�. ���� �� ��������!!!

                                                 WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                     THEN _tmpItemSumm.AccountId_From -- !!!�.�. ���� �� ��������!!!

                                                 ELSE _tmpItem_byAccount.AccountId
                                            END
     FROM _tmpItem
          JOIN (SELECT CASE WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                 THEN 0

                            ELSE lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������ -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                            , inAccountDirectionId     := CASE WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                                                                                                    THEN zc_Enum_AccountDirection_20900() -- 20900; "��������� ����"
                                                                                               ELSE _tmpItem_group.AccountDirectionId_To
                                                                                          END
                                                            , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                            , inInfoMoneyId            := NULL
                                                            , inUserId                 := inUserId
                                                             )
                        END AS AccountId
                     , _tmpItem_group.AccountDirectionId_To
                     , _tmpItem_group.InfoMoneyDestinationId
                FROM (SELECT DISTINCT
                             _tmpItem.AccountDirectionId_To
                           , _tmpItem.InfoMoneyDestinationId
                           , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                       THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                                  --WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                  --     THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                  WHEN (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20800() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()) -- ������ + �� �������� AND �������� ����� + ������ �����
                                       THEN zc_Enum_InfoMoneyDestination_10200() -- �������� ����� + ������ �����
                                  ELSE _tmpItem.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                      FROM _tmpItem
                      WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
                     ) AS _tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.AccountDirectionId_To  = _tmpItem.AccountDirectionId_To
                                      AND _tmpItem_byAccount.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
       -- ���� ��� �� ������� ������� � ��������� � ������ ������ ���-��
       AND vbIsAssetBalance_to                = FALSE
      ;


     -- 1.3.2. ������������ ContainerId ��� �������� �� ��������� ����� - ����  + ������������ ��������� ��� �������� - �������
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss =
                               CASE WHEN _tmpItem.ProfitLossGroupId <> 0
                                         THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                    , inParentId          := NULL
                                                                    , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                                                    , inJuridicalId_basis := _tmpItem.JuridicalId_Basis_To
                                                                    , inBusinessId        := _tmpItem.BusinessId_ProfitLoss -- !!!����������� ������ ��� �������!!!
                                                                    , inObjectCostDescId  := NULL
                                                                    , inObjectCostId      := NULL
                                                                    , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                                    , inObjectId_1        := lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem.ProfitLossGroupId
                                                                                                                           , inProfitLossDirectionId  := _tmpItem.ProfitLossDirectionId
                                                                                                                           , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                                                           , inInfoMoneyId            := NULL
                                                                                                                           , inUserId                 := inUserId
                                                                                                                            )
                                                                    , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                                    , inObjectId_2        := _tmpItem.BranchId_ProfitLoss
                                                                     )
                               END
                           , ContainerId_To = CASE WHEN _tmpItemSumm.ContainerDescId = zc_Container_SummAsset()
                                              THEN
                                              -- ���� ���� ������� ������� � ��������� � ������ ������ ���-��
                                              CASE WHEN vbIsAssetBalance_to = TRUE
                                              THEN 0
                                              ELSE
                                              lpInsertUpdate_ContainerSumm_Asset (inOperDate               := _tmpItem.OperDate
                                                                                , inUnitId                 := CASE WHEN _tmpItem.MemberId_To <> 0 THEN 0 /*_tmpItem.UnitId_Item*/ ELSE _tmpItem.UnitId_To END
                                                                                , inCarId                  := _tmpItem.CarId_To
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
                                                                                , inGoodsKindId            := CASE WHEN vbIsPartionGoodsKind_Unit_To = FALSE
                                                                                                                    -- ������ �����
                                                                                                                    AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                                                                        THEN 0
                                                                                                                   ELSE _tmpItem.GoodsKindId
                                                                                                              END
                                                                                , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                , inAssetId                := -- !!!����� ������ - ��������!!!
                                                                                                              CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                        THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                              FROM Container
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId_To
                                                                                                                                                                 AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_AssetTo
                                                                                                                                                                  ON CLO_AssetTo.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()
                                                                                                                              WHERE Container.ObjectId = _tmpItem.GoodsId
                                                                                                                                AND Container.DescId   = zc_Container_Count()
                                                                                                                              ORDER BY Container.Amount DESC, COALESCE (CLO_AssetTo.ObjectId, 0) DESC
                                                                                                                              LIMIT 1
                                                                                                                             )
                                                                                                                   ELSE _tmpItem.AssetId
                                                                                                              END
                                                                                 )
                                              END
                                              ELSE
                                              lpInsertUpdate_ContainerSumm_Goods (inOperDate               := _tmpItem.OperDate
                                                                                , inUnitId                 := CASE WHEN _tmpItem.MemberId_To <> 0 THEN 0 /*_tmpItem.UnitId_Item*/ ELSE _tmpItem.UnitId_To END
                                                                                , inCarId                  := _tmpItem.CarId_To
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
                                                                                , inGoodsKindId            := CASE WHEN vbIsPartionGoodsKind_Unit_To = FALSE
                                                                                                                    -- ������ �����
                                                                                                                    AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                                                                        THEN 0
                                                                                                                   ELSE _tmpItem.GoodsKindId
                                                                                                              END
                                                                                , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                , inAssetId                := -- !!!����� ������ - ��������!!!
                                                                                                              CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                        THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                              FROM Container
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId_To
                                                                                                                                                                 AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_AssetTo
                                                                                                                                                                  ON CLO_AssetTo.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()
                                                                                                                              WHERE Container.ObjectId = _tmpItem.GoodsId
                                                                                                                                AND Container.DescId   = zc_Container_Count()
                                                                                                                              ORDER BY Container.Amount DESC, COALESCE (CLO_AssetTo.ObjectId, 0) DESC
                                                                                                                              LIMIT 1
                                                                                                                             )
                                                                                                                   ELSE _tmpItem.AssetId
                                                                                                              END
                                                                                 )
                                              END
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
       ;



     -- 1.1.2. ����������� �������� ��� ��������������� ����� - ���� + ������������ MIContainer.Id (��������������) - !!!����� �������, �.�. ����� ContainerId_ProfitLoss!!!
     UPDATE _tmpItem SET MIContainerId_To = lpInsertUpdate_MovementItemContainer (ioId                      := 0
                                                                                , inDescId                  := CASE WHEN _tmpItem.ContainerDescId = zc_Container_CountAsset()
                                                                                                                     AND vbIsAssetBalance_to      = FALSE
                                                                                                                         THEN zc_MIContainer_CountAsset()
                                                                                                                    ELSE zc_MIContainer_Count()
                                                                                                               END
                                                                                , inMovementDescId          := vbMovementDescId
                                                                                , inMovementId              := _tmpItem.MovementId
                                                                                , inMovementItemId          := _tmpItem.MovementItemId
                                                                                , inParentId                := NULL
                                                                                , inContainerId             := _tmpItem.ContainerId_GoodsTo   -- ��� ���������� ����
                                                                                , inAccountId               := 0                              -- ��� �����
                                                                                , inAnalyzerId              := vbWhereObjectId_Analyzer_From  -- ��� ���������, �� ��� ��������� ������� ����� ������������ "�� ����" ���...
                                                                                , inObjectId_Analyzer       := _tmpItem.GoodsId               -- �����
                                                                                , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- ������������ ���...
                                                                                , inContainerId_Analyzer    := CASE WHEN _tmpItem.ProfitLossGroupId > 0 THEN (SELECT _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId LIMIT 1) ELSE 0 END -- ��������� ���� - ������ ����
                                                                                , inObjectIntId_Analyzer    := _tmpItem.GoodsKindId           -- ��� ������
                                                                                , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From  -- ������������ "�� ����"
                                                                                , inContainerIntId_Analyzer := _tmpItem.ContainerId_GoodsFrom -- �������������� ���������-������������� (�.�. �� �������)
                                                                                , inAmount                  := _tmpItem.OperCount
                                                                                , inOperDate                := _tmpItem.OperDate
                                                                                , inIsActive                := TRUE
                                                                                 )
                 , MIContainerId_count_To = CASE WHEN _tmpItem.OperCountCount = 0 THEN 0 ELSE
                                            lpInsertUpdate_MovementItemContainer (ioId                      := 0
                                                                                , inDescId                  := zc_MIContainer_CountCount()
                                                                                , inMovementDescId          := vbMovementDescId
                                                                                , inMovementId              := _tmpItem.MovementId
                                                                                , inMovementItemId          := _tmpItem.MovementItemId
                                                                                , inParentId                := NULL
                                                                                , inContainerId             := _tmpItem.ContainerId_countTo   -- ��� ���������� ����
                                                                                , inAccountId               := 0                              -- ��� �����
                                                                                , inAnalyzerId              := vbWhereObjectId_Analyzer_From  -- ��� ���������, �� ��� ��������� ������� ����� ������������ "�� ����" ���...
                                                                                , inObjectId_Analyzer       := _tmpItem.GoodsId               -- �����
                                                                                , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- ������������ ���...
                                                                                , inContainerId_Analyzer    := CASE WHEN _tmpItem.ProfitLossGroupId > 0 THEN (SELECT _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId LIMIT 1) ELSE 0 END -- ��������� ���� - ������ ����
                                                                                , inObjectIntId_Analyzer    := _tmpItem.GoodsKindId           -- ��� ������
                                                                                , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From  -- ������������ "�� ����"
                                                                                , inContainerIntId_Analyzer := _tmpItem.ContainerId_GoodsFrom -- �������������� ���������-������������� (�.�. �� �������)
                                                                                , inAmount                  := _tmpItem.OperCountCount
                                                                                , inOperDate                := _tmpItem.OperDate
                                                                                , inIsActive                := TRUE
                                                                                 ) END;
     -- 1.1.3. ����������� �������� ��� ��������������� ����� - �� ����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId --, ParentId, Amount, OperDate, IsActive)
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ContainerIntId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- ��� ������� �������� - zc_Container_Count
       SELECT 0
            , CASE WHEN _tmpItem.ContainerDescId = zc_Container_CountAsset()
                        THEN zc_MIContainer_CountAsset()
                   ELSE zc_MIContainer_Count()
              END                                     AS DescId
            , vbMovementDescId, _tmpItem.MovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_GoodsFrom
            , 0                                       AS AccountId               -- ��� �����
            , vbWhereObjectId_Analyzer_To             AS AnalyzerId              -- ��� ���������, �� ��� ��������� ������� ����� ������������ "����" ���...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer       -- �����
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer  -- ������������ ���...
            , CASE WHEN _tmpItem.ProfitLossGroupId > 0 THEN (SELECT _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId LIMIT 1) ELSE 0 END AS ContainerId_Analyzer -- ��������� ���� - ������ ����
            , _tmpItem.ContainerId_GoodsTo            AS ContainerIntId_Analyzer -- �������������� ���������-������������� (�.�. �� �������)
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer    -- ��� ������
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer    -- ������������ "����"
            , _tmpItem.MIContainerId_To               AS ParentId
            , -1 * _tmpItem.OperCount
            , _tmpItem.OperDate
            , FALSE
       FROM _tmpItem

      UNION ALL
       -- ��� ������� �������� - zc_Container_CountCount
       SELECT 0, zc_MIContainer_CountCount() AS DescId, vbMovementDescId, _tmpItem.MovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_countFrom
            , 0                                       AS AccountId                -- ��� �����
            , vbWhereObjectId_Analyzer_To             AS AnalyzerId               -- ��� ���������, �� ��� ��������� ������� ����� ������������ "����" ���...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer   -- ������������ ���...
            , CASE WHEN _tmpItem.ProfitLossGroupId > 0 THEN (SELECT _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId LIMIT 1) ELSE 0 END AS ContainerId_Analyzer -- ��������� ���� - ������ ����
            , _tmpItem.ContainerId_countTo            AS ContainerIntId_Analyzer -- �������������� ���������-������������� (�.�. �� �������)
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer    -- ��� ������
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer    -- ������������ "����"
            , NULL                                    AS ParentId                -- !!!
            , -1 * _tmpItem.OperCountCount
            , _tmpItem.OperDate
            , FALSE
       FROM _tmpItem
       WHERE _tmpItem.OperCountCount <> 0;


     -- 1.3.3. ����������� �������� ��� ��������� ����� - ���� + ������������ MIContainer.Id
     UPDATE _tmpItemSumm SET MIContainerId_To = lpInsertUpdate_MovementItemContainer (ioId:= 0
                                                                                    , inDescId         := CASE WHEN _tmpItemSumm.ContainerDescId = zc_Container_SummAsset()
                                                                                                                    THEN zc_MIContainer_SummAsset()
                                                                                                               ELSE zc_MIContainer_Summ()
                                                                                                          END
                                                                                    , inMovementDescId := vbMovementDescId
                                                                                    , inMovementId     := MovementId
                                                                                    , inMovementItemId := _tmpItem.MovementItemId
                                                                                    , inParentId       := NULL
                                                                                    , inContainerId    := _tmpItemSumm.ContainerId_To
                                                                                    , inAccountId               := _tmpItemSumm.AccountId_To      -- ���� ���� ������
                                                                                    , inAnalyzerId              := CASE WHEN _tmpItem.ProfitLossGroupId <> 0 THEN zc_Enum_AnalyzerId_ProfitLoss() ELSE vbWhereObjectId_Analyzer_From END  -- "������" ���� ���������, �� ��� ��������� ������� ����� ������������ "�� ����" ���...
                                                                                    , inObjectId_Analyzer       := _tmpItem.GoodsId               -- �����
                                                                                    , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- ������������ ���...
                                                                                    , inContainerId_Analyzer    := _tmpItemSumm.ContainerId_ProfitLoss -- ��������� ���� - ������ ����
                                                                                    , inObjectIntId_Analyzer    := _tmpItem.GoodsKindId           -- ��� ������
                                                                                    , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From  -- ������������ "�� ����"
                                                                                    , inContainerIntId_Analyzer := _tmpItemSumm.ContainerId_From  -- �������� ���������-������������� (�.�. �� �������)
                                                                                    , inAmount         := OperSumm
                                                                                    , inOperDate       := OperDate
                                                                                    , inIsActive       := TRUE
                                                                                     )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
       -- ���� ��� �� ������� ������� � ��������� � ������ ������ ���-��
       AND vbIsAssetBalance_to                = FALSE
       ;

     -- 1.3.4. ����������� �������� ��� ��������� ����� - �� ����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ContainerIntId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0
            , CASE WHEN _tmpItemSumm.ContainerDescId = zc_Container_SummAsset()
                        THEN zc_MIContainer_SummAsset()
                   ELSE zc_MIContainer_Summ()
              END                                     AS DescId
            , vbMovementDescId, MovementId, _tmpItem.MovementItemId
            , _tmpItemSumm.ContainerId_From
            , _tmpItemSumm.AccountId_From             AS AccountId              -- ���� ���� ������
            , CASE WHEN _tmpItem.ProfitLossGroupId <> 0 THEN zc_Enum_AnalyzerId_ProfitLoss() ELSE vbWhereObjectId_Analyzer_To END AS AnalyzerId -- "������" ���� ���������, �� ��� ��������� ������� ����� ������������ "����" ���...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- ������������ ���...
            , _tmpItemSumm.ContainerId_ProfitLoss     AS ContainerId_Analyzer   -- ��������� ���� - ������ ����
              -- ��������/�������������� ���������-������������� (�.�. �� �������)
            , CASE WHEN vbIsAssetBalance_to = TRUE THEN _tmpItem.ContainerId_GoodsTo ELSE _tmpItemSumm.ContainerId_To END AS ContainerIntId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- ������������ "����"
            , _tmpItemSumm.MIContainerId_To           AS ParentId
            , -1 * _tmpItemSumm.OperSumm
            , _tmpItem.OperDate
            , FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
                             AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
                             ;


     -- 1.3.5. ����������� �������� - �������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ContainerIntId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm_group.MovementItemId
            , _tmpItemSumm_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId              -- ������� �������� �������
            , 0                                       AS AnalyzerId             -- ��� ���������
            , _tmpItemSumm_group.GoodsId              AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- ��� ���� �� ���� ����������� ...
            , 0                                       AS ContainerId_Analyzer   -- � ���� �� �����
            , 0                                       AS ContainerIntId_Analyzer-- � ���� �� �����
            , _tmpItemSumm_group.GoodsKindId          AS ObjectIntId_Analyzer   -- ��� ������
            , _tmpItemSumm_group.UnitId_ProfitLoss    AS ObjectExtId_Analyzer   -- ������������ � �������� ��������� ��� ���� - �.�. ��� ���������� ��� ��� �������
            , 0                                       AS ParentId
            , _tmpItemSumm_group.OperSumm
            , _tmpItemSumm_group.OperDate
            , FALSE
       FROM (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_ProfitLoss
                  , _tmpItem.GoodsId
                  , _tmpItem.GoodsKindId
                  , _tmpItem.UnitId_ProfitLoss
                  , _tmpItem.OperDate
                  , SUM (_tmpItemSumm.OperSumm) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId        = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_GoodsFrom = _tmpItemSumm.ContainerId_GoodsFrom
             WHERE _tmpItemSumm.ContainerId_ProfitLoss <> 0
             GROUP BY _tmpItemSumm.MovementItemId
                    , _tmpItemSumm.ContainerId_ProfitLoss
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
                    , _tmpItem.UnitId_ProfitLoss
                    , _tmpItem.OperDate
            ) AS _tmpItemSumm_group
      UNION ALL
       -- ��� �� ������� � �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, MovementId, _tmpItem.MovementItemId
            , _tmpItemSumm.ContainerId_To
            , _tmpItemSumm.AccountId_To               AS AccountId              -- ���� ���� ������
            , zc_Enum_AnalyzerId_ProfitLoss()         AS AnalyzerId             -- ���� ���������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- ������������ ���...
            , _tmpItemSumm.ContainerId_ProfitLoss     AS ContainerId_Analyzer   -- ��������� ���� - ������ ����
            , 0                                       AS ContainerIntId_Analyzer-- ����� �� �����
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- ������������ "����"
            , NULL                                    AS ParentId
            , -1 * _tmpItemSumm.OperSumm
            , _tmpItem.OperDate
            , FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
                             AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
       WHERE _tmpItemSumm.ContainerId_ProfitLoss <> 0;


     -- !!!����������� �������� <����> - � ������ ���!!!
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Price(), tmp.PartionGoodsId, tmp.Price)
     FROM (SELECT _tmpItem.PartionGoodsId_To AS PartionGoodsId, SUM (tmp.OperSumm) / SUM (_tmpItem.OperCount) AS Price
           FROM _tmpItem
                INNER JOIN (SELECT _tmpItemSumm.MovementItemId, SUM (_tmpItemSumm.OperSumm) AS OperSumm FROM _tmpItemSumm GROUP BY _tmpItemSumm.MovementItemId
                           ) AS tmp ON tmp.MovementItemId = _tmpItem.MovementItemId
           WHERE _tmpItem.UnitId_From <> 0 AND _tmpItem.MemberId_To <> 0 -- ������ ���� ����������� �� ��
             AND _tmpItem.PartionGoodsId_To > 0
             AND _tmpItem.OperCount > 0
             AND (_tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                    , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                    , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                    , zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                    , zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                    , zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                    , zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                    , zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                     )
                  )
           GROUP BY _tmpItem.PartionGoodsId_To
          ) AS tmp;


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();
     -- 5.2. ����� - ����������� ��������� �������� ��� ������
     PERFORM lpInsertUpdate_MIReport_byTable ();

     -- 5.3. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := vbMovementDescId -- zc_Movement_Send()
                                , inUserId     := inUserId
                                 );

     -- ����� ������
     IF vbMovementDescId = zc_Movement_Send() AND (inUserId = zfCalc_UserAdmin() :: Integer OR 1=1)
     THEN
         -- !!!��������� - �����������/������� �����������!!! - �� ��������� "������������" - !!!����� - ����� ��������� ���, ������� ������ ����� ��������!!!
         PERFORM lpComplete_Movement_Send_Recalc (inMovementId := inMovementId
                                                , inFromId     := vbWhereObjectId_Analyzer_From
                                                , inToId       := vbWhereObjectId_Analyzer_To
                                                , inUserId     := inUserId
                                                 );
     END IF;
     
     
     --���� ������ ���������� ����� ��������� ������
     IF NOT EXISTS (SELECT 1 FROM MovementLinkObject
                    WHERE MovementLinkObject.MovementId = inMovementId
                      AND MovementLinkObject.DescId = zc_MovementLinkObject_StatusInsert()
                    )
     THEN
         -- ��������� �������� <���� ������� ����������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StatusInsert(), inMovementId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ ������� ����������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_StatusInsert(), inMovementId, inUserId);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.04.20                                        *
*/

/*
����� ����������� �� - ����� ������ - �� �������� ������ �� "�� �� ����" - �������� � ����� ������ zc_ContainerLinkObject_AssetTo + zc_ContainerLinkObject_PartionGoods : zc_ObjectLink_PartionGoods_Unit + zc_ObjectLink_PartionGoods_Storage = ����� �������� + Object.ValueData = ��� ����� + zc_ObjectDate_PartionGoods_Value = ���� ����������� + zc_ObjectFloat_PartionGoods_Price = "���� ��������" � ��������� � gpInsertUpdate_MovementItem_SendMember ������ 1) inGoodsId + inGoodsKindId + inAssetId + inPartionGoodsDate + ioPartionGoods + inUnitId + inStorageId - ��������� ������� + �� ������� ���� + � ����� �������� ��� ������ ������ StorageId , �.�. �� �������� ��� - SELECT Container union all  MovementItem ��� ����� ������ + ����� +inAssetId  ��� ���� � ������� �� ������ ������������� + ���� ��� ����������� �� ������ �� �� - ����� � zc_ContainerLinkObject_PartionGoods ��� ������ = ���� , � ����� ��� ��-�� �� �������� ��� ��, � ���� �� �������� �����  � �� "�������� ���" ���� ����� GoodsId + GoodsKindId
*/
-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 5854348, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= zfCalc_UserAdmin())


/*     
���������� ������� ���������� ��� ������� �������
SELECT   lpInsertUpdate_MovementDate (zc_MovementDate_StatusInsert(), tmp.MovementId, tmp.OperDate)
             -- ��������� �������� <������������ (��������)>
        , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_StatusInsert(),tmp.MovementId, tmp.UserId)

FROM
(
SELECT Movement.Id AS MovementId
    , MovementProtocol.OperDate
    , MovementProtocol.UserId
, ROW_NUMBER() OVER (PARTITION BY Movement.Id ORDER BY MovementProtocol.id) AS ord
FROM Movement
INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.Id

where Movement.Operdate BETWEEN  '01.04.2023' and '30.04.2023' 
 AND Movement.DescId = zc_Movement_Send()
and  ProtocolData ilike '%FieldValue = "��������"%'

) AS tmp
WHERE tmp.Ord = 1

*/
