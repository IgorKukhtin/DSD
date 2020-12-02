-- Function: gpSelect_Object_ProdColorPattern()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorPattern (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColorPattern(
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , NPP Integer
             , Comment TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdColorPattern());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY

     SELECT 
           Object_ProdColorPattern.Id         AS Id 
         , Object_ProdColorPattern.ObjectCode AS Code
         , Object_ProdColorPattern.ValueData  AS Name
         , ROW_NUMBER() OVER (PARTITION BY Object_ProdColorGroup.Id ORDER BY Object_ProdColorGroup.ObjectCode ASC, Object_ProdColorPattern.ObjectCode ASC) :: Integer AS NPP


         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
         , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName
         , Object_Goods.Id                    ::Integer  AS GoodsId
         , Object_Goods.ValueData             ::TVarChar AS GoodsName

         , Object_Insert.ValueData            AS InsertName
         , ObjectDate_Insert.ValueData        AS InsertDate
         , Object_ProdColorPattern.isErased   AS isErased
         
     FROM Object AS Object_ProdColorPattern
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

     WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
      AND (Object_ProdColorPattern.isErased = FALSE OR inIsErased = TRUE)
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.20         * zc_ObjectLink_ProdColorPattern_Goods
 15.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdColorPattern (false,false, zfCalc_UserAdmin())
