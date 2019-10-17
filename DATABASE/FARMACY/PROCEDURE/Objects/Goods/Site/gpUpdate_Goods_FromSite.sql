-- Function: gpUpdate_Goods_FromSite()

DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, TBlob, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, Integer, TBlob, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, Integer, TBlob, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_FromSite(
    IN inGoodsCode           Integer   ,    -- ключ объекта <Товар>
    IN inId                  Integer   ,    -- Ключ товара на сайте
    IN inName                TBlob     ,    -- Название товара на сайте
    IN inPhoto               TVarChar  ,    -- Фото
    IN inThumb               TVarChar  ,    -- Превью
    IN inDescription         TBlob     ,    -- Описание товара на сайте
    IN inManufacturer        TVarChar  ,    -- производитель
    IN inAppointmentCode     Integer   ,    -- назначение препарата
    IN inAppointmentName     TVarChar  ,    -- назначение препарата
    IN inPublished           Boolean   ,    -- Опубликован
    IN inIsOnly              Boolean   ,    -- сохранить Только 2 и 3 параметр
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbId Integer;
  DECLARE vbCount Integer;
  DECLARE vbApoitmentId Integer;
  DECLARE text_var1 text;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);


    -- поиск
    SELECT MAX (Id), COUNT (*)
           INTO vbId, vbCount
    FROM Object_Goods_View
    WHERE ObjectId = lpGet_DefaultValue ('zc_Object_Retail', vbUserId) :: Integer AND GoodsCodeInt = inGoodsCode;

    
    -- проверка
    IF COALESCE (vbId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Товаров с кодом <%> не найден.', inGoodsCode;
    END IF;
    -- проверка
    IF vbCount > 1
    THEN
        RAISE EXCEPTION 'Ошибка.Товаров с кодом <%> больше чем 1.', inGoodsCode;
    END IF;


    -- если нашли
    IF vbId <> 0
    THEN
        -- сохранили свойство <Ключ товара на сайте>
        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Site(), vbId, inId);

        -- сохранили свойство <Фото>
        PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Foto(), vbId, inPhoto);
        -- сохранили свойство <Превью>
        PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Thumb(), vbId, inThumb);
        -- сохранили свойство <Опубликован>
        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Published(), vbId, inPublished);

          -- Сохранили в плоскую таблицй
        BEGIN
          UPDATE Object_Goods_Main SET SiteId = inId
                                     , Foto = inPhoto
                                     , Thumb = inThumb
                                     , isPublished = inPublished
          WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = vbId);  
        EXCEPTION
           WHEN others THEN 
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
             PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_NotTransferTime', text_var1::TVarChar, vbUserId);
        END;

        IF COALESCE (inIsOnly, FALSE) = FALSE -- сохранить Только 2 и 3 параметр
        THEN
          -- сохранили свойство <название на сайте>
          PERFORM lpInsertUpdate_ObjectBlob (zc_objectBlob_Goods_Site(), vbId, inName);

          -- сохранили свойство <описание на сайте>
          PERFORM lpInsertUpdate_ObjectBlob (zc_objectBlob_Goods_Description(), vbId, inDescription);
          -- сохранили свойство <производитель>
          PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Maker(), vbId, inManufacturer);


            -- Сохранили в плоскую таблицй
          BEGIN
            UPDATE Object_Goods_Main SET MakerName = inManufacturer
            WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = vbId);  

            UPDATE Object_Goods_Blob SET Description = inDescription
                                       , NameSite    = inName
            WHERE Object_Goods_Blob.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = vbId);  
          EXCEPTION
             WHEN others THEN 
               GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
               PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_NotTransferTime', text_var1::TVarChar, vbUserId);
          END;
        END IF;
        
    END IF;

    -- для адекватного кода
    IF inAppointmentCode <> 0
    THEN
        -- поиск по коду
        vbApoitmentId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Appointment() AND ObjectCode = inAppointmentCode);
        -- добавили/изменили - ВСЕГДА
        vbApoitmentId:= lpInsertUpdate_Object (vbApoitmentId, zc_Object_Appointment(), inAppointmentCode, inAppointmentName);

        -- сохранили протокол
        PERFORM lpInsert_ObjectProtocol (vbApoitmentId, vbUserId);

        -- если нашли
        IF vbId <> 0
        THEN
          -- сохранили свойство <Apoitment>
          PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Appointment(), vbId, vbApoitmentId);

            -- Сохранили в плоскую таблицй
          BEGIN
            UPDATE Object_Goods_Main SET AppointmentId = vbApoitmentId
            WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = vbId);  
          EXCEPTION
             WHEN others THEN 
               GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
               PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_NotTransferTime', text_var1::TVarChar, vbUserId);
          END;
        END IF;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 17.10.19                                                                      *    
 06.04.16                                        * ALL
 11.11.15                                                          *
*/
