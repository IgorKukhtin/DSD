-- Function: gpInsertUpdate_MovementItem_ServiceItemAdd()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ServiceItemAdd(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- отдел 
    IN inInfoMoneyId         Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
    IN inDateStart           TDateTime , --
    IN inDateEnd             TDateTime , --
    IN inAmount              TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inArea                TFloat    , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ServiceItemAdd());

     ioId:= gpInsertUpdate_MovementItem_ServiceItemAdd (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inUnitId             := inUnitId
                                                      , inInfoMoneyId        := inInfoMoneyId
                                                      , inCommentInfoMoneyId := inCommentInfoMoneyId
                                                      , inDateStart          := inDateStart  
                                                      , inDateEnd            := inDateEnd
                                                      , inAmount             := inAmount
                                                      , inPrice              := inPrice
                                                      , inArea               := inArea
                                                      , inUserId             := vbUserId
                                                       );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.08.22         *
*/

-- тест
--