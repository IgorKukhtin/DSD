-- Function: gpUpdate_Movement_IncomeFuel_ChangePriceUser()

DROP FUNCTION IF EXISTS gpUpdate_Movement_IncomeFuel_ChangePriceUser(Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_IncomeFuel_ChangePriceUser(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inChangePrice         TFloat    , -- Скидка в цене
    IN inisChangePriceUser   Boolean   , -- Ручная скидка в цене (да/нет)
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbStatusId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_IncomeFuel_ChangePriceUser());
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_Update_Movement_IncomeFuel_ChangePriceUser());

     --текущий статус документа
     vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inId);
     
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         --распроводим документ
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- сохранили свойство <Ручная скидка в цене (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ChangePriceUser(), inId, inisChangePriceUser);
     
     -- сохранили свойство <Скидка в цене>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_ChangePrice(), inId, inChangePrice);


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);


     -- 5.3. проводим Документ
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
          --
          PERFORM gpComplete_Movement_Income (inMovementId, FALSE, inSession);
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.22         *
*/

-- тест
--