-- Function: gpUpdate_Goods_inTop()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inTop (Integer, Boolean, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inTop(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inTOP                 Boolean   ,    -- ТОП - позиция
    IN inPercentMarkup	     TFloat    ,    -- % наценки
    IN inPrice               TFloat    ,    -- Цена реализации
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE(inId, 0) = 0 THEN
        RETURN;
     END IF;
     
     IF inTOP = TRUE
     THEN
       IF COALESCE (inPercentMarkup, 0) = 0 AND COALESCE (inPrice, 0) = 0
       THEN
         RAISE EXCEPTION 'Ошибка.При установке признака <Топ> должно быть установлено <%% наценки> или <Цена реализ.>.';       
       END IF;
     ELSE
       IF COALESCE (inPercentMarkup, 0) <> 0 OR COALESCE (inPrice, 0) <> 0
       THEN
         RAISE EXCEPTION 'Ошибка.При снятии признака <Топ> убарите <%% наценки> и <Цена реализ.>.';       
       END IF;     
     END IF;
     
     -- ТОП - позиция
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_TOP(), inId, inTOP);
     -- % наценки
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PercentMarkup(), inId, inPercentMarkup);
     -- Цена
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Price(), inId, inPrice);

      -- Сохранили в плоскую таблицй
     BEGIN
         UPDATE Object_Goods_Retail SET PercentMarkup   = inPercentMarkup
                                      , Price           = inPrice
                                      , isTOP           = inTOP
                                      , DateUpdate      = CURRENT_TIMESTAMP
         WHERE Object_Goods_Retail.ID = inId;
     EXCEPTION
        WHEN others THEN 
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
          PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inTop', text_var1::TVarChar, vbUserId);
     END;

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.   Шаблий О.В.
 03.04.20                                                                      * 
*/

-- тест
--select * from gpUpdate_Goods_inTop(ioId := 4414 , inTOP := 'False' , inPercentMarkup := 0 , inPrice := 0 , inSession := '183242');