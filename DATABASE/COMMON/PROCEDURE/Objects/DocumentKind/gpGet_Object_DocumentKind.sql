-- Function: gpGet_Object_DocumentKind()

DROP FUNCTION IF EXISTS gpGet_Object_DocumentKind (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DocumentKind(
    IN inId          Integer,       -- ключ объекта 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , isAuto Boolean
             , isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_DocumentKind());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_DocumentKind()) AS Code
           , CAST ('' as TVarChar)  AS NAME

           , CAST (0 as Integer)    AS GoodsId
           , CAST ('' as TVarChar)  AS GoodsName
           , CAST (0 as Integer)    AS GoodsKindId
           , CAST ('' as TVarChar)  AS GoodsKindName

           , CAST (False AS Boolean) AS isAuto
           , CAST (False AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_DocumentKind.Id           AS Id
           , Object_DocumentKind.ObjectCode   AS Code
           , Object_DocumentKind.ValueData    AS NAME
           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ValueData           AS GoodsName
           , Object_GoodsKind.Id              AS GoodsKindId
           , Object_GoodsKind.ValueData       AS GoodsKindName
           , COALESCE (ObjectBoolean_isAuto.ValueData, False) :: Boolean AS isAuto
           , Object_DocumentKind.isErased     AS isErased
       FROM Object AS Object_DocumentKind
        LEFT JOIN ObjectLink AS ObjectLink_DocumentKind_Goods
                             ON ObjectLink_DocumentKind_Goods.ObjectId = Object_DocumentKind.Id
                            AND ObjectLink_DocumentKind_Goods.DescId = zc_ObjectLink_DocumentKind_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_DocumentKind_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_DocumentKind_GoodsKind
                             ON ObjectLink_DocumentKind_GoodsKind.ObjectId = Object_DocumentKind.Id
                            AND ObjectLink_DocumentKind_GoodsKind.DescId = zc_ObjectLink_DocumentKind_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_DocumentKind_GoodsKind.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isAuto
                                ON ObjectBoolean_isAuto.ObjectId = Object_DocumentKind.Id
                               AND ObjectBoolean_isAuto.DescId = zc_ObjectBoolean_DocumentKind_isAuto()
       WHERE Object_DocumentKind.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_DocumentKind(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.19         * add isAuto
 13.06.17         *
 13.06.16         *
*/

-- тест
-- SELECT * FROM gpGet_Object_DocumentKind (0, '2')