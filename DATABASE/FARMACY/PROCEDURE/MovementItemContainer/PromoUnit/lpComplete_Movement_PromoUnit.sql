-- Function: lpComplete_Movement_PromoUnit (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_PromoUnit (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PromoUnit(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$

BEGIN

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_PromoUnit()
                               , inUserId     := inUserId
                                );

    -- пересчитали суммы по документу (для суммы закупки, которая считается после проведения документа)
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm(inMovementId);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 06.02.17         * 
*/