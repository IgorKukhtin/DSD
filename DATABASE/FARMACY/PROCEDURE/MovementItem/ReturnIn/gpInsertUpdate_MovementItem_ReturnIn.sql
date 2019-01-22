-- Function: gpInsertUpdate_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnIn(
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

   DECLARE vbObjectId   Integer;
   DECLARE vbIsInsert   Boolean;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);


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

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    -- сохранили свойство <Цена>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     
    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummReturnIn (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.01.19         *
*/

-- тест
-- 