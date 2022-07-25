-- Function: gpSelect_Object_ProdOptions_сomment()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptions_сomment (Integer,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptions_сomment(
    IN inProdColorPatternId Integer,
    IN inIsShowAll          Boolean,            -- признак показать удаленные да / нет
    IN inSession            TVarChar            -- сессия пользователя

)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ProdColorPatternId Integer, ProdColorPatternCode Integer, ProdColorPatternName TVarChar
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbProdColorGroupId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   

   -- Нашли "общий" элемент
   vbProdColorGroupId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inProdColorPatternId AND OL.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup());


   -- результат
   RETURN QUERY
       WITH tmpProdColorPattern AS (SELECT Object_ProdColorPattern.Id          AS ProdColorPatternId
                                         , Object_ProdColorPattern.ObjectCode  AS ProdColorPatternCode
                                         , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData
                                                                           , Object_ProdColorPattern.ValueData
                                                                           , Object_Model_pcp.ValueData
                                                                           , Object_ProdColorPattern.isErased
                                                                            )  AS ProdColorPatternName
                                         , OS_Comment.ValueData                AS Comment
                                    FROM Object AS Object_ProdColorPattern
                                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                              ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                                             AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()

                                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_ProdColorGroup
                                                              ON ObjectLink_ProdColorPattern_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                                             AND ObjectLink_ProdColorPattern_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                         LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorPattern_ProdColorGroup.ChildObjectId
                             
                                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_ColorPattern
                                                              ON ObjectLink_ProdColorPattern_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                                             AND ObjectLink_ProdColorPattern_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
                             
                                         LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                                                              ON ObjectLink_ColorPattern_Model.ObjectId = ObjectLink_ProdColorPattern_ColorPattern.ChildObjectId
                                                             AND ObjectLink_ColorPattern_Model.DescId = zc_ObjectLink_ColorPattern_Model()
                                         LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_ColorPattern_Model.ChildObjectId
                             
                                         LEFT JOIN ObjectString AS OS_Comment
                                                                ON OS_Comment.ObjectId  = Object_ProdColorPattern.Id
                                                               AND OS_Comment.DescId    = zc_ObjectString_ProdColorPattern_Comment()

                                    WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
                                      AND (Object_ProdColorPattern.isErased = FALSE OR inIsShowAll = TRUE)
                                      AND (ObjectLink_ProdColorGroup.ChildObjectId = vbProdColorGroupId OR vbProdColorGroupId = 0
                                        OR (ObjectLink_ProdColorGroup.ChildObjectId = 32603 AND vbProdColorGroupId IN (1880, 32603, 32604)) -- Fiberglass - Hull
                                        OR (ObjectLink_ProdColorGroup.ChildObjectId = 1880  AND vbProdColorGroupId IN (1880, 32603, 32604))  -- Fiberglass - Deck
                                        OR (ObjectLink_ProdColorGroup.ChildObjectId = 32604 AND vbProdColorGroupId IN (1880, 32603, 32604))  -- Fiberglass - Deck
                                          )
                                   )
       -- 1. ProdOptions
       SELECT DISTINCT
              0 :: Integer          AS Id
            , 0 :: Integer          AS Code
            , OS_Comment.ValueData  AS Name

            --, tmpProdColorPattern.ProdColorPatternId
            --, tmpProdColorPattern.ProdColorPatternCode
            --, tmpProdColorPattern.ProdColorPatternName
            , 0  :: Integer  AS ProdColorPatternId
            , 0  :: Integer  AS ProdColorPatternCode
            , '' :: TVarChar AS ProdColorPatternName

            , FALSE :: Boolean        AS isErased

       FROM tmpProdColorPattern
            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ChildObjectId = tmpProdColorPattern.ProdColorPatternId
                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ProdOptions_ProdColorPattern()
            INNER JOIN ObjectString AS OS_Comment
                                    ON OS_Comment.ObjectId  = ObjectLink_ProdColorPattern.ObjectId
                                   AND OS_Comment.DescId    = zc_ObjectString_ProdOptions_Comment()
                                   AND OS_Comment.ValueData <> ''

      UNION
       -- 2. ReceiptGoodsChild
       SELECT DISTINCT
              0 :: Integer          AS Id
            , 0 :: Integer          AS Code
            , Object_ReceiptGoodsChild.ValueData AS Name

            , 0  :: Integer  AS ProdColorPatternId
            , 0  :: Integer  AS ProdColorPatternCode
            , '' :: TVarChar AS ProdColorPatternName

            , FALSE :: Boolean        AS isErased

       FROM tmpProdColorPattern
            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ChildObjectId = tmpProdColorPattern.ProdColorPatternId
                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
            INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ProdColorPattern.ObjectId
                                                         AND Object_ReceiptGoodsChild.isErased = FALSE
       WHERE Object_ReceiptGoodsChild.ValueData <> ''

      UNION
       -- 3. Object_ProdColorItems
       SELECT DISTINCT
              0 :: Integer          AS Id
            , 0 :: Integer          AS Code
            , OS_Comment.ValueData  AS Name

            , 0  :: Integer  AS ProdColorPatternId
            , 0  :: Integer  AS ProdColorPatternCode
            , '' :: TVarChar AS ProdColorPatternName

            , FALSE :: Boolean        AS isErased

       FROM tmpProdColorPattern
            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ChildObjectId = tmpProdColorPattern.ProdColorPatternId
                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
            INNER JOIN Object AS Object_ProdColorItems ON Object_ProdColorItems.Id       = ObjectLink_ProdColorPattern.ObjectId
                                                      AND Object_ProdColorItems.isErased = FALSE
            INNER JOIN ObjectString AS OS_Comment
                                    ON OS_Comment.ObjectId  = Object_ProdColorItems.Id
                                   AND OS_Comment.DescId    = zc_ObjectString_ProdColorItems_Comment()
                                   AND OS_Comment.ValueData <> ''
            INNER JOIN ObjectLink AS ObjectLink_Product
                                  ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                 AND ObjectLink_Product.DescId  = zc_ObjectLink_ProdColorItems_Product()
            INNER JOIN Object AS Object_Product ON Object_Product.Id       = ObjectLink_Product.ChildObjectId
                                               AND Object_Product.isErased = FALSE
       WHERE OS_Comment.ValueData <> ''

      UNION
       -- 4. ProdColorPattern
       SELECT DISTINCT
              0 :: Integer                 AS Id
            , 0 :: Integer                 AS Code
            , tmpProdColorPattern.Comment  AS Name

            , 0  :: Integer  AS ProdColorPatternId
            , 0  :: Integer  AS ProdColorPatternCode
            , '' :: TVarChar AS ProdColorPatternName

            , FALSE :: Boolean        AS isErased

       FROM tmpProdColorPattern
       WHERE tmpProdColorPattern.Comment <> ''
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.26.22          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdOptions_сomment (inProdColorPatternId:= 2325, inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
