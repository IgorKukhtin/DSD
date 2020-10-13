-- Function: gpSelect_Object_ProdOptItems()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptItems (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptItems(
    IN inIsShowAll   Boolean,       -- признак показать все (уникальные по всему справочнику)
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PriceIn TFloat, PriceOut TFloat
             , PartNumber TVarChar, Comment TVarChar
             , ProductId Integer, ProductName TVarChar
             , ProdOptionsId Integer, ProdOptionsName TVarChar
             , Color_fon Integer
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptItems());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH
     tmpProdOptItemsAll AS 
               (SELECT DISTINCT 
                       Object_ProdOptItems.ValueData     AS Name
            
                     , ObjectFloat_PriceIn.ValueData     AS PriceIn
                     , ObjectFloat_PriceOut.ValueData    AS PriceOut
                     , ObjectString_PartNumber.ValueData AS PartNumber
            
                     , Object_ProdOptions.Id            AS ProdOptionsId
                     , Object_ProdOptions.ValueData     AS ProdOptionsName
                     
                     , Object_ProdOptItems.isErased     AS isErased
                FROM Object AS Object_ProdOptItems
                     LEFT JOIN ObjectString AS ObjectString_PartNumber
                                            ON ObjectString_PartNumber.ObjectId = Object_ProdOptItems.Id
                                           AND ObjectString_PartNumber.DescId = zc_ObjectString_ProdOptItems_PartNumber()

                     LEFT JOIN ObjectFloat AS ObjectFloat_PriceIn
                                           ON ObjectFloat_PriceIn.ObjectId = Object_ProdOptItems.Id
                                          AND ObjectFloat_PriceIn.DescId = zc_ObjectFloat_ProdOptItems_PriceIn()

                     LEFT JOIN ObjectFloat AS ObjectFloat_PriceOut
                                           ON ObjectFloat_PriceOut.ObjectId = Object_ProdOptItems.Id
                                          AND ObjectFloat_PriceOut.DescId = zc_ObjectFloat_ProdOptItems_PriceOut()

                     LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                                          ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                                         AND ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdOptItems_ProdOptions()
                     LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId 

                WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                AND (Object_ProdOptItems.isErased = FALSE OR inIsErased = TRUE)
                AND inIsShowAll = TRUE
                )
   , tmpAll AS (SELECT Object_Product.Id AS ProductId
                FROM Object AS Object_Product
                     LEFT JOIN tmpProdOptItemsAll ON 1=1
                WHERE Object_Product.DescId = zc_Object_Product()
                 AND (Object_Product.isErased = FALSE OR inIsErased = TRUE)
               )

     SELECT 
           Object_ProdOptItems.Id         AS Id 
         , Object_ProdOptItems.ObjectCode AS Code
         , Object_ProdOptItems.ValueData  AS Name

         , ObjectFloat_PriceIn.ValueData     AS PriceIn
         , ObjectFloat_PriceOut.ValueData    AS PriceOut
         , ObjectString_PartNumber.ValueData AS PartNumber
         , ObjectString_Comment.ValueData    AS Comment

         , Object_Product.Id                AS ProductId
         , Object_Product.ValueData         AS ProductName

         , Object_ProdOptions.Id            AS ProdOptionsId
         , Object_ProdOptions.ValueData     AS ProdOptionsName
         
         , CASE WHEN CEIL (Object_ProdOptItems.ObjectCode / 2) * 2 <> Object_ProdOptItems.ObjectCode
                     THEN zc_Color_Aqua()
                ELSE
                    -- нет цвета
                    zc_Color_White()
           END :: Integer AS Color_fon

         , Object_Insert.ValueData          AS InsertName
         , ObjectDate_Insert.ValueData      AS InsertDate
         , Object_ProdOptItems.isErased   AS isErased
         
     FROM Object AS Object_ProdOptItems
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdOptItems.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptItems_Comment()  
          LEFT JOIN ObjectString AS ObjectString_PartNumber
                                 ON ObjectString_PartNumber.ObjectId = Object_ProdOptItems.Id
                                AND ObjectString_PartNumber.DescId = zc_ObjectString_ProdOptItems_PartNumber()

          LEFT JOIN ObjectFloat AS ObjectFloat_PriceIn
                                ON ObjectFloat_PriceIn.ObjectId = Object_ProdOptItems.Id
                               AND ObjectFloat_PriceIn.DescId = zc_ObjectFloat_ProdOptItems_PriceIn()
          LEFT JOIN ObjectFloat AS ObjectFloat_PriceOut
                                ON ObjectFloat_PriceOut.ObjectId = Object_ProdOptItems.Id
                               AND ObjectFloat_PriceOut.DescId = zc_ObjectFloat_ProdOptItems_PriceOut()

          LEFT JOIN ObjectLink AS ObjectLink_Product
                               ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_Product.DescId = zc_ObjectLink_ProdOptItems_Product()
          LEFT JOIN Object AS Object_Product ON Object_Product.Id = ObjectLink_Product.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                               ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdOptItems_ProdOptions()
          LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdOptItems.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

     WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
      AND (Object_ProdOptItems.isErased = FALSE OR inIsErased = TRUE)
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
-- SELECT * FROM gpSelect_Object_ProdOptItems (false, false, zfCalc_UserAdmin())
