-- Function: gpUodate_Cash_DoesNotShare()

DROP FUNCTION IF EXISTS gpUodate_Cash_DoesNotShare(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUodate_Cash_DoesNotShare(
    IN inGoodsID             Integer   ,    -- ключ объекта <Товар>
    IN inDoesNotShare        BOOLEAN   ,    -- Признак блокировки деления товаров
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inGoodsID, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_DoesNotShare(), inGoodsID, inDoesNotShare);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inGoodsID, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUodate_Cash_DoesNotShare(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.   Шаблий О.В.
 09.03.19                                                                        *

*/