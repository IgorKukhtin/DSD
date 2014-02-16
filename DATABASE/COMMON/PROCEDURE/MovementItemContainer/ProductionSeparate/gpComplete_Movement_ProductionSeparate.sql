-- Function: gpComplete_Movement_ProductionSeparate()

-- DROP FUNCTION gpComplete_Movement_ProductionSeparate (Integer, TVarChar);
-- DROP FUNCTION gpComplete_Movement_ProductionSeparate (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ProductionSeparate(
    IN inMovementId        Integer              , -- ���� ���������
    IN inIsLastComplete    Boolean DEFAULT False, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
-- RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId_From Integer, MemberId_From Integer, ContainerId_GoodsFrom Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime, OperCount TFloat, AccountDirectionId_From Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, isPartionCount Boolean, isPartionSumm Boolean, isPartionDate Boolean, PartionGoodsId Integer)
-- RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId_To Integer, MemberId_To Integer, BranchId_To Integer, ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime, OperCount TFloat, tmpOperSumm TFloat, AccountDirectionId_To Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, JuridicalId_basis_To Integer, BusinessId_To Integer, isPartionCount Boolean, isPartionSumm Boolean, isPartionDate Boolean, PartionGoodsId Integer)

-- RETURNS TABLE (MovementItemId Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat)
-- RETURNS TABLE (MovementItemId_Parent Integer, ContainerId_From Integer, MovementItemId Integer, MIContainerId_To Integer, ContainerId_To Integer, AccountId_To Integer, InfoMoneyId_Detail_To Integer, OperSumm TFloat)
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbTotalSummChild TFloat;
  DECLARE vbOperSumm TFloat;

  DECLARE vbOperDate TDateTime;
  DECLARE vbUnitId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbAccountDirectionId_From Integer;
  DECLARE vbIsPartionDate_Unit_From Boolean;
  DECLARE vbJuridicalId_Basis_From Integer;
  DECLARE vbBusinessId_From Integer;

  DECLARE vbUnitId_To Integer;
  DECLARE vbMemberId_To Integer;
  DECLARE vbBranchId_To Integer;
  DECLARE vbAccountDirectionId_To Integer;
  DECLARE vbIsPartionDate_Unit_To Boolean;
  DECLARE vbJuridicalId_Basis_To Integer;
  DECLARE vbBusinessId_To Integer;

BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Movement_Income());
     vbUserId:=2; -- CAST (inSession AS Integer);


     -- ��� ��������� ����� ��� ������������ �������� � ���������
     SELECT Movement.OperDate
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From
          , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_From -- ��������� ������ - ����������� !!!����� ������ ��� �������������!!!
          , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE) AS vbIsPartionDate_Unit_From
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
          , COALESCE (ObjectBoolean_PartionDate_To.ValueData, FALSE) AS vbIsPartionDate_Unit_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Juridical.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Business.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId_To

            INTO vbOperDate, vbUnitId_From, vbMemberId_From, vbAccountDirectionId_From, vbIsPartionDate_Unit_From, vbJuridicalId_Basis_From, vbBusinessId_From
               , vbUnitId_To, vbMemberId_To, vbBranchId_To, vbAccountDirectionId_To, vbIsPartionDate_Unit_To, vbJuridicalId_Basis_To, vbBusinessId_To
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                   ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                  AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                  AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                 ON MovementFloat_ChangePercent.MovementId = Movement.Id
                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                               ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_From
                                  ON ObjectBoolean_PartionDate_From.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_PartionDate_From.DescId = zc_ObjectBoolean_Unit_PartionDate()
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
       AND Movement.DescId = zc_Movement_ProductionSeparate()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- ������� - ��������� �������
     -- CREATE TEMP TABLE _tmpContainer (DescId Integer, ObjectId Integer) ON COMMIT DROP;
     -- ������� - ��������� <������� �/�>
     -- CREATE TEMP TABLE _tmpObjectCost (DescId Integer, ObjectId Integer) ON COMMIT DROP;
     -- ������� - ��������� <�������� ��� ������>
     CREATE TEMP TABLE _tmpChildReportContainer (AccountKindId Integer, ContainerId Integer, AccountId Integer) ON COMMIT DROP;
     -- ������� - 
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

     -- ������� - �������������� Master(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_GoodsFrom Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat
                               , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_From Integer
                               , isPartionCount Boolean, isPartionSumm Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;
     -- ������� - �������� Master(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat) ON COMMIT DROP;

     -- ������� - �������������� Child(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemChild (MovementItemId Integer
                                    , ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                                    , OperCount TFloat, tmpOperSumm TFloat
                                    , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                    , BusinessId_To Integer
                                    , isPartionCount Boolean, isPartionSumm Boolean
                                    , PartionGoodsId Integer) ON COMMIT DROP;
     -- ������� - �������� Child(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemSummChild (MovementItemId_Parent Integer, ContainerId_From Integer, MovementItemId Integer, MIContainerId_To Integer, ContainerId_To Integer, AccountId_To Integer, InfoMoneyId_Detail_To Integer, OperSumm TFloat) ON COMMIT DROP;
     -- ������� - ���������� �������� Child(������)-�������� ���������
     CREATE TEMP TABLE _tmpItemSummChildTotal (MovementItemId_Parent Integer, ContainerId_From Integer, OperSumm TFloat) ON COMMIT DROP;


     -- ��������� ������� - �������������� Child(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItemChild (MovementItemId
                              , ContainerId_GoodsTo, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                              , OperCount, tmpOperSumm
                              , InfoMoneyDestinationId, InfoMoneyId
                              , BusinessId_To
                              , isPartionCount, isPartionSumm
                              , PartionGoodsId)
        SELECT _tmp.MovementItemId

             , 0 AS ContainerId_GoodsTo
             , _tmp.GoodsId
             , _tmp.GoodsKindId
             , _tmp.AssetId
             , _tmp.PartionGoods
             , _tmp.PartionGoodsDate

             , _tmp.OperCount
             , _tmp.tmpOperSumm

               -- �������������� ����������
             , _tmp.InfoMoneyDestinationId
               -- ������ ����������
             , _tmp.InfoMoneyId

               -- �������� ������ !!!����������!!! �� ������ ��� ������������/����������
             , CASE WHEN _tmp.BusinessId_To = 0 THEN vbBusinessId_To ELSE _tmp.BusinessId_To END AS BusinessId_To

             , _tmp.isPartionCount
             , _tmp.isPartionSumm
               -- ������ ������, ���������� �����
             , 0 AS PartionGoodsId
        FROM 
             (SELECT MovementItem.Id AS MovementItemId

                   , MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , COALESCE (MovementString_PartionGoods.ValueData, '') AS PartionGoods
                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

                   , MovementItem.Amount AS OperCount
                   , COALESCE (MovementItem.Amount * lfObjectHistory_PriceListItem.ValuePrice, 0) AS tmpOperSumm

                    -- �������������� ����������
                  , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- ������ ����������
                  , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- ������ �� ������
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_To

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE) AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)  AS isPartionSumm

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                   LEFT JOIN MovementString AS MovementString_PartionGoods
                                            ON MovementString_PartionGoods.MovementId = MovementItem.MovementId
                                           AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

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

                   LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_ProductionSeparate(), inOperDate:= vbOperDate)
                          AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = MovementItem.ObjectId

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_ProductionSeparate()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp;


     -- ��������� ������� - �������������� Master(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_GoodsFrom, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount
                         , InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_From
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId)
        SELECT _tmp.MovementItemId

             , 0 AS ContainerId_GoodsFrom
             , _tmp.GoodsId
             , _tmp.GoodsKindId
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

             , _tmp.isPartionCount
             , _tmp.isPartionSumm
               -- ������ ������, ���������� �����
             , 0 AS PartionGoodsId
        FROM 
             (SELECT MovementItem.Id AS MovementItemId

                   , MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , COALESCE (MovementString_PartionGoods.ValueData, '') AS PartionGoods
                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

                   , MovementItem.Amount AS OperCount

                     -- �������������� ����������
                   , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                     -- ������ ����������
                   , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                     -- ������ �� ������
                   , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_From

                   , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)     AS isPartionCount
                   , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)      AS isPartionSumm

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                   LEFT JOIN MovementString AS MovementString_PartionGoods
                                            ON MovementString_PartionGoods.MovementId = MovementItem.MovementId
                                           AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

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
                AND Movement.DescId = zc_Movement_ProductionSeparate()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp;


     -- ����������� ������ ������ ��� Child(������)-��������, ���� ���� ...
     UPDATE _tmpItemChild SET PartionGoodsId = CASE WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                     AND vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- "������"; 20200; "�� �������"
                                                     AND (_tmpItemChild.isPartionCount OR _tmpItemChild.isPartionSumm)
                                                         THEN lpInsertFind_Object_PartionGoods (zfFormat_PartionGoods (_tmpItemChild.PartionGoods)) -- ������ �����, �.�. � ������ �������� �������
                                                    WHEN vbIsPartionDate_Unit_To
                                                     AND _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
                                                         THEN lpInsertFind_Object_PartionGoods (_tmpItemChild.PartionGoodsDate)
                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
     WHERE _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- "�������� �����"; 10100; "������ �����"
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
     ;
     -- ����������� ������ ������ ��� Master(������)-��������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                AND vbAccountDirectionId_From = zc_Enum_AccountDirection_20200() -- "������"; 20200; "�� �������"
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                    THEN lpInsertFind_Object_PartionGoods (zfFormat_PartionGoods (_tmpItem.PartionGoods)) -- ������ �����, �.�. � ������ �������� �������
                                               WHEN vbIsPartionDate_Unit_From
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
                                                    THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)
                                               ELSE lpInsertFind_Object_PartionGoods ('')
                                          END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- "�������� �����"; 10100; "������ �����"
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
     ;


     -- ��� ����� - Master
     -- RETURN QUERY SELECT _tmpItem.MovementItemId, inMovementId, vbOperDate, _tmpItem.UnitId_From, _tmpItem.MemberId_From, _tmpItem.ContainerId_GoodsFrom, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.AssetId, _tmpItem.PartionGoods, _tmpItem.PartionGoodsDate, _tmpItem.OperCount, _tmpItem.AccountDirectionId_From, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.isPartionCount, _tmpItem.isPartionSumm, _tmpItem.isPartionDate, _tmpItem.PartionGoodsId FROM _tmpItem;
     -- ��� ����� - Child
     -- RETURN QUERY SELECT _tmpItemChild.MovementItemId, inMovementId, vbOperDate, _tmpItemChild.UnitId_To, _tmpItemChild.MemberId_To, _tmpItemChild.BranchId_To, _tmpItemChild.ContainerId_GoodsTo, _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId, _tmpItemChild.AssetId, _tmpItemChild.PartionGoods, _tmpItemChild.PartionGoodsDate, _tmpItemChild.OperCount, _tmpItemChild.tmpOperSumm, _tmpItemChild.AccountDirectionId_To, _tmpItemChild.InfoMoneyDestinationId, _tmpItemChild.InfoMoneyId, _tmpItemChild.JuridicalId_basis_To, _tmpItemChild.BusinessId_To, _tmpItemChild.isPartionCount, _tmpItemChild.isPartionSumm, _tmpItemChild.isPartionDate, _tmpItemChild.PartionGoodsId FROM _tmpItemChild;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- ������������ ContainerId_GoodsFrom ��� Master(������)-�������� ��������������� �����
     UPDATE _tmpItem SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                    , inUnitId                 := vbUnitId_From
                                                                                    , inCarId                  := NULL
                                                                                    , inMemberId               := vbMemberId_From
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                    , inAssetId                := _tmpItem.AssetId
                                                                                     );

     -- ������������ ContainerId_GoodsTo ��� Child(������)-�������� ��������������� �����
     UPDATE _tmpItemChild SET ContainerId_GoodsTo = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                       , inUnitId                 := vbUnitId_To
                                                                                       , inCarId                  := NULL
                                                                                       , inMemberId               := vbMemberId_To
                                                                                       , inInfoMoneyDestinationId := _tmpItemChild.InfoMoneyDestinationId
                                                                                       , inGoodsId                := _tmpItemChild.GoodsId
                                                                                       , inGoodsKindId            := _tmpItemChild.GoodsKindId
                                                                                       , inIsPartionCount         := _tmpItemChild.isPartionCount
                                                                                       , inPartionGoodsId         := _tmpItemChild.PartionGoodsId
                                                                                       , inAssetId                := _tmpItemChild.AssetId
                                                                                        );


     -- ����� ����������: ��������� ������� - �������� Master(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_From, AccountId_From, InfoMoneyId_Detail_From, OperSumm)
        SELECT
              _tmpItem.MovementItemId
            , COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0)) AS ContainerId_From
            , COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) AS AccountId_From
            , COALESCE (ContainerLinkObject_InfoMoneyDetail.ObjectId, 0) AS InfoMoneyId_Detail_From
            , SUM (ABS (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0))) AS OperSumm
        FROM _tmpItem
             -- ��� ������� ��� ����
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItem.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis_From
                                                                                 AND lfContainerSumm_20901.BusinessId        = _tmpItem.BusinessId_From
                                                                                 AND _tmpItem.InfoMoneyDestinationId         = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
             -- ��� ������� ��� ���������
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_GoodsFrom
                                                  AND Container_Summ.DescId = zc_Container_Summ()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                           ON ContainerLinkObject_InfoMoneyDetail.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                          AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
             JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()
             LEFT JOIN HistoryCost ON HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND (ContainerLinkObject_InfoMoneyDetail.ObjectId = 0 OR zc_isHistoryCost_byInfoMoneyDetail()= TRUE)
          AND (inIsLastComplete = FALSE OR (_tmpItem.OperCount * HistoryCost.Price) <> 0) -- !!!�����������!!! ��������� ���� ���� ��� �� ��������� ��� (��� ����� ��� ������� �/�)
        GROUP BY _tmpItem.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId
               , ContainerLinkObject_InfoMoneyDetail.ObjectId
        ;

     -- !!!��������!!! - ������������ � Master(������)-�������� ���������
     IF EXISTS (SELECT MovementItemId, ContainerId_From FROM _tmpItemSumm GROUP BY MovementItemId, ContainerId_From HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION '������ � ���������.';
     END IF;


     -- ������ �������� ����� �� !!!������������!!! ������ ��� Child(������)-�������� ���������
     SELECT SUM (tmpOperSumm) INTO vbTotalSummChild FROM _tmpItemChild;

     -- ������������ ����� �� ����� �� Child-��������� ���������, � ��������� �� ��� ������� Master-�������� (�.�. ��������� ��� ProductionUnion)
     INSERT INTO _tmpItemSummChild (MovementItemId_Parent, ContainerId_From, MovementItemId, MIContainerId_To, ContainerId_To, AccountId_To, InfoMoneyId_Detail_To, OperSumm)
        SELECT _tmpItemSumm.MovementItemId
             , _tmpItemSumm.ContainerId_From
             , _tmpItemChild.MovementItemId
             , 0 AS MIContainerId_To
             , 0 AS ContainerId_To
             , 0 AS AccountId_To
             , _tmpItemSumm.InfoMoneyId_Detail_From
             , CASE WHEN vbTotalSummChild <> 0 THEN _tmpItemSumm.OperSumm * _tmpItemChild.tmpOperSumm / vbTotalSummChild ELSE 0 END
        FROM _tmpItemChild
             JOIN _tmpItemSumm ON 1 = 1 -- !!!������ ������� ������� ����� �������� � ������� �������� �������!!!
        ;

     -- ����� ������������� ���������� �������� ����� �� ����� ��� Child(������)-�������� ���������
     INSERT INTO _tmpItemSummChildTotal (MovementItemId_Parent, ContainerId_From, OperSumm)
        SELECT _tmpItemSummChild.MovementItemId_Parent, _tmpItemSummChild.ContainerId_From, SUM (_tmpItemSummChild.OperSumm) FROM _tmpItemSummChild GROUP BY _tmpItemSummChild.MovementItemId_Parent, _tmpItemSummChild.ContainerId_From;

     -- ���� �� ����� ��� �����, ������ !!!�����������!!! � ������� MovementItemId_Parent � ContainerId_From
     IF EXISTS (SELECT _tmpItemSumm.OperSumm
                FROM _tmpItemSumm
                     JOIN _tmpItemSummChildTotal ON _tmpItemSummChildTotal.MovementItemId_Parent = _tmpItemSumm.MovementItemId
                                                AND _tmpItemSummChildTotal.ContainerId_From      = _tmpItemSumm.ContainerId_From
                WHERE _tmpItemSumm.OperSumm <> _tmpItemSummChildTotal.OperSumm
               )
     THEN
         -- �� ������� ������������ �������� � ����� ������� ������ (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItemSummChild
            SET OperSumm = _tmpItemSummChild.OperSumm - _tmp_Total.SummDiff
         FROM (
               -- �������� ��� � ���� ���� ������� � � ������������� MovementItemId � ContainerId_From
               SELECT _tmp_Find.MovementItemId
                    , _tmpItemSummChildTotal.MovementItemId_Parent
                    , _tmpItemSummChildTotal.ContainerId_From
                    , (_tmpItemSummChildTotal.OperSumm - _tmpItemSumm.OperSumm) AS SummDiff
               FROM _tmpItemSumm
                    JOIN _tmpItemSummChildTotal ON _tmpItemSummChildTotal.MovementItemId_Parent = _tmpItemSumm.MovementItemId
                                               AND _tmpItemSummChildTotal.ContainerId_From      = _tmpItemSumm.ContainerId_From
                          -- �������� ������������ MovementItemId � ������� ������������ ���� � ContainerId_From
                    JOIN (SELECT MAX (_tmpItemSummChild.MovementItemId) AS MovementItemId, _tmpItemSummChild.MovementItemId_Parent, _tmpItemSummChild.ContainerId_From
                          FROM _tmpItemSummChild
                                      -- �������� ������������ ����� � ������� MovementItemId_Parent � ContainerId_From
                               JOIN (SELECT MAX (_tmpItemSummChild.OperSumm) AS OperSumm, _tmpItemSummChild.MovementItemId_Parent, _tmpItemSummChild.ContainerId_From
                                     FROM _tmpItemSummChild
                                     GROUP BY _tmpItemSummChild.MovementItemId_Parent, _tmpItemSummChild.ContainerId_From
                                    ) AS _tmp_MaxSumm ON _tmp_MaxSumm.MovementItemId_Parent = _tmpItemSummChild.MovementItemId_Parent
                                                     AND _tmp_MaxSumm.ContainerId_From      = _tmpItemSummChild.ContainerId_From
                                                     AND _tmp_MaxSumm.OperSumm              = _tmpItemSummChild.OperSumm
                          GROUP BY _tmpItemSummChild.MovementItemId_Parent, _tmpItemSummChild.ContainerId_From
                         ) AS _tmp_Find ON _tmp_Find.MovementItemId_Parent = _tmpItemSumm.MovementItemId
                                       AND _tmp_Find.ContainerId_From      = _tmpItemSumm.ContainerId_From
               WHERE _tmpItemSumm.OperSumm <> _tmpItemSummChildTotal.OperSumm
              ) AS _tmp_Total
         WHERE _tmpItemSummChild.MovementItemId        = _tmp_Total.MovementItemId
           AND _tmpItemSummChild.MovementItemId_Parent = _tmp_Total.MovementItemId_Parent
           AND _tmpItemSummChild.ContainerId_From      = _tmp_Total.ContainerId_From
        ;
     END IF;


     -- ��� ����� - Master - Summ
     -- RETURN QUERY SELECT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_From, _tmpItemSumm.InfoMoneyId_Detail_From, _tmpItemSumm.OperSumm FROM _tmpItemSumm;
     -- ��� ����� - Child - Summ
     -- RETURN QUERY SELECT _tmpItemSummChild.MovementItemId_Parent, _tmpItemSummChild.ContainerId_From, _tmpItemSummChild.MovementItemId, _tmpItemSummChild.MIContainerId_To, _tmpItemSummChild.ContainerId_To, _tmpItemSummChild.AccountId_To, _tmpItemSummChild.OperSumm FROM _tmpItemSummChild;


     -- ����������� �������� ��� ��������������� ����� - �� ����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, inMovementId, _tmpItem.MovementItemId, _tmpItem.ContainerId_GoodsFrom, 0 AS ParentId, -1 * _tmpItem.OperCount, vbOperDate, FALSE
       FROM _tmpItem;

     -- ����������� �������� ��� ��������������� ����� - ����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, inMovementId, _tmpItemChild.MovementItemId, _tmpItemChild.ContainerId_GoodsTo, 0 AS ParentId, _tmpItemChild.OperCount, vbOperDate, TRUE
       FROM _tmpItemChild;


     -- ������������ ����(�����������) ��� �������� �� ��������� ����� - ����
     UPDATE _tmpItemSummChild SET AccountId_To = _tmpItem_byAccount.AccountId
     FROM _tmpItemChild
          JOIN (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������ -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                  , inAccountDirectionId     := CASE WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                                                                                          THEN zc_Enum_AccountDirection_20900() -- 20900; "��������� ����"
                                                                                     WHEN vbMemberId_To <> 0
                                                                                      AND _tmpItem_group.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "�������� �����"; 10100; "������ �����"
                                                                                                                                  , zc_Enum_InfoMoneyDestination_20700() -- "�������������"; 20700; "������"
                                                                                                                                  , zc_Enum_InfoMoneyDestination_20900() -- "�������������"; 20900; "����"
                                                                                                                                  , zc_Enum_InfoMoneyDestination_21000() -- "�������������"; 21000; "�����"
                                                                                                                                  , zc_Enum_InfoMoneyDestination_21100() -- "�������������"; 21100; "�������"
                                                                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
                                                                                                                                   )
                                                                                          THEN 0 -- !!!�� ���� ��� ���������� �� ����� ���� �� �����!!!
                                                                                     ELSE vbAccountDirectionId_To
                                                                                END
                                                  , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := vbUserId
                                                   ) AS AccountId
                     , _tmpItem_group.InfoMoneyDestinationId
                FROM (SELECT _tmpItemChild.InfoMoneyDestinationId
                           , CASE WHEN GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_InfoMoneyDestination_WorkProgress() ELSE InfoMoneyDestinationId END AS InfoMoneyDestinationId_calc
                      FROM _tmpItemChild
                      WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
                      GROUP BY _tmpItemChild.InfoMoneyDestinationId
                             , CASE WHEN GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_InfoMoneyDestination_WorkProgress() ELSE InfoMoneyDestinationId END
                     ) AS _tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.InfoMoneyDestinationId = _tmpItemChild.InfoMoneyDestinationId
     WHERE _tmpItemSummChild.MovementItemId = _tmpItemChild.MovementItemId;

     -- ������������ ContainerId ��� �������� �� ��������� ����� - ����  + ����������� ��������� <������� �/�>
     UPDATE _tmpItemSummChild SET ContainerId_To = _tmpItem_byContainer.ContainerId
     FROM _tmpItemChild
          JOIN _tmpItemSummChild AS _tmpItemSummChild_find ON _tmpItemSummChild_find.MovementItemId = _tmpItemChild.MovementItemId
          JOIN (SELECT lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                         , inUnitId                 := vbUnitId_To
                                                         , inCarId                  := NULL
                                                         , inMemberId               := vbMemberId_To
                                                         , inBranchId               := vbBranchId_To
                                                         , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                         , inBusinessId             := _tmpItem_group.BusinessId_To
                                                         , inAccountId              := _tmpItem_group.AccountId_To
                                                         , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                         , inInfoMoneyId            := _tmpItem_group.InfoMoneyId
                                                         , inInfoMoneyId_Detail     := _tmpItem_group.InfoMoneyId_Detail_To
                                                         , inContainerId_Goods      := _tmpItem_group.ContainerId_GoodsTo
                                                         , inGoodsId                := _tmpItem_group.GoodsId
                                                         , inGoodsKindId            := _tmpItem_group.GoodsKindId
                                                         , inIsPartionSumm          := _tmpItem_group.isPartionSumm
                                                         , inPartionGoodsId         := _tmpItem_group.PartionGoodsId
                                                         , inAssetId                := _tmpItem_group.AssetId
                                                          ) AS ContainerId
                     , _tmpItem_group.BusinessId_To
                     , _tmpItem_group.AccountId_To
                     , _tmpItem_group.InfoMoneyDestinationId
                     , _tmpItem_group.InfoMoneyId
                     , _tmpItem_group.InfoMoneyId_Detail_To
                     , _tmpItem_group.ContainerId_GoodsTo
                     , _tmpItem_group.GoodsId
                     , _tmpItem_group.GoodsKindId
                     , _tmpItem_group.isPartionSumm
                     , _tmpItem_group.PartionGoodsId
                     , _tmpItem_group.AssetId
                FROM (SELECT _tmpItemChild.BusinessId_To
                           , _tmpItemSummChild.AccountId_To
                           , _tmpItemChild.InfoMoneyDestinationId
                           , _tmpItemChild.InfoMoneyId
                           , _tmpItemSummChild.InfoMoneyId_Detail_To
                           , _tmpItemChild.ContainerId_GoodsTo
                           , _tmpItemChild.GoodsId
                           , _tmpItemChild.GoodsKindId
                           , _tmpItemChild.isPartionSumm
                           , _tmpItemChild.PartionGoodsId
                           , _tmpItemChild.AssetId
                      FROM _tmpItemSummChild
                           JOIN _tmpItemChild ON _tmpItemChild.MovementItemId = _tmpItemSummChild.MovementItemId
                      GROUP BY _tmpItemChild.BusinessId_To
                             , _tmpItemSummChild.AccountId_To
                             , _tmpItemChild.InfoMoneyDestinationId
                             , _tmpItemChild.InfoMoneyId
                             , _tmpItemSummChild.InfoMoneyId_Detail_To
                             , _tmpItemChild.ContainerId_GoodsTo
                             , _tmpItemChild.GoodsId
                             , _tmpItemChild.GoodsKindId
                             , _tmpItemChild.isPartionSumm
                             , _tmpItemChild.PartionGoodsId
                             , _tmpItemChild.AssetId
                     ) AS _tmpItem_group
               ) AS _tmpItem_byContainer ON _tmpItem_byContainer.BusinessId_To          = _tmpItemChild.BusinessId_To
                                        AND _tmpItem_byContainer.AccountId_To           = _tmpItemSummChild_find.AccountId_To
                                        AND _tmpItem_byContainer.InfoMoneyDestinationId = _tmpItemChild.InfoMoneyDestinationId
                                        AND _tmpItem_byContainer.InfoMoneyId            = _tmpItemChild.InfoMoneyId
                                        AND _tmpItem_byContainer.InfoMoneyId_Detail_To  = _tmpItemSummChild_find.InfoMoneyId_Detail_To
                                        AND _tmpItem_byContainer.ContainerId_GoodsTo    = _tmpItemChild.ContainerId_GoodsTo
                                        AND _tmpItem_byContainer.GoodsId                = _tmpItemChild.GoodsId
                                        AND _tmpItem_byContainer.GoodsKindId            = _tmpItemChild.GoodsKindId
                                        AND _tmpItem_byContainer.isPartionSumm          = _tmpItemChild.isPartionSumm
                                        AND _tmpItem_byContainer.PartionGoodsId         = _tmpItemChild.PartionGoodsId
                                        AND _tmpItem_byContainer.AssetId                = _tmpItemChild.AssetId
     WHERE _tmpItemSummChild.MovementItemId = _tmpItemChild.MovementItemId;


     -- ����������� �������� ��� ��������� ����� - ���� + ������������ MIContainer.Id
     UPDATE _tmpItemSummChild SET MIContainerId_To =
             lpInsertUpdate_MovementItemContainer (ioId             := 0
                                                 , inDescId         := zc_MIContainer_Summ()
                                                 , inMovementId     := inMovementId
                                                 , inMovementItemId := _tmpItemChild.MovementItemId
                                                 , inParentId       := NULL
                                                 , inContainerId    := _tmpItemSummChild.ContainerId_To
                                                 , inAmount         := (OperSumm)
                                                 , inOperDate       := vbOperDate
                                                 , inIsActive       := TRUE
                                                  )
     FROM _tmpItemChild
     WHERE _tmpItemSummChild.MovementItemId = _tmpItemChild.MovementItemId;


     -- ����������� �������� ��� ��������� ����� - �� ����, ������ ��� !!!�������!! �������� ������� (������� � inAmount:= -1 * _tmpItemSummChild.OperSumm)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, _tmpItem.MovementItemId, _tmpItemSumm.ContainerId_From, _tmpItemSummChild.MIContainerId_To AS ParentId, -1 * _tmpItemSummChild.OperSumm, vbOperDate, FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
            JOIN _tmpItemSummChild ON _tmpItemSummChild.MovementItemId_Parent = _tmpItemSumm.MovementItemId
                                  AND _tmpItemSummChild.ContainerId_From = _tmpItemSumm.ContainerId_From
       ;


     -- ��� ����� - Child - Summ
     -- RETURN QUERY SELECT _tmpItemSummChild.MovementItemId_Parent, _tmpItemSummChild.ContainerId_From, _tmpItemSummChild.MovementItemId, _tmpItemSummChild.MIContainerId_To, _tmpItemSummChild.ContainerId_To, _tmpItemSummChild.AccountId_To, _tmpItemSummChild.OperSumm FROM _tmpItemSummChild;
     -- RETURN;

     -- ����������� �������� ��� ������ (���������: ����� ������ � ����� ������)
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId             := inMovementId
                                              , inMovementItemId         := _tmpItemSumm.MovementItemId
                                              , inActiveContainerId      := _tmpItemSummChild.ContainerId_To
                                              , inPassiveContainerId     := _tmpItemSumm.ContainerId_From
                                              , inActiveAccountId        := _tmpItemSummChild.AccountId_To
                                              , inPassiveAccountId       := _tmpItemSumm.AccountId_From
                                              , inReportContainerId      := _tmpItem_byReportContainer.ReportContainerId
                                              , inChildReportContainerId := _tmpItem_byReportContainer.ChildReportContainerId
                                              , inAmount                 := _tmpItemSummChild.OperSumm
                                              , inOperDate               := vbOperDate
                                               )
     FROM _tmpItem
          JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
          JOIN _tmpItemSummChild ON _tmpItemSummChild.MovementItemId_Parent = _tmpItemSumm.MovementItemId
                                AND _tmpItemSummChild.ContainerId_From      = _tmpItemSumm.ContainerId_From

          JOIN (SELECT lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem_group.ContainerId_To
                                                   , inPassiveContainerId := _tmpItem_group.ContainerId_From
                                                   , inActiveAccountId    := _tmpItem_group.AccountId_To
                                                   , inPassiveAccountId   := _tmpItem_group.AccountId_From
                                                    ) AS ReportContainerId
                     , lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem_group.ContainerId_To
                                                        , inPassiveContainerId := _tmpItem_group.ContainerId_From
                                                        , inActiveAccountId    := _tmpItem_group.AccountId_To
                                                        , inPassiveAccountId   := _tmpItem_group.AccountId_From
                                                        , inAccountKindId_1    := NULL
                                                        , inContainerId_1      := NULL
                                                        , inAccountId_1        := NULL
                                                         ) AS ChildReportContainerId
                     , _tmpItem_group.ContainerId_To
                     , _tmpItem_group.ContainerId_From
                     , _tmpItem_group.AccountId_To
                     , _tmpItem_group.AccountId_From
                FROM (SELECT _tmpItemSummChild.ContainerId_To
                           , _tmpItemSumm.ContainerId_From
                           , _tmpItemSummChild.AccountId_To
                           , _tmpItemSumm.AccountId_From
                      FROM _tmpItem
                           JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
                           JOIN _tmpItemSummChild ON _tmpItemSummChild.MovementItemId_Parent = _tmpItemSumm.MovementItemId
                                                 AND _tmpItemSummChild.ContainerId_From      = _tmpItemSumm.ContainerId_From
                      GROUP BY _tmpItemSummChild.ContainerId_To
                             , _tmpItemSumm.ContainerId_From
                             , _tmpItemSummChild.AccountId_To
                             , _tmpItemSumm.AccountId_From
                     ) AS _tmpItem_group
               ) AS _tmpItem_byReportContainer ON _tmpItem_byReportContainer.ContainerId_To   = _tmpItemSummChild.ContainerId_To
                                              AND _tmpItem_byReportContainer.ContainerId_From = _tmpItemSumm.ContainerId_From
                                              AND _tmpItem_byReportContainer.AccountId_To     = _tmpItemSummChild.AccountId_To
                                              AND _tmpItem_byReportContainer.AccountId_From   = _tmpItemSumm.AccountId_From
     ;


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ����� - ����������� ������ ������ ���������
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_ProductionSeparate() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.12.13                                        * Personal -> Member
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 03.10.13                                        * add inCarId := NULL
 25.09.13                                        * optimize
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 14.09.13                                        * add zc_ObjectLink_Goods_Business
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 26.08.13                                        * add zc_InfoMoneyDestination_WorkProgress
 11.08.13                                        * add inIsLastComplete
 10.08.13                                        * � ��������� !!!������!! ��� ��������� �����: Master - ������, Child - ������ (�.�. !!!��������!!! ��� � MovementItem ���� ���������� ��� ProductionUnion)
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 07.08.13                                        * add inParentId and inIsActive
 06.08.13                                        * err on vbOperSumm
 24.07.13                                        * !�����������! ��������� ����
 21.07.13                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 14101, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ProductionSeparate (inMovementId:= 14101, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 14101, inSession:= '2')
