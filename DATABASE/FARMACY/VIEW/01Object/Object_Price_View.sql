-- View: Object_Goods_View                                                            	

DROP VIEW IF EXISTS Object_Price_View;

CREATE OR REPLACE VIEW Object_Price_View AS
         SELECT 
           ObjectLink_LinkGoods_GoodsMain.ObjectId       AS Id
                                                        
         , ObjectLink_LinkGoods_GoodsMain.ChildObjectId  AS GoodsMainId
         , Object_MainGoods.ObjectCode                   AS GoodsMainCode
         , Object_MainGoods.ValueData                    AS GoodsMainName

         , ObjectLink_LinkGoods_Goods.ChildObjectId      AS GoodsId
         , Object_Goods.GoodsCodeInt                     AS GoodsCodeInt
         , Object_Goods.GoodsCode                        AS GoodsCode
         , Object_Goods.GoodsName                        AS GoodsName
         , Object_Goods.MakerName                        AS MakerName

         , Object_Goods.ObjectId                         AS ObjectId
         , false                                         AS isErased
         
     FROM ObjectLink AS ObjectLink_LinkGoods_GoodsMain
          LEFT JOIN Object AS Object_MainGoods ON Object_MainGoods.Id = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
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
