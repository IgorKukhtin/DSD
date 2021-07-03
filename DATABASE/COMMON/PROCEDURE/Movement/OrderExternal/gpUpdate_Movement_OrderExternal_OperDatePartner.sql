-- Function: gpUpdate_Movement_OrderExternal_OperDatePartner()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_OperDatePartner (Integer, Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_OperDatePartner(
    IN inId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inFromId              Integer   , --
    IN inOperDate            TDateTime , -- Дата док.
    IN inOperDatePartner     TDateTime , -- Дата отгрузки со склада
    IN inIsAuto              Boolean   , -- TRUE - расчет, FALSE - значит ручной режим
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

     -- проверка
     IF inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner)
     THEN
         -- inOperDatePartner:= DATE_TRUNC ('DAY', inOperDatePartner);
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     IF inIsAuto = TRUE 
     THEN
         inOperDatePartner:= inOperDate + (COALESCE ((SELECT ValueData FROM ObjectFloat WHERE ObjectId = inFromId AND DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0) :: TVarChar || ' DAY') :: INTERVAL;
     END IF;

     -- сохранили свойство <Дата отгрузки контрагенту>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), inId, inOperDatePartner);

     -- сохранили свойство <Режим расчета>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), inId, inIsAuto);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.06.18         *
*/

-- тест
-- 