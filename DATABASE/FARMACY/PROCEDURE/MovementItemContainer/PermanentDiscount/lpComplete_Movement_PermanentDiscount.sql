-- Function: lpComplete_Movement_PermanentDiscount (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_PermanentDiscount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PermanentDiscount(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$

BEGIN

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_PermanentDiscount()
                               , inUserId     := inUserId
                                );
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.12.19                                                       *
*/