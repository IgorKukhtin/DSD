-- Function: gpInsertUpdate_MI_OrderFinance_byReport()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderFinance_byReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderFinance_byReport(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbOrderFinanceId Integer;
   DECLARE vbPaidKindId     Integer;
   DECLARE vbOperDate       TDateTime;
   DECLARE vbWeekNumber     TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());


     -- проверка
     /*IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE)
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже заполнен.';
     END IF;*/


     -- из шапки документа
     SELECT Movement.OperDate
          , COALESCE (MovementLinkObject.ObjectId,0)              AS OrderFinanceId
            -- Форма оплаты
          , OrderFinance_PaidKind.ChildObjectId                   AS PaidKindId
            --
          , MovementFloat_WeekNumber.ValueData                    AS WeekNumber
            INTO vbOperDate, vbOrderFinanceId, vbPaidKindId, vbWeekNumber
     FROM Movement
          LEFT JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                      AND MovementLinkObject.DescId = zc_MovementLinkObject_OrderFinance()
          LEFT JOIN ObjectLink AS OrderFinance_PaidKind
                               ON OrderFinance_PaidKind.ObjectId = MovementLinkObject.ObjectId
                              AND OrderFinance_PaidKind.DescId = zc_ObjectLink_OrderFinance_PaidKind()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                      ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                     AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()

         LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                 ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()
     WHERE Movement.Id = inMovementId;

     -- переопределяем  - заливка данных на дату - конец недели WeekNumber
     vbOperDate := zfCalc_Week_EndDate (vbOperDate, vbWeekNumber);


    -- данные из отчета
    CREATE TEMP TABLE _tmpReport (JuridicalId Integer, PaidKindId Integer, ContractId Integer, InfomoneyId Integer
                                , DebetRemains TFloat, KreditRemains TFloat
                                  -- Долг с отсрочкой
                                , DefermentPaymentRemains  TFloat
                                , Remains                  TFloat
                                , SaleSumm                 TFloat    --приход
                                , SaleSumm1                TFloat    --  7 дней
                                , SaleSumm2                TFloat    -- 14 дней
                                , SaleSumm3                TFloat    -- 21 дней
                                , SaleSumm4                TFloat    -- 28 дней
                                , Comment_pay              TVarChar  -- Назначение платежа
                                 ) ON COMMIT DROP;
    INSERT INTO _tmpReport (JuridicalId, PaidKindId, ContractId, InfomoneyId
                          , DebetRemains, KreditRemains
                          , DefermentPaymentRemains
                          , Remains
                          , SaleSumm
                          , SaleSumm1
                          , SaleSumm2
                          , SaleSumm3
                          , SaleSumm4
                          , Comment_pay
                           )
     WITH
       -- Параметры Юр.лица в планировании
       tmpJuridicalOrderFinance AS (SELECT Object_JuridicalOrderFinance.Id
                                         , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId AS InfoMoneyId
                                         , OL_JuridicalOrderFinance_Juridical.ChildObjectId AS JuridicalId
                                          -- найти Назначение платежа
                                         , ObjectString_Comment.ValueData                   AS Comment_pay
                                           -- № п/п
                                         , ROW_NUMBER() OVER (PARTITION BY OL_JuridicalOrderFinance_InfoMoney.ChildObjectId
                                                                         , OL_JuridicalOrderFinance_Juridical.ChildObjectId
                                                              ORDER BY CASE WHEN TRIM (Object_Bank.ValueData) <> '' THEN 0 ELSE 1 END ASC
                                                                     , Object_Bank.ValueData ASC
                                                             ) AS Ord

                                    FROM Object AS Object_JuridicalOrderFinance

                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                                              ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_InfoMoney.DescId   = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()
                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_Juridical
                                                              ON OL_JuridicalOrderFinance_Juridical.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_Juridical.DescId   = zc_ObjectLink_JuridicalOrderFinance_Juridical()

                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccount
                                                              ON OL_JuridicalOrderFinance_BankAccount.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_BankAccount.DescId   = zc_ObjectLink_JuridicalOrderFinance_BankAccount()
                                         LEFT JOIN ObjectLink AS OL_BankAccount_Bank
                                                              ON OL_BankAccount_Bank.ObjectId = OL_JuridicalOrderFinance_BankAccount.ChildObjectId
                                                             AND OL_BankAccount_Bank.DescId   = zc_ObjectLink_BankAccount_Bank()
                                         LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = OL_BankAccount_Bank.ChildObjectId


                                         -- Назначение платежа
                                         LEFT JOIN ObjectString AS ObjectString_Comment
                                                                ON ObjectString_Comment.ObjectId = Object_JuridicalOrderFinance.Id
                                                               AND ObjectString_Comment.DescId = zc_ObjectString_JuridicalOrderFinance_Comment()

                                    WHERE Object_JuridicalOrderFinance.DescId   = zc_Object_JuridicalOrderFinance()
                                      AND Object_JuridicalOrderFinance.isErased = FALSE
                                      -- найти Назначение платежа
                                      AND TRIM (ObjectString_Comment.ValueData) <> ''
                                   )
    -- УП-Статья или Группа или ...
  , tmpOrderFinanceProperty AS (SELECT DISTINCT
                                       -- УП - Статья или Группа или ...
                                       OrderFinanceProperty_Object.ChildObjectId AS ObjectId
                                FROM ObjectLink AS OrderFinanceProperty_OrderFinance
                                     INNER JOIN ObjectLink AS OrderFinanceProperty_Object
                                                           ON OrderFinanceProperty_Object.ObjectId = OrderFinanceProperty_OrderFinance.ObjectId
                                                          AND OrderFinanceProperty_Object.DescId = zc_ObjectLink_OrderFinanceProperty_Object()
                                                          AND COALESCE (OrderFinanceProperty_Object.ChildObjectId,0) <> 0
                                     INNER JOIN Object ON Object.Id = OrderFinanceProperty_Object.ObjectId
                                                       -- не удален
                                                      AND Object.isErased = FALSE

                                WHERE OrderFinanceProperty_OrderFinance.ChildObjectId = vbOrderFinanceId
                                  AND OrderFinanceProperty_OrderFinance.DescId = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                               )
        -- разворачивается по УП-статьям
      , tmpInfoMoney AS (SELECT DISTINCT Object_InfoMoney_View.InfoMoneyId
                         FROM Object_InfoMoney_View
                              INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                  OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyDestinationId
                                                                  OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyGroupId)
                         )

	  , tmpReport AS (SELECT tmp.JuridicalId, tmp.PaidKindId, tmp.ContractId, tmp.InfomoneyId
                           , tmp.DebetRemains, tmp.KreditRemains
                           , tmp.DefermentPaymentRemains   --Долг с отсрочкой
                           , tmp.Remains
                           , tmp.SaleSumm    --приход
                           , tmp.SaleSumm1   --  7 дней
                           , tmp.SaleSumm2   -- 14 дней
                           , tmp.SaleSumm3   -- 21 дней
                           , tmp.SaleSumm4   -- 28 дней
                      FROM gpReport_JuridicalDefermentIncome(inOperDate      := vbOperDate
                                                           , inEmptyParam    := NULL        ::TDateTime
                                                           , inAccountId     := 0
                                                           , inPaidKindId    := COALESCE (vbPaidKindId,0)
                                                           , inBranchId      := 0
                                                           , inJuridicalGroupId := 0
                                                           , inSession       := inSession) AS tmp
                      WHERE COALESCE (tmp.DefermentPaymentRemains, 0) <> 0
                         OR COALESCE (tmp.Remains, 0) <> 0
                      )
      -- ограничили статьями
     SELECT tmp.JuridicalId, tmp.PaidKindId, tmp.ContractId, tmp.InfomoneyId
          , tmp.DebetRemains, tmp.KreditRemains
          , tmp.DefermentPaymentRemains   --Долг с отсрочкой
          , tmp.Remains
          , tmp.SaleSumm    --приход
          , tmp.SaleSumm1   --  7 дней
          , tmp.SaleSumm2   -- 14 дней
          , tmp.SaleSumm3   -- 21 дней
          , tmp.SaleSumm4   -- 28 дней
          , COALESCE (tmpJuridicalOrderFinance.Comment_pay, '') AS Comment_pay
     FROM tmpReport AS tmp
          -- УП-Статья в планировании
          INNER JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = tmp.InfomoneyId
          -- Параметры Юр.лица в планировании
          LEFT JOIN tmpJuridicalOrderFinance ON tmpJuridicalOrderFinance.JuridicalId = tmp.JuridicalId
                                            AND tmpJuridicalOrderFinance.InfoMoneyId = tmp.InfoMoneyId
                                            AND tmpJuridicalOrderFinance.Ord         = 1
     ;

    -- TEST
    -- RAISE EXCEPTION 'Ошибка.TEST. <%>', (SELECT _tmpReport.Comment_pay FROM _tmpReport WHERE _tmpReport.JuridicalId = 521158);


    -- строки документа
    CREATE TEMP TABLE _tmpData (Id Integer, JuridicalId Integer, ContractId Integer, PaidKindId Integer, InfoMoneyId Integer, isErased Boolean) ON COMMIT DROP;
    INSERT INTO _tmpData (Id, JuridicalId, ContractId, PaidKindId, InfoMoneyId, isErased)
       WITH tmpMI AS (SELECT MovementItem.Id                     AS Id
                           , MovementItem.ObjectId               AS JuridicalId
                           , MILinkObject_Contract.ObjectId      AS ContractId
                           , OL_Contract_PaidKind.ChildObjectId  AS PaidKindId
                           , OL_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                             -- !!!ВСЕ!!!
                           , MovementItem.isErased               AS isErased
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                            ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                           INNER JOIN ObjectLink AS OL_Contract_PaidKind
                                                 ON OL_Contract_PaidKind.ObjectId = MILinkObject_Contract.ObjectId
                                                AND OL_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                                                AND (OL_Contract_PaidKind.ChildObjectId = vbPaidKindId OR COALESCE (vbPaidKindId,0) = 0)
                           LEFT JOIN ObjectLink AS OL_Contract_InfoMoney
                                                ON OL_Contract_InfoMoney.ObjectId = MILinkObject_Contract.ObjectId
                                               AND OL_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         -- !!!ВСЕ!!!
                         -- AND MovementItem.isErased   = FALSE
                      )
       -- Результат
       SELECT
             COALESCE (tmpMI.Id, 0)            AS Id
           , COALESCE (tmpMI.JuridicalId, 0)   AS JuridicalId
           , COALESCE (tmpMI.ContractId, 0)    AS ContractId
           , COALESCE (tmpMI.PaidKindId, 0)    AS PaidKindId
           , COALESCE (tmpMI.InfoMoneyId, 0)   AS InfoMoneyId
           , tmpMI.isErased                    AS isErased
       FROM tmpMI
       ;


    -- сохраняем данные
    PERFORM lpUpdate_MI_OrderFinance_ByReport (inId            := COALESCE (_tmpData.Id, 0) ::Integer
                                             , inMovementId    := inMovementId
                                             , inJuridicalId   := _tmpReport.JuridicalId
                                             , inContractId    := _tmpReport.ContractId
                                             --, inBankAccountId := _tmpData.BankAccountId
                                             , inAmountRemains := (COALESCE (_tmpReport.KreditRemains,0) - COALESCE (_tmpReport.DebetRemains,0)) ::TFloat
                                             , inAmountPartner := CASE WHEN COALESCE (_tmpReport.DefermentPaymentRemains,0) < 0 THEN 0 ELSE COALESCE (_tmpReport.DefermentPaymentRemains,0) END ::TFloat
                                             , inSaleSumm      := COALESCE (_tmpReport.SaleSumm,0)   ::TFloat
                                             , inSaleSumm1     := COALESCE (_tmpReport.SaleSumm1,0)  ::TFloat
                                             , inSaleSumm2     := COALESCE (_tmpReport.SaleSumm2,0)  ::TFloat
                                             , inSaleSumm3     := COALESCE (_tmpReport.SaleSumm3,0)  ::TFloat
                                             , inSaleSumm4     := COALESCE (_tmpReport.SaleSumm4,0)  ::TFloat
                                           --, inComment       := COALESCE ((SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = _tmpData.Id AND MIS.DescId = zc_MIString_Comment()), '')
                                             , inComment_pay   := _tmpReport.Comment_pay
                                             , inUserId        := vbUserId
                                              )
    FROM _tmpReport
         LEFT JOIN _tmpData ON _tmpData.JuridicalId = _tmpReport.JuridicalId
                           AND _tmpData.ContractId  = _tmpReport.ContractId
                         --AND _tmpData.InfoMoneyId = _tmpReport.InfoMoneyId
                           AND _tmpData.PaidKindId  = _tmpReport.PaidKindId --OR COALESCE (vbPaidKindId,0) = 0)
                           -- не удален
                           AND _tmpData.isErased    = FALSE
         LEFT JOIN _tmpData AS _tmpData_erased
                            ON _tmpData_erased.JuridicalId = _tmpReport.JuridicalId
                           AND _tmpData_erased.ContractId  = _tmpReport.ContractId
                         --AND _tmpData_erased.InfoMoneyId = _tmpReport.InfoMoneyId
                           AND _tmpData_erased.PaidKindId  = _tmpReport.PaidKindId --OR COALESCE (vbPaidKindId,0) = 0)
                           -- !!!удален!!!
                           AND _tmpData_erased.isErased    = TRUE
    -- если удалили, больше заливать не надо
    WHERE _tmpData_erased.JuridicalId IS NULL
       -- или есть в рабочих
       OR _tmpData.JuridicalId > 0
    ;

    -- сохранили свойство <Дата/время заполнения данных из отчета>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update_report(), inMovementId, CURRENT_TIMESTAMP);
    -- сохранили свойство <Пользователь - заполнения данных из отчета>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update_report(), inMovementId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.19         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_OrderFinance_byReport (inMovementId := 32907306, inSession:= '5');
