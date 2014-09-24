-- Function: gpInsertUpdate_Movement_FounderService()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_FounderService (integer, Tvarchar, TDateTime, Integer , Tfloat, Tvarchar, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_FounderService(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    IN inFounderId                Integer   , --
    IN inAmount                   TFloat    , -- Сумма операции 
    IN inComment                  TVarChar  , -- Комментарий
    IN inSession                  TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_FounderService());
     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_FounderService());

     -- проверка
     IF (COALESCE(inAmount, 0) = 0) THEN
        RAISE EXCEPTION 'Введите сумму.';
     END IF;

     -- 1. Распроводим Документ
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_FounderService())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_FounderService(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inFounderId, ioId, inAmount, NULL);
    
     -- Комментарий
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

     -- 5.1. таблица - Проводки
  
     -- 5.2. таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
  
     -- 5.3. проводим Документ

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 03.09.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_FounderService (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, ininComment:= 0, inSession:= '2')
