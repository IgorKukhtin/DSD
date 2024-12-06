-- Function: lpComplete_Movement_ReturnIn (Integer, Integer, Boolean)

-- DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnIn (Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnIn (Integer, TDateTime, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnIn(
    IN inMovementId        Integer               , -- ключ Документа
    IN inStartDateSale     TDateTime             , --
   OUT outMessageText      Text                  ,
    IN inUserId            Integer               , -- Пользователь
    IN inIsLastComplete    Boolean  DEFAULT False  -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
)
RETURNS Text
AS
$BODY$
  DECLARE vbIsHistoryCost Boolean; -- нужны проводки с/с для этого пользователя

  DECLARE vbContainerId_Analyzer Integer;
  DECLARE vbContainerId_Analyzer_PartnerTo Integer;
  DECLARE vbWhereObjectId_Analyzer Integer;
  DECLARE vbObjectExtId_Analyzer Integer;
  DECLARE vbAccountId_GoodsTransit Integer;

  DECLARE vbMovementDescId Integer;
  DECLARE vbMovementId_parent Integer;

  DECLARE vbOperSumm_PriceList_byItem TFloat;
  DECLARE vbOperSumm_PriceList TFloat;
  DECLARE vbOperSumm_PriceList_real_byItem TFloat;
  DECLARE vbOperSumm_PriceList_real TFloat;
  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent_byItem TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent TFloat;
  DECLARE vbOperSumm_Currency_byItem TFloat;
  DECLARE vbOperSumm_Currency TFloat;

  DECLARE vbPriceWithVAT_PriceList Boolean;
  DECLARE vbVATPercent_PriceList TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbIsChangePrice Boolean;
  DECLARE vbIsDiscountPrice Boolean;

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
  DECLARE vbUnitId_HistoryCost Integer;

  DECLARE vbJuridicalId_To Integer;
  DECLARE vbPartnerId_To Integer;
  DECLARE vbPaidKindId_To Integer;
  DECLARE vbContractId_To Integer;
  DECLARE vbInfoMoneyDestinationId_To Integer;
  DECLARE vbInfoMoneyId_To Integer;

  DECLARE vbPaidKindId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbJuridicalId_Basis_To Integer;
  DECLARE vbBusinessId_To Integer;

  DECLARE vbCurrencyDocumentId Integer;
  DECLARE vbCurrencyPartnerId Integer;
  DECLARE vbCurrencyValue TFloat;
  DECLARE vbParValue TFloat;
  DECLARE vbCurrencyPartnerValue TFloat;
  DECLARE vbParPartnerValue TFloat;

  DECLARE curContainer refcursor;
  DECLARE vbContainerId_Goods Integer;
  DECLARE vbContainerId_Summ_Alternative Integer;
  DECLARE vbContainerDescId Integer;
  DECLARE vbContainerObjectId Integer;

  DECLARE vbIsPartionDoc_Branch Boolean;

  DECLARE vbOperSumm_51201 TFloat;
  DECLARE vbContainerId_51201 Integer;

  DECLARE vbIsNotRealGoods Boolean;

BEGIN
     -- !!!временно!!!
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= inMovementId);


     -- ContainerId для распределения
     vbContainerId_51201:= (SELECT Container.Id -- CLO_InfoMoney.ObjectId
                            FROM ObjectFloat
                                 INNER JOIN ContainerLinkObject AS CLO_PartionMovement
                                                                ON CLO_PartionMovement.ObjectId = ObjectFloat.ObjectId
                                                               AND CLO_PartionMovement.DescId   = zc_ContainerLinkObject_PartionMovement()
                               --INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                               --                               ON CLO_InfoMoney.ContainerId = CLO_PartionMovement.ContainerId
                               --                              AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                 INNER JOIN Container ON Container.Id       = CLO_PartionMovement.ContainerId
                                                     AND Container.ObjectId = zc_Enum_Account_51201() -- Распределение маркетинг + Маркетинг в накладных + Маркетинг
                                                     AND Container.DescId   = zc_Container_Summ()
                            WHERE ObjectFloat.ValueData = inMovementId
                              AND ObjectFloat.DescId    = zc_ObjectFloat_PartionMovement_MovementId()
                              AND Container.Amount <> 0
                           );
     -- Сумма для распределения
     vbOperSumm_51201:= (SELECT Container.Amount FROM Container WHERE Container.Id = vbContainerId_51201);

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - альтернативные ContainerId
     DELETE FROM _tmpList_Alternative;
     -- !!!обязательно!!! очистили таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItemSumm;
     -- !!!обязательно!!! очистили таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Эти параметры нужны для
     SELECT lfObject_PriceList.PriceWithVAT, lfObject_PriceList.VATPercent
            INTO vbPriceWithVAT_PriceList, vbVATPercent_PriceList
     FROM lfGet_Object_PriceList (zc_PriceList_Basis()) AS lfObject_PriceList;


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту или Сотуднику и для формирования Аналитик в проводках
     SELECT CASE WHEN EXTRACT (MONTH FROM Movement.OperDate) < EXTRACT (MONTH FROM CURRENT_DATE)
                  AND EXTRACT (MONTH FROM CURRENT_DATE) = EXTRACT (MONTH FROM CURRENT_DATE - INTERVAL '7 DAY')
                      THEN TRUE
                 ELSE vbIsHistoryCost
            END AS isHistoryCost -- !!!еще раз расчет!!!
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN      MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE)            AS isDiscountPrice_juridical

          , Movement.DescId                                                      AS MovementDescId
          , COALESCE (Movement.ParentId, 0)                                      AS MovementId_parent
          , Movement.OperDate                                                    AS OperDate -- COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)
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
          , COALESCE (ObjectBoolean_isNotRealGoods.ValueData, FALSE) AS isNotRealGoods
          , 0 AS MemberId_From -- COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From

            -- УП Статью назначения берем: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
          , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_From -- COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0)) AS InfoMoneyId_From

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN Object_To.Id ELSE 0 END, 0) AS UnitId_To
          , 0 AS MemberId_To -- COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN Object_To.Id WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_To
          , COALESCE (CASE WHEN ObjectLink_Partner_Branch.ChildObjectId <> 0
                                THEN ObjectLink_Partner_Branch.ChildObjectId

                           WHEN Object_To.DescId = zc_Object_Unit()
                                THEN ObjectLink_UnitTo_Branch.ChildObjectId

                           WHEN Object_To.DescId = zc_Object_Partner()
                                THEN ObjectLink_PartnerTo_Branch.ChildObjectId

                           WHEN Object_To.DescId = zc_Object_Personal()
                                THEN ObjectLink_UnitPersonalTo_Branch.ChildObjectId
                           ELSE 0
                      END, 0) AS BranchId_To
          , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= '01.05.2015'
                      THEN COALESCE (ObjectBoolean_PartionDoc.ValueData, FALSE)
                 ELSE FALSE
            END AS isPartionDoc_Branch
          , COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_To -- Аналитики счетов - направления !!!нужны только для подразделения!!!
          , COALESCE (ObjectBoolean_PartionDate.ValueData, FALSE) AS isPartionDate_Unit
          , COALESCE (ObjectLink_UnitTo_HistoryCost.ChildObjectId, 0) AS UnitId_HistoryCost

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_PartnerTo_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN Object_To.Id ELSE 0 END, 0) AS PartnerId_To
          , COALESCE (MovementLinkObject_PaidKindTo.ObjectId, 0) AS PaidKindId_To
          , COALESCE (MovementLinkObject_ContractTo.ObjectId, 0) AS ContractId_To
            -- УП Статью назначения берем: ВСЕГДА по договору
          , COALESCE (ObjectLink_ContractTo_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_To

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Juridical.ChildObjectId WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_ContractTo_JuridicalBasis.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Business.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId_To

          , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
          , COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())  AS CurrencyPartnerId
          , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                               AS CurrencyValue
          , COALESCE (MovementFloat_ParValue.ValueData, 0)                                    AS ParValue
          , COALESCE (MovementFloat_CurrencyPartnerValue.ValueData, 0)                        AS CurrencyPartnerValue
          , COALESCE (MovementFloat_ParPartnerValue.ValueData, 0)                             AS ParPartnerValue

            INTO vbIsHistoryCost, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbIsDiscountPrice
               , vbMovementDescId, vbMovementId_parent, vbOperDate, vbOperDatePartner
               , vbJuridicalId_From, vbIsCorporate_From, vbInfoMoneyId_CorporateFrom, vbPartnerId_From, vbIsNotRealGoods, vbMemberId_From, vbInfoMoneyId_From
               , vbUnitId_To, vbMemberId_To, vbBranchId_To, vbIsPartionDoc_Branch, vbAccountDirectionId_To, vbIsPartionDate_Unit, vbUnitId_HistoryCost
               , vbJuridicalId_To, vbPartnerId_To, vbPaidKindId_To, vbContractId_To, vbInfoMoneyId_To
               , vbPaidKindId, vbContractId
               , vbJuridicalId_Basis_To, vbBusinessId_To
               , vbCurrencyDocumentId, vbCurrencyPartnerId, vbCurrencyValue, vbParValue, vbCurrencyPartnerValue, vbParPartnerValue
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
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDoc
                                  ON ObjectBoolean_PartionDoc.ObjectId = ObjectLink_UnitTo_Branch.ChildObjectId
                                 AND ObjectBoolean_PartionDoc.DescId = zc_ObjectBoolean_Branch_PartionDoc()
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
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_HistoryCost
                               ON ObjectLink_UnitTo_HistoryCost.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_HistoryCost.DescId = zc_ObjectLink_Unit_HistoryCost()
                            --AND 1=0
                            --AND Movement.OperDate >= '01.01.2022'
                            --AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= '01.01.2022'

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

          LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Juridical
                               ON ObjectLink_PartnerTo_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_PartnerTo_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              AND Object_To.DescId = zc_Object_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Branch
                               ON ObjectLink_PartnerTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_PartnerTo_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!
                              AND Object_To.DescId = zc_Object_Partner()
                              AND 1 = 0 -- вроде это как наш филиал

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
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotRealGoods
                                  ON ObjectBoolean_isNotRealGoods.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isNotRealGoods.DescId   = zc_ObjectBoolean_Juridical_isNotRealGoods()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Branch
                               ON ObjectLink_Partner_Branch.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Partner_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!
                              AND Object_From.DescId = zc_Object_Partner()
                              AND 1 = 0 -- вроде это как наш филиал
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                               ON ObjectLink_Juridical_InfoMoney.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Constant_InfoMoney_isCorporate_View ON Constant_InfoMoney_isCorporate_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                  ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()

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

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

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

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_ReturnIn()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     -- проверка
     IF (vbOperDate <> vbOperDatePartner) AND (vbPartnerId_To <> 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <Дата(склад)> должно соответствовать значению <Дата документа у покупателя>.';
     END IF;

     -- если схема Павильоны
     IF EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId_From AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_Partner_Unit())
        -- AND inUserId = 5
     THEN
         -- Пересчитали
         PERFORM lpUpdate_MovementItem_Sale_PriceIn (inMovementId:= inMovementId, inUserId:= inUserId);

     END IF;


     -- определяется Управленческие назначения, параметр нужен для для формирования Аналитик в проводках (для Покупателя)
     SELECT View_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_From FROM lfGet_Object_InfoMoney (vbInfoMoneyId_From) AS View_InfoMoney;
     SELECT View_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_To FROM lfGet_Object_InfoMoney (vbInfoMoneyId_To) AS View_InfoMoney;


     -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = zc_Enum_Role_Admin())
        OR vbOperDate < DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '2 DAY')
     THEN IF inIsLastComplete = FALSE
     -- !!! нужны еще для Запорожья, понятно что временно!!!
     -- !!! OR 301310 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
     -- !!! нужны еще для Одесса, понятно что временно!!!
     -- !!! OR 8374 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
          THEN vbIsHistoryCost:= TRUE;
          ELSE vbIsHistoryCost:= FALSE;
          END IF;
          vbIsHistoryCost:= TRUE;
     ELSE
         -- !!! для остальных тоже нужны проводки с/с!!!
         IF 0 < (SELECT 1 FROM Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide WHERE View_RoleAccessKeyGuide.UserId = inUserId AND View_RoleAccessKeyGuide.BranchId <> 0 GROUP BY View_RoleAccessKeyGuide.BranchId LIMIT 1)
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382)) -- Кладовщик Днепр
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (97837)) -- Бухгалтер ДНЕПР
         THEN vbIsHistoryCost:= FALSE;
         ELSE vbIsHistoryCost:= TRUE;
         END IF;
     END IF;


     -- !!!Если нет филиала для "основной деятельности", тогда это "главный филиал"
     IF COALESCE (vbBranchId_To, 0) = 0
        /*vbInfoMoneyDestinationId_From IN (zc_Enum_InfoMoneyDestination_30100() -- Продукция
                                        , zc_Enum_InfoMoneyDestination_30200() -- Мясное сырье
                                         )
        AND vbBranchId_To = 0*/
     THEN
         vbBranchId_To:= zc_Branch_Basis();
     END IF;


     IF vbOperDatePartner < '01.08.2016' OR vbPaidKindId = zc_Enum_PaidKind_SecondForm()
        OR NOT EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE)
     THEN
         -- !!!пересчитали!!!
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), MovementItem.Id
                                                 , CASE WHEN vbOperDatePartner < '01.08.2016'
                                                             THEN vbExtraChargesPercent - vbDiscountPercent
                                                        WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbOperDate < zc_isReturnInNAL_bySale()
                                                             THEN vbExtraChargesPercent - vbDiscountPercent
                                                        WHEN 1=1 AND MIFloat_PromoMovement.ValueData > 0
                                                             THEN COALESCE (MIFloat_ChangePercent.ValueData, 0)
                                                        ELSE vbExtraChargesPercent - vbDiscountPercent
                                                   END
                                                  )
         FROM MovementItem
              LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                          ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                         AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                          ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                         AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId = zc_MI_Master();
     END IF;


     -- заполняем таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, ContainerId_Count, ContainerId_GoodsPartner, ContainerId_GoodsTransit, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate, ChangePercent, isChangePrice
                         , OperCount, OperCountCount, OperCount_Partner, tmpOperSumm_PriceList, OperSumm_PriceList, tmpOperSumm_PriceList_real, OperSumm_PriceList_real, tmpOperSumm_Partner, tmpOperSumm_Partner_original, OperSumm_Partner, OperSumm_Partner_ChangePercent
                         , tmpOperSumm_Partner_Currency, OperSumm_Currency
                         , ContainerId_ProfitLoss_10700
                         , ContainerId_Partner, ContainerId_Currency, AccountId_Partner, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_To
                         , isPartionCount, isPartionSumm, isTareReturning
                         , PartionGoodsId, PartionMovementId
                         , PriceListPrice, Price, Price_Currency, Price_original, CountForPrice)
    WITH tmpMI_all AS
             (SELECT (MovementItem.Id) AS MovementItemId
                   , COALESCE (MILinkObject_GoodsReal.ObjectId, MovementItem.ObjectId) AS GoodsId
                   , COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                   , SUM (MovementItem.Amount)                           AS OperCount
                   , SUM (COALESCE (MIFloat_Count.ValueData, 0))         AS OperCountCount
                   , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS OperCount_Partner

                   , COALESCE (MIFloat_Price.ValueData, 0)         AS Price_original

                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice
                   , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent

                   , COALESCE (MIFloat_MovementId.ValueData, 0) :: Integer AS MovementId_Partion

                   , COALESCE (MILinkObject_Asset.ObjectId, 0)              AS AssetId
                   , COALESCE (MIString_PartionGoods.ValueData, '')         AS PartionGoods
                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

              FROM MovementItem

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsReal
                                                    ON MILinkObject_GoodsReal.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsReal.DescId         = zc_MILinkObject_GoodsReal()
                                                   AND vbIsNotRealGoods                      = FALSE
                                                   AND vbOperDate                            >= '10.12.2022'
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindReal
                                                    ON MILinkObject_GoodsKindReal.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKindReal.DescId         = zc_MILinkObject_GoodsKindReal()
                                                   AND vbIsNotRealGoods                          = FALSE
                                                   AND vbOperDate                                >= '10.12.2022'

                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                   LEFT JOIN MovementItemFloat AS MIFloat_Count
                                               ON MIFloat_Count.MovementItemId = MovementItem.Id
                                              AND MIFloat_Count.DescId         = zc_MIFloat_Count()

                   LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                               ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                               ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                              AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE
                AND vbMovementDescId        = zc_Movement_ReturnIn()
              GROUP BY MovementItem.Id
                     , MovementItem.ObjectId
                     , MILinkObject_GoodsReal.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MILinkObject_GoodsKindReal.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
                     , MIFloat_ChangePercent.ValueData
                     , MIFloat_MovementId.ValueData
                     , MILinkObject_Asset.ObjectId
                     , MIString_PartionGoods.ValueData
                     , MIDate_PartionGoods.ValueData
             )
  , tmpChangePrice AS (SELECT TRUE AS isChangePrice
                       WHERE vbPaidKindId = zc_Enum_PaidKind_FirstForm() -- это БН
                      UNION
                       SELECT TRUE AS isChangePrice
                       FROM tmpMI_all
                       WHERE (vbIsDiscountPrice = TRUE                    -- у Юр лица есть галка
                           OR tmpMI_all.ChangePercent = 0                 -- в шапке есть скидка, но есть хоть один элемент со скидкой = 0%
                           OR vbPaidKindId = zc_Enum_PaidKind_FirstForm() -- это БН
                             )
                         -- оставил Для НАЛ?
                         AND (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0)
                         AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- это НАЛ
                       LIMIT 1
                      )
     , tmpPL_Basis AS (-- цены из прайса напрямую, для скорости
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
                            INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                     ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                    AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                    AND vbOperDatePartner >= ObjectHistory_PriceListItem.StartDate AND vbOperDatePartner < ObjectHistory_PriceListItem.EndDate
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                       WHERE ObjectHistoryFloat_PriceListItem_Value.ValueData > 0
                      )
               , tmpMI_child AS (SELECT MovementItem.ParentId       AS ParentId
                                      , MAX (Movement_Tax.OperDate) AS OperDate_tax
                                 FROM MovementItem
                                      LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                  ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                      LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MIFloat_MovementId.ValueData :: Integer
                                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                                                     ON MovementLinkMovement_Tax.MovementId = Movement_Sale.Id
                                                                    AND MovementLinkMovement_Tax.DescId     = zc_MovementLinkMovement_Master()
                                      LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Child()
                                   AND MovementItem.isErased   = FALSE
                                   AND MovementItem.Amount     <> 0
                                 GROUP BY MovementItem.ParentId
                                )
           , tmpMI AS (SELECT tmpMI.MovementItemId
                            , tmpMI.GoodsId
                            , tmpMI.GoodsKindId
                            , tmpMI.AssetId
                            , tmpMI.PartionGoods
                            , tmpMI.PartionGoodsDate
                            , tmpMI.ChangePercent
                            , tmpMI.isChangePrice

                            , tmpMI.OperCount
                            , tmpMI.OperCountCount
                            , tmpMI.OperCount_Partner

                            , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                        -- так переводится в валюту zc_Enum_Currency_Basis
                                        THEN CAST (tmpMI.Price * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                                   ELSE tmpMI.Price
                              END AS Price

                            , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                        -- так переводится в валюту zc_Enum_Currency_Basis
                                        THEN CAST (tmpMI.Price_original * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                                   ELSE tmpMI.Price_original
                              END AS Price_original

                            , tmpMI.CountForPrice

                            , tmpMI.Price AS Price_Currency

                            , tmpMI.MovementId_Partion

                       FROM  (SELECT tmpMI_all.MovementItemId
                                   , tmpMI_all.GoodsId
                                   , tmpMI_all.GoodsKindId
                                   , tmpMI_all.AssetId
                                   , tmpMI_all.PartionGoods
                                   , tmpMI_all.PartionGoodsDate
                                   , tmpMI_all.ChangePercent
                                   , COALESCE (tmpChangePrice.isChangePrice, FALSE) AS isChangePrice

                                   , tmpMI_all.OperCount
                                   , tmpMI_all.OperCountCount
                                   , tmpMI_all.OperCount_Partner
                                   , CASE WHEN tmpChangePrice.isChangePrice = TRUE -- !!!для НАЛ "иногда" не учитываем, для БН - всегда учитываем!!!
                                               THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpMI_child.OperDate_tax, vbOperDatePartner)
                                                                        , inChangePercent:= tmpMI_all.ChangePercent
                                                                        , inPrice        := tmpMI_all.Price_original
                                                                        , inIsWithVAT    := vbPriceWithVAT
                                                                         )
                                          ELSE tmpMI_all.Price_original
                                     END AS Price
                                   , tmpMI_all.Price_original
                                   , tmpMI_all.CountForPrice

                                   , tmpMI_all.MovementId_Partion

                              FROM tmpMI_all
                                   LEFT JOIN tmpChangePrice ON tmpChangePrice.isChangePrice = TRUE
                                   LEFT JOIN tmpMI_child ON tmpMI_child.ParentId = tmpMI_all.MovementItemId
                             ) AS tmpMI

                      )
        -- Результат
        SELECT
              _tmp.MovementItemId
            , 0 AS ContainerId_Goods
            , 0 AS ContainerId_Count
            , 0 AS ContainerId_GoodsPartner
            , 0 AS ContainerId_GoodsTransit -- Счет - кол-во Транзит
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate
            , _tmp.ChangePercent
            , _tmp.isChangePrice

              -- количество с остатка
            , _tmp.OperCount
            , _tmp.OperCountCount
              -- количество у контрагента
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                        THEN _tmp.OperCount
                   ELSE _tmp.OperCount_Partner
              END AS OperCount_Partner

              -- 1.1. промежуточная (в ценах док-та) сумма прайс-листа по Контрагенту !!!без скидки!!! - с округлением до 2-х знаков - кол-во у Покупателя
            , _tmp.tmpOperSumm_PriceList AS tmpOperSumm_PriceList
              -- 1.2. конечная сумма прайс-листа по Контрагенту !!! без скидки !!! - кол-во у Покупателя
            , CASE WHEN vbPriceWithVAT_PriceList = TRUE OR vbVATPercent_PriceList = 0
                      -- если цены с НДС или %НДС=0, тогда ничего не делаем
                      THEN _tmp.tmpOperSumm_PriceList
                   WHEN vbVATPercent_PriceList > 0
                      -- если цены без НДС, тогда получаем сумму с НДС
                      THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmp.tmpOperSumm_PriceList AS NUMERIC (16, 2))
              END AS OperSumm_PriceList

              -- 2.1. промежуточная (в ценах док-та) сумма прайс-листа по Контрагенту !!!без скидки!!! - с округлением до 2-х знаков - кол-во Склад
            , _tmp.tmpOperSumm_PriceList_real AS tmpOperSumm_PriceList_real
              -- 2.2. конечная сумма прайс-листа по Контрагенту !!! без скидки !!! - кол-во Склад
            , CASE WHEN vbPriceWithVAT_PriceList = TRUE OR vbVATPercent_PriceList = 0
                      -- если цены с НДС или %НДС=0, тогда ничего не делаем
                      THEN _tmp.tmpOperSumm_PriceList_real
                   WHEN vbVATPercent_PriceList > 0
                      -- если цены без НДС, тогда получаем сумму с НДС
                      THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmp.tmpOperSumm_PriceList_real AS NUMERIC (16, 2))
              END AS OperSumm_PriceList_real

              -- промежуточная сумма по Контрагенту !!!почти без скидки(т.е. учтена если надо)!!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_Partner
              -- промежуточная (в ценах док-та) сумма по Контрагенту !!!без скидки!!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_Partner_original

              -- конечная сумма по Контрагенту !!!без скидки!!!
            , CASE WHEN vbPriceWithVAT = TRUE  OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда ничего не делаем
                      THEN _tmp.tmpOperSumm_Partner_original
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда получаем сумму с НДС
                      THEN CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_original AS NUMERIC (16, 2))
              END AS OperSumm_Partner -- !!!результат!!!

              -- конечная сумма по Контрагенту
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Partner_ChangePercent

              -- промежуточная (в ценах док-та) сумма по Контрагенту !!!почти без скидки(т.е. учтена если надо)!!! - с округлением до 2-х знаков !!!в валюте!!!
            , _tmp.tmpOperSumm_Partner_Currency
              -- конечная сумма в валюте по Контрагенту
            , CAST
             (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner_Currency
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner_Currency) AS NUMERIC (16, 2))
                           END
              END   -- так переводится в валюту CurrencyPartnerId
                  * CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue / vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
              AS NUMERIC (16, 2)) AS OperSumm_Currency -- !!!результат!!!

              -- Счет - прибыль (ОПиУ - Сумма возвратов)
            , 0 AS ContainerId_ProfitLoss_10700

              -- Счет - долг Контрагента
            , 0 AS ContainerId_Partner
            , 0 AS ContainerId_Currency
              -- Счет(справочника) Контрагента
            , 0 AS AccountId_Partner
              -- Управленческие назначения
            , _tmp.InfoMoneyDestinationId
              -- Статьи назначения
            , _tmp.InfoMoneyId

              -- значение Бизнес !!!выбирается!!! из Товара или Подраделения/Сотрудника
            , CASE WHEN _tmp.BusinessId_To = 0 THEN vbBusinessId_To ELSE _tmp.BusinessId_To END AS BusinessId_To

            , _tmp.isPartionCount
            , _tmp.isPartionSumm

              -- Возвратная ли это тара (если да, себестоимость остается на остатке)
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                        THEN TRUE
                   ELSE FALSE
              END AS isTareReturning

              -- Партии товара, сформируем позже
            , 0 AS PartionGoodsId
              -- Партии накладны, сформируем позже
            , CASE WHEN vbIsPartionDoc_Branch = TRUE AND _tmp.MovementId_Partion > 0
                        THEN lpInsertFind_Object_PartionMovement (_tmp.MovementId_Partion, NULL)
                   WHEN vbIsPartionDoc_Branch = TRUE
                        THEN 0
                   ELSE 0
              END AS PartionMovementId

            , _tmp.PriceListPrice
            , _tmp.Price
            , _tmp.Price_Currency
            , _tmp.Price_original
            , _tmp.CountForPrice

        FROM
             (SELECT
                    tmpMI.MovementItemId

                  , tmpMI.GoodsId
                  , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье
                              THEN tmpMI.GoodsKindId

                         WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_30102()) -- Тушенка
                          AND tmpMI.GoodsKindId <> zc_GoodsKind_Basis()
                              THEN tmpMI.GoodsKindId

                         WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                              THEN tmpMI.GoodsKindId
                         ELSE 0
                    END AS GoodsKindId
                  , tmpMI.AssetId
                  , tmpMI.PartionGoods
                  , tmpMI.PartionGoodsDate
                  , tmpMI.ChangePercent
                  , tmpMI.isChangePrice

                  , COALESCE (tmpPL_Basis_kind.PriceListPrice, tmpPL_Basis.PriceListPrice, 0) AS PriceListPrice
                  , tmpMI.Price
                  , tmpMI.Price_Currency
                  , tmpMI.Price_original
                  , tmpMI.CountForPrice
                    -- количество для склада
                  , tmpMI.OperCount
                  , tmpMI.OperCountCount
                    -- количество у контрагента
                  , tmpMI.OperCount_Partner

                    -- промежуточная сумма прайс-листа по Контрагенту - с округлением до 2-х знаков - кол-во у Покупателя
                  , COALESCE (CAST (tmpMI.OperCount_Partner * COALESCE (tmpPL_Basis_kind.PriceListPrice, tmpPL_Basis.PriceListPrice, 0) AS NUMERIC (16, 2)), 0) AS tmpOperSumm_PriceList
                    -- промежуточная сумма прайс-листа по Контрагенту - с округлением до 2-х знаков - кол-во Склад
                  , COALESCE (CAST (tmpMI.OperCount * COALESCE (tmpPL_Basis_kind.PriceListPrice, tmpPL_Basis.PriceListPrice, 0) AS NUMERIC (16, 2)), 0) AS tmpOperSumm_PriceList_real
                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков + учтена скидка в цене (!!!если надо!!!)
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner
                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков + !!!НЕ!!! учтена скидка в цене
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price_original AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner_original
                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков + учтена скидка в цене (!!!если надо!!!) !!!в валюте!!!
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price_Currency / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price_Currency AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner_Currency

                    -- Управленческие назначения
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- Статьи назначения
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- Бизнес из Товара
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_To

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm

                    --
                  , tmpMI.MovementId_Partion

              FROM tmpMI

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
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                   -- привязываем цены 2 раза по виду и без
                   LEFT JOIN tmpPL_Basis AS tmpPL_Basis_kind
                                         ON tmpPL_Basis_kind.GoodsId                   = tmpMI.GoodsId
                                        AND COALESCE (tmpPL_Basis_kind.GoodsKindId, 0) = COALESCE (tmpMI.GoodsKindId, 0)
                   LEFT JOIN tmpPL_Basis ON tmpPL_Basis.GoodsId     = tmpMI.GoodsId
                                        AND tmpPL_Basis.GoodsKindId IS NULL
             ) AS _tmp;


     IF EXISTS (SELECT 1 FROM _tmpItem WHERE COALESCE (_tmpItem.InfoMoneyDestinationId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.УП статья не установлена. <%> <%>'
                       , (SELECT COUNT(*) FROM _tmpItem WHERE COALESCE (_tmpItem.InfoMoneyDestinationId, 0) = 0)
                       , (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId) FROM _tmpItem WHERE COALESCE (_tmpItem.InfoMoneyDestinationId, 0) = 0 LIMIT 1)
                        ;
     END IF;

     -- !!!надо определить - есть ли скидка в цене!!!
     vbIsChangePrice:= (SELECT _tmpItem.isChangePrice FROM _tmpItem LIMIT 1);

     -- проверка
     IF COALESCE (vbContractId, 0) = 0 AND (EXISTS (SELECT _tmpItem.isTareReturning FROM _tmpItem WHERE _tmpItem.isTareReturning = FALSE)
                                         -- OR !!! НАЛ !!!
                                           )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не установлено значение <Договор>.Проведение невозможно.';
     END IF;

     -- проверка для кривых пользователей
     IF inUserId <> zc_Enum_Process_Auto_PrimeCost() AND inUserId <> 5
        AND TRUE = (SELECT MovementBoolean.ValueData FROM MovementBoolean WHERE MovementBoolean.MovementId = inMovementId AND MovementBoolean.DescId = zc_MovementBoolean_List())
        AND EXISTS (SELECT 1 FROM _tmpItem
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                               ON MIFloat_MovementId.MovementItemId = _tmpItem.MovementItemId
                                                              AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                   WHERE COALESCE (MIFloat_MovementId.ValueData, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе установлен признак <привязка к Основ. № (да/нет)>, но не у всех элементов заполнено <Основание № (продажа)>.';
     END IF;


     -- !!!запуск новой схемы - с привязкой к продажам!!!
     IF zc_isReturnIn_bySale() = TRUE -- OR inUserId = 5
        -- !!!для ВСЕХ кладовщиков - выход!!! + zc_Enum_Process_Auto_PrimeCost
        AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View
                        WHERE UserId = inUserId
                          AND RoleId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Role() AND Object.ObjectCode IN (3004, 3104, 4004, 5004, 6004, 7004, 8004, 8014, 9004, 9014, 9024))
                       )
        AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
        AND inUserId <> zc_Enum_Process_Auto_ReturnIn()
        AND inMovementId <> 1156274 -- 201500380 - 08.03.2015
        -- AND inUserId <> 5
     THEN
         -- Проверка ошибки
         outMessageText:= lpCheck_Movement_ReturnIn_Auto (inMovementId    := inMovementId
                                                        , inUserId        := inUserId
                                                         );
         -- сохранили свойство <Ошибка>
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Error(), inMovementId, CASE WHEN outMessageText <> '' OR vbPaidKindId = zc_Enum_PaidKind_SecondForm() THEN TRUE ELSE FALSE END);

         -- !!!Выход если ошибка!!!
         IF outMessageText <> '' AND outMessageText <> '-1' THEN RETURN; END IF;

         -- !!!с такой ошибкой - все равно будем проводить!!!
         IF outMessageText = '-1' THEN outMessageText:= 'Важно.У пользователя <' || lfGet_Object_ValueData (inUserId) || '> нет прав формировать привязку накладной <Возврат от покупателя> к накладной <Продажи>.'; END IF;

     END IF;


     -- !!! только НЕ для Админа проверка что ParentId заполнен!!!
     -- только если по всем кол-во склад = 0 + "Голота К.О."
     IF inUserId NOT IN (6604558, 5, zc_Enum_Process_Auto_PrimeCost()) AND vbMovementId_parent = 0 AND NOT EXISTS (SELECT _tmpItem.OperCount FROM _tmpItem WHERE _tmpItem.OperCount <> 0 LIMIT 1)
        -- и нет "основание - Акт недовоза" = да
        AND NOT EXISTS (SELECT 1 FROM MovementBoolean WHERE MovementBoolean.MovementId = inMovementId AND MovementBoolean.ValueData = TRUE AND MovementBoolean.DescId = zc_MovementBoolean_isPartner())
        --
        AND (EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND COALESCE (MLO.ObjectId, 0) IN (0, zc_Enum_Currency_Basis())  AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument())
          OR EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND COALESCE (MLO.ObjectId, 0) IN (0, zc_Enum_Currency_Basis())  AND MLO.DescId = zc_MovementLinkObject_CurrencyPartner())
            )
     THEN
         RAISE EXCEPTION 'Ошибка.%В документе не установлено значение <Основание № (возврат проведен кладовщиком)>.%Проведение невозможно.', CHR(13), CHR(13);
     ELSE
         -- Нет основания в строчной части
         IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) AND vbMovementId_parent = 0 AND NOT EXISTS (SELECT 1
                                                                                                           FROM MovementItem
                                                                                                                INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                                                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                                                                                            AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                                                                                                                            AND MIFloat_MovementId.ValueData > 0
                                                                                                           WHERE MovementItem.MovementId = inMovementId
                                                                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                                                                             AND MovementItem.isErased   = FALSE
                                                                                                          )

            -- и нет "основание - Акт недовоза" = да
            AND EXISTS (SELECT MovementBoolean.MovementId FROM MovementBoolean WHERE MovementBoolean.MovementId = inMovementId AND MovementBoolean.ValueData = TRUE AND MovementBoolean.DescId = zc_MovementBoolean_isPartner())
         THEN
             RAISE EXCEPTION 'Ошибка.%В документе с признаком "Акт недовоза" не установлено значение <Основание № (продажа)>.%Проведение невозможно.', CHR(13), CHR(13);
     END IF;
     END IF;

     IF vbMovementId_parent = inMovementId
     THEN
         RAISE EXCEPTION 'Ошибка.%Неправильно выбран документ <Основание № (возврат проведен кладовщиком)>.%Выберите документ в котором заполнено <Кол-во (склад)>.%Проведение невозможно.', CHR(13), CHR(13), CHR(13);
     END IF;
     IF vbMovementId_parent <> 0 AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
     THEN
         -- проверка даты
         IF vbOperDate <> (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_parent)
         THEN RAISE EXCEPTION 'Ошибка.%Значение <Дата (склад)> должно соответствовать значению <%>%из документа <Основание № (возврат проведен кладовщиком)>.%Проведение невозможно.', CHR(13), DATE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_parent)), CHR(13), CHR(13);
         END IF;
         -- проверка "От Кого"
         IF vbPartnerId_From <> COALESCE ((SELECT MLO_From.ObjectId FROM MovementLinkObject AS MLO_From WHERE MLO_From.MovementId = vbMovementId_parent AND MLO_From.DescId = zc_MovementLinkObject_From()), 0)
         THEN RAISE EXCEPTION 'Ошибка.%Значение <От кого> должно соответствовать значению <%>%из документа <Основание № (возврат проведен кладовщиком)>.%Проведение невозможно.', CHR(13), lfGet_Object_ValueData ((SELECT MLO_From.ObjectId FROM MovementLinkObject AS MLO_From WHERE MLO_From.MovementId = vbMovementId_parent AND MLO_From.DescId = zc_MovementLinkObject_From())), CHR(13), CHR(13);
         END IF;
         -- проверка "Кому"
         IF vbUnitId_To <> COALESCE ((SELECT MLO_To.ObjectId FROM MovementLinkObject AS MLO_To WHERE MLO_To.MovementId = vbMovementId_parent AND MLO_To.DescId = zc_MovementLinkObject_To()), 0)
         THEN RAISE EXCEPTION 'Ошибка.%Значение <Кому> должно соответствовать значению <%>%из документа <Основание № (возврат проведен кладовщиком)>.%Проведение невозможно.', CHR(13), lfGet_Object_ValueData ((SELECT MLO_To.ObjectId FROM MovementLinkObject AS MLO_To WHERE MLO_To.MovementId = vbMovementId_parent AND MLO_To.DescId = zc_MovementLinkObject_To())), CHR(13), CHR(13);
         END IF;
     END IF;


     -- !!!
     -- IF NOT EXISTS (SELECT MovementItemId FROM _tmpItem) THEN RETURN; END IF;


     -- Расчеты сумм
     SELECT -- Расчет Итоговой суммы прайс-листа по Контрагенту - кол-во у Покупателя
            CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_PriceList
                 WHEN vbVATPercent_PriceList > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmpItem.tmpOperSumm_PriceList AS NUMERIC (16, 2))
            END AS OperSumm_PriceList

          , -- Расчет Итоговой суммы прайс-листа по Контрагенту - кол-во у Покупателя
            CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_PriceList_real
                 WHEN vbVATPercent_PriceList > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmpItem.tmpOperSumm_PriceList_real AS NUMERIC (16, 2))
            END AS OperSumm_PriceList_real

          , -- Расчет Итоговой суммы по Контрагенту !!!без скидки!!!
            CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_Partner_original
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_original AS NUMERIC (16, 2))
            END AS OperSumm_Partner

            -- Расчет Итоговой суммы по Контрагенту
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END

            -- Расчет Итоговой суммы в валюте по Контрагенту
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner_Currency
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                         END
            END   -- так переводится в валюту CurrencyPartnerId
                * CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue /  vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
            AS NUMERIC (16, 2)) AS OperSumm_Currency  -- !!!результат!!!

            INTO vbOperSumm_PriceList, vbOperSumm_PriceList_real, vbOperSumm_Partner, vbOperSumm_Partner_ChangePercent, vbOperSumm_Currency
     FROM (SELECT SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_PriceList ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.PriceListPrice AS NUMERIC (16, 2)) END) AS tmpOperSumm_PriceList
                , SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_PriceList ELSE CAST (_tmpItem.OperCount         * _tmpItem.PriceListPrice AS NUMERIC (16, 2)) END) AS tmpOperSumm_PriceList_real
                , SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_Partner -- так получаем по каждому товару отдельно (даже если он повторяется)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner
                , SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_Partner_original -- так получаем по каждому товару отдельно (даже если он повторяется)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_original / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_original AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner_original

                , SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_Partner_Currency -- так получаем по каждому товару отдельно (даже если он повторяется)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_Currency / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_Currency AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner_Currency

           FROM (SELECT _tmpItem.PriceListPrice
                      , _tmpItem.Price
                      , _tmpItem.Price_Currency
                      , _tmpItem.Price_original
                      , _tmpItem.CountForPrice
                      , SUM (_tmpItem.tmpOperSumm_PriceList) AS tmpOperSumm_PriceList
                      , SUM (_tmpItem.OperCount_Partner)     AS OperCount_Partner
                      , SUM (_tmpItem.OperCount)             AS OperCount
                      , SUM (_tmpItem.tmpOperSumm_Partner)   AS tmpOperSumm_Partner
                      , SUM (_tmpItem.tmpOperSumm_Partner_original) AS tmpOperSumm_Partner_original
                      , SUM (_tmpItem.tmpOperSumm_Partner_Currency) AS tmpOperSumm_Partner_Currency
                 FROM _tmpItem
                 GROUP BY _tmpItem.PriceListPrice
                        , _tmpItem.Price
                        , _tmpItem.Price_Currency
                        , _tmpItem.Price_original
                        , _tmpItem.CountForPrice
                        , _tmpItem.GoodsId
                        , _tmpItem.GoodsKindId
                ) AS _tmpItem
          ) AS _tmpItem
     ;
     
     -- !!!меняется значение - переводится в валюту zc_Enum_Currency_Basis!!! - !!!нельзя что б переводился в строчной части!!!
     IF vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND vbParValue <> 0
     THEN
         vbOperSumm_Partner:= CAST (vbOperSumm_Currency * vbCurrencyValue / vbParValue AS NUMERIC (16, 2));
         vbOperSumm_Partner_ChangePercent:= CAST (vbOperSumm_Currency * vbCurrencyValue / vbParValue AS NUMERIC (16, 2));
     END IF;

     -- Расчет Итоговых сумм по Контрагенту (по элементам)
     SELECT SUM (_tmpItem.OperSumm_PriceList), SUM (_tmpItem.OperSumm_PriceList_real), SUM (_tmpItem.OperSumm_Partner), SUM (_tmpItem.OperSumm_Partner_ChangePercent), SUM (_tmpItem.OperSumm_Currency)
            INTO vbOperSumm_PriceList_byItem, vbOperSumm_PriceList_real_byItem, vbOperSumm_Partner_byItem, vbOperSumm_Partner_ChangePercent_byItem, vbOperSumm_Currency_byItem
     FROM _tmpItem
    ;

     -- если не равны ДВЕ Итоговые суммы прайс-листа по Контрагенту
     IF COALESCE (vbOperSumm_PriceList, 0) <> COALESCE (vbOperSumm_PriceList_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_PriceList = _tmpItem.OperSumm_PriceList - (vbOperSumm_PriceList_byItem - vbOperSumm_PriceList)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_PriceList IN (SELECT MAX (_tmpItem.OperSumm_PriceList) FROM _tmpItem)
                                          );
     END IF;
     -- если не равны ДВЕ Итоговые суммы прайс-листа по Контрагенту
     IF COALESCE (vbOperSumm_PriceList_real, 0) <> COALESCE (vbOperSumm_PriceList_real_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_PriceList_real = _tmpItem.OperSumm_PriceList_real - (vbOperSumm_PriceList_real_byItem - vbOperSumm_PriceList_real)
         WHERE _tmpItem.MovementItemId IN (SELECT _tmpItem.MovementItemId FROM _tmpItem ORDER BY _tmpItem.OperSumm_PriceList_real DESC LIMIT 1
                                          );
     END IF;
     -- если не равны ДВЕ Итоговые суммы по Контрагенту !!!без скидки!!!
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner = _tmpItem.OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_Partner IN (SELECT MAX (_tmpItem.OperSumm_Partner) FROM _tmpItem)
                                          );
     END IF;
     -- если не равны ДВЕ Итоговые суммы по Контрагенту
     IF COALESCE (vbOperSumm_Partner_ChangePercent, 0) <> COALESCE (vbOperSumm_Partner_ChangePercent_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner_ChangePercent = _tmpItem.OperSumm_Partner_ChangePercent - (vbOperSumm_Partner_ChangePercent_byItem - vbOperSumm_Partner_ChangePercent)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_Partner_ChangePercent IN (SELECT MAX (_tmpItem.OperSumm_Partner_ChangePercent) FROM _tmpItem)
                                          );
     END IF;


     -- если не равны ДВЕ Итоговые суммы в валюте по Контрагенту
     IF COALESCE (vbOperSumm_Currency, 0) <> COALESCE (vbOperSumm_Currency_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Currency = _tmpItem.OperSumm_Currency - (vbOperSumm_Currency_byItem - vbOperSumm_Currency)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_Currency DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_Currency DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;


     -- Распределение - Маркетинг в накладных + Маркетинг
     IF vbOperSumm_51201 <> 0
     THEN
         -- распределили
         UPDATE _tmpItem SET OperSumm_51201 = CAST (vbOperSumm_51201 * _tmpItem.OperSumm_Partner / vbOperSumm_Partner AS NUMERIC (16,2));

         -- если не вышли на нужную сумму
         IF vbOperSumm_51201 <> (SELECT SUM (COALESCE (_tmpItem.OperSumm_51201, 0)) FROM _tmpItem)
         THEN
             -- выровняли копейки
             UPDATE _tmpItem SET OperSumm_51201 = _tmpItem.OperSumm_51201 - (SELECT SUM (_tmpItem.OperSumm_51201) FROM _tmpItem) + vbOperSumm_51201
             WHERE _tmpItem.MovementItemId = (SELECT _tmpItem.MovementItemId FROM _tmpItem WHERE _tmpItem.OperSumm_51201 <> 0 ORDER BY _tmpItem.OperSumm_51201 DESC LIMIT 1);

         END IF;
     END IF;


     -- формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                AND vbOperDate >= zc_DateStart_PartionGoods()
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                               WHEN vbIsPartionDate_Unit = TRUE
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)
                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                   THEN 0

                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                 OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                   THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= NULL
                                                                                        , inGoodsId       := NULL
                                                                                        , inStorageId     := NULL
                                                                                        , inInvNumber     := NULL
                                                                                        , inOperDate      := NULL
                                                                                        , inPrice         := NULL
                                                                                         )
                                               ELSE lpInsertFind_Object_PartionGoods ('')
                                          END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
     ;


     -- формируются данные если возврат от Контрагента -> Контрагенту
     INSERT INTO _tmpItemPartnerTo (MovementItemId, ContainerId_Partner, AccountId_Partner, ContainerId_ProfitLoss_10700, ContainerId_ProfitLoss_10800, OperSumm_Partner)
        SELECT MovementItemId
             , 0 AS ContainerId_Partner
             , 0 AS AccountId_Partner
             , 0 AS ContainerId_ProfitLoss_10700
             , 0 AS ContainerId_ProfitLoss_10800
             , OperSumm_PriceList AS OperSumm_Partner
        FROM _tmpItem
        WHERE vbPartnerId_To <> 0
    ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 3.0.1. определяется Счет(справочника) для проводок по долг Покупателя !!!если возврат от Контрагента -> Контрагенту!!!
     UPDATE _tmpItemPartnerTo SET AccountId_Partner = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30100() -- покупатели
                                             , inInfoMoneyDestinationId := vbInfoMoneyDestinationId_To
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
           WHERE EXISTS (SELECT _tmpItemPartnerTo.AccountId_Partner FROM _tmpItemPartnerTo)
          ) AS _tmpItem_byAccount
     ;

     -- 3.0.2. определяется ContainerId для проводок по долг Покупателя !!!если возврат от Контрагента -> Контрагенту!!!
     UPDATE _tmpItemPartnerTo SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
     FROM _tmpItem
          INNER JOIN (SELECT -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
                             lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                   , inParentId          := NULL
                                                   , inObjectId          := (SELECT AccountId_Partner FROM _tmpItemPartnerTo GROUP BY AccountId_Partner)
                                                   , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                   , inBusinessId        := tmp.BusinessId_To
                                                   , inObjectCostDescId  := NULL
                                                   , inObjectCostId      := NULL
                                                   , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                   , inObjectId_1        := vbJuridicalId_To
                                                   , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                   , inObjectId_2        := vbContractId_To
                                                   , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                   , inObjectId_3        := vbInfoMoneyId_To
                                                   , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                   , inObjectId_4        := vbPaidKindId_To
                                                   , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                   , inObjectId_5        := 0 -- !!!нет партии!!!
                                                   , inDescId_6          := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                   , inObjectId_6        := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN vbPartnerId_To ELSE NULL END
                                                   , inDescId_7          := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                   , inObjectId_7        := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN vbBranchId_To ELSE NULL END
                                                   , inDescId_8          := NULL -- zc_ContainerLinkObject_Currency()
                                                   , inObjectId_8        := NULL -- vbCurrencyPartnerId
                                                    ) AS ContainerId
                           , tmp.BusinessId_To
                      FROM (SELECT _tmpItem.BusinessId_To
                            FROM _tmpItem
                            WHERE EXISTS (SELECT _tmpItemPartnerTo.AccountId_Partner FROM _tmpItemPartnerTo)
                            GROUP BY _tmpItem.BusinessId_To
                           ) AS tmp
                    ) AS _tmpItem_byInfoMoney ON _tmpItem_byInfoMoney.BusinessId_To = _tmpItem.BusinessId_To
     WHERE _tmpItem.MovementItemId = _tmpItemPartnerTo.MovementItemId
     ;


     -- 3.1. определяется Счет(справочника) для проводок по долг Покупателя или Физ.лица (подотчетные лица)
     UPDATE _tmpItem SET AccountId_Partner = _tmpItem_byAccount.AccountId
     FROM (SELECT CASE WHEN vbIsCorporate_From = TRUE
                            THEN _tmpItem_group.AccountId_Corporate
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                   END AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbMemberId_From <> 0
                                  THEN zc_Enum_AccountDirection_30500() -- Физ.лица (подотчетные лица)
                             WHEN vbIsCorporate_From = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- наши компании
                             WHEN vbInfoMoneyDestinationId_From IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                  , zc_Enum_InfoMoneyDestination_20700()  -- Товары
                                                                  , zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                  , zc_Enum_InfoMoneyDestination_30100()  -- Продукция
                                                                  , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                  THEN CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                                                 THEN zc_Enum_AccountDirection_30150() -- покупатели ВЭД
                                            ELSE zc_Enum_AccountDirection_30100()      -- покупатели
                                       END

                             WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                    , zc_Enum_InfoMoneyDestination_20700()  -- Товары
                                                                    , zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                    , zc_Enum_InfoMoneyDestination_30100()  -- Продукция
                                                                    , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                  THEN CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                                                 THEN zc_Enum_AccountDirection_30150() -- покупатели ВЭД
                                            ELSE zc_Enum_AccountDirection_30100()      -- покупатели
                                       END

                         -- ELSE zc_Enum_AccountDirection_30400() -- Прочие дебиторы
                             ELSE CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                                            THEN zc_Enum_AccountDirection_30150() -- покупатели ВЭД
                                       ELSE zc_Enum_AccountDirection_30100()      -- покупатели
                                  END
                        END AS AccountDirectionId

                      , CASE WHEN vbIsCorporate_From = TRUE
                                   THEN vbInfoMoneyDestinationId_From -- zc_Enum_InfoMoneyDestination_30100() -- Продукция
                             WHEN vbInfoMoneyDestinationId_From <> 0
                                  THEN vbInfoMoneyDestinationId_From -- УП: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                             WHEN _tmpItem.isTareReturning = TRUE -- !!!Возвратная тара!!!
                                  THEN zc_Enum_InfoMoneyDestination_30100() -- Продукция
                             ELSE _tmpItem.InfoMoneyDestinationId -- иначе берем по товару
                        END AS InfoMoneyDestinationId_calc

                      , _tmpItem.InfoMoneyDestinationId
                      , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30201() -- Алан
                             WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30202() -- Ирна
                             WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30203() -- Чапли
                             WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30204() -- Дворкин
                             WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30205() -- ЕКСПЕРТ-АГРОТРЕЙД
                        END AS AccountId_Corporate

                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!нельзя ограничивать, т.к. этот AccountId в проводках для отчета!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId, _tmpItem.isTareReturning
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;


     -- 3.2.1. определяется ContainerId для проводок по долг Покупателя или Физ.лица (подотчетные лица)
     UPDATE _tmpItem SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
     FROM (SELECT CASE WHEN vbMemberId_From <> 0
                                 -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Физ.лица (подотчетные лица) 2)NULL 3)NULL 4)Статьи назначения
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
                                                       , inObjectId_3        := vbBranchId_To -- долг Подотчета всегда на филиале Склада
                                                       , inDescId_4          := zc_ContainerLinkObject_Car()
                                                       , inObjectId_4        := 0 -- для Физ.лица (подотчетные лица) !!!именно здесь последняя аналитика всегда значение = 0!!!
                                                        )
                            -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := _tmpItem_group.AccountId_Partner
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                  , inBusinessId        := _tmpItem_group.BusinessId_To
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                  , inObjectId_1        := vbJuridicalId_From
                                                  , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                  , inObjectId_2        := vbContractId
                                                  , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                  , inObjectId_3        := _tmpItem_group.InfoMoneyId_calc
                                                  , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                  , inObjectId_4        := vbPaidKindId
                                                  , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                  , inObjectId_5        := _tmpItem_group.PartionMovementId
                                                  , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                  , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END
                                                  , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                  , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbBranchId_To ELSE NULL END
                                                  , inDescId_8          := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE zc_ContainerLinkObject_Currency() END
                                                  , inObjectId_8        := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE vbCurrencyPartnerId END
                                                   )
                  END AS ContainerId
                , _tmpItem_group.InfoMoneyId
                , _tmpItem_group.PartionMovementId
           FROM (SELECT _tmpItem.AccountId_Partner
                      , _tmpItem.InfoMoneyId
                      , _tmpItem.BusinessId_To
                      , _tmpItem.PartionMovementId
                      , CASE WHEN vbInfoMoneyId_From <> 0
                                  THEN vbInfoMoneyId_From -- УП: ВСЕГДА по договору -- ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                             WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20901 () -- 20901; "Ирна"
                                  THEN zc_Enum_InfoMoney_30101 () -- 30101; "Готовая продукция"
                             ELSE _tmpItem.InfoMoneyId -- иначе берем по товару
                        END AS InfoMoneyId_calc
                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!нельзя ограничивать, т.к. этот ContainerId в проводках для отчета!!!
                 GROUP BY _tmpItem.AccountId_Partner
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_To
                        , _tmpItem.PartionMovementId
                ) AS _tmpItem_group
          ) AS _tmpItem_byInfoMoney
     WHERE _tmpItem.InfoMoneyId       = _tmpItem_byInfoMoney.InfoMoneyId
       AND _tmpItem.PartionMovementId = _tmpItem_byInfoMoney.PartionMovementId
     ;

     -- 3.2.2. определяется ContainerId_Currency для проводок по долг Покупателя или Физ.лица (подотчетные лица)
     UPDATE _tmpItem SET ContainerId_Currency = _tmpItem_byInfoMoney.ContainerId_Currency
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                        , inParentId          := _tmpItem_group.ContainerId_Partner
                                        , inObjectId          := _tmpItem_group.AccountId_Partner
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_group.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                        , inObjectId_1        := vbJuridicalId_From
                                        , inDescId_2          := zc_ContainerLinkObject_Contract()
                                        , inObjectId_2        := vbContractId
                                        , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_3        := _tmpItem_group.InfoMoneyId_calc
                                        , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                        , inObjectId_4        := vbPaidKindId
                                        , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                        , inObjectId_5        := _tmpItem_group.PartionMovementId
                                        , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                        , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END
                                        , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                        , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbBranchId_To ELSE NULL END
                                        , inDescId_8          := zc_ContainerLinkObject_Currency()
                                        , inObjectId_8        := vbCurrencyPartnerId
                                         ) AS ContainerId_Currency
                , _tmpItem_group.InfoMoneyId
                , _tmpItem_group.PartionMovementId
           FROM (SELECT _tmpItem.ContainerId_Partner
                      , _tmpItem.AccountId_Partner
                      , _tmpItem.InfoMoneyId
                      , _tmpItem.BusinessId_To
                      , CASE WHEN vbInfoMoneyId_From <> 0
                                  THEN vbInfoMoneyId_From -- УП: ВСЕГДА по договору -- ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                             WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20901 () -- 20901; "Ирна"
                                  THEN zc_Enum_InfoMoney_30101 () -- 30101; "Готовая продукция"
                             ELSE _tmpItem.InfoMoneyId -- иначе берем по товару
                        END AS InfoMoneyId_calc
                      , _tmpItem.PartionMovementId
                 FROM _tmpItem
                 WHERE vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                   AND vbMemberId_From = 0
                   AND vbIsCorporate_From = FALSE
                 GROUP BY _tmpItem.ContainerId_Partner
                        , _tmpItem.AccountId_Partner
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_To
                        , _tmpItem.PartionMovementId
                ) AS _tmpItem_group
          ) AS _tmpItem_byInfoMoney
     WHERE _tmpItem.InfoMoneyId       = _tmpItem_byInfoMoney.InfoMoneyId
       AND _tmpItem.PartionMovementId = _tmpItem_byInfoMoney.PartionMovementId
     ;

     --
     IF 1 < (SELECT COUNT(*) FROM (SELECT DISTINCT _tmpItem.ContainerId_Partner FROM _tmpItem) AS tmp)
     THEN
         RAISE EXCEPTION 'Ошибка. ContainerId_Partner = <%><%> or <%><%> № док = <%> от <%> <%> Товар = <%>'
                       , (SELECT MIN (_tmpItem.ContainerId_Partner) FROM _tmpItem)
                       , (SELECT COUNT(*) FROM _tmpItem WHERE _tmpItem.ContainerId_Partner = (SELECT MIN (_tmpItem.ContainerId_Partner) FROM _tmpItem))
                       , (SELECT MAX (_tmpItem.ContainerId_Partner) FROM _tmpItem)
                       , (SELECT COUNT(*) FROM _tmpItem WHERE _tmpItem.ContainerId_Partner = (SELECT MAX (_tmpItem.ContainerId_Partner) FROM _tmpItem))
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                       , inMovementId
                       , (SELECT MIN (lfGet_Object_ValueData (_tmpItem.GoodsId)) FROM _tmpItem WHERE _tmpItem.ContainerId_Partner = (SELECT MIN (_tmpItem.ContainerId_Partner) FROM _tmpItem))
                        ;
     END IF;

     -- 3.3. !!!Очень важно - определили здесь vbContainerId_Analyzer для ВСЕХ!!!, если он не один - тогда ошибка
     vbContainerId_Analyzer:= (SELECT DISTINCT _tmpItem.ContainerId_Partner FROM _tmpItem);
     -- определили
     vbContainerId_Analyzer_PartnerTo:= (SELECT ContainerId_Partner FROM _tmpItemPartnerTo GROUP BY ContainerId_Partner);
     -- определили
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId_To <> 0 THEN vbUnitId_To WHEN vbMemberId_To <> 0 THEN vbMemberId_To WHEN vbPartnerId_To <> 0 THEN vbPartnerId_To END;
     -- определили
     vbObjectExtId_Analyzer:= CASE WHEN vbPartnerId_From <> 0 THEN vbPartnerId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From END;
     -- определили
     vbAccountId_GoodsTransit:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110111() ELSE 0 END;


     -- 1.1.1. определяется ContainerId_GoodsPartner для !!!НЕ забалансовой!!! проводки по количественному учету - долги Покупателя или Физ.лица
     UPDATE _tmpItem SET ContainerId_GoodsPartner = -- 0)Товар 1)Покупатель
                                                    -- 0)Товар 1)Физ.лицо
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
                                                                          , inDescId_3          := zc_ContainerLinkObject_PaidKind()
                                                                          , inObjectId_3        := vbPaidKindId
                                                                           )
     WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
       AND vbPartnerId_To = 0 -- !!!если НЕ возврат от Контрагента -> Контрагенту!!!
    ;

     -- 1.1.2. формируются !!!НЕ забалансовые!!! Проводки для количественного учета - долги Покупателя или Физ.лица
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_GoodsPartner
            , 0                                       AS AccountId                -- нет счета
            , zc_Enum_AnalyzerId_TareReturning()      AS AnalyzerId               -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- Товар
            , CASE WHEN vbMemberId_From <> 0 THEN vbMemberId_From ELSE vbPartnerId_From END AS WhereObjectId_Analyzer -- Покупатель или Физ.лицо
            , 0                                       AS ContainerId_Analyzer     -- !!!нет!!!
            , 0                                       AS ObjectIntId_Analyzer     -- !!!нет!!!
            , vbWhereObjectId_Analyzer                AS ObjectExtId_Analyzer     -- подразделение или...
            , ContainerId_GoodsPartner                AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , 0                                       AS ParentId
            , -1 * OperCount                          AS Amount
            , vbOperDatePartner                       AS OperDate                 -- т.е. по "Дате покупателя"
            , FALSE                                   AS isActive
       FROM _tmpItem
       WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
         AND vbPartnerId_To = 0 -- !!!если НЕ возврат от Контрагента -> Контрагенту!!!
      ;


     -- 1.2.0. определяется ContainerId_Goods для количественного учета - !!!если возврат от Контрагента -> Контрагенту!!!
     UPDATE _tmpItemPartnerTo SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDatePartner
                                                                                         , inUnitId                 := NULL -- !!!подразделения нет!!!
                                                                                         , inCarId                  := NULL
                                                                                         , inMemberId               := NULL
                                                                                         , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                         , inGoodsId                := _tmpItem.GoodsId
                                                                                         , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                         , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                         , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                         , inAssetId                := _tmpItem.AssetId
                                                                                         , inBranchId               := NULL
                                                                                         , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                          )
     FROM _tmpItem
     WHERE _tmpItem.MovementItemId = _tmpItemPartnerTo.MovementItemId
    ;

     -- 1.2.1.1. определяется ContainerId_Goods для количественного учета + ...
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
                                                                                , inBranchId               := vbBranchId_To -- эта аналитика нужна для филиала
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
                , ContainerId_GoodsTransit = CASE WHEN vbAccountId_GoodsTransit <> 0
                                        THEN lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId_To
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_To -- эта аналитика нужна для филиала
                                                                                , inAccountId              := vbAccountId_GoodsTransit -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                        ELSE 0 END
                       , ContainerId_Goods_Alternative = CASE WHEN vbUnitId_HistoryCost IN (0, vbUnitId_To) -- если 0 или сам в себя
                                                                OR vbOperDate < '01.01.2022' OR vbOperDatePartner < '01.01.2022'
                                                                   THEN 0
                                        ELSE lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId_HistoryCost -- !!!на альтернативном подразделении!!!
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_To -- эта аналитика нужна для филиала
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                                        END
                         -- определяется счет !!!если "виртуальная" прибыль текущего периода!!!, т.е. возврат на филиале по ценам прайса (если склад возвратов)
                       , AccountId_SummIn_60000 = CASE WHEN vbUnitId_HistoryCost <> vbUnitId_To -- если признак НЕ установлен сам в себя
                                                         OR vbBranchId_To = zc_Branch_Basis()   -- !!!ИЛИ!!! это "Главный" филиал
                                                         OR vbOperDate < '01.01.2022' OR vbOperDatePartner < '01.01.2022'
                                                            THEN 0
                                                       ELSE -- если признак установлен сам в себя
                                                            lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                                                                       , inAccountDirectionId     := vbAccountDirectionId_To
                                                                                       , inInfoMoneyDestinationId := CASE WHEN 1=0 AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                                                                                               THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                                          ELSE _tmpItem.InfoMoneyDestinationId
                                                                                                                     END
                                                                                       , inInfoMoneyId            := NULL
                                                                                       , inUserId                 := inUserId
                                                                                        )
                                                    END
                        -- определяется счет !!!если "виртуальная" прибыль текущего периода!!!, т.е. возврат на филиале по ценам прайса (если склад возвратов)
                      , AccountId_SummOut_60000 = CASE WHEN vbUnitId_HistoryCost <> vbUnitId_To -- если признак НЕ установлен сам в себя
                                                         OR vbBranchId_To = zc_Branch_Basis()   -- !!!ИЛИ!!! это "Главный" филиал
                                                         OR vbOperDate < '01.01.2022' OR vbOperDatePartner < '01.01.2022'
                                                            THEN 0
                                                       ELSE -- если признак установлен сам в себя
                                                            lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                                                       , inAccountDirectionId     := zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
                                                                                       , inInfoMoneyDestinationId := CASE WHEN 1=0 AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                                                                                               THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                                          ELSE _tmpItem.InfoMoneyDestinationId
                                                                                                                     END
                                                                                       , inInfoMoneyId            := NULL
                                                                                       , inUserId                 := inUserId
                                                                                        )
                                                    END
     WHERE vbPartnerId_To = 0 -- !!!если НЕ возврат от Контрагента -> Контрагенту!!!
    ;

     -- 1.2.1.2. определяется ContainerId_Count для количественного учета
     UPDATE _tmpItem SET ContainerId_Count = lpInsertFind_Container (inContainerDescId   := zc_Container_CountCount()
                                                                   , inParentId          := _tmpItem.ContainerId_Goods
                                                                   , inObjectId          := _tmpItem.GoodsId
                                                                   , inJuridicalId_basis := NULL
                                                                   , inBusinessId        := NULL
                                                                   , inObjectCostDescId  := NULL
                                                                   , inObjectCostId      := NULL
                                                                    )
     WHERE _tmpItem.OperCountCount <> 0;

     -- 1.2.1.3. определяется ContainerId для проводок !!!если "виртуальная" прибыль текущего периода!!!, т.е. возврат на филиале по ценам прайса (если склад возвратов)
     UPDATE _tmpItem SET ContainerId_SummIn_60000 = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                      , inUnitId                 := vbUnitId_To
                                                                                      , inCarId                  := NULL
                                                                                      , inMemberId               := vbMemberId_To
                                                                                      , inBranchId               := vbBranchId_To
                                                                                      , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                                                      , inBusinessId             := _tmpItem.BusinessId_To
                                                                                      , inAccountId              := _tmpItem.AccountId_SummIn_60000
                                                                                      , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                      , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                      , inInfoMoneyId_Detail     := zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                                                      , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                                      , inGoodsId                := _tmpItem.GoodsId
                                                                                      , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                      , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                      , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                      , inAssetId                := _tmpItem.AssetId
                                                                                       )
                      , ContainerId_SummOut_60000 = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                      , inUnitId                 := vbUnitId_To
                                                                                      , inCarId                  := NULL
                                                                                      , inMemberId               := vbMemberId_To
                                                                                      , inBranchId               := vbBranchId_To
                                                                                      , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                                                      , inBusinessId             := _tmpItem.BusinessId_To
                                                                                      , inAccountId              := _tmpItem.AccountId_SummOut_60000
                                                                                      , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                      , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                      , inInfoMoneyId_Detail     := zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                                                                                      , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                                      , inGoodsId                := _tmpItem.GoodsId
                                                                                      , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                      , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                      , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                      , inAssetId                := _tmpItem.AssetId
                                                                                       )
     WHERE _tmpItem.AccountId_SummIn_60000 <> 0
        OR _tmpItem.AccountId_SummOut_60000 <> 0
    ;

     -- 1.2.2. формируются Проводки для количественного учета (остаток)
        WITH tmpMIContainer AS
            (SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_Count
                  , ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                  , CASE WHEN isTareReturning = TRUE THEN 0 ELSE zc_Enum_AnalyzerId_ReturnInCount_10800() END AS AnalyzerId -- Кол-во, возврат, от покупателя
                  , 0 AS ParentId
                  , OperCount_Partner AS Amount
                  , OperCountCount    AS OperCountCount
                  , TRUE              AS isActive
             FROM _tmpItem
             -- убрал т.к. хоть одна проводка должна быть (!!!для отчетов!!!)
             -- WHERE OperCount_Partner <> 0
             WHERE vbPartnerId_To = 0 -- !!!если НЕ возврат от Контрагента -> Контрагенту!!!

            UNION ALL
             SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_Count
                  , ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                  , CASE WHEN isTareReturning = TRUE THEN 0 ELSE zc_Enum_AnalyzerId_ReturnInCount_40200() END AS AnalyzerId -- Кол-во, возврат, Разница в весе
                  , 0 AS ParentId
                  , (OperCount - OperCount_Partner) AS Amount
                  , 0                               AS OperCountCount
                  , TRUE                            AS isActive
             FROM _tmpItem
             WHERE (OperCount - OperCount_Partner) <> 0 -- !!!нулевые не нужны!!!
               AND vbPartnerId_To = 0 -- !!!если НЕ возврат от Контрагента -> Контрагенту!!!
            )
     -- проводки: AnalyzerId <> 0 всегда, ContainerId_Analyzer <> 0 тогда попадает в отчеты покупателя, иначе "виртуальная" (т.е. AccountId <> 0, AnalyzerId <> 0, ContainerId_Analyzer = 0)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- это обычная проводка - zc_Container_Count
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_Goods
            , 0                                       AS AccountId              -- нет счета
            , tmpMIContainer.AnalyzerId               AS AnalyzerId             -- !!!аналитика есть всегда!!! (даже если через транзит, она нужна для склада)
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- если это транзит, тогда в реализацию за vbOperDate не попадет
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- если это транзит, тогда в реализацию за vbOperDate попадет 2 раза с + и -
            , tmpMIContainer.GoodsKindId              AS ObjectIntId_Analyzer   -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- покупатель / физ.лицо
            , tmpMIContainer.ContainerId_Goods        AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount
            , vbOperDate -- т.е. по "Дате склад"
            , tmpMIContainer.isActive
       FROM tmpMIContainer

     UNION ALL
       -- это обычная проводка - zc_Container_CountCount
       SELECT 0, zc_MIContainer_CountCount() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_Count
            , 0                                       AS AccountId              -- нет счета
            , tmpMIContainer.AnalyzerId               AS AnalyzerId             -- !!!аналитика есть всегда!!! (даже если через транзит, она нужна для склада)
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- если это транзит, тогда в реализацию за vbOperDate не попадет
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- если это транзит, тогда в реализацию за vbOperDate попадет 2 раза с + и -
            , tmpMIContainer.GoodsKindId              AS ObjectIntId_Analyzer   -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- покупатель / физ.лицо
            , tmpMIContainer.ContainerId_Goods        AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , tmpMIContainer.ParentId
            , tmpMIContainer.OperCountCount
            , vbOperDate -- т.е. по "Дате склад"
            , tmpMIContainer.isActive
       FROM tmpMIContainer
       WHERE tmpMIContainer.OperCountCount <> 0

     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_GoodsTransit
            , vbAccountId_GoodsTransit                AS AccountId                -- есть счет (т.е. в отчетах определяется "транзит")
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!аналитика есть всегда!!! (даже для "виртуальной")
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- т.е. в реализацию попадет "реальная" за vbOperDatePartner
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- т.е. в реализацию попадет "реальная" за vbOperDatePartner + за vbOperDate попадет 2 раза с + и -
            , tmpMIContainer.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , tmpMIContainer.ContainerId_GoodsTransit AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END AS Amount -- "виртуальная" с обратным знаком
            , tmpOperDate.OperDate -- !!!две проводки за разные даты!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN NOT tmpMIContainer.isActive ELSE tmpMIContainer.isActive END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN tmpMIContainer ON vbAccountId_GoodsTransit <> 0
     UNION ALL
       -- это обычная проводка - !!!если возврат от Контрагента -> Контрагенту!!!
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItemPartnerTo.MovementItemId
            , _tmpItemPartnerTo.ContainerId_Goods
            , 0                                        AS AccountId                -- нет счета
            , zc_Enum_AnalyzerId_ReturnInCount_10800() AS AnalyzerId               -- !!!аналитика есть всегда!!! Кол-во, возврат, от покупателя
            , _tmpItem.GoodsId                         AS ObjectId_Analyzer
            , CASE WHEN tmpIsActive.isActive = FALSE THEN vbPartnerId_To ELSE vbPartnerId_From END AS WhereObjectId_Analyzer
            , CASE WHEN tmpIsActive.isActive = FALSE THEN vbContainerId_Analyzer_PartnerTo ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                     AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                   AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItemPartnerTo.ContainerId_Goods      AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , 0 AS ParentId
            , _tmpItem.OperCount_Partner * CASE WHEN tmpIsActive.isActive = TRUE THEN 1 ELSE -1 END AS Amount
            , vbOperDatePartner -- т.е. по "Дате покупателя"
            , tmpIsActive.isActive
       FROM (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmpIsActive
            INNER JOIN _tmpItem ON _tmpItem.OperCount_Partner <> 0  -- !!!нулевые не нужны!!!
            INNER JOIN _tmpItemPartnerTo ON _tmpItemPartnerTo.MovementItemId = _tmpItem.MovementItemId
      ;


     -- 1.2.3. дальше !!!Возвратная тара не учавствует!!!, поэтому удаляем
     DELETE FROM _tmpItem WHERE _tmpItem.isTareReturning = TRUE;


     -- 1.2.2.
     OPEN curContainer FOR SELECT ContainerId_Goods, Container_Summ.Id AS ContainerId_Summ_Alternative, Container_Summ.DescId AS ContainerDescId, Container_Summ.ObjectId AS ContainerObjectId
                           FROM _tmpItem
                                INNER JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods_Alternative
                                                                      AND Container_Summ.DescId = zc_Container_Summ()
                           WHERE ContainerId_Goods_Alternative <> 0
                             AND InfoMoneyDestinationId        <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                             AND vbPartnerId_To = 0 -- !!!если НЕ возврат от Контрагента -> Контрагенту!!!
     ;
     -- начало цикла по курсору
     LOOP
          -- данные
          FETCH curContainer INTO vbContainerId_Goods, vbContainerId_Summ_Alternative, vbContainerDescId, vbContainerObjectId;
          -- если данных нет, то мы выходим
          IF NOT FOUND THEN
             EXIT;
          END IF;
          --
          WITH tmpJuridical_basis AS (SELECT ObjectId FROM ContainerLinkObject WHERE ContainerId = vbContainerId_Summ_Alternative AND DescId = zc_ContainerLinkObject_JuridicalBasis())
             , tmpBusiness AS (SELECT ObjectId FROM ContainerLinkObject WHERE ContainerId = vbContainerId_Summ_Alternative AND DescId = zc_ContainerLinkObject_Business())
             , tmpAll AS (SELECT DescId, ObjectId FROM ContainerLinkObject WHERE ContainerId = vbContainerId_Summ_Alternative AND DescId NOT IN (zc_ContainerLinkObject_JuridicalBasis(), zc_ContainerLinkObject_Business()))
             , tmpDesc1 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll)
             , tmpObject1 AS (SELECT ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc1))
             , tmpDesc2 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc1))
             , tmpObject2 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc2))
             , tmpDesc3 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc2))
             , tmpObject3 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc3))
             , tmpDesc4 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc3))
             , tmpObject4 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc4))
             , tmpDesc5 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc4))
             , tmpObject5 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc5))
             , tmpDesc6 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc5))
             , tmpObject6 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc6))
             , tmpDesc7 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc6))
             , tmpObject7 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc7))
             , tmpDesc8 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc7))
             , tmpObject8 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc8))
             , tmpDesc9 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc8))
             , tmpObject9 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc9))
             , tmpDesc10 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc9))
             , tmpObject10 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc10))
          --
          INSERT INTO _tmpList_Alternative (ContainerId_Goods, ContainerId_Summ_Alternative, ContainerId_Summ)
             SELECT vbContainerId_Goods, vbContainerId_Summ_Alternative
                         , lpInsertFind_Container (inContainerDescId   := vbContainerDescId
                                                 , inParentId          := vbContainerId_Goods
                                                 , inObjectId          := vbContainerObjectId
                                                 , inJuridicalId_basis := (SELECT ObjectId FROM tmpJuridical_basis)
                                                 , inBusinessId        := (SELECT ObjectId FROM tmpBusiness)
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := (SELECT DescId FROM tmpDesc1)
                                                 , inObjectId_1 := CASE WHEN (SELECT DescId FROM tmpDesc1) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject1) END
                                                 , inDescId_2   := (SELECT DescId FROM tmpDesc2)
                                                 , inObjectId_2 := CASE WHEN (SELECT DescId FROM tmpDesc2) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject2) END
                                                 , inDescId_3   := (SELECT DescId FROM tmpDesc3)
                                                 , inObjectId_3 := CASE WHEN (SELECT DescId FROM tmpDesc3) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject3) END
                                                 , inDescId_4   := (SELECT DescId FROM tmpDesc4)
                                                 , inObjectId_4 := CASE WHEN (SELECT DescId FROM tmpDesc4) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject4) END
                                                 , inDescId_5   := (SELECT DescId FROM tmpDesc5)
                                                 , inObjectId_5 := CASE WHEN (SELECT DescId FROM tmpDesc5) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject5) END
                                                 , inDescId_6   := (SELECT DescId FROM tmpDesc6)
                                                 , inObjectId_6 := CASE WHEN (SELECT DescId FROM tmpDesc6) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject6) END
                                                 , inDescId_7   := (SELECT DescId FROM tmpDesc7)
                                                 , inObjectId_7 := CASE WHEN (SELECT DescId FROM tmpDesc7) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject7) END
                                                 , inDescId_8   := (SELECT DescId FROM tmpDesc8)
                                                 , inObjectId_8 := CASE WHEN (SELECT DescId FROM tmpDesc8) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject8) END
                                                 , inDescId_9   := (SELECT DescId FROM tmpDesc9)
                                                 , inObjectId_9 := CASE WHEN (SELECT DescId FROM tmpDesc9) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject9) END
                                                 , inDescId_10  := (SELECT DescId FROM tmpDesc10)
                                                 , inObjectId_10:= CASE WHEN (SELECT DescId FROM tmpDesc10) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject10) END
                                                  );
     END LOOP; -- финиш цикла по курсору
     CLOSE curContainer; -- закрыли курсор



     -- 1.3.1.1. самое интересное: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10800, ContainerId, AccountId, ContainerId_Transit, OperSumm, OperSumm_Partner)
        SELECT
              _tmpItem.MovementItemId
            , 0 AS ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с1 - с/с2)
            , 0 AS ContainerId_ProfitLoss_10800 -- Счет - прибыль (ОПиУ - Себестоимость возвратов : с/с2)
            , COALESCE (lfContainerSumm_20901.ContainerId, _tmpList_Alternative.ContainerId_Summ, Container_Summ.Id, 0) AS ContainerId
            , COALESCE (lfContainerSumm_20901.AccountId, Container_Summ_Alternative.ObjectId, Container_Summ.ObjectId, 0) AS AccountId
            , 0 AS ContainerId_Transit -- Счет Транзит, определим позже
              -- с/с1 - для количества: приход на остаток
            , SUM (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0)
                       * CASE WHEN vbUnitId_HistoryCost > 0 AND vbUnitId_HistoryCost <> vbUnitId_To THEN 0.2 ELSE 1 END
                        AS NUMERIC (16,4))) AS OperSumm
              -- с/с2 - для количества: контрагента
            , SUM (CAST (_tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0)
                       * CASE WHEN vbUnitId_HistoryCost > 0 AND vbUnitId_HistoryCost <> vbUnitId_To THEN 0.2 ELSE 1 END
                        AS NUMERIC (16,4))) AS OperSumm_Partner
        FROM _tmpItem
             -- так находим для тары
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItem.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis_To
                                                                                 -- AND lfContainerSumm_20901.BusinessId        = _tmpItem.BusinessId_To -- !!!пока не понятно с проводками по Бизнесу!!!
                                                                                 AND _tmpItem.InfoMoneyDestinationId         = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                                                                                 AND _tmpItem.isTareReturning                = FALSE
             -- так находим для остальных
             LEFT JOIN _tmpList_Alternative ON _tmpList_Alternative.ContainerId_Goods = _tmpItem.ContainerId_Goods
             LEFT JOIN Container AS Container_Summ_Alternative ON Container_Summ_Alternative.Id = _tmpList_Alternative.ContainerId_Summ_Alternative
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId = zc_Container_Summ()
                                                  AND Container_Summ_Alternative.Id IS NULL
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = CASE WHEN vbUnitId_HistoryCost > 0 AND vbUnitId_HistoryCost <> vbUnitId_To
                                                                      AND (vbOperDate < '01.01.2022' OR vbOperDatePartner < '01.01.2022')
                                                                     THEN 0
                                                                     WHEN (vbUnitId_HistoryCost > 0 AND vbUnitId_HistoryCost <> vbUnitId_To)
                                                                     THEN Container_Summ_Alternative.Id
                                                                     ELSE COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ_Alternative.Id, Container_Summ.Id) -- HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                                                END
                                   AND CASE WHEN DATE_TRUNC ('MONTH', vbOperDatePartner) < DATE_TRUNC ('MONTH', vbOperDate)
                                            -- !!!
                                            --AND inUserId <> 5
                                                 THEN vbOperDatePartner
                                            --WHEN vbOperDatePartner < vbOperDate AND 1=0
                                            --     THEN vbOperDatePartner
                                            ELSE vbOperDate
                                       END BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND vbIsHistoryCost= TRUE -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
          AND (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) <> 0                -- здесь нули !!!НЕ НУЖНЫ!!!
            OR _tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0) <> 0)       -- здесь нули !!!НЕ НУЖНЫ!!!
          AND vbPartnerId_To = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
          AND AccountId_SummIn_60000  = 0 -- !!!если НЕ "виртуальная" прибыль текущего периода!!!
          AND AccountId_SummOut_60000 = 0 -- !!!если НЕ "виртуальная" прибыль текущего периода!!!
          AND (vbUnitId_HistoryCost <> vbUnitId_To  -- !!!И!!! если признак НЕ установлен сам в себя
            OR vbBranchId_To <> zc_Branch_Basis()   -- !!!ИЛИ!!! это НЕ "Главный" филиал
              )
        GROUP BY _tmpItem.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , _tmpList_Alternative.ContainerId_Summ
               , Container_Summ_Alternative.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId
       UNION ALL
        SELECT
              _tmpItem.MovementItemId
            , 0 AS ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с1 - с/с2)
            , 0 AS ContainerId_ProfitLoss_10800 -- Счет - прибыль (ОПиУ - Себестоимость возвратов : с/с2)
            , COALESCE (Container_Summ.Id, 0)       AS ContainerId
            , COALESCE (Container_Summ.ObjectId, 0) AS AccountId

            , 0 AS ContainerId_Transit -- Счет Транзит, определим позже

              -- с/с1 - для количества: приход на остаток
            , _tmpItem.OperSumm_51201 AS OperSumm
              -- с/с2 - для количества: контрагента
            , _tmpItem.OperSumm_51201 AS OperSumm_ChangePercent
        FROM _tmpItem
             -- так находим
             LEFT JOIN Container AS Container_Summ ON Container_Summ.Id = vbContainerId_51201
        WHERE _tmpItem.OperSumm_51201 <> 0
       ;
/*
    RAISE EXCEPTION 'Ошибка.<%>   <%>', (select sum (_tmpItemSumm.OperSumm) from _tmpItemSumm where _tmpItemSumm.MovementItemId = 289519917   ) -- 290865618
    , (select max (HistoryCost.Id)
            FROM _tmpItem
             -- так находим для тары
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItem.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis_To
                                                                                 -- AND lfContainerSumm_20901.BusinessId        = _tmpItem.BusinessId_To -- !!!пока не понятно с проводками по Бизнесу!!!
                                                                                 AND _tmpItem.InfoMoneyDestinationId         = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                                                                                 AND _tmpItem.isTareReturning                = FALSE
             -- так находим для остальных
             LEFT JOIN _tmpList_Alternative ON _tmpList_Alternative.ContainerId_Goods = _tmpItem.ContainerId_Goods
             LEFT JOIN Container AS Container_Summ_Alternative ON Container_Summ_Alternative.Id = _tmpList_Alternative.ContainerId_Summ_Alternative
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId = zc_Container_Summ()
                                                  AND Container_Summ_Alternative.Id IS NULL
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = CASE WHEN vbUnitId_HistoryCost > 0 AND vbUnitId_HistoryCost <> vbUnitId_To
                                                                      AND (vbOperDate < '01.01.2022' OR vbOperDatePartner < '01.01.2022')
                                                                     THEN 0
                                                                     WHEN (vbUnitId_HistoryCost > 0 AND vbUnitId_HistoryCost <> vbUnitId_To)
                                                                     THEN Container_Summ_Alternative.Id
                                                                     ELSE COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ_Alternative.Id, Container_Summ.Id) -- HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                                                END
                                   AND CASE WHEN DATE_TRUNC ('MONTH', vbOperDatePartner) < DATE_TRUNC ('MONTH', vbOperDate)
                                            -- !!!
                                            --AND inUserId <> 5
                                                 THEN vbOperDatePartner
                                            --WHEN vbOperDatePartner < vbOperDate AND 1=0
                                            --     THEN vbOperDatePartner
                                            ELSE vbOperDate
                                       END BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate

            where _tmpItem.MovementItemId = 290865618 -- 290865618 
)
    ;*/

     -- для филиалов вытянуть с/с РК
     IF COALESCE (vbBranchId_To, 0) NOT IN (0, zc_Branch_Basis())
        AND EXISTS (SELECT 1 FROM _tmpItem LEFT JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId WHERE _tmpItemSumm.MovementItemId IS NULL)
     THEN
         -- добавили новые ContainerId
         INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10800, ContainerId, AccountId, ContainerId_Transit, OperSumm, OperSumm_Partner)
            SELECT
                  _tmpItem.MovementItemId
                , 0 AS ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с1 - с/с2)
                , 0 AS ContainerId_ProfitLoss_10800 -- Счет - прибыль (ОПиУ - Себестоимость возвратов : с/с2)
                  -- нашли только один
                , COALESCE (MAX (COALESCE (Container.Id, 0)), 0) AS ContainerId
                , 0 AS AccountId

                , 0 AS ContainerId_Transit -- Счет Транзит, определим позже

                  -- с/с1 - для количества: приход на остаток
                , 0 AS OperSumm
                  -- с/с2 - для количества: контрагента
                , 0 AS OperSumm_Partner

            FROM _tmpItem
                 LEFT JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
                 -- найдем любой ОДИН
                 LEFT JOIN Container ON Container.ParentId = _tmpItem.ContainerId_Goods
                                    AND Container.DescId   = zc_Container_Summ()
                 -- эту статью нельзя
                 INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                ON CLO_InfoMoney.ContainerId = Container.Id
                                               AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                               AND CLO_InfoMoney.ObjectId    <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                 -- эту статью нельзя
                 INNER JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                ON CLO_InfoMoneyDetail.ContainerId = Container.Id
                                               AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                               AND CLO_InfoMoneyDetail.ObjectId    <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                 -- эти счета нельзя
                 LEFT JOIN ObjectLink AS ObjectLink_AccountGroup ON ObjectLink_AccountGroup.ObjectId      = Container.ObjectId
                                                                AND ObjectLink_AccountGroup.DescId        = zc_ObjectLink_Account_AccountGroup()
                                                                -- Прибыль будущих периодов + Транзит
                                                                AND ObjectLink_AccountGroup.ChildObjectId IN (zc_Enum_AccountGroup_60000()
                                                                                                            , zc_Enum_AccountGroup_110000()
                                                                                                             )

            WHERE _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
              -- если не был найден стандартный
              AND _tmpItemSumm.MovementItemId IS NULL
              -- находим по другим счетам
              AND ObjectLink_AccountGroup.ObjectId IS NULL
              -- !!!временно, пока только с поиском, потом прикрутим Insert!!!
              AND Container.Id > 0

            GROUP BY _tmpItem.MovementItemId
           ;


         -- если все еще не нашли - ОШИБКА
         IF EXISTS (SELECT 1 FROM _tmpItemSumm WHERE _tmpItemSumm.ContainerId = 0)
            AND 1=0
         THEN
             RAISE EXCEPTION 'Ошибка.Не нашли ячейку (ContainerId) для сохранения с/с.%Товар = <%>.%Вид = <%>.%Документ № <%> от <%>.'
                            , CHR (13)
                            , lfGet_Object_ValueData ((SELECT _tmpItem.GoodsId FROM _tmpItemSumm LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId WHERE _tmpItemSumm.ContainerId = 0 ORDER BY _tmpItemSumm.MovementItemId ASC LIMIT 1))
                            , CHR (13)
                            , lfGet_Object_ValueData ((SELECT _tmpItem.GoodsKindId FROM _tmpItemSumm LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId WHERE _tmpItemSumm.ContainerId = 0 ORDER BY _tmpItemSumm.MovementItemId ASC LIMIT 1))
                            , CHR (13)
                            , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                            , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                             ;
         END IF;

         -- с/с РК
         UPDATE _tmpItemSumm SET -- с/с1 - для количества: приход на остаток
                                 OperSumm               = CAST (tmpList.OperCount * tmpList.Price
                                                              * CASE WHEN vbUnitId_HistoryCost > 0 AND vbUnitId_HistoryCost <> vbUnitId_To THEN 0.2 ELSE 1 END
                                                                AS NUMERIC (16,4))
                                 -- с/с2 - для количества: контрагента
                               , OperSumm_Partner       = CAST (tmpList.OperCount_Partner * tmpList.Price
                                                              * CASE WHEN vbUnitId_HistoryCost > 0 AND vbUnitId_HistoryCost <> vbUnitId_To THEN 0.2 ELSE 1 END
                                                                AS NUMERIC (16,4))

         FROM (WITH tmpList AS (SELECT DISTINCT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                FROM _tmpItem
                                     JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
                                                      -- !!!только для НОВЫХ!!!
                                                      AND _tmpItemSumm.AccountId      = 0
                               )
             , tmpPrice_all AS (SELECT tmpList.GoodsId
                                     , tmpList.GoodsKindId
                                     , COALESCE (CLO_PartionGoods.ObjectId, 0)   AS PartionGoodsId
                                     , SUM (COALESCE (HistoryCost.Price, 0))     AS Price
                                     , SUM (COALESCE (HistoryCost_old.Price, 0)) AS Price_old
                                FROM tmpList
                                     INNER JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ObjectId = tmpList.GoodsId
                                                                                AND CLO_Goods.DescId   = zc_ContainerLinkObject_Goods()
                                     INNER JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = CLO_Goods.ContainerId
                                                                                    AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                                                                    AND CLO_GoodsKind.ObjectId    = tmpList.GoodsKindId
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = CLO_Goods.ContainerId
                                                                                      AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                     INNER JOIN Container ON Container.Id      = CLO_Goods.ContainerId
                                                         AND Container.DescId = zc_Container_Summ()
                                     INNER JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = CLO_Goods.ContainerId
                                                                               AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                               -- !!!Только Розподільчий комплекс!!!
                                                                               AND CLO_Unit.ObjectId    = 8459
                                     LEFT JOIN ObjectLink AS ObjectLink_AccountGroup ON ObjectLink_AccountGroup.ObjectId      = Container.ObjectId
                                                                                    AND ObjectLink_AccountGroup.DescId        = zc_ObjectLink_Account_AccountGroup()
                                                                                    -- Прибыль будущих периодов + Транзит
                                                                                    AND ObjectLink_AccountGroup.ChildObjectId IN (zc_Enum_AccountGroup_60000()
                                                                                                                                , zc_Enum_AccountGroup_110000()
                                                                                                                                 )
                                    LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container.Id
                                                         AND CASE WHEN DATE_TRUNC ('MONTH', vbOperDatePartner) < DATE_TRUNC ('MONTH', vbOperDate)
                                                                  -- !!!
                                                                  --AND inUserId <> 5
                                                                       THEN vbOperDatePartner
                                                                  --WHEN vbOperDatePartner < vbOperDate AND 1=0
                                                                  --     THEN vbOperDatePartner
                                                                  ELSE vbOperDate
                                                             END BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate

                                    LEFT JOIN HistoryCost AS HistoryCost_old
                                                          ON HistoryCost_old.ContainerId = Container.Id
                                                         AND (DATE_TRUNC ('MONTH', CASE WHEN vbOperDatePartner < vbOperDate AND 1=0
                                                                                             THEN vbOperDatePartner
                                                                                        ELSE vbOperDate
                                                                                   END) - INTERVAL '1 MONTH')
                                                             BETWEEN HistoryCost_old.StartDate AND HistoryCost_old.EndDate
                                -- находим по другим счетам
                                WHERE ObjectLink_AccountGroup.ObjectId IS NULL
                                GROUP BY tmpList.GoodsId
                                       , tmpList.GoodsKindId
                                       , COALESCE (CLO_PartionGoods.ObjectId, 0)
                               )
                 , tmpPrice AS (SELECT tmpPrice_all.GoodsId
                                     , tmpPrice_all.GoodsKindId
                                     , tmpPrice_all.PartionGoodsId
                                     , tmpPrice_all.Price
                                     , tmpPrice_all.Price_old
                                       -- № п/п
                                     , ROW_NUMBER() OVER (PARTITION BY tmpPrice_all.GoodsId, tmpPrice_all.GoodsKindId ORDER BY tmpPrice_all.Price     DESC) AS Ord
                                     , ROW_NUMBER() OVER (PARTITION BY tmpPrice_all.GoodsId, tmpPrice_all.GoodsKindId ORDER BY tmpPrice_all.Price_old DESC) AS Ord_old
                                FROM tmpPrice_all
                               )
               --
               SELECT _tmpItem.MovementItemId
                    , CASE WHEN tmpPrice.Price > 0 THEN tmpPrice.Price WHEN tmpPrice_old.Price_old > 0 THEN tmpPrice_old.Price_old ELSE 0 END AS Price
                    , _tmpItem.OperCount
                    , _tmpItem.OperCount_Partner

               FROM _tmpItem
                    LEFT JOIN tmpPrice ON tmpPrice.GoodsId     = _tmpItem.GoodsId
                                      AND tmpPrice.GoodsKindId = _tmpItem.GoodsKindId
                                      AND tmpPrice.Ord         = 1
                    LEFT JOIN tmpPrice AS tmpPrice_old
                                       ON tmpPrice_old.GoodsId     = _tmpItem.GoodsId
                                      AND tmpPrice_old.GoodsKindId = _tmpItem.GoodsKindId
                                      AND tmpPrice_old.Ord_old     = 1
               WHERE tmpPrice.GoodsId > 0 OR tmpPrice_old.GoodsId > 0
              ) AS tmpList

         -- !!!только для НОВЫХ!!!
         WHERE _tmpItemSumm.AccountId      = 0
           AND _tmpItemSumm.MovementItemId = tmpList.MovementItemId
        ;


         -- нашли AccountId
         UPDATE _tmpItemSumm SET AccountId = Container.ObjectId
         FROM Container
         WHERE Container.Id = _tmpItemSumm.ContainerId
           AND _tmpItemSumm.AccountId = 0
        ;


     END IF; -- для филиалов вытянуть с/с РК

IF inUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.<%>   %', (select sum (_tmpItemSumm.OperSumm) from _tmpItemSumm where _tmpItemSumm.ContainerId = 5172691)
, (select count(*) from _tmpItemSumm where _tmpItemSumm.ContainerId = 5172691)
;
END IF;

     -- 1.3.1.2. определяется ContainerId - Транзит
     UPDATE _tmpItemSumm SET ContainerId_Transit = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                     , inUnitId                 := _tmpItemSumm_find.UnitId
                                                                                     , inCarId                  := _tmpItemSumm_find.CarId
                                                                                     , inMemberId               := _tmpItemSumm_find.MemberId
                                                                                     , inBranchId               := vbBranchId_To -- эта аналитика нужна для филиала
                                                                                     , inJuridicalId_basis      := _tmpItemSumm_find.JuridicalId_Basis
                                                                                     , inBusinessId             := _tmpItemSumm_find.BusinessId
                                                                                     , inAccountId              := vbAccountId_GoodsTransit
                                                                                     , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                     , inInfoMoneyId            := _tmpItemSumm_find.InfoMoneyId
                                                                                     , inInfoMoneyId_Detail     := _tmpItemSumm_find.InfoMoneyId_Detail
                                                                                     , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit
                                                                                     , inGoodsId                := _tmpItemSumm_find.GoodsId
                                                                                     , inGoodsKindId            := _tmpItemSumm_find.GoodsKindId
                                                                                     , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                     , inPartionGoodsId         := _tmpItemSumm_find.PartionGoodsId
                                                                                     , inAssetId                := _tmpItemSumm_find.AssetId
                                                                                      )
     FROM (WITH _tmpItemSumm_find AS (SELECT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId FROM _tmpItemSumm)
              , tmpCLO AS (SELECT * FROM ContainerLinkObject WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT _tmpItemSumm_find.ContainerId FROM _tmpItemSumm_find))
           SELECT _tmpItemSumm_find.MovementItemId
                , _tmpItemSumm_find.ContainerId

                , CLO_Unit.ObjectId            AS UnitId
                , CLO_Car.ObjectId             AS CarId
                , CLO_Member.ObjectId          AS MemberId
                , CLO_JuridicalBasis.ObjectId  AS JuridicalId_Basis
                , CLO_Business.ObjectId        AS BusinessId
                , CLO_InfoMoney.ObjectId       AS InfoMoneyId
                , CLO_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail
                , CLO_Goods.ObjectId           AS GoodsId
                , CLO_GoodsKind.ObjectId       AS GoodsKindId
                , CLO_PartionGoods.ObjectId    AS PartionGoodsId
                , CLO_Asset.ObjectId           AS AssetId
                
           FROM _tmpItemSumm_find
                LEFT JOIN tmpCLO AS CLO_JuridicalBasis ON CLO_JuridicalBasis.ContainerId = _tmpItemSumm_find.ContainerId
                                                                   AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                LEFT JOIN tmpCLO AS CLO_Business ON CLO_Business.ContainerId = _tmpItemSumm_find.ContainerId
                                                             AND CLO_Business.DescId = zc_ContainerLinkObject_Business()
                LEFT JOIN tmpCLO AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = _tmpItemSumm_find.ContainerId
                                                              AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                LEFT JOIN tmpCLO AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = _tmpItemSumm_find.ContainerId
                                                                    AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                LEFT JOIN tmpCLO AS CLO_Goods ON CLO_Goods.ContainerId = _tmpItemSumm_find.ContainerId
                                                          AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                LEFT JOIN tmpCLO AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpItemSumm_find.ContainerId
                                                              AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                LEFT JOIN tmpCLO AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpItemSumm_find.ContainerId
                                                                 AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                LEFT JOIN tmpCLO AS CLO_Asset ON CLO_Asset.ContainerId = _tmpItemSumm_find.ContainerId
                                                          AND CLO_Asset.DescId = zc_ContainerLinkObject_AssetTo()
                LEFT JOIN tmpCLO AS CLO_Unit ON CLO_Unit.ContainerId = _tmpItemSumm_find.ContainerId
                                                         AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                LEFT JOIN tmpCLO AS CLO_Car ON CLO_Car.ContainerId = _tmpItemSumm_find.ContainerId
                                                        AND CLO_Car.DescId = zc_ContainerLinkObject_Car()
                LEFT JOIN tmpCLO AS CLO_Member ON CLO_Member.ContainerId = _tmpItemSumm_find.ContainerId
                                                     AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
           WHERE vbAccountId_GoodsTransit <> 0
          ) AS _tmpItemSumm_find
          INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm_find.MovementItemId
     WHERE _tmpItemSumm.MovementItemId = _tmpItemSumm_find.MovementItemId
       AND _tmpItemSumm.ContainerId    = _tmpItemSumm_find.ContainerId
       AND vbAccountId_GoodsTransit <> 0
    ;


     -- 1.3.2. формируются Проводки для суммового учета (c/c остаток) + !!!есть MovementItemId!!!
        WITH tmpMIContainer AS
            (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit
                  , zc_Enum_AnalyzerId_ReturnInSumm_10800() AS AnalyzerId -- Сумма с/с, возврат, от покупателя
                  , 0 AS ParentId
                  , _tmpItemSumm.OperSumm_Partner AS Amount
                  , TRUE                          AS isActive
             FROM _tmpItemSumm
             WHERE _tmpItemSumm.OperSumm_Partner <> 0 -- !!!нулевые не нужны!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit
                  , zc_Enum_AnalyzerId_ReturnInSumm_40200() AS AnalyzerId -- Сумма с/с, возврат, Разница в весе
                  , 0 AS ParentId
                  , (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner) AS Amount
                  , TRUE                                                    AS isActive
             FROM _tmpItemSumm
             WHERE (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner <> 0) -- !!!нулевые не нужны!!!
            )
     -- проводки: AnalyzerId <> 0 всегда, ContainerId_Analyzer <> 0 тогда попадает в отчеты покупателя, иначе "виртуальная" (т.е. AccountId <> 0, AnalyzerId <> 0, ContainerId_Analyzer = 0)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId
            , tmpMIContainer.AccountId                AS AccountId                -- счет есть всегда
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!аналитика есть всегда!!! (даже если через транзит, она нужна для склада)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- если это транзит, тогда в реализацию за vbOperDate не попадет
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- если это транзит, тогда в реализацию за vbOperDate попадет 2 раза с + и -
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount
            , vbOperDate -- т.е. по "Дате склад"
            , tmpMIContainer.isActive
       FROM tmpMIContainer
            INNER JOIN _tmpItem ON _tmpItem.MovementItemId = tmpMIContainer.MovementItemId

     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_Transit
            , vbAccountId_GoodsTransit                AS AccountId                -- есть счет (т.е. в отчетах определяется "транзит") + он такой же как у проводки кол-ва
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!аналитика есть всегда!!! (даже для "виртуальной")
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- т.е. в реализацию попадет "реальная" за vbOperDatePartner
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- т.е. в реализацию попадет "реальная" за vbOperDatePartner + за vbOperDate попадет 2 раза с + и -
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItem.ContainerId_GoodsTransit       AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END AS Amount -- "виртуальная" с обратным знаком
            , tmpOperDate.OperDate -- !!!две проводки за разные даты!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN NOT isActive ELSE isActive END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN _tmpItem ON vbAccountId_GoodsTransit <> 0
            INNER JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = _tmpItem.MovementItemId

     UNION ALL
       -- это необычная проводка - !!!прибыль текущего периода!!! по ценам ПРАЙСА zc_PriceList_Basis - кол-во у Покупателя
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , CASE WHEN tmp.mySign > 0 THEN _tmpItem.ContainerId_SummIn_60000 ELSE _tmpItem.ContainerId_SummOut_60000 END AS ContainerId
            , CASE WHEN tmp.mySign > 0 THEN _tmpItem.AccountId_SummIn_60000   ELSE _tmpItem.AccountId_SummOut_60000   END AS AccountId  -- счет есть всегда
            , zc_Enum_AnalyzerId_ReturnInSumm_10800()  AS AnalyzerId               -- Сумма с/с, возврат, от покупателя -- !!!аналитика есть всегда!!! (она нужна для склада)
            , _tmpItem.GoodsId                         AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                 AS WhereObjectId_Analyzer
            , vbContainerId_Analyzer                   AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                     AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                   AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItem.ContainerId_Goods               AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                        AS ParentId
            , tmp.mySign * _tmpItem.OperSumm_PriceList AS Amount
            , vbOperDate                               AS OperDate -- т.е. по "Дате склад"
            , tmp.isActive                             AS isActive
       FROM (SELECT 1 AS mySign, TRUE AS isActive UNION SELECT -1 AS mySign, FALSE AS isActive) AS tmp
             INNER JOIN _tmpItem ON AccountId_SummIn_60000 <> 0 OR AccountId_SummOut_60000 <> 0
     UNION ALL
       -- это необычная проводка - !!!прибыль текущего периода!!! по ценам ПРАЙСА zc_PriceList_Basis - кол-во Склад
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , CASE WHEN tmp.mySign > 0 THEN _tmpItem.ContainerId_SummIn_60000 ELSE _tmpItem.ContainerId_SummOut_60000 END AS ContainerId
            , CASE WHEN tmp.mySign > 0 THEN _tmpItem.AccountId_SummIn_60000   ELSE _tmpItem.AccountId_SummOut_60000   END AS AccountId  -- счет есть всегда
            , zc_Enum_AnalyzerId_ReturnInSumm_40200()  AS AnalyzerId               -- Сумма с/с, возврат, Разница в весе-- !!!аналитика есть всегда!!! (она нужна для склада)
            , _tmpItem.GoodsId                         AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                 AS WhereObjectId_Analyzer
            , vbContainerId_Analyzer                   AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                     AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                   AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItem.ContainerId_Goods               AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                        AS ParentId
            , tmp.mySign * (_tmpItem.OperSumm_PriceList_real - _tmpItem.OperSumm_PriceList) AS Amount
            , vbOperDate                               AS OperDate -- т.е. по "Дате склад"
            , tmp.isActive                             AS isActive
       FROM (SELECT 1 AS mySign, TRUE AS isActive UNION SELECT -1 AS mySign, FALSE AS isActive) AS tmp
             INNER JOIN _tmpItem ON AccountId_SummIn_60000 <> 0 OR AccountId_SummOut_60000 <> 0
      ;

/*
if inUserId = 5
then
    RAISE EXCEPTION 'Ошибка 2.<%> %   %'
, (select (_tmpItem.OperSumm_PriceList_real ) from _tmpItem where _tmpItem.MovementItemId = 188899816)
, (select ( _tmpItem.OperSumm_PriceList) from _tmpItem where _tmpItem.MovementItemId = 188899816)
, (select ( _tmpItem.OperCount) from _tmpItem where _tmpItem.MovementItemId = 188899816)
;
end if;
*/
     -- 2.0. создаем контейнеры для Проводки - Прибыль
     UPDATE _tmpItemPartnerTo SET ContainerId_ProfitLoss_10700 = _tmpItem_byDestination.ContainerId_ProfitLoss_10700 -- Счет - прибыль (ОПиУ - Сумма возвратов)
                                , ContainerId_ProfitLoss_10800 = _tmpItem_byDestination.ContainerId_ProfitLoss_10800 -- Счет - прибыль (ОПиУ - Себестоимость возвратов)
     FROM _tmpItem
          JOIN
          (SELECT -- для Сумма возвратов
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_PriceList
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss_10700
                  -- для учета себестоимости возвратов
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss_10800
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_To
           FROM (SELECT -- определяем ProfitLossId_PriceList - для учета суммы возвратов
                        CASE WHEN _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10702() -- Сумма возвратов + Ирна
                             ELSE zc_Enum_ProfitLoss_10701() -- Сумма возвратов + Продукция
                        END AS ProfitLossId_PriceList

                        -- определяем ProfitLossId_Partner - для учета себестоимости возвратов
                      , CASE WHEN _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10802() -- Себестоимость возвратов + Ирна
                             ELSE zc_Enum_ProfitLoss_10801() -- Себестоимость возвратов + Продукция
                        END AS ProfitLossId_Partner

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_To
                 FROM (SELECT DISTINCT
                              _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_To
                       FROM (SELECT  DISTINCT
                                     _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_To
                                   , CASE WHEN 1=0 AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                             FROM _tmpItemPartnerTo
                                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerTo.MovementItemId
                            ) AS _tmpItem

                      ) AS _tmpItem_group

                ) AS _tmpItem_byProfitLoss

          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BusinessId_To = _tmpItem.BusinessId_To
     WHERE _tmpItemPartnerTo.MovementItemId = _tmpItem.MovementItemId;


     -- 2.1. создаем контейнеры для Проводки - Прибыль
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_40208 = _tmpItem_byDestination.ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с1 - с/с2)
                           , ContainerId_ProfitLoss_10800 = _tmpItem_byDestination.ContainerId_ProfitLoss_10800 -- Счет - прибыль (ОПиУ - Себестоимость возвратов : с/с2)
     FROM _tmpItem
          JOIN
          (SELECT -- для учета разница в весе : с/с1 - с/с2
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_CountChange
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss_40208
                  -- для учета себестоимости возвратов : с/с2
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss_10800
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_To
           FROM (SELECT -- определяем ProfitLossId_CountChange - для учета разница в весе : с/с1 - с/с2
                        CASE WHEN vbIsCorporate_From = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_40208() -- Содержание филиалов + Разница в весе
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_40208() -- Содержание филиалов + Разница в весе

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_CountChange

                        -- определяем ProfitLossId_Partner - для учета себестоимости возвратов : с/с2
                      , CASE WHEN vbIsCorporate_From = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10802() -- Себестоимость возвратов + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10801() -- Себестоимость возвратов + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_To
                 FROM (SELECT DISTINCT
                              CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                              END AS ProfitLossGroupId

                            , CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossDirection_10800() -- Результат основной деятельности + Себестоимость возвратов
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70110() -- Дополнительная прибыль + Возвраты от наших компаний
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossDirection_10800() -- Результат основной деятельности + Себестоимость возвратов
                                   WHEN vbMemberId_From <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- !!!ошибка!!! Дополнительная прибыль + Физ.лица (возмещение ущерба)
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- Дополнительная прибыль + Прочее
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_To
                            , _tmpItem.ProfitLossId_Corporate
                       FROM (SELECT  DISTINCT
                                     _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_To
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                          --WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                          --     THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- Алан
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70111() -- Возвраты от наших компаний + Ирна
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70112() -- Возвраты от наших компаний + Чапли
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- Дворкин
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- ЕКСПЕРТ-АГРОТРЕЙД
                                     END AS ProfitLossId_Corporate
                             FROM _tmpItemSumm
                                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
                            ) AS _tmpItem

                      ) AS _tmpItem_group

                ) AS _tmpItem_byProfitLoss

          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BusinessId_To = _tmpItem.BusinessId_To
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 2.2. формируются Проводки - Прибыль (Себестоимость) + !!!нет MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId                -- прибыль текущего периода
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- аналитика, но значение = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer     -- в ОПиУ не нужен
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0 AS ParentId
            , -1 * _tmpItem_group.OperSumm
            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "Дате покупателя"
            , FALSE
       FROM -- Проводки по разнице в весе : с/с1 - с/с2
            (SELECT _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_40200()       AS AnalyzerId -- Сумма с/с, возврат, Разница в весе
                  , SUM (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_40208, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            UNION ALL
             -- Проводки по себестоимости возвратов : с/с2
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10800 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10800()       AS AnalyzerId -- Сумма с/с, возврат, от покупателя
                  , SUM (_tmpItemSumm.OperSumm_Partner)       AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10800, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId

            -- !!!если возврат от Контрагента -> Контрагенту!!!
            UNION ALL
             -- Проводки по себестоимости реализации : От Кого
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10800 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10800()       AS AnalyzerId --  Сумма с/с, возврат, у покупателя
                  , 1 * SUM (_tmpItemSumm.OperSumm_Partner)   AS OperSumm
             FROM _tmpItemPartnerTo AS _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10800, _tmpItemSumm.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            UNION ALL
             -- Проводки по себестоимости реализации : Кому
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10800 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10800()       AS AnalyzerId --  Сумма с/с, возврат, у покупателя
                  , -1 * SUM (_tmpItemSumm.OperSumm_Partner)  AS OperSumm
             FROM _tmpItemPartnerTo AS _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10800, _tmpItemSumm.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!нулевые не нужны!!!
       ;


     -- 3.3. формируются Проводки - долг Покупателя или Физ.лица (подотчетные лица) + !!!добавлен MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_group.MovementItemId
            , _tmpItem_group.ContainerId_Partner
            , CASE WHEN tmpTransit.AccountId > 0 THEN tmpTransit.AccountId ELSE _tmpItem_group.AccountId_Partner END AS AccountId -- счет есть всегда
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- аналитика
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- Товар
             , vbWhereObjectId_Analyzer               AS WhereObjectId_Analyzer   -- Подраделение или...
            , _tmpItem_group.ContainerId_Partner      AS ContainerId_Analyzer     -- тот же самый
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm * CASE WHEN tmpTransit.AccountId = zc_Enum_AnalyzerId_SummIn_110101() THEN 1 ELSE -1 END AS Amount
            , tmpTransit.OperDate                     AS OperDate                 -- т.е. по "определенной" Дате
            , tmpTransit.isActive                     AS isActive                 -- FALSE будет всегда, остальные зависят от даты
       FROM (SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_ReturnInSumm_10700() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_PriceList) AS OperSumm
                  , FALSE AS isActive
             FROM _tmpItem
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
             -- !!!нельзя ограничивать, т.к. на этих проводках строятся отчеты!!!
             -- HAVING SUM (_tmpItem.OperSumm_Partner) <> 0
           UNION ALL
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_ReturnInSumm_10200() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_PriceList) AS OperSumm
                  , FALSE AS isActive
             FROM _tmpItem
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
             HAVING SUM (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_PriceList) <> 0 -- !!!можно ограничить!!!

           UNION ALL
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_ReturnInSumm_10300() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) AS OperSumm
                  , FALSE AS isActive
             FROM _tmpItem
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
             HAVING SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) <> 0 -- !!!можно ограничить!!!

           -- !!!если возврат от Контрагента -> Контрагенту!!!
           UNION ALL
             SELECT _tmpItemPartnerTo.MovementItemId, _tmpItemPartnerTo.ContainerId_Partner, _tmpItemPartnerTo.AccountId_Partner, _tmpItemPartnerTo.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, zc_Enum_AnalyzerId_ReturnInSumm_10700() AS AnalyzerId
                  , -1 * SUM (_tmpItemPartnerTo.OperSumm_Partner) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItemPartnerTo
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerTo.MovementItemId
             GROUP BY _tmpItemPartnerTo.MovementItemId, _tmpItemPartnerTo.ContainerId_Partner, _tmpItemPartnerTo.AccountId_Partner, _tmpItemPartnerTo.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
             -- !!!нельзя ограничивать, т.к. на этих проводках строятся отчеты!!!
             -- HAVING SUM (_tmpItemPartnerTo.OperSumm_Partner) <> 0

            ) AS _tmpItem_group
            LEFT JOIN (SELECT -1                                  AS AccountId, FALSE AS isActive, CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AccountId, FALSE AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AccountId, FALSE AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AccountId, TRUE  AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AccountId, TRUE  AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit <> 0
                      ) AS tmpTransit ON tmpTransit.AccountId <> 0

     UNION ALL
       -- это !!!одна!!! проводка для "забалансового" Валютного счета
       SELECT 0, zc_MIContainer_SummCurrency() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_group.ContainerId_Currency
            , _tmpItem_group.AccountId_Partner    AS AccountId
            , 0                                   AS AnalyzerId
            , 0                                   AS ObjectId_Analyzer
            , 0                                   AS WhereObjectId_Analyzer
            , _tmpItem_group.ContainerId_Currency AS ContainerId_Analyzer
            , 0                                   AS ObjectIntId_Analyzer     -- !!!нет!!!
            , 0                                   AS ObjectExtId_Analyzer     -- !!!нет!!!
            , 0                                   AS ContainerIntId_Analyzer  -- !!!нет!!!
            , 0 AS ParentId
            , -1 * _tmpItem_group.OperSumm
            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "определенной" Дате
            , TRUE AS isActive
       FROM (SELECT _tmpItem.ContainerId_Currency, _tmpItem.AccountId_Partner, SUM (_tmpItem.OperSumm_Currency) AS OperSumm FROM _tmpItem WHERE _tmpItem.ContainerId_Currency <> 0 GROUP BY _tmpItem.ContainerId_Currency, _tmpItem.AccountId_Partner
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!ограничение - пустые проводки не формируются!!!
     ;


     -- 4.1.1. создаем контейнеры для Проводки - Прибыль (Сумма возвратов)
     UPDATE _tmpItem SET ContainerId_ProfitLoss_10700 = _tmpItem_byDestination.ContainerId_ProfitLoss_10700
     FROM (SELECT -- для Сумма возвратов
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss_10700
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_To
           FROM (SELECT -- определяем ProfitLossId_Partner - для Сумма возвратов
                        CASE WHEN vbIsCorporate_From = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10702() -- Сумма возвратов + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10701() -- Сумма возвратов + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner
                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_To
                 FROM (SELECT DISTINCT
                              -- здесь !!!тоже!!! что и для с/с (но из с/с нельзя брать т.к. может быть что с/с=0)
                              CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                              END AS ProfitLossGroupId

                              -- здесь !!!другое!!! (в THEN) чем для с/с
                            , CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossDirection_10700() -- Результат основной деятельности + Сумма возвратов
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70110() -- Дополнительная прибыль + Возвраты от наших компаний
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossDirection_10700() -- Результат основной деятельности + Сумма возвратов
                                   WHEN vbMemberId_From <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- !!!ошибка!!! Дополнительная прибыль + сотрудники (недостачи, порча)
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- Дополнительная прибыль + Прочее
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_To
                            , _tmpItem.ProfitLossId_Corporate
                       FROM (SELECT  DISTINCT
                                     _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_To
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                          --WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                          --     THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- Алан
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70111() -- Возвраты от наших компаний + Ирна
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70112() -- Возвраты от наших компаний + Чапли
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- Дворкин
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- ЕКСПЕРТ-АГРОТРЕЙД
                                     END AS ProfitLossId_Corporate
                             FROM _tmpItem
                             -- !!!нельзя ограничивать, т.к. проводки для отчета будем делать всегда!!!
                             -- WHERE _tmpItem.OperSumm_Partner <> 0 OR _tmpItem.OperSumm_Partner_ChangePercent <> 0
                            ) AS _tmpItem

                      ) AS _tmpItem_group

                ) AS _tmpItem_byProfitLoss

          ) AS _tmpItem_byDestination

     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byDestination.InfoMoneyDestinationId
       AND _tmpItem.BusinessId_To = _tmpItem_byDestination.BusinessId_To;

     -- 4.1.2. формируются Проводки - Прибыль (Сумма возвратов) + !!!нет MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId                -- прибыль текущего периода
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- аналитика, но значение = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer     -- в ОПиУ не нужен
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0 AS ParentId
            , _tmpItem_group.OperSumm
            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "Дате покупателя"
            , FALSE
       FROM  -- Сумма возвратов
            (SELECT _tmpItem.ContainerId_ProfitLoss_10700 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                      AS GoodsId
                  , _tmpItem.GoodsKindId                  AS GoodsKindId
                  , 0                                     AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10700()   AS AnalyzerId -- Сумма, возврат, от покупателя
                  , SUM (_tmpItem.OperSumm_Partner)       AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10700, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            UNION ALL
             -- Сумма возвратов
             SELECT _tmpItem.ContainerId_ProfitLoss_10700 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                      AS GoodsId
                  , _tmpItem.GoodsKindId                  AS GoodsKindId
                  , 0                                     AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10300()   AS AnalyzerId -- Сумма, возврат, Скидка дополнительная
                  , SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10700, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            -- !!!если возврат от Контрагента -> Контрагенту!!!
            UNION ALL
             -- Сумма возвратов Кому
             SELECT _tmpItemPartnerTo.ContainerId_ProfitLoss_10700 AS ContainerId_ProfitLoss
                  , _tmpItemPartnerTo.ContainerId_Goods   AS ContainerId_Goods
                  , _tmpItem.GoodsId                      AS GoodsId
                  , _tmpItem.GoodsKindId                  AS GoodsKindId
                  , 0                                     AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10700()   AS AnalyzerId -- Сумма, возврат, от покупателя
                  , -1 * SUM (_tmpItemPartnerTo.OperSumm_Partner) AS OperSumm
             FROM _tmpItemPartnerTo
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerTo.MovementItemId
             GROUP BY _tmpItemPartnerTo.ContainerId_ProfitLoss_10700, _tmpItemPartnerTo.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!ограничение - пустые проводки не формируются!!!
       ;


     /*-- убрал, т.к. св-во пишется теперь в ОПиУ
     DELETE FROM MovementItemLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementItemId IN (SELECT MovementItemId FROM _tmpItem);
     DELETE FROM MovementLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementId = inMovementId;*/
     -- !!!6.0.1. формируются свойства в элементах документа из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), _tmpItem.MovementItemId, vbBranchId_To)
     FROM _tmpItem;
     -- !!!6.0.2. формируются свойство связь с <филиал> в документе из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inMovementId, vbBranchId_To);
     -- !!!6.0.3. формируются свойства в элементах документа из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Business(), _tmpItem.MovementItemId, _tmpItem.BusinessId_To)
     FROM _tmpItem;
     -- !!!6.0.4. формируется свойство <zc_MIFloat_Summ - Сумма> + <zc_MIFloat_SummPriceList - Сумма по прайсу>!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), _tmpItem.MovementItemId, _tmpItem.OperSumm_Partner)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPriceList(), _tmpItem.MovementItemId, _tmpItem.OperSumm_PriceList)
     FROM _tmpItem;


     -- !!!6.0.5. синхронизируем zc_MI_Master и zc_MI_Child!!!
     UPDATE MovementItem SET ObjectId = tmp.ObjectId
                           , isErased = tmp.isErased
     FROM (SELECT MI_Master.Id, MI_Master.ObjectId, MI_Master.isErased FROM MovementItem AS MI_Master WHERE MI_Master.MovementId = inMovementId AND MI_Master.DescId = zc_MI_Master()
          ) AS tmp
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.ParentId   = tmp.Id
       AND (MovementItem.ObjectId  <> tmp.ObjectId
         OR MovementItem.isErased  <> tmp.isErased)
      ;

     -- 6.0.6. формируется - Экспедитор из "Заявка сторонняя от покупателя"
     PERFORM lpUpdate_Movement_ReturnIn_MemberExp (inMovementId := inMovementId
                                                 , inUserId     := inUserId
                                                  );

     -- 6.0.7. формируется -
     PERFORM lpInsertUpdate_MovementItem_Detail_auto (inMovementId:= inMovementId, inUserId:= inUserId);


     -- 6.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();


     -- 6.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ReturnIn()
                                , inUserId     := inUserId
                                 );

-- !!! ВРЕМЕННО !!!
 IF inUserId = 5 and 1=0 THEN
    RAISE EXCEPTION 'Admin - Test = OK : %   %', vbOperSumm_Partner_ChangePercent_byItem, vbOperSumm_Partner_ChangePercent
      ;
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.12.19         * add GoodsKindId в прайс
 18.12.14                                        * all
 08.11.14                                        * add _tmpList_Alternative
 07.09.14                                        * add zc_ContainerLinkObject_Branch to vbPartnerId_From
 05.09.14                                        * add zc_ContainerLinkObject_Branch to Физ.лица (подотчетные лица)
 02.09.14                                        * add vbIsHistoryCost
 23.08.14                                        * add vbPartnerId_From
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 12.08.14                                        * add !!!Виртуальные контейнеры!!!
 22.07.14                                        * add ...Price
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 04.05.14                                        * rem zc_Enum_AccountDirection_30400
 30.04.14                                        22:40 09.08.2023* set lp
 16.04.14                                        * err vbInfoMoneyDestinationId_To on 3.1. определяется Счет(справочника) для проводок по долг Покупателя или Физ.лица (недостачи, порча)
 08.04.14                                        * add Constant_InfoMoney_isCorporate_View
 08.04.14                                        * изменился алгоритм для vbIsCorporate_From
 08.04.14                                        * add !!!нельзя ограничивать, т.к. проводки для отчета будем делать всегда!!!
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 18.03.14                                        * add zc_Enum_InfoMoneyDestination_30200
 01.02.14                                        *
*/

/*
     UPDATE MovementItem SET ObjectId = tmp.ObjectId
                           , isErased = tmp.isErased
     FROM (SELECT MI_Child.Id, MI_Master.ObjectId, MI_Master.isErased
           FROM Movement
                inner JOIN MovementItem AS MI_Child
                                        ON MI_Child.MovementId = Movement .Id
                                       AND MI_Child.DescId = zc_MI_Child()
                inner JOIN MovementItem AS MI_Master ON MI_Master.Id = MI_Child.ParentId
                                                   and (MI_Master.ObjectId <> MI_Child.ObjectId
                                                     or MI_Master.isErased <> MI_Child.isErased)
           where Movement .DescId = zc_Movement_ReturnIn()
          ) AS tmp
     WHERE MovementItem.Id   = tmp.Id
*/
-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ReturnIn (inMovementId:= 602578, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')

-- select gpComplete_All_Sybase(    25743210  ,  false    , '')
-- select gpComplete_All_Sybase(    29901793  ,  false    , '')
