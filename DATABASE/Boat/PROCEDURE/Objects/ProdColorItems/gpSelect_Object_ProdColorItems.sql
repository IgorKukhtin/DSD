-- Function: gpSelect_Object_ProdColorItems()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorItems (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorItems (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColorItems(
    IN inIsShowAll   Boolean,            -- признак показать все (уникальные по всему справочнику)
    IN inIsErased    Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , ProductId Integer, ProductName TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
             , ProdColorId Integer, ProdColorName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdColorItems());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY

     WITH
     tmpProdColorItemsAll AS (SELECT DISTINCT 
                                     Object_ProdColorGroup.Id         AS ProdColorGroupId
                                   , Object_ProdColorGroup.ValueData  AS ProdColorGroupName
                                   , Object_ProdColor.Id              AS ProdColorId
                                   , Object_ProdColor.ValueData       AS ProdColorName
                              FROM Object AS Object_ProdColorItems
                                   LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                        ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorItems.Id
                                                       AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                   LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId 

                                   LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                                        ON ObjectLink_ProdColor.ObjectId = Object_ProdColorItems.Id
                                                       AND ObjectLink_ProdColor.DescId = zc_ObjectLink_ProdColorItems_ProdColor()
                                   LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId 
                              WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
                              AND (Object_ProdColorItems.isErased = FALSE OR inIsErased = TRUE)
                              AND inIsShowAll = TRUE
                              )
   , tmpAll AS (SELECT Object_Product.Id AS ProductId
                     , Object_Product.ValueData AS ProductName
                     , tmpProdColorItemsAll.ProdColorGroupId
                     , tmpProdColorItemsAll.ProdColorGroupName
                     , tmpProdColorItemsAll.ProdColorId
                     , tmpProdColorItemsAll.ProdColorName
                FROM Object AS Object_Product
                     LEFT JOIN tmpProdColorItemsAll ON 1=1
                WHERE Object_Product.DescId = zc_Object_Product()
                 AND (Object_Product.isErased = FALSE OR inIsErased = TRUE)
                 AND inIsShowAll = TRUE
               )

     SELECT 
           Object_ProdColorItems.Id         AS Id 
       --, Object_ProdColorItems.ObjectCode AS Code
         , ROW_NUMBER() OVER (PARTITION BY Object_Product.Id ORDER BY Object_ProdColorGroup.ObjectCode ASC, Object_ProdColorItems.ObjectCode ASC) :: Integer AS Code
         , Object_ProdColorItems.ValueData  AS Name


         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Product.Id                  ::Integer   AS ProductId
         , Object_Product.ValueData           ::TVarChar  AS ProductName

         , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
         , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName

         , Object_ProdColor.Id                ::Integer  AS ProdColorId
         , Object_ProdColor.ValueData         ::TVarChar AS ProdColorName

         , Object_Insert.ValueData            ::TVarChar  AS InsertName
         , ObjectDate_Insert.ValueData        ::TDateTime AS InsertDate
         , Object_ProdColorItems.isErased     ::Boolean   AS isErased
         
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

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdColorItems.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdColorItems.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

     WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
      AND (Object_ProdColorItems.isErased = FALSE OR inIsErased = TRUE) 

   UNION all
     SELECT 0                         ::Integer   AS Id 
          , 0                         ::Integer   AS Code
          , ''                        ::TVarChar  AS Name
          , ''                        ::TVarChar  AS Comment
          , tmpAll.ProductId          ::Integer   AS ProductId
          , tmpAll.ProductName        ::TVarChar  AS ProductName
          , tmpAll.ProdColorGroupId   ::Integer   AS ProdColorGroupId
          , tmpAll.ProdColorGroupName ::TVarChar  AS ProdColorGroupName
          , tmpAll.ProdColorId        ::Integer   AS ProdColorId
          , tmpAll.ProdColorName      ::TVarChar  AS ProdColorName
          , ''                        ::TVarChar  AS InsertName
          , NULL                      ::TDateTime AS InsertDate
          , FALSE                     ::Boolean   AS isErased
        FROM tmpAll
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
