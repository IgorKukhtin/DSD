DROP FUNCTION IF EXISTS gpSelect_Object_Goods_For_Site(Boolean,Boolean,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_For_Site(
    IN inPublished     Boolean,       -- опубликован
    IN inErased        Boolean,       -- удален
    IN inStartRecord   Integer,       -- со строки
    IN inCountRecord   Integer,       -- кол-во строк
    IN inSession       TVarChar       -- сессия пользователя    
    
)
RETURNS TABLE (id Integer, article Integer, name TVarChar, foto TVarChar, thumb TVarChar,
               description TBlob, manufacturer	TVarChar, appointment_id Integer, category_id Integer,
               price TFloat, supplier_id Integer, dateadd TDateTime, user_id Integer,
               published Boolean, deleted Boolean) AS
$BODY$
    DECLARE vbObjectId Integer;
    DECLARE vbUserId Integer;
BEGIN

    vbUserId := lpGetUserBySession (inSession);

    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
    RETURN QUERY
        SELECT
            T0.id              --ИД товара, совпадает ли он с базой постргел?
           ,T0.article         --ИД статьи, не знаю, зачем оно
           ,T0.name            --название товара
           ,T0.foto            --фото товара
           ,T0.thumb           --превьюшка фото
           ,T0.description     --описание товара
           ,T0.manufacturer    --производитель(текстом)
           ,T0.appointment_id  --ИД назначение препарарат. ссылка на ИД в другой таблице
           ,T0.category_id     --ИД категории
           ,T0.price           --Цена
           ,T0.supplier_id     --ИД поставщика 
           ,T0.common_name     --общее название(алиас чтоли) типа другое название товара
           ,T0.dateadd         --дата добавления
           ,T0.user_id         --ИД юзера, какого юзера фиг его знает
           ,T0.published       --товар опубликован (для отображения)
           ,T0.deleted         --товар удален если =1
        FROM(
                SELECT 
                    Object_Goods.Id                                         as id
                   ,Object_Goods.GoodsCodeInt                               as article
                   ,Object_Goods.GoodsName                                  as name
                   ,ObjectString_Foto.ValueData                             as foto
                   ,ObjectString_Thumb.ValueData                            as thumb
                   ,ObjectBlob_Description.ValueData                        as description
                   ,Object_Goods.MakerName                                  as manufacturer
                   ,ObjectLink_Goods_Appointment.ChildObjectId              as appointment_id
                   ,Object_Goods.GoodsGroupId                               as category_id
                   ,NULL::TFloat                                            AS Price
                   ,NULL::Integer                                           AS supplier_id
                   ,NULL::TVarChar                                          AS common_name
                   ,NULL::TDateTime                                         AS dateadd
                   ,NULL::Integer                                           AS user_id
                   ,COALESCE(ObjectBoolean_Goods_Published.ValueData,FALSE) as published
                   ,Object_Goods.isErased                                   as deleted
                   ,ROW_NUMBER()OVER(ORDER BY Object_Goods.Id)              as RecNo
                FROM Object_Goods_View AS Object_Goods
                    LEFT OUTER JOIN ObjectBoolean AS ObjectBoolean_Goods_Published
                                                  ON ObjectBoolean_Goods_Published.ObjectId = Object_Goods.Id
                                                 AND ObjectBoolean_Goods_Published.DescId = zc_ObjectBoolean_Goods_Published()
                    LEFT OUTER JOIN ObjectString AS ObjectString_Foto
                                                 ON ObjectString_Foto.ObjectId = Object_Goods.Id 
                                                AND ObjectString_Foto.DescId = zc_ObjectString_Goods_Foto()
                    LEFT OUTER JOIN ObjectString AS ObjectString_Thumb
                                                 ON ObjectString_Thumb.ObjectId = Object_Goods.Id 
                                                AND ObjectString_Thumb.DescId = zc_ObjectString_Goods_Thumb()
                    LEFT OUTER JOIN ObjectBlob AS ObjectBlob_Description
                                               ON ObjectBlob_Description.ObjectId = Object_Goods.Id
                                              AND ObjectBlob_Description.DescId = zc_objectBlob_Goods_Description()
                    LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_Appointment
                                               ON ObjectLink_Goods_Appointment.ObjectId = Object_Goods.ObjectId
                                              AND ObjectLink_Goods_Appointment.DescId = zc_ObjectLink_Goods_Appointment()
                WHERE
                    Object_Goods.ObjectId = vbObjectId
                    AND
                    Object_Goods.isErased = inErased
                    AND
                    COALESCE(ObjectBoolean_Goods_Published.ValueData,FALSE) = inPublished
            ) AS T0
        WHERE
            T0.RecNo >= inStartRecord
            AND
            T0.RecNo < (inStartRecord + inCountRecord)
        ORDER BY
            T0.id ASC
        ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods_For_Site(Boolean,Boolean,Integer,Integer,TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 27.10.15                                                         *
 
*/

-- тест
 --SELECT * FROM gpSelect_Object_Goods_Count(TRUE,FALSE);


