-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Juridical(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Juridical(
    IN inObjectId    INTEGER , 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer, GoodsMainCode Integer, GoodsMainName TVarChar
             , GoodsId Integer, GoodsCodeInt Integer, GoodsCode TVarChar, GoodsName TVarChar
             , MakerName TVarChar, MinimumLot TFloat

) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());


      RETURN QUERY 
      SELECT 
           ObjectLink_LinkGoods_GoodsMain.ObjectId AS Id
         , MainGoods.Id AS GoodsMainId
         , MainGoods.ObjectCode AS GoodsMainCode
         , MainGoods.ValueData AS GoodsMainName
         , Object_Goods_View.Id AS GoodsId
         , Object_Goods_View.GoodsCodeInt
         , Object_Goods_View.GoodsCode
         , Object_Goods_View.GoodsName
         , Object_Goods_View.MakerName
         , Object_Goods_View.MinimumLot

   FROM Object_Goods_View 
     LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                          ON ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                         AND ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods_View.Id 

     LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain 
                          ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId 
                         AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
     
     LEFT JOIN OBJECT AS MainGoods ON MainGoods.Id = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                         
   WHERE Object_Goods_View.ObjectId = inObjectId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods_Juridical(Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.14                         *
 22.10.14                         *
 24.06.14         *
 20.06.13                         *

*/

-- тест
 --SELECT * FROM gpSelect_Object_Goods('2')


