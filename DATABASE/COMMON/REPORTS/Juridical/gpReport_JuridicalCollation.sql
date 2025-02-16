-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_JuridicalCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalCollation(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inJuridicalId        Integer,    -- Юридическое лицо
    IN inPartnerId          Integer,    --
    IN inContractId         Integer,    -- Договор
    IN inAccountId          Integer,    -- Счет
    IN inPaidKindId         Integer   , --
    IN inInfoMoneyId        Integer,    -- Управленческая статья
    IN inCurrencyId         Integer   , -- Валюта
    IN inMovementId_Partion Integer   , -- Ключ документа
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementSumm TFloat,
               StartRemains TFloat,
               EndRemains TFloat,
               Debet TFloat,
               Kredit TFloat,
               MovementSumm_Currency TFloat,
               StartRemains_Currency TFloat,
               EndRemains_Currency TFloat,
               Debet_Currency TFloat,
               Kredit_Currency TFloat,
               OperDate TDateTime,
               InvNumber TVarChar, InvNumberPartner TVarChar,
               MovementComment TVarChar,
               AccountCode Integer,
               AccountName TVarChar,
               ContractCode Integer,
               ContractName TVarChar,
               ContractTagName TVarChar,
               ContractStateKindCode Integer, ContractComment TVarChar,
               PartnerId Integer, PartnerCode Integer, PartnerName TVarChar,
               PaidKindId Integer, PaidKindName TVarChar,
               BranchId Integer, BranchName TVarChar,

               InfoMoneyGroupCode Integer,
               InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationCode Integer,
               InfoMoneyDestinationName TVarChar,
               InfoMoneyCode Integer,
               InfoMoneyName TVarChar,
               MovementId Integer,
               ItemName TVarChar,
               OperationSort Integer,
               FromName TVarChar,
               ToName TVarChar,
               PartionMovementName TVarChar,
               PaymentDate TDateTime,
               InvNumber_Transport TVarChar,
               OperDate_Transport TDateTime,
               CarName TVarChar,
               PersonalDriverName TVarChar,
               ContainerId Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionMovementId Integer;

   DECLARE vbIsInfoMoneyDestination_21500 Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- !!!Опришко Н.М.!!!
     IF vbUserId = 11117426 AND COALESCE (inJuridicalId, 0) <> 15021 -- ЕКСПЕРТ-АГРОТРЕЙД ТОВ
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав для отчета по Юр.Лицу <%>.', lfGet_Object_ValueData_sh (inJuridicalId);
     END IF;


     -- Разрешен просмотр долги Маркетинг - НАЛ
     vbIsInfoMoneyDestination_21500:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS tmp WHERE tmp.UserId = vbUserId AND tmp.RoleId = 8852398)
                                   OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS tmp WHERE tmp.UserId = vbUserId AND tmp.RoleId = 2) -- Роль администратора
                                  ;

     -- Партия
     IF inMovementId_Partion <> 0
     THEN vbPartionMovementId:= COALESCE ((SELECT ObjectId FROM ObjectFloat WHERE ValueData = inMovementId_Partion AND DescId = zc_ObjectFloat_PartionMovement_MovementId()), -1);
     END IF;

  -- Один запрос, который считает остаток и движение.
  RETURN QUERY
     WITH Object_Account_View AS (SELECT Object_Account_View.AccountCode, Object_Account_View.AccountName_all, Object_Account_View.AccountId FROM Object_Account_View)
        , tmpContract AS (SELECT -- это ObjectId - объединение
                                 View_Contract_ContractKey.ContractKeyId
                                 -- это все ContractId
                               , COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
                                 -- это "главный" ContractId
                               , View_Contract_ContractKey.ContractId_Key

                          FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
                               LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
                          WHERE View_Contract_ContractKey.ContractId = inContractId
                         )
          -- НЕ Разрешен просмотр долги Маркетинг - НАЛ
        , tmpInfoMoney_not AS (SELECT Object_InfoMoney_View.*
                               FROM Object_InfoMoney_View
                               WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- Маркетинг
                                 AND vbIsInfoMoneyDestination_21500 = FALSE
                              )
        , tmpContainer AS (SELECT CLO_Juridical.ContainerId               AS ContainerId
                                , Container_Currency.Id                   AS ContainerId_Currency
                                , Container.ObjectId                      AS AccountId
                                , CLO_InfoMoney.ObjectId                  AS InfoMoneyId
                                , CLO_Branch.ObjectId                     AS BranchId
                                  -- "оригинал"
                                , CLO_Contract.ObjectId                   AS ContractId
                                , CLO_Partner.ObjectId                    AS PartnerId
                                  -- подставили "главный", если есть
                                , COALESCE (tmpContract.ContractId_Key, CLO_Contract.ObjectId) AS ContractId_Key
                                , CLO_PaidKind.ObjectId                   AS PaidKindId
                                , COALESCE (CLO_PartionMovement.ObjectId, 0) AS PartionMovementId
                                , COALESCE (CLO_Currency.ObjectId, 0)     AS CurrencyId
                                , Container.Amount                        AS Amount
                                , COALESCE (Container_Currency.Amount, 0) AS Amount_Currency
                                , CASE WHEN Container.DescId = zc_Container_SummAsset() THEN TRUE ELSE FALSE END AS isNotBalance
                                --, FALSE AS isNotBalance

                           FROM ContainerLinkObject AS CLO_Juridical
                                INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId
                                                    AND Container.DescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                                LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                              ON CLO_Branch.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                              ON CLO_Partner.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                              ON CLO_InfoMoney.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                              ON CLO_Contract.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                              ON CLO_PaidKind.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                LEFT JOIN ContainerLinkObject AS CLO_PartionMovement
                                                              ON CLO_PartionMovement.ContainerId = CLO_Juridical.ContainerId
                                                             AND CLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
                                LEFT JOIN tmpContract ON tmpContract.ContractId = CLO_Contract.ObjectId

                                LEFT JOIN ContainerLinkObject AS CLO_Currency ON CLO_Currency.ContainerId = CLO_Juridical.ContainerId AND CLO_Currency.DescId = zc_ContainerLinkObject_Currency()
                                LEFT JOIN Container AS Container_Currency ON Container_Currency.ParentId = CLO_Juridical.ContainerId AND Container_Currency.DescId = zc_Container_SummCurrency()

                                LEFT JOIN tmpInfoMoney_not ON tmpInfoMoney_not.InfoMoneyId = CLO_InfoMoney.ObjectId

                           WHERE CLO_Juridical.ObjectId = inJuridicalId AND inJuridicalId <> 0
                             AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                             AND (CLO_Partner.ObjectId = inPartnerId OR COALESCE (inPartnerId, 0) = 0)
                             AND (Container.ObjectId = inAccountId OR COALESCE (inAccountId, 0) = 0)
                             AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                             AND (CLO_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                             AND (CLO_PartionMovement.ObjectId = vbPartionMovementId OR COALESCE (vbPartionMovementId, 0) = 0)
                             AND (tmpContract.ContractId > 0 OR COALESCE (inContractId, 0) = 0)
                             AND (CLO_Currency.ObjectId = inCurrencyId OR COALESCE (inCurrencyId, 0) = 0 OR COALESCE (inCurrencyId, 0) = zc_Enum_Currency_Basis())
                             -- НЕ Разрешен просмотр долги Маркетинг - НАЛ
                             AND (tmpInfoMoney_not.InfoMoneyId IS NULL OR COALESCE (CLO_PaidKind.ObjectId, 0) <> zc_Enum_PaidKind_SecondForm())
                          )

        , tmpContainer_All AS (-- 1.1. сумма даижения в валюте баланса
                               SELECT tmpContainer.ContainerId,
                                      tmpContainer.AccountId,
                                      tmpContainer.InfoMoneyId,
                                      tmpContainer.BranchId,
                                      tmpContainer.ContractId,
                                      tmpContainer.PartnerId,
                                      tmpContainer.PaidKindId,
                                      tmpContainer.PartionMovementId,
                                      tmpContainer.CurrencyId,
                                      MIContainer.MovementId,
                                      MIContainer.OperDate,
                                      MAX (MIContainer.MovementItemId) AS MovementItemId,

                                      SUM (MIContainer.Amount) AS MovementSumm,
                                      0                        AS MovementSumm_Currency
                                    , tmpContainer.isNotBalance
                               FROM tmpContainer
                                    INNER JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                               GROUP BY tmpContainer.AccountId, tmpContainer.InfoMoneyId, tmpContainer.BranchId, tmpContainer.ContractId, tmpContainer.PaidKindId, tmpContainer.PartionMovementId, tmpContainer.CurrencyId
                                      , MIContainer.MovementId, MIContainer.OperDate
                                      , tmpContainer.ContainerId
                                      , tmpContainer.isNotBalance
                                      , tmpContainer.PartnerId

                               HAVING SUM (MIContainer.Amount) <> 0
                              UNION ALL
                               -- 1.2. сумма движения в валюте операции - Currency
                               SELECT tmpContainer.ContainerId,
                                      tmpContainer.AccountId,
                                      tmpContainer.InfoMoneyId,
                                      tmpContainer.BranchId,
                                      tmpContainer.ContractId,
                                      tmpContainer.PartnerId,
                                      tmpContainer.PaidKindId,
                                      tmpContainer.PartionMovementId,
                                      tmpContainer.CurrencyId,
                                      MIContainer.MovementId,
                                      MIContainer.OperDate,
                                      MAX (MIContainer.MovementItemId) AS MovementItemId,

                                      0                        AS MovementSumm,
                                      SUM (MIContainer.Amount) AS MovementSumm_Currency
                                    , tmpContainer.isNotBalance
                               FROM tmpContainer
                                    INNER JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.ContainerId = tmpContainer.ContainerId_Currency
                                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                               WHERE tmpContainer.ContainerId_Currency > 0
                               GROUP BY tmpContainer.AccountId, tmpContainer.InfoMoneyId, tmpContainer.BranchId, tmpContainer.ContractId, tmpContainer.PaidKindId, tmpContainer.PartionMovementId, tmpContainer.CurrencyId
                                      , MIContainer.MovementId, MIContainer.OperDate
                                      , tmpContainer.ContainerId
                                      , tmpContainer.isNotBalance
                                      , tmpContainer.PartnerId
                               HAVING SUM (MIContainer.Amount) <> 0
                              )
        , tmpRemains AS (-- 2.1. остаток в валюте баланса
                         SELECT tmpContainer.ContainerId,
                                tmpContainer.AccountId,
                                tmpContainer.InfoMoneyId,
                                tmpContainer.BranchId,
                                -- объединили по "главному"
                                tmpContainer.ContractId_Key AS ContractId,
                                -- оставили "оригинал"
                                -- tmpContainer.ContractId AS ContractId,
                                tmpContainer.PartnerId,
                                tmpContainer.PaidKindId,
                                tmpContainer.PartionMovementId,
                                tmpContainer.CurrencyId,
                                tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS StartSumm,
                                tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndSumm,
                                0 AS StartSumm_Currency,
                                0 AS EndSumm_Currency
                              , tmpContainer.isNotBalance
                         FROM tmpContainer
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                             AND MIContainer.OperDate >= inStartDate
                         GROUP BY tmpContainer.AccountId, tmpContainer.InfoMoneyId, tmpContainer.BranchId, tmpContainer.PaidKindId
                                , tmpContainer.PartionMovementId, tmpContainer.CurrencyId
                                , tmpContainer.ContainerId, tmpContainer.Amount
                                , tmpContainer.ContractId_Key
                                -- , tmpContainer.ContractId
                                , tmpContainer.isNotBalance
                                , tmpContainer.PartnerId
                        UNION ALL
                         -- 2.2. остаток в валюте операции - Currency
                         SELECT tmpContainer.ContainerId,
                                tmpContainer.AccountId,
                                tmpContainer.InfoMoneyId,
                                tmpContainer.BranchId,
                                -- объединили по "главному"
                                tmpContainer.ContractId_Key AS ContractId,
                                -- оставили "оригинал"
                                -- tmpContainer.ContractId AS ContractId,
                                tmpContainer.PartnerId,
                                tmpContainer.PaidKindId,
                                tmpContainer.PartionMovementId,
                                tmpContainer.CurrencyId,
                                0 AS StartSumm,
                                0 AS EndSumm,
                                tmpContainer.Amount_Currency - COALESCE (SUM (MIContainer.Amount), 0)                                                            AS StartSumm_Currency,
                                tmpContainer.Amount_Currency - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS EndSumm_Currency
                              , tmpContainer.isNotBalance
                         FROM tmpContainer
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.ContainerId = tmpContainer.ContainerId_Currency
                                                             AND MIContainer.OperDate >= inStartDate
                         WHERE tmpContainer.ContainerId_Currency > 0
                         GROUP BY tmpContainer.AccountId, tmpContainer.InfoMoneyId, tmpContainer.BranchId, tmpContainer.PaidKindId, tmpContainer.PartionMovementId, tmpContainer.CurrencyId
                                , tmpContainer.ContainerId, tmpContainer.ContainerId_Currency, tmpContainer.Amount_Currency
                                , tmpContainer.ContractId_Key
                                -- , tmpContainer.ContractId
                                , tmpContainer.isNotBalance
                                , tmpContainer.PartnerId
                        )
        , Operation AS (SELECT -- tmpContainer.ContainerId,
                               0 AS ContainerId,
                               tmpContainer.AccountId,
                               tmpContainer.InfoMoneyId,
                               tmpContainer.BranchId,
                               -- оставили "оригинал"
                               tmpContainer.ContractId,
                               tmpContainer.PartnerId,
                               tmpContainer.PaidKindId,
                               tmpContainer.PartionMovementId,
                               tmpContainer.CurrencyId,
                               MAX (tmpContainer.MovementId)     AS MovementId,
                               MAX (tmpContainer.OperDate)       AS OperDate,
                               MAX (tmpContainer.MovementItemId) AS MovementItemId,

                               SUM (tmpContainer.MovementSumm)          AS MovementSumm,
                               SUM (tmpContainer.MovementSumm_Currency) AS MovementSumm_Currency,
                               0 AS StartSumm,
                               0 AS EndSumm,
                               0 AS StartSumm_Currency,
                               0 AS EndSumm_Currency,
                               0 AS OperationSort
                             , tmpContainer.isNotBalance
                        FROM tmpContainer_All AS tmpContainer
                             --  Счет(клиента)
                             LEFT JOIN MovementString AS MovementString_InvNumberInvoice
                                                      ON MovementString_InvNumberInvoice.MovementId = tmpContainer.MovementId
                                                     AND MovementString_InvNumberInvoice.DescId     = zc_MovementString_InvNumberInvoice()
                        GROUP BY CASE WHEN MovementString_InvNumberInvoice.ValueData <> '' THEN MovementString_InvNumberInvoice.ValueData ELSE tmpContainer.MovementId :: TVarChar || tmpContainer.MovementItemId :: TVarChar END,
                                 tmpContainer.AccountId,
                                 tmpContainer.InfoMoneyId,
                                 tmpContainer.BranchId,
                                 tmpContainer.ContractId,
                                 tmpContainer.PaidKindId,
                                 tmpContainer.PartionMovementId,
                                 tmpContainer.CurrencyId,
                                 -- !!! tmpContainer.MovementId,
                                 -- !!! tmpContainer.OperDate,
                                 -- !!! tmpContainer.MovementItemId,
                                 -- tmpContainer.ContainerId,
                                 tmpContainer.isNotBalance,
                                 tmpContainer.PartnerId
                       UNION ALL
                        SELECT -- tmpRemains.ContainerId,
                               0 AS ContainerId,
                               tmpRemains.AccountId,
                               tmpRemains.InfoMoneyId,
                               tmpRemains.BranchId,
                               -- "главноый" или "оригинал"
                               tmpRemains.ContractId,
                               tmpRemains.PartnerId,
                               tmpRemains.PaidKindId,
                               tmpRemains.PartionMovementId,
                               tmpRemains.CurrencyId,
                               0 AS MovementId,
                               NULL :: TDateTime AS OperDate,
                               0 AS MovementItemId,
                               0 AS MovementSumm,
                               0 AS MovementSumm_Currency,
                               SUM (tmpRemains.StartSumm) AS StartSumm,
                               SUM (tmpRemains.EndSumm) AS EndSumm,
                               SUM (tmpRemains.StartSumm_Currency) AS StartSumm_Currency,
                               SUM (tmpRemains.EndSumm_Currency) AS EndSumm_Currency,
                               -1 AS OperationSort
                             , tmpRemains.isNotBalance
                        FROM tmpRemains
                        GROUP BY tmpRemains.AccountId, tmpRemains.InfoMoneyId, tmpRemains.BranchId
                               , tmpRemains.ContractId, tmpRemains.PaidKindId, tmpRemains.PartionMovementId
                               , tmpRemains.CurrencyId
                               -- , tmpRemains.ContainerId
                               , tmpRemains.isNotBalance
                               , tmpRemains.PartnerId
                        HAVING SUM (tmpRemains.StartSumm) <> 0 OR SUM (tmpRemains.EndSumm) <> 0
                       )

   -- результат
   SELECT
          CASE WHEN Operation.OperationSort = 0
                     THEN Operation.MovementSumm
               ELSE 0
          END :: TFloat AS MovementSumm,

          Operation.StartSumm :: TFloat AS StartRemains,
          Operation.EndSumm :: TFloat AS EndRemains,

          CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm > 0
                    THEN Operation.MovementSumm
               ELSE 0
          END :: TFloat AS Debet,

          CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm < 0
                    THEN -1 * Operation.MovementSumm
               ELSE 0
          END :: TFloat AS Kredit,

          CASE WHEN Operation.OperationSort = 0
                     THEN Operation.MovementSumm_Currency
               ELSE 0
          END :: TFloat AS MovementSumm_Currency,

          Operation.StartSumm_Currency :: TFloat AS StartRemains_Currency,
          Operation.EndSumm_Currency :: TFloat AS EndRemains_Currency,

          CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm_Currency > 0
                    THEN Operation.MovementSumm_Currency
               ELSE 0
          END :: TFloat AS Debet_Currency,

          CASE WHEN Operation.OperationSort = 0 AND Operation.MovementSumm_Currency < 0
                    THEN -1 * Operation.MovementSumm_Currency
               ELSE 0
          END :: TFloat AS Kredit_Currency,

          Operation.OperDate :: TDateTime,
          CASE WHEN Movement.DescId = zc_Movement_BankAccount() AND 1=0 THEN '' ELSE Movement.InvNumber END :: TVarChar AS InvNumber,
          CASE WHEN Movement.DescId = zc_Movement_BankAccount() AND 1=0 THEN '' ELSE MovementString_InvNumberPartner.ValueData END :: TVarChar AS InvNumberPartner,
          MIString_Comment.ValueData          AS MovementComment,
          Object_Account_View.AccountCode,
          (CASE WHEN Operation.isNotBalance = TRUE THEN '*з* ' ELSE '' END || Object_Account_View.AccountName_all) :: TVarChar AS AccountName,

          View_Contract_InvNumber.ContractCode,
          (View_Contract_InvNumber.InvNumber || CASE WHEN vbUserId = 5 THEN ' _ ' || View_Contract_InvNumber.ContractId :: TVarChar ELSE '' END )  :: TVarChar AS ContractName,
          View_Contract_InvNumber.ContractTagName,
          View_Contract_InvNumber.ContractStateKindCode,
          ObjectString_Comment.ValueData AS ContractComment,

          Object_Partner.Id         AS PartnerId,
          Object_Partner.ObjectCode AS PartnerCode,
          Object_Partner.ValueData  AS PartnerName,

          Object_PaidKind.Id AS PaidKindId,
          Object_PaidKind.ValueData AS PaidKindName,
          Object_Branch.Id AS BranchId,
          Object_Branch.ValueData AS BranchName,

          Object_InfoMoney_View.InfoMoneyGroupCode,
          Object_InfoMoney_View.InfoMoneyGroupName,
          Object_InfoMoney_View.InfoMoneyDestinationCode,
          Object_InfoMoney_View.InfoMoneyDestinationName,
          Object_InfoMoney_View.InfoMoneyCode,
          Object_InfoMoney_View.InfoMoneyName,
          Movement.Id               AS MovementId,
          CASE WHEN Operation.OperationSort = -1
                    THEN ' Долг:'
               ELSE MovementDesc.ItemName
          END::TVarChar  AS ItemName,
          Operation.OperationSort,
          (Object_From.ValueData || CASE WHEN Object_From.DescId = zc_Object_BankAccount() THEN ' * ' || Object_Bank.ValueData ELSE '' END) :: TVarChar AS FromName,
          (Object_To.ValueData || CASE WHEN Object_To.DescId = zc_Object_BankAccount() THEN ' * ' || Object_Bank.ValueData ELSE '' END) :: TVarChar AS ToName
          --, Operation.MovementItemId :: Integer AS MovementItemId

        , Object_PartionMovement.ValueData AS PartionMovementName
        , ObjectDate_PartionMovement_Payment.ValueData AS PaymentDate

        , Movement_Transport.InvNumber     :: TVarChar  AS InvNumber_Transport
        , Movement_Transport.OperDate      :: TDateTime AS OperDate_Transport
        , Object_Car.ValueData             :: TVarChar  AS CarName
        , Object_PersonalDriver.ValueData  :: TVarChar  AS PersonalDriverName

        , Operation.ContainerId :: Integer AS ContainerId

    FROM Operation

      LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = Operation.ContractId
      LEFT JOIN ObjectString AS ObjectString_Comment
                             ON ObjectString_Comment.ObjectId = Operation.ContractId
                            AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

      LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.AccountId
      LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId
      LEFT JOIN Movement ON Movement.Id = Operation.MovementId
      LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
      LEFT JOIN MovementString AS MovementString_InvNumberPartner
                               ON MovementString_InvNumberPartner.MovementId = Operation.MovementId
                              AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

      LEFT JOIN MovementItemString AS MIString_Comment
                                   ON MIString_Comment.MovementItemId = Operation.MovementItemId
                                  AND MIString_Comment.DescId = zc_MIString_Comment()

      LEFT JOIN MovementItem AS MovementItem_by ON MovementItem_by.Id = Operation.MovementItemId
                                               AND MovementItem_by.DescId IN (zc_MI_Master())
                                               AND Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
      LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                       ON MILinkObject_Unit.MovementItemId = Operation.MovementItemId
                                      AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
      LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                       ON MILinkObject_MoneyPlace.MovementItemId = Operation.MovementItemId
                                      AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()

      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = CASE WHEN Movement.DescId IN (zc_Movement_TransportService())
                                                                               THEN zc_MovementLinkObject_UnitForwarding()
                                                                            WHEN Movement.DescId IN (zc_Movement_PersonalAccount())
                                                                                 THEN zc_MovementLinkObject_Personal()
                                                                            WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_TransferDebtOut(), zc_Movement_Loss())
                                                                                 THEN zc_MovementLinkObject_From()
                                                                            WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
                                                                                 THEN zc_MovementLinkObject_From()
                                                                       END
      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                  AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_TransferDebtOut(), zc_Movement_Loss())
                                                                               THEN zc_MovementLinkObject_To()
                                                                          WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
                                                                               THEN zc_MovementLinkObject_To()
                                                                     END
      LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                   ON MovementLinkObject_Partner.MovementId = Movement.Id
                                  AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()

      LEFT JOIN Object AS Object_PartionMovement ON Object_PartionMovement.Id = Operation.PartionMovementId
      LEFT JOIN ObjectDate AS ObjectDate_PartionMovement_Payment
                           ON ObjectDate_PartionMovement_Payment.ObjectId = Operation.PartionMovementId
                          AND ObjectDate_PartionMovement_Payment.DescId = zc_ObjectDate_PartionMovement_Payment()

      LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                           ON ObjectLink_BankAccount_Bank.ObjectId = MovementItem_by.ObjectId
                          AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
      LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

      LEFT JOIN Object AS Object_From ON Object_From.Id = CASE WHEN Movement.DescId IN (zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective()) AND MovementLinkObject_Partner.ObjectId IS NOT NULL
                                                                    THEN MovementLinkObject_Partner.ObjectId
                                                               ELSE COALESCE (MovementLinkObject_From.ObjectId, COALESCE (CASE WHEN Operation.MovementSumm < 0 THEN MILinkObject_MoneyPlace.ObjectId ELSE MovementItem_by.ObjectId END, MILinkObject_Unit.ObjectId))
                                                          END
      LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN Movement.DescId IN (zc_Movement_TransferDebtOut()) AND MovementLinkObject_Partner.ObjectId IS NOT NULL
                                                                THEN MovementLinkObject_Partner.ObjectId
                                                           ELSE COALESCE (MovementLinkObject_To.ObjectId, COALESCE (CASE WHEN Operation.MovementSumm > 0 THEN MILinkObject_MoneyPlace.ObjectId ELSE MovementItem_by.ObjectId END, MILinkObject_Unit.ObjectId))
                                                      END
      LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Operation.PaidKindId
      LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = Operation.BranchId
      LEFT JOIN Object AS Object_Partner  ON Object_Partner.Id  = Operation.PartnerId

      -- путевой из реестра
      -- реестр
       LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                               ON MovementFloat_MovementItemId.MovementId = Operation.MovementId
                              AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
       LEFT JOIN MovementItem AS MI_reestr
                              ON MI_reestr.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                             AND MI_reestr.isErased = FALSE

       -- П/л (реестр)
       LEFT JOIN MovementLinkMovement AS MLM_Transport_reestr
                                      ON MLM_Transport_reestr.MovementId = MI_reestr.MovementId
                                     AND MLM_Transport_reestr.DescId     = zc_MovementLinkMovement_Transport()
       --LEFT JOIN Movement AS Movement_Transport_reestr ON Movement_Transport_reestr.Id = MLM_Transport_reestr.MovementChildId

      -- путевой из свойсв документа
      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                     ON MovementLinkMovement_Transport.MovementId = Operation.MovementId
                                    AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()

      LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = COALESCE (MLM_Transport_reestr.MovementChildId, MovementLinkMovement_Transport.MovementChildId)

      LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                   ON MovementLinkObject_Car.MovementId = Movement_Transport.Id
                                  AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
      LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

      LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                   ON MovementLinkObject_PersonalDriver.MovementId = Movement_Transport.Id
                                  AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
      LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId

  ORDER BY Operation.OperationSort
         , MovementDesc.Id
         , Operation.OperDate
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.23         *
 09.11.15         * add MovementComment
 14.11.14         * add inCurrencyId
 21.08.14                                        * add ContractComment
 03.07.14                                        * add InvNumberPartner
 16.05.14                                        * add Operation.OperDate
 10.05.14                                        * add inInfoMoneyId
 05.05.14                                        * add inPaidKindId
 04.05.14                                        * add PaidKindName
 26.04.14                                        * add Object_Contract_ContractKey_View
 17.04.14                        *
 26.03.14                        *
 18.02.14                        * add WITH для ускорения запроса.
 25.01.14                        *
 15.01.14                        *
*/

-- тест
-- SELECT * FROM gpReport_JuridicalCollation (inStartDate:= '01.01.2017', inEndDate:= '01.01.2017', inJuridicalId:= 0, inPartnerId:=0, inContractId:= 0, inAccountId:= 0, inPaidKindId:= 0, inInfoMoneyId:= 0, inCurrencyId:= 0, inMovementId_Partion:=0, inSession:= zfCalc_UserAdmin());
-- select * from gpReport_JuridicalCollation(inStartDate := ('11.04.2023')::TDateTime , inEndDate := ('11.04.2023')::TDateTime , inJuridicalId := 6629649 , inPartnerId := 0 , inContractId := 0 , inAccountId := 0 , inPaidKindId := 0 , inInfoMoneyId := 0 , inCurrencyId := 0 , inMovementId_Partion := 0 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
