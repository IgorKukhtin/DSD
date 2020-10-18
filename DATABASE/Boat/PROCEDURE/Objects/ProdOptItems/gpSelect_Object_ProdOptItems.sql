-- Function: gpSelect_Object_ProdOptItems()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptItems (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptItems(
    IN inIsShowAll   Boolean,       -- признак показать все (уникальные по всему справочнику)
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , NPP Integer
             , PriceIn TFloat, PriceOut TFloat
             , PartNumber TVarChar, Comment TVarChar
             , ProductId Integer, ProductName TVarChar
             , ProdOptionsId Integer, ProdOptionsName TVarChar
             , ProdOptPatternId Integer, ProdOptPatternName TVarChar
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
     -- получили все шаблоны
     tmpProdOptPattern AS (SELECT Object_ProdOptPattern.Id AS ProdOptPatternId
                           FROM Object AS Object_ProdOptPattern
                           WHERE Object_ProdOptPattern.DescId   = zc_Object_ProdOptPattern()
                             AND Object_ProdOptPattern.isErased = FALSE
                             AND inIsShowAll = TRUE
                          )
   , tmpRes_all AS (SELECT Object_ProdOptItems.Id           AS Id
                         , Object_ProdOptItems.ObjectCode   AS Code
                         , Object_ProdOptItems.ValueData    AS Name
                         , Object_ProdOptItems.isErased     AS isErased

                         , ObjectLink_Product.ChildObjectId        AS ProductId
                         , ObjectLink_ProdOptPattern.ChildObjectId AS ProdOptPatternId
                    FROM Object AS Object_ProdOptItems
                         LEFT JOIN ObjectLink AS ObjectLink_Product
                                              ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                                             AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdOptItems_Product()
                         LEFT JOIN ObjectLink AS ObjectLink_ProdOptPattern
                                              ON ObjectLink_ProdOptPattern.ObjectId = Object_ProdOptItems.Id
                                             AND ObjectLink_ProdOptPattern.DescId   = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                    WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                     AND (Object_ProdOptItems.isErased = FALSE OR inIsErased = TRUE)
                   )

       , tmpRes AS (SELECT tmpRes_all.Id
                         , tmpRes_all.Code
                         , tmpRes_all.Name
                         , tmpRes_all.isErased
                         , tmpRes_all.ProductId
                         , tmpRes_all.ProdOptPatternId
                     FROM tmpRes_all

                   UNION ALL
                    SELECT
                          0     :: Integer  AS Id
                        , 0     :: Integer  AS Code
                        , ''    :: TVarChar AS Name
                        , FALSE :: Boolean  AS isErased

                        , Object_Product.Id AS ProductId
                        , tmpProdOptPattern.ProdOptPatternId
                    FROM tmpProdOptPattern
                         JOIN Object AS Object_Product ON Object_Product.DescId   = zc_Object_Product()
                                                      AND Object_Product.isErased = FALSE
                         LEFT JOIN tmpRes_all ON tmpRes_all.ProductId        = Object_Product.Id
                                             AND tmpRes_all.ProdOptPatternId = tmpProdOptPattern.ProdOptPatternId
                    WHERE tmpRes_all.ProductId IS NULL
                   )
     SELECT
           Object_ProdOptItems.Id
         , Object_ProdOptItems.Code
         , Object_ProdOptItems.Name
         , ROW_NUMBER() OVER (PARTITION BY Object_Product.Id ORDER BY Object_ProdOptPattern.ObjectCode ASC, Object_ProdOptPattern.Id ASC) :: Integer AS NPP

         , ObjectFloat_PriceIn.ValueData      ::TFloat    AS PriceIn
         , ObjectFloat_PriceOut.ValueData     ::TFloat    AS PriceOut
         , ObjectString_PartNumber.ValueData  ::TVarChar  AS PartNumber
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Product.Id                  ::Integer   AS ProductId
         , Object_Product.ValueData           ::TVarChar  AS ProductName

         , Object_ProdOptions.Id            AS ProdOptionsId
         , Object_ProdOptions.ValueData     AS ProdOptionsName

         , Object_ProdOptPattern.Id           ::Integer  AS ProdOptPatternId
         , Object_ProdOptPattern.ValueData    ::TVarChar AS ProdOptPatternName

         , CASE WHEN CEIL (Object_ProdOptItems.Code / 2) * 2 <> Object_ProdOptItems.Code
                     THEN zc_Color_Aqua()
                ELSE
                    -- нет цвета
                    zc_Color_White()
           END :: Integer AS Color_fon

         , Object_Insert.ValueData            ::TVarChar  AS InsertName
         , ObjectDate_Insert.ValueData        ::TDateTime AS InsertDate
         , Object_ProdOptItems.isErased       ::Boolean   AS isErased

     FROM tmpRes AS Object_ProdOptItems
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

          LEFT JOIN Object AS Object_Product        ON Object_Product.Id        = Object_ProdOptItems.ProductId
          LEFT JOIN Object AS Object_ProdOptPattern ON Object_ProdOptPattern.Id = Object_ProdOptItems.ProdOptPatternId

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
-- SELECT * FROM gpSelect_Object_ProdOptItems (true, true, zfCalc_UserAdmin())
