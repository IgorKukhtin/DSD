-- Function: gpUpdate_Movement_WeighingPartner_Order()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingPartner_Order (Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingPartner_Order(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumberOrder       TVarChar  , -- Номер заявки контрагента
    IN inMovementId_Order     Integer   , -- ключ Документа заявка
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inId, 0) = 0
     THEN
          RAISE EXCEPTION 'Ошибка.Документ не записан.';
     END IF;


     -- сохранили свойство <Номер заявки у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), inId, inInvNumberOrder);

     -- сохранили связь с документом <Заявки сторонние>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inId, inMovementId_Order);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 06.06.16         *

*/

-- SELECT * FROM gpUpdate_Movement_WeighingPartner_Order (ioId:= 0, inInvNumber:= '-1', inMovementId_Order:= 0, , inSession:= '2')
