-- View: Object_Goods_View                                                            	

DROP VIEW IF EXISTS Object_LinkGoodsRetail_View;

CREATE OR REPLACE VIEW Object_LinkGoodsRetail_View AS
         SELECT 
           ObjectLink_LinkGoods_GoodsMain.ObjectId       AS Id
                                                        
         , ObjectLink_LinkGoods_GoodsMain.ChildObjectId  AS GoodsMainId
         , Object_MainGoods.GoodsCode                    AS GoodsMainCode
         , Object_MainGoods.GoodsName                    AS GoodsMainName

         , ObjectLink_LinkGoods_Goods.ChildObjectId      AS GoodsId
         , Object_Goods.GoodsCode                        AS GoodsCode
         , Object_Goods.GoodsName                        AS GoodsName

         , Object_Goods.ObjectId                         AS ObjectId
         , Object_MainGoods.ObjectId                     AS ObjectMainId
         , false                                         AS isErased
         
     FROM ObjectLink AS ObjectLink_LinkGoods_GoodsMain
          JOIN Object_Goods_View AS Object_MainGoods ON Object_MainGoods.Id = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
 
          JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                          ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                         AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
          JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = ObjectLink_LinkGoods_Goods.ChildObjectId
          
     WHERE ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain();

ALTER TABLE Object_Goods_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 23.07.14                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Goods_View
