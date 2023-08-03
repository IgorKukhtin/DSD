-- Function: lpUpdate__MovementItem_UnnamedEnterprises_Goods()

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_UnnamedEnterprises_Goods(Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_UnnamedEnterprises_Goods(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inNameUkr             TVarChar  ,    -- Название украинское
    IN inCodeUKTZED          TVarChar  ,    -- Код УКТЗЭД
    IN inExchangeId          Integer   ,    -- Од:
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN


   IF COALESCE(inId, 0) = 0 OR COALESCE (inNameUkr, '') = '' AND COALESCE (inCodeUKTZED, '') = '' AND COALESCE (inExchangeId, 0) = 0
   THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- !!!для сквозной синхронизации!!! со "всеми" Retail.Id
   -- сохранили свойство <Название украинское>
   IF COALESCE (inNameUkr, '') <> ''
   THEN

     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) AND 
        vbUserId <> 9383066 AND
        COALESCE (inNameUkr, '') <> COALESCE ((SELECT ObjectString_Goods_NameUkr.ValueData     
                                               FROM ObjectString AS ObjectString_Goods_NameUkr
                                               WHERE ObjectString_Goods_NameUkr.ObjectId = inId
                                                 AND ObjectString_Goods_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()), '')
     THEN
       RAISE EXCEPTION 'Изменения украинского названия вам запрещено.';   
     END IF;

     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_NameUkr(), tmpGoods.GoodsId, inNameUkr)
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
       UPDATE Object_Goods_Main SET NameUkr = inNameUkr
       WHERE Object_Goods_Main.Id IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
     EXCEPTION
        WHEN others THEN 
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
          PERFORM lpAddObject_Goods_Temp_Error('lpUpdate_MovementItem_UnnamedEnterprises_Goods', text_var1::TVarChar, vbUserId);
     END;
   END IF;

   -- сохранили свойство <Код УКТЗЭД>
   IF COALESCE (inCodeUKTZED, '') <> ''
   THEN
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_CodeUKTZED(), tmpGoods.GoodsId, inCodeUKTZED)
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
       UPDATE Object_Goods_Main SET CodeUKTZED = inCodeUKTZED
       WHERE Object_Goods_Main.Id IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
     EXCEPTION
        WHEN others THEN 
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
          PERFORM lpAddObject_Goods_Temp_Error('lpUpdate_MovementItem_UnnamedEnterprises_Goods', text_var1::TVarChar, vbUserId);
     END;
   END IF;

   -- сохранили свойство <Од>
   IF COALESCE (inExchangeId, 0) <> 0
   THEN
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Exchange(), tmpGoods.GoodsId, inExchangeId)
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
       UPDATE Object_Goods_Main SET ExchangeId = inExchangeId
       WHERE Object_Goods_Main.Id IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
     EXCEPTION
        WHEN others THEN 
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
          PERFORM lpAddObject_Goods_Temp_Error('lpUpdate_MovementItem_UnnamedEnterprises_Goods', text_var1::TVarChar, vbUserId);
     END;
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 02.10.18        *         

*/

-- тест
-- SELECT * FROM lpUpdate_MovementItem_UnnamedEnterprises_Goods
