-- Function: lpComplete_Movement_TransportService (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_TransportService (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_TransportService(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, PersonalId_From Integer, UnitId Integer, BranchId_Unit Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, JuridicalId_basis Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionMovementId Integer, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbIsAccount_50000 Boolean;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;

     -- !!!�����������!!! �������� ������� - �������� ������ ��� ������������� ������ �� ���������
     DELETE FROM _tmpMI_Sale;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

     -- ����������� ������ - �������� ������ ��� ������������� ������ �� ���������
     WITH -- ������ �������
          tmpReestr AS
                     (SELECT MovementItem.Id AS MI_Id
                      FROM MovementLinkMovement AS MLM_Transport
                           JOIN Movement ON Movement.Id       = MLM_Transport.MovementId
                                        AND Movement.DescId   = zc_Movement_Reestr()
                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                      WHERE MLM_Transport.DescId          = zc_MovementLinkMovement_Transport()
                        AND MLM_Transport.MovementChildId = inMovementId
                     )
          -- ��������� ������� - �������� ����� � ������� ���������
        , tmpMF_MovementItemId AS (SELECT MovementFloat_MovementItemId.MovementId AS MovementId_sale
                                   FROM MovementFloat AS MovementFloat_MovementItemId
                                   WHERE MovementFloat_MovementItemId.ValueData IN (SELECT DISTINCT tmpReestr.MI_Id FROM tmpReestr)
                                     AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                  )
          -- ��������� ������� - ������
        , tmpMI_sale_all AS (SELECT tmpSale.MovementId_sale AS MovementId_sale
                                  , MovementItem.Id         AS MI_Id_sale
                                  , MovementItem.ObjectId   AS GoodsId
                             FROM (SELECT DISTINCT tmpMF_MovementItemId.MovementId_sale FROM tmpMF_MovementItemId) AS tmpSale
                                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpSale.MovementId_Sale
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = FALSE
                            )
          --
        , tmpMLO_To AS (SELECT *
                        FROM MovementLinkObject AS MovementLinkObject_To
                        WHERE MovementLinkObject_To.MovementId IN (SELECT DISTINCT tmpMF_MovementItemId.MovementId_sale FROM tmpMF_MovementItemId)
                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                        )
         --
       , tmpMILO_GoodsKind AS (SELECT *
                               FROM MovementItemLinkObject
                               WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_sale_all.MI_Id_sale FROM tmpMI_sale_all)
                                 AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                              )
         --
       , tmpMIF_AmountPartner AS (SELECT *
                                  FROM MovementItemFloat AS MIFloat_AmountPartner
                                  WHERE MIFloat_AmountPartner.MovementItemId IN (SELECT DISTINCT tmpMI_sale_all.MI_Id_sale FROM tmpMI_sale_all)
                                    AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                  )
              -- ��������� ������� - ������
            , tmpMI_sale AS (SELECT tmpMI_sale_all.MI_Id_sale                           AS MI_Id_sale
                                  , MovementLinkObject_To.ObjectId                      AS PartnerId
                                  , tmpMI_sale_all.GoodsId                              AS GoodsId
                                  , MILinkObject_GoodsKind.ObjectId                     AS GoodsKindId
                                  , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS Amount
                                  , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                       * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0)
                                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1
                                              ELSE 0
                                         END) ::TFloat AS AmountWeight
                             FROM tmpMI_sale_all
                                  LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = tmpMI_sale_all.MI_Id_sale
                                  LEFT JOIN tmpMIF_AmountPartner AS MIFloat_AmountPartner
                                                                 ON MIFloat_AmountPartner.MovementItemId = tmpMI_sale_all.MI_Id_sale
                                  -- ����������
                                  LEFT JOIN tmpMLO_To AS MovementLinkObject_To
                                                      ON MovementLinkObject_To.MovementId = tmpMI_sale_all.MovementId_sale
                                  --
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                       ON ObjectLink_Goods_Measure.ObjectId = tmpMI_sale_all.GoodsId
                                                      AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                        ON ObjectFloat_Weight.ObjectId = tmpMI_sale_all.GoodsId
                                                       AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                             GROUP BY tmpMI_sale_all.MI_Id_sale
                                    , MovementLinkObject_To.ObjectId
                                    , tmpMI_sale_all.GoodsId
                                    , MILinkObject_GoodsKind.ObjectId
                            )
     -- ���������
     INSERT INTO _tmpMI_Sale (MI_Id_sale, PartnerId, GoodsId, GoodsKindId, Amount, AmountWeight)
        SELECT tmpMI_sale.MI_Id_sale, tmpMI_sale.PartnerId, tmpMI_sale.GoodsId, tmpMI_sale.GoodsKindId, tmpMI_sale.Amount, tmpMI_sale.AmountWeight
        FROM tmpMI_sale
        WHERE tmpMI_sale.AmountWeight > 0
       ;


     -- 1.1. ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , AnalyzerId, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                         , IsActive, IsMaster
                          )
        -- 1.1.
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , -1 * MovementItem.Amount AS OperSumm
             , MovementItem.Id AS MovementItemId

             , 0 AS ContainerId                                                     -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- ���������� �����, ��� ...
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- �� ������������

               -- �������������� ������ ����������
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- �������������� ����������
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- �������������� ������ ����������
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

               -- ������ ������: �� ������������
             , 0  AS BusinessId_Balance
               -- ������ ����: ������ �� �������������� �������� � ������������� (����� �� ������������, ������������ � ��������� ��������)
             , COALESCE (ObjectLink_UnitRoute_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- ������� ��.���� ������ �� �������� (� �� �� ������������� - ����� ��������)
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

               -- ������������ (����) (����� �� ������������, ������������ � ��������� ��������)
             , CASE -- ���� ������ = "�����", ����� ������� �� �������������� �������� � �������������, �.�. ��� ����(�+��), ���������, �����, ������.
                    WHEN ObjectLink_UnitRoute_Branch.ChildObjectId IS NULL
                         THEN COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)

                    -- ���� "�����������" �������, ����� ������� �� �������������� �������� � �������������, �.�. ��� ������� - ������������ ����� "���������� ��������"
                    WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                         THEN COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0) -- ������� �� �������������� �������� � �������������

                    -- ���� ������� "�� ������" � ��� ���� ������, ����� ������� ������ �� ������ - ������������ ����� "���������� ����������"
                    WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  <> ObjectLink_Route_Branch.ChildObjectId AND ObjectLink_Route_Branch.ChildObjectId > 0
                         THEN COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)

                    ELSE MovementLinkObject_UnitForwarding.ObjectId -- ����� ������������� (����� ��������)

               END AS UnitId

             , 0 AS PositionId -- �� ������������

               -- ������ ������: �� "����� ��������" (����� ��� ��� ������)
             , COALESCE (ObjectLink_UnitForwarding_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId_Balance
               -- ������ ����: �� ������������
             , 0 AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
             , COALESCE (MILinkObject_PaidKind.ObjectId, 0) AS PaidKindId

             , zc_Enum_AnalyzerId_ProfitLoss() AS AnalyzerId            -- ���� ���������, �.�. �� ��� ��������� � ����
             , MILinkObject_Car.ObjectId       AS ObjectIntId_Analyzer  -- ���������� !!!��� ������������ �������� ������ � UnitId!!!

               -- ������ (����), � ����� ���� BranchId_Route
             , CASE -- ���� "�����������" �������, ����� ������� �� �������������� �������� � �������������, �.�. ��� ������� - ������������ ����� "���������� ��������"
                    WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                         THEN COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0) -- ������� �� �������������� ������� -> ������������� -> ������

                    -- ���� ������� "�� ������" � ��� ���� ������, ����� ������� ������ �� ������ - ������������ ����� "���������� ����������"
                    WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  <> ObjectLink_Route_Branch.ChildObjectId AND ObjectLink_Route_Branch.ChildObjectId > 0
                         THEN COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)

                    ELSE 0 -- ����� ������� ��� �������������� � �������

               END AS ObjectExtId_Analyzer

             , FALSE AS IsActive
             , TRUE AS IsMaster
        FROM Movement
             JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                              ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                              ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Car.DescId = zc_MILinkObject_Car()

             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

             -- ��������� ��� ������ ��������
             LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                          ON MovementLinkObject_UnitForwarding.MovementId = inMovementId
                                         AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
             LEFT JOIN ObjectLink AS ObjectLink_UnitForwarding_Branch
                                  ON ObjectLink_UnitForwarding_Branch.ObjectId = MovementLinkObject_UnitForwarding.ObjectId
                                 AND ObjectLink_UnitForwarding_Branch.DescId = zc_ObjectLink_Unit_Branch()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                              ON MILinkObject_Route.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
             LEFT JOIN ObjectLink AS ObjectLink_Route_Branch
                                  ON ObjectLink_Route_Branch.ObjectId = MILinkObject_Route.ObjectId
                                 AND ObjectLink_Route_Branch.DescId = zc_ObjectLink_Route_Branch()
             LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                  ON ObjectLink_Route_Unit.ObjectId = MILinkObject_Route.ObjectId
                                 AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
             LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Branch
                                  ON ObjectLink_UnitRoute_Branch.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                 AND ObjectLink_UnitRoute_Branch.DescId = zc_ObjectLink_Unit_Branch()
             LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Business
                                  ON ObjectLink_UnitRoute_Business.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                 AND ObjectLink_UnitRoute_Business.DescId = zc_ObjectLink_Unit_Business()

        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_TransportService()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;

     -- 1.2. ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , AnalyzerId, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                         , IsActive, IsMaster
                          )
       SELECT MovementDescId, OperDate, ObjectId, ObjectDescId
            , -1 * MIFloat_SummAdd.ValueData AS OperSumm
            , _tmpItem.MovementItemId
            , ContainerId
            , AccountGroupId, AccountDirectionId, AccountId
            , ProfitLossGroupId, ProfitLossDirectionId
            , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
            , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
            , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
            , zc_Enum_AnalyzerId_Transport_Add() AS AnalyzerId
            , ObjectIntId_Analyzer, ObjectExtId_Analyzer
            , IsActive, IsMaster
       FROM _tmpItem
            INNER JOIN MovementItemFloat AS MIFloat_SummAdd
                                         ON MIFloat_SummAdd.MovementItemId = _tmpItem.MovementItemId
                                        AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
                                        AND MIFloat_SummAdd.ValueData <> 0
      ;


     -- ��������
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 OR _tmpItem.ObjectDescId <> zc_Object_Juridical())
     THEN
         RAISE EXCEPTION '������.� ��������� �� ���������� <����������� ����>.���������� ����������.';
     END IF;
     -- ��������
     IF EXISTS (SELECT _tmpItem.ContractId FROM _tmpItem WHERE _tmpItem.ContractId = 0)
     THEN
         RAISE EXCEPTION '������.� ��������� �� ��������� <�������>.���������� ����������.';
     END IF;
     -- ��������
     IF EXISTS (SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.InfoMoneyId = 0)
     THEN
         RAISE EXCEPTION '������.� ��������� �� ���������� <�� ������ ����������>.���������� ����������.';
     END IF;
     -- ��������
     IF EXISTS (SELECT _tmpItem.PaidKindId FROM _tmpItem WHERE _tmpItem.PaidKindId = 0)
     THEN
         RAISE EXCEPTION '������.� ��������� �� ���������� <����� ������>. ���������� ����������.';
     END IF;
     -- ��������
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION '������.� <��������> �� ����������� <������� ����������� ����>.���������� ����������.';
     END IF;


     -- 2.0. !!!�����������!!! - ���� ��� ������� ������� ��������
     vbIsAccount_50000:= EXISTS (SELECT 1
                                 FROM MovementFloat
                                      INNER JOIN Movement ON Movement.Id       = MovementFloat.MovementId
                                                         AND Movement.DescId   = zc_Movement_IncomeCost()
                                                      -- AND Movement.StatusId = zc_Enum_Status_Complete()
                                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 WHERE MovementFloat.ValueData = inMovementId
                                   AND MovementFloat.DescId    = zc_MovementFloat_MovementId()
                                );

     -- 2. ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , AnalyzerId, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_analyzer
                         , IsActive, IsMaster
                          )
       WITH -- ����� ���
            tmpMI_Sale_total AS (SELECT SUM (_tmpMI_Sale.AmountWeight) AS AmountWeight FROM _tmpMI_Sale)
            -- ������������
          , tmpItem_goods AS (SELECT _tmpItem.MovementItemId
                                   , _tmpItem.AnalyzerId
                                   , _tmpMI_Sale.MI_Id_sale
                                   , _tmpMI_Sale.PartnerId
                                   , _tmpMI_Sale.GoodsId
                                   , _tmpMI_Sale.GoodsKindId
                                   , CAST (_tmpItem.OperSumm * _tmpMI_Sale.AmountWeight / tmpMI_Sale_total.AmountWeight AS NUMERIC (16, 4)) AS OperSumm
                                     -- � �/�
                                   , ROW_NUMBER() OVER (PARTITION BY _tmpItem.MovementItemId, _tmpItem.AnalyzerId ORDER BY _tmpMI_Sale.AmountWeight DESC) AS Ord
                              FROM _tmpItem
                                   JOIN tmpMI_Sale_total ON tmpMI_Sale_total.AmountWeight > 0
                                   CROSS JOIN _tmpMI_Sale
                              WHERE vbIsAccount_50000 = FALSE
                             )
            -- ����� ������������
          , tmpItem_goods_sum AS (SELECT tmpItem_goods.MovementItemId
                                       , tmpItem_goods.AnalyzerId
                                       , SUM (tmpItem_goods.OperSumm) AS OperSumm
                                  FROM tmpItem_goods
                                  GROUP BY tmpItem_goods.MovementItemId
                                       , tmpItem_goods.AnalyzerId
                                 )
        -- 2.1.
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
               -- !!!������� ������� �������� ��� ����� ����!!!
             , CASE WHEN vbIsAccount_50000 = TRUE THEN lpInsertFind_Object_PartionMovement (inMovementId:= inMovementId, inPaymentDate:= _tmpItem.OperDate) ELSE 0 END AS ObjectId
               -- !!!������� ������� �������� ��� ����� ����!!!
             , CASE WHEN vbIsAccount_50000 = TRUE THEN zc_Object_PartionMovement() ELSE 0 END AS ObjectDescId
             , -1 * SUM (COALESCE (tmpItem_goods.OperSumm, _tmpItem.OperSumm)
                         -- ������������ �� ������� ����������
                       - CASE WHEN tmpItem_goods.Ord = 1 THEN tmpItem_goods_sum.OperSumm - _tmpItem.OperSumm ELSE 0 END
                        ) AS OperSumm
             , _tmpItem.MovementItemId
               -- ���������� �����
             , 0 AS ContainerId
               -- ������� ������� �������� ��� ...
             , CASE WHEN vbIsAccount_50000 = TRUE THEN zc_Enum_AccountGroup_50000() ELSE 0 END AS AccountGroupId
               -- ������� ������� �������� - ��������� �� ������� ��� ...
             , CASE WHEN vbIsAccount_50000 = TRUE THEN zc_Enum_AccountDirection_50300() ELSE 0 END AS AccountDirectionId
               -- ���������� �����
             , 0 AS AccountId

               -- ������ ���� (��� ������)
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
               -- ��������� ���� - ����������� (��� ������)
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId

               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyGroupId
               -- �������������� ����������
             , _tmpItem.InfoMoneyDestinationId
               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyId

               -- ������ ������: �� ������������ (� �� �� ���������� ��������)
             , 0 AS BusinessId_Balance
               -- ������ ����: ������ �� �������������� �������� � �������������
             , _tmpItem.BusinessId_ProfitLoss

               -- ������� ��.���� ������ �� ��������
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId -- ������������ (����), � ����� ���� UnitId_Route
             , 0 AS PositionId -- �� ������������

               -- ������ ������: �� ������������ (� �� �� ���������� ��������)
             , 0 AS BranchId_Balance
               -- ������ ����:
             , _tmpItem.ObjectExtId_Analyzer AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , 0 AS ContractId -- �� ������������
             , 0 AS PaidKindId -- �� ������������

             , 0 AS AnalyzerId -- � ���� �� ������ ���������, �.�. ����������� ������� �������� �� AnalyzerId <> 0
             , _tmpItem.ObjectIntId_Analyzer          AS ObjectIntId_Analyzer     -- ���������� !!!��� ������������ �������� ������ � UnitId!!!
             , _tmpItem.ObjectExtId_Analyzer          AS ObjectExtId_Analyzer     -- ������ (����), � ����� ���� BranchId_Route
             , COALESCE (tmpItem_goods.MI_Id_sale, 0) AS ContainerIntId_Analyzer  -- MI_Id_sale � ��������� ��� � ���� �� �����

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection
                    ON lfObject_Unit_byProfitLossDirection.UnitId = _tmpItem.UnitId
                   AND vbIsAccount_50000 = FALSE
             -- ���������� + �����
             LEFT JOIN tmpItem_goods ON tmpItem_goods.MovementItemId = _tmpItem.MovementItemId
                                    AND tmpItem_goods.AnalyzerId     = _tmpItem.AnalyzerId
             -- ����� ������������
             LEFT JOIN tmpItem_goods_sum ON tmpItem_goods_sum.MovementItemId = _tmpItem.MovementItemId
                                        AND tmpItem_goods_sum.AnalyzerId     = _tmpItem.AnalyzerId

             -- ���� �� ���������������
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                              ON MILinkObject_Route.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Route.DescId         = zc_MILinkObject_Route()
             LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                  ON ObjectLink_Route_Unit.ObjectId = MILinkObject_Route.ObjectId
                                 AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
             -- ���������������
             LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Contract
                                  ON ObjectLink_UnitRoute_Contract.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                 AND ObjectLink_UnitRoute_Contract.DescId   = zc_ObjectLink_Unit_Contract()

        -- !!!���� �� ���������������!!!
        WHERE ObjectLink_UnitRoute_Contract.ChildObjectId IS NULL

        GROUP BY _tmpItem.MovementDescId
               , _tmpItem.OperDate
               , _tmpItem.MovementItemId

                 -- ������ ���� (��� ������)
               , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0)
                 -- ��������� ���� - ����������� (��� ������)
               , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0)

                 -- �������������� ������ ����������
               , _tmpItem.InfoMoneyGroupId
                 -- �������������� ����������
               , _tmpItem.InfoMoneyDestinationId
                 -- �������������� ������ ����������
               , _tmpItem.InfoMoneyId

                 -- ������ ����: ������ �� �������������� �������� � �������������
               , _tmpItem.BusinessId_ProfitLoss

                 -- ������� ��.���� ������ �� ��������
               , _tmpItem.JuridicalId_Basis

               , _tmpItem.UnitId -- ������������ (����), � ����� ���� UnitId_Route

                 -- ������ ����:
               , _tmpItem.ObjectExtId_Analyzer

               , _tmpItem.ObjectIntId_Analyzer           -- ���������� !!!��� ������������ �������� ������ � UnitId!!!
               , _tmpItem.ObjectExtId_Analyzer           -- ������ (����), � ����� ���� BranchId_Route
               , COALESCE (tmpItem_goods.MI_Id_sale, 0)  -- MI_Id_sale � ��������� ��� � ���� �� �����

               , _tmpItem.IsActive
               , _tmpItem.IsMaster

       UNION ALL
        -- 2.2. ��������������� ������ �� �� ����
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId

             , -1 * _tmpItem.OperSumm AS OperSumm

             , _tmpItem.MovementItemId
               -- ���������� �����
             , 0 AS ContainerId

             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- ���������� �����

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId             -- �� ������������

               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyGroupId
               -- �������������� ����������
             , _tmpItem.InfoMoneyDestinationId
               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyId

               -- ������ ������: �� ������������
             , 0 AS BusinessId_Balance
               -- ������ ����: �� ������������
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.���� ������ �� ��������
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , 0 AS UnitId     -- �� ������������
             , 0 AS PositionId -- �� ������������

               -- ������ ������: ������ "������� ������" (����� ��� ��� ������)
             , zc_Branch_Basis() AS BranchId_Balance
               -- ������ ����: ����� �� ������������
             , 0 AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , 0 AS ContractId -- �� ������������
             , 0 AS PaidKindId -- �� ������������

             , 0 AS AnalyzerId -- �� ������������
             , _tmpItem.ObjectIntId_Analyzer          AS ObjectIntId_Analyzer     -- ���������� !!!��� ������������ �������� ������ � UnitId!!!
             , 0 AS ObjectExtId_Analyzer    -- �� ������������
             , 0 AS ContainerIntId_Analyzer -- �� ������������

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             -- ���� �� ���������������
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                              ON MILinkObject_Route.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Route.DescId         = zc_MILinkObject_Route()
             LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                  ON ObjectLink_Route_Unit.ObjectId = MILinkObject_Route.ObjectId
                                 AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
             -- ���������������
             LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Contract
                                  ON ObjectLink_UnitRoute_Contract.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                 AND ObjectLink_UnitRoute_Contract.DescId   = zc_ObjectLink_Unit_Contract()

             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_UnitRoute_Contract.ChildObjectId
                                                                  AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_UnitRoute_Contract.ChildObjectId
                                                                 AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_UnitRoute_Contract.ChildObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object ON Object.Id = ObjectLink_Contract_Juridical.ChildObjectId

        -- !!!���� ���������������!!!
        WHERE ObjectLink_UnitRoute_Contract.ChildObjectId > 0
       ;


     -- !!!5.0. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     /*PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_UnitRoute(), tmp.MovementItemId, tmp.UnitId_Route)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BranchRoute(), tmp.MovementItemId, tmp.BranchId_Route)
     FROM (SELECT _tmpItem.MovementItemId
                , COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0) AS UnitId_Route
                , COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0) AS BranchId_Route
           FROM _tmpItem
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                 ON MILinkObject_Route.MovementItemId = _tmpItem.MovementItemId
                                                AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                     ON ObjectLink_Route_Unit.ObjectId = MILinkObject_Route.ObjectId
                                    AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
                LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Branch
                                     ON ObjectLink_UnitRoute_Branch.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                    AND ObjectLink_UnitRoute_Branch.DescId = zc_ObjectLink_Unit_Branch()
           WHERE _tmpItem.ObjectDescId = 0 OR _tmpItem.AccountId = zc_Enum_Account_100301() -- 100301; "������� �������� �������"
          ) AS tmp;*/


     -- 5.0. ���������  "����� ������" - ������ ��� �������� ����������� � ��������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCost(), inMovementId, COALESCE ((SELECT -1 * SUM (_tmpItem.OperSumm) FROM _tmpItem WHERE _tmpItem.IsMaster = TRUE), 0));

     -- 5.1. ����� - ���������/��������� ��������
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_TransportService()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 25.01.14                                        * all
 04.01.14         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_TransportService (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
