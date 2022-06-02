-- Function: gpInsertUpdate_MovementItem_ServiceItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItem (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ServiceItem(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- отдел 
    IN inInfoMoneyId         Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ServiceItem());

     ioId:= lpInsertUpdate_MovementItem_ServiceItem (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inUnitId             := inUnitId
                                                   , inInfoMoneyId        := inInfoMoneyId
                                                   , inCommentInfoMoneyId := inCommentInfoMoneyId
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
 01.06.22         *
*/

-- тест
--