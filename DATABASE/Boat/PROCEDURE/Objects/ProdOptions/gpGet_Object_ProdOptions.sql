-- Function: gpGet_Object_ProdOptions()

DROP FUNCTION IF EXISTS gpGet_Object_ProdOptions(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdOptions(
    IN inId          Integer,       -- Названия Опций
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ModelId Integer, ModelName TVarChar
             , BrandId Integer, BrandName TVarChar
             , ProdEngineId Integer, ProdEngineName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , SalePrice TFloat
             , Comment TVarChar
             ) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ProdOptions());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)      AS Id
           , lfGet_ObjectCode (0, zc_Object_ProdOptions()) AS Code
           , CAST ('' as TVarChar)    AS NAME

           , 0  :: Integer            AS ModelId
           , '' :: TVarChar           AS ModelName
           , CAST (0  AS Integer)     AS BrandId
           , CAST ('' AS TVarChar)    AS BrandName
           , CAST (0  AS Integer)     AS ProdEngineId
           , CAST ('' AS TVarChar)    AS ProdEngineName
           , 0  :: Integer            AS GoodsId
           , '' :: TVarChar           AS GoodsName

           , Object_TaxKind.Id        AS TaxKindId
           , Object_TaxKind.ValueData AS TaxKindName

           , CAST (0 AS TFloat)       AS SalePrice
           , CAST ('' AS TVarChar)    AS Comment
       FROM Object AS Object_TaxKind
       WHERE Object_TaxKind.Id = zc_Enum_TaxKind_Basis()
      ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_ProdOptions.Id              AS Id 
         , Object_ProdOptions.ObjectCode      AS Code
         , Object_ProdOptions.ValueData       AS Name

         , Object_Model.Id         ::Integer  AS ModelId
         , Object_Model.ValueData  ::TVarChar AS ModelName
         , Object_Brand.Id                    AS BrandId
         , Object_Brand.ValueData             AS BrandName
         , Object_ProdEngine.Id               AS ProdEngineId
         , Object_ProdEngine.ValueData        AS ProdEngineName

         , Object_Goods.Id         ::Integer  AS GoodsId
         , Object_Goods.ValueData  ::TVarChar AS GoodsName

         , Object_TaxKind.Id                  AS TaxKindId
         , Object_TaxKind.ValueData           AS TaxKindName


         , ObjectFloat_SalePrice.ValueData    AS SalePrice
         , ObjectString_Comment.ValueData     AS Comment
        
     FROM Object AS Object_ProdOptions
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdOptions.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptions_Comment()  

          LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                ON ObjectFloat_SalePrice.ObjectId = Object_ProdOptions.Id
                               AND ObjectFloat_SalePrice.DescId = zc_ObjectFloat_ProdOptions_SalePrice()

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdOptions_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_Model.DescId = zc_ObjectLink_ProdOptions_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                               ON ObjectLink_TaxKind.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_TaxKind.DescId = zc_ObjectLink_ProdOptions_TaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_Model.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdEngine
                               ON ObjectLink_ProdEngine.ObjectId = Object_Model.Id
                              AND ObjectLink_ProdEngine.DescId = zc_ObjectLink_ProdModel_ProdEngine()
          LEFT JOIN Object AS Object_ProdEngine ON Object_ProdEngine.Id = ObjectLink_ProdEngine.ChildObjectId
       WHERE Object_ProdOptions.Id = inId;
   END IF;
   
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.12.20         *
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ProdOptions (0, zfCalc_UserAdmin())
