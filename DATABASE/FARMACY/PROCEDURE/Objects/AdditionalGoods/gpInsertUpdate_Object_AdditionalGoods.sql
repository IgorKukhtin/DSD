DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AdditionalGoods (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AdditionalGoods(
 INOUT ioId               Integer   , -- ключ объекта <Дополнительный товар>
    IN inGoodsMainId      Integer   , -- Главный товар
    IN inGoodsSecondId    Integer   , -- Товар для замены
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean;   
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession(inSession);

    IF EXISTS(SELECT Object_AdditionalGoods_View.Id               
               FROM Object_AdditionalGoods_View
              WHERE Object_AdditionalGoods_View.GoodsMainId = inGoodsMainId
                AND Object_AdditionalGoods_View.GoodsSecondId = inGoodsSecondId
                AND Object_AdditionalGoods_View.Id <> COALESCE (ioId, 0)) 
    THEN
        RAISE EXCEPTION 'Связь между данными товарами уже установлена';
    END IF;

   
   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_AdditionalGoods(), 0, '');
   
   -- сохранили связь с <главным товаром>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_AdditionalGoods_GoodsMain(), ioId, inGoodsMainId);   
   -- сохранили связь с <доп товаром>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_AdditionalGoods_GoodsSecond(), ioId, inGoodsSecondId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AdditionalGoods (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 11.10.15                                                          *
*/