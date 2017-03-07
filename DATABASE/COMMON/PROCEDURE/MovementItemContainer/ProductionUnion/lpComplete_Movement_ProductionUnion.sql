 -- Function: lpComplete_Movement_ProductionUnion()

DROP FUNCTION IF EXISTS lpComplete_Movement_ProductionUnion (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ProductionUnion(
    IN inMovementId        Integer              , -- ���� ���������
    IN inIsHistoryCost     Boolean              , -- �������� ��� � �������� ���� ���-��� ������ � �� ����������� �������� �/�
    IN inUserId            Integer                -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbIsHistoryCost Boolean; -- ����� �������� �/� ��� ����� ������������

  DECLARE vbWhereObjectId_Analyzer_From Integer;
  DECLARE vbWhereObjectId_Analyzer_To Integer;

  DECLARE vbMovementDescId Integer;

  DECLARE vbOperDate TDateTime;
  DECLARE vbUnitId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbBranchId_From Integer;
  DECLARE vbAccountDirectionId_From Integer;
  DECLARE vbIsPartionDate_Unit_From Boolean;
  DECLARE vbIsPartionGoodsKind_Unit_From Boolean;
  DECLARE vbJuridicalId_Basis_From Integer;
  DECLARE vbBusinessId_From Integer;

  DECLARE vbUnitId_To Integer;
  DECLARE vbMemberId_To Integer;
  DECLARE vbBranchId_To Integer;
  DECLARE vbAccountDirectionId_To Integer;
  DECLARE vbIsPartionDate_Unit_To Boolean;
  DECLARE vbIsPartionGoodsKind_Unit_To Boolean;
  DECLARE vbJuridicalId_Basis_To Integer;
  DECLARE vbBusinessId_To Integer;

  DECLARE vbIsPeresort Boolean;
  DECLARE vbProcessId Integer;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������������� Master(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_pr;
     -- !!!�����������!!! �������� ������� - �������� Master(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItemSumm_pr;
     -- !!!�����������!!! �������� ������� - �������������� Child(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItemChild;
     -- !!!�����������!!! �������� ������� - �������� Child(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItemSummChild;


     -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = zc_Enum_Role_Admin())
     THEN
          vbIsHistoryCost:= TRUE;
     ELSE
         -- !!! ��� ��������� ���� ����� �������� �/�!!!
         /*IF 0 < (SELECT 1 FROM Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide WHERE View_RoleAccessKeyGuide.UserId = inUserId AND View_RoleAccessKeyGuide.BranchId <> 0 GROUP BY View_RoleAccessKeyGuide.BranchId LIMIT 1)
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382)) -- ��������� �����
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (97837)) -- ��������� �����
         THEN vbIsHistoryCost:= FALSE;
         ELSE vbIsHistoryCost:= TRUE;
         END IF;*/
         vbIsHistoryCost:= FALSE;
     END IF;


     -- ��� ��������� ����� ��� ������������ �������� � ���������
     SELECT Movement.DescId, Movement.OperDate
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_From
          , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_From -- ��������� ������ - ����������� !!!����� ������ ��� �������������!!!
          , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE)     AS isPartionDate_Unit_From
          , COALESCE (ObjectBoolean_PartionGoodsKind_From.ValueData, TRUE) AS isPartionGoodsKind_Unit_From

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Juridical.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Business.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId_From

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS UnitId_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Branch.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit()
                                THEN ObjectLink_UnitTo_AccountDirection.ChildObjectId
                           WHEN Object_To.DescId = zc_Object_Personal()
                                THEN zc_Enum_AccountDirection_20500() -- "������"; 20500; "���������� (��)"
                      END, 0) AS AccountDirectionId_To -- !!!�� ������������� ��������, �.�. ��� ����� �������� �� ������!!!
          , COALESCE (ObjectBoolean_PartionDate_To.ValueData, FALSE)     AS isPartionDate_Unit_To
          , COALESCE (ObjectBoolean_PartionGoodsKind_To.ValueData, TRUE) AS isPartionGoodsKind_Unit_To

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Juridical.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Business.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId_To

          , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
          , COALESCE (MovementLinkObject_User.ObjectId, 0)       AS ProcessId

            INTO vbMovementDescId, vbOperDate, vbUnitId_From, vbMemberId_From, vbBranchId_From, vbAccountDirectionId_From, vbIsPartionDate_Unit_From, vbIsPartionGoodsKind_Unit_From, vbJuridicalId_Basis_From, vbBusinessId_From
               , vbUnitId_To, vbMemberId_To, vbBranchId_To, vbAccountDirectionId_To, vbIsPartionDate_Unit_To, vbIsPartionGoodsKind_Unit_To, vbJuridicalId_Basis_To, vbBusinessId_To
               , vbIsPeresort, vbProcessId
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                    ON MovementBoolean_Peresort.MovementId = Movement.Id
                                   AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                       ON MovementLinkObject_User.MovementId = Movement.Id
                                      AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                               ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                               ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_From
                                  ON ObjectBoolean_PartionDate_From.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_PartionDate_From.DescId = zc_ObjectBoolean_Unit_PartionDate()
                                 AND Object_From.DescId = zc_Object_Unit()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind_From
                                  ON ObjectBoolean_PartionGoodsKind_From.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_PartionGoodsKind_From.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()
                                 AND Object_From.DescId = zc_Object_Unit()

          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Juridical
                               ON ObjectLink_UnitFrom_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Business
                               ON ObjectLink_UnitFrom_Business.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Business.DescId = zc_ObjectLink_Unit_Business()
                              AND Object_From.DescId = zc_Object_Unit()

          LEFT JOIN ObjectLink AS ObjectLink_PersonalFrom_Member
                               ON ObjectLink_PersonalFrom_Member.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PersonalFrom_Member.DescId = zc_ObjectLink_Personal_Member()
                              AND Object_From.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_PersonalFrom_Unit
                               ON ObjectLink_PersonalFrom_Unit.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PersonalFrom_Unit.DescId = zc_ObjectLink_Personal_Unit()
                              AND Object_From.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalFrom_Juridical
                               ON ObjectLink_UnitPersonalFrom_Juridical.ObjectId = ObjectLink_PersonalFrom_Unit.ChildObjectId
                              AND ObjectLink_UnitPersonalFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND Object_From.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalFrom_Business
                               ON ObjectLink_UnitPersonalFrom_Business.ObjectId = ObjectLink_PersonalFrom_Unit.ChildObjectId
                              AND ObjectLink_UnitPersonalFrom_Business.DescId = zc_ObjectLink_Unit_Business()
                              AND Object_From.DescId = zc_Object_Personal()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                               ON ObjectLink_UnitTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND Object_To.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                               ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                              AND Object_To.DescId = zc_Object_Unit()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_To
                                  ON ObjectBoolean_PartionDate_To.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_PartionDate_To.DescId = zc_ObjectBoolean_Unit_PartionDate()
                                 AND Object_To.DescId = zc_Object_Unit()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind_To
                                  ON ObjectBoolean_PartionGoodsKind_To.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_PartionGoodsKind_To.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()
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

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_ProductionUnion()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());



     -- ��������� ������� - �������������� Master(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem_pr (MovementItemId
                         , MIContainerId_To, ContainerId_GoodsTo, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount
                         , InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_To
                         , UnitId_Item, StorageId_Item
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId)
        SELECT _tmp.MovementItemId

             , 0 AS MIContainerId_To
             , 0 AS ContainerId_GoodsTo
             , _tmp.GoodsId
             , _tmp.GoodsKindId
             , _tmp.GoodsKindId_complete
             , _tmp.AssetId
             , _tmp.PartionGoods
             , _tmp.PartionGoodsDate

             , _tmp.OperCount

               -- �������������� ����������
             , _tmp.InfoMoneyDestinationId
               -- ������ ����������
             , _tmp.InfoMoneyId

               -- �������� ������ !!!����������!!! �� ������ ��� ������������/����������
             , CASE WHEN _tmp.BusinessId_To = 0 THEN vbBusinessId_To ELSE _tmp.BusinessId_To END AS BusinessId_To

             , 0 AS UnitId_Item, 0 AS StorageId_Item
             , _tmp.isPartionCount
             , _tmp.isPartionSumm
               -- ������ ������, ���������� �����
             , 0 AS PartionGoodsId
        FROM
             (SELECT MovementItem.Id AS MovementItemId

                   , MovementItem.ObjectId AS GoodsId
                   , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ���������
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                           AND vbIsPartionGoodsKind_Unit_To = TRUE
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          ELSE 0
                     END AS GoodsKindId
                   , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_complete

                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                   , Movement.OperDate AS PartionGoodsDate

                   , MovementItem.Amount AS OperCount

                  -- �������������� ����������
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                  -- ������ ����������
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- ������ �� ������
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_To

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)     AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)      AS isPartionSumm

              FROM Movement
                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                    ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

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

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_ProductionUnion()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp;


     -- !!!�����: ����� ������������ ������� - �������������� Child(������)-�������� ���������!!!
     IF vbIsPartionDate_Unit_From = TRUE AND vbIsPartionDate_Unit_To = FALSE AND vbOperDate >= '01.07.2015'
     THEN -- ������ ������ �/� (��) �� ���������
          PERFORM lpComplete_Movement_ProductionUnion_Partion (inMovementId:= inMovementId
                                                             , inFromId    := vbUnitId_From
                                                             , inUserId    := inUserId
                                                              );
     END IF;


     -- ��������� ������� - �������������� Child(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItemChild (MovementItemId_Parent, MovementItemId
                              , ContainerId_GoodsFrom, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate
                              , OperCount
                              , InfoMoneyDestinationId, InfoMoneyId
                              , BusinessId_From
                              , UnitId_Item, PartionGoodsId_Item
                              , isPartionCount, isPartionSumm
                              , PartionGoodsId)

        SELECT _tmp.MovementItemId_Parent
             , _tmp.MovementItemId

             , 0 AS ContainerId_GoodsFrom
             , _tmp.GoodsId
             , _tmp.GoodsKindId
             , _tmp.GoodsKindId_complete
             , _tmp.AssetId
             , _tmp.PartionGoods
             , _tmp.PartionGoodsDate

             , _tmp.OperCount

               -- �������������� ����������
             , _tmp.InfoMoneyDestinationId
               -- ������ ����������
             , _tmp.InfoMoneyId

               -- �������� ������ !!!����������!!! �� ������ ��� ������������/����������
             , CASE WHEN _tmp.BusinessId_From = 0 THEN vbBusinessId_From ELSE _tmp.BusinessId_From END AS BusinessId_From

             , 0 AS UnitId_Item, 0 AS PartionGoodsId_Item
             , _tmp.isPartionCount
             , _tmp.isPartionSumm
               -- ������ ������, ���������� �����
             , 0 AS PartionGoodsId
        FROM
             (SELECT MovementItem.ParentId AS MovementItemId_Parent
                   , MovementItem.Id AS MovementItemId

                   , MovementItem.ObjectId AS GoodsId
                   , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ���������
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                           AND vbIsPartionGoodsKind_Unit_From = TRUE
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          ELSE 0
                     END AS GoodsKindId
                   , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ���������
                               THEN COALESCE (MILinkObject_GoodsKindComplete.ObjectId, CASE WHEN _tmpItem_pr.GoodsKindId <> zc_GoodsKind_WorkProgress() THEN _tmpItem_pr.GoodsKindId ELSE 0 END)
                          ELSE 0
                     END AS GoodsKindId_complete
                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

                   , MovementItem.Amount AS OperCount

                     -- �������������� ����������
                   , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                     -- ������ ����������
                   , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                     -- ������ �� ������
                   , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_From

                   , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)     AS isPartionCount
                   , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)      AS isPartionSumm

              -- FROM Movement
              --     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE
              FROM _tmpItem_pr
                   INNER JOIN MovementItem ON MovementItem.ParentId = _tmpItem_pr.MovementItemId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE
                                          AND MovementItem.MovementId = inMovementId

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                    ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

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

              -- WHERE Movement.Id = inMovementId
              --   AND Movement.DescId = zc_Movement_ProductionUnion()
              --   AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp;



     -- ����������� ������ ������ ��� Master(������)-��������, ���� ���� ...
     UPDATE _tmpItem_pr SET PartionGoodsId = CASE WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                AND vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                AND (_tmpItem_pr.isPartionCount = TRUE OR _tmpItem_pr.isPartionSumm = TRUE)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem_pr.PartionGoods)

                                               -- �������� ���� (���� ��-��)
                                               WHEN vbIsPartionDate_Unit_To      = TRUE
                                                AND vbIsPartionGoodsKind_Unit_To = TRUE
                                                AND vbIsPeresort = FALSE
                                                AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()  -- �������� ����� + ������ �����
                                                   THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem_pr.PartionGoodsDate
                                                                                        , inGoodsKindId_complete := _tmpItem_pr.GoodsKindId_complete
                                                                                         )
                                               -- ������������ ��-��
                                               WHEN vbIsPartionDate_Unit_To = TRUE
                                                AND _tmpItem_pr.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ������������� + ����
                                                                                         , zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                         , zc_Enum_InfoMoneyDestination_30200()  -- ������ + ������ �����
                                                                                          )
                                                   THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem_pr.PartionGoodsDate
                                                                                        , inGoodsKindId_complete := _tmpItem_pr.GoodsKindId_complete
                                                                                         )
                                               WHEN _tmpItem_pr.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ������������� + ����
                                                                                         , zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                         , zc_Enum_InfoMoneyDestination_30200()  -- ������ + ������ �����
                                                                                          )
                                                   THEN 0

                                               WHEN _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                 OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                 OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                    THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= _tmpItem_pr.UnitId_Item
                                                                                         , inGoodsId       := _tmpItem_pr.GoodsId
                                                                                         , inStorageId     := _tmpItem_pr.StorageId_Item
                                                                                         , inInvNumber     := _tmpItem_pr.PartionGoods
                                                                                         , inOperDate      := _tmpItem_pr.PartionGoodsDate
                                                                                         , inPrice         := NULL
                                                                                          )
                                               ELSE lpInsertFind_Object_PartionGoods ('')
                                          END
     WHERE _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
     ;
     -- ����������� ������ ������ ��� Child(������)-��������, ���� ���� ...
     UPDATE _tmpItemChild SET PartionGoodsId = CASE WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                     AND vbAccountDirectionId_From = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                     AND (_tmpItemChild.isPartionCount = TRUE OR _tmpItemChild.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItemChild.PartionGoods)

                                                    -- �������� ���� (���� ��-��)
                                                    WHEN vbIsPartionDate_Unit_From = TRUE
                                                     AND vbUnitId_From <> vbUnitId_To
                                                     -- AND EXISTS (SELECT 1 FROM _tmpItem_pr WHERE _tmpItem_pr.MovementItemId = _tmpItemChild.MovementItemId_Parent AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100())
                                                     AND _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()  -- �������� ����� + ������ �����
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItemChild.PartionGoodsDate
                                                                                             , inGoodsKindId_complete := _tmpItemChild.GoodsKindId_complete
                                                                                              )
                                                    -- ������������ ��-��
                                                    WHEN vbIsPartionDate_Unit_From = TRUE
                                                     AND _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ������������� + ����
                                                                                                , zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                                , zc_Enum_InfoMoneyDestination_30200()  -- ������ + ������ �����
                                                                                                 )
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItemChild.PartionGoodsDate
                                                                                             , inGoodsKindId_complete := _tmpItemChild.GoodsKindId_complete
                                                                                              )
                                                    WHEN _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ������������� + ����
                                                                                                , zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                                , zc_Enum_InfoMoneyDestination_30200()  -- ������ + ������ �����
                                                                                                 )
                                                        THEN 0

                                                    WHEN _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                      OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                      OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                         THEN _tmpItemChild.PartionGoodsId_Item
                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
     WHERE _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
     ;

     -- ����������
     vbWhereObjectId_Analyzer_From:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From END;
     vbWhereObjectId_Analyzer_To:= CASE WHEN vbUnitId_To <> 0 THEN vbUnitId_To WHEN vbMemberId_To <> 0 THEN vbMemberId_To END;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- ������������ ContainerId_GoodsFrom ��� Child(������)-�������� ��������������� �����
     UPDATE _tmpItemChild SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                         , inUnitId                 := CASE WHEN vbMemberId_From <> 0 THEN _tmpItemChild.UnitId_Item ELSE vbUnitId_From END
                                                                                         , inCarId                  := NULL
                                                                                         , inMemberId               := vbMemberId_From
                                                                                         , inInfoMoneyDestinationId := _tmpItemChild.InfoMoneyDestinationId
                                                                                         , inGoodsId                := _tmpItemChild.GoodsId
                                                                                         , inGoodsKindId            := _tmpItemChild.GoodsKindId
                                                                                         , inIsPartionCount         := _tmpItemChild.isPartionCount
                                                                                         , inPartionGoodsId         := _tmpItemChild.PartionGoodsId
                                                                                         , inAssetId                := _tmpItemChild.AssetId
                                                                                         , inBranchId               := vbBranchId_From
                                                                                         , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                          );
     -- ������������ ContainerId_GoodsTo ��� Master(������)-�������� ��������������� �����
     UPDATE _tmpItem_pr SET ContainerId_GoodsTo = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                  , inUnitId                 := CASE WHEN vbMemberId_To <> 0 THEN _tmpItem_pr.UnitId_Item ELSE vbUnitId_To END
                                                                                  , inCarId                  := NULL
                                                                                  , inMemberId               := vbMemberId_To
                                                                                  , inInfoMoneyDestinationId := _tmpItem_pr.InfoMoneyDestinationId
                                                                                  , inGoodsId                := _tmpItem_pr.GoodsId
                                                                                  , inGoodsKindId            := _tmpItem_pr.GoodsKindId
                                                                                  , inIsPartionCount         := _tmpItem_pr.isPartionCount
                                                                                  , inPartionGoodsId         := _tmpItem_pr.PartionGoodsId
                                                                                  , inAssetId                := _tmpItem_pr.AssetId
                                                                                  , inBranchId               := vbBranchId_To
                                                                                  , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                   );

     -- ����� ����������: ��������� ������� - �������� Child(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     IF inMovementId IN (2296516, 2296563) -- !!!����������� ����������� ������ - 31.07.2015!!!
     THEN
     INSERT INTO _tmpItemSummChild (MovementItemId_Parent, MovementItemId, ContainerId_From, AccountId_From, InfoMoneyId_Detail_From, OperSumm)
        WITH tmpRemains AS (SELECT _tmpItemChild.ContainerId_GoodsFrom, Container.Id AS ContainerId, Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS OperSumm
                            FROM _tmpItemChild
                                 INNER JOIN Container ON Container.ParentId = _tmpItemChild.ContainerId_GoodsFrom
                                 LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = Container.Id
                                                                               AND MIContainer.OperDate >= '01.08.2015'
                            GROUP BY _tmpItemChild.ContainerId_GoodsFrom, Container.Id, Container.Amount
                            HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                           )
        SELECT
              _tmpItemChild.MovementItemId_Parent
            , _tmpItemChild.MovementItemId
            , Container.Id       AS ContainerId_From
            , Container.ObjectId AS AccountId_From
            , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
            , 1 * tmpRemains.OperSumm
        FROM _tmpItemChild
             INNER JOIN tmpRemains ON tmpRemains.ContainerId_GoodsFrom = _tmpItemChild.ContainerId_GoodsFrom
             INNER JOIN Container ON Container.Id = tmpRemains.ContainerId
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                           ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpRemains.ContainerId
                                          AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
       ;
     ELSE
     INSERT INTO _tmpItemSummChild (MovementItemId_Parent, MovementItemId, ContainerId_From, AccountId_From, InfoMoneyId_Detail_From, OperSumm)
        SELECT
              _tmpItemChild.MovementItemId_Parent
            , _tmpItemChild.MovementItemId
            , COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0)) AS ContainerId_From
            , COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) AS AccountId_From
            , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
            , SUM (/*ABS*/ (CASE WHEN vbProcessId = zc_Enum_Process_Auto_Defroster() -- !!!��� <����� ���������> ������ ����!!!
                                      THEN CAST (_tmpItemChild.OperCount * COALESCE (HistoryCost.Price_external, 0) AS NUMERIC (16,4))
                                 ELSE CAST (_tmpItemChild.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                                    + CASE WHEN _tmpItemChild.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItemChild.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                                                THEN HistoryCost.Summ_diff -- !!!���� ���� "�����������" ��� ����������, �������� �����!!!
                                           ELSE 0
                                      END
                            END)) AS OperSumm
        FROM _tmpItemChild
             -- ��� ������� ��� ����
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItemChild.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis_From
                                                                                 AND lfContainerSumm_20901.BusinessId        = _tmpItemChild.BusinessId_From
                                                                                 AND _tmpItemChild.InfoMoneyDestinationId    = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
             -- ��� ������� ��� ���������
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItemChild.ContainerId_GoodsFrom
                                                  AND Container_Summ.DescId = zc_Container_Summ()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                           ON ContainerLinkObject_InfoMoneyDetail.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                          AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
             /*INNER JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                            ON ContainerObjectCost_Basis.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                           AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id) -- ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE /*zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND (ContainerLinkObject_InfoMoneyDetail.ObjectId = 0 OR zc_isHistoryCost_byInfoMoneyDetail()= TRUE)
          -- AND inIsHistoryCost = TRUE -- OR (_tmpItemChild.OperCount * HistoryCost.Price) <> 0) -- !!!�����������!!! ��������� ���� ���� ��� �� ��������� ��� (��� ����� ��� ������� �/�)
          AND*/ (_tmpItemChild.OperCount * HistoryCost.Price) <> 0 -- !!!��!!! ��������� ����
          AND vbIsHistoryCost= TRUE -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
        GROUP BY
                 _tmpItemChild.MovementItemId_Parent
               , _tmpItemChild.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId
               , ContainerLinkObject_InfoMoneyDetail.ObjectId
        ;
     END IF;

     -- !!!��������!!! - ������������ � Child(������)-�������� ���������
     IF EXISTS (SELECT _tmpItemSummChild.MovementItemId, _tmpItemSummChild.ContainerId_From FROM _tmpItemSummChild GROUP BY _tmpItemSummChild.MovementItemId, _tmpItemSummChild.ContainerId_From HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION '������ � ���������.';
     END IF;


     -- ���������� � �������� ������� - �������� Master(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     IF inMovementId IN (2296516, 2296563) -- !!!����������� ����������� ������ - 01.08.2015!!!
     THEN
     INSERT INTO _tmpItemSumm_pr (MovementItemId, AccountGroupId_From, AccountDirectionId_From, AccountId_From, ContainerId_From, MIContainerId_To, ContainerId_To, AccountId_To, InfoMoneyId_Detail_To, OperSumm)
        SELECT _tmpItemSummChild.MovementItemId_Parent, ObjectLink_Account_AccountGroup.ChildObjectId, ObjectLink_Account_AccountDirection.ChildObjectId, _tmpItemSummChild.AccountId_From, _tmpItemSummChild.ContainerId_From
             , 0 AS MIContainerId_To
             , 0 AS ContainerId_To
             , 0 AS AccountId_To -- !!!������ ���� _tmpItemSummChild.AccountId_From!!!, ������ ������� ������
             , zc_Enum_InfoMoney_10203() AS InfoMoneyId_Detail_From
             , SUM (_tmpItemSummChild.OperSumm)
        FROM _tmpItemSummChild
             LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                  ON ObjectLink_Account_AccountGroup.ObjectId = _tmpItemSummChild.AccountId_From
                                 AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
             LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                                  ON ObjectLink_Account_AccountDirection.ObjectId = _tmpItemSummChild.AccountId_From
                                 AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()
        GROUP BY _tmpItemSummChild.MovementItemId_Parent
               , ObjectLink_Account_AccountGroup.ChildObjectId
               , ObjectLink_Account_AccountDirection.ChildObjectId
               , _tmpItemSummChild.AccountId_From
               , _tmpItemSummChild.ContainerId_From
                ;
     ELSE
     INSERT INTO _tmpItemSumm_pr (MovementItemId, AccountGroupId_From, AccountDirectionId_From, AccountId_From, ContainerId_From, MIContainerId_To, ContainerId_To, AccountId_To, InfoMoneyId_Detail_To, OperSumm)
        SELECT _tmpItemSummChild.MovementItemId_Parent, ObjectLink_Account_AccountGroup.ChildObjectId, ObjectLink_Account_AccountDirection.ChildObjectId, _tmpItemSummChild.AccountId_From, _tmpItemSummChild.ContainerId_From
             , 0 AS MIContainerId_To
             , 0 AS ContainerId_To
             , CASE WHEN vbIsPeresort = TRUE THEN 0 ELSE 0 END AS AccountId_To -- !!!������ ���� _tmpItemSummChild.AccountId_From!!!, ������ ������� ������
             , _tmpItemSummChild.InfoMoneyId_Detail_From
             , SUM (_tmpItemSummChild.OperSumm)
        FROM _tmpItemSummChild
             LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                  ON ObjectLink_Account_AccountGroup.ObjectId = _tmpItemSummChild.AccountId_From
                                 AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
             LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                                  ON ObjectLink_Account_AccountDirection.ObjectId = _tmpItemSummChild.AccountId_From
                                 AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()
        GROUP BY _tmpItemSummChild.MovementItemId_Parent
               , ObjectLink_Account_AccountGroup.ChildObjectId
               , ObjectLink_Account_AccountDirection.ChildObjectId
               , _tmpItemSummChild.AccountId_From
               , _tmpItemSummChild.ContainerId_From
               -- , CASE WHEN vbIsPeresort = TRUE THEN 0 ELSE 0 END -- !!!������ ���� _tmpItemSummChild.AccountId_From!!!, ������ ������� ������
               , _tmpItemSummChild.InfoMoneyId_Detail_From;
     END IF;


     -- ��� ����� - Master - Summ
     -- RETURN QUERY SELECT _tmpItemSumm_pr.AccountId_To, _tmpItemSumm_pr.MovementItemId, _tmpItemSumm_pr.MIContainerId_To, _tmpItemSumm_pr.InfoMoneyId_Detail_To, _tmpItemSumm_pr.OperSumm FROM _tmpItemSumm_pr;
     -- ��� ����� - Child - Summ
     -- RETURN QUERY SELECT _tmpItemSummChild.MovementItemId_Parent, _tmpItemSummChild.MovementItemId, _tmpItemSummChild.ContainerId_From, _tmpItemSummChild.InfoMoneyId_Detail_From, _tmpItemSummChild.OperSumm FROM _tmpItemSummChild ;
     -- RETURN;


     -- ����������� �������� ��� ��������������� ����� - ���� + ������������ MIContainer.Id (��������������)
     UPDATE _tmpItem_pr SET MIContainerId_To =
             lpInsertUpdate_MovementItemContainer (ioId             := 0
                                                 , inDescId         := zc_MIContainer_Count()
                                                 , inMovementDescId := vbMovementDescId
                                                 , inMovementId     := inMovementId
                                                 , inMovementItemId := _tmpItem_pr.MovementItemId
                                                 , inParentId       := NULL
                                                 , inContainerId    := _tmpItem_pr.ContainerId_GoodsTo            -- ��� ���������� ����
                                                 , inAccountId      := 0                                       -- ��� �����
                                                 , inAnalyzerId              := vbWhereObjectId_Analyzer_From  -- ��� ���������, �� ��� ��������� ������� ����� ������������ "�� ����" ���...
                                                 , inObjectId_Analyzer       := _tmpItem_pr.GoodsId               -- �����
                                                 , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- ������������ ���...
                                                 , inContainerId_Analyzer    := 0                              -- �������������� ���������-������ (��� ������� �� ����)
                                                 , inObjectIntId_Analyzer    := _tmpItem_pr.GoodsKindId           -- ��� ������
                                                 , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From  -- ������������ "�� ����"
                                                 , inContainerIntId_Analyzer := 0                              -- ��������� "�����"
                                                 , inAmount         := _tmpItem_pr.OperCount
                                                 , inOperDate       := vbOperDate
                                                 , inIsActive       := TRUE
                                                  );
     -- ����������� �������� ��� ��������������� ����� - �� ����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId --, ParentId, Amount, OperDate, IsActive)
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       WITH tmpGoods_ReWork AS (SELECT ObjectLink.ObjectId AS GoodsId FROM ObjectLink WHERE ObjectLink.ChildObjectId = zc_Enum_InfoMoney_30301() AND ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney())
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItemChild.MovementItemId
            , _tmpItemChild.ContainerId_GoodsFrom
            , 0                                       AS AccountId              -- ��� �����
            , CASE WHEN tmpGoods_ReWork.GoodsId > 0 THEN zc_Enum_AnalyzerId_ReWork() ELSE vbWhereObjectId_Analyzer_To END AS AnalyzerId -- ���� ��������� + ��� ��������� ������� ����� ������������ "����" ���...
            , _tmpItemChild.GoodsId                   AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- ������������ ���...
            , _tmpItem_pr.ContainerId_GoodsTo            AS ContainerId_Analyzer   -- �������������� ���������-������ (�.�. �� �������)
            , _tmpItemChild.GoodsKindId               AS ObjectIntId_Analyzer   -- ��� ������
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- ������������ "����"
            , _tmpItem_pr.MIContainerId_To               AS ParentId
            , -1 * _tmpItemChild.OperCount
            , vbOperDate
            , FALSE
       FROM _tmpItemChild
            JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItemChild.MovementItemId_Parent
            LEFT JOIN tmpGoods_ReWork ON tmpGoods_ReWork.GoodsId = _tmpItem_pr.GoodsId
      ;


     -- ������������ ����(�����������) ��� �������� �� ��������� ����� - ����
     UPDATE _tmpItemSumm_pr SET AccountId_To = _tmpItem_byAccount.AccountId
     FROM _tmpItem_pr
          JOIN (SELECT lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId_From -- zc_Enum_AccountGroup_20000() -- ������ -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                  , inAccountDirectionId     := CASE WHEN vbIsPeresort = TRUE
                                                                                          THEN _tmpItem_group.AccountDirectionId_From
                                                                                     WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                                                                                          THEN zc_Enum_AccountDirection_20900() -- 20900; "��������� ����"
                                                                                     WHEN vbMemberId_To <> 0
                                                                                      AND _tmpItem_group.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "�������� �����"; 10100; "������ �����"
                                                                                                                                  , zc_Enum_InfoMoneyDestination_20700() -- "�������������"; 20700; "������"
                                                                                                                                  , zc_Enum_InfoMoneyDestination_20900() -- "�������������"; 20900; "����"
                                                                                                                                  , zc_Enum_InfoMoneyDestination_21000() -- "�������������"; 21000; "�����"
                                                                                                                                  , zc_Enum_InfoMoneyDestination_21100() -- "�������������"; 21100; "�������"
                                                                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                                                                  , zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                                                                                                                   )
                                                                                          THEN 0 -- !!!�� ���� ��� ���������� �� ����� ���� �� �����!!!
                                                                                     ELSE vbAccountDirectionId_To
                                                                                END
                                                  , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := inUserId
                                                   ) AS AccountId
                     , _tmpItem_group.InfoMoneyDestinationId
                     , _tmpItem_group.AccountId_From
                FROM (SELECT _tmpItem_pr.InfoMoneyDestinationId
                           , CASE WHEN (_tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                    OR (_tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                    OR (_tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                       THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                                  WHEN _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20800() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()) -- ������ + �� �������� AND �������� ����� + ������ �����
                                       THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                  ELSE _tmpItem_pr.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                           , _tmpItemSumm_pr.AccountGroupId_From
                           , _tmpItemSumm_pr.AccountDirectionId_From
                           , _tmpItemSumm_pr.AccountId_From
                      FROM _tmpItem_pr
                           INNER JOIN _tmpItemSumm_pr ON _tmpItemSumm_pr.MovementItemId = _tmpItem_pr.MovementItemId
                      WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
                        -- AND vbIsPeresort = FALSE -- !!!���� �� �����������!!! -- !!!������ ���� _tmpItemSummChild.AccountId_From!!!, ������ ������� ������
                      GROUP BY _tmpItem_pr.InfoMoneyDestinationId
                             , CASE WHEN (_tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                      OR (_tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                      OR (_tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                      OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                      OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                      OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                         THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                                    WHEN _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                      OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20800() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()) -- ������ + �� �������� AND �������� ����� + ������ �����
                                         THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                    ELSE _tmpItem_pr.InfoMoneyDestinationId
                               END
                             , _tmpItemSumm_pr.AccountGroupId_From
                             , _tmpItemSumm_pr.AccountDirectionId_From
                             , _tmpItemSumm_pr.AccountId_From
                     ) AS _tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.InfoMoneyDestinationId = _tmpItem_pr.InfoMoneyDestinationId
     WHERE _tmpItemSumm_pr.MovementItemId = _tmpItem_pr.MovementItemId
       AND _tmpItemSumm_pr.AccountId_From = _tmpItem_byAccount.AccountId_From;

     -- ������������ ContainerId ��� �������� �� ��������� ����� - ����  + ����������� ��������� <������� �/�>
     UPDATE _tmpItemSumm_pr SET ContainerId_To = _tmpItem_group.ContainerId_To
     FROM (SELECT lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                    , inUnitId                 := CASE WHEN vbMemberId_To <> 0 THEN _tmpItem_pr.UnitId_Item ELSE vbUnitId_To END
                                                    , inCarId                  := NULL
                                                    , inMemberId               := vbMemberId_To
                                                    , inBranchId               := vbBranchId_To
                                                    , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                    , inBusinessId             := _tmpItem_pr.BusinessId_To
                                                    , inAccountId              := _tmpItemSumm_group.AccountId_To
                                                    , inInfoMoneyDestinationId := _tmpItem_pr.InfoMoneyDestinationId
                                                    , inInfoMoneyId            := _tmpItem_pr.InfoMoneyId
                                                    , inInfoMoneyId_Detail     := _tmpItemSumm_group.InfoMoneyId_Detail_To
                                                    , inContainerId_Goods      := _tmpItem_pr.ContainerId_GoodsTo
                                                    , inGoodsId                := _tmpItem_pr.GoodsId
                                                    , inGoodsKindId            := _tmpItem_pr.GoodsKindId
                                                    , inIsPartionSumm          := _tmpItem_pr.isPartionSumm
                                                    , inPartionGoodsId         := _tmpItem_pr.PartionGoodsId
                                                    , inAssetId                := _tmpItem_pr.AssetId
                                                     ) AS ContainerId_To
                , _tmpItem_pr.MovementItemId
                , _tmpItemSumm_group.AccountId_To
                , _tmpItemSumm_group.InfoMoneyId_Detail_To
           FROM _tmpItem_pr
                JOIN (SELECT _tmpItemSumm_pr.MovementItemId, _tmpItemSumm_pr.AccountId_To, _tmpItemSumm_pr.InfoMoneyId_Detail_To FROM _tmpItemSumm_pr GROUP BY _tmpItemSumm_pr.MovementItemId, _tmpItemSumm_pr.AccountId_To, _tmpItemSumm_pr.InfoMoneyId_Detail_To
                     ) AS _tmpItemSumm_group ON _tmpItemSumm_group.MovementItemId = _tmpItem_pr.MovementItemId
          ) AS _tmpItem_group
     WHERE _tmpItemSumm_pr.MovementItemId = _tmpItem_group.MovementItemId
       AND _tmpItemSumm_pr.AccountId_To = _tmpItem_group.AccountId_To
       AND _tmpItemSumm_pr.InfoMoneyId_Detail_To = _tmpItem_group.InfoMoneyId_Detail_To;

     -- ����������� �������� ��� ��������� ����� - ���� + ������������ MIContainer.Id (��������)
     UPDATE _tmpItemSumm_pr SET MIContainerId_To = _tmpItem_group.MIContainerId_To
     FROM (SELECT lpInsertUpdate_MovementItemContainer (ioId             := 0
                                                      , inDescId         := zc_MIContainer_Summ()
                                                      , inMovementDescId := vbMovementDescId
                                                      , inMovementId     := inMovementId
                                                      , inMovementItemId := _tmpItem_pr.MovementItemId
                                                      , inParentId       := NULL
                                                      , inContainerId    := _tmpItemSumm_group.ContainerId_To
                                                      , inAccountId      := _tmpItemSumm_group.AccountId_To         -- ���� ���� ������
                                                      , inAnalyzerId              := vbWhereObjectId_Analyzer_From  -- ��� ���������, �� ��� ��������� ������� ����� ������������ "�� ����" ���...
                                                      , inObjectId_Analyzer       := _tmpItem_pr.GoodsId            -- �����
                                                      , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- ������������ ���...
                                                      , inContainerId_Analyzer    := 0                              -- �������� ���������-������ (��� ������� �� ����)
                                                      , inObjectIntId_Analyzer    := _tmpItem_pr.GoodsKindId        -- ��� ������
                                                      , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From  -- ������������ "�� ����"
                                                      , inContainerIntId_Analyzer := 0                              -- ��������� "�����"
                                                      , inAmount         := _tmpItemSumm_group.OperSumm
                                                      , inOperDate       := vbOperDate
                                                      , inIsActive       := TRUE
                                                       ) AS MIContainerId_To
                , _tmpItem_pr.MovementItemId
                , _tmpItemSumm_group.ContainerId_To
           FROM _tmpItem_pr
                JOIN (SELECT _tmpItemSumm_pr.MovementItemId, _tmpItemSumm_pr.ContainerId_To, _tmpItemSumm_pr.AccountId_To, SUM (_tmpItemSumm_pr.OperSumm) AS OperSumm FROM _tmpItemSumm_pr GROUP BY _tmpItemSumm_pr.MovementItemId, _tmpItemSumm_pr.ContainerId_To, _tmpItemSumm_pr.AccountId_To
                     ) AS _tmpItemSumm_group ON _tmpItemSumm_group.MovementItemId = _tmpItem_pr.MovementItemId
          ) AS _tmpItem_group
     WHERE _tmpItemSumm_pr.MovementItemId = _tmpItem_group.MovementItemId
       AND _tmpItemSumm_pr.ContainerId_To = _tmpItem_group.ContainerId_To;

     -- ����������� �������� ��� ��������� ����� - �� ����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       WITH tmpGoods_ReWork AS (SELECT ObjectLink.ObjectId AS GoodsId FROM ObjectLink WHERE ObjectLink.ChildObjectId = zc_Enum_InfoMoney_30301() AND ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney())
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemChild.MovementItemId
            , _tmpItemSummChild.ContainerId_From
            , _tmpItemSummChild.AccountId_From        AS AccountId              -- ���� ���� ������
            , CASE WHEN tmpGoods_ReWork.GoodsId > 0 THEN zc_Enum_AnalyzerId_ReWork() ELSE vbWhereObjectId_Analyzer_To END AS AnalyzerId -- ���� ��������� + ��� ��������� ������� ����� ������������ "����" ���...
            , _tmpItemChild.GoodsId                   AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- ������������ ���...
            , _tmpItemSumm_pr.ContainerId_To          AS ContainerId_Analyzer   -- �������� ���������-������ (�.�. �� �������)
            , _tmpItemChild.GoodsKindId               AS ObjectIntId_Analyzer   -- ��� ������
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- ������������ "����"
            , _tmpItemSumm_pr.MIContainerId_To        AS ParentId
            , -1 * _tmpItemSummChild.OperSumm
            , vbOperDate
            , FALSE
       FROM _tmpItemChild
            JOIN _tmpItemSummChild ON _tmpItemSummChild.MovementItemId = _tmpItemChild.MovementItemId
            JOIN _tmpItemSumm_pr ON _tmpItemSumm_pr.MovementItemId   = _tmpItemSummChild.MovementItemId_Parent
                             AND _tmpItemSumm_pr.ContainerId_From = _tmpItemSummChild.ContainerId_From
            JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItemSumm_pr.MovementItemId
            LEFT JOIN tmpGoods_ReWork ON tmpGoods_ReWork.GoodsId = _tmpItem_pr.GoodsId
       WHERE _tmpItemSummChild.MovementItemId = _tmpItemChild.MovementItemId;



     -- !!!�������� ��� ������ ������ �� �����!!!
     IF 1=0 THEN
     -- !!!�� ������ �������� ��� ������!!!
     IF vbIsHistoryCost = TRUE THEN


     -- ����������� �������� ��� ������ (���������: ����� ������ � ����� ������)
     INSERT INTO _tmpMIReport_insert (Id, MovementDescId, MovementId, MovementItemId, ActiveContainerId, PassiveContainerId, ActiveAccountId, PassiveAccountId, ReportContainerId, ChildReportContainerId, Amount, OperDate)
        SELECT 0, vbMovementDescId, inMovementId, MovementItemId, ActiveContainerId, PassiveContainerId, ActiveAccountId, PassiveAccountId, ReportContainerId, ChildReportContainerId, Amount, OperDate
        FROM (SELECT tmpMIReport.MovementItemId
                   , tmpMIReport.ActiveContainerId
                   , tmpMIReport.PassiveContainerId
                   , tmpMIReport.ActiveAccountId
                   , tmpMIReport.PassiveAccountId
                   , lpInsertFind_ReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                 , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                 , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                 , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                  ) AS ReportContainerId
                   , lpInsertFind_ChildReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                      , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                      , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                      , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                      --, inAccountKindId_1    := NULL
                                                      --, inContainerId_1      := NULL
                                                      --, inAccountId_1        := NULL
                                                       ) AS ChildReportContainerId
                   , tmpMIReport.OperSumm AS Amount
                   , vbOperDate AS OperDate
              FROM (SELECT ABS (tmpCalc.OperSumm)       AS OperSumm
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_To   ELSE tmpCalc.ContainerId_From END AS ActiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_From ELSE tmpCalc.ContainerId_To   END AS PassiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_To     ELSE tmpCalc.AccountId_From   END AS ActiveAccountId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_From   ELSE tmpCalc.AccountId_To     END AS PassiveAccountId
                         , tmpCalc.MovementItemId
                    FROM (SELECT _tmpItemSumm_pr.MovementItemId
                               , _tmpItemSummChild.ContainerId_From
                               , _tmpItemSummChild.AccountId_From
                               , _tmpItemSumm_pr.ContainerId_To
                               , _tmpItemSumm_pr.AccountId_To
                               , (_tmpItemSummChild.OperSumm) AS OperSumm
                          FROM _tmpItemSummChild
                               JOIN _tmpItemSumm_pr ON _tmpItemSumm_pr.MovementItemId = _tmpItemSummChild.MovementItemId_Parent
                                                   AND _tmpItemSumm_pr.ContainerId_From = _tmpItemSummChild.ContainerId_From
                               LEFT JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItemSummChild.MovementItemId_Parent
                         ) AS tmpCalc
                    WHERE tmpCalc.OperSumm <> 0
                   ) AS tmpMIReport
             ) AS tmpMIReport
       ;

     END IF; -- if vbIsHistoryCost = TRUE -- !!!�� ������ �������� ��� ������!!!
     END IF; -- if 1=0 -- !!!�������� ��� ������ ������ �� �����!!!


     -- !!!5.0. ����������� �������� � ��������� ��������� - <���������>, ���� �� ��-�� � �� �����������!!!
     IF vbIsPeresort = FALSE
     THEN
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), tmp.MovementItemId, tmp.ReceiptId)
          FROM (SELECT _tmpItem_pr.MovementItemId
                     , tmpReceipt.ReceiptId
                FROM _tmpItem_pr
                     LEFT JOIN (SELECT COALESCE (ObjectLink_Receipt_Goods.ObjectId, 0) AS ReceiptId
                                     , tmpGoods.GoodsId
                                     , tmpGoods.GoodsKindId
                                FROM (SELECT _tmpItem_pr.GoodsId, _tmpItem_pr.GoodsKindId FROM _tmpItem_pr WHERE _tmpItem_pr.GoodsKindId <> zc_GoodsKind_WorkProgress() GROUP BY _tmpItem_pr.GoodsId, _tmpItem_pr.GoodsKindId) AS tmpGoods
                                     INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                           ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                          AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                              ON ObjectBoolean_Main.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                             AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                             AND ObjectBoolean_Main.ValueData = TRUE
                                     LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                          ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                         AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpGoods.GoodsKindId
                               ) AS tmpReceipt ON tmpReceipt.GoodsId = _tmpItem_pr.GoodsId
                                         AND tmpReceipt.GoodsKindId = _tmpItem_pr.GoodsKindId
                WHERE _tmpItem_pr.GoodsKindId <> zc_GoodsKind_WorkProgress()
               ) AS tmp;

     END IF; -- if vbIsPeresort = FALSE

     -- !!!5.0.2. ����������� �������� "�� ���������" � ��������� ���������, ���� ��-�� � �� �����������!!!
     IF vbIsPeresort = FALSE AND 1=0
     THEN
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_WeightMain(), tmp.MovementItemId, tmp.isWeightMain)
                , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_TaxExit(), tmp.MovementItemId, tmp.isTaxExit)
          FROM (SELECT MovementItem.Id                      AS MovementItemId
                     , COALESCE (tmpMI.isWeightMain, FALSE) AS isWeightMain
                     , COALESCE (tmpMI.isTaxExit, FALSE)    AS isTaxExit
                FROM _tmpItem_pr
                     INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId   = zc_MI_Child()
                                            AND MovementItem.ParentId = _tmpItem_pr.MovementItemId
                                            AND MovementItem.isErased  = FALSE
                     LEFT JOIN (SELECT _tmpItem_pr.MovementItemId                              AS MovementItemId
                                     , ObjectLink_ReceiptChild_Goods.ChildObjectId          AS GoodsId
                                     , COALESCE (ObjectBoolean_WeightMain.ValueData, FALSE) AS isWeightMain
                                     , COALESCE (ObjectBoolean_TaxExit.ValueData, FALSE)    AS isTaxExit
                                FROM _tmpItem_pr
                                     INNER JOIN MovementItemLinkObject AS MILO_Receipt
                                                                       ON MILO_Receipt.MovementItemId = _tmpItem_pr.MovementItemId
                                                                      AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                                     INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                           ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = MILO_Receipt.ObjectId
                                                          AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                                     LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                          ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                         AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                                             ON ObjectBoolean_WeightMain.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                            AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                             ON ObjectBoolean_TaxExit.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                            AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
                                WHERE _tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress()
                               ) AS tmpMI ON tmpMI.MovementItemId = _tmpItem_pr.MovementItemId
                                         AND tmpMI.GoodsId = MovementItem.ObjectId
                WHERE _tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress()
               ) AS tmp;

     END IF; -- if vbIsPeresort = FALSE AND 1=0


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();
     -- 5.2. ����� - ����������� ��������� �������� ��� ������
     PERFORM lpInsertUpdate_MIReport_byTable ();

     -- 5.3. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ProductionUnion()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.07.15                                        * add lpComplete_Movement_ProductionUnion_Partion
 03.05.15                                        * set lp
 17.08.14                                        * add MovementDescId
 13.08.14                                        * add lpInsertUpdate_MIReport_byTable
 12.08.14                                        * add inBranchId :=
 05.08.14                                        * add UnitId_Item and ...
 25.05.14                                        * add lpComplete_Movement
 21.12.13                                        * Personal -> Member
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 03.10.13                                        * add inCarId := NULL
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 14.09.13                                        * add zc_ObjectLink_Goods_Business
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 26.08.13                                        * add zc_InfoMoneyDestination_WorkProgress
 11.08.13                                        * add inIsHistoryCost
 10.08.13                                        * � ��������� ��� ��������������� � ��������� �����: Master - ������, Child - ������ (�.�. ����� ��� �� ��� � ��� MovementItem)
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 24.07.13                                        * !�����������! ��������� ����
 21.07.13                                        * ! finich !
 20.07.13                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 143712, inSession:= '2')
-- SELECT * FROM lpComplete_Movement_ProductionUnion (inMovementId:= 143712, inIsHistoryCost:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 143712, inSession:= '2')
