-- Function: gpSelect_Object_AlternativeGoodsCode(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_AlternativeGoodsCode(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AlternativeGoodsCode(
    IN inRetailId    Integer,       -- Торговая сеть
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer             
             , GoodsId Integer, GoodsCodeInt Integer, GoodsCode TVarChar, GoodsName TVarChar    
             ) AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AlternativeGoodsCode());

   RETURN QUERY 
     SELECT 
           Object_AlternativeGoodsCode.Id        AS Id
                                                        
         , ObjectLink_AlternativeGoodsCode_GoodsMain.ChildObjectId  AS GoodsMainId

         , Object_Goods.Id            AS GoodsId
         , Object_Goods.ValueData     AS GoodsName

         , Object_AlternativeGoodsCode.isErased  AS isErased
         
     FROM Object AS Object_AlternativeGoodsCode
     
          JOIN ObjectLink AS ObjectLink_AlternativeGoodsCode_GoodsMain
                          ON ObjectLink_AlternativeGoodsCode_GoodsMain.ObjectId = Object_AlternativeGoodsCode.Id
                         AND ObjectLink_AlternativeGoodsCode_GoodsMain.DescId = zc_ObjectLink_AlternativeGoodsCode_GoodsMain()
 
          JOIN ObjectLink AS ObjectLink_AlternativeGoodsCode_Goods
                          ON ObjectLink_AlternativeGoodsCode_Goods.ObjectId = Object_AlternativeGoodsCode.Id
                         AND ObjectLink_AlternativeGoodsCode_Goods.DescId = zc_ObjectLink_AlternativeGoodsCode_Goods()
          JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_AlternativeGoodsCode_Goods.ChildObjectId
          
          JOIN ObjectLink AS ObjectLink_AlternativeGoodsCode_Retail
                          ON ObjectLink_AlternativeGoodsCode_Retail.ObjectId = Object_AlternativeGoodsCode.Id
                         AND ObjectLink_AlternativeGoodsCode_Retail.DescId = zc_ObjectLink_AlternativeGoodsCode_Retail()
           
     WHERE Object_AlternativeGoodsCode.DescId = zc_Object_AlternativeGoodsCode()
       AND ObjectLink_AlternativeGoodsCode_Retail.ChildObjectId = inRetailId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AlternativeGoodsCode (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.08.14                        *
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_AlternativeGoodsCode ('2')
