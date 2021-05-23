-- Function: gpInsertUpdate_MI_IncomeFuel_Sign()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_IncomeFuel_Sign (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_IncomeFuel_Sign(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inIsSign              Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeFuel_Sign());
     vbUserId:= lpGetUserBySession (inSession);


     -- сохранили
     PERFORM gpInsertUpdate_MI_Sign (inMovementId, inIsSign, inSession);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.  Климентьев К.И.
 03.08.17         *
 23.08.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '12894') -- Степаненко О.М.
-- SELECT * FROM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '12894') -- Степаненко О.М.

-- SELECT * FROM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '9463') -- Махота Д.П.
-- SELECT * FROM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '9463') -- Махота Д.П.
