-- Function: gpInsertUpdate_Movement_BankAccountChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccountChild (Integer, Integer, TVarChar, TVarChar, TDateTime, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccountChild(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ> 
    IN inMovementItemId_child Integer   , -- чайлд
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inInvNumberPartner     TVarChar  , -- Номер документа (внешний)
    IN inOperDate             TDateTime , -- Дата документа
    IN inAmountIn             TFloat    , -- Сумма прихода
    IN inAmountOut            TFloat    , -- Сумма расхода 
    IN inAmount               TFloat    , -- сумма оплаты по счету
    IN inBankAccountId        Integer   , -- Расчетный счет 	
    IN inMoneyPlaceId         Integer   , -- Юр лицо, счет, касса  	
    IN inMovementId_Invoice   Integer   , -- Счет    
    IN inInvoiceKindId        Integer   , -- вид счета
    IN inMovementId_Parent    Integer   , -- Заказ Клиента
    IN inComment              TVarChar  , -- Комментарий
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());

     -- проверка
     IF COALESCE (inBankAccountId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не выбран Расчетный счет';
     END IF;

     -- проверка
     IF COALESCE (inAmountIn, 0) = 0 AND COALESCE (inAmountOut, 0) = 0 
     THEN
        RAISE EXCEPTION 'Ошибка.Введите сумму прихода или расхода';
     END IF;
     -- проверка
     IF COALESCE (inAmountIn, 0) <> 0 AND COALESCE (inAmountOut, 0) <> 0
     THEN
        RAISE EXCEPTION 'Ошибка.Должна быть введена только одна сумма - или <Приход> или <Расход>.';
     END IF;

     -- проверка
     /*IF COALESCE (inMovementId_Invoice, 0) = 0 AND COALESCE (inMovementId_Parent, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не выбран документ Счет.';
     END IF;*/


     -- !!!очень важный расчет!!!
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;

     -- если док. Счет пусто нужно его создать
     IF COALESCE (inMovementId_Invoice, 0) = 0
     THEN
         -- сохранили <Документ> + для inMovementId_Parent уствновится связь на этот inMovementId_Invoice
         inMovementId_Invoice := gpInsertUpdate_Movement_Invoice (ioId               := 0                                   ::Integer
                                                                , inParentId         := inMovementId_Parent                 ::Integer
                                                                , inInvNumber        := NEXTVAL ('movement_Invoice_seq')    ::TVarChar
                                                                , inOperDate         := inOperDate
                                                                , inPlanDate         := NULL                                ::TDateTime
                                                                  -- это св-во в Заказе
                                                                , inVATPercent       := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId_Parent AND MF.DescId = zc_MovementFloat_VATPercent())
                                                                  -- 
                                                                , inAmountIn         := CASE WHEN vbAmount > 0 THEN  1 * vbAmount ELSE 0 END
                                                                , inAmountOut        := CASE WHEN vbAmount < 0 THEN -1 * vbAmount ELSE 0 END
                                                                , inInvNumberPartner := ''                                  ::TVarChar
                                                                , inReceiptNumber    := (1 + COALESCE ((SELECT MAX (zfConvert_StringToNumber (MovementString.ValueData))
                                                                                                        FROM MovementString
                                                                                                             JOIN Movement ON Movement.Id       = MovementString.MovementId
                                                                                                                          AND Movement.DescId   = zc_Movement_Invoice()
                                                                                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                                                        WHERE MovementString.DescId = zc_MovementString_ReceiptNumber()
                                                                                                       ), 0)
                                                                                        ) :: TVarChar
                                                                , inComment          := ''                                  ::TVarChar
                                                                , inObjectId         := inMoneyPlaceId
                                                                , inUnitId           := NULL                                ::Integer
                                                                , inInfoMoneyId      := ObjectLink_InfoMoney.ChildObjectId  ::Integer
                                                                , inPaidKindId       := zc_Enum_PaidKind_FirstForm()        ::Integer
                                                                , inInvoiceKindId    := CASE WHEN COALESCE (inInvoiceKindId,0) = 0 THEN zc_Enum_InvoiceKind_PrePay() ELSE inInvoiceKindId END :: Integer
                                                                , inSession          := inSession
                                                                 )
         FROM Object AS Object_Client
              LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                   ON ObjectLink_InfoMoney.ObjectId = Object_Client.Id
                                  AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_Client_InfoMoney()
         WHERE Object_Client.Id = inMoneyPlaceId;

         -- проводим Документ
         /*IF vbUserId = lpCheckRight (vbUserId :: TVarChar, zc_Enum_Process_Complete_Invoice())
         THEN
              PERFORM lpComplete_Movement_Invoice (inMovementId := inMovementId_Invoice
                                                 , inUserId     := vbUserId);
         END IF;*/

     END IF;
     

     -- 1. Распроводим Документ
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- сохранили <Документ> + мастер
     ioId:= lpInsertUpdate_Movement_BankAccount (ioId                   := ioId
                                               , inInvNumber            := inInvNumber
                                               , inInvNumberPartner     := inInvNumberPartner
                                               , inOperDate             := inOperDate
                                               , inAmount               := vbAmount
                                               , inAmount_Invoice       := vbAmount
                                               , inBankAccountId        := inBankAccountId
                                               , inMoneyPlaceId         := inMoneyPlaceId
                                               , inMovementId_Invoice   := (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.DescId = zc_MovementLinkMovement_Invoice() AND MLM.MovementId = ioId)--inMovementId_Invoice
                                               , inComment              := (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = ioId AND MS.DescId = zc_MovementString_Comment())
                                               , inUserId               := vbUserId
                                                );
                                                
          
     --сохранили чайлд   
     PERFORM gpInsertUpdate_MI_BankAccount_Child(ioId                  := COALESCE (inMovementItemId_child,0)::Integer    -- Ключ объекта <> 
                                               , inParentId            := (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master())::Integer   
                                               , inMovementId          := ioId                   ::Integer     
                                               , inMovementId_OrderClient := inMovementId_Parent ::Integer
                                               , inMovementId_invoice  := inMovementId_Invoice   ::Integer    -- 
                                               , inInvoiceKindId       := inInvoiceKindId        ::Integer   --
                                               , inObjectId            := inMoneyPlaceId         ::Integer    -- 
                                               , inAmount              := inAmount               ::TFloat     --
                                               , inAmount_invoice      := inAmount               ::TFloat     --
                                               , inComment             := inComment              ::TVarChar   --
                                               , inSession             := inSession              ::TVarChar    -- сессия пользователя 
                                               );
                                               

     -- создаются временные таблицы - для формирование данных для проводок
     --PERFORM lpComplete_Movement_Finance_CreateTemp();

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
 19.01.24         * 
*/

-- тест
--
