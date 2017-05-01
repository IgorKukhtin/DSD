-- Function: lpComplete_Movement_Loss (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Loss (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Loss(
    IN inMovementId        Integer               , -- ���� ���������
    IN inUserId            Integer                 -- ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbWhereObjectId_Analyzer Integer;
  DECLARE vbObjectExtId_Analyzer Integer;
  DECLARE vbAnalyzerId Integer;

  DECLARE vbOperDate TDateTime;
  DECLARE vbUnitId Integer;
  DECLARE vbMemberId Integer;
  DECLARE vbBranchId_Unit Integer;
  DECLARE vbAccountDirectionId Integer;
  DECLARE vbIsPartionDate_Unit Boolean;
  DECLARE vbIsPartionGoodsKind_Unit Boolean;
  DECLARE vbInfoMoneyId_ArticleLoss Integer;
  DECLARE vbBranchId_Unit_ProfitLoss Integer;
  DECLARE vbProfitLossGroupId Integer;
  DECLARE vbProfitLossDirectionId Integer;
  DECLARE vbJuridicalId_Basis Integer;
  DECLARE vbBusinessId_ProfitLoss Integer;
  DECLARE vbUnitId_ProfitLoss Integer;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItemSumm;
     -- !!!�����������!!! �������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ��� ��������� ����� ��� ������������ �������� � ���������
     WITH tmpMember AS (SELECT lfSelect.MemberId, lfSelect.UnitId
                        FROM lfSelect_Object_Member_findPersonal (inUserId :: TVarChar) AS lfSelect
                        WHERE lfSelect.Ord = 1
                       )
     SELECT _tmp.MovementDescId, _tmp.OperDate
          , _tmp.UnitId, _tmp.MemberId, _tmp.BranchId_Unit, _tmp.AccountDirectionId, _tmp.isPartionDate_Unit, _tmp.isPartionGoodsKind_Unit
          , _tmp.InfoMoneyId_ArticleLoss, _tmp.BranchId_ProfitLoss
          , _tmp.ProfitLossGroupId, _tmp.ProfitLossDirectionId
          , _tmp.JuridicalId_Basis, _tmp.BusinessId_ProfitLoss, _tmp.UnitId_ProfitLoss
          , _tmp.ObjectExtId_Analyzer, _tmp.AnalyzerId
            INTO vbMovementDescId, vbOperDate
               , vbUnitId, vbMemberId, vbBranchId_Unit, vbAccountDirectionId, vbIsPartionDate_Unit, vbIsPartionGoodsKind_Unit
               , vbInfoMoneyId_ArticleLoss, vbBranchId_Unit_ProfitLoss
               , vbProfitLossGroupId, vbProfitLossDirectionId
               , vbJuridicalId_Basis, vbBusinessId_ProfitLoss, vbUnitId_ProfitLoss
               , vbObjectExtId_Analyzer, vbAnalyzerId

     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE 0 END, 0) AS UnitId
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id ELSE 0 END, 0) AS MemberId
                , COALESCE (ObjectLink_UnitFrom_Branch.ChildObjectId, 0) AS BranchId_Unit -- ��� ������ �� ������������ �� ���� (����� ��� �������� ��������)
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()
                                      THEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId
                                 WHEN Object_From.DescId = zc_Object_Member()
                                      THEN zc_Enum_AccountDirection_20500() -- ������ + ���������� (��)
                            END, 0) AS AccountDirectionId -- ��������� ������ - ����������� !!!����� ������ ��� �������������!!!
                , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE)     AS isPartionDate_Unit
                , COALESCE (ObjectBoolean_PartionGoodsKind_From.ValueData, TRUE) AS isPartionGoodsKind_Unit

                , COALESCE (ObjectLink_ArticleLoss_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_ArticleLoss
                , COALESCE (ObjectLink_Branch.ChildObjectId, 0)                AS BranchId_ProfitLoss -- �� ������������� (� ����,!!!���.����!!!, ����, �� ����)

                  -- ������ ���� (!!!��������� - ArticleLoss!!!)
                , COALESCE (View_ProfitLossDirection.ProfitLossGroupId, COALESCE (lfSelect.ProfitLossGroupId, 0)) AS ProfitLossGroupId
                  -- ��������� ���� - ����������� (!!!��������� - ArticleLoss!!!)
                , COALESCE (ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId, CASE WHEN COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, COALESCE (tmpMemberTo.UnitId, COALESCE (MovementLinkObject_To.ObjectId, COALESCE (MovementLinkObject_ArticleLoss.ObjectId, 0)))) = 0
                                                                                                THEN CASE /*WHEN Object_From.DescId = zc_Object_Member()
                                                                                                               THEN COALESCE (lfSelect.ProfitLossDirectionId, 0)*/ -- !!!����������!!!
                                                                                                          WHEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId IN (zc_Enum_AccountDirection_20100() -- ������ + �� ������� ��
                                                                                                                                                                    , zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                                                                                                                                    , zc_Enum_AccountDirection_20400() -- ������ + �� ������������
                                                                                                                                                                    , zc_Enum_AccountDirection_20800() -- ������ + �� ��������
                                                                                                                                                                     )
                                                                                                               THEN zc_Enum_ProfitLossDirection_20500() -- �������������������� ������� + ������ ������ (��������+��������������)
                                                                                                          WHEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId IN (zc_Enum_AccountDirection_20700() -- ������ + �� ��������
                                                                                                                                                                     )
                                                                                                               THEN zc_Enum_ProfitLossDirection_40400() -- ������� �� ���� + ������ ������ (��������+��������������)
                                                                                                          ELSE 0 -- !!!����� ������!!!
                                                                                                     END
                                                                                           ELSE COALESCE (lfSelect.ProfitLossDirectionId, 0)
                                                                                      END) AS ProfitLossDirectionId

                , COALESCE (ObjectLink_UnitFrom_Juridical.ChildObjectId, zc_Juridical_Basis()) AS JuridicalId_Basis
                , COALESCE (ObjectLink_Business.ChildObjectId, 0)                              AS BusinessId_ProfitLoss -- �� ������������� (� ����,!!!���.����!!!, ����, �� ����)
                , COALESCE (MovementLinkObject_ArticleLoss.ObjectId, lfSelect.UnitId)          AS UnitId_ProfitLoss
                , MovementLinkObject_To.ObjectId          AS ObjectExtId_Analyzer
                , MovementLinkObject_ArticleLoss.ObjectId AS AnalyzerId
           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                            -- AND MovementLinkObject_To.ObjectId <> MovementLinkObject_From.ObjectId -- ��� � ���������� �������� - ������ ������ (��������+��������������)
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                             ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                            AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
                LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_InfoMoney
                                     ON ObjectLink_ArticleLoss_InfoMoney.ObjectId = MovementLinkObject_ArticleLoss.ObjectId
                                    AND ObjectLink_ArticleLoss_InfoMoney.DescId = zc_ObjectLink_ArticleLoss_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                                     ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = MovementLinkObject_ArticleLoss.ObjectId
                                    AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
                LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                     ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_From
                                        ON ObjectBoolean_PartionDate_From.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectBoolean_PartionDate_From.DescId = zc_ObjectBoolean_Unit_PartionDate()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind_From
                                        ON ObjectBoolean_PartionGoodsKind_From.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectBoolean_PartionGoodsKind_From.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()

                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                     ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Juridical
                                     ON ObjectLink_UnitFrom_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

                LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Unit
                                     ON ObjectLink_PersonalTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_PersonalTo_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                    AND Object_To.DescId = zc_Object_Personal()
                LEFT JOIN ObjectLink AS ObjectLink_CarTo_Unit
                                     ON ObjectLink_CarTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_CarTo_Unit.DescId = zc_ObjectLink_Car_Unit()
                                    AND Object_To.DescId = zc_Object_Car()
                LEFT JOIN tmpMember AS tmpMemberTo ON tmpMemberTo.MemberId = MovementLinkObject_To.ObjectId
                                                  AND Object_To.DescId = zc_Object_Member()

                LEFT JOIN tmpMember AS tmpMemberFrom ON tmpMemberFrom.MemberId = MovementLinkObject_From.ObjectId
                                                    AND Object_From.DescId = zc_Object_Member()

                LEFT JOIN ObjectLink AS ObjectLink_Branch
                                     ON ObjectLink_Branch.ObjectId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, COALESCE (ObjectLink_PersonalTo_Unit.ChildObjectId, COALESCE (tmpMemberTo.UnitId, COALESCE (MovementLinkObject_To.ObjectId, COALESCE (tmpMemberFrom.UnitId, MovementLinkObject_From.ObjectId)))))
                                    AND ObjectLink_Branch.DescId = zc_ObjectLink_Unit_Branch()
                LEFT JOIN ObjectLink AS ObjectLink_Business
                                     ON ObjectLink_Business.ObjectId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, COALESCE (ObjectLink_PersonalTo_Unit.ChildObjectId, COALESCE (tmpMemberTo.UnitId, COALESCE (MovementLinkObject_To.ObjectId, COALESCE (tmpMemberFrom.UnitId, MovementLinkObject_From.ObjectId)))))
                                    AND ObjectLink_Business.DescId = zc_ObjectLink_Unit_Business()
                -- ��� ������ (!!!���� �� ������ ArticleLoss!!!)
                LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfSelect
                       ON lfSelect.UnitId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, COALESCE (ObjectLink_PersonalTo_Unit.ChildObjectId, COALESCE (tmpMemberTo.UnitId, COALESCE (MovementLinkObject_To.ObjectId, COALESCE (tmpMemberFrom.UnitId, MovementLinkObject_From.ObjectId)))))
                      AND MovementLinkObject_ArticleLoss.ObjectId IS NULL

           WHERE Movement.Id = inMovementId
             AND Movement.DescId = zc_Movement_Loss()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmp;



     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate, PartionGoodsId_Item
                         , OperCount
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId)
        SELECT
              _tmp.MovementItemId
            , 0 AS ContainerId_Goods         -- ���������� �����
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , 0 AS AssetId -- _tmp.AssetId -- !!!�������� ��������, �.�. �� ������ ����������� � ������!!!
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate
            , _tmp.PartionGoodsId_Item

            , _tmp.OperCount

            , _tmp.InfoMoneyGroupId       -- �������������� ������
            , _tmp.InfoMoneyDestinationId -- �������������� ����������
            , _tmp.InfoMoneyId            -- ������ ����������

              -- ������ �������: �� ������������
            , _tmp.BusinessId 

            , _tmp.isPartionCount
            , _tmp.isPartionSumm 

            , 0 AS PartionGoodsId -- ������ ������, ���������� �����

        FROM (SELECT
                     MovementItem.Id AS MovementItemId

                   , MovementItem.ObjectId AS GoodsId
                   , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ���������
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                           AND vbIsPartionGoodsKind_Unit = TRUE
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          ELSE 0
                     END AS GoodsKindId
                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate
                   , COALESCE (MILinkObject_PartionGoods.ObjectId, 0) AS PartionGoodsId_Item

                   , MovementItem.Amount AS OperCount

                    -- �������������� ������
                  , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
                    -- �������������� ����������
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- ������ ����������
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                     -- ������ �������: �� ������������
                   , 0 AS BusinessId

                   , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE) AS isPartionCount
                   , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)  AS isPartionSumm

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                    ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()

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
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

              WHERE Movement.Id = inMovementId
                AND Movement.StatusId = zc_Enum_Status_UnComplete()
             ) AS _tmp
        ;

     -- ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId      = CASE WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                     AND vbAccountDirectionId = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN vbIsPartionDate_Unit = TRUE
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)
                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                                        THEN 0

                                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                        THEN _tmpItem.PartionGoodsId_Item

                                                    ELSE lpInsertFind_Object_PartionGoods ('')

                                               END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
     ;

     -- ����������
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId WHEN vbMemberId <> 0 THEN vbMemberId END;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1.1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_Unit
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 );


     -- 1.2.1. ����� ����������: ��������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_ProfitLoss, ContainerId, AccountId, OperSumm)
        SELECT
              _tmpItem.MovementItemId
            , 0 AS ContainerId_ProfitLoss
            , COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0))     AS ContainerId
            , COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) AS AccountId
            , SUM (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                 + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                             THEN HistoryCost.Summ_diff -- !!!���� ���� "�����������" ��� ����������, �������� �����!!!
                        ELSE 0
                   END) AS OperSumm
        FROM _tmpItem
             -- ��� ������� ��� ����
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItem.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis
                                                                                 -- AND lfContainerSumm_20901.BusinessId        = _tmpItem.BusinessId -- !!!���� �� ������� � ���������� �� �������!!!
                                                                                 AND _tmpItem.InfoMoneyDestinationId         = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
             -- ��� ������� ��� ���������
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId = zc_Container_Summ()
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND _tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) <> 0 -- ����� ���� !!!�� �����!!! 
        GROUP BY _tmpItem.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId;


     -- 2.1.1. ������� ���������� ��� �������� - �������
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss = _tmpItem_byDestination.ContainerId_ProfitLoss -- ���� - �������
     FROM _tmpItem
          JOIN
          (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId_ProfitLoss -- !!!����������� ������ ��� �������!!!
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_Unit_ProfitLoss

                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                  THEN CASE WHEN _tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- ���������������� ������������
                                                     -- !!!...!!!
                                                THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60201) -- ����������� + ���������������� �� + �������� ��������*****
                                                -- !!!...!!!
                                           ELSE (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60101) -- ����������� + ���������������� �� + �������� ��������*****
                                      END
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := vbProfitLossGroupId
                                                                , inProfitLossDirectionId  := vbProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId

                      , _tmpItem_group.InfoMoneyDestinationId
                 FROM (SELECT _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.InfoMoneyId
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.InfoMoneyId
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN vbInfoMoneyId_ArticleLoss > 0
                                               THEN (SELECT InfoMoneyDestinationId FROM Object_InfoMoney_View WHERE InfoMoneyId = vbInfoMoneyId_ArticleLoss) -- !!!������ �� ������� �� ������!!!

                                          WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                            OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                            OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                            OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������

                                          WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������

                                          ELSE _tmpItem.InfoMoneyDestinationId

                                     END AS InfoMoneyDestinationId_calc
                             FROM _tmpItemSumm
                                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.InfoMoneyId
                                    , _tmpItem.GoodsKindId
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.InfoMoneyId
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 2.1.2. �������� ���������� ��� �������� - ������� ������ ���� ����
     IF EXISTS (SELECT 1 FROM (SELECT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm GROUP BY _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_ProfitLoss) AS tmp GROUP BY tmp.MovementItemId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION '������. COUNT > 1 by ContainerId_ProfitLoss';
     END IF;

     -- 2.2. ����������� �������� - �������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm_group.MovementItemId
            , _tmpItemSumm_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId              -- ������� �������� �������
            , vbAnalyzerId                            AS AnalyzerId             -- ���� ���������: ������ ��������
            , _tmpItemSumm_group.GoodsId              AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer   -- � ���� �� �����
            , _tmpItemSumm_group.GoodsKindId          AS ObjectIntId_Analyzer   -- ��� ������
            , CASE WHEN vbUnitId_ProfitLoss <> 0 THEN vbUnitId_ProfitLoss ELSE vbObjectExtId_Analyzer END AS ObjectExtId_Analyzer   -- !!!������!!! ����� - ������������ ���� ���...
            , 0                                       AS ParentId
            , _tmpItemSumm_group.OperSumm
            , vbOperDate
            , FALSE
       FROM (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_ProfitLoss
                  , _tmpItem.GoodsId
                  , _tmpItem.GoodsKindId
                  , SUM (_tmpItemSumm.OperSumm) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.MovementItemId
                    , _tmpItemSumm.ContainerId_ProfitLoss
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
            ) AS _tmpItemSumm_group;


     -- 1.1.2. ����������� �������� ��� ��������������� �����, !!!����� �������, �.�. ����� ContainerId_ProfitLoss!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId --, ParentId, Amount, OperDate, IsActive)
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS AccountId              -- ��� �����
            , vbAnalyzerId                            AS AnalyzerId             -- ���� ���������: ������ ��������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , tmpProfitLoss.ContainerId_ProfitLoss    AS ContainerId_Analyzer   -- ��������� ���� - ������ ����
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ������������ ���� ���...
            , 0                                       AS ParentId
            , -1 * _tmpItem.OperCount
            , vbOperDate
            , FALSE
       FROM _tmpItem
            LEFT JOIN (SELECT DISTINCT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm
                      ) AS tmpProfitLoss ON tmpProfitLoss.MovementItemId = _tmpItem.MovementItemId
       ;
     -- 1.2.2. ����������� �������� ��� ��������� �����, !!!����� �������, �.�. ����� ContainerId_ProfitLoss!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId
            , _tmpItemSumm.ContainerId
            , _tmpItemSumm.AccountId                  AS AccountId              -- ���� ���� ������
            , vbAnalyzerId                            AS AnalyzerId             -- ���� ���������: ������ ��������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , _tmpItemSumm.ContainerId_ProfitLoss     AS ContainerId_Analyzer   -- ��������� ���� - ������ ����
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ������������ ���� ���...
            , 0                                       AS ParentId
            , -1 * _tmpItemSumm.OperSumm
            , vbOperDate
            , FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;




     -- �����, �.�. ��-�� ������� ������ � ����
     DELETE FROM MovementItemLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementItemId IN (SELECT MovementItemId FROM _tmpItem);
     -- !!!6.0. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     /*PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, vbBranchId_Unit_ProfitLoss)
     FROM (SELECT _tmpItem.MovementItemId
           FROM _tmpItem
          ) AS tmp;*/

     -- 6.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();


     -- 6.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Loss()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.10.14                                        * all
 07.09.14                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Loss (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
