-- Function: gpUpdate_Movement_FinalSUA_DateOrderClear()

DROP FUNCTION IF EXISTS gpUpdate_Movement_FinalSUA_DateOrderClear (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_FinalSUA_DateOrderClear(
    IN inId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_FinalSUA());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка

     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен.';
     END IF;

     IF NOT EXISTS(SELECT * 
                   FROM MovementDate AS MovementDate_DateOrder
                   WHERE MovementDate_DateOrder.MovementId = inId
                     AND MovementDate_DateOrder.DescId = zc_MovementDate_Order()
                     AND MovementDate_DateOrder.ValueData IS NOT NULL)
     THEN
         RETURN;
     END IF;

     -- сохранили <Дата вставки в заказ>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Order(), inId, Null);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.08.22                                                       *
 */

-- тест
-- SELECT * FROM gpUpdate_Movement_FinalSUA_DateOrderClear (inSession:= '2')