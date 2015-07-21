-- Function: lpComplete_Movement_Sale (Integer, Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer               , -- Пользователь
    IN inIsLastComplete    Boolean  DEFAULT False  -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementId_Tax Integer;

  DECLARE vbIsHistoryCost Boolean; -- нужны проводки с/с для этого пользователя

  DECLARE vbContainerId_Analyzer Integer;
  DECLARE vbContainerId_Analyzer_PartnerFrom Integer;
  DECLARE vbWhereObjectId_Analyzer Integer;
  DECLARE vbAccountId_GoodsTransit Integer;

  DECLARE vbMovementDescId Integer;

  DECLARE vbOperSumm_PriceList_byItem TFloat;
  DECLARE vbOperSumm_PriceList TFloat;
  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Currency_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent_byItem TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent TFloat;
  DECLARE vbOperSumm_Currency TFloat;

  DECLARE vbPriceWithVAT_PriceList Boolean;
  DECLARE vbVATPercent_PriceList TFloat;

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

  DECLARE vbCurrencyDocumentId Integer;
  DECLARE vbCurrencyPartnerId Integer;
  DECLARE vbCurrencyValue TFloat;
  DECLARE vbParValue TFloat;
  DECLARE vbCurrencyPartnerValue TFloat;
  DECLARE vbParPartnerValue TFloat;

  DECLARE vbIsPartionDoc_Branch Boolean;
  DECLARE vbPartionMovementId Integer;
  DECLARE vbPaymentDate TDateTime;
BEGIN

     -- LOCK TABLE ChildReportContainerLink IN SHARE ROW EXCLUSIVE MODE;

     -- !!!временно!!!
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= inMovementId);

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItemSumm;
     -- !!!обязательно!!! очистили таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = zc_Enum_Role_Admin())
     THEN IF inIsLastComplete = FALSE
          -- !!! нужны еще для Запорожья, понятно что временно!!!
          -- !!! OR 301310 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
          -- !!! нужны еще для Одесса, понятно что временно!!!
          -- !!! OR 8374 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
          THEN vbIsHistoryCost:= TRUE;
          ELSE vbIsHistoryCost:= FALSE;
          END IF;
     ELSE
         -- !!! для остальных тоже нужны проводки с/с!!!
         IF 0 < (SELECT 1 FROM Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide WHERE View_RoleAccessKeyGuide.UserId = inUserId AND View_RoleAccessKeyGuide.BranchId <> 0 GROUP BY View_RoleAccessKeyGuide.BranchId LIMIT 1)
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382)) -- Кладовщик Днепр
         THEN vbIsHistoryCost:= FALSE;
         ELSE vbIsHistoryCost:= TRUE;
         END IF;
     END IF;


     -- Эти параметры нужны для 
     SELECT lfObject_PriceList.PriceWithVAT, lfObject_PriceList.VATPercent
       INTO vbPriceWithVAT_PriceList, vbVATPercent_PriceList
     FROM lfGet_Object_PriceList (zc_PriceList_Basis()) AS lfObject_PriceList;


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту или Сотуднику и для формирования Аналитик в проводках
     SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent

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
          , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_From -- Аналитики счетов - направления !!!нужны только для подразделения!!!
          , COALESCE (ObjectBoolean_PartionDate.ValueData, FALSE) AS isPartionDate_Unit

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_PartnerFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id ELSE 0 END, 0) AS PartnerId_From
          , COALESCE (MovementLinkObject_PaidKindFrom.ObjectId, 0) AS PaidKindId_From
          , COALESCE (MovementLinkObject_ContractFrom.ObjectId, 0) AS ContractId_From
            -- УП Статью назначения берем: ВСЕГДА по договору
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

            -- УП Статью назначения берем: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
          , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_To -- COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0)) AS InfoMoneyId_To

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Juridical.ChildObjectId WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_ContractFrom_JuridicalBasis.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Business.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId_From

          , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
          , COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())  AS CurrencyPartnerId
          , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                               AS CurrencyValue
          , COALESCE (MovementFloat_ParValue.ValueData, 0)                                    AS ParValue
          , COALESCE (MovementFloat_CurrencyPartnerValue.ValueData, 0)                        AS CurrencyPartnerValue
          , COALESCE (MovementFloat_ParPartnerValue.ValueData, 0)                             AS ParPartnerValue

            INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
               , vbMovementDescId, vbOperDate, vbOperDatePartner
               , vbUnitId_From, vbMemberId_From, vbBranchId_From, vbIsPartionDoc_Branch, vbAccountDirectionId_From, vbIsPartionDate_Unit
               , vbJuridicalId_From, vbPartnerId_From, vbPaidKindId_From, vbContractId_From, vbInfoMoneyId_From
               , vbJuridicalId_To, vbIsCorporate_To, vbInfoMoneyId_CorporateTo, vbPartnerId_To , vbMemberId_To, vbInfoMoneyId_To
               , vbPaidKindId, vbContractId
               , vbJuridicalId_Basis_From, vbBusinessId_From
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

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
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
                              AND ObjectLink_PartnerFrom_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!
                              AND Object_From.DescId = zc_Object_Partner()

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
                              AND ObjectLink_Partner_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!
                              AND Object_To.DescId = zc_Object_Partner()
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

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_Sale()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- определяется "Партионный учет долгов нал"
     IF vbIsPartionDoc_Branch = TRUE 
     THEN
         -- определяется
         vbPaymentDate:= (SELECT tmp.OperDate + (tmp.OperDate - zfCalc_DetermentPaymentDate (COALESCE (Object_ContractCondition_View.ContractConditionKindId, 0), COALESCE (Value, 0) :: Integer, tmp.OperDate))
                          FROM (SELECT vbOperDatePartner AS OperDate) AS tmp
                               LEFT JOIN Object_ContractCondition_View
                                      ON Object_ContractCondition_View.ContractId = vbContractId
                                     AND Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                                     AND Object_ContractCondition_View.Value <> 0
                         );
         -- проверка
         IF vbPaymentDate IS NULL OR vbPaymentDate < vbOperDatePartner
         THEN
             RAISE EXCEPTION 'Ошибка.В договоре не определены условия отсрочки.(%)', vbPaymentDate;
         END IF;
                    
         -- определяется
         vbPartionMovementId:= lpInsertFind_Object_PartionMovement (inMovementId, vbPaymentDate);

     END IF;

     -- определяется Управленческие назначения, параметр нужен для для формирования Аналитик в проводках (для Покупателя)
     SELECT View_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_From FROM lfGet_Object_InfoMoney (vbInfoMoneyId_From) AS View_InfoMoney;
     SELECT View_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_To FROM lfGet_Object_InfoMoney (vbInfoMoneyId_To) AS View_InfoMoney;

     -- !!!Если нет филиала для "основной деятельности", тогда это "главный филиал"
     IF COALESCE (vbBranchId_From, 0) = 0
        /*vbInfoMoneyDestinationId_To IN (zc_Enum_InfoMoneyDestination_30100() -- Продукция
                                      , zc_Enum_InfoMoneyDestination_30200() -- Мясное сырье
                                       )
        AND vbBranchId_From = 0*/
     THEN
         vbBranchId_From:= zc_Branch_Basis();
     END IF;


     -- заполняем таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, ContainerId_GoodsPartner, ContainerId_GoodsTransit, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperCount_ChangePercent, OperCount_Partner, tmpOperSumm_PriceList, OperSumm_PriceList, tmpOperSumm_Partner, tmpOperSumm_Partner_Currency, tmpOperSumm_Partner_original, OperSumm_Partner, OperSumm_Partner_ChangePercent, OperSumm_Currency, OperSumm_80103
                         , ContainerId_ProfitLoss_10100, ContainerId_ProfitLoss_10200, ContainerId_ProfitLoss_10300, ContainerId_ProfitLoss_80103
                         , ContainerId_Partner, ContainerId_Currency, AccountId_Partner, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_From
                         , isPartionCount, isPartionSumm, isTareReturning, isLossMaterials
                         , PartionGoodsId
                         , PriceListPrice, Price, Price_Currency, Price_original, CountForPrice)
        SELECT
              _tmp.MovementItemId
            , 0 AS ContainerId_Goods
            , 0 AS ContainerId_GoodsPartner
            , 0 AS ContainerId_GoodsTransit -- Счет - кол-во Транзит
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate

            , _tmp.OperCount
            , _tmp.OperCount_ChangePercent
            , _tmp.OperCount_Partner
              -- промежуточная (в ценах док-та) сумма прайс-листа по Контрагенту !!!без скидки!!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_PriceList
              -- конечная сумма прайс-листа по Контрагенту !!! без скидки !!!
            , CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                      -- если цены с НДС или %НДС=0, тогда ничего не делаем
                      THEN _tmp.tmpOperSumm_PriceList
                   WHEN vbVATPercent_PriceList > 0
                      -- если цены без НДС, тогда получаем сумму с НДС
                      THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmp.tmpOperSumm_PriceList AS NUMERIC (16, 2))
              END AS OperSumm_PriceList

              -- промежуточная (в ценах док-та) сумма по Контрагенту !!!почти без скидки(т.е. учтена если надо)!!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_Partner
              -- промежуточная (в ценах док-та) сумма по Контрагенту !!!почти без скидки(т.е. учтена если надо)!!! - с округлением до 2-х знаков !!!в валюте!!!
            , _tmp.tmpOperSumm_Partner_Currency
              -- промежуточная (в ценах док-та) сумма по Контрагенту !!!без скидки!!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_Partner_original

              -- конечная сумма по Контрагенту !!!без скидки!!!
            , CAST
             (CASE WHEN vbPriceWithVAT = TRUE  OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда ничего не делаем
                      THEN _tmp.tmpOperSumm_Partner_original
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда получаем сумму с НДС
                      THEN CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_original AS NUMERIC (16, 2))
              END   -- так переводится в валюту zc_Enum_Currency_Basis
                  -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
              AS NUMERIC (16, 2)) AS OperSumm_Partner -- !!!результат!!!


              -- конечная сумма по Контрагенту
            , CAST
             (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН скидка/наценка учтена в цене!!!
                      THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН скидка/наценка учтена в цене!!!
                      THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
              END   -- так переводится в валюту zc_Enum_Currency_Basis
                  -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
              AS NUMERIC (16, 2)) AS OperSumm_Partner_ChangePercent  -- !!!результат!!!

              -- конечная сумма в валюте по Контрагенту
            , CAST
             (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН скидка/наценка учтена в цене!!!
                      THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                                WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner_Currency
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН скидка/наценка учтена в цене!!!
                      THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner_Currency) AS NUMERIC (16, 2))
                           END
              END   -- так переводится в валюту CurrencyPartnerId
                  * CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue /  vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
              AS NUMERIC (16, 2)) AS OperSumm_Currency -- !!!результат!!!

            , 0 AS OperSumm_80103

              -- Счет - прибыль (ОПиУ - Сумма реализации)
            , 0 AS ContainerId_ProfitLoss_10100
              -- Счет - прибыль (ОПиУ - Скидка по акциям)
            , 0 AS ContainerId_ProfitLoss_10200
              -- Счет - прибыль (ОПиУ - Скидка дополнительная)
            , 0 AS ContainerId_ProfitLoss_10300
              -- Счет - прибыль (ОПиУ - Курсовая разница)
            , 0 AS ContainerId_ProfitLoss_80103

              -- Счет - долг Контрагента
            , 0 AS ContainerId_Partner
              -- Счет - долг Контрагента в валюте
            , 0 AS ContainerId_Currency
              -- Счет(справочника) Контрагента
            , 0 AS AccountId_Partner 
              -- Управленческие назначения
            , _tmp.InfoMoneyDestinationId
              -- Статьи назначения
            , _tmp.InfoMoneyId

              -- значение Бизнес !!!выбирается!!! из Товара или Подраделения/Сотрудника
            , CASE WHEN _tmp.BusinessId_From = 0 THEN vbBusinessId_From ELSE _tmp.BusinessId_From END AS BusinessId_From

            , _tmp.isPartionCount
            , _tmp.isPartionSumm 

              -- Возвратная ли это тара (если да, себестоимость остается на остатке)
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                        THEN TRUE
                   ELSE FALSE
              END AS isTareReturning

              -- Списание Прочее сырье ли это (если да, то в проводках будет zc_Enum_AnalyzerId_Loss...)
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20600() -- 10200; "Прочее сырье"
                        THEN TRUE
                   ELSE FALSE
              END AS isLossMaterials

              -- Партии товара, сформируем позже
            , 0 AS PartionGoodsId


            , _tmp.PriceListPrice
            , _tmp.Price
            , _tmp.Price_Currency
            , _tmp.Price_original
            , _tmp.CountForPrice

        FROM 
             (SELECT
                    tmpMI.MovementItemId
                  , tmpMI.GoodsId
                  , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN tmpMI.GoodsKindId ELSE 0 END AS GoodsKindId -- Ирна + Готовая продукция + Доходы Мясное сырье
                  , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                  , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate
 
                  , lfObjectHistory_PriceListItem.ValuePrice AS PriceListPrice
                  , tmpMI.Price
                  , tmpMI.Price_original
                  , tmpMI.Price_Currency
                  , tmpMI.CountForPrice
                    -- количество для склада
                  , tmpMI.OperCount
                    -- количество с учетом % скидки
                  , tmpMI.OperCount_ChangePercent
                    -- количество у контрагента
                  , tmpMI.OperCount_Partner

                    -- промежуточная сумма прайс-листа по Контрагенту - с округлением до 2-х знаков
                  , COALESCE (CAST (tmpMI.OperCount_Partner * lfObjectHistory_PriceListItem.ValuePrice AS NUMERIC (16, 2)), 0) AS tmpOperSumm_PriceList
                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков + учтена скидка в цене (!!!если надо!!!)
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner
                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков + учтена скидка в цене (!!!если надо!!!) !!!в валюте!!!
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price_Currency / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price_Currency AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner_Currency
                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков + !!!НЕ!!! учтена скидка в цене
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price_original AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner_original

                    -- Управленческие назначения
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- Статьи назначения
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- Бизнес из Товара
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_From

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm

              FROM
             (SELECT MovementItemId
                   , GoodsId
                   , GoodsKindId

                   , OperCount
                   , OperCount_ChangePercent
                   , OperCount_Partner
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
                       , tmpMI.Price AS Price_Currency
                   , CountForPrice
              FROM
             (SELECT (MovementItem.Id) AS MovementItemId
                   , MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                   , SUM (MovementItem.Amount) AS OperCount
                   , SUM (COALESCE (MIFloat_AmountChangePercent.ValueData, 0)) AS OperCount_ChangePercent
                   , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS OperCount_Partner
                   , CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                               THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                               THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END AS Price
                   , COALESCE (MIFloat_Price.ValueData, 0) AS Price_original
                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

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
              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Sale()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
              GROUP BY MovementItem.Id
                     , MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
             ) AS tmpMI
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
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                   LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= vbOperDatePartner)
                          AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = tmpMI.GoodsId
             ) AS _tmp;


     -- проверка
     IF COALESCE (vbContractId, 0) = 0 AND (EXISTS (SELECT _tmpItem.isTareReturning FROM _tmpItem WHERE _tmpItem.isTareReturning = FALSE))
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор>.Проведение невозможно.';
     END IF;


     -- !!!
     -- IF NOT EXISTS (SELECT MovementItemId FROM _tmpItem) THEN RETURN; END IF;


     -- Расчеты сумм
     SELECT -- Расчет Итоговой суммы прайс-листа по Контрагенту
            CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_PriceList
                 WHEN vbVATPercent_PriceList > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmpItem.tmpOperSumm_PriceList AS NUMERIC (16, 2))
            END AS OperSumm_PriceList

            -- Расчет Итоговой суммы по Контрагенту !!!без скидки!!!
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_Partner_original
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_original AS NUMERIC (16, 2))
            END   -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_Partner  -- !!!результат!!!

            -- Расчет Итоговой суммы по Контрагенту
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END   -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_Partner_ChangePercent  -- !!!результат!!!

            -- Расчет Итоговой суммы в валюте по Контрагенту
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner_Currency
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                         END
            END   -- так переводится в валюту CurrencyPartnerId
                * CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue /  vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
            AS NUMERIC (16, 2)) AS OperSumm_Currency  -- !!!результат!!!

            INTO vbOperSumm_PriceList, vbOperSumm_Partner, vbOperSumm_Partner_ChangePercent, vbOperSumm_Currency
     FROM
           -- получили 1 запись
          (SELECT SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_PriceList ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.PriceListPrice AS NUMERIC (16, 2)) END) AS tmpOperSumm_PriceList
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
                      , _tmpItem.Price_original
                      , _tmpItem.Price_Currency
                      , _tmpItem.CountForPrice
                      , SUM (_tmpItem.OperCount_Partner) AS OperCount_Partner
                      , SUM (_tmpItem.tmpOperSumm_PriceList) AS tmpOperSumm_PriceList
                      , SUM (_tmpItem.tmpOperSumm_Partner) AS tmpOperSumm_Partner
                      , SUM (_tmpItem.tmpOperSumm_Partner_original) AS tmpOperSumm_Partner_original
                      , SUM (_tmpItem.tmpOperSumm_Partner_Currency) AS tmpOperSumm_Partner_Currency
                 FROM _tmpItem
                 GROUP BY _tmpItem.PriceListPrice
                        , _tmpItem.Price
                        , _tmpItem.Price_original
                        , _tmpItem.Price_Currency
                        , _tmpItem.CountForPrice
                        , _tmpItem.GoodsId
                        , _tmpItem.GoodsKindId
                ) AS _tmpItem
          ) AS _tmpItem
     ;

     -- Расчет Итоговых сумм по Контрагенту (по элементам)
     SELECT SUM (_tmpItem.OperSumm_PriceList), SUM (_tmpItem.OperSumm_Partner), SUM (_tmpItem.OperSumm_Partner_ChangePercent), SUM (_tmpItem.OperSumm_Currency) INTO vbOperSumm_PriceList_byItem, vbOperSumm_Partner_byItem, vbOperSumm_Partner_ChangePercent_byItem, vbOperSumm_Currency_byItem FROM _tmpItem;

     -- если не равны ДВЕ Итоговые суммы прайс-листа по Контрагенту
     IF COALESCE (vbOperSumm_PriceList, 0) <> COALESCE (vbOperSumm_PriceList_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_PriceList = _tmpItem.OperSumm_PriceList - (vbOperSumm_PriceList_byItem - vbOperSumm_PriceList)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_PriceList IN (SELECT MAX (_tmpItem.OperSumm_PriceList) FROM _tmpItem)
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
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_Currency IN (SELECT MAX (_tmpItem.OperSumm_Currency) FROM _tmpItem)
                                          );
     END IF;


     -- формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbAccountDirectionId_From = zc_Enum_AccountDirection_20200() -- Запасы + на складах
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
                                                 OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
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
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
     ;


     -- формируются данные если продажа от Контрагента -> Контрагенту
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
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 3.0.1. определяется Счет(справочника) для проводок по долг Покупателя !!!если продажа от Контрагента -> Контрагенту!!!
     UPDATE _tmpItemPartnerFrom SET AccountId_Partner = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30100() -- покупатели
                                             , inInfoMoneyDestinationId := vbInfoMoneyDestinationId_From
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
           WHERE EXISTS (SELECT _tmpItemPartnerFrom.AccountId_Partner FROM _tmpItemPartnerFrom)
          ) AS _tmpItem_byAccount
     ;

     -- 3.0.2. определяется ContainerId для проводок по долг Покупателя !!!если продажа от Контрагента -> Контрагенту!!!
     UPDATE _tmpItemPartnerFrom SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
     FROM _tmpItem
          INNER JOIN (SELECT -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
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


     -- 3.1. определяется Счет(справочника) для проводок по долг Покупателя или Физ.лица (подотчетные лица)
     UPDATE _tmpItem SET AccountId_Partner = _tmpItem_byAccount.AccountId
     FROM (SELECT CASE WHEN vbIsCorporate_To = TRUE
                            THEN _tmpItem_group.AccountId_Corporate
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                   END AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbMemberId_To <> 0
                                  THEN zc_Enum_AccountDirection_30500() -- Физ.лица (подотчетные лица)
                             WHEN vbIsCorporate_To = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- наши компании
                             WHEN vbInfoMoneyDestinationId_To IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                , zc_Enum_InfoMoneyDestination_20700()  -- Товары
                                                                , zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                , zc_Enum_InfoMoneyDestination_30100()  -- Продукция
                                                                , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                  THEN CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis() THEN zc_Enum_AccountDirection_30150() ELSE zc_Enum_AccountDirection_30100() END -- покупатели ВЭД OR покупатели
                             WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                    , zc_Enum_InfoMoneyDestination_20700()  -- Товары
                                                                    , zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                    , zc_Enum_InfoMoneyDestination_30100()  -- Продукция
                                                                    , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                  THEN CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis() THEN zc_Enum_AccountDirection_30150() ELSE zc_Enum_AccountDirection_30100() END -- покупатели ВЭД OR покупатели
                          -- ELSE zc_Enum_AccountDirection_30400() -- Прочие дебиторы
                             ELSE CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis() THEN zc_Enum_AccountDirection_30150() ELSE zc_Enum_AccountDirection_30100() END -- покупатели ВЭД OR покупатели
                        END AS AccountDirectionId

                      , CASE WHEN vbIsCorporate_To = TRUE
                                  THEN vbInfoMoneyDestinationId_To -- zc_Enum_InfoMoneyDestination_30100() -- Продукция
                             WHEN vbInfoMoneyDestinationId_To <> 0
                                  THEN vbInfoMoneyDestinationId_To -- УП: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                             WHEN _tmpItem.isTareReturning = TRUE -- !!!Возвратная тара!!!
                               OR _tmpItem.isLossMaterials = TRUE -- !!!Прочее сырье с ценой=0!!!
                                  THEN zc_Enum_InfoMoneyDestination_30100() -- Продукция
                             ELSE _tmpItem.InfoMoneyDestinationId -- иначе берем по товару
                        END AS InfoMoneyDestinationId_calc

                      , _tmpItem.InfoMoneyDestinationId
                      , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30201() -- Алан
                             WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30202() -- Ирна
                             WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30203() -- Чапли
                             WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30204() -- Дворкин
                             WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30205() -- ЕКСПЕРТ-АГРОТРЕЙД
                        END AS AccountId_Corporate
                 FROM _tmpItem
                 WHERE _tmpItem.isTareReturning = FALSE -- !!!Возвратная тара не учавствует!!!
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!нельзя ограничивать, т.к. этот AccountId в проводках для отчета!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId, _tmpItem.isTareReturning, _tmpItem.isLossMaterials
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 3.2.1. определяется ContainerId для проводок по долг Покупателя или Физ.лица (подотчетные лица)
     UPDATE _tmpItem SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
     FROM (SELECT CASE WHEN vbMemberId_To <> 0
                                 -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Физ.лица (подотчетные лица) 2)NULL 3)NULL 4)Статьи назначения
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
                                                       , inObjectId_3        := vbBranchId_From -- долг Подотчета всегда на филиале Склада
                                                       , inDescId_4          := zc_ContainerLinkObject_Car()
                                                       , inObjectId_4        := 0 -- для Физ.лица (подотчетные лица) !!!именно здесь последняя аналитика всегда значение = 0!!!
                                                        )
                            -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
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
                                  THEN vbInfoMoneyId_To -- УП: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                             WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20901 () -- Ирна
                                  THEN zc_Enum_InfoMoney_30101 () -- Готовая продукция
                             ELSE _tmpItem.InfoMoneyId -- иначе берем по товару
                        END AS InfoMoneyId_calc
                 FROM _tmpItem
                 WHERE _tmpItem.isTareReturning = FALSE -- !!!Возвратная тара не учавствует!!!
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!нельзя ограничивать, т.к. этот ContainerId в проводках для отчета!!!
                 GROUP BY _tmpItem.AccountId_Partner
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_group
          ) AS _tmpItem_byInfoMoney
     WHERE _tmpItem.InfoMoneyId = _tmpItem_byInfoMoney.InfoMoneyId
     ;

     -- 3.3. !!!Очень важно - определили здесь vbContainerId_Analyzer для ВСЕХ!!!, если он не один - тогда ошибка
     vbContainerId_Analyzer:= (SELECT ContainerId_Partner FROM _tmpItem WHERE ContainerId_Partner <> 0 GROUP BY ContainerId_Partner);
     -- определили
     vbContainerId_Analyzer_PartnerFrom:= (SELECT ContainerId_Partner FROM _tmpItemPartnerFrom WHERE ContainerId_Partner <> 0 GROUP BY ContainerId_Partner);
     -- определили
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From WHEN vbPartnerId_From <> 0 THEN vbPartnerId_From END;
     -- определили
     vbAccountId_GoodsTransit:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110101() ELSE 0 END; -- Транзит + товар в пути


     -- 1.1.1. определяется ContainerId_GoodsPartner для !!!забалансовой!!! проводки по количественному учету - долги Покупателя или Физ.лица
     UPDATE _tmpItem SET ContainerId_GoodsPartner = -- 0)Товар 1)Покупатель
                                                    -- 0)Товар 1)Физ.лицо
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
                                                                           )
     WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
       AND vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
    ;

     -- 1.1.2. формируются !!!забалансовые!!! Проводки для количественного учета - долги Покупателя или Физ.лица
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_CountSupplier() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_GoodsPartner
            , 0                                       AS AccountId              -- нет счета
            , 0                                       AS AnalyzerId             -- нет аналитики
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , CASE WHEN vbMemberId_To <> 0 THEN vbMemberId_To ELSE vbPartnerId_To END AS WhereObjectId_Analyzer -- Покупатель или Физ.лицо
            , 0                                       AS ContainerId_Analyzer   -- !!!нет!!!
            , 0                                       AS ParentId
            , OperCount                               AS Amountt
            , vbOperDate                              AS OperDate               -- т.е. по "Дате склад"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
         AND vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
      ;


     -- 1.2.0. определяется ContainerId_Goods для количественного учета - !!!если продажа от Контрагента -> Контрагенту!!!
     UPDATE _tmpItemPartnerFrom SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDatePartner -- !!!по "Дате покупателя"!!!
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
     WHERE _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
    ;
     -- 1.2.1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
                , ContainerId_GoodsTransit = CASE WHEN vbAccountId_GoodsTransit <> 0 AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                        THEN lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_From          -- эта аналитика нужна для филиала
                                                                                , inAccountId              := vbAccountId_GoodsTransit -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                        ELSE 0 END
     WHERE vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
    ;

     -- 1.2.2. формируются Проводки для количественного учета (остаток)
        WITH tmpMIContainer AS
            (SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_GoodsTransit
                  , GoodsId
                  , zc_Enum_AnalyzerId_LossCount_20200() AS AnalyzerId -- Кол-во, списание при реализации/перемещении по цене
                  , 0 AS ParentId
                  , -1 * OperCount         AS Amount
                  , FALSE                  AS isActive
             FROM _tmpItem
             WHERE vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
               AND isLossMaterials = TRUE -- !!!если списание!!!
            UNION ALL
             SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_GoodsTransit
                  , GoodsId
                  , CASE WHEN isTareReturning = TRUE THEN 0 ELSE zc_Enum_AnalyzerId_SaleCount_10400() END AS AnalyzerId --  Кол-во, реализация, у покупателя
                  , 0 AS ParentId
                  , -1 * OperCount_Partner AS Amount
                  , FALSE                  AS isActive
             FROM _tmpItem
             -- убрал т.к. хоть одна проводка должна быть (!!!для отчетов!!!)
             -- WHERE OperCount_Partner <> 0
             WHERE vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
               AND isLossMaterials = FALSE -- !!!если НЕ списание!!!
            UNION ALL
             SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_GoodsTransit
                  , GoodsId
                  , CASE WHEN isTareReturning = TRUE THEN 0 ELSE zc_Enum_AnalyzerId_SaleCount_10500() END AS AnalyzerId --  Кол-во, реализация, Скидка за вес
                  , 0 AS ParentId
                  , -1 * (OperCount - OperCount_ChangePercent) AS Amount
                  , FALSE                                      AS isActive
             FROM _tmpItem
             WHERE (OperCount - OperCount_ChangePercent) <> 0  -- !!!нулевые не нужны!!!
               AND isLossMaterials = FALSE -- !!!если НЕ списание!!!
               AND vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
            UNION ALL
             SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_GoodsTransit
                  , GoodsId
                  , CASE WHEN isTareReturning = TRUE THEN 0 ELSE zc_Enum_AnalyzerId_SaleCount_40200() END AS AnalyzerId -- Кол-во, реализация, Разница в весе
                  , 0 AS ParentId
                  , -1 * (OperCount_ChangePercent - OperCount_Partner) AS Amount
                  , FALSE                                              AS isActive
             FROM _tmpItem
             WHERE (OperCount_ChangePercent - OperCount_Partner) <> 0 -- !!!нулевые не нужны!!!
               AND isLossMaterials = FALSE -- !!!если НЕ списание!!!
               AND vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
            )
     -- проводки: AnalyzerId <> 0 всегда, ContainerId_Analyzer <> 0 тогда попадает в отчеты покупателя, иначе "виртуальная" (т.е. AccountId <> 0, AnalyzerId <> 0, ContainerId_Analyzer = 0)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_Goods
            , 0                                       AS AccountId  -- нет счета
            , tmpMIContainer.AnalyzerId               AS AnalyzerId -- !!!аналитика есть всегда!!! (даже если через транзит, она нужна для склада)
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            , CASE WHEN vbAccountId_GoodsTransit <> 0 AND tmpMIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossCount_20200() THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- если это транзит, тогда в реализацию за vbOperDate не попадет
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount
            , vbOperDate -- т.е. по "Дате склад"
            , tmpMIContainer.isActive
       FROM tmpMIContainer

     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_GoodsTransit
            , vbAccountId_GoodsTransit                AS AccountId  -- есть счет (т.е. в отчетах определяется "транзит")
            , tmpMIContainer.AnalyzerId               AS AnalyzerId -- !!!аналитика есть всегда!!! (даже для "виртуальной")
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- т.е. в реализацию попадет "реальная" за vbOperDatePartner
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END AS Amount -- "виртуальная" с обратным знаком
            , tmpOperDate.OperDate -- !!!две проводки за разные даты!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN NOT tmpMIContainer.isActive ELSE tmpMIContainer.isActive END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN tmpMIContainer ON vbAccountId_GoodsTransit <> 0
                                     AND tmpMIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossCount_20200() -- !!!если НЕ списание!!!

     UNION ALL
       -- это обычная проводка - !!!если продажа от Контрагента -> Контрагенту!!!
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItemPartnerFrom.MovementItemId
            , _tmpItemPartnerFrom.ContainerId_Goods
            , 0                                    AS AccountId  -- нет счета
            , zc_Enum_AnalyzerId_SaleCount_10400() AS AnalyzerId -- !!!аналитика есть всегда!!! Кол-во, реализация, у покупателя 
            , _tmpItem.GoodsId                     AS ObjectId_Analyzer
            , CASE WHEN tmpIsActive.isActive = TRUE THEN vbPartnerId_From ELSE vbPartnerId_To END AS WhereObjectId_Analyzer
            , CASE WHEN tmpIsActive.isActive = TRUE THEN vbContainerId_Analyzer_PartnerFrom ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer
            , 0 AS ParentId
            , _tmpItem.OperCount_Partner * CASE WHEN tmpIsActive.isActive = TRUE THEN 1 ELSE -1 END AS Amount
            , vbOperDatePartner -- т.е. по "Дате покупателя"
            , tmpIsActive.isActive
       FROM (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmpIsActive
            INNER JOIN _tmpItem ON _tmpItem.OperCount_Partner <> 0  -- !!!нулевые не нужны!!!
            INNER JOIN _tmpItemPartnerFrom ON _tmpItemPartnerFrom.MovementItemId = _tmpItem.MovementItemId
      ;


     -- 1.2.3. дальше !!!Возвратная тара не учавствует!!!, поэтому удаляем
     DELETE FROM _tmpItem WHERE _tmpItem.isTareReturning = TRUE;

     -- 1.2.4. дальше !!!Прочее сырье с ценой=0 не учавствует!!!, поэтому удаляем (потом это будет документ Списание))
     -- DELETE FROM _tmpItem WHERE _tmpItem.isLossMaterials = TRUE;


     -- 1.3.1.1. самое интересное: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10500, ContainerId_ProfitLoss_10400, ContainerId_ProfitLoss_20200, ContainerId, AccountId, ContainerId_Transit, OperSumm, OperSumm_ChangePercent, OperSumm_Partner, isLossMaterials)
        SELECT
              _tmpItem.MovementItemId
            , 0 AS ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с2 - с/с3)
            , 0 AS ContainerId_ProfitLoss_10500 -- Счет - прибыль (ОПиУ - скидки в весе : с/с1 - с/с2)
            , 0 AS ContainerId_ProfitLoss_10400 -- Счет - прибыль (ОПиУ - себестоимости реализации : с/с3)
            , 0 AS ContainerId_ProfitLoss_20200 -- Счет - прибыль (ОПиУ - Общепроизводственные расходы + Содержание складов)
            , COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0)) AS ContainerId
            , COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) AS AccountId
            , 0 AS ContainerId_Transit -- Счет Транзит, определим позже
              -- с/с1 - для количества: расход с остатка
            , SUM ((_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0))) AS OperSumm
              -- с/с2 - для количества: с учетом % скидки
            , SUM ((_tmpItem.OperCount_ChangePercent * COALESCE (HistoryCost.Price, 0))) AS OperSumm_ChangePercent
              -- с/с3 - для количества: контрагента
            , SUM ((_tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0))) AS OperSumm_Partner
            , _tmpItem.isLossMaterials
        FROM _tmpItem
             -- так находим для тары
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItem.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis_From
                                                                                 -- AND lfContainerSumm_20901.BusinessId        = _tmpItem.BusinessId_From -- !!!пока не понятно с проводками по Бизнесу!!!
                                                                                 AND _tmpItem.InfoMoneyDestinationId         = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                                                                                 AND _tmpItem.isTareReturning                = FALSE
             -- так находим для остальных
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId = zc_Container_Summ()
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id) -- HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND vbIsHistoryCost = TRUE -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
          AND (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) <> 0                 -- !!!
             OR _tmpItem.OperCount_ChangePercent * COALESCE (HistoryCost.Price, 0) <> 0  -- здесь нули !!!НЕ НУЖНЫ!!! 
             OR _tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0) <> 0)       -- !!!
          AND vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
        GROUP BY _tmpItem.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId
               , _tmpItem.isLossMaterials;

     -- 1.3.1.2. определяется ContainerId - Транзит
     UPDATE _tmpItemSumm SET ContainerId_Transit = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                     , inUnitId                 := CLO_Unit.ObjectId
                                                                                     , inCarId                  := CLO_Car.ObjectId
                                                                                     , inMemberId               := CLO_Member.ObjectId
                                                                                     , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                     , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                     , inBusinessId             := CLO_Business.ObjectId
                                                                                     , inAccountId              := vbAccountId_GoodsTransit -- !!!для счета Транзит!!!
                                                                                     , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                     , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                     , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                     , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit -- Счет - кол-во Транзит
                                                                                     , inGoodsId                := CLO_Goods.ObjectId
                                                                                     , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                     , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                     , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                     , inAssetId                := CLO_Asset.ObjectId
                                                                                      )
     FROM _tmpItem
          INNER JOIN _tmpItemSumm AS _tmpItemSumm_find ON _tmpItemSumm_find.MovementItemId = _tmpItem.MovementItemId
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
     WHERE _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
       AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
       AND vbAccountId_GoodsTransit <> 0
    ;


     -- 1.3.2. формируются Проводки для суммового учета (c/c остаток) + !!!есть MovementItemId!!!
        WITH tmpMIContainer AS
            (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit
                  , zc_Enum_AnalyzerId_LossSumm_20200() AS AnalyzerId -- Сумма с/с, списание при реализации/перемещении по цене
                  , 0 AS ParentId
                  , -1 * _tmpItemSumm.OperSumm         AS Amount
                  , FALSE                              AS isActive
             FROM _tmpItemSumm
             WHERE _tmpItemSumm.OperSumm <> 0 -- !!!нулевые не нужны!!!
               AND _tmpItemSumm.isLossMaterials = TRUE -- !!!если списание!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit
                  , zc_Enum_AnalyzerId_SaleSumm_10400() AS AnalyzerId -- Сумма с/с, реализация, у покупателя
                  , 0 AS ParentId
                  , -1 * _tmpItemSumm.OperSumm_Partner AS Amount
                  , FALSE                              AS isActive
             FROM _tmpItemSumm
             WHERE _tmpItemSumm.OperSumm_Partner <> 0 -- !!!нулевые не нужны!!!
               AND _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit
                  , zc_Enum_AnalyzerId_SaleSumm_10500() AS AnalyzerId --  Сумма с/с, реализация, Скидка за вес 
                  , 0 AS ParentId
                  , -1 * (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS Amount
                  , FALSE                                                              AS isActive
             FROM _tmpItemSumm
             WHERE (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) <> 0  -- !!!нулевые не нужны!!!
               AND _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit
                  , zc_Enum_AnalyzerId_SaleSumm_40200() AS AnalyzerId -- Сумма с/с, реализация, Разница в весе
                  , 0 AS ParentId
                  , -1 * (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS Amount
                  , FALSE                                                                      AS isActive
             FROM _tmpItemSumm
             WHERE (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) <> 0  -- !!!нулевые не нужны!!!
               AND _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
            )
     -- проводки: AnalyzerId <> 0 всегда, ContainerId_Analyzer <> 0 тогда попадает в отчеты покупателя, иначе "виртуальная" (т.е. AccountId <> 0, AnalyzerId <> 0, ContainerId_Analyzer = 0)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId
            , tmpMIContainer.AccountId                AS AccountId  -- счет есть всегда
            , tmpMIContainer.AnalyzerId               AS AnalyzerId -- !!!аналитика есть всегда!!! (даже если через транзит, она нужна для склада)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            , CASE WHEN vbAccountId_GoodsTransit <> 0 AND _tmpItem.isLossMaterials = FALSE THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- если это транзит, тогда в реализацию за vbOperDate не попадет
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
            , vbAccountId_GoodsTransit                AS AccountId  -- есть счет (т.е. в отчетах определяется "транзит") + он такой же как у проводки кол-ва
            , tmpMIContainer.AnalyzerId               AS AnalyzerId -- !!!аналитика есть всегда!!! (даже для "виртуальной")
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- т.е. в реализацию попадет "реальная" за vbOperDatePartner
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END AS Amount -- "виртуальная" с обратным знаком
            , tmpOperDate.OperDate -- !!!две проводки за разные даты!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN NOT isActive ELSE isActive END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN _tmpItem ON vbAccountId_GoodsTransit <> 0
                               AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
            INNER JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = _tmpItem.MovementItemId
      ;


     -- 2.0. создаем контейнеры для Проводки - Прибыль !!!если продажа от Контрагента -> Контрагенту!!!
     UPDATE _tmpItemPartnerFrom SET ContainerId_ProfitLoss_10100 = _tmpItem_byDestination.ContainerId_ProfitLoss_10100 -- Счет - прибыль (ОПиУ - Сумма реализации)
                                  , ContainerId_ProfitLoss_10400 = _tmpItem_byDestination.ContainerId_ProfitLoss_10400 -- Счет - прибыль (ОПиУ - Себестоимости реализации)
     FROM _tmpItem
          JOIN
          (SELECT -- для Сумма реализации
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_PriceList
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10100
                  -- для учета себестоимости реализации 
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
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
           FROM (SELECT -- определяем ProfitLossId_PriceList - для учета суммы реализации
                        CASE WHEN _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10102() -- Сумма реализации + Ирна
                             ELSE zc_Enum_ProfitLoss_10101() -- Сумма реализации + Продукция
                        END AS ProfitLossId_PriceList

                        -- определяем ProfitLossId_Partner - для учета себестоимости реализации
                      , CASE WHEN _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10402() -- Себестоимость реализации + Ирна
                             ELSE zc_Enum_ProfitLoss_10401() -- Себестоимость реализации + Продукция
                        END AS ProfitLossId_Partner

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_From
                 FROM (SELECT _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_From
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_From
                                   , CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
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


     -- 2.1. создаем контейнеры для Проводки - Прибыль
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_40208 = _tmpItem_byDestination.ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с2 - с/с3)
                           , ContainerId_ProfitLoss_10500 = _tmpItem_byDestination.ContainerId_ProfitLoss_10500 -- Счет - прибыль (ОПиУ - скидки в весе : с/с1 - с/с2)
                           , ContainerId_ProfitLoss_10400 = _tmpItem_byDestination.ContainerId_ProfitLoss_10400 -- Счет - прибыль (ОПиУ - себестоимости реализации : с/с3)
                           , ContainerId_ProfitLoss_20200 = _tmpItem_byDestination.ContainerId_ProfitLoss_20200 -- Счет - прибыль (ОПиУ - Общепроизводственные расходы + Содержание складов)
     FROM _tmpItem
          JOIN
          (SELECT -- для учета разница в весе : с/с2 - с/с3
                  CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = TRUE -- !!!если списание!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
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
                  -- для учета скидки в весе : с/с1 - с/с2
                , CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = TRUE -- !!!если списание!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
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
                  -- для учета себестоимости реализации : с/с3
                , CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = TRUE -- !!!если списание!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
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
                  -- для учета себестоимости списания
                , CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
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
           FROM (SELECT -- определяем ProfitLossId_CountChange - для учета разница в весе : с/с2 - с/с3
                        CASE WHEN _tmpItem_group.isLossMaterials = TRUE -- !!!если списание!!!
                                  THEN 0

                             WHEN vbIsCorporate_To = TRUE
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

                        -- определяем ProfitLossId_ChangePercent - для учета скидки в весе : с/с1 - с/с2
                      , CASE WHEN _tmpItem_group.isLossMaterials = TRUE -- !!!если списание!!!
                                  THEN 0

                             WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10502() -- Скидка за вес + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10501() -- Скидка за вес + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_ChangePercent

                        -- определяем ProfitLossId_Partner - для учета себестоимости реализации : с/с3
                      , CASE WHEN _tmpItem_group.isLossMaterials = TRUE -- !!!если списание!!!
                                  THEN 0

                             WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10402() -- Себестоимость реализации + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10401() -- Себестоимость реализации + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner

                        -- определяем ProfitLossId_Loss - для учета себестоимости списания
                      , CASE WHEN _tmpItem_group.isLossMaterials = FALSE -- !!!если НЕ списание!!!
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
                 FROM (SELECT CASE WHEN _tmpItem.isLossMaterials = TRUE -- !!!если списание!!!
                                        THEN zc_Enum_ProfitLossGroup_20000() -- Общепроизводственные расходы
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                              END AS ProfitLossGroupId

                            , CASE WHEN _tmpItem.isLossMaterials = TRUE -- !!!если списание!!!
                                        THEN zc_Enum_ProfitLossDirection_20200() -- Общепроизводственные расходы + Содержание складов
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossDirection_10400() -- Результат основной деятельности + Себестоимость реализации
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70100() -- Дополнительная прибыль + Реализация нашим компаниям
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossDirection_10400() -- Результат основной деятельности + Себестоимость реализации
                                   WHEN vbMemberId_To <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- !!!ошибка!!! Дополнительная прибыль + Физ.лица (возмещение ущерба)
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- Дополнительная прибыль + Прочее
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
                                   , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                          WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- Алан
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70101() -- Ирна
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70102() -- Чапли
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70103() -- Дворкин
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70104() -- ЕКСПЕРТ-АГРОТРЕЙД
                                     END AS ProfitLossId_Corporate
                             FROM _tmpItemSumm
                                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
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
                                     AND _tmpItem_byDestination.BusinessId_From = _tmpItem.BusinessId_From
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 2.2. формируются Проводки - Прибыль (Себестоимость) + !!!нет MovementItemId!!! + !!!добавлен GoodsId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                AS AccountId              -- прибыль текущего периода
            , _tmpItem_group.AnalyzerId               AS AnalyzerId             -- аналитика, но значение = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , CASE WHEN vbAccountId_GoodsTransit <> 0 AND _tmpItem_group.isLossMaterials = FALSE THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "Дате покупателя"
            , FALSE                                   AS isActive
       FROM -- Проводки по разнице в весе : с/с2 - с/с3
            (SELECT _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                  , _tmpItem.GoodsId                          AS GoodsId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_40200()       AS AnalyzerId -- Сумма с/с, реализация, Разница в весе
                  , SUM (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_40208, _tmpItem.GoodsId, _tmpItem.isLossMaterials
            UNION ALL
             -- Проводки по скидкам в весе : с/с1 - с/с2
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10500 AS ContainerId_ProfitLoss
                  , _tmpItem.GoodsId                          AS GoodsId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10500()       AS AnalyzerId -- Сумма с/с, реализация, Скидка за вес
                  , SUM (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10500, _tmpItem.GoodsId, _tmpItem.isLossMaterials
            UNION ALL
             -- Проводки по себестоимости реализации : с/с3
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                  , _tmpItem.GoodsId                          AS GoodsId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10400()       AS AnalyzerId --  Сумма с/с, реализация, у покупателя 
                  , SUM (_tmpItemSumm.OperSumm_Partner)       AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10400, _tmpItem.GoodsId, _tmpItem.isLossMaterials

            UNION ALL
             -- Проводки по списанию
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_20200 AS ContainerId_ProfitLoss
                  , _tmpItem.GoodsId                          AS GoodsId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_LossSumm_20200()       AS AnalyzerId --  Сумма с/с, списание при реализации/перемещении по цене
                  , SUM (_tmpItemSumm.OperSumm)               AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             WHERE _tmpItem.isLossMaterials = TRUE -- !!!если списание!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_20200, _tmpItem.GoodsId, _tmpItem.isLossMaterials

            -- !!!если продажа от Контрагента -> Контрагенту!!!
            UNION ALL
             -- Проводки по себестоимости реализации : От Кого
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                  , _tmpItem.GoodsId                          AS GoodsId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10400()       AS AnalyzerId --  Сумма с/с, реализация, у покупателя 
                  , -1 * SUM (_tmpItemSumm.OperSumm_Partner)  AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemPartnerFrom AS _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10400, _tmpItem.GoodsId, _tmpItem.isLossMaterials
            UNION ALL
             -- Проводки по себестоимости реализации : Кому
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                  , _tmpItem.GoodsId                          AS GoodsId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10400()       AS AnalyzerId --  Сумма с/с, реализация, у покупателя 
                  , 1 * SUM (_tmpItemSumm.OperSumm_Partner)   AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemPartnerFrom AS _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10400, _tmpItem.GoodsId, _tmpItem.isLossMaterials
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!нулевые не нужны!!!
       ;


     -- 3.2.2. определяется ContainerId_Currency для проводок по долг Покупателя или Физ.лица (подотчетные лица)
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
                                  THEN vbInfoMoneyId_To -- УП: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                             WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20901 () -- Ирна
                                  THEN zc_Enum_InfoMoney_30101 () -- Готовая продукция
                             ELSE _tmpItem.InfoMoneyId -- иначе берем по товару
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

     -- 3.3. формируются Проводки - долг Покупателя или Физ.лица (подотчетные лица) + !!!добавлен MovementItemId!!! + !!!добавлен GoodsId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_group.MovementItemId
            , _tmpItem_group.ContainerId_Partner
            , _tmpItem_group.AccountId_Partner   AS AccountId              -- счет есть всегда
            , _tmpItem_group.AnalyzerId          AS AnalyzerId             -- аналитика
            , _tmpItem_group.GoodsId             AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer           AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItem_group.ContainerId_Partner AS ContainerId_Analyzer   -- тот же самый
            , 0                                  AS ParentId
            , _tmpItem_group.OperSumm            AS Amount
            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "определенной" Дате
            , _tmpItem_group.isActive            AS isActive
       FROM (SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.GoodsId
                  -- , CASE WHEN _tmpItem.isLossMaterials = TRUE THEN zc_Enum_AnalyzerId_LossSumm_20200() ELSE zc_Enum_AnalyzerId_SaleSumm_10100() END AS AnalyzerId
                  , zc_Enum_AnalyzerId_SaleSumm_10100() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_PriceList) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItem
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.GoodsId --, _tmpItem.isLossMaterials
             -- !!!нельзя ограничивать, т.к. на этих проводках строятся отчеты!!!
             -- HAVING SUM (_tmpItem.OperSumm_PriceList) <> 0
           UNION ALL
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.GoodsId
                  -- , CASE WHEN _tmpItem.isLossMaterials = TRUE THEN zc_Enum_AnalyzerId_LossSumm_20200() ELSE zc_Enum_AnalyzerId_SaleSumm_10200() END AS AnalyzerId
                  , zc_Enum_AnalyzerId_SaleSumm_10200() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_PriceList) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItem
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.GoodsId --, _tmpItem.isLossMaterials
             HAVING SUM (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_PriceList) <> 0 -- !!!можно ограничить!!!
           UNION ALL
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.GoodsId
                  -- , CASE WHEN _tmpItem.isLossMaterials = TRUE THEN zc_Enum_AnalyzerId_LossSumm_20200() ELSE zc_Enum_AnalyzerId_SaleSumm_10300() END AS AnalyzerId
                  , zc_Enum_AnalyzerId_SaleSumm_10300() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItem
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.GoodsId --, _tmpItem.isLossMaterials
             HAVING SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) <> 0 -- !!!можно ограничить!!!

           -- !!!если продажа от Контрагента -> Контрагенту!!!
           UNION ALL
             SELECT _tmpItemPartnerFrom.MovementItemId, _tmpItemPartnerFrom.ContainerId_Partner, _tmpItemPartnerFrom.AccountId_Partner, _tmpItem.GoodsId, zc_Enum_AnalyzerId_SaleSumm_10100() AS AnalyzerId
                  , -1 * SUM (_tmpItemPartnerFrom.OperSumm_Partner) AS OperSumm
                  , FALSE AS isActive
             FROM _tmpItemPartnerFrom
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
             GROUP BY _tmpItemPartnerFrom.MovementItemId, _tmpItemPartnerFrom.ContainerId_Partner, _tmpItemPartnerFrom.AccountId_Partner, _tmpItem.GoodsId
             -- !!!нельзя ограничивать, т.к. на этих проводках строятся отчеты!!!
             -- HAVING SUM (_tmpItemPartnerFrom.OperSumm_Partner) <> 0

            ) AS _tmpItem_group
     UNION ALL
       -- это !!!одна!!! проводка для "забалансового" Валютного счета
       SELECT 0, zc_MIContainer_SummCurrency() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_group.ContainerId_Currency
            , _tmpItem_group.AccountId_Partner    AS AccountId
            , 0                                   AS AnalyzerId
            , 0                                   AS ObjectId_Analyzer
            , 0                                   AS WhereObjectId_Analyzer
            , _tmpItem_group.ContainerId_Currency AS ContainerId_Analyzer
            , 0 AS ParentId
            , _tmpItem_group.OperSumm
            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "определенной" Дате
            , TRUE AS isActive
       FROM (SELECT _tmpItem.ContainerId_Currency, _tmpItem.AccountId_Partner, SUM (_tmpItem.OperSumm_Currency) AS OperSumm FROM _tmpItem WHERE _tmpItem.ContainerId_Currency <> 0 GROUP BY _tmpItem.ContainerId_Currency, _tmpItem.AccountId_Partner
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!ограничение - пустые проводки не формируются!!!
     ;


     -- 4.1.1. создаем контейнеры для Проводки - Прибыль (Сумма реализации и Скидка по акциям и Скидка дополнительная и Курсовая разница)
     UPDATE _tmpItem SET ContainerId_ProfitLoss_10100 = _tmpItem_byDestination.ContainerId_ProfitLoss_10100
                       , ContainerId_ProfitLoss_10200 = _tmpItem_byDestination.ContainerId_ProfitLoss_10200
                       , ContainerId_ProfitLoss_10300 = _tmpItem_byDestination.ContainerId_ProfitLoss_10300
                       , ContainerId_ProfitLoss_80103 = _tmpItem_byDestination.ContainerId_ProfitLoss_80103
     FROM (SELECT -- для Сумма реализации
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_PriceList
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10100
                  -- для Скидка по акциям
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10200
                  -- для Скидка дополнительная
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_ChangePercent
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10300
                  -- для Курсовая разница
                , CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                       , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                       , inObjectId_1        := zc_Enum_ProfitLoss_80103() -- Расходы с прибыли + Финансовая деятельность + Курсовая разница
                                                       , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                       , inObjectId_2        := vbBranchId_From
                                                        )
                       ELSE 0
                  END AS ContainerId_ProfitLoss_80103
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_From
           FROM (SELECT -- определяем ProfitLossId_PriceList - для Сумма реализации
                        CASE WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10102() -- Сумма реализации + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10101() -- Сумма реализации + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_PriceList

                        -- определяем ProfitLossId_Partner - для Скидка по акциям
                      , CASE WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10202() -- Скидка по акциям + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10201() -- Скидка по акциям + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner

                        -- определяем ProfitLossId_ChangePercent - для Скидка дополнительная
                      , CASE WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  THEN zc_Enum_ProfitLoss_10302() -- Скидка дополнительная + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() --Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10301() -- Скидка дополнительная + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_ChangePercent

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_From
                 FROM (SELECT -- здесь !!!тоже!!! что и для с/с (но из с/с нельзя брать т.к. может быть что с/с=0)
                              CASE WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                              END AS ProfitLossGroupId

                              -- здесь !!!другое!!! (в THEN) чем для с/с
                            , CASE WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossDirection_10100() -- Результат основной деятельности + Сумма реализации
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70100() -- Дополнительная прибыль + Реализация нашим компаниям
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossDirection_10100() -- Результат основной деятельности + Сумма реализации
                                   WHEN vbMemberId_To <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- !!!ошибка!!! Дополнительная прибыль + Физ.лица (возмещение ущерба)
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- Дополнительная прибыль + Прочее
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_From
                            , _tmpItem.ProfitLossId_Corporate
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_From
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                          WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- Алан
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70101() -- Ирна
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70102() -- Чапли
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70103() -- Дворкин
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70104() -- ЕКСПЕРТ-АГРОТРЕЙД
                                     END AS ProfitLossId_Corporate
                             FROM _tmpItem
                             -- !!!нельзя ограничивать, т.к. проводки для отчета будем делать всегда!!!
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

     -- 4.1.2. формируются Проводки - Прибыль (Сумма реализации и Скидка по акциям и Скидка дополнительная) + !!!нет MovementItemId!!! + !!!добавлен GoodsId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId              -- прибыль текущего периода
            , _tmpItem_group.AnalyzerId               AS AnalyzerId             -- аналитика, но значение = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "определенной" Дате
            , FALSE                                   AS isActive
       FROM  -- Сумма реализации
            (SELECT _tmpItem.ContainerId_ProfitLoss_10100  AS ContainerId_ProfitLoss
                  , _tmpItem.GoodsId                       AS GoodsId
                  , 0                                      AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10100()    AS AnalyzerId -- Сумма, реализация, у покупателя
                  , -1 * SUM (_tmpItem.OperSumm_PriceList) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10100, _tmpItem.GoodsId
            UNION ALL
             -- Разница с оптовыми ценами (Скидка по акциям)
             SELECT _tmpItem.ContainerId_ProfitLoss_10200 AS ContainerId_ProfitLoss
                  , _tmpItem.GoodsId                      AS GoodsId
                  , 0                                     AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10200()   AS AnalyzerId --  Сумма, реализация, Разница с оптовыми ценами(акции) 
                  , 1 * SUM (_tmpItem.OperSumm_PriceList - _tmpItem.OperSumm_Partner) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10200, _tmpItem.GoodsId
            UNION ALL
             -- Скидка дополнительная
             SELECT _tmpItem.ContainerId_ProfitLoss_10300 AS ContainerId_ProfitLoss
                  , _tmpItem.GoodsId                      AS GoodsId
                  , 0                                     AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10300()   AS AnalyzerId -- Сумма, реализация, Скидка дополнительная
                  , 1 * SUM (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_Partner_ChangePercent) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10300, _tmpItem.GoodsId
            -- !!!если продажа от Контрагента -> Контрагенту!!!
            UNION ALL
             -- Сумма реализации От Кого
             SELECT _tmpItemPartnerFrom.ContainerId_ProfitLoss_10100 AS ContainerId_ProfitLoss
                  , _tmpItem.GoodsId                      AS GoodsId
                  , 0                                     AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10100()   AS AnalyzerId -- Сумма, реализация, у покупателя
                  , 1 * SUM (_tmpItemPartnerFrom.OperSumm_Partner) AS OperSumm
             FROM _tmpItemPartnerFrom
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
             GROUP BY _tmpItemPartnerFrom.ContainerId_ProfitLoss_10100, _tmpItem.GoodsId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!ограничение - пустые проводки не формируются!!!
      ;

     -- 5.1.1. формируются Проводки для отчета (Счета: Товар(с/с) <-> ОПиУ(разница в весе))
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
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                , _tmpCalc.MovementItemId
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , tmpOperDate.OperDate
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.ContainerId ELSE _tmpCalc_all.ContainerId_Transit END AS ContainerId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.AccountId   ELSE _tmpCalc_all.AccountId_Transit   END AS AccountId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND vbAccountId_GoodsTransit <> 0 THEN _tmpCalc_all.ContainerId_Transit ELSE _tmpCalc_all.ContainerId_ProfitLoss END AS ContainerId_ProfitLoss
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND vbAccountId_GoodsTransit <> 0 THEN _tmpCalc_all.AccountId_Transit   ELSE _tmpCalc_all.AccountId_ProfitLoss   END AS AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit <> 0
                      ) AS tmpOperDate
                      INNER JOIN (SELECT _tmpItemSumm.MovementItemId
                                       , _tmpItemSumm.ContainerId
                                       , _tmpItemSumm.AccountId
                                       , _tmpItemSumm.ContainerId_Transit           AS ContainerId_Transit
                                       , vbAccountId_GoodsTransit                   AS AccountId_Transit
                                       , _tmpItemSumm.ContainerId_ProfitLoss_40208  AS ContainerId_ProfitLoss
                                       , zc_Enum_Account_100301 ()                  AS AccountId_ProfitLoss -- прибыль текущего периода
                                       , (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS OperSumm -- !!!если>0, значит "убыток", т.е. покупателю пришло меньше чем ушло со склада!!!
                                                                                                                           -- п.с. убыток: Active=ContainerId_ProfitLoss а доход: Passive=ContainerId_ProfitLoss
                                  FROM _tmpItemSumm
                                  WHERE _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                 ) AS _tmpCalc_all ON _tmpCalc_all.OperSumm <> 0 -- !!!ограничили, т.к. нулевые не нужны!!!
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     -- 5.1.2. формируются Проводки для отчета (Счета: Товар(с/с) <-> ОПиУ(скидка в весе))
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
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                , _tmpCalc.MovementItemId
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , tmpOperDate.OperDate
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.ContainerId ELSE _tmpCalc_all.ContainerId_Transit END AS ContainerId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.AccountId   ELSE _tmpCalc_all.AccountId_Transit   END AS AccountId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND vbAccountId_GoodsTransit <> 0 THEN _tmpCalc_all.ContainerId_Transit ELSE _tmpCalc_all.ContainerId_ProfitLoss END AS ContainerId_ProfitLoss
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND vbAccountId_GoodsTransit <> 0 THEN _tmpCalc_all.AccountId_Transit   ELSE _tmpCalc_all.AccountId_ProfitLoss   END AS AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit <> 0
                      ) AS tmpOperDate
                      INNER JOIN (SELECT _tmpItemSumm.MovementItemId
                                       , _tmpItemSumm.ContainerId
                                       , _tmpItemSumm.AccountId
                                       , _tmpItemSumm.ContainerId_Transit           AS ContainerId_Transit
                                       , vbAccountId_GoodsTransit                   AS AccountId_Transit
                                       , _tmpItemSumm.ContainerId_ProfitLoss_10500  AS ContainerId_ProfitLoss
                                       , zc_Enum_Account_100301 ()                  AS AccountId_ProfitLoss -- прибыль текущего периода
                                       , (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS OperSumm -- !!!по идее >0, значит "убыток"!!!
                                                                                                                   -- п.с. убыток: Active=ContainerId_ProfitLoss а доход: Passive=ContainerId_ProfitLoss
                                  FROM _tmpItemSumm
                                  WHERE _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                 ) AS _tmpCalc_all ON _tmpCalc_all.OperSumm <> 0 -- !!!ограничили, т.к. нулевые не нужны!!!
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;
     -- 5.1.3. формируются Проводки для отчета (Счета: Товар(с/с) <-> ОПиУ(себестоимость реализации))
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
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                , _tmpCalc.MovementItemId
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , tmpOperDate.OperDate
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.ContainerId ELSE _tmpCalc_all.ContainerId_Transit END AS ContainerId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.AccountId   ELSE _tmpCalc_all.AccountId_Transit   END AS AccountId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND vbAccountId_GoodsTransit <> 0 THEN _tmpCalc_all.ContainerId_Transit ELSE _tmpCalc_all.ContainerId_ProfitLoss END AS ContainerId_ProfitLoss
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND vbAccountId_GoodsTransit <> 0 THEN _tmpCalc_all.AccountId_Transit   ELSE _tmpCalc_all.AccountId_ProfitLoss   END AS AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit <> 0
                      ) AS tmpOperDate
                      INNER JOIN (SELECT _tmpItemSumm.MovementItemId
                                       , _tmpItemSumm.ContainerId
                                       , _tmpItemSumm.AccountId
                                       , _tmpItemSumm.ContainerId_Transit           AS ContainerId_Transit
                                       , vbAccountId_GoodsTransit                   AS AccountId_Transit
                                       , _tmpItemSumm.ContainerId_ProfitLoss_10400  AS ContainerId_ProfitLoss
                                       , zc_Enum_Account_100301 ()                  AS AccountId_ProfitLoss -- прибыль текущего периода
                                       , (_tmpItemSumm.OperSumm_Partner)            AS OperSumm -- !!!по идее >0, значит "убыток"!!!
                                                                                                -- п.с. убыток: Active=ContainerId_ProfitLoss а доход: Passive=ContainerId_ProfitLoss
                                  FROM _tmpItemSumm
                                  WHERE _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                 ) AS _tmpCalc_all ON _tmpCalc_all.OperSumm <> 0 -- !!!ограничили, т.к. нулевые не нужны!!!
                /*-- !!!если продажа от Контрагента -> Контрагенту!!!
                UNION ALL
                 SELECT _tmpItemPartnerFrom.MovementItemId
                      , vbOperDatePartner AS OperDate
                      , _tmpItemPartnerFrom.ContainerId_ProfitLoss_10400 AS ContainerId
                      , zc_Enum_Account_100301 () AS AccountId -- прибыль текущего периода
                      , _tmpItemPartnerFrom.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                      , zc_Enum_Account_100301 () AS AccountId_ProfitLoss -- прибыль текущего периода
                      , _tmpItemPartnerFrom.OperSumm_Partner
                 FROM _tmpItemPartnerFrom
                 WHERE _tmpItemPartnerFrom.OperSumm_Partner <> 0 -- !!!ограничили, т.к. нулевые не нужны!!!
                */
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     -- 5.1.4. формируются Проводки для отчета (Счета: Товар(с/с) <-> ОПиУ (Общепроизводственные расходы + Содержание складов)
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
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                , _tmpCalc.MovementItemId
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , tmpOperDate.OperDate
                      , _tmpCalc_all.ContainerId
                      , _tmpCalc_all.AccountId
                      , _tmpCalc_all.ContainerId_ProfitLoss
                      , _tmpCalc_all.AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT vbOperDate AS OperDate
                      ) AS tmpOperDate
                      INNER JOIN (SELECT _tmpItemSumm.MovementItemId
                                       , _tmpItemSumm.ContainerId
                                       , _tmpItemSumm.AccountId
                                       , _tmpItemSumm.ContainerId_ProfitLoss_20200  AS ContainerId_ProfitLoss
                                       , zc_Enum_Account_100301 ()                  AS AccountId_ProfitLoss -- прибыль текущего периода
                                       , (_tmpItemSumm.OperSumm)                    AS OperSumm -- !!!по идее >0, значит "убыток"!!!
                                                                                                -- п.с. убыток: Active=ContainerId_ProfitLoss а доход: Passive=ContainerId_ProfitLoss
                                  FROM _tmpItemSumm
                                  WHERE _tmpItemSumm.isLossMaterials = TRUE -- !!!если списание!!!
                                 ) AS _tmpCalc_all ON _tmpCalc_all.OperSumm <> 0 -- !!!ограничили, т.к. нулевые не нужны!!!
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     -- 5.2.1. формируются Проводки для отчета (Счета: Юр.лицо(Сумма по прайсу) <-> ОПиУ(сумма реализации)) Аналитики: !!!Товар здесь ЛЮБОЙ из с/с, а если его нет тогда количественный и еще inAccountId_1 НЕ ПРАВИЛЬНЫЙ!!! 
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
                                                                                                             , inAccountKindId_1    := CASE WHEN vbPartnerId_From <> 0 THEN NULL ELSE zc_Enum_AccountKind_All() END
                                                                                                             , inContainerId_1      := CASE WHEN vbPartnerId_From <> 0 THEN NULL ELSE COALESCE (_tmpItemSumm_group.ContainerId, _tmpItem_byProfitLoss.ContainerId_Goods) END
                                                                                                             , inAccountId_1        := CASE WHEN vbPartnerId_From <> 0 THEN NULL ELSE COALESCE (_tmpItemSumm_group.AccountId, zc_Enum_Account_100301 ()) END -- 100301; "прибыль текущего периода"
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "прибыль текущего периода"
                , _tmpCalc.MovementItemId
                , _tmpCalc.ContainerId_Goods
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , _tmpCalc_all.ContainerId_Goods
                      , _tmpCalc_all.OperDate
                      , _tmpCalc_all.ContainerId
                      , _tmpCalc_all.AccountId
                      , _tmpCalc_all.ContainerId_ProfitLoss
                      , _tmpCalc_all.AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT _tmpItem.MovementItemId
                            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "Дате покупателя"
                            , _tmpItem.ContainerId_Goods
                            , _tmpItem.ContainerId_Partner AS ContainerId
                            , _tmpItem.AccountId_Partner   AS AccountId
                            , _tmpItem.ContainerId_ProfitLoss_10100 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301 ()             AS AccountId_ProfitLoss   -- прибыль текущего периода
                            , -1 * _tmpItem.OperSumm_PriceList AS OperSumm -- !!!минус, значит "доход"!!!
                                                                           -- п.с. убыток: Active=ContainerId_ProfitLoss а доход: Passive=ContainerId_ProfitLoss
                       FROM _tmpItem
                      UNION ALL
                       -- !!!если продажа от Контрагента -> Контрагенту!!!
                       SELECT _tmpItem.MovementItemId
                            , vbOperDatePartner AS OperDate -- т.е. по "Дате покупателя"
                            , NULL AS ContainerId_Goods
                            , _tmpItem.ContainerId_Partner AS ContainerId
                            , _tmpItem.AccountId_Partner   AS AccountId
                            , _tmpItem.ContainerId_ProfitLoss_10100 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301 ()             AS AccountId_ProfitLoss   -- прибыль текущего периода
                            , 1 * _tmpItem.OperSumm_Partner AS OperSumm -- !!!минус, значит "доход"!!!
                                                                        -- п.с. убыток: Active=ContainerId_ProfitLoss а доход: Passive=ContainerId_ProfitLoss
                       FROM _tmpItemPartnerFrom AS _tmpItem
                      ) AS _tmpCalc_all
                      -- LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                      --                                                                                                    OR  (tmpOperDate.OperDate = vbOperDatePartner
                      --                                                                                                     AND COALESCE (_tmpCalc_all.AccountId_Transit, 0) <> 0)
                 -- !!!ограничили, т.к. нулевые не нужны!!!
                 -- WHERE _tmpCalc_all.OperSumm <> 0 -- !!!нельзя ограничивать, т.к. проводки для отчета будем делать всегда!!!
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

     -- 5.2.2. формируются Проводки для отчета (Счета: Юр.лицо(Сумма по прайсу "минус" Сумма контрагенту) <-> ОПиУ(Скидка по акциям)) Аналитики: !!!Товар здесь ЛЮБОЙ из с/с, а если его нет тогда количественный и еще inAccountId_1 НЕ ПРАВИЛЬНЫЙ!!! 
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
                                                                                                             , inAccountKindId_1    := CASE WHEN vbPartnerId_From <> 0 THEN NULL ELSE zc_Enum_AccountKind_All() END
                                                                                                             , inContainerId_1      := CASE WHEN vbPartnerId_From <> 0 THEN NULL ELSE COALESCE (_tmpItemSumm_group.ContainerId, _tmpItem_byProfitLoss.ContainerId_Goods) END
                                                                                                             , inAccountId_1        := CASE WHEN vbPartnerId_From <> 0 THEN NULL ELSE COALESCE (_tmpItemSumm_group.AccountId, zc_Enum_Account_100301 ()) END -- 100301; "прибыль текущего периода"
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "прибыль текущего периода"
                , _tmpCalc.MovementItemId
                , _tmpCalc.ContainerId_Goods
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , _tmpCalc_all.ContainerId_Goods
                      , _tmpCalc_all.OperDate
                      , _tmpCalc_all.ContainerId
                      , _tmpCalc_all.AccountId
                      , _tmpCalc_all.ContainerId_ProfitLoss
                      , _tmpCalc_all.AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT _tmpItem.MovementItemId
                            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "Дате покупателя"
                            , _tmpItem.ContainerId_Goods
                            , _tmpItem.ContainerId_Partner AS ContainerId
                            , _tmpItem.AccountId_Partner   AS AccountId
                            , _tmpItem.ContainerId_ProfitLoss_10200 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301 ()             AS AccountId_ProfitLoss   -- прибыль текущего периода
                            , 1 * (_tmpItem.OperSumm_PriceList - _tmpItem.OperSumm_Partner) AS OperSumm -- !!!не минус, значит убыток, т.е. уменьшаем "доход" на скидку!!!
                                                                                                        -- п.с. убыток: Active=ContainerId_ProfitLoss а доход: Passive=ContainerId_ProfitLoss
                       FROM _tmpItem
                      ) AS _tmpCalc_all
                      -- LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                      --                                                                                                   OR  (tmpOperDate.OperDate = vbOperDatePartner
                      --                                                                                                    AND COALESCE (_tmpCalc_all.AccountId_Transit, 0) <> 0)
                 -- !!!ограничили, т.к. нулевые не нужны!!!
                 -- WHERE _tmpCalc_all.OperSumm <> 0 -- !!!нельзя ограничивать, т.к. проводки для отчета будем делать всегда!!!
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

     -- 5.2.3. формируются Проводки для отчета (Счета: Юр.лицо(Сумма контрагента "минус" конечная сумма по Контрагенту) <-> ОПиУ(скидка дополнительная)) Аналитики: !!!Товар здесь ЛЮБОЙ из с/с, а если его нет тогда количественный и еще inAccountId_1 НЕ ПРАВИЛЬНЫЙ!!! 
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
                                                                                                             , inAccountKindId_1    := CASE WHEN vbPartnerId_From <> 0 THEN NULL ELSE zc_Enum_AccountKind_All() END
                                                                                                             , inContainerId_1      := CASE WHEN vbPartnerId_From <> 0 THEN NULL ELSE COALESCE (_tmpItemSumm_group.ContainerId, _tmpItem_byProfitLoss.ContainerId_Goods) END
                                                                                                             , inAccountId_1        := CASE WHEN vbPartnerId_From <> 0 THEN NULL ELSE COALESCE (_tmpItemSumm_group.AccountId, zc_Enum_Account_100301 ()) END -- 100301; "прибыль текущего периода"
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "прибыль текущего периода"
                , _tmpCalc.MovementItemId
                , _tmpCalc.ContainerId_Goods
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , _tmpCalc_all.ContainerId_Goods
                      , _tmpCalc_all.OperDate
                      , _tmpCalc_all.ContainerId
                      , _tmpCalc_all.AccountId
                      , _tmpCalc_all.ContainerId_ProfitLoss
                      , _tmpCalc_all.AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT _tmpItem.MovementItemId
                            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "Дате покупателя"
                            , _tmpItem.ContainerId_Goods
                            , _tmpItem.ContainerId_Partner AS ContainerId
                            , _tmpItem.AccountId_Partner   AS AccountId
                            , _tmpItem.ContainerId_ProfitLoss_10300 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301 ()             AS AccountId_ProfitLoss   -- прибыль текущего периода
                            , 1 * (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_Partner_ChangePercent) AS OperSumm -- !!!не минус, значит "убыток", т.е. уменьшаем "доход" на скидку!!!
                                                                                                                    -- п.с. убыток: Active=ContainerId_ProfitLoss а доход: Passive=ContainerId_ProfitLoss
                       FROM _tmpItem
                      ) AS _tmpCalc_all
                      -- LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                      --                                                                                                    OR  (tmpOperDate.OperDate = vbOperDatePartner
                      --                                                                                                     AND COALESCE (_tmpCalc_all.AccountId_Transit, 0) <> 0)
                 -- !!!ограничили, т.к. нулевые не нужны!!!
                 -- WHERE _tmpCalc_all.OperSumm <> 0 -- !!!нельзя ограничивать, т.к. проводки для отчета будем делать всегда!!!
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


     /*-- убрал, т.к. св-во пишется теперь в ОПиУ
     DELETE FROM MovementItemLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementItemId IN (SELECT MovementItemId FROM _tmpItem);
     DELETE FROM MovementLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementId = inMovementId;*/
     -- !!!6.0.1. формируются свойства в элементах документа из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, vbBranchId_From)
     FROM (SELECT _tmpItem.MovementItemId
           FROM _tmpItem
          ) AS tmp;
     -- !!!6.0.2. формируются свойство связь с <филиал> в документе из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inMovementId, vbBranchId_From);


     -- 6.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 6.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Sale()
                                , inUserId     := inUserId
                                 );

     -- 6.3. ФИНИШ - перепроводим Налоговую
     IF (vbIsHistoryCost = FALSE)
        AND vbPaidKindId = zc_Enum_PaidKind_FirstForm()
        AND vbCurrencyDocumentId = zc_Enum_Currency_Basis()
        AND vbCurrencyPartnerId = zc_Enum_Currency_Basis()
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
     THEN PERFORM lpInsertUpdate_Movement_Tax_From_Kind (inMovementId            := inMovementId
                                                       , inDocumentTaxKindId     := zc_Enum_DocumentTaxKind_Tax()
                                                       , inDocumentTaxKindId_inf := NULL
                                                       , inUserId                := inUserId
                                                        );
     END IF;

     -- 6.4. ФИНИШ - в Налоговой устанавливается признак "Проверен"
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
     THEN -- сохранили свойство <Проверен>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), vbMovementId_Tax, (SELECT ValueData FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Checked()));
     END IF;


     -- 6.6. Дата оплаты по накладной (только если парт.учет долгов)
     IF vbPartionMovementId > 0 OR EXISTS (SELECT MovementId FROM MovementDate WHERE MovementId = inMovementId AND DescId = zc_MovementDate_Payment())
     THEN
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Payment(), inMovementId, vbPaymentDate);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.01.15                                        * add !!!убрал, переводится в строчной части!!!
 18.12.14                                        * all
 19.10.14                                        * add inIsLastComplete = FALSE, тогда перепроводим Налоговую
 07.09.14                                        * add zc_ContainerLinkObject_Branch to vbPartnerId_To
 05.09.14                                        * add zc_ContainerLinkObject_Branch to Физ.лица (подотчетные лица)
 02.09.14                                        * add vbIsHistoryCost
 23.08.14                                        * add vbPartnerId_To
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 12.08.14                                        * add !!!Виртуальные контейнеры!!!
 22.07.14                                        * add ...Price
 25.05.14                                        * add lpComplete_Movement
 22.05.14                                        * modify lfSelect_ObjectHistory_PriceListItem ... inOperDate:= vbOperDatePartner
 16.05.14                                        * add ФИНИШ - перепроводим Налоговую
 10.05.14                                        * add lpInsert_MovementProtocol
 04.05.14                                        * rem zc_Enum_AccountDirection_30400
 30.04.14                                        * set lp
 26.04.14                                        * !!!RESTORE!!!
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 14.02.14                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM lpComplete_Movement_Sale (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
