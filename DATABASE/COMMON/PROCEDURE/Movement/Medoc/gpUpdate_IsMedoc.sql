-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_IsMedoc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IsMedoc(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_...());
   vbUserId:= lpGetUserBySession(inSession);

   -- сохранили - выгрузка в медок прошла
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Medoc(), inMovementId, TRUE);

   -- сохранили "текущая дата", вместо "регистрации" - если её нет или убрали признак электронная (т.е. регистрацию медка)
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), tmp.MovementId, CURRENT_DATE)
   FROM (SELECT inMovementId AS MovementId) AS tmp
        LEFT JOIN MovementBoolean ON MovementBoolean.MovementId = tmp.MovementId
                                 AND MovementBoolean.DescId = zc_MovementBoolean_Electron()
   WHERE COALESCE (MovementBoolean.ValueData, FALSE) = FALSE
   ;

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.03.16                                        * 
 15.12.14                         * 
*/

-- тест
-- SELECT * FROM gpUpdate_IsMedoc (ioId:= 0, inSession:= '2')
