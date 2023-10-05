-- Function: gpUpdate_Goods_NotTransferTime()

DROP FUNCTION IF EXISTS gpUpdate_Goods_CodeUKTZED(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_CodeUKTZED(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inCodeUKTZED          TVarChar  ,    -- Код УКТЗЕД
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCodeUKTZED BIGINT;
   DECLARE text_var1 text;
BEGIN

   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE(inId, 0) = 0 OR
      COALESCE(inCodeUKTZED, '') = '' OR
      length(REPLACE(REPLACE(REPLACE(inCodeUKTZED, ' ', ''), '.', ''), Chr(160), '')) < 4 OR
      length(REPLACE(REPLACE(REPLACE(inCodeUKTZED, ' ', ''), '.', ''), Chr(160), '')) > 10 OR
      inCodeUKTZED = (SELECT Object_Goods_Main.CodeUKTZED
                      FROM Object_Goods_Retail 
                           INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                      WHERE Object_Goods_Retail.Id = inId) 
   THEN
      RETURN;   
   END IF;
   
    -- Проверили на число
   BEGIN
     vbCodeUKTZED := REPLACE(REPLACE(REPLACE(inCodeUKTZED, ' ', ''), '.', ''), Chr(160), '')::BIGINT;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        RETURN;   
   END;
   
/*   -- !!!для сквозной синхронизации!!! со "всеми" Retail.Id
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_CodeUKTZED(), tmpGoods.GoodsId, inCodeUKTZED)
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
                    ) AS tmpGoods;*/
                    
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET CodeUKTZED = inCodeUKTZED
     WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_CodeUKTZED', text_var1::TVarChar, vbUserId);
   END;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.10.23                                                       *         

*/

-- тест
-- 
SELECT * FROM gpUpdate_Goods_CodeUKTZED (325, '9603210000', '3')