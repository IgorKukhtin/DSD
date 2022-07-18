-- View: Object_Goods_View_ForSite

DROP VIEW IF EXISTS Object_Goods_View_ForSite;

CREATE OR REPLACE VIEW Object_Goods_View_ForSite AS
    SELECT
         ObjectLink_Goods_Object.ObjectId                        as id
       , Object_Goods.ObjectCode                                 as article
       , ObjectFloat_Goods_Site.ValueData :: Integer             as Id_Site
       , ObjectBlob_Site.ValueData                               as Name_Site
       , Object_Goods.ValueData                                  as name
       , ObjectString_NameUkr.ValueData                          as nameukr
       , ObjectString_Foto.ValueData                             as foto
       , ObjectString_Thumb.ValueData                            as thumb
       , ObjectBlob_Description.ValueData                        as description
       , ObjectString_Goods_Maker.ValueData                      as manufacturer
       , ObjectString_Goods_MakerUkr.ValueData                   as ManufacturerUkr
       , ObjectLink_Goods_Appointment.ChildObjectId              as appointment_id
       , Object_GoodsGroup.Id                                    as category_id
       , NULL::TFloat                                            AS Price
       , NULL::TFloat                                            AS PriceBADM
       , NULL::Integer                                           AS supplier_id
       , NULL::TVarChar                                          AS common_name
       , NULL::TDateTime                                         AS dateadd
       , NULL::Integer                                           AS user_id
       , CASE WHEN COALESCE(ObjectBoolean_Goods_Published.ValueData,FALSE)=TRUE THEN 1::Integer ELSE 0::Integer END AS published
       , CASE WHEN Object_Goods.isErased=TRUE THEN 1::Integer ELSE 0::Integer END                                   AS deleted
       , ObjectLink_Goods_Object.ChildObjectId                  AS ObjectId
       , COALESCE(ObjectBoolean_Goods_HideOnTheSite.ValueData, FALSE) AS isHideOnTheSite
       , tmpBarCode.BarCode

       , Object_FormDispensing.ValueData                        AS FormDispensingName
       , ObjectString_FormDispensing_NameUkr.ValueData          AS FormDispensingNameUkr
       
       , ObjectFloat_Goods_NumberPlates.ValueData::Integer      AS NumberPlates   
       , ObjectFloat_Goods_QtyPackage.ValueData::Integer        AS QtyPackage
       , COALESCE(ObjectBoolean_Goods_Recipe.ValueData, FALSE)  AS isRecipe

    -- FROM Object_Goods_View AS Object_Goods
    FROM ObjectLink AS ObjectLink_Goods_Object

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_Goods_Object.ObjectId
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                             ON ObjectLink_LinkGoods_Goods.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                            AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
        LEFT JOIN ObjectLink AS ObjectLink_Main 
                             ON ObjectLink_Main.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                            AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                    ON ObjectFloat_Goods_Site.ObjectId = ObjectLink_Goods_Object.ObjectId
                                   AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()
        LEFT OUTER JOIN ObjectBoolean AS ObjectBoolean_Goods_Published
                                      ON ObjectBoolean_Goods_Published.ObjectId = ObjectLink_Goods_Object.ObjectId
                                     AND ObjectBoolean_Goods_Published.DescId = zc_ObjectBoolean_Goods_Published()
        LEFT OUTER JOIN ObjectBoolean AS ObjectBoolean_Goods_HideOnTheSite
                                      ON ObjectBoolean_Goods_HideOnTheSite.ObjectId = ObjectLink_Main.ChildObjectId 
                                     AND ObjectBoolean_Goods_HideOnTheSite.DescId = zc_ObjectBoolean_Goods_HideOnTheSite()
        LEFT OUTER JOIN ObjectString AS ObjectString_Foto
                                     ON ObjectString_Foto.ObjectId = ObjectLink_Goods_Object.ObjectId
                                    AND ObjectString_Foto.DescId = zc_ObjectString_Goods_Foto()
        LEFT OUTER JOIN ObjectString AS ObjectString_Thumb
                                     ON ObjectString_Thumb.ObjectId = ObjectLink_Goods_Object.ObjectId
                                    AND ObjectString_Thumb.DescId = zc_ObjectString_Goods_Thumb()
                                    
        LEFT OUTER JOIN ObjectString AS ObjectString_NameUkr
                                     ON ObjectString_NameUkr.ObjectId = ObjectLink_Goods_Object.ObjectId
                                    AND ObjectString_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()
                                    
        LEFT OUTER JOIN ObjectBlob AS ObjectBlob_Site
                                   ON ObjectBlob_Site.ObjectId = ObjectLink_Goods_Object.ObjectId
                                  AND ObjectBlob_Site.DescId = zc_objectBlob_Goods_Site()
        LEFT OUTER JOIN ObjectBlob AS ObjectBlob_Description
                                   ON ObjectBlob_Description.ObjectId = ObjectLink_Goods_Object.ObjectId
                                  AND ObjectBlob_Description.DescId = zc_objectBlob_Goods_Description()
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_Appointment
                                   ON ObjectLink_Goods_Appointment.ObjectId = ObjectLink_Goods_Object.ChildObjectId -- Object_Goods.ObjectId
                                  AND ObjectLink_Goods_Appointment.DescId = zc_ObjectLink_Goods_Appointment()
                                  
        LEFT OUTER JOIN (WITH  tmpBarCode AS (
                           SELECT DISTINCT
                                  Object_Goods_Retail.Id        AS GoodsId
                                , Object_Goods.ValueData        AS GoodsName

                           FROM ObjectLink AS ObjectLink_Goods_Object -- связь с Юридические лица или Торговая сеть или ...
                                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId
                                -- получается GoodsMainId
                                LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                                                         AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                        AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                LEFT JOIN  Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = ObjectLink_Main.ChildObjectId
                                                              AND Object_Goods_Retail.RetailId = 4
                           WHERE ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                             AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                             AND ObjectLink_Main.ChildObjectId > 0 -- !!!убрали безликие!!!
                             AND length(Object_Goods.ValueData) = 13)
                               
                         SELECT tmpBarCode.GoodsId
                              , string_agg(tmpBarCode.GoodsName, ',') AS BarCode
                         FROM tmpBarCode                        
                         GROUP BY tmpBarCode.GoodsId) AS tmpBarCode ON tmpBarCode.GoodsId = ObjectLink_Goods_Object.ObjectId

        LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                               ON ObjectString_Goods_Maker.ObjectId = ObjectLink_Main.ChildObjectId 
                              AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()   
        LEFT JOIN ObjectString AS ObjectString_Goods_MakerUkr
                               ON ObjectString_Goods_MakerUkr.ObjectId = ObjectLink_Main.ChildObjectId 
                              AND ObjectString_Goods_MakerUkr.DescId = zc_ObjectString_Goods_MakerUkr()   

        LEFT JOIN ObjectLink AS ObjectLink_Goods_FormDispensing
                             ON ObjectLink_Goods_FormDispensing.ObjectId = ObjectLink_Main.ChildObjectId 
                            AND ObjectLink_Goods_FormDispensing.DescId = zc_ObjectLink_Goods_FormDispensing()
        LEFT JOIN Object AS Object_FormDispensing ON Object_FormDispensing.Id = ObjectLink_Goods_FormDispensing.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_FormDispensing_NameUkr
                               ON ObjectString_FormDispensing_NameUkr.ObjectId = Object_FormDispensing.Id
                              AND ObjectString_FormDispensing_NameUkr.DescId = zc_ObjectString_FormDispensing_NameUkr()   

        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_NumberPlates
                                    ON ObjectFloat_Goods_NumberPlates.ObjectId = ObjectLink_Main.ChildObjectId 
                                   AND ObjectFloat_Goods_NumberPlates.DescId = zc_ObjectFloat_Goods_NumberPlates()
        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_QtyPackage
                                    ON ObjectFloat_Goods_QtyPackage.ObjectId = ObjectLink_Main.ChildObjectId 
                                   AND ObjectFloat_Goods_QtyPackage.DescId = zc_ObjectFloat_Goods_QtyPackage()
        LEFT OUTER JOIN ObjectBoolean AS ObjectBoolean_Goods_Recipe
                                      ON ObjectBoolean_Goods_Recipe.ObjectId = ObjectLink_Main.ChildObjectId 
                                     AND ObjectBoolean_Goods_Recipe.DescId = zc_ObjectBoolean_Goods_Recipe()

    WHERE ObjectLink_Goods_Object.ChildObjectId = 4 -- !!!ВРЕМЕННО!!!
      -- AND (ObjectBoolean_Goods_Published.ValueData = TRUE OR ObjectBoolean_Goods_Published.ValueData IS NULL)
    --ORDER BY ObjectBlob_Site.ValueData
   ;

ALTER TABLE Object_Goods_View_ForSite  OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 23.11.15                                                          *
*/

-- Select * from Object_Goods_View_ForSite as Object_Goods Where Object_Goods.ObjectId = lpGet_DefaultValue('zc_Object_Retail', 3)::Integer LIMIT 100