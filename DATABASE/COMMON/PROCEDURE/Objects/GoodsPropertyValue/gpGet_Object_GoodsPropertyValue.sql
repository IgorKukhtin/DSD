-- Function: gpGet_Object_GoodsPropertyValue()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsPropertyValue (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsPropertyValue(
    IN inId          Integer,       -- Классификатор свойств товаров
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar, isErased Boolean,
               Amount TFloat, BoxCount TFloat, AmountDoc TFloat,
               BarCode TVarChar, Article TVarChar,
               BarCodeGLN TVarChar, ArticleGLN TVarChar, GroupName TVarChar,GoodsPropertyId Integer, GoodsPropertyName TVarChar,
               GoodsId Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName  TVarChar,
               GoodsBoxId Integer, GoodsBoxName TVarChar, 
               GoodsKindSubId Integer, GoodsKindSubName TVarChar,
               isGoodsKind Boolean
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsPropertyValue());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             0 :: Integer     AS Id
           , '' :: TVarChar   AS Name
           , NULL :: Boolean  AS isErased
           , NULL :: TFloat   AS Amount
           , NULL :: TFloat   AS BoxCount
           , NULL :: TFloat   AS AmountDoc
           , '' :: TVarChar   AS BarCode
           , '' :: TVarChar   AS Article
           , '' :: TVarChar   AS BarCodeGLN
           , '' :: TVarChar   AS ArticleGLN
           , '' :: TVarChar   AS GroupName
           , 0 :: Integer     AS GoodsPropertyId
           , '' :: TVarChar   AS GoodsPropertyName
           , 0 :: Integer     AS GoodsId
           , '' :: TVarChar   AS GoodsName
           , 0 :: Integer     AS GoodsKindId
           , '' :: TVarChar   AS GoodsKindName
           , 0  :: Integer    AS GoodsBoxId
           , '' :: TVarChar   AS GoodsBoxName
           , 0  :: Integer    AS GoodsKindSubId
           , '' :: TVarChar   AS GoodsKindSubName
           , FALSE ::Boolean  AS isGoodsKind

       /*FROM Object
       WHERE Object.DescId = zc_Object_GoodsPropertyValue()*/;

   ELSE
       RETURN QUERY
       SELECT
             Object.Id               AS Id
           , Object.ValueData        AS NAME
           , Object.isErased         AS isErased
           , ObjectFloat_Amount.ValueData         AS Amount
           , ObjectFloat_BoxCount.ValueData       AS BoxCount
           , ObjectFloat_AmountDoc.ValueData      AS AmountDoc
           , BarCode.ValueData       AS BarCode
           , Article.ValueData       AS Article
           , BarCodeGLN.ValueData    AS BarCodeGLN
           , ArticleGLN.ValueData    AS ArticleGLN
           , ObjectString_GroupName.ValueData     AS GroupName
           , GoodsProperty.Id        AS GoodsPropertyId
           , GoodsProperty.ValueData AS GoodsPropertyName
           , Goods.Id                AS GoodsId
           , Goods.ValueData         AS GoodsName
           , GoodsKind.Id            AS GoodsKindId
           , GoodsKind.ValueData     AS GoodsKindName
           , GoodsBox.Id             AS GoodsBoxId
           , ('(' || GoodsBox.ObjectCode :: TVarChar || ') '  || GoodsBox.ValueData) :: TVarChar AS GoodsBoxName
           , Object_GoodsKindSub.Id         AS GoodsKindSubId
           , Object_GoodsKindSub.ValueData  AS GoodsKindSubName  
           , COALESCE (ObjectBoolean_isGoodsKind.ValueData, FALSE) :: Boolean AS isGoodsKind         
       FROM Object
           LEFT JOIN ObjectFloat AS ObjectFloat_Amount 
                                 ON ObjectFloat_Amount.ObjectId = Object.Id
                                AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()
           LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                 ON ObjectFloat_BoxCount.ObjectId = Object.Id
                                AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_GoodsPropertyValue_BoxCount()                                          
           LEFT JOIN ObjectFloat AS ObjectFloat_AmountDoc
                                 ON ObjectFloat_AmountDoc.ObjectId = Object.Id
                                AND ObjectFloat_AmountDoc.DescId = zc_ObjectFloat_GoodsPropertyValue_AmountDoc()

           LEFT JOIN ObjectString AS BarCode
                                  ON BarCode.ObjectId = Object.Id
                                 AND BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()

           LEFT JOIN ObjectString AS Article 
                                  ON Article.ObjectId = Object.Id
                                 AND Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
           LEFT JOIN ObjectString AS BarCodeGLN 
                                  ON BarCodeGLN.ObjectId = Object.Id
                                 AND BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()

           LEFT JOIN ObjectString AS ArticleGLN
                                  ON ArticleGLN.ObjectId = Object.Id
                                 AND ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()

           LEFT JOIN ObjectString AS ObjectString_GroupName
                                  ON ObjectString_GroupName.ObjectId = Object.Id
                                 AND ObjectString_GroupName.DescId = zc_ObjectString_GoodsPropertyValue_GroupName()

           LEFT JOIN ObjectLink AS GoodsPropertyValue_GoodsProperty 
                                ON GoodsPropertyValue_GoodsProperty.ObjectId = Object.Id
                               AND GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
           LEFT JOIN Object AS GoodsProperty ON GoodsProperty.Id = GoodsPropertyValue_GoodsProperty.ChildObjectId

           LEFT JOIN ObjectLink AS GoodsPropertyValue_Goods 
                                ON GoodsPropertyValue_Goods.ObjectId = Object.Id
                               AND GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
           LEFT JOIN Object AS Goods ON Goods.Id = GoodsPropertyValue_Goods.ChildObjectId

           LEFT JOIN ObjectLink AS GoodsPropertyValue_GoodsKind 
                                ON GoodsPropertyValue_GoodsKind.ObjectId = Object.Id
                               AND GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
           LEFT JOIN Object AS GoodsKind ON GoodsKind.Id = GoodsPropertyValue_GoodsKind.ChildObjectId

           LEFT JOIN ObjectLink AS GoodsPropertyValue_GoodsBox
                                ON GoodsPropertyValue_GoodsBox.ObjectId = Object.Id
                               AND GoodsPropertyValue_GoodsBox.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
           LEFT JOIN Object AS GoodsBox ON GoodsBox.Id = GoodsPropertyValue_GoodsBox.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_GoodsKindSub
                                ON ObjectLink_GoodsKindSub.ObjectId = Object.Id
                               AND ObjectLink_GoodsKindSub.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKindSub()
           LEFT JOIN Object AS Object_GoodsKindSub ON Object_GoodsKindSub.Id = ObjectLink_GoodsKindSub.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isGoodsKind
                                   ON ObjectBoolean_isGoodsKind.ObjectId = Object.Id
                                  AND ObjectBoolean_isGoodsKind.DescId = zc_ObjectBoolean_GoodsPropertyValue_isGoodsKind()
       WHERE Object.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsPropertyValue(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.07.22         *
 14.02.18         * add GoodsBox
 22.06.17         * add AmountDoc
 17.09.15         * add BoxCount
 10.10.14                                                       *
 12.06.13         *
*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsPropertyValue( 86896, inSession := '5');
