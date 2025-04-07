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

  DECLARE vbOperDate      TDateTime;
  DECLARE vbUnitId        Integer;
  DECLARE vbMemberId      Integer;
  DECLARE vbCarId         Integer;
  DECLARE vbToId          Integer;
  DECLARE vbArticleLossId Integer;
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

  DECLARE vbContractId_send Integer;
  DECLARE vbJuridicalId_send Integer;
  DECLARE vbPaidKindId_send Integer;
  DECLARE vbJuridicalId_Basis_send Integer;
  DECLARE vbContainerId_send Integer;
  DECLARE vbAccountId_Send Integer;
  DECLARE vbInfoMoneyId_send Integer;

  DECLARE vbIsContainer_Asset Boolean;
  DECLARE vbIsPartionCell_from Boolean;
BEGIN

-- if inUserId = zc_Enum_Process_Auto_PrimeCost() :: Integer then return; end if;


     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItemSumm;
     -- !!!�����������!!! �������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

     -- ��� ��������� ����� ��� ������������ �������� � ���������
     WITH tmpMember AS (SELECT lfSelect.MemberId, lfSelect.UnitId
                        FROM lfSelect_Object_Member_findPersonal (lfGet_User_Session (inUserId)) AS lfSelect
                        WHERE lfSelect.Ord = 1
                       )
     SELECT _tmp.MovementDescId, _tmp.OperDate
          , _tmp.UnitId, _tmp.MemberId, _tmp.CarId, _tmp.ToId, _tmp.ArticleLossId
          , _tmp.BranchId_Unit, _tmp.AccountDirectionId, _tmp.isPartionDate_Unit, _tmp.isPartionGoodsKind_Unit
          , _tmp.InfoMoneyId_ArticleLoss, _tmp.BranchId_ProfitLoss
          , _tmp.ProfitLossGroupId, _tmp.ProfitLossDirectionId
          , _tmp.JuridicalId_Basis, _tmp.BusinessId_ProfitLoss, _tmp.UnitId_ProfitLoss
          , _tmp.ObjectExtId_Analyzer, _tmp.AnalyzerId
          , _tmp.ContractId_send , _tmp.JuridicalId_send , _tmp.InfoMoneyId_send, _tmp.PaidKindId_send , _tmp.JuridicalId_Basis_send
            INTO vbMovementDescId, vbOperDate
               , vbUnitId, vbMemberId, vbCarId, vbToId, vbArticleLossId
               , vbBranchId_Unit, vbAccountDirectionId, vbIsPartionDate_Unit, vbIsPartionGoodsKind_Unit
               , vbInfoMoneyId_ArticleLoss, vbBranchId_Unit_ProfitLoss
               , vbProfitLossGroupId, vbProfitLossDirectionId
               , vbJuridicalId_Basis, vbBusinessId_ProfitLoss, vbUnitId_ProfitLoss
               , vbObjectExtId_Analyzer, vbAnalyzerId

               , vbContractId_send, vbJuridicalId_send, vbInfoMoneyId_send, vbPaidKindId_send, vbJuridicalId_Basis_send

     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()   THEN Object_From.Id ELSE 0 END, 0) AS UnitId
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id ELSE 0 END, 0) AS MemberId
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Car()    THEN Object_From.Id ELSE 0 END, 0) AS CarId
                , COALESCE (Object_To.Id, MovementLinkObject_ArticleLoss.ObjectId)                               AS ToId
                , MovementLinkObject_ArticleLoss.ObjectId                                                        AS ArticleLossId
                , COALESCE (ObjectLink_UnitFrom_Branch.ChildObjectId, 0) AS BranchId_Unit -- ��� ������ �� ������������ �� ���� (����� ��� �������� ��������)
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()
                                      THEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId
                                 WHEN Object_From.DescId = zc_Object_Member()
                                      THEN zc_Enum_AccountDirection_20500() -- ������ + ���������� (��)
                            END, 0) AS AccountDirectionId -- ��������� ������ - ����������� !!!����� ������ ��� �������������!!!
                , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE)     AS isPartionDate_Unit
                , COALESCE (ObjectBoolean_PartionGoodsKind_From.ValueData, TRUE) AS isPartionGoodsKind_Unit

                , COALESCE (ObjectLink_ArticleLoss_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_ArticleLoss
                  -- �� ArticleLoss OR ������������� (� ����,!!!���.����!!!, ����, �� ����)
                , COALESCE (ObjectLink_ArticleLoss_Branch.ChildObjectId, ObjectLink_Branch.ChildObjectId, 0) AS BranchId_ProfitLoss

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
                  -- �� ������������� (� ����,!!!���.����!!!, ����, �� ����)
                , COALESCE (ObjectLink_ArticleLoss_Business.ChildObjectId, ObjectLink_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss
                  --
                , COALESCE (MovementLinkObject_ArticleLoss.ObjectId, lfSelect.UnitId)          AS UnitId_ProfitLoss
                  -- ������������ ���� ��� ��.���� - ���������������
                , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId) AS ObjectExtId_Analyzer
                , MovementLinkObject_ArticleLoss.ObjectId AS AnalyzerId

                , COALESCE (ObjectLink_Unit_Contract.ChildObjectId, 0)           AS ContractId_send
                , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, 0)      AS JuridicalId_send
                , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0)      AS InfoMoneyId_send
                , COALESCE (ObjectLink_Contract_PaidKind.ChildObjectId, 0)       AS PaidKindId_send
                , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis_send

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
                LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_Business
                                     ON ObjectLink_ArticleLoss_Business.ObjectId = MovementLinkObject_ArticleLoss.ObjectId
                                    AND ObjectLink_ArticleLoss_Business.DescId   = zc_ObjectLink_ArticleLoss_Business()
                LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_Branch
                                     ON ObjectLink_ArticleLoss_Branch.ObjectId = MovementLinkObject_ArticleLoss.ObjectId
                                    AND ObjectLink_ArticleLoss_Branch.DescId   = zc_ObjectLink_ArticleLoss_Branch()
                -- ��� ������ (!!!���� �� ������ ArticleLoss!!!)
                LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfSelect
                       ON lfSelect.UnitId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, COALESCE (ObjectLink_PersonalTo_Unit.ChildObjectId, COALESCE (tmpMemberTo.UnitId, COALESCE (MovementLinkObject_To.ObjectId, COALESCE (tmpMemberFrom.UnitId, MovementLinkObject_From.ObjectId)))))
                      AND MovementLinkObject_ArticleLoss.ObjectId IS NULL
                -- ��� ��������������� ������ �� �� ���� (!!!���� ���� ������ ArticleLoss!!!)
                LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, COALESCE (ObjectLink_PersonalTo_Unit.ChildObjectId, COALESCE (tmpMemberTo.UnitId, COALESCE (MovementLinkObject_To.ObjectId, COALESCE (tmpMemberFrom.UnitId, MovementLinkObject_From.ObjectId)))))
                                                                AND ObjectLink_Unit_Contract.DescId   = zc_ObjectLink_Unit_Contract()
                LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney ON ObjectLink_Contract_InfoMoney.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                     AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                     AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                    AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                          AND ObjectLink_Contract_JuridicalBasis.DescId   = zc_ObjectLink_Contract_JuridicalBasis()

           WHERE Movement.Id = inMovementId
             AND Movement.DescId IN (zc_Movement_Loss(), zc_Movement_LossAsset())
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmp;


     -- ���� ���� �� ������� - ������
     IF (vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
        AND zc_Unit_RK() = vbUnitId
        )
     THEN
         -- ���� ����� ��� �� ����
         vbIsPartionCell_from:= TRUE;
     ELSE 
         vbIsPartionCell_from:= FALSE;
     END IF;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, ContainerId_Count, ContainerId_asset, ObjectDescId, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate, PartionGoodsId_Item
                         , OperCount, OperCountCount, Summ_service
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId, isAsset
                         , OperCount_start
                          )
        WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                            , MovementItem.ObjectId AS GoodsId
                            , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ���������
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                                    AND vbIsPartionGoodsKind_Unit = TRUE
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                   ELSE 0
                              END AS GoodsKindId
                            , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_complete
                            , CASE WHEN vbMovementDescId = zc_Movement_LossAsset() AND Object_Goods.DescId = zc_Object_Asset() THEN Object_Goods.Id ELSE COALESCE (MILinkObject_Asset.ObjectId, 0) END AS AssetId
                            , COALESCE (MIString_PartionGoods.ValueData, '')         AS PartionGoods
                            , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

                            , COALESCE (MIFloat_ContainerId.ValueData, 0) :: Integer AS ContainerId_asset
                            , COALESCE (CLO_PartionGoods.ObjectId, 0)                AS PartionGoodsId_asset
                            , COALESCE (MILinkObject_PartionGoods.ObjectId, 0)       AS PartionGoodsId_mi

                            , MovementItem.Amount                   AS OperCount
                            , COALESCE (MIFloat_Count.ValueData, 0) AS OperCountCount
                            , MIFloat_Summ.ValueData                AS Summ_service

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

                            , COALESCE (ObjectBoolean_Asset.ValueData, FALSE) AS isAsset

                       FROM Movement
                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                             ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
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

                             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                         ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Count.DescId         = zc_MIFloat_Count()
                             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                         ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Summ.DescId         = zc_MIFloat_Summ()
                                                        AND vbMovementDescId                   = zc_Movement_LossAsset()
                             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                         ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                        AND vbMovementDescId                   = zc_Movement_LossAsset()
                             LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                           ON CLO_PartionGoods.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()

                            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                                    ON ObjectBoolean_PartionCount.ObjectId = MovementItem.ObjectId
                                                   AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                                    ON ObjectBoolean_PartionSumm.ObjectId = MovementItem.ObjectId
                                                   AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()
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

                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Asset
                                                     ON ObjectBoolean_Asset.ObjectId = MovementItem.ObjectId
                                                    AND ObjectBoolean_Asset.DescId   = zc_ObjectBoolean_Goods_Asset()

                       WHERE Movement.Id = inMovementId
                         AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                      )
, tmpContainer_asset AS (SELECT tmpMI.ContainerId_asset
                                -- ���� �� ������ ������ - ����������� ���������� + ���������������� ������������
                              , COALESCE (CLO_InfoMoney.ObjectId, zc_Enum_InfoMoney_70102()) AS InfoMoneyId
                              , ROW_NUMBER()     OVER (PARTITION BY tmpMI.ContainerId_asset ORDER BY CLO_InfoMoney.ObjectId ASC) AS Ord -- !!!�� ������ ������!!!
                         FROM tmpMI
                              LEFT JOIN Container ON Container.ParentId = tmpMI.ContainerId_asset
                                                 AND Container.DescId   IN (zc_Container_Summ(), zc_Container_SummAsset())
                              LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                            ON CLO_InfoMoney.ContainerId = Container.Id
                                                           AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                         WHERE tmpMI.ContainerId_asset > 0
                        )
   -- ������� ������ ��� ����� �������
 , tmpMI_summ AS (SELECT tmpMI.GoodsId, 0 AS GoodsKindId, tmpMI.PartionGoods, SUM (tmpMI.OperCount) AS OperCount
                       , FALSE AS is_30100
                  FROM tmpMI
                  WHERE -- ������ �� ����������� ��
                        tmpMI.ContainerId_asset = 0
                        -- ���� ������ �� ���� ������� = ��� �� ����������
                    AND tmpMI.PartionGoodsId_mi = 0
                        -- ������ �� ����
                    AND tmpMI.InfoMoneyId <> zc_Enum_InfoMoney_20103() -- �������� � ������� + ����
                        -- ������ ��� �� ������ - ���� - �� �������
                    AND (tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                        , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                        , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                         )
                      -- ��� ����� ����� - ������ ��
                      OR tmpMI.isAsset = TRUE
                        )
                  GROUP BY tmpMI.GoodsId, tmpMI.PartionGoods

                 UNION ALL
                  -- !!! ���� - ������ �� ����� + ������
                  SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, '' AS PartionGoods, SUM (tmpMI.OperCount) AS OperCount
                       , TRUE AS is_30100
                  FROM tmpMI
                  WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                       , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                        )
                        --!!!
                    AND vbIsPartionCell_from = TRUE
                  GROUP BY tmpMI.GoodsId, tmpMI.GoodsKindId
                 )
               -- !!! - 01 - �� ������� ��� �������������
              , tmp_01 AS (-- 1. ��� zc_ContainerLinkObject_Unit
                           SELECT tmpMI.GoodsId                                         AS GoodsId
                                , 0                                                     AS GoodsKindId
                                , Container.Id                                          AS ContainerId
                                , Container.Amount                                      AS Amount
                                , COALESCE (CLO_PartionGoods.ObjectId, 0)               AS PartionGoodsId
                                , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                                , COALESCE (Object_PartionGoods.ValueData, '')          AS PartionGoods
                           FROM tmpMI_summ AS tmpMI
                                INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                    AND Container.DescId   IN (zc_Container_Count(), zc_Container_CountAsset())
                                                  -- ��� �����������
                                                  --AND Container.Amount   > 0
                                LEFT JOIN ContainerLinkObject AS CLO_Member
                                                              ON CLO_Member.ContainerId = Container.Id
                                                             AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = Container.Id
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                               ON CLO_PartionGoods.ContainerId = Container.Id
                                                              AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                        AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                                                                       AND Object_PartionGoods.ValueData <> '0'
                           WHERE vbIsPartionCell_from = FALSE
                             AND ((CLO_Unit.ObjectId   = vbUnitId   AND vbUnitId    > 0)
                               OR (CLO_Member.ObjectId = vbMemberId AND vbMemberId  > 0)
                                 )
                          )
               -- !!! - 02 - ���� ��� �� - ������ �� ����� + ������
             , tmp_02 AS (SELECT DISTINCT Container.Id               AS ContainerId
                                        , tmpMI.GoodsId              AS GoodsId
                                        , tmpMI.GoodsKindId          AS GoodsKindId
                                        , CLO_PartionGoods.ObjectId  AS PartionGoodsId
                                        , CASE WHEN ObjectLink_PartionCell.ChildObjectId = zc_PartionCell_RK()
                                               -- ���� zc_PartionCell_RK, ��������� ������ - ������
                                               THEN zc_DateStart()
                                               ELSE COALESCE (ObjectDate_Value.ValueData, zc_DateStart())
                                          END AS PartionGoodsDate
                                        , Container.Amount           AS Amount
                          FROM tmpMI_summ AS tmpMI
                               INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.DescId   = zc_Container_Count()
                                                   -- ���� �����������
                                                   AND Container.Amount   > 0
                               INNER JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = Container.Id
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                             AND CLO_Unit.ObjectId    = vbUnitId
                               -- !!!
                               LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                             ON CLO_GoodsKind.ContainerId = Container.Id
                                                            AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                             ON CLO_PartionGoods.ContainerId = Container.Id
                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                               LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                       AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                               -- ���� zc_PartionCell_RK, ��������� ������ - ������
                               LEFT JOIN ObjectLink AS ObjectLink_PartionCell ON ObjectLink_PartionCell.ObjectId = CLO_PartionGoods.ObjectId
                                                                             AND ObjectLink_PartionCell.DescId   = zc_ObjectLink_PartionGoods_PartionCell()
                          WHERE vbIsPartionCell_from = TRUE
                            -- �� �����
                            AND COALESCE (CLO_GoodsKind.ObjectId, 0) = tmpMI.GoodsKindId
                            --!!! �� ������ �������� ������ �� ���������� �������
                            AND (COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
                              OR CLO_PartionGoods.ContainerId IS NULL
                                )
                            --!!!�� ������ ������!!!
                            AND COALESCE (CLO_PartionGoods.ObjectId, -1) NOT IN (80132, 0)
                         )
               -- !!! - 03 - ���� ��� �� - ������ �� ����� + ������
             , tmp_03 AS (SELECT DISTINCT Container.Id               AS ContainerId
                                        , tmpMI.GoodsId              AS GoodsId
                                        , tmpMI.GoodsKindId          AS GoodsKindId
                                        , CLO_PartionGoods.ObjectId  AS PartionGoodsId
                                        , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                                        , Container.Amount           AS Amount
                                          -- !!!���� �������� ����!!!
                                       , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY Container.Id) AS Ord
                          FROM tmpMI_summ AS tmpMI
                               -- !!!
                               LEFT JOIN tmp_02 ON tmp_02.GoodsId     = tmpMI.GoodsId
                                               AND tmp_02.GoodsKindId = tmpMI.GoodsKindId
                               INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.DescId   = zc_Container_Count()
                                                   -- ������ ��� 0 ���� �� ����� > 0
                                                   AND Container.Amount   <= 0
                               INNER JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = Container.Id
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                             AND CLO_Unit.ObjectId    = vbUnitId
                               -- !!!
                               LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                             ON CLO_GoodsKind.ContainerId = Container.Id
                                                            AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                             ON CLO_PartionGoods.ContainerId = Container.Id
                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                               LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                       AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                               -- ���� zc_PartionCell_RK, �� ��������� ������ ����� ������
                               LEFT JOIN ObjectLink AS ObjectLink_PartionCell ON ObjectLink_PartionCell.ObjectId      = CLO_PartionGoods.ObjectId
                                                                             AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                                                                             AND ObjectLink_PartionCell.ChildObjectId = zc_PartionCell_RK()

                          WHERE vbIsPartionCell_from = TRUE
                            AND COALESCE (CLO_GoodsKind.ObjectId, 0) = tmpMI.GoodsKindId
                            --!!!
                            AND tmp_02.GoodsId IS NULL
                            --!!! �� ������ �������� ������ �� ���������� �������
                            AND (COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
                              OR CLO_PartionGoods.ContainerId IS NULL
                                )
                            --!!!�� ������ ������!!!
                            AND COALESCE (CLO_PartionGoods.ObjectId, -1) NOT IN (80132, 0)
                            -- �� ��������� ��� ������ - ����� ������
                            AND ObjectLink_PartionCell.ObjectId IS NULL
                        )
     -- ������ ���� ������
   , tmpContainer_list AS (-- �� ������� ��� �������������
                           SELECT tmp_01.ContainerId
                                , tmp_01.GoodsId
                                , tmp_01.GoodsKindId
                                , tmp_01.PartionGoodsId
                                , tmp_01.PartionGoodsDate
                                , tmp_01.PartionGoods
                                , tmp_01.Amount
                           FROM tmp_01

                         UNION ALL
                          -- ���� ��� �� - ������ �� ����� + ������
                          SELECT tmp_02.ContainerId
                               , tmp_02.GoodsId
                               , tmp_02.GoodsKindId
                               , tmp_02.PartionGoodsId
                               , tmp_02.PartionGoodsDate
                               , '' AS PartionGoods
                               , tmp_02.Amount
                          FROM tmp_02

                         UNION ALL
                          -- ���� ��� �� - ������ �� ����� + ������
                          SELECT tmp_03.ContainerId
                               , tmp_03.GoodsId
                               , tmp_03.GoodsKindId
                               , tmp_03.PartionGoodsId
                               , tmp_03.PartionGoodsDate
                               , '' AS PartionGoods
                                 -- ���������� ��� ����� ���� �������
                               , 0.01 AS Amount
                          FROM tmp_03
                          -- !!!������ ����!!1
                          WHERE tmp_03.Ord = 1
                          )

     -- ���� ������ �������, ������ ����� ������
   , tmpContainer_find AS (SELECT tmpMI.MovementItemId
                                , tmpMI.GoodsId
                                , tmpMI.GoodsKindId
                                , tmpMI.OperCount  AS Amount
                                , tmpContainer_list.ContainerId
                              --, tmpContainer_list.Amount AS Amount_container
                                , tmpContainer_list.PartionGoodsId
                                  -- !!!�� ������ ������!!!
                                , ROW_NUMBER() OVER (PARTITION BY tmpMI.MovementItemId ORDER BY tmpContainer_list.ContainerId ASC) AS Ord
                           FROM tmpMI
                                LEFT JOIN tmpContainer_list ON tmpContainer_list.GoodsId      = tmpMI.GoodsId
                                                           AND tmpContainer_list.PartionGoods = tmpMI.PartionGoods
                                                           AND tmpContainer_list.Amount       > 0
                           -- ������ �����������
                           WHERE tmpMI.PartionGoods <> ''
                          )
     -- ������� � ������ ��������, �������� ����� ��
   , tmpContainer_rem AS (SELECT tmpMIContainer.ContainerId
                               , tmpMIContainer.GoodsId
                               , tmpMIContainer.GoodsKindId
                               , SUM (tmpMIContainer.Amount_rem) AS Amount_rem
                          FROM (-- ������� �� ����� ���
                                SELECT tmpContainer_list.ContainerId
                                     , tmpContainer_list.GoodsId
                                     , tmpContainer_list.GoodsKindId
                                     , tmpContainer_list.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_rem
                                FROM tmpContainer_list
                                     LEFT JOIN tmpContainer_find ON tmpContainer_find.ContainerId = tmpContainer_list.ContainerId
                                     LEFT JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.ContainerId = tmpContainer_list.ContainerId
                                                                    -- !!!�� ����� ���
                                                                    AND MIContainer.OperDate    > vbOperDate
                                -- ������ ���� ������ �� �����
                                WHERE tmpContainer_find.ContainerId IS NULL
                                  -- ��� �������� - ��� �� + �� �� ���� - ����� ������ ��� ���� � �.�.
                                  AND vbIsPartionCell_from = FALSE

                                GROUP BY tmpContainer_list.ContainerId, tmpContainer_list.GoodsId, tmpContainer_list.GoodsKindId, tmpContainer_list.Amount
                                HAVING tmpContainer_list.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) > 0
    
                               UNION ALL
                                -- ����� ���� ������ ��� ����������
                                SELECT tmpContainer_find.ContainerId
                                     , tmpContainer_find.GoodsId
                                     , tmpContainer_find.GoodsKindId
                                     , -1 * SUM (tmpContainer_find.Amount) AS Amount_rem
                                FROM tmpContainer_find
                                -- !!!�� ������ ������!!!
                                WHERE tmpContainer_find.Ord = 1
                                  AND tmpContainer_find.ContainerId > 0
                                  -- ��� �������� - ��� �� + �� �� ���� - ����� ������ ��� ���� � �.�.
                                  AND vbIsPartionCell_from = FALSE

                                GROUP BY tmpContainer_find.ContainerId, tmpContainer_find.GoodsId, tmpContainer_find.GoodsKindId

                               ) AS tmpMIContainer
                          GROUP BY tmpMIContainer.ContainerId, tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                          HAVING SUM (tmpMIContainer.Amount_rem) > 0
                         )
     -- ��� ������� � ������ ��������������, ������ ��� ��
   , tmpContainer_rem_RK AS (SELECT tmpContainer_list.ContainerId
                                    -- ��������� �������� ��� ����� ������
                                  , -1 * SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_invent
                             FROM tmpContainer_list
                                  INNER JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.ContainerId = tmpContainer_list.ContainerId
                                                                  -- !!!���
                                                                  AND MIContainer.OperDate       >= DATE_TRUNC ('MONTH', vbOperDate)
                                                                  AND MIContainer.MovementDescId = zc_Movement_Inventory()
                             -- ��� ��
                             WHERE vbIsPartionCell_from = TRUE
                             GROUP BY tmpContainer_list.ContainerId
                             --HAVING SUM (COALESCE (MIContainer.Amount, 0)) <> 0
                             -- !!! -- select * from gpComplete_All_Sybase(28658170,False,'444873')
                             HAVING SUM (COALESCE (MIContainer.Amount, 0)) < 0
                            )
  -- ����� ������ ������
, tmpContainer_all AS (SELECT tmpMI.GoodsId
                            , tmpMI.GoodsKindId
                            , Container.ContainerId
                              -- ���-��
                            , tmpMI.OperCount AS Amount
                              -- ������� + ��� ����� �������������� ��� ��
                            , COALESCE (tmpContainer_rem.Amount_rem, Container.Amount) + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) AS Amount_container
                              -- ������������
                            , SUM (COALESCE (tmpContainer_rem.Amount_rem, Container.Amount) + COALESCE (tmpContainer_rem_RK.Amount_invent, 0))
                                               OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId
                                                     ORDER BY CASE WHEN tmpMI.is_30100 = TRUE AND Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) > 0 THEN 0 ELSE 1 END
                                                            , CASE WHEN tmpMI.is_30100 = TRUE AND Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) < 0 THEN 0 ELSE 1 END
                                                            , CASE WHEN tmpMI.is_30100 = TRUE THEN Container.PartionGoodsDate ELSE zc_DateStart() END ASC
                                                              --
                                                              --
                                                          --, CASE WHEN tmpContainer_rem.Amount_rem > 0 THEN Container.ContainerId ELSE 0 END DESC
                                                              --
                                                          --, COALESCE (tmpContainer_rem.Amount_rem, 0) DESC
                                                              --
                                                            , Container.PartionGoodsDate ASC
                                                            , Container.ContainerId ASC
                                                    )  AS AmountSUM
                              -- !!!���� �������� ���������!!!
                            , ROW_NUMBER()     OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId
                                                     ORDER BY CASE WHEN tmpMI.is_30100 = TRUE AND Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) > 0 THEN 0 ELSE 1 END
                                                            , CASE WHEN tmpMI.is_30100 = TRUE AND Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) < 0 THEN 0 ELSE 1 END
                                                              -- ��������
                                                            , CASE WHEN tmpMI.is_30100 = TRUE THEN Container.PartionGoodsDate ELSE zc_DateStart() END DESC
                                                              --
                                                              -- ��������
                                                          --, CASE WHEN tmpContainer_rem.Amount_rem > 0 THEN Container.ContainerId ELSE 0 END ASC
                                                              -- ��������
                                                          --, COALESCE (tmpContainer_rem.Amount_rem, 0) ASC
                                                              -- ��������
                                                            , Container.PartionGoodsDate DESC
                                                              -- ��������
                                                            , Container.ContainerId DESC
                                                    ) AS Ord
                            , Container.PartionGoodsId

                       FROM tmpMI_summ AS tmpMI
                               INNER JOIN tmpContainer_list AS Container
                                                            ON Container.GoodsId     = tmpMI.GoodsId
                                                           AND Container.GoodsKindId = tmpMI.GoodsKindId

                            LEFT JOIN tmpContainer_find ON tmpContainer_find.ContainerId = Container.ContainerId

                            LEFT JOIN tmpContainer_rem ON tmpContainer_rem.ContainerId = Container.ContainerId
                            LEFT JOIN tmpContainer_rem_RK ON tmpContainer_rem_RK.ContainerId = Container.ContainerId
                                                         AND tmpContainer_rem.ContainerId IS NULL

                       WHERE (COALESCE (tmpContainer_rem.Amount_rem, Container.Amount) > 0
                           -- ��� �� + �� -�����
                           OR tmpMI.is_30100 = TRUE
                             )
                         -- ������ ���� ������ �� �����
                         AND tmpContainer_find.ContainerId IS NULL
                      )
      -- ����� ���-�� ������� �� �������
    , tmpContainer_partion AS (SELECT DD.ContainerId
                                    , DD.GoodsId
                                    , DD.GoodsKindId
                                    , DD.PartionGoodsId
                                    , CASE WHEN DD.Amount - DD.AmountSUM > 0 AND DD.Ord <> 1 -- ���������� ���������� ��������!!!
                                                THEN DD.Amount_container
                                           ELSE DD.Amount - DD.AmountSUM + DD.Amount_container
                                      END AS Amount
                               FROM (SELECT * FROM tmpContainer_all) AS DD
                               WHERE DD.Amount - (DD.AmountSUM - DD.Amount_container) > 0
                              )
      -- �������� ������������� �����
    , tmpContainer_sum AS (SELECT tmpContainer.ContainerId
                                , tmpContainer.GoodsId
                                , tmpContainer.GoodsKindId
                                , tmpContainer.PartionGoodsId
                                , tmpContainer.Amount
                                  -- ���������� �� ContainerId
                                , SUM (tmpContainer.Amount) OVER (PARTITION BY tmpContainer.GoodsId, tmpContainer.GoodsKindId ORDER BY tmpContainer.ContainerId ASC) AS AmountSUM
                           FROM tmpContainer_partion AS tmpContainer
                          )
      -- �������� � �/�, ���� ������������ ������������� �������
    , tmpContainer_NUMBER AS (SELECT tmpContainer.ContainerId
                                   , tmpContainer.GoodsId
                                   , tmpContainer.GoodsKindId
                                   , tmpContainer.PartionGoodsId
                                   , tmpContainer.Amount
                                   , tmpContainer.AmountSUM
                                     -- ���� ���-�� ����� � � �/� = 1
                                   , ROW_NUMBER() OVER (PARTITION BY tmpContainer.GoodsId, tmpContainer.GoodsKindId ORDER BY tmpContainer.AmountSUM DESC) AS Ord
                              FROM tmpContainer_sum AS tmpContainer
                             )
      -- ������������� �������
    , tmpContainer_group AS (SELECT tmpContainer.ContainerId
                                  , tmpContainer.GoodsId
                                  , tmpContainer.GoodsKindId
                                  , tmpContainer.PartionGoodsId
                                  , tmpContainer.Amount
                                  , tmpContainer.AmountSUM
                                  , tmpContainer.Ord
                                    -- � ������������
                                  , COALESCE (tmpContainer_old.AmountSUM, 0) AS Amount_min
                                    -- �������� ��������� ���-��, ���� ������ �� ������, ��� � ��� ����� �� ���� ContainerId (���� ��� � ��� ������ ������� tmpContainer_partion)
                                  , CASE WHEN tmpContainer.Ord = 1 THEN tmpContainer.AmountSUM * 1000 ELSE tmpContainer.AmountSUM END AS Amount_max
                              FROM tmpContainer_NUMBER AS tmpContainer
                                   LEFT JOIN tmpContainer_NUMBER AS tmpContainer_old
                                                                 ON tmpContainer_old.GoodsId     = tmpContainer.GoodsId
                                                                AND tmpContainer_old.GoodsKindId = tmpContainer.GoodsKindId
                                                                AND tmpContainer_old.Ord         = tmpContainer.Ord + 1
                             )
      -- ������������� MI
    , tmpMI_group AS (SELECT tmpMI.MovementItemId
                           , tmpMI.GoodsId
                           , tmpMI.GoodsKindId
                           , tmpMI.OperCount
                             -- ���������� �� MovementItemId
                           , SUM (tmpMI.OperCount) OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.MovementItemId ASC) AS AmountSUM
                      FROM tmpMI
                           LEFT JOIN tmpContainer_find ON tmpContainer_find.MovementItemId = tmpMI.MovementItemId
                      -- ������ ���� ������ �� �����
                      WHERE tmpContainer_find.ContainerId IS NULL
                     )

      -- ������ ���������� � MI -  ???"���������������"???
    , tmpContainer_res_1 AS (SELECT tmpMI_group.MovementItemId
                                  , tmpMI_group.GoodsId
                                  , tmpMI_group.GoodsKindId

                                    -- ���������� �� MI - ERROR
                                --, tmpMI_group.OperCount AS Amount

                                    -- �� ���������� �� Container
                                --, tmpContainer_group.Amount AS Amount

                                    -- ���������� �� Container - ���������������
                                  , CAST (tmpContainer_group.Amount * tmpMI_group.OperCount / tmpMI_summ.OperCount AS NUMERIC(16,4)) AS Amount

                                  , tmpContainer_group.ContainerId
                                  , tmpContainer_group.PartionGoodsId

                                    -- � �/�
                                  , ROW_NUMBER() OVER (PARTITION BY tmpContainer_group.ContainerId ORDER BY tmpMI_group.OperCount DESC) AS Ord

                            FROM tmpMI_group
                                 LEFT JOIN tmpContainer_group ON tmpContainer_group.GoodsId     = tmpMI_group.GoodsId
                                                             AND tmpContainer_group.GoodsKindId = tmpMI_group.GoodsKindId
                                                           -- !!!�����, ����� ���������!!!
                                                           --AND tmpMI_group.AmountSUM > tmpContainer_group.Amount_min AND tmpMI_group.AmountSUM <= tmpContainer_group.Amount_max
                                 LEFT JOIN tmpMI_summ ON tmpMI_summ.GoodsId     = tmpMI_group.GoodsId
                                                     AND tmpMI_summ.GoodsKindId = tmpMI_group.GoodsKindId
                            WHERE tmpMI_summ.OperCount > 0
                           )
      -- ������������ �� �������
    , tmpContainer_res_2 AS (SELECT tmpContainer_res_1.MovementItemId
                                  , tmpContainer_res_1.GoodsId
                                  , tmpContainer_res_1.GoodsKindId

                                    -- ���� ��������������� � �������� �������
                                  , tmpContainer_res_1.Amount + CASE WHEN tmpContainer_res_1.Ord = 1
                                                                          THEN tmpContainer_partion.Amount - tmpContainer_res_sum.Amount
                                                                     ELSE 0
                                                                END AS Amount
                                    --
                                  , tmpContainer_res_1.ContainerId
                                  , tmpContainer_res_1.PartionGoodsId

                             FROM tmpContainer_res_1
                                  -- ������� ���� ���������� �� ContainerId
                                  LEFT JOIN tmpContainer_partion ON tmpContainer_partion.ContainerId = tmpContainer_res_1.ContainerId
                                                                -- ������ 1
                                                                AND tmpContainer_res_1.Ord           = 1
                                  -- ����� ���������� �� ContainerId
                                  LEFT JOIN (SELECT tmpContainer_res_1.ContainerId
                                                  , SUM (tmpContainer_res_1.Amount) AS Amount
                                             FROM tmpContainer_res_1
                                             GROUP BY tmpContainer_res_1.ContainerId
                                            ) AS tmpContainer_res_sum
                                              ON tmpContainer_res_sum.ContainerId = tmpContainer_res_1.ContainerId
                                             -- ������ 1
                                             AND tmpContainer_res_1.Ord           = 1
                            )
      -- ������ ���������� � MI
    , tmpContainer AS (SELECT tmpMI_group.MovementItemId
                            , tmpMI_group.GoodsId
                            , tmpMI_group.GoodsKindId
                              -- ��������
                            , tmpMI_group.Amount
                              --
                            , tmpMI_group.ContainerId
                            , tmpMI_group.PartionGoodsId

                              -- � �/�
                            , ROW_NUMBER() OVER (PARTITION BY tmpMI_group.MovementItemId ORDER BY tmpMI_group.ContainerId DESC) AS Ord

                      FROM tmpContainer_res_2 AS tmpMI_group
                     )
        -- ���������
        SELECT
              tmpMI.MovementItemId
              -- !!!��� ���� ������ �� ��� ������ ������!!!
            , CASE WHEN vbMovementDescId = zc_Movement_LossAsset() THEN tmpMI.ContainerId_asset ELSE COALESCE (tmpContainer_find.ContainerId, tmpContainer.ContainerId, 0) END AS ContainerId_Goods
            , 0 AS ContainerId_Count
              -- ������� � ��������, ��������� �����
            , 0 AS ContainerId_asset

            , Object.DescId AS ObjectDescId
            , tmpMI.GoodsId
            , tmpMI.GoodsKindId
            , tmpMI.GoodsKindId_complete
            , 0 AS AssetId -- tmpMI.AssetId -- !!!�������� ��������, �.�. �� ������ ����������� � ������!!!
            , tmpMI.PartionGoods
            , tmpMI.PartionGoodsDate

            , CASE WHEN vbMovementDescId = zc_Movement_LossAsset()
                        THEN tmpMI.PartionGoodsId_asset
                   ELSE COALESCE (tmpContainer_find.PartionGoodsId, tmpContainer.PartionGoodsId, tmpMI.PartionGoodsId_mi, 0)
              END AS PartionGoodsId_Item

              -- !!!��� ������ ������!!!
            , COALESCE (tmpContainer_find.Amount, tmpContainer.Amount, tmpMI.OperCount)  AS OperCount

            , CASE WHEN COALESCE (tmpContainer.Ord, 1) = 1 THEN tmpMI.OperCountCount ELSE 0 END AS OperCountCount
            , COALESCE (tmpMI.Summ_service, 0)                 AS Summ_service

            , COALESCE (View_InfoMoney.InfoMoneyGroupId, tmpMI.InfoMoneyGroupId)             AS InfoMoneyGroupId       -- �������������� ������
            , COALESCE (View_InfoMoney.InfoMoneyDestinationId, tmpMI.InfoMoneyDestinationId) AS InfoMoneyDestinationId -- �������������� ����������
            , COALESCE (View_InfoMoney.InfoMoneyId, tmpMI.InfoMoneyId)                       AS InfoMoneyId            -- ������ ����������

              -- ������ �������: �� ������������
            , tmpMI.BusinessId

            , tmpMI.isPartionCount
            , tmpMI.isPartionSumm

              -- ������ ������, ���������� �����
            , CASE WHEN vbMovementDescId = zc_Movement_LossAsset() THEN tmpMI.PartionGoodsId_asset
                   -- ����� ����� - ��
                   WHEN tmpMI.isAsset = TRUE AND COALESCE (tmpContainer_find.PartionGoodsId, tmpContainer.PartionGoodsId) > 0
                        THEN COALESCE (tmpContainer_find.PartionGoodsId, tmpContainer.PartionGoodsId)
                   ELSE 0
              END AS PartionGoodsId
            
            , tmpMI.isAsset

            , tmpMI.OperCount AS OperCount_start

        FROM tmpMI
             LEFT JOIN Object ON Object.Id = tmpMI.GoodsId

             -- ����� - ���� ������ �������
             LEFT JOIN tmpContainer_find  ON tmpContainer_find.MovementItemId     = tmpMI.MovementItemId
                                         -- !!!�� ������ ������!!!
                                         AND tmpContainer_find.Ord                = 1

             -- ������ ����������� ������
             LEFT JOIN tmpContainer       ON tmpContainer.MovementItemId = tmpMI.MovementItemId
                                         -- ��� � �������������
                                         AND tmpContainer_find.MovementItemId      IS NULL

             -- ������ ������� ��� asset
             LEFT JOIN tmpContainer_asset ON tmpContainer_asset.ContainerId_asset = tmpMI.ContainerId_asset
                                         AND tmpContainer_asset.Ord               = 1
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                             ON View_InfoMoney.InfoMoneyId = tmpContainer_asset.InfoMoneyId
     ;


     -- �������� - 2 - ������ ������
     IF vbIsPartionCell_from = TRUE
        AND EXISTS (SELECT 1
                    FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                          FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.OperCount_start
                                FROM _tmpItem
                                WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                        , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                         )
                                  AND _tmpItem.OperCount_start > 0
                               ) AS tmpItem_start
                          GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                         ) AS tmpItem_start
                         FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId, SUM (_tmpItem.OperCount) AS OperCount
                                    FROM _tmpItem
                                    WHERE _tmpItem.ContainerId_Goods > 0
                                      AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                            , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                             )
                                    GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                   ) AS tmpItem
                                     ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                    AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                    WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                   )
        AND inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer)
        --AND 1=0
     THEN
         RAISE EXCEPTION '������.������ ������.% % � <%> �� <%> %����� = <%> %��� = <%> %���-�� = <%> %���-�� �� ������� = <%> %Id = <%>'
                       , CHR (13)
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                       , CHR (13)
                         -- GoodsId
                       , (SELECT lfGet_Object_ValueData (tmpItem_start.GoodsId)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.OperCount_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                               )
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount) AS OperCount
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                   )
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- GoodsKindId
                       , (SELECT lfGet_Object_ValueData_sh (tmpItem_start.GoodsKindId)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.OperCount_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                               )
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount) AS OperCount
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                   )
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- 1.1. OperCount_start
                       , (SELECT zfConvert_FloatToString (tmpItem_start.OperCount_start)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.OperCount_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                               )
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount) AS OperCount
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                   )
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- 1.2. OperCount - calc
                       , (SELECT zfConvert_FloatToString (tmpItem.OperCount)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.OperCount_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                               )
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount) AS OperCount
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                   )
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- MovementItemId
                       , (SELECT COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId) :: TVarChar || ' - ' || COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId) :: TVarChar
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.OperCount_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                               )
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount) AS OperCount
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                   )
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                        ;
     END IF;


     -- ������������ = ����� �� ��� �������� ���������� �� ������������ ���� ��: ���� �� ������ �������� + ���� �� ����� ��������
     vbIsContainer_Asset:= vbArticleLossId IN (5670650, 5670651) AND NOT EXISTS (SELECT 1 FROM _tmpItem INNER JOIN Container ON Container.Id = _tmpItem.ContainerId_Goods AND Container.DescId IN (zc_Container_CountAsset(), zc_Container_SummAsset()));
     -- ��� ��������� - ��������������� ���
     IF vbIsContainer_Asset = TRUE THEN vbContractId_send:= 0; END IF;


/*     IF inUserId = 5
     THEN
          RAISE EXCEPTION '������. PartionGoodsId_Item = <%>'
              , (SELECT _tmpItem.PartionGoodsId_Item FROM _tmpItem WHERE _tmpItem.MovementItemId = 165388198)
               ;
     END IF;*/

     -- �������� - ��� ��
     IF vbMovementDescId = zc_Movement_LossAsset()
        AND EXISTS (SELECT 1
                    FROM _tmpItem
                    WHERE COALESCE (_tmpItem.ContainerId_Goods, 0) = 0 OR COALESCE (_tmpItem.PartionGoodsId, 0) = 0
                   )
     THEN
          RAISE EXCEPTION '������.��� �� <%> ������ ���� ������� ������.'
                        , lfGet_Object_ValueData_sh ((SELECT _tmpItem.GoodsId
                                                      FROM _tmpItem
                                                      WHERE COALESCE (_tmpItem.ContainerId_Goods, 0) = 0 OR COALESCE (_tmpItem.PartionGoodsId, 0) = 0
                                                      LIMIT 1
                                                     ))
                                                     ;
     END IF;

     -- �������� - �.�.��� ���� ��-������ ����� ������ ������ - ���� ��� � ����� ��� ����������
     IF EXISTS (SELECT _tmpItem.GoodsId FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId
                                              FROM _tmpItem
                                              WHERE _tmpItem.PartionGoods = ''
                                                AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                                                      , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                                                      , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                                                       )
                                             ) AS _tmpItem
                GROUP BY _tmpItem.GoodsId
                HAVING COUNT(*) > 1)
     THEN
          RAISE EXCEPTION '������.� ��������� ������ ����������� ����� <%>.'
              , lfGet_Object_ValueData (
               (SELECT _tmpItem.GoodsId FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId
                                              FROM _tmpItem
                                              WHERE _tmpItem.PartionGoods = ''
                                                AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                                                      , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                                                      , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                                                       )
                                             ) AS _tmpItem
                GROUP BY _tmpItem.GoodsId
                HAVING COUNT(*) > 1
                LIMIT 1));
     END IF;

     -- ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId      = CASE WHEN _tmpItem.ContainerId_Goods > 0
                                                        THEN _tmpItem.PartionGoodsId_Item -- !!!������ ��� ����� �� �������!!!

                                                    WHEN _tmpItem.PartionGoodsId_Item > 0
                                                        THEN _tmpItem.PartionGoodsId_Item -- !!!������ ��� ����� � MovementItem !!!

                                                    -- ����������
                                                    WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20202() AND _tmpItem.PartionGoods <> ''
                                                         THEN lpInsertFind_Object_PartionGoods (inValue       := _tmpItem.PartionGoods
                                                                                              , inOperDate    := zc_DateStart()
                                                                                              , inInfoMoneyId := zc_Enum_InfoMoney_20202()
                                                                                               )

                                                  WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                     AND vbAccountDirectionId = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN vbOperDate >= zc_DateStart_PartionGoods_20103()
                                                     AND _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20103() -- �������� � ������� + ����
                                                        THEN lpInsertFind_Object_PartionGoods (inValue:= _tmpItem.PartionGoods)

                                                    WHEN vbIsPartionDate_Unit = TRUE
                                                     AND _tmpItem.PartionGoodsDate <> zc_DateEnd()
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

                                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                        THEN 0 -- !!!�������� ����!!! -- _tmpItem.PartionGoodsId_Item

                                                    ELSE lpInsertFind_Object_PartionGoods ('')

                                               END
     WHERE (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
          )
       AND _tmpItem.ObjectDescId <> zc_Object_InfoMoney()
     ;

     -- ����������
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId WHEN vbMemberId <> 0 THEN vbMemberId WHEN vbCarId <> 0 THEN vbCarId END;


     IF inUserId <> zfCalc_UserAdmin() :: Integer THEN
       -- !!!��������� - �����������/������� �����������!!! - �� ��������� "����������" - !!!����� - ����� ��������� _tmpMIContainer_insert, ������� ������ �� ��������!!!, �� ����� ���������� _tmpItem
       PERFORM lpComplete_Movement_Sale_Recalc (inMovementId := inMovementId
                                              , inUnitId     := vbUnitId
                                              , inUserId     := inUserId);
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1.1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_Goods = CASE WHEN _tmpItem.ContainerId_Goods > 0 THEN _tmpItem.ContainerId_Goods
                                                  ELSE
                                             lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inCarId                  := vbCarId
                                                                                , inMemberId               := vbMemberId
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_Unit
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
                                             END;

     -- 1.1.2. ������������ ContainerId_Count ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_Count = lpInsertFind_Container (inContainerDescId   := zc_Container_CountCount()
                                                                   , inParentId          := _tmpItem.ContainerId_Goods
                                                                   , inObjectId          := _tmpItem.GoodsId
                                                                   , inJuridicalId_basis := NULL
                                                                   , inBusinessId        := NULL
                                                                   , inObjectCostDescId  := NULL
                                                                   , inObjectCostId      := NULL
                                                                    )
     WHERE _tmpItem.OperCountCount <> 0;

     -- 1.1.3. ������������ ContainerId_asset ��� ��������������� ����� - ������� � ��������
     UPDATE _tmpItem SET ContainerId_asset = lpInsertUpdate_ContainerCount_Asset (inOperDate               := vbOperDate
                                                                                , inUnitId                 := CLO_Unit.ObjectId
                                                                                , inCarId                  := CLO_Car.ObjectId
                                                                                , inMemberId               := CLO_Member.ObjectId
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                , inAssetId                := CLO_Asset.ObjectId
                                                                                , inBranchId               := NULL -- ��� ��������� ����� ��� �������
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
     FROM Container
          LEFT JOIN ContainerLinkObject AS CLO_Unit
                                        ON CLO_Unit.ContainerId = Container.Id
                                       AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
          LEFT JOIN ContainerLinkObject AS CLO_Car
                                        ON CLO_Car.ContainerId = Container.Id
                                       AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
          LEFT JOIN ContainerLinkObject AS CLO_Member
                                        ON CLO_Member.ContainerId = Container.Id
                                       AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
          LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                        ON CLO_PartionGoods.ContainerId = Container.Id
                                       AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
          LEFT JOIN ContainerLinkObject AS CLO_Asset
                                        ON CLO_Asset.ContainerId = Container.Id
                                       AND CLO_Asset.DescId      = zc_ContainerLinkObject_AssetTo()
     WHERE vbIsContainer_Asset = TRUE AND vbMovementDescId = zc_Movement_LossAsset()
       AND _tmpItem.ContainerId_Goods = Container.Id
       -- !!!���� �� ���������������!!!
       AND vbContractId_send = 0
       -- !!!���� �� ������!!!
       AND _tmpItem.ObjectDescId <> zc_Object_InfoMoney()
    ;

     -- 1.1.4. !!! ContainerId - ��� ������� � ��������, ��������� ���-�� �������� � ���-��� ������!!!!
     UPDATE Container SET ParentId = _tmpItem.ContainerId_Goods
     FROM _tmpItem
     WHERE Container.Id = _tmpItem.ContainerId_asset
       -- !!!���� �� ������!!!
       AND _tmpItem.ObjectDescId <> zc_Object_InfoMoney()
     ;


     -- 1.2.1. ����� ����������: ��������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_Goods, ContainerId_ProfitLoss, ContainerDescId, ContainerId, ContainerId_asset, AccountId, OperSumm)
       --
       WITH -- ��� ���� ��������� �/� � ����� ����� �������������� ����
            tmpHistoryCost_find_all AS (SELECT _tmpItem.ContainerId_Goods
                                             , _tmpItem.GoodsId
                                             , _tmpItem.GoodsKindId
                                             , Container_Summ.Id               AS ContainerId_Summ
                                             , Container_Summ.ObjectId         AS AccountId
                                             , COALESCE (HistoryCost.Price, 0) AS Price
                                        FROM _tmpItem
                                             INNER JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                                                   AND Container_Summ.DescId   = zc_Container_Summ()
                                             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                                        WHERE vbIsPartionCell_from = TRUE
                                       )
                -- ����� �/� ���� ��� ��� ContainerId_Goods
              , tmpHistoryCost_find AS (SELECT Container_Summ.ContainerId_Goods
                                             , Container_Summ.ContainerId_Summ
                                             , MAX (HistoryCost.Price) AS Price
                                        FROM -- ����� � ����� ContainerId_Goods ��� ���� = 0
                                             (SELECT tmpHistoryCost_find_all.ContainerId_Goods FROM tmpHistoryCost_find_all
                                              GROUP BY tmpHistoryCost_find_all.ContainerId_Goods
                                              HAVING MAX (tmpHistoryCost_find_all.Price) = 0
                                             ) AS tmpHistoryCost_list
                                             -- ��� ���� ContainerId_Summ ���� ����� �������������� ����
                                             JOIN tmpHistoryCost_find_all AS Container_Summ ON Container_Summ.ContainerId_Goods = tmpHistoryCost_list.ContainerId_Goods

                                             -- ��-�� ContainerId_Summ, ��� ��� ����
                                             LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container_Summ.ContainerId_Summ
                                                                                           AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                             LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = Container_Summ.ContainerId_Summ
                                                                                                 AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                             LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis ON CLO_JuridicalBasis.ContainerId = Container_Summ.ContainerId_Summ
                                                                                                AND CLO_JuridicalBasis.DescId      = zc_ContainerLinkObject_JuridicalBasis()
                                               
                                             -- ������������
                                             JOIN Container AS Container_Count_new ON Container_Count_new.ObjectId = Container_Summ.GoodsId
                                                                                  AND Container_Count_new.DescId   = zc_Container_Count()
                                             JOIN Container AS Container_Summ_new ON Container_Summ_new.ParentId = Container_Count_new.Id
                                                                                 AND Container_Summ_new.ObjectId = Container_Summ.AccountId
                                                                                 AND Container_Summ_new.DescId   = zc_Container_Summ()
                                             INNER JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ_new.Id
                                                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                                                                  -- !!! ���� ���� !!!
                                                                  AND HistoryCost.Price > 0
                                             -- ��-��
                                             INNER JOIN ContainerLinkObject AS CLO_Unit_new
                                                                            ON CLO_Unit_new.ContainerId = Container_Summ_new.Id
                                                                           AND CLO_Unit_new.DescId      = zc_ContainerLinkObject_Unit()
                                                                           AND CLO_Unit_new.ObjectId    = vbUnitId

                                             INNER JOIN ContainerLinkObject AS CLO_InfoMoney_new ON CLO_InfoMoney_new.ContainerId = Container_Summ_new.Id
                                                                                                AND CLO_InfoMoney_new.DescId      = zc_ContainerLinkObject_InfoMoney()
                                                                                                AND CLO_InfoMoney_new.ObjectId    = CLO_InfoMoney.ObjectId
                                             INNER JOIN ContainerLinkObject AS CLO_InfoMoneyDetail_new ON CLO_InfoMoneyDetail_new.ContainerId = Container_Summ_new.Id
                                                                                                      AND CLO_InfoMoneyDetail_new.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                      AND CLO_InfoMoneyDetail_new.ObjectId    = CLO_InfoMoneyDetail.ObjectId
                                             LEFT JOIN ContainerLinkObject AS CLO_GoodsKind_new ON CLO_GoodsKind_new.ContainerId = Container_Summ_new.Id
                                                                                               AND CLO_GoodsKind_new.DescId      = zc_ContainerLinkObject_GoodsKind()
                                             INNER JOIN ContainerLinkObject AS CLO_JuridicalBasis_new ON CLO_JuridicalBasis_new.ContainerId = Container_Summ_new.Id
                                                                                                     AND CLO_JuridicalBasis_new.DescId      = zc_ContainerLinkObject_JuridicalBasis()
                                                                                                     AND CLO_JuridicalBasis_new.ObjectId    = CLO_JuridicalBasis.ObjectId

                                        WHERE COALESCE (CLO_GoodsKind_new.ObjectId, 0) = COALESCE (Container_Summ.GoodsKindId, 0)
                                        GROUP BY Container_Summ.ContainerId_Goods
                                               , Container_Summ.ContainerId_Summ
                                  )
        -- ���������
        SELECT
              _tmpItem.MovementItemId
            , CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN 0 ELSE _tmpItem.ContainerId_Goods END AS ContainerId_Goods
              -- ��������������� - � �������
            , 0 AS ContainerId_ProfitLoss
            , 0 AS ContainerDescId
              -- ������ ��������
            , CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN _tmpItem.ContainerId_Goods ELSE COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0)) END AS ContainerId
              -- ������� � ��������, ��������� �����
            , 0 AS ContainerId_asset

            , CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN Container_asset.ObjectId ELSE COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) END AS AccountId
            , SUM (CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney()
                        THEN _tmpItem.Summ_service
                        WHEN ABS (Container_Summ.Amount - _tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0)) < 0.01
                        THEN Container_Summ.Amount
                        ELSE CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))
                           + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                                       THEN HistoryCost.Summ_diff -- !!!���� ���� "�����������" ��� ����������, �������� �����!!!
                                  ELSE 0
                             END
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
                                                  AND Container_Summ.DescId   = zc_Container_Summ()
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
             -- ����� �/� ���� ��� ��� ContainerId_GoodsFrom
             LEFT JOIN tmpHistoryCost_find ON tmpHistoryCost_find.ContainerId_Summ = Container_Summ.Id
                                          AND HistoryCost.ContainerId IS NULL

             -- ��� ������� �� - ������
             LEFT JOIN Container AS Container_asset ON Container_asset.Id     = _tmpItem.ContainerId_Goods
                                                   AND Container_asset.DescId = zc_Container_Summ()

        WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) <> 0 -- ����� ���� !!!�� �����!!!
           -- !!!���� ������!!!
            OR _tmpItem.ObjectDescId = zc_Object_InfoMoney()
              )
        GROUP BY _tmpItem.MovementItemId
               , _tmpItem.ContainerId_Goods
               , _tmpItem.ObjectDescId
               , Container_asset.ObjectId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId

       UNION ALL
        -- ���� � ���������
        SELECT
              _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                           AS ContainerId_ProfitLoss
            , zc_Container_SummAsset()    AS ContainerDescId
              -- ������ ��������
            , Container_Summ.Id           AS ContainerId
              -- ������� � ��������, ����� ��� ���
            , 0                           AS ContainerId_asset
            , Container_Summ.ObjectId     AS AccountId
            , CASE WHEN _tmpItem.OperCount = Container_GoodsAsset.Amount OR Container_GoodsAsset.Amount = 0
                        THEN Container_Summ.Amount
                   ELSE Container_Summ.Amount / Container_GoodsAsset.Amount * _tmpItem.OperCount
              END AS OperSumm
        FROM _tmpItem
             -- ��� �������
             INNER JOIN Container AS Container_GoodsAsset ON Container_GoodsAsset.Id     = _tmpItem.ContainerId_Goods
                                                         AND Container_GoodsAsset.DescId = zc_Container_CountAsset()
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId   = zc_Container_SummAsset()
        WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND vbMovementDescId = zc_Movement_LossAsset()
          AND CASE WHEN _tmpItem.OperCount = Container_GoodsAsset.Amount OR Container_GoodsAsset.Amount = 0
                        THEN Container_Summ.Amount
                   ELSE Container_Summ.Amount / Container_GoodsAsset.Amount * _tmpItem.OperCount
              END <> 0
        --AND inUserId = 5 -- !!! ��������, �.�. ��� �/� � HistoryCost ��� "�������" �������

       /*UNION ALL
        SELECT
              _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0 AS ContainerId_ProfitLoss
            , Container_Summ.Id       AS ContainerId
            , 0                       AS ContainerId_asset
            , Container_Summ.ObjectId AS AccountId
            , CASE WHEN _tmpItem.OperCount = Container_Goods.Amount OR Container_Goods.Amount = 0
                        THEN Container_Summ.Amount
                   ELSE Container_Summ.Amount / Container_Goods.Amount * _tmpItem.OperCount
              END AS OperSumm
        FROM _tmpItem
             -- ��� �������
             LEFT JOIN Container AS Container_Goods ON Container_Goods.Id = _tmpItem.ContainerId_Goods
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId   = zc_Container_Summ()
        WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND vbMovementDescId = zc_Movement_LossAsset()
          AND CASE WHEN _tmpItem.OperCount = Container_Goods.Amount OR Container_Goods.Amount = 0
                        THEN Container_Summ.Amount
                   ELSE Container_Summ.Amount / Container_Goods.Amount * _tmpItem.OperCount
              END <> 0
          AND inUserId = 5 -- !!! ��������, �.�. ��� �/� � HistoryCost ��� "�������" �������
       */
       ;


     -- 2.1.1. ������� ���������� ��� �������� - �������
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss = _tmpItem_byDestination.ContainerId_ProfitLoss -- ���� - �������
     FROM _tmpItem
          JOIN (-- ����� ContainerId_ProfitLoss, �������� InfoMoneyDestinationId
                SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
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
                FROM (-- ����� ProfitLossId - ��� InfoMoneyDestinationId_calc, �������� InfoMoneyDestinationId
                      SELECT CASE WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                    OR vbMovementDescId = zc_Movement_LossAsset()
                                       THEN CASE WHEN _tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- ���������������� ������������
                                                          -- !!!...!!!
                                                     THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60201) -- ������� ������������ + ���������������� �� + �������� ��������*****
                                                     -- !!!...!!!
                                                ELSE (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60101) -- ������� ������������ + ���������������� �� + �������� ��������*****
                                           END
                                  ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := vbProfitLossGroupId
                                                                     , inProfitLossDirectionId  := vbProfitLossDirectionId
                                                                     , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                     , inInfoMoneyId            := NULL
                                                                     , inUserId                 := inUserId
                                                                      )
                             END AS ProfitLossId

                           , _tmpItem_group.InfoMoneyDestinationId
                      FROM (SELECT -- ��� ��� �������������
                                   DISTINCT
                                   _tmpItem.InfoMoneyDestinationId_calc
                                 , _tmpItem.InfoMoneyDestinationId
                                 , _tmpItem.InfoMoneyId
                            FROM (-- ������������� � "��������"
                                  SELECT DISTINCT
                                         _tmpItem.InfoMoneyDestinationId
                                       , _tmpItem.InfoMoneyId
                                       , _tmpItem.GoodsKindId
                                       , CASE WHEN vbInfoMoneyId_ArticleLoss > 0
                                                   THEN (SELECT InfoMoneyDestinationId FROM Object_InfoMoney_View WHERE InfoMoneyId = vbInfoMoneyId_ArticleLoss) -- !!!������ �� ������� �� ������!!!

--                                              when inUserId = 444873 THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������

                                              WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                                OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                                OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                                OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                                OR ((COALESCE (vbArticleLossId, 0) = 0 OR _tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress())
                                                    AND vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                                OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                                   THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������

                                              --WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                              --     THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������

                                              ELSE _tmpItem.InfoMoneyDestinationId

                                         END AS InfoMoneyDestinationId_calc
                                  FROM _tmpItemSumm
                                       JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
                                  -- !!!���� �� ���������������!!!
                                  WHERE vbContractId_send = 0
                                    -- !!!���� �� � ���������!!!
                                    AND  _tmpItemSumm.ContainerDescId <> zc_Container_SummAsset()
                                 ) AS _tmpItem

                           ) AS _tmpItem_group
                     ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       -- !!!���� �� ���������������!!!
       AND vbContractId_send = 0
    ;

     -- 2.1.2. ������� ��������� ��� �������� - ��������������� ������ �� �� ����
     IF vbContractId_send > 0
     THEN
         -- �������� :)
         vbAccountId_Send:= zc_Enum_Account_30205(); -- �������-���������
         --
         vbContainerId_send:= lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                    , inParentId          := NULL
                                                    , inObjectId          := vbAccountId_Send
                                                    , inJuridicalId_basis := vbJuridicalId_Basis_send
                                                    , inBusinessId        := 0                       -- ������ ������: �� ������������
                                                    , inObjectCostDescId  := NULL
                                                    , inObjectCostId      := NULL
                                                    , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                    , inObjectId_1        := vbJuridicalId_send
                                                    , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                    , inObjectId_2        := vbContractId_send
                                                    , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                    , inObjectId_3        := vbInfoMoneyId_send
                                                    , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                    , inObjectId_4        := vbPaidKindId_send
                                                    , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                    , inObjectId_5        := 0
                                                    , inDescId_6          := NULL
                                                    , inObjectId_6        := NULL
                                                    , inDescId_7          := NULL
                                                    , inObjectId_7        := NULL
                                                    , inDescId_8          := NULL
                                                    , inObjectId_8        := NULL
                                                     );
     END IF;


     -- 2.1.3. ������� ContainerId_asset ��� ��������� ����� - ������� � ��������
     UPDATE _tmpItemSumm SET ContainerId_asset = lpInsertUpdate_ContainerSumm_Asset (inOperDate               := vbOperDate
                                                                                   , inUnitId                 := CLO_Unit.ObjectId
                                                                                   , inCarId                  := CLO_Car.ObjectId
                                                                                   , inMemberId               := CLO_Member.ObjectId
                                                                                   , inBranchId               := NULL -- ��� ��������� ����� ��� �������
                                                                                   , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                   , inBusinessId             := NULL
                                                                                   , inAccountId              := _tmpItemSumm.AccountId
                                                                                   , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                   , inInfoMoneyId            := (SELECT CLO.ObjectId FROM ContainerLinkObject AS CLO WHERE CLO.ContainerId = _tmpItemSumm.ContainerId AND CLO.DescId = zc_ContainerLinkObject_InfoMoney())
                                                                                   , inInfoMoneyId_Detail     := (SELECT CLO.ObjectId FROM ContainerLinkObject AS CLO WHERE CLO.ContainerId = _tmpItemSumm.ContainerId AND CLO.DescId = zc_ContainerLinkObject_InfoMoneyDetail())
                                                                                   , inContainerId_Goods      := CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN _tmpItem.ContainerId_goods ELSE _tmpItem.ContainerId_asset END
                                                                                   , inGoodsId                := _tmpItem.GoodsId
                                                                                   , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                   , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                   , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                   , inAssetId                := CLO_Asset.ObjectId
                                                                                    )
     FROM _tmpItem
          LEFT JOIN ContainerLinkObject AS CLO_Unit
                                        ON CLO_Unit.ContainerId = _tmpItem.ContainerId_Goods
                                       AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
          LEFT JOIN ContainerLinkObject AS CLO_Car
                                        ON CLO_Car.ContainerId = _tmpItem.ContainerId_Goods
                                       AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
          LEFT JOIN ContainerLinkObject AS CLO_Member
                                        ON CLO_Member.ContainerId = _tmpItem.ContainerId_Goods
                                       AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
          LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                        ON CLO_PartionGoods.ContainerId = _tmpItem.ContainerId_Goods
                                       AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
          LEFT JOIN ContainerLinkObject AS CLO_Asset
                                        ON CLO_Asset.ContainerId = _tmpItem.ContainerId_Goods
                                       AND CLO_Asset.DescId      = zc_ContainerLinkObject_AssetTo()
     WHERE vbIsContainer_Asset = TRUE AND vbMovementDescId = zc_Movement_LossAsset()
       AND _tmpItemSumm.MovementItemId    = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_Goods = CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN 0 ELSE _tmpItem.ContainerId_Goods END
       -- !!!���� �� ���������������!!!
       AND vbContractId_send = 0
      ;


     -- 2.1.2. �������� ���������� ��� �������� - ������� ������ ���� ����
     IF vbContractId_send = 0 AND EXISTS (SELECT 1 FROM (SELECT DISTINCT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm) AS tmp GROUP BY tmp.MovementItemId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION '������. COUNT > 1 by ContainerId_ProfitLoss';
     END IF;

     -- 2.2.1. ����������� �������� - �������
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
              -- !!!������!!! ����� - ������������ ���� ���...
            , CASE WHEN vbUnitId_ProfitLoss <> 0 THEN vbUnitId_ProfitLoss ELSE vbObjectExtId_Analyzer END AS ObjectExtId_Analyzer
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
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN 0 ELSE _tmpItem.ContainerId_Goods END = _tmpItemSumm.ContainerId_Goods
             -- !!!���� �� ���������������!!!
             WHERE vbContractId_send = 0
              -- !!!���� �� � ���������!!!
              AND  _tmpItemSumm.ContainerDescId <> zc_Container_SummAsset()
             GROUP BY _tmpItemSumm.MovementItemId
                    , _tmpItemSumm.ContainerId_ProfitLoss
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
            ) AS _tmpItemSumm_group;

     -- 2.2.2. ����������� �������� - ��������������� ������ �� �� ����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm_group.MovementItemId
            , _tmpItemSumm_group.ContainerId_Send
            , _tmpItemSumm_group.AccountId_Send       AS AccountId              -- ���� �� ����
            , vbAnalyzerId                            AS AnalyzerId             -- ���� ���������: ������ ��������
            , vbJuridicalId_send                      AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , _tmpItemSumm_group.ContainerId          AS ContainerId_Analyzer   -- � ���������������� - ����� ����� �����
            , vbToId                                  AS ObjectIntId_Analyzer   -- vbToId - ����, �������������, ���������
              -- �����
            , _tmpItemSumm_group.GoodsId              AS ObjectExtId_Analyzer   -- �����
            , 0                                       AS ParentId
            , _tmpItemSumm_group.OperSumm
            , vbOperDate
            , FALSE
       FROM (SELECT _tmpItemSumm.MovementItemId
                  , vbContainerId_send  AS ContainerId_Send
                  , vbAccountId_Send    AS AccountId_Send
                  , _tmpItemSumm.ContainerId
                  , _tmpItem.GoodsId
                  , SUM (_tmpItemSumm.OperSumm) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
             -- !!!���� ���������������!!!
             WHERE vbContractId_send > 0
             GROUP BY _tmpItemSumm.MovementItemId
                    , _tmpItemSumm.ContainerId
                    , _tmpItem.GoodsId
            ) AS _tmpItemSumm_group;

     -- 1.1.2. ����������� �������� ��� ��������������� �����, !!!����� �������, �.�. ����� ContainerId_ProfitLoss!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId --, ParentId, Amount, OperDate, IsActive)
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- ��� ������� �������� - zc_Container_Count
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS AccountId              -- ��� �����
            , vbAnalyzerId                            AS AnalyzerId             -- ���� ���������: ������ ��������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
              -- ��������� ���� - ��� ��������� ��.���� - ���������������
            , CASE WHEN vbContractId_send > 0 THEN vbContainerId_send ELSE tmpProfitLoss.ContainerId_ProfitLoss END AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ������������ ���� ���...
            , 0                                       AS ParentId
            , -1 * _tmpItem.OperCount
            , vbOperDate
            , FALSE
       FROM _tmpItem
            LEFT JOIN (SELECT DISTINCT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm
                      ) AS tmpProfitLoss ON tmpProfitLoss.MovementItemId = _tmpItem.MovementItemId

       WHERE _tmpItem.ObjectDescId <> zc_Object_InfoMoney()

      UNION ALL
       -- ��� ������� �������� - zc_Container_CountCount
       SELECT 0, zc_MIContainer_CountCount() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Count
            , 0                                       AS AccountId              -- ��� �����
            , vbAnalyzerId                            AS AnalyzerId             -- ���� ���������: ������ ��������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
              -- ��������� ���� - ��� ��������� ��.���� - ���������������
            , CASE WHEN vbContractId_send > 0 THEN vbContainerId_send ELSE tmpProfitLoss.ContainerId_ProfitLoss END AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ������������ ���� ���...
            , 0                                       AS ParentId
            , -1 * _tmpItem.OperCountCount
            , vbOperDate
            , FALSE
       FROM _tmpItem
            LEFT JOIN (SELECT DISTINCT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm
                      ) AS tmpProfitLoss ON tmpProfitLoss.MovementItemId = _tmpItem.MovementItemId

       WHERE _tmpItem.ObjectDescId <> zc_Object_InfoMoney()
         AND _tmpItem.OperCountCount <> 0

      UNION ALL
       -- 1.1.3. ����������� �������� ��� ��������������� �����, ContainerId_asset - ������� � ��������
       SELECT 0, zc_MIContainer_CountAsset() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_asset
            , 0                                       AS AccountId              -- ��� �����
            , vbAnalyzerId                            AS AnalyzerId             -- ���� ���������: ������ ��������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
              -- ��������� ��������������� �����
            , _tmpItem.ContainerId_Goods              AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ������������ ���� ���...
            , 0                                       AS ParentId
            , 1 * _tmpItem.OperCount
            , vbOperDate
            , TRUE
       FROM _tmpItem
       WHERE _tmpItem.ContainerId_asset > 0
         AND _tmpItem.ObjectDescId <> zc_Object_InfoMoney()
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
              -- ��������� ���� ��� ��������� ��.���� - ���������������
            , CASE WHEN vbContractId_send > 0 THEN vbContainerId_send ELSE _tmpItemSumm.ContainerId_ProfitLoss END AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ������������ ���� ���...
            , 0                                       AS ParentId
            , -1 * _tmpItemSumm.OperSumm
            , vbOperDate
            , FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId    = _tmpItem.MovementItemId
                             AND _tmpItemSumm.ContainerId_Goods = CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN 0 ELSE _tmpItem.ContainerId_Goods END

      UNION ALL
       -- 1.2.3. ����������� �������� ��� ��������� �����, ContainerId_asset - ������� � ��������
       SELECT 0, zc_MIContainer_SummAsset() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId
            , _tmpItemSumm.ContainerId_asset
            , _tmpItemSumm.AccountId                  AS AccountId              -- ���� ���� ������
            , vbAnalyzerId                            AS AnalyzerId             -- ���� ���������: ������ ��������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
              -- ��������� ��������� ����� / ��� ��� ������, � ContainerId_Goods - �������� ����
            , CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN _tmpItem.ContainerId_Goods ELSE _tmpItemSumm.ContainerId_asset END AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ������������ ���� ���...
            , 0                                       AS ParentId
            , 1 * _tmpItemSumm.OperSumm
            , vbOperDate
            , TRUE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId    = _tmpItem.MovementItemId
                             AND _tmpItemSumm.ContainerId_Goods = CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN 0 ELSE _tmpItem.ContainerId_Goods END
                             AND _tmpItemSumm.ContainerId_asset > 0
      ;


     -- �����, �.�. ��-�� ������� ������ � ����
     -- DELETE FROM MovementItemLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementItemId IN (SELECT MovementItemId FROM _tmpItem);
     -- !!!6.0. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     /*PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, vbBranchId_Unit_ProfitLoss)
     FROM (SELECT _tmpItem.MovementItemId
           FROM _tmpItem
          ) AS tmp;*/


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, inUserId, FALSE)
     FROM (WITH tmpPrice AS (SELECT tmpGoods.GoodsId
                                  , COALESCE (ObjectLink_PriceListItem_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                  , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS OperPrice
                             FROM (SELECT DISTINCT _tmpItem.GoodsId FROM _tmpItem) AS tmpGoods
                                   INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                         ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpGoods.GoodsId
                                                        AND ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                   INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                         ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                        AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                                        AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                   LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                        ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                       AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                                   INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                            ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                           AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                           AND vbOperDate >= ObjectHistory_PriceListItem.StartDate AND vbOperDate < ObjectHistory_PriceListItem.EndDate
                                   LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                               AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                             WHERE ObjectHistoryFloat_PriceListItem_Value.ValueData > 0
                            )
              , tmpAll AS (SELECT _tmpItem.MovementItemId
                                , COALESCE (tmpPrice_1.OperPrice, tmpPrice_2.OperPrice, 0) AS OperPrice
                           FROM _tmpItem
                                LEFT JOIN tmpPrice AS tmpPrice_1 ON tmpPrice_1.GoodsId     = _tmpItem.GoodsId
                                                                AND tmpPrice_1.GoodsKindId = _tmpItem.GoodsKindId
                                LEFT JOIN tmpPrice AS tmpPrice_2 ON tmpPrice_2.GoodsId     = _tmpItem.GoodsId
                                                                AND tmpPrice_2.GoodsKindId = 0
                           WHERE COALESCE (tmpPrice_1.OperPrice, tmpPrice_2.OperPrice, 0) > 0
                          )
           -- ��������� ����
           SELECT lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmpAll.MovementItemId, tmpAll.OperPrice)
                  --
                , tmpAll.MovementItemId
           FROM tmpAll
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = tmpAll.MovementItemId
                                           AND MIFloat_Price.DescId        = zc_MIFloat_Price()
           WHERE COALESCE (MIFloat_Price.ValueData, 0) <> tmpAll.OperPrice
          ) AS tmp;

     -- !!!��������!!!
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= inMovementId);


     -- 6.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();


     -- 6.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := vbMovementDescId
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
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_Loss (inMovementId:= 5869019 , inSession:= zfCalc_UserAdmin())
-- select gpComplete_All_Sybase (28152646, false, '')
