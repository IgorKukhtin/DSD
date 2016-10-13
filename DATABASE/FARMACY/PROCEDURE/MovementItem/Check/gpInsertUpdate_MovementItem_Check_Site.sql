-- Function: gpInsertUpdate_MovementItem_Check_Site()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_Site (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check_Site(
 INOUT ioId                  Integer   , -- Ключ объекта <строка документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbAmount_old TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    -- Находим элемент по документу и товару и ЦЕНЕ
    IF COALESCE(ioId,0) = 0
       OR NOT EXISTS(SELECT 1 FROM MovementItem WHERE Id = ioId)
    THEN
        SELECT MovementItem.Id, MovementItem.Amount
               INTO ioId, vbAmount_old
        FROM MovementItem
             INNER JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                         AND MIFloat_Price.ValueData = inPrice
        WHERE MovementItem.MovementId = inMovementId 
          AND MovementItem.ObjectId   = inGoodsId 
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
         ;
    END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount + COALESCE (vbAmount_old, 0), NULL);

    -- сохранили свойство <Кол-во заявка>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), ioId, inAmount);

    -- сохранили свойство <Цена>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     
    -- сохранили свойство <Цена без скидки>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, inPrice);

    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_Site(Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 17.12.2015                                                                      *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Check_Site (ioId:= 0, inMovementId:= 2335126, inGoodsId:= 51922, inAmount:= 2, inPrice:= 22, inSession := '3')
