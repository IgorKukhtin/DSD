-- Function: gpInsertUpdate_MovementItem_Check_SendVIP()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_SendVIP (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check_SendVIP(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMISendId            Integer   , -- Ключ объекта <Строка документа перемещения>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;

   DECLARE vbObjectId   Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbAmount_old TFloat;
   DECLARE vbPriceSale TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inMovementId, 0) = 0 OR
       COALESCE(inMISendId, 0) = 0 OR
       COALESCE(inAmount, 0) = 0 OR
       COALESCE(inPrice, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Не заполнены: ID чека <%> или Строка документа перемещения <%> или Количество <%> или Цена <%>', inMovementId, inMISendId, inAmount, inPrice;
    END IF;

    -- !!!только так - определяется <Торговая сеть>!!!
    vbObjectId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Unit())
                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                 );

    -- !!!Замена, вдруг у нас другая сеть!!!
    inGoodsId:= (SELECT ObjectLink_Child.ChildObjectId
                 FROM ObjectLink AS ObjectLink_Child_NB
                      INNER JOIN ObjectLink AS ObjectLink_Main_NB ON ObjectLink_Main_NB.ObjectId = ObjectLink_Child_NB.ObjectId
                                                                 AND ObjectLink_Main_NB.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                      INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ChildObjectId = ObjectLink_Main_NB.ChildObjectId
                                                               AND ObjectLink_Main.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                      INNER JOIN ObjectLink AS ObjectLink_Child
                                            ON ObjectLink_Child.ObjectId = ObjectLink_Main.ObjectId
                                           AND ObjectLink_Child.DescId   = zc_ObjectLink_LinkGoods_Goods()
                      INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                            ON ObjectLink_Goods_Object.ObjectId      = ObjectLink_Child.ChildObjectId
                                           AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                           AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId -- !!!другая сеть!!!
                 WHERE ObjectLink_Child_NB.ChildObjectId = inGoodsId -- здесь скорее всего сеть НБ
                   AND ObjectLink_Child_NB.DescId        = zc_ObjectLink_LinkGoods_Goods()
                );

    -- Проверим
    IF COALESCE (inGoodsId, 0) = 0
    THEN
         RAISE EXCEPTION 'Ошибка.Такой товар <%> НЕ найден в торговой сети <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (vbObjectId);
    END IF;

    -- Находим элемент по документу и товару
    IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId
                                           AND MovementItem.ObjectId   = inGoodsId
                                           AND MovementItem.DescId     = zc_MI_Master()
                                           AND MovementItem.isErased   = FALSE)
    THEN
        SELECT MovementItem.Id, MovementItem.Amount
        INTO vbId, vbAmount_old
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.ObjectId   = inGoodsId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
         ;
    END IF;

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    -- сохранили <Элемент документа>
    vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Master(), inGoodsId, inMovementId, inAmount + COALESCE (vbAmount_old, 0), NULL);

    -- сохранили свойство <Кол-во заявка>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), vbId, inAmount + COALESCE (vbAmount_old, 0));
    -- сохранили свойство <Цена>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbId, inPrice);

    -- сохранили свойство <Цена без скидки>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), vbId, inPrice);

    -- сохранили свойство <Строка документа перемещения>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), inMISendId, vbId);

    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_SendVIP(Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 29.05.20                                                                                      *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Check_SendVIP (ioId:= 219344347, inMovementId:= 12604039, inGoodsId:= 51922, inAmount:= 2, inPrice:= 248.80, inSession := '3')
