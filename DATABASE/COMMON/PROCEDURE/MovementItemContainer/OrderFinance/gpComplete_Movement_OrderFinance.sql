-- Function: gpComplete_Movement_OrderFinance()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderFinance (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderFinance(
    IN inMovementId        Integer                , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDate_max TDateTime;
  DECLARE vbBankAccountId Integer;
  DECLARE vbOrderFinanceId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderFinance());
      vbUserId:= lpGetUserBySession (inSession);

      -- проводим Документ + сохранили протокол
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_OrderFinance()
                                 , inUserId     := vbUserId
                                  );


      -- если это последний документ то сохраняем примечание (Назначение платежа) в JuridicalOrderFinance
      --данные из шапки документа
      SELECT Movement.OperDate
           , COALESCE (MovementLinkObject_BankAccount.ObjectId,0)  AS BankAccountId
           , COALESCE (MovementLinkObject_OrderFinance.ObjectId,0) AS OrderFinanceId
     INTO vbOperDate, vbBankAccountId, vbOrderFinanceId
      FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                       ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                      AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                       ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                      AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
      WHERE Movement.Id = inMovementId;
      --макс. дата документов
      vbOperDate_max := (SELECT MAX(Movement.OperDate) ::TDateTime
                         FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                                           ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                                          AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
                                                          AND MovementLinkObject_BankAccount.ObjectId = vbBankAccountId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                          ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                         AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
                         WHERE Movement.DescId = zc_Movement_OrderFinance()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND (COALESCE (MovementLinkObject_OrderFinance.ObjectId,0) = vbOrderFinanceId OR vbOrderFinanceId = 0)
                        );
      --Если дата проводимого док = макс, т.е. это последний   документ, следовательно сохраняем примечание в справочник
     
      IF vbOperDate >= vbOperDate_max
      THEN
      -- RAISE EXCEPTION 'Ошибка.Тест.';
          CREATE TEMP TABLE _tmpJuridicalOrderFinance (Id Integer, BankAccountId Integer, JuridicalId Integer, InfoMoneyId Integer) ON COMMIT DROP;
           INSERT INTO _tmpJuridicalOrderFinance (Id, BankAccountId, JuridicalId, InfoMoneyId)
              SELECT DISTINCT
                     tmp.Id
                   , tmp.BankAccountId
                   , tmp.JuridicalId
                   , tmp.InfoMoneyId
              FROM gpSelect_Object_JuridicalOrderFinance_choice (inBankAccountMainId := vbBankAccountId
                                                               , inOrderFinanceId    := COALESCE (vbOrderFinanceId,0)
                                                               , inisShowAll         := FALSE
                                                               , inisErased          := FALSE
                                                               , inSession           := inSession) AS tmp
              ;

          -- сохранили свойство <>
          PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_JuridicalOrderFinance_Comment(), _tmpJuridicalOrderFinance.Id, tmp.Comment)
          FROM _tmpJuridicalOrderFinance
              INNER JOIN (SELECT MovementItem.ObjectId               AS JuridicalId
                               , OL_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                               , MIString_Comment.ValueData          AS Comment
                          FROM MovementItem
                              INNER JOIN MovementItemString AS MIString_Comment
                                                           ON MIString_Comment.MovementItemId = MovementItem.Id
                                                          AND MIString_Comment.DescId = zc_MIString_Comment()
                                                          AND COALESCE (MIString_Comment.ValueData,'') <> ''
                                                          
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                               ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                              LEFT JOIN ObjectLink AS OL_Contract_InfoMoney
                                                   ON OL_Contract_InfoMoney.ObjectId = MILinkObject_Contract.ObjectId
                                                  AND OL_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          ) AS tmp ON tmp.JuridicalId = _tmpJuridicalOrderFinance.JuridicalId
                                  AND tmp.InfoMoneyId = _tmpJuridicalOrderFinance.InfoMoneyId
          ;
      END IF;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.02.21         *
 30.07.19         *
 */

-- тест
--