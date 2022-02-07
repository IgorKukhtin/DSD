 -- Function: lpComplete_Movement_LayoutFile (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_LayoutFile (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_LayoutFile(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbLayoutFileId Integer;
BEGIN

     IF NOT EXISTS (SELECT 1
                    FROM Movement
                         INNER JOIN MovementString AS MovementString_FileName
                                                   ON MovementString_FileName.MovementId = Movement.Id
                                                  AND MovementString_FileName.DescId = zc_MovementString_FileName()
                                                  AND COALESCE (MovementString_FileName.ValueData,'') <> ''
                    WHERE Movement.DescId = zc_Movement_LayoutFile()
                      AND Movement.Id = inMovementId)
     THEN
          RAISE EXCEPTION 'Ошибка. К документу не прикреплен файл.';
     END IF;

     
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;

     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_LayoutFile()
                                , inUserId     := inUserId
                                 );
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.02.22                                                       *
*/

-- тест
-- 