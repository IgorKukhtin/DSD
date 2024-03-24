-- Object_GoodsByGoodsKind_View

DROP VIEW IF EXISTS Object_GoodsByGoodsKind_View;

CREATE OR REPLACE VIEW Object_GoodsByGoodsKind_View AS
       SELECT
             ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId           AS Id 
           , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId          AS GoodsId
           , Object_Goods.ObjectCode                                  AS GoodsCode
           , Object_Goods.ValueData                                   AS GoodsName
           , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId      AS GoodsKindId
           , Object_GoodsKind.ObjectCode                              AS GoodsKindCode
           , Object_GoodsKind.ValueData                               AS GoodsKindName
           , COALESCE (ObjectFloat_NormInDays.ValueData, 0) :: TFloat AS NormInDays
           , Object_GoodsByGoodsKind.isErased                         AS isErased
       FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
            JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                            ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                           AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
            LEFT JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId
            
            LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                                  ON ObjectFloat_NormInDays.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                 AND ObjectFloat_NormInDays.DescId   = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()
            
       WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods();


ALTER TABLE Object_GoodsByGoodsKind_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 30.10.13                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_GoodsByGoodsKind_View
