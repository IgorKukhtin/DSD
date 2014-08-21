-- View: Object_Goods_View                                                            	

DROP VIEW IF EXISTS Object_AdditionalGoods_View;

CREATE OR REPLACE VIEW Object_AdditionalGoods_View AS
         SELECT 
           Object_AdditionalGoods.Id                           AS Id
                                                        
         , ObjectLink_AdditionalGoods_GoodsMain.ChildObjectId  AS GoodsMainId
         , Object_MainGoods.ValueData                          AS GoodsMainName

         , ObjectLink_AdditionalGoods_Goods.ChildObjectId      AS GoodsId
         , Object_Goods.ValueData                              AS GoodsName

         , ObjectLink_AdditionalGoods_Retail.ChildObjectId     AS RetailId
         , Object_AdditionalGoods.isErased                     AS isErased
         
     FROM Object AS Object_AdditionalGoods
     
          JOIN ObjectLink AS ObjectLink_AdditionalGoods_GoodsMain
                          ON ObjectLink_AdditionalGoods_GoodsMain.ObjectId = Object_AdditionalGoods.Id
                         AND ObjectLink_AdditionalGoods_GoodsMain.DescId = zc_ObjectLink_AdditionalGoods_GoodsMain()
          JOIN Object AS Object_MainGoods ON Object_MainGoods.Id = ObjectLink_AdditionalGoods_GoodsMain.ChildObjectId
 
          JOIN ObjectLink AS ObjectLink_AdditionalGoods_Goods
                          ON ObjectLink_AdditionalGoods_Goods.ObjectId = Object_AdditionalGoods.Id
                         AND ObjectLink_AdditionalGoods_Goods.DescId = zc_ObjectLink_AdditionalGoods_Goods()
          JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_AdditionalGoods_Goods.ChildObjectId
          
          JOIN ObjectLink AS ObjectLink_AdditionalGoods_Retail
                          ON ObjectLink_AdditionalGoods_Retail.ObjectId = Object_AdditionalGoods.Id
                         AND ObjectLink_AdditionalGoods_Retail.DescId = zc_ObjectLink_AdditionalGoods_Retail()
           
     WHERE Object_AdditionalGoods.DescId = zc_Object_AdditionalGoods();

ALTER TABLE Object_Goods_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 23.07.14                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Goods_View
