-- Function: gpInsertUpdate_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalService(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPersonalId          Integer   , -- Сотрудники
    IN inSummService         TFloat    , -- Сумма начислено
    IN inSummCard            TFloat    , -- Сумма на карточку (БН)
    IN inSummMinus           TFloat    , -- Сумма удержания
    IN inSummAdd             TFloat    , -- Сумма премия
    IN inComment             TVarChar  , -- 
    IN inInfoMoneyId         Integer   , -- Статьи назначения
    IN inUnitId              Integer   , -- Подразделение
    IN inPositionId          Integer   , -- Должность
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId:= inSession;

     -- сохранили
     SELECT tmp.ioId
       INTO ioId
     FROM lpInsertUpdate_MovementItem_PersonalService (ioId      := ioId
                                          , inMovementId         := inMovementId
                                          , inPersonalId         := inPersonalId
                                          , inSummService        := inSummService
                                          , inSummCard           := inSummCard
                                          , inSummMinus          := inSummMinus
                                          , inSummAdd            := inSummAdd
                                          , inComment            := inComment
                                          , inInfoMoneyId        := inInfoMoneyId
                                          , inUnitId             := inUnitId
                                          , inPositionId         := inPositionId
                                          , inUserId             := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.09.14         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_PersonalService (ioId:= 0, inMovementId:= 258038 , inPersonalId:= 8473, inAmount:= 44, inSummService:= 20, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8426, inPositionId:=12431, inSession:= '2')
