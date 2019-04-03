-- View: Object_Goods_View

-- DROP VIEW IF EXISTS Object_Goods_View CASCADE;

CREATE OR REPLACE VIEW Object_Goods_View AS
         SELECT 
             ObjectLink_Goods_Object.ObjectId                 AS Id
           , Object_Goods.ObjectCode                          AS GoodsCodeInt
           , ObjectString.ValueData                           AS GoodsCode
           , Object_Goods.ValueData                           AS GoodsName
           , Object_Goods.isErased                            AS isErased
           , ObjectLink_Goods_Area.ChildObjectId              AS AreaId
           , ObjectLink_Goods_Object.ChildObjectId            AS ObjectId
           , ObjectLink_Goods_GoodsGroup.ChildObjectId        AS GoodsGroupId
           , Object_GoodsGroup.ValueData                      AS GoodsGroupName
           , ObjectLink_Goods_Measure.ChildObjectId           AS MeasureId
           , Object_Measure.ValueData                         AS MeasureName
           , ObjectLink_Goods_NDSKind.ChildObjectId           AS NDSKindId
           , Object_NDSKind.ValueData                         AS NDSKindName
           , ObjectFloat_NDSKind_NDS.ValueData                AS NDS
           , ObjectString_Goods_Maker.ValueData               AS MakerName
           , COALESCE (ObjectFloat_Goods_MinimumLot.ValueData, 0) :: TFloat AS MinimumLot
           , COALESCE (ObjectBoolean_Goods_Close.ValueData, FALSE)    AS isClose
           , COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)      AS isTOP
           , COALESCE (ObjectBoolean_First.ValueData, FALSE)          AS isFirst
           , COALESCE (ObjectBoolean_Second.ValueData, FALSE)         AS isSecond
           , ObjectBoolean_Published.ValueData                        AS isPublished
           , ObjectFloat_Goods_PercentMarkup.ValueData        AS PercentMarkup
           , ObjectFloat_Goods_Price.ValueData                AS Price
           , COALESCE (ObjectBoolean_Goods_IsUpload.ValueData, FALSE) AS IsUpload 
           , COALESCE (ObjectBoolean_Promo.ValueData, FALSE)          AS IsPromo
       FROM ObjectLink AS ObjectLink_Goods_Object

            LEFT JOIN Object AS Object_Goods 
                             ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 

            LEFT JOIN ObjectString ON ObjectString.ObjectId = ObjectLink_Goods_Object.ObjectId
                                  AND ObjectString.DescId = zc_ObjectString_Goods_Code()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                ON ObjectLink_Goods_Area.ObjectId = ObjectLink_Goods_Object.ObjectId
                               AND ObjectLink_Goods_Area.DescId   = zc_ObjectLink_Goods_Area()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_Goods_Object.ObjectId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   

        LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                               ON ObjectString_Goods_Maker.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()   

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                ON ObjectBoolean_Goods_Close.ObjectId = ObjectLink_Goods_Object.ObjectId 
                               AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()   

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                ON ObjectBoolean_Goods_TOP.ObjectId = ObjectLink_Goods_Object.ObjectId 
                               AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  

        LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                ON ObjectBoolean_First.ObjectId = ObjectLink_Goods_Object.ObjectId 
                               AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First() 
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                ON ObjectBoolean_Second.ObjectId = ObjectLink_Goods_Object.ObjectId 
                               AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second() 
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Published
                                ON ObjectBoolean_Published.ObjectId = ObjectLink_Goods_Object.ObjectId 
                               AND ObjectBoolean_Published.DescId = zc_ObjectBoolean_Goods_Published()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Promo
                                ON ObjectBoolean_Promo.ObjectId = ObjectLink_Goods_Object.ObjectId 
                               AND ObjectBoolean_Promo.DescId   = zc_ObjectBoolean_Goods_Promo()
                               

        LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_PercentMarkup
                               ON ObjectFloat_Goods_PercentMarkup.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()   

        LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                               ON ObjectFloat_Goods_Price.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectFloat_Goods_Price.DescId = zc_ObjectFloat_Goods_Price()   

        LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_MinimumLot
                               ON ObjectFloat_Goods_MinimumLot.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()   

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsUpload
                                ON ObjectBoolean_Goods_IsUpload.ObjectId = ObjectLink_Goods_Object.ObjectId 
                               AND ObjectBoolean_Goods_IsUpload.DescId = zc_ObjectBoolean_Goods_IsUpload()   

    WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object();


ALTER TABLE Object_Goods_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 30.04.16         *
 12.04.16         * add isSecond
 10.06.15                         *
 16.02.15                         *
 21.10.14                         *
 23.07.14                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Goods_View
