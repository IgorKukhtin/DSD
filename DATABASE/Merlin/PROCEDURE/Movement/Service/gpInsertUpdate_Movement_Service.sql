-- Function: gpInsertUpdate_Movement_Service()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Service(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inServiceDate          TDateTime , -- Дата начисления
    IN inAmount               TFloat    , -- Сумма
    IN inUnitId               Integer   , -- отдел 
    IN inInfoMoneyId          Integer   , -- Статьи 
    IN inCommentInfoMoneyId   Integer   , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Service());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_Service (ioId                   := ioId
                                           , inInvNumber            := inInvNumber
                                           , inOperDate             := inOperDate
                                           , inServiceDate          := inServiceDate
                                           , inAmount               := inAmount
                                           , inUnitId               := inUnitId
                                           , inInfoMoneyId          := inInfoMoneyId
                                           , inCommentInfoMoneyId   := inCommentInfoMoneyId
                                           , inUserId               := vbUserId
                                            );
                                                

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Service())
     THEN
          PERFORM lpComplete_Movement_Service (inMovementId := ioId
                                             , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.22         *
 */

-- тест
--