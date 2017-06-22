-- Function: gpGet_Object_GoodsPropertyValue()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsPropertyValue (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsPropertyValue(
    IN inId          Integer,       -- ������������� ������� �������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Name TVarChar, isErased Boolean,
               Amount TFloat, BoxCount TFloat, AmountDoc TFloat,
               BarCode TVarChar, Article TVarChar,
               BarCodeGLN TVarChar, ArticleGLN TVarChar, GroupName TVarChar,GoodsPropertyId Integer, GoodsPropertyName TVarChar,
               GoodsId Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName  TVarChar) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
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

       WHERE Object.Id = inId;

   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsPropertyValue(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.06.17         * add AmountDoc
 17.09.15         * add BoxCount
 10.10.14                                                       *
 12.06.13         *
*/

-- ����
-- select * from gpGet_Object_GoodsPropertyValue( 86896, inSession := '5');