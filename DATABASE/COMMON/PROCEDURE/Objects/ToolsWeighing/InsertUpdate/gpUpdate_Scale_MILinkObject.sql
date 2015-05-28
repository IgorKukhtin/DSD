-- Function: gpUpdate_Scale_MILinkObject()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MILinkObject (Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MILinkObject(
    IN inMovementItemId        Integer   , -- Ключ объекта <Элемент документа>
    IN inDescCode              TVarChar  , -- 
    IN inObjectId              Integer   , -- 
    IN inSession               TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Scale_MI_Erased());
     vbUserId:= lpGetUserBySession (inSession);


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (MovementItemLinkObjectDesc.Id, inMovementItemId, inObjectId)
     FROM (SELECT inDescCode AS DescCode WHERE TRIM (inDescCode) <> '') AS tmp
          LEFT JOIN MovementItemLinkObjectDesc ON MovementItemLinkObjectDesc.Code = tmp.DescCode;


     -- сохранили свойство <Дата/время>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inMovementItemId, CURRENT_TIMESTAMP);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.05.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_MILinkObject (inMovementItemId:= 0, inItemName:= 'zc_MILinkObject_BoxNumber', inValueData:= 1, inSession:= '5')
