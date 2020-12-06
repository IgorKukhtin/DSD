-- Function: gpUpdate_Goods_KoeffSUN()

DROP FUNCTION IF EXISTS gpUpdate_Goods_KoeffSUN(Integer, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_KoeffSUN(
    IN inId                       Integer   ,    -- ключ объекта <>
    IN inis_v1                    Boolean   ,    --
    IN inis_v2                    Boolean   ,    --
    IN inis_v4                    Boolean   ,    --
    IN inis_Supplementv1          Boolean   ,    --
    IN inKoeffSUN_v1              TFloat    ,    --
    IN inKoeffSUN_v2              TFloat    ,    --
    IN inKoeffSUN_v4              TFloat    ,    --
    IN inKoeffSUN_Supplementv1    TFloat    ,    --
    IN inSession                  TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE text_var1    text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE (inis_v1, FALSE) = TRUE
   THEN
       -- сохранили <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_KoeffSUN_v1(), inId, inKoeffSUN_v1);

        -- Сохранили в плоскую таблицй
       BEGIN
         UPDATE Object_Goods_Retail SET KoeffSUN_v1 = inKoeffSUN_v1
         WHERE Object_Goods_Retail.Id = inId;  
       EXCEPTION
          WHEN others THEN 
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
            PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_KoeffSUN_v1', text_var1::TVarChar, vbUserId);
       END;

   END IF;
   
   IF COALESCE (inis_v2, FALSE) = TRUE
   THEN
       -- сохранили <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_KoeffSUN_v2(), inId, inKoeffSUN_v2);

        -- Сохранили в плоскую таблицй
       BEGIN
         UPDATE Object_Goods_Retail SET KoeffSUN_v2 = inKoeffSUN_v2
         WHERE Object_Goods_Retail.Id = inId;  
       EXCEPTION
          WHEN others THEN 
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
            PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_KoeffSUN_v2', text_var1::TVarChar, vbUserId);
       END;
   END IF;
   
   IF COALESCE (inis_v4, FALSE) = TRUE
   THEN
       -- сохранили <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_KoeffSUN_v4(), inId, inKoeffSUN_v4);
       
        -- Сохранили в плоскую таблицй
       BEGIN
         UPDATE Object_Goods_Retail SET KoeffSUN_v4 = inKoeffSUN_v4
         WHERE Object_Goods_Retail.Id = inId;  
       EXCEPTION
          WHEN others THEN 
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
            PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_KoeffSUN_v4', text_var1::TVarChar, vbUserId);
       END;
   END IF;
  
   IF COALESCE (inis_Supplementv1, FALSE) = TRUE
   THEN
       -- сохранили <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_KoeffSUN_Supplementv1(), inId, inKoeffSUN_Supplementv1);
       
        -- Сохранили в плоскую таблицй
       BEGIN
         UPDATE Object_Goods_Retail SET KoeffSUN_Supplementv1 = inKoeffSUN_Supplementv1
         WHERE Object_Goods_Retail.Id = inId;  
       EXCEPTION
          WHEN others THEN 
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
            PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_KoeffSUN_Supplementv1', text_var1::TVarChar, vbUserId);
       END;
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.05.20         *
*/