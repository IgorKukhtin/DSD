-- Function: gpUpdate_Goods_FromSite()

DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite(Integer, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite(Integer, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite(Integer, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_FromSite(
    IN inGoodsCode           Integer   ,    -- ключ объекта <Товар>
    IN inPhoto               TVarChar  ,    -- Фото
    IN inThumb               TVarChar  ,    --Превью
    IN inDescription         TBlob     ,    --Описание товара
    IN inManufacturer        TVarChar  ,    --производитель (ObjectString_Goods_Maker)
    IN inAppointmentCode     Integer   ,    --назначение препарата
    IN inAppointmentName     TVarChar  ,    --назначение препарата
    IN inPublished           Boolean   ,    --Опубликован
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
    DECLARE vbId Integer;
    DECLARE vbApoitmentId Integer;
BEGIN
    Select
        id
    INTO
        vbId
    FROM
        Object_Goods_View
    Where 
        ObjectId = 4 
        AND
        GoodsCodeInt = inGoodsCode;
    IF COALESCE(vbId,0)<> 0
    THEN
        -- сохранили свойство <Фото>
        PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Foto(), vbId, inPhoto );
        -- сохранили свойство <Превью>
        PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Thumb(), vbId, inThumb );
        -- сохранили свойство <Описание>
        PERFORM lpInsertUpdate_ObjectBlob(zc_objectBlob_Goods_Description(), vbId, inDescription );
        -- сохранили свойство <производитель>
        PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Maker(), vbId, inManufacturer );
        -- сохранили свойство <Опубликован>
        PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Goods_Published(), vbId, inPublished );
        
        IF COALESCE(inAppointmentCode,0)<>0
        THEN
            SELECT
                ID
            INTO
                vbApoitmentId
            FROM
                Object
            WHERE
                DescId = zc_Object_Appointment()
                AND
                ObjectCode::Integer = inAppointmentCode;
            
            IF COALESCE(vbApoitmentId,0) = 0
            THEN
                vbApoitmentId := lpInsertUpdate_Object(vbApoitmentId, zc_Object_Appointment(), inAppointmentCode, inAppointmentName);
            END IF;
            -- сохранили свойство <Apoitment>
            PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Appointment(), vbId, vbApoitmentId );
        END IF;
    END IF;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Goods_FromSite(Integer, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 11.11.14                                                          *

*/
