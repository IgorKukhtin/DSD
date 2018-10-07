-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpUpdate_Movement_BankAccount_Contract(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankAccount_Contract(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inContractId           Integer   , -- Договор 
   OUT outContractName        TVarChar  , -- Договор
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementItemId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_BankAccount_Contract());


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

     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. проводим Документ
     PERFORM lpComplete_Movement_BankAccount (inMovementId := inId
                                            , inUserId     := vbUserId);

     outContractName := (SELECT Object.ValueData FROM Object WHERE Object.Id = inContractId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.18         *
*/

-- тест
--