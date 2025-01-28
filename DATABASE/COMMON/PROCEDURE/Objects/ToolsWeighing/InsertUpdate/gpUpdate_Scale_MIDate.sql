-- Function: gpUpdate_Scale_MIDate()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MIDate (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MIDate(
    IN inMovementItemId        Integer   , -- Ключ объекта <Элемент документа>
    IN inDescCode              TVarChar  , -- 
    IN inValueData             TDateTime  , -- 
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
     PERFORM lpInsertUpdate_MovementItemDate (MovementItemDateDesc.Id, CASE WHEN inMovementItemId < 0 THEN -1 * inMovementItemId ELSE inMovementItemId END, CASE WHEN inMovementItemId < 0 THEN NULL ELSE inValueData END)
     FROM (SELECT inDescCode AS DescCode WHERE TRIM (inDescCode) <> '') AS tmp
          LEFT JOIN MovementItemDateDesc ON MovementItemDateDesc.Code = tmp.DescCode;


     -- сохранили свойство <Дата/время>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), CASE WHEN inMovementItemId < 0 THEN -1 * inMovementItemId ELSE inMovementItemId END, CURRENT_TIMESTAMP);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (CASE WHEN inMovementItemId < 0 THEN -1 * inMovementItemId ELSE inMovementItemId END, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.05.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_MIDate (inMovementItemId:= 0, inItemName:= 'zc_MIDate_BoxNumber', inValueData:= CURRENT_TIMESTAMP, inSession:= '5')
