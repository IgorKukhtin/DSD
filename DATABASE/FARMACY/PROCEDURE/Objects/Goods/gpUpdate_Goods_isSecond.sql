-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isSecond(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isSecond(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inisSecond            Boolean   ,    -- Неприоритет-выбор
   OUT outColor        Integer   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

  
   IF inisSecond = TRUE 
   THEN
      outColor = 16440317  ; --zc_Color_Red();  --16380671
   ELSE 
      IF (select COALESCE(ObjectBoolean.ValueData, False) FROM ObjectBoolean WHERE ObjectBoolean.DescId = zc_ObjectBoolean_Goods_First() AND ObjectBoolean.ObjectId = inId) = True
      THEN
          outColor = zc_Color_GreenL();
      ELSE
          outColor = zc_Color_White();
      END IF;
   END IF;

   

   -- !!!для сквозной синхронизации!!! со "всеми" Retail.Id
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Second(), tmpGoods.GoodsId, inisSecond)
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

                     WHERE Object_Goods.Id = inId
                    ) AS tmpGoods;

    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Retail SET isSecond = inisSecond
     WHERE Object_Goods_Retail.GoodsMainId IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isSecond', text_var1::TVarChar, vbUserId);
   END;
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.10.19                                                       *  
 12.04.16         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
