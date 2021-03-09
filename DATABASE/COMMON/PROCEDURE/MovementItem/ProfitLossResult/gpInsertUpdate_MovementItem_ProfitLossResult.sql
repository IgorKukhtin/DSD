-- Function: gpInsertUpdate_MovementItem_ProfitLossResult()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProfitLossResult (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ProfitLossResult(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inAccountId             Integer   , -- Товары
    IN inContainerId           TFloat    , -- Партия ОС
    IN inAmount                TFloat    , -- Количество
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProfitLossResult());

     -- сохранили
     ioId := lpInsertUpdate_MovementItem_ProfitLossResult (ioId          := ioId
                                                         , inMovementId  := inMovementId
                                                         , inAccountId   := inAccountId
                                                         , inAmount      := inAmount
                                                         , inContainerId := inContainerId
                                                         , inUserId      := vbUserId
                                                          ) ;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.03.21         *
*/

-- тест
--