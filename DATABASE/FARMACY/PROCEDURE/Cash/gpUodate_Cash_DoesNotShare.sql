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
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;

   DECLARE text_var1 text;
BEGIN

   -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        RAISE EXCEPTION 'Не определено подразделение';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
   IF COALESCE(inGoodsID, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_DoesNotShare(), inGoodsID, inDoesNotShare);

    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET isDoesNotShare = inDoesNotShare
     WHERE Object_Goods_Main.Id IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inGoodsID);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_DoesNotShare', text_var1::TVarChar, vbUserId);
   END;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inGoodsID, vbUserId);
   
   PERFORM gpInsertUpdate_Object_GoodsDivisionLock(ioId       := 0
                                                 , inGoodsId  := inGoodsID
                                                 , inUnitId   := vbUnitId
                                                 , inisLock   := inDoesNotShare
                                                 , inSession  := inSession);   

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUodate_Cash_DoesNotShare(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.   Шаблий О.В.
 09.03.19                                                                        *

*/