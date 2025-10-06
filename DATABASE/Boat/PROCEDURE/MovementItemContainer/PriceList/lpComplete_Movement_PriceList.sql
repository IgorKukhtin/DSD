DROP FUNCTION IF EXISTS lpComplete_Movement_PriceList (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PriceList(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate TDateTime;
BEGIN

    -- Проверка - Eсли не нашли
    IF COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Partner()), 0) = 0
    THEN
         RAISE EXCEPTION 'Ошибка.Не выбран Поставщик.';
    END IF;

    -- 1.1. дописали Link_Partner + Закупочная цена без ндс 
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Partner(), MovementItem.ObjectId, (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Partner()))
          , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_EKPrice(), MovementItem.ObjectId, MovementItem.Amount)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE;

    -- 1.2. дописали Рекомендуемая цена без ндс
    PERFORM lpInsertUpdate_ObjectFloat ( zc_ObjectFloat_Goods_EmpfPrice (), MovementItem.ObjectId, MIFloat_EmpfPriceParent.ValueData)
    FROM MovementItem
         -- Рекомендованная цена без ндс (упакови)
         INNER JOIN MovementItemFloat AS MIFloat_EmpfPriceParent
                                      ON MIFloat_EmpfPriceParent.MovementItemId = MovementItem.Id
                                     AND MIFloat_EmpfPriceParent.DescId         = zc_MIFloat_EmpfPriceParent()
                                     AND MIFloat_EmpfPriceParent.ValueData      <> 0
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE;


    -- нашли
    vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

    -- 2. дописали цена Прайс
    PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId          := 0
                                                      , inPriceListId := zc_PriceList_Basis()
                                                      , inGoodsId     := MovementItem.ObjectId
                                                      , inOperDate    := DATE_TRUNC ('MONTH', vbOperDate)
                                                      , inValue       := MIFloat_EmpfPriceParent.ValueData
                                                      , inUserId      := inUserId
                                                       )
    FROM MovementItem
         -- Рекомендованная цена без ндс (упакови)
         INNER JOIN MovementItemFloat AS MIFloat_EmpfPriceParent
                                      ON MIFloat_EmpfPriceParent.MovementItemId = MovementItem.Id
                                     AND MIFloat_EmpfPriceParent.DescId         = zc_MIFloat_EmpfPriceParent()
                                     AND MIFloat_EmpfPriceParent.ValueData      <> 0
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
