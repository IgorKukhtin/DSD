-- Function: gpSelect_Goods_ForSite()

DROP FUNCTION IF EXISTS gpSelect_Goods_ForSite (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Goods_ForSite(
    IN inGoodsName        TVarChar ,  -- Список товаров, через зпт
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id               Integer    -- Id Товара
             , Article          Integer    -- Код товара
             , Id_Site          Integer    -- Id на сайте
             , Name_Site        TVarChar   -- Название на сайте 
             , Name             TVarChar   -- Название
             , Foto             TVarChar   -- Фото товара
             , Thumb            TVarChar   -- путь к мелким фото
--             , Description   	TBlob      -- Описание товара на сайте
             , Manufacturer     TVarChar   -- Производитель
             , Appointmentid    Integer    -- Id назначение препарата
             , GroupId          Integer    -- Id Группы товаров
              )
AS
$BODY$
BEGIN

  -- Результат
  RETURN QUERY
  WITH tmpGoods AS (SELECT
                           ObjectLink_Goods_Object.ObjectId                        as id
                         , Object_Goods.ObjectCode                                 as article
                         , ObjectBlob_Site.ValueData                               as Name_Site
                         , Object_Goods.ValueData                                  as Name

                    FROM ObjectLink AS ObjectLink_Goods_Object
                            
                         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId
                                                                
                         LEFT OUTER JOIN ObjectBlob AS ObjectBlob_Site
                                                    ON ObjectBlob_Site.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                   AND ObjectBlob_Site.DescId = zc_objectBlob_Goods_Site()

                         LEFT OUTER JOIN ObjectBoolean AS ObjectBoolean_Goods_Published
                                                       ON ObjectBoolean_Goods_Published.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                      AND ObjectBoolean_Goods_Published.DescId = zc_ObjectBoolean_Goods_Published()

                    WHERE ObjectLink_Goods_Object.ChildObjectId = 4
                      AND Object_Goods.isErased = FALSE
                      AND COALESCE(ObjectBoolean_Goods_Published.ValueData, FALSE) = TRUE
                      AND (Object_Goods.ValueData ~* inGoodsName OR ObjectBlob_Site.ValueData ~* inGoodsName)    
                    )
  
  
  
  SELECT
       tmpGoods.Id                                             as Id
     , tmpGoods.article                                        as Article
     , ObjectFloat_Goods_Site.ValueData :: Integer             as Id_Site
     , tmpGoods.Name_Site::TVarChar                            as Name_Site
     , tmpGoods.name                                           as Name
     , ObjectString_Foto.ValueData                             as Foto
     , ObjectString_Thumb.ValueData                            as Thumb
--     , ObjectBlob_Description.ValueData                        as Description
     , ObjectString_Goods_Maker.ValueData                      as Manufacturer
     , ObjectLink_Goods_Appointment.ChildObjectId              as Appointmentid
     , Object_GoodsGroup.Id                                    as GroupId

  FROM tmpGoods
    
      LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                             ON ObjectString_Goods_Maker.ObjectId = tmpGoods.Id
                            AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()   

      LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                           ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.Id
                          AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
      LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId


      LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                  ON ObjectFloat_Goods_Site.ObjectId = tmpGoods.Id
                                 AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()
      LEFT OUTER JOIN ObjectString AS ObjectString_Foto
                                   ON ObjectString_Foto.ObjectId = tmpGoods.Id
                                  AND ObjectString_Foto.DescId = zc_ObjectString_Goods_Foto()
      LEFT OUTER JOIN ObjectString AS ObjectString_Thumb
                                   ON ObjectString_Thumb.ObjectId = tmpGoods.Id
                                  AND ObjectString_Thumb.DescId = zc_ObjectString_Goods_Thumb()
/*      LEFT OUTER JOIN ObjectBlob AS ObjectBlob_Description
                                 ON ObjectBlob_Description.ObjectId = tmpGoods.Id
                                AND ObjectBlob_Description.DescId = zc_objectBlob_Goods_Description()
*/
      LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_Appointment
                                 ON ObjectLink_Goods_Appointment.ObjectId = tmpGoods.Id
                                AND ObjectLink_Goods_Appointment.DescId = zc_ObjectLink_Goods_Appointment()

 ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.01.21                                                       *
*/

-- тест

SELECT * FROM gpSelect_Goods_ForSite(inGoodsName := 'Вали', inSession:= zfCalc_UserSite())