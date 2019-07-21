-- Function: gpUpdate_Promo_GoodsGroupPromo()

DROP FUNCTION IF EXISTS gpUpdate_Promo_GoodsGroupPromo (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Promo_GoodsGroupPromo(
    IN inGoodsId             Integer   , -- Ключ объекта <Товар>
    IN inGoodsGroupPromoID   Integer   , -- Группы товаров для маркетинга
    IN inSession             TVarChar    -- сессия пользователя
)

RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
   vbUserId := inSession;
   
   -- проверка <inName>
   IF COALESCE (inGoodsId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка. Товар не определен.';
   END IF;
   
    
   -- сохранили свойство <связи чьи товары>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupPromo(), inGoodsId, COALESCE(inGoodsGroupPromoID, 0));
 
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inGoodsId, vbUserId);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.07.19                                                       *
*/