-- Function: gpSelect_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (TDateTime, TDateTime, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_BankAccount(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- Главное юр.лицо 
    IN inAccountId         Integer   , -- (Павильоны) -  10895486   ()
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumber_Parent TVarChar, BankSInvNumber_Parent TVarChar, ParentId Integer
             , OperDate TDateTime
             , ServiceDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , AmountSumm TFloat
             , AmountCurrency TFloat
             , Comment TVarChar
             , BankAccountName TVarChar, BankName TVarChar, MFO TVarChar
             , JuridicalName TVarChar, OKPO_BankAccount TVarChar
             , MoneyPlaceId Integer , MoneyPlaceCode Integer, MoneyPlaceName TVarChar, ItemName TVarChar, OKPO TVarChar, OKPO_Parent TVarChar 
             , PartnerId Integer, PartnerName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , CurrencyName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , PartnerBankName TVarChar, PartnerBankMFO TVarChar, PartnerBankAccountName TVarChar
             , isCopy Boolean
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar

             , ProfitLossGroupName     TVarChar
             , ProfitLossDirectionName TVarChar
             , ProfitLossName          TVarChar
             , ProfitLossName_all      TVarChar
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsIrna   Boolean;
   DECLARE vbMemberId Integer;
   DECLARE vbIsExists Boolean;
   DECLARE vbCount    Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- !!!Ирна!!!
     vbIsIrna:= zfCalc_User_isIrna (vbUserId);

     -- проверка доступа
     vbMemberId := (SELECT ObjectLink_User_Member.ChildObjectId AS MemberId
                    FROM ObjectLink AS ObjectLink_User_Member
                    WHERE ObjectLink_User_Member.ObjectId = vbUserId
                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                   );

     --
     vbIsExists:= EXISTS (SELECT BankAccount_Juridical.ChildObjectId AS JuridicalId
                          FROM ObjectLink AS ObjectLink_MemberBankAccount_Member
                              INNER JOIN Object AS Object_MemberBankAccount
                                                ON Object_MemberBankAccount.Id = ObjectLink_MemberBankAccount_Member.ObjectId
                                               AND Object_MemberBankAccount.DescId = zc_Object_MemberBankAccount()
                                               AND Object_MemberBankAccount.isErased = FALSE
            
                              INNER JOIN ObjectLink AS ObjectLink_MemberBankAccount_BankAccount
                                                    ON ObjectLink_MemberBankAccount_BankAccount.ObjectId = ObjectLink_MemberBankAccount_Member.ObjectId
                                                   AND ObjectLink_MemberBankAccount_BankAccount.DescId = zc_ObjectLink_MemberBankAccount_BankAccount()
                   
                              INNER JOIN ObjectLink AS BankAccount_Juridical
                                                    ON BankAccount_Juridical.ObjectId      = ObjectLink_MemberBankAccount_BankAccount.ChildObjectId
                                                   AND BankAccount_Juridical.DescId        = zc_ObjectLink_BankAccount_Juridical()
                                                   AND BankAccount_Juridical.ChildObjectId = inJuridicalBasisId
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_All 
                                                      ON ObjectBoolean_All.ObjectId = ObjectLink_MemberBankAccount_Member.ObjectId
                                                     AND ObjectBoolean_All.DescId = zc_ObjectBoolean_MemberBankAccount_All()
                                                     AND COALESCE (ObjectBoolean_All.ValueData, FALSE) = FALSE
                          WHERE ObjectLink_MemberBankAccount_Member.DescId = zc_ObjectLink_MemberBankAccount_Member()
                            AND ObjectLink_MemberBankAccount_Member.ChildObjectId = vbMemberId
                         );
     --
     vbCount:=COALESCE ((SELECT COUNT(*)
                         FROM ObjectLink AS ObjectLink_MemberBankAccount_Member
                             INNER JOIN Object AS Object_MemberBankAccount
                                               ON Object_MemberBankAccount.Id = ObjectLink_MemberBankAccount_Member.ObjectId
                                              AND Object_MemberBankAccount.DescId = zc_Object_MemberBankAccount()
                                              AND Object_MemberBankAccount.isErased = FALSE
                      
                             INNER JOIN ObjectLink AS ObjectLink_MemberBankAccount_BankAccount
                                                   ON ObjectLink_MemberBankAccount_BankAccount.ObjectId = ObjectLink_MemberBankAccount_Member.ObjectId
                                                  AND ObjectLink_MemberBankAccount_BankAccount.DescId = zc_ObjectLink_MemberBankAccount_BankAccount()
                        
                             INNER JOIN ObjectLink AS BankAccount_Juridical
                                                   ON BankAccount_Juridical.ObjectId      = ObjectLink_MemberBankAccount_BankAccount.ChildObjectId
                                                  AND BankAccount_Juridical.DescId        = zc_ObjectLink_BankAccount_Juridical()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_All 
                                                     ON ObjectBoolean_All.ObjectId = ObjectLink_MemberBankAccount_Member.ObjectId
                                                    AND ObjectBoolean_All.DescId = zc_ObjectBoolean_MemberBankAccount_All()
                                                    AND COALESCE (ObjectBoolean_All.ValueData, FALSE) = FALSE
                         WHERE ObjectLink_MemberBankAccount_Member.DescId = zc_ObjectLink_MemberBankAccount_Member()
                           AND ObjectLink_MemberBankAccount_Member.ChildObjectId = vbMemberId
                        ), 0);

     --
     IF COALESCE (inJuridicalBasisId = 0) AND vbCount <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав на просмотрт документов по всем Главным юр.лицам.';
     END IF;
     --
     IF COALESCE (inJuridicalBasisId <> 0) AND vbIsExists = FALSE AND vbCount <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав на просмотрт документов по Главному юр.лицу <%>.', lfGet_Object_ValueData_sh (inJuridicalBasisId);
     END IF;


     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
         , tmpMovement AS (SELECT Movement.*
                           FROM tmpStatus
                               JOIN Movement ON Movement.DescId = zc_Movement_BankAccount()
                                            AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                            AND Movement.StatusId = tmpStatus.StatusId
                           )

         , tmpMI AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementItem.DescId = zc_MI_Master()
                     )

         -- ProfitLoss из проводок
         , tmpMIС AS (SELECT DISTINCT MovementItemContainer.MovementId, MovementItemContainer.ContainerId
                      FROM MovementItemContainer
                      WHERE MovementItemContainer.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                        AND MovementItemContainer.DescId     = zc_MIContainer_Summ()
                        AND MovementItemContainer.AccountId  = zc_Enum_Account_100301()   -- прибыль текущего периода
                        AND 1=0
                     )
         , tmpMIС_ProfitLoss AS (SELECT DISTINCT CLO_ProfitLoss.ContainerId
                                      , CLO_ProfitLoss.ObjectId AS ProfitLossId
                                 FROM ContainerLinkObject AS CLO_ProfitLoss
                                 WHERE CLO_ProfitLoss.ContainerId IN (SELECT DISTINCT tmpMIС.ContainerId FROM tmpMIС)
                                   AND CLO_ProfitLoss.DescId      = zc_ContainerLinkObject_ProfitLoss()
                                   AND 1=0
                                )
         , tmpProfitLoss_View AS (SELECT * FROM Object_ProfitLoss_View WHERE Object_ProfitLoss_View.ProfitLossId IN (SELECT tmpMIС_ProfitLoss.ProfitLossId FROM tmpMIС_ProfitLoss))

         , tmpObject_BankAccount AS (SELECT Object_BankAccount_View.*
                                     FROM Object_BankAccount_View
                                     WHERE CASE WHEN inJuridicalBasisId = zc_Juridical_Irna() THEN COALESCE (Object_BankAccount_View.isIrna, FALSE) = TRUE 
                                                ELSE  COALESCE (Object_BankAccount_View.isIrna, FALSE) = FALSE  --inJuridicalBasisId = zc_Juridical_Basis() THEN
                                           END
                                    )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , (Movement_BankStatementItem.InvNumber || ' от ' || Movement_BankStatement.OperDate :: Date :: TVarChar || ' (' ||  Movement_BankStatement.InvNumber :: TVarChar || ')' ) :: TVarChar AS InvNumber_Parent
           , Movement_BankStatementItem.InvNumber AS BankSInvNumber_Parent
           , Movement.ParentId
           , Movement.OperDate
           , MIDate_ServiceDate.ValueData  AS ServiceDate
           , Object_Status.ObjectCode      AS StatusCode
           , Object_Status.ValueData       AS StatusName
           , CASE WHEN MovementItem.Amount > 0 THEN
                       MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountIn
           , CASE WHEN MovementItem.Amount < 0 THEN
                       -1 * MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountOut
           , MovementFloat_Amount.ValueData         AS AmountSumm
           , MovementFloat_AmountCurrency.ValueData AS AmountCurrency

           , MIString_Comment.ValueData        AS Comment
           , Object_BankAccount_View.Name      AS BankAccountName
           , Object_BankAccount_View.BankName  AS BankName
           , Object_BankAccount_View.MFO       AS MFO

           , Object_BankAccount_View.JuridicalName  AS JuridicalName
           , View_JuridicalDetails_BankAccount.OKPO AS OKPO_BankAccount
           , Object_MoneyPlace.Id              AS MoneyPlaceId
           , Object_MoneyPlace.ObjectCode      AS MoneyPlaceCode
           , (Object_MoneyPlace.ValueData || COALESCE (' * '|| Object_Bank.ValueData, '')) :: TVarChar AS MoneyPlaceName
           , ObjectDesc.ItemName
           , ObjectHistory_JuridicalDetails_View.OKPO
           , MovementString_OKPO.ValueData     AS OKPO_Parent

           , Object_Partner.Id                 AS PartnerId
           , Object_Partner.ValueData          AS PartnerName

           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all
           , Object_Contract_InvNumber_View.ContractCode
           , Object_Contract_InvNumber_View.InvNumber  AS ContractInvNumber
           , Object_Contract_InvNumber_View.ContractTagName
           , Object_Unit.ObjectCode            AS UnitCode
           , Object_Unit.ValueData             AS UnitName
           , Object_Currency.ValueData         AS CurrencyName
           , MovementFloat_CurrencyValue.ValueData             AS CurrencyValue
           , MovementFloat_ParValue.ValueData                  AS ParValue
           , MovementFloat_CurrencyPartnerValue.ValueData      AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData           AS ParPartnerValue
           , Partner_BankAccount_View.BankName
           , Partner_BankAccount_View.MFO
           , Partner_BankAccount_View.Name                     AS PartnerBankAccountName
           , COALESCE(MovementBoolean_isCopy.ValueData, FALSE) AS isCopy

           , Movement_Invoice.Id                 AS MovementId_Invoice
           , (CASE WHEN Movement_Invoice.StatusId = zc_Enum_Status_Erased() THEN '***УДАЛЕН ' WHEN Movement_Invoice.StatusId = zc_Enum_Status_UnComplete() THEN '*не проведен ' ELSE '' END || zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate)
             ) :: TVarChar AS InvNumber_Invoice
           , MS_Comment_Invoice.ValueData        AS Comment_Invoice

           , tmpProfitLoss_View.ProfitLossGroupName     ::TVarChar
           , tmpProfitLoss_View.ProfitLossDirectionName ::TVarChar
           , tmpProfitLoss_View.ProfitLossName          ::TVarChar
           , tmpProfitLoss_View.ProfitLossName_all      ::TVarChar
       FROM tmpMovement AS Movement
            LEFT JOIN Movement AS Movement_BankStatementItem ON Movement_BankStatementItem.Id = Movement.ParentId
            LEFT JOIN Movement AS Movement_BankStatement ON Movement_BankStatement.Id = Movement_BankStatementItem.ParentId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            --
            LEFT JOIN tmpMIС ON tmpMIС.MovementId = Movement.Id
            LEFT JOIN tmpMIС_ProfitLoss ON tmpMIС_ProfitLoss.ContainerId = tmpMIС.ContainerId
            LEFT JOIN tmpProfitLoss_View ON tmpProfitLoss_View.ProfitLossId = tmpMIС_ProfitLoss.ProfitLossId

            LEFT JOIN MovementBoolean AS MovementBoolean_isCopy
                                      ON MovementBoolean_isCopy.MovementId = Movement.Id
                                     AND MovementBoolean_isCopy.DescId = zc_MovementBoolean_isCopy()

            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId = Movement.Id
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
            LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
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

            LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                           ON MLM_Invoice.MovementId = Movement.Id
                                          AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MS_Comment_Invoice
                                     ON MS_Comment_Invoice.MovementId = Movement_Invoice.Id
                                    AND MS_Comment_Invoice.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementString AS MovementString_OKPO
                                     ON MovementString_OKPO.MovementId =  Movement_BankStatementItem.Id
                                    AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
            --
            LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            -- показываем только нужные расчетные счета, или Алан или Ирна
            INNER JOIN tmpObject_BankAccount AS Object_BankAccount_View ON Object_BankAccount_View.Id = MovementItem.ObjectId
            
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS View_JuridicalDetails_BankAccount ON View_JuridicalDetails_BankAccount.JuridicalId = Object_BankAccount_View.JuridicalId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_MoneyPlace.Id

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                             ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MILinkObject_Partner.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                         ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MILinkObject_Currency.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                             ON MILinkObject_BankAccount.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()
            LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = MILinkObject_BankAccount.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId         = zc_MIDate_ServiceDate()
                                      AND MILinkObject_InfoMoney.ObjectId   IN (zc_Enum_InfoMoney_60101() -- Заработная плата + Заработная плата
                                                                              , zc_Enum_InfoMoney_60102() -- Заработная плата + Алименты
                                                                               )
                                      -- AND MILinkObject_MoneyPlace.ObjectId > 0  

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Account
                                 ON ObjectLink_BankAccount_Account.ObjectId = Object_BankAccount_View.Id
                                AND ObjectLink_BankAccount_Account.DescId = zc_ObjectLink_BankAccount_Account()

       WHERE (Object_BankAccount_View.JuridicalId = inJuridicalBasisId OR inJuridicalBasisId = 0
           --OR vbUserId = 5
           OR (Object_BankAccount_View.JuridicalId <> zc_Juridical_Irna() AND inJuridicalBasisId <> zc_Juridical_Irna())
             )
         AND (  (inAccountId > 0 AND ObjectLink_BankAccount_Account.ChildObjectId = inAccountId)
             OR (inAccountId < 0 AND COALESCE (ObjectLink_BankAccount_Account.ChildObjectId,0) <> (-1) * inAccountId)
             OR inAccountId = 0
           --OR vbUserId = 5
             )
       ;

       --zc_Juridical_Irna() = 15512, тогда в селекте COALESCE (zc_Object_BankAccount.zc_ObjectBoolean_Guide_Irna, FALSE) = TRUE



     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpSelect_Movement_BankAccount'
               -- ProtocolData
             , CHR (39) || zfConvert_DateToString (inStartDate) || CHR (39)
    || ', ' || CHR (39) || zfConvert_DateToString (inEndDate) || CHR (39)
    || ', ' || inJuridicalBasisId :: TVarChar
    || ', ' || inAccountId :: TVarChar
    || ', ' || CASE WHEN inIsErased = TRUE THEN 'TRUE' ELSE 'FALSE' END
    || ', ' || inSession
              ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_BankAccount (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.06.24         *
 26.05.22         *
 04.03.20         *
 06.10.16         * add inJuridicalBasisId
 21.07.16         *
 08.04.15         * add isCopy
 14.11.14                                        * add Currency...
 27.09.14                                        * add ContractTagName
 18.06.14                         * add Object_BankAccount_View
 18.03.14                                        * add zc_ObjectLink_BankAccount_Bank
 03.02.14                                        * add inIsErased
 29.01.14                                        * add InvNumber_Parent
 15.01.14                         *
 */

-- тест
-- SELECT * FROM gpSelect_Movement_BankAccount (inStartDate:= '24.06.2024', inEndDate:= '24.06.2024', inJuridicalBasisId:=0 , inIsErased:= FALSE, inAccountId:= 0, inSession:= '9457')  -- -10895486
