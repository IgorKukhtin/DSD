-- View: Object_Goods_View                                                            	

DROP VIEW IF EXISTS Object_LinkGoods_View;

CREATE OR REPLACE VIEW Object_LinkGoods_View AS
         SELECT 
           Object_LinkGoods.Id                           AS Id
                                                        
         , ObjectLink_LinkGoods_GoodsMain.ChildObjectId  AS GoodsMainId
         , Object_MainGoods.GoodsName                    AS GoodsMainName

         , ObjectLink_LinkGoods_Goods.ChildObjectId      AS GoodsId
         , Object_Goods.GoodsName                        AS GoodsName

         , Object_Goods.ObjectId                         AS ObjectId
         , Object_MainGoods.ObjectId                     AS ObjectMainId
         , Object_LinkGoods.isErased                     AS isErased
         
     FROM Object AS Object_LinkGoods
     
          JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                          ON ObjectLink_LinkGoods_GoodsMain.ObjectId = Object_LinkGoods.Id
                         AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
          JOIN Object_Goods_View AS Object_MainGoods ON Object_MainGoods.Id = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
 
          JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                          ON ObjectLink_LinkGoods_Goods.ObjectId = Object_LinkGoods.Id
                         AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
          JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = ObjectLink_LinkGoods_Goods.ChildObjectId
          
     WHERE Object_LinkGoods.DescId = zc_Object_LinkGoods();

ALTER TABLE Object_Goods_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 23.07.14                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Goods_View
