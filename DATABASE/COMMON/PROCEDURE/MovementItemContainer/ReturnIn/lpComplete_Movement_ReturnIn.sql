-- Function: lpComplete_Movement_ReturnIn (Integer, Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnIn (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnIn(
    IN inMovementId        Integer               , -- ���� ���������
    IN inUserId            Integer               , -- ������������
    IN inIsLastComplete    Boolean  DEFAULT False  -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
)                              
 RETURNS VOID
AS
$BODY$
  DECLARE vbIsHistoryCost Boolean; -- ����� �������� �/� ��� ����� ������������

  DECLARE vbMovementDescId Integer;

  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;

  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDatePartner TDateTime;

  DECLARE vbJuridicalId_From Integer;
  DECLARE vbIsCorporate_From Boolean;
  DECLARE vbInfoMoneyId_CorporateFrom Integer;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbInfoMoneyDestinationId_From Integer;
  DECLARE vbInfoMoneyId_From Integer;

  DECLARE vbUnitId_To Integer;
  DECLARE vbMemberId_To Integer;
  DECLARE vbBranchId_To Integer;
  DECLARE vbAccountDirectionId_To Integer;
  DECLARE vbIsPartionDate_Unit Boolean;

  DECLARE vbPaidKindId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbJuridicalId_Basis_To Integer;
  DECLARE vbBusinessId_To Integer;

BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItemSumm;
     -- !!!�����������!!! �������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
     IF EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
        AND inIsLastComplete = FALSE
     THEN vbIsHistoryCost:= TRUE;
     ELSE vbIsHistoryCost:= FALSE;
     END IF;

     -- ��� ��������� ����� ��� ������� �������� ���� �� ����������� ��� ��������� � ��� ������������ �������� � ���������
     SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent

          , Movement.DescId                                                      AS MovementDescId
          , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDate -- Movement.OperDate
          , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_From

          , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                      THEN TRUE
                 ELSE COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE)
            END AS IsCorporate_From

          , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                      THEN ObjectLink_Juridical_InfoMoney.ChildObjectId
                 ELSE 0
            END AS InfoMoneyId_CorporateFrom

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id ELSE 0 END, 0) AS PartnerId_From
          , 0 AS MemberId_From -- COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From

            -- �� ������ ���������� �����: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
          , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_From -- COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0)) AS InfoMoneyId_From

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN Object_To.Id ELSE 0 END, 0) AS UnitId_To
          , 0 AS MemberId_To -- COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN Object_To.Id WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Branch.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_To
          , COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_To -- ��������� ������ - ����������� !!!����� ������ ��� �������������!!!
          , COALESCE (ObjectBoolean_PartionDate.ValueData, FALSE) AS isPartionDate_Unit

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Juridical.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Business.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId_To

            INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
               , vbMovementDescId, vbOperDate, vbOperDatePartner
               , vbJuridicalId_From, vbIsCorporate_From, vbInfoMoneyId_CorporateFrom, vbPartnerId_From , vbMemberId_From, vbInfoMoneyId_From
               , vbUnitId_To, vbMemberId_To, vbBranchId_To, vbAccountDirectionId_To, vbIsPartionDate_Unit
               , vbPaidKindId, vbContractId
               , vbJuridicalId_Basis_To, vbBusinessId_To
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
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                  ON ObjectBoolean_PartionDate.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()
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

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PersonalFrom_Member
                               ON ObjectLink_PersonalFrom_Member.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PersonalFrom_Member.DescId = zc_ObjectLink_Personal_Member()
                              AND Object_From.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              AND Object_From.DescId = zc_Object_Partner()
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
       AND Movement.DescId = zc_Movement_ReturnIn()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     -- ��������
     IF vbOperDate <> vbOperDatePartner
     THEN
         RAISE EXCEPTION '������.�������� <����(�����)> ������ ��������������� �������� <���� ��������� � ����������>.';
     END IF;


     -- ������������ �������������� ����������, �������� ����� ��� ��� ������������ �������� � ��������� (��� ����������)
     SELECT lfObject_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_From FROM lfGet_Object_InfoMoney (vbInfoMoneyId_From) AS lfObject_InfoMoney;

     -- !!!���� ��� ������� ��� "�������� ������������", ����� ��� "������� ������"
     IF vbInfoMoneyDestinationId_From IN (zc_Enum_InfoMoneyDestination_30100() -- ���������
                                        , zc_Enum_InfoMoneyDestination_30200() -- ������ �����
                                         )
        AND vbBranchId_To = 0
     THEN
         vbBranchId_To:= zc_Branch_Basis();
     END IF;



     -- ��������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, ContainerId_GoodsPartner, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperCount_Partner, tmpOperSumm_Partner, OperSumm_Partner
                         , ContainerId_ProfitLoss_10700
                         , ContainerId_Partner, AccountId_Partner, ContainerId_Transit, AccountId_Transit, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_To
                         , isPartionCount, isPartionSumm, isTareReturning
                         , PartionGoodsId
                         , Price, CountForPrice)
        SELECT
              _tmp.MovementItemId
            , 0 AS ContainerId_Goods
            , 0 AS ContainerId_GoodsPartner
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate

            , _tmp.OperCount
            , _tmp.OperCount_Partner

              -- ������������� ����� �� ����������� !!! ��� ������ !!! - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_Partner
              -- �������� ����� �� �����������
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ������/������� ������ � ����!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ������/������� ������ � ����!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ������/������� ������ � ����!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Partner

              -- ���� - ������� (���� - ����� ���������)
            , 0 AS ContainerId_ProfitLoss_10700

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
            , CASE WHEN _tmp.BusinessId_To = 0 THEN vbBusinessId_To ELSE _tmp.BusinessId_To END AS BusinessId_To

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

            , _tmp.Price
            , _tmp.CountForPrice

        FROM 
             (SELECT
                    tmpMI.MovementItemId

                  , tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                  , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate
 
                  , tmpMI.Price
                  , tmpMI.CountForPrice
                    -- ���������� ��� ������
                  , tmpMI.OperCount
                    -- ���������� � �����������
                  , tmpMI.OperCount_Partner

                    -- ������������� ����� �� ����������� - � ����������� �� 2-� ������
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner

                    -- �������������� ����������
                  , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- ������ ����������
                  , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- ������ �� ������
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_To

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm

              FROM
             (SELECT (MovementItem.Id) AS MovementItemId
                   , MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                   , SUM (MovementItem.Amount) AS OperCount
                   , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS OperCount_Partner
                   , CASE WHEN vbDiscountPercent <> 0
                               THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          WHEN vbExtraChargesPercent <> 0
                               THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END AS Price
                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_ReturnIn()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
              GROUP BY MovementItem.Id
                     , MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
             ) AS tmpMI


                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = tmpMI.MovementItemId
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = tmpMI.MovementItemId
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = tmpMI.MovementItemId
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                           ON ObjectBoolean_PartionCount.ObjectId = tmpMI.GoodsId
                                          AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                           ON ObjectBoolean_PartionSumm.ObjectId = tmpMI.GoodsId
                                          AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                        ON ObjectLink_Goods_Business.ObjectId = tmpMI.GoodsId
                                       AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
             ) AS _tmp;


     -- ��������
     IF COALESCE (vbContractId, 0) = 0 AND (EXISTS (SELECT _tmpItem.isTareReturning FROM _tmpItem WHERE _tmpItem.isTareReturning = FALSE)
                                         -- OR !!! ��� !!!
                                           )
     THEN
         RAISE EXCEPTION '������.� ��������� �� ��������� <�������>.���������� ����������.';
     END IF;


     -- !!!
     -- IF NOT EXISTS (SELECT MovementItemId FROM _tmpItem) THEN RETURN; END IF;


     -- ������� ����
     SELECT -- ������ �������� ����� �� �����������
            CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END
            INTO vbOperSumm_Partner
     FROM (SELECT SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_Partner
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner
           FROM (SELECT _tmpItem.Price
                      , _tmpItem.CountForPrice
                      , SUM (_tmpItem.OperCount_Partner) AS OperCount_Partner
                      , SUM (_tmpItem.tmpOperSumm_Partner) AS tmpOperSumm_Partner
                 FROM _tmpItem
                 GROUP BY _tmpItem.Price
                        , _tmpItem.CountForPrice
                        , _tmpItem.GoodsId
                        , _tmpItem.GoodsKindId
                ) AS _tmpItem
          ) AS _tmpItem
     ;

     -- ������ �������� ���� �� ����������� (�� ���������)
     SELECT SUM (_tmpItem.OperSumm_Partner) INTO vbOperSumm_Partner_byItem FROM _tmpItem;

     -- ���� �� ����� ��� �������� ����� �� �����������
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_Partner = _tmpItem.OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_Partner IN (SELECT MAX (_tmpItem.OperSumm_Partner) FROM _tmpItem)
                                          );
     END IF;


     -- ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                AND vbOperDate >= zc_DateStart_PartionGoods()
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                               WHEN vbIsPartionDate_Unit = TRUE
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)
                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                   THEN 0

                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                 OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
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
     ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1.1.1. ������������ ContainerId_GoodsPartner ��� �������� �� ��������������� ����� - ����� ���������� ��� ���.����
     UPDATE _tmpItem SET ContainerId_GoodsPartner = -- 0)����� 1)����������
                                                    -- 0)����� 1)���.����
                                                    lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                                          , inParentId          := NULL
                                                                          , inObjectId          := _tmpItem.GoodsId
                                                                          , inJuridicalId_basis := NULL
                                                                          , inBusinessId        := NULL
                                                                          , inObjectCostDescId  := NULL
                                                                          , inObjectCostId      := NULL
                                                                          , inDescId_1          := CASE WHEN vbMemberId_From <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Partner() END
                                                                          , inObjectId_1        := CASE WHEN vbMemberId_From <> 0 THEN vbMemberId_From ELSE vbPartnerId_From END
                                                                          , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                                          , inObjectId_2        := vbBranchId_To
                                                                           )
     WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0;

     -- 1.1.2. ����������� �������� ��� ��������������� ����� - ����� ���������� ��� ���.����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_CountSupplier() AS DescId, vbMovementDescId, inMovementId, MovementItemId, ContainerId_GoodsPartner, 0 AS ParentId, -1 * OperCount, vbOperDate, FALSE
       FROM _tmpItem
       WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0;


     -- 1.2.1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId_To
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_To -- ��� ��������� ����� ��� �������
                                                                                 );
     -- 1.2.2. ����������� �������� ��� ��������������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId, ContainerId_Goods, 0 AS ParentId, OperCount, vbOperDate, TRUE
       FROM _tmpItem;
       -- WHERE OperCount <> 0;


     -- 1.2.3. ������ !!!���������� ���� �� ����������!!!, ������� �������
     DELETE FROM _tmpItem WHERE _tmpItem.isTareReturning = TRUE;


     -- 1.3.1. ����� ����������: ��������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10800, ContainerId, AccountId, OperSumm, OperSumm_Partner)
        SELECT
              _tmpItem.MovementItemId
            , 0 AS ContainerId_ProfitLoss_40208 -- ���� - ������� (���� - ������� � ���� : �/�1 - �/�2)
            , 0 AS ContainerId_ProfitLoss_10800 -- ���� - ������� (���� - ������������� ��������� : �/�2)
            , COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0)) AS ContainerId
            , COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) AS AccountId
              -- �/�1 - ��� ����������: ������ �� �������
            , SUM ((_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0))) AS OperSumm
              -- �/�2 - ��� ����������: �����������
            , SUM ((_tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0))) AS OperSumm_Partner
        FROM _tmpItem
             -- ��� ������� ��� ����
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItem.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis_To
                                                                                 -- AND lfContainerSumm_20901.BusinessId        = _tmpItem.BusinessId_To -- !!!���� �� ������� � ���������� �� �������!!!
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
          AND vbIsHistoryCost= TRUE -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
          AND (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) <> 0                -- ����� ���� !!!�� �����!!! 
            OR _tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0) <> 0)       -- ����� ���� !!!�� �����!!! 
        GROUP BY _tmpItem.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId;

     -- 1.3.2. ����������� �������� ��� ��������� ����� : �/�1
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId, 0 AS ParentId, _tmpItemSumm.OperSumm, vbOperDate, TRUE
       FROM _tmpItemSumm
       WHERE _tmpItemSumm.OperSumm <> 0;


     -- 2.1. ������� ���������� ��� �������� - �������
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_40208 = _tmpItem_byDestination.ContainerId_ProfitLoss_40208 -- ���� - ������� (���� - ������� � ���� : �/�1 - �/�2)
                           , ContainerId_ProfitLoss_10800 = _tmpItem_byDestination.ContainerId_ProfitLoss_10800 -- ���� - ������� (���� - ������������� ��������� : �/�2)
     FROM _tmpItem
          JOIN
          (SELECT -- ��� ����� ������� � ���� : �/�1 - �/�2
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "������� �������� �������"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_CountChange
                                         ) AS ContainerId_ProfitLoss_40208
                  -- ��� ����� ������������� ���������� : �/�2
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "������� �������� �������"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                         ) AS ContainerId_ProfitLoss_10800
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_To
           FROM (SELECT -- ���������� ProfitLossId - ��� ����� ������� � ���� : �/�1 - �/�2
                        CASE WHEN vbIsCorporate_From = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                                  THEN _tmpItem_group.ProfitLossId
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900()  -- ����      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  THEN zc_Enum_ProfitLoss_40208() -- ���������� �������� 40208; "������� � ����"
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                                  THEN zc_Enum_ProfitLoss_40208() -- ���������� �������� 40208; "������� � ����"
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_CountChange

                        -- ���������� ProfitLossId - ��� ����� ������������� ���������� : �/�2
                      , CASE WHEN vbIsCorporate_From = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                                  THEN _tmpItem_group.ProfitLossId
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900()  -- ����
                                  THEN zc_Enum_ProfitLoss_10802() -- ������������� ��������� 10802; "����"
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                                  THEN zc_Enum_ProfitLoss_10801() -- ������������� ��������� 10801; "���������"
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_To
                 FROM (SELECT CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ��������� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                        THEN zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- 70000; "�������������� �������"
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                        THEN zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- 70000; "�������������� �������"
                              END AS ProfitLossGroupId

                            , CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ��������� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                        THEN zc_Enum_ProfitLossDirection_10800() -- 10400; "������������� ���������"
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70100() -- 70300; "���������� ����� ���������"
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                        THEN zc_Enum_ProfitLossDirection_10800() -- 10400; "������������� ���������"
                                   WHEN vbMemberId_From <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- 70300; "���������� (���������, �����)"
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- 70200; "������"
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_To
                            , _tmpItem.ProfitLossId
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_To
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                                          WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- ����
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70101() -- ����
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70102() -- �����
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- �������
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- �������-���������
                                     END AS ProfitLossId
                             FROM _tmpItemSumm
                                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.BusinessId_To
                                    , _tmpItem.GoodsKindId
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_To
                              , _tmpItem.ProfitLossId
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BusinessId_To = _tmpItem.BusinessId_To
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 2.2. ����������� �������� - ������� (�������������)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       -- �������� �� ������� � ���� : �/�1 - �/�2
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss, 0 AS ParentId, -1 * _tmpItem_group.OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                  , SUM (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner) AS OperSumm
             FROM _tmpItemSumm
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_40208
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
      UNION ALL
       -- �������� �� ������������� ��������� : �/�2
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss, 0 AS ParentId, -1 * _tmpItem_group.OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItemSumm.ContainerId_ProfitLoss_10800 AS ContainerId_ProfitLoss
                  , SUM (_tmpItemSumm.OperSumm_Partner) AS OperSumm
             FROM _tmpItemSumm
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10800
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
       ;


     -- 3.1. ������������ ����(�����������) ��� �������� �� ���� ���������� ��� ���.���� (����������� ����)
     UPDATE _tmpItem SET AccountId_Partner = _tmpItem_byAccount.AccountId
                       , AccountId_Transit = CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110101() ELSE 0 END -- �������
     FROM (SELECT CASE WHEN vbIsCorporate_From = TRUE
                            THEN _tmpItem_group.AccountId
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- �������� -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                   END AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbMemberId_From <> 0
                                  THEN zc_Enum_AccountDirection_30500() -- ���.���� (����������� ����)  -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30500())
                             WHEN vbIsCorporate_From = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- ���� �������� -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30200())
                             WHEN vbInfoMoneyDestinationId_From IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                  , zc_Enum_InfoMoneyDestination_20700()  -- ������       -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700()
                                                                  , zc_Enum_InfoMoneyDestination_20900()  -- ����         -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                  , zc_Enum_InfoMoneyDestination_30100()  -- ���������    -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                                  , zc_Enum_InfoMoneyDestination_30200()) -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                  THEN zc_Enum_AccountDirection_30100() -- ���������� -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30100())
                             WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                    , zc_Enum_InfoMoneyDestination_20700()  -- ������       -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700()
                                                                    , zc_Enum_InfoMoneyDestination_20900()  -- ����         -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                    , zc_Enum_InfoMoneyDestination_30100()  -- ���������    -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                                    , zc_Enum_InfoMoneyDestination_30200()) -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                  THEN zc_Enum_AccountDirection_30100() -- ���������� -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30100())
                         -- ELSE zc_Enum_AccountDirection_30400() -- ������ �������� select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30400())
                            ELSE zc_Enum_AccountDirection_30100() -- ���������� -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30100())
                        END AS AccountDirectionId

                      , CASE WHEN vbIsCorporate_From = TRUE
                                   THEN vbInfoMoneyDestinationId_From -- zc_Enum_InfoMoneyDestination_30100() -- ���������
                             WHEN vbInfoMoneyDestinationId_From <> 0
                                  THEN vbInfoMoneyDestinationId_From -- ��: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                             ELSE _tmpItem.InfoMoneyDestinationId -- ����� ����� �� ������
                        END AS InfoMoneyDestinationId_calc

                      , _tmpItem.InfoMoneyDestinationId
                      , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30201() -- ����
                             WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30202() -- ����
                             WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30203() -- �����
                             WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30204() -- �������
                             WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30205() -- �������-���������
                        END AS AccountId

                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner <> 0 !!!������ ������������, �.�. ���� AccountId � ��������� ��� ������!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;


     -- 3.2. ������������ ContainerId ��� �������� �� ���� ���������� ��� ���.���� (����������� ����)
     UPDATE _tmpItem SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
                       , ContainerId_Transit = _tmpItem_byInfoMoney.ContainerId_Transit
     FROM (SELECT CASE WHEN vbMemberId_From <> 0
                                 -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���.���� (����������� ����) 2)NULL 3)NULL 4)������ ����������
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := _tmpItem_group.AccountId_Partner
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                       , inBusinessId        := _tmpItem_group.BusinessId_To
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_Member()
                                                       , inObjectId_1        := vbMemberId_From
                                                       , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                       , inObjectId_2        := _tmpItem_group.InfoMoneyId_calc
                                                       , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                       , inObjectId_3        := vbBranchId_To -- ���� ��������� ������ �� ������� ������
                                                       , inDescId_4          := zc_ContainerLinkObject_Car()
                                                       , inObjectId_4        := 0 -- ��� ���.���� (����������� ����) !!!������ ����� ��������� ��������� ������ �������� = 0!!!
                                                        )
                            -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                       WHEN vbIsCorporate_From = TRUE
                                 -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := _tmpItem_group.AccountId_Partner
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                       , inBusinessId        := _tmpItem_group.BusinessId_To
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                       , inObjectId_1        := vbJuridicalId_From
                                                       , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                       , inObjectId_2        := _tmpItem_group.InfoMoneyId_calc
                                                       , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                       , inObjectId_3        := vbContractId
                                                       , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                       , inObjectId_4        := vbPaidKindId
                                                        )
                            -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := _tmpItem_group.AccountId_Partner
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                  , inBusinessId        := _tmpItem_group.BusinessId_To
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                  , inObjectId_1        := vbJuridicalId_From
                                                  , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                  , inObjectId_2        := vbPaidKindId
                                                  , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                  , inObjectId_3        := vbContractId
                                                  , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                  , inObjectId_4        := _tmpItem_group.InfoMoneyId_calc
                                                  , inDescId_5          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                  , inObjectId_5        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() THEN vbPartnerId_From ELSE NULL END
                                                  , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                  , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() THEN vbBranchId_To ELSE NULL END
                                                   )
                  END AS ContainerId
                , CASE WHEN _tmpItem_group.AccountId_Transit = 0 OR vbMemberId_From <> 0
                            THEN 0
                            -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := _tmpItem_group.AccountId_Transit
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                  , inBusinessId        := _tmpItem_group.BusinessId_To
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                  , inObjectId_1        := vbJuridicalId_From
                                                  , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                  , inObjectId_2        := vbPaidKindId
                                                  , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                  , inObjectId_3        := vbContractId
                                                  , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                  , inObjectId_4        := _tmpItem_group.InfoMoneyId_calc
                                                  , inDescId_5          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                  , inObjectId_5        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END
                                                  , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                  , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbBranchId_To ELSE NULL END
                                                   )
                  END AS ContainerId_Transit
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.AccountId_Partner
                      , _tmpItem.AccountId_Transit
                      , _tmpItem.InfoMoneyId
                      , _tmpItem.BusinessId_To
                      , CASE WHEN vbInfoMoneyId_From <> 0
                                  THEN vbInfoMoneyId_From -- ��: ������ �� �������� -- ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                             WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20901 () -- 20901; "����"
                                  THEN zc_Enum_InfoMoney_30101 () -- 30101; "������� ���������"
                             ELSE _tmpItem.InfoMoneyId -- ����� ����� �� ������
                        END AS InfoMoneyId_calc
                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner <> 0 !!!������ ������������, �.�. ���� ContainerId � ��������� ��� ������!!!
                 GROUP BY _tmpItem.AccountId_Partner
                        , _tmpItem.AccountId_Transit
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_To
                ) AS _tmpItem_group
          ) AS _tmpItem_byInfoMoney
     WHERE _tmpItem.InfoMoneyId = _tmpItem_byInfoMoney.InfoMoneyId
     ;

     -- 3.3. ����������� �������� - ���� ���������� ��� ���.���� (����������� ����)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       -- ��� ������� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_Partner, 0 AS ParentId, -1 * _tmpItem_group.OperSumm
            , CASE WHEN _tmpItem_group.AccountId_Transit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
            , FALSE
       FROM (SELECT _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Transit, SUM (_tmpItem.OperSumm_Partner) AS OperSumm FROM _tmpItem GROUP BY _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Transit
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!����������� - ������ �������� �� �����������!!!
     UNION ALL
       -- ��� ��� �������� ��� ����� �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_Transit, 0 AS ParentId
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END * _tmpItem_group.OperSumm
            , tmpOperDate.OperDate
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN FALSE ELSE TRUE END AS IsActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            JOIN (SELECT _tmpItem.ContainerId_Transit, SUM (_tmpItem.OperSumm_Partner) AS OperSumm FROM _tmpItem WHERE _tmpItem.AccountId_Transit <> 0 GROUP BY _tmpItem.ContainerId_Transit
                 ) AS _tmpItem_group ON _tmpItem_group.OperSumm <> 0 -- !!!����������� - ������ �������� �� �����������!!!
     ;


     -- 4.1.1. ������� ���������� ��� �������� - ������� (����� ���������)
     UPDATE _tmpItem SET ContainerId_ProfitLoss_10700 = _tmpItem_byDestination.ContainerId_ProfitLoss_10700
     FROM (SELECT -- ��� ����� ���������
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "������� �������� �������"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                         ) AS ContainerId_ProfitLoss_10700
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_To
           FROM (SELECT -- ���������� ProfitLossId - ��� ����� ���������
                        CASE WHEN vbIsCorporate_From = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                                  THEN _tmpItem_group.ProfitLossId
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  THEN zc_Enum_ProfitLoss_10702() -- ����� ��������� 10102; "����"
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                                  THEN zc_Enum_ProfitLoss_10701() -- ����� ��������� 10101; "���������"
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner
                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_To
                 FROM (SELECT -- ����� !!!����!!! ��� � ��� �/� (�� �� �/� ������ ����� �.�. ����� ���� ��� �/�=0)
                              CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ��������� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                        THEN zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- 70000; "�������������� �������"
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                        THEN zc_Enum_ProfitLossGroup_10000() -- 10000; "��������� �������� ������������"
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- 70000; "�������������� �������"
                              END AS ProfitLossGroupId

                              -- ����� !!!������!!! (� THEN) ��� ��� �/�
                            , CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ��������� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                        THEN zc_Enum_ProfitLossDirection_10700() -- 10100; "����� ���������"
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70100() -- 70300; "���������� ����� ���������"
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                        THEN zc_Enum_ProfitLossDirection_10700() -- 10100; "����� ���������"
                                   WHEN vbMemberId_From <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- 70300; "���������� (���������, �����)"
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- 70200; "������"
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_To
                            , _tmpItem.ProfitLossId
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_To
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN _tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_InfoMoneyDestination_WorkProgress() ELSE _tmpItem.InfoMoneyDestinationId END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- ����
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70101() -- ����
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70102() -- �����
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- �������
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- �������-���������
                                     END AS ProfitLossId
                             FROM _tmpItem
                             -- !!!������ ������������, �.�. �������� ��� ������ ����� ������ ������!!!
                             -- WHERE _tmpItem.OperSumm_Partner <> 0
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.BusinessId_To
                                    , _tmpItem.GoodsKindId
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_To
                              , _tmpItem.ProfitLossId
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination
     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byDestination.InfoMoneyDestinationId
       AND _tmpItem.BusinessId_To = _tmpItem_byDestination.BusinessId_To;

     -- 4.1.2. ����������� �������� - ������� (����� ���������)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       -- ����� ���������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss, 0 AS ParentId, _tmpItem_group.OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItem.ContainerId_ProfitLoss_10700 AS ContainerId_ProfitLoss
                  , SUM (_tmpItem.OperSumm_Partner) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10700
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
       ;

     -- 5.1.1. ����������� �������� ��� ������ (�����: �����(�/�) <-> ����(������������� ��������-������ ������� � ����))
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
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                , _tmpCalc.MovementItemId
           FROM (SELECT _tmpItemSumm.MovementItemId
                      , _tmpItemSumm.ContainerId
                      , _tmpItemSumm.AccountId
                      , _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                      , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "������� �������� �������"
                      , (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner) AS OperSumm -- !!!����>0, ������ "�����", �.�. �� ���������� ���� ������ ��� ������ �� �����!!!
                                                                                            -- �.�. ������: Active=ContainerId_ProfitLoss � �����: Passive=ContainerId_ProfitLoss
                 FROM _tmpItemSumm
                ) AS _tmpCalc
           WHERE _tmpCalc.OperSumm <> 0
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;
     -- 5.1.2. ����������� �������� ��� ������ (�����: �����(�/�) <-> ����(������������� ��������))
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
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                , _tmpCalc.MovementItemId
           FROM (SELECT _tmpItemSumm.MovementItemId
                      , _tmpItemSumm.ContainerId
                      , _tmpItemSumm.AccountId
                      , _tmpItemSumm.ContainerId_ProfitLoss_10800 AS ContainerId_ProfitLoss
                      , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "������� �������� �������"
                      , (_tmpItemSumm.OperSumm_Partner) AS OperSumm -- !!!�� ���� >0, ������ "�����"!!!
                                                                    -- �.�. ������: Active=ContainerId_ProfitLoss � �����: Passive=ContainerId_ProfitLoss
                 FROM _tmpItemSumm
                ) AS _tmpCalc
           WHERE _tmpCalc.OperSumm <> 0
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     -- 5.2.1. ����������� �������� ��� ������ (�����: ��.���� <-> ����(����� ��������)) !!!����� ����� ����� �� �/�, � ���� ��� ��� ����� �������������� � ��� inAccountId_1 �� ����������!!! 
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
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "������� �������� �������"
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
                            , _tmpItem.ContainerId_ProfitLoss_10700 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "������� �������� �������"
                            , _tmpItem.OperSumm_Partner AS OperSumm -- !!!����, ������ "������"!!!
                                                                    -- �.�. ������: Active=ContainerId_ProfitLoss � �����: Passive=ContainerId_ProfitLoss
                       FROM _tmpItem
                      ) AS _tmpCalc_all
                      LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                                                                                                                         OR  (tmpOperDate.OperDate = vbOperDatePartner
                                                                                                                          AND COALESCE (_tmpCalc_all.AccountId_Transit, 0) <> 0)
                 -- !!!������ ������������, �.�. �������� ��� ������ ����� ������ ������!!!
                 -- WHERE _tmpCalc_all.OperSumm <> 0
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


     -- !!!6.0. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, vbBranchId_To)
     FROM (SELECT _tmpItem.MovementItemId
           FROM _tmpItem
          ) AS tmp;

     -- 6.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 6.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ReturnIn()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.09.14                                        * add zc_ContainerLinkObject_Branch to vbPartnerId_From
 05.09.14                                        * add zc_ContainerLinkObject_Branch to ���.���� (����������� ����)
 02.09.14                                        * add vbIsHistoryCost
 23.08.14                                        * add vbPartnerId_From
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 12.08.14                                        * add !!!����������� ����������!!!
 22.07.14                                        * add ...Price
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 04.05.14                                        * rem zc_Enum_AccountDirection_30400
 30.04.14                                        * set lp
 16.04.14                                        * err vbInfoMoneyDestinationId_To on 3.1. ������������ ����(�����������) ��� �������� �� ���� ���������� ��� ���.���� (���������, �����)
 08.04.14                                        * add Constant_InfoMoney_isCorporate_View
 08.04.14                                        * ��������� �������� ��� vbIsCorporate_From
 08.04.14                                        * add !!!������ ������������, �.�. �������� ��� ������ ����� ������ ������!!!
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 18.03.14                                        * add zc_Enum_InfoMoneyDestination_30200
 01.02.14                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM lpComplete_Movement_ReturnIn (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
