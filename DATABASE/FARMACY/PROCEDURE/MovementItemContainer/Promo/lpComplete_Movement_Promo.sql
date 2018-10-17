-- Function: lpComplete_Movement_Promo (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Promo (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Promo(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$

BEGIN

  /*
     16.10.18 вынес в отдельную функцию: gpUpdate_MovementItemContainer_Promo

    -- 1. Обязательно
    PERFORM lpReComplete_Movement_Promo_All (inMovementId := inMovementId
                                           , inUserId     := inUserId
                                            );
  */

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Promo()
                               , inUserId     := inUserId
                                );

    -- сохранили <Статус надо прописать ObjectIntId_analyzer>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo_Prescribe(), inMovementId, TRUE);

    -- пересчитали суммы по документу (для суммы закупки, которая считается после проведения документа)
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm(inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.  Шаблий О.В.
 16.10.18                                                                       *
 25.04.16         *
*/