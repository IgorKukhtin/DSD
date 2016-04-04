-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_DateRegistered (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_DateRegistered(
    IN inMovementId_Tax          Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Corrective   Integer   , -- Ключ объекта <Документ>
    IN inSession                 TVarChar     -- Пользователь
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_...());
   vbUserId:= lpGetUserBySession(inSession);


   -- сохранили "текущая дата", вместо "регистрации" - если нет если её нет или убрали признак электронная (т.е. регистрацию медка)
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), tmp.MovementId, CURRENT_DATE)
   FROM (SELECT inMovementId_Tax AS MovementId WHERE inMovementId_Tax <> 0 AND COALESCE (inMovementId_Corrective, 0) = 0
        UNION 
         SELECT inMovementId_Corrective AS MovementId WHERE inMovementId_Corrective <> 0
        ) AS tmp
        LEFT JOIN MovementBoolean ON MovementBoolean.MovementId = tmp.MovementId
                                 AND MovementBoolean.DescId = zc_MovementBoolean_Electron()
   WHERE COALESCE (MovementBoolean.ValueData, FALSE) = FALSE
   ;

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (tmp.MovementId, vbUserId, FALSE)
   FROM (SELECT inMovementId_Tax AS MovementId WHERE inMovementId_Tax <> 0 AND COALESCE (inMovementId_Corrective, 0) = 0
        UNION 
         SELECT inMovementId_Corrective AS MovementId WHERE inMovementId_Corrective <> 0
        ) AS tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.03.16                                        * 
*/

-- тест
-- SELECT * FROM gpUpdate_DateRegistered (ioId:= 0, inSession:= '2')
