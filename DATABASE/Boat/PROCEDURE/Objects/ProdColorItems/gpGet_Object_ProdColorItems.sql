-- Function: gpGet_Object_ProdColorItems()

DROP FUNCTION IF EXISTS gpGet_Object_ProdColorItems (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdColorItems(
    IN inId          Integer ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , ProductId Integer, ProductName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdColorItems());
   vbUserId:= lpGetUserBySession (inSession);

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_Brand())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Comment
           ,  0 :: Integer            AS ProductId
           , '' :: TVarChar           AS ProductName
           ,  0 :: Integer            AS GoodsId
           , '' :: TVarChar           AS GoodsName
           ,  0 :: Integer            AS ProdColorPatternId
           , '' :: TVarChar           AS ProdColorPatternName
       ;
   ELSE
     RETURN QUERY
     SELECT 
           Object_ProdColorItems.Id         AS Id 
         , ROW_NUMBER() OVER (PARTITION BY Object_Product.Id ORDER BY Object_Goods.ObjectCode ASC, Object_ProdColorItems.ObjectCode ASC) :: Integer AS Code
         , Object_ProdColorItems.ValueData  AS Name

         , ObjectString_Comment.ValueData     ::TVarChar AS Comment

         , Object_Product.Id                  ::Integer  AS ProductId
         , Object_Product.ValueData           ::TVarChar AS ProductName

         , Object_Goods.Id           ::Integer  AS GoodsId
         , Object_Goods.ValueData    ::TVarChar AS GoodsName

         , Object_ProdColorPattern.Id         ::Integer  AS ProdColorPatternId
         , Object_ProdColorPattern.ValueData  ::TVarChar AS ProdColorPatternName
     FROM Object AS Object_ProdColorItems
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorItems_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_Product
                               ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                              AND ObjectLink_Product.DescId = zc_ObjectLink_ProdColorItems_Product()
          LEFT JOIN Object AS Object_Product ON Object_Product.Id = ObjectLink_Product.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorItems_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                               ON ObjectLink_ProdColor.ObjectId = Object_ProdColorItems.Id
                              AND ObjectLink_ProdColor.DescId = zc_ObjectLink_ProdColorItems_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                               ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                              AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ProdColorItems_ProdColorPattern()
          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId 

     WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
      AND Object_ProdColorItems.Id = inId
     ;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.10.20         *
*/

-- тест
--SELECT * FROM gpGet_Object_ProdColorItems (0, zfCalc_UserAdmin())