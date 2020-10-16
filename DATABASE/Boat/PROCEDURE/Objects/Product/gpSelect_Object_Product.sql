-- Function: gpSelect_Object_Product()

DROP FUNCTION IF EXISTS gpSelect_Object_Product (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Product (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inIsSale      Boolean,       -- признак показать проданные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ProdColorName TVarChar
             , Hours TFloat
             , DateStart TDateTime, DateBegin TDateTime, DateSale TDateTime
             , Article TVarChar, CIN TVarChar, EngineNum TVarChar
             , Comment TVarChar
             , ProdGroupId Integer, ProdGroupName TVarChar
             , BrandId Integer, BrandName TVarChar
             , ModelId Integer, ModelName TVarChar
             , EngineId Integer, EngineName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isSale Boolean
             , PriceIn TFloat, PriceOut TFloat
             , PriceIn2 TFloat, PriceOut2 TFloat
             , PriceIn3 TFloat, PriceOut3 TFloat
             , isErased Boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpProdColorItems AS (SELECT ObjectLink_Product.ChildObjectId AS ProductId
                                     , Object_ProdColorItems.ObjectCode AS ProdColorItemsCode
                                     , Object_ProdColorItems.ValueData  AS ProdColorItemsName
                                     , Object_ProdColorGroup.ObjectCode AS ProdColorGroupCode
                                     , Object_ProdColorGroup.ValueData  AS ProdColorGroupName
                                     , Object_ProdColor.ValueData       AS ProdColorName
                                     , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Product.ChildObjectId ORDER BY Object_ProdColorGroup.ObjectCode ASC, Object_ProdColorItems.ObjectCode ASC) :: Integer AS NPP
                                 FROM Object AS Object_ProdColorItems
                                      LEFT JOIN ObjectLink AS ObjectLink_Product
                                                           ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                                          AND ObjectLink_Product.DescId = zc_ObjectLink_ProdColorItems_Product()

                                      LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                           ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorItems.Id
                                                          AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                      LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

                                      LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                                           ON ObjectLink_ProdColor.ObjectId = Object_ProdColorItems.Id
                                                          AND ObjectLink_ProdColor.DescId = zc_ObjectLink_ProdColorItems_ProdColor()
                                      LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId


                                 WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
                                   AND Object_ProdColorItems.isErased = FALSE
                                )
     , tmpProdOptItems AS (SELECT ObjectLink_Product.ChildObjectId AS ProductId
                                , SUM (COALESCE (ObjectFloat_PriceIn.ValueData, 0))     ::TFloat    AS PriceIn
                                , SUM (COALESCE (ObjectFloat_PriceOut.ValueData, 0))     ::TFloat    AS PriceOut
                           FROM Object AS Object_ProdOptItems
                                LEFT JOIN ObjectLink AS ObjectLink_Product
                                                     ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                                                    AND ObjectLink_Product.DescId = zc_ObjectLink_ProdOptItems_Product()
                      
                                LEFT JOIN ObjectFloat AS ObjectFloat_PriceIn
                                                      ON ObjectFloat_PriceIn.ObjectId = Object_ProdOptItems.Id
                                                     AND ObjectFloat_PriceIn.DescId = zc_ObjectFloat_ProdOptItems_PriceIn()
                                LEFT JOIN ObjectFloat AS ObjectFloat_PriceOut
                                                      ON ObjectFloat_PriceOut.ObjectId = Object_ProdOptItems.Id
                                                     AND ObjectFloat_PriceOut.DescId = zc_ObjectFloat_ProdOptItems_PriceOut()

                           WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                             AND Object_ProdOptItems.isErased = FALSE 
                           GROUP BY ObjectLink_Product.ChildObjectId
                          )
, tmpObjAll AS (SELECT Object_Product.*
                     ,  ROW_NUMBER() OVER (ORDER BY Object_Product.Id DESC) AS Ord
                FROM Object AS Object_Product
                WHERE Object_Product.DescId = zc_Object_Product()
                  AND Object_Product.isErased = FALSE
               )
  , tmpResAll AS(SELECT Object_Product.Id               AS Id
                      , Object_Product.ObjectCode       AS Code
                      , Object_Product.ValueData        AS Name
                      , CASE WHEN tmpProdColorItems_1.ProdColorName ILIKE tmpProdColorItems_2.ProdColorName
                             THEN tmpProdColorItems_1.ProdColorName
                             ELSE COALESCE (tmpProdColorItems_1.ProdColorName, '') || ' / ' || COALESCE (tmpProdColorItems_2.ProdColorName, '')
                        END :: TVarChar AS ProdColorName
             
                      , ObjectFloat_Hours.ValueData      AS Hours
                      , ObjectDate_DateStart.ValueData   AS DateStart
                      , ObjectDate_DateBegin.ValueData   AS DateBegin
                      , ObjectDate_DateSale.ValueData    AS DateSale
                      , ObjectString_Article.ValueData   AS Article
                      , ObjectString_CIN.ValueData       AS CIN
                      , ObjectString_EngineNum.ValueData AS EngineNum
                      , ObjectString_Comment.ValueData   AS Comment
             
                      , Object_ProdGroup.Id             AS ProdGroupId
                      , Object_ProdGroup.ValueData      AS ProdGroupName
             
                      , Object_Brand.Id                 AS BrandId
                      , Object_Brand.ValueData          AS BrandName
             
                      , Object_Model.Id                 AS ModelId
                      , Object_Model.ValueData          AS ModelName
             
                      , Object_Engine.Id                AS EngineId
                      , Object_Engine.ValueData         AS EngineName
             
                      , Object_Insert.ValueData         AS InsertName
                      , ObjectDate_Insert.ValueData     AS InsertDate
                      , CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END ::Boolean AS isSale
                      , Object_Product.isErased         AS isErased
             
                      , CASE WHEN tmpObjAll.Ord = 1 THEN 4750 
                             WHEN tmpObjAll.Ord = 2 THEN 4560 
                             WHEN tmpObjAll.Ord = 3 THEN 25456 
                             WHEN tmpObjAll.Ord = 4 THEN 29357
                             WHEN tmpObjAll.Ord = 5 THEN 32347
                             ELSE 0
                        END :: TFloat AS PriceIn
             
                      , CASE WHEN tmpObjAll.Ord = 1 THEN 4750  + 1645
                             WHEN tmpObjAll.Ord = 2 THEN 4560  + 1345 
                             WHEN tmpObjAll.Ord = 3 THEN 25456  + 14234
                             WHEN tmpObjAll.Ord = 4 THEN 29357  + 21700
                             WHEN tmpObjAll.Ord = 5 THEN 32347  + 18345
                             ELSE 0
                        END :: TFloat AS PriceOut
             
                  FROM Object AS Object_Product
                       LEFT JOIN tmpObjAll ON tmpObjAll.Id =  Object_Product.Id
                       LEFT JOIN tmpProdColorItems AS tmpProdColorItems_1
                                                   ON tmpProdColorItems_1.ProductId = Object_Product.Id
                                                  AND tmpProdColorItems_1.NPP = 1
                       LEFT JOIN tmpProdColorItems AS tmpProdColorItems_2
                                                   ON tmpProdColorItems_2.ProductId = Object_Product.Id
                                                  AND tmpProdColorItems_2.NPP = 2
             
                       LEFT JOIN ObjectString AS ObjectString_Comment
                                              ON ObjectString_Comment.ObjectId = Object_Product.Id
                                             AND ObjectString_Comment.DescId = zc_ObjectString_Product_Comment()
             
                       LEFT JOIN ObjectFloat AS ObjectFloat_Hours
                                             ON ObjectFloat_Hours.ObjectId = Object_Product.Id
                                            AND ObjectFloat_Hours.DescId = zc_ObjectFloat_Product_Hours()
             
                       LEFT JOIN ObjectDate AS ObjectDate_DateStart
                                            ON ObjectDate_DateStart.ObjectId = Object_Product.Id
                                           AND ObjectDate_DateStart.DescId = zc_ObjectDate_Product_DateStart()
             
                       LEFT JOIN ObjectDate AS ObjectDate_DateBegin
                                            ON ObjectDate_DateBegin.ObjectId = Object_Product.Id
                                           AND ObjectDate_DateBegin.DescId = zc_ObjectDate_Product_DateBegin()
             
                       LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                            ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                           AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()
             
                       LEFT JOIN ObjectString AS ObjectString_Article
                                              ON ObjectString_Article.ObjectId = Object_Product.Id
                                             AND ObjectString_Article.DescId = zc_ObjectString_Article()
             
                       LEFT JOIN ObjectString AS ObjectString_CIN
                                              ON ObjectString_CIN.ObjectId = Object_Product.Id
                                             AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
             
                       LEFT JOIN ObjectString AS ObjectString_EngineNum
                                              ON ObjectString_EngineNum.ObjectId = Object_Product.Id
                                             AND ObjectString_EngineNum.DescId = zc_ObjectString_Product_EngineNum()
             
                       LEFT JOIN ObjectLink AS ObjectLink_ProdGroup
                                            ON ObjectLink_ProdGroup.ObjectId = Object_Product.Id
                                           AND ObjectLink_ProdGroup.DescId = zc_ObjectLink_Product_ProdGroup()
                       LEFT JOIN Object AS Object_ProdGroup ON Object_ProdGroup.Id = ObjectLink_ProdGroup.ChildObjectId
             
                       LEFT JOIN ObjectLink AS ObjectLink_Brand
                                            ON ObjectLink_Brand.ObjectId = Object_Product.Id
                                           AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
                       LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId
             
                       LEFT JOIN ObjectLink AS ObjectLink_Model
                                            ON ObjectLink_Model.ObjectId = Object_Product.Id
                                           AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()
                       LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
             
                       LEFT JOIN ObjectLink AS ObjectLink_Engine
                                            ON ObjectLink_Engine.ObjectId = Object_Product.Id
                                           AND ObjectLink_Engine.DescId = zc_ObjectLink_Product_Engine()
                       LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId
             
                       LEFT JOIN ObjectLink AS ObjectLink_Insert
                                            ON ObjectLink_Insert.ObjectId = Object_Product.Id
                                           AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                       LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId
             
                       LEFT JOIN ObjectDate AS ObjectDate_Insert
                                            ON ObjectDate_Insert.ObjectId = Object_Product.Id
                                           AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
             
                  WHERE Object_Product.DescId = zc_Object_Product()
                   AND (Object_Product.isErased = FALSE OR inIsShowAll = TRUE)
                   AND (COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() OR inIsSale = TRUE)
                 )
     -- Результат
    SELECT
           tmpResAll.Id
         , tmpResAll.Code
         , tmpResAll.Name
         , tmpResAll.ProdColorName

         , tmpResAll.Hours
         , tmpResAll.DateStart
         , tmpResAll.DateBegin
         , tmpResAll.DateSale
         , tmpResAll.Article
         , tmpResAll.CIN
         , tmpResAll.EngineNum
         , tmpResAll.Comment

         , tmpResAll.ProdGroupId
         , tmpResAll.ProdGroupName

         , tmpResAll.BrandId
         , tmpResAll.BrandName

         , tmpResAll.ModelId
         , tmpResAll.ModelName

         , tmpResAll.EngineId
         , tmpResAll.EngineName

         , tmpResAll.InsertName
         , tmpResAll.InsertDate
         , tmpResAll.isSale

         , tmpResAll.PriceIn
         , tmpResAll.PriceOut

         , tmpProdOptItems.PriceIn AS PriceIn2
         , tmpProdOptItems.PriceOut AS PriceOut2

         , (COALESCE (tmpResAll.PriceIn, 0) + COALESCE (tmpProdOptItems.PriceIn, 0))   :: TFloat AS PriceIn3
         , (COALESCE (tmpResAll.PriceOut, 0) + COALESCE (tmpProdOptItems.PriceOut, 0)) :: TFloat AS PriceOut3

         , tmpResAll.isErased

     FROM tmpResAll
          LEFT JOIN tmpProdOptItems ON tmpProdOptItems. ProductId = tmpResAll.Id
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
--
 --SELECT * FROM gpSelect_Object_Product (false, true, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_Product (false, false, zfCalc_UserAdmin())
