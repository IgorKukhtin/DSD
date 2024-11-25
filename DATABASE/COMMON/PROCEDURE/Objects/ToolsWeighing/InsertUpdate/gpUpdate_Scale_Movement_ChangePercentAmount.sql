-- Function: gpUpdate_Scale_Movement_ChangePercentAmount()

DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_ChangePercentAmount (Integer, TFloat, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Movement_ChangePercentAmount(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inChangePercentAmount TFloat    , -- % скидки для кол-ва поставщика
    IN inIsReason1           Boolean   , -- Причина скидки в кол-ве температура
    IN inIsReason2           Boolean   , -- Причина скидки в кол-ве качество
    IN inBranchCode          Integer   , --
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


     -- Проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <Взвешивание> не сформирован.';
     END IF;

     --
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercentAmount(), inMovementId, inChangePercentAmount);

     -- сохранили свойство <Причина скидки в кол-ве температура>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Reason1(), inMovementId, inIsReason1);

     -- сохранили свойство <Причина скидки в кол-ве качество>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Reason2(), inMovementId, inIsReason2);
       
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.10.24                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_Movement_ChangePercentAmount (inMovementId:= 29547683, inBranchCode:= 201, inIsUpdate:= TRUE, inSession:= '5')
