-- Function: gpGet_Object_GoodsPropertyValue()

--DROP FUNCTION gpGet_Object_GoodsPropertyValue();

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsPropertyValue(
IN inId          Integer,       /* Классификатор свойств товаров */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Name TVarChar, Amount TFloat, BarCode TVarChar, Article TVarChar, 
               BarCodeGLN TVarChar, ArticleGLN TVarChar, GoodsPropertyId Integer, GoodsPropertyName TVarChar, 
               GoodsId Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName  TVarChar) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
       Object.Id
     , Object.ValueData        AS Name
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
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_GoodsPropertyValue(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')