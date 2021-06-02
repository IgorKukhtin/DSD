-- Function: gpUpdate_Movement_Sale_isDisableSMS()


DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_isDisableSMS (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_isDisableSMS(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inisDisableSMS         Boolean   , -- 
   OUT outisDisableSMS        Boolean   , -- 
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId := lpGetUserBySession (inSession);

     -- переопределили
     outisDisableSMS := Not inisDisableSMS;
     
     -- сохранили связь с <Примерка>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DisableSMS(), inId, outisDisableSMS);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.21         *
 */

-- тест