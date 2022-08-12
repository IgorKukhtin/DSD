-- Function: gpUpdate_Movement_FinalSUA_DateOrder()

DROP FUNCTION IF EXISTS gpUpdate_Movement_FinalSUA_DateOrder (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_FinalSUA_DateOrder(
    IN inId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inDateOrder           TDateTime , -- Дата вставки в заказ
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
     IF inDateOrder <> DATE_TRUNC ('DAY', inDateOrder)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен.';
     END IF;

     -- сохранили <Дата вставки в заказ>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Order(), inId, inDateOrder);

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
-- SELECT * FROM gpUpdate_Movement_FinalSUA_DateOrder (inSession:= '2')