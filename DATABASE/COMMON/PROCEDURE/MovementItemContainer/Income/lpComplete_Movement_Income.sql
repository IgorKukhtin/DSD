-- Function: lpComplete_Movement_Income()

DROP FUNCTION IF EXISTS lpComplete_Movement_Income (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income(
    IN inMovementId        Integer               , -- ���� ���������
    IN inUserId            Integer               , -- ������������
    IN inIsLastComplete    Boolean  DEFAULT False  -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbContainerId_Analyzer Integer;
  DECLARE vbContainerId_Analyzer_Packer Integer;
  DECLARE vbWhereObjectId_Analyzer Integer;

  DECLARE vbMovementDescId Integer;

  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Packer_byItem TFloat;
  DECLARE vbOperSumm_PartnerTo_byItem TFloat;

  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Packer TFloat;
  DECLARE vbOperSumm_PartnerTo TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbChangePrice TFloat;

  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDatePartner TDateTime;
  DECLARE vbJuridicalId_From Integer;
  DECLARE vbIsCorporate_From Boolean;
  DECLARE vbInfoMoneyId_CorporateFrom Integer;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbCardFuelId_From Integer;
  DECLARE vbTicketFuelId_From Integer;
  DECLARE vbInfoMoneyGroupId_From Integer;
  DECLARE vbInfoMoneyDestinationId_From Integer;
  DECLARE vbInfoMoneyId_From Integer;

  DECLARE vbJuridicalId_To Integer;
  DECLARE vbPartnerId_To Integer;
  DECLARE vbInfoMoneyGroupId_To Integer;
  DECLARE vbInfoMoneyDestinationId_To Integer;
  DECLARE vbInfoMoneyId_To Integer;
  DECLARE vbPaidKindId_To Integer;
  DECLARE vbContractId_To Integer;
  DECLARE vbChangePercent_To TFloat;
  DECLARE vbIsAccount_30000 Boolean;

  DECLARE vbUnitId Integer;
  DECLARE vbCarId Integer;
  DECLARE vbMemberId_Driver Integer;
  DECLARE vbBranchId_To Integer;
  DECLARE vbBranchId_Car Integer;
  DECLARE vbAccountDirectionId_To Integer;
  DECLARE vbIsPartionDate_Unit Boolean;

  DECLARE vbMemberId_Packer Integer;
  DECLARE vbPaidKindId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbJuridicalId_Basis_To Integer;
  DECLARE vbBusinessId_To Integer;
  DECLARE vbBusinessId_Route Integer;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummPartner;
     -- !!!�����������!!! �������� ������� - �������� �� ����������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummPartner_To;
     -- !!!�����������!!! �������� ������� - �������� �� ���������� (������������), �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummPacker;
     -- !!!�����������!!! �������� ������� - �������� �� ���������� (��������), �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummDriver;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ����������� ������ ��� �����
     PERFORM lpInsertUpdate_MovementItemString (inDescId:= zc_MIString_PartionGoodsCalc()
                                              , inMovementItemId:= MovementItem.Id
                                              , inValueData:= CAST (COALESCE (Object_Goods.ObjectCode, 0) AS TVarChar)
                                                    || '-' || CAST (COALESCE (Object_Partner.ObjectCode, 0) AS TVarChar)
                                                    || '-' || TO_CHAR (Movement.OperDate, 'DD.MM.YYYY')
                                               )
     FROM MovementItem
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = MovementItem.MovementId
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
     WHERE MovementItem.MovementId = inMovementId
       AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- ������ �����
     ;

     -- ��� ��������� ����� ��� ������� �������� ���� �� ����������� � ���������� (������������) � ��� ������������ �������� � ���������
     SELECT _tmp.PriceWithVAT, _tmp.VATPercent, _tmp.DiscountPercent, _tmp.ExtraChargesPercent, _tmp.ChangePrice
          , _tmp.MovementDescId, _tmp.OperDate, _tmp.OperDatePartner, _tmp.JuridicalId_From, _tmp.isCorporate_From, _tmp.InfoMoneyId_CorporateFrom, _tmp.PartnerId_From, _tmp.MemberId_From, _tmp.CardFuelId_From, _tmp.TicketFuelId_From
          , _tmp.InfoMoneyId_From
          , _tmp.JuridicalId_To, _tmp.PartnerId_To, _tmp.InfoMoneyId_To, _tmp.PaidKindId_To, _tmp.ContractId_To, _tmp.ChangePercent_To, _tmp.isAccount_30000
          , _tmp.UnitId, _tmp.CarId, _tmp.MemberDriverId, _tmp.BranchId_To, _tmp.BranchId_Car, _tmp.AccountDirectionId_To, _tmp.isPartionDate_Unit
          , _tmp.MemberId_Packer, _tmp.PaidKindId, _tmp.ContractId, _tmp.JuridicalId_Basis_To, _tmp.BusinessId_To, _tmp.BusinessId_Route
            INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbChangePrice
               , vbMovementDescId, vbOperDate, vbOperDatePartner, vbJuridicalId_From, vbIsCorporate_From, vbInfoMoneyId_CorporateFrom, vbPartnerId_From, vbMemberId_From, vbCardFuelId_From, vbTicketFuelId_From
               , vbInfoMoneyId_From
               , vbJuridicalId_To, vbPartnerId_To, vbInfoMoneyId_To, vbPaidKindId_To, vbContractId_To, vbChangePercent_To, vbIsAccount_30000
               , vbUnitId, vbCarId, vbMemberId_Driver, vbBranchId_To, vbBranchId_Car, vbAccountDirectionId_To, vbIsPartionDate_Unit
               , vbMemberId_Packer, vbPaidKindId, vbContractId, vbJuridicalId_Basis_To, vbBusinessId_To, vbBusinessId_Route

     FROM (SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
                , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
                , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
                , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
                , COALESCE (MovementFloat_ChangePrice.ValueData, 0) AS ChangePrice

                , Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner
                , COALESCE (COALESCE (ObjectLink_CardFuel_Juridical.ChildObjectId, ObjectLink_Partner_Juridical.ChildObjectId), 0) AS JuridicalId_From
                , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                            THEN TRUE
                       ELSE COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE)
                  END AS isCorporate_From
                , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                            THEN ObjectLink_Juridical_InfoMoney.ChildObjectId
                       ELSE 0
                  END AS InfoMoneyId_CorporateFrom

                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner()    THEN Object_From.Id ELSE 0 END, 0) AS PartnerId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member()     THEN Object_From.Id ELSE 0 END, 0) AS MemberId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_CardFuel()   THEN Object_From.Id ELSE 0 END, 0) AS CardFuelId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_TicketFuel() THEN Object_From.Id ELSE 0 END, 0) AS TicketFuelId_From
                  -- �� ������ ���������� �����: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_From -- COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0)) AS InfoMoneyId_From

                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_PartnerTo_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_To
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN Object_To.Id ELSE 0 END, 0) AS PartnerId_To
                  -- ���������� �� ������ ���������� �����: ������ �� �������� 
                , COALESCE (ObjectLink_ContractTo_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_To
                , COALESCE (MovementLinkObject_PaidKindTo.ObjectId, 0)        AS PaidKindId_To
                , COALESCE (MovementLinkObject_ContractTo.ObjectId, 0)        AS ContractId_To
                , COALESCE (MovementFloat_ChangePercentPartner.ValueData, 0)  AS ChangePercent_To
                , CASE WHEN ObjectLink_PartnerFrom_Unit.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isAccount_30000

                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN Object_To.Id ELSE 0 END, 0) AS UnitId
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Car() THEN Object_To.Id ELSE 0 END, 0) AS CarId
                , COALESCE (ObjectLink_PersonalDriver_Member.ChildObjectId, 0) AS MemberDriverId
                , COALESCE (ObjectLink_UnitTo_Branch.ChildObjectId, 0) AS BranchId_To
                , COALESCE (ObjectLink_UnitCar_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId_Car
                  -- ��������� ������ - �����������
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Car()
                                      THEN zc_Enum_AccountDirection_20500() -- 20000; "������"; 20500; "���������� (��)"
                                 ELSE ObjectLink_UnitTo_AccountDirection.ChildObjectId
                            END, 0) AS AccountDirectionId_To
                , COALESCE (ObjectBoolean_PartionDate.ValueData, FALSE)  AS isPartionDate_Unit

                , COALESCE (MovementLinkObject_PersonalPacker.ObjectId, 0) AS MemberId_Packer
                , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
                , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_ContractTo_JuridicalBasis.ChildObjectId ELSE ObjectLink_UnitTo_Juridical.ChildObjectId END, 0) AS JuridicalId_Basis_To
                , COALESCE (ObjectLink_UnitTo_Business.ChildObjectId, 0)    AS BusinessId_To
                , COALESCE (ObjectLink_UnitRoute_Business.ChildObjectId, 0) AS BusinessId_Route

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
                LEFT JOIN MovementFloat AS MovementFloat_ChangePrice
                                        ON MovementFloat_ChangePrice.MovementId =  Movement.Id
                                       AND MovementFloat_ChangePrice.DescId = zc_MovementFloat_ChangePrice()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_PartnerFrom_Unit
                                     ON ObjectLink_PartnerFrom_Unit.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_PartnerFrom_Unit.DescId = zc_ObjectLink_Partner_Unit()

                LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical
                                     ON ObjectLink_CardFuel_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                        ON ObjectBoolean_isCorporate.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                       AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                                     ON ObjectLink_Juridical_InfoMoney.ObjectId = COALESCE (ObjectLink_CardFuel_Juridical.ChildObjectId, ObjectLink_Partner_Juridical.ChildObjectId)
                                    AND ObjectLink_Juridical_InfoMoney.DescId   = zc_ObjectLink_Juridical_InfoMoney()
                LEFT JOIN Constant_InfoMoney_isCorporate_View ON Constant_InfoMoney_isCorporate_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Juridical
                                     ON ObjectLink_PartnerTo_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_PartnerTo_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                LEFT JOIN ObjectLink AS ObjectLink_CarTo_Unit
                                     ON ObjectLink_CarTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_CarTo_Unit.DescId = zc_ObjectLink_Car_Unit()
                LEFT JOIN ObjectLink AS ObjectLink_UnitCar_Branch
                                     ON ObjectLink_UnitCar_Branch.ObjectId = ObjectLink_CarTo_Unit.ChildObjectId
                                    AND ObjectLink_UnitCar_Branch.DescId = zc_ObjectLink_Unit_Branch()

                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                     ON ObjectLink_UnitTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                                     ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_UnitTo_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                        ON ObjectBoolean_PartionDate.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                             ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                            AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalPacker
                                             ON MovementLinkObject_PersonalPacker.MovementId = Movement.Id
                                            AND MovementLinkObject_PersonalPacker.DescId = zc_MovementLinkObject_PersonalPacker()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                             ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                     ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                    AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindTo
                                             ON MovementLinkObject_PaidKindTo.MovementId = Movement.Id
                                            AND MovementLinkObject_PaidKindTo.DescId = zc_MovementLinkObject_PaidKindTo()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractTo
                                             ON MovementLinkObject_ContractTo.MovementId = Movement.Id
                                            AND MovementLinkObject_ContractTo.DescId = zc_MovementLinkObject_ContractTo()
                LEFT JOIN ObjectLink AS ObjectLink_ContractTo_InfoMoney
                                     ON ObjectLink_ContractTo_InfoMoney.ObjectId = MovementLinkObject_ContractTo.ObjectId
                                    AND ObjectLink_ContractTo_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_ContractTo_JuridicalBasis
                                     ON ObjectLink_ContractTo_JuridicalBasis.ObjectId = MovementLinkObject_ContractTo.ObjectId
                                    AND ObjectLink_ContractTo_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Unit
                                     ON ObjectLink_PartnerTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_PartnerTo_Unit.DescId = zc_ObjectLink_Partner_Unit()

                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Juridical
                                     ON ObjectLink_UnitTo_Juridical.ObjectId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, MovementLinkObject_To.ObjectId)
                                    AND ObjectLink_UnitTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Business
                                     ON ObjectLink_UnitTo_Business.ObjectId = COALESCE (ObjectLink_PartnerTo_Unit.ChildObjectId, COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, MovementLinkObject_To.ObjectId))
                                    AND ObjectLink_UnitTo_Business.DescId = zc_ObjectLink_Unit_Business()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                             ON MovementLinkObject_Route.MovementId = Movement.Id
                                            AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
                LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                     ON ObjectLink_Route_Unit.ObjectId = MovementLinkObject_Route.ObjectId
                                    AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
                LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Business
                                     ON ObjectLink_UnitRoute_Business.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                    AND ObjectLink_UnitRoute_Business.DescId = zc_ObjectLink_Unit_Business()

                LEFT JOIN ObjectLink AS ObjectLink_PersonalDriver_Member
                                     ON ObjectLink_PersonalDriver_Member.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                    AND ObjectLink_PersonalDriver_Member.DescId = zc_ObjectLink_Personal_Member()

           WHERE Movement.Id = inMovementId
             AND Movement.DescId = zc_Movement_Income()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmp;


     -- ������������ �������������� ����������, �������� ����� ��� ��� ������������ �������� � ���������
     SELECT lfGet_InfoMoney.InfoMoneyGroupId, lfGet_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyGroupId_From, vbInfoMoneyDestinationId_From FROM lfGet_Object_InfoMoney (vbInfoMoneyId_From) AS lfGet_InfoMoney;
     -- ���������� ������������ �������������� ����������, �������� ����� ��� ��� ������������ �������� � ���������
     SELECT lfGet_InfoMoney.InfoMoneyGroupId, lfGet_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyGroupId_To, vbInfoMoneyDestinationId_To FROM lfGet_Object_InfoMoney (vbInfoMoneyId_To) AS lfGet_InfoMoney;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods, ContainerId_CountSupplier, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                         , ContainerId_GoodsTicketFuel, GoodsId_TicketFuel
                         , OperCount, OperCount_Partner, OperCount_Packer, tmpOperSumm_Partner, OperSumm_Partner, tmpOperSumm_Packer, OperSumm_Packer, tmpOperSumm_PartnerTo, OperSumm_PartnerTo
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId, InfoMoneyGroupId_Detail, InfoMoneyDestinationId_Detail, InfoMoneyId_Detail
                         , BusinessId, UnitId_Asset
                         , isPartionCount, isPartionSumm, isCountSupplier
                         , PartionGoodsId)
        SELECT
              _tmp.MovementItemId
            , 0 AS ContainerId_Summ          -- ���������� �����
            , 0 AS ContainerId_Goods         -- ���������� �����
            , 0 AS ContainerId_CountSupplier -- ���������� �����
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate

            , 0 AS ContainerId_GoodsTicketFuel
            , _tmp.GoodsId_TicketFuel

            , _tmp.OperCount
            , _tmp.OperCount_Partner
            , _tmp.OperCount_Packer

              -- ������������� ����� �� ����������� - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_Partner_ChangePrice AS tmpOperSumm_Partner
              -- �������� ����� �� �����������
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                ELSE (tmpOperSumm_Partner_ChangePrice)
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Partner

              -- ������������� ����� �� ���������� (������������) - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_Packer
              -- �������� ����� �� ���������� (������������)
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                                ELSE (tmpOperSumm_Packer)
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Packer

              -- ������������� ����� �� ���������� - � ����������� �� 2-� ������
            , 0 AS tmpOperSumm_PartnerTo
              -- �������� ����� �� ����������
            , 0 AS OperSumm_PartnerTo
              
            , 0 AS AccountId              -- ����(�����������), ���������� �����
            , _tmp.InfoMoneyGroupId       -- �������������� ������
            , _tmp.InfoMoneyDestinationId -- �������������� ����������
            , _tmp.InfoMoneyId            -- ������ ����������

              -- �������������� ������ (����������� �/�), ��� �� !!!�������������!!! �� ���� �����������
            , CASE WHEN vbInfoMoneyGroupId_From <> 0
                        THEN vbInfoMoneyGroupId_From -- �� ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                   ELSE _tmp.InfoMoneyGroupId -- �� ������� �� ������
              END AS InfoMoneyGroupId_Detail

              -- �������������� ���������� (����������� �/�), ��� �� !!!�������������!!! �� ���� �����������
            , CASE WHEN vbInfoMoneyDestinationId_From <> 0
                        THEN vbInfoMoneyDestinationId_From -- �� ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                   ELSE _tmp.InfoMoneyDestinationId -- �� ������� �� ������
              END AS InfoMoneyDestinationId_Detail

              -- ������ ���������� (����������� �/�), ��� �� !!!�������������!!! �� ���� �����������
            , CASE WHEN vbInfoMoneyId_From <> 0
                        THEN vbInfoMoneyId_From -- �� ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                   ELSE _tmp.InfoMoneyId -- ����� �� ������� �� ������
              END AS InfoMoneyId_Detail

              -- �������� ������ !!!����������!!! �� 1)���������� ��� 2)������ ��� 3)������������
            , CASE WHEN _tmp.BusinessId = 0 THEN vbBusinessId_To ELSE _tmp.BusinessId END AS BusinessId 
            , 0 AS UnitId_Asset -- !!!����� ��������!!!

            , _tmp.isPartionCount
            , _tmp.isPartionSumm 
              -- ���� �� ������ ������������ �������� ��� �������������� ���� - ����� ����������
            , CASE WHEN _tmp.Price = 0
                    AND vbMemberId_From = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                        THEN TRUE
                   ELSE FALSE
               END AS isCountSupplier

            , 0 AS PartionGoodsId -- ������ ������, ���������� �����

        FROM (SELECT
                     MovementItem.Id AS MovementItemId
                     -- ���� ��� �������, ����� - �����
                   , COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, MovementItem.ObjectId) AS GoodsId
                   , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ELSE 0 END AS GoodsKindId -- ���� + ������� ���������
                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , CASE WHEN COALESCE (MIString_PartionGoods.ValueData, '') <> '' THEN MIString_PartionGoods.ValueData
                          WHEN COALESCE (MIString_PartionGoodsCalc.ValueData, '') <> '' THEN MIString_PartionGoodsCalc.ValueData
                          ELSE ''
                     END AS PartionGoods
                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate
 
                   , MovementItem.ObjectId AS GoodsId_TicketFuel

                   , MovementItem.Amount                           AS OperCount
                   , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS OperCount_Partner
                   , COALESCE (MIFloat_AmountPacker.ValueData, 0)  AS OperCount_Packer
                   , COALESCE (MIFloat_Price.ValueData, 0)         AS Price

                     -- ������������� ����� �� ����������� - � ����������� �� 2-� ������
                   , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                  ELSE COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                     END AS tmpOperSumm_Partner
                     -- ������������� ����� �� ����������� � ������ ������ � ���� - � ����������� �� 2-� ������
                   , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPartner.ValueData * (MIFloat_Price.ValueData - vbChangePrice) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                  ELSE COALESCE (CAST (MIFloat_AmountPartner.ValueData * (MIFloat_Price.ValueData - vbChangePrice) AS NUMERIC (16, 2)), 0)
                     END AS tmpOperSumm_Partner_ChangePrice

                     -- ������������� ����� �� ���������� (������������) - � ����������� �� 2-� ������
                   , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                  ELSE COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                     END AS tmpOperSumm_Packer

                    -- �������������� ������
                  , CASE WHEN COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, 0) <> 0 THEN COALESCE (lfGet_InfoMoney_Fuel.InfoMoneyGroupId, 0)
                         ELSE COALESCE (View_InfoMoney.InfoMoneyGroupId, 0)
                    END AS InfoMoneyGroupId
                    -- �������������� ����������
                  , CASE WHEN COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, 0) <> 0 THEN COALESCE (lfGet_InfoMoney_Fuel.InfoMoneyDestinationId, 0)
                         ELSE COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0)
                    END AS InfoMoneyDestinationId
                    -- ������ ����������
                  , CASE WHEN COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, 0) <> 0 THEN COALESCE (lfGet_InfoMoney_Fuel.InfoMoneyId, 0)
                         ELSE COALESCE (View_InfoMoney.InfoMoneyId, 0)
                    END AS InfoMoneyId

                    -- ������ �� ������ ����� ������ ���� �� <��� �������>
                  , CASE WHEN COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, 0) <> 0 THEN 0
                         ELSE COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0)
                    END AS BusinessId

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

                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                               ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()

                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemString AS MIString_PartionGoodsCalc
                                                ON MIString_PartionGoodsCalc.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoodsCalc.DescId = zc_MIString_PartionGoodsCalc()
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
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                        ON ObjectLink_Goods_Fuel.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                                       AND ObjectLink_Goods_Fuel.ChildObjectId <> 0 -- !!!�����������, ��� � ����� ������������ COALESCE!!!
                                       AND vbCarId <> 0 -- !!!�����������, �.�. � ��������� ������� ����� �����!!!

                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                    AND ObjectLink_Goods_Fuel.ChildObjectId IS NULL
                   LEFT JOIN lfGet_Object_InfoMoney (zc_Enum_InfoMoney_20401()) AS lfGet_InfoMoney_Fuel ON ObjectLink_Goods_Fuel.ChildObjectId <> 0 -- ���

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Income()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp
        ;

     -- !!!����������� ����� ����������!!!
     UPDATE _tmpItem SET tmpOperSumm_PartnerTo = CAST ((1 + vbChangePercent_To / 100)
                                               * CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                                                           -- ���� ���� � ��� ��� %���=0
                                                           THEN (tmpOperSumm_Partner)
                                                      -- ���� ���� ��� ���
                                                      ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                                                 END AS NUMERIC (16, 2))
                       , OperSumm_PartnerTo    = CAST ((1 + vbChangePercent_To / 100)
                                               * CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                                                           -- ���� ���� � ��� ��� %���=0
                                                           THEN (tmpOperSumm_Partner)
                                                      -- ���� ���� ��� ���
                                                      ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                                                 END AS NUMERIC (16, 2))
     WHERE vbPartnerId_To <> 0;

     -- ��������
     IF 1=0 AND COALESCE (vbContractId, 0) = 0 AND (EXISTS (SELECT _tmpItem.isCountSupplier FROM _tmpItem WHERE _tmpItem.isCountSupplier = FALSE AND OperSumm_Partner <> 0)
                                       -- AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!! ��� !!!
                                           )
     THEN
         RAISE EXCEPTION '������.� ��������� �� ��������� <�������>.���������� ����������.';
     END IF;

     -- ��������
     IF COALESCE (vbContractId_To, 0) = 0 AND vbPartnerId_To <> 0
     THEN
         RAISE EXCEPTION '������.� ��������� �� ��������� <������� (����������)>.���������� ����������.';
     END IF;

     -- �������� - ���� ���� ����� < 0, �� <������>
     IF EXISTS (SELECT MovementItemId FROM _tmpItem WHERE tmpOperSumm_Partner < 0 OR OperSumm_Partner < 0 OR OperSumm_PartnerTo < 0)
     THEN
         RAISE EXCEPTION '������.���� �������� � ������������� ������.';
     END IF;


     -- !!!
     -- IF NOT EXISTS (SELECT MovementItemId FROM _tmpItem) THEN RETURN; END IF;


     -- ������� ����
     SELECT -- ������ �������� ����� �� �����������
            CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END
            -- ������ �������� ����� �� ���������� (������������) (����� ��� �� ��� � ��� �����������)
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                              ELSE tmpOperSumm_Packer
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * tmpOperSumm_Packer AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * tmpOperSumm_Packer AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                         END
            END
            -- ������ �������� ����� �� ����������
          , CAST ((1 + vbChangePercent_To / 100)
          * CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0
                    THEN tmpOperSumm_Partner
                 -- ���� ���� ��� ���
                 ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
            END AS NUMERIC (16, 2))

            INTO vbOperSumm_Partner, vbOperSumm_Packer, vbOperSumm_PartnerTo

     FROM (SELECT SUM (_tmpItem.tmpOperSumm_Partner) AS tmpOperSumm_Partner
                , SUM (_tmpItem.tmpOperSumm_Packer) AS tmpOperSumm_Packer
           FROM _tmpItem
          ) AS _tmpItem
     ;


     -- ������ �������� ���� (�� ���������)
     SELECT SUM (OperSumm_Partner), SUM (OperSumm_Packer), SUM (OperSumm_PartnerTo) INTO vbOperSumm_Partner_byItem, vbOperSumm_Packer_byItem, vbOperSumm_PartnerTo_byItem FROM _tmpItem;

     -- ���� �� ����� ��� �������� ����� �� �����������
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_Partner = OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpItem WHERE OperSumm_Partner IN (SELECT MAX (OperSumm_Partner) FROM _tmpItem)
                                 );
     END IF;

     -- ���� �� ����� ��� �������� ����� �� ���������� (������������)
     IF COALESCE (vbOperSumm_Packer, 0) <> COALESCE (vbOperSumm_Packer_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_Packer = OperSumm_Packer - (vbOperSumm_Packer_byItem - vbOperSumm_Packer)
         WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpItem WHERE OperSumm_Packer IN (SELECT MAX (OperSumm_Packer) FROM _tmpItem)
                                 );
     END IF;

     -- ���� �� ����� ��� �������� ����� �� ����������
     IF COALESCE (vbOperSumm_PartnerTo, 0) <> COALESCE (vbOperSumm_PartnerTo_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_PartnerTo = OperSumm_PartnerTo - (vbOperSumm_PartnerTo_byItem - vbOperSumm_PartnerTo)
         WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpItem WHERE OperSumm_PartnerTo IN (SELECT MAX (OperSumm_PartnerTo) FROM _tmpItem)
                                 );
     END IF;


     -- ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                AND vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                   THEN lpInsertFind_Object_PartionGoods (inValue:= _tmpItem.PartionGoods)

                                               WHEN vbIsPartionDate_Unit
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                   THEN lpInsertFind_Object_PartionGoods (inOperDate:= _tmpItem.PartionGoodsDate)
                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                   THEN 0

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
     ;

     -- ��������� ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������, ����� �� !!!InfoMoneyId_Detail!!!
     -- !!!������ ���� �� �����!!!
     INSERT INTO _tmpItem_SummPartner (ContainerId, AccountId, ContainerId_Transit, AccountId_Transit, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId, BusinessId, UnitId_Asset, GoodsId, OperSumm_Partner)
        SELECT 0 AS ContainerId, 0 AS AccountId, 0 AS ContainerId_Transit, 0 AS AccountId_Transit
             , _tmpSumm.InfoMoneyGroupId_Detail, _tmpSumm.InfoMoneyDestinationId_Detail, _tmpSumm.InfoMoneyId_Detail, _tmpSumm.BusinessId, _tmpSumm.UnitId_Asset
             , _tmpSumm.GoodsId
             , SUM (_tmpSumm.OperSumm_Partner) AS OperSumm_Partner
        FROM (SELECT _tmpSumm_all.InfoMoneyGroupId_Detail
                   , _tmpSumm_all.InfoMoneyDestinationId_Detail
                   , _tmpSumm_all.InfoMoneyId_Detail
                   , _tmpSumm_all.BusinessId
                   , _tmpSumm_all.UnitId_Asset
                   , _tmpSumm_all.GoodsId
                   , _tmpSumm_all.OperSumm_Partner
              FROM (SELECT _tmpItem.InfoMoneyGroupId_Detail, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyDestinationId_Detail, _tmpItem.InfoMoneyId_Detail, _tmpItem.BusinessId, _tmpItem.UnitId_Asset, _tmpItem.GoodsId
                         , SUM (_tmpItem.OperSumm_Partner) AS OperSumm_Partner
                    FROM _tmpItem
                    -- ����� �.�. ���� ���� �������� ������ ���� (!!!��� �������!!!)
                    -- WHERE _tmpItem.OperSumm_Partner <> 0 AND zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
                    WHERE vbTicketFuelId_From = 0
                    GROUP BY _tmpItem.InfoMoneyGroupId_Detail, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyDestinationId_Detail, _tmpItem.InfoMoneyId_Detail, _tmpItem.BusinessId, _tmpItem.UnitId_Asset, _tmpItem.GoodsId
                   ) AS _tmpSumm_all
             ) AS _tmpSumm
        GROUP BY _tmpSumm.InfoMoneyGroupId_Detail, _tmpSumm.InfoMoneyDestinationId_Detail, _tmpSumm.InfoMoneyId_Detail, _tmpSumm.BusinessId, _tmpSumm.UnitId_Asset, _tmpSumm.GoodsId;

     -- ��������� ������� - �������� �� ����������, �� ����� ���������� ��� ������������ �������� � ���������, ����� �� !!!MovementItemId!!!
     INSERT INTO _tmpItem_SummPartner_To (MovementItemId, ContainerId_Goods, ContainerId, AccountId, ContainerId_ProfitLoss_70201, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId, BusinessId, GoodsId, OperCount_PartnerFrom, OperCount, OperSumm_Partner, OperSumm_70201)
        SELECT _tmpSumm.MovementItemId
             , 0 AS ContainerId_Goods, 0 AS ContainerId, 0 AS AccountId, 0 AS ContainerId_ProfitLoss_70201
             , vbInfoMoneyGroupId_To, vbInfoMoneyDestinationId_To, vbInfoMoneyId_To
             , _tmpSumm.BusinessId
             , _tmpSumm.GoodsId
             , (_tmpSumm.OperCount_PartnerFrom)                          AS OperCount_PartnerFrom
             , (_tmpSumm.OperCount)                                      AS OperCount
             , (_tmpSumm.OperSumm_PartnerTo)                             AS OperSumm_Partner
             , (_tmpSumm.OperSumm_PartnerTo - _tmpSumm.OperSumm_Partner) AS OperSumm_70201
        FROM (SELECT _tmpSumm_all.MovementItemId
                   , _tmpSumm_all.BusinessId
                   , _tmpSumm_all.GoodsId
                   , _tmpSumm_all.OperCount_PartnerFrom
                   , _tmpSumm_all.OperCount
                   , _tmpSumm_all.OperSumm_Partner
                   , _tmpSumm_all.OperSumm_PartnerTo
              FROM (SELECT _tmpItem.MovementItemId
                         , _tmpItem.BusinessId, _tmpItem.GoodsId
                         , (_tmpItem.OperCount_Partner)  AS OperCount_PartnerFrom
                         , (_tmpItem.OperCount)          AS OperCount
                         , (_tmpItem.OperSumm_Partner)   AS OperSumm_Partner
                         , (_tmpItem.OperSumm_PartnerTo) AS OperSumm_PartnerTo
                    FROM _tmpItem
                    -- ����� �.�. ���� ���� �������� ������ ���� (!!!��� �������!!!)
                    -- WHERE _tmpItem.OperSumm_PartnerTo <> 0 AND zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
                    WHERE vbPartnerId_To <> 0
                    -- GROUP BY _tmpItem.BusinessId, _tmpItem.GoodsId
                   ) AS _tmpSumm_all
             ) AS _tmpSumm
        -- GROUP BY _tmpSumm.BusinessId, _tmpSumm.GoodsId
       ;

     -- ��������� ������� - �������� �� ���������� (������������), �� ����� ���������� ��� ������������ �������� � ���������, ����� �� !!!InfoMoneyId!!!
     INSERT INTO _tmpItem_SummPacker (ContainerId, AccountId, InfoMoneyDestinationId, InfoMoneyId, BusinessId, OperSumm_Packer)
        SELECT 0 AS ContainerId, 0 AS AccountId
             , _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.BusinessId
             , SUM (_tmpItem.OperSumm_Packer) AS OperSumm_Packer
        FROM _tmpItem
        -- ����� �.�. ���� ���� �������� ������ ���� (!!!��� �������!!!)
        -- WHERE _tmpItem.OperSumm_Packer <> 0 AND zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
        WHERE vbMemberId_Packer <> 0
        GROUP BY _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.BusinessId;

     -- ��������� ������� - �������� �� ���������� (��������), �� ����� ���������� ��� ������������ �������� � ���������, ����� �� !!!InfoMoneyId!!!
     -- !!!�� ������� �������� �� �����������!!! � !!!������ ���� zc_Enum_PaidKind_SecondForm!!! � !!!������ ���� ����������!!! � !!!�� ����� � �� �����!!!
     INSERT INTO _tmpItem_SummDriver (ContainerId, AccountId, ContainerId_Transit, AccountId_Transit, InfoMoneyDestinationId, InfoMoneyId, BusinessId, OperSumm_Driver)
        SELECT 0 AS ContainerId, 0 AS AccountId, 0 AS ContainerId_Transit, 0 AS AccountId_Transit
             , _tmpItem_SummPartner.InfoMoneyDestinationId, _tmpItem_SummPartner.InfoMoneyId
               -- !!!��� ��������� (��������) ����������� ������ ������!!!
             , vbBusinessId_Route
             , SUM (_tmpItem_SummPartner.OperSumm_Partner)
        FROM _tmpItem_SummPartner
        WHERE vbPaidKindId = zc_Enum_PaidKind_SecondForm()
          AND vbCardFuelId_From = 0
          AND vbTicketFuelId_From = 0
          AND vbCarId <> 0
        GROUP BY _tmpItem_SummPartner.InfoMoneyDestinationId, _tmpItem_SummPartner.InfoMoneyId;



     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 2.0.1.1. ������������ ����(�����������) ��� �������� �� ���� ���������� ��� ���.���� (����������� ����)
     UPDATE _tmpItem_SummPartner SET AccountId         = _tmpItem_byAccount.AccountId
                                   , AccountId_Transit = CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 THEN zc_Enum_Account_110101() ELSE 0 END -- �������
     FROM (SELECT CASE WHEN vbIsCorporate_From = TRUE
                            THEN _tmpItem_group.AccountId
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                  END AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbMemberId_From <> 0
                                  THEN zc_Enum_AccountGroup_30000() -- ��������  -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())

                             WHEN vbIsCorporate_From = TRUE
                                  THEN zc_Enum_AccountGroup_30000() -- �������� -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())

                             WHEN vbIsAccount_30000 = TRUE
                                  THEN zc_Enum_AccountGroup_30000() -- �������� -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())

                             ELSE zc_Enum_AccountGroup_70000()  -- ��������� select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_70000())
                        END AS AccountGroupId
                      , CASE WHEN vbMemberId_From <> 0
                                  THEN zc_Enum_AccountDirection_30500() -- ���������� (����������� ����)  -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30500())

                             WHEN vbIsCorporate_From = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- ���� �������� -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30200())

                             WHEN _tmpItem_SummPartner.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- ����������
                                  THEN zc_Enum_AccountDirection_70800() -- ��������� + ���������������� �� !!!�����������-��� ����, ���� ����� ������� � �������������� ���...!!!

                             WHEN vbIsAccount_30000 = TRUE
                                  THEN zc_Enum_AccountDirection_30100() -- �������� + ���������� 

                             ELSE zc_Enum_AccountDirection_70100() -- ���������� select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_70100())
                        END AS AccountDirectionId
                      , _tmpItem_SummPartner.InfoMoneyDestinationId
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
                 FROM _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.InfoMoneyGroupId, _tmpItem_SummPartner.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPartner.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 2.0.1.2. ������������ ContainerId ��� �������� �� ���� ���������� ��� ���.���� (����������� ����)
     UPDATE _tmpItem_SummPartner SET ContainerId         = tmp.ContainerId
                                   , ContainerId_Transit = tmp.ContainerId_Transit
     FROM (SELECT tmp.AccountId, tmp.AccountId_Transit, tmp.BusinessId, tmp.InfoMoneyId
                                                               , CASE WHEN vbMemberId_From <> 0
                                                                                -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������(����������� ����) 2)NULL 3)NULL 4)������ ���������� 5)����������
                                                                           THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Member()
                                                                                                      , inObjectId_1        := vbMemberId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_2        := tmp.InfoMoneyId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                                                                      , inObjectId_3        := zc_Branch_Basis() -- ���� ��������� ������ �� ������� �������
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_Car()
                                                                                                      , inObjectId_4        := 0 -- ��� ���.���� (����������� ����) !!!������ ����� ��������� ��������� ������ �������� = 0!!!
                                                                                                       )
                                                                                -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ���������� 5)������ ���������
                                                                           ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_2        := vbContractId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_3        := tmp.InfoMoneyId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_4        := vbPaidKindId
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := 0 -- !!!�� ���� ��������� ���� ���� �� �����!!!
                                                                                                      , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                      , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END
                                                                                                      , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                      , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_Branch_Basis() ELSE NULL END -- ���� ���������� ������ �� ������� ������� 
                                                                                                      , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                                                                      , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                                                                       )
                                                                   END AS ContainerId
                                                                 , CASE WHEN tmp.AccountId_Transit = 0 OR vbMemberId_From <> 0
                                                                           THEN 0
                                                                                -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ���������� 5)������ ���������
                                                                           ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId_Transit
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_2        := vbContractId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_3        := tmp.InfoMoneyId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_4        := vbPaidKindId
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := 0 -- !!!�� ���� ��������� ���� ���� �� �����!!!
                                                                                                      , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                      , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END
                                                                                                      , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                      , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_Branch_Basis() ELSE NULL END -- ���� ���������� ������ �� ������� ������� 
                                                                                                      , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                                                                      , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                                                                       )
                                                                   END AS ContainerId_Transit
           FROM (SELECT _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.AccountId_Transit, _tmpItem_SummPartner.BusinessId, _tmpItem_SummPartner.InfoMoneyId
                 FROM _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.AccountId_Transit, _tmpItem_SummPartner.BusinessId, _tmpItem_SummPartner.InfoMoneyId
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_SummPartner.AccountId         = tmp.AccountId
       AND _tmpItem_SummPartner.AccountId_Transit = tmp.AccountId_Transit
       AND _tmpItem_SummPartner.BusinessId        = tmp.BusinessId
       AND _tmpItem_SummPartner.InfoMoneyId       = tmp.InfoMoneyId
    ;


     -- 2.0.2.1. ������������ ContainerId_Goods ��� "�����������" �������� ��������������� ����� �� ����������
     UPDATE _tmpItem_SummPartner_To SET ContainerId_Goods = tmp.ContainerId
     FROM                            (SELECT _tmpItem.GoodsId
                                           , lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- �� "���� �����"
                                                                                , inUnitId                 := vbPartnerId_To
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
                 FROM _tmpItem_SummPartner_To AS _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.GoodsId, _tmpItem_SummPartner.InfoMoneyDestinationId
                ) AS _tmpItem
          ) AS tmp
     WHERE _tmpItem_SummPartner_To.GoodsId = tmp.GoodsId
    ;

     -- 2.0.2.2. ������������ ����(�����������) ��� �������� �� ���� ����������
     UPDATE _tmpItem_SummPartner_To SET AccountId = _tmpItem_byAccount.AccountId
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
                 FROM _tmpItem_SummPartner_To AS _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.InfoMoneyGroupId, _tmpItem_SummPartner.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPartner_To.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 2.0.2.3. ������������ ContainerId ��� �������� �� ���� ����������
     UPDATE _tmpItem_SummPartner_To SET ContainerId = tmp.ContainerId
     FROM              (SELECT tmp.AccountId, tmp.BusinessId, tmp.InfoMoneyId
                                                                             , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_To
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_2        := vbContractId_To
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_3        := tmp.InfoMoneyId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_4        := vbPaidKindId_To
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := 0 -- !!!�� ���� ��������� ���� ���� �� �����!!!
                                                                                                      , inDescId_6          := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                      , inObjectId_6        := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN vbPartnerId_To ELSE NULL END
                                                                                                      , inDescId_7          := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                      , inObjectId_7        := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN zc_Branch_Basis() ELSE NULL END -- ���� ���������� ������ �� ������� �������
                                                                                                      , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                                                                      , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                                                                       ) AS ContainerId

           FROM (SELECT _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.BusinessId, _tmpItem_SummPartner.InfoMoneyId
                 FROM _tmpItem_SummPartner_To AS _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.BusinessId, _tmpItem_SummPartner.InfoMoneyId
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_SummPartner_To.AccountId         = tmp.AccountId
       AND _tmpItem_SummPartner_To.BusinessId        = tmp.BusinessId
       AND _tmpItem_SummPartner_To.InfoMoneyId       = tmp.InfoMoneyId
    ;

     -- 2.0.2.4. ������������ ContainerId ��� �������� - ������� ����������
     UPDATE _tmpItem_SummPartner_To SET ContainerId_ProfitLoss_70201 = _tmpItem_byDestination.ContainerId_ProfitLoss_70201 -- ���� - ������� (���� - �������������� ������� + ������ + ������)
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301() -- 100301; "������� �������� �������"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
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
           FROM (SELECT  _tmpItem_SummPartner_To.InfoMoneyDestinationId
                       , _tmpItem_SummPartner_To.BusinessId
                 FROM _tmpItem_SummPartner_To
                 GROUP BY _tmpItem_SummPartner_To.InfoMoneyDestinationId
                        , _tmpItem_SummPartner_To.BusinessId
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination
     WHERE _tmpItem_SummPartner_To.InfoMoneyDestinationId = _tmpItem_byDestination.InfoMoneyDestinationId
       AND _tmpItem_SummPartner_To.BusinessId = _tmpItem_byDestination.BusinessId
    ;


     -- 3.0.1. ������������ ����(�����������) ��� �������� �� ������� ���.���� (������������)
     UPDATE _tmpItem_SummPacker SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- ��������
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30500() -- ���������� (����������� ����)
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT InfoMoneyDestinationId FROM _tmpItem_SummPacker GROUP BY InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPacker.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 3.0.2. ������������ ContainerId ��� �������� �� ������� ���.���� (������������)
     UPDATE _tmpItem_SummPacker SET ContainerId = 
                                                  -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1) ���.���� (������������) 3)������ ����������
                                                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                        , inParentId          := NULL
                                                                        , inObjectId          := _tmpItem_SummPacker.AccountId
                                                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                        , inBusinessId        := _tmpItem_SummPacker.BusinessId
                                                                        , inObjectCostDescId  := NULL
                                                                        , inObjectCostId      := NULL
                                                                        , inDescId_1          := zc_ContainerLinkObject_Member()
                                                                        , inObjectId_1        := vbMemberId_Packer
                                                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                        , inObjectId_2        := _tmpItem_SummPacker.InfoMoneyId
                                                                        , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                                        , inObjectId_3        := zc_Branch_Basis() -- ���� ��������� ������ �� ������� �������
                                                                        , inDescId_4          := zc_ContainerLinkObject_Car()
                                                                        , inObjectId_4        := 0 -- ��� ���.���� (������������) !!!������ ����� ��������� ��������� ������ �������� = 0!!!
                                                                        );

     -- 3.0.3. !!!����� ����� - ���������� ����� vbContainerId_Analyzer ��� ����!!!, ���� �� �� ���� - ����� ������
     vbContainerId_Analyzer:= (SELECT ContainerId FROM _tmpItem_SummPartner GROUP BY ContainerId);
     -- ����������
     vbContainerId_Analyzer_Packer:= (SELECT ContainerId FROM _tmpItem_SummPacker GROUP BY ContainerId);
     -- ����������
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId WHEN vbCarId <> 0 THEN vbCarId WHEN vbPartnerId_To <> 0 THEN vbPartnerId_To END;
     -- ����������
     vbObjectExtId_Analyzer:= CASE WHEN vbPartnerId_From <> 0 THEN vbPartnerId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From WHEN vbCardFuelId_From <> 0 THEN vbCardFuelId_From WHEN vbTicketFuelId_From <> 0 THEN vbTicketFuelId_From END;


     -- 3.0.4. !!!��� ����� - �������, ���� ����������!!!
     DELETE FROM _tmpItem WHERE vbPartnerId_To <> 0;


     -- 1.1.1. ������������ ContainerId_CountSupplier ��� !!!������������!!! �������� �� ��������������� ����� - ����� ����������
     UPDATE _tmpItem SET ContainerId_CountSupplier = -- 0)����� 1)���������
                                                     lpInsertFind_Container (inContainerDescId   := zc_Container_CountSupplier()
                                                                           , inParentId          := NULL
                                                                           , inObjectId          := _tmpItem.GoodsId
                                                                           , inJuridicalId_basis := NULL
                                                                           , inBusinessId        := NULL
                                                                           , inObjectCostDescId  := NULL
                                                                           , inObjectCostId      := NULL
                                                                           , inDescId_1          := zc_ContainerLinkObject_Partner()
                                                                           , inObjectId_1        := vbPartnerId_From
                                                                           , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                                           , inObjectId_2        := zc_Branch_Basis() -- ���� ���������� ������ �� ������� �������
                                                                            )
     WHERE _tmpItem.isCountSupplier = TRUE AND _tmpItem.OperCount <> 0;

     -- 1.1.2. ����������� !!!������������!!! �������� ��� ��������������� ����� - ����� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_CountSupplier() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_CountSupplier
            , 0                                       AS AccountId              -- ��� �����
            , 0                                       AS AnalyzerId             -- ��� ���������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbPartnerId_From                        AS WhereObjectId_Analyzer -- ���������
            , 0                                       AS ContainerId_Analyzer   -- !!!���!!!
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbPartnerId_From                        AS ObjectExtId_Analyzer   -- ���������
            , 0                                       AS ParentId
            , -1 * OperCount                          AS Amount
            , vbOperDate                              AS OperDate               -- �.�. �� "���� �����"
            , FALSE                                   AS isActive
       FROM _tmpItem
       WHERE _tmpItem.isCountSupplier = TRUE AND _tmpItem.OperCount <> 0;


     -- 1.2.1. ������������ ContainerId_Goods ��� �������� �� ��������������� �����
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inCarId                  := vbCarId
                                                                                , inMemberId               := NULL
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := NULL -- ��� ��������� ����� ��� �������
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
     WHERE vbPartnerId_To = 0;

     -- 1.2.2. ����������� �������� ��� ��������������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_Goods
            , 0                                       AS AccountId              -- ��� �����
            , 0                                       AS AnalyzerId             -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- ��������� - �� ������ ����������
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ��������� ���...
            , 0                                       AS ParentId
            , OperCount_Partner                       AS Amount
            , vbOperDate                              AS OperDate               -- �.�. �� "���� �����"
            , TRUE                                    AS isActive
       FROM _tmpItem
       -- WHERE OperCount <> 0
      UNION ALL
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_Goods
            , 0                                       AS AccountId              -- ��� �����
            , zc_Enum_AnalyzerId_Count_40200()        AS AnalyzerId             -- ���� ���������, ������� � ����, ���� ������� ��� ������� �� �������� � ������ ������ 40200...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- ��������� - �� ������ ����������
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ��������� ���...
            , 0                                       AS ParentId
            , OperCount - OperCount_Partner           AS Amount
            , vbOperDate                              AS OperDate               -- �.�. �� "���� �����"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE OperCount <> OperCount_Partner
      UNION ALL
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_Goods
            , 0                                       AS AccountId              -- ��� �����
            , zc_Enum_AnalyzerId_Income_Packer()      AS AnalyzerId             -- ���� ���������, �� ������������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , vbContainerId_Analyzer_Packer           AS ContainerId_Analyzer   -- ��������� - �� ������ ������������
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbMemberId_Packer                       AS ObjectExtId_Analyzer   -- ������������
            , 0                                       AS ParentId
            , OperCount_Packer                        AS Amount
            , vbOperDate                              AS OperDate               -- �.�. �� "���� �����"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE OperCount_Packer <> 0;


     -- 1.2.3. ������������ ContainerId_GoodsTicketFuel ��� �������� �� ��������������� ����� - ������ �������
     UPDATE _tmpItem SET ContainerId_GoodsTicketFuel = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := NULL
                                                                                          , inCarId                  := NULL
                                                                                          , inMemberId               := vbMemberId_Driver
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpItem.GoodsId_TicketFuel
                                                                                          , inGoodsKindId            := NULL
                                                                                          , inIsPartionCount         := NULL
                                                                                          , inPartionGoodsId         := NULL
                                                                                          , inAssetId                := NULL
                                                                                          , inBranchId               := NULL -- ��� ��������� ����� ��� �������
                                                                                          , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                           )
     WHERE vbTicketFuelId_From <> 0;

     -- 1.2.4. ����������� �������� ��� ��������������� ����� - ������ �������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_GoodsTicketFuel
            , 0                                       AS AccountId              -- ��� �����
            , 0                                       AS AnalyzerId             -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , _tmpItem.GoodsId_TicketFuel             AS ObjectId_Analyzer      -- �����
            , vbMemberId_Driver                       AS WhereObjectId_Analyzer -- vbMemberId_Driver
            , 0                                       AS ContainerId_Analyzer   -- !!!���!!!
            , 0                                       AS ObjectIntId_Analyzer   -- ��� ������
            , 0                                       AS ObjectExtId_Analyzer   -- ... ��� ...
            , 0                                       AS ParentId
            , -1 * OperCount                          AS Amount
            , vbOperDate                              AS OperDate               -- �.�. �� "���� �����"
            , FALSE                                   AS isActive
       FROM _tmpItem
       WHERE OperCount <> 0
         AND vbTicketFuelId_From <> 0;


     -- 1.3.1. ������������ ����(�����������) ��� �������� �� ��������� �����
     UPDATE _tmpItem SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := CASE WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                                                     THEN zc_Enum_AccountGroup_10000() -- ����������� ������
                                                                                ELSE zc_Enum_AccountGroup_20000() -- ������
                                                                           END
                                             , inAccountDirectionId     := CASE WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                                                                     THEN zc_Enum_AccountDirection_20900() -- ��������� ����

                                                                                WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                                                     THEN CASE WHEN _tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- ���������������� ������������
                                                                                                    THEN zc_Enum_AccountDirection_10200() -- ���������������� ��
                                                                                               ELSE zc_Enum_AccountDirection_10100() -- ���������������� ��
                                                                                          END

                                                                                ELSE vbAccountDirectionId_To
                                                                           END
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.InfoMoneyDestinationId
                      , _tmpItem.InfoMoneyId
                      , CASE /*WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                               OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                  THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                             */
                             WHEN (vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- !!!��������!!! ������ + �� ������� 
                                OR vbAccountDirectionId_To = zc_Enum_AccountDirection_20300() -- ������ + �� ��������
                                  )
                              AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21400() -- ������������� + ������ ����������
                                  THEN zc_Enum_InfoMoneyDestination_10200() -- �������� ����� + ������ �����

                             ELSE _tmpItem.InfoMoneyDestinationId
                        END AS InfoMoneyDestinationId_calc
                 FROM _tmpItem
                 WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId
                        , _tmpItem.InfoMoneyId
                        , CASE /*WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                 OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                    THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                               */
                               WHEN (vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- !!!��������!!! ������ + �� ������� 
                                  OR vbAccountDirectionId_To = zc_Enum_AccountDirection_20300() -- ������ + �� ��������
                                    )
                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21400() -- ������������� + ������ ����������
                                    THEN zc_Enum_InfoMoneyDestination_10200() -- �������� ����� + ������ �����

                               ELSE _tmpItem.InfoMoneyDestinationId
                          END
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyId = _tmpItem_byAccount.InfoMoneyId;

     -- 1.3.2. ������������ ContainerId_Summ ��� �������� �� ��������� ����� + ����������� ��������� <������� �/�>
     UPDATE _tmpItem SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                              , inUnitId                 := vbUnitId
                                                                              , inCarId                  := vbCarId
                                                                              , inMemberId               := NULL
                                                                              , inBranchId               := NULL -- ��� ��������� ����� ��� �������
                                                                              , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                                              , inBusinessId             := _tmpItem.BusinessId
                                                                              , inAccountId              := _tmpItem.AccountId
                                                                              , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                              , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                              , inInfoMoneyId_Detail     := _tmpItem.InfoMoneyId_Detail
                                                                              , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                              , inGoodsId                := _tmpItem.GoodsId
                                                                              , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                              , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                              , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                              , inAssetId                := _tmpItem.AssetId
                                                                               )
     WHERE zc_isHistoryCost() = TRUE; -- !!!���� ����� ��������!!!

     -- 1.3.3. ����������� �������� ��� ��������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_Summ
            , _tmpItem.AccountId                      AS AccountId              -- ���� ���� ������
            , 0                                       AS AnalyzerId             -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- ��������� - �� ������ ����������
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ��������� ���...
            , 0                                       AS ParentId
            , CASE WHEN OperCount <> OperCount_Partner AND OperCount_Partner <> 0 THEN CAST (OperCount * OperSumm_Partner / OperCount_Partner AS NUMERIC (16, 4)) ELSE OperSumm_Partner END AS Amount
            , vbOperDate                              AS OperDate               -- �.�. �� "���� �����"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE OperSumm_Partner <> 0
      UNION ALL
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_Summ
            , _tmpItem.AccountId                      AS AccountId              -- ���� ���� ������
            , zc_Enum_AnalyzerId_Count_40200()        AS AnalyzerId             -- ���� ���������, ������� � ����, ���� ������� ��� ������� �� �������� � ������ ������ 40200...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- ��������� - �� ������ ����������
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ��������� ���...
            , 0                                       AS ParentId
            , CASE WHEN OperCount <> OperCount_Partner AND OperCount_Partner <> 0 THEN OperSumm_Partner - CAST (OperCount * OperSumm_Partner / OperCount_Partner AS NUMERIC (16, 4)) ELSE 0 END AS Amount
            , vbOperDate                              AS OperDate               -- �.�. �� "���� �����"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE OperSumm_Partner <> 0
         AND OperCount <> OperCount_Partner
      UNION ALL
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_Summ
            , _tmpItem.AccountId                      AS AccountId              -- ���� ���� ������
            , zc_Enum_AnalyzerId_Income_Packer()      AS AnalyzerId             -- ���� ���������, �� ������������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , vbContainerId_Analyzer_Packer           AS ContainerId_Analyzer   -- ��������� - �� ������ ������������
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- ��� ������
            , vbMemberId_Packer                       AS ObjectExtId_Analyzer   -- ������������
            , 0                                       AS ParentId
            , OperSumm_Packer                         AS Amount
            , vbOperDate                              AS OperDate               -- �.�. �� "���� �����"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE OperSumm_Packer <> 0;


     -- 2.0.3. ����������� �������� - ���� ���������� ��� ���.���� (����������� ����) + !!!�� �������� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- ��� ������� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_SummPartner.ContainerId
            , _tmpItem_SummPartner.AccountId          AS AccountId              -- ���� ���� ������
            , 0                                       AS AnalyzerId             -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , _tmpItem_SummPartner.GoodsId            AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , _tmpItem_SummPartner.ContainerId        AS ContainerId_Analyzer   -- ��� �� �����
            , _tmpItem_SummPartner.GoodsKindId        AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ��������� ���...
            , 0                                       AS ParentId
            , -1 * _tmpItem_SummPartner.OperSumm_Partner
            , CASE WHEN _tmpItem_SummPartner.AccountId_Transit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_SummPartner
       -- !!!������ ������������, �.�. �� ���� ��������� �������� ������!!!
       -- WHERE _tmpItem_SummPartner.OperSumm_Partner <> 0
     UNION ALL
       -- ��� ��� �������� ��� ����� �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_SummPartner.ContainerId_Transit
            , _tmpItem_SummPartner.AccountId_Transit  AS AccountId              -- ���� ���� (�.�. � ������� ������������ "�������")
            , 0                                       AS AnalyzerId             -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , _tmpItem_SummPartner.GoodsId            AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpItem_SummPartner.ContainerId_Transit ELSE _tmpItem_SummPartner.ContainerId_Transit END AS ContainerId_Analyzer -- ��� �� �����, �.�. � ������ ������� "�����������" �� vbOperDate + "��������" �� vbOperDatePartner
            , _tmpItem_SummPartner.GoodsKindId        AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ��������� ���...
            , 0                                       AS ParentId
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END * _tmpItem_SummPartner.OperSumm_Partner
            , tmpOperDate.OperDate
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN FALSE ELSE TRUE END AS IsActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            JOIN _tmpItem_SummPartner ON  _tmpItem_SummPartner.OperSumm_Partner <> 0
                                      AND _tmpItem_SummPartner.AccountId_Transit <> 0
      ;

     -- 2.1.2. ����������� "�����������" �������� - ��� ��������������� ����� �� ���������� + !!!�������� MovementItemId!!! + !!!�������� GoodsId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner_To.MovementItemId
            , _tmpItem_SummPartner_To.ContainerId_Goods
            , zc_Enum_Account_110401()                AS AccountId              -- ���� ���� ������� + ����������� ����� + ����������� ����� (�.�. � ������� ������������ "�����������")
            , 0                                       AS AnalyzerId             -- ��� ���������, �.�. �������� "�����������" ���� �� ����
            , _tmpItem_SummPartner_To.GoodsId         AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ����������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- ��������� - �� ������ ����������
            , 0                                       AS ObjectIntId_Analyzer   -- !!!���!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ��������� ���...
            , 0                                       AS ParentId
            , _tmpItem_SummPartner_To.OperCount_PartnerFrom * CASE WHEN tmp.isActive = TRUE THEN 1 ELSE -1 END AS Amount -- � ���������������� �������
            , vbOperDate                              AS OperDate
            , tmp.isActive                            AS isActive -- �.�. � ���������������� �������
       FROM _tmpItem_SummPartner_To
            INNER JOIN (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmp ON 1 = 1
      UNION ALL
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner_To.MovementItemId
            , _tmpItem_SummPartner_To.ContainerId_Goods
            , zc_Enum_Account_110401()                AS AccountId              -- ���� ���� ������� + ����������� ����� + ����������� ����� (�.�. � ������� ������������ "�����������")
            , zc_Enum_AnalyzerId_Count_40200()        AS AnalyzerId             -- ���� ���������, ������� � ����, ���� ������� ��� ������� �� �������� � ������ ������ 40200...
            , _tmpItem_SummPartner_To.GoodsId         AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ����������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- ��������� - �� ������ ����������
            , 0                                       AS ObjectIntId_Analyzer   -- !!!���!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ��������� ���...
            , 0                                       AS ParentId
            , (_tmpItem_SummPartner_To.OperCount - _tmpItem_SummPartner_To.OperCount_PartnerFrom) * CASE WHEN tmp.isActive = TRUE THEN 1 ELSE -1 END AS Amount -- � ���������������� �������
            , vbOperDate                              AS OperDate
            , tmp.isActive                            AS isActive -- �.�. � ���������������� �������
       FROM _tmpItem_SummPartner_To
            INNER JOIN (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmp ON 1 = 1
       WHERE _tmpItem_SummPartner_To.OperCount <> _tmpItem_SummPartner_To.OperCount_PartnerFrom
      ;



     -- 2.1.3. ����������� �������� - ���� ���������� + !!!�������� MovementItemId!!! + !!!�������� GoodsId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- ��� ������� �������� (�� ����� ����������)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner.MovementItemId
            , _tmpItem_SummPartner.ContainerId
            , _tmpItem_SummPartner.AccountId          AS AccountId              -- ���� ���� ������
            , 0                                       AS AnalyzerId             -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , _tmpItem_SummPartner.GoodsId            AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ����������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- ��������� - �� ������ ����������
            , 0                                       AS ObjectIntId_Analyzer   -- !!!���!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ��������� ���...
            , 0                                       AS ParentId
            , 1 * (_tmpItem_SummPartner.OperSumm_Partner - _tmpItem_SummPartner.OperSumm_70201)
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_SummPartner_To AS _tmpItem_SummPartner
       -- !!!������ ������������, �.�. �� ���� ��������� �������� ������!!!
       -- WHERE _tmpItem_SummPartner.OperSumm_Partner <> 0
      UNION ALL
       -- ��� ������� �������� (�� ����� �������)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner.MovementItemId
            , _tmpItem_SummPartner.ContainerId
            , _tmpItem_SummPartner.AccountId          AS AccountId              -- ���� ���� ������
            , zc_Enum_AnalyzerId_ProfitLoss()         AS AnalyzerId             -- ���� ���������, �.�. �� ��� ��������� � ����
            , _tmpItem_SummPartner.GoodsId            AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ����������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- ��������� - �� ������ ����������
            , 0                                       AS ObjectIntId_Analyzer   -- !!!���!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ��������� ���...
            , 0                                       AS ParentId
            , 1 * _tmpItem_SummPartner.OperSumm_70201
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_SummPartner_To AS _tmpItem_SummPartner
       WHERE _tmpItem_SummPartner.OperSumm_70201 <> 0
      ;

     -- 2.1.4. ����������� �������� - ������� ���������� + !!!��� MovementItemId!!! + !!!�������� GoodsId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                AS AccountId              -- ������� �������� �������
            , _tmpItem_group.AnalyzerId               AS AnalyzerId             -- ���������, �� �������� = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer   -- � ���� �� �����
            , 0                                       AS ObjectIntId_Analyzer   -- !!!���!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ��������� ���...
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , vbOperDate                              AS OperDate               -- �.�. �� "���� �����"
            , FALSE                                   AS isActive
       FROM (SELECT _tmpItem_SummPartner_To.ContainerId_ProfitLoss_70201 AS ContainerId_ProfitLoss
                  , _tmpItem_SummPartner_To.GoodsId                      AS GoodsId
                  , 0                                                    AS AnalyzerId -- ��� ���������
                  , -1 * SUM (_tmpItem_SummPartner_To.OperSumm_70201)    AS OperSumm
             FROM _tmpItem_SummPartner_To
             GROUP BY _tmpItem_SummPartner_To.ContainerId_ProfitLoss_70201, _tmpItem_SummPartner_To.GoodsId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
      ;

     -- 3.3. ����������� �������� - ������� ���.����(������������)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , ContainerId
            , _tmpItem_SummPacker.AccountId           AS AccountId              -- ���� ���� ������
            , 0                                       AS AnalyzerId             -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , 0                                       AS ObjectId_Analyzer      -- ��� ������
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , ContainerId                             AS ContainerId_Analyzer   -- ��� �� �����
            , 0                                       AS ObjectIntId_Analyzer   -- !!!���!!!
            , vbMemberId_Packer                       AS ObjectExtId_Analyzer   -- ������������
            , 0                                       AS ParentId
            , -1 * OperSumm_Packer                    AS Amount
            , vbOperDate                              AS OperDate               -- �.�. �� "���� �����"
            , FALSE                                   AS isActive
       FROM _tmpItem_SummPacker
       WHERE OperSumm_Packer <> 0;


     -- 4.1. ������������ ����(�����������) ��� �������� �� �������� � ����������� - ���.����� (��������)
     UPDATE _tmpItem_SummDriver SET AccountId = _tmpItem_byAccount.AccountId
                                  , AccountId_Transit = CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 THEN zc_Enum_Account_110101() ELSE 0 END -- �������
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- �������� -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30500() -- ���������� (����������� ����) -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30500())
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT InfoMoneyDestinationId FROM _tmpItem_SummDriver GROUP BY InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummDriver.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 4.2. ������������ ContainerId ��� �������� �� �������� � ����������� - ���.����(��������)
     UPDATE _tmpItem_SummDriver SET ContainerId = 
                                                  -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1) ���.����(��������) 3)������ ����������
                                                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                        , inParentId          := NULL
                                                                        , inObjectId          := _tmpItem_SummDriver.AccountId
                                                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                        , inBusinessId        := _tmpItem_SummDriver.BusinessId
                                                                        , inObjectCostDescId  := NULL
                                                                        , inObjectCostId      := NULL
                                                                        , inDescId_1          := zc_ContainerLinkObject_Member()
                                                                        , inObjectId_1        := vbMemberId_Driver
                                                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                        , inObjectId_2        := _tmpItem_SummDriver.InfoMoneyId
                                                                        , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                                        , inObjectId_3        := vbBranchId_Car -- ���� ��������� �� ������� ���������� or zc_Branch_Basis
                                                                        , inDescId_4          := zc_ContainerLinkObject_Car()
                                                                        , inObjectId_4        := vbCarId
                                                                         )
                                  ,ContainerId_Transit = CASE WHEN _tmpItem_SummDriver.AccountId_Transit = 0 THEN 0
                                                              ELSE
                                                  -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1) ���.���� (��������) 3)������ ����������
                                                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                        , inParentId          := NULL
                                                                        , inObjectId          := _tmpItem_SummDriver.AccountId_Transit
                                                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                        , inBusinessId        := _tmpItem_SummDriver.BusinessId
                                                                        , inObjectCostDescId  := NULL
                                                                        , inObjectCostId      := NULL
                                                                        , inDescId_1          := zc_ContainerLinkObject_Member()
                                                                        , inObjectId_1        := vbMemberId_Driver
                                                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                        , inObjectId_2        := _tmpItem_SummDriver.InfoMoneyId
                                                                        , inDescId_3          := zc_ContainerLinkObject_Car()
                                                                        , inObjectId_3        := vbCarId
                                                                         )
                                                         END;

     -- 4.3. ����������� �������� - ������� � ����������� ���.����(��������)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer -- , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- ��� �������� � ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , ContainerId
            , _tmpItem_SummDriver.AccountId           AS AccountId              -- ���� ���� ������
            , 0                                       AS AnalyzerId             -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , 0                                       AS ObjectId_Analyzer      -- ��� ������
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , ContainerId                             AS ContainerId_Analyzer   -- ��� �� ����� - ��������
            , 0                                       AS ParentId
            , -1 * OperSumm_Driver                    AS Amount
            , vbOperDate                              AS OperDate               -- �.�. �� "���� �����"
            , FALSE                                   AS isActive
       FROM _tmpItem_SummDriver
       WHERE OperSumm_Driver <> 0
     UNION ALL
       -- ��� ������� � ����������� �� ���� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_SummPartner.ContainerId
            , _tmpItem_SummPartner.AccountId          AS AccountId              -- ���� ���� ������
            , 0                                       AS AnalyzerId             -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , 0                                       AS ObjectId_Analyzer      -- ��� ������
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , _tmpItem_SummDriver.ContainerId         AS ContainerId_Analyzer   -- !!!��������!!!
            , 0                                       AS ParentId
            , 1 * _tmpItem_SummDriver.OperSumm_Driver AS Amount
            , CASE WHEN _tmpItem_SummDriver.AccountId_Transit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_SummDriver
            INNER JOIN (SELECT _tmpItem_SummPartner.InfoMoneyId, _tmpItem_SummPartner.ContainerId, _tmpItem_SummPartner.AccountId FROM _tmpItem_SummPartner GROUP BY _tmpItem_SummPartner.InfoMoneyId, _tmpItem_SummPartner.ContainerId, _tmpItem_SummPartner.AccountId
                       ) AS _tmpItem_SummPartner ON _tmpItem_SummPartner.InfoMoneyId = _tmpItem_SummDriver.InfoMoneyId
       WHERE _tmpItem_SummDriver.OperSumm_Driver <> 0
     UNION ALL
       -- ��� ��� �������� ��� ����� �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_SummDriver.ContainerId_Transit
            , _tmpItem_SummDriver.AccountId           AS AccountId              -- ���� ���� ������
            , 0                                       AS AnalyzerId             -- ��� ���������, �.�. ������� ���������, ������������, ����������, ������ ���� �� ����
            , 0                                       AS ObjectId_Analyzer      -- ��� ������
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ������������ ���...
            , _tmpItem_SummDriver.ContainerId         AS ContainerId_Analyzer   -- !!!��������!!!
            , 0                                       AS ParentId
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 1 ELSE -1 END * _tmpItem_SummDriver.OperSumm_Driver
            , tmpOperDate.OperDate
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN TRUE ELSE FALSE END AS IsActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            JOIN _tmpItem_SummDriver ON  _tmpItem_SummDriver.OperSumm_Driver <> 0
                                     AND _tmpItem_SummDriver.AccountId_Transit <> 0
      ;


     -- 5.1.1. ����������� �������� ��� ������ (�����: �����(�/�) <-> ���� ���������� ��� ���.���� (����������� ����)) !!!����� �� InfoMoneyId_Detail + GoodsId!!!
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
                                                                                                             , inAccountKindId_1    := (SELECT zc_Enum_AccountKind_All() FROM _tmpItem_SummPacker)
                                                                                                             , inContainerId_1      := (SELECT ContainerId FROM _tmpItem_SummPacker)
                                                                                                             , inAccountId_1        := (SELECT AccountId FROM _tmpItem_SummPacker)
                                                                                                     )
                                              , inAmount   := tmpMIReport.OperSumm
                                              , inOperDate := tmpMIReport.OperDate
                                               )
     FROM (SELECT _tmpItem.MovementItemId
                , _tmpItem.OperSumm_Partner AS OperSumm
                , tmpOperDate.OperDate
                , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpItem.ContainerId_Summ ELSE _tmpItem_SummPartner.ContainerId_Transit END AS ActiveContainerId
                , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpItem_SummPartner.AccountId_Transit <> 0 THEN _tmpItem_SummPartner.ContainerId_Transit ELSE _tmpItem_SummPartner.ContainerId END AS PassiveContainerId
                , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpItem.AccountId ELSE _tmpItem_SummPartner.AccountId_Transit END AS ActiveAccountId
                , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpItem_SummPartner.AccountId_Transit <> 0 THEN _tmpItem_SummPartner.AccountId_Transit ELSE _tmpItem_SummPartner.AccountId END AS PassiveAccountId
           FROM _tmpItem
                LEFT JOIN _tmpItem_SummPartner ON _tmpItem_SummPartner.InfoMoneyId  = _tmpItem.InfoMoneyId_Detail
                                              AND _tmpItem_SummPartner.GoodsId      = _tmpItem.GoodsId
                                              AND _tmpItem_SummPartner.BusinessId   = _tmpItem.BusinessId
                                              AND _tmpItem_SummPartner.UnitId_Asset = _tmpItem.UnitId_Asset
                LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                                                                                                                   OR  (tmpOperDate.OperDate = vbOperDatePartner
                                                                                                                    AND COALESCE (_tmpItem_SummPartner.AccountId_Transit, 0) <> 0)
           WHERE _tmpItem.OperSumm_Partner <> 0
          ) AS tmpMIReport;


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
     FROM (SELECT _tmpItem_SummPartner_To.MovementItemId   AS MovementItemId
                , _tmpItem_SummPartner_To.OperSumm_Partner - _tmpItem_SummPartner_To.OperSumm_70201 AS OperSumm
                , _tmpItem_SummPartner_To.ContainerId      AS ActiveContainerId
                , _tmpItem_SummPartner.ContainerId         AS PassiveContainerId
                , _tmpItem_SummPartner_To.AccountId        AS ActiveAccountId
                , _tmpItem_SummPartner.AccountId           AS PassiveAccountId
           FROM _tmpItem_SummPartner_To
                LEFT JOIN _tmpItem_SummPartner ON _tmpItem_SummPartner.GoodsId      = _tmpItem_SummPartner_To.GoodsId
                                              AND _tmpItem_SummPartner.BusinessId   = _tmpItem_SummPartner_To.BusinessId
           WHERE _tmpItem_SummPartner_To.OperSumm_Partner - _tmpItem_SummPartner_To.OperSumm_70201 <> 0
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
     FROM (SELECT _tmpItem_SummPartner_To.MovementItemId   AS MovementItemId
                , _tmpItem_SummPartner_To.OperSumm_70201   AS OperSumm
                , _tmpItem_SummPartner_To.ContainerId      AS ActiveContainerId
                , _tmpItem_SummPartner_To.ContainerId_ProfitLoss_70201 AS PassiveContainerId
                , _tmpItem_SummPartner_To.AccountId        AS ActiveAccountId
                , zc_Enum_Account_100301()                 AS PassiveAccountId -- 100301; "������� �������� �������"
           FROM _tmpItem_SummPartner_To
           WHERE _tmpItem_SummPartner_To.OperSumm_70201 <> 0
          ) AS tmpMIReport;


     -- 5.2. ����������� �������� ��� ������ (�����: �����(�/�) <-> ���� ���.���� (������������)) !!!����� �� InfoMoneyId!!!
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem.MovementItemId
                                              , inActiveContainerId  := _tmpItem.ContainerId_Summ
                                              , inPassiveContainerId := _tmpItem_SummPacker.ContainerId
                                              , inActiveAccountId    := _tmpItem.AccountId
                                              , inPassiveAccountId   := _tmpItem_SummPacker.AccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem.ContainerId_Summ
                                                                                                    , inPassiveContainerId := _tmpItem_SummPacker.ContainerId
                                                                                                    , inActiveAccountId    := _tmpItem.AccountId
                                                                                                    , inPassiveAccountId   := _tmpItem_SummPacker.AccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem.ContainerId_Summ
                                                                                                             , inPassiveContainerId := _tmpItem_SummPacker.ContainerId
                                                                                                             , inActiveAccountId    := _tmpItem.AccountId
                                                                                                             , inPassiveAccountId   := _tmpItem_SummPacker.AccountId
                                                                                                             , inAccountKindId_1    := (SELECT zc_Enum_AccountKind_All() FROM _tmpItem_SummPartner LIMIT 1)
                                                                                                             , inContainerId_1      := vbContainerId_Analyzer
                                                                                                             , inAccountId_1        := (SELECT AccountId FROM _tmpItem_SummPartner LIMIT 1)
                                                                                                     )
                                              , inAmount   := _tmpItem.OperSumm_Packer
                                              , inOperDate := vbOperDate
                                               )
     FROM _tmpItem
          LEFT JOIN _tmpItem_SummPacker ON _tmpItem_SummPacker.InfoMoneyId = _tmpItem.InfoMoneyId
                                       AND _tmpItem_SummPacker.BusinessId = _tmpItem.BusinessId
     WHERE _tmpItem.OperSumm_Packer <> 0;


     -- 5.3. ����������� �������� ��� ������ (���������: ��������� (��������) � ��������� ��� ��������� (����������� ����)) !!!����� �� InfoMoneyId!!!
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
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := tmpMIReport.ContainerId_Summ
                                                                                                             , inAccountId_1        := tmpMIReport.AccountId
                                                                                                     )
                                              , inAmount   := tmpMIReport.OperSumm
                                              , inOperDate := tmpMIReport.OperDate
                                               )
     FROM (SELECT _tmpItem.MovementItemId
                , _tmpItem.OperSumm_Partner AS OperSumm
                , tmpOperDate.OperDate
                , _tmpItem.ContainerId_Summ
                , _tmpItem.AccountId
                , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpItem_SummDriver.AccountId_Transit <> 0 THEN _tmpItem_SummDriver.ContainerId_Transit
                       ELSE _tmpItem_SummPartner.ContainerId
                  END AS ActiveContainerId
                , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpItem_SummDriver.ContainerId
                       ELSE _tmpItem_SummDriver.ContainerId_Transit
                  END AS PassiveContainerId
                , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpItem_SummDriver.AccountId_Transit <> 0 THEN _tmpItem_SummDriver.AccountId_Transit
                       ELSE _tmpItem_SummPartner.AccountId
                  END AS ActiveAccountId
                , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpItem_SummDriver.AccountId
                       ELSE _tmpItem_SummDriver.AccountId_Transit
                  END AS PassiveAccountId
           FROM _tmpItem
                JOIN _tmpItem_SummDriver ON _tmpItem_SummDriver.InfoMoneyId = _tmpItem.InfoMoneyId
                LEFT JOIN (SELECT _tmpItem_SummPartner.InfoMoneyId, _tmpItem_SummPartner.ContainerId, _tmpItem_SummPartner.AccountId FROM _tmpItem_SummPartner GROUP BY _tmpItem_SummPartner.InfoMoneyId, _tmpItem_SummPartner.ContainerId, _tmpItem_SummPartner.AccountId
                          ) AS _tmpItem_SummPartner ON _tmpItem_SummPartner.InfoMoneyId = _tmpItem.InfoMoneyId
                LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                                                                                                                   OR  (tmpOperDate.OperDate = vbOperDatePartner
                                                                                                                    AND COALESCE (_tmpItem_SummDriver.AccountId_Transit, 0) <> 0)
           WHERE _tmpItem.OperSumm_Partner <> 0
          ) AS tmpMIReport;


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Income()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.10.14                                        * add InfoMoneyGroupId and InfoMoneyGroupId_Detail and UnitId_Asset
 07.09.14                                        * add zc_ContainerLinkObject_Branch to vbPartnerId_From
 05.09.14                                        * add zc_ContainerLinkObject_Branch to ���.���� (����������� ����)
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 01.08.14                                        * zc_Enum_AccountDirection... ��������� (������������) -> ���������� (����������� ����)
 29.07.14                                        * change zc_GoodsKind_WorkProgress
 26.07.14                                        * add ����
 25.05.14                                        * add lpComplete_Movement
 11.05.14                                        * set zc_ContainerLinkObject_PaidKind is last
 11.05.14                                        * add Object_InfoMoney_View
 10.05.14                                        * add lpInsert_MovementProtocol
 08.04.14                                        * add Constant_InfoMoney_isCorporate_View
 04.04.14                                        * add zc_Enum_InfoMoney_21151
 21.12.13                                        * Personal -> Member
 01.11.13                                        * add vbOperDatePartner
 30.10.13                                        * add 
 20.10.13                                        * add vbCardFuelId_From and vbTicketFuelId_From
 20.10.13                                        * add vbChangePrice
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 06.10.13                                        * add inUserId
 03.10.13                                        * add vbBusinessId_Route
 02.10.13                                        * add zc_ObjectLink_Goods_Fuel
 30.09.13                                        * add vbCarId and vbMemberId_Driver
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 15.09.13                                        * all
 14.09.13                                        * add vbBusinessId_To + isCountSupplier
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 29.08.13                                        * add lpInsertUpdate_MovementItemReport
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 07.08.13                                        * add inParentId and inIsActive
 05.08.13                                        * no InfoMoneyId_isCorporate
 20.07.13                                        * add MovementItemId
 20.07.13                                        * all ������ ������, ���� ���� ...
 19.07.13                                        * all
 12.07.13                                        * add PartionGoods
 11.07.13                                        * add ObjectCost
 04.07.13                                        * ! finich !
 02.07.13                                        *
*/

-- ����
/*
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 1100 , inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM lpComplete_Movement_Income (inMovementId:= 1100 , inUserId:= zfCalc_UserAdmin() :: Integer, inIsLastComplete:= FALSE)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 1100 , inSession:= zfCalc_UserAdmin())
*/
