-- Function: gpUpdate_ScaleCeh_Movement_ArticleLoss()

DROP FUNCTION IF EXISTS gpUpdate_ScaleCeh_Movement_ArticleLoss (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ScaleCeh_Movement_ArticleLoss(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inArticleLossId       Integer   , -- Ключ объекта
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- сохранили связь с <Сотрудник комплектовщик 1>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inMovementId, inArticleLossId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.06.18                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_ScaleCeh_Movement_ArticleLoss (inMovementId:= 0, inSession:= '2')
