-- gpUpdate_Movement_Sale_CorrSumm()

DROP FUNCTION IF EXISTS gpUpdate_Movement_CorrSumm (Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_CorrSumm (Integer, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_CorrSumm (
    IN inMovementId    Integer   , -- Ключ объекта <Документ>
    IN inCorrSumm      TFloat    , -- Корректировка суммы покупателя для выравнивания округлений
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- сохранили свойство <Корректировка суммы покупателя для выравнивания округлений>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CorrSumm(), inMovementId, inCorrSumm);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

     -- проверка - что б Админ ничего не ломал
     IF vbUserId = 5 OR vbUserId = 9457
     THEN
         RAISE EXCEPTION 'Тест Ок.Нет прав - что б Админ ничего не ломал.';
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.08.15         * 
*/

-- тест
--