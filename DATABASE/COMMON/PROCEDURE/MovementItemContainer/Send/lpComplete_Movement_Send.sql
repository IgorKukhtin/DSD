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

  DECLARE vbOperDate TDateTime;
  DECLARE vbUnitId_from  Integer;
  DECLARE vbWhereObjectId_Analyzer_From  Integer;
  DECLARE vbWhereObjectId_Analyzer_To    Integer;

  DECLARE vbIsPartionGoodsKind_Unit_From Boolean;
  DECLARE vbIsPartionGoodsKind_Unit_To   Boolean;

  DECLARE vbIsAssetBalance_to  Boolean;
  DECLARE vbIsMember_to        Boolean;
  DECLARE vbIsPartionCell_from Boolean;
  DECLARE vbIsPartionCell_to   Boolean;
  DECLARE vbIsRePack           Boolean;
BEGIN
     -- ��� ��������� ����� ���
     vbMovementDescId:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);
     -- ��� ��������� ����� ���
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- ���� ���� ������� ������� � ��������� � ������ ������ ���-��
     vbIsAssetBalance_to:= COALESCE ('30.01.2021' = (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_SendAsset()), FALSE)
   --AND 1=0
    ;

     -- ���� ���� �� ������� - ������
     IF (vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
        AND zc_Unit_RK() = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
        )
     THEN
         -- ���� ����� ��� �� ����
         vbIsPartionCell_from:= TRUE;
     ELSE
         vbIsPartionCell_from:= FALSE;
     END IF;


     -- ��� �����������
     vbIsMember_to:= EXISTS (SELECT 1 FROM MovementLinkObject AS MLO JOIN Object ON Object.Id = MLO.ObjectId AND Object.DescId = zc_Object_Member() WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());
     vbUnitId_from:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());
     
     
     -- ������� ��� ����������� �����
     vbIsRePack:= EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_isRePack() AND MB.ValueData = TRUE);



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
                         , ContainerDescId, MIContainerId_To, MIContainerId_count_To, ContainerId_GoodsFrom, ContainerId_GoodsTo, ContainerId_countFrom, ContainerId_countTo, ObjectDescId, GoodsId, GoodsKindId, GoodsKindId_to, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate_From, PartionGoodsDate_To
                         , OperCount, OperCountCount
                         , AccountDirectionId_From, AccountDirectionId_To, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , JuridicalId_basis_To, BusinessId_To
                         , StorageId_mi, PartionGoodsId_mi
                         , isPartionCount, isPartionSumm, isPartionDate_From, isPartionDate_To, isPartionGoodsKind_From, isPartionGoodsKind_To
                         , PartionGoodsId_From, PartionGoodsId_To
                         , ProfitLossGroupId, ProfitLossDirectionId, UnitId_ProfitLoss, BranchId_ProfitLoss, BusinessId_ProfitLoss
                         , PartNumber, PartionModelId, isAsset
                         , OperCount_start
                          )
        WITH tmpMember AS (SELECT lfSelect.MemberId, lfSelect.UnitId
                           FROM lfSelect_Object_Member_findPersonal (lfGet_User_Session (inUserId)) AS lfSelect
                           WHERE vbIsMember_to = TRUE
                             AND lfSelect.Ord  = 1
                          )
         -- ��� �����������
       , tmpMI_all AS (SELECT * FROM MovementItem           WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master())
       , tmpMIDate AS (SELECT * FROM MovementItemDate       WHERE MovementItemDate.MovementItemId       IN (SELECT DISTINCT tmpMI_all.Id from tmpMI_all))
      , tmpMIFloat AS (SELECT * FROM MovementItemFloat      WHERE MovementItemFloat.MovementItemId      IN (SELECT DISTINCT tmpMI_all.Id from tmpMI_all))
 , tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id from tmpMI_all))
 , tmpCLO AS (SELECT * FROM ContainerLinkObject WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpMIFloat.ValueData :: Integer FROM tmpMIFloat WHERE tmpMIFloat.DescId = zc_MIFloat_ContainerId() AND vbMovementDescId = zc_Movement_SendAsset() AND tmpMIFloat.ValueData > 0))

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
                              --
                            , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ���������
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                                   WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_30102()) -- �������
                                    AND MILinkObject_GoodsKind.ObjectId <> zc_GoodsKind_Basis()
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                                   -- ����� �������
                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                                    AND MovementLinkObject_From.ObjectId = 8445  -- ����� ���������
                                    AND MovementLinkObject_To.ObjectId  IN (8447    -- ��� ��������� ������
                                                                          , 8449    -- ��� ������������ ������
                                                                          , 8448    -- ĳ������ ���������
                                                                          , 2790412 -- ��� �������
                                                                            --
                                                                          , 8020711 -- ��� ��������� (����)
                                                                          , 8020708 -- ����� ��������� (����)
                                                                          , 8020709 -- ����� ���������� (����)
                                                                          , 8020710 -- ������� ������� ����� (����)
                                                                           )

                                    AND vbOperDate >= '01.01.2024'
                                    AND MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis()

                                        -- �����.
                                        THEN 8338

                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                   ELSE 0
                              END AS GoodsKindId_to

                            , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_complete
                            , CASE WHEN vbMovementDescId = zc_Movement_SendAsset() AND Object_Goods.DescId = zc_Object_Asset() THEN Object_Goods.Id ELSE 0 END AS AssetId
                            , COALESCE (MILinkObject_Storage.ObjectId, 0)    AS StorageId_mi
                            , CASE WHEN MIString_PartionGoods.ValueData = '0'
                                       THEN ''
                                   ELSE COALESCE (MIString_PartionGoods.ValueData, '')
                              END AS PartionGoods

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

                              -- ��� ��
                            , COALESCE (MILinkObject_PartionGoods.ObjectId, 0) AS PartionGoodsId_real


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
                                                 THEN COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, ObjectLink_UnitTo_AccountDirection_two.ChildObjectId)
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

                            , MIString_PartNumber.ValueData                          AS PartNumber
                            , MILinkObject_PartionModel.ObjectId                     AS PartionModelId

                            , CASE -- ��� ����������
                                   WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_20202()
                                    AND COALESCE (MILinkObject_PartionGoods.ObjectId, 0) = 0
                                        THEN TRUE
                                   ELSE COALESCE (ObjectBoolean_Asset.ValueData, FALSE)
                              END AS isAsset

                        FROM Movement
                             JOIN tmpMI_all AS MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

--       , tmpMI_all AS (SELECT * FROM MovementItem           WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master())
--       , tmpMIDate AS (SELECT * FROM MovementItemDate       WHERE MovementItemDate.MovementItemId       IN (SELECT DISTINCT tmpMI_all.Id from tmpMI_all))
--      , tmpMIFloat AS (SELECT * FROM MovementItemFloat      WHERE MovementItemFloat.MovementItemId      IN (SELECT DISTINCT tmpMI_all.Id from tmpMI_all))
--- , tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id from tmpMI_all))

                             LEFT JOIN tmpMILinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             LEFT JOIN tmpMILinkObject AS MILinkObject_GoodsKindComplete
                                                              ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                             LEFT JOIN tmpMILinkObject AS MILinkObject_Storage
                                                              ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
                             LEFT JOIN tmpMILinkObject AS MILinkObject_PartionGoods
                                                              ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()

                             LEFT JOIN tmpMIFloat AS MIFloat_Count
                                                         ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Count.DescId         = zc_MIFloat_Count()

                             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                         AND MIString_PartionGoods.DescId         = zc_MIString_PartionGoods()
                                                         AND MIString_PartionGoods.ValueData      <> '0'
                             LEFT JOIN tmpMIDate AS MIDate_PartionGoods
                                                        ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                             LEFT JOIN tmpMILinkObject AS MILinkObject_PartionModel
                                                              ON MILinkObject_PartionModel.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_PartionModel.DescId = zc_MILinkObject_PartionModel()
                             LEFT JOIN MovementItemString AS MIString_PartNumber
                                                          ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                         AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Asset
                                                     ON ObjectBoolean_Asset.ObjectId = MovementItem.ObjectId
                                                    AND ObjectBoolean_Asset.DescId   = zc_ObjectBoolean_Goods_Asset()

                             LEFT JOIN tmpMIFloat AS MIFloat_ContainerId
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

                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                  ON ObjectLink_Unit_Parent.ObjectId = MovementLinkObject_To.ObjectId
                                                 AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                                                 AND Object_To.DescId = zc_Object_Unit()
                             LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection_two
                                                  ON ObjectLink_UnitTo_AccountDirection_two.ObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                                 AND ObjectLink_UnitTo_AccountDirection_two.DescId   = zc_ObjectLink_Unit_AccountDirection()

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


               -- !!! - 04 - ���� ��� �� - ������ �� ����� + ������ + ������� ������
             , tmp_04 AS (SELECT tmpMI.MovementItemId
                               , Container.Id               AS ContainerId
                               , tmpMI.GoodsId              AS GoodsId
                               , tmpMI.GoodsKindId          AS GoodsKindId
                               , tmpMI.PartionGoodsId_real  AS PartionGoodsId
                               , CASE WHEN tmpMI.PartionGoodsDate_From <> zc_DateStart() THEN tmpMI.PartionGoodsDate_From ELSE COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) END AS PartionGoodsDate
                                 -- !!!���� �������� ����!!!
                               , ROW_NUMBER() OVER (PARTITION BY tmpMI.MovementItemId
                                                    ORDER BY -- ������� ���� ������� ������
                                                             CASE WHEN tmpMI.PartionGoodsId_real = CLO_PartionGoods.ObjectId THEN 0 ELSE 1 END
                                                             -- ���� ���� �������
                                                           , CASE WHEN Container.Amount > 0 THEN 0 ELSE 1 END
                                                             -- ���� zc_PartionCell_RK, ����� � ��������� �������
                                                           , CASE WHEN COALESCE (ObjectLink_PartionCell.ChildObjectId, 0) = zc_PartionCell_RK() THEN 1 ELSE 0 END
                                                   ) AS Ord
                          FROM tmpMI
                               INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.DescId   = zc_Container_Count()
                               INNER JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = Container.Id
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                             AND CLO_Unit.ObjectId    = vbUnitId_from -- (SELECT DISTINCT tmpMI.UnitId_From FROM tmpMI WHERE tmpMI.UnitId_From <> 0)
                               -- !!!
                               LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                             ON CLO_GoodsKind.ContainerId = Container.Id
                                                            AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                             ON CLO_PartionGoods.ContainerId = Container.Id
                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                               LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                       AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                               -- ���� zc_PartionCell_RK, ��������� � ��������� �������
                               LEFT JOIN ObjectLink AS ObjectLink_PartionCell ON ObjectLink_PartionCell.ObjectId      = CLO_PartionGoods.ObjectId
                                                                             AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()

                          WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                               , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                )
                            AND COALESCE (CLO_GoodsKind.ObjectId, 0) = tmpMI.GoodsKindId
                            AND (tmpMI.PartionGoodsDate_From <> zc_DateStart()
                              OR tmpMI.PartionGoodsId_real   <> 0
                                )
                            AND (tmpMI.PartionGoodsDate_From = ObjectDate_Value.ValueData
                              OR tmpMI.PartionGoodsId_real   = CLO_PartionGoods.ObjectId
                                )
                            --!!!
                            AND vbIsPartionCell_from = TRUE
                        )

   -- ������� ������ ��� ����� �������
 , tmpMI_summ AS (-- 1.������������� + ����������
                  SELECT tmpMI.GoodsId, 0 AS GoodsKindId, tmpMI.PartionGoods, SUM (tmpMI.OperCount) AS OperCount
                       , FALSE AS is_30100
                  FROM tmpMI
                  WHERE -- ������ �� ����������� ��
                        tmpMI.ContainerId_asset = 0
                        -- ��� �� ����������
                    AND tmpMI.PartionGoodsId_mi = 0
                        -- ������ ��� �� ������ - ���� - �� �������
                    AND (tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                        , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                        , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����

                                                        , zc_Enum_InfoMoneyDestination_70100() -- ���������� + ����������� ����������
                                                        , zc_Enum_InfoMoneyDestination_70200() -- ���������� + ����������� ������
                                                        , zc_Enum_InfoMoneyDestination_70300() -- ���������� + ������������ ����������
                                                        , zc_Enum_InfoMoneyDestination_70400() -- ���������� + ����������� �������������
                                                        , zc_Enum_InfoMoneyDestination_70500() -- ���������� + ���
                                                         )
                      -- ��� ����� ����� - ������ �� ��� zc_Object_Asset
                      OR tmpMI.isAsset = TRUE
                        )

                  GROUP BY tmpMI.GoodsId, tmpMI.PartionGoods

                 UNION ALL
                  -- !!! 2.���� - ������ �� ����� + ������
                  SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, '' AS PartionGoods, SUM (tmpMI.OperCount) AS OperCount
                       , TRUE AS is_30100
                  FROM tmpMI
                       -- ������ ���� ������ �� �����
                       LEFT JOIN tmp_04 ON tmp_04.MovementItemId = tmpMI.MovementItemId
                  WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                       , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                        )
                    --!!!
                    AND vbIsPartionCell_from = TRUE
                    -- ������ ���� ������ �� �����
                    AND tmp_04.MovementItemId IS NULL

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
                                                    AND Container.DescId   = zc_Container_Count()
                                                  -- ��� �����������
                                                  --AND Container.Amount   > 0
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                              AND CLO_Unit.ObjectId    = vbUnitId_from -- (SELECT DISTINCT tmpMI.UnitId_From FROM tmpMI WHERE tmpMI.UnitId_From <> 0)
                                -- !!!
                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = Container.Id
                                                             AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                        AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                                                                       AND Object_PartionGoods.ValueData <> '0'
                           WHERE vbIsPartionCell_from = FALSE

                          UNION
                           -- 2. ��� zc_ContainerLinkObject_Member
                           SELECT tmpMI.GoodsId                                         AS GoodsId
                                , 0                                                     AS GoodsKindId
                                , Container.Id                                          AS ContainerId
                                , Container.Amount                                      AS Amount
                                , COALESCE (CLO_PartionGoods.ObjectId, 0)               AS PartionGoodsId
                                , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                                , COALESCE (Object_PartionGoods.ValueData, '')          AS PartionGoods
                           FROM tmpMI_summ AS tmpMI
                                INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                    AND Container.DescId   = zc_Container_Count()
                                                  -- ��� �����������
                                                  --AND Container.Amount   > 0
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
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id        = CLO_PartionGoods.ObjectId
                                                                       AND Object_PartionGoods.ValueData <> '0'
                           WHERE vbIsPartionCell_from = FALSE

                          UNION
                           -- 3. ��� zc_ContainerLinkObject_Car
                           SELECT tmpMI.GoodsId                                         AS GoodsId
                                , 0                                                     AS GoodsKindId
                                , Container.Id                                          AS ContainerId
                                , Container.Amount                                      AS Amount
                                , COALESCE (CLO_PartionGoods.ObjectId, 0)               AS PartionGoodsId
                                , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                                , COALESCE (Object_PartionGoods.ValueData, '')          AS PartionGoods
                           FROM tmpMI_summ AS tmpMI
                                INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                    AND Container.DescId   = zc_Container_Count()
                                                  -- ��� �����������
                                                  --AND Container.Amount   > 0
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
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id        = CLO_PartionGoods.ObjectId
                                                                       AND Object_PartionGoods.ValueData <> '0'
                           WHERE vbIsPartionCell_from = FALSE
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
                                                             AND CLO_Unit.ObjectId    = vbUnitId_from -- (SELECT DISTINCT tmpMI.UnitId_From FROM tmpMI WHERE tmpMI.UnitId_From <> 0)
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
                                                             AND CLO_Unit.ObjectId    = vbUnitId_from -- (SELECT DISTINCT tmpMI.UnitId_From FROM tmpMI WHERE tmpMI.UnitId_From <> 0)
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

     -- ������ ���� ������ � ����������� PartionGoods � ������
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
                                , COALESCE (tmp_04.PartionGoodsDate, zc_DateStart()) AS PartionGoodsDate
                                , tmpMI.OperCount  AS Amount
                                , COALESCE (tmp_04.ContainerId, tmpContainer_list.ContainerId) AS ContainerId
                              --, tmpContainer_list.Amount AS Amount_container
                                , COALESCE (tmp_04.PartionGoodsId, tmpContainer_list.PartionGoodsId) AS PartionGoodsId
                                  -- !!!�� ������ ������!!!
                                , ROW_NUMBER() OVER (PARTITION BY tmpMI.MovementItemId ORDER BY tmpContainer_list.ContainerId ASC) AS Ord
                           FROM tmpMI
                                LEFT JOIN tmpContainer_list ON tmpContainer_list.GoodsId      = tmpMI.GoodsId
                                                           AND tmpContainer_list.PartionGoods = tmpMI.PartionGoods
                                                           AND tmpContainer_list.Amount       > 0
                                -- ������ ����������� - ��� ��
                                LEFT JOIN tmp_04 ON tmp_04.MovementItemId = tmpMI.MovementItemId
                                                 -- !!!������ ����!!!
                                                AND tmp_04.Ord = 1

                           -- ������ �����������
                           WHERE tmpMI.PartionGoods <> ''

                              -- ������ ����������� ��� �� + RK
                              OR tmp_04.MovementItemId > 0
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

                             /*UNION ALL
                                -- �������� ������ �� 1 ����
                                SELECT tmpContainer_list.ContainerId
                                     , tmpContainer_list.GoodsId
                                     , SUM (MIContainer.Amount) AS Amount_rem
                                FROM tmpContainer_list
                                     INNER JOIN MovementItemContainer AS MIContainer
                                                                      ON MIContainer.ContainerId = tmpContainer_list.ContainerId
                                                                     AND MIContainer.OperDate    = vbOperDate
                                                                     AND MIContainer.Amount      > 0
                                -- ������ ���� ������ ���
                                WHERE tmpContainer_list.PartionGoods = ''
                                GROUP BY tmpContainer_list.ContainerId, tmpContainer_list.GoodsId*/

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
                                                            , CASE WHEN tmpContainer_rem.Amount_rem > 0 THEN Container.ContainerId ELSE 0 END DESC
                                                              --
                                                            , COALESCE (tmpContainer_rem.Amount_rem, 0) DESC
                                                              --
                                                            , CASE WHEN Container.PartionGoods = ''
                                                                        THEN 0
                                                                   WHEN Container.PartionGoods ILIKE '��%' THEN 2
                                                                   ELSE 1
                                                              END ASC
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
                                                            , CASE WHEN tmpContainer_rem.Amount_rem > 0 THEN Container.ContainerId ELSE 0 END ASC
                                                              -- ��������
                                                            , COALESCE (tmpContainer_rem.Amount_rem, 0) ASC
                                                              -- ��������
                                                            , CASE WHEN Container.PartionGoods = ''
                                                                        THEN 0
                                                                   WHEN Container.PartionGoods ILIKE '��%' THEN 2
                                                                   ELSE 1
                                                              END DESC
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
                            -- ������ ���� ������ �� �����
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
            , CASE WHEN vbMovementDescId = zc_Movement_SendAsset() THEN _tmp.ContainerId_asset ELSE COALESCE (tmpContainer_find.ContainerId, tmpContainer.ContainerId, 0) END AS ContainerId_GoodsFrom
            , 0 AS ContainerId_GoodsTo
            , 0 AS ContainerId_countFrom
            , 0 AS ContainerId_countTo

            , _tmp.ObjectDescId
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.GoodsKindId_to
            , _tmp.GoodsKindId_complete
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate_From
            , _tmp.PartionGoodsDate_To

              -- !!!��� ������ ������!!!
            , COALESCE (tmpContainer_find.Amount, tmpContainer.Amount, _tmp.OperCount) AS OperCount

            , CASE WHEN COALESCE (tmpContainer.Ord, 1) = 1 THEN _tmp.OperCountCount ELSE 0 END AS OperCountCount
-- , (select Amount from tmpContainer where GoodsId = 5810441 and ord= 1 ) AS OperCountCount
-- , (select OperCount_start from _tmpItem where GoodsId = 645529 ) AS OperCountCount

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
-- , (select count(*) from _tmpItem where _tmpItem.GoodsId = 7981) as StorageId_mi

              -- !!!��� ������ ������!!!
            , COALESCE (tmpContainer_find.PartionGoodsId, tmpContainer.PartionGoodsId, 0) AS PartionGoodsId_mi

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
                   -- ����� ����� - ��
                   WHEN _tmp.isAsset = TRUE AND COALESCE (tmpContainer_find.PartionGoodsId, tmpContainer.PartionGoodsId) > 0
                        THEN COALESCE (tmpContainer_find.PartionGoodsId, tmpContainer.PartionGoodsId)
                   -- !!! ���� - ������ �� ����� + ������
                   WHEN vbIsPartionCell_from = TRUE AND tmpContainer.PartionGoodsId > 0
                        THEN tmpContainer.PartionGoodsId

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

            , _tmp.PartNumber
            , _tmp.PartionModelId
            , _tmp.isAsset

            , _tmp.OperCount AS OperCount_start

        FROM tmpMI AS _tmp
             -- ����� - ���� ������ �������
             LEFT JOIN tmpContainer_find  ON tmpContainer_find.MovementItemId     = _tmp.MovementItemId
                                         -- !!!�� ������ ������!!!
                                         AND tmpContainer_find.Ord                = 1

             -- ������ ����������� ������
             LEFT JOIN tmpContainer       ON tmpContainer.MovementItemId          = _tmp.MovementItemId
                                         -- ��� � �������������
                                         AND tmpContainer_find.MovementItemId      IS NULL
                                       --AND _tmp.InfoMoneyId <> zc_Enum_InfoMoney_20202() -- ����������
             -- ������ ������� ��� asset
             LEFT JOIN tmpContainer_asset ON tmpContainer_asset.ContainerId_asset = _tmp.ContainerId_asset
                                         AND tmpContainer_asset.Ord               = 1

             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                             ON View_InfoMoney.InfoMoneyId = tmpContainer_asset.InfoMoneyId
       ;


if inUserId IN (5, zc_Enum_Process_Auto_PrimeCost()) and 1=0
then
    RAISE EXCEPTION ' %  %  %'
                  , (select MAX (_tmpItem.ContainerId_GoodsFrom) from _tmpItem where _tmpItem.GoodsId = 645529)
                  , (select count(*) from _tmpItem where _tmpItem.GoodsId = 645529)
                  , (select OperCountCount from _tmpItem limit 1)
  ;

end if;


IF 1=0
THEN
-- , (select CLO_PartionGoods.ObjectId from ContainerLinkObject AS CLO_PartionGoods where CLO_PartionGoods.ContainerId = Container.ContainerId AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()) as PartionGoodsId

    RAISE EXCEPTION '������. <%>'
, (select 'ContainerId_GoodsFrom = ' || coalesce (_tmpItem.ContainerId_GoodsFrom ::TVarChar , '') || ' - PartionGoodsId_From = ' || coalesce (_tmpItem.PartionGoodsId_From ::TVarChar , '') || ' - CLO_PartionGoods.ObjectId = ' || coalesce (CLO_PartionGoods.ObjectId ::TVarChar , 'NULL') || ' - GoodsId = ' || coalesce (_tmpItem.GoodsId ::TVarChar , '') || ' - ' || coalesce (_tmpItem.OperCount ::TVarChar , '')  || ' - ' || coalesce (_tmpItem.OperCountCount ::TVarChar , '')
   from _tmpItem
        LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                      ON CLO_PartionGoods.ContainerId = _tmpItem.ContainerId_GoodsFrom
                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
   WHERE _tmpItem.MovementItemId = 290396121
  )
;
end if;



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
                               ) AS tmpItem_start
                          GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                         ) AS tmpItem_start
                         FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId, SUM (_tmpItem.OperCount) AS OperCount
                                    FROM _tmpItem
                                    WHERE _tmpItem.ContainerId_GoodsFrom > 0
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
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
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
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
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
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
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
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
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
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
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


-- IF inUserId = 5 AND 1=0
/*IF inMovementId = 26666487   AND 1=1
THEN
    RAISE EXCEPTION '������ - 1.<%>  %   %  %   %'
    , (select _tmpItem.OperCount from _tmpItem where _tmpItem.MovementItemId = 273318373  )
    , (select _tmpItem.OperCount from _tmpItem where _tmpItem.MovementItemId = 273318373  )
    , (select _tmpItem.ContainerId_GoodsFrom from _tmpItem where _tmpItem.MovementItemId = 273318373  )
    , (select _tmpItem.ContainerId_GoodsFrom from _tmpItem where _tmpItem.MovementItemId = 273318373  )
    , (select max (_tmpItem.StorageId_mi) from _tmpItem where _tmpItem.GoodsId = 6836  )
    ;
end if;
*/

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


     -- !!!
     vbIsPartionCell_to:= FALSE;

     -- ���� ���� �� ������� - ������
     IF (vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
     AND vbWhereObjectId_Analyzer_To = zc_Unit_RK()
        )
     THEN
         -- ���� ����� ��� ����
         vbIsPartionCell_to := TRUE;

         -- 1.0. ����� ������ �� ������� - ������
         INSERT INTO _tmpItem_PartionCell (MovementItemId, MIContainerId_To, ContainerId_GoodsFrom, ContainerId_GoodsTo
                                         , PartionCellId, DescId_PartionCell
                                         , PartionGoodsDate_From, PartionGoodsDate_To
                                         , OperCount
                                         , PartionGoodsId_From, PartionGoodsId_To
                                         , Ord
                                          )
            WITH tmpItem_new AS (SELECT _tmpItem.MovementItemId
                                        -- ������ ��������
                                      , CASE WHEN vbIsRePack = TRUE THEN zc_PartionCell_RK()             ELSE 0 END  AS PartionCellId -- COALESCE (MILO.ObjectId, zc_PartionCell_RK())
                                      , CASE WHEN vbIsRePack = TRUE THEN zc_MILinkObject_PartionCell_1() ELSE 0 END  AS DescId_PartionCell -- COALESCE (MILO.DescId, zc_MILinkObject_PartionCell_1())
                                        -- ���� ������
                                      , _tmpItem.PartionGoodsDate_To
                                        --
                                      , _tmpItem.OperCount
                                        -- � �/�
                                      , ROW_NUMBER() OVER (PARTITION BY _tmpItem.MovementItemId ORDER BY MILO.ObjectId ASC) AS Ord
                                 FROM _tmpItem
                                      LEFT JOIN MovementItemLinkObject AS MILO
                                                                       ON MILO.MovementItemId = _tmpItem.MovementItemId
                                                                      AND MILO.ObjectId       > 0
                                                                      AND MILO.DescId         IN (zc_MILinkObject_PartionCell_1()
                                                                                                , zc_MILinkObject_PartionCell_2()
                                                                                                , zc_MILinkObject_PartionCell_3()
                                                                                                , zc_MILinkObject_PartionCell_4()
                                                                                                , zc_MILinkObject_PartionCell_5()
                                                                                                , zc_MILinkObject_PartionCell_6()
                                                                                                , zc_MILinkObject_PartionCell_7()
                                                                                                , zc_MILinkObject_PartionCell_8()
                                                                                                , zc_MILinkObject_PartionCell_9()
                                                                                                , zc_MILinkObject_PartionCell_10()
                                                                                                , zc_MILinkObject_PartionCell_11()
                                                                                                , zc_MILinkObject_PartionCell_12()
                                                                                                , zc_MILinkObject_PartionCell_13()
                                                                                                , zc_MILinkObject_PartionCell_14()
                                                                                                , zc_MILinkObject_PartionCell_15()
                                                                                                , zc_MILinkObject_PartionCell_16()
                                                                                                , zc_MILinkObject_PartionCell_17()
                                                                                                , zc_MILinkObject_PartionCell_18()
                                                                                                , zc_MILinkObject_PartionCell_19()
                                                                                                , zc_MILinkObject_PartionCell_20()
                                                                                                , zc_MILinkObject_PartionCell_21()
                                                                                                , zc_MILinkObject_PartionCell_22()
                                                                                                 )
                                                                      -- !!!��������!!!
                                                                      AND 1=0
                                 WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- ����
                                                                         , zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                          )
                                )
                 -- ����� max ��� ���������
             /*, tmpItem_max AS (SELECT tmpItem_new.MovementItemId
                                        -- � �/�
                                      , MAX (tmpItem_new.Ord) AS Ord
                                 FROM tmpItem_new
                                 GROUP BY tmpItem_new.MovementItemId
                                )*/
                 -- ������������ ���-��
               , tmpItem_res AS (SELECT tmpItem_new.MovementItemId
                                      , tmpItem_new.PartionCellId
                                      , tmpItem_new.DescId_PartionCell
                                      , tmpItem_new.PartionGoodsDate_To
                                        -- ������������ ����������
                                      -- , CAST (tmpItem_new.OperCount / tmpItem_max.Ord AS NUMERIC (16,2)) AS OperCount
                                      , tmpItem_new.OperCount AS OperCount
                                        -- �������� ���-��
                                      , tmpItem_new.OperCount AS OperCount_total
                                        -- � �/�
                                      , tmpItem_new.Ord
                                 FROM tmpItem_new
                                      -- INNER JOIN tmpItem_max ON tmpItem_max.MovementItemId = tmpItem_new.MovementItemId
                                )
            --
            SELECT tmpItem_res.MovementItemId
                 , 0 AS MIContainerId_To, 0 AS ContainerId_GoodsFrom, 0 AS ContainerId_GoodsTo
                   -- ������ ��������
                 , tmpItem_res.PartionCellId
                 , tmpItem_res.DescId_PartionCell
                   -- ���� ������ - �� ����
                 , NULL AS PartionGoodsDate_From
                   -- ���� ������ - ����
                 , tmpItem_res.PartionGoodsDate_To
                   -- ���-�� - ��������� �� �����������, ���� ����
                 , tmpItem_res.OperCount /*- CASE WHEN tmpItem_res.Ord = 1 THEN COALESCE (tmpItem_sum.OperCount, 0) - tmpItem_res.OperCount_total ELSE 0 END*/ AS OperCount
                   --
                 , 0 AS PartionGoodsId_From, 0 AS PartionGoodsId_To
                   -- � �/�
                 , tmpItem_res.Ord
            FROM tmpItem_res
                 -- ����� ������� ��������� ����� �������������
                 /*LEFT JOIN (SELECT tmpItem_res.MovementItemId, SUM (tmpItem_res.OperCount) AS OperCount FROM tmpItem_res GROUP BY tmpItem_res.MovementItemId
                           ) AS tmpItem_sum
                             ON tmpItem_sum.MovementItemId = tmpItem_res.MovementItemId
                            -- ������ ��� � �/� = 1
                            AND tmpItem_res.Ord            = 1*/
           ;

         --  1.1. - ����������� ������ ������ ��� Master(������)-��������, ����� ����� - ��
         UPDATE _tmpItem_PartionCell SET PartionGoodsId_To = lpInsertFind_Object_PartionGoods (inOperDate             := CASE WHEN COALESCE (_tmpItem_PartionCell.PartionGoodsDate_To, zc_DateEnd()) = zc_DateEnd()
                                                                                                                                   THEN vbOperDate
                                                                                                                              ELSE _tmpItem_PartionCell.PartionGoodsDate_To
                                                                                                                         END
                                                                                               -- ����������� ��������, �.�. ����� ��������� ������������ � ������ ����
                                                                                             , inGoodsKindId_complete := NULL
                                                                                               -- ������
                                                                                             , inPartionCellId        := _tmpItem_PartionCell.PartionCellId
                                                                                              )
        ;

         --  1.2. - ����������� ContainerId
         UPDATE _tmpItem_PartionCell SET ContainerId_GoodsTo = lpInsertUpdate_ContainerCount_Goods
                                                                 (inOperDate               := _tmpItem.OperDate
                                                                , inUnitId                 := _tmpItem.UnitId_To
                                                                , inCarId                  := _tmpItem.CarId_To
                                                                , inMemberId               := _tmpItem.MemberId_To
                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                , inPartionGoodsId         := _tmpItem_PartionCell.PartionGoodsId_To
                                                                , inAssetId                := _tmpItem.AssetId
                                                                , inBranchId               := _tmpItem.BranchId_To
                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                 )

         FROM _tmpItem
         WHERE _tmpItem_PartionCell.MovementItemId = _tmpItem.MovementItemId
        ;

         -- 1.10. - ��������� ��-��
         PERFORM lpInsertUpdate_MovementItemFloat (tmpItem_desc.DescId, tmpItem_desc.MovementItemId, COALESCE (_tmpItem_PartionCell.OperCount, 0))
         FROM (SELECT _tmpItem.MovementItemId, tmpDesc.DescId, tmpDesc.DescId_link
               FROM _tmpItem
                    CROSS JOIN (SELECT zc_MIFloat_PartionCell_Amount_1() AS DescId, zc_MILinkObject_PartionCell_1() AS DescId_link
                               UNION
                                SELECT zc_MIFloat_PartionCell_Amount_2() AS DescId, zc_MILinkObject_PartionCell_2() AS DescId_link
                               UNION
                                SELECT zc_MIFloat_PartionCell_Amount_3() AS DescId, zc_MILinkObject_PartionCell_3() AS DescId_link
                               UNION
                                SELECT zc_MIFloat_PartionCell_Amount_4() AS DescId, zc_MILinkObject_PartionCell_4() AS DescId_link
                               UNION
                                SELECT zc_MIFloat_PartionCell_Amount_5() AS DescId, zc_MILinkObject_PartionCell_5() AS DescId_link
                               ) AS tmpDesc
              ) AS tmpItem_desc
              LEFT JOIN _tmpItem_PartionCell
                          ON tmpItem_desc.DescId_link    = _tmpItem_PartionCell.DescId_PartionCell
                         AND tmpItem_desc.MovementItemId = _tmpItem_PartionCell.MovementItemId
                        ;

     -- ���� ���� �� ������� - ������
     ELSEIF lfGet_Object_Unit_isPartionCell (vbOperDate, vbWhereObjectId_Analyzer_From) = TRUE
        OR (vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
        AND vbWhereObjectId_Analyzer_From = zc_Unit_RK()
           )
     THEN
         -- ���� ����� ��� �� ����
         vbIsPartionCell_from:= TRUE;

         -- ������ ������ ��� ���� �� ������� - ������

     END IF;


     --  �1.1. - ����������� ������ ������ ��� Master(������)-��������, ����� ����� - ��
     UPDATE _tmpItem SET PartionGoodsId_To = lpInsertFind_Object_PartionGoods (inUnitId_Partion := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem.PartionGoodsId_From AND OL.DescId  = zc_ObjectLink_PartionGoods_Unit())
                                                                             , inGoodsId        := _tmpItem.GoodsId
                                                                             , inStorageId      := CASE WHEN _tmpItem.StorageId_mi > 0 THEN _tmpItem.StorageId_mi ELSE 10123304 END -- �� ����������
                                                                             , inPartionModelId := _tmpItem.PartionModelId
                                                                             , inInvNumber      := _tmpItem.PartionGoods
                                                                             , inPartNumber      := _tmpItem.PartNumber
                                                                             , inOperDate       := (SELECT OD.ValueData  FROM ObjectDate  AS OD  WHERE OD.ObjectId  = _tmpItem.PartionGoodsId_From AND OD.DescId  = zc_ObjectDate_PartionGoods_Value())
                                                                             , inPrice          := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = _tmpItem.PartionGoodsId_From AND OFl.DescId = zc_ObjectFloat_PartionGoods_Price())
                                                                              )
     WHERE _tmpItem.isAsset = TRUE AND (_tmpItem.PartionGoods <> '' OR _tmpItem.PartNumber <> '') -- AND _tmpItem.StorageId_mi <> 0
     --AND 1=0
    ;

     -- �1.2. - ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId_From = CASE -- ��� �������� �� ������� - �� ����
                                                    WHEN vbIsPartionCell_from = TRUE AND _tmpItem.PartionGoodsId_From > 0 -- EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.MovementItemId = _tmpItem.MovementItemId)
                                                         -- !!!��������, ��� ������ ������
                                                         THEN _tmpItem.PartionGoodsId_From

                                                    -- ���������� + PartionGoodsId_asset
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
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ������������� + ����
                                                                                           , zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                           , zc_Enum_InfoMoneyDestination_30200()  -- ������ + ������ �����
                                                                                            )
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem.PartionGoodsDate_From
                                                                                             , inGoodsKindId_complete := _tmpItem.GoodsKindId_complete
                                                                                              )
                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ������������� + ����
                                                                                           , zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                           , zc_Enum_InfoMoneyDestination_30200()  -- ������ + ������ �����
                                                                                            )
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
                         , PartionGoodsId_To = CASE -- ��� �������� �� ������� - ����
                                                    WHEN vbIsPartionCell_to = TRUE AND EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.MovementItemId = _tmpItem.MovementItemId)
                                                         -- !!!���������, ������ � ������ ����
                                                         THEN 0

                                                    -- �� - ������ ������, �.�. ����� ���������� StorageId
                                                    WHEN _tmpItem.PartionGoodsId_From > 0 AND vbMovementDescId = zc_Movement_SendAsset()
                                                         THEN lpInsertFind_Object_PartionGoods
                                                                                        (inMovementId     := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = _tmpItem.PartionGoodsId_From)
                                                                                       , inGoodsId        := _tmpItem.GoodsId
                                                                                       , inUnitId         := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem.PartionGoodsId_From AND OL.DescId  = zc_ObjectLink_PartionGoods_Unit())
                                                                                       , inStorageId      := _tmpItem.StorageId_mi
                                                                                       , inInvNumber      := (SELECT Object.ValueData FROM Object WHERE Object.Id = _tmpItem.PartionGoodsId_From)
                                                                                        )

                                                    -- ������ - ��
                                                    WHEN _tmpItem.isAsset = TRUE
                                                         AND (_tmpItem.MemberId_To > 0
                                                          AND _tmpItem.StorageId_mi <> 0
                                                          AND (SELECT Object.ValueData FROM Object WHERE Object.Id = _tmpItem.PartionGoodsId_mi AND Object.ValueData <> '' AND Object.ValueData <> '0') <> ''
                                                          AND (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = _tmpItem.PartionGoodsId_mi AND OS.DescId = zc_ObjectString_PartionGoods_PartNumber() AND OS.ValueData <> '') <> ''
                                                             )
                                                         THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion := COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem.PartionGoodsId_mi AND OL.DescId  = zc_ObjectLink_PartionGoods_Unit()), -1 * 0) -- _tmpItem.PartionGoodsId_mi
                                                                                              , inGoodsId        := _tmpItem.GoodsId
                                                                                              , inStorageId      := CASE WHEN COALESCE (_tmpItem.StorageId_mi, 0) = 0 AND inUserId = zc_Enum_Process_Auto_PrimeCost() THEN 9569212 ELSE _tmpItem.StorageId_mi END
                                                                                              , inPartionModelId := _tmpItem.PartionModelId
                                                                                              , inInvNumber      := COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = _tmpItem.PartionGoodsId_mi AND Object.ValueData <> '' AND Object.ValueData <> '0'), _tmpItem.PartionGoods)
                                                                                              , inPartNumber     := COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = _tmpItem.PartionGoodsId_mi AND OS.DescId = zc_ObjectString_PartionGoods_PartNumber() AND OS.ValueData <> ''), _tmpItem.PartNumber)
                                                                                              , inOperDate       := (SELECT OD.ValueData  FROM ObjectDate  AS OD  WHERE OD.ObjectId  = _tmpItem.PartionGoodsId_mi AND OD.DescId  = zc_ObjectDate_PartionGoods_Value())
                                                                                              , inPrice          := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = _tmpItem.PartionGoodsId_mi AND OFl.DescId = zc_ObjectFloat_PartionGoods_Price())
                                                                                               )
                                                    -- ����� ������ �� - ��� �� ����
                                                    WHEN _tmpItem.PartionGoodsId_To > 0
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
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ������������� + ����
                                                                                           , zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                           , zc_Enum_InfoMoneyDestination_30200()  -- ������ + ������ �����
                                                                                            )
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem.PartionGoodsDate_To
                                                                                             , inGoodsKindId_complete := _tmpItem.GoodsKindId_complete
                                                                                              )
                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ������������� + ����
                                                                                           , zc_Enum_InfoMoneyDestination_30100()  -- ������ + ���������
                                                                                           , zc_Enum_InfoMoneyDestination_30200()  -- ������ + ������ �����
                                                                                            )
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
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
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
       -- �� ��� �������� �� ������� - �� ����
       AND (vbIsPartionCell_from = FALSE OR NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.MovementItemId = _tmpItem.MovementItemId))
    ;

     -- �2.2. - ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId_To = _tmpItem.PartionGoodsId_From
     WHERE _tmpItem.PartionGoodsId_From > 0
       AND _tmpItem.PartionGoodsId_To   = 0
       AND _tmpItem.PartionGoods <> ''
       AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
       -- �� ��� �������� �� ������� - ����
       AND (vbIsPartionCell_to = FALSE OR NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.MovementItemId = _tmpItem.MovementItemId))
    ;



 if inMovementId = 26731021 AND 1=0
 then
    RAISE EXCEPTION '<%>  %   <%>  % ',
     (select distinct _tmpItem.PartionGoodsId_From from _tmpItem where _tmpItem.MovementItemId = 273960538 )
    , (select _tmpItem.PartionGoods from _tmpItem where _tmpItem.MovementItemId = 273960538 )
    , (select distinct _tmpItem.PartionGoodsId_From from _tmpItem where _tmpItem.MovementItemId = 273960537  )
    , (select _tmpItem.PartionGoods from _tmpItem where _tmpItem.MovementItemId = 273960537  )
    ;

 end if;


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
        -- !����������!
        AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
        AND 1=0
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

--    RAISE EXCEPTION '������.<%>', (select distinct lfGet_Object_ValueData_sh(_tmpItem.GoodsKindId_to) from _tmpItem);



     -- 1.1.1. ������������ ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_GoodsFrom = CASE -- ��� �������� �� ������� - �� ����
                                                      WHEN vbIsPartionCell_from = TRUE AND _tmpItem.ContainerId_GoodsFrom > 0
                                                           -- !!!��������, ��� ������ ������
                                                           THEN _tmpItem.ContainerId_GoodsFrom

                                                      WHEN _tmpItem.ContainerId_GoodsFrom > 0 THEN _tmpItem.ContainerId_GoodsFrom
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
                       , ContainerId_GoodsTo   = CASE -- ��� �������� �� ������� - ����
                                                      WHEN vbIsPartionCell_to = TRUE AND EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.MovementItemId = _tmpItem.MovementItemId)
                                                           -- !!!���������, ������ � ������ ����
                                                           THEN 0

                                                      WHEN _tmpItem.ContainerDescId = zc_Container_CountAsset() AND vbIsAssetBalance_to = FALSE
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

                                                                                                                       -- ������ �����
                                                                                                                       WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                                                                            -- ����� �������
                                                                                                                            THEN _tmpItem.GoodsKindId_to

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
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerDescId, MIContainerId_To, ContainerId_GoodsTo, ContainerId_To, AccountId_To, ContainerId_ProfitLoss, ContainerId_GoodsFrom, ContainerId_From, AccountId_From, InfoMoneyId_Detail_From, OperSumm)
       --
       WITH -- ��� ���� ��������� �/� � ����� ����� �������������� ����
            tmpHistoryCost_find_all AS (SELECT _tmpItem.ContainerId_GoodsFrom
                                             , _tmpItem.GoodsId
                                             , _tmpItem.GoodsKindId
                                             , Container_Summ.Id               AS ContainerId_Summ
                                             , Container_Summ.ObjectId         AS AccountId
                                             , COALESCE (HistoryCost.Price, 0) AS Price
                                        FROM _tmpItem
                                             INNER JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_GoodsFrom
                                                                                   AND Container_Summ.DescId   = zc_Container_Summ()
                                             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                                        WHERE vbIsPartionCell_from = TRUE
                                       )
                -- ����� �/� ���� ��� ��� ContainerId_Goods
              , tmpHistoryCost_find AS (SELECT Container_Summ.ContainerId_GoodsFrom
                                             , Container_Summ.ContainerId_Summ
                                             , MAX (HistoryCost.Price) AS Price
                                        FROM -- ����� � ����� ContainerId_GoodsFrom ��� ���� = 0
                                             (SELECT tmpHistoryCost_find_all.ContainerId_GoodsFrom FROM tmpHistoryCost_find_all
                                              GROUP BY tmpHistoryCost_find_all.ContainerId_GoodsFrom
                                              HAVING MAX (tmpHistoryCost_find_all.Price) = 0
                                             ) AS tmpHistoryCost_list
                                             -- ��� ���� ContainerId_Summ ���� ����� �������������� ����
                                             JOIN tmpHistoryCost_find_all AS Container_Summ ON Container_Summ.ContainerId_GoodsFrom = tmpHistoryCost_list.ContainerId_GoodsFrom

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
                                                                           AND CLO_Unit_new.ObjectId    = vbWhereObjectId_Analyzer_From

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
                                        GROUP BY Container_Summ.ContainerId_GoodsFrom
                                               , Container_Summ.ContainerId_Summ
                                  )
        -- ���������
        SELECT
              _tmpItem.MovementItemId
            , zc_Container_Summ() AS ContainerDescId
            , 0 AS MIContainerId_To
              -- ���� �����
            , COALESCE (_tmpItem_PartionCell_to.ContainerId_GoodsTo, 0) AS ContainerId_GoodsTo
              --
            , 0 AS ContainerId_To
            , 0 AS AccountId_To
            , 0 AS ContainerId_ProfitLoss
            , COALESCE (_tmpItem_PartionCell_from.ContainerId_GoodsFrom, _tmpItem.ContainerId_GoodsFrom) AS ContainerId_GoodsFrom
            , Container_Summ.Id AS ContainerId_From
            , Container_Summ.ObjectId AS AccountId_From
            , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
              -- �������� ���-��
            , SUM (CAST (COALESCE (_tmpItem_PartionCell_from.OperCount, _tmpItem_PartionCell_to.OperCount, _tmpItem.OperCount) * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4)) -- ABS
                 /*+ CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                             THEN HistoryCost.Summ_diff -- !!!���� ���� "�����������" ��� ����������, �������� �����!!!
                        ELSE 0
                   END*/) AS OperSumm
        FROM _tmpItem
             -- ��� �������� �� ������� - �� ����
             LEFT JOIN _tmpItem_PartionCell AS _tmpItem_PartionCell_from
                                            ON _tmpItem_PartionCell_from.MovementItemId = _tmpItem.MovementItemId
                                           AND vbIsPartionCell_from                     = TRUE

             -- ��� �������� �� ������� - ����
             LEFT JOIN _tmpItem_PartionCell AS _tmpItem_PartionCell_to
                                            ON _tmpItem_PartionCell_to.MovementItemId = _tmpItem.MovementItemId
                                           AND vbIsPartionCell_to                     = TRUE

             JOIN Container AS Container_Summ ON Container_Summ.ParentId = COALESCE (_tmpItem_PartionCell_from.ContainerId_GoodsFrom, _tmpItem.ContainerId_GoodsFrom)
                                             AND Container_Summ.DescId   = zc_Container_Summ()
             JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                      ON ContainerLinkObject_InfoMoneyDetail.ContainerId = Container_Summ.Id
                                     AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = Container_Summ.Id
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id -- ContainerObjectCost_Basis.ObjectCostId
                                  AND _tmpItem.OperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate

             -- ����� �/� ���� ��� ��� ContainerId_GoodsFrom
             LEFT JOIN tmpHistoryCost_find ON tmpHistoryCost_find.ContainerId_Summ = Container_Summ.Id
                                          AND HistoryCost.ContainerId IS NULL

        WHERE /*zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND (ContainerLinkObject_InfoMoneyDetail.ObjectId = 0 OR zc_isHistoryCost_byInfoMoneyDetail()= TRUE)
          -- AND (inIsLastComplete = FALSE OR (_tmpItem.OperCount * HistoryCost.Price) <> 0) -- !!!�����������!!! ��������� ���� ���� ��� �� ��������� ��� (��� ����� ��� ������� �/�)
          AND*/ (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0)) <> 0 -- !!!��!!! ��������� ����
          AND _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
          AND vbIsHistoryCost= TRUE -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
        GROUP BY _tmpItem.MovementItemId
               , COALESCE (_tmpItem_PartionCell_from.ContainerId_GoodsFrom, _tmpItem.ContainerId_GoodsFrom)
                 -- ���� �����
               , COALESCE (_tmpItem_PartionCell_to.ContainerId_GoodsTo, 0)

               , Container_Summ.Id
               , Container_Summ.ObjectId
               , ContainerLinkObject_InfoMoneyDetail.ObjectId
       UNION ALL
        -- ���� � ���������
        SELECT
              _tmpItem.MovementItemId
            , zc_Container_SummAsset() AS ContainerDescId
            , 0 AS MIContainerId_To
            , 0 AS ContainerId_GoodsTo
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
          -- ��� �������� �� ������� - �� ����
          LEFT JOIN _tmpItem_PartionCell ON _tmpItem_PartionCell.MovementItemId = _tmpItem.MovementItemId
                                        AND vbIsPartionCell_from                = TRUE
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
       AND _tmpItemSumm.ContainerId_GoodsFrom = COALESCE (_tmpItem_PartionCell.ContainerId_GoodsFrom, _tmpItem.ContainerId_GoodsFrom)
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
                                                                                , inContainerId_Goods      := -- ���������� ������ �� �������
                                                                                                              COALESCE (_tmpItem_PartionCell_to.ContainerId_GoodsTo, _tmpItem.ContainerId_GoodsTo)

                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := CASE WHEN vbIsPartionGoodsKind_Unit_To = FALSE
                                                                                                                    -- ������ �����
                                                                                                                    AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                                                                        THEN 0

                                                                                                                   -- ������ �����
                                                                                                                   WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                                                                        -- ����� �������
                                                                                                                        THEN _tmpItem.GoodsKindId_to

                                                                                                                   ELSE _tmpItem.GoodsKindId
                                                                                                              END
                                                                                , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                , inPartionGoodsId         := -- ���������� ������ �� �������
                                                                                                              COALESCE (_tmpItem_PartionCell_to.PartionGoodsId_To, _tmpItem.PartionGoodsId_To)

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
     FROM _tmpItemSumm AS _tmpItemSumm_find
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm_find.MovementItemId
          -- ��� �������� �� ������� - ����
          LEFT JOIN _tmpItem_PartionCell AS _tmpItem_PartionCell_to
                                         ON _tmpItem_PartionCell_to.MovementItemId      = _tmpItem.MovementItemId
                                        AND _tmpItem_PartionCell_to.ContainerId_GoodsTo = _tmpItemSumm_find.ContainerId_GoodsTo
                                        AND vbIsPartionCell_to                          = TRUE
     WHERE _tmpItemSumm.MovementItemId        = _tmpItemSumm_find.MovementItemId
       -- ���������� ������ �� �������
       AND _tmpItemSumm.ContainerId_GoodsTo   = _tmpItemSumm_find.ContainerId_GoodsTo

       AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItemSumm_find.ContainerId_GoodsFrom
       AND _tmpItemSumm.ContainerId_From      = _tmpItemSumm_find.ContainerId_From
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

                                                                                , inContainerId             := -- ���������� ������ �� �������
                                                                                                               COALESCE (_tmpItem_PartionCell_to.ContainerId_GoodsTo, _tmpItem.ContainerId_GoodsTo)

                                                                                , inAccountId               := 0                              -- ��� �����
                                                                                , inAnalyzerId              := vbWhereObjectId_Analyzer_From  -- ��� ���������, �� ��� ��������� ������� ����� ������������ "�� ����" ���...
                                                                                , inObjectId_Analyzer       := _tmpItem.GoodsId               -- �����
                                                                                , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- ������������ ���...
                                                                                , inContainerId_Analyzer    := CASE WHEN _tmpItem.ProfitLossGroupId > 0 THEN (SELECT _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId LIMIT 1) ELSE 0 END -- ��������� ���� - ������ ����
                                                                                , inObjectIntId_Analyzer    := _tmpItem.GoodsKindId           -- ��� ������
                                                                                , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From  -- ������������ "�� ����"
                                                                                , inContainerIntId_Analyzer := _tmpItem.ContainerId_GoodsFrom -- �������������� ���������-������������� (�.�. �� �������)

                                                                                , inAmount                  := -- ���������� ������ �� �������
                                                                                                               COALESCE (_tmpItem_PartionCell_to.OperCount, _tmpItem.OperCount)

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
                                                                                 ) END
     FROM _tmpItem AS _tmpItem_find
          -- ��� �������� �� ������� - ����
          LEFT JOIN _tmpItem_PartionCell AS _tmpItem_PartionCell_to
                                         ON _tmpItem_PartionCell_to.MovementItemId = _tmpItem_find.MovementItemId
                                        AND vbIsPartionCell_to                     = TRUE
     WHERE _tmpItem.MovementItemId        = _tmpItem_find.MovementItemId
       AND _tmpItem.ContainerId_GoodsFrom = _tmpItem_find.ContainerId_GoodsFrom
    ;

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
            , COALESCE (_tmpItem_PartionCell_from.ContainerId_GoodsFrom, _tmpItem.ContainerId_GoodsFrom)
            , 0                                       AS AccountId               -- ��� �����
            , vbWhereObjectId_Analyzer_To             AS AnalyzerId              -- ��� ���������, �� ��� ��������� ������� ����� ������������ "����" ���...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer       -- �����
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer  -- ������������ ���...
            , CASE WHEN _tmpItem.ProfitLossGroupId > 0 THEN (SELECT _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId LIMIT 1) ELSE 0 END AS ContainerId_Analyzer -- ��������� ���� - ������ ����
            , _tmpItem.ContainerId_GoodsTo            AS ContainerIntId_Analyzer -- �������������� ���������-������������� (�.�. �� �������)
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer    -- ��� ������
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer    -- ������������ "����"
            , _tmpItem.MIContainerId_To               AS ParentId
            , -1 * COALESCE (_tmpItem_PartionCell_from.OperCount, _tmpItem.OperCount)
            , _tmpItem.OperDate
            , FALSE
       FROM _tmpItem
            -- ��� �������� �� ������� - �� ����
            LEFT JOIN _tmpItem_PartionCell AS _tmpItem_PartionCell_from
                                           ON _tmpItem_PartionCell_from.MovementItemId = _tmpItem.MovementItemId
                                          AND vbIsPartionCell_from                     = TRUE

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
                                                                                    , inDescId                  := CASE WHEN _tmpItemSumm.ContainerDescId = zc_Container_SummAsset()
                                                                                                                             THEN zc_MIContainer_SummAsset()
                                                                                                                        ELSE zc_MIContainer_Summ()
                                                                                                                   END
                                                                                    , inMovementDescId          := vbMovementDescId
                                                                                    , inMovementId              := MovementId
                                                                                    , inMovementItemId          := _tmpItem.MovementItemId
                                                                                    , inParentId                := NULL
                                                                                    , inContainerId             := _tmpItemSumm.ContainerId_To
                                                                                    , inAccountId               := _tmpItemSumm.AccountId_To      -- ���� ���� ������
                                                                                    , inAnalyzerId              := CASE WHEN _tmpItem.ProfitLossGroupId <> 0 THEN zc_Enum_AnalyzerId_ProfitLoss() ELSE vbWhereObjectId_Analyzer_From END  -- "������" ���� ���������, �� ��� ��������� ������� ����� ������������ "�� ����" ���...
                                                                                    , inObjectId_Analyzer       := _tmpItem.GoodsId               -- �����
                                                                                    , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- ������������ ���...
                                                                                    , inContainerId_Analyzer    := _tmpItemSumm.ContainerId_ProfitLoss -- ��������� ���� - ������ ����
                                                                                    , inObjectIntId_Analyzer    := _tmpItem.GoodsKindId           -- ��� ������
                                                                                    , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From  -- ������������ "�� ����"
                                                                                    , inContainerIntId_Analyzer := _tmpItemSumm.ContainerId_From  -- �������� ���������-������������� (�.�. �� �������)
                                                                                    , inAmount                  := OperSumm
                                                                                    , inOperDate                := OperDate
                                                                                    , inIsActive                := TRUE
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

     -- �������� - 3 - ������ ������
     IF (vbIsPartionCell_from = TRUE OR vbIsPartionCell_to = TRUE)
        AND inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer)
        AND EXISTS (SELECT MIContainer.MovementItemId, MIContainer.DescId FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = inMovementId AND MIContainer.DescId IN (zc_MIContainer_Count(), zc_MIContainer_Summ()) GROUP BY MIContainer.MovementItemId, MIContainer.DescId HAVING SUM (MIContainer.Amount) <> 0)
     THEN
         RAISE EXCEPTION '������.������ ������.% % � <%> �� <%> %����� = <%> %��� = <%> %���-�� = <%> %����� = <%> %������� = <%> %Id = <%>'
                       , CHR (13)
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                       , CHR (13)
                         -- GoodsId
                       , (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId)
                          FROM _tmpItem
                          WHERE _tmpItem.MovementItemId IN (SELECT MIContainer.MovementItemId FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = inMovementId AND MIContainer.DescId IN (zc_MIContainer_Count(), zc_MIContainer_Summ()) GROUP BY MIContainer.MovementItemId, MIContainer.DescId HAVING SUM (MIContainer.Amount) <> 0)
                          ORDER BY _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                          LIMIT 1
                         )
                       , CHR (13)
                         -- GoodsKindId
                       , (SELECT lfGet_Object_ValueData_sh (_tmpItem.GoodsKindId)
                          FROM _tmpItem
                          WHERE _tmpItem.MovementItemId IN (SELECT MIContainer.MovementItemId FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = inMovementId AND MIContainer.DescId IN (zc_MIContainer_Count(), zc_MIContainer_Summ()) GROUP BY MIContainer.MovementItemId, MIContainer.DescId HAVING SUM (MIContainer.Amount) <> 0)
                          ORDER BY _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                          LIMIT 1
                         )
                       , CHR (13)
                         -- 1.1. OperCount
                       , (SELECT zfConvert_FloatToString (SUM (CASE WHEN MIContainer_2.Amount < 0 THEN MIContainer_2.Amount ELSE 0 END))
                   || ' and ' || zfConvert_FloatToString (SUM (CASE WHEN MIContainer_2.Amount > 0 THEN MIContainer_2.Amount ELSE 0 END))
                          FROM MovementItemContainer AS MIContainer_2
                          WHERE MIContainer_2.MovementId = inMovementId
                            AND MIContainer_2.DescId     = zc_MIContainer_Count()
                            AND MIContainer_2.MovementItemId IN (SELECT MIContainer.MovementItemId FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = inMovementId AND MIContainer.DescId IN (zc_MIContainer_Count(), zc_MIContainer_Summ()) GROUP BY MIContainer.MovementItemId, MIContainer.DescId HAVING SUM (MIContainer.Amount) <> 0)
                          GROUP BY MIContainer_2.MovementItemId
                          ORDER BY MIContainer_2.MovementItemId
                          LIMIT 1
                         )
                       , CHR (13)
                         -- 1.2. OperSumm
                       , (SELECT zfConvert_FloatToString (SUM (CASE WHEN MIContainer_2.Amount < 0 THEN MIContainer_2.Amount ELSE 0 END))
                   || ' and ' || zfConvert_FloatToString (SUM (CASE WHEN MIContainer_2.Amount > 0 THEN MIContainer_2.Amount ELSE 0 END))
                          FROM MovementItemContainer AS MIContainer_2
                          WHERE MIContainer_2.MovementId = inMovementId
                            AND MIContainer_2.DescId     = zc_MIContainer_Summ()
                            AND MIContainer_2.MovementItemId IN (SELECT MIContainer.MovementItemId FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = inMovementId AND MIContainer.DescId IN (zc_MIContainer_Count(), zc_MIContainer_Summ()) GROUP BY MIContainer.MovementItemId, MIContainer.DescId HAVING SUM (MIContainer.Amount) <> 0)
                          GROUP BY MIContainer_2.MovementItemId
                          ORDER BY MIContainer_2.MovementItemId
                          LIMIT 1
                         )
                       , CHR (13)
                         -- diff
                       , (SELECT zfConvert_FloatToString (SUM (CASE WHEN MIContainer_2.DescId = zc_MIContainer_Count() THEN MIContainer_2.Amount ELSE 0 END))
                   || ' and ' || zfConvert_FloatToString (SUM (CASE WHEN MIContainer_2.Amount = zc_MIContainer_Summ()  THEN MIContainer_2.Amount ELSE 0 END))
                          FROM MovementItemContainer AS MIContainer_2
                          WHERE MIContainer_2.MovementId = inMovementId
                            AND MIContainer_2.DescId     IN (zc_MIContainer_Count(), zc_MIContainer_Summ())
                            AND MIContainer_2.MovementItemId IN (SELECT MIContainer.MovementItemId FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = inMovementId AND MIContainer.DescId IN (zc_MIContainer_Count(), zc_MIContainer_Summ()) GROUP BY MIContainer.MovementItemId, MIContainer.DescId HAVING SUM (MIContainer.Amount) <> 0)
                          GROUP BY MIContainer_2.MovementItemId
                          ORDER BY MIContainer_2.MovementItemId
                          LIMIT 1
                         )
                       , CHR (13)
                         -- Id
                       , (SELECT MIContainer_2.MovementItemId
                          FROM MovementItemContainer AS MIContainer_2
                          WHERE MIContainer_2.MovementId = inMovementId
                            AND MIContainer_2.DescId     IN (zc_MIContainer_Count(), zc_MIContainer_Summ())
                            AND MIContainer_2.MovementItemId IN (SELECT MIContainer.MovementItemId FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = inMovementId AND MIContainer.DescId IN (zc_MIContainer_Count(), zc_MIContainer_Summ()) GROUP BY MIContainer.MovementItemId, MIContainer.DescId HAVING SUM (MIContainer.Amount) <> 0)
                          ORDER BY MIContainer_2.MovementItemId
                          LIMIT 1
                         )
                        ;
     END IF;


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


     -- ���� ������ ���������� ����� ��������� ������
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
WITH
tmpMov AS (SELECT Movement.Id
           FROM Movement
           WHERE Movement.Operdate BETWEEN  '18.04.2023' and '25.04.2023'
             AND Movement.DescId = zc_Movement_Send()
           )

, tmpProtocol AS (SELECT tmp.OperDate
                       , tmp.UserId
                       , tmp.MovementId
                       , ROW_NUMBER() OVER (PARTITION BY tmp.MovementId ORDER BY tmp.Id) AS ord
                  FROM
                 (SELECT * from MovementProtocol
                  WHERE MovementProtocol.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                    AND MovementProtocol.ProtocolData ilike '%FieldValue = "��������"%'
                union
                  SELECT * from MovementProtocol_arc
                  WHERE MovementProtocol_arc.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                    AND MovementProtocol_arc.ProtocolData ilike '%FieldValue = "��������"%'
                  ) AS tmp
                 )

SELECT tmpProtocol.MovementId
    , tmpProtocol.OperDate
    , tmpProtocol.UserId
FROM tmpProtocol
WHERE tmpProtocol.Ord = 1
) AS tmp

*/
-- select lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), 312833261 , '08.01.2025'); 
-- select lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), 312833261 , '');

-- select lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), 312833261 , null); 
-- select lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), 312833261 , '08.01.2025');

-- select * from MovementItemContainer where MovementItemId =312833261 and DescId = 1
-- SELECT * FROM Movement where Id = 30202848
-- SELECT gpComplete_All_Sybase (30202848, false, '')
