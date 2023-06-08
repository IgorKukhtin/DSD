-- Function: gpInsertUpdate_MovementItem_Check_DivideGoodsLots()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_DivideGoodsLots (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check_DivideGoodsLots(
 INOUT ioId                  Integer   , -- Ключ объекта <строка документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inPriceSale           TFloat    , -- Цена без скидки
    IN inNDSKindId           Integer   , -- Ставка НДС
    IN inPartionDateKindID   Integer   , -- Тип срок/не срок
    IN inDivisionPartiesId   Integer   , -- Разделение партий в кассе для продажи
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId   Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbAmount_old TFloat;
   DECLARE vbPriceSale TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);


    -- Находим элемент по документу и товару
    IF COALESCE (ioId, 0) = 0 OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = ioId)
    THEN
      -- задваивает, зараза, поэтому на этот случай - ТАК
      ioId:= (SELECT MAX(MovementItem.Id)
              FROM MovementItem
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                   LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                                 ON MIBoolean_Present.MovementItemId = MovementItem.Id
                                                AND MIBoolean_Present.DescId         = zc_MIBoolean_Present()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                    ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_DivisionParties
                                                    ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_DivisionParties.DescId = zc_MILinkObject_DivisionParties()
                   LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                   LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                                    ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsPresent
                                                    ON MILinkObject_GoodsPresent.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsPresent.DescId = zc_MILinkObject_GoodsPresent()
                   LEFT JOIN MovementItemBoolean AS MIBoolean_GoodsPresent
                                                 ON MIBoolean_GoodsPresent.MovementItemId = MovementItem.Id
                                                AND MIBoolean_GoodsPresent.DescId         = zc_MIBoolean_GoodsPresent()

              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.ObjectId   = inGoodsId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE
                AND COALESCE (MILinkObject_PartionDateKind.ObjectId, 0) = COALESCE (inPartionDateKindID, 0)
                AND COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId) = COALESCE (inNDSKindId, 0)
                AND COALESCE (MILinkObject_DivisionParties.ObjectId, 0) = COALESCE (inDivisionPartiesID, 0)
                AND COALESCE (MIFloat_Price.ValueData, 0) = inPrice
                AND COALESCE (MIBoolean_Present.ValueData, False) = False
                AND COALESCE (MIBoolean_GoodsPresent.ValueData, False) = False
             );
    END IF;


    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount + COALESCE (vbAmount_old, 0), NULL);

    -- сохранили свойство <Кол-во заявка>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), ioId, inAmount);
    -- сохранили свойство <Цена>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    -- сохранили свойство <Цена загруженная>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceLoad(), ioId, inPrice);
    
    -- !!!замена!!!
    IF COALESCE (inPriceSale, 0) = 0 THEN inPriceSale:= inPrice; END IF;
    -- сохранили свойство <Цена без скидки>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, inPriceSale);

    -- сохранили свойство <НДС>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_NDSKind(), ioId, inNDSKindId);

    -- сохранили связь с <Разделение партий в кассе для продажи>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DivisionParties(), ioId, COALESCE (inDivisionPartiesID, 0));

    -- сохранили свойство <Тип срок/не срок>
    IF COALESCE (inPartionDateKindID, 0) <> 0
    THEN
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionDateKind(), ioId, inPartionDateKindID);
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartionDate(), ioId, inPrice);
      BEGIN
        PERFORM lpInsertUpdate_MovementItemLinkContainer(inMovementItemId := ioId, inUserId := vbUserId);
      EXCEPTION
         WHEN others THEN vbUserId := vbUserId;
      END;        
    ELSE
      IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = ioId)
      THEN
        UPDATE MovementItem SET isErased = True, Amount = 0
        WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = ioId;
      END IF;
    END IF;
         
    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

    -- !!!ВРЕМЕННО для ТЕСТА!!!
/*    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', inSession, inPartionDateKindID;
    END IF;
*/
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_Site(Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.06.23                                                       *
*/

-- тест
-- 