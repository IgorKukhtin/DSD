-- update Object set ValueData = REPLACE(Object.ValueData, 'ÀGL', 'AGL') where ValueData <> REPLACE(Object.ValueData, 'ÀGL', 'AGL')

/*
delete from objectProtocol where ObjectId = 253247 ;
delete from ObjectLink where ObjectId = 253247 ;
delete from ObjectString where ObjectId = 253247 ;
delete from ObjectFloat where ObjectId = 253247 ;
delete from Object where Id = 253247 ;
*/

-- update MovementItemLinkObject set ObjectId = ReceiptGoodsId_Main from(

with tmp_ReceiptProdModel as (
        SELECT DISTINCT ObjectLink_Object.ChildObjectId AS GoodsId

        FROM Object AS Object_ReceiptProdModelChild
             LEFT JOIN ObjectLink AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()

             LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                  ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
             INNER JOIN Object AS Object_ReceiptProdModel
                                   ON Object_ReceiptProdModel.Id = ObjectLink_ReceiptProdModel.ChildObjectId
                                  AND Object_ReceiptProdModel.isErased = FALSE
        WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
          AND Object_ReceiptProdModelChild.isErased = FALSE
       )

   , tmp_all as (select tmp.*
                      , ROW_NUMBER() OVER (PARTITION BY ModelName, Comment
                                           ORDER BY CASE WHEN tmp.isErased = FALSE THEN 0 ELSE 1 END
                                                  , CASE WHEN tmp_ReceiptProdModel.GoodsId > 0 THEN 0 ELSE 1 END
                                                  , ReceiptGoodsId
                                          ) AS Ord
                 from (
                       select Object.Id AS ReceiptGoodsId, Object_Goods.Id AS GoodsId, Object_Goods.ObjectCode AS GoodsCode, Object_Goods.ValueData AS GoodsName
                            , SPLIT_PART (TRIM (RIGHT (LEFT (SPLIT_PART (Object_Goods.ValueData, 'AGL', 2), 5), 4)), 'AGL-', 1)  AS ModelName
                            , CASE WHEN Object_Goods.ValueData ILIKE '%RAL %' THEN TRIM (SPLIT_PART (Object_Goods.ValueData, 'AGL-', 1))
                                   ELSE ObjectString_Comment.ValueData
                              END AS Comment
     
                            , Object.isErased

                       
                       from Object 
                            LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                 ON ObjectLink_Goods.ObjectId = Object .Id
                                                AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
                            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId
                       
                                 LEFT JOIN ObjectString AS ObjectString_Comment
                                                        ON ObjectString_Comment.ObjectId = Object_Goods.Id
                                                       AND ObjectString_Comment.DescId = zc_ObjectString_Goods_Comment()
                       
                       where Object.DescId   = zc_Object_ReceiptGoods()
                       --AND Object.isErased = FALSE
                       ) as tmp
                       left join tmp_ReceiptProdModel on tmp_ReceiptProdModel.GoodsId = tmp.GoodsId
                 )

select distinct  tmp_all.* , tmp_main.ReceiptGoodsId AS ReceiptGoodsId_Main, tmp_main.GoodsName AS GoodsName_Main
--  , lpDel_Object_ReceiptGoods(tmp_all.ReceiptGoodsId, tmp_main.ReceiptGoodsId)
 
from tmp_all
      left join tmp_ReceiptProdModel on tmp_ReceiptProdModel.GoodsId = tmp_all.GoodsId
      left join tmp_all as tmp_main on tmp_main.ModelName = tmp_all.ModelName
                                   AND tmp_main.Comment   = tmp_all.Comment
                                   AND tmp_main.ord       = 1
where tmp_all.Ord <> 1 
-- and tmp_ReceiptProdModel.GoodsId is not null
order by tmp_main.ReceiptGoodsId, tmp_main.GoodsName, 4

-- ) as a where ReceiptGoodsId = ObjectId

-- select lpDel_Object_ReceiptGoods(33069, null)
/*252298
252299 
252379
252377
252381 
252382
*/
