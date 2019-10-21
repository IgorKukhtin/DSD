-- Function: ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_PriceLoad(TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_PriceLoad(
    IN inGoodsCode           TVarChar  ,    -- код объекта <Товар>
    IN inPrice               TFloat    ,    -- цена
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
    SELECT Object_Goods_View.Id 
     INTO vbGoodsId
    FROM Object_Goods_View 
    WHERE Object_Goods_View.ObjectId = vbObjectId
      AND Object_Goods_View.GoodsCode = inGoodsCode;

    IF COALESCE(vbGoodsId,0) <> 0
    THEN
        -- сохраняем цену
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Goods_Price(), vbGoodsId, inPrice);    

        IF COALESCE(inPrice,0) > 0
        THEN
            -- если цена в экселе > 0 , ставить этим товарам zc_ObjectBoolean_Goods_TOP
            -- ТОП - позиция
            PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_TOP(), vbGoodsId, TRUE);
        END IF;

         -- Сохранили в плоскую таблицй
        BEGIN

           -- сохраняем цену
            -- если цена в экселе > 0 , ставить этим товарам zc_ObjectBoolean_Goods_TOP
            -- ТОП - позиция
          UPDATE Object_Goods_Retail SET Price  = inPrice
                                       , isTOP  = CASE WHEN COALESCE(inPrice,0) > 0 THEN TRUE ELSE isTOP END
          WHERE Object_Goods_Retail.GoodsMainId IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
        EXCEPTION
           WHEN others THEN 
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
             PERFORM lpAddObject_Goods_Temp_Error('gpInsertUpdate_Object_Goods_PriceLoad', text_var1::TVarChar, vbUserId);
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
 21.10.19                                                      * 
 02.04.18         *
*/*/