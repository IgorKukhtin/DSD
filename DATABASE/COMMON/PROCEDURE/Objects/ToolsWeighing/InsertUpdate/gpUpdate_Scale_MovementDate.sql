-- Function: gpUpdate_Scale_MovementDate()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MovementDate (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MovementDate(
    IN inMovementId        Integer   , -- Ключ объекта <Элемент документа>
    IN inDescCode          TVarChar  , -- 
    IN inValueData         TDateTime  , -- 
    IN inSession           TVarChar    -- сессия пользователя
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
     PERFORM lpInsertUpdate_MovementDate (MovementDateDesc.Id, inMovementId, inValueData)
     FROM (SELECT inDescCode AS DescCode WHERE TRIM (inDescCode) <> '') AS tmp
          LEFT JOIN MovementDateDesc ON MovementItemDateDesc.Code ILIKE tmp.DescCode;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.08.22                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_MovementDate (inMovementId:= 0, inDescCode:= 'zc_MovementDate_OperDatePartner', inValueData:= CURRENT_TIMESTAMP, inSession:= '5')
