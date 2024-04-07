-- Function: gpSelect_Movement_Cash_Bonus()

--DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Bonus (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Bonus (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cash_Bonus(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inCashId           Integer , --
    IN inCurrencyId       Integer , --
    IN inJuridicalBasisId Integer   , -- Главное юр.лицо
    IN inInfoMoneyId      Integer   , --статья назначения
    IN inBranchId         Integer   , --Филиал
    IN inRetailId         Integer   , --Торг. сеть
    IN inJuridicalId      Integer   , --Юр.лицо
    IN inPersonalId       Integer   , --супервайзер
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , AmountCurrency TFloat, AmountSumm TFloat
             , ServiceDate TDateTime
             , Comment TVarChar
             , CashName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceCode Integer, MoneyPlaceName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , RetailName TVarChar
             , OKPO TVarChar, ItemName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractId Integer, ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , BranchId Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , CurrencyName TVarChar, CurrencyPartnerName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , isLoad Boolean
             , PartionMovementName TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InsertDate TDateTime
             , InsertMobileDate TDateTime
             , InsertName TVarChar
             , UnitName_Mobile TVarChar
             , PositionName_Mobile TVarChar
             , GUID TVarChar
             , CurrencyId_x  Integer
             , MovementId_x  Integer
             , AmountSumm_x  TFloat
             , CurrencyValue_calc    TFloat
             , CurrencyValue_mi_calc TFloat
             , SummToPay TFloat
             , SummPay   TFloat
             , RemainsToPay TFloat
             , ContainerId_bonus Integer
             , AreaId Integer, AreaName TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Блокируем ему просмотр
     IF 1=0 AND vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;

     --проверка нельзя выбрать чужую кассу, филиал можно, для пользователей с ролью админ не проверяем
     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
    AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND AccessKeyId = zc_Enum_Process_AccessKey_CashAll())
     THEN
         IF inCashId <> (SELECT tmp.CashId FROM gpGet_UserParams_bonus (inSession:= inSession) AS tmp)
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав доступа для просмотра данных по <%>.', lfGet_Object_ValueData (inCashId);
         END IF;
     END IF;

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate WHERE inIsErased = TRUE
                         )
          , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
          , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
          , tmpAccessKey_isCashAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                 UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_CashAll()
                                      )
          , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_isCashAll.Id FROM tmpAccessKey_isCashAll)
                           UNION SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = zc_Enum_Process_InsertUpdate_Movement_Cash() AND EXISTS (SELECT tmpAccessKey_isCashAll.Id FROM tmpAccessKey_isCashAll) GROUP BY AccessKeyId
                                )
          , tmpAll AS (SELECT tmpStatus.StatusId, tmpStatus.StartDate, tmpStatus.EndDate, tmpRoleAccessKey.AccessKeyId FROM tmpStatus, tmpRoleAccessKey)
          , tmpMovement2 AS (SELECT Movement.*
                             FROM Movement
                             WHERE Movement.DescId = zc_Movement_Cash()
                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                            )
         , tmpMovement AS (SELECT Movement.*
                                , Object_Status.ObjectCode AS StatusCode
                                , Object_Status.ValueData  AS StatusName
                           FROM tmpAll
                                INNER JOIN tmpMovement2 AS Movement ON Movement.DescId = zc_Movement_Cash()
                                                   AND Movement.OperDate BETWEEN tmpAll.StartDate AND tmpAll.EndDate
                                                   AND Movement.StatusId = tmpAll.StatusId
                                                   AND Movement.AccessKeyId = tmpAll.AccessKeyId
                                LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpAll.StatusId
                          )
         , tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.BranchId
                           FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
         , tmpMLO AS (SELECT MovementLinkObject.*
                               FROM MovementLinkObject
                               WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementLinkObject.DescId = zc_MovementLinkObject_Insert()
                              )
         , tmpMovementDate AS (SELECT MovementDate.*
                               FROM MovementDate
                               WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                              )
         , tmpMovementFloat AS (SELECT MovementFloat.*
                                FROM MovementFloat
                                WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementFloat.DescId IN (zc_MovementFloat_AmountCurrency()
                                                              , zc_MovementFloat_Amount()
                                                              , zc_MovementFloat_CurrencyValue()
                                                              , zc_MovementFloat_ParValue()
                                                              , zc_MovementFloat_CurrencyPartnerValue()
                                                              , zc_MovementFloat_ParPartnerValue()
                                                                )
                                )
         , tmpMovementString_GUID AS (SELECT MovementString.*
                                      FROM MovementString
                                      WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                        AND MovementString.DescId = zc_MovementString_GUID()
                                      )

         , tmpMovementBoolean_isLoad AS (SELECT MovementBoolean.*
                                         FROM MovementBoolean
                                         WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                           AND MovementBoolean.DescId = zc_MovementBoolean_isLoad()
                                         )

         , tmpMLM_Invoice AS (SELECT MovementLinkMovement.*
                              FROM MovementLinkMovement
                              WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                              )

         , tmpMovementString_Invoice AS (SELECT MovementString.*
                                         FROM MovementString
                                         WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMLM_Invoice.MovementChildId FROM tmpMLM_Invoice)
                                           AND MovementString.DescId IN (zc_MovementString_InvNumberPartner()
                                                                       , zc_MovementString_Comment()
                                                                         )
                                )

         , tmpMI2 AS (SELECT MovementItem.*
                      FROM MovementItem
                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                        AND MovementItem.DescId = zc_MI_Master()
                     )
         , tmpMI AS (SELECT MovementItem.*
                     FROM tmpMovement
                          INNER JOIN tmpMI2 AS MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 AND (MovementItem.ObjectId = inCashId or inCashId = 0)
                     )
           -- проводки
         , tmpMIС AS (SELECT MovementItemContainer.MovementId, SUM (MovementItemContainer.Amount) AS Amount
                      FROM MovementItemContainer
                      WHERE MovementItemContainer.MovementId        IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                        AND MovementItemContainer.DescId            = zc_MIContainer_Summ()
                        AND MovementItemContainer.AccountId         = zc_Enum_Account_100301()   -- прибыль текущего периода
                        AND MovementItemContainer.ObjectId_Analyzer IN (zc_Enum_ProfitLoss_75103(), zc_Enum_ProfitLoss_80103()) -- Курсовая разница
                        AND inCurrencyId                            <> zc_Enum_Currency_Basis()
                      GROUP BY MovementItemContainer.MovementId
                     )
           -- остаток суммы на дату в ГРН
         , tmpListContainer_SummCurrency AS
                    (SELECT Container.ParentId AS ContainerId
                          , Container.Id       AS ContainerId_Currency
                          , Container.Amount
                     FROM ContainerLinkObject AS CLO_Cash
                          INNER JOIN ContainerLinkObject AS CLO_Currency
                                                         ON CLO_Currency.ContainerId = CLO_Cash.ContainerId
                                                        AND CLO_Currency.ObjectId    = inCurrencyId
                                                        AND CLO_Currency.DescId      = zc_ContainerLinkObject_Currency()
                          INNER JOIN Container ON Container.Id     = CLO_Cash.ContainerId
                                              AND Container.DescId = zc_Container_SummCurrency()
                          INNER JOIN Object_Account_View AS View_Account
                                                         ON View_Account.AccountId      = Container.ObjectId
                                                        AND View_Account.AccountGroupId = zc_Enum_AccountGroup_40000() -- Денежные средства
                     WHERE CLO_Cash.DescId      = zc_ContainerLinkObject_Cash()
                       AND (CLO_Cash.ObjectId    = inCashId or inCashId = 0)
                       AND inCurrencyId         <> zc_Enum_Currency_Basis()
                    )
           -- остаток суммы на дату в ГРН
         , tmpListContainer_Summ AS
                    (SELECT Container.Id       AS ContainerId
                          , Container.Amount
                     FROM ContainerLinkObject AS CLO_Cash
                          INNER JOIN ContainerLinkObject AS CLO_Currency
                                                         ON CLO_Currency.ContainerId = CLO_Cash.ContainerId
                                                        AND CLO_Currency.ObjectId    = inCurrencyId
                                                        AND CLO_Currency.DescId      = zc_ContainerLinkObject_Currency()
                          INNER JOIN Container ON Container.Id     = CLO_Cash.ContainerId
                                              AND Container.DescId = zc_Container_Summ()
                          INNER JOIN Object_Account_View AS View_Account
                                                         ON View_Account.AccountId      = Container.ObjectId
                                                        AND View_Account.AccountGroupId = zc_Enum_AccountGroup_40000() -- Денежные средства
                     WHERE CLO_Cash.DescId      = zc_ContainerLinkObject_Cash()
                       AND (CLO_Cash.ObjectId    = inCashId or inCashId = 0)
                       AND inCurrencyId         <> zc_Enum_Currency_Basis()
                    )
           --
         , tmpMIContainer_SummCurrency AS
                    (SELECT MIContainer.*, tmpListContainer_SummCurrency.Amount AS Amount_Container
                     FROM tmpListContainer_SummCurrency
                          LEFT JOIN MovementItemContainer AS MIContainer
                                                          ON MIContainer.Containerid = tmpListContainer_SummCurrency.ContainerId_Currency
                                                         AND MIContainer.OperDate    >= inStartDate
                    )
           --
         , tmpMIContainer_Summ AS
                    (SELECT MIContainer.*, tmpListContainer_Summ.Amount AS Amount_Container
                     FROM tmpListContainer_Summ
                          LEFT JOIN MovementItemContainer AS MIContainer
                                                          ON MIContainer.Containerid = tmpListContainer_Summ.ContainerId
                                                         AND MIContainer.OperDate    >= inStartDate
                    )
           --
         , tmpMIDate_ServiceDate AS (SELECT MovementItemDate.MovementItemId
                                          , MovementItemDate.ValueData
                                          , MovementItemDate.DescId
                                     FROM MovementItemDate
                                     WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                       AND MovementItemDate.DescId = zc_MIDate_ServiceDate()
                                    )
         , tmpMIFloat_MovementId AS (SELECT MovementItemFloat.MovementItemId
                                          , MovementItemFloat.ValueData :: Integer AS ValueData
                                          , MovementItemFloat.DescId
                                     FROM MovementItemFloat
                                     WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                       AND MovementItemFloat.DescId = zc_MIFloat_MovementId()
                                    )

          , tmpMD_PartionMovement AS (SELECT MovementDate.*
                                      FROM MovementDate
                                      WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMIFloat_MovementId.ValueData FROM tmpMIFloat_MovementId)
                                        AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                                     )
         , tmpMIString_Comment AS (SELECT MovementItemString.*
                                   FROM MovementItemString
                                   WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                     AND MovementItemString.DescId = zc_MIString_Comment()
                                  )

         , tmpMILO AS (SELECT MovementItemLinkObject.*
                       FROM MovementItemLinkObject
                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                         AND MovementItemLinkObject.DescId IN (zc_MILinkObject_MoneyPlace()
                                                             , zc_MILinkObject_InfoMoney()
                                                             , zc_MILinkObject_Branch()
                                                             , zc_MILinkObject_Contract()
                                                             , zc_MILinkObject_Unit()
                                                             , zc_MILinkObject_Currency()
                                                             , zc_MILinkObject_CurrencyPartner()
                                                             )
                      )

         , tmpContract_View AS (SELECT Object_Contract_InvNumber_View.*
                                FROM Object_Contract_InvNumber_View
                                --WHERE Object_Contract_InvNumber_View.ContractId IN (SELECT DISTINCT MILinkObject_Contract.ObjectId FROM tmpMILO AS MILinkObject_Contract WHERE MILinkObject_Contract.DescId = zc_MILinkObject_Contract())
                               )
         , tmpInfoMoney_View AS (SELECT * FROM Object_InfoMoney_View)
         , tmpJuridicalDetails_View AS (SELECT *
                                        FROM ObjectHistory_JuridicalDetails_View
                                       /* WHERE ObjectHistory_JuridicalDetails_View.JuridicalId
                                              IN (SELECT DISTINCT ObjectLink_Partner_Juridical.ChildObjectId
                                                  FROM tmpMILO AS MILinkObject_MoneyPlace
                                                       INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                          ON ObjectLink_Partner_Juridical.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                  WHERE MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                                 )*/
                                       )

         , tmpContainerBonus AS (SELECT CLO_Juridical.ObjectId AS JuridicalId
                                      , CLO_Partner.ObjectId   AS PartnerId
                                      , CLO_InfoMoney.ObjectId AS InfoMoneyId
                                      , CLO_Contract.ObjectId  AS ContractId
                                      , CLO_Branch.ObjectId    AS BranchId
                                      , SUM (COALESCE (Container.Amount,0)) * (-1) AS Amount
                                      , MAX (Container.Id)     AS ContainerId
                                 FROM ContainerLinkObject AS CLO_Juridical
                                      INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
                                      LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                    ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()

                                      LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                                    ON CLO_Partner.ContainerId = Container.Id
                                                                   AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()

                                      LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                                    ON CLO_Branch.ContainerId = Container.Id
                                                                   AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                      LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                                                    ON CLO_PaidKind.ContainerId = Container.Id
                                                                   AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()

                                      LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                                    ON CLO_Contract.ContainerId = Container.Id
                                                                   AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()

                                 WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                   AND (CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm())
                                   AND (CLO_Branch.ObjectId = inBranchId OR COALESCE (inBranchId, 0) = 0)
                                   AND (CLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                   --AND CLO_Juridical.ObjectId = 3834632  --мидас
                                   AND (CLO_InfoMoney.ObjectId = inInfoMoneyId OR (COALESCE (inInfoMoneyId, 0) = 0 AND CLO_InfoMoney.ObjectId IN (zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21502(), zc_Enum_InfoMoney_21512(), zc_Enum_InfoMoney_21512())) )
                                                                                                              --  AND CLO_InfoMoney.ObjectId IN (8950, 8951)   --Бонусы за продукцию, Бонусы за мясное сырье, Маркетинговый бюджет, Маркетинговый бюджет
                                   AND COALESCE (Container.Amount,0) <> 0
                                 GROUP BY CLO_Juridical.ObjectId
                                        , CLO_InfoMoney.ObjectId
                                        , CLO_Branch.ObjectId
                                        , CLO_Partner.ObjectId
                                        , CLO_Contract.ObjectId
                                 )

       -- Результат
      , tmpRes AS (SELECT tmpMovement.Id
                        , tmpMovement.InvNumber
                        , tmpMovement.OperDate
                        , tmpMovement.StatusCode
                        , tmpMovement.StatusName

                        , CASE WHEN MILinkObject_Currency.ObjectId <> inCurrencyId AND inCurrencyId = zc_Enum_Currency_Basis()
                                AND MovementItem.Amount < 0
                                    THEN MovementFloat_AmountSumm.ValueData
                               WHEN MILinkObject_Currency.ObjectId <> inCurrencyId AND inCurrencyId = zc_Enum_Currency_Basis()
                                    THEN 0
                               WHEN MovementItem.Amount > 0
                                    THEN MovementItem.Amount
                               ELSE 0
                          END::TFloat AS AmountIn
                        , CASE WHEN MILinkObject_Currency.ObjectId <> inCurrencyId AND inCurrencyId = zc_Enum_Currency_Basis()
                                AND MovementItem.Amount > 0
                                    THEN MovementFloat_AmountSumm.ValueData
                               WHEN MILinkObject_Currency.ObjectId <> inCurrencyId AND inCurrencyId = zc_Enum_Currency_Basis()
                                    THEN 0
                               WHEN MovementItem.Amount < 0
                                    THEN -1 * MovementItem.Amount
                               ELSE 0
                          END::TFloat AS AmountOut

                        , MovementFloat_AmountCurrency.ValueData AS AmountCurrency
                        , CASE WHEN MovementFloat_AmountSumm.ValueData <> 0 THEN MovementFloat_AmountSumm.ValueData * CASE WHEN MovementItem.Amount < 0 THEN 1 ELSE -1 END
                               WHEN ObjectDesc.Id = zc_Object_Cash() AND Object_Currency.Id <> zc_Enum_Currency_Basis() THEN -1 * MovementItem.Amount -- !!!с обратным знаком!!!
                          END :: TFloat AS AmountSumm

                        , MIDate_ServiceDate.ValueData      AS ServiceDate
                        , MIString_Comment.ValueData        AS Comment
                        , Object_Cash.ValueData             AS CashName
                        , Object_MoneyPlace.Id              AS MoneyPlaceId
                        , Object_MoneyPlace.ObjectCode      AS MoneyPlaceCode
                        , Object_MoneyPlace.ValueData       AS MoneyPlaceName
                        , Object_Juridical.Id               AS JuridicalId
                        , Object_Juridical.ObjectCode       AS JuridicalCode
                        , Object_Juridical.ValueData        AS JuridicalName
                        , Object_Retail.ValueData           AS RetailName
                        , ObjectHistory_JuridicalDetails_View.OKPO
                        , ObjectDesc.ItemName
                        , View_InfoMoney.InfoMoneyGroupName
                        , View_InfoMoney.InfoMoneyDestinationName
                        , View_InfoMoney.InfoMoneyId
                        , View_InfoMoney.InfoMoneyCode
                        , View_InfoMoney.InfoMoneyName
                        , View_InfoMoney.InfoMoneyName_all

                        , View_Contract_InvNumber.ContractId
                        , View_Contract_InvNumber.ContractCode
                        , View_Contract_InvNumber.InvNumber  AS ContractInvNumber
                        , View_Contract_InvNumber.ContractTagName

                        , Object_Branch.Id                   AS BranchId
                        , Object_Branch.ValueData            AS BranchName

                        , Object_Unit.ObjectCode             AS UnitCode
                        , Object_Unit.ValueData              AS UnitName

                        , Object_Personal.Id                 AS PersonalId
                        , Object_Personal.ObjectCode         AS PersonalCode
                        , Object_Personal.ValueData          AS PersonalName

                        , Object_Currency.ValueData                     AS CurrencyName
                        , Object_CurrencyPartner.ValueData              AS CurrencyPartnerName
                        , MovementFloat_CurrencyValue.ValueData         AS CurrencyValue
                        , MovementFloat_ParValue.ValueData              AS ParValue
                        , MovementFloat_CurrencyPartnerValue.ValueData  AS CurrencyPartnerValue
                        , MovementFloat_ParPartnerValue.ValueData       AS ParPartnerValue

                        , COALESCE (MovementBoolean_isLoad.ValueData, FALSE) :: Boolean AS isLoad

                        , zfCalc_PartionMovementName (Movement_PartionMovement.DescId, MovementDesc_PartionMovement.ItemName, Movement_PartionMovement.InvNumber, MovementDate_OperDatePartner_PartionMovement.ValueData) AS PartionMovementName

                        , Movement_Invoice.Id                 AS MovementId_Invoice
                        , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice
                        , MS_Comment_Invoice.ValueData        AS Comment_Invoice

                        , MovementDate_Insert.ValueData          AS InsertDate
                        , MovementDate_InsertMobile.ValueData    AS InsertMobileDate
                        , Object_User.ValueData                  AS InsertName
                        , Object_Unit_mobile.ValueData           AS UnitName_Mobile
                        , CASE WHEN MovementString_GUID.ValueData <> '' THEN Object_Position_mobile.ValueData ELSE '' END :: TVarChar AS PositionName_Mobile
                        , MovementString_GUID.ValueData          AS GUID

                        , MILinkObject_Currency.ObjectId     AS CurrencyId_x
                        , MovementItem.MovementId            AS MovementId_x
                        , MovementFloat_AmountSumm.ValueData AS AmountSumm_x

                        -- расч. курс на дату - для курс разн.
                        , CASE WHEN (SELECT SUM (tmp.Amount)
                                     FROM (SELECT tmpMIContainer.Amount_Container - COALESCE (SUM (tmpMIContainer.Amount), 0) AS Amount
                                           FROM tmpMIContainer_SummCurrency AS tmpMIContainer
                                           WHERE tmpMIContainer.OperDate >= tmpMovement.OperDate - INTERVAL '0 DAY'
                                           GROUP BY tmpMIContainer.ContainerId, tmpMIContainer.Amount_Container
                                          ) AS tmp
                                    ) <> 0
                               THEN
                                    (SELECT SUM (tmp.Amount)
                                     FROM (SELECT tmpMIContainer.Amount_Container - COALESCE (SUM (tmpMIContainer.Amount), 0) AS Amount
                                           FROM tmpMIContainer_Summ AS tmpMIContainer
                                           WHERE tmpMIContainer.OperDate >= tmpMovement.OperDate - INTERVAL '0 DAY'
                                           GROUP BY tmpMIContainer.ContainerId, tmpMIContainer.Amount_Container
                                          ) AS tmp
                                    )
                                    /
                                    (SELECT SUM (tmp.Amount)
                                     FROM (SELECT tmpMIContainer.Amount_Container - COALESCE (SUM (tmpMIContainer.Amount), 0) AS Amount
                                           FROM tmpMIContainer_SummCurrency AS tmpMIContainer
                                           WHERE tmpMIContainer.OperDate >= tmpMovement.OperDate - INTERVAL '0 DAY'
                                           GROUP BY tmpMIContainer.ContainerId, tmpMIContainer.Amount_Container
                                          ) AS tmp
                                    )
                               ELSE 0
                          END :: TFloat AS CurrencyValue_calc

                        -- факт. курс на дату - для курс разн.
                      , CASE WHEN MovementFloat_AmountCurrency.ValueData <> 0 THEN (ABS (MovementItem.Amount) + tmpMIС.Amount) / ABS (MovementFloat_AmountCurrency.ValueData) ELSE 0 END :: TFloat AS CurrencyValue_mi_calc

                      , COALESCE (tmpContainerBonus.Amount,0) :: TFloat  AS AmountBonus
                      , tmpContainerBonus.ContainerId         :: Integer AS ContainerId_bonus

                      , SUM (CASE WHEN MILinkObject_Currency.ObjectId <> inCurrencyId AND inCurrencyId = zc_Enum_Currency_Basis()
                                   AND MovementItem.Amount > 0
                                       THEN MovementFloat_AmountSumm.ValueData
                                  WHEN MILinkObject_Currency.ObjectId <> inCurrencyId AND inCurrencyId = zc_Enum_Currency_Basis()
                                       THEN 0
                                  WHEN MovementItem.Amount < 0
                                       THEN -1 * COALESCE (MovementItem.Amount,0)
                                  ELSE 0
                             END
                             ) OVER (PARTITION BY Object_Branch.Id, Object_Juridical.Id, View_InfoMoney.InfoMoneyId, View_Contract_InvNumber.ContractId, Object_MoneyPlace.Id)       ::TFloat  AS TotalAmountOut
                      , ROW_NUMBER() OVER (PARTITION BY Object_Branch.Id, Object_Juridical.Id, View_InfoMoney.InfoMoneyId, View_Contract_InvNumber.ContractId, Object_MoneyPlace.Id) ::Integer AS Ord
                    FROM tmpMovement

                         LEFT JOIN tmpMIС ON tmpMIС.MovementId = tmpMovement.Id

                         LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                                   ON MovementDate_Insert.MovementId = tmpMovement.Id
                                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                         LEFT JOIN tmpMovementDate AS MovementDate_InsertMobile
                                                   ON MovementDate_InsertMobile.MovementId = tmpMovement.Id
                                                  AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()
                         LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                                          ON MovementLinkObject_Insert.MovementId = tmpMovement.Id
                                         AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
                         LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId

                         LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                              ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                             AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()

                         LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
                         LEFT JOIN Object AS Object_Position_mobile ON Object_Position_mobile.Id = tmpPersonal.PositionId
                         LEFT JOIN Object AS Object_Unit_mobile ON Object_Unit_mobile.Id = tmpPersonal.UnitId

                         LEFT JOIN tmpMovementString_GUID AS MovementString_GUID
                                                          ON MovementString_GUID.MovementId = tmpMovement.Id

                         LEFT JOIN tmpMLM_Invoice AS MLM_Invoice
                                                  ON MLM_Invoice.MovementId = tmpMovement.Id
                                                 AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                         LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
                         LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
                         LEFT JOIN tmpMovementString_Invoice AS MovementString_InvNumberPartner
                                                             ON MovementString_InvNumberPartner.MovementId = Movement_Invoice.Id
                                                            AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                         LEFT JOIN tmpMovementString_Invoice AS MS_Comment_Invoice
                                                             ON MS_Comment_Invoice.MovementId = Movement_Invoice.Id
                                                            AND MS_Comment_Invoice.DescId = zc_MovementString_Comment()

                         LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = tmpMovement.Id

                         LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId

                         LEFT JOIN tmpMovementBoolean_isLoad AS MovementBoolean_isLoad
                                                             ON MovementBoolean_isLoad.MovementId = tmpMovement.Id

                         LEFT JOIN tmpMIFloat_MovementId AS MIFloat_MovementId
                                                         ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                         LEFT JOIN Movement AS Movement_PartionMovement ON Movement_PartionMovement.Id = MIFloat_MovementId.ValueData

                         LEFT JOIN MovementDesc AS MovementDesc_PartionMovement ON MovementDesc_PartionMovement.Id = Movement_PartionMovement.DescId
                         LEFT JOIN tmpMD_PartionMovement AS MovementDate_OperDatePartner_PartionMovement
                                                         ON MovementDate_OperDatePartner_PartionMovement.MovementId = Movement_PartionMovement.Id
                                                        AND MovementDate_OperDatePartner_PartionMovement.DescId = zc_MovementDate_OperDatePartner()

                         LEFT JOIN tmpMILO AS MILinkObject_MoneyPlace
                                           ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                          AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()


                         LEFT JOIN tmpMILO AS MILinkObject_InfoMoney
                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

                         LEFT JOIN tmpMILO AS MILinkObject_Contract
                                           ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                         LEFT JOIN tmpMILO AS MILinkObject_Unit
                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

                         LEFT JOIN tmpMILO AS MILinkObject_Branch
                                           ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

                         LEFT JOIN tmpMIDate_ServiceDate AS MIDate_ServiceDate
                                                         ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                                        AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                                        AND MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_60101() -- Заработная плата + Заработная плата
                                                        AND MILinkObject_MoneyPlace.ObjectId > 0
                         LEFT JOIN tmpMIString_Comment AS MIString_Comment
                                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                                      AND MIString_Comment.DescId = zc_MIString_Comment()

                         -- Ограничили - Только одной валютой
                         LEFT JOIN tmpMILO AS MILinkObject_Currency
                                           ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()

                         LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MILinkObject_Currency.ObjectId

                         LEFT JOIN tmpMILO AS MILinkObject_CurrencyPartner
                                           ON MILinkObject_CurrencyPartner.MovementItemId = MovementItem.Id
                                          AND MILinkObject_CurrencyPartner.DescId = zc_MILinkObject_CurrencyPartner()
                         LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MILinkObject_CurrencyPartner.ObjectId

                         LEFT JOIN tmpMovementFloat AS MovementFloat_AmountCurrency
                                                    ON MovementFloat_AmountCurrency.MovementId = tmpMovement.Id
                                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
                         LEFT JOIN tmpMovementFloat AS MovementFloat_AmountSumm
                                                    ON MovementFloat_AmountSumm.MovementId = tmpMovement.Id
                                                   AND MovementFloat_AmountSumm.DescId = zc_MovementFloat_Amount()

                         LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyValue
                                                    ON MovementFloat_CurrencyValue.MovementId = tmpMovement.Id
                                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                         LEFT JOIN tmpMovementFloat AS MovementFloat_ParValue
                                                    ON MovementFloat_ParValue.MovementId = tmpMovement.Id
                                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
                         LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyPartnerValue
                                                    ON MovementFloat_CurrencyPartnerValue.MovementId = tmpMovement.Id
                                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
                         LEFT JOIN tmpMovementFloat AS MovementFloat_ParPartnerValue
                                                    ON MovementFloat_ParPartnerValue.MovementId = tmpMovement.Id
                                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

                         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                              ON ObjectLink_Partner_Juridical.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                         FULL JOIN tmpContainerBonus ON tmpContainerBonus.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MILinkObject_MoneyPlace.ObjectId)
                                                    AND tmpContainerBonus.PartnerId   = MILinkObject_MoneyPlace.ObjectId
                                                    AND tmpContainerBonus.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
                                                    AND COALESCE (tmpContainerBonus.BranchId,0)   = COALESCE (MILinkObject_Branch.ObjectId,0)
                                                    AND COALESCE (tmpContainerBonus.ContractId,0) = COALESCE (MILinkObject_Contract.ObjectId,0)

                         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (tmpContainerBonus.JuridicalId, ObjectLink_Partner_Juridical.ChildObjectId, MILinkObject_MoneyPlace.ObjectId)
                                                             AND Object_Juridical.DescId = zc_Object_Juridical()
                         LEFT JOIN tmpJuridicalDetails_View AS ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

                         LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = COALESCE (MILinkObject_MoneyPlace.ObjectId, tmpContainerBonus.PartnerId)
                         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId
                         LEFT JOIN tmpInfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (MILinkObject_InfoMoney.ObjectId, tmpContainerBonus.InfoMoneyId)

                         LEFT JOIN tmpContract_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = COALESCE (MILinkObject_Contract.ObjectId, tmpContainerBonus.ContractId)

                         LEFT JOIN ObjectLink AS OL_Cash_Branch
                                              ON OL_Cash_Branch.ObjectId = Object_Cash.Id
                                             AND OL_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()

                         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = COALESCE (tmpContainerBonus.BranchId, MILinkObject_Branch.ObjectId, OL_Cash_Branch.ChildObjectId)

                         LEFT JOIN ObjectLink AS OL_Juridical_Retail
                                              ON OL_Juridical_Retail.ObjectId = Object_Juridical.Id
                                             AND OL_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                         LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = OL_Juridical_Retail.ChildObjectId

                         LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                              ON ObjectLink_Partner_Personal.ObjectId = Object_MoneyPlace.Id
                                             AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
                         LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Partner_Personal.ChildObjectId
                    WHERE (View_InfoMoney.InfoMoneyId = inInfoMoneyId OR (inInfoMoneyId = 0 AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21502(), zc_Enum_InfoMoney_21512(), zc_Enum_InfoMoney_21512()) ))
                       AND (OL_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                       AND (ObjectLink_Partner_Personal.ChildObjectId = inPersonalId OR inPersonalId = 0)
                   )

       SELECT tmpRes.Id
            , tmpRes.InvNumber
            , tmpRes.OperDate
            , tmpRes.StatusCode
            , tmpRes.StatusName
            , tmpRes.AmountIn
            , tmpRes.AmountOut
            , tmpRes.AmountCurrency
            , tmpRes.AmountSumm
            , tmpRes.ServiceDate
            , tmpRes.Comment
            , tmpRes.CashName
            , tmpRes.MoneyPlaceId
            , tmpRes.MoneyPlaceCode
            , tmpRes.MoneyPlaceName
            , tmpRes.JuridicalId
            , tmpRes.JuridicalCode
            , tmpRes.JuridicalName
            , tmpRes.RetailName
            , tmpRes.OKPO
            , tmpRes.ItemName
            , tmpRes.InfoMoneyGroupName
            , tmpRes.InfoMoneyDestinationName
            , tmpRes.InfoMoneyId
            , tmpRes.InfoMoneyCode
            , tmpRes.InfoMoneyName
            , tmpRes.InfoMoneyName_all
            , tmpRes.ContractId
            , tmpRes.ContractCode
            , tmpRes.ContractInvNumber
            , tmpRes.ContractTagName
            , tmpRes.BranchId
            , tmpRes.BranchName
            , tmpRes.UnitCode
            , tmpRes.UnitName
            , tmpRes.CurrencyName
            , tmpRes.CurrencyPartnerName
            , tmpRes.CurrencyValue
            , tmpRes.ParValue
            , tmpRes.CurrencyPartnerValue
            , tmpRes.ParPartnerValue
            , tmpRes.isLoad
            , tmpRes.PartionMovementName
            , tmpRes.MovementId_Invoice
            , tmpRes.InvNumber_Invoice
            , tmpRes.Comment_Invoice
            , tmpRes.InsertDate
            , tmpRes.InsertMobileDate
            , tmpRes.InsertName
            , tmpRes.UnitName_Mobile
            , tmpRes.PositionName_Mobile
            , tmpRes.GUID
            , tmpRes.CurrencyId_x
            , tmpRes.MovementId_x
            , tmpRes.AmountSumm_x
            , tmpRes.CurrencyValue_calc
            , tmpRes.CurrencyValue_mi_calc

            , CASE WHEN tmpRes.Ord = 1 THEN COALESCE (tmpRes.AmountBonus,0) ELSE 0 END ::TFloat AS SummToPay
            , CASE WHEN tmpRes.Ord = 1 THEN COALESCE (tmpRes.TotalAmountOut,0)   ELSE 0 END ::TFloat AS SummPay
            , CASE WHEN tmpRes.Ord = 1 THEN (COALESCE(tmpRes.AmountBonus,0) - COALESCE (tmpRes.TotalAmountOut,0)) ELSE 0 END ::TFloat AS RemainsToPay

            , tmpRes.ContainerId_bonus
            
            , Object_Area.Id                  AS AreaId
            , Object_Area.ValueData           AS AreaName
            
            , tmpRes.PersonalId
            , tmpRes.PersonalCode
            , tmpRes.PersonalName

       FROM tmpRes
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                              ON ObjectLink_Partner_Area.ObjectId = tmpRes.MoneyPlaceId
                             AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.20         *
*/

-- тест
-- SELECT * FROM  Object where ValueData like '%Розница Одесса%'
-- SELECT * FROM gpSelect_Movement_Cash_Bonus(inStartDate := ('01.08.2020')::TDateTime , inEndDate := ('05.08.2020')::TDateTime , inCashId := 0 , inCurrencyId := 0, inJuridicalBasisId := 9399 , inInfoMoneyId:= 0, inBranchId:=0, inRetailId:=524072, inJuridicalId := 0, inIsErased := 'False' ,  inSession := '5');
-- SELECT * FROM gpSelect_Movement_Cash_Bonus(inStartDate := ('01.08.2024')::TDateTime , inEndDate := ('05.08.2024')::TDateTime , inCashId := 14462 , inCurrencyId := 0, inJuridicalBasisId := 0 , inInfoMoneyId:= 0, inBranchId:=0, inRetailId:=0, inJuridicalId := 0, inIsErased := 'False' ,  inSession := '5567897');
