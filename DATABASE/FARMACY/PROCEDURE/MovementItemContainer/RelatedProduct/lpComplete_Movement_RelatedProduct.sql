-- Function: lpComplete_Movement_RelatedProduct (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_RelatedProduct (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_RelatedProduct(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$

BEGIN

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_RelatedProduct()
                               , inUserId     := inUserId
                                );
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.10.20                                                       *
*/