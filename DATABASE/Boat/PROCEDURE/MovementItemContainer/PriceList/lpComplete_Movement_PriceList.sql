DROP FUNCTION IF EXISTS lpComplete_Movement_PriceList (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PriceList(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- Проверка - Eсли не нашли
    IF COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Partner()), 0) = 0
    THEN
         RAISE EXCEPTION 'Ошибка.Не выбран Поставщик.';
    END IF;

    -- 1.
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Partner(), MovementItem.Id, (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Partner()))
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE;
    

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_PriceList()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.03.22         *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_PriceList (inMovementId:= 224, inUserId := zfCalc_UserAdmin() :: Integer)  order by ObjectId_parent;
