-- Function: lpComplete_Movement_Income()

DROP FUNCTION IF EXISTS lpComplete_Movement_Income (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income(
    IN inMovementId        Integer               , -- ���� ���������
    IN inUserId            Integer               , -- ������������
    IN inIsLastComplete    Boolean  DEFAULT False  -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
)                              
RETURNS VOID
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, MemberId_From Integer, UnitId Integer, BranchId_Unit Integer, MemberId_Packer Integer, PaidKindId Integer, ContractId Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, JuridicalId_basis Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionMovementId Integer, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Packer_byItem TFloat;

  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Packer TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbChangePrice TFloat;

  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDatePartner TDateTime;
  DECLARE vbJuridicalId_From Integer;
  DECLARE vbIsCorporate_From Boolean;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbCardFuelId_From Integer;
  DECLARE vbTicketFuelId_From Integer;
  DECLARE vbInfoMoneyDestinationId_From Integer;
  DECLARE vbInfoMoneyId_From Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbCarId Integer;
  DECLARE vbMemberId_Driver Integer;
  DECLARE vbBranchId_To Integer;
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
     -- !!!�����������!!! �������� ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummPartner;
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
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = MovementItem.MovementId
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
     WHERE MovementItem.MovementId = inMovementId
       AND lfObject_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
     ;

     -- ��� ��������� ����� ��� ������� �������� ���� �� ����������� � ���������� (������������) � ��� ������������ �������� � ���������
     SELECT _tmp.PriceWithVAT, _tmp.VATPercent, _tmp.DiscountPercent, _tmp.ExtraChargesPercent, _tmp.ChangePrice
          , _tmp.OperDate, _tmp.OperDatePartner, _tmp.JuridicalId_From, _tmp.isCorporate_From, _tmp.PartnerId_From, _tmp.MemberId_From, _tmp.CardFuelId_From, _tmp.TicketFuelId_From
          , _tmp.InfoMoneyId_From
          , _tmp.UnitId, _tmp.CarId, _tmp.MemberDriverId, _tmp.BranchId_To, _tmp.AccountDirectionId_To, _tmp.isPartionDate_Unit
          , _tmp.MemberId_Packer, _tmp.PaidKindId, _tmp.ContractId, _tmp.JuridicalId_Basis_To, _tmp.BusinessId_To, _tmp.BusinessId_Route
            INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbChangePrice
               , vbOperDate, vbOperDatePartner, vbJuridicalId_From, vbIsCorporate_From, vbPartnerId_From, vbMemberId_From, vbCardFuelId_From, vbTicketFuelId_From
               , vbInfoMoneyId_From
               , vbUnitId, vbCarId, vbMemberId_Driver, vbBranchId_To, vbAccountDirectionId_To, vbIsPartionDate_Unit
               , vbMemberId_Packer, vbPaidKindId, vbContractId, vbJuridicalId_Basis_To, vbBusinessId_To, vbBusinessId_Route

     FROM (SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
                , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
                , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
                , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
                , COALESCE (MovementFloat_ChangePrice.ValueData, 0) AS ChangePrice

                , Movement.OperDate
                , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner
                , COALESCE (COALESCE (ObjectLink_CardFuel_Juridical.ChildObjectId, ObjectLink_Partner_Juridical.ChildObjectId), 0) AS JuridicalId_From
                , COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE) AS isCorporate_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner()    THEN Object_From.Id ELSE 0 END, 0) AS PartnerId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Personal()   THEN ObjectLink_Personal_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_CardFuel()   THEN Object_From.Id ELSE 0 END, 0) AS CardFuelId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_TicketFuel() THEN Object_From.Id ELSE 0 END, 0) AS TicketFuelId_From
                  -- �� ������ ���������� �����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0)) AS InfoMoneyId_From

                , COALESCE (CASE WHEN Object_To.DescId <> zc_Object_Car() THEN Object_To.Id ELSE 0 END, 0) AS UnitId
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Car() THEN Object_To.Id ELSE 0 END, 0) AS CarId
                , COALESCE (ObjectLink_PersonalDriver_Member.ChildObjectId, 0) AS MemberDriverId
                , COALESCE (ObjectLink_UnitTo_Branch.ChildObjectId, 0) AS BranchId_To
                  -- ��������� ������ - �����������
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Car()
                                      THEN zc_Enum_AccountDirection_20500() -- 20000; "������"; 20500; "���������� (��)"
                                 ELSE ObjectLink_UnitTo_AccountDirection.ChildObjectId
                            END, 0) AS AccountDirectionId_To
                , COALESCE (ObjectBoolean_PartionDate.ValueData, FALSE)  AS isPartionDate_Unit

                , COALESCE (ObjectLink_PersonalPacker_Member.ChildObjectId, 0) AS MemberId_Packer
                , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
                , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

                , COALESCE (ObjectLink_UnitTo_Juridical.ChildObjectId, 0)   AS JuridicalId_Basis_To
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
                LEFT JOIN MovementFloat AS MovementFloat_ChangePrice
                                        ON MovementFloat_ChangePrice.MovementId =  Movement.Id
                                       AND MovementFloat_ChangePrice.DescId = zc_MovementFloat_ChangePrice()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId


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
                                    AND ObjectBoolean_isCorporate.ValueData = TRUE

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_CarTo_Unit
                                     ON ObjectLink_CarTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_CarTo_Unit.DescId = zc_ObjectLink_Car_Unit()

                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                     ON ObjectLink_UnitTo_Branch.ObjectId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, MovementLinkObject_To.ObjectId)
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

                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Juridical
                                     ON ObjectLink_UnitTo_Juridical.ObjectId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, MovementLinkObject_To.ObjectId)
                                    AND ObjectLink_UnitTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Business
                                     ON ObjectLink_UnitTo_Business.ObjectId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, MovementLinkObject_To.ObjectId)
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

                LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                     ON ObjectLink_Personal_Member.ObjectId = Object_From.Id
                                    AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                    AND Object_From.DescId = zc_Object_Personal()
                LEFT JOIN ObjectLink AS ObjectLink_PersonalDriver_Member
                                     ON ObjectLink_PersonalDriver_Member.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                    AND ObjectLink_PersonalDriver_Member.DescId = zc_ObjectLink_Personal_Member()
                LEFT JOIN ObjectLink AS ObjectLink_PersonalPacker_Member
                                     ON ObjectLink_PersonalPacker_Member.ObjectId = MovementLinkObject_PersonalPacker.ObjectId
                                    AND ObjectLink_PersonalPacker_Member.DescId = zc_ObjectLink_Personal_Member()

           WHERE Movement.Id = inMovementId
             AND Movement.DescId = zc_Movement_Income()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmp;

     -- ������������ �������������� ����������, �������� ����� ��� ��� ������������ �������� � ���������
     SELECT lfObject_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_From FROM lfGet_Object_InfoMoney (vbInfoMoneyId_From) AS lfObject_InfoMoney;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods, ContainerId_CountSupplier, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                         , ContainerId_GoodsTicketFuel, GoodsId_TicketFuel
                         , OperCount, tmpOperSumm_Partner, OperSumm_Partner, tmpOperSumm_Packer, OperSumm_Packer
                         , AccountId, InfoMoneyDestinationId, InfoMoneyId, InfoMoneyDestinationId_Detail, InfoMoneyId_Detail
                         , BusinessId
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

              
            , 0 AS AccountId              -- ����(�����������), ���������� �����
            , _tmp.InfoMoneyDestinationId -- �������������� ����������
            , _tmp.InfoMoneyId            -- ������ ����������

              -- �������������� ���������� (����������� �/�), ��� �� !!!�������������!!! �� ���� �����������
            , CASE WHEN vbInfoMoneyDestinationId_From <> 0
                        THEN vbInfoMoneyDestinationId_From -- �� ������� �� �������� ��� �� ��.���� !!!(��� ���� ��������)!!!
                   ELSE _tmp.InfoMoneyDestinationId -- �� ������� �� ������
               END AS InfoMoneyDestinationId_Detail

              -- ������ ���������� (����������� �/�), ��� �� !!!�������������!!! �� ���� �����������
            , CASE WHEN vbInfoMoneyId_From <> 0
                        THEN vbInfoMoneyId_From -- �� ������� �� �������� ��� �� ��.���� !!!(��� ���� ��������)!!!
                   ELSE _tmp.InfoMoneyId -- ����� �� ������� �� ������
               END AS InfoMoneyId_Detail

              -- �������� ������ !!!����������!!! �� 1)���������� ��� 2)������ ��� 3)������������
            , CASE WHEN _tmp.BusinessId = 0 THEN vbBusinessId_To ELSE _tmp.BusinessId END AS BusinessId 

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
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , CASE WHEN COALESCE (MIString_PartionGoods.ValueData, '') <> '' THEN MIString_PartionGoods.ValueData
                          WHEN COALESCE (MIString_PartionGoodsCalc.ValueData, '') <> '' THEN MIString_PartionGoodsCalc.ValueData
                          ELSE ''
                     END AS PartionGoods
                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate
 
                   , MovementItem.ObjectId AS GoodsId_TicketFuel

                   , MovementItem.Amount AS OperCount
                   , COALESCE (MIFloat_Price.ValueData, 0) AS Price

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

                    -- �������������� ����������
                  , CASE WHEN COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, 0) <> 0 THEN COALESCE (lfObject_InfoMoney_Fuel.InfoMoneyDestinationId, 0)
                         ELSE COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0)
                    END AS InfoMoneyDestinationId
                    -- ������ ����������
                  , CASE WHEN COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, 0) <> 0 THEN COALESCE (lfObject_InfoMoney_Fuel.InfoMoneyId, 0)
                         ELSE COALESCE (lfObject_InfoMoney.InfoMoneyId, 0)
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

                   LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                              AND ObjectLink_Goods_Fuel.ChildObjectId IS NULL
                   LEFT JOIN lfGet_Object_InfoMoney (zc_Enum_InfoMoney_20401()) AS lfObject_InfoMoney_Fuel ON ObjectLink_Goods_Fuel.ChildObjectId <> 0 -- ���

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Income()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp
        ;


     -- �������� - ���� ���� ����� < 0, �� <������>
     IF EXISTS (SELECT MovementItemId FROM _tmpItem WHERE tmpOperSumm_Partner < 0 OR OperSumm_Partner < 0)
     THEN
         RAISE EXCEPTION '������.���� �������� � ������������� ������.';
     END IF;


     -- !!!
     -- IF NOT EXISTS (SELECT MovementItemId FROM _tmpItem) THEN RETURN; END IF;


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
            INTO vbOperSumm_Partner, vbOperSumm_Packer
     FROM (SELECT SUM (_tmpItem.tmpOperSumm_Partner) AS tmpOperSumm_Partner
                , SUM (_tmpItem.tmpOperSumm_Packer) AS tmpOperSumm_Packer
           FROM _tmpItem
          ) AS _tmpItem
     ;


     -- ������ �������� ���� (�� ���������)
     SELECT SUM (OperSumm_Partner), SUM (OperSumm_Packer) INTO vbOperSumm_Partner_byItem, vbOperSumm_Packer_byItem FROM _tmpItem;

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


     -- ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                AND vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- "������"; 20200; "�� �������"
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)
                                               WHEN vbIsPartionDate_Unit
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)
                                               ELSE lpInsertFind_Object_PartionGoods ('')
                                          END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- "�������� �����"; 10100; "������ �����"
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "������"; 30100; "���������"
     ;

     -- ��������� ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������, ����� �� !!!InfoMoneyId_Detail!!!
     -- !!!������ ���� �� �����!!!
     INSERT INTO _tmpItem_SummPartner (ContainerId, AccountId, ContainerId_Transit, AccountId_Transit, InfoMoneyDestinationId, InfoMoneyId, BusinessId, PartionMovementId, OperSumm_Partner)
        SELECT 0 AS ContainerId, 0 AS AccountId, 0 AS ContainerId_Transit, 0 AS AccountId_Transit
             , _tmpSumm.InfoMoneyDestinationId_Detail, _tmpSumm.InfoMoneyId_Detail, _tmpSumm.BusinessId, _tmpSumm.PartionMovementId
             , SUM (_tmpSumm.OperSumm_Partner) AS OperSumm_Partner
        FROM (SELECT _tmpSumm_all.InfoMoneyDestinationId_Detail
                   , _tmpSumm_all.InfoMoneyId_Detail
                   , _tmpSumm_all.BusinessId
                     -- ����������� ������ ���������, ���� �� ���� � NOT vbIsCorporate_From � �������������� ���������� = 10100; "������ �����"
                   , CASE WHEN vbMemberId_From = 0
                           AND _tmpSumm_all.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                           AND vbIsCorporate_From = FALSE
                               THEN lpInsertFind_Object_PartionMovement (inMovementId)
                          ELSE 0
                     END AS PartionMovementId
                   , _tmpSumm_all.OperSumm_Partner
              FROM (SELECT _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyDestinationId_Detail, _tmpItem.InfoMoneyId_Detail, _tmpItem.BusinessId
                         , SUM (_tmpItem.OperSumm_Partner) AS OperSumm_Partner
                    FROM _tmpItem
                    WHERE _tmpItem.OperSumm_Partner <> 0 AND zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
                      AND vbTicketFuelId_From = 0
                    GROUP BY _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyDestinationId_Detail, _tmpItem.InfoMoneyId_Detail, _tmpItem.BusinessId
                   ) AS _tmpSumm_all
             ) AS _tmpSumm
        GROUP BY _tmpSumm.InfoMoneyDestinationId_Detail, _tmpSumm.InfoMoneyId_Detail, _tmpSumm.BusinessId, _tmpSumm.PartionMovementId;

     -- ��������� ������� - �������� �� ���������� (������������), �� ����� ���������� ��� ������������ �������� � ���������, ����� �� !!!InfoMoneyId!!!
     INSERT INTO _tmpItem_SummPacker (ContainerId, AccountId, InfoMoneyDestinationId, InfoMoneyId, BusinessId, OperSumm_Packer)
        SELECT 0 AS ContainerId, 0 AS AccountId
             , _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.BusinessId
             , SUM (_tmpItem.OperSumm_Packer) AS OperSumm_Packer
        FROM _tmpItem
        WHERE _tmpItem.OperSumm_Packer <> 0 AND zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
        GROUP BY _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.BusinessId;


     -- ��������� ������� - �������� �� ���������� (��������), �� ����� ���������� ��� ������������ �������� � ���������, ����� �� !!!InfoMoneyId!!!
     -- !!!�� ������� �������� �� �����������!!! � !!!������ ���� zc_Enum_PaidKind_SecondForm!!! � !!!������ ���� ����������!!! � !!!�� ����� � �� �����!!!
     INSERT INTO _tmpItem_SummDriver (ContainerId, AccountId, ContainerId_Transit, AccountId_Transit, InfoMoneyDestinationId, InfoMoneyId, BusinessId, OperSumm_Driver)
        SELECT 0 AS ContainerId, 0 AS AccountId, 0 AS ContainerId_Transit, 0 AS AccountId_Transit
             , _tmpItem_SummPartner.InfoMoneyDestinationId, _tmpItem_SummPartner.InfoMoneyId
               -- !!!��� ��������� (��������) ����������� ������ ������!!!
             , vbBusinessId_Route
             , _tmpItem_SummPartner.OperSumm_Partner
        FROM _tmpItem_SummPartner
        WHERE vbPaidKindId = zc_Enum_PaidKind_SecondForm()
          AND vbCardFuelId_From = 0
          AND vbTicketFuelId_From = 0
          AND vbCarId <> 0;


     -- ��� �����
     -- RETURN QUERY SELECT _tmpItem.MovementItemId, _tmpItem.MovementId, _tmpItem.OperDate, _tmpItem.JuridicalId_From, _tmpItem.isCorporate, _tmpItem.MemberId_From, _tmpItem.UnitId, _tmpItem.BranchId_Unit, _tmpItem.MemberId_Packer, _tmpItem.PaidKindId, _tmpItem.ContractId, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.AssetId, _tmpItem.PartionGoods, _tmpItem.OperCount, _tmpItem.tmpOperSumm_Partner, _tmpItem.OperSumm_Partner, _tmpItem.tmpOperSumm_Packer, _tmpItem.OperSumm_Packer, _tmpItem.AccountDirectionId, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.InfoMoneyDestinationId_isCorporate, _tmpItem.InfoMoneyId_isCorporate, _tmpItem.JuridicalId_basis, _tmpItem.BusinessId                         , _tmpItem.isPartionCount, _tmpItem.isPartionSumm, _tmpItem.PartionMovementId, _tmpItem.PartionGoodsId FROM _tmpItem;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


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
                                                                            )
     WHERE _tmpItem.isCountSupplier = TRUE AND _tmpItem.OperCount <> 0;

     -- 1.1.2. ����������� !!!������������!!! �������� ��� ��������������� ����� - ����� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_CountSupplier() AS DescId, inMovementId, MovementItemId, ContainerId_CountSupplier, 0 AS ParentId, -1 * OperCount, vbOperDate, FALSE
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
                                                                                 );
     -- 1.2.2. ����������� �������� ��� ��������������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, inMovementId, MovementItemId, ContainerId_Goods, 0 AS ParentId, OperCount, vbOperDate, TRUE
       FROM _tmpItem;
       -- WHERE OperCount <> 0;


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
                                                                                           )
     WHERE vbTicketFuelId_From <> 0;

     -- 1.2.4. ����������� �������� ��� ��������������� ����� - ������ �������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, inMovementId, MovementItemId, ContainerId_GoodsTicketFuel, 0 AS ParentId, -1 * OperCount, vbOperDate, FALSE
       FROM _tmpItem
       WHERE OperCount <> 0
         AND vbTicketFuelId_From <> 0;


     -- 1.3.1. ������������ ����(�����������) ��� �������� �� ��������� �����
     UPDATE _tmpItem SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������ -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                             , inAccountDirectionId     := CASE WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                                                                                     THEN zc_Enum_AccountDirection_20900() -- 20900; "��������� ����"
                                                                                ELSE vbAccountDirectionId_To
                                                                           END
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT _tmpItem.InfoMoneyDestinationId
                      , CASE WHEN _tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_InfoMoneyDestination_WorkProgress() ELSE _tmpItem.InfoMoneyDestinationId END AS InfoMoneyDestinationId_calc
                 FROM _tmpItem
                 WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId
                        , CASE WHEN _tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_InfoMoneyDestination_WorkProgress() ELSE _tmpItem.InfoMoneyDestinationId END
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 1.3.2. ������������ ContainerId_Summ ��� �������� �� ��������� ����� + ����������� ��������� <������� �/�>
     UPDATE _tmpItem SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                              , inUnitId                 := vbUnitId
                                                                              , inCarId                  := vbCarId
                                                                              , inMemberId               := NULL
                                                                              , inBranchId               := vbBranchId_To
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
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, MovementItemId, ContainerId_Summ, 0 AS ParentId, OperSumm_Partner + OperSumm_Packer, vbOperDate, TRUE
       FROM _tmpItem
       WHERE OperSumm_Partner <> 0 OR OperSumm_Packer <> 0
         AND zc_isHistoryCost() = TRUE; -- !!!���� ����� ��������!!!


     -- 2.1. ������������ ����(�����������) ��� �������� �� ���� ���������� ��� ���������� (����������� ����)
     UPDATE _tmpItem_SummPartner SET AccountId         = _tmpItem_byAccount.AccountId
                                   , AccountId_Transit = CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 THEN zc_Enum_Account_110101() ELSE 0 END -- �������
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                             , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbMemberId_From <> 0
                                  THEN zc_Enum_AccountGroup_30000() -- ��������  -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                             WHEN vbIsCorporate_From
                                  THEN zc_Enum_AccountGroup_30000() -- �������� -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                            ELSE zc_Enum_AccountGroup_70000()  -- ��������� select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_70000())
                        END AS AccountGroupId
                      , CASE WHEN vbMemberId_From <> 0
                                  THEN zc_Enum_AccountDirection_30500() -- ���������� (����������� ����)  -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30500())
                             WHEN vbIsCorporate_From
                                  THEN zc_Enum_AccountDirection_30200() -- ���� �������� -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30200())
                            ELSE zc_Enum_AccountDirection_70100() -- ���������� select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_70100())
                        END AS AccountDirectionId
                     , _tmpItem_SummPartner.InfoMoneyDestinationId
                 FROM _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPartner.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 2.2. ������������ ContainerId ��� �������� �� ���� ���������� ��� ���������� (����������� ����)
     UPDATE _tmpItem_SummPartner SET ContainerId =                 CASE WHEN _tmpItem_SummPartner.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                         AND vbMemberId_From = 0
                                                                         AND NOT vbIsCorporate_From
                                                                                -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ���������� 5)������ ���������
                                                                           THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := _tmpItem_SummPartner.AccountId
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := _tmpItem_SummPartner.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_2        := vbPaidKindId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_3        := vbContractId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_4        := _tmpItem_SummPartner.InfoMoneyId
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := _tmpItem_SummPartner.PartionMovementId
                                                                                                       )
                                                                                -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                                                                                -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������(����������� ����) 2)NULL 3)NULL 4)������ ���������� 5)����������
                                                                                -- ��� ����������(����������� ����) !!!������ ����� ��������� ��������� ������ �������� = 0!!!
                                                                           ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := _tmpItem_SummPartner.AccountId
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := _tmpItem_SummPartner.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := CASE WHEN vbMemberId_From <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Juridical() END
                                                                                                      , inObjectId_1        := CASE WHEN vbMemberId_From <> 0 THEN vbMemberId_From ELSE vbJuridicalId_From END
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_2        := _tmpItem_SummPartner.InfoMoneyId
                                                                                                      , inDescId_3          := CASE WHEN vbMemberId_From <> 0 THEN zc_ContainerLinkObject_Car() ELSE zc_ContainerLinkObject_Contract() END
                                                                                                      , inObjectId_3        := CASE WHEN vbMemberId_From <> 0 THEN 0 ELSE vbContractId END
                                                                                                      , inDescId_4          := CASE WHEN vbMemberId_From <> 0 THEN NULL ELSE zc_ContainerLinkObject_PaidKind() END
                                                                                                      , inObjectId_4        := vbPaidKindId
                                                                                                       )
                                                                   END
                                   , ContainerId_Transit = CASE WHEN _tmpItem_SummPartner.AccountId_Transit = 0 THEN 0
                                                                ELSE
                                                                   CASE WHEN _tmpItem_SummPartner.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                         AND vbMemberId_From = 0
                                                                         AND NOT vbIsCorporate_From
                                                                                -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ���������� 5)������ ���������
                                                                           THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := _tmpItem_SummPartner.AccountId_Transit
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := _tmpItem_SummPartner.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_2        := vbPaidKindId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_3        := vbContractId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_4        := _tmpItem_SummPartner.InfoMoneyId
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := _tmpItem_SummPartner.PartionMovementId
                                                                                                       )
                                                                                -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                                                                                -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������(����������� ����) 2)NULL 3)NULL 4)������ ���������� 5)����������
                                                                                -- ��� ����������(����������� ����) !!!������ ����� ��������� ��������� ������ �������� = 0!!!
                                                                           ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := _tmpItem_SummPartner.AccountId_Transit
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := _tmpItem_SummPartner.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := CASE WHEN vbMemberId_From <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Juridical() END
                                                                                                      , inObjectId_1        := CASE WHEN vbMemberId_From <> 0 THEN vbMemberId_From ELSE vbJuridicalId_From END
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_2        := _tmpItem_SummPartner.InfoMoneyId
                                                                                                      , inDescId_3          := CASE WHEN vbMemberId_From <> 0 THEN zc_ContainerLinkObject_Car() ELSE zc_ContainerLinkObject_Contract() END
                                                                                                      , inObjectId_3        := CASE WHEN vbMemberId_From <> 0 THEN 0 ELSE vbContractId END
                                                                                                      , inDescId_4          := CASE WHEN vbMemberId_From <> 0 THEN NULL ELSE zc_ContainerLinkObject_PaidKind() END
                                                                                                      , inObjectId_4        := vbPaidKindId
                                                                                                       )
                                                                   END
                                                           END;

     -- 2.3. ����������� �������� - ���� ���������� ��� ���������� (����������� ����)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       -- ��� ������� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_SummPartner.ContainerId, 0 AS ParentId, -1 * _tmpItem_SummPartner.OperSumm_Partner
            , CASE WHEN _tmpItem_SummPartner.AccountId_Transit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
            , FALSE
       FROM _tmpItem_SummPartner
       WHERE _tmpItem_SummPartner.OperSumm_Partner <> 0
     UNION ALL
       -- ��� ��� �������� ��� ����� �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_SummPartner.ContainerId_Transit, 0 AS ParentId
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END * _tmpItem_SummPartner.OperSumm_Partner
            , tmpOperDate.OperDate
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN FALSE ELSE TRUE END AS IsActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            JOIN _tmpItem_SummPartner ON  _tmpItem_SummPartner.OperSumm_Partner <> 0
                                      AND _tmpItem_SummPartner.AccountId_Transit <> 0
      ;


     -- 3.1. ������������ ����(�����������) ��� �������� �� ������� ���������� (������������)
     UPDATE _tmpItem_SummPacker SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000() -- ��������� -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_70000())
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_70600() -- ��������� (������������) -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_70600())
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT InfoMoneyDestinationId FROM _tmpItem_SummPacker GROUP BY InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPacker.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 3.2. ������������ ContainerId ��� �������� �� ������� ���������� (������������)
     UPDATE _tmpItem_SummPacker SET ContainerId = 
                                                  -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1) ����������(����������) 3)������ ����������
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
                                                                        );
     -- 3.3. ����������� �������� - ������� ���������� (������������)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, ContainerId, 0 AS ParentId, -1 * OperSumm_Packer, vbOperDate, FALSE
       FROM _tmpItem_SummPacker
       WHERE OperSumm_Packer <> 0;


     -- 4.1. ������������ ����(�����������) ��� �������� �� �������� � ����������� ����������� (��������)
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

     -- 4.2. ������������ ContainerId ��� �������� �� �������� � ����������� ����������� (��������)
     UPDATE _tmpItem_SummDriver SET ContainerId = 
                                                  -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1) ����������(����������) 3)������ ����������
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
                                                                        , inDescId_3          := zc_ContainerLinkObject_Car()
                                                                        , inObjectId_3        := vbCarId
                                                                        )
                                  ,ContainerId_Transit = CASE WHEN _tmpItem_SummDriver.AccountId_Transit = 0 THEN 0
                                                              ELSE
                                                  -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1) ����������(����������) 3)������ ����������
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

     -- 4.3. ����������� �������� - ������� � ����������� ����������� (��������)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       -- ��� �������� � ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, ContainerId, 0 AS ParentId, -1 * OperSumm_Driver, vbOperDate, FALSE
       FROM _tmpItem_SummDriver
       WHERE OperSumm_Driver <> 0
     UNION ALL
       -- ��� ������� � ����������� �� ���� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_SummPartner.ContainerId, 0 AS ParentId, 1 * _tmpItem_SummDriver.OperSumm_Driver
            , CASE WHEN _tmpItem_SummDriver.AccountId_Transit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
            , TRUE
       FROM _tmpItem_SummDriver
            JOIN _tmpItem_SummPartner ON _tmpItem_SummPartner.InfoMoneyId = _tmpItem_SummDriver.InfoMoneyId
       WHERE _tmpItem_SummDriver.OperSumm_Driver <> 0
     UNION ALL
       -- ��� ��� �������� ��� ����� �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_SummDriver.ContainerId_Transit, 0 AS ParentId
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 1 ELSE -1 END * _tmpItem_SummDriver.OperSumm_Driver
            , tmpOperDate.OperDate
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN TRUE ELSE FALSE END AS IsActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            JOIN _tmpItem_SummDriver ON  _tmpItem_SummDriver.OperSumm_Driver <> 0
                                     AND _tmpItem_SummDriver.AccountId_Transit <> 0
      ;


     -- 5.1. ����������� �������� ��� ������ (���������: ����� � ��������� ��� ��������� (����������� ����)) !!!����� �� InfoMoneyId_Detail!!!
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
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
                LEFT JOIN _tmpItem_SummPartner ON _tmpItem_SummPartner.InfoMoneyId = _tmpItem.InfoMoneyId_Detail
                LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                                                                                                                   OR  (tmpOperDate.OperDate = vbOperDatePartner
                                                                                                                    AND COALESCE (_tmpItem_SummPartner.AccountId_Transit, 0) <> 0)
           WHERE _tmpItem.OperSumm_Partner <> 0
          ) AS tmpMIReport;

     -- 5.2. ����������� �������� ��� ������ (���������: ����� � ��������� (������������)) !!!����� �� InfoMoneyId!!!
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
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
                                                                                                             , inAccountKindId_1    := (SELECT zc_Enum_AccountKind_All() FROM _tmpItem_SummPartner)
                                                                                                             , inContainerId_1      := (SELECT ContainerId FROM _tmpItem_SummPartner)
                                                                                                             , inAccountId_1        := (SELECT AccountId FROM _tmpItem_SummPartner)
                                                                                                     )
                                              , inAmount   := _tmpItem.OperSumm_Packer
                                              , inOperDate := vbOperDate
                                               )
     FROM _tmpItem
          LEFT JOIN _tmpItem_SummPacker ON _tmpItem_SummPacker.InfoMoneyId = _tmpItem.InfoMoneyId
     WHERE _tmpItem.OperSumm_Packer <> 0;


     -- 5.3. ����������� �������� ��� ������ (���������: ��������� (��������) � ��������� ��� ��������� (����������� ����)) !!!����� �� InfoMoneyId!!!
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
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
                LEFT JOIN _tmpItem_SummPartner ON _tmpItem_SummPartner.InfoMoneyId = _tmpItem.InfoMoneyId
                LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                                                                                                                   OR  (tmpOperDate.OperDate = vbOperDatePartner
                                                                                                                    AND COALESCE (_tmpItem_SummDriver.AccountId_Transit, 0) <> 0)
           WHERE _tmpItem.OperSumm_Partner <> 0
          ) AS tmpMIReport;


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ����� - ����������� ������ ������ ���������
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_Income() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
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
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpItem_SummPartner (ContainerId Integer, AccountId Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, PartionMovementId Integer, OperSumm_Partner TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpItem_SummPacker (ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Packer TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpItem_SummDriver (ContainerId Integer, AccountId Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Driver TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer, ContainerId_CountSupplier Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , ContainerId_GoodsTicketFuel Integer, GoodsId_TicketFuel Integer
                               , OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat
                               , AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_Detail Integer, InfoMoneyId_Detail Integer
                               , BusinessId Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isCountSupplier Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 1100 , inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM lpComplete_Movement_Income (inMovementId:= 1100 , inUserId:= zfCalc_UserAdmin() :: Integer, inIsLastComplete:= FALSE)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 1100 , inSession:= zfCalc_UserAdmin())
*/