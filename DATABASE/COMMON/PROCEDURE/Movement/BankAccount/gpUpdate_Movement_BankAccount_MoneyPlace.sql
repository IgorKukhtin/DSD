-- Function: gpUpdate_Movement_BankAccount_MoneyPlace()

DROP FUNCTION IF EXISTS gpUpdate_Movement_BankAccount_MoneyPlace(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankAccount_MoneyPlace(
    IN inId                    Integer   , -- Ключ объекта <Документ>
    IN inMoneyPlaceId          Integer   , -- Юр лицо, счет, касса, Ведомости начисления
    IN inContractId            Integer   , -- Договора
    IN inSession               TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementItemId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_BankAccount_MoneyPlace());


     -- проверка
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inId AND Movement.DescId = zc_Movement_BankAccount() AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка. Документ № <%> от <%> должен быть Проведен.'
                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inId)
                        , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inId));
     END IF;

     -- 1. Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inId
                                  , inUserId     := vbUserId);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = inId AND MovementItem.DescId = zc_MI_Master();

     -- сохранили связь с <Юр лицо, счет, касса, Ведомости начисления>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);
     

     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inContractId AND OL.DescId = zc_ObjectLink_Contract_InfoMoney()));


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. проводим Документ
     PERFORM lpComplete_Movement_BankAccount (inMovementId := inId
                                            , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.19         *
*/

-- тест
--