DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AdditionalGoodsRetail (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AdditionalGoodsRetail(
    IN inGoodsMainCode      TVarChar   , -- Главный товар
    IN inGoodsSecondCode    TVarChar   , -- Товар для замены
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean;   
   DECLARE vbGoodsMainId Integer;
   DECLARE vbGoodsSecondId  Integer;
   DECLARE vbId  Integer;
   DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession(inSession);
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
    SELECT Id INTO vbGoodsMainId FROM Object_Goods_View
    WHERE ObjectId = vbObjectId AND GoodsCode = inGoodsMainCode;

    SELECT Id INTO vbGoodsSecondId FROM Object_Goods_View
    WHERE ObjectId = vbObjectId AND GoodsCode = inGoodsSecondCode;

    SELECT Id INTO vbId 
    FROM Object_AdditionalGoods_View
    WHERE Object_AdditionalGoods_View.GoodsMainId = vbGoodsMainId 
      AND Object_AdditionalGoods_View.GoodsSecondId = vbGoodsSecondId;

    IF (COALESCE(vbId,0) = 0) AND (COALESCE(vbGoodsMainId,0) <> 0) AND (COALESCE(vbGoodsSecondId,0) <> 0)
    THEN
        -- сохранили <Объект>
        vbId := lpInsertUpdate_Object (vbId, zc_Object_AdditionalGoods(), 0, '');
       
        -- сохранили связь с <главным товаром>
        PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_AdditionalGoods_GoodsMain(), vbId, vbGoodsMainId);   
        -- сохранили связь с <доп товаром>
        PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_AdditionalGoods_GoodsSecond(), vbId, vbGoodsSecondId);

        -- сохранили протокол
        PERFORM lpInsert_ObjectProtocol (inObjectId:= vbId, inUserId:= vbUserId, inIsUpdate:= FALSE, inIsErased:= NULL);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AdditionalGoodsRetail (TVarChar, TVarChar, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 11.10.15                                                          *
*/