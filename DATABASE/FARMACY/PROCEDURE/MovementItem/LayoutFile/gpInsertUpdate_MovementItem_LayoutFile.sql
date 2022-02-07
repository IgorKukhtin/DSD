-- Function: gpInsertUpdate_MovementItem_LayoutFile()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LayoutFile (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LayoutFile(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- Аптека
    IN inIsChecked           Boolean   , -- отмечен
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
  
     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_LayoutFile (ioId                 := ioId
                                                  , inMovementId         := inMovementId
                                                  , inUnitId             := inUnitId
                                                  , inIsChecked          := inIsChecked
                                                  , inUserId             := vbUserId
                                                   );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.02.22                                                       *
*/