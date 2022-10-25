-- Function: lpComplete_Movement_ReturnOut (Integer, Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnOut (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnOut(
    IN inMovementId        Integer               , -- ���� ���������
    IN inUserId            Integer               , -- ������������
    IN inIsLastComplete    Boolean  DEFAULT False  -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbContainerId_Analyzer Integer;
  DECLARE vbWhereObjectId_Analyzer Integer;
  DECLARE vbObjectExtId_Analyzer Integer;

  DECLARE vbMovementDescId Integer;

  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;

  DECLARE vbOperSumm_PartnerFrom_byItem TFloat;
  DECLARE vbOperSumm_PartnerFrom TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;

  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDatePartner TDateTime;

  DECLARE vbUnitId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbBranchId_From Integer;
  DECLARE vbAccountDirectionId_From Integer;
  DECLARE vbIsPartionDate_Unit Boolean;

  DECLARE vbJuridicalId_From Integer;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbInfoMoneyGroupId_From Integer;
  DECLARE vbInfoMoneyDestinationId_From Integer;
  DECLARE vbInfoMoneyId_From Integer;
  DECLARE vbPaidKindId_From Integer;
  DECLARE vbContractId_From Integer;
  DECLARE vbChangePercent_From TFloat;

  DECLARE vbJuridicalId_To Integer;
  DECLARE vbIsCorporate_To Boolean;
  DECLARE vbInfoMoneyId_CorporateTo Integer;
  DECLARE vbPartnerId_To Integer;
  DECLARE vbInfoMoneyDestinationId_To Integer;
  DECLARE vbInfoMoneyId_To Integer;

  DECLARE vbPaidKindId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbJuridicalId_Basis_From Integer;
  DECLARE vbBusinessId_From Integer;

BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItemSumm;
     -- !!!�����������!!! �������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;
     -- !!!�����������!!! �������� ������� - �������� �� ����������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummPartner_From;


     -- ��� ��������� ����� ��� ������� �������� ���� �� ����������� ��� ��������� � ��� ������������ �������� � ���������
     SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent

          , Movement.DescId                                                      AS MovementDescId
          , Movement.OperDate                                                    AS OperDate -- COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)
          , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE 0 END, 0) AS UnitId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Branch.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_From
          , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_From -- ��������� ������ - ����������� !!!����� ������ ��� �������������!!!
          , COALESCE (ObjectBoolean_PartionDate.ValueData, FALSE) AS isPartionDate_Unit

                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_PartnerFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id ELSE 0 END, 0) AS PartnerId_From
                  -- ���������� �� ������ ���������� �����: ������ �� �������� 
                , COALESCE (ObjectLink_ContractFrom_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_From
                , COALESCE (MovementLinkObject_PaidKindFrom.ObjectId, 0)        AS PaidKindId_From
                , COALESCE (MovementLinkObject_ContractFrom.ObjectId, 0)        AS ContractId_From
                , COALESCE (MovementFloat_ChangePercentPartner.ValueData, 0)    AS ChangePercent_From

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_To
          , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                      THEN TRUE
                 ELSE COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE)
            END AS isCorporate_To
          , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                      THEN ObjectLink_Juridical_InfoMoney.ChildObjectId
                 ELSE 0
            END AS InfoMoneyId_CorporateTo
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN Object_To.Id ELSE 0 END, 0) AS PartnerId_To

            -- �� ������ ���������� �����: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
          , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_To -- COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0)) AS InfoMoneyId_To

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_ContractFrom_JuridicalBasis.ChildObjectId WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Juridical.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_From
          , COALESCE (CASE WHEN Object_From.DescId IN (zc_Object_Unit(), zc_Object_Partner()) THEN ObjectLink_UnitFrom_Business.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId_From

            INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
               , vbMovementDescId, vbOperDate, vbOperDatePartner
               , vbUnitId_From, vbMemberId_From, vbBranchId_From, vbAccountDirectionId_From, vbIsPartionDate_Unit
               , vbJuridicalId_From, vbPartnerId_From, vbInfoMoneyId_From, vbPaidKindId_From, vbContractId_From, vbChangePercent_From
               , vbJuridicalId_To, vbIsCorporate_To, vbInfoMoneyId_CorporateTo, vbPartnerId_To, vbInfoMoneyId_To
               , vbPaidKindId, vbContractId
               , vbJuridicalId_Basis_From, vbBusinessId_From
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercentPartner
                                  ON MovementFloat_ChangePercentPartner.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercentPartner.DescId = zc_MovementFloat_ChangePercentPartner()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_PartnerFrom_Juridical
                                     ON ObjectLink_PartnerFrom_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_PartnerFrom_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindFrom
                                             ON MovementLinkObject_PaidKindFrom.MovementId = Movement.Id
                                            AND MovementLinkObject_PaidKindFrom.DescId = zc_MovementLinkObject_PaidKindFrom()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom
                                             ON MovementLinkObject_ContractFrom.MovementId = Movement.Id
                                            AND MovementLinkObject_ContractFrom.DescId = zc_MovementLinkObject_ContractFrom()
                LEFT JOIN ObjectLink AS ObjectLink_ContractFrom_InfoMoney
                                     ON ObjectLink_ContractFrom_InfoMoney.ObjectId = MovementLinkObject_ContractFrom.ObjectId
                                    AND ObjectLink_ContractFrom_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_ContractFrom_JuridicalBasis
                                     ON ObjectLink_ContractFrom_JuridicalBasis.ObjectId = MovementLinkObject_ContractFrom.ObjectId
                                    AND ObjectLink_ContractFrom_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                LEFT JOIN ObjectLink AS ObjectLink_PartnerFrom_Unit
                                     ON ObjectLink_PartnerFrom_Unit.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_PartnerFrom_Unit.DescId = zc_ObjectLink_Partner_Unit()

          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                               ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                               ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                  ON ObjectBoolean_PartionDate.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()
                                 AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Juridical
                               ON ObjectLink_UnitFrom_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Business
                               ON ObjectLink_UnitFrom_Business.ObjectId = COALESCE (ObjectLink_PartnerFrom_Unit.ChildObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_UnitFrom_Business.DescId = zc_ObjectLink_Unit_Business()

          LEFT JOIN ObjectLink AS ObjectLink_PersonalFrom_Member
                               ON ObjectLink_PersonalFrom_Member.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PersonalFrom_Member.DescId = zc_ObjectLink_Personal_Member()
                              AND Object_From.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_PersonalFrom_Unit
                               ON ObjectLink_PersonalFrom_Unit.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PersonalFrom_Unit.DescId = zc_ObjectLink_Personal_Unit()
                              AND Object_From.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalFrom_Branch
                               ON ObjectLink_UnitPersonalFrom_Branch.ObjectId = ObjectLink_PersonalFrom_Unit.ChildObjectId
                              AND ObjectLink_UnitPersonalFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
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

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              AND Object_To.DescId = zc_Object_Partner()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                               ON ObjectLink_Juridical_InfoMoney.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Constant_InfoMoney_isCorporate_View ON Constant_InfoMoney_isCorporate_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_ReturnOut()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     
     -- ��������
     IF vbOperDate <> vbOperDatePartner
     THEN
         RAISE EXCEPTION '������.�������� <����(�����)> ������ ��������������� �������� <���� ��������� � ����������>.';
     END IF;

     -- ������������ �������������� ����������, �������� ����� ��� ��� ������������ �������� � ��������� (��� ����������)
     SELECT View_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_To FROM lfGet_Object_InfoMoney (vbInfoMoneyId_To) AS View_InfoMoney;
     -- ���������� ������������ �������������� ����������, �������� ����� ��� ��� ������������ �������� � ���������
     SELECT lfGet_InfoMoney.InfoMoneyGroupId, lfGet_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyGroupId_From, vbInfoMoneyDestinationId_From FROM lfGet_Object_InfoMoney (vbInfoMoneyId_From) AS lfGet_InfoMoney;


     -- ��������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, ContainerId_GoodsPartner, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperCount_Partner, tmpOperSumm_Partner, OperSumm_Partner, tmpOperSumm_PartnerFrom, OperSumm_PartnerFrom
                         , ContainerId_ProfitLoss_70203
                         , ContainerId_Partner, AccountId_Partner, ContainerId_Transit, AccountId_Transit, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_From
                         , isPartionCount, isPartionSumm, isTareReturning
                         , PartionGoodsId)
        SELECT
              _tmp.MovementItemId
            , 0 AS ContainerId_Goods
            , 0 AS ContainerId_GoodsPartner
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate

              -- ���������� � �������
            , _tmp.OperCount
              -- ���������� � �����������
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                        THEN _tmp.OperCount
                   ELSE _tmp.OperCount_Partner
              END AS OperCount_Partner

              -- ������������� ����� �� ����������� !!! ��� ������ !!! - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_Partner
              -- �������� ����� �� �����������
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Partner

              -- ������������� ����� �� ���������� - � ����������� �� 2-� ������
            , 0 AS tmpOperSumm_PartnerFrom
              -- �������� ����� �� ����������
            , 0 AS OperSumm_PartnerFrom

              -- ���� - ������� (���� - ����� ���������)
            , 0 AS ContainerId_ProfitLoss_70203

              -- ���� - ���� �����������
            , 0 AS ContainerId_Partner
              -- ����(�����������) �����������
            , 0 AS AccountId_Partner 
              -- ���� - ���� �������
            , 0 AS ContainerId_Transit
              -- ����(�����������) �������
            , 0 AS AccountId_Transit
              -- �������������� ����������
            , _tmp.InfoMoneyDestinationId
              -- ������ ����������
            , _tmp.InfoMoneyId

              -- �������� ������ !!!����������!!! �� ������ ��� ������������/����������
            , CASE WHEN _tmp.BusinessId_From = 0 THEN vbBusinessId_From ELSE _tmp.BusinessId_From END AS BusinessId_From

            , _tmp.isPartionCount
            , _tmp.isPartionSumm 

              -- ���������� �� ��� ���� (���� ��, ������������� �������� �� �������)
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                        THEN TRUE
                   ELSE FALSE
              END AS isTareReturning

              -- ������ ������, ���������� �����
            , 0 AS PartionGoodsId

        FROM 
             (SELECT
                    MovementItem.Id AS MovementItemId

                  , MovementItem.ObjectId AS GoodsId
                  , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ELSE 0 END AS GoodsKindId -- ���� + ������� ���������
                  , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                  , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate
 
                  , COALESCE (MIFloat_Price.ValueData, 0) AS Price
                    -- ���������� ��� �������
                  , MovementItem.Amount AS OperCount
                    -- ���������� � �����������
                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS OperCount_Partner

                    -- ������������� ����� �� ����������� - � ����������� �� 2-� ������
                  , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                 ELSE COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                    END AS tmpOperSumm_Partner

                    -- �������������� ����������
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- ������ ����������
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- ������ �� ������
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_From

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                               ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

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

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_ReturnOut()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp;


     -- !!!����������� ����� ����������!!!
     UPDATE _tmpItem SET tmpOperSumm_PartnerFrom = CAST ((1 + vbChangePercent_From / 100)
                                                 * CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                                                             -- ���� ���� � ��� ��� %���=0
                                                             THEN (tmpOperSumm_Partner)
                                                        -- ���� ���� ��� ���
                                                        ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                                                   END AS NUMERIC (16, 2))
                       , OperSumm_PartnerFrom    = CAST ((1 + vbChangePercent_From / 100)
                                                 * CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                                                             -- ���� ���� � ��� ��� %���=0
                                                             THEN (tmpOperSumm_Partner)
                                                        -- ���� ���� ��� ���
                                                        ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                                                   END AS NUMERIC (16, 2))
     WHERE vbPartnerId_To <> 0;


     -- ��������
     IF COALESCE (vbContractId, 0) = 0 AND (EXISTS (SELECT _tmpItem.isTareReturning FROM _tmpItem WHERE _tmpItem.isTareReturning = FALSE)
                                         -- OR !!! ��� !!!
                                           )
     THEN
         RAISE EXCEPTION '������.� ��������� �� ��������� <�������>.���������� ����������.';
     END IF;

     -- ��������
     IF COALESCE (vbContractId_From, 0) = 0 AND vbPartnerId_From <> 0
     THEN
         RAISE EXCEPTION '������.� ��������� �� ��������� <������� (����������)>.���������� ����������.';
     END IF;


     -- !!!
     -- IF NOT EXISTS (SELECT MovementItemId FROM _tmpItem) THEN RETURN; END IF;


     -- ������� ����
     SELECT -- ������ �������� ����� �� �����������
            CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END
            -- ������ �������� ����� �� ����������
          , CAST ((1 + vbChangePercent_From / 100)
          * CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0
                    THEN _tmpItem.tmpOperSumm_Partner
                 -- ���� ���� ��� ���
                 ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
            END AS NUMERIC (16, 2))

            INTO vbOperSumm_Partner, vbOperSumm_PartnerFrom

     FROM (SELECT SUM (_tmpItem.tmpOperSumm_Partner) AS tmpOperSumm_Partner
           FROM _tmpItem
          ) AS _tmpItem
     ;


     -- ������ �������� ���� �� ����������� (�� ���������)
     SELECT SUM (_tmpItem.OperSumm_Partner), SUM (OperSumm_PartnerFrom) INTO vbOperSumm_Partner_byItem, vbOperSumm_PartnerFrom_byItem FROM _tmpItem;


     -- ���� �� ����� ��� �������� ����� �� �����������
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_Partner = _tmpItem.OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_Partner IN (SELECT MAX (_tmpItem.OperSumm_Partner) FROM _tmpItem)
                                          );
     END IF;

     -- ���� �� ����� ��� �������� ����� �� ����������
     IF COALESCE (vbOperSumm_PartnerFrom, 0) <> COALESCE (vbOperSumm_PartnerFrom_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_PartnerFrom = OperSumm_PartnerFrom - (vbOperSumm_PartnerFrom_byItem - vbOperSumm_PartnerFrom)
         WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpItem WHERE OperSumm_PartnerFrom IN (SELECT MAX (OperSumm_PartnerFrom) FROM _tmpItem)
                                 );
     END IF;



     -- ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbAccountDirectionId_From = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                AND vbOperDate >= zc_DateStart_PartionGoods()
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                               WHEN vbIsPartionDate_Unit = TRUE
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)
                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                   THEN 0

                                               -- �������� � ������� + ����
                                               WHEN vbOperDate >= zc_DateStart_PartionGoods_20103()
                                                AND _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20103()
                                                   THEN lpInsertFind_Object_PartionGoods (inValue:= _tmpItem.PartionGoods)

                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                 OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                 OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                   THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= NULL
                                                                                        , inGoodsId       := NULL
                                                                                        , inStorageId     := NULL
                                                                                        , inInvNumber     := NULL
                                                                                        , inOperDate      := NULL
                                                                                        , inPrice         := NULL
                                                                                         )
                                               ELSE lpInsertFind_Object_PartionGoods ('')
                                          END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
        OR _tmpItem.InfoMoneyId            = zc_Enum_InfoMoney_20103()            -- �������� � ������� + ����
     ;

     -- ��������� ������� - �������� �� ����������, �� ����� ���������� ��� ������������ �������� � ���������, ����� �� !!!MovementItemId!!!
     INSERT INTO _tmpItem_SummPartner_From (MovementItemId, ContainerId_Goods, ContainerId, AccountId, ContainerId_ProfitLoss_70201, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId, BusinessId, GoodsId, OperCount_PartnerFrom, OperCount, OperSumm_Partner, OperSumm_70201)
        SELECT _tmpSumm.MovementItemId
             , 0 AS ContainerId_Goods, 0 AS ContainerId, 0 AS AccountId, 0 AS ContainerId_ProfitLoss_70201
             , vbInfoMoneyGroupId_From, vbInfoMoneyDestinationId_From, vbInfoMoneyId_From
             , _tmpSumm.BusinessId
             , _tmpSumm.GoodsId
             , (_tmpSumm.OperCount_PartnerFrom)                            AS OperCount_PartnerFrom
             , (_tmpSumm.OperCount)                                        AS OperCount
             , (_tmpSumm.OperSumm_PartnerFrom)                             AS OperSumm_Partner
             , (_tmpSumm.OperSumm_PartnerFrom - _tmpSumm.OperSumm_Partner) AS OperSumm_70201
        FROM (SELECT _tmpSumm_all.MovementItemId
                   , _tmpSumm_all.BusinessId
                   , _tmpSumm_all.GoodsId
                   , _tmpSumm_all.OperCount_PartnerFrom
                   , _tmpSumm_all.OperCount
                   , _tmpSumm_all.OperSumm_Partner
                   , _tmpSumm_all.OperSumm_PartnerFrom
              FROM (SELECT _tmpItem.MovementItemId
                         , _tmpItem.BusinessId_From AS BusinessId, _tmpItem.GoodsId
                         , (_tmpItem.OperCount_Partner)    AS OperCount_PartnerFrom
                         , (_tmpItem.OperCount)            AS OperCount
                         , (_tmpItem.OperSumm_Partner)     AS OperSumm_Partner
                         , (_tmpItem.OperSumm_PartnerFrom) AS OperSumm_PartnerFrom
                    FROM _tmpItem
                    -- ����� �.�. ���� ���� �������� ������ ���� (!!!��� �������!!!)
                    -- WHERE _tmpItem.OperSumm_PartnerFrom <> 0 AND zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
                    WHERE vbPartnerId_From <> 0
                    -- GROUP BY _tmpItem.BusinessId, _tmpItem.GoodsId
                   ) AS _tmpSumm_all
             ) AS _tmpSumm
        -- GROUP BY _tmpSumm.BusinessId, _tmpSumm.GoodsId
       ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 3.0.1.1. ������������ ����(�����������) ��� �������� �� ���� ����������
     UPDATE _tmpItem SET AccountId_Partner = _tmpItem_byAccount.AccountId
                       , AccountId_Transit = CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 THEN zc_Enum_Account_110101() ELSE 0 END -- �������
     FROM (SELECT CASE WHEN vbIsCorporate_To = TRUE
                            THEN _tmpItem_group.AccountId
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                  END AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbIsCorporate_To = TRUE
                                  THEN zc_Enum_AccountGroup_30000() -- �������� -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                             ELSE zc_Enum_AccountGroup_70000()  -- ��������� select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_70000())
                        END AS AccountGroupId
                      , CASE WHEN vbIsCorporate_To = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- ���� �������� -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30200())
                             ELSE zc_Enum_AccountDirection_70100() -- ���������� select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_70100())
                        END AS AccountDirectionId
                     , CASE WHEN vbInfoMoneyDestinationId_To <> 0
                                 THEN vbInfoMoneyDestinationId_To -- ��: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                            ELSE _tmpItem.InfoMoneyDestinationId -- ����� ����� �� ������
                       END AS InfoMoneyDestinationId_calc
                      , _tmpItem.InfoMoneyDestinationId
                      , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30201() -- ����
                             WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30202() -- ����
                             WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30203() -- �����
                             WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30204() -- �������
                             WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30205() -- �������-���������
                        END AS AccountId
                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner <> 0 !!!������ ������������, �.�. ���� AccountId � ��������� ��� ������!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;


     -- 3.0.1.2. ������������ ContainerId ��� �������� �� ���� ����������
     UPDATE _tmpItem SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
                       , ContainerId_Transit = _tmpItem_byInfoMoney.ContainerId_Transit

     FROM (SELECT           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ���������� 5)������ ���������
                            lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := _tmpItem_group.AccountId_Partner
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_group.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                  , inObjectId_1        := vbJuridicalId_To
                                                  , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                  , inObjectId_2        := vbContractId
                                                  , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                  , inObjectId_3        := _tmpItem_group.InfoMoneyId_calc
                                                  , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                  , inObjectId_4        := vbPaidKindId
                                                  , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                  , inObjectId_5        := 0 -- !!!�� ���� ��������� ���� ���� �� �����!!!
                                                  , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                  , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbPartnerId_To ELSE NULL END
                                                  , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                  , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_Branch_Basis() ELSE NULL END -- ���� ���������� ������ �� ������� �������
                                                  , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                  , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                   ) AS ContainerId
                , CASE WHEN _tmpItem_group.AccountId_Transit = 0
                            THEN 0
                            -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ���������� 5)������ ���������
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := _tmpItem_group.AccountId_Transit
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_group.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                  , inObjectId_1        := vbJuridicalId_To
                                                  , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                  , inObjectId_2        := vbContractId
                                                  , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                  , inObjectId_3        := _tmpItem_group.InfoMoneyId_calc
                                                  , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                  , inObjectId_4        := vbPaidKindId
                                                  , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                  , inObjectId_5        := 0 -- !!!�� ���� ��������� ���� ���� �� �����!!!
                                                  , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                  , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbPartnerId_To ELSE NULL END
                                                  , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                  , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_Branch_Basis() ELSE NULL END -- ���� ���������� ������ �� ������� �������
                                                  , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                  , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                   )
                  END AS ContainerId_Transit
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.AccountId_Partner
                      , _tmpItem.AccountId_Transit
                      , _tmpItem.InfoMoneyDestinationId
                      , _tmpItem.InfoMoneyId
                      , _tmpItem.BusinessId_From
                      , CASE WHEN vbInfoMoneyId_To <> 0
                                  THEN vbInfoMoneyId_To -- ��: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                             ELSE _tmpItem.InfoMoneyId -- ����� ����� �� ������
                        END AS InfoMoneyId_calc
                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner <> 0 !!!������ ������������, �.�. ���� ContainerId � ��������� ��� ������!!!
                 GROUP BY _tmpItem.AccountId_Partner
                        , _tmpItem.AccountId_Transit
                        , _tmpItem.InfoMoneyDestinationId
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_group
          ) AS _tmpItem_byInfoMoney
     WHERE _tmpItem.InfoMoneyId = _tmpItem_byInfoMoney.InfoMoneyId
     ;

     -- 3.0.2.1. ������������ ContainerId_Goods ��� "�����������" �������� ��������������� ����� �� ����������
     UPDATE _tmpItem_SummPartner_From SET ContainerId_Goods = tmp.ContainerId
     FROM                            (SELECT _tmpItem.GoodsId
                                           , lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- �� "���� �����"
                                                                                , inUnitId                 := vbPartnerId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := NULL
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := NULL
                                                                                , inIsPartionCount         := FALSE
                                                                                , inPartionGoodsId         := NULL
                                                                                , inAssetId                := NULL
                                                                                , inBranchId               := NULL                     -- ��� ��������� ����� ��� �������
                                                                                , inAccountId              := zc_Enum_Account_110401() -- ��� ��������� ����� ��� "����� � ���� / ����������� �����"
                                                                                 ) AS ContainerId
           FROM (SELECT _tmpItem_SummPartner.GoodsId, _tmpItem_SummPartner.InfoMoneyDestinationId
                 FROM _tmpItem_SummPartner_From AS _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.GoodsId, _tmpItem_SummPartner.InfoMoneyDestinationId
                ) AS _tmpItem
          ) AS tmp
     WHERE _tmpItem_SummPartner_From.GoodsId = tmp.GoodsId
    ;

     -- 3.0.2.2. ������������ ����(�����������) ��� �������� �� ���� ����������
     UPDATE _tmpItem_SummPartner_From SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                             , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT zc_Enum_AccountGroup_30000()      AS AccountGroupId     -- ��������
                      , zc_Enum_AccountDirection_30100()  AS AccountDirectionId -- �������� + ���������� 
                      , _tmpItem_SummPartner.InfoMoneyDestinationId
                 FROM _tmpItem_SummPartner_From AS _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.InfoMoneyGroupId, _tmpItem_SummPartner.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPartner_From.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 3.0.2.3. ������������ ContainerId ��� �������� �� ���� ����������
     UPDATE _tmpItem_SummPartner_From SET ContainerId = tmp.ContainerId
     FROM              (SELECT tmp.AccountId, tmp.BusinessId, tmp.InfoMoneyId
                                                                             , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_2        := vbContractId_From
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_3        := tmp.InfoMoneyId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_4        := vbPaidKindId_From
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := 0 -- !!!�� ���� ��������� ���� ���� �� �����!!!
                                                                                                      , inDescId_6          := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                      , inObjectId_6        := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN vbPartnerId_From ELSE NULL END
                                                                                                      , inDescId_7          := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                      , inObjectId_7        := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN zc_Branch_Basis() ELSE NULL END -- ���� ���������� ������ �� ������� �������
                                                                                                      , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                                                                      , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                                                                       ) AS ContainerId

           FROM (SELECT _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.BusinessId, _tmpItem_SummPartner.InfoMoneyId
                 FROM _tmpItem_SummPartner_From AS _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.BusinessId, _tmpItem_SummPartner.InfoMoneyId
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_SummPartner_From.AccountId         = tmp.AccountId
       AND _tmpItem_SummPartner_From.BusinessId        = tmp.BusinessId
       AND _tmpItem_SummPartner_From.InfoMoneyId       = tmp.InfoMoneyId
    ;

     -- 3.0.2.4. ������������ ContainerId ��� �������� - ������� ����������
     UPDATE _tmpItem_SummPartner_From SET ContainerId_ProfitLoss_70201 = _tmpItem_byDestination.ContainerId_ProfitLoss_70201 -- ���� - ������� (���� - �������������� ������� + ������ + ������)
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301() -- 100301; "������� �������� �������"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_70201() -- �������������� ������� + ������ + ������
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := 0
                                         ) AS ContainerId_ProfitLoss_70201
                , _tmpItem_byProfitLoss.BusinessId
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
           FROM (SELECT  _tmpItem_SummPartner_From.InfoMoneyDestinationId
                       , _tmpItem_SummPartner_From.BusinessId
                 FROM _tmpItem_SummPartner_From
                 GROUP BY _tmpItem_SummPartner_From.InfoMoneyDestinationId
                        , _tmpItem_SummPartner_From.BusinessId
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination
     WHERE _tmpItem_SummPartner_From.InfoMoneyDestinationId = _tmpItem_byDestination.InfoMoneyDestinationId
       AND _tmpItem_SummPartner_From.BusinessId            = _tmpItem_byDestination.BusinessId
    ;

     -- 3.3. !!!����� ����� - ���������� ����� vbContainerId_Analyzer ��� ����!!!, ���� �� �� ���� - ����� ������
     vbContainerId_Analyzer:= (SELECT ContainerId_Partner FROM _tmpItem WHERE ContainerId_Partner <> 0 GROUP BY ContainerId_Partner);
     -- ����������
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From WHEN vbPartnerId_From <> 0 THEN vbPartnerId_From END;
     -- ����������
     vbObjectExtId_Analyzer:= CASE WHEN vbPartnerId_To <> 0 THEN vbPartnerId_To END;


     -- 3.0.4. !!!��� ����� - �������, ���� ����������!!!
     -- !!!!!!!!!!!!! DELETE FROM _tmpItem WHERE vbPartnerId_From <> 0;


     -- 1.1.1. ������������ ContainerId_GoodsPartner ��� !!!������������!!! �������� �� ��������������� ����� - ����� ����������
     UPDATE _tmpItem SET ContainerId_GoodsPartner = -- 0)����� 1)����������
                                                    lpInsertFind_Container (inContainerDescId   := zc_Container_CountSupplier()
                                                                          , inParentId          := NULL
                                                                          , inObjectId          := _tmpItem.GoodsId
                                                                          , inJuridicalId_basis := NULL
                                                                          , inBusinessId        := NULL
                                                                          , inObjectCostDescId  := NULL
                                                                          , inObjectCostId      := NULL
                                                                          , inDescId_1          := zc_ContainerLinkObject_Partner()
                                                                          , inObjectId_1        := vbPartnerId_To
                                                                          , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                                          , inObjectId_2        := zc_Branch_Basis() -- ���� ���������� ������ �� ������� �������
                                                                          , inDescId_3          := zc_ContainerLinkObject_PaidKind()
                                                                          , inObjectId_3        := vbPaidKindId
                                                                           )
     WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
       AND vbPartnerId_From = 0 -- !!!���� �� ����������!!!
    ;

     -- 1.1.2. ����������� !!!������������!!! �������� ��� ��������������� ����� - ����� ���������� ��� ���.����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_CountSupplier() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_GoodsPartner
            , 0                                       AS AccountId                -- ��� �����
            , zc_Enum_AnalyzerId_TareReturning()      AS AnalyzerId               -- ���� ���������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- �����
            , vbPartnerId_To                          AS WhereObjectId_Analyzer   -- ���������
            , 0                                       AS ContainerId_Analyzer     -- !!!���!!!
            , 0                                       AS ObjectIntId_Analyzer     -- !!!���!!!
            , vbWhereObjectId_Analyzer                AS ObjectExtId_Analyzer     -- ������������� ���...
            , ContainerId_GoodsPartner                AS ContainerIntId_Analyzer  -- ��������� "�����" - ��� �� �����
            , 0                                       AS ParentId
            , OperCount                               AS Amount
            , vbOperDate                              AS OperDate                 -- �.�. �� "���� �����"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
         AND vbPartnerId_From = 0 -- !!!���� �� ����������!!!
      ;

     -- 1.2.1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := NULL -- ��� ��������� ����� ��� �������
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
     WHERE vbPartnerId_From = 0 -- !!!���� �� ����������!!!
    ;
     -- 1.2.2. ����������� �������� ��� ��������������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_Goods
            , 0                                       AS AccountId                -- ��� �����
            , CASE WHEN _tmpItem.isTareReturning = TRUE THEN zc_Enum_AnalyzerId_TareReturning() ELSE 0 END AS AnalyzerId               -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ������������ ���...
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- ��������� - �� ������ ����������
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- ��������� "�����" - ��� �� �����
            , 0                                       AS ParentId
            , -1 * OperCount_Partner                  AS Amount
            , vbOperDate                              AS OperDate                 -- �.�. �� "���� �����"
            , FALSE                                   AS isActive
       FROM _tmpItem
       WHERE vbPartnerId_From = 0 -- !!!���� �� ����������!!!
      UNION ALL
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_Goods
            , 0                                       AS AccountId                -- ��� �����
            , zc_Enum_AnalyzerId_Count_40200()        AS AnalyzerId               -- ���� ���������, ������� � ����, ���� ������� ��� ������� �� �������� � ������ ������ 40200...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ������������ ���...
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- ��������� - �� ������ ����������
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- ��������� "�����" - ��� �� �����
            , 0                                       AS ParentId
            , -1 * (OperCount - OperCount_Partner)    AS Amount
            , vbOperDate                              AS OperDate                 -- �.�. �� "���� �����"
            , FALSE                                   AS isActive
       FROM _tmpItem
       WHERE vbPartnerId_From = 0 -- !!!���� �� ����������!!!
         AND OperCount <> OperCount_Partner
      ;


     -- 1.2.3. ������ !!!���������� ���� �� ����������!!!, ������� �������
     DELETE FROM _tmpItem WHERE _tmpItem.isTareReturning = TRUE;


     -- 1.3.1. ����� ����������: ��������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_70203, ContainerId, AccountId, OperSumm, OperSumm_Partner)
        SELECT
              _tmpItem.MovementItemId
            , 0 AS ContainerId_ProfitLoss_40208 -- ���� - ������� (���� - ������� ����������� (������� � ���� : �/�1 - �/�2))
            , 0 AS ContainerId_ProfitLoss_70203 -- ���� - ������� (���� - ������� ����������� (������������� �������� : �/�2))
            , COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0)) AS ContainerId
            , COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) AS AccountId
              -- �/�1 - ��� ����������: ������ � �������
            , SUM (ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)))
                 + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                             THEN HistoryCost.Summ_diff -- !!!���� ���� "�����������" ��� ����������, �������� �����!!!
                        ELSE 0
                   END) AS OperSumm
              -- �/�2 - ��� ����������: �����������
            , SUM (ABS (CAST (_tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)))) AS OperSumm_Partner
        FROM _tmpItem
             -- ��� ������� ��� ����
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItem.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis_From
                                                                                 -- AND lfContainerSumm_20901.BusinessId        = _tmpItem.BusinessId_From -- !!!���� �� ������� � ���������� �� �������!!!
                                                                                 AND _tmpItem.InfoMoneyDestinationId         = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                                                                                 AND _tmpItem.isTareReturning                = FALSE
             -- ��� ������� ��� ���������
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId = zc_Container_Summ()
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id) -- HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) <> 0                -- ����� ���� !!!�� �����!!! 
            OR _tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0) <> 0        -- ����� ���� !!!�� �����!!! 
              )
          AND vbPartnerId_From = 0 -- !!!���� �� ����������!!!
        GROUP BY _tmpItem.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId;

     -- 1.3.2. ����������� �������� ��� ��������� ����� : �/�1 + !!!���� MovementItemId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId
            , _tmpItemSumm.ContainerId
            , _tmpItemSumm.AccountId                  AS AccountId                -- ���� ���� ������
            , 0                                       AS AnalyzerId               -- ��� ���������, � ���� �� ����
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ������������ ���...
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- ��������� - �� ������ ����������
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , -1 * _tmpItemSumm.OperSumm              AS Amount
            , vbOperDate                              AS OperDate                 -- �.�. �� "���� �����"
            , FALSE                                   AS isActive
       FROM _tmpItemSumm
            LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
       WHERE _tmpItemSumm.OperSumm <> 0;


     -- 2.1. ������� ���������� ��� �������� - �������
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_40208 = _tmpItem_byDestination.ContainerId_ProfitLoss_70203 -- ���� - ������� (���� - ������� ����������� (������� � ���� : �/�1 - �/�2))
                           , ContainerId_ProfitLoss_70203 = _tmpItem_byDestination.ContainerId_ProfitLoss_70203 -- ���� - ������� (���� - (������������� �������� : �/�2))
     FROM _tmpItem
          JOIN
          (SELECT -- ��� ����� ������� � ���� : �/�1 - �/�2 AND ��� ����� ������������� �������� : �/�2
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "������� �������� �������"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_70203() -- �������������� ������� + ������ + ������� �����������
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := 0
                                         ) AS ContainerId_ProfitLoss_70203
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
           FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                       , _tmpItem.BusinessId_From
                 FROM _tmpItemSumm
                       JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
                 GROUP BY _tmpItem.InfoMoneyDestinationId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 2.2. ����������� �������� - ������� (�������������) + !!!��� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- �������� �� ������� � ���� : �/�1 - �/�2
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                AS AccountId                -- ������� �������� �������
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- ���������, �� �������� = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer     -- � ���� �� �����
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , vbOperDate                              AS OperDate                 -- �.�. �� "���� �����"
            , FALSE                                   AS isActive
       FROM (SELECT _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- ��� ���������
                  , SUM (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_40208, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
      UNION ALL
       -- �������� �� ������������� ��������� : �/�2
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                AS AccountId                -- ������� �������� �������
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- ���������, �� �������� = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer     -- � ���� �� �����
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , vbOperDate                              AS OperDate                 -- �.�. �� "���� �����"
            , FALSE                                   AS isActive
       FROM (SELECT _tmpItemSumm.ContainerId_ProfitLoss_70203 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , _tmpItem.GoodsId                          AS GoodsId
                  , 0                                         AS AnalyzerId -- ��� ���������
                  , SUM (_tmpItemSumm.OperSumm_Partner) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_70203, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
       ;


     -- 3.3. ����������� �������� - ���� ���������� + !!!�������� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       WITH tmpItemSumm_group AS (SELECT _tmpItemSumm.MovementItemId, SUM (_tmpItemSumm.OperSumm_Partner) AS OperSumm FROM _tmpItemSumm GROUP BY _tmpItemSumm.MovementItemId)
          , tmpItem_group AS (SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Transit, _tmpItem.AccountId_Transit, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                   , _tmpItem.OperSumm_Partner - COALESCE (tmpItemSumm_group.OperSumm, 0) AS OperSumm
                                   , zc_Enum_AnalyzerId_ProfitLoss() AS AnalyzerId -- ���� ���������, �.�. �� ��� ��������� � ����
                              FROM _tmpItem
                                   LEFT JOIN tmpItemSumm_group ON tmpItemSumm_group.MovementItemId = _tmpItem.MovementItemId
                             UNION ALL
                              SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Transit, _tmpItem.AccountId_Transit, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                   , COALESCE (tmpItemSumm_group.OperSumm, 0) AS OperSumm
                                   , 0 AS AnalyzerId -- ��� ���������
                              FROM _tmpItem
                                   LEFT JOIN tmpItemSumm_group ON tmpItemSumm_group.MovementItemId = _tmpItem.MovementItemId
                              WHERE tmpItemSumm_group.OperSumm <> 0
                             )
       -- ��� ������� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpItem_group.MovementItemId
            , tmpItem_group.ContainerId_Partner
            , tmpItem_group.AccountId_Partner         AS AccountId              -- ���� ���� ������
            , tmpItem_group.AnalyzerId                AS AnalyzerId             -- ���� ���������, ��� "�������" ��� 0, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , tmpItem_group.GoodsId                   AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , tmpItem_group.ContainerId_Partner       AS ContainerId_Analyzer   -- ��� �� �����
            , tmpItem_group.GoodsKindId               AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ���������
            , tmpItem_group.ContainerId_Goods         AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , tmpItem_group.OperSumm
            , CASE WHEN tmpItem_group.AccountId_Transit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- �.�. �� "������������" ����
            , TRUE
       FROM tmpItem_group
       -- !!!������ ������������, �.�. �� ���� ��������� �������� ������!!!
       -- WHERE tmpItem_group.OperSumm <> 0
     UNION ALL
       -- ��� ��� �������� ��� ����� �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpItem_group.MovementItemId
            , tmpItem_group.ContainerId_Transit
            , tmpItem_group.AccountId_Transit         AS AccountId                -- ���� ���� (�.�. � ������� ������������ "�������")
            , tmpItem_group.AnalyzerId                AS AnalyzerId               -- ���� ���������, ��� "�������" ��� 0, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , tmpItem_group.GoodsId                   AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ������������ ���...
            , tmpItem_group.ContainerId_Transit       AS ContainerId_Analyzer     -- ��� �� �����, �.�. � ������ ������� "�����������" �� vbOperDate + "��������" �� vbOperDatePartner
            , tmpItem_group.GoodsKindId               AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������
            , tmpItem_group.ContainerId_Goods         AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 1 ELSE -1 END * tmpItem_group.OperSumm
            , tmpOperDate.OperDate                    AS OperDate                 -- �.�. �� "������������" ����
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN TRUE ELSE FALSE END AS IsActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            JOIN tmpItem_group ON tmpItem_group.AccountId_Transit <> 0 AND tmpItem_group.OperSumm <> 0
     ;

     -- 3.4. ����������� "�����������" �������� - ��� ��������������� ����� �� ���������� + !!!�������� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner_From.MovementItemId
            , _tmpItem_SummPartner_From.ContainerId_Goods
            , zc_Enum_Account_110401()                AS AccountId                -- ���� ���� ������� + ����������� ����� + ����������� ����� (�.�. � ������� ������������ "�����������")
            , 0                                       AS AnalyzerId               -- ��� ���������, �.�. �������� "�����������" ���� �� ����
            , _tmpItem_SummPartner_From.GoodsId       AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ����������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- ��������� - �� ������ ����������
            , 0                                       AS ObjectIntId_Analyzer     -- !!!���!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������
            , _tmpItem_SummPartner_From.ContainerId_Goods AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , _tmpItem_SummPartner_From.OperCount_PartnerFrom * CASE WHEN tmp.isActive = TRUE THEN 1 ELSE -1 END AS Amount -- � ���������������� �������
            , vbOperDate                              AS OperDate
            , tmp.isActive                            AS isActive                 -- �.�. � ���������������� �������
       FROM _tmpItem_SummPartner_From
            LEFT JOIN (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmp ON 1 = 1
      UNION ALL
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner_From.MovementItemId
            , _tmpItem_SummPartner_From.ContainerId_Goods
            , zc_Enum_Account_110401()                AS AccountId                -- ���� ���� ������� + ����������� ����� + ����������� ����� (�.�. � ������� ������������ "�����������")
            , zc_Enum_AnalyzerId_Count_40200()        AS AnalyzerId               -- ���� ���������, ������� � ����, ���� ������� ��� ������� �� �������� � ������ ������ 40200...
            , _tmpItem_SummPartner_From.GoodsId       AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ����������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- ��������� - �� ������ ����������
            , 0                                       AS ObjectIntId_Analyzer     -- !!!���!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������
            , _tmpItem_SummPartner_From.ContainerId_Goods AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , (_tmpItem_SummPartner_From.OperCount - _tmpItem_SummPartner_From.OperCount_PartnerFrom) * CASE WHEN tmp.isActive = TRUE THEN 1 ELSE -1 END AS Amount -- � ���������������� �������
            , vbOperDate                              AS OperDate
            , tmp.isActive                            AS isActive                 -- �.�. � ���������������� �������
       FROM _tmpItem_SummPartner_From
            LEFT JOIN (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmp ON 1 = 1
       WHERE _tmpItem_SummPartner_From.OperCount <> _tmpItem_SummPartner_From.OperCount_PartnerFrom
      ;


     -- 3.5. ����������� �������� - ���� ���������� + !!!�������� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- ��� ������� �������� (�� ����� ����������)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner.MovementItemId
            , _tmpItem_SummPartner.ContainerId
            , _tmpItem_SummPartner.AccountId          AS AccountId                -- ���� ���� ������
            , 0                                       AS AnalyzerId               -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , _tmpItem_SummPartner.GoodsId            AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ����������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- ��������� - �� ������ ����������
            , 0                                       AS ObjectIntId_Analyzer     -- !!!���!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������
            , _tmpItem_SummPartner.ContainerId_Goods  AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , -1 * (_tmpItem_SummPartner.OperSumm_Partner - _tmpItem_SummPartner.OperSumm_70201)
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_SummPartner_From AS _tmpItem_SummPartner
       -- !!!������ ������������, �.�. �� ���� ��������� �������� ������!!!
       -- WHERE _tmpItem_SummPartner.OperSumm_Partner <> 0
      UNION ALL
       -- ��� ������� �������� (�� ����� �������)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner.MovementItemId
            , _tmpItem_SummPartner.ContainerId
            , _tmpItem_SummPartner.AccountId          AS AccountId                -- ���� ���� ������
            , zc_Enum_AnalyzerId_ProfitLoss()         AS AnalyzerId               -- ���� ���������, �.�. �� ��� ��������� � ����
            , _tmpItem_SummPartner.GoodsId            AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ����������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- ��������� - �� ������ ����������
            , 0                                       AS ObjectIntId_Analyzer     -- !!!���!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������
            , _tmpItem_SummPartner.ContainerId_Goods  AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , -1 * _tmpItem_SummPartner.OperSumm_70201
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_SummPartner_From AS _tmpItem_SummPartner
       WHERE _tmpItem_SummPartner.OperSumm_70201 <> 0
      ;

     -- 3.6. ����������� �������� - ������� ���������� + !!!��� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                AS AccountId                -- ������� �������� �������
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- ���������, �� �������� = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer     -- � ���� �� �����
            , 0                                       AS ObjectIntId_Analyzer     -- !!!���!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , vbOperDate                              AS OperDate                 -- �.�. �� "���� �����"
            , FALSE                                   AS isActive
       FROM (SELECT _tmpItem_SummPartner_From.ContainerId_ProfitLoss_70201 AS ContainerId_ProfitLoss
                  , _tmpItem_SummPartner_From.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem_SummPartner_From.GoodsId                      AS GoodsId
                  , 0                                                      AS AnalyzerId  -- ��� ���������
                  , SUM (_tmpItem_SummPartner_From.OperSumm_70201)         AS OperSumm
             FROM _tmpItem_SummPartner_From
             GROUP BY _tmpItem_SummPartner_From.ContainerId_ProfitLoss_70201, _tmpItem_SummPartner_From.ContainerId_Goods, _tmpItem_SummPartner_From.GoodsId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
      ;


     -- 4.1.1. ������� ���������� ��� �������� - ������� (����� ���������)
     UPDATE _tmpItem SET ContainerId_ProfitLoss_70203 = _tmpItem_byDestination.ContainerId_ProfitLoss_70203
     FROM (SELECT -- ��� ����� ���������
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "������� �������� �������"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_70203() -- �������������� ������� + ������ + ������� �����������
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := 0
                                         ) AS ContainerId_ProfitLoss_70203
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
           FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                       , _tmpItem.BusinessId_From
                 FROM _tmpItem
                 WHERE _tmpItem.OperSumm_Partner <> 0
                   AND vbPartnerId_From = 0 -- !!!���� �� ����������!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination
     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byDestination.InfoMoneyDestinationId;

     -- 4.1.2. ����������� �������� - ������� (����� ���������) + !!!��� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- ����� ���������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId              -- ������� �������� �������
            , 0                                       AS AnalyzerId             -- ��� ���������
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer   -- � ���� �� �����
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ���������
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , vbOperDate                              AS Amount
            , FALSE                                   AS isActive
       FROM (SELECT _tmpItem.ContainerId_ProfitLoss_70203 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                      AS GoodsId
                  , _tmpItem.GoodsKindId                  AS GoodsKindId
                  , -1 * SUM (_tmpItem.OperSumm_Partner)  AS OperSumm
             FROM _tmpItem
             WHERE vbPartnerId_From = 0 -- !!!���� �� ����������!!!
             GROUP BY _tmpItem.ContainerId_ProfitLoss_70203, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
       ;

     -- 5.1.1. ����������� �������� ��� ������ (�����: �����(�/�) <-> ����(������� �����������-������ ������� � ����))
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
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := _tmpItem.ContainerId_Partner
                                                                                                             , inAccountId_1        := _tmpItem.AccountId_Partner
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                , _tmpCalc.MovementItemId
           FROM (SELECT _tmpItemSumm.MovementItemId
                      , _tmpItemSumm.ContainerId
                      , _tmpItemSumm.AccountId
                      , _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                      , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "������� �������� �������"
                      , (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner) AS OperSumm -- !!!����>0, ������ "������", �.�. ���������� ������ ������ ��� ���� �� ������!!!
                                                                                            -- �.�. ������: Active=ContainerId_ProfitLoss � �����: Passive=ContainerId_ProfitLoss
                 FROM _tmpItemSumm
                ) AS _tmpCalc
           WHERE _tmpCalc.OperSumm <> 0
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     -- 5.1.2. ����������� �������� ��� ������ (�����: �����(�/�) <-> ����(������� �����������-������������� ����������))
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
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := _tmpItem.ContainerId_Partner
                                                                                                             , inAccountId_1        := _tmpItem.AccountId_Partner
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "������� �������� �������"
                , _tmpCalc.MovementItemId
           FROM (SELECT _tmpItemSumm.MovementItemId
                      , _tmpItemSumm.ContainerId
                      , _tmpItemSumm.AccountId
                      , _tmpItemSumm.ContainerId_ProfitLoss_70203 AS ContainerId_ProfitLoss
                      , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "������� �������� �������"
                      , (_tmpItemSumm.OperSumm_Partner) AS OperSumm -- !!!�� ���� >0, ������ "������"!!!
                                                                    -- �.�. ������: Active=ContainerId_ProfitLoss � �����: Passive=ContainerId_ProfitLoss
                 FROM _tmpItemSumm
                ) AS _tmpCalc
           WHERE _tmpCalc.OperSumm <> 0
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     -- 5.2.1. ����������� �������� ��� ������ (�����: ��.���� <-> ����(������� �����������-����� ��������)) !!!����� ����� ����� �� �/�, � ���� ��� ��� ����� �������������� � ��� inAccountId_1 �� ����������!!! 
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
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := COALESCE (_tmpItemSumm_group.ContainerId, _tmpItem_byProfitLoss.ContainerId_Goods)
                                                                                                             , inAccountId_1        := COALESCE (_tmpItemSumm_group.AccountId, zc_Enum_Account_100301 ()) -- 100301; "������� �������� �������"
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "������� �������� �������"
                , _tmpCalc.MovementItemId
                , _tmpCalc.ContainerId_Goods
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , _tmpCalc_all.ContainerId_Goods
                      , tmpOperDate.OperDate
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpCalc_all.AccountId_Transit <> 0 THEN _tmpCalc_all.ContainerId_Transit ELSE _tmpCalc_all.ContainerId END AS ContainerId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpCalc_all.AccountId_Transit <> 0 THEN _tmpCalc_all.AccountId_Transit ELSE _tmpCalc_all.AccountId END AS AccountId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.ContainerId_ProfitLoss ELSE _tmpCalc_all.ContainerId_Transit END AS ContainerId_ProfitLoss
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.AccountId_ProfitLoss ELSE _tmpCalc_all.AccountId_Transit END AS AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT _tmpItem.MovementItemId
                            , _tmpItem.ContainerId_Goods
                            , _tmpItem.ContainerId_Partner AS ContainerId
                            , _tmpItem.AccountId_Partner   AS AccountId
                            , _tmpItem.ContainerId_Transit
                            , _tmpItem.AccountId_Transit
                            , _tmpItem.ContainerId_ProfitLoss_70203 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "������� �������� �������"
                            , -1 * _tmpItem.OperSumm_Partner AS OperSumm -- !!!�����, ������ "�����"!!!
                                                                         -- �.�. ������: Active=ContainerId_ProfitLoss � �����: Passive=ContainerId_ProfitLoss
                       FROM _tmpItem
                       WHERE vbPartnerId_From = 0 -- !!!���� �� ����������!!!
                      ) AS _tmpCalc_all
                      LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                                                                                                                         OR  (tmpOperDate.OperDate = vbOperDatePartner
                                                                                                                          AND COALESCE (_tmpCalc_all.AccountId_Transit, 0) <> 0)
                 WHERE _tmpCalc_all.OperSumm <> 0
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN (SELECT _tmpItemSumm.MovementItemId
                          , _tmp_byContainer.ContainerId
                          , MAX (_tmpItemSumm.AccountId) AS AccountId
                     FROM _tmpItemSumm
                          JOIN (SELECT _tmpItemSumm.MovementItemId, MAX  (_tmpItemSumm.ContainerId) AS ContainerId FROM _tmpItemSumm GROUP BY _tmpItemSumm.MovementItemId
                               ) AS _tmp_byContainer ON _tmp_byContainer.MovementItemId = _tmpItemSumm.MovementItemId
                     GROUP BY _tmpItemSumm.MovementItemId
                            , _tmp_byContainer.ContainerId
                    ) AS _tmpItemSumm_group ON _tmpItemSumm_group.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     -- 5.1.2. ����������� �������� ��� ������ (�����: ���������� <-> ���� ���������� ��� ���.���� (����������� ����)) !!!����� �� BusinessId + GoodsId!!!
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := tmpMIReport.MovementItemId
                                              , inActiveContainerId  := tmpMIReport.ActiveContainerId
                                              , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                              , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                              , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                                                                    , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                                                                    , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                                                                    , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                                                                             , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                                                                             , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                                                                             , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                                                                     )
                                              , inAmount   := tmpMIReport.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT _tmpItem_SummPartner_From.MovementItemId   AS MovementItemId
                , _tmpItem_SummPartner_From.OperSumm_Partner - _tmpItem_SummPartner_From.OperSumm_70201 AS OperSumm
                , _tmpItem.ContainerId_Partner               AS ActiveContainerId
                , _tmpItem_SummPartner_From.ContainerId      AS PassiveContainerId
                , _tmpItem.AccountId_Partner                 AS ActiveAccountId
                , _tmpItem_SummPartner_From.AccountId        AS PassiveAccountId
           FROM _tmpItem_SummPartner_From
                LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_SummPartner_From.MovementItemId
           WHERE _tmpItem_SummPartner_From.OperSumm_Partner - _tmpItem_SummPartner_From.OperSumm_70201 <> 0
          ) AS tmpMIReport;


     -- 5.1.3. ����������� �������� ��� ������ (�����: ���������� <-> ���� (�������������� ������� + ������ + ������))
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := tmpMIReport.MovementItemId
                                              , inActiveContainerId  := tmpMIReport.ActiveContainerId
                                              , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                              , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                              , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                                                                    , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                                                                    , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                                                                    , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                                                                             , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                                                                             , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                                                                             , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                                                                     )
                                              , inAmount   := tmpMIReport.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT _tmpItem_SummPartner_From.MovementItemId   AS MovementItemId
                , _tmpItem_SummPartner_From.OperSumm_70201   AS OperSumm
                , _tmpItem_SummPartner_From.ContainerId_ProfitLoss_70201 AS ActiveContainerId
                , _tmpItem_SummPartner_From.ContainerId      AS PassiveContainerId
                , zc_Enum_Account_100301()                   AS ActiveAccountId -- 100301; "������� �������� �������"
                , _tmpItem_SummPartner_From.AccountId        AS PassiveAccountId
           FROM _tmpItem_SummPartner_From
           WHERE _tmpItem_SummPartner_From.OperSumm_70201 <> 0
          ) AS tmpMIReport;


     -- !!!�������!!!
     -- vbBranchId_From:= 0;
     -- !!!!!!!!!!!!!
     -- �����, �.�. ��-�� ������� ������ � ����
     DELETE FROM MovementItemLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementItemId IN (SELECT MovementItemId FROM _tmpItem);
     -- !!!6.0. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     /*PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, vbBranchId_From)
     FROM (SELECT _tmpItem.MovementItemId
           FROM _tmpItem
          ) AS tmp;*/

     -- 6.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 6.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ReturnOut()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.09.14                                        * add zc_ContainerLinkObject_Branch
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 04.07.14                                        * add Constant_InfoMoney_isCorporate_View
 26.07.14                                        * add ����
 25.05.14                                        * add lpComplete_Movement
 11.05.14                                        * set zc_ContainerLinkObject_PaidKind is last
 10.05.14                                        * add lpInsert_MovementProtocol
 26.04.14                                        * !!!RESTORE!!!
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 14.02.14                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 1627746 , inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 1627746 , inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ReturnOut (inMovementId:= 1627746 , inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
