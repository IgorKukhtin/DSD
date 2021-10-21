-- Function: lpComplete_Movement_Sale22 (Integer, Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale22 (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale22(
    IN inMovementId        Integer               , -- ���� ���������
    IN inUserId            Integer               , -- ������������
    IN inIsLastComplete    Boolean  DEFAULT False  -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementId_Tax Integer;

  DECLARE vbMovementItemId_check Integer;

  DECLARE vbIsHistoryCost Boolean; -- ����� �������� �/� ��� ����� ������������

  DECLARE vbContainerId_Analyzer Integer;
  DECLARE vbContainerId_Analyzer_PartnerFrom Integer;
  DECLARE vbWhereObjectId_Analyzer Integer;
  DECLARE vbObjectExtId_Analyzer Integer;

  DECLARE vbAccountId_GoodsTransit_01 Integer;
  DECLARE vbAccountId_GoodsTransit_02 Integer;
  DECLARE vbAccountId_GoodsTransit_51 Integer;
  DECLARE vbAccountId_GoodsTransit_52 Integer;
  DECLARE vbAccountId_GoodsTransit_53 Integer;

  DECLARE vbMovementDescId Integer;

  DECLARE vbOperSumm_PriceList_byItem TFloat;
  DECLARE vbOperSumm_PriceList TFloat;
  DECLARE vbOperSumm_PriceListJur_byItem TFloat;
  DECLARE vbOperSumm_PriceListJur TFloat;
  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent_byItem TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent TFloat;
  DECLARE vbOperSumm_PartnerVirt_ChangePercent_byItem TFloat;
  DECLARE vbOperSumm_PartnerVirt_ChangePercent TFloat;
  DECLARE vbOperSumm_Currency_byItem TFloat;
  DECLARE vbOperSumm_Currency TFloat;

  DECLARE vbPriceWithVAT_PriceList Boolean;
  DECLARE vbVATPercent_PriceList TFloat;
  DECLARE vbPriceWithVAT_PriceListJur Boolean;
  DECLARE vbVATPercent_PriceListJur TFloat;
  DECLARE vbPriceListId_Jur Integer;
  DECLARE vbPriceListId_begin Integer;
  DECLARE vbOperDate_pl TDateTime;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbIsChangePrice Boolean;
  DECLARE vbIsDiscountPrice Boolean;

  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDatePartner TDateTime;

  DECLARE vbUnitId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbBranchId_From Integer;
  DECLARE vbAccountDirectionId_From Integer;
  DECLARE vbIsPartionDate_Unit Boolean;

  DECLARE vbJuridicalId_From Integer;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbPaidKindId_From Integer;
  DECLARE vbContractId_From Integer;
  DECLARE vbInfoMoneyDestinationId_From Integer;
  DECLARE vbInfoMoneyId_From Integer;

  DECLARE vbJuridicalId_To Integer;
  DECLARE vbIsCorporate_To Boolean;
  DECLARE vbInfoMoneyId_CorporateTo Integer;
  DECLARE vbPartnerId_To Integer;
  DECLARE vbMemberId_To Integer;
  DECLARE vbInfoMoneyDestinationId_To Integer;
  DECLARE vbInfoMoneyId_To Integer;

  DECLARE vbPaidKindId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbJuridicalId_Basis_From Integer;
  DECLARE vbBusinessId_From Integer;
  DECLARE vbBusinessId_To Integer;

  DECLARE vbCurrencyDocumentId Integer;
  DECLARE vbCurrencyPartnerId Integer;
  DECLARE vbCurrencyValue TFloat;
  DECLARE vbParValue TFloat;
  DECLARE vbCurrencyPartnerValue TFloat;
  DECLARE vbParPartnerValue TFloat;

  DECLARE vbIsPartionDoc_Branch Boolean;
  DECLARE vbPartionMovementId Integer;
  DECLARE vbPaymentDate TDateTime;

  DECLARE vbOperSumm_51201 TFloat;
  DECLARE vbContainerId_51201 Integer;

  DECLARE vbIsPriceList_begin_recalc Boolean;
BEGIN
/*IF inUserId in (zfCalc_UserAdmin() :: Integer) -- , zc_Enum_Process_Auto_PrimeCost(), zfCalc_UserMain())
 OR ('01.10.2017' <= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
     AND
     '01.10.2017' <= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
    )
THEN
    PERFORM lpComplete_Movement_Sale22_NEW (inMovementId, inUserId, FALSE);
    RETURN;
END IF;*/


     -- ContainerId ��� �������������
     vbContainerId_51201:= (SELECT Container.Id -- CLO_InfoMoney.ObjectId
                            FROM ObjectFloat
                                 INNER JOIN ContainerLinkObject AS CLO_PartionMovement
                                                                ON CLO_PartionMovement.ObjectId = ObjectFloat.ObjectId
                                                               AND CLO_PartionMovement.DescId   = zc_ContainerLinkObject_PartionMovement()
                               --INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                               --                               ON CLO_InfoMoney.ContainerId = CLO_PartionMovement.ContainerId
                               --                              AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                 INNER JOIN Container ON Container.Id       = CLO_PartionMovement.ContainerId
                                                     AND Container.ObjectId = zc_Enum_Account_51201() -- ������������� ��������� + ��������� � ��������� + ���������
                                                     AND Container.DescId   = zc_Container_Summ()
                            WHERE ObjectFloat.ValueData = inMovementId
                              AND ObjectFloat.DescId    = zc_ObjectFloat_PartionMovement_MovementId()
                              AND Container.Amount <> 0
                           );
     -- ����� ��� �������������
     vbOperSumm_51201:= (SELECT Container.Amount FROM Container WHERE Container.Id = vbContainerId_51201);



     -- !!!��������!!!
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= inMovementId);

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItemSumm;
     -- !!!�����������!!! �������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ��� ��������� ����� ��� ������� �������� ���� �� ����������� ��� ��������� � ��� ������������ �������� � ���������
     SELECT
            CASE WHEN EXTRACT (MONTH FROM Movement.OperDate) < EXTRACT (MONTH FROM CURRENT_DATE)
                  AND EXTRACT (MONTH FROM CURRENT_DATE) = EXTRACT (MONTH FROM CURRENT_DATE - INTERVAL '7 DAY')
                      THEN TRUE
                 ELSE vbIsHistoryCost
            END AS isHistoryCost -- !!!��� ��� ������!!!
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN      MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE)            AS isDiscountPrice_juridical

          , Movement.DescId                                                      AS MovementDescId
          , Movement.OperDate                                                    AS OperDate -- COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDate --
          , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE 0 END, 0) AS UnitId_From
          , 0 AS MemberId_From -- COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From
          , COALESCE (CASE WHEN ObjectLink_Partner_Branch.ChildObjectId <> 0
                                THEN ObjectLink_Partner_Branch.ChildObjectId

                           WHEN Object_From.DescId = zc_Object_Unit()
                                THEN ObjectLink_UnitFrom_Branch.ChildObjectId

                           WHEN Object_From.DescId = zc_Object_Partner()
                                THEN ObjectLink_PartnerFrom_Branch.ChildObjectId

                           WHEN Object_From.DescId = zc_Object_Personal()
                                THEN ObjectLink_UnitPersonalFrom_Branch.ChildObjectId
                           ELSE 0
                      END, 0) AS BranchId_From
          , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= '01.05.2015'
                      THEN COALESCE (ObjectBoolean_PartionDoc.ValueData, FALSE)
                 ELSE FALSE
            END AS isPartionDoc_Branch
          , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_From -- ��������� ������ - ����������� !!!����� ������ ��� �������������!!!
          , COALESCE (ObjectBoolean_PartionDate.ValueData, FALSE) AS isPartionDate_Unit

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_PartnerFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id ELSE 0 END, 0) AS PartnerId_From
          , COALESCE (MovementLinkObject_PaidKindFrom.ObjectId, 0) AS PaidKindId_From
          , COALESCE (MovementLinkObject_ContractFrom.ObjectId, 0) AS ContractId_From
            -- �� ������ ���������� �����: ������ �� ��������
          , COALESCE (ObjectLink_ContractFrom_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_From

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
          , 0 AS MemberId_To -- COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN Object_To.Id WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_To

            -- �� ������ ���������� �����: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
          , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_To -- COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0)) AS InfoMoneyId_To

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Juridical.ChildObjectId WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_ContractFrom_JuridicalBasis.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Business.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId_From
          , COALESCE (ObjectLink_PartnerTo_Business.ChildObjectId, 0) AS BusinessId_To

          , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
          , COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())  AS CurrencyPartnerId
          , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                               AS CurrencyValue
          , COALESCE (MovementFloat_ParValue.ValueData, 0)                                    AS ParValue
          , COALESCE (MovementFloat_CurrencyPartnerValue.ValueData, 0)                        AS CurrencyPartnerValue
          , COALESCE (ObjectLink_Contract_PriceList.ChildObjectId, ObjectLink_Juridical_PriceList.ChildObjectId) AS PriceListId_Jur

            INTO vbIsHistoryCost, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbIsDiscountPrice
               , vbMovementDescId, vbOperDate, vbOperDatePartner
               , vbUnitId_From, vbMemberId_From, vbBranchId_From, vbIsPartionDoc_Branch, vbAccountDirectionId_From, vbIsPartionDate_Unit
               , vbJuridicalId_From, vbPartnerId_From, vbPaidKindId_From, vbContractId_From, vbInfoMoneyId_From
               , vbJuridicalId_To, vbIsCorporate_To, vbInfoMoneyId_CorporateTo, vbPartnerId_To , vbMemberId_To, vbInfoMoneyId_To
               , vbPaidKindId, vbContractId
               , vbJuridicalId_Basis_From, vbBusinessId_From, vbBusinessId_To
               , vbCurrencyDocumentId, vbCurrencyPartnerId, vbCurrencyValue, vbParValue, vbCurrencyPartnerValue, vbParPartnerValue
               , vbPriceListId_Jur
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

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                       ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                      AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                       ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                      AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
          LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                  ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                 AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
          LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                  ON MovementFloat_ParValue.MovementId = Movement.Id
                                 AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
          LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                  ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                 AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
          LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                  ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                 AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                               ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                               ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDoc
                                  ON ObjectBoolean_PartionDoc.ObjectId = ObjectLink_UnitFrom_Branch.ChildObjectId
                                 AND ObjectBoolean_PartionDoc.DescId = zc_ObjectBoolean_Branch_PartionDoc()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                  ON ObjectBoolean_PartionDate.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()
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

          LEFT JOIN ObjectLink AS ObjectLink_PartnerFrom_Juridical
                               ON ObjectLink_PartnerFrom_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PartnerFrom_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              AND Object_From.DescId = zc_Object_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_PartnerFrom_Branch
                               ON ObjectLink_PartnerFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PartnerFrom_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!�� ������!!!
                              AND Object_From.DescId = zc_Object_Partner()
                              AND 1 = 0 -- ����� ��� ��� ��� ������

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Member
                               ON ObjectLink_PersonalTo_Member.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_PersonalTo_Member.DescId = zc_ObjectLink_Personal_Member()
                              AND Object_To.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              AND Object_To.DescId = zc_Object_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Branch
                               ON ObjectLink_Partner_Branch.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!�� ������!!!
                              AND Object_To.DescId = zc_Object_Partner()
                              AND 1 = 0 -- ����� ��� ��� ��� ������
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Unit
                               ON ObjectLink_Partner_Unit.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
                              AND Object_To.DescId = zc_Object_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Business
                               ON ObjectLink_PartnerTo_Business.ObjectId = ObjectLink_Partner_Unit.ChildObjectId
                              AND ObjectLink_PartnerTo_Business.DescId = zc_ObjectLink_Unit_Business()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                  ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                               ON ObjectLink_Juridical_InfoMoney.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Constant_InfoMoney_isCorporate_View ON Constant_InfoMoney_isCorporate_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId

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

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                               ON ObjectLink_Contract_PriceList.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                               ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     -- ��� ��������� �����-����� ����� ��� ...
     SELECT lfGet.PriceWithVAT, lfGet.VATPercent INTO vbPriceWithVAT_PriceList, vbVATPercent_PriceList FROM lfGet_Object_PriceList (zc_PriceList_Basis()) AS lfGet;
     -- ��� ��������� ����. �����-����� ����� ��� ...
     SELECT lfGet.PriceWithVAT, lfGet.VATPercent INTO vbPriceWithVAT_PriceListJur, vbVATPercent_PriceListJur FROM lfGet_Object_PriceList (vbPriceListId_Jur) AS lfGet;


     -- !!!
     vbIsPriceList_begin_recalc:= inUserId IN (zfCalc_UserMain()) AND vbOperDate >= '01.04.2021';

     -- !!!�������� ��� - ���� ����!!!!
     IF vbIsPriceList_begin_recalc = TRUE
     THEN
         -- !!!�����!!!
         SELECT tmp.PriceListId, tmp.OperDate
               INTO vbPriceListId_begin, vbOperDate_pl
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := vbContractId
                                                   , inPartnerId      := vbPartnerId_To
                                                   , inMovementDescId := zc_Movement_Sale()
                                                   , inOperDate_order := NULL
                                                   , inOperDatePartner:= vbOperDatePartner
                                                   , inDayPrior_PriceReturn:= 0
                                                   , inIsPrior        := FALSE -- !!!���������� �� ������ ���!!!
                                                   , inOperDatePartner_order:= NULL
                                                    ) AS tmp;


         -- ��������� �����
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, vbPriceListId_begin);


         -- ��������� ��������
         PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, inUserId, FALSE)
         FROM (WITH tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                                   , MovementItem.ObjectId                         AS GoodsId
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                   , COALESCE (MIFloat_Price.ValueData, 0)         AS OperPrice_old
                              FROM MovementItem
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                              AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.isErased   = FALSE
                             )
                    , tmpPrice AS (SELECT tmpGoods.GoodsId
                                        , COALESCE (ObjectLink_PriceListItem_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                        , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS OperPrice
                                   FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods
                                         INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                               ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpGoods.GoodsId
                                                              AND ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                         INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                               ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                              AND ObjectLink_PriceListItem_PriceList.ChildObjectId = vbPriceListId_begin
                                                              AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                         LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                              ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                             AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                                         LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                                 ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                                AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                                AND vbOperDate_pl >= ObjectHistory_PriceListItem.StartDate AND vbOperDate_pl < ObjectHistory_PriceListItem.EndDate
                                         LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                      ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                     AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                  )
                  , tmpAll AS (SELECT tmpMI.MovementItemId
                                    , COALESCE (tmpPrice_1.OperPrice, tmpPrice_2.OperPrice, 0) AS OperPrice
                               FROM tmpMI
                                    LEFT JOIN tmpPrice AS tmpPrice_1 ON tmpPrice_1.GoodsId     = tmpMI.GoodsId
                                                                    AND tmpPrice_1.GoodsKindId = tmpMI.GoodsKindId
                                    LEFT JOIN tmpPrice AS tmpPrice_2 ON tmpPrice_2.GoodsId     = tmpMI.GoodsId
                                                                    AND tmpPrice_2.GoodsKindId = 0
                               WHERE COALESCE (tmpPrice_1.OperPrice, tmpPrice_2.OperPrice, 0) > 0
                                 AND tmpMI.OperPrice_old <> COALESCE (tmpPrice_1.OperPrice, tmpPrice_2.OperPrice, 0)
                              )
               -- ��������� ����
               SELECT lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmpAll.MovementItemId, tmpAll.OperPrice)
                    , tmpAll.MovementItemId
               FROM tmpAll
              ) AS tmp;


         -- ����
         -- RAISE EXCEPTION '������.<%  %>', lfGet_Object_ValueData_sh (vbPriceListId_begin), zfConvert_DateToString (vbOperDate_pl);

     END IF;



     -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = zc_Enum_Role_Admin())
        OR (vbOperDate < DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '2 DAY'))
     THEN /*IF inIsLastComplete = FALSE
             -- OR DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '3 DAY') <= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
          -- !!! ����� ��� ��� ���������, ������� ��� ��������!!!
          -- !!! OR 301310 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
          -- !!! ����� ��� ��� ������, ������� ��� ��������!!!
          -- !!! OR 8374 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
          THEN vbIsHistoryCost:= TRUE;
          ELSE vbIsHistoryCost:= FALSE;
          END IF;*/
          vbIsHistoryCost:= TRUE;
     ELSE
         -- !!! ��� ��������� ���� ����� �������� �/�!!!
         IF (0 < (SELECT 1 FROM Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide WHERE View_RoleAccessKeyGuide.UserId = inUserId AND View_RoleAccessKeyGuide.BranchId <> 0 GROUP BY View_RoleAccessKeyGuide.BranchId LIMIT 1)
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382)) -- ��������� �����
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (97837)) -- ��������� �����
            )
         THEN vbIsHistoryCost:= FALSE;
         ELSE vbIsHistoryCost:= TRUE;
         END IF;
     END IF;


     -- ������������ "���������� ���� ������ ���"
     IF vbIsPartionDoc_Branch = TRUE
     THEN
         -- ������������
         vbPaymentDate:= (SELECT tmp.OperDate + (tmp.OperDate - zfCalc_DetermentPaymentDate (COALESCE (Object_ContractCondition_View.ContractConditionKindId, 0), COALESCE (Value, 0) :: Integer, tmp.OperDate))
                          FROM (SELECT vbOperDatePartner AS OperDate) AS tmp
                               LEFT JOIN Object_ContractCondition_View
                                      ON Object_ContractCondition_View.ContractId = vbContractId
                                     AND Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                                     AND Object_ContractCondition_View.Value <> 0
                                     AND vbOperDatePartner BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                         );
         -- ��������
         IF vbPaymentDate IS NULL OR vbPaymentDate < vbOperDatePartner
         THEN
             RAISE EXCEPTION '������.� �������� �� ���������� ������� ��������.(%)', vbPaymentDate;
         END IF;

         -- ������������
         vbPartionMovementId:= lpInsertFind_Object_PartionMovement (inMovementId, vbPaymentDate);

     END IF;

     -- ������������ �������������� ����������, �������� ����� ��� ��� ������������ �������� � ��������� (��� ����������)
     SELECT View_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_From FROM lfGet_Object_InfoMoney (vbInfoMoneyId_From) AS View_InfoMoney;
     SELECT View_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_To FROM lfGet_Object_InfoMoney (vbInfoMoneyId_To) AS View_InfoMoney;

     -- !!!���� ��� ������� ��� "�������� ������������", ����� ��� "������� ������"
     IF COALESCE (vbBranchId_From, 0) = 0
        /*vbInfoMoneyDestinationId_To IN (zc_Enum_InfoMoneyDestination_30100() -- ���������
                                      , zc_Enum_InfoMoneyDestination_30200() -- ������ �����
                                       )
        AND vbBranchId_From = 0*/
     THEN
         vbBranchId_From:= zc_Branch_Basis();
     END IF;


     -- ��������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, ContainerId_GoodsPartner, ContainerId_GoodsTransit_01, ContainerId_GoodsTransit_02, ContainerId_GoodsTransit_53, ObjectDescId, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate, ChangePercent, isChangePrice
                         , OperCount, OperCount_ChangePercent, OperCount_Partner, tmpOperSumm_PriceList, OperSumm_PriceList, tmpOperSumm_PriceListJur, OperSumm_PriceListJur
                         , tmpOperSumm_Partner, tmpOperSumm_Partner_original, tmpOperSumm_PartnerVirt, tmpOperSumm_Partner_Currency
                         , OperSumm_Partner, OperSumm_Partner_ChangePercent, OperSumm_PartnerVirt_ChangePercent, OperSumm_Currency, OperSumm_Partner_ChangePromo, OperSumm_80103
                         , ContainerId_ProfitLoss_10100, ContainerId_ProfitLoss_10200, ContainerId_ProfitLoss_10250, ContainerId_ProfitLoss_10300, ContainerId_ProfitLoss_80103
                         , ContainerId_Partner, ContainerId_Currency, AccountId_Partner, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_From
                         , isPartionCount, isPartionSumm, isTareReturning, isLossMaterials, isPromo
                         , PartionGoodsId
                         , PriceListPrice, PriceListJurPrice, Price, Price_Currency, Price_original, CountForPrice)

    WITH tmpMI_all AS (SELECT (MovementItem.Id)                             AS MovementItemId
                            , MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                            , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent
                            , COALESCE (MIFloat_PromoMovement.ValueData, 0) AS MovementId_promo

                            , (MovementItem.Amount)                                  AS OperCount
                            , (COALESCE (MIFloat_AmountChangePercent.ValueData, 0))  AS OperCount_ChangePercent
                            , (COALESCE (MIFloat_AmountPartner.ValueData, 0))        AS OperCount_Partner

                            , COALESCE (MIFloat_Price.ValueData, 0)                  AS Price_original
                            , COALESCE (MIFloat_CountForPrice.ValueData, 0)          AS CountForPrice

                            , CASE WHEN vbMovementDescId = zc_Movement_SaleAsset() THEN MovementItem.ObjectId ELSE COALESCE (MILinkObject_Asset.ObjectId, 0) END AS AssetId
                            , COALESCE (MIString_PartionGoods.ValueData, '')         AS PartionGoods
                            , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

                            , COALESCE (MIFloat_ContainerId.ValueData, 0) :: Integer AS ContainerId_asset
                            , COALESCE (CLO_PartionGoods.ObjectId, 0)                AS PartionGoodsId_asset

                       FROM MovementItem
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                        ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                            LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                        ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()

                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                         ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                       ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                       AND vbMovementDescId                   = zc_Movement_SaleAsset()
                            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                          ON CLO_PartionGoods.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                         AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                         AND vbMovementDescId        IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                      )
    -- !!!���� ���������� - ���� �� ������ � ����!!!
  , tmpChangePrice AS (SELECT TRUE AS isChangePrice
                       FROM tmpMI_all
                       WHERE (vbIsDiscountPrice = TRUE                    -- � �� ���� ���� �����
                           OR tmpMI_all.ChangePercent = 0                 -- � ����� ���� ������, �� ���� ���� ���� ������� �� ������� = 0%
                           OR vbPaidKindId = zc_Enum_PaidKind_FirstForm() -- ��� ��
                             )
                         AND (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0)
                       LIMIT 1
                      )
     , tmpPL_Basis AS (-- ���� �� ������ ��������, ��� ��������
                       SELECT DISTINCT
                              tmpMI_all.GoodsId
                            , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                            , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS PriceListPrice
                       FROM tmpMI_all
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                  ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpMI_all.GoodsId
                                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                  ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                 AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                                 AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                 ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

                            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                   AND vbOperDatePartner >= ObjectHistory_PriceListItem.StartDate AND vbOperDatePartner < ObjectHistory_PriceListItem.EndDate
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                      )
       , tmpPL_Jur AS (-- ���� �� ������ ��������, ��� ��������
                       SELECT DISTINCT
                              tmpMI_all.GoodsId
                            , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                            , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS PriceListPrice
                       FROM tmpMI_all
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                  ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpMI_all.GoodsId
                                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                  ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                 AND ObjectLink_PriceListItem_PriceList.ChildObjectId = vbPriceListId_Jur
                                                 AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                 ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

                            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                   AND vbOperDatePartner >= ObjectHistory_PriceListItem.StartDate AND vbOperDatePartner < ObjectHistory_PriceListItem.EndDate
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                      )
, tmpContainer_asset AS (SELECT tmpMI.ContainerId_asset
                                -- ���� �� ������ ������ - ����������� ���������� + ���������������� ������������
                              , COALESCE (CLO_InfoMoney.ObjectId, zc_Enum_InfoMoney_70102()) AS InfoMoneyId
                              , ROW_NUMBER()     OVER (PARTITION BY tmpMI.ContainerId_asset ORDER BY CLO_InfoMoney.ObjectId ASC) AS Ord -- !!!�� ������ ������!!!
                         FROM tmpMI_all AS tmpMI
                              LEFT JOIN Container ON Container.ParentId = tmpMI.ContainerId_asset
                                                 AND Container.DescId   = zc_Container_Summ()
                              LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                            ON CLO_InfoMoney.ContainerId = Container.Id
                                                           AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                         WHERE tmpMI.ContainerId_asset > 0
                        )
, tmpContainer_all AS (SELECT tmpMI.MovementItemId
                            , tmpMI.GoodsId
                            , tmpMI.OperCount  AS Amount
                            , tmp.ContainerId  AS ContainerId
                            , tmp.Amount       AS Amount_container
                            , SUM (tmp.Amount) OVER (PARTITION BY tmpMI.GoodsId ORDER BY tmp.PartionGoodsDate,      tmp.ContainerId    )  AS AmountSUM --
                            , ROW_NUMBER()     OVER (PARTITION BY tmpMI.GoodsId ORDER BY tmp.PartionGoodsDate DESC, tmp.ContainerId DESC) AS Ord      -- !!!���� �������� ���������!!!
                            , tmp.PartionGoodsId
                       FROM tmpMI_all AS tmpMI
                            INNER JOIN (SELECT tmpMI.MovementItemId                                  AS MovementItemId
                                             , Container.Id                                          AS ContainerId
                                             , Container.Amount                                      AS Amount
                                             , COALESCE (CLO_PartionGoods.ObjectId, 0)               AS PartionGoodsId
                                             , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                                        FROM tmpMI_all AS tmpMI
                                             INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                                 AND Container.DescId   = zc_Container_Count()
                                                                 AND Container.Amount   > 0
                                             INNER JOIN ContainerLinkObject AS CLO_Member
                                                                            ON CLO_Member.ContainerId = Container.Id
                                                                           AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                                                                                      -- !!!���� ������ � ���������!!!
                                                                           AND CLO_Member.ObjectId    = vbMemberId_From
                                             -- !!!
                                             LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                           ON CLO_PartionGoods.ContainerId = Container.Id
                                                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                             LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                                     AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()

                                             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                  ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

                                             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                                             ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                                        WHERE View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                                                      , zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                                                      , zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                                                       )
                                          -- ������ �� ��
                                          AND tmpMI.ContainerId_asset = 0
                                       ) AS tmp ON tmp.MovementItemId = tmpMI.MovementItemId
                      )
    , tmpContainer AS (SELECT DD.ContainerId
                            , DD.GoodsId
                            , DD.MovementItemId
                            , DD.PartionGoodsId
                            , CASE WHEN DD.Amount - DD.AmountSUM > 0 AND DD.Ord <> 1
                                        THEN DD.Amount_container
                                   ELSE DD.Amount - DD.AmountSUM + DD.Amount_container
                              END AS Amount
                       FROM (SELECT * FROM tmpContainer_all) AS DD
                       WHERE DD.Amount - (DD.AmountSUM - DD.Amount_container) > 0
                      )
        -- ��������� - ����� � ������ ���� ����
        SELECT
              _tmp.MovementItemId

              -- !!!��� ������ ������!!!
            , _tmp.ContainerId_Goods AS ContainerId_Goods
            , 0 AS ContainerId_GoodsPartner

            , 0 AS ContainerId_GoodsTransit_01 -- ���� - ���-�� �������
            , 0 AS ContainerId_GoodsTransit_02 -- ���� - ���-�� �������
            , 0 AS ContainerId_GoodsTransit_53 -- ���� - ���-�� �������

            , _tmp.ObjectDescId
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate
            , _tmp.ChangePercent
            , _tmp.isChangePrice

              -- ���������� � �������
            , _tmp.OperCount
              -- ���������� � ������ % ������
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                        THEN _tmp.OperCount
                   ELSE _tmp.OperCount_ChangePercent
              END AS OperCount_ChangePercent
              -- ���������� � �����������
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                        THEN _tmp.OperCount
                   ELSE _tmp.OperCount_Partner
              END AS OperCount_Partner

              -- ������������� (� ����� ���-��) ����� �����-����� �� ����������� !!!��� ������!!! - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_PriceList
              -- �������� ����� �����-����� �� ����������� !!! ��� ������ !!!
            , CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ������ �� ������
                      THEN _tmp.tmpOperSumm_PriceList
                   WHEN vbVATPercent_PriceList > 0
                      -- ���� ���� ��� ���, ����� �������� ����� � ���
                      THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmp.tmpOperSumm_PriceList AS NUMERIC (16, 2))
              END AS OperSumm_PriceList

              -- ������������� (� ����� ���-��) ����� ����. �����-����� �� ����������� !!!��� ������!!! - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_PriceListJur
              -- �������� ����� ����. �����-����� �� ����������� !!! ��� ������ !!!
            , CASE WHEN vbPriceWithVAT_PriceListJur OR vbVATPercent_PriceListJur = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ������ �� ������
                      THEN _tmp.tmpOperSumm_PriceListJur
                   WHEN vbVATPercent_PriceListJur > 0
                      -- ���� ���� ��� ���, ����� �������� ����� � ���
                      THEN CAST ( (1 + vbVATPercent_PriceListJur / 100) * _tmp.tmpOperSumm_PriceListJur AS NUMERIC (16, 2))
              END AS OperSumm_PriceListJur

              -- ������������� (� ����� ���-��) ����� �� ����������� !!!����� ��� ������(�.�. ������ ���� ����)!!! - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_Partner
              -- ������������� (� ����� ���-��) ����� �� ����������� !!!��� ������!!! - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_Partner_original
              -- ������������� (� ����� ���-��) ����� ��� ���-�� � ��. %��.��� !!!����� ��� ������(�.�. ������ ���� ����)!!! - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_PartnerVirt
              -- ������������� (� ����� ���-��) ����� �� ����������� !!!����� ��� ������(�.�. ������ ���� ����)!!! - � ����������� �� 2-� ������ !!!� ������!!!
            , _tmp.tmpOperSumm_Partner_Currency


              -- �������� ����� �� ����������� !!!��� ������!!!
            , CAST
             (CASE WHEN vbPriceWithVAT = TRUE  OR vbVATPercent = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ������ �� ������
                      THEN _tmp.tmpOperSumm_Partner_original
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� �������� ����� � ���
                      THEN CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_original AS NUMERIC (16, 2))
              END   -- ��� ����������� � ������ zc_Enum_Currency_Basis
                  -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
              AS NUMERIC (16, 2)) AS OperSumm_Partner -- !!!���������!!!


              -- �������� ����� �� �����������
            , CAST
             (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
              END   -- ��� ����������� � ������ zc_Enum_Currency_Basis
                  -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
              AS NUMERIC (16, 2)) AS OperSumm_Partner_ChangePercent  -- !!!���������!!!


              -- �������� ����� �� ����������� - ��� ���-�� � ��. %��.���
            , CAST
             (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_PartnerVirt
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_PartnerVirt) AS NUMERIC (16, 2))
                           END
              END   -- ��� ����������� � ������ zc_Enum_Currency_Basis
                  -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
              AS NUMERIC (16, 2)) AS OperSumm_PartnerVirt_ChangePercent -- !!!���������!!!


              -- �������� ����� � ������ �� �����������
            , CAST
             (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner_Currency
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner_Currency) AS NUMERIC (16, 2))
                           END
              END   -- ��� ����������� � ������ CurrencyPartnerId
                  * CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue /  vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
              AS NUMERIC (16, 2)) AS OperSumm_Currency -- !!!���������!!!

              -- ����� ������ �����
            , 0 AS OperSumm_Partner_ChangePromo
              -- �����
            , 0 AS OperSumm_80103

              -- ���� - ������� (���� - ����� ����������)
            , 0 AS ContainerId_ProfitLoss_10100
              -- ���� - ������� (���� - ������� � �������� ������)
            , 0 AS ContainerId_ProfitLoss_10200
              -- ���� - ������� (���� - ������ �����)
            , 0 AS ContainerId_ProfitLoss_10250
              -- ���� - ������� (���� - ������ ��������������)
            , 0 AS ContainerId_ProfitLoss_10300
              -- ���� - ������� (���� - �������� �������)
            , 0 AS ContainerId_ProfitLoss_80103

              -- ���� - ���� �����������
            , 0 AS ContainerId_Partner
              -- ���� - ���� ����������� � ������
            , 0 AS ContainerId_Currency
              -- ����(�����������) �����������
            , 0 AS AccountId_Partner
              -- �������������� ������
            , _tmp.InfoMoneyGroupId
              -- �������������� ����������
            , _tmp.InfoMoneyDestinationId
              -- ������ ����������
            , _tmp.InfoMoneyId

              -- �������� ������ !!!����������!!!: 1) ���������� (��� ����������)  2) ����� 3) ������������/���������
            , CASE WHEN vbBusinessId_To <> 0 THEN vbBusinessId_To WHEN _tmp.BusinessId_From = 0 THEN vbBusinessId_From ELSE _tmp.BusinessId_From END AS BusinessId_From

            , _tmp.isPartionCount
            , _tmp.isPartionSumm

              -- ���������� �� ��� ���� (���� ��, ������������� �������� �� �������)
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                        THEN TRUE
                   ELSE FALSE
              END AS isTareReturning

              -- �������� ������ ����� �� ��� (���� ��, �� � ��������� ����� zc_Enum_AnalyzerId_Loss...)
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20600() -- 10200; "������ �����"
                        THEN TRUE
                   ELSE FALSE
              END AS isLossMaterials
              -- �������� ������ ����� �� ��� (���� ��, �� � ��������� ����� zc_Enum_AnalyzerId_Loss...)
            , CASE WHEN _tmp.MovementId_promo > 0
                        THEN TRUE
                   ELSE FALSE
              END AS isPromo

              -- ������ ������, ���������� ����� - !!!��� ������ ������!!!
            , _tmp.PartionGoodsId_Item AS PartionGoodsId


            , _tmp.PriceListPrice
            , _tmp.PriceListJurPrice
            , _tmp.Price
            , _tmp.Price_Currency
            , _tmp.Price_original
            , _tmp.CountForPrice

        FROM
             (-- ������ ����� �� ��������� + �� ���������� �� 2-� ������ (������ ���� ���� - ����� ��������� ����)
              SELECT
                    tmpMI.MovementItemId
                  , Object_Goods.DescId AS ObjectDescId
                  , tmpMI.GoodsId
                  , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ��������� + ������ ������ �����
                              THEN tmpMI.GoodsKindId
                         WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                              THEN tmpMI.GoodsKindId
                         ELSE 0
                    END AS GoodsKindId
                  , tmpMI.AssetId
                  , tmpMI.PartionGoods
                  , tmpMI.PartionGoodsDate
                  , tmpMI.ChangePercent
                  , tmpMI.isChangePrice
                  , tmpMI.MovementId_promo

                  , COALESCE (tmpPL_Basis_kind.PriceListPrice, tmpPL_Basis.PriceListPrice, 0) AS PriceListPrice
                  , COALESCE (tmpPL_Jur_kind.PriceListPrice, tmpPL_Jur.PriceListPrice, 0)     AS PriceListJurPrice
                  , tmpMI.Price
                  , tmpMI.Price_original
                  , tmpMI.Price_Currency
                  , tmpMI.CountForPrice
                    -- ���������� ��� ������
                  , tmpMI.OperCount
                    -- ���������� � ������ % ������
                  , tmpMI.OperCount_ChangePercent
                    -- ���������� � �����������
                  , tmpMI.OperCount_Partner

                    -- ������������� ����� �����-����� �� ����������� - � ����������� �� 2-� ������
                  , COALESCE (CAST (tmpMI.OperCount_Partner * COALESCE (tmpPL_Basis_kind.PriceListPrice, tmpPL_Basis.PriceListPrice, 0) AS NUMERIC (16, 2)), 0) AS tmpOperSumm_PriceList
                    -- ������������� ����� ����. �����-����� �� ����������� - � ����������� �� 2-� ������
                  , COALESCE (CAST (tmpMI.OperCount_Partner * COALESCE (tmpPL_Jur_kind.PriceListPrice, tmpPL_Jur.PriceListPrice, 0)     AS NUMERIC (16, 2)), 0) AS tmpOperSumm_PriceListJur
                    -- ������������� ����� �� ����������� - � ����������� �� 2-� ������ + ������ ������ � ���� (!!!���� ����!!!)
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner
                    -- ������������� ����� ��� ���-�� � ��. %��.��� - � ����������� �� 2-� ������ + ������ ������ � ���� (!!!���� ����!!!)
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_ChangePercent * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_ChangePercent * tmpMI.Price AS NUMERIC (16, 2))
                    END AS tmpOperSumm_PartnerVirt

                    -- ������������� ����� �� ����������� - � ����������� �� 2-� ������ + ������ ������ � ���� (!!!���� ����!!!) !!!� ������!!!
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price_Currency / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price_Currency AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner_Currency
                    -- ������������� ����� �� ����������� - � ����������� �� 2-� ������ + !!!��!!! ������ ������ � ����
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price_original AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner_original

                    -- �������������� ������
                  , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
                    -- �������������� ����������
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- ������ ����������
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- ������ �� ������
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_From

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm

                    -- !!!��� ������ ������!!!
                  , tmpMI.ContainerId_Goods
                    -- !!!��� ������ ������!!!
                  , tmpMI.PartionGoodsId_Item

              FROM (-- ������� ���� � ������ zc_Enum_Currency_Basis
                    SELECT tmpMI.MovementItemId
                         , tmpMI.ContainerId_asset
                         , tmpMI.GoodsId
                         , tmpMI.GoodsKindId
                         , tmpMI.AssetId
                         , tmpMI.PartionGoods
                         , tmpMI.PartionGoodsDate
                         , tmpMI.ChangePercent
                         , tmpMI.isChangePrice
                         , tmpMI.MovementId_promo

                         , tmpMI.OperCount
                         , tmpMI.OperCount_ChangePercent
                         , tmpMI.OperCount_Partner
                             , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                         -- ��� ����������� � ������ zc_Enum_Currency_Basis
                                         THEN CAST (tmpMI.Price * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                                    ELSE tmpMI.Price
                               END AS Price
                             , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                         -- ��� ����������� � ������ zc_Enum_Currency_Basis
                                         THEN CAST (tmpMI.Price_original * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                                    ELSE tmpMI.Price_original
                               END AS Price_original
                             , tmpMI.Price AS Price_Currency
                         , tmpMI.CountForPrice

                           -- !!!��� ������ ������!!!
                         , tmpMI.ContainerId_Goods
                           -- !!!��� ������ ������!!!
                         , tmpMI.PartionGoodsId_Item

                    FROM (-- ������ ���� � ������ ������ !!!"������"!!!
                          SELECT tmpMI_all.MovementItemId
                               , tmpMI_all.ContainerId_asset
                               , tmpMI_all.GoodsId
                               , tmpMI_all.GoodsKindId
                               , tmpMI_all.AssetId
                               , tmpMI_all.PartionGoods
                               , tmpMI_all.PartionGoodsDate
                               , tmpMI_all.ChangePercent
                               , COALESCE (tmpChangePrice.isChangePrice, FALSE) AS isChangePrice
                               , tmpMI_all.MovementId_promo

                                 -- !!!��� ������ ������!!!
                               , COALESCE (tmpContainer.Amount, tmpMI_all.OperCount)               AS OperCount
                               , COALESCE (tmpContainer.Amount, tmpMI_all.OperCount_ChangePercent) AS OperCount_ChangePercent
                               , COALESCE (tmpContainer.Amount, tmpMI_all.OperCount_Partner)       AS OperCount_Partner

                               , CASE WHEN tmpChangePrice.isChangePrice = TRUE AND tmpMI_all.ChangePercent <> 0 -- !!!��� ��� "������" �� ���������, ��� �� - ������ ���������!!!
                                           THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                    , inChangePercent:= tmpMI_all.ChangePercent
                                                                    , inPrice        := tmpMI_all.Price_original
                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                     )
                                      ELSE tmpMI_all.Price_original
                                 END AS Price
                               , tmpMI_all.Price_original
                               , tmpMI_all.CountForPrice

                                 -- !!!��� ������ ������ - ContainerId_Goods !!!
                               , CASE WHEN vbMovementDescId = zc_Movement_SaleAsset() THEN tmpMI_all.ContainerId_asset    ELSE COALESCE (tmpContainer.ContainerId, 0)    END AS ContainerId_Goods
                                 -- !!!��� ������ ������ - PartionGoodsId_Item !!!
                               , CASE WHEN vbMovementDescId = zc_Movement_SaleAsset() THEN tmpMI_all.PartionGoodsId_asset ELSE COALESCE (tmpContainer.PartionGoodsId, 0) END AS PartionGoodsId_Item

                          FROM tmpMI_all
                               LEFT JOIN tmpChangePrice ON tmpChangePrice.isChangePrice = TRUE
                               LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = tmpMI_all.MovementItemId
                         ) AS tmpMI
                   ) AS tmpMI

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

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

                   LEFT JOIN tmpContainer_asset ON tmpContainer_asset.ContainerId_asset = tmpMI.ContainerId_asset
                                               AND tmpContainer_asset.Ord               = 1

                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                   ON View_InfoMoney.InfoMoneyId = CASE WHEN Object_Goods.DescId = zc_Object_Asset()
                                                                                                       THEN -- !!!�������� �����������!!! - ����������� ���������� + ���������������� ������������
                                                                                                            COALESCE (tmpContainer_asset.InfoMoneyId, zc_Enum_InfoMoney_70102())
                                                                                                  ELSE ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                             END
                   -- ����������� ���� 2 ���� �� ���� � ���
                   LEFT JOIN tmpPL_Basis AS tmpPL_Basis_kind
                                         ON tmpPL_Basis_kind.GoodsId                   = tmpMI.GoodsId
                                        AND COALESCE (tmpPL_Basis_kind.GoodsKindId, 0) = COALESCE (tmpMI.GoodsKindId, 0)
                   LEFT JOIN tmpPL_Basis ON tmpPL_Basis.GoodsId     = tmpMI.GoodsId
                                        AND tmpPL_Basis.GoodsKindId IS NULL

                   -- ����������� ���� 2 ���� �� ���� � ���
                   LEFT JOIN tmpPL_Jur AS tmpPL_Jur_kind
                                       ON tmpPL_Jur_kind.GoodsId                  = tmpMI.GoodsId
                                      AND COALESCE (tmpPL_Jur_kind.GoodsKindId,0) = COALESCE (tmpMI.GoodsKindId,0)
                   LEFT JOIN tmpPL_Jur ON tmpPL_Jur.GoodsId     = tmpMI.GoodsId
                                      AND tmpPL_Jur.GoodsKindId IS NULL
             ) AS _tmp
            ;

     -- !!!���� ���������� - ���� �� ������ � ����!!!
     vbIsChangePrice:= (SELECT _tmpItem.isChangePrice FROM _tmpItem LIMIT 1);


     -- �������� - ��� ��
     IF vbMovementDescId = zc_Movement_SaleAsset()
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

     -- ��������
     IF COALESCE (vbContractId, 0) = 0 AND (EXISTS (SELECT _tmpItem.isTareReturning FROM _tmpItem WHERE _tmpItem.isTareReturning = FALSE))
     THEN
         RAISE EXCEPTION '������.� ��������� �� ��������� <�������>.���������� ����������.';
     END IF;

     -- �������� - ���� = 0
     vbMovementItemId_check:= (SELECT MIN (_tmpItem.MovementItemId)
                               FROM _tmpItem
                               WHERE _tmpItem.OperCount_Partner > 0
                               --AND _tmpItem.OperSumm_Partner  = 0
                                 AND _tmpItem.Price_original    = 0
                                 AND _tmpItem.InfoMoneyDestinationId NOT IN (zc_Enum_InfoMoneyDestination_10200() -- ������ �����
                                                                           , zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                                                           , zc_Enum_InfoMoneyDestination_20600() -- ������ ���������
                                                                           , zc_Enum_InfoMoneyDestination_30500() -- ������ ������
                                                                            ));
     --
     IF vbMovementItemId_check > 0 AND 1=1 -- AND inUserId = 5
        AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
        AND vbIsCorporate_To = FALSE
     THEN
         RAISE EXCEPTION '������.%� ��������� � <%> �� <%> ���� = 0%<%> <%>.%���������� ����������.'
                       , CHR (13)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , zfConvert_DateToString (vbOperDate)
                       , CHR (13)
                       , (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId)        FROM _tmpItem WHERE _tmpItem.MovementItemId = vbMovementItemId_check)
                       , (SELECT lfGet_Object_ValueData_sh (_tmpItem.GoodsKindId) FROM _tmpItem WHERE _tmpItem.MovementItemId = vbMovementItemId_check)
                       , CHR (13)
                        ;
     END IF;

     -- ����� ������
     IF inUserId <> zfCalc_UserAdmin() :: Integer OR 1=1
     THEN
         -- !!!��������� - �����������/������� �����������!!! - �� ��������� "����������" - !!!����� - ����� ��������� _tmpMIContainer_insert, ������� ������ �� ��������!!!, �� ����� ���������� _tmpItem
         PERFORM lpComplete_Movement_Sale_Recalc (inMovementId := inMovementId
                                                , inUnitId     := vbUnitId_From
                                                , inUserId     := inUserId
                                                 );
     END IF;


     -- !!!
     -- IF NOT EXISTS (SELECT MovementItemId FROM _tmpItem) THEN RETURN; END IF;


     -- ������� ����
     SELECT -- ������ �������� ����� �����-����� �� �����������
            CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ������ �� ������
                    THEN _tmpItem.tmpOperSumm_PriceList
                 WHEN vbVATPercent_PriceList > 0
                    -- ���� ���� ��� ���, ����� �������� ����� � ���
                    THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmpItem.tmpOperSumm_PriceList AS NUMERIC (16, 2))
            END AS OperSumm_PriceList


            -- ������ �������� ����� �����-����� �� �����������
          , CASE WHEN vbPriceWithVAT_PriceListJur OR vbVATPercent_PriceListJur = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ������ �� ������
                    THEN _tmpItem.tmpOperSumm_PriceListJur
                 WHEN vbVATPercent_PriceListJur > 0
                    -- ���� ���� ��� ���, ����� �������� ����� � ���
                    THEN CAST ( (1 + vbVATPercent_PriceListJur / 100) * _tmpItem.tmpOperSumm_PriceListJur AS NUMERIC (16, 2))
            END AS OperSumm_PriceListJur


            -- ������ �������� ����� �� ����������� !!!��� ������!!!
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ������ �� ������
                    THEN _tmpItem.tmpOperSumm_Partner_original
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� �������� ����� � ���
                    THEN CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_original AS NUMERIC (16, 2))
            END   -- ��� ����������� � ������ zc_Enum_Currency_Basis
                -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_Partner  -- !!!���������!!!


            -- ������ �������� ����� �� �����������
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END   -- ��� ����������� � ������ zc_Enum_Currency_Basis
                -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_Partner_ChangePercent  -- !!!���������!!!


            -- ������ �������� ����� �� ����������� - ��� ���-�� � ��. %��.���
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_PartnerVirt
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                         END
            END   -- ��� ����������� � ������ zc_Enum_Currency_Basis
                -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_PartnerVirt_ChangePercent  -- !!!���������!!!


            -- ������ �������� ����� � ������ �� �����������
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner_Currency
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                         END
            END   -- ��� ����������� � ������ CurrencyPartnerId
                * CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue /  vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
            AS NUMERIC (16, 2)) AS OperSumm_Currency  -- !!!���������!!!

            INTO vbOperSumm_PriceList, vbOperSumm_PriceListJur, vbOperSumm_Partner, vbOperSumm_Partner_ChangePercent, vbOperSumm_PartnerVirt_ChangePercent, vbOperSumm_Currency
     FROM
           -- �������� 1 ������
          (SELECT SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_PriceList    ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.PriceListPrice    AS NUMERIC (16, 2)) END) AS tmpOperSumm_PriceList
                , SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_PriceListJur ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.PriceListJurPrice AS NUMERIC (16, 2)) END) AS tmpOperSumm_PriceListJur

                , SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_Partner -- ��� �������� �� ������� ������ �������� (���� ���� �� �����������)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner

                , SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_PartnerVirt -- ��� �������� �� ������� ������ �������� (���� ���� �� �����������)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_ChangePercent * _tmpItem.Price / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_ChangePercent * _tmpItem.Price AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_PartnerVirt

                , SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_Partner_original -- ��� �������� �� ������� ������ �������� (���� ���� �� �����������)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_original / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_original AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner_original

                , SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_Partner_Currency -- ��� �������� �� ������� ������ �������� (���� ���� �� �����������)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_Currency / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_Currency AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner_Currency

           FROM (SELECT _tmpItem.PriceListPrice
                      , _tmpItem.PriceListJurPrice
                      , _tmpItem.Price
                      , _tmpItem.Price_original
                      , _tmpItem.Price_Currency
                      , _tmpItem.CountForPrice
                      , SUM (_tmpItem.OperCount_ChangePercent)  AS OperCount_ChangePercent
                      , SUM (_tmpItem.OperCount_Partner)        AS OperCount_Partner
                      , SUM (_tmpItem.tmpOperSumm_PriceList)    AS tmpOperSumm_PriceList
                      , SUM (_tmpItem.tmpOperSumm_PriceListJur) AS tmpOperSumm_PriceListJur
                      , SUM (_tmpItem.tmpOperSumm_Partner)      AS tmpOperSumm_Partner
                      , SUM (_tmpItem.tmpOperSumm_PartnerVirt)  AS tmpOperSumm_PartnerVirt
                      , SUM (_tmpItem.tmpOperSumm_Partner_original) AS tmpOperSumm_Partner_original
                      , SUM (_tmpItem.tmpOperSumm_Partner_Currency) AS tmpOperSumm_Partner_Currency
                 FROM _tmpItem
                 GROUP BY _tmpItem.PriceListPrice
                        , _tmpItem.PriceListJurPrice
                        , _tmpItem.Price
                        , _tmpItem.Price_original
                        , _tmpItem.Price_Currency
                        , _tmpItem.CountForPrice
                        , _tmpItem.GoodsId
                        , _tmpItem.GoodsKindId
                ) AS _tmpItem
          ) AS _tmpItem
    ;

     -- !!!�������� �������� - ����������� � ������ zc_Enum_Currency_Basis!!! - !!!������ ��� � ����������� � �������� �����!!!
     IF vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND vbParValue <> 0
     THEN
         vbOperSumm_Partner_ChangePercent:= CAST (vbOperSumm_Currency * vbCurrencyValue / vbParValue AS NUMERIC (16, 2));
         IF vbDiscountPercent = 0 AND vbExtraChargesPercent = 0
         THEN vbOperSumm_Partner:= vbOperSumm_Partner_ChangePercent;
         END IF;
     END IF;


     -- ������ �������� ���� �� ����������� (�� ���������)
     SELECT SUM (_tmpItem.OperSumm_PriceList), SUM (_tmpItem.OperSumm_PriceListJur), SUM (_tmpItem.OperSumm_Partner), SUM (_tmpItem.OperSumm_Partner_ChangePercent), SUM (_tmpItem.OperSumm_PartnerVirt_ChangePercent), SUM (_tmpItem.OperSumm_Currency)
            INTO vbOperSumm_PriceList_byItem, vbOperSumm_PriceListJur_byItem, vbOperSumm_Partner_byItem, vbOperSumm_Partner_ChangePercent_byItem, vbOperSumm_PartnerVirt_ChangePercent_byItem, vbOperSumm_Currency_byItem
     FROM _tmpItem;

     -- ���� �� ����� ��� �������� ����� �����-����� �� �����������
     IF COALESCE (vbOperSumm_PriceList, 0) <> COALESCE (vbOperSumm_PriceList_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_PriceList = _tmpItem.OperSumm_PriceList - (vbOperSumm_PriceList_byItem - vbOperSumm_PriceList)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_PriceList DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_PriceList DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- ���� �� ����� ��� �������� ����� ����. �����-����� �� �����������
     IF COALESCE (vbOperSumm_PriceListJur, 0) <> COALESCE (vbOperSumm_PriceListJur_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_PriceListJur = _tmpItem.OperSumm_PriceListJur - (vbOperSumm_PriceListJur_byItem - vbOperSumm_PriceListJur)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_PriceListJur DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_PriceListJur DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- ���� �� ����� ��� �������� ����� �� ����������� !!!��� ������!!!
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_Partner = _tmpItem.OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_Partner DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_Partner DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- ���� �� ����� ��� �������� ����� �� �����������
     IF COALESCE (vbOperSumm_Partner_ChangePercent, 0) <> COALESCE (vbOperSumm_Partner_ChangePercent_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_Partner_ChangePercent = _tmpItem.OperSumm_Partner_ChangePercent - (vbOperSumm_Partner_ChangePercent_byItem - vbOperSumm_Partner_ChangePercent)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_Partner_ChangePercent DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_Partner_ChangePercent DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- ���� �� ����� ��� �������� ����� ��� ���-�� � ��. %��.���
     IF COALESCE (vbOperSumm_PartnerVirt_ChangePercent, 0) <> COALESCE (vbOperSumm_PartnerVirt_ChangePercent_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_PartnerVirt_ChangePercent = _tmpItem.OperSumm_PartnerVirt_ChangePercent - (vbOperSumm_PartnerVirt_ChangePercent_byItem - vbOperSumm_PartnerVirt_ChangePercent)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_PartnerVirt_ChangePercent DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_PartnerVirt_ChangePercent DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- ���� �� ����� ��� �������� ����� � ������ �� �����������
     IF COALESCE (vbOperSumm_Currency, 0) <> COALESCE (vbOperSumm_Currency_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_Currency = _tmpItem.OperSumm_Currency - (vbOperSumm_Currency_byItem - vbOperSumm_Currency)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_Currency DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_Currency DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- !!!���������� ������ ����� - ������ �����!!!
     UPDATE _tmpItem SET OperSumm_Partner_ChangePromo = CASE WHEN _tmpItem.isPromo = TRUE AND vbPriceListId_Jur <> 0
                                                                  THEN _tmpItem.OperSumm_PriceListJur - _tmpItem.OperSumm_Partner
                                                             WHEN _tmpItem.isPromo = TRUE
                                                                  THEN _tmpItem.OperSumm_PriceList - _tmpItem.OperSumm_Partner
                                                             ELSE 0
                                                        END;

     -- ������������� - ��������� � ��������� + ���������
     IF vbOperSumm_51201 <> 0
     THEN
         -- ������������
         UPDATE _tmpItem SET OperSumm_51201 = CAST (vbOperSumm_51201 * _tmpItem.OperSumm_Partner / vbOperSumm_Partner AS NUMERIC (16,2))
         WHERE _tmpItem.isLossMaterials = FALSE;

         -- ���� �� ����� �� ������ �����
         IF vbOperSumm_51201 <> (SELECT SUM (COALESCE (_tmpItem.OperSumm_51201, 0)) FROM _tmpItem)
         THEN
             -- ��������� �������
             UPDATE _tmpItem SET OperSumm_51201 = _tmpItem.OperSumm_51201 - (SELECT SUM (_tmpItem.OperSumm_51201) FROM _tmpItem) + vbOperSumm_51201
             WHERE _tmpItem.MovementItemId = (SELECT _tmpItem.MovementItemId FROM _tmpItem WHERE _tmpItem.OperSumm_51201 <> 0 ORDER BY _tmpItem.OperSumm_51201 DESC LIMIT 1);

         END IF;
     END IF;


     -- ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbMovementDescId = zc_Movement_SaleAsset()
                                                    THEN _tmpItem.PartionGoodsId -- !!!������ ��� �����!!!

                                               WHEN (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- ������������� + �������� � �������
                                                  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                    )
                                                 AND (_tmpItem.PartionGoodsId    > 0
                                                   OR _tmpItem.ContainerId_Goods > 0
                                                     )
                                                    THEN _tmpItem.PartionGoodsId

                                               WHEN _tmpItem.ObjectDescId     = zc_Object_Asset()
                                                 OR _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- ����������
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
                                                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                             ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                          WHERE ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                            AND ObjectLink_Goods.ChildObjectId = _tmpItem.GoodsId
                                                          ORDER BY CASE WHEN CLO_PartionGoods.ObjectId = ObjectLink_Goods.ObjectId AND CLO_Unit.ObjectId = vbUnitId_From AND Container.Amount > 0 THEN 1
                                                                        WHEN CLO_Unit.ObjectId = vbUnitId_From THEN 2
                                                                        ELSE 3
                                                                   END ASC
                                                                 , Container.Amount DESC
                                                          LIMIT 1
                                                         )
                                               WHEN vbAccountDirectionId_From = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                AND vbOperDate >= zc_DateStart_PartionGoods()
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                               WHEN vbIsPartionDate_Unit = TRUE
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)
                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                   THEN 0

                                               WHEN (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                              --  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                    )
                                              -- AND _tmpItem.UnitId_Item > 0
                                              -- AND 1=0
                                                   THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= NULL
                                                                                        , inGoodsId       := NULL -- _tmpItem.GoodsId
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
        OR _tmpItem.ObjectDescId           = zc_Object_Asset()
     ;


     -- ����������� ������ ���� ������� �� ����������� -> �����������
     INSERT INTO _tmpItemPartnerFrom (MovementItemId, ContainerId_Partner, AccountId_Partner, ContainerId_ProfitLoss_10100, ContainerId_ProfitLoss_10400, OperSumm_Partner)
        SELECT MovementItemId
             , 0 AS ContainerId_Partner
             , 0 AS AccountId_Partner
             , 0 AS ContainerId_ProfitLoss_10100
             , 0 AS ContainerId_ProfitLoss_10400
             , OperSumm_PriceList AS OperSumm_Partner
        FROM _tmpItem
        WHERE vbPartnerId_From <> 0
    ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 3.0.1. ������������ ����(�����������) ��� �������� �� ���� ���������� !!!���� ������� �� ����������� -> �����������!!!
     UPDATE _tmpItemPartnerFrom SET AccountId_Partner = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- ��������
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30100() -- ����������
                                             , inInfoMoneyDestinationId := vbInfoMoneyDestinationId_From
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
           WHERE EXISTS (SELECT _tmpItemPartnerFrom.AccountId_Partner FROM _tmpItemPartnerFrom)
          ) AS _tmpItem_byAccount
     ;

     -- 3.0.2. ������������ ContainerId ��� �������� �� ���� ���������� !!!���� ������� �� ����������� -> �����������!!!
     UPDATE _tmpItemPartnerFrom SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
     FROM _tmpItem
          INNER JOIN (SELECT -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                             lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                   , inParentId          := NULL
                                                   , inObjectId          := (SELECT AccountId_Partner FROM _tmpItemPartnerFrom GROUP BY AccountId_Partner)
                                                   , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                   , inBusinessId        := tmp.BusinessId_From
                                                   , inObjectCostDescId  := NULL
                                                   , inObjectCostId      := NULL
                                                   , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                   , inObjectId_1        := vbJuridicalId_From
                                                   , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                   , inObjectId_2        := vbContractId_From
                                                   , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                   , inObjectId_3        := vbInfoMoneyId_From
                                                   , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                   , inObjectId_4        := vbPaidKindId_From
                                                   , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                   , inObjectId_5        := vbPartionMovementId
                                                   , inDescId_6          := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                   , inObjectId_6        := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN vbPartnerId_From ELSE NULL END
                                                   , inDescId_7          := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                   , inObjectId_7        := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN vbBranchId_From ELSE NULL END
                                                   , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                   , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                    ) AS ContainerId
                           , tmp.BusinessId_From
            FROM (SELECT _tmpItem.BusinessId_From
                  FROM _tmpItem
                  WHERE EXISTS (SELECT _tmpItemPartnerFrom.AccountId_Partner FROM _tmpItemPartnerFrom)
                  GROUP BY _tmpItem.BusinessId_From
                 ) AS tmp
          ) AS _tmpItem_byInfoMoney ON _tmpItem_byInfoMoney.BusinessId_From = _tmpItem.BusinessId_From
     WHERE _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
     ;


     -- 3.1. ������������ ����(�����������) ��� �������� �� ���� ���������� ��� ���.���� (����������� ����)
     UPDATE _tmpItem SET AccountId_Partner = _tmpItem_byAccount.AccountId
     FROM (SELECT CASE WHEN vbIsCorporate_To = TRUE
                            THEN _tmpItem_group.AccountId_Corporate
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- ��������
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                   END AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbMemberId_To <> 0
                                  THEN zc_Enum_AccountDirection_30500() -- ���.���� (����������� ����)
                             WHEN vbIsCorporate_To = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- ���� ��������
                             WHEN vbInfoMoneyDestinationId_To IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                , zc_Enum_InfoMoneyDestination_20700()  -- ������
                                                                , zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                , zc_Enum_InfoMoneyDestination_30100()  -- ���������
                                                                , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                  THEN CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis() THEN zc_Enum_AccountDirection_30150() ELSE zc_Enum_AccountDirection_30100() END -- ���������� ��� OR ����������
                             WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                    , zc_Enum_InfoMoneyDestination_20700()  -- ������
                                                                    , zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                    , zc_Enum_InfoMoneyDestination_30100()  -- ���������
                                                                    , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                  THEN CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis() THEN zc_Enum_AccountDirection_30150() ELSE zc_Enum_AccountDirection_30100() END -- ���������� ��� OR ����������
                          -- ELSE zc_Enum_AccountDirection_30400() -- ������ ��������
                             ELSE CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis() THEN zc_Enum_AccountDirection_30150() ELSE zc_Enum_AccountDirection_30100() END -- ���������� ��� OR ����������
                        END AS AccountDirectionId

                      , CASE WHEN vbIsCorporate_To = TRUE
                                  THEN vbInfoMoneyDestinationId_To -- zc_Enum_InfoMoneyDestination_30100() -- ���������
                             WHEN vbInfoMoneyDestinationId_To <> 0
                                  THEN vbInfoMoneyDestinationId_To -- ��: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                             WHEN _tmpItem.isTareReturning = TRUE -- !!!���������� ����!!!
                               OR _tmpItem.isLossMaterials = TRUE -- !!!������ ����� � �����=0!!!
                                  THEN zc_Enum_InfoMoneyDestination_30100() -- ���������
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
                        END AS AccountId_Corporate
                 FROM _tmpItem
                 WHERE _tmpItem.isTareReturning = FALSE -- !!!���������� ���� �� ����������!!!
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!������ ������������, �.�. ���� AccountId � ��������� ��� ������!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId, _tmpItem.isTareReturning, _tmpItem.isLossMaterials
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 3.2.1. ������������ ContainerId ��� �������� �� ���� ���������� ��� ���.���� (����������� ����)
     UPDATE _tmpItem SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
     FROM (SELECT CASE WHEN vbMemberId_To <> 0
                                 -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���.���� (����������� ����) 2)NULL 3)NULL 4)������ ����������
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := _tmpItem_group.AccountId_Partner
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                       , inBusinessId        := _tmpItem_group.BusinessId_From
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_Member()
                                                       , inObjectId_1        := vbMemberId_To
                                                       , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                       , inObjectId_2        := _tmpItem_group.InfoMoneyId_calc
                                                       , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                       , inObjectId_3        := vbBranchId_From -- ���� ��������� ������ �� ������� ������
                                                       , inDescId_4          := zc_ContainerLinkObject_Car()
                                                       , inObjectId_4        := 0 -- ��� ���.���� (����������� ����) !!!������ ����� ��������� ��������� ������ �������� = 0!!!
                                                        )
                            -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
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
                                                  , inObjectId_5        := vbPartionMovementId
                                                  , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                  , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbPartnerId_To ELSE NULL END
                                                  , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                  , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbBranchId_From ELSE NULL END
                                                  , inDescId_8          := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE zc_ContainerLinkObject_Currency() END
                                                  , inObjectId_8        := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE vbCurrencyPartnerId END
                                                   )
                  END AS ContainerId
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.AccountId_Partner
                      , _tmpItem.InfoMoneyId
                      , _tmpItem.BusinessId_From
                      , CASE WHEN vbInfoMoneyId_To <> 0
                                  THEN vbInfoMoneyId_To -- ��: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                             WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20901 () -- ����
                                  THEN zc_Enum_InfoMoney_30101 () -- ������� ���������
                             ELSE _tmpItem.InfoMoneyId -- ����� ����� �� ������
                        END AS InfoMoneyId_calc
                 FROM _tmpItem
                 WHERE _tmpItem.isTareReturning = FALSE -- !!!���������� ���� �� ����������!!!
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!������ ������������, �.�. ���� ContainerId � ��������� ��� ������!!!
                 GROUP BY _tmpItem.AccountId_Partner
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_group
          ) AS _tmpItem_byInfoMoney
     WHERE _tmpItem.InfoMoneyId = _tmpItem_byInfoMoney.InfoMoneyId
     ;

     -- 3.3. !!!����� ����� - ���������� ����� vbContainerId_Analyzer ��� ����!!!, ���� �� �� ���� - ����� ������
     vbContainerId_Analyzer:= (SELECT ContainerId_Partner FROM _tmpItem WHERE ContainerId_Partner <> 0 GROUP BY ContainerId_Partner);
     -- ����������
     vbContainerId_Analyzer_PartnerFrom:= (SELECT ContainerId_Partner FROM _tmpItemPartnerFrom WHERE ContainerId_Partner <> 0 GROUP BY ContainerId_Partner);
     -- ����������
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From WHEN vbPartnerId_From <> 0 THEN vbPartnerId_From END;
     -- ����������
     vbObjectExtId_Analyzer:= CASE WHEN vbPartnerId_To <> 0 THEN vbPartnerId_To WHEN vbMemberId_To <> 0 THEN vbMemberId_To END;

     -- ����������
     vbAccountId_GoodsTransit_01:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110101() ELSE 0 END; -- ������� + ����� � ����
     IF vbOperDate < zc_DateStart_OperDatePartner()
     THEN vbAccountId_GoodsTransit_02:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110102() ELSE 0 END; -- ������� + ����� � ����
     ELSE vbAccountId_GoodsTransit_02:= vbAccountId_GoodsTransit_01;
     END IF;
     -- ����������
     vbAccountId_GoodsTransit_51:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110151() ELSE 0 END; -- ������� + ����� � ����
     vbAccountId_GoodsTransit_52:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110152() ELSE 0 END; -- ������� + ����� � ����
     IF vbOperDate < zc_DateStart_OperDatePartner()
     THEN vbAccountId_GoodsTransit_53:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110153() ELSE 0 END; -- ������� + ����� � ����
     ELSE vbAccountId_GoodsTransit_53:= vbAccountId_GoodsTransit_01;
     END IF;


     -- 1.1.1. ������������ ContainerId_GoodsPartner ��� !!!�� ������������!!! �������� �� ��������������� ����� - ����� ���������� ��� ���.����
     UPDATE _tmpItem SET ContainerId_GoodsPartner = -- 0)����� 1)����������
                                                    -- 0)����� 1)���.����
                                                    lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                                          , inParentId          := NULL
                                                                          , inObjectId          := _tmpItem.GoodsId
                                                                          , inJuridicalId_basis := NULL
                                                                          , inBusinessId        := NULL
                                                                          , inObjectCostDescId  := NULL
                                                                          , inObjectCostId      := NULL
                                                                          , inDescId_1          := CASE WHEN vbMemberId_To <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Partner() END
                                                                          , inObjectId_1        := CASE WHEN vbMemberId_To <> 0 THEN vbMemberId_To ELSE vbPartnerId_To END
                                                                          , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                                          , inObjectId_2        := vbBranchId_From
                                                                          , inDescId_3          := zc_ContainerLinkObject_PaidKind()
                                                                          , inObjectId_3        := vbPaidKindId
                                                                           )
     WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
       AND vbPartnerId_From = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
    ;

     -- 1.1.2. ����������� !!!�� ������������!!! �������� ��� ��������������� ����� - ����� ���������� ��� ���.����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_GoodsPartner
            , 0                                       AS AccountId                -- ��� �����
            , zc_Enum_AnalyzerId_TareReturning()      AS AnalyzerId               -- ���� ���������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- �����
            , CASE WHEN vbMemberId_To <> 0 THEN vbMemberId_To ELSE vbPartnerId_To END AS WhereObjectId_Analyzer -- ���������� ��� ���.����
            , 0                                       AS ContainerId_Analyzer     -- !!!���!!!
            , 0                                       AS ObjectIntId_Analyzer     -- !!!���!!!
            , vbWhereObjectId_Analyzer                AS ObjectExtId_Analyzer     -- ������������� ���...
            , ContainerId_GoodsPartner                AS ContainerIntId_Analyzer  -- ��������� "�����" - ��� �� �����
            , 0                                       AS ParentId
            , OperCount                               AS Amount
            , vbOperDatePartner                       AS OperDate                 -- �.�. �� "���� ����������"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
         AND vbPartnerId_From = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
      ;


     -- 1.2.0. ������������ ContainerId_Goods ��� ��������������� ����� - !!!���� ������� �� ����������� -> �����������!!!
     UPDATE _tmpItemPartnerFrom SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDatePartner -- !!!�� "���� ����������"!!!
                                                                                           , inUnitId                 := NULL -- !!!������������� ���!!!
                                                                                           , inCarId                  := NULL
                                                                                           , inMemberId               := NULL
                                                                                           , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                           , inGoodsId                := _tmpItem.GoodsId
                                                                                           , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                           , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                           , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                           , inAssetId                := _tmpItem.AssetId
                                                                                           , inBranchId               := NULL
                                                                                           , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                            )
     FROM _tmpItem
     WHERE _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
    ;
     -- 1.2.1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_Goods = CASE WHEN _tmpItem.ContainerId_Goods > 0 THEN _tmpItem.ContainerId_Goods
                                             ELSE
                                             lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- �� "���� �����"
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := -- !!!����� ������ - ��������!!!
                                                                                                              CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                        THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                              FROM Container
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId
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
                                                                                , inBranchId               := vbBranchId_From -- ��� ��������� ����� ��� �������
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
                                             END
                  -- � ����������
                , ContainerId_GoodsTransit_01 = CASE WHEN vbAccountId_GoodsTransit_01 <> 0 AND _tmpItem.isLossMaterials = FALSE -- !!!���� �� ��������!!!
                                        THEN lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- �� "���� �����"
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := -- !!!����� ������ - ��������!!!
                                                                                                              CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                        THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                              FROM Container
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId
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
                                                                                , inBranchId               := vbBranchId_From             -- ��� ��������� ����� ��� �������
                                                                                , inAccountId              := vbAccountId_GoodsTransit_01 -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
                                        ELSE 0 END
                  -- ������� � ����
                , ContainerId_GoodsTransit_02 = CASE WHEN vbAccountId_GoodsTransit_02 <> 0 AND _tmpItem.isLossMaterials = FALSE -- !!!���� �� ��������!!!
                                                      AND _tmpItem.OperCount_ChangePercent <> _tmpItem.OperCount_Partner
                                        THEN lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- �� "���� �����"
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := -- !!!����� ������ - ��������!!!
                                                                                                              CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                        THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                              FROM Container
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId
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
                                                                                , inBranchId               := vbBranchId_From             -- ��� ��������� ����� ��� �������
                                                                                , inAccountId              := vbAccountId_GoodsTransit_02 -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
                                        ELSE 0 END
                  -- ������ � ����
                , ContainerId_GoodsTransit_53 = CASE WHEN vbAccountId_GoodsTransit_53 <> 0 AND _tmpItem.isLossMaterials = FALSE -- !!!���� �� ��������!!!
                                                     AND _tmpItem.OperCount <>_tmpItem.OperCount_ChangePercent
                                        THEN lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- �� "���� �����"
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := -- !!!����� ������ - ��������!!!
                                                                                                              CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                        THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                              FROM Container
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId
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
                                                                                , inBranchId               := vbBranchId_From             -- ��� ��������� ����� ��� �������
                                                                                , inAccountId              := vbAccountId_GoodsTransit_53 -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
                                        ELSE 0 END
     WHERE vbPartnerId_From = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
    ;

     -- 1.2.2. ����������� �������� ��� ��������������� ����� (�������)
        WITH tmpMIContainer AS
            (SELECT MovementItemId
                  , ContainerId_Goods
                  , 0                                          AS AccountId_GoodsTransit
                  , 0                                          AS ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                    -- ���-��, �������� ��� ����������/����������� �� ����
                  , zc_Enum_AnalyzerId_LossCount_20200()       AS AnalyzerId
                  , 0                                          AS ParentId
                  , -1 * OperCount                             AS Amount
                  , FALSE                                      AS isActive
             FROM _tmpItem
             WHERE vbPartnerId_From = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
               AND isLossMaterials = TRUE -- !!!���� ��������!!!
            UNION ALL
             SELECT MovementItemId
                  , ContainerId_Goods
                  , vbAccountId_GoodsTransit_01                AS AccountId_GoodsTransit
                  , ContainerId_GoodsTransit_01                AS ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                    --  ���-��, ����������, � ����������
                  , CASE WHEN isTareReturning = TRUE THEN zc_Enum_AnalyzerId_TareReturning() ELSE zc_Enum_AnalyzerId_SaleCount_10400() END AS AnalyzerId
                  , 0                                          AS ParentId
                  , -1 * OperCount_Partner                     AS Amount
                  , FALSE                                      AS isActive
             FROM _tmpItem
             -- ����� �.�. ���� ���� �������� ������ ���� (!!!��� �������!!!)
             -- WHERE OperCount_Partner <> 0
             WHERE vbPartnerId_From = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
               AND isLossMaterials = FALSE -- !!!���� �� ��������!!!
            UNION ALL
             SELECT MovementItemId
                  , ContainerId_Goods
                  , vbAccountId_GoodsTransit_53                AS AccountId_GoodsTransit
                  , ContainerId_GoodsTransit_53                AS ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                    --  ���-��, ����������, ������ �� ���
                  , CASE WHEN isTareReturning = TRUE THEN zc_Enum_AnalyzerId_TareReturning() ELSE zc_Enum_AnalyzerId_SaleCount_10500() END AS AnalyzerId
                  , 0                                          AS ParentId
                  , -1 * (OperCount - OperCount_ChangePercent) AS Amount
                  , FALSE                                      AS isActive
             FROM _tmpItem
             WHERE (OperCount - OperCount_ChangePercent) <> 0  -- !!!������� �� �����!!!
               AND isLossMaterials = FALSE -- !!!���� �� ��������!!!
               AND vbPartnerId_From = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
            UNION ALL
             SELECT MovementItemId
                  , ContainerId_Goods
                  , vbAccountId_GoodsTransit_02                        AS AccountId_GoodsTransit
                  , ContainerId_GoodsTransit_02                        AS ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                     -- ���-��, ����������, ������� � ����
                  , CASE WHEN isTareReturning = TRUE THEN zc_Enum_AnalyzerId_TareReturning() ELSE zc_Enum_AnalyzerId_SaleCount_40200() END AS AnalyzerId
                  , 0                                                  AS ParentId
                  , -1 * (OperCount_ChangePercent - OperCount_Partner) AS Amount
                  , FALSE                                              AS isActive
             FROM _tmpItem
             WHERE (OperCount_ChangePercent - OperCount_Partner) <> 0 -- !!!������� �� �����!!!
               AND isLossMaterials = FALSE -- !!!���� �� ��������!!!
               AND vbPartnerId_From = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
            )
     -- ��������: AnalyzerId <> 0 ������, ContainerId_Analyzer <> 0 ����� �������� � ������ ����������, ����� "�����������" (�.�. AccountId <> 0, AnalyzerId <> 0, ContainerId_Analyzer = 0)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- ��� ������� ��������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_Goods
            , 0                                       AS AccountId                -- ��� �����
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!��������� ���� ������!!! (���� ���� ����� �������, ��� ����� ��� ������)
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 AND tmpMIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossCount_20200() THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- ���� ��� �������, ����� � ���������� �� vbOperDate �� �������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- ���� ��� �������, ����� � ���������� �� vbOperDate ������� 2 ���� � + � -
            , tmpMIContainer.GoodsKindId              AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , tmpMIContainer.ContainerId_Goods        AS ContainerIntId_Analyzer  -- ��������� "�����" - ��� �� �����
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount
            , vbOperDate -- �.�. �� "���� �����"
            , tmpMIContainer.isActive
       FROM tmpMIContainer

     UNION ALL
       -- ��� ��� �������� ��� ����� �������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_GoodsTransit
            , tmpMIContainer.AccountId_GoodsTransit   AS AccountId                -- ���� ���� (�.�. � ������� ������������ "�������")
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!��������� ���� ������!!! (���� ��� "�����������")
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- �.�. � ���������� ������� "��������" �� vbOperDatePartner
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- �.�. � ���������� ������� "��������" �� vbOperDatePartner + �� vbOperDate ������� 2 ���� � + � -
            , tmpMIContainer.GoodsKindId              AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , tmpMIContainer.ContainerId_GoodsTransit AS ContainerIntId_Analyzer  -- ��������� "�����" - ��� �� �����
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END AS Amount -- "�����������" � �������� ������
            , tmpOperDate.OperDate -- !!!��� �������� �� ������ ����!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN NOT tmpMIContainer.isActive ELSE tmpMIContainer.isActive END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN tmpMIContainer ON tmpMIContainer.AccountId_GoodsTransit <> 0
                                     AND tmpMIContainer.AnalyzerId             <> zc_Enum_AnalyzerId_LossCount_20200() -- !!!���� �� ��������!!!

     UNION ALL
       -- ��� ������� �������� - !!!���� ������� �� ����������� -> �����������!!!
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItemPartnerFrom.MovementItemId
            , _tmpItemPartnerFrom.ContainerId_Goods
            , 0                                       AS AccountId                -- ��� �����
            , zc_Enum_AnalyzerId_SaleCount_10400()    AS AnalyzerId               -- !!!��������� ���� ������!!! ���-��, ����������, � ����������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , CASE WHEN tmpIsActive.isActive = TRUE THEN vbPartnerId_From ELSE vbPartnerId_To END AS WhereObjectId_Analyzer
            , CASE WHEN tmpIsActive.isActive = TRUE THEN vbContainerId_Analyzer_PartnerFrom ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItemPartnerFrom.ContainerId_Goods   AS ContainerIntId_Analyzer  -- ��������� "�����" - ��� �� �����
            , 0 AS ParentId
            , _tmpItem.OperCount_Partner * CASE WHEN tmpIsActive.isActive = TRUE THEN 1 ELSE -1 END AS Amount
            , vbOperDatePartner -- �.�. �� "���� ����������"
            , tmpIsActive.isActive
       FROM (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmpIsActive
            INNER JOIN _tmpItem ON _tmpItem.OperCount_Partner <> 0  -- !!!������� �� �����!!!
            INNER JOIN _tmpItemPartnerFrom ON _tmpItemPartnerFrom.MovementItemId = _tmpItem.MovementItemId
      ;


     -- 1.2.3. ������ !!!���������� ���� �� ����������!!!, ������� �������
     DELETE FROM _tmpItem WHERE _tmpItem.isTareReturning = TRUE;

     -- 1.2.4. ������ !!!������ ����� � �����=0 �� ����������!!!, ������� ������� (����� ��� ����� �������� ��������))
     -- DELETE FROM _tmpItem WHERE _tmpItem.isLossMaterials = TRUE;



     IF vbIsHistoryCost         = TRUE -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
        AND zc_isHistoryCost()  = TRUE -- !!!���� ����� ��������!!!
     THEN
     -- 1.3.1.1. ����� ����������: ��������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_Goods, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10500, ContainerId_ProfitLoss_10400, ContainerId_ProfitLoss_20200, ContainerId, AccountId, ContainerId_Transit_01, ContainerId_Transit_02, ContainerId_Transit_51, ContainerId_Transit_52, ContainerId_Transit_53, OperSumm, OperSumm_ChangePercent, OperSumm_Partner, isLossMaterials)
        SELECT
              _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0 AS ContainerId_ProfitLoss_40208 -- ���� - ������� (���� - ������� � ���� : �/�2 - �/�3)
            , 0 AS ContainerId_ProfitLoss_10500 -- ���� - ������� (���� - ������ � ���� : �/�1 - �/�2)
            , 0 AS ContainerId_ProfitLoss_10400 -- ���� - ������� (���� - ������������� ���������� : �/�3)
            , 0 AS ContainerId_ProfitLoss_20200 -- ���� - ������� (���� - �������������������� ������� + ���������� �������)
            , COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0)) AS ContainerId
            , COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) AS AccountId

            , 0 AS ContainerId_Transit_01 -- ���� �������, ��������� ����� +++
            , 0 AS ContainerId_Transit_02 -- ���� �������, ��������� ����� +++
            , 0 AS ContainerId_Transit_51 -- ���� �������, ��������� �����
            , 0 AS ContainerId_Transit_52 -- ���� �������, ��������� �����
            , 0 AS ContainerId_Transit_53 -- ���� �������, ��������� ����� +++

              -- �/�1 - ��� ����������: ������ � �������
            , SUM (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                 + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                             THEN HistoryCost.Summ_diff -- !!!���� ���� "�����������" ��� ����������, �������� �����!!!
                        ELSE 0
                   END) AS OperSumm
              -- �/�2 - ��� ����������: � ������ % ������
            , SUM (CAST (_tmpItem.OperCount_ChangePercent * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                 + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                             THEN HistoryCost.Summ_diff -- !!!���� ���� "�����������" ��� ����������, �������� �����!!!
                        ELSE 0
                   END) AS OperSumm_ChangePercent
              -- �/�3 - ��� ����������: �����������
            , SUM (CAST (_tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                 + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                             THEN HistoryCost.Summ_diff -- !!!���� ���� "�����������" ��� ����������, �������� �����!!!
                        ELSE 0
                   END) AS OperSumm_Partner
            , _tmpItem.isLossMaterials
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
                                                  AND Container_Summ.DescId   = zc_Container_Summ()
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id) -- HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) <> 0                 -- !!!
             OR _tmpItem.OperCount_ChangePercent * COALESCE (HistoryCost.Price, 0) <> 0  -- ����� ���� !!!�� �����!!!
             OR _tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0) <> 0)       -- !!!
          AND vbPartnerId_From = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
        GROUP BY _tmpItem.MovementItemId
               , _tmpItem.ContainerId_Goods
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId
               , _tmpItem.isLossMaterials

       UNION ALL
        SELECT
              _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0 AS ContainerId_ProfitLoss_40208 -- ���� - ������� (���� - ������� � ���� : �/�2 - �/�3)
            , 0 AS ContainerId_ProfitLoss_10500 -- ���� - ������� (���� - ������ � ���� : �/�1 - �/�2)
            , 0 AS ContainerId_ProfitLoss_10400 -- ���� - ������� (���� - ������������� ���������� : �/�3)
            , 0 AS ContainerId_ProfitLoss_20200 -- ���� - ������� (���� - �������������������� ������� + ���������� �������)
            , COALESCE (Container_Summ.Id, 0)       AS ContainerId
            , COALESCE (Container_Summ.ObjectId, 0) AS AccountId

            , 0 AS ContainerId_Transit_01 -- ���� �������, ��������� ����� +++
            , 0 AS ContainerId_Transit_02 -- ���� �������, ��������� ����� +++
            , 0 AS ContainerId_Transit_51 -- ���� �������, ��������� �����
            , 0 AS ContainerId_Transit_52 -- ���� �������, ��������� �����
            , 0 AS ContainerId_Transit_53 -- ���� �������, ��������� ����� +++

              -- �/�1 - ��� ����������: ������ � �������
            , _tmpItem.OperSumm_51201 AS OperSumm
              -- �/�2 - ��� ����������: � ������ % ������
            , _tmpItem.OperSumm_51201 AS OperSumm_ChangePercent
              -- �/�3 - ��� ����������: �����������
            , _tmpItem.OperSumm_51201 AS OperSumm_Partner
            , _tmpItem.isLossMaterials
        FROM _tmpItem
             -- ��� �������
             LEFT JOIN Container AS Container_Summ ON Container_Summ.Id = vbContainerId_51201
        WHERE _tmpItem.OperSumm_51201 <> 0
       ;

     END IF; -- if vbIsHistoryCost = TRUE AND zc_isHistoryCost() = TRUE


     -- 1.3.1.2. ������������ ContainerId - �������
     UPDATE _tmpItemSumm SET -- � ����������
                             ContainerId_Transit_01 = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := CLO_Unit.ObjectId
                                                                                        , inCarId                  := CLO_Car.ObjectId
                                                                                        , inMemberId               := CLO_Member.ObjectId
                                                                                        , inBranchId               := vbBranchId_From -- ��� ��������� ����� ��� �������
                                                                                        , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                        , inBusinessId             := CLO_Business.ObjectId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_01 -- !!!��� ����� �������!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                        , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_01 -- ���� - ���-�� �������
                                                                                        , inGoodsId                := CLO_Goods.ObjectId
                                                                                        , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                        , inAssetId                := CLO_Asset.ObjectId
                                                                                         )
                             -- ������� � ����
                           , ContainerId_Transit_02 = CASE WHEN _tmpItem.ContainerId_GoodsTransit_02 <> 0 THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := CLO_Unit.ObjectId
                                                                                        , inCarId                  := CLO_Car.ObjectId
                                                                                        , inMemberId               := CLO_Member.ObjectId
                                                                                        , inBranchId               := vbBranchId_From -- ��� ��������� ����� ��� �������
                                                                                        , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                        , inBusinessId             := CLO_Business.ObjectId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_02 -- !!!��� ����� �������!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                        , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_02 -- ���� - ���-�� �������
                                                                                        , inGoodsId                := CLO_Goods.ObjectId
                                                                                        , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                        , inAssetId                := CLO_Asset.ObjectId
                                                                                         )
                                                      ELSE 0
                                                      END
                             -- � ����������
                           , ContainerId_Transit_51 = CASE WHEN 1=1 THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := CLO_Unit.ObjectId
                                                                                        , inCarId                  := CLO_Car.ObjectId
                                                                                        , inMemberId               := CLO_Member.ObjectId
                                                                                        , inBranchId               := vbBranchId_From -- ��� ��������� ����� ��� �������
                                                                                        , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                        , inBusinessId             := CLO_Business.ObjectId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_51 -- !!!��� ����� �������!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                        , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_01 -- ���� - ���-�� �������
                                                                                        , inGoodsId                := CLO_Goods.ObjectId
                                                                                        , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                        , inAssetId                := CLO_Asset.ObjectId
                                                                                         )
                                                      ELSE 0
                                                      END
                             -- ������� � ����
                           , ContainerId_Transit_52 = CASE WHEN 1=1 AND _tmpItem.ContainerId_GoodsTransit_02 <> 0 THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := CLO_Unit.ObjectId
                                                                                        , inCarId                  := CLO_Car.ObjectId
                                                                                        , inMemberId               := CLO_Member.ObjectId
                                                                                        , inBranchId               := vbBranchId_From -- ��� ��������� ����� ��� �������
                                                                                        , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                        , inBusinessId             := CLO_Business.ObjectId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_52 -- !!!��� ����� �������!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                        , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_02 -- ���� - ���-�� �������
                                                                                        , inGoodsId                := CLO_Goods.ObjectId
                                                                                        , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                        , inAssetId                := CLO_Asset.ObjectId
                                                                                         )
                                                      ELSE 0
                                                      END
                             -- ������ � ����
                           , ContainerId_Transit_53 = CASE WHEN _tmpItem.ContainerId_GoodsTransit_53 <> 0 THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := CLO_Unit.ObjectId
                                                                                        , inCarId                  := CLO_Car.ObjectId
                                                                                        , inMemberId               := CLO_Member.ObjectId
                                                                                        , inBranchId               := vbBranchId_From -- ��� ��������� ����� ��� �������
                                                                                        , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                        , inBusinessId             := CLO_Business.ObjectId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_53 -- !!!��� ����� �������!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                        , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_53 -- ���� - ���-�� �������
                                                                                        , inGoodsId                := CLO_Goods.ObjectId
                                                                                        , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                        , inAssetId                := CLO_Asset.ObjectId
                                                                                         )
                                                      ELSE 0
                                                      END
     FROM (SELECT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId, _tmpItemSumm.ContainerId_Goods FROM _tmpItemSumm) AS _tmpItemSumm_find
          INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm_find.MovementItemId
                             AND _tmpItem.ContainerId_Goods = _tmpItemSumm_find.ContainerId_Goods
                             AND _tmpItem.isLossMaterials   = FALSE -- !!!���� �� ��������!!!
          LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis ON CLO_JuridicalBasis.ContainerId = _tmpItemSumm_find.ContainerId
                                                             AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
          LEFT JOIN ContainerLinkObject AS CLO_Business ON CLO_Business.ContainerId = _tmpItemSumm_find.ContainerId
                                                       AND CLO_Business.DescId = zc_ContainerLinkObject_Business()
          LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = _tmpItemSumm_find.ContainerId
                                                        AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
          LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = _tmpItemSumm_find.ContainerId
                                                              AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
          LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = _tmpItemSumm_find.ContainerId
                                                    AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
          LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpItemSumm_find.ContainerId
                                                        AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
          LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpItemSumm_find.ContainerId
                                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
          LEFT JOIN ContainerLinkObject AS CLO_Asset ON CLO_Asset.ContainerId = _tmpItemSumm_find.ContainerId
                                                    AND CLO_Asset.DescId = zc_ContainerLinkObject_AssetTo()
          LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = _tmpItemSumm_find.ContainerId
                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
          LEFT JOIN ContainerLinkObject AS CLO_Car ON CLO_Car.ContainerId = _tmpItemSumm_find.ContainerId
                                                  AND CLO_Car.DescId = zc_ContainerLinkObject_Car()
          LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = _tmpItemSumm_find.ContainerId
                                                     AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
     WHERE _tmpItemSumm.MovementItemId    = _tmpItemSumm_find.MovementItemId
       AND _tmpItemSumm.ContainerId       = _tmpItemSumm_find.ContainerId
       AND _tmpItemSumm.ContainerId_Goods = _tmpItemSumm_find.ContainerId_Goods
       AND vbAccountId_GoodsTransit_01    <> 0
    ;


     -- 1.3.2. ����������� �������� ��� ��������� ����� (c/c �������) + !!!���� MovementItemId!!!
        WITH tmpAccount_60000 AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_60000()) -- ������� ������� ��������
           , tmpMIContainer AS
            (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_Goods
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , _tmpItemSumm.ContainerId_Transit_52
                  , _tmpItemSumm.ContainerId_Transit_53
                    -- ����� �/�, �������� ��� ����������/����������� �� ����
                  , zc_Enum_AnalyzerId_LossSumm_20200() AS AnalyzerId
                  , 0                                   AS ParentId
                  , -1 * _tmpItemSumm.OperSumm          AS Amount
                  , FALSE                               AS isActive
             FROM _tmpItemSumm
             WHERE _tmpItemSumm.OperSumm        <> 0   -- !!!������� �� �����!!!
               AND _tmpItemSumm.isLossMaterials = TRUE -- !!!���� ��������!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_Goods
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , _tmpItemSumm.ContainerId_Transit_52
                  , _tmpItemSumm.ContainerId_Transit_53
                    -- ����� �/�, ����������, � ����������
                  , zc_Enum_AnalyzerId_SaleSumm_10400() AS AnalyzerId
                  , 0                                   AS ParentId
                  , -1 * _tmpItemSumm.OperSumm_Partner  AS Amount
                  , FALSE                               AS isActive
             FROM _tmpItemSumm
             WHERE _tmpItemSumm.OperSumm_Partner <> 0    -- !!!������� �� �����!!!
               AND _tmpItemSumm.isLossMaterials  = FALSE -- !!!���� �� ��������!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_Goods
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , _tmpItemSumm.ContainerId_Transit_52
                  , _tmpItemSumm.ContainerId_Transit_53
                    --  ����� �/�, ����������, ������ �� ���
                  , zc_Enum_AnalyzerId_SaleSumm_10500()                                AS AnalyzerId
                  , 0                                                                  AS ParentId
                  , -1 * (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS Amount
                  , FALSE                                                              AS isActive
             FROM _tmpItemSumm
             WHERE (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) <> 0    -- !!!������� �� �����!!!
               AND _tmpItemSumm.isLossMaterials                                  = FALSE -- !!!���� �� ��������!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_Goods
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , _tmpItemSumm.ContainerId_Transit_52
                  , _tmpItemSumm.ContainerId_Transit_53
                    -- ����� �/�, ����������, ������� � ����
                  , zc_Enum_AnalyzerId_SaleSumm_40200()                                        AS AnalyzerId
                  , 0                                                                          AS ParentId
                  , -1 * (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS Amount
                  , FALSE                                                                      AS isActive
             FROM _tmpItemSumm
             WHERE (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) <> 0  -- !!!������� �� �����!!!
               AND _tmpItemSumm.isLossMaterials = FALSE -- !!!���� �� ��������!!!
            )
     -- ��������: AnalyzerId <> 0 ������, ContainerId_Analyzer <> 0 ����� �������� � ������ ����������, ����� "�����������" (�.�. AccountId <> 0, AnalyzerId <> 0, ContainerId_Analyzer = 0)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- ��� ������� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId
            , tmpMIContainer.AccountId                AS AccountId                -- ���� ���� ������
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!��������� ���� ������!!! (���� ���� ����� �������, ��� ����� ��� ������)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 AND _tmpItem.isLossMaterials = FALSE THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- ���� ��� �������, ����� � ���������� �� vbOperDate �� �������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- ���� ��� �������, ����� � ���������� �� vbOperDate ������� 2 ���� � + � -
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- ��������� "�����"
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount
            , vbOperDate -- �.�. �� "���� �����"
            , tmpMIContainer.isActive
       FROM tmpMIContainer
            INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = tmpMIContainer.MovementItemId
                               AND _tmpItem.ContainerId_Goods = tmpMIContainer.ContainerId_Goods
     UNION ALL
       -- ��� ��� �������� ��� ����� �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId

            , CASE WHEN tmpAccount_60000.AccountId > 0
                        THEN tmpMIContainer.ContainerId_Transit_51

                   -- ������� � ����
                   WHEN tmpMIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200()
                        THEN tmpMIContainer.ContainerId_Transit_02
                   -- ������ �� ���
                   WHEN tmpMIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500()
                        THEN tmpMIContainer.ContainerId_Transit_53

                   ELSE tmpMIContainer.ContainerId_Transit_01

              END AS ContainerId

            , CASE WHEN tmpAccount_60000.AccountId > 0 AND tmpOperDate.OperDate = vbOperDate
                        THEN zc_Enum_AnalyzerId_SummIn_110101()
                   WHEN tmpAccount_60000.AccountId > 0 AND tmpOperDate.OperDate = vbOperDatePartner
                        THEN zc_Enum_AnalyzerId_SummOut_110101()

                   WHEN tmpMIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- ������� � ����
                        THEN vbAccountId_GoodsTransit_02
                   WHEN tmpMIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- ������ �� ���
                        THEN vbAccountId_GoodsTransit_53

                   ELSE vbAccountId_GoodsTransit_01 -- ����� �� ��� � �������� ���-��

              END AS AccountId                                                    -- ���� ���� (�.�. � ������� ������������ "�������")

            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!��������� ���� ������!!! (���� ��� "�����������")
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- �.�. � ���������� ������� "��������" �� vbOperDatePartner
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- �.�. � ���������� ������� "��������" �� vbOperDatePartner + �� vbOperDate ������� 2 ���� � + � -
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItem.ContainerId_GoodsTransit_01    AS ContainerIntId_Analyzer  -- ��������� "�����"
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END AS Amount -- "�����������" � �������� ������
            , tmpOperDate.OperDate -- !!!��� �������� �� ������ ����!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN NOT isActive ELSE isActive END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN _tmpItem ON vbAccountId_GoodsTransit_01 <> 0
                               AND _tmpItem.isLossMaterials    = FALSE -- !!!���� �� ��������!!!
            INNER JOIN tmpMIContainer ON tmpMIContainer.MovementItemId    = _tmpItem.MovementItemId
                                     AND tmpMIContainer.ContainerId_Goods = _tmpItem.ContainerId_Goods
            LEFT JOIN tmpAccount_60000 ON tmpAccount_60000.AccountId = tmpMIContainer.AccountId
      ;


     -- 2.0. ������� ���������� ��� �������� - ������� !!!���� ������� �� ����������� -> �����������!!!
     UPDATE _tmpItemPartnerFrom SET ContainerId_ProfitLoss_10100 = _tmpItem_byDestination.ContainerId_ProfitLoss_10100 -- ���� - ������� (���� - ����� ����������)
                                  , ContainerId_ProfitLoss_10400 = _tmpItem_byDestination.ContainerId_ProfitLoss_10400 -- ���� - ������� (���� - ������������� ����������)
     FROM _tmpItem
          JOIN
          (SELECT -- ��� ����� ����������
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_PriceList
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10100
                  -- ��� ����� ������������� ����������
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10400
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_From
           FROM (SELECT -- ���������� ProfitLossId_PriceList - ��� ����� ����� ����������
                        CASE WHEN _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_10102() -- ����� ���������� + ����
                             ELSE zc_Enum_ProfitLoss_10101() -- ����� ���������� + ���������
                        END AS ProfitLossId_PriceList

                        -- ���������� ProfitLossId_Partner - ��� ����� ������������� ����������
                      , CASE WHEN _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_10402() -- ������������� ���������� + ����
                             ELSE zc_Enum_ProfitLoss_10401() -- ������������� ���������� + ���������
                        END AS ProfitLossId_Partner

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_From
                 FROM (SELECT _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_From
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_From
                                   , CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                             FROM _tmpItemPartnerFrom
                                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.BusinessId_From
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_From
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BusinessId_From = _tmpItem.BusinessId_From
     WHERE _tmpItemPartnerFrom.MovementItemId = _tmpItem.MovementItemId;


     -- 2.1. ������� ���������� ��� �������� - �������
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_40208 = _tmpItem_byDestination.ContainerId_ProfitLoss_40208 -- ���� - ������� (���� - ������� � ���� : �/�2 - �/�3)
                           , ContainerId_ProfitLoss_10500 = _tmpItem_byDestination.ContainerId_ProfitLoss_10500 -- ���� - ������� (���� - ������ � ���� : �/�1 - �/�2)
                           , ContainerId_ProfitLoss_10400 = _tmpItem_byDestination.ContainerId_ProfitLoss_10400 -- ���� - ������� (���� - ������������� ���������� : �/�3)
                           , ContainerId_ProfitLoss_20200 = _tmpItem_byDestination.ContainerId_ProfitLoss_20200 -- ���� - ������� (���� - �������������������� ������� + ���������� �������)
     FROM _tmpItem
          JOIN
          (SELECT -- ��� ����� ������� � ���� : �/�2 - �/�3
                  CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = TRUE -- !!!���� ��������!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                  , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_CountChange
                                                  , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                  , inObjectId_2        := vbBranchId_From
                                                   )
                  END AS ContainerId_ProfitLoss_40208
                  -- ��� ����� ������ � ���� : �/�1 - �/�2
                , CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = TRUE -- !!!���� ��������!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                  , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_ChangePercent
                                                  , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                  , inObjectId_2        := vbBranchId_From
                                                   )
                  END AS ContainerId_ProfitLoss_10500
                  -- ��� ����� ������������� ���������� : �/�3
                , CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = TRUE -- !!!���� ��������!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                  , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                                  , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                  , inObjectId_2        := vbBranchId_From
                                                   )
                  END AS ContainerId_ProfitLoss_10400
                  -- ��� ����� ������������� ��������
                , CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = FALSE -- !!!���� �� ��������!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                  , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Loss
                                                  , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                  , inObjectId_2        := vbBranchId_From
                                                   )
                  END AS ContainerId_ProfitLoss_20200
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_From
           FROM (SELECT -- ���������� ProfitLossId_CountChange - ��� ����� ������� � ���� : �/�2 - �/�3
                        CASE WHEN _tmpItem_group.isLossMaterials = TRUE -- !!!���� ��������!!!
                                  THEN 0

                             WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_40208() -- ���������� �������� + ������� � ����
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                  THEN zc_Enum_ProfitLoss_40208() -- ���������� �������� + ������� � ����

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_CountChange

                        -- ���������� ProfitLossId_ChangePercent - ��� ����� ������ � ���� : �/�1 - �/�2
                      , CASE WHEN _tmpItem_group.isLossMaterials = TRUE -- !!!���� ��������!!!
                                  THEN 0

                             WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_10502() -- ������ �� ��� + ����
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                  THEN zc_Enum_ProfitLoss_10501() -- ������ �� ��� + ���������

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_ChangePercent

                        -- ���������� ProfitLossId_Partner - ��� ����� ������������� ���������� : �/�3
                      , CASE WHEN _tmpItem_group.isLossMaterials = TRUE -- !!!���� ��������!!!
                                  THEN 0

                             WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_10402() -- ������������� ���������� + ����
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                  THEN zc_Enum_ProfitLoss_10401() -- ������������� ���������� + ���������

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner

                        -- ���������� ProfitLossId_Loss - ��� ����� ������������� ��������
                      , CASE WHEN _tmpItem_group.isLossMaterials = FALSE -- !!!���� �� ��������!!!
                                  THEN 0
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Loss

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_From
                      , _tmpItem_group.isLossMaterials
                 FROM (SELECT CASE WHEN _tmpItem.isLossMaterials = TRUE -- !!!���� ��������!!!
                                        THEN zc_Enum_ProfitLossGroup_20000() -- �������������������� �������
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ���������
                                        THEN zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- �������������� �������
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                        THEN zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- �������������� �������
                              END AS ProfitLossGroupId

                            , CASE WHEN _tmpItem.isLossMaterials = TRUE -- !!!���� ��������!!!
                                        THEN zc_Enum_ProfitLossDirection_20200() -- �������������������� ������� + ���������� �������
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ���������
                                        THEN zc_Enum_ProfitLossDirection_10400() -- ��������� �������� ������������ + ������������� ����������
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70100() -- �������������� ������� + ���������� ����� ���������
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                        THEN zc_Enum_ProfitLossDirection_10400() -- ��������� �������� ������������ + ������������� ����������
                                   WHEN vbMemberId_To <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- !!!������!!! �������������� ������� + ���.���� (���������� ������)
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- �������������� ������� + ������
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_From
                            , _tmpItem.ProfitLossId_Corporate
                            , _tmpItem.isLossMaterials
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_From
                                   , _tmpItem.GoodsKindId
                                   , _tmpItem.isLossMaterials
                                   , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                                          WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- ����
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70101() -- ����
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70102() -- �����
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70103() -- �������
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70104() -- �������-���������
                                     END AS ProfitLossId_Corporate
                             FROM _tmpItemSumm
                                  JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                               AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.BusinessId_From
                                    , _tmpItem.GoodsKindId
                                    , _tmpItem.isLossMaterials
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_From
                              , _tmpItem.ProfitLossId_Corporate
                              , _tmpItem.isLossMaterials
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BusinessId_From        = _tmpItem.BusinessId_From
     WHERE _tmpItemSumm.MovementItemId    = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_Goods = _tmpItem.ContainerId_Goods
     ;

     -- 2.2. ����������� �������� - ������� (�������������) + !!!��� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                AS AccountId                -- ������� �������� �������
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- ���������, �� �������� = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer     -- � ���� �� �����
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 AND _tmpItem_group.isLossMaterials = FALSE THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- �.�. �� "���� ����������"
            , FALSE                                   AS isActive
       FROM (-- �������� �� ������� � ���� : �/�2 - �/�3
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_40200()       AS AnalyzerId -- ����� �/�, ����������, ������� � ����
                  , SUM (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!���� �� ��������!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_40208, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials
            UNION ALL
             -- �������� �� ������� � ���� : �/�1 - �/�2
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10500 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10500()       AS AnalyzerId -- ����� �/�, ����������, ������ �� ���
                  , SUM (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!���� �� ��������!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10500, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials
            UNION ALL
             -- �������� �� ������������� ���������� : �/�3
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10400()       AS AnalyzerId --  ����� �/�, ����������, � ����������
                  , SUM (_tmpItemSumm.OperSumm_Partner)       AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!���� �� ��������!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10400, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials

            UNION ALL
             -- �������� �� ��������
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_20200 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_LossSumm_20200()       AS AnalyzerId --  ����� �/�, �������� ��� ����������/����������� �� ����
                  , SUM (_tmpItemSumm.OperSumm)               AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
             WHERE _tmpItem.isLossMaterials = TRUE -- !!!���� ��������!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_20200, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials

            -- !!!���� ������� �� ����������� -> �����������!!!
            UNION ALL
             -- �������� �� ������������� ���������� : �� ����
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10400()       AS AnalyzerId --  ����� �/�, ����������, � ����������
                  , -1 * SUM (_tmpItemSumm.OperSumm_Partner)  AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemPartnerFrom AS _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10400, _tmpItemSumm.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials
            UNION ALL
             -- �������� �� ������������� ���������� : ����
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10400()       AS AnalyzerId --  ����� �/�, ����������, � ����������
                  , 1 * SUM (_tmpItemSumm.OperSumm_Partner)   AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemPartnerFrom AS _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10400, _tmpItemSumm.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!������� �� �����!!!
       ;


     -- 3.2.2. ������������ ContainerId_Currency ��� �������� �� ���� ���������� ��� ���.���� (����������� ����)
     UPDATE _tmpItem SET ContainerId_Currency = _tmpItem_byInfoMoney.ContainerId_Currency
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                        , inParentId          := _tmpItem_group.ContainerId_Partner
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
                                        , inObjectId_5        := vbPartionMovementId
                                        , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                        , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbPartnerId_To ELSE NULL END
                                        , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                        , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbBranchId_From ELSE NULL END
                                        , inDescId_8          := zc_ContainerLinkObject_Currency()
                                        , inObjectId_8        := vbCurrencyPartnerId
                                         ) AS ContainerId_Currency
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.ContainerId_Partner
                      , _tmpItem.AccountId_Partner
                      , _tmpItem.InfoMoneyId
                      , _tmpItem.BusinessId_From
                      , CASE WHEN vbInfoMoneyId_To <> 0
                                  THEN vbInfoMoneyId_To -- ��: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                             WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20901 () -- ����
                                  THEN zc_Enum_InfoMoney_30101 () -- ������� ���������
                             ELSE _tmpItem.InfoMoneyId -- ����� ����� �� ������
                        END AS InfoMoneyId_calc
                 FROM _tmpItem
                 WHERE vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                   AND vbMemberId_To = 0
                   AND vbIsCorporate_To = FALSE
                 GROUP BY _tmpItem.ContainerId_Partner
                        , _tmpItem.AccountId_Partner
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_group
          ) AS _tmpItem_byInfoMoney
     WHERE _tmpItem.InfoMoneyId = _tmpItem_byInfoMoney.InfoMoneyId;

     -- 3.3. ����������� �������� - ���� ���������� ��� ���.���� (����������� ����) + !!!�������� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- ��� ������� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_group.MovementItemId
            , _tmpItem_group.ContainerId_Partner
            , CASE WHEN tmpTransit.AccountId > 0 THEN tmpTransit.AccountId ELSE _tmpItem_group.AccountId_Partner END AS AccountId -- ���� ���� ������, !!�� ��� ������ zc_Enum_AnalyzerId_Summ...!!
            , _tmpItem_group.AnalyzerId          AS AnalyzerId             -- ���������
            , _tmpItem_group.GoodsId             AS ObjectId_Analyzer      -- �����
            , vbWhereObjectId_Analyzer           AS WhereObjectId_Analyzer -- ������������ ���...
            , _tmpItem_group.ContainerId_Partner AS ContainerId_Analyzer   -- ��� �� �����
            , _tmpItem_group.GoodsKindId         AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer             AS ObjectExtId_Analyzer   -- ���������� / ���.����
            , _tmpItem_group.ContainerId_Goods   AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                  AS ParentId
            , _tmpItem_group.OperSumm * CASE WHEN tmpTransit.AccountId = zc_Enum_AnalyzerId_SummOut_110101() THEN -1 ELSE 1 END AS Amount
            , tmpTransit.OperDate                AS OperDate               -- �.�. �� "������������" ����
            , tmpTransit.isActive                AS isActive               -- TRUE ����� ������, ��������� ������� �� ����
       FROM (-- ����� ����������
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_SaleSumm_10100() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_PriceList) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItem
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!���� �� ��������!!!
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId --, _tmpItem.isLossMaterials
             -- !!!������ ������������, �.�. �� ���� ��������� �������� ������!!!
             -- HAVING SUM (_tmpItem.OperSumm_PriceList) <> 0

           UNION ALL
             -- ������� � �������� ������
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_SaleSumm_10200() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_Partner + _tmpItem.OperSumm_Partner_ChangePromo - _tmpItem.OperSumm_PriceList) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItem
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!���� �� ��������!!!
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId --, _tmpItem.isLossMaterials
             HAVING SUM (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_PriceList) <> 0 -- !!!����� ����������!!!

           UNION ALL
             -- ������ �����
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_SaleSumm_10250() AS AnalyzerId
                  , SUM (-1 * _tmpItem.OperSumm_Partner_ChangePromo) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItem
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!���� �� ��������!!!
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId --, _tmpItem.isLossMaterials
             HAVING SUM (_tmpItem.OperSumm_Partner_ChangePromo) <> 0 -- !!!����� ����������!!!

           UNION ALL
             -- ������ ��������������
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_SaleSumm_10300() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItem
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!���� �� ��������!!!
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId --, _tmpItem.isLossMaterials
             HAVING SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) <> 0 -- !!!����� ����������!!!

           -- !!!���� ������� �� ����������� -> �����������!!!
           UNION ALL
             SELECT _tmpItemPartnerFrom.MovementItemId, _tmpItemPartnerFrom.ContainerId_Partner, _tmpItemPartnerFrom.AccountId_Partner, _tmpItemPartnerFrom.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, zc_Enum_AnalyzerId_SaleSumm_10100() AS AnalyzerId
                  , -1 * SUM (_tmpItemPartnerFrom.OperSumm_Partner) AS OperSumm
                  , FALSE AS isActive
             FROM _tmpItemPartnerFrom
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
             GROUP BY _tmpItemPartnerFrom.MovementItemId, _tmpItemPartnerFrom.ContainerId_Partner, _tmpItemPartnerFrom.AccountId_Partner, _tmpItemPartnerFrom.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
             -- !!!������ ������������, �.�. �� ���� ��������� �������� ������!!!
             -- HAVING SUM (_tmpItemPartnerFrom.OperSumm_Partner) <> 0

            ) AS _tmpItem_group
            LEFT JOIN (SELECT -1                                  AS AccountId, TRUE  AS isActive, CASE WHEN vbAccountId_GoodsTransit_01 <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AccountId, TRUE  AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AccountId, TRUE  AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AccountId, FALSE AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AccountId, FALSE AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
                      ) AS tmpTransit ON tmpTransit.AccountId <> 0
     UNION ALL
       -- ��� !!!����!!! �������� ��� "�������������" ��������� �����
       SELECT 0, zc_MIContainer_SummCurrency() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_group.ContainerId_Currency
            , _tmpItem_group.AccountId_Partner    AS AccountId
            , 0                                   AS AnalyzerId
            , 0                                   AS ObjectId_Analyzer
            , 0                                   AS WhereObjectId_Analyzer
            , _tmpItem_group.ContainerId_Currency AS ContainerId_Analyzer
            , 0                                   AS ObjectIntId_Analyzer     -- !!!���!!!
            , 0                                   AS ObjectExtId_Analyzer     -- !!!���!!!
            , 0                                   AS ContainerIntId_Analyzer  -- !!!���!!!
            , 0 AS ParentId
            , _tmpItem_group.OperSumm
            , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- �.�. �� "������������" ����
            , TRUE AS isActive
       FROM (SELECT _tmpItem.ContainerId_Currency, _tmpItem.AccountId_Partner, SUM (_tmpItem.OperSumm_Currency) AS OperSumm FROM _tmpItem WHERE _tmpItem.ContainerId_Currency <> 0 GROUP BY _tmpItem.ContainerId_Currency, _tmpItem.AccountId_Partner
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!����������� - ������ �������� �� �����������!!!
     ;


     -- 4.1.1. ������� ���������� ��� �������� - ������� (����� ���������� � ������ �� ������ � ������ �������������� � �������� �������)
     UPDATE _tmpItem SET ContainerId_ProfitLoss_10100 = _tmpItem_byDestination.ContainerId_ProfitLoss_10100
                       , ContainerId_ProfitLoss_10200 = _tmpItem_byDestination.ContainerId_ProfitLoss_10200
                       , ContainerId_ProfitLoss_10250 = _tmpItem_byDestination.ContainerId_ProfitLoss_10250
                       , ContainerId_ProfitLoss_10300 = _tmpItem_byDestination.ContainerId_ProfitLoss_10300
                       , ContainerId_ProfitLoss_80103 = _tmpItem_byDestination.ContainerId_ProfitLoss_80103
     FROM (SELECT -- ��� ����� ����������
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_PriceList
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10100
                  -- ��� ������� � �������� ������
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10200
                  -- ��� ������ �����
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Promo
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10250
                  -- ��� ������ ��������������
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_ChangePercent
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10300
                  -- ��� �������� �������
                , CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                       , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                       , inObjectId_1        := zc_Enum_ProfitLoss_80103() -- ������� � ������� + ���������� ������������ + �������� �������
                                                       , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                       , inObjectId_2        := vbBranchId_From
                                                        )
                       ELSE 0
                  END AS ContainerId_ProfitLoss_80103
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_From
           FROM (SELECT -- ���������� ProfitLossId_PriceList - ��� ����� ����������
                        CASE WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_10102() -- ����� ���������� + ����
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                  THEN zc_Enum_ProfitLoss_10101() -- ����� ���������� + ���������

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_PriceList

                        -- ���������� ProfitLossId_Partner - ��� ������� � �������� ������
                      , CASE WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_10202() -- ������� � �������� ������ + ����
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                  THEN zc_Enum_ProfitLoss_10201() -- ������� � �������� ������ + ���������

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner

                        -- ���������� ProfitLossId_Promo - ��� ������ �����
                      , CASE WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_10252() -- ������ ����� + ����
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                  THEN zc_Enum_ProfitLoss_10251() -- ������ ����� + ���������

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Promo


                        -- ���������� ProfitLossId_ChangePercent - ��� ������ ��������������
                      , CASE WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  THEN zc_Enum_ProfitLoss_10302() -- ������ �������������� + ����
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() --��������� �������� ������������
                                  THEN zc_Enum_ProfitLoss_10301() -- ������ �������������� + ���������

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_ChangePercent

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_From
                 FROM (SELECT -- ����� !!!����!!! ��� � ��� �/� (�� �� �/� ������ ����� �.�. ����� ���� ��� �/�=0)
                              CASE WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ���������
                                        THEN zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- �������������� �������
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                        THEN zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- �������������� �������
                              END AS ProfitLossGroupId

                              -- ����� !!!������!!! (� THEN) ��� ��� �/�
                            , CASE WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ���������
                                        THEN zc_Enum_ProfitLossDirection_10100() -- ��������� �������� ������������ + ����� ����������
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70100() -- �������������� ������� + ���������� ����� ���������
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                        THEN zc_Enum_ProfitLossDirection_10100() -- ��������� �������� ������������ + ����� ����������
                                   WHEN vbMemberId_To <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- !!!������!!! �������������� ������� + ���.���� (���������� ������)
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- �������������� ������� + ������
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_From
                            , _tmpItem.ProfitLossId_Corporate
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_From
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                                          WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- ����
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70101() -- ����
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70102() -- �����
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70103() -- �������
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70104() -- �������-���������
                                     END AS ProfitLossId_Corporate
                             FROM _tmpItem
                             -- !!!������ ������������, �.�. �������� ��� ������ ����� ������ ������!!!
                             -- WHERE _tmpItem.OperSumm_PriceList <> 0 OR _tmpItem.OperSumm_Partner <> 0 OR _tmpItem.OperSumm_Partner_ChangePercent <> 0
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.BusinessId_From
                                    , _tmpItem.GoodsKindId
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_From
                              , _tmpItem.ProfitLossId_Corporate
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination
     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byDestination.InfoMoneyDestinationId
       AND _tmpItem.BusinessId_From = _tmpItem_byDestination.BusinessId_From;

     -- 4.1.2. ����������� �������� - ������� (����� ���������� � ������ �� ������ � ������ ��������������) + !!!��� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId                -- ������� �������� �������
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- ���������, �� �������� = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer     -- � ���� �� �����
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- �.�. �� "������������" ����
            , FALSE                                   AS isActive
       FROM  -- ����� ����������
            (SELECT _tmpItem.ContainerId_ProfitLoss_10100  AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods             AS ContainerId_Goods
                  , _tmpItem.GoodsId                       AS GoodsId
                  , _tmpItem.GoodsKindId                   AS GoodsKindId
                  , 0                                      AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10100()    AS AnalyzerId -- �����, ����������, � ����������
                  , -1 * SUM (_tmpItem.OperSumm_PriceList) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10100, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            UNION ALL
             -- ������� � �������� ������
             SELECT _tmpItem.ContainerId_ProfitLoss_10200  AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods             AS ContainerId_Goods
                  , _tmpItem.GoodsId                       AS GoodsId
                  , _tmpItem.GoodsKindId                   AS GoodsKindId
                  , 0                                      AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10200()   AS AnalyzerId --  �����, ����������, ������� � �������� ������
                  , 1 * SUM (_tmpItem.OperSumm_PriceList - _tmpItem.OperSumm_Partner - _tmpItem.OperSumm_Partner_ChangePromo) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10200, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId

            UNION ALL
             -- ������ �����
             SELECT _tmpItem.ContainerId_ProfitLoss_10250  AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods             AS ContainerId_Goods
                  , _tmpItem.GoodsId                       AS GoodsId
                  , _tmpItem.GoodsKindId                   AS GoodsKindId
                  , 0                                      AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10250()   AS AnalyzerId --  �����, ����������, ������ �����
                  , 1 * SUM (_tmpItem.OperSumm_Partner_ChangePromo) AS OperSumm
             FROM _tmpItem
             WHERE OperSumm_Partner_ChangePromo <> 0
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10250, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId

            UNION ALL
             -- ������ ��������������
             SELECT _tmpItem.ContainerId_ProfitLoss_10300  AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods             AS ContainerId_Goods
                  , _tmpItem.GoodsId                       AS GoodsId
                  , _tmpItem.GoodsKindId                   AS GoodsKindId
                  , 0                                      AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10300()   AS AnalyzerId -- �����, ����������, ������ ��������������
                  , 1 * SUM (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_Partner_ChangePercent) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10300, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            -- !!!���� ������� �� ����������� -> �����������!!!
            UNION ALL
             -- ����� ���������� �� ����
             SELECT _tmpItemPartnerFrom.ContainerId_ProfitLoss_10100 AS ContainerId_ProfitLoss
                  , _tmpItemPartnerFrom.ContainerId_Goods  AS ContainerId_Goods
                  , _tmpItem.GoodsId                       AS GoodsId
                  , _tmpItem.GoodsKindId                   AS GoodsKindId
                  , 0                                      AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10100()   AS AnalyzerId -- �����, ����������, � ����������
                  , 1 * SUM (_tmpItemPartnerFrom.OperSumm_Partner) AS OperSumm
             FROM _tmpItemPartnerFrom
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
             GROUP BY _tmpItemPartnerFrom.ContainerId_ProfitLoss_10100, _tmpItemPartnerFrom.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!����������� - ������ �������� �� �����������!!!
      ;


     /*-- �����, �.�. ��-�� ������� ������ � ����
     DELETE FROM MovementItemLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementItemId IN (SELECT MovementItemId FROM _tmpItem);
     DELETE FROM MovementLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementId = inMovementId;*/
     -- !!!6.0.1. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), _tmpItem.MovementItemId, vbBranchId_From)
     FROM (SELECT DISTINCT _tmpItem.MovementItemId FROM _tmpItem) AS _tmpItem;
     -- !!!6.0.2. ����������� �������� ����� � <������> � ��������� �� ������ ��� ��������!!!
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inMovementId, vbBranchId_From);
     -- !!!6.0.3. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Business(), _tmpItem.MovementItemId, _tmpItem.BusinessId_From)
     FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.BusinessId_From FROM _tmpItem) AS _tmpItem;
     -- !!!6.0.4. ����������� �������� <zc_MIFloat_Summ - �����> + <zc_MIFloat_SummFrom - ����� (����)> + <zc_MIFloat_SummPriceList - ����� �� ������>!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(),          _tmpItem.MovementItemId, _tmpItem.OperSumm_Partner_ChangePercent)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummFrom(),      _tmpItem.MovementItemId, _tmpItem.OperSumm_PartnerVirt_ChangePercent)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPriceList(), _tmpItem.MovementItemId, _tmpItem.OperSumm_PriceList)
     FROM (SELECT _tmpItem.MovementItemId
                , SUM (_tmpItem.OperSumm_Partner_ChangePercent)     AS OperSumm_Partner_ChangePercent
                , SUM (_tmpItem.OperSumm_PartnerVirt_ChangePercent) AS OperSumm_PartnerVirt_ChangePercent
                , SUM (_tmpItem.OperSumm_PriceList)                 AS OperSumm_PriceList
           FROM _tmpItem
           GROUP BY _tmpItem.MovementItemId
          ) AS _tmpItem;


     -- 6.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();


     -- 6.2.1. ���� ������ �� ��������� (������ ���� ����.���� ������)
     IF vbPartionMovementId > 0 OR EXISTS (SELECT MovementId FROM MovementDate WHERE MovementId = inMovementId AND DescId = zc_MovementDate_Payment())
     THEN
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Payment(), inMovementId, vbPaymentDate);
     END IF;

     -- 6.2.2. � MovementLinkMovement ���� ������� ����� � ��� 1
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Promo(), inMovementId, CASE WHEN tmp.MovementId_min = tmp.MovementId_max THEN tmp.MovementId_min ELSE NULL END :: Integer)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo(), inMovementId, CASE WHEN tmp.MovementId_min > 0 AND tmp.MovementId_max > 0 THEN TRUE ELSE FALSE END)
     FROM (SELECT 1 AS x) AS x1
           LEFT JOIN
          (SELECT MIN (MIFloat_PromoMovement.ValueData) AS MovementId_min,  MAX (MIFloat_PromoMovement.ValueData) AS MovementId_max
           FROM (SELECT DISTINCT _tmpItem.MovementItemId FROM _tmpItem) AS _tmpItem
                INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                             ON MIFloat_PromoMovement.MovementItemId = _tmpItem.MovementItemId
                                            AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()
                                            AND MIFloat_PromoMovement.ValueData      <> 0
          ) AS tmp ON 1 = 1;


     -- 6.2.3. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := vbMovementDescId
                                , inUserId     := inUserId
                                 );

     -- 6.3. ����� - ������������ ���������
     IF inUserId <> zc_Enum_Process_Auto_PrimeCost()
        AND inUserId <> 343013 -- �������� �.�.
        -- AND inUserId <> zfCalc_UserMain()
        -- AND inUserId <> 5
        AND vbPaidKindId = zc_Enum_PaidKind_FirstForm()
        AND vbCurrencyDocumentId = zc_Enum_Currency_Basis()
        AND vbCurrencyPartnerId = zc_Enum_Currency_Basis()
        AND vbMovementDescId = zc_Movement_Sale()
        AND EXISTS (SELECT MovementLinkMovement_Master.MovementId
                    FROM MovementLinkMovement AS MovementLinkMovement_Master
                         INNER JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                                       AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
                         INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Master
                                                       ON MovementLinkObject_DocumentTaxKind_Master.MovementId = Movement_DocumentMaster.Id
                                                      AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                      AND MovementLinkObject_DocumentTaxKind_Master.ObjectId = zc_Enum_DocumentTaxKind_Tax()
                    WHERE MovementLinkMovement_Master.MovementId = inMovementId
                      AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                   )
     THEN
          -- ������ ������ �������
          if inUserId <> 5
          then
          --
          PERFORM lpInsertUpdate_Movement_Tax_From_Kind (inMovementId            := inMovementId
                                                       , inDocumentTaxKindId     := zc_Enum_DocumentTaxKind_Tax()
                                                       , inDocumentTaxKindId_inf := NULL
                                                       , inStartDateTax          := NULL
                                                       , inUserId                := inUserId
                                                        );
           ELSE RAISE EXCEPTION '������ ������ �������';
           end if;
     END IF;

     -- 6.4. ����� - � ��������� ��������������� ������� "��������"
     vbMovementId_Tax:= (SELECT MovementLinkMovement_Master.MovementChildId
                         FROM MovementLinkMovement AS MovementLinkMovement_Master
                              INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Master
                                                            ON MovementLinkObject_DocumentTaxKind_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                                           AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                           AND MovementLinkObject_DocumentTaxKind_Master.ObjectId = zc_Enum_DocumentTaxKind_Tax()
                         WHERE MovementLinkMovement_Master.MovementId = inMovementId
                           AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                        );
     IF vbMovementId_Tax <> 0
     THEN -- ��������� �������� <��������>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), vbMovementId_Tax, (SELECT ValueData FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Checked()));
     END IF;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.12.19         * add GoodsKindId � �����
 16.01.15                                        * add !!!�����, ����������� � �������� �����!!!
 18.12.14                                        * all
 19.10.14                                        * add inIsLastComplete = FALSE, ����� ������������ ���������
 07.09.14                                        * add zc_ContainerLinkObject_Branch to vbPartnerId_To
 05.09.14                                        * add zc_ContainerLinkObject_Branch to ���.���� (����������� ����)
 02.09.14                                        * add vbIsHistoryCost
 23.08.14                                        * add vbPartnerId_To
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 12.08.14                                        * add !!!����������� ����������!!!
 22.07.14                                        * add ...Price
 25.05.14                                        * add lpComplete_Movement
 22.05.14                                        * modify lfSelect_ObjectHistory_PriceListItem ... inOperDate:= vbOperDatePartner
 16.05.14                                        * add ����� - ������������ ���������
 10.05.14                                        * add lpInsert_MovementProtocol
 04.05.14                                        * rem zc_Enum_AccountDirection_30400
 30.04.14                                        * set lp
 26.04.14                                        * !!!RESTORE!!!
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 14.02.14                                        *
*/

/*
select Movement.*
--     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), MovementItem.Id, MovementFloat_ChangePercent.ValueData)
     FROM Movement
         inner JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                                 AND MovementFloat_ChangePercent.ValueData <> 0
          inner JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Master()

          LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                      ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                     AND MIFloat_PromoMovement.DescId = zc_MIFloat_ChangePercent()

where Movement.DescId = zc_Movement_Sale()
  and Movement.OperDate >= '01.01.2016'
and coalesce (MIFloat_PromoMovement.ValueData, 0) <> MovementFloat_ChangePercent.ValueData

-- check - zc_MIFloat_Summ - zc_MIFloat_SummFrom
select *
from MovementItem
left join MovementItemFloat  AS M1 on M1.MovementItemId = MovementItem.Id and M1.DescId = zc_MIFloat_Summ()
left join MovementItemFloat  AS M2 on M2.MovementItemId = MovementItem.Id and M2.DescId = zc_MIFloat_SummFrom()
where MovementItem.MovementId = 4321872
   and MovementItem.DescId = 1
   and MovementItem.isErased = false
and coalesce (M1.ValueData, 0) <> coalesce (M2.ValueData, 0)

*/
-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM lpComplete_Movement_Sale22 (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
