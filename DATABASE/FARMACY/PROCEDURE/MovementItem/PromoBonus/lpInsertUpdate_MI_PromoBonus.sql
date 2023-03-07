-- Function: lpInsertUpdate_MI_PromoBonus()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PromoBonus (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_PromoBonus(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inMIPromoId           Integer   , -- MI маркетингового контракта
    IN inAmount              TFloat    , -- Маркетинговый бонус
    IN inBonusInetOrder      TFloat    , -- Маркет бонусы для инет заказов, %
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbAmount Integer;
BEGIN
     
     IF EXISTS(SELECT 1
               FROM MovementItem

                   INNER JOIN MovementItemFloat AS MIPromo
                                                ON MIPromo.MovementItemId = MovementItem.Id
                                               AND MIPromo.DescId = zc_MIFloat_MovementItemId()

               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.Id <> COALESCE (ioId, 0)
                 AND MovementItem.DescId = zc_MI_Master()
                 AND MIPromo.ValueData = inMIPromoId)
     THEN
        RAISE EXCEPTION 'Ошибка. По товару и маркетинговому контракту должна быть одна запись.';     
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     vbAmount := COALESCE((SELECT MovementItem.Amount
                           FROM MovementItem WHERE  MovementItem.ID = ioId), 0);
          
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- Сохранили <MI маркетингового контракта>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMIPromoId);
       
     -- Сохранили <Маркет бонусы для инет заказов, %>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusInetOrder(), ioId, inBonusInetOrder);
       

       -- Сохранили <Дату изменения>
     -- сохранили
     IF COALESCE (inAmount, 0) <> vbAmount
     THEN
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;

     -- пересчитали Итоговые суммы по документу
     PERFORM lpInsertUpdate_PromoBonus_TotalSumm (inMovementId);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 17.02.21                                                                      * 
 */

-- тест
-- select * from gpInsertUpdate_MI_PromoBonus(ioId := 410422039 , inMovementId := 22181875 , inGoodsId := 14051181 , inMIPromoId := 339776720 , inAmount := 1 ,  inSession := '3');