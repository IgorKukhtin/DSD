-- Function: gpInsertUpdate_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderInternalPromo(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inStartSale             TDateTime  , -- Дата начала продаж
  --  IN inAmount                TFloat     , -- итого кол-во
    IN inRetailId              Integer    , -- Торговая сеть
    IN inComment               TVarChar   , -- Примечание
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternalPromo());
    vbUserId := inSession;
    
    -- считаем итого кол-во
    vbAmount := COALESCE ( (SELECT SUM(MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE) , 0) :: TFloat;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_OrderInternalPromo (ioId            := ioId
                                                      , inInvNumber     := inInvNumber
                                                      , inOperDate      := inOperDate
                                                      , inStartSale     := inStartSale
                                                      , inAmount        := vbAmount
                                                      , inRetailId      := inRetailId
                                                      , inComment       := inComment
                                                      , inUserId        := vbUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.19         *
*/