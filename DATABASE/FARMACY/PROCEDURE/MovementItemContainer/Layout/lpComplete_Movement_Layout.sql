 -- Function: lpComplete_Movement_Layout (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Layout (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Layout(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbLayoutId Integer;
BEGIN

     -- проверка если, например, док. был удален , то старый запретить распроводить если есть новый с такой выкладкой
     vbLayoutId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_Layout() AND MLO.MovementId = inMovementId);

     IF EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Layout
                                                   ON MovementLinkObject_Layout.MovementId = Movement.Id
                                                  AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
                                                  AND MovementLinkObject_Layout.ObjectId = vbLayoutId
                WHERE Movement.DescId = zc_Movement_Layout()
                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                  AND Movement.Id <> inMovementId)
     THEN
          RAISE EXCEPTION 'Ошибка.Документ для выкладки <%> уже существует.', lfGet_Object_ValueData (vbLayoutId);
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
                                , inDescId     := zc_Movement_Layout()
                                , inUserId     := inUserId
                                 );
    --пересчитываем сумму документа по приходным ценам
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm(inMovementId);    
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.08.20         *
*/

-- тест
-- 