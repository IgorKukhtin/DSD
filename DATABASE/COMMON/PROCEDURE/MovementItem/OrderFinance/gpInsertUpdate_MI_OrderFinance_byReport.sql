-- Function: gpInsertUpdate_MI_OrderFinance_byReport()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderFinance_byReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderFinance_byReport(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOrderFinanceId Integer;
   DECLARE vbPaidKindId Integer;
   DECLARE vbBankAccountMainId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

     -- проверка
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE)
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже заполнен.';
     END IF;
     
     -- из шапки документа
     SELECT Movement.OperDate
          , COALESCE (MovementLinkObject.ObjectId,0)              AS OrderFinanceId
          , OrderFinance_PaidKind.ChildObjectId                   AS PaidKindId
          , COALESCE (MovementLinkObject_BankAccount.ObjectId,0)  AS BankAccountId
     INTO vbOperDate, vbOrderFinanceId, vbPaidKindId, vbBankAccountMainId
     FROM Movement
          LEFT JOIN MovementLinkObject ON MovementLinkObject.MovementId = inMovementId
                                      AND MovementLinkObject.DescId = zc_MovementLinkObject_OrderFinance()
          LEFT JOIN ObjectLink AS OrderFinance_PaidKind
                               ON OrderFinance_PaidKind.ObjectId = MovementLinkObject.ObjectId
                              AND OrderFinance_PaidKind.DescId = zc_ObjectLink_OrderFinance_PaidKind()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                      ON MovementLinkObject_BankAccount.MovementId = inMovementId
                                     AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
     WHERE Movement.Id = inMovementId;
       

    -- данные из отчета
    CREATE TEMP TABLE _tmpReport (JuridicalId Integer, PaidKindId Integer, ContractId Integer, InfomoneyId Integer
                                , DebetRemains TFloat, KreditRemains TFloat
                                , DefermentPaymentRemains TFloat   --Долг с отсрочкой
                                , Remains TFloat) ON COMMIT DROP;
    INSERT INTO _tmpReport (JuridicalId, PaidKindId, ContractId, InfomoneyId
                          , DebetRemains, KreditRemains
                          , DefermentPaymentRemains   --Долг с отсрочкой
                          , Remains)
	    SELECT tmp.JuridicalId, tmp.PaidKindId, tmp.ContractId, tmp.InfomoneyId 
                 , tmp.DebetRemains, tmp.KreditRemains
                 , tmp.DefermentPaymentRemains   --Долг с отсрочкой
                 , tmp.Remains 
            FROM gpReport_JuridicalDefermentIncome(inOperDate      := vbOperDate 
                                                 , inEmptyParam    := NULL        ::TDateTime
                                                 , inAccountId     := 0
                                                 , inPaidKindId    := COALESCE (vbPaidKindId,0)
                                                 , inBranchId      := 0
                                                 , inJuridicalGroupId := 0
                                                 , inSession       := inSession) AS tmp
            WHERE COALESCE (tmp.DefermentPaymentRemains, 0) <> 0
               OR COALESCE (tmp.Remains, 0) <> 0;

    -- строки документа
    CREATE TEMP TABLE _tmpData (Id Integer, JuridicalId Integer, ContractId Integer, PaidKindId Integer, InfoMoneyId Integer, BankAccountId Integer, Comment TVarChar) ON COMMIT DROP;
    INSERT INTO _tmpData (Id, JuridicalId, ContractId, PaidKindId, InfoMoneyId, BankAccountId, Comment)
     WITH
     tmpJuridicalOrderFinance AS (SELECT tmp.BankAccountId
                                       , tmp.JuridicalId
                                       , tmp.InfoMoneyId
                                       , tmp.Comment
                                  FROM gpSelect_Object_JuridicalOrderFinance_choice (inBankAccountMainId := vbBankAccountMainId
                                                                                   , inOrderFinanceId    := vbOrderFinanceId
                                                                                   , inisShowAll         := FALSE
                                                                                   , inisErased          := FALSE
                                                                                   , inSession           := inSession) AS tmp
                                  )

/*     tmpOrderFinanceProperty AS (SELECT DISTINCT OrderFinanceProperty_Object.ChildObjectId AS Id
                                 FROM ObjectLink AS OrderFinanceProperty_OrderFinance
                                      INNER JOIN ObjectLink AS OrderFinanceProperty_Object
                                                            ON OrderFinanceProperty_Object.ObjectId = OrderFinanceProperty_OrderFinance.ObjectId
                                                           AND OrderFinanceProperty_Object.DescId = zc_ObjectLink_OrderFinanceProperty_Object()
                                                           AND COALESCE (OrderFinanceProperty_Object.ChildObjectId,0) <> 0

                                 WHERE OrderFinanceProperty_OrderFinance.ChildObjectId = vbOrderFinanceId
                                   AND OrderFinanceProperty_OrderFinance.DescId = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                )
   , tmpInfoMoney AS (SELECT DISTINCT Object_InfoMoney_View.InfoMoneyId
                      FROM Object_InfoMoney_View
                           INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyId
                                                               OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyDestinationId
                                                               OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyGroupId)
                      )
*/
   , tmpData AS (SELECT DISTINCT 
                        ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                      , ObjectLink_Contract_InfoMoney.ObjectId      AS ContractId
                      , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                      , OL_Contract_PaidKind.ChildObjectId          AS PaidKindId
                      , tmpJuridicalOrderFinance.BankAccountId      AS BankAccountId
                      , tmpJuridicalOrderFinance.Comment            AS Comment
                 FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                      
                      INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                            ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_InfoMoney.ObjectId
                                           AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

                      INNER JOIN tmpJuridicalOrderFinance ON tmpJuridicalOrderFinance.JuridicalId = ObjectLink_Contract_Juridical.ChildObjectId
                                                         AND tmpJuridicalOrderFinance.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId                                   

                      INNER JOIN ObjectLink AS OL_Contract_PaidKind
                                            ON OL_Contract_PaidKind.ObjectId = ObjectLink_Contract_InfoMoney.ObjectId
                                           AND OL_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                                           AND (OL_Contract_PaidKind.ChildObjectId = vbPaidKindId OR COALESCE (vbPaidKindId,0) = 0)
                 WHERE ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                )

   , tmpMI AS (SELECT MovementItem.Id                     AS Id
                    , MovementItem.ObjectId               AS JuridicalId
                    , MILinkObject_Contract.ObjectId      AS ContractId
                    , OL_Contract_PaidKind.ChildObjectId  AS PaidKindId
                    , OL_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                    , MILinkObject_BankAccount.ObjectId   AS BankAccountId
                    , MIString_Comment.ValueData          AS Comment
               FROM MovementItem
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                    ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                                    ON MILinkObject_BankAccount.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()

                   LEFT JOIN MovementItemString AS MIString_Comment
                                                ON MIString_Comment.MovementItemId = MovementItem.Id
                                               AND MIString_Comment.DescId = zc_MIString_Comment()

                   INNER JOIN ObjectLink AS OL_Contract_PaidKind
                                         ON OL_Contract_PaidKind.ObjectId = MILinkObject_Contract.ObjectId
                                        AND OL_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                                        AND (OL_Contract_PaidKind.ChildObjectId = vbPaidKindId OR COALESCE (vbPaidKindId,0) = 0)
                   LEFT JOIN ObjectLink AS OL_Contract_InfoMoney
                                        ON OL_Contract_InfoMoney.ObjectId = MILinkObject_Contract.ObjectId
                                       AND OL_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
               )

       -- Результат
       SELECT
             COALESCE (tmpMI.Id, 0)                            AS MI_Id
           , COALESCE (tmpData.JuridicalId, tmpMI.JuridicalId) AS JuridicalId
           , COALESCE (tmpData.ContractId, tmpMI.ContractId)   AS ContractId
           , COALESCE (tmpData.PaidKindId, tmpMI.PaidKindId)   AS PaidKindId
           , COALESCE (tmpData.InfoMoneyId, tmpMI.InfoMoneyId) AS InfoMoneyId
           , COALESCE (tmpData.BankAccountId, tmpMI.BankAccountId) AS BankAccountId
           , COALESCE (tmpData.Comment, tmpMI.Comment)         AS Comment
       FROM tmpData
            FULL JOIN tmpMI ON tmpMI.JuridicalId   = tmpData.JuridicalId
                           AND tmpMI.ContractId    = tmpData.ContractId
                           AND tmpMI.PaidKindId    = tmpData.PaidKindId
                           AND tmpMI.InfoMoneyId   = tmpData.InfoMoneyId
                           AND tmpMI.BankAccountId = tmpData.BankAccountId;
            
    -- сохраняем данные
    PERFORM lpUpdate_MI_OrderFinance_ByReport (inId            := COALESCE (_tmpData.Id, 0)                       ::Integer
                                             , inMovementId    := inMovementId 
                                             , inJuridicalId   := _tmpData.JuridicalId
                                             , inContractId    := _tmpData.ContractId
                                             , inBankAccountId := _tmpData.BankAccountId
                                             , inAmountRemains := (COALESCE (_tmpReport.KreditRemains,0) - COALESCE (_tmpReport.DebetRemains,0)) ::TFloat
                                             , inAmountPartner := CASE WHEN COALESCE (_tmpReport.DefermentPaymentRemains,0) < 0 THEN 0 ELSE COALESCE (_tmpReport.DefermentPaymentRemains,0) END ::TFloat
                                             , inComment       := _tmpData.Comment                                ::TVarChar
                                             , inUserId        := vbUserId
                                              )
    FROM _tmpData
         INNER JOIN _tmpReport ON _tmpReport.JuridicalId = _tmpData.JuridicalId
                              AND _tmpReport.ContractId  = _tmpData.ContractId
                              AND _tmpReport.InfoMoneyId = _tmpData.InfoMoneyId
                              AND _tmpReport.PaidKindId  = _tmpData.PaidKindId --OR COALESCE (vbPaidKindId,0) = 0)
                              ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.19         *
*/

-- тест
--select * from gpInsertUpdate_MI_OrderFinance_byReport(inMovementId := 14022564 ,  inSession := '5');

/*SELECT *
            FROM gpReport_JuridicalDefermentIncome(inOperDate      := '30.07.2019' 
                                                 , inEmptyParam    := '30.07.2019'
                                                 , inAccountId     := 0
                                                 , inPaidKindId    := 3
                                                 , inBranchId      := 0
                                                 , inJuridicalGroupId := 0
                                                 , inSession       := '5'::TVarchar);
*/