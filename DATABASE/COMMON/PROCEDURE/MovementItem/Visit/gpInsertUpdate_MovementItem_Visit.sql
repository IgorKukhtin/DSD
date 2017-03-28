-- Function: gpInsertUpdate_MovementItem_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Visit (Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Visit(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPhotoMobileId       Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Visit());
	    
    -- сохранили
    ioId:= lpInsertUpdate_MovementItem_Visit (ioId                 := COALESCE(ioId,0)
                                                , inMovementId     := inMovementId
                                                , inPhotoMobileId  := inPhotoMobileId
                                                , inAmount         := inAmount
                                                , inComment        := inComment
                                                , inUserId         := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 26.03.17         *
*/

-- тест
-- 