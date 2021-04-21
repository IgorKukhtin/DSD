-- Function: gpSelect_Object_ProductDocument(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ProductDocument(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProductDocument(
    IN inProductId      Integer, 
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , FileName TVarChar
             , DocTagId Integer, DocTagName TVarChar
             , Comment TVarChar
             ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProductCondition());

   RETURN QUERY 
     SELECT Object_ProductDocument.Id        AS Id
          , Object_ProductDocument.ValueData AS FileName
          , Object_DocTag.Id               AS DocTagId
          , Object_DocTag.ValueData        AS DocTagName
          , ObjectString_Comment.ValueData AS Comment
     FROM Object AS Object_ProductDocument
          JOIN ObjectLink AS ObjectLink_ProductDocument_Product
                          ON ObjectLink_ProductDocument_Product.ObjectId = Object_ProductDocument.Id
                         AND ObjectLink_ProductDocument_Product.DescId = zc_ObjectLink_ProductDocument_Product()
                         AND ObjectLink_ProductDocument_Product.ChildObjectId = inProductId
           
          LEFT JOIN ObjectLink AS ObjectLink_DocTag
                               ON ObjectLink_DocTag.ObjectId = Object_ProductDocument.Id
                              AND ObjectLink_DocTag.DescId = zc_ObjectLink_ProductDocument_DocTag()
          LEFT JOIN Object AS Object_DocTag ON Object_DocTag.Id = ObjectLink_DocTag.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProductDocument.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProductDocument_Comment()  
     WHERE Object_ProductDocument.DescId = zc_Object_ProductDocument(); 
          
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProductDocument (0,'2')