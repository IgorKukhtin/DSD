-- Function: gpInsertUpdate_Movement_BankSecondNum()

---DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankSecondNum (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankSecondNum (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankSecondNum(
 INOUT ioId                     Integer   , -- Ключ объекта <Документ >
    IN inInvNumber              TVarChar  , -- Номер документа
    IN inOperDate               TDateTime , -- Дата 
    IN inMovementId_PersonalService Integer, -- ведомость начисления
    IN inBankSecondId_num       Integer   , -- 
    IN inBankSecondTwoId_num    Integer   , --  
    IN inBankSecondDiffId_num   Integer   , -- 
    IN inBankSecond_num         TFloat    , -- 
    IN inBankSecondTwo_num      TFloat    , --
    IN inBankSecondDiff_num     TFloat    , -- 
    IN inComment                TVarChar  , -- Примечание
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyDocumentId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankSecondNum());


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- переопределяем дату документа - Месяц начислений = первое число месяца
     inOperDate:= DATE_TRUNC ('MONTH', inOperDate);

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankSecondNum(), inInvNumber, inOperDate, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankSecond_num(), ioId, inBankSecondId_num);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankSecondTwo_num(), ioId, inBankSecondTwoId_num);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankSecondDiff_num(), ioId, inBankSecondDiffId_num);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BankSecond_num(), ioId, inBankSecond_num);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BankSecondTwo_num(), ioId, inBankSecondTwo_num);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BankSecondDiff_num(), ioId, inBankSecondDiff_num);

     -- Примечание
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- удалили - ВСЕ
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_BankSecondNum(), MovementLinkMovement.MovementId, NULL)
     FROM MovementLinkMovement
     WHERE MovementLinkMovement.DescId          = zc_MovementLinkMovement_BankSecondNum()
       AND MovementLinkMovement.MovementChildId = ioId
    ;


     -- сохранили связь с документом <Ведомость начисления и приоритет начисления>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_BankSecondNum(), inMovementId_PersonalService, ioId);
     
     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (создание)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
     ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, vbUserId);
     END IF;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.03.24         *
*/

-- тест
-- 