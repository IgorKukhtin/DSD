-- Function: gpUpdate_Goods_NDS_Full()

DROP FUNCTION IF EXISTS gpUpdate_Goods_NDS_Full(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_NDS_Full(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inNDSKindId           Integer   ,    -- NDS
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
      
   vbUserId := lpGetUserBySession (inSession);

   -- сохранили свойство <НДС> для всех сетей
   PERFORM 
           -- сохраняем новое значение НДС
           lpInsertUpdate_ObjectLink(inDescId        := zc_ObjectLink_Goods_NDSKind()
                                   , inObjectId      := COALESCE (tmpGoods.GoodsId, inId)
                                   , inChildObjectId := inNDSKindId
                                   ) 

   FROM Object AS Object_Retail
        LEFT JOIN (SELECT DISTINCT
                          COALESCE (ObjectLink_LinkGoods_Goods_find.ChildObjectId, Object_Goods.Id) AS GoodsId
                        , ObjectLink_Goods_Object.ChildObjectId                                     AS RetailId
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
                   WHERE Object_Goods.Id = inId
                  ) AS tmpGoods ON tmpGoods.RetailId = Object_Retail.Id AND tmpGoods.GoodsId > 0
   WHERE Object_Retail.DescId = zc_Object_Retail();
   
    -- Сохранили в плоскую таблицй
   BEGIN
       -- сохраняем новое значение НДС в главный товар
     UPDATE Object_Goods_Main SET NDSKindId = inNDSKindId
     WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  

   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_NDS_Full', text_var1::TVarChar, vbUserId);
   END;
   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 05.12.20                                                                      *         
*/

-- тест select * from gpUpdate_Goods_NDS_Full (inId := 586, inNDSKindId := zc_Enum_NDSKind_Special_0(), inSession := '3')