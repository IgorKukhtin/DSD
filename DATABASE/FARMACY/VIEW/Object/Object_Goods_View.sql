-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_Goods_View;

CREATE OR REPLACE VIEW Object_Goods_View AS
         SELECT 
             Object_Goods.Id                                  AS Id
           , Object_Goods.ObjectCode                          AS GoodsCodeInt
           , ObjectString.ValueData                           AS GoodsCode
           , Object_Goods.ValueData                           AS GoodsName
           , Object_Goods.isErased                            AS isErased
           , ObjectLink_Goods_Object.ChildObjectId            AS ObjectId
           , ObjectLink_Goods_GoodsGroup.ChildObjectId        AS GoodsGroupId
           , Object_GoodsGroup.ValueData                      AS GoodsGroupName
           , Object_Measure.Id                                AS MeasureId
           , Object_Measure.ValueData                         AS MeasureName
           , Object_NDSKind.Id                                AS NDSKindId
           , Object_NDSKind.ValueData                         AS NDSKindName

       FROM Object AS Object_Goods
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Object 
                                 ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()

            LEFT JOIN ObjectString ON ObjectString.ObjectId = Object_Goods.Id
                                  AND ObjectString.DescId = zc_ObjectString_Goods_Code()

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

       WHERE Object_Goods.DescId = zc_Object_Goods();


ALTER TABLE Object_Goods_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 23.07.14                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Goods_View
