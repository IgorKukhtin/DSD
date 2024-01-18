-- Function: gpInsertUpdate_Movement_BankAccount_csv_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount_csv_Load (TVarChar,TVarChar, TVarChar, TVarChar, TDateTime, TDateTime
                                                                    , TVarChar,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar, TFloat
                                                                    , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount_csv_Load (TVarChar,TVarChar, TVarChar, TVarChar, TDateTime, TDateTime
                                                                    , TVarChar,TVarChar, TVarChar, TVarChar, Text, TFloat, TVarChar, TFloat
                                                                    , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccount_csv_Load(
    IN inString_1             TVarChar  , -- 
    IN inString_2             TVarChar  , --
    IN inString_3             TVarChar  , --
    IN inString_4             TVarChar  , --
    IN inTDateTime_5          TDateTime , --
    IN inOperDate             TDateTime , --  6
    IN inString_7             TVarChar  , --
    IN inString_8             TVarChar  , --
    IN inString_9             TVarChar  , --
    IN inString_10            TVarChar  , --
    IN inComment              Text      , --   11
    IN inAmount               TFloat    , --   12 
    IN inString_13            TVarChar  , --
    IN inTFloat_14            TFloat  , --
    IN inString_15            TVarChar  , -- 
    IN inString_16            TVarChar  , --
    IN inString_17            TVarChar  , --
    IN inString_18            TVarChar  , --
    IN inString_19            TVarChar  , --
    IN inSession              TVarChar    -- сессия пользователя
)                         
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbMovementId Integer;  
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());

/*
     -- проверка
     IF COALESCE (inBankAccountId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не выбран Расчетный счет';
     END IF;
*/
     -- проверка
     IF COALESCE (inAmount, 0) = 0  
     THEN
        RETURN;
     END IF;
/*
     -- проверка
     IF COALESCE (inMovementId_Invoice, 0) = 0 AND COALESCE (inMovementId_Parent, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не выбран документ Счет.';
     END IF;
*/
     --пробуем найти док. (на случай если несколько раз пробуют загрузить )
     --ключ  String_2 +  inTDateTime_5  + inOperDate +  String_7 +String_10 + Amount   
     SELECT Movement.Id, Movement.InvNumber 
    INTO vbMovementId, vbInvNumber
     FROM Movement   
         --
         INNER JOIN MovementString AS MovementString_2
                                   ON MovementString_2.MovementId = Movement.Id
                                  AND MovementString_2.DescId = zc_MovementString_2()
                                  AND MovementString_2.ValueData = TRIM (inString_2)
         INNER JOIN MovementString AS MovementString_7
                                   ON MovementString_7.MovementId = Movement.Id
                                  AND MovementString_7.DescId = zc_MovementString_7()
                                  AND MovementString_7.ValueData = TRIM (inString_7)
         INNER JOIN MovementString AS MovementString_10
                                   ON MovementString_10.MovementId = Movement.Id
                                  AND MovementString_10.DescId = zc_MovementString_10()
                                  AND MovementString_10.ValueData = TRIM (inString_10)
         INNER JOIN MovementDate AS MovementDate_5
                                 ON MovementDate_5.MovementId = Movement.Id
                                AND MovementDate_5.DescId = zc_MovementDate_5() 
                                AND MovementDate_5.ValueData = inTDateTime_5
         INNER JOIN MovementFloat AS MovementFloat_14
                                  ON MovementFloat_14.MovementId = Movement.Id
                                 AND MovementFloat_14.DescId = zc_MovementFloat_14()
                                 AND MovementFloat_14.ValueData = inTFloat_14 
         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                AND MovementItem.DescId = zc_MI_Master()
                                AND MovementItem.isErased = FALSE
                                AND MovementItem.Amount = inAmount
     WHERE Movement.DescId = zc_Movement_BankAccount()
       AND Movement.StatusId <> zc_Enum_Status_Erased()
       AND Movement.OperDate = inOperDate 
     LIMIT 1  --на всякий случай
     ;

     -- 1. Распроводим Документ
     IF COALESCE (vbMovementId,0) > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := vbMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- сохранили <Документ>
     vbMovementId:= lpInsertUpdate_Movement_BankAccount (ioId                   := COALESCE (vbMovementId,0)::Integer
                                                       , inInvNumber            := CASE WHEN COALESCE (vbMovementId,0) = 0 THEN CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar) ELSE vbInvNumber END ::TVarChar
                                                       , inInvNumberPartner     := NULL        ::TVarChar
                                                       , inOperDate             := inOperDate  ::TDateTime
                                                       , inAmount               := inAmount    ::TFloat
                                                       , inBankAccountId        := 33325       ::Integer       --     "34567890"     "Erste Bank"        "EUR"
                                                       , inMoneyPlaceId         := 0           ::Integer
                                                       , inMovementId_Invoice   := 0           ::Integer
                                                       , inComment              := inComment   ::TVarChar
                                                       , inUserId               := vbUserId    ::Integer
                                                        );
                                                
     --и сохраняем остальные загрузочные параметры
     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_1(), vbMovementId, TRIM (inString_1));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_2(), vbMovementId, TRIM (inString_2));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_3(), vbMovementId, TRIM (inString_3));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_4(), vbMovementId, TRIM (inString_4));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_7(), vbMovementId, TRIM (inString_7));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_8(), vbMovementId, TRIM (inString_8));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_9(), vbMovementId, TRIM (inString_9));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_10(), vbMovementId, TRIM (inString_10));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_13(), vbMovementId, TRIM (inString_13));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_15(), vbMovementId, TRIM (inString_15));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_16(), vbMovementId, TRIM (inString_16));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_17(), vbMovementId, TRIM (inString_17));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_18(), vbMovementId, TRIM (inString_18));
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_19(), vbMovementId, TRIM (inString_19)); 
     --
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_5(), vbMovementId, inTDateTime_5::TDateTime);
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_14(), vbMovementId, inTFloat_14::TFloat);
     
     -- 5.3. проводим Документ
    /* IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount())
     THEN
          PERFORM lpComplete_Movement_BankAccount (inMovementId := vbMovementId
                                                 , inUserId     := vbUserId);
     END IF;
    */
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.24         * 
*/

-- тест
--