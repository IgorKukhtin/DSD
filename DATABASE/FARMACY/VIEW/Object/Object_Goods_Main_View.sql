-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_Goods_Main_View CASCADE;

CREATE OR REPLACE VIEW Object_Goods_Main_View AS
         SELECT 
             ObjectBoolean_Goods_isMain.ObjectId              AS Id
           , Object_Goods.ObjectCode                          AS GoodsCode
           , Object_Goods.ValueData                           AS GoodsName
           , Object_Goods.isErased                            AS isErased
           , ObjectLink_Goods_Object.ChildObjectId            AS ObjectId
           , ObjectLink_Goods_GoodsGroup.ChildObjectId        AS GoodsGroupId
           , Object_GoodsGroup.ValueData                      AS GoodsGroupName
           , ObjectLink_Goods_Measure.ChildObjectId           AS MeasureId
           , Object_Measure.ValueData                         AS MeasureName
           , ObjectLink_Goods_NDSKind.ChildObjectId           AS NDSKindId
           , Object_NDSKind.ValueData                         AS NDSKindName
           , ObjectFloat_NDSKind_NDS.ValueData                AS NDS

       FROM ObjectBoolean AS ObjectBoolean_Goods_isMain 

            LEFT JOIN Object AS Object_Goods 
                             ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Object 
                                 ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
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

   WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain();


ALTER TABLE Object_Goods_Main_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 23.07.14                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Goods_View
