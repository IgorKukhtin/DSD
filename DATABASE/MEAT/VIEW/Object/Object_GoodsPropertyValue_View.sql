-- Object_GoodsPropertyValue_View

-- DROP VIEW IF EXISTS Object_GoodsPropertyValue_View;

CREATE OR REPLACE VIEW Object_GoodsPropertyValue_View AS

       SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId           AS GoodsPropertyId
            , ObjectLink_GoodsPropertyValue_Goods.ObjectId                        AS Id
            , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
            , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
            , ObjectString_BarCodeGLN.ValueData                                   AS BarCodeGLN
            , ObjectString_ArticleGLN.ValueData                                   AS ArticleGLN
       FROM ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
            LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                 ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
            LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                   ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                  AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
            LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                   ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                  AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
       WHERE ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods();


ALTER TABLE Object_GoodsPropertyValue_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 19.07.14                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_GoodsPropertyValue_View ORDER BY 1
