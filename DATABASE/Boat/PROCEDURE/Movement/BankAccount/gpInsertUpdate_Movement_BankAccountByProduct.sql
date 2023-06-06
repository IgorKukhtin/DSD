-- Function: gpInsertUpdate_Movement_BankAccountByProduct()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccountByProduct (Integer, TDateTime, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccountByProduct(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inOperDate             TDateTime , -- Дата документа   
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inAmountIn             TFloat    , -- Сумма прихода
    IN inBankAccountId        Integer   , -- Расчетный счет 	
    IN inMoneyPlaceId         Integer   , -- Юр лицо, счет, касса  	
    IN inMovementId_Invoice   Integer   , -- Счет
    IN inMovementId_Parent    Integer   , -- Заказ Клиента
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());

     -- проверка
     IF COALESCE (inAmountIn, 0) = 0  
     THEN
        RETURN;
     END IF;

     -- проверка
     IF COALESCE (inMovementId_Invoice,0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Документ счет не сохранен.';
     END IF;

     -- проверка
     IF COALESCE (inBankAccountId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не выбран Расчетный счет';
     END IF;


     -- 1. Распроводим Документ
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_BankAccount (ioId                   := ioId
                                               , inInvNumber            := CASE WHEN COALESCE (inInvNumber,'') ='' THEN CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar)  ELSE inInvNumber END  ::TVarChar
                                               , inInvNumberPartner     := (SELECT tmp.ValueData FROM MovementString AS tmp WHERE tmp.DescId = zc_MovementString_InvNumberPartner() AND tmp.MovementId = ioId)
                                               , inOperDate             := inOperDate
                                               , inAmount               := inAmountIn
                                               , inBankAccountId        := inBankAccountId
                                               , inMoneyPlaceId         := inMoneyPlaceId
                                               , inMovementId_Invoice   := inMovementId_Invoice
                                               , inComment              := (SELECT tmp.ValueData FROM MovementString AS tmp WHERE tmp.DescId = zc_MovementString_Comment() AND tmp.MovementId = ioId)
                                               , inUserId               := vbUserId
                                                );
                                                

     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount())
     THEN
          PERFORM lpComplete_Movement_BankAccount (inMovementId := ioId
                                                 , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.06.23         * 
*/

-- тест
--