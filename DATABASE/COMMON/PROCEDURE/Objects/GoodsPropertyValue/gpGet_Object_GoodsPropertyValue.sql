-- Function: gpGet_Object_GoodsPropertyValue()

--DROP FUNCTION gpGet_Object_GoodsPropertyValue();

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsPropertyValue(
    IN inId          Integer,       -- Классификатор свойств товаров 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar, isErased Boolean, Amount TFloat, BarCode TVarChar, Article TVarChar, 
               BarCodeGLN TVarChar, ArticleGLN TVarChar, GoodsPropertyId Integer, GoodsPropertyName TVarChar, 
               GoodsId Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName  TVarChar) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsPropertyValue());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , CAST ('' as TVarChar)   AS Name
           , CAST (NULL AS Boolean)  AS isErased
           , CAST (0 as TFloat)      AS Amount
           , CAST ('' as TVarChar)   AS BarCode
           , CAST ('' as TVarChar)   AS Article
           , CAST ('' as TVarChar)   AS BarCodeGLN
           , CAST ('' as TVarChar)   AS ArticleGLN
           , CAST (0 as Integer)     AS GoodsPropertyId
           , CAST ('' as TVarChar)   AS GoodsPropertyName
           , CAST (0 as Integer)     AS GoodsId
           , CAST ('' as TVarChar)   AS GoodsName
           , CAST (0 as Integer)     AS GoodsKindId
           , CAST ('' as TVarChar)   AS GoodsKindName            
       FROM Object 
       WHERE Object.DescId = zc_Object_GoodsPropertyValue();
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id               AS Id
           , Object.ValueData        AS NAME
           , Object.isErased         AS isErased
           , Amount.ValueData        AS Amount
           , BarCode.ValueData       AS BarCode
           , Article.ValueData       AS Article
           , BarCodeGLN.ValueData    AS BarCodeGLN
           , ArticleGLN.ValueData    AS ArticleGLN
           , GoodsProperty.Id        AS GoodsPropertyId
           , GoodsProperty.ValueData AS GoodsPropertyName
           , Goods.Id                AS GoodsId
           , Goods.ValueData         AS GoodsName
           , GoodsKind.Id            AS GoodsKindId
           , GoodsKind.ValueData     AS GoodsKindName 
       FROM Object
  LEFT JOIN ObjectFloat AS Amount 
         ON Amount.ObjectId = Object.Id AND Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()
  LEFT JOIN ObjectString AS BarCode 
         ON BarCode.ObjectId = Object.Id AND BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
  LEFT JOIN ObjectString AS Article 
         ON Article.ObjectId = Object.Id AND Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
  LEFT JOIN ObjectString AS BarCodeGLN 
         ON BarCodeGLN.ObjectId = Object.Id AND BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
  LEFT JOIN ObjectString AS ArticleGLN 
         ON ArticleGLN.ObjectId = Object.Id AND ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
  LEFT JOIN ObjectLink AS GoodsPropertyValue_GoodsProperty
         ON GoodsPropertyValue_GoodsProperty.ObjectId = Object.Id
        AND GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
  LEFT JOIN Object AS GoodsProperty
         ON GoodsProperty.Id = GoodsPropertyValue_GoodsProperty.ChildObjectId
  LEFT JOIN ObjectLink AS GoodsPropertyValue_Goods
         ON GoodsPropertyValue_Goods.ObjectId = Object.Id
        AND GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
  LEFT JOIN Object AS Goods
         ON Goods.Id = GoodsPropertyValue_Goods.ChildObjectId
  LEFT JOIN ObjectLink AS GoodsPropertyValue_GoodsKind
         ON GoodsPropertyValue_GoodsKind.ObjectId = Object.Id
        AND GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
  LEFT JOIN Object AS GoodsKind
         ON GoodsKind.Id = GoodsPropertyValue_GoodsKind.ChildObjectId
       WHERE Object.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsPropertyValue(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.06.13          *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsPropertyValue('2')