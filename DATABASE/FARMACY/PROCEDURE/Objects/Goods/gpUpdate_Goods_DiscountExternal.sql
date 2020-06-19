-- Function: gpUpdate_Goods_DiscountExternal()

DROP FUNCTION IF EXISTS gpUpdate_Goods_DiscountExternal(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_DiscountExternal(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inDiscountExternalId  Integer   ,    -- Товар для проекта (дисконтные карты)
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId             Integer;
   DECLARE vbDiscountExternalId Integer;
   DECLARE text_var1            text;
BEGIN

    IF COALESCE(inId, 0) = 0 THEN
      RETURN;
    END IF;

    vbUserId := lpGetUserBySession (inSession);


    -- Получаем сохраненное значение св-ва
    vbDiscountExternalId := COALESCE((SELECT OL.ChildObjectid FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Goods_DiscountExternal() AND OL.ObjectId = inId), 0);

     -- !!!протокол конкретного свойства объекта!!!
     IF COALESCE(vbDiscountExternalId, 0) <> COALESCE(inDiscountExternalId, 0)
     THEN
         -- сохранили свойство <Товар для проекта (дисконтные карты)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_DiscountExternal(), inId, inDiscountExternalId);
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inId, vbUserId);

          -- Сохранили в плоскую таблицй
         BEGIN
           UPDATE Object_Goods_Juridical SET DiscountExternalId      = inDiscountExternalId
                                           , UserUpdateId = vbUserId
                                           , DateUpdate   = CURRENT_TIMESTAMP
           WHERE Object_Goods_Juridical.Id = inId;  
         EXCEPTION
            WHEN others THEN 
              GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
              PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_Promo', text_var1::TVarChar, vbUserId);
         END;

         -- сохранили протокол
         PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
     END IF;
          
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Goods_DiscountExternal(Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 10.02.16         *
*/

--select * from gpUpdate_Goods_DiscountExternal(inId := 559417 , gpUpdate_Goods_DiscountExternal := 0,  inSession := '3');