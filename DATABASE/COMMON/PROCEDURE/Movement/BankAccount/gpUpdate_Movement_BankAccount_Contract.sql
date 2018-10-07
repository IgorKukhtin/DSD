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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());


     -- 1. Распроводим Документ
     IF inId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := inId
                                      , inUserId     := vbUserId);
     END IF;

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = inId AND MovementItem.DescId = zc_MI_Master();

     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, FALSE);
                                

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount())
     THEN
          PERFORM lpComplete_Movement_BankAccount (inMovementId := inId
                                                 , inUserId     := vbUserId);
     END IF;

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