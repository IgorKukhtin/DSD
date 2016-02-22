-- Function: gpInsertUpdate_Object_Goods_IsSpecCondition()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_IsSpecCondition(TVarChar, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_IsSpecCondition(
    IN inGoodsCode           TVarChar   ,    -- код объекта <Товар>
    IN inObjectId            Integer    ,    -- Ключ объекта <поставщик>
    IN inIsSpecCondition     Boolean    ,    -- товар под спец условия
    IN inSession             TVarChar        -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
BEGIN
    --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
    vbUserId := inSession;

    IF COALESCE(inObjectId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Сначала выберите поставщика';
    END IF;
    
    -- Ищем по коду и inObjectId
    SELECT Object_Goods_View.Id INTO vbGoodsId
    FROM Object_Goods_View 
    WHERE Object_Goods_View.ObjectId = inObjectId
      AND Object_Goods_View.GoodsCode = inGoodsCode;   

    IF COALESCE(vbGoodsId,0) <> 0
    THEN
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Goods_SpecCondition(), vbGoodsId, inIsSpecCondition);    
    END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Goods_IsSpecCondition(TVarChar, Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 18.02.16         *
*/                                          

                                           