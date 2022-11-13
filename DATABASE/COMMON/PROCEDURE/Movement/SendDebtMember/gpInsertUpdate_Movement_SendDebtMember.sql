-- Function: gpInsertUpdate_Movement_SendDebtMember()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebtMember (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat
                                                              , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                              , TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendDebtMember(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа

 INOUT ioMasterId             Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioChildId              Integer   , -- Ключ объекта <Элемент документа>

    IN inAmount               TFloat    , -- сумма  
        
    IN inMemberFromId         Integer   , -- физ. лицо
    IN inJuridicalBasisFromId Integer   , -- гл. Юр.лицо
    IN inCarFromId            Integer   , -- авто
    IN inInfoMoneyFromId      Integer   , -- Статьи назначения
    IN inBranchFromId         Integer   , -- 
    
    IN inMemberToId           Integer   , -- физ.лицо
    IN inJuridicalBasisToId   Integer   , -- гл. Юр.лицо
    IN inCarToId              Integer   , -- авто
    IN inInfoMoneyToId        Integer   , -- Статьи назначения
    IN inBranchToId           Integer   , -- 

    IN inComment              TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendDebtMember());

     -- проверка
     IF (COALESCE (inMemberFromId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Физ.лицо лицо (Кредит)>.';
     END IF;
     -- проверка
     IF (COALESCE (inInfoMoneyFromId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <УП статья назначения (Кредит)>.';
     END IF;
     -- проверка
   /*IF (COALESCE (inCarFromId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Авто (Кредит)>.';
     END IF;
     -- проверка
     IF (COALESCE (inJuridicalBasisFromId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Гл.юр.лицо (Кредит)>.';
     END IF;

     -- проверка
     IF (COALESCE (inMemberToId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Физ.лицо (Дебет)>.';
     END IF;
     -- проверка
     IF (COALESCE (inInfoMoneyToId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <УП статья назначения (Дебет)>.';
     END IF;
     -- проверка
     IF (COALESCE (inCarToId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Авто (Дебет)>.';
     END IF;
     -- проверка
     IF (COALESCE (inJuridicalBasisToId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Гл.юр.лицо (Дебет)>.';
     END IF;*/


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- 1. Распроводим Документ
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_SendDebtMember())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SendDebtMember(), inInvNumber, inOperDate, NULL);

     -- сохранили свойство <Комментарий>
     PERFORM lpInsertUpdate_MovementString(zc_MovementString_Comment(), ioId, inComment);
   
     -- сохранили <Элемент> - Кредит
     ioMasterId := lpInsertUpdate_MovementItem (ioMasterId, zc_MI_Master(), inMemberFromId, ioId, inAmount, NULL);

     -- сохранили связь с <Авто ОТ >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), ioMasterId, inCarFromId);

     -- сохранили связь с <гл юр.лицо ОТ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_JuridicalBasis(), ioMasterId, inJuridicalBasisFromId);

     -- сохранили связь с <Статьи назначения ОТ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioMasterId, inInfoMoneyFromId);

     -- сохранили связь с <Филиал ОТ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioMasterId, inBranchFromId);


  


     -- сохранили <Элемент> - Дебет
     ioChildId := lpInsertUpdate_MovementItem (ioChildId, zc_MI_Child(), CASE WHEN inMemberToId > 0 THEN inMemberToId ELSE inMemberFromId END, ioId, inAmount, NULL);

     -- сохранили связь с <авто КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), ioChildId, inCarToId);

     -- сохранили связь с <гл юр.лицо ОТ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_JuridicalBasis(), ioChildId, inJuridicalBasisToId);

     -- сохранили связь с <Статьи назначения КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioChildId, CASE WHEN inInfoMoneyToId > 0 THEN inInfoMoneyToId ELSE inInfoMoneyFromId END);

     -- сохранили связь с <Филиал КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioChildId, inBranchToId);

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_SendDebtMember())
     THEN
          PERFORM lpComplete_Movement_SendDebtMember (inMovementId := ioId
                                                    , inUserId     := vbUserId);
     END IF;

     -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.10.22         *
 */

-- тест
-- 