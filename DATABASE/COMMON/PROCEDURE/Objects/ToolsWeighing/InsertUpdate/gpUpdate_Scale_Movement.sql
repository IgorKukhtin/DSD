-- Function: gpUpdate_Scale_Movement()

DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Movement(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inMovementDescId       Integer   , -- Вид документа
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- Проверка
     IF NOT EXISTS (SELECT 1 FROM gpGet_Movement_WeighingPartner (inMovementId:= inId, inSession:= inSession) AS tmp WHERE tmp.MovementDescId = inMovementDescId)
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не найден <%>', inId;
     END IF;


     -- Изменения - только Склад
     IF inMovementDescId = zc_Movement_Sale()
     THEN
         -- сохранили связь с <От кого (в документе)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);
     ELSEIF inMovementDescId = zc_Movement_ReturnIn()
     THEN
          -- сохранили связь с <Кому (в документе)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inId, inToId);
     ELSE
         RAISE EXCEPTION 'Ошибка. Вид документа <%> не может быть изменен', inMovementDescId;
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.08.16                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_Movement (inId:= 0, inAssetId:= 0, inSession:= '2')
