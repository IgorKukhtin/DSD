-- Function: ()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inSupplementSUN1Load(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inSupplementSUN1Load(
    IN inGoodsCode           Integer  ,    -- код объекта <Товар>
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbObjectId Integer;
   DECLARE text_var1 text;
BEGIN
    --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
    vbUserId := inSession;

    -- определяется <Торговая сеть>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
     
    -- Ищем по коду и inObjectId    
    SELECT Object_Goods_Main.Id 
     INTO vbGoodsId
    FROM Object_Goods_Main 
    WHERE Object_Goods_Main.ObjectCode = inGoodsCode;

    IF COALESCE(vbGoodsId,0) <> 0
    THEN

       -- сохранили свойство <Дополнение СУН1>
       PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SupplementSUN1(), vbGoodsId, TRUE);
       
        -- Сохранили в плоскую таблицй
       BEGIN
         UPDATE Object_Goods_Main SET isSupplementSUN1 = TRUE
         WHERE Object_Goods_Main.Id = vbGoodsId;  
       EXCEPTION
          WHEN others THEN 
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
            PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Object_Goods_inSupplementSUN1Load', text_var1::TVarChar, vbUserId);
       END;

    ELSE 
        RAISE EXCEPTION 'Ошибка.Товар с кодом <%> не найден.', inGoodsCode;
    END IF;
    

END;
$BODY$
LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 28.12.20                                                      * 
*/