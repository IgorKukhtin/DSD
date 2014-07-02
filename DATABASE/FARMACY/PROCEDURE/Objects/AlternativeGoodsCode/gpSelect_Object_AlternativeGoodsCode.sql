-- Function: gpSelect_Object_AlternativeGoodsCode(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_AlternativeGoodsCode(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AlternativeGoodsCode(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer, GoodsMainName TVarChar                
             , GoodsId Integer, GoodsName TVarChar    
             , RetailId Integer, RetailName TVarChar 
             , isErased boolean
             ) AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AlternativeGoodsCode());

   RETURN QUERY 
     SELECT 
           Object_AlternativeGoodsCode.Id        AS Id
                                                        
         , Object_GoodsMain.Id        AS GoodsMainId
         , Object_GoodsMain.ValueData AS GoodsMainName

         , Object_Goods.Id            AS GoodsId
         , Object_Goods.ValueData     AS GoodsName

         , Object_Retail.Id           AS RetailId
         , Object_Retail.ValueData    AS RetailName
         
         , Object_AlternativeGoodsCode.isErased  AS isErased
         
     FROM Object AS Object_AlternativeGoodsCode
     
          LEFT JOIN ObjectLink AS ObjectLink_AlternativeGoodsCode_GoodsMain
                               ON ObjectLink_AlternativeGoodsCode_GoodsMain.ObjectId = Object_AlternativeGoodsCode.Id
                              AND ObjectLink_AlternativeGoodsCode_GoodsMain.DescId = zc_ObjectLink_AlternativeGoodsCode_GoodsMain()
          LEFT JOIN Object AS Object_GoodsMain ON Object_GoodsMain.Id = ObjectLink_AlternativeGoodsCode_GoodsMain.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_AlternativeGoodsCode_Goods
                               ON ObjectLink_AlternativeGoodsCode_Goods.ObjectId = Object_AlternativeGoodsCode.Id
                              AND ObjectLink_AlternativeGoodsCode_Goods.DescId = zc_ObjectLink_AlternativeGoodsCode_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_AlternativeGoodsCode_Goods.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_AlternativeGoodsCode_Retail
                               ON ObjectLink_AlternativeGoodsCode_Retail.ObjectId = Object_AlternativeGoodsCode.Id
                              AND ObjectLink_AlternativeGoodsCode_Retail.DescId = zc_ObjectLink_AlternativeGoodsCode_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_AlternativeGoodsCode_Retail.ChildObjectId
           
     WHERE Object_AlternativeGoodsCode.DescId = zc_Object_AlternativeGoodsCode()
       AND Object_AlternativeGoodsCode.isErased = FALSE
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AlternativeGoodsCode (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_AlternativeGoodsCode ('2')
