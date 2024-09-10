-- Function: gpSelect_Movement_Cash()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cash (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cash(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inCashId           Integer , --
    IN inCurrencyId       Integer , --
    IN inJuridicalBasisId Integer   , -- Главное юр.лицо
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat

               -- Сумма в валюте
             , AmountCurrency TFloat
               -- Cумма грн, обмен
             , AmountSumm TFloat
               -- факт. курс на дату - для курс разн.
             , CurrencyValue_mi_calc TFloat
               -- расч. курс на дату - для курс разн.
             , CurrencyValue_calc    TFloat

             , ServiceDate TDateTime
             , Comment TVarChar
             , CashName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceCode Integer, MoneyPlaceName TVarChar, OKPO TVarChar, ItemName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , MemberName TVarChar, PositionName TVarChar, PersonalServiceListId Integer, PersonalServiceListCode Integer, PersonalServiceListName TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , CarId Integer, CarName TVarChar
             , CarModelId Integer, CarModelName TVarChar
             , UnitId_Car Integer, UnitName_Car TVarChar
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

             , ProfitLossGroupName     TVarChar
             , ProfitLossDirectionName TVarChar
             , ProfitLossName          TVarChar
             , ProfitLossName_all      TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCount Integer;
   DECLARE vbUser_all Boolean;
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

     -- Блокируем ему просмотр за ДРУГОЙ период
     ELSEIF EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_CashReplace() AND UserId = vbUserId)
        -- AND inCashId    <> 296540 -- Касса Днепр БН
        AND (inStartDate < zc_DateStart_Role_CashReplace() OR inStartDate > zc_DateEnd_Role_CashReplace()
          OR inEndDate   < zc_DateStart_Role_CashReplace() OR inEndDate   > zc_DateEnd_Role_CashReplace()
          OR inCashId    <> 14462 -- Касса Днепр
            )
     THEN
         IF inStartDate < zc_DateStart_Role_CashReplace() OR inStartDate > zc_DateEnd_Role_CashReplace() THEN inStartDate:= zc_DateStart_Role_CashReplace(); END IF;
         IF inEndDate   < zc_DateStart_Role_CashReplace() OR inEndDate   > zc_DateEnd_Role_CashReplace() THEN inEndDate  := zc_DateEnd_Role_CashReplace();   END IF;

     END IF;
     
     vbUser_all:= EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId      = zc_Enum_Role_Admin()
                    UNION SELECT 1 AS Id FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND AccessKeyId = zc_Enum_Process_AccessKey_CashAll()
                         )
                  -- Касса карта Любарского Г.О. + Касса карта Сохбатовой Е.
              AND inCashId NOT IN (10575420, 10575421)
               ;

-- "Коротченко Т.Н."
-- if vbUserId <> 14599 or 1=1 then 

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
                                                 AND Movement.OperDate BETWEEN tmpAll.StartDate AND tmpAll.EndDate -- inStartDate AND inEndDate
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
                       -- AND MovementItem.ObjectId = inCashId
                     )
         , tmpMI AS (SELECT MovementItem.*
                     FROM tmpMovement
                          INNER JOIN tmpMI2 AS MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 AND (MovementItem.ObjectId = inCashId
                                                   OR (inCashId = 0 AND vbUser_all = TRUE)
                                                     )
                     )
         -- проводки
       , tmpMIС_1 AS (SELECT MovementItemContainer.MovementId, MAX (MovementItemContainer.ContainerId) AS ContainerId
                           , SUM (-1 * MovementItemContainer.Amount) AS Amount
                      FROM MovementItemContainer
                      WHERE MovementItemContainer.MovementId        IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                        AND MovementItemContainer.DescId            = zc_MIContainer_Summ()
                        AND MovementItemContainer.AccountId         = zc_Enum_Account_100301()   -- прибыль текущего периода
                      --AND MovementItemContainer.ObjectId_Analyzer = zc_Enum_ProfitLoss_80103() -- Курсовая разница
                      --AND inCurrencyId                            <> zc_Enum_Currency_Basis()
                      GROUP BY MovementItemContainer.MovementId
                     )
         -- проводки
       , tmpMIС_2 AS (SELECT MovementItemContainer.MovementId
                           , MAX (CASE WHEN MovementItemContainer.AccountId = zc_Enum_Account_100301() THEN MovementItemContainer.ContainerId ELSE 0 END) AS ContainerId
                           , SUM (1 * CASE WHEN MovementItemContainer.AccountId = zc_Enum_Account_40801() THEN 0 * MovementItemContainer.Amount ELSE 0 END) AS Amount
                      FROM MovementItemContainer
                      WHERE MovementItemContainer.MovementId        IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                        AND MovementItemContainer.DescId            = zc_MIContainer_Summ()
                        AND MovementItemContainer.AccountId         IN (zc_Enum_Account_40801()    -- Курсовая разница
                                                                      , zc_Enum_Account_100301()   -- прибыль текущего периода
                                                                       )
                        AND MovementItemContainer.ObjectId_Analyzer <> zc_Enum_ProfitLoss_80103() -- Курсовая разница
                        --AND vbUserId = 5
                      GROUP BY MovementItemContainer.MovementId
                     )
           -- проводки
         , tmpMIС AS (SELECT tmpMIС_1.MovementId, tmpMIС_1.ContainerId, tmpMIС_1.Amount
                      FROM tmpMIС_1
                           LEFT JOIN tmpMIС_2 ON tmpMIС_2.MovementId = tmpMIС_1.MovementId
                      WHERE tmpMIС_2.MovementId IS NULL

                     UNION ALL
                      SELECT tmpMIС_2.MovementId, tmpMIС_2.ContainerId, tmpMIС_2.Amount
                      FROM tmpMIС_2
                     )

         , tmpMIС_ProfitLoss AS (SELECT CLO_ProfitLoss.ContainerId
                                      , CLO_ProfitLoss.ObjectId AS ProfitLossId
                                 FROM ContainerLinkObject AS CLO_ProfitLoss
                                 WHERE CLO_ProfitLoss.ContainerId IN (SELECT DISTINCT tmpMIС_2.ContainerId FROM tmpMIС_2)
                                   AND CLO_ProfitLoss.DescId      = zc_ContainerLinkObject_ProfitLoss()
                                )
         , tmpProfitLoss_View AS (SELECT * FROM Object_ProfitLoss_View WHERE Object_ProfitLoss_View.ProfitLossId IN (SELECT DISTINCT tmpMIС_ProfitLoss.ProfitLossId FROM tmpMIС_ProfitLoss))

           -- остаток суммы на дату в Валюте
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
                       AND CLO_Cash.ObjectId    = inCashId
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
                       AND CLO_Cash.ObjectId    = inCashId
                       AND inCurrencyId         <> zc_Enum_Currency_Basis()
                    )
           --
         , tmpMIContainer_SummCurrency AS
                    (SELECT MIContainer.* --, tmpListContainer_SummCurrency.Amount AS Amount_Container
                     FROM tmpListContainer_SummCurrency
                          INNER JOIN MovementItemContainer AS MIContainer
                                                           ON MIContainer.ContainerId = tmpListContainer_SummCurrency.ContainerId_Currency
                                                          AND MIContainer.OperDate    >= inStartDate
                    )
           --
         , tmpMIContainer_Summ AS
                    (SELECT MIContainer.* -- , tmpListContainer_Summ.Amount AS Amount_Container
                     FROM tmpListContainer_Summ
                          INNER JOIN MovementItemContainer AS MIContainer
                                                           ON MIContainer.ContainerId = tmpListContainer_Summ.ContainerId
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
                                                             , zc_MILinkObject_Member()
                                                             , zc_MILinkObject_Position()
                                                             , zc_MILinkObject_Contract()
                                                             , zc_MILinkObject_Unit()
                                                             , zc_MILinkObject_Currency()
                                                             , zc_MILinkObject_CurrencyPartner()
                                                             , zc_MILinkObject_Car()
                                                             )
                      )

         , tmpContract_View AS (SELECT Object_Contract_InvNumber_View.*
                                FROM Object_Contract_InvNumber_View
                                WHERE Object_Contract_InvNumber_View.ContractId IN (SELECT DISTINCT MILinkObject_Contract.ObjectId FROM tmpMILO AS MILinkObject_Contract WHERE MILinkObject_Contract.DescId = zc_MILinkObject_Contract())
                               )
         , tmpInfoMoney_View AS (SELECT * FROM Object_InfoMoney_View)
         , tmpJuridicalDetails_View AS (SELECT *
                                        FROM ObjectHistory_JuridicalDetails_View
                                        WHERE ObjectHistory_JuridicalDetails_View.JuridicalId
                                              IN (SELECT DISTINCT ObjectLink_Partner_Juridical.ChildObjectId
                                                  FROM tmpMILO AS MILinkObject_MoneyPlace
                                                       INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                          ON ObjectLink_Partner_Juridical.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                  WHERE MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                                 )
                                       )
            -- LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId
            -- LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
            -- LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

       -- Результат
      , tmpRes AS
      (SELECT
             tmpMovement.Id
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

             -- Сумма в валюте
           , MovementFloat_AmountCurrency.ValueData AS AmountCurrency
             -- Cумма грн, обмен
           , CASE WHEN MovementFloat_AmountSumm.ValueData <> 0 THEN MovementFloat_AmountSumm.ValueData * CASE WHEN MovementItem.Amount < 0 THEN 1 ELSE -1 END
                  WHEN ObjectDesc.Id = zc_Object_Cash() AND Object_Currency.Id <> zc_Enum_Currency_Basis() THEN -1 * MovementItem.Amount -- !!!с обратным знаком!!!
             END :: TFloat AS AmountSumm

           -- факт. курс на дату - для курс разн.
         , CASE WHEN MovementFloat_AmountCurrency.ValueData <> 0 THEN ABS (MovementItem.Amount + COALESCE (tmpMIС.Amount, 0)) / ABS (MovementFloat_AmountCurrency.ValueData) ELSE 0 END :: TFloat AS CurrencyValue_mi_calc

--       , MovementFloat_CurrencyPartnerValue.ValueData  AS CurrencyPartnerValue
--       , MovementFloat_ParPartnerValue.ValueData       AS ParPartnerValue
--       , MovementFloat_AmountCurrency.ValueData

             -- расч. курс на дату - для курс разн.
           , CASE WHEN (SELECT SUM (tmp.Amount)
                        FROM (SELECT tmpListContainer_SummCurrency.Amount - COALESCE (SUM (tmpMIContainer.Amount), 0) AS Amount
                              FROM tmpListContainer_SummCurrency
                                   LEFT JOIN tmpMIContainer_SummCurrency AS tmpMIContainer
                                                                         ON tmpMIContainer.ContainerId = tmpListContainer_SummCurrency.ContainerId_Currency
                                                                         -- курс на конец дня 
                                                                        AND tmpMIContainer.OperDate >= CASE WHEN tmpMovement.OperDate >= '01.08.2024' THEN tmpMovement.OperDate + INTERVAL '1 DAY' ELSE tmpMovement.OperDate - INTERVAL '0 DAY' END
                              GROUP BY tmpListContainer_SummCurrency.ContainerId_Currency, tmpListContainer_SummCurrency.Amount
                             ) AS tmp
                       ) <> 0
                  THEN
                       (SELECT SUM (tmp.Amount)
                        FROM (SELECT tmpListContainer_Summ.Amount - COALESCE (SUM (tmpMIContainer.Amount), 0) AS Amount
                              FROM tmpListContainer_Summ
                                   LEFT JOIN tmpMIContainer_Summ AS tmpMIContainer
                                                                 ON tmpMIContainer.ContainerId = tmpListContainer_Summ.ContainerId
                                                                AND tmpMIContainer.OperDate >= CASE WHEN tmpMovement.OperDate >= '01.08.2024' THEN tmpMovement.OperDate + INTERVAL '1 DAY' ELSE tmpMovement.OperDate - INTERVAL '0 DAY' END
                              GROUP BY tmpListContainer_Summ.ContainerId, tmpListContainer_Summ.Amount
                             ) AS tmp
                       )
                      /
                       (SELECT SUM (tmp.Amount)
                        FROM (SELECT tmpListContainer_SummCurrency.Amount - COALESCE (SUM (tmpMIContainer.Amount), 0) AS Amount
                              FROM tmpListContainer_SummCurrency
                                   LEFT JOIN tmpMIContainer_SummCurrency AS tmpMIContainer
                                                                         ON tmpMIContainer.ContainerId = tmpListContainer_SummCurrency.ContainerId_Currency
                                                                        AND tmpMIContainer.OperDate >= CASE WHEN tmpMovement.OperDate >= '01.08.2024' THEN tmpMovement.OperDate + INTERVAL '1 DAY' ELSE tmpMovement.OperDate - INTERVAL '0 DAY' END
                              GROUP BY tmpListContainer_SummCurrency.ContainerId_Currency, tmpListContainer_SummCurrency.Amount
                             ) AS tmp
                       )
                  ELSE 0
             END :: TFloat AS CurrencyValue_calc


           , MIDate_ServiceDate.ValueData      AS ServiceDate
           , MIString_Comment.ValueData        AS Comment
           , Object_Cash.ValueData             AS CashName
           , Object_MoneyPlace.Id              AS MoneyPlaceId
           , Object_MoneyPlace.ObjectCode      AS MoneyPlaceCode
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName
           , ObjectHistory_JuridicalDetails_View.OKPO
           , ObjectDesc.ItemName
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all
           , Object_Member.ValueData            AS MemberName
           , Object_Position.ValueData          AS PositionName
           , Object_PersonalServiceList.Id         AS PersonalServiceListId
           , Object_PersonalServiceList.ObjectCode AS PersonalServiceListCode
           , Object_PersonalServiceList.ValueData  AS PersonalServiceListName
           , View_Contract_InvNumber.ContractCode
           , View_Contract_InvNumber.InvNumber  AS ContractInvNumber
           , View_Contract_InvNumber.ContractTagName
           , Object_Unit.ObjectCode             AS UnitCode
           , Object_Unit.ValueData              AS UnitName

           , Object_Car.Id                      AS CarId
           , Object_Car.ValueData               AS CarName
           , Object_CarModel.Id                 AS CarModelId
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , Object_Unit_Car.Id                 AS UnitId_Car
           , Object_Unit_Car.ValueData          AS UnitName_Car

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

         , tmpProfitLoss_View.ProfitLossGroupName     ::TVarChar
         , tmpProfitLoss_View.ProfitLossDirectionName ::TVarChar
         , tmpProfitLoss_View.ProfitLossName          ::TVarChar
         , tmpProfitLoss_View.ProfitLossName_all      ::TVarChar
       FROM tmpMovement

            LEFT JOIN tmpMIС ON tmpMIС.MovementId = tmpMovement.Id
            LEFT JOIN tmpMIС_ProfitLoss ON tmpMIС_ProfitLoss.ContainerId = tmpMIС.ContainerId
            LEFT JOIN tmpProfitLoss_View ON tmpProfitLoss_View.ProfitLossId = tmpMIС_ProfitLoss.ProfitLossId

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
                                -- AND MovementString_GUID.ValueData <> ''
            LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
            LEFT JOIN Object AS Object_Position_mobile ON Object_Position_mobile.Id = tmpPersonal.PositionId
            LEFT JOIN Object AS Object_Unit_mobile ON Object_Unit_mobile.Id = tmpPersonal.UnitId

            LEFT JOIN tmpMovementString_GUID AS MovementString_GUID
                                             ON MovementString_GUID.MovementId = tmpMovement.Id
                                  --  AND MovementString_GUID.DescId = zc_MovementString_GUID()

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

         -- INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = tmpMovement.Id
            LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                 --  AND MovementItem.DescId = zc_MI_Master()
                                 --  AND MovementItem.ObjectId = inCashId
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId

            LEFT JOIN tmpMovementBoolean_isLoad AS MovementBoolean_isLoad
                                                ON MovementBoolean_isLoad.MovementId = tmpMovement.Id
                                              -- AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()

            LEFT JOIN tmpMIFloat_MovementId AS MIFloat_MovementId
                                            ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                           AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_PartionMovement ON Movement_PartionMovement.Id = MIFloat_MovementId.ValueData

            LEFT JOIN MovementDesc AS MovementDesc_PartionMovement ON MovementDesc_PartionMovement.Id = Movement_PartionMovement.DescId
            LEFT JOIN tmpMD_PartionMovement AS MovementDate_OperDatePartner_PartionMovement
                                            ON MovementDate_OperDatePartner_PartionMovement.MovementId = Movement_PartionMovement.Id
                                           AND MovementDate_OperDatePartner_PartionMovement.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                         ON MLO_PersonalServiceList.MovementId = tmpMovement.Id
                                        AND MLO_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MLO_PersonalServiceList.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_MoneyPlace
                              ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                             AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN tmpJuridicalDetails_View AS ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

            LEFT JOIN tmpMILO AS MILinkObject_InfoMoney
                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN tmpInfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Member
                              ON MILinkObject_Member.MovementItemId = MovementItem.Id
                             AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MILinkObject_Member.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Position
                              ON MILinkObject_Position.MovementItemId = MovementItem.Id
                             AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Contract
                              ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN tmpContract_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Unit
                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN tmpMIDate_ServiceDate AS MIDate_ServiceDate
                                            ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                           AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                           AND MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_60101() -- Заработная плата + Заработная плата
                                           AND MILinkObject_MoneyPlace.ObjectId > 0
            LEFT JOIN tmpMIString_Comment AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

            -- Ограничили - Только одной валютой
         -- INNER JOIN tmpMILO AS MILinkObject_Currency
            LEFT JOIN tmpMILO AS MILinkObject_Currency
                              ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                             AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()

            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MILinkObject_Currency.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_CurrencyPartner
                              ON MILinkObject_CurrencyPartner.MovementItemId = MovementItem.Id
                             AND MILinkObject_CurrencyPartner.DescId = zc_MILinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MILinkObject_CurrencyPartner.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Car
                              ON MILinkObject_Car.MovementItemId = MovementItem.Id
                             AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MILinkObject_Car.ObjectId

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

            --свойства авто
            LEFT JOIN ObjectLink AS Car_CarModel
                                 ON Car_CarModel.ObjectId = MILinkObject_Car.ObjectId
                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = MILinkObject_Car.ObjectId
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                 ON ObjectLink_Car_Unit.ObjectId = MILinkObject_Car.ObjectId
                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object AS Object_Unit_Car ON Object_Unit_Car.Id = ObjectLink_Car_Unit.ChildObjectId
            --
    -- WHERE MILinkObject_Currency.ObjectId = inCurrencyId
    --    OR (inCurrencyId = zc_Enum_Currency_Basis() AND MovementFloat_AmountSumm.ValueData <> 0)
      )

       SELECT *
       FROM tmpRes
       WHERE (tmpRes.CurrencyId_x = inCurrencyId
           OR (inCurrencyId = zc_Enum_Currency_Basis() AND tmpRes.AmountSumm_x <> 0)
           OR (inCurrencyId = 0 AND vbUser_all = TRUE)
             )
          AND tmpRes.MovementId_x > 0
       ;
       

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.10.21         * add ProfitLossId
 09.01.19         * немного оптимизации
 01.09.18         * add Car
 21.05.17         * add CurrencyPartner
 06.10.16         * add inJuridicalBasisId
 26.07.16         * invoice
 17.04.16         * add inCurrencyid
 27.04.15         * add InvNumber_Sale
 06.03.15         * add Currency...
 30.08.14                                        * all
 14.01.14                                        * add Object_Contract_InvNumber_View
 26.12.13                                        * add View_InfoMoney
 26.12.13                                        * add Object_RoleAccessKey_View
 23.12.13                          *
 09.08.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cash (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inCashId:= 14462, inCurrencyId:= zc_Enum_Currency_Basis(), inJuridicalBasisId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Movement_Cash (inStartDate:= '30.01.2016', inEndDate:= '30.01.2016', inCashId:= 14462, inCurrencyId:= zc_Enum_Currency_Basis(), inJuridicalBasisId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Movement_Cash (inStartDate:= ('09.09.2024')::TDateTime , inEndDate := ('10.09.2024')::TDateTime , inCashId := 14462 , inCurrencyId :=  zc_Enum_Currency_Basis() , inJuridicalBasisId := 0 , inIsErased := 'False' ,  inSession := '5');
