-- Function: gpUpdate_MI_PromoGoods_MainDiscount()

--DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_MainDiscount (Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_MainDiscount (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoGoods_MainDiscount(
    IN inMovementId           Integer   , -- Ключ объекта <Документ>
    IN inGoodsId              Integer   , -- Товары
    IN inMainDiscount         TFloat    , -- общий % скидки
    IN inPriceSale            TFloat    , -- Цена на полке
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Promo_MainDiscount());

    -- поиск строки док. 
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MainDiscount(), MovementItem.Id, inMainDiscount)  -- общий % скидки
          , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), MovementItem.Id, COALESCE(inPriceSale,0))       -- сохранили <цена на полке>
          , lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
    FROM MovementItem
    WHERE MovementItem.DescId = zc_MI_Master()
      AND MovementItem.MovementId = inMovementId
      AND MovementItem.ObjectId = inGoodsId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.20         *
*/