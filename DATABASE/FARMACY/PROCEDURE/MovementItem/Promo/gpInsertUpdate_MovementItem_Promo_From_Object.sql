-- Function: gpInsertUpdate_MovementItem_Promo_From_Object()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Promo_From_Object (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Promo_From_Object(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Инвентаризации>
    IN inObjectId            Integer   , -- Код товара
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
    IF COALESCE (inObjectId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Не выбран поставщик';
    END IF;
    
    -- Очистили
    PERFORM gpInsertUpdate_MovementItem_Promo_Set_Zero (inMovementId := inMovementId, inSession := inSession);

    -- сохранили
    PERFORM lpInsertUpdate_MovementItem_Promo (ioId                 := COALESCE(MI_Promo.Id,0)
                                             , inMovementId         := inMovementId
                                             , inGoodsId            := Goods.Id
                                             , inAmount             := 1
                                             , inPrice              := 0
                                             , inIsChecked          := False
                                             , inUserId             := vbUserId)
    FROM (SELECT DISTINCT Object_Goods_Retail.Id
          FROM ObjectLink AS ObjectLink_Goods_Object

              INNER JOIN Object AS Object_Goods 
                                ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 
                               AND Object_Goods.isErased = False
              
              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                    ON ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                   AND ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id

              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain 
                                    ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId 
                                   AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                   
              INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.RetailId = vbObjectId 
                                            AND Object_Goods_Retail.GoodsMainId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId


          WHERE ObjectLink_Goods_Object.ChildObjectId = inObjectId
         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()) AS Goods
    LEFT JOIN MovementItem AS MI_Promo
                           ON MI_Promo.ObjectId = Goods.Id
                          AND MI_Promo.MovementId = inMovementId
                          AND MI_Promo.DescId = zc_MI_Master();
         
    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Promo_From_Object (Integer, Integer, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
  31.01.20                                                      *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Promo_From_Object (inMovementId:= 0, inObjectId:= 183345, inSession:= '3')