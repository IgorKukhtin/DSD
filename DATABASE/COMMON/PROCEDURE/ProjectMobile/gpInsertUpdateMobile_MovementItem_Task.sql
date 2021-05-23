-- Function: gpInsertUpdateMobile_MovementItem_Task()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Task (Integer, Integer, Boolean, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_Task(
    IN inId         Integer   , -- Уникальный идентификатор формируется в Главной БД, и используется при синхронизации
    IN inMovementId Integer   , -- Уникальный идентификатор документа
    IN inClosed     Boolean   , -- Выполнено (да/нет)
    IN inComment    TVarChar  , -- Примечание. Заполняет Торговый, после выполнения/не выполнения задания
    IN inUpdateDate TDateTime , -- Дата/время когда торговый отметил выполнение/не выполнение задания
    IN inSession    TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- testm
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION 'Ошибка.Нет Прав.';
      END IF;


      -- проверяем существование задания
      SELECT MI_Task.Id
      INTO vbId
      FROM Movement AS Movement_Task
           JOIN MovementItem AS MI_Task
                             ON MI_Task.MovementId = Movement_Task.Id
                            AND MI_Task.DescId = zc_MI_Master()
                            AND MI_Task.Id = inId
      WHERE Movement_Task.DescId = zc_Movement_Task()
        AND Movement_Task.Id = inMovementId;

      IF COALESCE (vbId, 0) = 0
      THEN
           RAISE EXCEPTION 'Ошибка. Задание не заведено.';
      END IF;

      -- сохранили свойство <Выполнено (да/нет)>
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Close(), vbId, inClosed);

      -- сохранили свойство <Примечание>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbId, inComment);

      -- сохранили свойство <Дата/время выполнения задания>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_UpdateMobile(), vbId, inUpdateDate);

      -- сохранили свойство < Дата/время когда выполнилась загрузка с моб устр >
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), vbId, CURRENT_TIMESTAMP);


      RETURN vbId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 03.04.17                                                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdateMobile_MovementItem_Task (inId:= 71885005, inMovementId:= 5285630, inClosed:= true, inComment:= 'с трудом, но сделал', inUpdateDate:= CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
