 -- Function: gpSelect_Object_ProdColorItems()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorItems (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorItems (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColorItems(
    IN inIsShowAll   Boolean,       -- признак показать все (уникальные по всему справочнику)
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , NPP Integer
             , Comment TVarChar
             , ProductId Integer, ProductName TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
             , ProdColorId Integer, ProdColorName TVarChar
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
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
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdColorItems());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY

     WITH
<<<<<<< HEAD
     -- получили все шаблоны
     tmpProdColorPattern AS (SELECT Object_ProdColorPattern.Id               AS ProdColorPatternId
                                  , ObjectLink_ProdColorGroup.ChildObjectId  AS ProdColorGroupId
                             FROM Object AS Object_ProdColorPattern
                                  INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                        ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                                       AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                             WHERE Object_ProdColorPattern.DescId   = zc_Object_ProdColorPattern()
                               AND Object_ProdColorPattern.isErased = FALSE
                               AND inIsShowAll = TRUE
                            )
     --
   , tmpRes_all AS (SELECT Object_ProdColorItems.Id         AS Id
                         , Object_ProdColorItems.ObjectCode AS Code
                         , Object_ProdColorItems.ValueData  AS Name
                         , Object_ProdColorItems.isErased   AS isErased

                         , ObjectLink_Product.ChildObjectId          AS ProductId
                         , ObjectLink_ProdColorGroup.ChildObjectId   AS ProdColorGroupId
                         , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId

                    FROM Object AS Object_ProdColorItems
                         LEFT JOIN ObjectLink AS ObjectLink_Product
                                              ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdColorItems_Product()

                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                              ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorItems_ProdColorGroup()

                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                              ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                             AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()

                    WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
                     AND (Object_ProdColorItems.isErased = FALSE OR inIsErased = TRUE)
                   )
       , tmpRes AS (SELECT tmpRes_all.Id
                         , tmpRes_all.Code
                         , tmpRes_all.Name
                         , tmpRes_all.isErased
                         , tmpRes_all.ProductId
                         , tmpRes_all.ProdColorGroupId
                         , tmpRes_all.ProdColorPatternId
                     FROM tmpRes_all

                   UNION ALL
                    SELECT
                          0     :: Integer  AS Id
                        , 0     :: Integer  AS Code
                        , ''    :: TVarChar AS Name
                        , FALSE :: Boolean  AS isErased

                        , Object_Product.Id AS ProductId
                        , tmpProdColorPattern.ProdColorGroupId
                        , tmpProdColorPattern.ProdColorPatternId
                    FROM tmpProdColorPattern
                         JOIN Object AS Object_Product ON Object_Product.DescId   = zc_Object_Product()
                                                      AND Object_Product.isErased = FALSE
                         LEFT JOIN tmpRes_all ON tmpRes_all.ProductId          = Object_Product.Id
                                             AND tmpRes_all.ProdColorGroupId   = tmpProdColorPattern.ProdColorGroupId
                                             AND tmpRes_all.ProdColorPatternId = tmpProdColorPattern.ProdColorPatternId
                    WHERE tmpRes_all.ProductId IS NULL
                   )
     -- Результат
     SELECT
           Object_ProdColorItems.Id    AS Id
         , Object_ProdColorItems.Code  AS Code
         , Object_ProdColorItems.Name  AS Name
         , ROW_NUMBER() OVER (PARTITION BY Object_Product.Id ORDER BY Object_ProdColorGroup.ObjectCode ASC, Object_ProdColorPattern.ObjectCode ASC, Object_ProdColorPattern.Id ASC) :: Integer AS NPP

         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Product.Id                  ::Integer   AS ProductId
         , Object_Product.ValueData           ::TVarChar  AS ProductName

         , Object_ProdColorGroup.Id           ::Integer   AS ProdColorGroupId
         , Object_ProdColorGroup.ValueData    ::TVarChar  AS ProdColorGroupName

         , Object_ProdColor.Id                ::Integer   AS ProdColorId
         , Object_ProdColor.ValueData         ::TVarChar  AS ProdColorName

         , Object_ProdColorPattern.Id         ::Integer   AS ProdColorPatternId
         , Object_ProdColorPattern.ValueData  ::TVarChar  AS ProdColorPatternName

         , CASE WHEN CEIL (Object_ProdColorGroup.ObjectCode / 2) * 2 <> Object_ProdColorGroup.ObjectCode
                     THEN zc_Color_Yelow() -- zc_Color_Lime() -- zc_Color_Aqua()
                ELSE
                    -- нет цвета
                    zc_Color_White()
           END :: Integer AS Color_fon

         , Object_Insert.ValueData          AS InsertName
         , ObjectDate_Insert.ValueData      AS InsertDate
         , Object_ProdColorItems.isErased   AS isErased

     FROM tmpRes AS Object_ProdColorItems
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorItems_Comment()

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

          LEFT JOIN Object AS Object_Product          ON Object_Product.Id          = Object_ProdColorItems.ProductId
          LEFT JOIN Object AS Object_ProdColorGroup   ON Object_ProdColorGroup.Id   = Object_ProdColorItems.ProdColorGroupId
          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = Object_ProdColorItems.ProdColorPatternId
=======
     tmpProdColorPatternAll AS (SELECT DISTINCT
                                       Object_ProdColorPattern.Id         AS Id 
                                     , Object_ProdColorPattern.ObjectCode AS Code
                                     , Object_ProdColorPattern.ValueData  AS Name
                                     , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
                                     , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName
                                     , Object_ProdColorPattern.isErased   AS isErased
                                FROM Object AS Object_ProdColorPattern
                                     LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                          ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                                         AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                     LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId 
                                WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
                                 AND (Object_ProdColorPattern.isErased = FALSE OR inIsErased = TRUE) 
                                 AND inIsShowAll = TRUE
                               )

   , tmpAll AS (SELECT Object_Product.Id             AS ProductId
                     , Object_Product.ValueData      AS ProductName
                     , tmpProdColorPatternAll.ProdColorGroupId
                     , tmpProdColorPatternAll.ProdColorGroupName
                     , tmpProdColorPatternAll.Id     AS ProdColorPatternId
                     , tmpProdColorPatternAll.Name   AS ProdColorPatternName
                     , CASE WHEN Object_Product.isErased = TRUE OR tmpProdColorPatternAll.isErased = TRUE THEN TRUE ELSE FALSE END AS isErased
                FROM tmpProdColorPatternAll
                     LEFT JOIN Object AS Object_Product ON Object_Product.DescId = zc_Object_Product()
                WHERE (Object_Product.isErased = FALSE OR inIsErased = TRUE)
                  AND inIsShowAll = TRUE
               )

   , tmpProdColorItems AS (SELECT Object_ProdColorItems.Id         AS Id 
                                , Object_ProdColorItems.ObjectCode AS Code
                                , Object_ProdColorItems.ValueData  AS Name
                                , ROW_NUMBER() OVER (PARTITION BY Object_Product.Id ORDER BY Object_ProdColorGroup.ObjectCode ASC, Object_ProdColorItems.ObjectCode ASC) :: Integer AS NPP
                                , ObjectString_Comment.ValueData     ::TVarChar  AS Comment
                                , Object_Product.Id                  ::Integer   AS ProductId
                                , Object_Product.ValueData           ::TVarChar  AS ProductName
                                , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
                                , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName
                                , Object_ProdColor.Id                ::Integer  AS ProdColorId
                                , Object_ProdColor.ValueData         ::TVarChar AS ProdColorName
                                , Object_ProdColorPattern.Id         ::Integer  AS ProdColorPatternId
                                , Object_ProdColorPattern.ValueData  ::TVarChar AS ProdColorPatternName
                                , CASE WHEN CEIL (Object_ProdColorGroup.ObjectCode / 2) * 2 <> Object_ProdColorGroup.ObjectCode
                                            THEN zc_Color_Yelow() -- zc_Color_Lime() -- zc_Color_Aqua()
                                       ELSE
                                           -- нет цвета
                                           zc_Color_White()
                                  END :: Integer AS Color_fon
                                , Object_Insert.ValueData          AS InsertName
                                , ObjectDate_Insert.ValueData      AS InsertDate
                                , Object_ProdColorItems.isErased   AS isErased
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

                                 LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                      ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                                     AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                 LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId 

                                 LEFT JOIN ObjectLink AS ObjectLink_Insert
                                                      ON ObjectLink_Insert.ObjectId = Object_ProdColorItems.Id
                                                     AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                                 LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

                                 LEFT JOIN ObjectDate AS ObjectDate_Insert
                                                      ON ObjectDate_Insert.ObjectId = Object_ProdColorItems.Id
                                                     AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

                            WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
                             AND (Object_ProdColorItems.isErased = FALSE OR inIsErased = TRUE)
                            )

     SELECT tmpProdColorItems.*         
     FROM tmpProdColorItems
   UNION all
     SELECT 0                           ::Integer   AS Id 
          , 0                           ::Integer   AS Code
          , 'DELETE'                    ::TVarChar  AS Name
          , 0                           :: Integer  AS NPP
          , ''                          ::TVarChar  AS Comment
          , tmpAll.ProductId            ::Integer   AS ProductId
          , tmpAll.ProductName          ::TVarChar  AS ProductName
          , tmpAll.ProdColorGroupId     ::Integer   AS ProdColorGroupId
          , tmpAll.ProdColorGroupName   ::TVarChar  AS ProdColorGroupName
          , 0                           ::Integer   AS ProdColorId
          , ''                          ::TVarChar  AS ProdColorName
          , tmpAll.ProdColorPatternId   ::Integer   AS ProdColorPatternId
          , tmpAll.ProdColorPatternName ::TVarChar  AS ProdColorPatternName
            -- нет цвета
          , zc_Color_Red()              :: Integer  AS Color_fon
          , ''                          ::TVarChar  AS InsertName
          , NULL                        ::TDateTime AS InsertDate
          , FALSE                       ::Boolean   AS isErased
        FROM tmpAll
             LEFT JOIN tmpProdColorItems ON tmpProdColorItems.ProductId = tmpAll.ProductId
                                        AND tmpProdColorItems.ProdColorPatternId = tmpAll.ProdColorPatternId
                             
        WHERE inIsShowAll = TRUE
          AND tmpProdColorItems.ProductId IS NULL
>>>>>>> origin/master
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
