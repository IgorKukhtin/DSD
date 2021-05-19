-- Function: gpUpdate_Movement_Sale_isOffer()


DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_isOffer (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_isOffer(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inisOffer              Boolean   , -- Примерка
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId := lpGetUserBySession (inSession);

     -- переопределили
     inisOffer := Not inisOffer;
     
     -- сохранили связь с <Примерка>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Offer(), inId, inisOffer);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.05.17         *
 */

-- тест