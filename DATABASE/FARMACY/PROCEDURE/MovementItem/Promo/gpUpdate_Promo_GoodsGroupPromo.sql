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
   DECLARE text_var1 text;
BEGIN
    -- проверка прав пользователя на вызов процедуры
   vbUserId := inSession;
   
   -- проверка <inName>
   IF COALESCE (inGoodsId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка. Товар не определен.';
   END IF;
   
    
   -- сохранили свойство <НДС> для всех сетей
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupPromo(), tmpGoods.GoodsId, COALESCE(inGoodsGroupPromoID, 0))
   FROM             (SELECT DISTINCT
                            COALESCE (ObjectLink_LinkGoods_Goods_find.ChildObjectId, Object_Goods.Id) AS GoodsId
                          , ObjectLink_Goods_Object.ChildObjectId                                     AS RetailId
                          , Object_Goods.*
                     FROM Object AS Object_Goods
                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                               ON ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id
                                              AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                               ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                              AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain_find
                                               ON ObjectLink_LinkGoods_GoodsMain_find.ChildObjectId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                                              AND ObjectLink_LinkGoods_GoodsMain_find.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods_find
                                               ON ObjectLink_LinkGoods_Goods_find.ObjectId = ObjectLink_LinkGoods_GoodsMain_find.ObjectId
                                              AND ObjectLink_LinkGoods_Goods_find.DescId = zc_ObjectLink_LinkGoods_Goods()

                          LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                               ON ObjectLink_Goods_Object.ObjectId = COALESCE (ObjectLink_LinkGoods_Goods_find.ChildObjectId, Object_Goods.Id)
                                              AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                          INNER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Goods_Object.ChildObjectId
                                                            AND Object_Retail.DescId = zc_Object_Retail()

                     WHERE Object_Goods.Id = inGoodsId
                    ) AS tmpGoods;


   -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET GoodsGroupPromoId = NULLIF (inGoodsGroupPromoID, 0)
     WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = ioId);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Promo_GoodsGroupPromo', text_var1::TVarChar, vbUserId);
   END;

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