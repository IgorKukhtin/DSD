-- Function: gpUpdate_Goods_NotTransferTime()

DROP FUNCTION IF EXISTS gpUpdate_Goods_NotTransferTime(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_NotTransferTime(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
 INOUT ioNotTransferTime     Boolean   ,    -- Не переводить в сроки
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  
                  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Spotter(), zc_Enum_Role_Admin(), zc_Enum_Role_TechnicalRediscount())) 
   THEN
       RAISE EXCEPTION 'Ошибка. У васнет правв изменять признак "Не переводить в сроки".';
   END IF;
   

   -- !!!для сквозной синхронизации!!! со "всеми" Retail.Id
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_NotTransferTime(), tmpGoods.GoodsId, ioNotTransferTime)
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
     UPDATE Object_Goods_Main SET isNotTransferTime = ioNotTransferTime
     WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_NotTransferTime', text_var1::TVarChar, vbUserId);
   END;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.10.19                                                       *         
 23.09.19                                                       *         

*/

-- тест
-- SELECT * FROM gpUpdate_Goods_NotTransferTime
