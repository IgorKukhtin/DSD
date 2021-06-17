-- Function: gpInsertUpdate_MovementItem_Check_Site_Liki24()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_Site_Liki24 (Integer, Integer, TVarChar, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check_Site_Liki24(
 INOUT ioId                  Integer   , -- Ключ объекта <строка документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inItemId              TVarChar  , -- ID строки товара в заказе
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId   Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbSiteDiscount TFloat;
   DECLARE vbPriceSale TFloat;
   DECLARE vbStatusId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    IF inSession = zfCalc_UserAdmin()
    THEN
      inSession = zfCalc_UserSite();
    END IF;
    
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inItemId, '') = ''
    THEN
        RAISE EXCEPTION 'Оштбка. Не заполнено ID строки товара в заказе';
    END IF;


    IF COALESCE(ioId,0) = 0 AND
       EXISTS(SELECT MovementItemString.MovementItemId FROM MovementItemString
              WHERE MovementItemString.DescId = zc_MIString_ItemId()
                AND MovementItemString.ValueData = inItemId)
    THEN
      SELECT MovementItemString.MovementItemId
      INTO ioId
      FROM MovementItemString
      WHERE MovementItemString.DescId = zc_MIString_ItemId()
        AND MovementItemString.ValueData = inItemId;
    END IF;

    SELECT StatusId
    INTO vbStatusId
    FROM Movement
    WHERE Id = inMovementId;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
      RETURN;
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

    -- Находим элемент по документу и товару и ЦЕНЕ
    IF COALESCE(ioId,0) = 0
       OR NOT EXISTS(SELECT 1 FROM MovementItem WHERE Id = ioId)
    THEN
        SELECT MovementItem.Id
               INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.ObjectId   = inGoodsId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
         ;
    END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     inAmount := round(inAmount, 3);

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    -- сохранили свойство <Кол-во заявка>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), ioId, inAmount);
    -- сохранили свойство <Цена>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    -- сохранили свойство <Цена без скидки>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, inPrice);
    -- сохранили свойство <Id строки товара в заказе>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ItemId(), ioId, inItemId);

    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

/*    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', inItemId, inSession;
    END IF;
*/
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_Site_Liki24(Integer, Integer, TVarChar, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.06.20                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Check_Site_Liki24 (ioId:= 0, inMovementId:= 19235565 , inItemId := '1111111',  inGoodsId:= 36085, inAmount:= 2, inPrice:= 248.80, inSession := '3')