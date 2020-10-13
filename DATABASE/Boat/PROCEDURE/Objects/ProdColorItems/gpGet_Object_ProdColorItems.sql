-- Function: gpGet_Object_ProdColorItems()

DROP FUNCTION IF EXISTS gpGet_Object_ProdColorItems (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdColorItems(
    IN inId          Integer ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , ProductId Integer, ProductName TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
             , ProdColorId Integer, ProdColorName TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdColorItems());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY

     SELECT 
           Object_ProdColorItems.Id         AS Id 
         , ROW_NUMBER() OVER (PARTITION BY Object_Product.Id ORDER BY Object_ProdColorGroup.ObjectCode ASC, Object_ProdColorItems.ObjectCode ASC) :: Integer AS Code
         , Object_ProdColorItems.ValueData  AS Name

         , ObjectString_Comment.ValueData     ::TVarChar AS Comment

         , Object_Product.Id                  ::Integer  AS ProductId
         , Object_Product.ValueData           ::TVarChar AS ProductName

         , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
         , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName

         , Object_ProdColor.Id                ::Integer  AS ProdColorId
         , Object_ProdColor.ValueData         ::TVarChar AS ProdColorName
         
     FROM Object AS Object_ProdColorItems
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorItems_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_Product
                               ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                              AND ObjectLink_Product.DescId = zc_ObjectLink_ProdColorItems_Product()
          LEFT JOIN Object AS Object_Product ON Object_Product.Id = ObjectLink_Product.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorItems.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorItems_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                               ON ObjectLink_ProdColor.ObjectId = Object_ProdColorItems.Id
                              AND ObjectLink_ProdColor.DescId = zc_ObjectLink_ProdColorItems_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId 

     WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
      AND Object_ProdColorItems.Id = inId
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdColorItems (false,false, zfCalc_UserAdmin())
