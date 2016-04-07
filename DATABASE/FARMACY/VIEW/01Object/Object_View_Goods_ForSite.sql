-- View: Object_Goods_View_ForSite

DROP VIEW IF EXISTS Object_Goods_View_ForSite;

CREATE OR REPLACE VIEW Object_Goods_View_ForSite AS
    SELECT 
        Object_Goods.Id                                         as id
       ,Object_Goods.GoodsCodeInt                               as article
       ,ObjectFloat_Goods_Site.ValueData                        as Id_Site
       ,ObjectBlob_Site.ValueData                               as Name_Site
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
       ,CASE WHEN COALESCE(ObjectBoolean_Goods_Published.ValueData,FALSE)=TRUE THEN 1::Integer ELSE 0::Integer END as published
       ,CASE WHEN Object_Goods.isErased=TRUE THEN 1::Integer ELSE 0::Integer END                                   as deleted
       ,Object_Goods.ObjectId                                   as ObjectId
    FROM Object_Goods_View AS Object_Goods
        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                    ON ObjectFloat_Goods_Site.ObjectId = Object_Goods.Id
                                   AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()
        LEFT OUTER JOIN ObjectBoolean AS ObjectBoolean_Goods_Published
                                      ON ObjectBoolean_Goods_Published.ObjectId = Object_Goods.Id
                                     AND ObjectBoolean_Goods_Published.DescId = zc_ObjectBoolean_Goods_Published()
        LEFT OUTER JOIN ObjectString AS ObjectString_Foto
                                     ON ObjectString_Foto.ObjectId = Object_Goods.Id 
                                    AND ObjectString_Foto.DescId = zc_ObjectString_Goods_Foto()
        LEFT OUTER JOIN ObjectString AS ObjectString_Thumb
                                     ON ObjectString_Thumb.ObjectId = Object_Goods.Id 
                                    AND ObjectString_Thumb.DescId = zc_ObjectString_Goods_Thumb()
        LEFT OUTER JOIN ObjectBlob AS ObjectBlob_Site
                                   ON ObjectBlob_Site.ObjectId = Object_Goods.Id
                                  AND ObjectBlob_Site.DescId = zc_objectBlob_Goods_Site()
        LEFT OUTER JOIN ObjectBlob AS ObjectBlob_Description
                                   ON ObjectBlob_Description.ObjectId = Object_Goods.Id
                                  AND ObjectBlob_Description.DescId = zc_objectBlob_Goods_Description()
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_Appointment
                                   ON ObjectLink_Goods_Appointment.ObjectId = Object_Goods.ObjectId
                                  AND ObjectLink_Goods_Appointment.DescId = zc_ObjectLink_Goods_Appointment();

ALTER TABLE Object_Goods_View_ForSite  OWNER TO postgres;

/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   ¬ÓÓ·Í‡ÎÓ ¿.¿.
 23.11.15                                                          *
*/

-- Select * from Object_Goods_View_ForSite as Object_Goods Where Object_Goods.ObjectId = lpGet_DefaultValue('zc_Object_Retail', 3)::Integer LIMIT 100
